------------------------------------------------------------
-- SavedVariables initialization (unique names)
------------------------------------------------------------

if GuildRecruiter_RunRecruit == nil then GuildRecruiter_RunRecruit = true end
if GuildRecruiter_RecruitmentRunTimer == nil then GuildRecruiter_RecruitmentRunTimer = 900 end
if GuildRecruiter_RecruitChannel == nil then GuildRecruiter_RecruitChannel = "world" end
if GuildRecruiter_WorldOverride == nil then GuildRecruiter_WorldOverride = false end
if GuildRecruiter_GuildName == nil then GuildRecruiter_GuildName = "Group Therapy" end

if (not GuildRecruiter_NewZones) or (type(GuildRecruiter_NewZones) ~= "table") then
    GuildRecruiter_NewZones = {}
end

AddonName = "GuildRecruiter"
GuildRecruiter_LogInTime = GetTime()
GR_Version = 4 -- Update this will force a update of the recruit messages to default.

-- Runtime only
RecruitTime = GetTime()
StopGuildRecruit = false
strDND = false


------------------------------------------------------------
-- Recruitment messages (unique SavedVariable)
------------------------------------------------------------

local function MessageCheck()

    local DEFAULT_MESSAGES = {
        "<Group Therapy> PUGs! || BWL Mon 19:30 CET || MC Mon 21:00 CET || AQ40 Wed 19:30 CET || Naxx Sun 19:30 CET || Kara40 on the 26th! We promise only mild emotional damage. Info: https://discord.gg/mBFNyh7gh9",
        "<Group Therapy> PUGs! || BWL Mon 19:30 CET || MC Mon 21:00 CET || AQ40 Wed 19:30 CET || Naxx Sun 19:30 CET || Kara40 on the 26th! Mild emotional damage guaranteed. Info: https://discord.gg/mBFNyh7gh9",
        "<Group Therapy> is recruiting for Kara40 Progression || BWL Mon 19:30 CET || MC Mon 21:00 CET || AQ40 Wed 19:30 CET || Kara40 Thu 19:30 CET || Naxx Sun 19:30 CET. Join us for light emotional trauma. Info: https://discord.gg/mBFNyh7gh9",
        "<Group Therapy> is recruiting for Kara40 Progression || BWL Mon 19:30 CET || MC Mon 21:00 CET || AQ40 Wed 19:30 CET || Kara40 Thu 19:30 CET || Naxx Sun 19:30 CET. Therapy not included, mild damage is. Info: https://discord.gg/mBFNyh7gh9",
    }

    GuildRecruiter_Version = GuildRecruiter_Version or 0

    if GuildRecruiter_Version ~= GR_Version then
        GuildRecruiter_Messages = DEFAULT_MESSAGES
    else
        GuildRecruiter_Messages = GuildRecruiter_Messages or DEFAULT_MESSAGES
    end
end


------------------------------------------------------------
-- Message count helper
------------------------------------------------------------

local function GetRecruitmentMessageCount()
    local count = 0
    for _ in ipairs(GuildRecruiter_Messages) do
        count = count + 1
    end
    return count
end


------------------------------------------------------------
-- Message editing helpers
------------------------------------------------------------

local function ListMessages()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[GR] Recruitment messages:|r")
    local index = 0
    for i, msg in ipairs(GuildRecruiter_Messages) do
        index = i
        DEFAULT_CHAT_FRAME:AddMessage("  " .. i .. ": " .. msg)
    end
    if index == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("  (no messages)")
    end
end

local function AddMessage(newMsg)
    local len = string.len(newMsg)
    if len > 254 then
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Message too long (" .. len .. " chars). Max is 254.")
        return
    end

    table.insert(GuildRecruiter_Messages, newMsg)
    local count = GetRecruitmentMessageCount()
    DEFAULT_CHAT_FRAME:AddMessage("[GR] Added message " .. count)
end

local function RemoveMessage(index)
    if GuildRecruiter_Messages[index] then
        table.remove(GuildRecruiter_Messages, index)
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Removed message " .. index)
    else
        DEFAULT_CHAT_FRAME:AddMessage("[GR] No message with index " .. index)
    end
end


------------------------------------------------------------
-- Zones (FULL TABLE)
------------------------------------------------------------

