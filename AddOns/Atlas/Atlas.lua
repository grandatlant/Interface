--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005-2010 Dan Gilbert <dan.b.gilbert@gmail.com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

--Atlas, an instance map browser
--Author: Dan Gilbert
--Email: loglow@gmail.com
--AIM: dan5981



local Atlas_DebugMode = false;
local function debug(info)
	if ( Atlas_DebugMode ) then
		DEFAULT_CHAT_FRAME:AddMessage("[Atlas] "..info);
	end
end



ATLAS_VERSION = GetAddOnMetadata("Atlas", "Version");
ATLAS_OLDEST_VERSION_SAME_SETTINGS = "1.16.1";

--all in one place now
ATLAS_DROPDOWNS = {};
ATLAS_INST_ENT_DROPDOWN = {};

ATLAS_NUM_LINES = 24;
ATLAS_CUR_LINES = 0;
ATLAS_SCROLL_LIST = {};

ATLAS_DATA = {};
ATLAS_SEARCH_METHOD = nil;

local DefaultAtlasOptions = {
	["AtlasVersion"] = ATLAS_OLDEST_VERSION_SAME_SETTINGS;
	["AtlasZone"] = 1;
	["AtlasAlpha"] = 1.0;
	["AtlasLocked"] = false;
	["AtlasAutoSelect"] = false;
	["AtlasButtonPosition"] = 356;
	["AtlasButtonRadius"] = 78;
	["AtlasButtonShown"] = true;
	["AtlasRightClick"] = false;
	["AtlasType"] = 1;
	["AtlasAcronyms"] = true;
	["AtlasScale"] = 1.0;
	["AtlasClamped"] = true;
	["AtlasSortBy"] = 1;
	["AtlasCtrl"] = false;
};

--yes, the following two tables are redundant, but they're both here in case there's ever more than one entrance map for an instance

--entrance maps to instance maps
Atlas_EntToInstMatches = {
	["AuchindounEnt"] =				{"AuchManaTombs","AuchAuchenaiCrypts","AuchSethekkHalls","AuchShadowLabyrinth"};
	["BlackfathomDeepsEnt"] =		{"BlackfathomDeeps"};
	["BlackrockSpireEnt"] =			{"BlackrockSpireLower","BlackrockSpireUpper","BlackwingLair","BlackrockDepths","MoltenCore"};
	["CoilfangReservoirEnt"] =		{"CFRTheSlavePens","CFRTheUnderbog","CFRTheSteamvault","CFRSerpentshrineCavern"};
	["GnomereganEnt"] =				{"Gnomeregan"};
	["MaraudonEnt"] =				{"Maraudon"};
	["TheDeadminesEnt"] =			{"TheDeadmines"};
	["TheSunkenTempleEnt"] =		{"TheSunkenTemple"};
	["UldamanEnt"] =				{"Uldaman"};
	["WailingCavernsEnt"] =			{"WailingCaverns"};
	["DireMaulEnt"] =				{"DireMaulEast","DireMaulNorth","DireMaulWest"};
	["CoTEnt"] =					{"CoTHyjal","CoTBlackMorass","CoTOldHillsbrad","CoTOldStratholme"};
	["KarazhanEnt"] =				{"KarazhanStart","KarazhanEnd"};
	["SMEnt"] =						{"SMArmory","SMLibrary","SMCathedral","SMGraveyard"};
};

--instance maps to entrance maps
Atlas_InstToEntMatches = {
	["AuchManaTombs"] =				{"AuchindounEnt"};
	["AuchAuchenaiCrypts"] =		{"AuchindounEnt"};
	["AuchSethekkHalls"] =			{"AuchindounEnt"};
	["AuchShadowLabyrinth"] =		{"AuchindounEnt"};
	["BlackfathomDeeps"] =			{"BlackfathomDeepsEnt"};
	["BlackrockSpireLower"] =		{"BlackrockSpireEnt"};
	["BlackrockSpireUpper"] =		{"BlackrockSpireEnt"};
	["BlackwingLair"] =				{"BlackrockSpireEnt"};
	["BlackrockDepths"] =			{"BlackrockSpireEnt"};
	["MoltenCore"] =				{"BlackrockSpireEnt"};
	["CFRTheSlavePens"] =			{"CoilfangReservoirEnt"};
	["CFRTheUnderbog"] =			{"CoilfangReservoirEnt"};
	["CFRTheSteamvault"] =			{"CoilfangReservoirEnt"};
	["CFRSerpentshrineCavern"] =	{"CoilfangReservoirEnt"};
	["Gnomeregan"] =				{"GnomereganEnt"};
	["Maraudon"] =					{"MaraudonEnt"};
	["TheDeadmines"] =				{"TheDeadminesEnt"};
	["TheSunkenTemple"] =			{"TheSunkenTempleEnt"};
	["Uldaman"] =					{"UldamanEnt"};
	["WailingCaverns"] =			{"WailingCavernsEnt"};
	["DireMaulEast"] =				{"DireMaulEnt"};
	["DireMaulNorth"] =				{"DireMaulEnt"};
	["DireMaulWest"] =				{"DireMaulEnt"};
	["CoTHyjal"] =					{"CoTEnt"};
	["CoTBlackMorass"] =			{"CoTEnt"};
	["CoTOldHillsbrad"] =			{"CoTEnt"};
	["CoTOldStratholme"] =			{"CoTEnt"};
	["KarazhanStart"] =				{"KarazhanEnt"};
	["KarazhanEnd"] =				{"KarazhanEnt"};
	["SMArmory"] =					{"SMEnt"};
	["SMLibrary"] =					{"SMEnt"};
	["SMCathedral"] =				{"SMEnt"};
	["SMGraveyard"] =				{"SMEnt"};
};

