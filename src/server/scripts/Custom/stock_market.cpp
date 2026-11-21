/*
 * 股票市场 MVP
 *
 * - 6 家魔兽公司
 * - A 股时段：周一至周五 09:00-11:30、13:00-15:00
 * - 每 5 分钟一个 tick
 * - T+1，买入当天不能卖
 * - NPC 做市，玩家买卖只产生很小的价格冲击
 * - 均值回归，避免单边上涨/下跌
 */

#include "Chat.h"
#include "DatabaseEnv.h"
#include "Player.h"
#include "Random.h"
#include "ScriptMgr.h"
#include "World.h"

#include <algorithm>
#include <cmath>
#include <ctime>
#include <iomanip>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

namespace
{
    struct StockCompany
    {
        uint32 Id = 0;
        std::string Name;
        std::string Ticker;
        double Price = 0.0;
        double PrevClose = 0.0;
        double Intrinsic = 0.0;
        double Volatility = 0.005;
        uint64 TotalShares = 0;
        double OpenPrice = 0.0;
        double HighPrice = 0.0;
        double LowPrice = 0.0;
        uint64 Volume = 0;
        uint32 LastDay = 0;
    };

    std::vector<StockCompany> _companies;
    std::unordered_map<uint32, int64> _pendingImpact; // 铜币净买入
    int _lastTickMinute = -1;

    constexpr uint32 STOCK_TICK_MINUTES = 5;
    constexpr double PLAYER_IMPACT_DIVISOR = 10000000000.0; // 1000G 约 0.1% 冲击
    constexpr double MAX_PLAYER_IMPACT = 0.003;

    bool IsTradingDay(std::tm const& tm)
    {
        return tm.tm_wday >= 1 && tm.tm_wday <= 5;
    }

    bool IsMarketOpen(std::tm const& tm)
    {
        if (!IsTradingDay(tm))
            return false;

        int minute = tm.tm_hour * 60 + tm.tm_min;
        return (minute >= 9 * 60 && minute < 11 * 60 + 30) ||
               (minute >= 13 * 60 && minute < 15 * 60);
    }

    StockCompany* FindCompany(uint32 id)
    {
        auto it = std::find_if(_companies.begin(), _companies.end(),
            [id](StockCompany const& company) { return company.Id == id; });
        return it == _companies.end() ? nullptr : &(*it);
    }

    std::string FormatGold(double price)
    {
        std::ostringstream oss;
        oss << std::fixed << std::setprecision(2) << price;
        return oss.str();
    }

    void SaveCompany(StockCompany const& company)
    {
        std::ostringstream sql;
        sql << "UPDATE stock_company SET price=" << std::fixed << std::setprecision(4) << company.Price
            << ", prev_close=" << company.PrevClose
            << ", open_price=" << company.OpenPrice
            << ", high_price=" << company.HighPrice
            << ", low_price=" << company.LowPrice
            << ", volume=" << company.Volume
            << ", last_day=" << company.LastDay
            << " WHERE id=" << company.Id;
        WorldDatabase.Execute(sql.str().c_str());
    }

    void LoadCompanies()
    {
        _companies.clear();

        QueryResult result = WorldDatabase.Query(
            "SELECT id,name,ticker,price,prev_close,intrinsic,volatility,total_shares,"
            "open_price,high_price,low_price,volume,last_day FROM stock_company ORDER BY id");
        if (!result)
        {
            TC_LOG_INFO("server.loading", ">> Stock market: no companies configured");
            return;
        }

        do
        {
            Field* fields = result->Fetch();
            StockCompany company;
            company.Id = fields[0].GetUInt32();
            company.Name = fields[1].GetString();
            company.Ticker = fields[2].GetString();
            company.Price = fields[3].GetDouble();
            company.PrevClose = fields[4].GetDouble();
            company.Intrinsic = fields[5].GetDouble();
            company.Volatility = fields[6].GetDouble();
            company.TotalShares = fields[7].GetUInt64();
            company.OpenPrice = fields[8].GetDouble();
            company.HighPrice = fields[9].GetDouble();
            company.LowPrice = fields[10].GetDouble();
            company.Volume = fields[11].GetUInt64();
            company.LastDay = fields[12].GetUInt32();
            _companies.push_back(company);
        } while (result->NextRow());

        TC_LOG_INFO("server.loading", ">> Stock market: loaded {} companies", _companies.size());
    }

    void ResetDay(StockCompany& company, uint32 day)
    {
        company.PrevClose = company.Price;
        company.OpenPrice = company.Price;
        company.HighPrice = company.Price;
        company.LowPrice = company.Price;
        company.Volume = 0;
        company.LastDay = day;

        // T+1：新交易日所有持仓解冻
        CharacterDatabase.Execute("UPDATE character_stock SET available=shares");
    }

