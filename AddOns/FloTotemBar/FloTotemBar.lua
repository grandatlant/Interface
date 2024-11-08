-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

local VERSION = "3.3.0.16"

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------

local SCHOOL_COLORS = {
	[""] = { 1.0, 0.7, 0.0 },
	[1] = { 1.0, 0.3, 0.0 },
	[2] = { 0.5, 0.5, 1.0 },
	[3] = { 0.0, 1.0, 0.0 }
};

local SHOW_WELCOME = true;
local FLOTOTEMBAR_OPTIONS_DEFAULT = { [1] = { scale = 1, borders = true, barLayout = "1row", barSettings = {} }, active = 1 };
FLOTOTEMBAR_OPTIONS = FLOTOTEMBAR_OPTIONS_DEFAULT;
local FLOTOTEMBAR_BARSETTINGS_DEFAULT = {
	["CALL"] = { buttonsOrder = {}, position = "auto", color = { 0.49, 0, 0.49, 0.7 }, hiddenSpells = {} },
	["TRAP"] = { buttonsOrder = {}, position = "auto", color = { 0.49, 0.49, 0, 0.7 }, hiddenSpells = {} },
	["EARTH"] = { buttonsOrder = {}, position = "auto", color = { 0, 0.49, 0, 0.7 }, hiddenSpells = {} },
	["FIRE"] = { buttonsOrder = {}, position = "auto", color = { 0.49, 0, 0, 0.7 }, hiddenSpells = {} },
	["WATER"] = { buttonsOrder = {}, position = "auto", color = { 0, 0.49, 0.49, 0.7 }, hiddenSpells = {} },
	["AIR"] = { buttonsOrder = {}, position = "auto", color = { 0, 0, 0.99, 0.7 }, hiddenSpells = {} },
};
FLO_CLASS_NAME = nil;
local ACTIVE_OPTIONS = FLOTOTEMBAR_OPTIONS[1];

local FLO_TOTEMIC_CALL_SPELL = GetSpellInfo(TOTEM_MULTI_CAST_RECALL_SPELLS[1]);

-- Ugly
local changingSpec = true;

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- Executed on load, calls general set-up functions
function FloTotemBar_OnLoad(self)

	-- Re-anchor the first button, link it to the timer
	local thisName = self:GetName();
	local button = _G[thisName.."Button1"];

	if thisName == "FloBarTRAP" then
		button:SetPoint("LEFT", thisName.."Countdown3", "RIGHT", 5, 0);
	elseif thisName ~= "FloBarCALL" then
		button:SetPoint("LEFT", thisName.."Countdown", "RIGHT", 5, 0);
	end

	-- Class-based setup, abort if not supported
	_, FLO_CLASS_NAME = UnitClass("player");
	FLO_CLASS_NAME = strupper(FLO_CLASS_NAME);

	local classSpells = FLO_TOTEM_SPELLS[FLO_CLASS_NAME];

	if classSpells == nil then
		return;
	end
	
	self.totemtype = string.sub(thisName, 7);

	-- Store the spell list for later
	self.availableSpells = classSpells[self.totemtype];
	if self.availableSpells == nil then
		return;
	end

	-- Init the settings variable
	ACTIVE_OPTIONS.barSettings[self.totemtype] = FLOTOTEMBAR_BARSETTINGS_DEFAULT[self.totemtype];

	self.spells = {};
	self.SetupSpell = FloTotemBar_SetupSpell;
	self.OnSetup = FloTotemBar_OnSetup;
	self.menuHooks = { SetPosition = FloTotemBar_SetPosition, SetBorders = FloTotemBar_SetBorders };
	if FLO_CLASS_NAME == "SHAMAN" then
		if self.totemtype ~= "CALL" then
			self.slot = _G[self.totemtype.."_TOTEM_SLOT"];
			FloTotemBar_AddCallButtons(self);
		end
		self.menuHooks.SetLayoutMenu = FloTotemBar_SetLayoutMenu;
	end
	self:EnableMouse(1);

	if SHOW_WELCOME then
		DEFAULT_CHAT_FRAME:AddMessage( "FloTotemBar "..VERSION.." loaded." );
		SHOW_WELCOME = nil;

		SLASH_FLOTOTEMBAR1 = "/flototembar";
		SLASH_FLOTOTEMBAR2 = "/ftb";
		SlashCmdList["FLOTOTEMBAR"] = FloTotemBar_ReadCmd;

		self:RegisterEvent("VARIABLES_LOADED");
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
		self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");

		-- Hide default totem bar
		if FLO_CLASS_NAME == "SHAMAN" then
			MultiCastActionBarFrame:SetScript("OnShow", MultiCastActionBarFrame.Hide);
		end
	end
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB");
	self:RegisterEvent("CHARACTER_POINTS_CHANGED");
	self:RegisterEvent("PLAYER_ALIVE");
	self:RegisterEvent("PLAYER_LEVEL_UP");
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	self:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	self:RegisterEvent("UPDATE_BINDINGS");

	if self.totemtype ~= "CALL" then
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		self:RegisterEvent("PLAYER_DEAD");

		-- Destruction detection
		if FLO_CLASS_NAME == "HUNTER" then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		else
			self:RegisterEvent("PLAYER_TOTEM_UPDATE");
		end
	end