Zones = {
    ["Ahn'Qiraj"] = true,
    ["Alterac Mountains"] = true,
    ["Arathi Highlands"] = true,
    ["Ashenvale"] = true,
    ["Azshara"] = true,
    ["Badlands"] = true,
    ["Blackrock Mountain"] = true,
    ["Blasted Lands"] = true,
    ["Burning Steppes"] = true,
    ["Darkshore"] = true,
    ["Deadwind Pass"] = true,
    ["Deeprun Tram"] = true,
    ["Desolace"] = true,
    ["Dun Morogh"] = true,
    ["Durotar"] = true,
    ["Duskwood"] = true,
    ["Dustwallow Marsh"] = true,
    ["Eastern Plaguelands"] = true,
    ["Elwynn Forest"] = true,
    ["Felwood"] = true,
    ["Feralas"] = true,
    ["Gates of Ahn'Qiraj"] = true,
    ["Hillsbrad Foothills"] = true,
    ["Loch Modan"] = true,
    ["Moonglade"] = true,
    ["Mulgore"] = true,
    ["Redridge Mountains"] = true,
    ["Scarlet Monastery"] = true,
    ["Searing Gorge"] = true,
    ["Silithus"] = true,
    ["Silverpine Forest"] = true,
    ["Stonetalon Mountains"] = true,
    ["Stranglethorn Vale"] = true,
    ["Swamp of Sorrows"] = true,
    ["Tanaris"] = true,
    ["Teldrassil"] = true,
    ["The Barrens"] = true,
    ["The Great Sea"] = true,
    ["The Hinterlands"] = true,
    ["Thousand Needles"] = true,
    ["Tirisfal Glades"] = true,
    ["Un'Goro Crater"] = true,
    ["Westfall"] = true,
    ["Western Plaguelands"] = true,
    ["Wetlands"] = true,
    ["Winterspring"] = true,

    ["Darnassus"] = true,
    ["Ironforge"] = true,
    ["Orgrimmar"] = true,
    ["Stormwind City"] = true,
    ["Thunder Bluff"] = true,
    ["Undercity"] = true,

    ["Blackfathom Deeps"] = "Nope",
    ["Blackrock Depths"] = "Nope",
    ["Blackrock Spire"] = "Nope",
    ["Dire Maul"] = "Nope",
    ["Gnomeregan"] = "Nope",
    ["Maraudon"] = "Nope",
    ["Ragefire Chasm"] = "Nope",
    ["Razorfen Downs"] = "Nope",
    ["Razorfen Kraul"] = "Nope",
    ["Scarlet Monastery Armory"] = "Nope",
    ["Scarlet Monastery Cathedral"] = "Nope",
    ["Scarlet Monastery Graveyard"] = "Nope",
    ["Scarlet Monastery Library"] = "Nope",
    ["Scholomance"] = "Nope",
    ["Shadowfang Keep"] = "Nope",
    ["Stratholme"] = "Nope",
    ["The Deadmines"] = "Nope",
    ["The Temple of Atal'Hakkar"] = "Nope",
    ["Uldaman"] = "Nope",
    ["Wailing Caverns"] = "Nope",
    ["Zul'Farrak"] = "Nope",

    ["Blackwing Lair"] = "Nope",
    ["Molten Core"] = "Nope",
    ["Naxxramas"] = "Nope",
    ["Onyxia's Lair"] = "Nope",
    ["Ruins of Ahn'Qiraj"] = "Nope",
    ["The Upper Necropolis"] = "Nope",
    ["Zul'Gurub"] = "Nope",

    ["Warsong Gulch"] = "Nope",

    ["Alah'Thalas"] = true,
    ["Amani'Alor"] = true,
    ["Balor"] = true,
    ["Blackstone Island"] = true,
    ["Caverns of Time"] = true,
    ["Gillijim's Isle"] = true,
    ["Gilneas"] = true,
    ["Grim Reaches"] = true,
    ["Hyjal"] = true,
    ["Lapidis Isle"] = true,
    ["Northwind"] = true,
    ["Scarlet Enclave"] = true,
    ["Tel'Abim"] = true,
    ["Thalassian Highlands"] = true,
    ["Winter Veil Vale"] = true,

    ["Crescent Grove"] = "Nope",
    ["Emerald Sanctum"] = "Nope",
    ["Gilneas City"] = "Nope",
    ["Karazhan Crypt"] = "Nope",
    ["Stormwind Vault"] = "Nope",
    ["Stormwrought Ruins"] = "Nope",
    ["The Black Morass"] = "Nope",
    ["Tower of Karazhan"] = "Nope",

    ["Lordaeron Arena"] = "Nope",
    ["Sunstrider Court"] = "Nope",
}


------------------------------------------------------------
-- PLAYER_LOGIN
------------------------------------------------------------