    void TickCompanies(uint32 day)
    {
        for (StockCompany& company : _companies)
        {
            if (company.LastDay != day)
                ResetDay(company, day);

            double impact = 0.0;
            auto impactIt = _pendingImpact.find(company.Id);
            if (impactIt != _pendingImpact.end())
                impact = std::clamp(double(impactIt->second) / PLAYER_IMPACT_DIVISOR,
                    -MAX_PLAYER_IMPACT, MAX_PLAYER_IMPACT);

            // 均值回归 + 对称噪声 + 玩家冲击
            double noise = (double(rand_norm()) * 2.0 - 1.0);
            double reversion = 0.02 * (company.Intrinsic - company.Price);
            company.Price += reversion + company.Price * company.Volatility * noise
                + company.Price * impact;

            double minimum = std::max({ 0.50, company.PrevClose * 0.90, company.Intrinsic * 0.50 });
            double maximum = std::min({ company.PrevClose * 1.10, company.Intrinsic * 2.00 });
            if (minimum > maximum)
                minimum = maximum = company.Intrinsic;

            company.Price = std::clamp(company.Price, minimum, maximum);
            company.HighPrice = std::max(company.HighPrice, company.Price);
            company.LowPrice = company.LowPrice > 0.0 ? std::min(company.LowPrice, company.Price) : company.Price;

            SaveCompany(company);
        }

        _pendingImpact.clear();
    }

    struct Holding
    {
        uint64 Shares = 0;
        uint64 Available = 0;
        double AvgCost = 0.0;
    };

    std::unordered_map<uint32, Holding> LoadHoldings(uint32 guid)
    {
        std::unordered_map<uint32, Holding> holdings;
        QueryResult result = CharacterDatabase.Query((
            "SELECT company_id,shares,available,avg_cost FROM character_stock WHERE guid="
            + std::to_string(guid)).c_str());
        if (!result)
            return holdings;

        do
        {
            Field* fields = result->Fetch();
            Holding holding;
            holding.Shares = fields[1].GetUInt64();
            holding.Available = fields[2].GetUInt64();
            holding.AvgCost = fields[3].GetDouble();
            holdings[fields[0].GetUInt32()] = holding;
        } while (result->NextRow());

        return holdings;
    }

    void SendMarket(Player* player)
    {
        if (!player)
            return;

        std::time_t now = std::time(nullptr);
        std::tm tm{};
        localtime_s(&tm, &now);

        auto holdings = LoadHoldings(player->GetGUID().GetCounter());

        std::ostringstream oss;
        oss << "STOCK;M;" << (IsMarketOpen(tm) ? 1 : 0) << ";";

        for (StockCompany const& company : _companies)
        {
            double change = company.PrevClose > 0.0
                ? (company.Price / company.PrevClose - 1.0) * 100.0
                : 0.0;

            auto it = holdings.find(company.Id);
            uint64 shares = it == holdings.end() ? 0 : it->second.Shares;
            uint64 available = it == holdings.end() ? 0 : it->second.Available;

            oss << company.Id << ',' << company.Name << ',' << FormatGold(company.Price) << ','
                << std::fixed << std::setprecision(2) << change << ','
                << shares << ',' << available << '|';
        }

        ChatHandler(player->GetSession()).SendSysMessage(oss.str());
    }

    bool Buy(Player* player, uint32 companyId, uint32 quantity, std::string& message)
    {
        if (!player || quantity == 0 || quantity % 100 != 0)
        {
            message = "数量必须是 100 的整数倍。";
            return false;
        }

        std::time_t now = std::time(nullptr);
        std::tm tm{};
        localtime_s(&tm, &now);
        if (!IsMarketOpen(tm))
        {
            message = "当前休市。";
            return false;
        }

        StockCompany* company = FindCompany(companyId);
        if (!company)
        {
            message = "公司不存在。";
            return false;
        }

        double ask = company->Price * 1.005;
        uint64 cost = uint64(ask * quantity * GOLD);
        uint64 fee = std::max<uint64>(100, cost / 1000);
        uint64 total = cost + fee;

        if (player->GetMoney() < total)
        {
            message = "金币不足。";
            return false;
        }

        auto holdings = LoadHoldings(player->GetGUID().GetCounter());
        Holding holding = holdings[companyId];

        uint64 newShares = holding.Shares + quantity;
        double newAvgCost = (holding.AvgCost * holding.Shares + ask * quantity) / double(newShares);

        player->ModifyMoney(-int64(total));

        std::ostringstream insert;
        insert << "INSERT INTO character_stock (guid,company_id,shares,available,avg_cost) VALUES ("
            << player->GetGUID().GetCounter() << "," << companyId << ","
            << newShares << "," << holding.Available << ","
            << std::fixed << std::setprecision(4) << newAvgCost << ") "
            << "ON DUPLICATE KEY UPDATE shares=VALUES(shares), available=VALUES(available), avg_cost=VALUES(avg_cost)";
        CharacterDatabase.Execute(insert.str().c_str());

        company->Volume += quantity;
        _pendingImpact[companyId] += int64(total);
        SaveCompany(*company);

        std::ostringstream oss;
        oss << "买入 " << company->Name << " " << quantity << " 股，成交价 " << FormatGold(ask)
            << "G，手续费 " << FormatGold(double(fee) / GOLD) << "G。";
        message = oss.str();
        return true;
    }