end

function FloTotemBar_AddCallButtons(self)

	local button, callButton;
	for i = 1, 10 do
		button = _G[self:GetName().."Button"..i];

		callButton = CreateFrame("Button", "$parentFIRE", button, "FloSwitchButtonTemplate");
		callButton:SetPoint("BOTTOMLEFT", button, "TOPLEFT", -2, -2);
		callButton.callElement = "FIRE";
		callButton:SetAttribute("action", FloSwitchButton_GetActionID(callButton));

		callButton = CreateFrame("Button", "$parentWATER", button, "FloSwitchButtonTemplate");
		callButton:SetPoint("BOTTOM", button, "TOP", 0, -2);
		callButton.callElement = "WATER";
		callButton:SetAttribute("action", FloSwitchButton_GetActionID(callButton));

		callButton = CreateFrame("Button", "$parentAIR", button, "FloSwitchButtonTemplate");
		callButton:SetPoint("BOTTOMRIGHT", button, "TOPRIGHT", 2, -2);
		callButton.callElement = "AIR";
		callButton:SetAttribute("action", FloSwitchButton_GetActionID(callButton));

		button:SetScript("OnEnter", FloTotemBar_OnEnter);
		button:SetScript("OnLeave", FloTotemBar_OnLeave);
	end
end


function FloTotemBar_OnEvent(self, event, arg1, ...)

	if event == "PLAYER_ENTERING_WORLD" or event == "LEARNED_SPELL_IN_TAB" or event == "PLAYER_ALIVE" or event == "PLAYER_LEVEL_UP" or event == "CHARACTER_POINTS_CHANGED" then
		if not changingSpec then
			FloLib_Setup(self);
		end

	elseif event == "UNIT_SPELLCAST_SUCCEEDED"  then
		if arg1 == "player" then
			FloTotemBar_StartTimer(self, ...);
		end

	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
		local spellName = ...;
		if arg1 == "player" and (spellName == FLOLIB_ACTIVATE_SPEC_1 or spellName == FLOLIB_ACTIVATE_SPEC_2) then
			changingSpec = false;
		end

	elseif event == "SPELL_UPDATE_COOLDOWN" or event == "ACTIONBAR_UPDATE_USABLE" then
		FloLib_UpdateState(self);

	elseif event == "PLAYER_DEAD" then
		FloTotemBar_ResetTimers(self);

	elseif event == "VARIABLES_LOADED" then
		FloTotemBar_MigrateVars();
		FloTotemBar_CheckTalentGroup(FLOTOTEMBAR_OPTIONS.active);

		-- Hook the UIParent_ManageFramePositions function
		hooksecurefunc("UIParent_ManageFramePositions", FloTotemBar_UpdatePositions);
		hooksecurefunc("SetActiveTalentGroup", function() changingSpec = true; end);

	elseif event == "UPDATE_BINDINGS" then
		FloLib_UpdateBindings(self, "FLOTOTEM"..self.totemtype);

	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		if FLOTOTEMBAR_OPTIONS.active ~= arg1 then
			FloTotemBar_TalentGroupChanged(arg1);
		end

	else
		-- Events used for totem destruction detection
		if self.activeSpell then
			self.spells[self.activeSpell].algo(self, arg1, ...);
		end
	end