--Links maps together that are part of the same instance
Atlas_SubZoneAssoc = {
	["BlackTempleStart"] =			"Black Temple";
	["BlackTempleBasement"] =		"Black Temple";
	["BlackTempleTop"] =			"Black Temple";
	["KarazhanStart"] =				"Karazhan";
	["KarazhanEnd"] =				"Karazhan";
	["KarazhanEnt"] =				"Karazhan";
	["DireMaulNorth"] =				"Dire Maul";
	["DireMaulEast"] =				"Dire Maul";
	["DireMaulWest"] =				"Dire Maul";
	["DireMaulEnt"] =				"Dire Maul";
	["BlackrockSpireLower"] =		"Blackrock Spire";
	["BlackrockSpireUpper"] =		"Blackrock Spire";
	["BlackrockSpireEnt"] =			"Blackrock Spire";
	["SMGraveyard"] =				"Scarlet Monastery";
	["SMLibrary"] =					"Scarlet Monastery";
	["SMArmory"] =					"Scarlet Monastery";
	["SMCathedral"] =				"Scarlet Monastery";
	["SMEnt"] =						"Scarlet Monastery";
	["IcecrownCitadelA"] =			"Icecrown Citadel";
	["IcecrownCitadelB"] =			"Icecrown Citadel";
	["IcecrownCitadelC"] =			"Icecrown Citadel";
};

--Default map to auto-select to when no SubZone data is available
Atlas_AssocDefaults = {
	["Black Temple"] =				"BlackTempleStart";
	["Karazhan"] =					"KarazhanStart";
	["Dire Maul"] =					"DireMaulNorth";
	["Blackrock Spire"] =			"BlackrockSpireLower";
	["Scarlet Monastery"] =			"SMEnt";
	["Icecrown Citadel"] =			"IcecrownCitadelA";
};

--Links SubZone values with specific instance maps
Atlas_SubZoneData = {
	["Karabor Sewers"] =			"BlackTempleStart";
	["Illidari Training Grounds"] =	"BlackTempleStart";
	["The Refectory"] =				"BlackTempleStart";
	["Sanctuary of Shadow"] =		"BlackTempleStart";
	["Gorefiend's Vigil"] =			"BlackTempleBasement";
	["Halls of Anguish"] =			"BlackTempleBasement";
	["Shrine of Lost Souls"] =		"BlackTempleBasement";
	["Den of Mortal Delights"] =	"BlackTempleTop";
	["Chamber of Command"] =		"BlackTempleTop";
	["Grand Promenade"] =			"BlackTempleTop";
	["Temple Summit"] =				"BlackTempleTop";
	["The Gatehouse"] =				"KarazhanStart";
	["Livery Stables"] =			"KarazhanStart";
	["The Guardhouse"] =			"KarazhanStart";
	["The Scullery"] =				"KarazhanStart";
	["Servants' Quarters"] =		"KarazhanStart";
	["The Grand Ballroom"] =		"KarazhanStart";
	["The Banquet Hall"] =			"KarazhanStart";
	["The Guest Chambers"] =		"KarazhanStart";
	["The Opera Hall"] =			"KarazhanStart";
	["The Broken Stair"] =			"KarazhanStart";
	["Master's Terrace"] =			"KarazhanStart";
	["The Menagerie"] =				"KarazhanEnd";
	["Guardian's Library"] =		"KarazhanEnd";
	["The Repository"] =			"KarazhanEnd";
	["The Celestial Watch"] =		"KarazhanEnd";
	["Gamesman's Hall"] =			"KarazhanEnd";
	["Medivh's Chambers"] =			"KarazhanEnd";
	["Master's Terrace"] =			"KarazhanEnd";
	["Netherspace"] =				"KarazhanEnd";
	["Halls of Destruction"] =		"DireMaulNorth";
	["Gordok's Seat"] =				"DireMaulNorth";
	["Warpwood Quarter"] =			"DireMaulEast";
	["The Hidden Reach"] =			"DireMaulEast";
	["The Conservatory"] =			"DireMaulEast";
	["The Shrine of Eldretharr"] =	"DireMaulEast";
	["Capital Gardens"] =			"DireMaulWest";
	["Court of the Highborne"] =	"DireMaulWest";
	["Prison of Immol'thar"] =		"DireMaulWest";
	["The Athenaeum"] =				"DireMaulWest";
	["Hordemar City"] =				"BlackrockSpireLower";
	["Mok'Doom"] =					"BlackrockSpireLower";
	["Tazz'Alaor"] =				"BlackrockSpireLower";
	["Skitterweb Tunnels"] =		"BlackrockSpireLower";
	["The Storehouse"] =			"BlackrockSpireLower";
	["Chamber of Battle"] =			"BlackrockSpireLower";
	["Dragonspire Hall"] =			"BlackrockSpireUpper";
	["Hall of Binding"] =			"BlackrockSpireUpper";
	["The Rookery"] =				"BlackrockSpireUpper";
	["Hall of Blackhand"] =			"BlackrockSpireUpper";
	["Blackrock Stadium"] =			"BlackrockSpireUpper";
	["The Furnace"] =				"BlackrockSpireUpper";
	["Hordemar City"] =				"BlackrockSpireUpper";
	["Spire Throne"] =				"BlackrockSpireUpper";
	["Chamber of Atonement"] =		"SMGraveyard";
	["Forlorn Cloister"] =			"SMGraveyard";
	["Honor's Tomb"] =				"SMGraveyard";
	["Huntsman's Cloister"] =		"SMLibrary";
	["Gallery of Treasures"] =		"SMLibrary";
	["Athenaeum"] =					"SMLibrary";
	["Training Grounds"] =			"SMArmory";
	["Footman's Armory"] =			"SMArmory";
	["Crusader's Armory"] =			"SMArmory";
	["Hall of Champions"] =			"SMArmory";
	["Chapel Gardens"] =			"SMCathedral";
	["Crusader's Chapel"] =			"SMCathedral";
	["The Grand Vestibule"] =		"SMEnt";
};

