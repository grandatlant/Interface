FLO_TOTEM_SPELLS = {
	["HUNTER"] = {
		["TRAP"] = {
			{ id = 13795, school = 1 },
			{ id = 1499, school = 2 },
			{ id = 13809, school = 2 },
			{ id = 13813, school = 1 },
			{ id = 34600, school = 3 },
			{ id = 60192, school = 2 }
		}
	},
	["SHAMAN"] = {
		["CALL"] = {
			{ id = 36936 },
			{ id = 66842 },
			{ id = 66843 },
			{ id = 66844 }
		},
		["EARTH"] = {
			{ id = 8071 },
			{ id = 2484 },
			{ id = 5730 },
			{ id = 8075 },
			{ id = 8143 },
			{ id = 2062 }
		},
		["FIRE"] = {
			{ id = 3599 },
			{ id = 8181 },
			{ id = 8190 },
			{ id = 8227 },
			{ id = 2894 },
			{ id = 30706 }
		},
		["WATER"] = {
			{ id = 5394 },
			{ id = 8170 },
			{ id = 5675 },
			{ id = 8184 },
			{ id = 16190 }
		},
		["AIR"] = {
			{ id = 8177 },
			{ id = 10595 },
			{ id = 8512 },
			{ id = 6495 },
			{ id = 3738 }
		}
	}
};
FLO_TOTEM_LAYOUTS = {
	["1row"] = { label = FLO_TOTEM_1ROW, offset = 0,
		["FloBarFIRE"] = { "LEFT", "FloBarEARTH", "RIGHT", 3, 0 },
		["FloBarWATER"] = { "LEFT", "FloBarFIRE", "RIGHT", 3, 0 },
		["FloBarAIR"] = { "LEFT", "FloBarWATER", "RIGHT", 3, 0 },
		["FloBarCALL"] = { "RIGHT", "FloBarEARTH", "LEFT", -3, 0 },
	},
	["2rows"] = { label = FLO_TOTEM_2ROWS, offset = 1,
		["FloBarFIRE"] = { "LEFT", "FloBarEARTH", "RIGHT", 3, 0 },
		["FloBarWATER"] = { "TOPLEFT", "FloBarEARTH", "BOTTOMLEFT", 0, 0 },
		["FloBarAIR"] = { "LEFT", "FloBarWATER", "RIGHT", 3, 0 },
		["FloBarCALL"] = { "RIGHT", "FloBarEARTH", "LEFT", -3, 0 },
	},
	["4rows"] = { label = FLO_TOTEM_4ROWS, offset = 3,
		["FloBarFIRE"] = { "TOPLEFT", "FloBarEARTH", "BOTTOMLEFT", 0, 0 },
		["FloBarWATER"] = { "TOPLEFT", "FloBarFIRE", "BOTTOMLEFT", 0, 0 },
		["FloBarAIR"] = { "TOPLEFT", "FloBarWATER", "BOTTOMLEFT", 0, 0 },
		["FloBarCALL"] = { "RIGHT", "FloBarEARTH", "LEFT", -3, 0 },
	},
	["2rows-reverse"] = { label = FLO_TOTEM_2ROWS_REVERSE, offset = 0,
		["FloBarFIRE"] = { "LEFT", "FloBarEARTH", "RIGHT", 3, 0 },
		["FloBarWATER"] = { "BOTTOMLEFT", "FloBarEARTH", "TOPLEFT", 0, 0 },
		["FloBarAIR"] = { "LEFT", "FloBarWATER", "RIGHT", 3, 0 },
		["FloBarCALL"] = { "RIGHT", "FloBarEARTH", "LEFT", -3, 0 },
	},
	["4rows-reverse"] = { label = FLO_TOTEM_4ROWS_REVERSE, offset = 0,
		["FloBarFIRE"] = { "BOTTOMLEFT", "FloBarEARTH", "TOPLEFT", 0, 0 },
		["FloBarWATER"] = { "BOTTOMLEFT", "FloBarFIRE", "TOPLEFT", 0, 0 },
		["FloBarAIR"] = { "BOTTOMLEFT", "FloBarWATER", "TOPLEFT", 0, 0 },
		["FloBarCALL"] = { "RIGHT", "FloBarEARTH", "LEFT", -3, 0 },
	},
}
FLO_TOTEM_LAYOUTS_ORDER = {
	"1row",
	"2rows",
	"4rows",
	"2rows-reverse",
	"4rows-reverse"
}
