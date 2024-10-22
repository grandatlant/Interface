-----------------------------------------
--                RageBar                  --
--     An additional rage bar     --
----------------------------------------

RB = LibStub("AceAddon-3.0"):NewAddon("RageBar", "AceEvent-3.0", "AceConsole-3.0")
local media = LibStub("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RageBar")
local textures = media:List("statusbar")
local fonts = media:List("font")
local RageCap
local AceConfig
local RBBar
local RBHealth
local HealthText
local HLossText
local RageText
local LossText
local RBFrame
local Temp

-- default options
local defaults = {
	global = {
		width = 250,
	 	height = 20,
		barori = "HORIZONTAL",
	 	fontsize = 20,
		ragealign = "LEFT",
		lossalign = "RIGHT",
		healthalign = "LEFT",
		hlossalign = "RIGHT",
	 	lock = false,
	 	x = 0, -- rage frame horizontal position
	 	y = 0, -- rage frame vertical position
		hx = 0, -- health frame horizontal position
		hy = 20, -- health frame vertical position
		rtx = 0, -- rage text horizontal position
		rty = 0, -- rage text vertical position
		ltx = 0, -- loss text horizontal position
		lty = 0, -- loss text vertical position
		htx = 0, -- health text horizontal position
		hty = 0, -- health text vertival position
		lhtx = 0, -- loss health text horizontal position
		lhty = 0, -- loss health text vertival position
		hideooc = false,
		hideoor = false,
		hidehealth = false,
		barmax = false,
		vertical = false,
		colorbg = {
			["r"] = 0,
			["g"] = 0,
			["b"] = 0,
			["a"] = 1,
		},
		font = 1,
		tex = 1,
		talentmaxrank = 3,
		talentrank = 0,
		talenticon = "Interface\\Icons\\Spell_Nature_EnchantArmor",
		talentname = "Tactical Mastery",
	},
}

function RB:OnInitialize()
	local _, Class = UnitClass("player");
	if Class ~= "WARRIOR" then RB:Print(L["has not been loaded, you are no warrior!"]) return end
	RB.db = LibStub('AceDB-3.0'):New('RageBardb')
	RB.db:RegisterDefaults(defaults)
	RB:Options()
	RageCap = (RB.db.global.talentrank*5)+10
	RB:Print(L["RageBar v1.02 loaded."])
end

-- Frame dragging
local function dragstart()
	if not RB.db.global.lock then
		RBFrame:StartMoving()
	end
end

local function dragstop()
	RBFrame:StopMovingOrSizing()
	RB.db.global.x = RBFrame:GetLeft()
	RB.db.global.y = RBFrame:GetBottom()
end

function RB:OnEnable()
	local _, Class = UnitClass("player");
	if Class ~= "WARRIOR" then return end
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_MAXHEALTH")
	self:RegisterEvent("UNIT_RAGE")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

--Main Frame creation
	RBFrame = CreateFrame("Frame",nil,UIParent)
	RBFrame:SetFrameStrata("LOW")
	RBFrame:SetWidth(RB.db.global.width)
	RBFrame:SetHeight(RB.db.global.height)
	RBFrame:SetPoint("BOTTOMLEFT",RB.db.global.x,RB.db.global.y)
	RBFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",tile = false})
	RBFrame:SetBackdropColor(RB.db.global.colorbg.r, RB.db.global.colorbg.g, RB.db.global.colorbg.b, RB.db.global.colorbg.a)
	RBFrame:SetMovable(true)
	RBFrame:RegisterForDrag('LeftButton')
	RBFrame:SetClampedToScreen(true)
	RBFrame:EnableMouse(not RB.db.global.lock)
	RBFrame:SetScript('OnDragStart', dragstart)
	RBFrame:SetScript('OnDragStop', dragstop)