--Maps to auto-select to from outdoor zones.
--Duplicates are commented out. Fuck, I hate auto-select.
Atlas_OutdoorZoneToAtlas = {
	["Ashenvale"] =					"BlackfathomDeepsEnt";
	["Badlands"] =					"UldamanEnt";
	["Blackrock Mountain"] =		"BlackrockSpireEnt";
	["Burning Steppes"] =			"BlackrockSpireEnt";
	["Deadwind Pass"] =				"KarazhanEnt";
	["Desolace"] =					"MaraudonEnt";
	["Dun Morogh"] =				"GnomereganEnt";
	["Feralas"] =					"DireMaulEnt";
	["Searing Gorge"] =				"BlackrockSpireEnt";
	["Swamp of Sorrows"] =			"TheSunkenTempleEnt";
	["Tanaris"] =					"CoTEnt";
	--["Tanaris"] =					"ZulFarrak";
	["Terokkar Forest"] =			"AuchindounEnt";
	["The Barrens"] =				"WailingCavernsEnt";
	--["The Barrens"] =				"RazorfenKraul";
	--["The Barrens"] =				"RazorfenDowns";
	["Tirisfal Glades"]	=			"SMEnt";
	["Westfall"] =					"TheDeadminesEnt";
	["Zangarmarsh"] =				"CoilfangReservoirEnt";
	["Orgrimmar"] =					"RagefireChasm";
	["Dustwallow Marsh"] =			"OnyxiasLair";
	["Silithus"] =					"TheTempleofAhnQiraj";
	--["Silithus"] =				"TheRuinsofAhnQiraj";
	["Western Plaguelands"] =		"Scholomance";
	["Silverpine Forest"] =			"ShadowfangKeep";
	["Eastern Plaguelands"] =		"Stratholme";
	--["Eastern Plaguelands"] =		"Naxxramas";
	["Stormwind City"] =			"TheStockade";
	["Stranglethorn Vale"] =		"ZulGurub";
	["Ghostlands"] =				"ZulAman";
	["Isle of Quel'Danas"] =		"MagistersTerrace";
	--["Isle of Quel'Danas"] =		"SunwellPlateau";
	["Hellfire Peninsula"] =		"HCHellfireRamparts";
	--["Hellfire Peninsula"] =		"HCBloodFurnace";
	--["Hellfire Peninsula"] =		"HCTheShatteredHalls";
	--["Hellfire Peninsula"] =		"HCMagtheridonsLair";
	["Zangarmarsh"] =				"CFRTheSlavePens";
	--["Zangarmarsh"] =				"CFRTheUnderbog";
	--["Zangarmarsh"] =				"CFRTheSteamvault";
	--["Zangarmarsh"] =				"CFRSerpentshrineCavern";
	["Netherstorm"] =				"TempestKeepMechanar";
	--["Netherstorm"] =				"TempestKeepBotanica";
	--["Netherstorm"] =				"TempestKeepArcatraz";
	--["Netherstorm"] =				"TempestKeepTheEye";
	["Blade's Edge Mountains"] =	"GruulsLair";
	["Shadowmoon Valley"] =			"BlackTempleStart";
	--["Shadowmoon Valley"] =		"BlackTempleBasement";
	--["Shadowmoon Valley"] =		"BlackTempleTop";
	["Icecrown"] =					"IcecrownCitadelA";
};

function Atlas_FreshOptions()
	AtlasOptions = CloneTable(DefaultAtlasOptions);
end

--Code by Grayhoof (SCT)
function CloneTable(t)				-- return a copy of the table t
	local new = {};					-- create a new table
	local i, v = next(t, nil);		-- i is an index of t, v = t[i]
	while i do
		if type(v)=="table" then 
			v=CloneTable(v);
		end 
		new[i] = v;
		i, v = next(t, i);			-- get next index
	end
	return new;
end

ATLAS_PLUGINS = {};
ATLAS_PLUGIN_DATA = {};
local GREN = "|cff66cc33";

Atlas_MapTypes = {};
function Atlas_RegisterPlugin(name, myCategory, myData)
	table.insert(ATLAS_PLUGINS, name);
	local i = getn(Atlas_MapTypes) + 1;
	Atlas_MapTypes[i] = GREN..myCategory;
	
	for k,v in pairs(myData) do
		AtlasMaps[k] = v;
	end
	
	table.insert(ATLAS_PLUGIN_DATA, myData);
	
	if ( ATLAS_OLD_TYPE and ATLAS_OLD_TYPE <= getn(AtlasMaps) ) then
		AtlasOptions.AtlasType = ATLAS_OLD_TYPE;
		AtlasOptions.AtlasZone = ATLAS_OLD_ZONE;
	end
	
	Atlas_PopulateDropdowns();
	Atlas_Refresh();
end

