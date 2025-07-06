local SaySapped = CreateFrame("Frame")
SaySapped.playername = UnitName("player")

SaySapped:SetScript("OnEvent",function()
	if ((arg7 == SaySapped.playername)
	and (arg2 == "SPELL_AURA_APPLIED" or arg2 == "SPELL_AURA_REFRESH")
	and (arg9 == 51724 or arg9 == 11297 or arg9 == 2070 or arg9 ==  6770))
	then
		SendChatMessage("Sapped", "SAY")
	end
end)

SaySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
DEFAULT_CHAT_FRAME:AddMessage("SaySapped loaded")