--Frame health creation
	RBFrame2 = CreateFrame("Frame",nil,RBFrame)
	RBFrame2:SetFrameStrata("LOW")
	RBFrame2:SetWidth(RB.db.global.width)
	RBFrame2:SetHeight(RB.db.global.height)
	RBFrame2:SetPoint("BOTTOMLEFT",RB.db.global.hx,RB.db.global.hy)
	RBFrame2:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",tile = false})
	RBFrame2:SetBackdropColor(RB.db.global.colorbg.r, RB.db.global.colorbg.g, RB.db.global.colorbg.b, RB.db.global.colorbg.a)
	RBFrame2:SetMovable(true)
	RBFrame2:RegisterForDrag('LeftButton')
	RBFrame2:SetClampedToScreen(true)
	RBFrame2:EnableMouse(not RB.db.global.lock)
	RBFrame2:SetScript('OnDragStart', dragstart)
	RBFrame2:SetScript('OnDragStop', dragstop)

--RageBar showing current health
	RBHealth = CreateFrame("StatusBar",nil,RBFrame2)
	RBHealth:SetStatusBarTexture(media:Fetch("statusbar",RB.db.global.tex))
	RBHealth:SetOrientation(RB.db.global.barori)
	RBHealth:SetMinMaxValues(0, UnitHealthMax("player"))
	RBHealth:SetValue(UnitHealth("player"))
	RBHealth:SetStatusBarColor(0,1,0,1)
	RBHealth:SetAllPoints(RBFrame2)

--Labels on the health bar
	HealthText = RBHealth:CreateFontString(nil, 'OVERLAY')
	HealthText:SetPoint(RB.db.global.healthalign, RBFrame2, RB.db.global.htx, RB.db.global.hty);
	HealthText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize)
	HealthText:SetText(UnitHealth('player'))

	HLossText = RBHealth:CreateFontString(nil, 'OVERLAY')
	HLossText:SetPoint(RB.db.global.hlossalign, RBFrame2, RB.db.global.lhtx, RB.db.global.lhty);
	HLossText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize)
	HLossText:SetText("0")

--RageBar showing current rage
	RBBar = CreateFrame("StatusBar",nil,RBFrame)
	RBBar:SetStatusBarTexture(media:Fetch("statusbar",RB.db.global.tex))
	RBBar:SetOrientation(RB.db.global.barori)
	if not RB.db.global.barmax then RBBar:SetMinMaxValues(0, 100) else RBBar:SetMinMaxValues(0, RageCap) end
	RBBar:SetValue(0)
	RBBar:SetAllPoints(RBFrame)

--Labels on the rage bar
	RageText = RBBar:CreateFontString(nil, 'OVERLAY')
	RageText:SetPoint(RB.db.global.ragealign, RBFrame, RB.db.global.rtx, RB.db.global.rty);
	RageText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize)
	RageText:SetText(UnitMana('player'))

	LossText = RBBar:CreateFontString(nil, 'OVERLAY')
	LossText:SetPoint(RB.db.global.lossalign, RBFrame, RB.db.global.ltx, RB.db.global.lty);
	LossText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize)
	LossText:SetText("|cff00ff000|r")

	if RB.db.global.hideooc then RBFrame:Hide() else RBFrame:Show() end
	if RB.db.global.hidehealth then RBFrame2:Hide() else RBFrame2:Show() end
end

function RB:PLAYER_REGEN_DISABLED()
	RBFrame:Show()
end

function RB:PLAYER_REGEN_ENABLED()
	if UnitMana("player") == 0 and RB.db.global.hideoor then RBFrame:Hide() elseif RB.db.global.hideooc and not RB.db.global.hideoor then RBFrame:Hide() end
end

-- Get new values if the player spends talent points
function RB:CHARACTER_POINTS_CHANGED()
	RB.db.global.talentname, RB.db.global.talenticon, _, _, RB.db.global.talentrank, RB.db.global.talentmaxrank = GetTalentInfo(1, 6)
end

-- When zoning with a loading screen, rage is always reset to 0 but UNIT_RAGE is not triggered, so fix this with this event
function RB:PLAYER_ENTERING_WORLD()
	RB:UNIT_RAGE("player","player")