function Atlas_Search(text)
	local data = nil;

	if (ATLAS_SEARCH_METHOD == nil) then
		data = ATLAS_DATA;
	else
		data = ATLAS_SEARCH_METHOD(ATLAS_DATA, text);
	end

	--populate the scroll frame entries list, the update func will do the rest
	local i = 1;
	while ( data[i] ~= nil ) do
		ATLAS_SCROLL_LIST[i] = data[i][1];
		i = i + 1;
	end

	ATLAS_CUR_LINES = i - 1;
end

function Atlas_SearchAndRefresh(text)
	Atlas_Search(text);
	AtlasScrollBar_Update();
end

local function Process_Deprecated()

	--list of deprecated Atlas modules.
	--first value is the name
	--second value is the version
	--nil version means NO version will EVER be loaded!
	--non-nil version mean ONLY IT OR NEWER versions will be laoded!
	local Deprecated_List = {
		{ "Atlas_Entrances", nil }, --entrances were rolled into core addon
		{ "Atlas_FlightPaths", nil }, --renamed to Atlas_Transportation
		{ "AtlasEntrances", nil }, --old name for entrances module
		{ "AtlasFlightPaths", nil }, --old name for flight paths module
		{ "AtlasDungeonLocs", nil }, --old name for dungeon location module
		{ "AtlasOutdoorRaids", nil }, --old name for outdoor raids module
		{ "AtlasBattlegrounds", nil }, --old name for battlegrounds module
		
		--most recent (working) versions of known modules at time of release
		{ "AtlasWorld", "2.4.3" },
		{ "AtlasQuest", "4.3.6" }, --updated October 7, 2009
		{ "AtlasMajorCities", "v1.5a" }, --updated October 7, 2009
		{ "AtlasLoot", "5.08.04" }, --updated October 7, 2009
	};

	--check for outdated modules, build a list of them, then disable them and tell the player.
	local OldList = {};
	for k,v in pairs(Deprecated_List) do
		local enabled, loadable = select(4, GetAddOnInfo(v[1]));
		if enabled and loadable then
			local oldVersion = true;			
			if v[2] ~= nil and GetAddOnMetadata(v[1], "Version") >= v[2] then
				oldVersion = false;
			end
			if oldVersion then
				table.insert(OldList, v[1]);
			end
		end
	end
	if table.getn(OldList) > 0 then
		local textList = "";
		for k,v in pairs(OldList) do
			textList = textList.."\n"..v..", "..GetAddOnMetadata(v, "Version");
			DisableAddOn(v);
		end
		StaticPopupDialogs["ATLAS_OLD_MODULES"] = {
			text = ATLAS_DEP_MSG1.."\n"..ATLAS_DEP_MSG2.."\n"..ATLAS_DEP_MSG3.."\n|cff6666ff"..textList.."|r";
			button1 = ATLAS_DEP_OK,
			timeout = 0,
			exclusive = 1,
			whileDead = 1,
		}
		StaticPopup_Show("ATLAS_OLD_MODULES")
	end
end

--Called when the Atlas frame is first loaded
--We CANNOT assume that data in other files is available yet!
function Atlas_OnLoad()

	Process_Deprecated();

	--Register the Atlas frame for the following events
	this:RegisterEvent("PLAYER_LOGIN");
	this:RegisterEvent("ADDON_LOADED");

	--Allows Atlas to be closed with the Escape key
	tinsert(UISpecialFrames, "AtlasFrame");
	
	--Dragging involves some special registration
	AtlasFrame:RegisterForDrag("LeftButton");
	
	--Setting up slash commands involves referencing some strage auto-generated variables
	SLASH_ATLAS1 = ATLAS_SLASH;
	SlashCmdList["ATLAS"] = Atlas_SlashCommand;
	

end


--Removal of articles in map names (for proper alphabetic sorting)
--For example: "The Deadmines" will become "Deadmines"
--Thus it will be sorted under D and not under T
local function Atlas_SanitizeName(text)
   text = string.lower(text);
   if (AtlasSortIgnore) then
	   for _,v in pairs(AtlasSortIgnore) do
		   local match; 
           if ( string.gmatch ) then 
                match = string.gmatch(text, v)();
           else 
                match = string.gfind(text, v)(); 
           end
		   if (match) and ((string.len(text) - string.len(match)) <= 4) then
			   return match;
		   end
	   end
   end
   return text;
end




--Comparator function for alphabetic sorting of maps
--yey, one function for everything
local function Atlas_SortZonesAlpha(a, b)
	local aa = Atlas_SanitizeName(AtlasMaps[a].ZoneName[1]);
	local bb = Atlas_SanitizeName(AtlasMaps[b].ZoneName[1]);
	return aa < bb;
end



--Main Atlas event handler
function Atlas_OnEvent()

	if (event == "ADDON_LOADED" and arg1 == "Atlas") then
		Atlas_Init();
	end
	
end

function Atlas_PopulateDropdowns()
	local i = 1;
	local catName = Atlas_DropDownLayouts_Order[AtlasOptions.AtlasSortBy];
	local subcatOrder = Atlas_DropDownLayouts_Order[catName];
	for n = 1, getn(subcatOrder), 1 do
		local subcatItems = Atlas_DropDownLayouts[catName][subcatOrder[n]];
		
		ATLAS_DROPDOWNS[n] = {};
		
		for k,v in pairs(subcatItems) do
			table.insert(ATLAS_DROPDOWNS[n], v);
		end
		
		table.sort(ATLAS_DROPDOWNS[n], Atlas_SortZonesAlpha);
		
		i = n + 1;
	end
	
	if ( ATLAS_PLUGIN_DATA ) then
		for ka,va in pairs(ATLAS_PLUGIN_DATA) do
		
			ATLAS_DROPDOWNS[i] = {};
			
			for kb,vb in pairs(va) do
				if ( type(vb) == "table" ) then
					table.insert(ATLAS_DROPDOWNS[i], kb);
				end
			end
			
			table.sort(ATLAS_DROPDOWNS[i], Atlas_SortZonesAlpha);
			
			i = i + 1;
			
		end	
	end