local function InitializeGuildName()
    if GuildRecruiter_GuildName == nil then
        GuildRecruiter_GuildName = "Group Therapy"
    end
end


------------------------------------------------------------
-- Guild check
------------------------------------------------------------

local function IsAllowedGuildAndRank()
    local gName = GetGuildInfo("player")
    if not gName then
        return false
    end
    if gName ~= GuildRecruiter_GuildName then
        return false
    end
    return true
end


------------------------------------------------------------
-- RegisterZone with cleanup-loop
------------------------------------------------------------

local function RegisterZone()
    local zone = GetRealZoneText()
    if not zone or zone == "" then return end

    for z in pairs(GuildRecruiter_NewZones) do
        if Zones[z] ~= nil then
            GuildRecruiter_NewZones[z] = nil
        end
    end

    if Zones[zone] ~= nil then
        return
    end

    if not GuildRecruiter_NewZones[zone] then
        GuildRecruiter_NewZones[zone] = "Unknown"
    end
end


------------------------------------------------------------
-- Handle system messages
------------------------------------------------------------

local function HandleSystemMessage(msg)
    if string.find(msg, string.sub(MARKED_DND, 1, string.len(MARKED_DND) - 3)) then
        StopGuildRecruit = true
        strDND = true
    elseif string.find(msg, string.sub(MARKED_AFK, 1, string.len(MARKED_AFK) - 2)) then
        StopGuildRecruit = true
    elseif msg == CLEARED_DND then
        StopGuildRecruit = false
        strDND = false
    elseif msg == CLEARED_AFK and not strDND then
        StopGuildRecruit = false
    end
end


------------------------------------------------------------
-- GuildRecruitment
------------------------------------------------------------

local function GuildRecruitment()
    RegisterZone()

    if StopGuildRecruit then return end
    if not IsAllowedGuildAndRank() then return end

    local zone = GetRealZoneText()
    if not zone or zone == "" then return end

    if not (GuildRecruiter_RecruitChannel == "world" and GuildRecruiter_WorldOverride) then
        if Zones[zone] ~= true then return end
    end

    local msgCount = GetRecruitmentMessageCount()
    if msgCount == 0 then return end

    local target = math.random(1, msgCount)
    local msg = GuildRecruiter_Messages[target]

    if not msg or string.len(msg) > 254 then return end

    for i = 1, 20 do
        local id, name = GetChannelName(i)
        if name and string.find(string.lower(name), GuildRecruiter_RecruitChannel) then
            SendChatMessage(msg, "CHANNEL", nil, id)
            RecruitTime = GetTime()
            break
        end
    end
end


local function GuildRecruitment_Manual()
    RecruitTime = 0
end


------------------------------------------------------------
-- Debug zones
------------------------------------------------------------

local function DebugZones()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[GR] Zone status:|r")

    local list = {}
    for zone in pairs(GuildRecruiter_NewZones) do
        table.insert(list, zone)
    end

    table.sort(list)

    local count = 0
    for _, zone in ipairs(list) do
        count = count + 1
        local known = Zones[zone]
        if known == true then
            DEFAULT_CHAT_FRAME:AddMessage("  |cff00ff00✔|r " .. zone .. " (allowed)")
        elseif known == "Nope" then
            DEFAULT_CHAT_FRAME:AddMessage("  |cffff0000✘|r " .. zone .. " (blocked)")
        else
            DEFAULT_CHAT_FRAME:AddMessage("  |cffffff00?|r " .. zone .. " (unknown)")
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[GR] Total: " .. count .. " unknown zones.|r")
end


------------------------------------------------------------
-- Frame & events
------------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("CHAT_MSG_SYSTEM")

f:SetScript("OnEvent", function()
    if event == "PLAYER_LOGIN" then
        InitializeGuildName()
        GuildRecruiter_RecruitChannel = string.lower(GuildRecruiter_RecruitChannel or "world")
        MessageCheck()

    elseif event == "CHAT_MSG_SYSTEM" then
        HandleSystemMessage(arg1)

    else
        RegisterZone()
    end
end)


------------------------------------------------------------
-- OnUpdate
------------------------------------------------------------

