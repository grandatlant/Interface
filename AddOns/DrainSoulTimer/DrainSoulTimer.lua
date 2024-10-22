function DST_OnLoad()

	EWPlayed = false

	SlashCmdList["DrainSoulTimerCommand"] = DST_SlashHandler
	SLASH_DrainSoulTimerCommand1 = "/dst"
end

function DST_VarsLoaded()
	
	if(not DST_Vars) then
		DST_Vars = {
			EW_Sound = true,
			EW_Raidwarning = true,
			EW_Color = {r=1.0, g=0.0, b=0.75},
			Tick_Sound = true,
			EW_Sound = true,
			EW_Raidwarning = true,
			EW_Color = {r=1.0, g=0.0, b=0.75},
			Tick_Sound = true,
			Tick_Raidwarning = true,
			Tick_Color = {r=0.0, g=1.0, b=0.75},
			EW_Min_HP = 180000,
			EW_Percentage = 25
		}
	end

	frame = getglobal("DST_MainFrame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:RegisterEvent("UNIT_HEALTH")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function DST_OnEvent(event,...)

	local eventType = select(2,...)
	local srcName = select(4,...)

	if((event == "COMBAT_LOG_EVENT_UNFILTERED") and (srcName == UnitName("player"))
        and (eventType == "SPELL_PERIODIC_DAMAGE" )) then

		local spellName = select(10,...)
		local drainSoulName = GetSpellInfo(1120) --Drain Soul Rank 1

		if(spellName == drainSoulName) then
        
			if(DST_Vars["Tick_Sound"]) then
				PlaySoundFile("Interface\\AddOns\\DrainSoulTimer\\Sounds\\tick.ogg")
			end
			if(DST_Vars["Tick_Raidwarning"]) then
				RaidNotice_AddMessage(RaidWarningFrame, DST_String_DrainSoul, DST_Vars["Tick_Color"])
			end
		end
        
	elseif(event == "UNIT_HEALTH") then
        if not EWPlayed and UnitIsEnemy("player","target") then
            if not UnitIsDead("target") then
                if (UnitHealthMax("target") > DST_Vars["EW_Min_HP"]) then
                    if (((UnitHealth("target") / UnitHealthMax("target") )*100) < DST_Vars["EW_Percentage"]) then
                
                        if(DST_Vars["EW_Sound"]) then
                            PlaySoundFile("Interface\\AddOns\\DrainSoulTimer\\Sounds\\quaddamage.ogg")
                        end
                        if(DST_Vars["EW_Raidwarning"]) then
                            RaidNotice_AddMessage(RaidWarningFrame, DST_String_EW, DST_Vars["EW_Color"])
                        end
                        
                        EWPlayed = true
                    end
                end
            end
        end
	elseif(event == "PLAYER_TARGET_CHANGED") then
		EWPlayed = false
	end
end

function DST_SlashHandler(arg1)

	InterfaceOptionsFrame_OpenToCategory(DrainSoulTimerOptions);
    
end

function DrainSoulTimerOptions_OnShow()

	DrainSoulTimerOptionsEWSound:SetChecked(DST_Vars["EW_Sound"])
	DrainSoulTimerOptionsEWRaidwarning:SetChecked(DST_Vars["EW_Raidwarning"])
	DrainSoulTimerOptionsTickSound:SetChecked(DST_Vars["Tick_Sound"])
	DrainSoulTimerOptionsTickRaidwarning:SetChecked(DST_Vars["Tick_Raidwarning"])
	DrainSoulTimerOptionsTxtPercentage:SetText(DST_Vars["EW_Percentage"])
	DrainSoulTimerOptionsTxtMinHP:SetText(DST_Vars["EW_Min_HP"])    
end

function DrainSoulTimerOptions_OnLoad()
	
	DrainSoulTimerOptionsTitleString:SetText(DST_String_Title)
	DrainSoulTimerOptionsEWSoundText:SetText(DST_String_Opt_EW_Sound)
	DrainSoulTimerOptionsEWRaidwarningText:SetText(DST_String_Opt_EW_Raidframe)
	DrainSoulTimerOptionsTickSoundText:SetText(DST_String_Opt_Tick_Sound)
	DrainSoulTimerOptionsTickRaidwarningText:SetText(DST_String_opt_Tick_Raidframe)
	DrainSoulTimerOptionsEWPercentageLabel:SetText(DST_String_Opt_EW_Percentage)
	DrainSoulTimerOptionsEWMinHPLabel:SetText(DST_String_Opt_EW_MinHP)

	DrainSoulTimerOptions.name = "DrainSoulTimer"
	DrainSoulTimerOptions.okay = function (self) DrainSoulTimerOptions_Save(); end;

	InterfaceOptions_AddCategory(DrainSoulTimerOptions)

end

function DrainSoulTimerOptions_Save()

	DST_Vars["EW_Sound"] = DrainSoulTimerOptionsEWSound:GetChecked()
	DST_Vars["EW_Raidwarning"] = DrainSoulTimerOptionsEWRaidwarning:GetChecked()
	DST_Vars["Tick_Sound"] = DrainSoulTimerOptionsTickSound:GetChecked()
	DST_Vars["Tick_Raidwarning"] = DrainSoulTimerOptionsTickRaidwarning:GetChecked()
    
	if tonumber(DrainSoulTimerOptionsTxtPercentage:GetText()) then
		DST_Vars["EW_Percentage"] = tonumber(DrainSoulTimerOptionsTxtPercentage:GetText())
	end
	if tonumber(DrainSoulTimerOptionsTxtMinHP:GetText()) then
		DST_Vars["EW_Min_HP"] = tonumber(DrainSoulTimerOptionsTxtMinHP:GetText())
	end

end