end


ATLAS_OLD_TYPE = false;
ATLAS_OLD_ZONE = false;

--Initializes everything relating to saved variables and data in other lua files
--This should be called ONLY when we're sure our variables are in memory
function Atlas_Init()

	--fix for certain UI elements that appear on top of the Atlas window
	--[[
	MultiBarBottomLeft:SetFrameStrata("MEDIUM");
	MultiBarBottomRight:SetFrameStrata("MEDIUM");
	MultiBarLeft:SetFrameStrata("MEDIUM");
	MultiBarRight:SetFrameStrata("MEDIUM");
	MainMenuBarOverlayFrame:SetFrameStrata("LOW");
	--]]

	--make the Atlas window go all the way to the edge of the screen, exactly
	AtlasFrame:SetClampRectInsets(12, 0, -12, 0);

	--init saved vars for a new install
	if ( AtlasOptions == nil ) then
		Atlas_FreshOptions();
	end
	
	--saved options version check
	if ( AtlasOptions["AtlasVersion"] ~= ATLAS_OLDEST_VERSION_SAME_SETTINGS ) then
		Atlas_FreshOptions();
	end
	
	--populate the dropdown lists...yeeeah this is so much nicer!
	Atlas_PopulateDropdowns();
	
	
	if ( ATLAS_DROPDOWNS[AtlasOptions.AtlasType] == nil ) then
		ATLAS_OLD_TYPE = AtlasOptions.AtlasType;
		ATLAS_OLD_ZONE = AtlasOptions.AtlasZone;
		AtlasOptions.AtlasType = 1;
		AtlasOptions.AtlasZone = 1;
	end
	
	--Now that saved variables have been loaded, update everything accordingly
	Atlas_Refresh();
	Atlas_UpdateLock();
	Atlas_UpdateAlpha();
	AtlasFrame:SetClampedToScreen(AtlasOptions.AtlasClamped);
	AtlasButton_UpdatePosition();
	AtlasOptions_Init();
	
	--Cosmos integration
	if(EarthFeature_AddButton) then
		EarthFeature_AddButton(
		{
			id = ATLAS_TITLE;
			name = ATLAS_TITLE;
			subtext = ATLAS_SUBTITLE;
			tooltip = ATLAS_DESC;
			icon = "Interface\\AddOns\\Atlas\\Images\\AtlasIcon";
			callback = Atlas_Toggle;
			test = nil;
		}
	);
	elseif(Cosmos_RegisterButton) then
		Cosmos_RegisterButton(
			ATLAS_TITLE,
			ATLAS_SUBTITLE,
			ATLAS_DESC,
			"Interface\\AddOns\\Atlas\\Images\\AtlasIcon",
			Atlas_Toggle
		);
	end
	
	--CTMod integration
	if(CT_RegisterMod) then
		CT_RegisterMod(
			ATLAS_TITLE,
			ATLAS_SUBTITLE,
			5,
			"Interface\\AddOns\\Atlas\\Images\\AtlasIcon",
			ATLAS_DESC,
			"switch",
			"",
			Atlas_Toggle
		);
	end
	
	--Make an LDB object
	LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Atlas", {
		type = "launcher",
		text = "Atlas",
		OnClick = function(_, msg)
			if msg == "LeftButton" then
				Atlas_Toggle();
			elseif msg == "RightButton" then
				AtlasOptions_Toggle();
			end
		end,
		icon = "Interface\\WorldMap\\WorldMap-Icon",
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine("|cffffffff"..ATLAS_TITLE)
			tooltip:AddLine(ATLAS_LDB_HINT)
		end,
	})
	
end

--Simple function to toggle the Atlas frame's lock status and update it's appearance
function Atlas_ToggleLock()
	if(AtlasOptions.AtlasLocked) then
		AtlasOptions.AtlasLocked = false;
		Atlas_UpdateLock();
	else
		AtlasOptions.AtlasLocked = true;
		Atlas_UpdateLock();
	end
end

--Updates the appearance of the lock button based on the status of AtlasLocked
function Atlas_UpdateLock()
	if(AtlasOptions.AtlasLocked) then
		AtlasLockNorm:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Locked-Up");
		AtlasLockPush:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Locked-Down");
	else
		AtlasLockNorm:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Unlocked-Up");
		AtlasLockPush:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Unlocked-Down");
	end
end

--Begin moving the Atlas frame if it's unlocked
function Atlas_StartMoving()
	if(not AtlasOptions.AtlasLocked) then
		AtlasFrame:StartMoving();
	end
end

--Parses slash commands
--If an unrecognized command is given, toggle Atlas
function Atlas_SlashCommand(msg)
	if(msg == ATLAS_SLASH_OPTIONS) then
		AtlasOptions_Toggle();
	else
		Atlas_Toggle();
	end
end

--Sets the transparency of the Atlas frame based on AtlasAlpha
function Atlas_UpdateAlpha()
	AtlasFrame:SetAlpha(AtlasOptions.AtlasAlpha);
end

--Sets the scale of the Atlas frame based on AtlasScale
function Atlas_UpdateScale()
	AtlasFrame:SetScale(AtlasOptions.AtlasScale);
end

--Simple function to toggle the visibility of the Atlas frame
function Atlas_Toggle()
	if(AtlasFrame:IsVisible()) then
		HideUIPanel(AtlasFrame);
	else
		ShowUIPanel(AtlasFrame);
	end
