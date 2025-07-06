ENERGYWATCH_VERSION = "EnergyWatch Reborn 3.2.0"

ENERGYWATCH_ALPHA = 1

ENERGYWATCH_TEXT = "&e/&em (&c)"

ENERGYWATCH_COMBO = 0

ENERGYWATCH_SHOW = 0

ENERGYWATCH_SCALE = 1

EnergyWatch_Save = {}

ENERGYWATCH_VARIABLES_LOADED = false

ENERGYWATCH_VARIABLE_TIMER = 0

function EnergyWatch_OnLoad()
	EnergyWatch:RegisterEvent("PLAYER_REGEN_ENABLED");
	EnergyWatch:RegisterEvent("PLAYER_REGEN_DISABLED");
	EnergyWatch:RegisterEvent("UNIT_AURA");
	EnergyWatch:RegisterEvent("UNIT_COMBO_POINTS");
	EnergyWatch:RegisterEvent("UNIT_DISPLAYPOWER");

	SLASH_ENERGYWATCH1 = "/energywatch";
	SLASH_ENERGYWATCH2 = "/ew";
	SlashCmdList["ENERGYWATCH"] = function(msg)
		EnergyWatch_SlashCommandHandler(msg);
	end

	DEFAULT_CHAT_FRAME:AddMessage(ENERGYWATCH_VERSION.." Loaded - /ew");
end

function EnergyWatch_OnUpdate()
	if( ENERGYWATCH_STATUS == 0 ) then
		return;
	end
	
	local Energy = UnitPower("player", SPELL_POWER_ENERGY);
	local EnergyMax = UnitPowerMax("player", SPELL_POWER_ENERGY);

	EnergyWatchFrameStatusBar:SetMinMaxValues(0, EnergyMax);
	EnergyWatchFrameStatusBar:SetValue(Energy);
	EnergyWatch_TextUpdate();
end

function EnergyWatch_OnEvent(event)
	--DEFAULT_CHAT_FRAME:AddMessage("Caught Event "..event)
	if( ENERGYWATCH_STATUS == 0 ) then
		return
	end
	
	EnergyWatch_EventHandler[event](arg1, arg2, arg3, arg4, arg5);
end

EnergyWatch_EventHandler = {}

EnergyWatch_EventHandler["UNIT_COMBO_POINTS"] = function()
	ENERGYWATCH_COMBO = GetComboPoints("player");
	EnergyWatch_TextUpdate();
end

EnergyWatch_EventHandler["PLAYER_REGEN_ENABLED"] = function()
	if ENERGYWATCH_SHOW == 0 then
		if hasEnergy() then
	    		EnergyWatchBar:Show()
		end
	else
			EnergyWatchBar:Hide()
	end
end

EnergyWatch_EventHandler["UNIT_DISPLAYPOWER"] = function(unit)
	--print("Displaypower changed for " .. unit)
	--local powerType, powerTypeString = UnitPowerType("player")
	--print("Unit currently has " .. powerType .. " " .. powerTypeString)
	if ( ENERGYWATCH_SHOW == 0 ) then
		if hasEnergy() then
	    		EnergyWatchBar:Show()
		else
			EnergyWatchBar:Hide()
		end
	elseif ( ENERGYWATCH_SHOW == 1 ) then
		if hasEnergy() and UnitAffectingCombat("player") then
			EnergyWatchBar:Show()
		else
			EnergyWatchBar:Hide()
		end
	elseif ( ENERGYWATCH_SHOW == 2 ) then
		if (( inStealth() ) or ( hasEnergy() and UnitAffectingCombat("player") )) then
			EnergyWatchBar:Show()
		else 
			EnergyWatchBar:Hide()
		end	
	elseif ( ENERGYWATCH_SHOW == 3 ) then
		if inStealth() then
			EnergyWatchBar:Show()
		else
			EnergyWatchBar:Hide()
		end
	end
end

EnergyWatch_EventHandler["PLAYER_REGEN_DISABLED"] = function()
	if ENERGYWATCH_SHOW == 0 then
		if hasEnergy() then
	    		EnergyWatchBar:Show()
		end
	elseif ENERGYWATCH_SHOW == 1 or ENERGYWATCH_SHOW == 2 then
		if hasEnergy() then
	    		EnergyWatchBar:Show()
		end
	else
		EnergyWatchBar:Hide()
	end