end

function FloTotemBar_TalentGroupChanged(grp)

	-- Save old spec position
	for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
		if v.position ~= "auto" then
			local bar = _G["FloBar"..k];
			v.refPoint = { bar:GetPoint() };
		end
	end

	FloTotemBar_CheckTalentGroup(grp);
	for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
		local bar = _G["FloBar"..k];
		FloLib_Setup(bar);
		-- Restore position
		if v.position ~= "auto" and v.refPoint then
			bar:ClearAllPoints();
			bar:SetPoint(unpack(v.refPoint));
		end
	end
end

function FloTotemBar_CheckTalentGroup(grp)

	changingSpec = false;

	FLOTOTEMBAR_OPTIONS.active = grp;
	ACTIVE_OPTIONS = FLOTOTEMBAR_OPTIONS[grp];
	-- first time talent activation ?
	if not ACTIVE_OPTIONS then
		-- Copy primary spec options into other spec
		FLOTOTEMBAR_OPTIONS[grp] = {};
		FloLib_CopyPreserve(FLOTOTEMBAR_OPTIONS[1], FLOTOTEMBAR_OPTIONS[grp]);
		ACTIVE_OPTIONS = FLOTOTEMBAR_OPTIONS[grp];
	end
	for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
		local bar = _G["FloBar"..k];
		bar.globalSettings = ACTIVE_OPTIONS;
		bar.settings = v;
		FloTotemBar_SetPosition(nil, bar, v.position);
	end
	FloTotemBar_SetScale(ACTIVE_OPTIONS.scale);
	FloTotemBar_SetBorders(nil, ACTIVE_OPTIONS.borders);
end

function FloTotemBar_MigrateVars()

	-- Check new dual spec vars
	if not FLOTOTEMBAR_OPTIONS[1] then
		local tmp = FLOTOTEMBAR_OPTIONS;
		FLOTOTEMBAR_OPTIONS = { [1] = tmp };
	end

	-- Copy new variables
	FloLib_CopyPreserve(FLOTOTEMBAR_OPTIONS_DEFAULT, FLOTOTEMBAR_OPTIONS);
	if FLOTOTEMBAR_OPTIONS[2] then
		FloLib_CopyPreserve(FLOTOTEMBAR_OPTIONS_DEFAULT[1], FLOTOTEMBAR_OPTIONS[2]);
	end

	ACTIVE_OPTIONS = FLOTOTEMBAR_OPTIONS[1];

	-- Import old variables
	if FLOTOTEMBAR_LAYOUT then
		for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
			v.position = FLOTOTEMBAR_LAYOUT;
		end
	elseif ACTIVE_OPTIONS.layout then
		for k, v in pairs(ACTIVE_OPTIONS.buttonsOrder) do
			if k ~= "TRAP" then
				ACTIVE_OPTIONS.barSettings[k] = FLOTOTEMBAR_BARSETTINGS_DEFAULT[k];
				ACTIVE_OPTIONS.barSettings[k].position = ACTIVE_OPTIONS.layout;
			end
		end
		ACTIVE_OPTIONS.layout = nil;
	end
	if FLOTOTEMBAR_SCALE then
		ACTIVE_OPTIONS.scale = FLOTOTEMBAR_SCALE;
	end
	if FLOTOTEMBAR_BUTTONS_ORDER then
		for k, v in pairs(FLOTOTEMBAR_BUTTONS_ORDER) do
			if k ~= "TRAP" then
				ACTIVE_OPTIONS.barSettings[k].buttonsOrder = v;
			end
		end
	elseif ACTIVE_OPTIONS.buttonsOrder then
		for k, v in pairs(ACTIVE_OPTIONS.buttonsOrder) do
			if k ~= "TRAP" then
				ACTIVE_OPTIONS.barSettings[k].buttonsOrder = v;
			end
		end
		ACTIVE_OPTIONS.buttonsOrder = nil;
	end

	for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
		FloLib_CopyPreserve(FLOTOTEMBAR_BARSETTINGS_DEFAULT[k], v);
	end