end

--Refreshes the Atlas frame, usually because a new map needs to be displayed
--The zoneID variable represents the internal name used for each map
--Also responsible for updating all the text when a map is changed
function Atlas_Refresh()
	
	local zoneID = ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone];
	local data = AtlasMaps;
	local base = data[zoneID];

	AtlasMap:ClearAllPoints();
	AtlasMap:SetWidth(512);
	AtlasMap:SetHeight(512);
	AtlasMap:SetPoint("TOPLEFT", "AtlasFrame", "TOPLEFT", 18, -84);
	local builtIn = AtlasMap:SetTexture("Interface\\AddOns\\Atlas\\Images\\Maps\\"..zoneID);
	
	if ( not builtIn ) then
		for k,v in pairs(ATLAS_PLUGINS) do
			if ( AtlasMap:SetTexture("Interface\\AddOns\\"..v.."\\Images\\"..zoneID) ) then
				break;
			end
		end
	end
	
	local tName = base.ZoneName[1];
	if ( AtlasOptions.AtlasAcronyms and base.Acronym ~= nil) then
		local _RED = "|cffcc6666";
		tName = tName.._RED.." ["..base.Acronym.."]";
	end
	AtlasText_ZoneName_Text:SetText(tName);
	
	local tLoc = "";
	local tLR = "";
	local tML = "";
	local tPL = "";
	if ( base.Location ) then
		tLoc = ATLAS_STRING_LOCATION..": "..base.Location[1];
	end
	if ( base.LevelRange ) then
		tLR = ATLAS_STRING_LEVELRANGE..": "..base.LevelRange;
	end
	if ( base.MinLevel ) then
		tML = ATLAS_STRING_MINLEVEL..": "..base.MinLevel;
	end
	if ( base.PlayerLimit ) then
		tPL = ATLAS_STRING_PLAYERLIMIT..": "..base.PlayerLimit;
	end
	AtlasText_Location_Text:SetText(tLoc);
	AtlasText_LevelRange_Text:SetText(tLR);
	AtlasText_MinLevel_Text:SetText(tML);
	AtlasText_PlayerLimit_Text:SetText(tPL);

	ATLAS_DATA = base;
	ATLAS_SEARCH_METHOD = data.Search;
	
	if ( data.Search == nil ) then
		ATLAS_SEARCH_METHOD = AtlasSimpleSearch;
	end
	
	if ( data.Search ~= false ) then
		AtlasSearchEditBox:Show();
		AtlasNoSearch:Hide();
	else
		AtlasSearchEditBox:Hide();
		AtlasNoSearch:Show();
		ATLAS_SEARCH_METHOD = nil;
	end

	--populate the scroll frame entries list, the update func will do the rest
	Atlas_Search("");
	AtlasSearchEditBox:SetText("");
	AtlasSearchEditBox:ClearFocus();

	--create and align any new entry buttons that we need
	for i=1,ATLAS_CUR_LINES do
		if ( not getglobal("AtlasEntry"..i) ) then
			local f = CreateFrame("Button", "AtlasEntry"..i, AtlasFrame, "AtlasEntryTemplate");
			if i==1 then
				f:SetPoint("TOPLEFT", "AtlasScrollBar", "TOPLEFT", 16, -2);
			else
				f:SetPoint("TOPLEFT", "AtlasEntry"..(i-1), "BOTTOMLEFT");
			end
		end
	end
	
	AtlasScrollBar_Update();
	
	
	
	--deal with the switch to entrance/instance button here
	--only display if appropriat
	
	--see if we should display the button or not, and decide what it should say
	local matchFound = {nil};
	local sayEntrance = nil;
	for k,v in pairs(Atlas_EntToInstMatches) do
		if ( k == zoneID ) then
			matchFound = v;
			sayEntrance = false;
		end
	end
	if ( not matchFound[1] ) then
		for k,v in pairs(Atlas_InstToEntMatches) do
			if ( k == zoneID ) then
				matchFound = v;
				sayEntrance = true;
			end
		end
	end
	
	--set the button's text, populate the dropdown menu, and show or hide the button
	if ( matchFound[1] ~= nil ) then
		ATLAS_INST_ENT_DROPDOWN = {};
		for k,v in pairs(matchFound) do
			table.insert(ATLAS_INST_ENT_DROPDOWN, v);
		end
		table.sort(ATLAS_INST_ENT_DROPDOWN, AtlasSwitchDD_Sort);
		if ( sayEntrance ) then
			AtlasSwitchButton:SetText(ATLAS_ENTRANCE_BUTTON);
		else
			AtlasSwitchButton:SetText(ATLAS_INSTANCE_BUTTON);
		end
		AtlasSwitchButton:Show();
		UIDropDownMenu_Initialize(AtlasSwitchDD, AtlasSwitchDD_OnLoad);
	else
		AtlasSwitchButton:Hide();
	end
	
	if ( TitanPanelButton_UpdateButton ) then
		TitanPanelButton_UpdateButton("Atlas");
	end
	
end


--when the switch button is clicked
--we can basically assume that there's a match
--find it, set it, then update menus and the maps
function AtlasSwitchButton_OnClick()
	local zoneID = ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone];
	
	if ( getn(ATLAS_INST_ENT_DROPDOWN) == 1 ) then
		--one link, so we can just go there right away
		AtlasSwitchDD_Set(1);
	else
		--more than one link, so it's dropdown menu time
		ToggleDropDownMenu(1, nil, AtlasSwitchDD, "AtlasSwitchButton", 0, 0);
	end