end

EnergyWatch_EventHandler["UNIT_AURA"] = function(unit)
	--DEFAULT_CHAT_FRAME:AddMessage("Auras changed for " .. unit)
	if ( ENERGYWATCH_SHOW == 0 ) then
		if hasEnergy() then
	    		EnergyWatchBar:Show()
		else
			EnergyWatchBar:Hide()
		end
	elseif ( ENERGYWATCH_SHOW == 1 ) then
		if hasEnergy() and UnitAffectingCombat("player") then
			EnergyWatchBar:Show()
		else
			EnergyWatchBar:Hide()
		end
	elseif ( ENERGYWATCH_SHOW == 2 ) then
		if (( inStealth() ) or ( hasEnergy() and UnitAffectingCombat("player") )) then
			EnergyWatchBar:Show()
		else 
			EnergyWatchBar:Hide()
		end	
	elseif ( ENERGYWATCH_SHOW == 3 ) then
		if inStealth() then
			EnergyWatchBar:Show()
		else
			EnergyWatchBar:Hide()
		end
	end

end

function inStealth()
	for i = 1, 40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", i)
		if (not icon) then
		--DEFAULT_CHAT_FRAME:AddMessage("Found no icon for buffid "..i)
			return false
		end
		--DEFAULT_CHAT_FRAME:AddMessage(name.." "..rank.." "..icon)
		if icon == "Interface\\Icons\\Ability_Stealth" or 
		   icon == "Interface\\Icons\\Ability_Ambush" and
	   	hasEnergy() then
			--DEFAULT_CHAT_FRAME:AddMessage("Unit is stealthed")
			return true
		end
	end
	--DEFAULT_CHAT_FRAME:AddMessage("Unit is not stealthed")
	return false
end

function hasEnergy()
	if ( UnitPowerType("player") == 3 ) then
	    		return true
		else
			return false
		end
end