end

function FloTotemBar_ReadCmd(line)

	local cmd, var = strsplit(' ', line or "");

	if cmd == "scale" and tonumber(var) then
		FloTotemBar_SetScale(var);
	elseif cmd == "lock" or cmd == "unlock" or cmd == "auto" then
		for i, v in ipairs({FloBarTRAP, FloBarCALL, FloBarEARTH, FloBarFIRE, FloBarWATER, FloBarAIR}) do
			FloTotemBar_SetPosition(nil, v, cmd);
		end
	elseif cmd == "borders" then
		FloTotemBar_SetBorders(nil, true);
	elseif cmd == "noborders" then
		FloTotemBar_SetBorders(nil, false);
	elseif cmd == "panic" or cmd == "reset" then
		FloLib_ResetAddon("FloTotemBar");
	else
		DEFAULT_CHAT_FRAME:AddMessage( "FloTotemBar usage :" );
		DEFAULT_CHAT_FRAME:AddMessage( "/ftb lock|unlock : lock/unlock position" );
		DEFAULT_CHAT_FRAME:AddMessage( "/ftb borders|noborders : show/hide borders" );
		DEFAULT_CHAT_FRAME:AddMessage( "/ftb auto : Automatic positioning" );
		DEFAULT_CHAT_FRAME:AddMessage( "/ftb scale <num> : Set scale" );
		DEFAULT_CHAT_FRAME:AddMessage( "/ftb panic||reset : Reset FloTotemBar" );
		return;
	end
end

function FloTotemBar_UpdateTotem(self, slot)

	if self.slot == slot then

		local duration = GetTotemTimeLeft(slot);
		if duration == 0 then
			FloTotemBar_ResetTimer(self, "");
		end
	end
end

function FloTotemBar_CheckTrapLife(self, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool, ...)
	-- [environmentalDamageType]
	-- [spellName, spellRank, spellSchool]
	-- [damage, school, [resisted, blocked, absorbed, crit, glancing, crushing]]

	local spell = self.spells[self.activeSpell];
	local name = string.upper(spell.name);

	if strsub(event, 1, 5) == "SPELL" and event ~= "SPELL_CAST_SUCCESS" and event ~= "SPELL_CREATE" and string.find(string.upper(spellName), name, 1, true) then
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) then
			FloTotemBar_ResetTimer(self, spell.school);
		else
			FloTotemBar_TimerRed(self, spell.school);
		end
	end
end

function FloTotemBar_CheckTrap2Life(self, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	-- [environmentalDamageType]
	-- [spellName, spellRank, spellSchool]
	-- [damage, school, [resisted, blocked, absorbed, crit, glancing, crushing]]

	local spell = self.spells[self.activeSpell];
	local name = string.upper(spell.name);
	local COMBATLOG_FILTER_MY_GUARDIAN = bit.bor(
		COMBATLOG_OBJECT_AFFILIATION_MINE,
		COMBATLOG_OBJECT_REACTION_FRIENDLY,
		COMBATLOG_OBJECT_CONTROL_PLAYER,
		COMBATLOG_OBJECT_TYPE_GUARDIAN
		);
 

	if strsub(event, 1, 5) == "SWING" and CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_GUARDIAN) then
		FloTotemBar_ResetTimer(self, spell.school);
	end
end