end

-- Changing health value
function RB:UNIT_HEALTH()
	local hloss = UnitHealthMax("player")-UnitHealth("player")
	if hloss > (UnitHealthMax("player")*0.2) and hloss < (UnitHealthMax("player")*0.7) then RBHealth:SetStatusBarColor(1,1,0,1) elseif hloss > (UnitHealthMax("player")*0.7) then RBHealth:SetStatusBarColor(1,0,0,1) else RBHealth:SetStatusBarColor(0,1,0,1) end
	if hloss > 0 then hloss = "|cffff0000"..(hloss*-1).."|r" else hloss = 0 end
	HealthText:SetText(UnitHealth("player"))
	HLossText:SetText(hloss)
	RBHealth:SetValue(UnitHealth("player"))
end

-- Changing max health value
function RB:UNIT_MAXHEALTH()
	RBHealth:SetMinMaxValues(0, UnitHealthMax("player"))
end

-- Changing rage value
function RB:UNIT_RAGE(arg1,arg2)
	if arg2 ~= "player" then return end
	local rage = UnitMana("player")
	local loss = rage-RageCap
	if loss < 1 then loss = "|cff00ff000|r" else loss = "|cffffff00"..(loss*-1).."|r" end
	RageText:SetText(tostring(rage))
	LossText:SetText(loss)
	RBBar:SetValue(rage)
	if rage >= RageCap then RBBar:SetStatusBarColor(1,0,0,1) else RBBar:SetStatusBarColor(0,1,0,1) end
	if rage > 0 and RB.db.global.hideoor then RBFrame:Show() elseif rage == 0 and RB.db.global.hideooc then RBFrame:Hide() end
end

-- /ragebar
function RB:OnCmd()
	RB.db.global.talentname, RB.db.global.talenticon, _, _, RB.db.global.talentrank, RB.db.global.talentmaxrank = GetTalentInfo(1, 6)
	InterfaceOptionsFrame_OpenToCategory("RageBar")
end

-- Helper function for shared media
local function GetLSMIndex(t, value)
	for k, v in pairs(media:List(t)) do
		if v == value then
			return k
		end
	end
	return nil
end