end

function AtlasSwitchDD_OnLoad()
	local info, i;
	for k,v in pairs(ATLAS_INST_ENT_DROPDOWN) do
		info = {
			text = AtlasMaps[v].ZoneName[1];
			func = AtlasSwitchDD_OnClick;
		};
		UIDropDownMenu_AddButton(info);
	end
end

function AtlasSwitchDD_OnClick()
	AtlasSwitchDD_Set(this:GetID());
end

function AtlasSwitchDD_Set(index)
	for k,v in pairs(ATLAS_DROPDOWNS) do
		for k2,v2 in pairs(v) do
			if ( v2 == ATLAS_INST_ENT_DROPDOWN[index] ) then
				AtlasOptions.AtlasType = k;
				AtlasOptions.AtlasZone = k2;
			end
		end
	end
	AtlasFrameDropDownType_OnShow();
	AtlasFrameDropDown_OnShow();
	Atlas_Refresh();
end

function AtlasSwitchDD_Sort(a, b)
	local aa = AtlasMaps[a].ZoneName[1];
	local bb = AtlasMaps[b].ZoneName[1];
	return aa < bb;
end



--Function used to initialize the map type dropdown menu
--Cycle through Atlas_MapTypes to populate the dropdown
function AtlasFrameDropDownType_Initialize()

	local info, i;
	local catName = Atlas_DropDownLayouts_Order[AtlasOptions.AtlasSortBy];
	local subcatOrder = Atlas_DropDownLayouts_Order[catName];
	for i = 1, getn(subcatOrder), 1 do
		info = {
			text = subcatOrder[i];
			func = AtlasFrameDropDownType_OnClick;
		};
		UIDropDownMenu_AddButton(info);
	end
	for i = 1, getn(Atlas_MapTypes), 1 do
		info = {
			text = Atlas_MapTypes[i];
			func = AtlasFrameDropDownType_OnClick;
		};
		UIDropDownMenu_AddButton(info);
	end
	
end

--Called whenever the map type dropdown menu is shown
function AtlasFrameDropDownType_OnShow()
	UIDropDownMenu_Initialize(AtlasFrameDropDownType, AtlasFrameDropDownType_Initialize);
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDownType, AtlasOptions.AtlasType);
	UIDropDownMenu_SetWidth(AtlasFrameDropDownType, 190);
end

--Called whenever an item in the map type dropdown menu is clicked
--Sets the main dropdown menu contents to reflect the category of map selected
function AtlasFrameDropDownType_OnClick()
	local thisID = this:GetID();
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDownType, thisID);
	AtlasOptions.AtlasType = thisID;
	AtlasOptions.AtlasZone = 1;
	AtlasFrameDropDown_OnShow();
	Atlas_Refresh();
end

--Function used to initialize the main dropdown menu
--Looks at the status of AtlasType to determine how to populate the list
function AtlasFrameDropDown_Initialize()

	local info;
	for k,v in pairs(ATLAS_DROPDOWNS[AtlasOptions.AtlasType]) do
		info = {
			text = AtlasMaps[v].ZoneName[1];
			func = AtlasFrameDropDown_OnClick;
		};
		UIDropDownMenu_AddButton(info);
	end

end

--Called whenever the main dropdown menu is shown
function AtlasFrameDropDown_OnShow()
	UIDropDownMenu_Initialize(AtlasFrameDropDown, AtlasFrameDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, AtlasOptions.AtlasZone);
	UIDropDownMenu_SetWidth(AtlasFrameDropDown, 190);
end

--Called whenever an item in the main dropdown menu is clicked
--Sets the newly selected map as current and refreshes the frame
function AtlasFrameDropDown_OnClick()
	i = this:GetID();
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, i);
	AtlasOptions.AtlasZone = i;
	Atlas_Refresh();
end

--Modifies the value of GetRealZoneText to account for some naming conventions
--Always use this function instead of GetRealZoneText within Atlas
function Atlas_GetFixedZoneText()
	local currentZone = GetRealZoneText();
	if (AtlasZoneSubstitutions[currentZone]) then
		return AtlasZoneSubstitutions[currentZone];
	end
	return currentZone;
end 

