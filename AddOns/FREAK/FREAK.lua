-- -------------------------------------------------------------------------- --
--                                                                            --
--                           __| _ \ __|   \   |  /                           --
--                           _|    / _|   _ \  | <                            --
--                          _|  _|_\___|_/  _\_|\_\                           --
--                                         by kunda                           --
--                                                                            --
--                Freaking geaR dEpendent Achievement checKer                 --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- Gear check for the Achievements 'A Tribute to Dedicated Insanity' (4080)   --
-- and 'Herald of the Titans' (3316).                                         --
--                                                                            --
-- Notes:                                                                     --
-- - THERE IS NO WARRANTY THAT THIS ADDON GIVES A VALID GEAR CHECK FOR THE    --
--   ABOVE-MENTIONED ACHIEVEMENTS!                                            --
-- - Please read FREAK_GearData.lua.                                          --
-- - Please use the wowace.com forum if you find an error. Thanks.            --
-- - FREAK GUI available via LDB, InterfaceOptions or '/freak'.               --
--                                                                            --
-- -------------------------------------------------------------------------- --

-- ---------------------------------------------------------------------------------------------------------------------
FREAK = CreateFrame("Frame")     -- container
FREAK_Options = {}               -- SavedVariable options table

local L = FREAK_Locales          -- localization table
local DATA = FREAK_GearData      -- valid gear data table

local _G = _G
local GetTime = _G.GetTime
local math_floor = _G.math.floor

local mult2 = 10^(2 or 0)        -- x.xx
local playerGUID = ""            -- current character GUID (set after event PLAYER_LOGIN triggered)
local SingleScanIsActive = false -- false = SingleScan is NOT active | true = SingleScan is active
local GroupScanIsActive = false  -- false = GroupScan is NOT active | true = GroupScan is active
local GroupScanNext = false      --
local AchievementIDTable = {}    --
local SCANGUID                   -- current scan GUID
local SCAN = {}                  -- scanned unit data (key = GUID)
local GUI_Data = {}              --
local GUI_Data_Count             --
local GUI_Data_curNum = 10       -- data table current rows
local GUI_Data_maxNum = 10       -- data table max rows

local classcolors = RAID_CLASS_COLORS

