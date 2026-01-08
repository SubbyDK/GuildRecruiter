------------------------------------------------------------
-- GuildRecruiter UI Window
------------------------------------------------------------

local GRUI = CreateFrame("Frame", "GuildRecruiterUI", UIParent)
GRUI:SetWidth(400)
GRUI:SetHeight(350)

-- Center window (Vanilla-correct SetPoint)
GRUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

GRUI:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
GRUI:SetBackdropColor(0, 0, 0, 0.85)
GRUI:Hide()

-- Movable
GRUI:SetMovable(true)
GRUI:EnableMouse(true)
GRUI:RegisterForDrag("LeftButton")
GRUI:SetScript("OnDragStart", GRUI.StartMoving)
GRUI:SetScript("OnDragStop", GRUI.StopMovingOrSizing)

------------------------------------------------------------
-- Close button
------------------------------------------------------------

local close = CreateFrame("Button", nil, GRUI, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", GRUI, "TOPRIGHT", -5, -5)

------------------------------------------------------------
-- Title
------------------------------------------------------------

local title = GRUI:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", GRUI, "TOP", 0, -15)
title:SetText("GuildRecruiter Commands")

------------------------------------------------------------
-- ScrollFrame for text
------------------------------------------------------------

local scrollFrame = CreateFrame("ScrollFrame", "GRUIScrollFrame", GRUI, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", GRUI, "TOPLEFT", 15, -45)
scrollFrame:SetPoint("BOTTOMRIGHT", GRUI, "BOTTOMRIGHT", -30, 15)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetWidth(340)
content:SetHeight(1)
scrollFrame:SetScrollChild(content)

local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
text:SetFont("Fonts\\FRIZQT__.TTF", 14)
text:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
text:SetWidth(340)
text:SetJustifyH("LEFT")

------------------------------------------------------------
-- Command list text
------------------------------------------------------------

local helpText = [[
|cffffff00/gr|r
  Open or close this window.

|cffffff00/gr on|r
  Enable automatic recruitment.

|cffffff00/gr off|r
  Disable automatic recruitment.

|cffffff00/gr now|r
  Send a recruitment message immediately.

|cffffff00/gr status|r
  Show current settings.

|cffffff00/gr zones|r
  Show zones not yet defined in the addon.

|cffffff00/gr timer <seconds>|r
  Set delay between recruitment messages.

|cffffff00/gr channel <name>|r
  Set the chat channel to send messages in.

|cffffff00/gr guild <guild name>|r
  Set the guild name required to run recruitment.

|cffffff00/gr worldoverride on/off|r
  World Override:
  On = recruit everywhere.
  Off = no recruiting in instances, BGs, or raids.

|cffffff00/gr msg list|r
  List recruitment messages.

|cffffff00/gr msg add <text>|r
  Add a recruitment message.

|cffffff00/gr msg remove <number>|r
  Remove a recruitment message.
]]

text:SetText(helpText)
