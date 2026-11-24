#include "BotLocaleText.h"

namespace Playerbot::Locale {

std::vector<Catalog::Entry> const& ChineseEntries()
{
    static std::vector<Catalog::Entry> const entries =
    {
        { "PlayerbotV2 not initialized.", "玩家机器人尚未初始化。" },
        { "Chinese", "中文" },
        { "Russian", "俄语" },
        { "English", "英语" },
        { "your client's language", "你的客户端语言" },
        { "your choice", "你的选择" },
        { "Usage: .bot language auto|en|ru", "用法：.bot language auto|en|ru|zh" },
        { "Bot replies: {} ({}). .bot language auto|en|ru changes it.",
          "机器人回复语言：{}（{}）。使用 .bot language auto|en|ru|zh 修改。" },
        { "WoW Forever Bots by Karrz, based on agatho's PlayerbotV2 (GPL-2.0). .bot add <class> [tank|healer|dps], .bot call, .bot dismiss; all orders: BOT_COMMANDS.md",
          "WoW Forever Bots（Karrz），基于 agatho 的 PlayerbotV2（GPL-2.0）。添加：.bot add <职业> [tank|healer|dps]；召回：.bot call；解散：.bot dismiss。完整命令见 BOT_COMMANDS.md。" },
        { "WoW Forever Bots. Usage: .bot add <class> [tank|healer|dps] [race] [male|female]  e.g. .bot add priest healer",
          "用法：.bot add <职业> [tank|healer|dps] [种族] [male|female]，例如：.bot add priest healer。" },
        { "No companions yet. `.bot add <class> [tank|healer|dps]` makes one.",
          "你还没有机器人。使用 `.bot add <职业> [tank|healer|dps]` 创建一个。" },
        { "No companion of yours called '{}'. `.bot list` shows them.",
          "你没有名为“{}”的机器人。使用 `.bot list` 查看列表。" },
        { "No bot or summoned alt of yours called '{}'. `.bot list` shows your bots.",
          "你没有名为“{}”的机器人或已召唤角色。使用 `.bot list` 查看列表。" },
        { ".bot dismiss <name|all>: logs out one of your bots or summoned alts and takes it out of your group.",
          ".bot dismiss <名称|all>：让一个机器人或召唤角色离线并退出队伍。" },
        { "Example: .bot dismiss Myalt, or .bot dismiss all",
          "例如：.bot dismiss 角色名，或 .bot dismiss all。" },
        { "No character named '{}' exists.", "不存在名为“{}”的角色。" },
        { "'{}' is not on your account.", "“{}”不属于当前游戏账号。" },
        { "Summon failed: {}", "召唤失败：{}" },
        { ".playerbot summon <AltName>: logs in one of your offline characters (same account) as a bot.",
          "用法：.playerbot summon <角色名>：将当前账号下的离线角色作为机器人登录。" },
        { "Example: .playerbot summon Myalt", "例如：.playerbot summon 角色名" },
        { "That's your current character. Use `.playerbot self on` to drive your own character with the bot logic instead.",
          "这是你当前使用的角色。若要让机器人逻辑控制当前角色，请使用 `.playerbot self on`。" },
        { "Summoning your alt '{}': it logs in as a bot, comes to you and joins your group. "
          "You (and any other char on your account) can whisper `follow`, `stop`, `engage`, `squad`, `role` to it.",
          "正在召唤你的角色“{}”：角色将作为机器人登录、前往你的位置并加入队伍。"
          "当前账号的任意角色都可对它使用 follow、stop、engage、squad、role 命令。" },
        { "Usage: .playerbot account <account> <password> <character>.",
          "用法：.playerbot account <账号> <密码> <角色名>（也可使用 `.playerbot 添加账号`）。" },
        { "The password is checked once and is never stored.", "密码只用于本次校验，不会被保存。" },
        { "Account or password is too long.", "账号或密码过长。" },
        { "Too many failed password attempts. Try again in one minute.",
          "密码校验失败次数过多，请一分钟后重试。" },
        { "Account name or password is invalid.", "账号名称或密码错误。" },
        { "Bot-pool accounts cannot be linked as player accounts.",
          "机器人池账号不能作为玩家账号添加。" },
        { "That character does not belong to the supplied account.",
          "该角色不属于输入的账号。" },
        { "That character name is invalid.", "角色名称无效。" },
        { "That is your current character.", "不能把当前角色添加为机器人。" },
        { "That character is currently online.", "该角色当前已在线。" },
        { "That character is already linked to another player.",
          "该角色已被另一名玩家添加。" },
        { "That linked character is controlled by its owner account.",
          "该角色仅能由绑定它的玩家账号控制。" },
        { "'{}' is linked to another player.", "“{}”已由另一名玩家绑定。" },
        { "Account-linked bots are disabled on this realm.",
          "当前服务器已关闭账号机器人功能。" },
        { "Your active linked-bot limit has been reached.",
          "你已达到同时在线的账号机器人数量上限。" },
        { "Could not log in the linked character: {}",
          "无法登录已添加的角色：{}" },
        { "Linked character {} and started it as a bot. Only your account can control it.",
          "已添加角色“{}”并以机器人方式登录。此角色仅可由你的账号控制。" },
        { "This command must be used by an in-game player.",
          "该命令只能由游戏中的玩家使用。" },
    };
    return entries;
}

} // namespace Playerbot::Locale
