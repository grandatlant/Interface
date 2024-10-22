-- -----------------
-- Engraved
-- by lieandswell
-- -----------------



-- -----------------
-- MOVING AND SIZING
-- -----------------


function Engraved.Rune_OnDragStart(self)

	if ( IsShiftKeyDown() ) then
		self:StartMoving();
--		self:GetParent():StartMoving();
--		self.parentMoving = true;
	else
		self:StartMoving();
--[[
		self.oldPositionParent = self:GetPoint();
		self:StartMoving();
		self.oldPositionScreen = self:GetPoint();
--]]
	end

end

function Engraved.Rune_OnDragStop(self)

	--	get new on-screen position
	self:StopMovingOrSizing();
	--	re-anchor to runeFrame at appropriate new position
	Engraved.SaveRunePosition(self);

--[[
	if ( self.parentMoving ) then
		self:GetParent():StopMovingOrSizing();
		Engraved.SavePosition(self:GetParent());
		self.parentMoving = nil;
	else
		-- get new on-screen position
		-- calculate position wrt runeFrame
		-- StopMovingOrSizing()
		-- re-anchor to runeFrame
		Engraved.SaveRunePosition(self);
	end
--]]

end

function Engraved.SaveRunePosition(rune)
	local point, _, relativePoint, xOfs, yOfs = rune:GetPoint();
	Engraved_Settings["RuneSettings"][rune:GetID()]["Position"] = {point, relativePoint, xOfs, yOfs};
end

function Engraved.SavePosition(runeFrame)
	local point, _, relativePoint, xOfs, yOfs = runeFrame:GetPoint();
	Engraved_Settings["Position"] = {point, relativePoint, xOfs, yOfs};
end

function Engraved.StartSizing(self, buttonPressed)
	local rune = self:GetParent();
	rune.oldScale = rune:GetScale();
	rune.oldX = rune:GetLeft();
	rune.oldY = rune:GetTop();
	rune:ClearAllPoints();
	rune:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", rune.oldX, rune.oldY);
	self.oldCursorX, self.oldCursorY = GetCursorPosition(UIParent);
	self:SetScript("OnUpdate", Engraved.Sizing_OnUpdate);
end

function Engraved.Sizing_OnUpdate(self)
	local uiScale = UIParent:GetScale();
	local cursorX, cursorY = GetCursorPosition(UIParent);
	local rune = self:GetParent();

	-- calculate & set new scale
	local newYScale = rune.oldScale * (cursorY/uiScale - rune.oldY*rune.oldScale) / (self.oldCursorY/uiScale - rune.oldY*rune.oldScale);
	local newXScale = rune.oldScale * (cursorX/uiScale - rune.oldX*rune.oldScale) / (self.oldCursorX/uiScale - rune.oldX*rune.oldScale) ;
	local newScale = max(0.2, newYScale, newXScale);
	rune:SetScale(newScale);

	-- set new frame coords to keep same on-screen position
	local newX = rune.oldX * rune.oldScale / newScale;
	local newY = rune.oldY * rune.oldScale / newScale;
	rune:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", newX, newY);
end

function Engraved.StopSizing(self, buttonPressed)
	self:SetScript("OnUpdate", nil)
	Engraved_Settings["RuneSettings"][self:GetParent():GetID()]["Scale"] = self:GetParent():GetScale();
	Engraved.SaveRunePosition(self:GetParent());
end



-- -----------------------
-- INTERFACE OPTIONS PANEL
-- -----------------------

function Engraved.UIPanel_OnLoad(self)
	local panelName = self:GetName();

	-- local background = _G[panelName.."Background"];
	-- background:SetTexture("Interface\\DressUpFrame\\DressUpBackground-Scourge1");
	-- background:SetVertexColor(0.4, 0.4, 0.4, 1);

	_G[panelName.."Version"]:SetText(ENGRAVED.VERSION);
	_G[panelName.."SubText"]:SetText(ENGRAVED.UIPANEL_SUBTEXT);

	-- Note: this should match the MinMax values in Engraved.UIPanel_Update()
	_G[panelName.."AlmostTimeSlider".."Low"]:SetText("0 "..ENGRAVED.UIPANEL_SECONDS);
	_G[panelName.."AlmostTimeSlider".."High"]:SetText("3 "..ENGRAVED.UIPANEL_SECONDS);

	_G[panelName.."PlayModeButtonText"]:SetText(ENGRAVED.UIPANEL_PLAYMODE);
	_G[panelName.."ConfigModeButtonText"]:SetText(ENGRAVED.UIPANEL_CONFIGMODE);

	_G[panelName.."ThemeDropDownLabel"]:SetText(ENGRAVED.UIPANEL_THEME);
	UIDropDownMenu_SetWidth(InterfaceOptionsEngravedPanelThemeDropDown, 128);

	_G[panelName.."TimerDropDownLabel"]:SetText(ENGRAVED.UIPANEL_TIMERMETHOD);
	UIDropDownMenu_SetWidth(InterfaceOptionsEngravedPanelTimerDropDown, 128);
end