function FloTotemBar_SetupSpell(self, spell, pos)

	local duration = 30;
	local algo;

	-- Avoid tainting
	if not InCombatLockdown() then
		local name, button, icon;
		name = self:GetName();
		button = _G[name.."Button"..pos];
		icon = _G[name.."Button"..pos.."Icon"];

		button:SetAttribute("type1", "spell");
		button:SetAttribute("spell", spell.name);

		icon:SetTexture(spell.texture);

		button.refId = spell.refId;

		if self.totemtype == "EARTH" or self.totemtype == "FIRE" or self.totemtype == "WATER" or self.totemtype=="AIR" then
			local button;
			local callSpells = FLO_TOTEM_SPELLS.SHAMAN.CALL;

			button = _G[name.."Button"..pos.."FIRE"];
			if IsSpellKnown(callSpells[2].id) then
				button:Show();
			else
				button:Hide();
			end
			button:SetAttribute("spell", spell.refId);
			FloSwitchButton_OnUpdate(button);

			button = _G[name.."Button"..pos.."WATER"];
			if IsSpellKnown(callSpells[3].id) then
				button:Show();
			else
				button:Hide();
			end
			button:SetAttribute("spell", spell.refId);
			FloSwitchButton_OnUpdate(button);

			button = _G[name.."Button"..pos.."AIR"];
			if IsSpellKnown(callSpells[4].id) then
				button:Show();
			else
				button:Hide();
			end
			button:SetAttribute("spell", spell.refId);
			FloSwitchButton_OnUpdate(button);
		end
	end

	if FLO_CLASS_NAME ~= "HUNTER" then
		duration = nil;
		algo = FloTotemBar_UpdateTotem;
	elseif spell.x then
		algo = FloTotemBar_CheckTrap2Life;
	else
		algo = FloTotemBar_CheckTrapLife;
	end

	self.spells[pos] = { name = spell.name, duration = duration, algo = algo, school = spell.school };

end

function FloTotemBar_OnSetup(self)

	FloTotemBar_ResetTimers(self);
end

function FloTotemBar_UpdatePosition(self)

	-- Avoid tainting when in combat
	if InCombatLockdown() then
		return;
	end

	-- non auto positionning
	if not self.settings or self.settings.position ~= "auto" then
		return;
	end

	local layout = FLO_TOTEM_LAYOUTS[ACTIVE_OPTIONS.barLayout];

	self:ClearAllPoints();
	if self == FloBarEARTH or self == FloBarTRAP then
		local yOffset = -3;
		local yOffset1 = 0;
		local yOffset2 = 0;
		local anchorFrame;

		if not MainMenuBar:IsShown() and not (VehicleMenuBar and VehicleMenuBar:IsShown()) then
			anchorFrame = UIParent;
			yOffset = 110-UIParent:GetHeight();
		else
			anchorFrame = MainMenuBar;
			if ReputationWatchBar:IsShown() and MainMenuExpBar:IsShown() then
				yOffset = yOffset + 9;
			end

			if MainMenuBarMaxLevelBar:IsShown() then
				yOffset = yOffset - 5;
			end

			if SHOW_MULTI_ACTIONBAR_2 then
				yOffset2 = yOffset2 + 45;
			end

			if SHOW_MULTI_ACTIONBAR_1 then
				yOffset1 = yOffset1 + 45;
			end
		end

		if FLO_CLASS_NAME == "HUNTER" then
			if FloAspectBar then
				self:SetPoint("LEFT", FloAspectBar, "RIGHT", 12, 0);
			else
				self:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 512/ACTIVE_OPTIONS.scale, (yOffset + yOffset2)/ACTIVE_OPTIONS.scale);
			end
		else
			local finalOffset = layout.offset * self:GetHeight();
			self:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", FloBarCALL:GetWidth() + 18, (yOffset + yOffset1)/ACTIVE_OPTIONS.scale + finalOffset);
		end

	elseif FLO_CLASS_NAME == "SHAMAN" then

		self:SetPoint(unpack(layout[self:GetName()]));
	end
end

function FloTotemBar_UpdatePositions()

	-- Avoid tainting when in combat
	if InCombatLockdown() then
		return;
	end

	for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
		if v.position == "auto" then
			FloTotemBar_UpdatePosition(_G["FloBar"..k])
		end
	end
end

function FloTotemBar_SetBarDrag(frame, enable)

	local countdown = _G[frame:GetName().."Countdown"];
	if enable then
		FloLib_ShowBorders(frame);
		frame:RegisterForDrag("LeftButton");
		if countdown then
			countdown:RegisterForDrag("LeftButton");
		end
	else
		if ACTIVE_OPTIONS.borders then
			FloLib_ShowBorders(frame);
		else
			FloLib_HideBorders(frame);
		end
	end
end

