local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Raid Roll", {
	text = "Raid Roll",
	type = "data source",
	icon = "Interface\\Icons\\INV_Helmet_74",
	OnClick = function(clickedframe, button)
		--InterfaceOptionsFrame_OpenToCategory(myconfigframe)
		
		if button == "LeftButton" then
			if IsAltKeyDown() then 
				RR_Command("loot")
			else
				RR_Command("toggle")
			end
		elseif button == "RightButton" then
			InterfaceOptionsFrame_OpenToCategory(RaidRoll_Panel.panel);
			RR_GuildRankUpdate()
		end
		if RaidRoll_DB["debug"] == true then RR_Test("You clicked with " .. button) end
	end,
})





if dataobj ~= nil then

	function dataobj:OnTooltipShow()
		self:AddLine(RAIDROLL_LOCALE["BARTOOLTIP"])
		
		
	end

	function dataobj:OnEnter()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
		GameTooltip:ClearLines()
		dataobj.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end

	function dataobj:OnLeave()
		GameTooltip:Hide()
	end
	

end