function Engraved.UIPanel_Update()
	local panelName = "InterfaceOptionsEngravedPanel";
	local settings = Engraved_Settings;

	for runeType = 1, 4 do
		_G[panelName .. "RuneColorButton"..runeType.."NormalTexture"]:SetVertexColor(unpack(settings.RuneColor[runeType]));
	end

	_G[panelName.."PrioritizeButton"]:SetChecked(settings.Prioritize);
	Engraved.ThemeDropDown_Update()
	Engraved.TimerDropDown_Update()

	local almostTimeSlider = _G[panelName.."AlmostTimeSlider"];
	almostTimeSlider:SetMinMaxValues(0, 3);
	almostTimeSlider:SetValueStep(0.5);
	almostTimeSlider:SetValue(settings.AlmostTime);

	local inCombatOpacitySlider = _G[panelName.."InCombatOpacitySlider"];
	inCombatOpacitySlider:SetMinMaxValues(0, 1);
	inCombatOpacitySlider:SetValueStep(0.1);
	inCombatOpacitySlider:SetValue(settings.InCombatOpacity);

	local outOfCombatOpacitySlider = _G[panelName.."OutOfCombatOpacitySlider"];
	outOfCombatOpacitySlider:SetMinMaxValues(0, 1);
	outOfCombatOpacitySlider:SetValueStep(0.1);
	outOfCombatOpacitySlider:SetValue(settings.OutOfCombatOpacity);

	local unusableOpacitySlider = _G[panelName.."UnusableOpacitySlider"];
	unusableOpacitySlider:SetMinMaxValues(0, 1);
	unusableOpacitySlider:SetValueStep(0.1);
	unusableOpacitySlider:SetValue(settings.UnusableOpacity);

	local almostOpacitySlider = _G[panelName.."AlmostOpacitySlider"];
	almostOpacitySlider:SetMinMaxValues(0, 1);
	almostOpacitySlider:SetValueStep(0.1);
	almostOpacitySlider:SetValue(settings.AlmostOpacity);
end

function Engraved.CheckButton_OnClick(self, variable)
	if ( self:GetChecked() ) then
		Engraved_Settings[variable] = true;
	else
		Engraved_Settings[variable] = false;
	end
	Engraved.Update();
end

function Engraved.ChooseRuneColor(runeType)
	info = UIDropDownMenu_CreateInfo();
	info.r, info.g, info.b  = unpack(Engraved_Settings.RuneColor[runeType]);
	info.swatchFunc = Engraved.SetRuneColor;
	info.cancelFunc = Engraved.CancelRuneColor;
	info.extraInfo = runeType;
	OpenColorPicker(info);
end

function Engraved.SetRuneColor()
	local runeType = ColorPickerFrame.extraInfo;
	local r,g,b = ColorPickerFrame:GetColorRGB();
	Engraved_Settings.RuneColor[runeType] = {r, g, b};
	Engraved.Update();
	Engraved.UIPanel_Update();
end

function Engraved.CancelRuneColor(previousValues)
	if ( previousValues ) then
		local runeType = ColorPickerFrame.extraInfo;
		Engraved_Settings.RuneColor[runeType] = {previousValues.r, previousValues.g, previousValues.b};
		Engraved.Update();
		Engraved.UIPanel_Update();
	end
end

function Engraved.ThemeDropDown(self)
	if ( Engraved_Settings ) then
		for key, themeName in ipairs(ENGRAVED.THEME_LIST) do 
			info = UIDropDownMenu_CreateInfo();
			info.value = themeName;
			info.text = themeName;
			info.checked = ( Engraved_Settings["Theme"] == themeName );
			info.func = Engraved.ChooseTheme;
			UIDropDownMenu_AddButton(info);
		end
	end
end

function Engraved.ChooseTheme()
	Engraved_Settings["Theme"] = this.value;
	Engraved.Update();
	Engraved.ThemeDropDown_Update();
end

function Engraved.ThemeDropDown_Update()
	_G["InterfaceOptionsEngravedPanelThemeDropDownText"]:SetText(Engraved_Settings["Theme"]);
end

function Engraved.TimerDropDown(self)
	if ( Engraved_Settings ) then
		for key, timerMethod in ipairs(ENGRAVED.TIMER_LIST) do 
			info = UIDropDownMenu_CreateInfo();
			info.value = timerMethod;
			info.text = timerMethod;
			info.checked = ( Engraved_Settings["TimerMethod"] == timerMethod );
			info.func = Engraved.ChooseTimerMethod;
			UIDropDownMenu_AddButton(info);
		end
	end
end

function Engraved.ChooseTimerMethod()
	Engraved_Settings["TimerMethod"] = this.value;
	Engraved.Update();
	Engraved.TimerDropDown_Update();
end

function Engraved.TimerDropDown_Update()
	_G["InterfaceOptionsEngravedPanelTimerDropDownText"]:SetText(Engraved_Settings["TimerMethod"]);
end

function Engraved.EnterPlayMode()
	PlaySound("gsTitleOptionOK");
	Engraved_Settings["Locked"] = true;
	Engraved.Update();
end

function Engraved.EnterConfigMode()
	PlaySound("gsTitleOptionOK");
	Engraved_Settings["Locked"] = false;
	Engraved.Update();
end

function Engraved.Reset()
	Engraved_Settings = CopyTable(ENGRAVED.DEFAULTS);
	Engraved.Update();
	Engraved.UIPanel_Update();
end

function Engraved.Cancel()
	Engraved_Settings = CopyTable(Engraved.OldSettings);
	Engraved.Update();
end