function EnergyWatch_SlashCommandHandler(msg)
	if( msg ) then
		local command = string.lower(msg);
		if( command == "on" ) then
			if( ENERGYWATCH_STATUS == 0 ) then
				ENERGYWATCH_STATUS = 1;
				EnergyWatch_Save.status = ENERGYWATCH_STATUS;
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch enabled");
				EnergyWatchBar:Show()
			end
		elseif( command == "off" ) then
			if( ENERGYWATCH_STATUS ~= 0 ) then
				ENERGYWATCH_STATUS = 0;
				EnergyWatch_Save.status = ENERGYWATCH_STATUS;
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch disabled");
				EnergyWatchBar:Hide();
			end
		elseif( command == "unlock" ) then
			if( ENERGYWATCH_STATUS ~= 2 ) then
				ENERGYWATCH_STATUS = 2;
				EnergyWatch_Save.status = ENERGYWATCH_STATUS;
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch unlocked");
			end
		elseif( command == "lock" ) then
			if( ENERGYWATCH_STATUS == 2 ) then
				ENERGYWATCH_STATUS = 1;
				EnergyWatch_Save.status = ENERGYWATCH_STATUS;
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch locked");
			end
		elseif( command == "clear" ) then
			local pn = UnitName("player");
			if(pn ~= nil and pn ~= UNKNOWNBEING and pn ~= UKNOWNBEING and pn ~= UNKNOWNOBJECT) then
				EnergyWatch_Save = nil;
				ENERGYWATCH_VARIABLES_LOADED = false;
				EnergyWatch_LoadVariables(2);
			else
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch: World not yet loaded, please wait...")
			end

		elseif( command == "reset" ) then
			EnergyWatch_Save.alpha = nil;
			EnergyWatch_Save.scale = nil;
			EnergyWatchBar:ClearAllPoints();
			EnergyWatchBar:SetPoint("CENTER", "UIParent");
			EnergyWatchBar:Show();
			DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch scale, alpha and position reset")

		elseif( string.sub(command,1,4) == "text" ) then
			if( string.len(command) > 5 ) then
				ENERGYWATCH_TEXT = string.sub(msg,6);
			else
				ENERGYWATCH_TEXT = "";
			end
			EnergyWatch_Save.text = ENERGYWATCH_TEXT;
			EnergyWatch_TextUpdate();
		elseif( command == "show always") then
			EnergyWatch_Save.show = 0;
			ENERGYWATCH_SHOW = EnergyWatch_Save.show
			if ENERGYWATCH_STATUS ~= 0 then
				if hasEnergy() then
	    				EnergyWatchBar:Show()
				end
			end
		elseif( command == "show combat") then
			EnergyWatch_Save.show = 1;
			ENERGYWATCH_SHOW = EnergyWatch_Save.show
			if ENERGYWATCH_STATUS ~= 0 then
				if UnitAffectingCombat("player") then
					EnergyWatchBar:Show()
				else
					EnergyWatchBar:Hide()
				end
			end
		elseif( command == "show stealth") then
			EnergyWatch_Save.show = 2;
			ENERGYWATCH_SHOW = EnergyWatch_Save.show
			if inStealth() then
				EnergyWatchBar:Show()
			else
		    		EnergyWatchBar:Hide()
			end
		elseif( command == "show stealthonly" ) then
			EnergyWatch_Save.show = 3;
			ENERGYWATCH_SHOW = EnergyWatch_Save.show
			if inStealth() then
				EnergyWatchBar:Show()
			else
		    		EnergyWatchBar:Hide()
			end
		elseif( string.sub(command, 1, 5) == "scale" ) then
			local scale = tonumber(string.sub(command, 7))
			if( scale <= 3.0 and scale >= 0.25 ) then
				EnergyWatch_Save.scale = scale;
				ENERGYWATCH_SCALE = scale;
				EnergyWatchBar:SetScale(ENERGYWATCH_SCALE * UIParent:GetScale());
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch scale set to "..scale);
			else
				EnergyWatch_Help()
			end
		elseif( string.sub(command, 1, 5) == "alpha" ) then
			local alpha = tonumber(string.sub(command, 7))
			if( alpha <= 1.0 and alpha >= 0.0 ) then
				EnergyWatch_Save.alpha = alpha;
				ENERGYWATCH_ALPHA = alpha;
				EnergyWatchBar:SetAlpha(alpha);
				DEFAULT_CHAT_FRAME:AddMessage("EnergyWatch alpha set to "..alpha);
			else
				EnergyWatch_Help()
			end
		elseif( command == "help text" ) then
			EnergyWatch_HelpText();
		elseif( command == "help show" ) then
			EnergyWatch_HelpShow();
		else
			EnergyWatch_Help();
		end
	end
end

function EnergyWatch_LoadVariables(arg1)
	if ENERGYWATCH_VARIABLES_LOADED then
		return
	end
	ENERGYWATCH_VARIABLE_TIMER = ENERGYWATCH_VARIABLE_TIMER + arg1
	if ENERGYWATCH_VARIABLE_TIMER < 0.2 then
		return
	end
	ENERGYWATCH_VARIABLE_TIMER = 0;

	local playerName=UnitName("player")
	if playerName==nil or playerName==UNKNOWNBEING or playerName==UKNOWNBEING or playerName==UNKNOWNOBJECT then
		return
	end

	if EnergyWatch_Save.status == nil then
		local localizedClass, englishClass = UnitClass("player");
		if englishClass == "ROGUE" or englishClass == "DRUID" then
			EnergyWatch_Save.status = 1;
		else 
			EnergyWatch_Save.status = 0;
		end
	end
	if EnergyWatch_Save.text == nil then
		EnergyWatch_Save.text = ENERGYWATCH_TEXT;
	end
	if EnergyWatch_Save.show == nil then
		EnergyWatch_Save.show = ENERGYWATCH_SHOW;
	end
	if EnergyWatch_Save.scale == nil then
		EnergyWatch_Save.scale = ENERGYWATCH_SCALE;
	end
	if EnergyWatch_Save.alpha == nil then
		EnergyWatch_Save.alpha = ENERGYWATCH_ALPHA;
	end

	ENERGYWATCH_TEXT = EnergyWatch_Save.text;
	ENERGYWATCH_STATUS = EnergyWatch_Save.status;
	ENERGYWATCH_SHOW = EnergyWatch_Save.show;
	ENERGYWATCH_SCALE = EnergyWatch_Save.scale;	
	ENERGYWATCH_ALPHA = EnergyWatch_Save.alpha;

	EnergyWatchBar:SetScale(ENERGYWATCH_SCALE * UIParent:GetScale());
	EnergyWatchBar:SetAlpha(ENERGYWATCH_ALPHA);

	if( ENERGYWATCH_STATUS ~= 0 ) then
		if ENERGYWATCH_SHOW == 0 then
			if hasEnergy() then
				EnergyWatchBar:Show();
			end
		elseif ( ENERGYWATCH_SHOW == 2 or ENERGYWATCH_SHOW == 3 ) then
			if inStealth() then
				EnergyWatchBar:Show();
			else
				EnergyWatchBar:Hide();
			end
		end
	else
		EnergyWatchBar:Hide();
	end
	EnergyWatch_TextUpdate();

	ENERGYWATCH_VARIABLES_LOADED = true;
	EnergyWatch_Variable_Frame:Hide();
	
