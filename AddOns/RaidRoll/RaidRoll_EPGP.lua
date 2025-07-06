
function RR_GetEPGPGuildData()

	if RaidRoll_DB["EPGP"] == nil then RaidRoll_DB["EPGP"] = {} end
-- Setting up default Values
	RaidRoll_DB["DECAY_P"]  = 0		-- The decay (in %)
	RaidRoll_DB["EXTRAS_P"] = 0		-- Standby EPGP
	RaidRoll_DB["MIN_EP"]   = 1		-- Min ep req to be eligable for loot
	RaidRoll_DB["BASE_GP"]  = 1		-- GP value you start with
	
	if IsInGuild() then
		GuildInfo = GetGuildInfoText();
		
		--[[
		-EPGP-
		@DECAY_P:10
		@EXTRAS_P:50
		@MIN_EP:2500
		@BASE_GP:100
		-EPGP-
		]]
		
		string_start,string_end = string.find(GuildInfo, "%-EPGP%-");
		if string_start ~= nil and string_end ~= nil then
			GuildInfo = string.sub(GuildInfo, string_end+2)
			
			--[[
			@DECAY_P:10
			@EXTRAS_P:50
			@MIN_EP:2500
			@BASE_GP:100
			-EPGP-
			]]
			
			string_start,string_end = string.find(GuildInfo, "%-EPGP%-");
			GuildInfo = string.sub(GuildInfo, 1, string_start-2);
			
			--[[	
			@DECAY_P:10
			@EXTRAS_P:50
			@MIN_EP:2500
			@BASE_GP:100
			]]
			
			for i=1,10 do
				if GuildInfo ~= nil then
					string_start,string_end=string.find(GuildInfo, "%@+%a+%_%a+%:%d+");
					if string_start ~= nil then
						Substring = string.sub(GuildInfo, string_start, string_end);
						GuildInfo = string.sub(GuildInfo, string_end+2);
						if RaidRoll_DB["debug"] == true then RR_Test("Leftover String: " .. GuildInfo) end
						
						--[[
						Substring
						@DECAY_P:10
						]]
						
						--[[
						GuildInfo
						@EXTRAS_P:50
						@MIN_EP:2500
						@BASE_GP:100
						]]
						
						string_start,string_end=string.find(Substring, "%@+%a+%_%a+%:");
						Type = string.upper(string.sub(Substring, string_start+1, string_end-1))
						if RaidRoll_DB["debug"] == true then RR_Test("Type: " .. Type); end
						
						-- DECAY_P
						
						string_start,string_end=string.find(Substring, "%:%d+");
						Value = tonumber(string.sub(Substring, string_start+1, string_end));
						if RaidRoll_DB["debug"] == true then RR_Test("Value: " .. Value); end
						
						-- 10
						
						RaidRoll_DB[Type] = Value ;
					end
				end
			end
		end
	end
end


function RR_GetEPGPCharacterData(character)

-- setup defaults
PR = 0
AboveThreshold = false
EP = 0
GP = 1

	if IsInGuild() then
		if character ~= nil then 
			character = string.lower(character)
			
			for i=1,GetNumGuildMembers() do
				name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i);
				
				name = string.lower(name)
				
				if character == name then
					officernote = strtrim(officernote)	-- cut out [space][tab][return][newline]
					
					EP,GP = strsplit("," ,officernote)
					
					EP = tonumber(EP)
					GP = tonumber(GP)
					
					if tonumber(EP) == nil then EP = 0 end
					if tonumber(GP) == nil then GP = 0 end
					
					GP = GP + RaidRoll_DB["BASE_GP"]
					
					
					PR = (ceil(EP/GP*100) / 100)
					
					if EP >= RaidRoll_DB["MIN_EP"] then AboveThreshold = true end
					
					if RaidRoll_DB["debug"] == true then RR_Test(name .. ": EP=" .. EP .. " GP=" .. GP .. " PR=" .. PR) end
					
				end
			end
		end
	end
	
	return PR,AboveThreshold,EP,GP
	
end

function RR_EPGP_Setup()

 local EPGP_Event = CreateFrame("Frame")
 
  EPGP_Event:RegisterEvent("CHAT_MSG_RAID")
  EPGP_Event:RegisterEvent("CHAT_MSG_OFFICER")
  EPGP_Event:RegisterEvent("CHAT_MSG_GUILD")
  EPGP_Event:RegisterEvent("CHAT_MSG_ADDON")

 
  EPGP_Event:SetScript("OnEvent", EPGP_Event_Function)

end


function EPGP_Event_Function(self, event, ...)
	local arg1, arg2, arg3, arg4, arg5, arg6 = ...;
	
	if arg1 ~= nil then
		GuildString = string.lower(arg1)
		
		if string.find(GuildString, "epgp") then 
			if RaidRoll_DB["debug"] == true then RR_Test("EPGP String Found, updating guild info") end
			if IsInGuild() then
				GuildRoster();
			end
		end
	end
end 