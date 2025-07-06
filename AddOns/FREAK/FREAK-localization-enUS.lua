-- -------------------------------------------------------------------------- --
-- FREAK DEFAULT (english) Localization                                       --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --

FREAK_Locales =

{
-- Interface Options
["Open GUI"] = true,

-- MainFrame
["click & move"] = true,
["click & resize"] = true,
["Check Group"] = true,
["Check Target"] = true,
["Delete All"] = true,
["Delete"] = true,
["STOP CHECK"] = true,
["Checked Players"] = true,
["Not in inspect range!"] = true,
["Tooltip"] = true,
["VALID"] = true,
["NOT VALID"] = true,
["PLEASE READ"] = true,
["The itemLinks (Tooltip/ChatLink) does not contain additional data (gems, enchantments, etc.)."] = true,
["THERE IS NO WARRANTY THAT THIS ADDON GIVES A VALID GEAR CHECK FOR THE ABOVE-MENTIONED ACHIEVEMENTS!"] = true,
["Please use the wowace.com forum if you find an error. Thanks."] = true,
}

function FREAK_Locales:CreateLocaleTable(t)
	for k,v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

FREAK_Locales:CreateLocaleTable(FREAK_Locales)