f:SetScript("OnUpdate", function()
    if GuildRecruiter_RunRecruit and (GetTime() >= (RecruitTime + GuildRecruiter_RecruitmentRunTimer)) then
        GuildRecruitment()
    end
    if (GuildRecruiter_LogInTime) and ((GuildRecruiter_LogInTime + 15) < GetTime()) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFF8000" .. AddonName .. "|r" .. " by " .. "|cFFFFF468" .. "Subby" .. "|r" .. " is loaded.")
        if (GuildRecruiter_Version ~= GR_Version) then
            DEFAULT_CHAT_FRAME:AddMessage("|cffFF8000" .. AddonName .. "|r" .. ": Recruitment messages have been updated.")
            GuildRecruiter_Version = GR_Version
        end
        GuildRecruiter_LogInTime = false
    end
    
end)


------------------------------------------------------------
-- Slash commands
------------------------------------------------------------

local function SlashHandler(msg)
    local msg = msg or ""
    local msgLower = string.lower(msg)

    if msgLower == "" then
        if GuildRecruiterUI then
            if GuildRecruiterUI:IsShown() then
                GuildRecruiterUI:Hide()
            else
                GuildRecruiterUI:Show()
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("[GR] UI not loaded.")
        end
        return
    end

    if msgLower == "on" then
        GuildRecruiter_RunRecruit = true
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Recruitment: ON")

    elseif msgLower == "off" then
        GuildRecruiter_RunRecruit = false
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Recruitment: OFF")

    elseif msgLower == "now" then
        GuildRecruitment_Manual()

    elseif msgLower == "status" then
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Recruitment: " .. (GuildRecruiter_RunRecruit and "ON" or "OFF"))
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Timer: " .. GuildRecruiter_RecruitmentRunTimer .. " seconds")
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Channel: " .. GuildRecruiter_RecruitChannel)
        DEFAULT_CHAT_FRAME:AddMessage("[GR] World override: " .. (GuildRecruiter_WorldOverride and "ON" or "OFF"))
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Guild: " .. (GuildRecruiter_GuildName or "n/a"))

    elseif string.sub(msgLower, 1, 3) == "msg" then
        local _, _, subcmd, rest = string.find(msg, "^msg%s+(%S+)%s*(.*)$")

        if subcmd == "list" then
            ListMessages()

        elseif subcmd == "add" then
            if rest and rest ~= "" then
                AddMessage(rest)
            else
                DEFAULT_CHAT_FRAME:AddMessage("[GR] Usage: /gr msg add <text>")
            end

        elseif subcmd == "remove" then
            local num = tonumber(rest)
            if num then
                RemoveMessage(num)
            else
                DEFAULT_CHAT_FRAME:AddMessage("[GR] Usage: /gr msg remove <number>")
            end

        else
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Message commands:")
            DEFAULT_CHAT_FRAME:AddMessage("  /gr msg list")
            DEFAULT_CHAT_FRAME:AddMessage("  /gr msg add <text>")
            DEFAULT_CHAT_FRAME:AddMessage("  /gr msg remove <number>")
        end

    elseif string.sub(msgLower, 1, 5) == "timer" then
        local _, _, numStr = string.find(msgLower, "^timer%s*(%d+)%s*$")
        if not numStr then
            _, _, numStr = string.find(msgLower, "(%d+)")
        end

        local num = numStr and tonumber(numStr) or nil
        if num and num > 0 then
            GuildRecruiter_RecruitmentRunTimer = num
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Timer set to " .. num)
        else
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Usage: /gr timer <seconds>")
        end

    elseif string.sub(msgLower, 1, 7) == "channel" then
        local _, _, ch = string.find(msgLower, "^channel%s+(%S+)")
        if ch then
            GuildRecruiter_RecruitChannel = string.lower(ch)
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Channel set to: " .. GuildRecruiter_RecruitChannel)
        else
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Usage: /gr channel <name>")
        end

    elseif string.sub(msgLower, 1, 5) == "guild" then
        local _, _, name = string.find(msg, "^guild%s+(.+)")
        if name then
            GuildRecruiter_GuildName = name
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Guild name set to: " .. name)
        else
            DEFAULT_CHAT_FRAME:AddMessage("[GR] Usage: /gr guild <guild name>")
        end

    elseif msgLower == "worldoverride on" then
        GuildRecruiter_WorldOverride = true
        DEFAULT_CHAT_FRAME:AddMessage("[GR] World override ENABLED")

    elseif msgLower == "worldoverride off" then
        GuildRecruiter_WorldOverride = false
        DEFAULT_CHAT_FRAME:AddMessage("[GR] World override DISABLED")

    elseif msgLower == "zones" then
        DebugZones()

    else
        DEFAULT_CHAT_FRAME:AddMessage("[GR] Unknown command. Type /gr to open UI.")
    end
end

SlashCmdList["GR"] = SlashHandler
SLASH_GR1 = "/gr"
