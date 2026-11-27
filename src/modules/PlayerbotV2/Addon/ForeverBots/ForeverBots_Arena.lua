--[[
ForeverBots_Arena: Enter and Leave buttons when an arena (2v2 / 3v3) is ready. The game's own arena pop shows Enter only, with no
way to turn the arena down (Karrz 2026-11-08: "have a leave as well, not just an enter"). Both buttons send the server line
(.bot arena enter / .bot arena leave); Leave also takes your party's bots out of the same queue. The pop-up closes by itself
once the arena is no longer waiting for you (you went in, left, or the invite ran out).
]]

local ADDON, ns = ...
local L = ns.L or setmetatable({}, { __index = function(_, k) return k end })   -- text by client language

local function Send(text)
    if ns.Queue then ns.Queue(text) end
end

-- The battlefield slot of an arena that waits for your answer, and its team size; nil when there is none.
local function ReadyArena()
    local count = (GetMaxBattlefieldID and GetMaxBattlefieldID()) or 3
    for i = 1, count do
        local ok, status, _, teamSize = pcall(GetBattlefieldStatus, i)
        if ok and status == "confirm" and (tonumber(teamSize) or 0) > 0 then
            return i, tonumber(teamSize)
        end
    end
end

-- Only a key of the client's table is ours (never assign StaticPopupDialogs itself: see ForeverBots_Quests.lua).
StaticPopupDialogs.FOREVERBOTS_ARENA_READY = {
    text = L["Your %dv%d arena is ready."],
    button1 = L["Enter"],
    button2 = L["Leave"],
    OnAccept = function() Send(".bot arena enter") end,
    OnCancel = function(_, _, reason)
        if reason == nil or reason == "clicked" then Send(".bot arena leave") end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = false,
    preferredIndex = 3,
}

local shownFor
local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    local slot, size = ReadyArena()
    if slot then
        if shownFor ~= slot then
            shownFor = slot
            StaticPopup_Show("FOREVERBOTS_ARENA_READY", size, size)
        end
    elseif shownFor then
        shownFor = nil
        StaticPopup_Hide("FOREVERBOTS_ARENA_READY")
    end
end)