end

function EnergyWatch_TextUpdate()
	local ewtext = ENERGYWATCH_TEXT
	ewtext,_ = string.gsub(ewtext,"&em", UnitPowerMax("player", SPELL_POWER_ENERGY))
	ewtext,_ = string.gsub(ewtext,"&e", UnitPower("player", SPELL_POWER_ENERGY))
	ewtext,_ = string.gsub(ewtext,"&c", ENERGYWATCH_COMBO)

	EnergyWatchText:SetText(ewtext);
end

function EnergyWatch_Help()
	DEFAULT_CHAT_FRAME:AddMessage(ENERGYWATCH_VERSION.." : Usage - /ew option");
	DEFAULT_CHAT_FRAME:AddMessage(" options:");
	DEFAULT_CHAT_FRAME:AddMessage("  on      : Enables EnergyWatch");
	DEFAULT_CHAT_FRAME:AddMessage("  off     : Disables EnergyWatch");
	DEFAULT_CHAT_FRAME:AddMessage("  unlock  : Allows you to move EnergyWatch");
	DEFAULT_CHAT_FRAME:AddMessage("  lock    : Locks EnergyWatch");
	DEFAULT_CHAT_FRAME:AddMessage("  scale _ : Scales EnergyWatch bar (0.25 - 3.0)");
	DEFAULT_CHAT_FRAME:AddMessage("  alpha _ : Sets bar Alpha (opacity) (0.0 - 1.0)");
	DEFAULT_CHAT_FRAME:AddMessage("  reset   : Resets bar scale, alpha and position to defaults");
	DEFAULT_CHAT_FRAME:AddMessage("  help _  : Prints help for certain options (below)");
	DEFAULT_CHAT_FRAME:AddMessage("  text _  : Sets the text on EnergyWatch");
	DEFAULT_CHAT_FRAME:AddMessage("  show _  : Set when EnergyWatch should be shown")
end

function EnergyWatch_HelpText()
	DEFAULT_CHAT_FRAME:AddMessage(ENERGYWATCH_VERSION.." : Usage - /ew text string");
	DEFAULT_CHAT_FRAME:AddMessage(" the string may contain a few special replacements:");
	DEFAULT_CHAT_FRAME:AddMessage("  &e  : Current Energy");
	DEFAULT_CHAT_FRAME:AddMessage("  &em : Maximum Energy");
	DEFAULT_CHAT_FRAME:AddMessage("  &c : Combo Points");
end

function EnergyWatch_HelpShow()
	DEFAULT_CHAT_FRAME:AddMessage(ENERGYWATCH_VERSION.." : Usage - /ew show option");
	DEFAULT_CHAT_FRAME:AddMessage(" options:");
	DEFAULT_CHAT_FRAME:AddMessage("  always      : Always shown");
	DEFAULT_CHAT_FRAME:AddMessage("  combat      : Shown in Combat");
	DEFAULT_CHAT_FRAME:AddMessage("  stealth     : Shown in Combat and while stealthed");
	DEFAULT_CHAT_FRAME:AddMessage("  stealthonly : Shown only while Stealthed");
	DEFAULT_CHAT_FRAME:AddMessage("  Druids - EnergyWatch will only be visible while you are in cat form");
end