    bool Sell(Player* player, uint32 companyId, uint32 quantity, std::string& message)
    {
        if (!player || quantity == 0 || quantity % 100 != 0)
        {
            message = "数量必须是 100 的整数倍。";
            return false;
        }

        std::time_t now = std::time(nullptr);
        std::tm tm{};
        localtime_s(&tm, &now);
        if (!IsMarketOpen(tm))
        {
            message = "当前休市。";
            return false;
        }

        StockCompany* company = FindCompany(companyId);
        if (!company)
        {
            message = "公司不存在。";
            return false;
        }

        auto holdings = LoadHoldings(player->GetGUID().GetCounter());
        auto it = holdings.find(companyId);
        if (it == holdings.end() || it->second.Available < quantity)
        {
            message = "可卖数量不足（T+1，今天买的明天才能卖）。";
            return false;
        }

        double bid = company->Price * 0.995;
        uint64 gross = uint64(bid * quantity * GOLD);
        uint64 fee = std::max<uint64>(100, gross / 500); // 佣金 + 印花税约 0.2%

        player->ModifyMoney(int64(gross - fee));

        uint64 newShares = it->second.Shares - quantity;
        uint64 newAvailable = it->second.Available - quantity;

        if (newShares == 0)
        {
            CharacterDatabase.Execute((
                "DELETE FROM character_stock WHERE guid=" + std::to_string(player->GetGUID().GetCounter())
                + " AND company_id=" + std::to_string(companyId)).c_str());
        }
        else
        {
            CharacterDatabase.Execute((
                "UPDATE character_stock SET shares=" + std::to_string(newShares)
                + ", available=" + std::to_string(newAvailable)
                + " WHERE guid=" + std::to_string(player->GetGUID().GetCounter())
                + " AND company_id=" + std::to_string(companyId)).c_str());
        }

        company->Volume += quantity;
        _pendingImpact[companyId] -= int64(gross);
        SaveCompany(*company);

        std::ostringstream oss;
        oss << "卖出 " << company->Name << " " << quantity << " 股，成交价 " << FormatGold(bid)
            << "G，手续费 " << FormatGold(double(fee) / GOLD) << "G。";
        message = oss.str();
        return true;
    }

    std::vector<std::string> Split(std::string const& value, char separator)
    {
        std::vector<std::string> parts;
        std::string current;
        std::istringstream stream(value);
        while (std::getline(stream, current, separator))
            parts.push_back(current);
        return parts;
    }
}

class stock_market_worldscript : public WorldScript
{
public:
    stock_market_worldscript() : WorldScript("stock_market_worldscript") { }

    void OnStartup() override
    {
        LoadCompanies();
    }

    void OnUpdate(uint32 /*diff*/) override
    {
        if (_companies.empty())
            return;

        std::time_t now = std::time(nullptr);
        std::tm tm{};
        localtime_s(&tm, &now);

        if (!IsMarketOpen(tm))
        {
            _lastTickMinute = -1;
            return;
        }

        int minute = tm.tm_hour * 60 + tm.tm_min;
        if (minute % STOCK_TICK_MINUTES != 0 || minute == _lastTickMinute)
            return;

        _lastTickMinute = minute;
        uint32 day = uint32((tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday);
        TickCompanies(day);
    }
};

class stock_market_playerscript : public PlayerScript
{
public:
    stock_market_playerscript() : PlayerScript("stock_market_playerscript") { }

    void OnAddonMessageSent(Player* player, uint32 /*type*/, std::string const& prefix,
        std::string const& text, Player* /*receiver*/) override
    {
        if (!player || prefix != "WX" || text.rfind("STOCK|", 0) != 0)
            return;

        std::vector<std::string> parts = Split(text, '|');
        if (parts.size() >= 2 && parts[1] == "LIST")
        {
            SendMarket(player);
            return;
        }

        if (parts.size() >= 4 && (parts[1] == "BUY" || parts[1] == "SELL"))
        {
            uint32 companyId = 0;
            uint32 quantity = 0;
            try
            {
                companyId = uint32(std::stoul(parts[2]));
                quantity = uint32(std::stoul(parts[3]));
            }
            catch (...)
            {
                return;
            }

            std::string message;
            bool success = parts[1] == "BUY"
                ? Buy(player, companyId, quantity, message)
                : Sell(player, companyId, quantity, message);

            ChatHandler(player->GetSession()).PSendSysMessage("STOCK;R;%d;%s", success ? 1 : 0, message.c_str());
            SendMarket(player);
        }
    }
};

void AddSC_stock_market()
{
    new stock_market_worldscript();
    new stock_market_playerscript();
}