--Checks the player's current location against all Atlas maps
--If a match is found display that map right away
--update for Outland zones contributed by Drahcir
--3/23/08 now takes SubZones into account as well
function Atlas_AutoSelect()
	local currentZone = Atlas_GetFixedZoneText();
	local currentSubZone = GetSubZoneText();
	debug("Using auto-select to open the best map.");
	
	if ( Atlas_AssocDefaults[currentZone] ) then
		debug("You're in a zone where SubZone data is relevant.");
		if ( Atlas_SubZoneData[currentSubZone] ) then
			debug("There's data for your current SubZone.");
			for ka,va in pairs(ATLAS_DROPDOWNS) do
				for kb,vb in pairs(va) do         
					if ( Atlas_SubZoneData[currentSubZone] == vb ) then
						AtlasOptions.AtlasType = ka;
						AtlasOptions.AtlasZone = kb;
						Atlas_Refresh();
						debug("Map changed directly based on SubZone data.");
						return;
					end
				end
			end
		else
			debug("No applicable SubZone data exists.");
			if ( currentZone == Atlas_SubZoneAssoc[ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone]] ) then
				debug("You're in the same instance as the former map. Doing nothing.");
				return;
			else
				for ka,va in pairs(ATLAS_DROPDOWNS) do
					for kb,vb in pairs(va) do         
						if ( Atlas_AssocDefaults[currentZone] == vb ) then
							AtlasOptions.AtlasType = ka;
							AtlasOptions.AtlasZone = kb;
							Atlas_Refresh();
							debug("You just arrived here. Using the default map.");
							return;
						end
					end
				end
			end
		end
	else
		debug("SubZone data isn't relevant here.");
		if ( Atlas_OutdoorZoneToAtlas[currentZone] ) then
			debug("This world zone is associated with a map.");
			for ka,va in pairs(ATLAS_DROPDOWNS) do
				for kb,vb in pairs(va) do         
					if ( Atlas_OutdoorZoneToAtlas[currentZone] == vb ) then
						AtlasOptions.AtlasType = ka;
						AtlasOptions.AtlasZone = kb;
						Atlas_Refresh();
						debug("Map changed to the associated map.");
						return;
					end
				end
			end
		elseif ( Atlas_InstToEntMatches[ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone]] ) then
			for ka,va in pairs(Atlas_InstToEntMatches[ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone]]) do
				if ( currentZone == AtlasMaps[va].ZoneName[1] ) then
					debug("Instance/entrance pair found. Doing nothing.");
					return;
				end
			end
		elseif ( Atlas_EntToInstMatches[ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone]] ) then
			for ka,va in pairs(Atlas_EntToInstMatches[ATLAS_DROPDOWNS[AtlasOptions.AtlasType][AtlasOptions.AtlasZone]]) do
				if ( currentZone == AtlasMaps[va].ZoneName[1] ) then
					debug("Instance/entrance pair found. Doing nothing.");
					return;
				end
			end
		end
		debug("Searching through all maps for a ZoneName match.");
		for ka,va in pairs(ATLAS_DROPDOWNS) do
			for kb,vb in pairs(va) do         
				-- Compare the currentZone to the new substr of ZoneName
				if ( currentZone == strsub(AtlasMaps[vb].ZoneName[1], strlen(AtlasMaps[vb].ZoneName[1]) - strlen(currentZone) + 1) ) then
					AtlasOptions.AtlasType = ka;
					AtlasOptions.AtlasZone = kb;
					Atlas_Refresh();
					debug("Found a match. Map has been changed.");
					return;
				end
			end
		end
	end
	debug("Nothing changed because no match was found.");
end

--Called whenever the Atlas frame is displayed
function Atlas_OnShow()
	if(AtlasOptions.AtlasAutoSelect) then
		Atlas_AutoSelect();
	end

	--sneakiness
	AtlasFrameDropDownType_OnShow();
	AtlasFrameDropDown_OnShow();
end

--Code provided by tyroney
--Bugfix code by Cold
--Runs when the Atlas frame is clicked on
--RightButton closes Atlas and open the World Map if the RightClick option is turned on
function Atlas_OnClick()
	if ( arg1 == "RightButton" ) then
		if (AtlasOptions.AtlasRightClick) then
			Atlas_Toggle();
			ToggleFrame(WorldMapFrame);
		end
	end
end

function AtlasScrollBar_Update()
	GameTooltip:Hide();
	local line, lineplusoffset;
	FauxScrollFrame_Update(AtlasScrollBar,ATLAS_CUR_LINES,ATLAS_NUM_LINES,15);
	for line=1,ATLAS_NUM_LINES do
		lineplusoffset = line + FauxScrollFrame_GetOffset(AtlasScrollBar);
		if ( lineplusoffset <= ATLAS_CUR_LINES ) then
			getglobal("AtlasEntry"..line.."_Text"):SetText(ATLAS_SCROLL_LIST[lineplusoffset]);
			getglobal("AtlasEntry"..line):Show();
		elseif ( getglobal("AtlasEntry"..line) ) then
			getglobal("AtlasEntry"..line):Hide();
		end
	end
end

function AtlasSimpleSearch(data, text)
	local new = {};-- create a new table
	local i;
	local v;
	local n;
	
	local search_text = string.lower(text);
	search_text = search_text:gsub("([%^%$%(%)%%%.%[%]%+%-%?])", "%%%1");
	search_text = search_text:gsub("%*", ".*");
	local match;

	i, v = next(data, nil);-- i is an index of data, v = data[i]
	n = i;
	while i do
		if ( type(i) == "number" ) then
			if ( string.gmatch ) then 
				match = string.gmatch(string.lower(data[i][1]), search_text)();
			else 
				match = string.gfind(string.lower(data[i][1]), search_text)(); 
			end
			if ( match ) then
				new[n] = {};
				new[n][1] = data[i][1];
				n = n + 1;
			end
		end
		i, v = next(data, i);-- get next index
	end
	return new;
end

local function round(num, idp)
   local mult = 10 ^ (idp or 0);
   return math.floor(num * mult + 0.5) / mult;
end

function AtlasEntryTemplate_OnUpdate(self)
	if ( AtlasOptions.AtlasCtrl ) then
		if ( MouseIsOver(self) ) then
			if ( IsControlKeyDown() ) then
				if ( not GameTooltip:IsShown() ) then
					local str = _G[self:GetName().."_Text"]:GetText();
					if ( str ) then
						GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
						GameTooltip:SetBackdropBorderColor(0,0,0,0);
						GameTooltip:SetBackdropColor(0,0,0,1);
						local colorCheck = string.sub(str, 1, 4);
						if ( colorCheck == "|cff" ) then
							local color = string.sub(str, 1, 10);
							local stripped = strtrim(string.sub(str, 11));
							GameTooltip:SetText(color..stripped,1,1,1,1);
						else
							GameTooltip:SetText(str,1,1,1,1);
						end
					end
				end
			else
				GameTooltip:Hide();
			end
		end
	end
end