function FloTotemBar_SetBorders(self, visible)

	ACTIVE_OPTIONS.borders = visible;
	for k, v in pairs(ACTIVE_OPTIONS.barSettings) do
		local bar = _G["FloBar"..k];
		if visible or v.position == "unlock" then
			FloLib_ShowBorders(bar);
		else
			FloLib_HideBorders(bar);
		end
	end

end

function FloTotemBar_SetPosition(self, bar, mode)

	local unlocked = (mode == "unlock");

	-- Close all dropdowns
	CloseDropDownMenus();

	if bar.settings then
		bar.settings.position = mode;
		DEFAULT_CHAT_FRAME:AddMessage(bar:GetName().." position "..mode);

		FloTotemBar_SetBarDrag(bar, unlocked);

		if mode == "auto" then
			-- Force the auto positionning
			FloTotemBar_UpdatePosition(bar);
		else
			-- Force the game to remember position
			bar:StartMoving();
			bar:StopMovingOrSizing();
		end
	end
end

function FloTotemBar_SetLayoutMenu()

	-- Add the possible values to the menu
	for i = 1, #FLO_TOTEM_LAYOUTS_ORDER do
		local value = FLO_TOTEM_LAYOUTS_ORDER[i];
		local info = UIDropDownMenu_CreateInfo();
		info.text = FLO_TOTEM_LAYOUTS[value].label;
		info.value = value;
		info.func = FloTotemBar_SetLayout;
		info.arg1 = value;

		if value == ACTIVE_OPTIONS.barLayout then
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	end

end

function FloTotemBar_SetLayout(self, layout)

	-- Close all dropdowns
	CloseDropDownMenus();

	ACTIVE_OPTIONS.barLayout = layout;
	FloTotemBar_UpdatePositions();
end

function FloTotemBar_SetScale(scale)

	scale = tonumber(scale);
	if not scale or scale <= 0 then
		DEFAULT_CHAT_FRAME:AddMessage( "FloTotemBar : scale must be >0 ("..scale..")" );
		return;
	end

	ACTIVE_OPTIONS.scale = scale;

	for i, v in ipairs({FloBarTRAP, FloBarCALL, FloBarEARTH, FloBarFIRE, FloBarWATER, FloBarAIR}) do
		if v:IsVisible() then
			local p, a, rp, ox, oy = v:GetPoint();
			local os = v:GetScale();
			v:SetScale(scale);
			if a == nil or a == UIParent or a == MainMenuBar then
				v:SetPoint(p, a, rp, ox*os/scale, oy*os/scale);
			end
		end
	end
	FloTotemBar_UpdatePositions();

end

function FloTotemBar_ResetTimer(self, school)

	self["startTime"..school] = 0;
	FloTotemBar_OnUpdate(self);
end

function FloTotemBar_ResetTimers(self)

	self.startTime = 0;
	self.startTime1 = 0;
	self.startTime2 = 0;
	self.startTime3 = 0;
	FloTotemBar_OnUpdate(self);
end

function FloTotemBar_TimerRed(self, school)

	local countdown = _G[self:GetName().."Countdown"..school];
	countdown:SetStatusBarColor(0.5, 0.5, 0.5);

end

function FloTotemBar_StartTimer(self, spellName, rank)

	local founded = false;
	local haveTotem, name, startTime, duration, icon;
	local countdown;
	local school;

	-- Special case for Totemic Call
	if spellName == FLO_TOTEMIC_CALL_SPELL then
		FloTotemBar_ResetTimer(self, "");
		return;
	end

	-- Find spell
	for i = 1, #self.spells do
		if string.lower(self.spells[i].name) == string.lower(spellName) then
			founded = i;

			if FLO_CLASS_NAME == "SHAMAN" then
				haveTotem, name, startTime, duration, icon = GetTotemInfo(self.slot);
				school = "";
			else
				duration = self.spells[i].duration;
				startTime = GetTime();
				school = self.spells[i].school;
			end
			break;
		end
	end

	if founded then

		self["activeSpell"..school] = founded;
		self["startTime"..school] = startTime;

		countdown = _G[self:GetName().."Countdown"..school];
		countdown:SetMinMaxValues(0, duration);
		countdown:SetStatusBarColor(unpack(SCHOOL_COLORS[school]));
		FloTotemBar_OnUpdate(self);

	end