-- Options menu
function RB:Options()
local options = {
	type = "group",
	name = "RageBar",
	childGroups = "tab",
	args = {
		main = {
			type = "group",
			name = L["Common"],
			args = {
				header = {
					type = 'description',
					name = " "..RB.db.global.talentname..": "..RB.db.global.talentrank.."/"..RB.db.global.talentmaxrank.."\n "..L["Rage kept"]..": "..tostring((RB.db.global.talentrank*5)+10),
					imageWidth = 25,
					imageHeight = 25,
					image = RB.db.global.talenticon,
					order = 1,
				},
				about = {
					type = 'description',
					name = L["\n\nRageBar v1.02 by Navy EU Dalaran.\nAn additional rage bar, which shows how much rage would be lost by switching the stance.\n\nThe first time you load RageBar, you must reload UI to save Tactycal mastery rank\n\n"],
					order = 2,
				},
				lock = {
					type = 'toggle',
					name = L["Frame lock"],
					desc = L["Locks the frame / unlocks the frame."],
					set = function(info, value)
					RB.db.global.lock = value;
					RBFrame:EnableMouse(not RB.db.global.lock)
					RBFrame2:EnableMouse(not RB.db.global.lock)
 					if not RB.db.global.lock then RB:Print(L["unlocked."]) else RB:Print(L["locked."]) end
					end,
					get = function(info) return RB.db.global.lock end,
					order = 3,
				},
				nothing = {
					type = 'description',
					name = "   ",
					order = 4,
				},
				reloadui = {
					type = 'execute',
					name = L["Reload UI"],
					desc = L["Save all preferences and reload user interface"],
					func = function()
						RB.db.global.talentname, RB.db.global.talenticon, _, _, RB.db.global.talentrank, RB.db.global.talentmaxrank = GetTalentInfo(1, 6);
						ReloadUI();
					end,
					order = 5,
				},
				reset = {
					type = 'execute',
					name = 'Reset',
					desc = L["Resets all preferences."],
					func = function()
						RB.db:ResetDB('global')
						RBFrame:SetBackdropColor(RB.db.global.colorbg.r, RB.db.global.colorbg.g, RB.db.global.colorbg.b, RB.db.global.colorbg.a);
						RBFrame2:SetBackdropColor(RB.db.global.colorbg.r, RB.db.global.colorbg.g, RB.db.global.colorbg.b, RB.db.global.colorbg.a);
						RageText:SetFont("Fonts\\ARIALN.TTF",RB.db.global.fontsize);
						LossText:SetFont("Fonts\\ARIALN.TTF",RB.db.global.fontsize);
						HealthText:SetFont("Fonts\\ARIALN.TTF",RB.db.global.fontsize);
						HLossText:SetFont("Fonts\\ARIALN.TTF",RB.db.global.fontsize);
						RBFrame:SetHeight(RB.db.global.height);
						RBFrame:SetWidth(RB.db.global.width);
						RBFrame2:SetHeight(RB.db.global.height);
						RBFrame2:SetWidth(RB.db.global.width);
						RBFrame:ClearAllPoints();
						RBFrame2:ClearAllPoints();
						RageText:ClearAllPoints();
						LossText:ClearAllPoints();
						HealthText:ClearAllPoints();
						HLossText:ClearAllPoints();
						RageText:SetPoint(RB.db.global.ragealign, RBFrame, RB.db.global.rtx, RB.db.global.rty);
						LossText:SetPoint(RB.db.global.lossalign, RBFrame, RB.db.global.ltx, RB.db.global.lty);
						HealthText:SetPoint(RB.db.global.healthalign, RBFrame2, RB.db.global.htx, RB.db.global.hty);
						HLossText:SetPoint(RB.db.global.hlossalign, RBFrame2, RB.db.global.lhtx, RB.db.global.lhty);
						RBBar:SetOrientation(RB.db.global.barori);
						RBHealth:SetOrientation(RB.db.global.barori);
						RBFrame:SetPoint("BOTTOMLEFT",RB.db.global.x,RB.db.global.y);
						RBFrame:EnableMouse(not RB.db.global.lock);
						RBFrame2:SetPoint("BOTTOMLEFT",RB.db.global.hx,RB.db.global.hy);
						RBFrame2:EnableMouse(not RB.db.global.lock);
						RBFrame:Show();
						RBFrame2:Show();
						RB.db.global.talentname, RB.db.global.talenticon, _, _, RB.db.global.talentrank, RB.db.global.talentmaxrank = GetTalentInfo(1, 6);
						RB:Print(L["Preferences reset."]);
					end,
					order = 6,
				},
			},
			order = 1,
		},
		frameopts = {
			type = "group",
			name = L["Bar options"],
			desc = L["Configure bar options"],
			args = {
				hideooc = {
					type = 'toggle',
					name = L["Show only in combat"],
					desc = L["Show only if in combat?"],
					set = function(info, value)
					RB.db.global.hideooc = value;
 					if not RB.db.global.hideooc then RB.db.global.hideoor = value RBFrame:Show() RB:Print(L["always visible."]) else RBFrame:Hide(); RB:Print(L["only visible in combat."]) end
					end,
					get = function(info) return RB.db.global.hideooc end,
					order = 1,
				},
				hideoor = {
					type = 'toggle',
					name = L["Show if you have rage"],
					desc = L["Show RageBar as long as you have rage after combat"],
					set = function(info, value)
					RB.db.global.hideoor = value;
 					if not RB.db.global.hideoor then RB:Print(L["only visible in combat."]) else RB.db.global.hideooc = value RBFrame:Hide() RB:Print(L["only visible in combat and as long as you have rage."]) end
					end,
					get = function(info) return RB.db.global.hideoor end,
					order = 2,
				},
  			    barmax = {
					type = 'toggle',
					name = L["Full bar "]..tostring((RB.db.global.talentrank*5)+10)..L[" rage"],
					desc = L["Full bar = rage kept when switching the stance or 100 rage?"],
					set = function(info, value)
					RB.db.global.barmax = value;
 					if not RB.db.global.barmax then RB:Print(L["Maximum bar value"].." = 100"..L[" rage"]) RBBar:SetMinMaxValues(0, 100) else RB:Print(L["Maximum bar value"].." = "..L["Rage kept"]) RBBar:SetMinMaxValues(0, (RB.db.global.talentrank*5)+10) end
					end,
					get = function(info) return RB.db.global.barmax end,
					order = 3,
				},
				vertical = {
					type = 'toggle',
					name = L["Vertical bar"],
					desc = L["Displays vertical bar"],
					set = function(info, value)
					RB.db.global.vertical = value;
					if not RB.db.global.vertical
						then
						RB:Print(L["horizontal"]);
						Temp = RB.db.global.width;
						RB.db.global.width = RB.db.global.height;
						RB.db.global.height = Temp;
						RBFrame:SetWidth(RB.db.global.width);
						RBFrame:SetHeight(RB.db.global.height);
						RBFrame2:SetWidth(RB.db.global.width);
						RBFrame2:SetHeight(RB.db.global.height);
						RBFrame2:ClearAllPoints();
						RageText:ClearAllPoints();
						LossText:ClearAllPoints();
						HealthText:ClearAllPoints();
						HLossText:ClearAllPoints();
						RB.db.global.hx = 0;
						RB.db.global.hy = RB.db.global.height;
						RB.db.global.rtx = 0;
						RB.db.global.rty = 0;
						RB.db.global.ltx = 0;
						RB.db.global.lty = 0;
						RB.db.global.htx = 0;
						RB.db.global.hty = 0;
						RB.db.global.lhtx = 0;
						RB.db.global.lhty = 0;
						RB.db.global.ragealign = "LEFT";
						RB.db.global.lossalign = "RIGHT";
						RB.db.global.healthalign = "LEFT";
						RB.db.global.hlossalign = "RIGHT";
						RBFrame2:SetPoint("BOTTOMLEFT",RB.db.global.hx,RB.db.global.hy);
						RageText:SetPoint(RB.db.global.ragealign, RBFrame, RB.db.global.rtx, RB.db.global.rty);
						LossText:SetPoint(RB.db.global.lossalign, RBFrame, RB.db.global.ltx, RB.db.global.lty);
						HealthText:SetPoint(RB.db.global.healthalign, RBFrame2, RB.db.global.htx, RB.db.global.hty);
						HLossText:SetPoint(RB.db.global.hlossalign, RBFrame2, RB.db.global.lhtx, RB.db.global.lhty);
						RB.db.global.barori = "HORIZONTAL";
						RBBar:SetOrientation(RB.db.global.barori);
						RBHealth:SetOrientation(RB.db.global.barori);
						else
						RB:Print(L["vertical"]);
						Temp = RB.db.global.width;
						RB.db.global.width = RB.db.global.height;
						RB.db.global.height = Temp;
						RBFrame:SetWidth(RB.db.global.width);
						RBFrame:SetHeight(RB.db.global.height);
						RBFrame2:SetWidth(RB.db.global.width);
						RBFrame2:SetHeight(RB.db.global.height);
						RBFrame2:ClearAllPoints();
						RageText:ClearAllPoints();
						LossText:ClearAllPoints();
						HealthText:ClearAllPoints();
						HLossText:ClearAllPoints();
						RB.db.global.hx = RB.db.global.width;
						RB.db.global.hy = 0;
						RB.db.global.rtx = RB.db.global.hx*-1;
						RB.db.global.rty = 0;
						RB.db.global.ltx = RB.db.global.hx*-1;
						RB.db.global.lty = 0;
						RB.db.global.htx = RB.db.global.hx;
						RB.db.global.hty = 0;
						RB.db.global.lhtx = RB.db.global.hx;
						RB.db.global.lhty = 0;
						RB.db.global.ragealign = "BOTTOMRIGHT";
						RB.db.global.lossalign = "TOPRIGHT";
						RB.db.global.healthalign = "BOTTOMLEFT";
						RB.db.global.hlossalign = "TOPLEFT";
						RBFrame2:SetPoint("BOTTOMLEFT",RB.db.global.hx,RB.db.global.hy);
						RageText:SetPoint(RB.db.global.ragealign, RBFrame, RB.db.global.rtx, RB.db.global.rty);
						LossText:SetPoint(RB.db.global.lossalign, RBFrame, RB.db.global.ltx, RB.db.global.lty);
						HealthText:SetPoint(RB.db.global.healthalign, RBFrame2, RB.db.global.htx, RB.db.global.hty);
						HLossText:SetPoint(RB.db.global.hlossalign, RBFrame2, RB.db.global.lhtx, RB.db.global.lhty);
						RB.db.global.barori = "VERTICAL";
						RBBar:SetOrientation(RB.db.global.barori);
						RBHealth:SetOrientation(RB.db.global.barori);
						end
					end,
					get = function(info) return RB.db.global.vertical end,
					order = 4,
				},
				hidehealth = { -- a localiser
					type = 'toggle',
					name = L["Disable health bar"],
					desc = L["Hide the health bar"],
					set = function(info, value)
					RB.db.global.hidehealth = value;
 					if not RB.db.global.hidehealth then RBFrame2:Show() RB:Print(L["health bar enabled."]) else RBFrame2:Hide(); RB:Print(L["health bar disabled."]) end
					end,
					get = function(info) return RB.db.global.hidehealth end,
					order = 5,
				},
				nothing = {
					type = 'description',
					name = "   ",
					order = 6,
				},
				width = {
					type = 'range',
					name = L["Bar width"],
					desc = L["Changes bar width."],
					min = 1,
					max = 500,
					step = 1,
					get = function() return RB.db.global.width end,
					set = function(info, v)
						RB.db.global.width = v;
						RBFrame:SetWidth(v);
						RBFrame2:SetWidth(v);
						if RB.db.global.vertical
							then
							RBFrame2:ClearAllPoints();
							RageText:ClearAllPoints();
							LossText:ClearAllPoints();
							HealthText:ClearAllPoints();
							HLossText:ClearAllPoints();
							RB.db.global.hx = v;
							RB.db.global.hy = 0;
							RB.db.global.rtx = v*-1;
							RB.db.global.rty = 0;
							RB.db.global.ltx = v*-1;
							RB.db.global.lty = 0;
							RB.db.global.htx = v;
							RB.db.global.hty = 0;
							RB.db.global.lhtx = v;
							RB.db.global.lhty = 0;
							RBFrame2:SetPoint("BOTTOMLEFT",RB.db.global.hx,RB.db.global.hy);
							RageText:SetPoint(RB.db.global.ragealign, RBFrame, RB.db.global.rtx, RB.db.global.rty);
							LossText:SetPoint(RB.db.global.lossalign, RBFrame, RB.db.global.ltx, RB.db.global.lty);
							HealthText:SetPoint(RB.db.global.healthalign, RBFrame2, RB.db.global.htx, RB.db.global.hty);
							HLossText:SetPoint(RB.db.global.hlossalign, RBFrame2, RB.db.global.lhtx, RB.db.global.lhty);
						end
					end,
					order = 7,
				},
				height = {
					type = 'range',
					name = L["Bar height"],
					desc = L["Changes bar height."],
					min = 1,
					max = 500,
					step = 1,
					get = function() return RB.db.global.height end,
					set = function(info, v)
						RB.db.global.height = v;
						RBFrame:SetHeight(v);
						RBFrame2:SetHeight(v);
						if not RB.db.global.vertical
							then
							RBFrame2:ClearAllPoints();
							RageText:ClearAllPoints();
							LossText:ClearAllPoints();
							HealthText:ClearAllPoints();
							HLossText:ClearAllPoints();
							RB.db.global.hx = 0;
							RB.db.global.hy = v;
							RB.db.global.rtx = 0;
							RB.db.global.rty = 0;
							RB.db.global.ltx = 0;
							RB.db.global.lty = 0;
							RB.db.global.htx = 0;
							RB.db.global.hty = 0;
							RB.db.global.lhtx = 0;
							RB.db.global.lhty = 0;
							RBFrame2:SetPoint("BOTTOMLEFT",RB.db.global.hx,RB.db.global.hy);
							RageText:SetPoint(RB.db.global.ragealign, RBFrame, RB.db.global.rtx, RB.db.global.rty);
							LossText:SetPoint(RB.db.global.lossalign, RBFrame, RB.db.global.ltx, RB.db.global.lty);
							HealthText:SetPoint(RB.db.global.healthalign, RBFrame2, RB.db.global.htx, RB.db.global.hty);
							HLossText:SetPoint(RB.db.global.hlossalign, RBFrame2, RB.db.global.lhtx, RB.db.global.lhty);
						end
					end,
					order = 8,
				},
				colorbg = {
					type = 'color',
					name = L["Background colour"],
					desc = L["Changes background colour and opacity."],
					hasAlpha = true,
					get = function(info) return RB.db.global.colorbg.r, RB.db.global.colorbg.g, RB.db.global.colorbg.b, RB.db.global.colorbg.a end,
					set = function(info, r, g, b, a)
						RBFrame:SetBackdropColor(r, g, b, a);
						RBFrame2:SetBackdropColor(r, g, b, a);
						RB.db.global.colorbg.r = r;
						RB.db.global.colorbg.g = g;
						RB.db.global.colorbg.b = b;
						RB.db.global.colorbg.a = a;
						end,
					order = 9,
				},
				bartex = {
					type = "select",
					name = L["Bar texture"],
					desc = L["Changes the bar texture used."],
					values = textures,
					get = function(info) return GetLSMIndex("statusbar", RB.db.global.tex) end,
					set = function(info, v)
						RB.db.global.tex = media:List("statusbar")[v];
  						RBBar:SetStatusBarTexture(media:Fetch("statusbar",RB.db.global.tex));
						RBHealth:SetStatusBarTexture(media:Fetch("statusbar",RB.db.global.tex));
					end,
					order = 10,
				},
			},
			order = 2,
		},
		fontopts = {
			type = "group",
			name = L["Font options"],
			desc = L["Configure font options"],
			args = {
				font = {
					type = "select",
					name = L["Font"],
					desc = L["Changes the font used."],
					values = fonts,
					get = function(info) return GetLSMIndex("font", RB.db.global.font) end,
					set = function(info, v)
						RB.db.global.font = media:List("font")[v];
						RageText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize);
						LossText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize);
						HealthText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize);
						HLossText:SetFont(media:Fetch("font",RB.db.global.font),RB.db.global.fontsize);
						end,
					order = 1,
				},
				fontsize = {
					type = 'range',
					name = L["Font size"],
					desc = L["Changes the font size."],
					min = 1,
					max = 30,
					step = 1,
					get = function() return RB.db.global.fontsize end,
					set = function(info, v)
						RB.db.global.fontsize = v;
						RageText:SetFont(media:Fetch("font",RB.db.global.font),v);
						LossText:SetFont(media:Fetch("font",RB.db.global.font),v);
						HealthText:SetFont(media:Fetch("font",RB.db.global.font),v);
						HLossText:SetFont(media:Fetch("font",RB.db.global.font),v);
					end,
					order = 2,
				},
			},
			order = 3,
		},
	},
}

-- Config Stuff
AceConfig = LibStub("AceConfigDialog-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("RageBar", options, nil)
AceConfig:AddToBlizOptions("RageBar", "RageBar")
RB:RegisterChatCommand('ragebar', 'OnCmd') 
end