local GearSlots = {
  [1]  = {name = "HeadSlot",          id =  1, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Head"},
  [2]  = {name = "NeckSlot",          id =  2, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Neck"},
  [3]  = {name = "ShoulderSlot",      id =  3, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Shoulder"},
  [4]  = {name = "BackSlot",          id = 15, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Chest"}, -- Back
  [5]  = {name = "ChestSlot",         id =  5, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Chest"},
--[6]  = {name = "ShirtSlot",         id =  4, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Shirt"},
--[7]  = {name = "TabardSlot",        id = 19, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Tabard"},
  [6]  = {name = "WristSlot",         id =  9, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Wrists"},
  [7]  = {name = "MainHandSlot",      id = 16, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-MainHand"},
  [8]  = {name = "SecondaryHandSlot", id = 17, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-SecondaryHand"},
  [9]  = {name = "RangedSlot",        id = 18, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Ranged"},
--[12] = {name = "AmmoSlot",          id =  0, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Ammo"},
  [10] = {name = "Trinket1Slot",      id = 14, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Trinket"},
  [11] = {name = "Trinket0Slot",      id = 13, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Trinket"},
  [12] = {name = "Finger1Slot",       id = 12, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Finger"},
  [13] = {name = "Finger0Slot",       id = 11, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Finger"},
  [14] = {name = "FeetSlot",          id =  8, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Feet"},
  [15] = {name = "LegsSlot",          id =  7, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Legs"},
  [16] = {name = "WaistSlot",         id =  6, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Waist"}, -- Belt
  [17] = {name = "HandsSlot",         id = 10, texture="Interface\\Paperdoll\\UI-PaperDoll-Slot-Hands"}
}

local invtype = {}
invtype.INVTYPE_AMMO = 1           -- Ammo 0
invtype.INVTYPE_HEAD = 1           -- Head 1
invtype.INVTYPE_NECK = 1           -- Neck 2
invtype.INVTYPE_SHOULDER = 1       -- Shoulder 3
invtype.INVTYPE_BODY = 1           -- Shirt 4
invtype.INVTYPE_CHEST = 1          -- Chest 5
invtype.INVTYPE_ROBE = 1           -- Chest 5
invtype.INVTYPE_WAIST = 1          -- Waist 6
invtype.INVTYPE_LEGS = 1           -- Legs 7
invtype.INVTYPE_FEET = 1           -- Feet 8
invtype.INVTYPE_WRIST = 1          -- Wrist 9
invtype.INVTYPE_HAND = 1           -- Hands 10
invtype.INVTYPE_FINGER = 1         -- Fingers 11,12
invtype.INVTYPE_TRINKET = 1        -- Trinkets 13,14
invtype.INVTYPE_CLOAK = 1          -- Cloaks 15
invtype.INVTYPE_WEAPON = 1         -- One-Hand 16,17
invtype.INVTYPE_SHIELD = 1         -- Shield 17
invtype.INVTYPE_2HWEAPON = 1       -- Two-Handed 16
invtype.INVTYPE_WEAPONMAINHAND = 1 -- Main-Hand Weapon 16
invtype.INVTYPE_WEAPONOFFHAND = 1  -- Off-Hand Weapon 17
invtype.INVTYPE_HOLDABLE = 1       -- Held In Off-Hand 17
invtype.INVTYPE_RANGED = 1         -- Bows 18
invtype.INVTYPE_THROWN = 1         -- Ranged 18
invtype.INVTYPE_RANGEDRIGHT = 1    -- Wands, Guns, and Crossbows 18
invtype.INVTYPE_RELIC = 1          -- Relics 18
invtype.INVTYPE_TABARD = 1         -- Tabard 19  


-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function Print(...)
	print("|cffffff7fFREAK:|r", ...)
end

local function NOOP() end

local function CreateScanDataByGUID(guid)
	SCAN[guid] = {}
	SCAN[guid].canInspect = false -- scanned unit: unit is inspectable
	SCAN[guid].name = ""          -- scanned unit: name
	SCAN[guid].classEN = ""       -- scanned unit: class (english)
	SCAN[guid].gear = {}          -- scanned unit: item data from every gear slot
	SCAN[guid].itemlevelAvg = 0   -- scanned unit: itemlevel - average item level
end

local function BuildIDTable()
	for i = 1, #DATA do
		if DATA[i].achievementID then
			AchievementIDTable[DATA[i].achievementID] = select(2, GetAchievementInfo(DATA[i].achievementID))
		end
	end
end

local function GearTooltipHandler(self)
	if not self.comparing and IsModifiedClick("COMPAREITEMS") then
		self.shoppingTooltips = {ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3}
		GameTooltip_ShowCompareItem()
		self.comparing = true
	elseif self.comparing and not IsModifiedClick("COMPAREITEMS") then
		for _, frame in pairs(self.shoppingTooltips) do
			frame:Hide()
		end
		self.comparing = false
	end
	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end

local function cnum(number)
	local a = tostring(number)
	local p = string.find(a, ".", 1, true)
	if p then
		local r = string.sub(a, p+1)
		if string.len(r) == 1 then
			number = number.."0"
		end
	else
		number = number..".00"
	end
	return number -- string
end

local Hooks = {}
function Hooks:SetAction(id)
	local _, item = self:GetItem()
	if not item then return end
	FREAK:AddNote(self, item)
end
function Hooks:SetAuctionItem()
	FREAK:AddNote(self)
end
function Hooks:SetAuctionSellItem()
	FREAK:AddNote(self)
end
function Hooks:SetBagItem()
	FREAK:AddNote(self)
end
function Hooks:SetHyperlink()
	FREAK:AddNote(self)
end
function Hooks:SetInboxItem()
	FREAK:AddNote(self)
end
function Hooks:SetInventoryItem(unit, slot)
	if type(slot) ~= "number" or slot < 0 then return end
	FREAK:AddNote(self)
end
function Hooks:SetLootItem()
	FREAK:AddNote(self)
end
function Hooks:SetLootRollItem()
	FREAK:AddNote(self)
end
function Hooks:SetMerchantCostItem()
	FREAK:AddNote(self)
end
function Hooks:SetMerchantItem()
	FREAK:AddNote(self)
end
function Hooks:SetQuestItem()
	FREAK:AddNote(self)
end
function Hooks:SetQuestLogItem()
	FREAK:AddNote(self)
end
function Hooks:SetSendMailItem()
	FREAK:AddNote(self)
end
function Hooks:SetTradePlayerItem()
	FREAK:AddNote(self)
end
function Hooks:SetTradeSkillItem()
	FREAK:AddNote(self)
end
function Hooks:SetTradeTargetItem()
	FREAK:AddNote(self)
end
function Hooks:SetGuildBankItem()
	FREAK:AddNote(self)
end

local function InstallHooks(tooltip, hooks)
	for name, func in pairs(hooks) do
		hooksecurefunc(tooltip, name, func)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:InitializeOptions()
	SlashCmdList["FREAK"] = function() FREAK:MainFrameToggle() end
	SLASH_FREAK1 = "/freak"

	if FREAK_Options.version          == nil then FREAK_Options.version          = 1 end
	if FREAK_Options.Data_Achievement == nil then FREAK_Options.Data_Achievement = DATA[1].achievementID end
	if FREAK_Options.Tooltip4080      == nil then FREAK_Options.Tooltip4080      = false end
	if FREAK_Options.Tooltip3316      == nil then FREAK_Options.Tooltip3316      = false end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:LDBcheck()
	if LibStub and LibStub:GetLibrary("CallbackHandler-1.0", true) and LibStub:GetLibrary("LibDataBroker-1.1", true) then
		LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("FREAK", {
			type = "launcher",
			icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
			OnClick = function(self, button)
				FREAK:MainFrameToggle()
			end,
		})
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:CreateInterfaceOptions()
	local options = CreateFrame("Frame", "FREAK_InterfaceOptions")
	options.name = "FREAK"

	local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("FREAK")
	title:SetJustifyH("LEFT")
	title:SetJustifyV("TOP")

	CreateFrame("Button", "FREAK_InterfaceOptions_GUI", FREAK_InterfaceOptions, "UIPanelButtonTemplate")
	FREAK_InterfaceOptions_GUI:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
	FREAK_InterfaceOptions_GUI:SetWidth(120)
	FREAK_InterfaceOptions_GUI:SetHeight(24)
	FREAK_InterfaceOptions_GUIText:SetText(L["Open GUI"])
	FREAK_InterfaceOptions_GUI:SetScript("OnClick", function(self)
		InterfaceOptionsFrame_Show() -- hide InterfaceOptionsFrame
		HideUIPanel(GameMenuFrame) -- hide GameMenuFrame
		FREAK:MainFrameToggle() -- show GUI
	end)

	InterfaceOptions_AddCategory(options)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:AddNote(tooltip, item)
	if not FREAK_Options.Tooltip4080 and not FREAK_Options.Tooltip3316 then return end

	local item = item or select(2, tooltip:GetItem())
	if not item then return end

	local itemID = select(3, item:find("item:(%d+)"))
	itemID = tonumber(itemID)
	if not itemID then return end

	local _, _, _, itemLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemID)
	if not itemEquipLoc then return end

	if invtype[itemEquipLoc] then

		if FREAK_Options.Tooltip4080 then
			if FREAK:ValidateItem(4080, itemID, itemLevel, itemEquipLoc) then
				tooltip:AddLine("|cffffd100FREAK:|r "..AchievementIDTable[4080].." (4080) = "..L["VALID"], 0,0.75,0)
			else
				tooltip:AddLine("|cffffd100FREAK:|r "..AchievementIDTable[4080].." (4080) = "..L["NOT VALID"], 1,0,0)
			end
		end

		if FREAK_Options.Tooltip3316 then
			if FREAK:ValidateItem(3316, itemID, itemLevel, itemEquipLoc) then
				tooltip:AddLine("|cffffd100FREAK:|r "..AchievementIDTable[3316].." (3316) = "..L["VALID"], 0,0.75,0)
			else
				tooltip:AddLine("|cffffd100FREAK:|r "..AchievementIDTable[3316].." (3316) = "..L["NOT VALID"], 1,0,0)
			end
		end

		if FREAK_Options.Tooltip4080 or FREAK_Options.Tooltip3316 then
			tooltip:Show()
		end

	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:ValidateItem(achievementID, itemID, itemLevel, itemEquipLoc, itemEquipNum)
	if achievementID == 4080 then
		local valid = false
		if itemLevel < 245 then
			valid = true
		else
			if DATA[1].gear[itemID] then
				valid = true
			end
		end
		return valid
	elseif achievementID == 3316 then
		local valid = false
		if itemLevel <= 226 then
			valid = true
		elseif itemLevel <= 232 then
			if itemEquipNum then
				if itemEquipNum == 16 then     -- One-Hand (INVTYPE_WEAPON), Two-Handed (INVTYPE_2HWEAPON), Main-Hand Weapon (INVTYPE_WEAPONMAINHAND)
					valid = true
				elseif itemEquipNum == 17 then -- One-Hand (INVTYPE_WEAPON), Shield (INVTYPE_SHIELD), Off-Hand Weapon (INVTYPE_WEAPONOFFHAND), Held In Off-Hand (INVTYPE_HOLDABLE)
					valid = true
				elseif itemEquipNum == 18 then -- Bows (INVTYPE_RANGED), Ranged (INVTYPE_THROWN), Wands, Guns, and Crossbows (INVTYPE_RANGEDRIGHT), Relics (INVTYPE_RELIC)
					valid = true
				end
			else
				if itemEquipLoc == "INVTYPE_WEAPON" then             -- One-Hand 16,17
					valid = true
				elseif itemEquipLoc == "INVTYPE_SHIELD" then         -- Shield 17
					valid = true
				elseif itemEquipLoc == "INVTYPE_2HWEAPON" then       -- Two-Handed 16
					valid = true
				elseif itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then -- Main-Hand Weapon 16
					valid = true
				elseif itemEquipLoc == "INVTYPE_WEAPONOFFHAND" then  -- Off-Hand Weapon 17
					valid = true
				elseif itemEquipLoc == "INVTYPE_HOLDABLE" then       -- Held In Off-Hand 17
					valid = true
				elseif itemEquipLoc == "INVTYPE_RANGED" then         -- Bows 18
					valid = true
				elseif itemEquipLoc == "INVTYPE_THROWN" then         -- Ranged 18
					valid = true
				elseif itemEquipLoc == "INVTYPE_RANGEDRIGHT" then    -- Wands, Guns, and Crossbows 18
					valid = true
				elseif itemEquipLoc == "INVTYPE_RELIC" then          -- Relics 18
					valid = true
				end
			end
		end
		return valid
	end
	return false
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function TemplateBorderTRBL(frame)
	local texture = frame:CreateTexture(nil, "BORDER")
	texture:SetPoint("TOPLEFT", 1, -1)
	texture:SetPoint("BOTTOMRIGHT", -1, 1)
	texture:SetTexture(0, 0, 0, 1)
	local textureBackground = frame:CreateTexture(nil, "BACKGROUND")
	textureBackground:SetPoint("TOPLEFT", 0, 0)
	textureBackground:SetPoint("BOTTOMRIGHT", 0, 0)
	textureBackground:SetTexture(0.4, 0.4, 0.4, 1)
end

local function TemplateTextButton(button, text, action)
	local name = button:GetName()

	local font
	local buttoncolor
	local fontcolor
	if action == 1 then
		font = "GameFontNormal"
		buttoncolor = {0.38, 0, 0, 1}
		fontcolor = {1, 0.82, 0, 1}
	elseif action == 2 then
		font = "GameFontWhiteSmall"
		buttoncolor = {0.38, 0, 0, 1}
		fontcolor = {1, 0.82, 0, 1}
	else
		font = "GameFontNormal"
		buttoncolor = {0, 0, 0, 1}
		fontcolor = {1, 0.82, 0, 1}
	end

	local textureBack = button:CreateTexture(nil, "BORDER")
	textureBack:SetPoint("TOPLEFT", 1, -1)
	textureBack:SetPoint("BOTTOMRIGHT", -1, 1)
	textureBack:SetTexture(0, 0, 0, 1)

	local texture = button:CreateTexture(nil, "ARTWORK")
	texture:SetPoint("TOPLEFT", 2, -2)
	texture:SetPoint("BOTTOMRIGHT", -2, 2)
	texture:SetTexture(buttoncolor[1], buttoncolor[2], buttoncolor[3], buttoncolor[4])

	local textureBorder = button:CreateTexture(nil, "BACKGROUND")
	textureBorder:SetPoint("TOPLEFT", 0, 0)
	textureBorder:SetPoint("BOTTOMRIGHT", 0, 0)
	textureBorder:SetTexture(0.4, 0.4, 0.4, 1)

	local textureHighlight = button:CreateTexture(nil, "OVERLAY")
	textureHighlight:SetPoint("TOPLEFT", 3, -3)
	textureHighlight:SetPoint("BOTTOMRIGHT", -3, 3)
	textureHighlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(textureHighlight)

	local buttontext = button:CreateFontString(name.."Text", "OVERLAY", font)
	buttontext:SetText(text)
	buttontext:SetWidth( buttontext:GetStringWidth()+10 )
	buttontext:SetHeight(12)
	buttontext:SetPoint("CENTER", button, "CENTER", 0, 0)
	buttontext:SetJustifyH("CENTER")
	buttontext:SetTextColor(fontcolor[1], fontcolor[2], fontcolor[3], fontcolor[4])

	button:SetScript("OnMouseDown", function() buttontext:SetPoint("CENTER", button, "CENTER", 1, -1) end)
	button:SetScript("OnMouseUp", function() buttontext:SetPoint("CENTER", button, "CENTER", 0, 0) end)
end

local function TemplateIconButton(button, cut)
	local name = button:GetName()

	local textureBack = button:CreateTexture(nil, "BORDER")
	textureBack:SetPoint("TOPLEFT", 1, -1)
	textureBack:SetPoint("BOTTOMRIGHT", -1, 1)
	textureBack:SetTexture(0, 0, 0, 1)

	local textureBorder = button:CreateTexture(nil, "BACKGROUND")
	textureBorder:SetPoint("TOPLEFT", 0, 0)
	textureBorder:SetPoint("BOTTOMRIGHT", 0, 0)
	textureBorder:SetTexture(0.4, 0.4, 0.4, 1)

	if cut == 1 then
		local textureNormal = button:CreateTexture(nil, "ARTWORK")
		textureNormal:SetPoint("TOPLEFT", 3, -3)
		textureNormal:SetPoint("BOTTOMRIGHT", -3, 3)
		textureNormal:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		textureNormal:SetTexCoord(8/32, 22/32, 10/32, 22/32)
		button:SetNormalTexture(textureNormal)
		local texturePush = button:CreateTexture(nil, "ARTWORK")
		texturePush:SetPoint("TOPLEFT", 4, -4)
		texturePush:SetPoint("BOTTOMRIGHT", -4, 4)
		texturePush:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		texturePush:SetTexCoord(8/32, 22/32, 10/32, 22/32)
		button:SetPushedTexture(texturePush)
	end

	local textureHighlight = button:CreateTexture(nil, "OVERLAY")
	textureHighlight:SetPoint("TOPLEFT", 3, -3)
	textureHighlight:SetPoint("BOTTOMRIGHT", -3, 3)
	textureHighlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(textureHighlight)
end

local function TemplateCheckButton(button, size, space, text)
	local name = button:GetName()
	local width

	local textureBorder = button:CreateTexture(nil, "BACKGROUND")
	textureBorder:SetWidth( size )
	textureBorder:SetHeight( size )
	textureBorder:SetPoint("LEFT", 0, 0)
	textureBorder:SetTexture(0.4, 0.4, 0.4, 1)

	local textureBackground = button:CreateTexture(nil, "BORDER")
	textureBackground:SetPoint("TOPLEFT", textureBorder, "TOPLEFT", 1, -1)
	textureBackground:SetPoint("BOTTOMRIGHT", textureBorder, "BOTTOMRIGHT", -1, 1)
	textureBackground:SetTexture(0, 0, 0, 1)

	local textureNormal = button:CreateTexture(nil, "ARTWORK")
	textureNormal:SetPoint("TOPLEFT", textureBorder, "TOPLEFT", 1, -1)
	textureNormal:SetPoint("BOTTOMRIGHT", textureBorder, "BOTTOMRIGHT", -1, 1)
	textureNormal:SetTexture(0, 0, 0, 1)
	button:SetNormalTexture(textureNormal)

	local texturePush = button:CreateTexture(nil, "ARTWORK")
	texturePush:SetPoint("TOPLEFT", textureBorder, "TOPLEFT", 4, -4)
	texturePush:SetPoint("BOTTOMRIGHT", textureBorder, "BOTTOMRIGHT", -4, 4)
	texturePush:SetTexture(0.4, 0.4, 0.4, 0.5)
	button:SetPushedTexture(texturePush)

	local textureChecked = button:CreateTexture(nil, "ARTWORK")
	textureChecked:SetWidth( size )
	textureChecked:SetHeight( size )
	textureChecked:SetPoint("LEFT", 0, 0)
	textureChecked:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:SetCheckedTexture(textureChecked)

	local buttontext = button:CreateFontString(nil, "OVERLAY", "GameFontWhiteSmall")
	buttontext:SetHeight( size )
	buttontext:SetPoint("LEFT", textureNormal, "RIGHT", space, 0)
	buttontext:SetJustifyH("LEFT")
	buttontext:SetText(text)

	local textureHighlight = button:CreateTexture(nil, "OVERLAY")
	textureHighlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	textureHighlight:SetPoint("BOTTOMRIGHT", buttontext, "BOTTOMRIGHT", space, 0)
	textureHighlight:SetTexture(1, 1, 1, 0.1)
	textureHighlight:Hide()

	button:SetWidth(size + space + buttontext:GetStringWidth() + space)
	button:SetHeight(size)
	button:SetScript("OnEnter", function() textureHighlight:Show() end)
	button:SetScript("OnLeave", function() textureHighlight:Hide() end)
end

local function TemplateButtonTexture(button, pos)
	local textureNormal = button:CreateTexture(nil, "ARTWORK")
	textureNormal:SetWidth(16)
	textureNormal:SetHeight(16)
	textureNormal:SetPoint("LEFT", 0, 0)
	textureNormal:SetTexture("Interface\\Buttons\\UI-ScrollBar-Scroll"..pos.."Button-Up")
	textureNormal:SetTexCoord(6/32, 25/32, 7/32, 24/32)
	button:SetNormalTexture(textureNormal)

	local texturePush = button:CreateTexture(nil, "ARTWORK")
	texturePush:SetWidth(16)
	texturePush:SetHeight(16)
	texturePush:SetPoint("LEFT", 0, 0)
	texturePush:SetTexture("Interface\\Buttons\\UI-ScrollBar-Scroll"..pos.."Button-Down")
	texturePush:SetTexCoord(6/32, 25/32, 7/32, 24/32)
	button:SetPushedTexture(texturePush)

	local textureHighlight = button:CreateTexture(nil, "ARTWORK")
	textureHighlight:SetWidth(16)
	textureHighlight:SetHeight(16)
	textureHighlight:SetPoint("LEFT", 0, 0)
	textureHighlight:SetTexture("Interface\\Buttons\\UI-ScrollBar-Scroll"..pos.."Button-Highlight")
	textureHighlight:SetTexCoord(6/32, 25/32, 7/32, 24/32)
	button:SetHighlightTexture(textureHighlight)

	local textureDisable = button:CreateTexture(nil, "ARTWORK")
	textureDisable:SetWidth(16)
	textureDisable:SetHeight(16)
	textureDisable:SetPoint("LEFT", 0, 0)
	textureDisable:SetTexture("Interface\\Buttons\\UI-ScrollBar-Scroll"..pos.."Button-Disabled")
	textureDisable:SetTexCoord(6/32, 25/32, 7/32, 24/32)
	button:SetDisabledTexture(textureDisable)

	local shaderSupported = textureDisable:SetDesaturated(true)
	if not shaderSupported then
		textureDisable:SetVertexColor(0.5, 0.5, 0.5)
	end
end

local function TemplateScrollFrame(frame)
	local name = frame:GetName()

	frame.offset = 0
	frame:EnableMouseWheel(true)

	local scrollBar = CreateFrame("Slider", name.."ScrollBar", frame)
	scrollBar:SetWidth(16)
	scrollBar:SetHeight(0)
	scrollBar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 2, -16)
	scrollBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 2, 16)
	scrollBar:SetMinMaxValues(0, 0)
	scrollBar:SetValue(0)
	scrollBar:SetOrientation("VERTICAL")
	scrollBar:EnableMouseWheel(true)
	scrollBar:SetScript("OnValueChanged", function(self, value)
		frame:SetVerticalScroll(value)
	end)
	scrollBar:SetScript("OnMouseWheel", function(self, delta)
		ScrollFrameTemplate_OnMouseWheel(frame, delta)
	end)

	local upButton = CreateFrame("Button",  name.."ScrollBarScrollUpButton", scrollBar)
	upButton:SetWidth(16)
	upButton:SetHeight(16)
	upButton:SetPoint("BOTTOM", scrollBar, "TOP", 0, 0)
	upButton:SetScript("OnClick", function()
		scrollBar:SetValue(scrollBar:GetValue() - (scrollBar:GetHeight() / 2))
		PlaySound("UChatScrollButton")
	end)
	TemplateButtonTexture(upButton, "Up")

	local downButton = CreateFrame("Button",  name.."ScrollBarScrollDownButton", scrollBar)
	downButton:SetWidth(16)
	downButton:SetHeight(16)
	downButton:SetPoint("TOP", scrollBar, "BOTTOM", 0, 0)
	downButton:SetScript("OnClick", function()
		scrollBar:SetValue(scrollBar:GetValue() + (scrollBar:GetHeight() / 2))
		PlaySound("UChatScrollButton")
	end)
	TemplateButtonTexture(downButton, "Down")

	local thumb = scrollBar:CreateTexture(name.."ScrollBarThumbTexture", "BORDER")
	thumb:SetWidth(14)
	thumb:SetHeight(16)
	thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	thumb:SetTexCoord(8/32, 23/32, 8/32, 23/32)
	scrollBar:SetThumbTexture(thumb)

	frame:SetScript("OnScrollRangeChanged", function(self, xrange, yrange)
		ScrollFrame_OnScrollRangeChanged(self, xrange, yrange)
	end)
	frame:SetScript("OnMouseWheel", function(self, delta)
		ScrollFrameTemplate_OnMouseWheel(self, delta)
	end)
	frame:SetScript("OnVerticalScroll", function(self, off)
		scrollBar:SetValue(off)
	end)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:CreateMainFrame()
	local width_mainframe = 3 + 20 + 2 + 150 + 2 + 40 + 2 + (#GearSlots*24) + ((#GearSlots-1)*2) + 2 + 20 + 2 + 16 + 3

	local mainframe = CreateFrame("Frame", "FREAK_MainFrame", UIParent)
	mainframe:EnableMouse(true)
	mainframe:SetMovable(true)
	mainframe:SetToplevel(true)
	mainframe:SetClampedToScreen(true)
	mainframe:Hide()
	mainframe:SetWidth(width_mainframe)
	mainframe:SetHeight(28)
	mainframe:SetScript("OnShow", function() FREAK:MainFrameShow() end)
	mainframe:SetScript("OnHide", function() FREAK:MainFrameHide() end)

	-- MoverInfoTop Frame START
	local moverinfo = CreateFrame("Frame", "FREAK_MoverInfoTopFrame", mainframe)
	moverinfo:SetWidth(150)
	moverinfo:SetHeight(14)
	moverinfo:SetPoint("BOTTOM", FREAK_MainFrame, "TOP", 0, 0)
	moverinfo:EnableMouse(true)
	moverinfo:Hide()
	local texture = moverinfo:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(moverinfo)
	texture:SetTexture(0, 0, 0, 0.5)
	local text = moverinfo:CreateFontString("FREAK_MoverInfoTopFrame_Text", "ARTWORK", "GameFontWhiteSmall")
	text:SetPoint("CENTER", moverinfo, "CENTER", 0, 0)
	text:SetJustifyH("CENTER")
	text:SetTextColor(0.4, 0.4, 0.4, 1)
	-- MoverInfoTop Frame END

	-- Headline Frame START
	local headline = CreateFrame("Frame", "FREAK_HeadlineFrame", mainframe)
	TemplateBorderTRBL(headline)
	headline:SetWidth(width_mainframe)
	headline:SetHeight(28)
	headline:SetPoint("TOPLEFT", FREAK_MainFrame, "TOPLEFT", 0, 0)
	headline:EnableMouse(true)

	local title = headline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	title:SetPoint("LEFT", headline, "LEFT", 4, 0)
	title:SetJustifyH("LEFT")
	title:SetText("FREAK ")

	local title2 = headline:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	title2:SetPoint("LEFT", title, "RIGHT", 0, 0)
	title2:SetJustifyH("LEFT")
	title2:SetTextColor(0.7, 0.7, 0.7, 1)
	title2:SetText("(|cffffd100F|rreaking gea|cffffd100R|r d|cffffd100E|rpendent |cffffd100A|rchievement chec|cffffd100K|rer)")

	local headlineButtonX = CreateFrame("Button", "FREAK_HeadlineFrame_ButtonX", headline)
	TemplateIconButton(headlineButtonX, 1)
	headlineButtonX:SetWidth(20)
	headlineButtonX:SetHeight(20)
	headlineButtonX:SetPoint("RIGHT", FREAK_HeadlineFrame, "RIGHT", -4, 0)
	headlineButtonX:SetScript("OnClick", function() FREAK:MainFrameToggle() end)

	local headlineButtonMover = CreateFrame("Button", "FREAK_HeadlineFrame_ButtonMover", headline)
	headlineButtonMover:SetWidth(22)
	headlineButtonMover:SetHeight(28)
	headlineButtonMover:SetPoint("LEFT", headline, "LEFT", 0, 0)
	headlineButtonMover:SetPoint("RIGHT", headlineButtonX, "LEFT", 0, 0)
	local textureMover = headlineButtonMover:CreateTexture(nil, "BACKGROUND")
	textureMover:SetWidth(1)
	textureMover:SetHeight(1)
	textureMover:SetPoint("LEFT", title, "RIGHT", 0, 0)
	textureMover:SetPoint("TOPRIGHT", headlineButtonMover, "TOPRIGHT", 0, 0)
	textureMover:SetPoint("BOTTOMRIGHT", headlineButtonMover, "BOTTOMRIGHT", 0, 0)
	textureMover:SetTexture(1, 1, 1, 0)
	headlineButtonMover:SetScript("OnEnter", function() FREAK:MoverInfo("MOVE", "TOP") end)
	headlineButtonMover:SetScript("OnLeave", function() FREAK:MoverInfo() end)
	headlineButtonMover:SetScript("OnMouseDown", function() FREAK_MainFrame:StartMoving() end)
	headlineButtonMover:SetScript("OnMouseUp", function() FREAK_MainFrame:StopMovingOrSizing() FREAK:SaveMainFramePos() end)
	-- Headline Frame END

	-- Action Frame START
	local action = CreateFrame("Frame", "FREAK_ActionFrame", mainframe)
	TemplateBorderTRBL(action)
	action:SetWidth(width_mainframe)
	action:SetHeight(32)
	action:SetPoint("TOPLEFT", FREAK_HeadlineFrame, "BOTTOMLEFT", 0, 1)
	action:EnableMouse(true)

	local scangroup = CreateFrame("Button", "FREAK_ActionFrame_ScanGroup", action)
	TemplateTextButton(scangroup, L["Check Group"], 1)
	scangroup:SetWidth(150)
	scangroup:SetHeight(22)
	scangroup:SetPoint("LEFT", action, "LEFT", 4, 0)
	scangroup:SetScript("OnClick", function() FREAK:ScanGroup() end)

	local scansingle = CreateFrame("Button", "FREAK_ActionFrame_ScanSingle", action)
	TemplateTextButton(scansingle, L["Check Target"], 1)
	scansingle:SetWidth(150)
	scansingle:SetHeight(22)
	scansingle:SetPoint("LEFT", "FREAK_ActionFrame_ScanGroup", "RIGHT", 10, 0)
	scansingle:SetScript("OnClick", function() FREAK:ScanUnit("target") end)

	local deleteall = CreateFrame("Button", "FREAK_ActionFrame_DeleteAll", action)
	TemplateTextButton(deleteall, L["Delete All"], 1)
	deleteall:SetWidth(150)
	deleteall:SetHeight(22)
	deleteall:SetPoint("RIGHT", action, "RIGHT", -4, 0)
	deleteall:SetScript("OnClick", function() FREAK:DeleteAll() end)
	-- Action Frame END

	-- Selection Frame START
	local selection = CreateFrame("Frame", "FREAK_SelectionFrame", mainframe)
	TemplateBorderTRBL(selection)
	selection:SetWidth(width_mainframe)
	selection:SetHeight(4+(#DATA*20)+((#DATA-1)*4)+4)
	selection:SetPoint("TOPLEFT", FREAK_ActionFrame, "BOTTOMLEFT", 0, 1)
	selection:EnableMouse(true)

	for i = 1, #DATA do
		local button = CreateFrame("CheckButton", "FREAK_SelectionFrame_Button"..i, selection)
		TemplateCheckButton(button, 20, 4, AchievementIDTable[DATA[i].achievementID].." - ID "..DATA[i].achievementID)
		if i == 1 then
			button:SetPoint("TOPLEFT", selection, "TOPLEFT", 4, -4)
		else
			button:SetPoint("BOTTOMLEFT", selection, "TOPLEFT", 4, -(i*24)) -- -((i*4)+(i+14))
		end
		if FREAK_Options.Data_Achievement == DATA[i].achievementID then
			button:SetChecked(true)
		else
			button:SetChecked(false)
		end
		button:SetScript("OnClick", function(self)
			FREAK_Options.Data_Achievement = DATA[i].achievementID
			for i = 1, #DATA do
				_G["FREAK_SelectionFrame_Button"..i]:SetChecked(false)
			end
			self:SetChecked(true)
			FREAK:UpdateData()
		end)
	end

	local button = CreateFrame("CheckButton", "FREAK_SelectionFrame_Button_Tooltip4080", selection)
	TemplateCheckButton(button, 20, 4, L["Tooltip"].." - ID 4080")
	button:SetPoint("TOPLEFT", selection, "TOPLEFT", 320, -4)
	button:SetChecked(FREAK_Options.Tooltip4080)
	button:SetScript("OnClick", function(self)
		FREAK_Options.Tooltip4080 = not FREAK_Options.Tooltip4080
		self:SetChecked(FREAK_Options.Tooltip4080)
	end)
	local button = CreateFrame("CheckButton", "FREAK_SelectionFrame_Button_Tooltip3316", selection)
	TemplateCheckButton(button, 20, 4, L["Tooltip"].." - ID 3316")
	button:SetPoint("BOTTOMLEFT", selection, "TOPLEFT", 320, -(2*24))
	button:SetChecked(FREAK_Options.Tooltip3316)
	button:SetScript("OnClick", function(self)
		FREAK_Options.Tooltip3316 = not FREAK_Options.Tooltip3316
		self:SetChecked(FREAK_Options.Tooltip3316)
	end)

	local prButton = CreateFrame("Button", "FREAK_SelectionFrame_PleaseRead", selection)
	prButton:SetWidth(24)
	prButton:SetHeight(24)
	prButton:SetPoint("RIGHT", selection, "RIGHT", -4, 0)

	local prTexture = prButton:CreateTexture(nil, "ARTWORK")
	prTexture:SetWidth(24)
	prTexture:SetHeight(24)
	prTexture:SetPoint("RIGHT", prButton, "RIGHT", 0, 0)
	prTexture:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")

	local prText = prButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	prText:SetPoint("RIGHT", prTexture, "LEFT", -4, 0)
	prText:SetText(L["PLEASE READ"]..":")

	prButton:SetScript("OnEnter", function() FREAK_DataFrame:Hide() FREAK_WarningFrame:Show() end)
	prButton:SetScript("OnLeave", function() FREAK_DataFrame:Show() FREAK_WarningFrame:Hide() end)
	-- Selection Frame END

	-- Data Frame START
	local data = CreateFrame("Frame", "FREAK_DataFrame", mainframe)
	TemplateBorderTRBL(data)
	data:SetWidth(width_mainframe)
	data:SetHeight(3 + 24 + 2 + (10*24) + (9*2) + 3)
	data:SetPoint("TOPLEFT", FREAK_SelectionFrame, "BOTTOMLEFT", 0, 1)
	data:EnableMouse(true)
	data:EnableMouseWheel(true)
	data:SetScript("OnMouseWheel", NOOP)

	for i = 1, #GearSlots do
		local iconbutton = CreateFrame("Button", "FREAK_DataFrame_"..GearSlots[i].id, data)
		iconbutton.slotname = _G[string.upper(GearSlots[i].name)]
		iconbutton:SetWidth(24)
		iconbutton:SetHeight(24)
		if i == 1 then
			iconbutton:SetPoint("TOPLEFT", "FREAK_DataFrame", "TOPLEFT", 3+2+20+2+150+2+40, -3)
		else
			iconbutton:SetPoint("LEFT", "FREAK_DataFrame_"..GearSlots[i-1].id, "RIGHT", 2, 0)
		end

		local border = iconbutton:CreateTexture(nil, "BACKGROUND")
		border:SetWidth(24)
		border:SetHeight(24)
		border:SetAllPoints(iconbutton)
		border:SetTexture(0.2, 0.2, 0.2, 1)

		local background = iconbutton:CreateTexture(nil, "BORDER")
		background:SetWidth(22)
		background:SetHeight(22)
		background:SetPoint("TOPLEFT", 1, -1)
		background:SetTexture(0, 0, 0, 1)

		local icon = iconbutton:CreateTexture("FREAK_DataFrame_Icon_"..GearSlots[i].id, "ARTWORK")
		icon:SetWidth(20)
		icon:SetHeight(20)
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetTexture(GearSlots[i].texture)
		icon:SetTexCoord(5/64, 59/64, 5/64, 59/64)

		iconbutton:SetScript("OnEnter", function(self)
			border:SetTexture(1, 1, 0.49, 1)
			GameTooltip:SetOwner(iconbutton, "ANCHOR_TOPLEFT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(self.slotname)
			GameTooltip:Show()
		end)
		iconbutton:SetScript("OnLeave", function()
			border:SetTexture(0.2, 0.2, 0.2, 1)
			GameTooltip:Hide()
		end)
	end

	local dataScrollFrame = CreateFrame("ScrollFrame", "FREAK_DataFrame_ScrollFrame", data)
	TemplateScrollFrame(dataScrollFrame)
	dataScrollFrame:SetPoint("TOPLEFT", data, "TOPLEFT", 3, -29) -- 3, -(24+2+3)
	dataScrollFrame:SetPoint("BOTTOMRIGHT", data, "BOTTOMRIGHT", -21, 3) -- -(16+3+2), 3
	dataScrollFrame:SetScript("OnVerticalScroll", function() FREAK:OnVerticalScroll() end)

	for i = 1, GUI_Data_maxNum do
		local button = CreateFrame("Button", "FREAK_DataFrame_Button"..i, data)
		button:Hide()
		button:SetWidth(width_mainframe - 3 - 3)
		button:SetHeight(24)
		if i == 1 then
			button:SetPoint("TOPLEFT", "FREAK_DataFrame", "TOPLEFT", 3, -29) -- 3, -(24+2+3)
		else
			button:SetPoint("TOPLEFT", "FREAK_DataFrame_Button"..(i-1), "BOTTOMLEFT", 0, -2)
		end

		local result = button:CreateTexture("FREAK_DataFrame_Button"..i.."Result", "ARTWORK")
		result:SetWidth(20)
		result:SetHeight(20)
		result:SetPoint("LEFT", button, "LEFT", 0, 0)

		local name = button:CreateFontString("FREAK_DataFrame_Button"..i.."Name", "ARTWORK", "GameFontNormalSmall")
		name:SetWidth(150)
		name:SetHeight(12)
		name:SetPoint("LEFT", button, "LEFT", 20+2, 0)
		name:SetJustifyH("LEFT")

		local ilvlavg = button:CreateFontString("FREAK_DataFrame_Button"..i.."iLvlAvg", "ARTWORK", "GameFontNormalSmall")
		ilvlavg:SetWidth(40)
		ilvlavg:SetHeight(12)
		ilvlavg:SetPoint("LEFT", button, "LEFT", 20+2+150+2, 0)
		ilvlavg:SetJustifyH("RIGHT")

		local noInpectRangeTex = button:CreateTexture("FREAK_DataFrame_Button"..i.."noInpectRangeTex", "BACKGROUND")
		noInpectRangeTex:SetWidth( (#GearSlots*24) + ((#GearSlots-1)*2) )
		noInpectRangeTex:SetHeight(24)
		noInpectRangeTex:SetPoint("LEFT", button, "LEFT", 20+2+150+2+40+2, 0)
		noInpectRangeTex:SetTexture(0.6, 0.6, 0.6, 0.1)
		noInpectRangeTex:Hide()

		local noInpectRange = button:CreateFontString("FREAK_DataFrame_Button"..i.."noInpectRange", "OVERLAY", "GameFontNormalSmall")
		noInpectRange:SetPoint("CENTER", noInpectRangeTex, "CENTER", 0, 0)
		noInpectRange:SetJustifyH("CENTER")
		noInpectRange:SetText(L["Not in inspect range!"])
		noInpectRange:Hide()

		for j = 1, #GearSlots do
			local itembutton = CreateFrame("Button", "FREAK_DataFrame_Button"..i.."Item"..GearSlots[j].id, button)
			itembutton:SetWidth(24)
			itembutton:SetHeight(24)
			if j == 1 then
				itembutton:SetPoint("LEFT", button, "LEFT", 20+2+150+2+40+2, 0)
			else
				itembutton:SetPoint("LEFT", "FREAK_DataFrame_Button"..i.."Item"..GearSlots[(j-1)].id, "RIGHT", 2, 0)
			end

			local border = itembutton:CreateTexture(nil, "BACKGROUND")
			border:SetWidth(24)
			border:SetHeight(24)
			border:SetAllPoints(itembutton)
			border:SetTexture(0.2, 0.2, 0.2, 1)

			local background = itembutton:CreateTexture(nil, "BORDER")
			background:SetWidth(22)
			background:SetHeight(22)
			background:SetPoint("TOPLEFT", 1, -1)
			background:SetTexture(0, 0, 0, 1)

			local itemtexture = itembutton:CreateTexture("FREAK_DataFrame_Button"..i.."Item"..GearSlots[j].id.."Texture", "ARTWORK")
			itemtexture:SetWidth(20)
			itemtexture:SetHeight(20)
			itemtexture:SetPoint("TOPLEFT", 2, -2)
			itemtexture:SetTexCoord(5/64, 59/64, 5/64, 59/64)

			local itemleveltexture = itembutton:CreateTexture(nil, "OVERLAY")
			itemleveltexture:SetWidth(22)
			itemleveltexture:SetHeight(10)
			itemleveltexture:SetPoint("BOTTOM", itembutton, "BOTTOM", 0, 1)
			itemleveltexture:SetTexture(0, 0, 0, 0.8)

			local itemlevel = itembutton:CreateFontString("FREAK_DataFrame_Button"..i.."Item"..GearSlots[j].id.."Level", "OVERLAY", "GameFontNormalSmall")
			--itemlevel:SetWidth(24)
			--itemlevel:SetHeight(12)
			itemlevel:SetPoint("CENTER", itemleveltexture, "CENTER", 0, 0)
			itemlevel:SetJustifyH("CENTER")
			
			itembutton:SetScript("OnEnter", function(self)
				if self.iID then
					border:SetTexture(1, 1, 0.49, 1)
					GameTooltip:SetOwner(itembutton, "ANCHOR_BOTTOMRIGHT", 0, 0)
					GameTooltip:ClearLines()
					GameTooltip:SetHyperlink("item:"..self.iID..":0:0:0:0:0:0:0")
					GameTooltip:Show()
					self.UpdateTooltip = GearTooltipHandler
				end
			end)
			itembutton:SetScript("OnLeave", function()
				border:SetTexture(0.2, 0.2, 0.2, 1)
				GameTooltip:Hide()
				ResetCursor()
				self.comparing = false
			end)
			itembutton:SetScript("OnClick", function()
				local _, itemLink = GameTooltip:GetItem()
				if itemLink then
					HandleModifiedItemClick(itemLink)
				end
			end)
		end

		local deleteunitButton = CreateFrame("Button", "FREAK_DataFrame_Button"..i.."Delete", button)
		deleteunitButton:SetWidth(16)
		deleteunitButton:SetHeight(16)
		deleteunitButton:SetPoint("LEFT", button, "LEFT", 20+2+150+2+40+2 + (#GearSlots*24) + ((#GearSlots-1)*2) + 2  +  2, 0)

		local border = deleteunitButton:CreateTexture(nil, "BACKGROUND")
		border:SetWidth(16)
		border:SetHeight(16)
		border:SetAllPoints(deleteunitButton)
		border:SetTexture(0.82, 0, 0, 0.6)

		local background = deleteunitButton:CreateTexture(nil, "BORDER")
		background:SetWidth(14)
		background:SetHeight(14)
		background:SetPoint("TOPLEFT", 1, -1)
		background:SetTexture(0, 0, 0, 1)

		local textureNormal = deleteunitButton:CreateTexture(nil, "ARTWORK")
		textureNormal:SetPoint("TOPLEFT", 2, -2)
		textureNormal:SetPoint("BOTTOMRIGHT", -2, 2)
		textureNormal:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		textureNormal:SetTexCoord(8/32, 22/32, 10/32, 22/32)
		textureNormal:SetAlpha(0.5)
		deleteunitButton:SetNormalTexture(textureNormal)
		local texturePush = deleteunitButton:CreateTexture(nil, "ARTWORK")
		texturePush:SetPoint("TOPLEFT", 3, -3)
		texturePush:SetPoint("BOTTOMRIGHT", -3, 3)
		texturePush:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		texturePush:SetTexCoord(8/32, 22/32, 10/32, 22/32)
		deleteunitButton:SetPushedTexture(texturePush)

		deleteunitButton:SetScript("OnClick", function() FREAK:DeleteUnit(button.guid) end)
		deleteunitButton:SetScript("OnEnter", function()
			border:SetTexture(0.82, 0, 0, 1)
			textureNormal:SetAlpha(1)
			GameTooltip:SetOwner(deleteunitButton, "ANCHOR_TOPLEFT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L["Delete"])
			GameTooltip:Show()
		end)
		deleteunitButton:SetScript("OnLeave", function()
			border:SetTexture(0.82, 0, 0, 0.6)
			textureNormal:SetAlpha(0.5)
			GameTooltip:Hide()
		end)

	end
	-- Data Frame END

	-- Summary Frame START
	local summary = CreateFrame("Frame", "FREAK_SummaryFrame", mainframe)
	TemplateBorderTRBL(summary)
	summary:SetWidth(width_mainframe)
	summary:SetHeight(3 + 24 + 3)
	summary:SetPoint("TOPLEFT", FREAK_DataFrame, "BOTTOMLEFT", 0, 1)
	summary:EnableMouse(true)

	local result = summary:CreateTexture("FREAK_SummaryFrameResult", "ARTWORK")
	result:SetWidth(20)
	result:SetHeight(20)
	result:SetPoint("LEFT", summary, "LEFT", 3, 0)

	local ilvlavg = summary:CreateFontString("FREAK_SummaryFrameiLvlAvg", "ARTWORK", "GameFontNormalSmall")
	ilvlavg:SetWidth(40)
	ilvlavg:SetHeight(12)
	ilvlavg:SetPoint("LEFT", summary, "LEFT", 3+20+2+150+2, 0)
	ilvlavg:SetJustifyH("RIGHT")

	for j = 1, #GearSlots do
		local itembutton = CreateFrame("Button", "FREAK_SummaryFrame"..GearSlots[j].id, summary)
		itembutton:SetWidth(24)
		itembutton:SetHeight(24)
		if j == 1 then
			itembutton:SetPoint("LEFT", summary, "LEFT", 3+20+2+150+2+40+2, 0)
		else
			itembutton:SetPoint("LEFT", "FREAK_SummaryFrame"..GearSlots[(j-1)].id, "RIGHT", 2, 0)
		end

		local border = itembutton:CreateTexture(nil, "BACKGROUND")
		border:SetWidth(24)
		border:SetHeight(24)
		border:SetAllPoints(itembutton)
		border:SetTexture(0.2, 0.2, 0.2, 1)

		local background = itembutton:CreateTexture(nil, "BORDER")
		background:SetWidth(22)
		background:SetHeight(22)
		background:SetPoint("TOPLEFT", 1, -1)
		background:SetTexture(0, 0, 0, 1)

		local itemtexture = itembutton:CreateTexture("FREAK_SummaryFrame"..GearSlots[j].id.."Texture", "ARTWORK")
		itemtexture:SetWidth(20)
		itemtexture:SetHeight(20)
		itemtexture:SetPoint("TOPLEFT", 2, -2)
		itemtexture:SetTexture(GearSlots[j].texture)
		itemtexture:SetTexCoord(5/64, 59/64, 5/64, 59/64)
	end
	-- Data Summary Frame END

	-- Warning Frame START
	local warning = CreateFrame("Frame", "FREAK_WarningFrame", mainframe)
	TemplateBorderTRBL(warning)
	warning:SetWidth(width_mainframe)
	warning:SetHeight(50)
	warning:SetPoint("TOPLEFT", data, "TOPLEFT", 0, 0)
	warning:SetPoint("BOTTOMLEFT", data, "BOTTOMLEFT", 0, 0)
	warning:EnableMouse(true)
	warning:Hide()

	local warn1 = warning:CreateFontString("FREAK_WarningFrame_Text1", "ARTWORK", "GameFontNormal")
	warn1:SetWidth(width_mainframe-100)
	warn1:SetPoint("TOP", warning, "TOP", 0, -40)
	warn1:SetJustifyH("CENTER")
	warn1:SetText(L["The itemLinks (Tooltip/ChatLink) does not contain additional data (gems, enchantments, etc.)."])
	warn1:SetTextColor(0.7, 0.7, 0.7, 1)

	local warn2 = warning:CreateFontString("FREAK_WarningFrame_Text2", "ARTWORK", "GameFontRedLarge")
	warn2:SetWidth(width_mainframe-100)
	warn2:SetPoint("TOP", warn1, "BOTTOM", 0, -20)
	warn2:SetJustifyH("CENTER")
	warn2:SetText(L["THERE IS NO WARRANTY THAT THIS ADDON GIVES A VALID GEAR CHECK FOR THE ABOVE-MENTIONED ACHIEVEMENTS!"])
	warn2:SetTextColor(1, 0, 0, 1)

	local warn3 = warning:CreateFontString("FREAK_WarningFrame_Text3", "ARTWORK", "GameFontNormal")
	warn3:SetWidth(width_mainframe-100)
	warn3:SetPoint("TOP", warn2, "BOTTOM", 0, -20)
	warn3:SetJustifyH("CENTER")
	warn3:SetText(L["Please use the wowace.com forum if you find an error. Thanks."])
	warn3:SetTextColor(1, 1, 1, 1)
	-- Warning Frame END

	-- Status Frame START
	local status = CreateFrame("Frame", "FREAK_StatusFrame", mainframe)
	TemplateBorderTRBL(status)
	status:SetWidth(width_mainframe)
	status:SetHeight(20)
	status:SetPoint("TOPLEFT", FREAK_SummaryFrame, "BOTTOMLEFT", 0, 1)
	status:EnableMouse(true)
	status:SetScript("OnEnter", function() FREAK:MoverInfo("MOVE", "BOTTOM") end)
	status:SetScript("OnLeave", function() FREAK:MoverInfo() end)
	status:SetScript("OnMouseDown", function() FREAK_MainFrame:StartMoving() end)
	status:SetScript("OnMouseUp", function() FREAK_MainFrame:StopMovingOrSizing() FREAK:SaveMainFramePos() end)

	local title = status:CreateFontString("FREAK_StatusFrameText", "ARTWORK", "GameFontWhiteSmall")
	title:SetHeight(20)
	title:SetPoint("CENTER", status)
	title:SetJustifyH("CENTER")
	-- Status Frame END

	-- MoverInfoBottom Frame START
	local moverinfo = CreateFrame("Frame", "FREAK_MoverInfoBottomFrame", mainframe)
	moverinfo:SetWidth(150)
	moverinfo:SetHeight(14)
	moverinfo:SetPoint("TOP", FREAK_StatusFrame, "BOTTOM", 0, 0)
	moverinfo:EnableMouse(true)
	moverinfo:Hide()
	local texture = moverinfo:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(moverinfo)
	texture:SetTexture(0, 0, 0, 0.5)
	local text = moverinfo:CreateFontString("FREAK_MoverInfoBottomFrame_Text", "ARTWORK", "GameFontWhiteSmall")
	text:SetPoint("CENTER", moverinfo, "CENTER", 0, 0)
	text:SetJustifyH("CENTER")
	text:SetTextColor(0.4, 0.4, 0.4, 1)
	-- MoverInfoBottom Frame END

	-- Protection Frame START
	local ProtectionFrame = CreateFrame("Frame", "FREAK_ProtectionFrame", mainframe)
	ProtectionFrame:SetToplevel(true)
	ProtectionFrame:SetWidth(width_mainframe-2)
	ProtectionFrame:SetHeight(50)
	ProtectionFrame:SetPoint("TOPLEFT", action, "TOPLEFT", 1, -1)
	ProtectionFrame:SetPoint("BOTTOMLEFT", data, "BOTTOMLEFT", -1, 1)
	ProtectionFrame:EnableMouse(true)
	ProtectionFrame:Hide()
	local texture = ProtectionFrame:CreateTexture(nil, "BACKGROUND")
	texture:SetPoint("TOPLEFT", 0, 0)
	texture:SetPoint("BOTTOMRIGHT", 0, 0)
	texture:SetTexture(0, 0, 0, 0.85)
	local ProtectionButton = CreateFrame("Button", "FREAK_ProtectionFrame_Button", ProtectionFrame)
	TemplateTextButton(ProtectionButton, L["STOP CHECK"], 1)
	ProtectionButton:SetWidth(150)
	ProtectionButton:SetHeight(22)
	ProtectionButton:SetPoint("TOP", ProtectionFrame, "TOP", 0, -50)
	ProtectionButton:SetScript("OnClick", function() FREAK:StopScan() end)
	local progressText = ProtectionFrame:CreateFontString("FREAK_ProtectionFrame_ProgressText", "ARTWORK", "GameFontNormalSmall")
	progressText:SetPoint("TOP", ProtectionButton, "BOTTOM", 0, -20)
	progressText:SetJustifyH("CENTER")
	progressText:SetWidth(100)
	progressText:SetText("-/-")
	progressText:SetTextColor(1, 1, 1, 1)
	local progressBackground = ProtectionFrame:CreateTexture(nil, "BORDER")
	progressBackground:SetPoint("TOP", progressText, "BOTTOM", 0, -10)
	progressBackground:SetWidth(222)
	progressBackground:SetHeight(12)
	progressBackground:SetTexture(0.2, 0.2, 0.2, 1)
	local progressDone = ProtectionFrame:CreateTexture("FREAK_ProtectionFrame_ProgressDone", "ARTWORK")
	progressDone:SetPoint("LEFT", progressBackground, "LEFT", 0, 0)
	progressDone:SetWidth(1)
	progressDone:SetHeight(12)
	progressDone:SetBlendMode("BLEND")
	progressDone:SetTexture(0, 0.75, 0, 1)
	-- Protection Frame END
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:InitializeFrame()
	FREAK:DeleteAll()
	FREAK:UpdateData()
end

function FREAK:MainFrameToggle()
	if FREAK_MainFrame:IsShown() then
		FREAK_MainFrame:Hide()
	else
		FREAK_MainFrame:Show()
	end
end

function FREAK:MainFramePos()
	if FREAK_Options.MainFrame_relP then
		FREAK_MainFrame:ClearAllPoints()
		FREAK_MainFrame:SetPoint(FREAK_Options.MainFrame_relP, FREAK_Options.MainFrame_posX, FREAK_Options.MainFrame_posY)
	else
		FREAK_MainFrame:ClearAllPoints()
		FREAK_MainFrame:SetPoint("CENTER", 0, 100)
	end
end

function FREAK:MainFrameHide()
	PlaySound("igQuestListClose")
	FREAK_InterfaceOptions_GUI:Enable()
end

function FREAK:MainFrameShow()
	PlaySound("igQuestListOpen")
	FREAK_InterfaceOptions_GUI:Disable()
	FREAK:MainFramePos()
end

function FREAK:SaveMainFramePos()
	local point, relativeTo, relativePoint, x, y = FREAK_MainFrame:GetPoint()
	FREAK_Options.MainFrame_posX = x
	FREAK_Options.MainFrame_posY = y
	FREAK_Options.MainFrame_relP = relativePoint
end

function FREAK:ProtectionFrameToggle(show)
	if show then
		FREAK_ProtectionFrame:Show()
	else
		FREAK_ProtectionFrame:Hide()
	end
end

function FREAK:MoverInfo(action, where)
	if not action then
		FREAK_MoverInfoTopFrame:Hide()
		FREAK_MoverInfoBottomFrame:Hide()
		return
	end

	if action == "MOVE" then
		FREAK_MoverInfoTopFrame_Text:SetText(L["click & move"])
		FREAK_MoverInfoBottomFrame_Text:SetText(L["click & move"])
	else
		FREAK_MoverInfoTopFrame_Text:SetText(L["click & resize"])
		FREAK_MoverInfoBottomFrame_Text:SetText(L["click & resize"])
	end

	if where == "TOP" then
		FREAK_MoverInfoTopFrame:Show()
	else
		FREAK_MoverInfoBottomFrame:Show()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:ScanGroup()
	local partymember = GetNumPartyMembers()
	local raidmember  = GetNumRaidMembers()
	local inParty
	local inRaid
	if partymember > 0 then
		inRaid  = false
		inParty = true
	end
	if raidmember > 0 then
		inRaid  = true
		inParty = false
	end

	FREAK:DeleteAll()

	if not inRaid and not inParty then
		FREAK:ScanUnit("player", true)
		return
	end

	-- temp membertable START
	-- we build our own membertable. so we are independent from PARTY_MEMBERS_CHANGED/RAID_ROSTER_UPDATE changes
	-- raid roster changes between button click and end of groupscan are discarded!
	local t = {}
	local x = 1
	if inParty then
		for i = 1, partymember do
			local unit = "party"..i
			local guid = UnitGUID(unit)
			if guid then
				t[x] = {}
				t[x].guid = guid
				t[x].unit = unit
				x = x + 1
			end
		end
		-- add player to temp db
		t[x] = {}
		t[x].guid = playerGUID
		t[x].unit = "player"
	end
	if inRaid then
		for i = 1, raidmember do
			local unit = "raid"..i
			local guid = UnitGUID(unit)
			if guid then
				t[x] = {}
				t[x].guid = guid
				t[x].unit = unit
				x = x + 1
			end
		end
	end
	local numMember = #t
	-- temp membertable END

	GroupScanIsActive = true
	GroupScanNext = false
	local gsStart = GetTime()
	local currentScanNumber = 1

	local function scanNextMember()
		local guid = UnitGUID(t[currentScanNumber].unit)
		if guid and guid == t[currentScanNumber].guid then
			FREAK_ProtectionFrame_ProgressText:SetText(currentScanNumber.."/"..numMember)
			FREAK_ProtectionFrame_ProgressDone:SetWidth(currentScanNumber*222/numMember)
			FREAK:ScanUnit(t[currentScanNumber].unit)
			currentScanNumber = currentScanNumber + 1
		else
			FREAK_ProtectionFrame_ProgressText:SetText(currentScanNumber.."/"..numMember)
			FREAK_ProtectionFrame_ProgressDone:SetWidth(currentScanNumber*222/numMember)
			currentScanNumber = currentScanNumber + 1
		end
	end

	local function gsTimeCheck()
		if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then 
			FREAK:StopScan()
			return
		end
		if (GetTime() - gsStart) >= 1 or GroupScanNext then
			if currentScanNumber > numMember then
				FREAK:StopScan()
				return
			end
			-- next scan
			gsStart = GetTime()
			GroupScanNext = false
			scanNextMember()
		end
	end

	FREAK_ActionFrame_ScanGroup:SetScript("OnUpdate", gsTimeCheck)
	scanNextMember()
end

function FREAK:ScanUnit(unit, forceSingle)
	if not UnitExists(unit) or not UnitIsPlayer(unit) then
		GroupScanNext = true
		return
	end

	local inspectReady = true
	if not CanInspect(unit) then
		inspectReady = false
	end

	FREAK:ProtectionFrameToggle(true)

	if unit == "target" then
		if not inspectReady then
			FREAK:StopScan()
			return
		end
		SingleScanIsActive = true
	end

	SCANGUID = UnitGUID(unit)
	if not SCANGUID then Print("GUID ERROR!", SCANGUID) return end -- This is bad.
	CreateScanDataByGUID(SCANGUID)

	local name, realm = UnitName(unit)
	if realm and realm ~= "" then
		name = name.."-"..realm
	end
	SCAN[SCANGUID].name = name

	local _, classEN = UnitClass(unit)
	SCAN[SCANGUID].classEN = classEN

	local IsUnitInpected = true -- "Inspect"
	if UnitIsUnit("player", unit) then
		IsUnitInpected = false -- "Character" -> it's me
		unit = "player"
	end

	if inspectReady then
		SCAN[SCANGUID].canInspect = true
	end

	if inspectReady then
		NotifyInspect(unit)
		if IsUnitInpected then
			FREAK:ItemLevelCalc(unit, "Inspect")
		else
			FREAK:ItemLevelCalc(unit, "Character")
		end
	end

	if GroupScanIsActive then
		GroupScanNext = true
	end

	if SingleScanIsActive or forceSingle then
		FREAK:StopScan()
	end
end

function FREAK:StopScan()
	FREAK_ActionFrame_ScanGroup:SetScript("OnUpdate", nil)

	GroupScanNext = false
	GroupScanIsActive = false
	SingleScanIsActive = false

	FREAK:UpdateData()
	FREAK:ProtectionFrameToggle(false)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:DeleteAll()
	table.wipe(SCAN)
	table.wipe(GUI_Data)
	GUI_Data_Count = 0
	for i=1, GUI_Data_maxNum do
		_G["FREAK_DataFrame_Button"..i]:Hide()
	end
	FREAK:UpdateData()
end

function FREAK:DeleteUnit(guid)
	SCAN[guid] = nil
	FREAK:UpdateData()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function FREAK:UpdateData()
	FREAK:CreateGUIdata()
	FREAK:FillList()
	FREAK:UpdateStatus()
end

function FREAK:UpdateStatus()
	local sum_ItemLevel = 0
	local sum_Validation = true
	local sum_ValidInpsections = 0
	for i = 1, GUI_Data_Count do
		if GUI_Data[i].itemlevelAvg then
			sum_ItemLevel = sum_ItemLevel + tonumber(GUI_Data[i].itemlevelAvg)
			sum_ValidInpsections = sum_ValidInpsections + 1
		end
		if not GUI_Data[i].result then
			sum_Validation = false
		end
	end

	-- ohhh a -1.#IND indefinite wannabe number
	if sum_ValidInpsections == 0 then
		sum_ItemLevel = cnum(0)
	else
		sum_ItemLevel = cnum(math_floor((sum_ItemLevel/sum_ValidInpsections) * mult2 + 0.5) / mult2)
	end

	if sum_Validation then
		FREAK_SummaryFrameResult:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
	else
		FREAK_SummaryFrameResult:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
	end
	FREAK_SummaryFrameiLvlAvg:SetText(sum_ItemLevel)
	FREAK_StatusFrameText:SetText(L["Checked Players"]..": "..GUI_Data_Count)
end

function FREAK:CreateGUIdata()
	table.wipe(GUI_Data)

	if FREAK_Options.Data_Achievement == 4080 then -- A Tribute to Dedicated Insanity

		local x = 1
		for k, v in pairs(SCAN) do
			GUI_Data[x] = {}
			GUI_Data[x].guid = k
			GUI_Data[x].name = SCAN[k].name
			GUI_Data[x].classEN = SCAN[k].classEN

			if SCAN[k].canInspect == true then
				GUI_Data[x].itemlevelAvg = SCAN[k].itemlevelAvg
				GUI_Data[x].gear = {}
				local cr = true
				for k3,v3 in pairs(SCAN[k].gear) do
					GUI_Data[x].gear[k3] = {}
					GUI_Data[x].gear[k3].iLvl = v3.iLvl
					GUI_Data[x].gear[k3].iTex = v3.iTex
					GUI_Data[x].gear[k3].iID  = v3.iID
					local valid = FREAK:ValidateItem(4080, v3.iID, v3.iLvl, nil, nil)
					GUI_Data[x].gear[k3].iValidation = valid
					if not valid then
						cr = valid
					end
				end
				GUI_Data[x].result = cr
			else
				GUI_Data[x].itemlevelAvg = nil
				GUI_Data[x].result = false
			end

			x = x + 1
		end
		GUI_Data_Count = #GUI_Data

	elseif FREAK_Options.Data_Achievement == 3316 then -- Herald of the Titans

		local x = 1
		for k, v in pairs(SCAN) do
			GUI_Data[x] = {}
			GUI_Data[x].guid = k
			GUI_Data[x].name = SCAN[k].name
			GUI_Data[x].classEN = SCAN[k].classEN

			if SCAN[k].canInspect == true then
				GUI_Data[x].itemlevelAvg = SCAN[k].itemlevelAvg
				GUI_Data[x].gear = {}
				local cr = true
				for k3,v3 in pairs(SCAN[k].gear) do
					GUI_Data[x].gear[k3] = {}
					GUI_Data[x].gear[k3].iLvl = v3.iLvl
					GUI_Data[x].gear[k3].iTex = v3.iTex
					GUI_Data[x].gear[k3].iID  = v3.iID
					local valid = FREAK:ValidateItem(3316, v3.iID, v3.iLvl, nil, k3)
					GUI_Data[x].gear[k3].iValidation = valid
					if not valid then
						cr = valid
					end
				end
				GUI_Data[x].result = cr
			else
				GUI_Data[x].itemlevelAvg = nil
				GUI_Data[x].result = false
			end

			x = x + 1
		end
		GUI_Data_Count = #GUI_Data

	end

	table.sort(GUI_Data, function(a, b)
		if a.name < b.name then
			return true
		end
	end)
end

function FREAK:OnVerticalScroll()
	FREAK_DataFrame_ScrollFrameScrollBar:SetValue(arg1)
	FREAK_DataFrame_ScrollFrame.offset = math_floor((arg1 / 24) + 0.5)
	FREAK:FillList()
end

function FREAK:FillList()
	local frameName = "FREAK_DataFrame_ScrollFrame"
	local frame = _G[frameName]
	local scrollBar = _G[frameName.."ScrollBar"]
	local scrollUpButton = _G[frameName.."ScrollBarScrollUpButton"]
	local scrollDownButton = _G[frameName.."ScrollBarScrollDownButton"]
	local scrollFrameHeight = 0
	local numToDisplay = GUI_Data_curNum
	local valueStep = 24

	if GUI_Data_Count < numToDisplay then
		numToDisplay = GUI_Data_Count
	end

	if GUI_Data_Count > 0 then
		scrollFrameHeight = (GUI_Data_Count - numToDisplay) * valueStep
		if scrollFrameHeight < 0 then
			scrollFrameHeight = 0
		end
	end
	scrollBar:SetMinMaxValues(0, scrollFrameHeight)
	scrollBar:SetValueStep(valueStep)

	if scrollBar:GetValue() == 0 then
		scrollUpButton:Disable()
	else
		scrollUpButton:Enable()
	end
	if ((scrollBar:GetValue() - scrollFrameHeight) == 0) then
		scrollDownButton:Disable()
	else
		scrollDownButton:Enable()
	end

	if GUI_Data_Count <= GUI_Data_curNum then
		frame:SetAlpha(0.2)
		scrollUpButton:Disable()
		scrollDownButton:Disable()
	else
		frame:SetAlpha(1)
	end

	for i=1, GUI_Data_maxNum do
		_G["FREAK_DataFrame_Button"..i]:Hide()
	end

	local j = 1
	local sliderPos = FREAK_DataFrame_ScrollFrame.offset
	for i=sliderPos+1, sliderPos+numToDisplay do
		if sliderPos < GUI_Data_Count then
			if GUI_Data[i].result then
				_G["FREAK_DataFrame_Button"..j.."Result"]:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			else
				_G["FREAK_DataFrame_Button"..j.."Result"]:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
			end

			_G["FREAK_DataFrame_Button"..j.."Name"]:SetText(GUI_Data[i].name)
			_G["FREAK_DataFrame_Button"..j.."Name"]:SetTextColor(classcolors[GUI_Data[i].classEN].r, classcolors[GUI_Data[i].classEN].g, classcolors[GUI_Data[i].classEN].b, 1)

			if GUI_Data[i].itemlevelAvg then

				_G["FREAK_DataFrame_Button"..j.."noInpectRangeTex"]:Hide()
				_G["FREAK_DataFrame_Button"..j.."noInpectRange"]:Hide()

				_G["FREAK_DataFrame_Button"..j.."iLvlAvg"]:SetText(GUI_Data[i].itemlevelAvg)
				for k = 1, #GearSlots do
					if GUI_Data[i].gear[GearSlots[k].id].iLvl > 0 then
						_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id]:Show()
						_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id.."Texture"]:SetTexture(GUI_Data[i].gear[GearSlots[k].id].iTex)
						_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id.."Level"]:SetText(GUI_Data[i].gear[GearSlots[k].id].iLvl)
						if GUI_Data[i].gear[GearSlots[k].id].iValidation then
							_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id.."Level"]:SetTextColor(0, 0.75, 0, 1)
						else
							_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id.."Level"]:SetTextColor(1, 0, 0, 1)
						end
					else
						_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id]:Hide()
					end
					_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id].iID = GUI_Data[i].gear[GearSlots[k].id].iID
				end

			else

				_G["FREAK_DataFrame_Button"..j.."noInpectRangeTex"]:Show()
				_G["FREAK_DataFrame_Button"..j.."noInpectRange"]:Show()

				_G["FREAK_DataFrame_Button"..j.."iLvlAvg"]:SetText("-")
				for k = 1, #GearSlots do
					_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id]:Hide()
					_G["FREAK_DataFrame_Button"..j.."Item"..GearSlots[k].id].iID = nil
				end

			end
			_G["FREAK_DataFrame_Button"..j].guid = GUI_Data[i].guid
			_G["FREAK_DataFrame_Button"..j]:Show()
			j = j + 1
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function ItemData(unit, index)
	local itemLink = GetInventoryItemLink(unit, index)
	if not SCAN[SCANGUID].gear[index] then SCAN[SCANGUID].gear[index] = {} end

	if itemLink then
		local _, _, linkID = itemLink:find("item:(%d+):(%d+)")
		local _, _, itemRarity, itemLevel, _, _, _, _, _, itemTexture = GetItemInfo(linkID)
		SCAN[SCANGUID].gear[index].iID   = tonumber(linkID) or 0
		SCAN[SCANGUID].gear[index].iLvl  = itemLevel or 0
		SCAN[SCANGUID].gear[index].iTex  = itemTexture or ""
		return itemLevel or 0
	else
		SCAN[SCANGUID].gear[index].iID   = -1
		SCAN[SCANGUID].gear[index].iLvl  = -1
		SCAN[SCANGUID].gear[index].iTex  = ""
		return -1
	end
end

local function TwoHandWeaponCheck(unit, who)
	local id = GetInventoryItemLink(unit, _G[who.."MainHandSlot"]:GetID())
	local twohandweapon = false
	if id then
		local linkID = select(3, id:find("item:(%d+)"))
		local itemEquipLoc = select(9, GetItemInfo(linkID))
		if itemEquipLoc == "INVTYPE_2HWEAPON" then
			local id2 = GetInventoryItemLink(unit, _G[who.."SecondaryHandSlot"]:GetID())
			if not id2 then
				twohandweapon = true
			end
		end
	end
	return twohandweapon
end

function FREAK:ItemLevelCalc(unit, who)
	local SlotCount = 17
	if TwoHandWeaponCheck(unit, who) then
		SlotCount = 16
	end
	local ItemLevel = 0
	local ItemCount = 0

	for i = 1, #GearSlots do
		local i1 = ItemData(unit, GearSlots[i].id)
		if i1 >= 0 then
			ItemLevel = ItemLevel + i1
			ItemCount = ItemCount + 1
		end
	end

	local ItemIQ = math_floor((ItemLevel/SlotCount) * mult2 + 0.5) / mult2
	if type(ItemIQ) == "number" and ItemIQ > 0 then
		SCAN[SCANGUID].itemlevelAvg = cnum(ItemIQ)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function OnEvent(self, event)
	if event == "PLAYER_LOGIN" then
		LoadAddOn("Blizzard_InspectUI") -- we need this
		playerGUID = UnitGUID("player")
		BuildIDTable()
		FREAK:InitializeOptions()
		FREAK:CreateInterfaceOptions()
		FREAK:LDBcheck()
		FREAK:CreateMainFrame()
		FREAK:InitializeFrame()
		InstallHooks(_G.GameTooltip, Hooks)
		InstallHooks(_G.ItemRefTooltip, Hooks)
		table.insert(UISpecialFrames, "FREAK_MainFrame")
		FREAK:UnregisterEvent("PLAYER_LOGIN")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

FREAK:RegisterEvent("PLAYER_LOGIN")
FREAK:SetScript("OnEvent", OnEvent)