end

function FloTotemBar_OnUpdate(self)

	local isActive;
	local button;
	local countdown;
	local timeleft;
	local duration;
	local name;

	for i=1, #self.spells do

		name = self:GetName();
		button = _G[name.."Button"..i];

		spell = self.spells[i];

		isActive = false;
		for k,v in pairs(SCHOOL_COLORS) do

			if self["activeSpell"..k] == i then

				countdown = _G[name.."Countdown"..k];
				_, duration = countdown:GetMinMaxValues();

				timeleft = self["startTime"..k] + duration - GetTime();
				isActive = timeleft > 0;

				if (isActive) then
					countdown:SetValue(timeleft);
					break;
				else
					self["activeSpell"..k] = nil;
					countdown:SetValue(0);
				end
			end
		end

		if isActive then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end

--		if _G[name.."FIRE"] then
--			FloSwitchButton_OnUpdate(_G[name.."FIRE");
--			FloSwitchButton_OnUpdate(_G[name.."WATER");
--			FloSwitchButton_OnUpdate(_G[name.."AIR");
--		end
	end
end

local CALL_PAGE_OFFSETS = { FIRE = 0, WATER = 4, AIR = 8 };
local CALL_TEX_COORDS = { FIRE = {0, 0.5, 0.5, 1}, WATER = {0.5, 1, 0.5, 1}, AIR = {0, 0.5, 0, 0.5} };

function FloSwitchButton_GetActionID(self)
	return 132 + CALL_PAGE_OFFSETS[self.callElement] + self:GetParent():GetParent().slot;
end

function FloSwitchButton_OnClick(self)

	-- Avoid tainting when in combat
	if InCombatLockdown() then
		return;
	end

	if IsAltKeyDown() then
		SetMultiCastSpell(FloSwitchButton_GetActionID(self), nil);
	else
		SetMultiCastSpell(FloSwitchButton_GetActionID(self), self:GetParent().refId);
	end
end

function FloSwitchButton_OnUpdate(self)

	local action = FloSwitchButton_GetActionID(self);
	local type, id, subType, globalID = GetActionInfo(action);
	local buttonIcon = _G[self:GetName().."IconTexture"];

	if globalID == self:GetParent().refId then
		buttonIcon:SetTexture("Interface\\AddOns\\FloTotemBar\\images\\calls");
		buttonIcon:SetTexCoord(unpack(CALL_TEX_COORDS[self.callElement]));
		self:SetAlpha(1);
	else
		buttonIcon:SetTexture(nil);
		if not self:GetParent().hover then
			self:SetAlpha(0);
		end
	end
end

function FloTotemBar_OnEnter(self)
	FloLib_Button_SetTooltip(self);
	FloSwitchButton_OnEnter(self);
end

function FloSwitchButton_OnEnter(self)
	local name = self:GetName();
	_G[name.."FIRE"]:SetAlpha(1);
	_G[name.."WATER"]:SetAlpha(1);
	_G[name.."AIR"]:SetAlpha(1);
	self.hover = true;
end

function FloTotemBar_OnLeave(self)
	GameTooltip:Hide();
	FloSwitchButton_OnLeave(self);
end

function FloSwitchButton_OnLeave(self)

	local buttonIcon;
	local name = self:GetName();

	buttonIcon = _G[self:GetName().."FIREIconTexture"];
	if buttonIcon:GetTexture() then
		_G[name.."FIRE"]:SetAlpha(1);
	else
		_G[name.."FIRE"]:SetAlpha(0);
	end

	buttonIcon = _G[self:GetName().."WATERIconTexture"];
	if buttonIcon:GetTexture() then
		_G[name.."WATER"]:SetAlpha(1);
	else
		_G[name.."WATER"]:SetAlpha(0);
	end

	buttonIcon = _G[self:GetName().."AIRIconTexture"];
	if buttonIcon:GetTexture() then
		_G[name.."AIR"]:SetAlpha(1);
	else
		_G[name.."AIR"]:SetAlpha(0);
	end

	self.hover = nil;
end

