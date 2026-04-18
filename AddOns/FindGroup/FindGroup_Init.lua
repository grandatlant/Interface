FGL={}
FGL.db={}
FGL.func={}
FGL.Interface = {}
FGL.SPACE_NAME= "FindGroup: link"
FGL.SPACE_VERSION = "3.0"
FGL.SPACE_BUILD = "2162"
FGL.Interface.Frame = FindGroupFrame
FGL.ChannelName = "FindGroupChannel"
function FGL.func:IsLoad() return 1 end
function FGL.func:Version() return SPACE_VERSION end
if not FGL.db.FGC then FGL.db.FGC={} end

--[[--------------------START DEFAULT PARAMETRS------------------]]--

FGL.db.defparam={
["findlistvalues"]={true,true,true,true},	-- bool false or true
["findpatches"]={true,true,true, true},		-- bool false or true
["createpatches"]={true,true,true, true},	-- bool false or true
["alarmpatches"]={true,true,true, true},	-- bool false or true
["needs"]={true,true,true},					-- bool false or true
["alarmlist"]={},							-- serious table
["msgforparty"]="inv", 			-- string max=80 symbols
["timeleft"]=60, 			-- seconds 15, 30, 45, 60, 75, 90
["framealpha"]=100, 		-- alpha percent 20 to 100
["framealphaback"]=100,		-- alpha percent 0 to 100
["framealphafon"]=0, 		-- alpha percent 0 to 100
["framescale"]=100, 		-- alpha percent 80 to 150
["linefadesec"]=2, 			-- alpha percent 0.5 to 5
["alarminst"]=1, 			-- table 1 to max of table
["defbackground"]=1,		-- table 1 to max of table
["alarmsound"]=23, 			-- table 1 to max of table
["alarmir"]=1, 				-- table 1 to max of table
["showstatus"]=1, 			-- trigger 1 or 0
["configstatus"]=0, 		-- trigger 1 or 0
["faststatus"]=0, 			-- trigger 1 or 0
["pinstatus"]=0, 			-- trigger 1 or 0
["raidcdstatus"]=1, 		-- trigger 1 or 0
["changebackdrop"]=1,		-- trigger 1 or 0
["closefindstatus"]=1, 		-- trigger 1 or 0
["iconstatus"]=0, 			-- trigger 1 or 0
["channelyellstatus"]=1, 	-- trigger 1 or 0
["channelguildstatus"]=1, 	-- trigger 1 or 0
["alarmstatus"]=0,			-- trigger 1 or 0
["raidfindstatus"]=0,		-- trigger 1 or 0
["classfindstatus"]=1,		-- trigger 1 or 0
["instsplitestatus"]=0,		-- trigger 1 or 0
["minimapiconshow"]=1,		-- trigger 1 or 0
["minimapiconfree"]=0,		-- trigger 1 or 0
["checksplite"]=1,			-- trigger 1 or 0
["checklider"]=1,			-- trigger 1 or 0
["checkfull"]=1,			-- trigger 1 or 0
["checkid"]=0,				-- trigger 1 or 0
["alarmcd"]=0,				-- trigger 1 or 0
}

--[[--------------------END DEFAULT PARAMETRS------------------]]--

-----------------------------------------------------------------------------------------------------------------------------


FGL.db.difficulties={
{name="5", 			print="", 		maxplayers=5, 	heroic=0, 		balance={1,1,3}}, 	-- 1. 5nm
{name="5 hc", 		print="", 		maxplayers=5, 	heroic=1,		balance={1,1,3}}, 	-- 2. 5hc
{name="10", 		print=" 10", 	maxplayers=10, 	heroic=0,		balance={2,3,5}},	-- 3. 10nm
{name="10 hc", 	print=" 10", 	maxplayers=10, 	heroic=1,		balance={2,3,5}}, 	-- 4. 10hc
{name="25", 		print=" 25", 	maxplayers=25, 	heroic=0,		balance={2,5,18}}, 	-- 5. 25nm
{name="25 hc",		print=" 25", 	maxplayers=25, 	heroic=1,		balance={2,5,18}}, 	-- 6. 25hc
{name="20", 		print=" 20",	maxplayers=20, 	heroic=0,		balance={2,4,14}},	-- 7. 20
{name="40", 		print=" 40",	maxplayers=40, 	heroic=0,		balance={3,7,30}},	-- 8. 40
}

FGL.db.add_difficulties={
{name="nm", difficulties="13578"},
{name="hc", difficulties="246"},
{name="all 10", difficulties="34"},
{name="all 25", difficulties="56"},
{name="any", difficulties="12345678"}
}

FGL.db.patches={
{name="Wrath of the Lich King",		abbreviation="WotLK",	point="wotlk"},
{name="The Burning Crusade", 		abbreviation="TBC",	point="tbc"},
{name="Classic", 					abbreviation="Classic",	point="classic"},
{name="Seasonal Events", 			abbreviation="Events",	point="events"},
}

-----------------------------------------------------------------------------------------------------------------------------------

FGL.db.instances={
{	name="Icecrown Citadel", 
 	namecreatepartyraid="To ICC",
	abbreviationrus="ICC",
	abbreviationeng="ICC",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-IcecrownCitadel", 
	search={criteria={"icc", "icecrown"}
}},
{	name="Vault of Archavon", 
 	namecreatepartyraid="To VoA",
	abbreviationrus="VoA",
	abbreviationeng="VoA",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-VaultOfArchavon",
	search={criteria={"voa", "vault"}
}},
{	name="Ulduar", 
 	namecreatepartyraid="To Ulduar",
	abbreviationrus="Uld",
	abbreviationeng="Ulduar",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Ulduar",
	search={criteria={"ulduar", "uld"}
}},
{	name="Naxxramas", 
 	namecreatepartyraid="To Naxx",
	abbreviationrus="Naxx",
	abbreviationeng="Naxx",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Naxxramas",
	search={criteria={"naxx", "naxxramas"}
}},
{	name="Onyxia's Lair", 
 	namecreatepartyraid="To Onyxia",
	abbreviationrus="Ony",
	abbreviationeng="Onyxia",
	cutVeng="true",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-OnyxiaEncounter",
	search={criteria={"ony", "onyxia", {"onyxia's", "lair"}}
}},
{	name="Eye of Eternity", 
 	namecreatepartyraid="To EoE",
	abbreviationrus="EoE",
	abbreviationeng="Malygos",
	cutVeng="true",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Malygos",
	search={criteria={"eoe", "malygos", {"eye", "of", "eternity"}}
}},
{	name="Obsidian Sanctum", 
 	namecreatepartyraid="To OS",
	abbreviationrus="OS",
	abbreviationeng="OS",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ChamberOfAspects",
	search={criteria={"os", "sarth", "obsidian"}
}},
{	name="Ruby Sanctum", 
 	namecreatepartyraid="To RS",
	abbreviationrus="RS",
	abbreviationeng="RS",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RubySanctum",
	search={criteria={"rs", "halion", "ruby"}
}},
{	name="Trial of the Crusader", 
 	namecreatepartyraid="To ToC",
	abbreviationrus="ToC",
	abbreviationeng="ToC",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ArgentRaid",
	search={criteria={"toc", "togc", "totc", "trial of the crusader", "crusader"}
}},
{	name="Trial of the Champion", 
 	namecreatepartyraid="To ToC5",
	abbreviationrus="ToC5",
	abbreviationeng="ToC5",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ArgentDungeon",
	search={criteria={"toc5", "champion"}
}},
{	name="Halls of Stone", 
 	namecreatepartyraid="To HoS",
	abbreviationrus="HoS",
	abbreviationeng="HoS",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HallsofStone",
	search={criteria={"hos", {"halls", "of", "stone"}}
}},
{	name="Halls of Lightning", 
 	namecreatepartyraid="To HoL",
	abbreviationrus="HoL",
	abbreviationeng="HoL",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HallsofLightning",
	search={criteria={"hol", {"halls", "of", "lightning"}}
}},
{	name="Violet Hold", 
 	namecreatepartyraid="To VH",
	abbreviationrus="VH",
	abbreviationeng="VH",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheVioletHold",
	search={criteria={"vh", "violet"}
}},
{	name="Pit of Saron", 
 	namecreatepartyraid="To PoS",
	abbreviationrus="PoS",
	abbreviationeng="PoS",
 	cutVname="true",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-PitofSaron", 
	search={criteria={"pos", {"pit", "of", "saron"}}
}},
{	name="Forge of Souls", 
 	namecreatepartyraid="To FoS",
	abbreviationrus="FoS",
	abbreviationeng="FoS",
 	cutVname="true",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheForgeofSouls",
	search={criteria={"fos", {"forge", "of", "souls"}}
}},
{	name="Halls of Reflection", 
 	namecreatepartyraid="To HoR",
	abbreviationrus="HoR",
	abbreviationeng="HoR",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HallsofReflection",
	search={criteria={"hor", {"halls", "of", "reflection"}}
}},
{	name="The Nexus", 
 	namecreatepartyraid="To Nexus",
	abbreviationrus="Nexus",
	abbreviationeng="Nexus",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheNexus",
	search={criteria={"nexus"}
}},
{	name="The Oculus", 
 	namecreatepartyraid="To Oculus",
	abbreviationrus="Occ",
	abbreviationeng="Oculus",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheOculus",
	search={criteria={"oculus", "occ"}
}},
{	name="Azjol-Nerub", 
 	namecreatepartyraid="To AN",
	abbreviationrus="AN",
	abbreviationeng="Azjol",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-AzjolNerub",
	search={criteria={"azjol", "nerub", "an"}
}},
{	name="Ahn'kahet", 
 	namecreatepartyraid="To AK",
	abbreviationrus="AK",
	abbreviationeng="Ahn'kahet",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Ahnkalet",
	search={criteria={"ahn", "kahet", "ak", "ok", {"old", "kingdom"}}
}},
{	name="Utgarde Pinnacle", 
 	namecreatepartyraid="To UP",
	abbreviationrus="UP",
	abbreviationeng="UP",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-UtgardePinnacle",
	search={criteria={"up", "pinnacle"}
}},
{	name="Utgarde Keep", 
 	namecreatepartyraid="To UK",
	abbreviationrus="UK",
	abbreviationeng="UK",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Utgarde",
	search={criteria={"uk", "keep", {"utgarde", "keep"}}
}},
{	name="Drak'Tharon Keep", 
 	namecreatepartyraid="To DTK",
	abbreviationrus="DTK",
	abbreviationeng="DTK",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-DrakTharon", 
	search={criteria={"dtk", "drak"}
}},
{	name="Culling of Stratholme", 
 	namecreatepartyraid="To CoS",
	abbreviationrus="CoS",
	abbreviationeng="CoS",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-OldStrathome",
	search={criteria={"cos", "culling"}
}},
{	name="Gundrak", 
 	namecreatepartyraid="To GD",
	abbreviationrus="GD",
	abbreviationeng="Gundrak",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Gundrak",
	search={criteria={"gd", "gundrak"}
}},
{	name="Zul'Aman", 
 	namecreatepartyraid="To ZA",
	abbreviationrus="ZA",
	abbreviationeng="ZA",
	difficulties="3",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ZulAman",
	search={criteria={"za", "zul'aman"}
}},
{	name="Karazhan", 
 	namecreatepartyraid="To Kara",
	abbreviationrus="Kara",
	abbreviationeng="Karazhan",
	difficulties="3",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Karazhan",
	search={criteria={"kara", "karazhan"}
}},
{  
	name="Tempest Keep", 
 	namecreatepartyraid="To TK",
	abbreviationrus="TK",
	abbreviationeng="TK",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"tk", "tempest"}
}},
{	name="Gruul's Lair", 
 	namecreatepartyraid="To Gruul",
	abbreviationrus="Gruul",
	abbreviationeng="Gruul",
	cutVeng="true",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-GruulsLair",
	search={criteria={"gruul"}
}},
{	name="Mount Hyjal", 
 	namecreatepartyraid="To Hyjal",
	abbreviationrus="Hyjal",
	abbreviationeng="Hyjal",
	cutVname="true",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HyjalPast",
	search={criteria={"hyjal"}
}},
{	name="Sunwell Plateau", 
 	namecreatepartyraid="To SWP",
	abbreviationrus="SWP",
	abbreviationeng="SWP",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Sunwell",
	search={criteria={"swp", "sunwell"}
}},
{	name="Serpentshrine Cavern", 
 	namecreatepartyraid="To SSC",
	abbreviationrus="SSC",
	abbreviationeng="SSC",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
	search={criteria={"ssc", "serpentshrine"}
}},
{	name="Magtheridon's Lair", 
 	namecreatepartyraid="To Mag",
	abbreviationrus="Mag",
	abbreviationeng="Magtheridon",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HellfireCitadelRaid",
	search={criteria={"mag", "magtheridon"}
}},
{	name="Black Temple", 
 	namecreatepartyraid="To BT",
	abbreviationrus="BT",
	abbreviationeng="BT",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackTemple",
	search={criteria={"bt", {"black", "temple"}}
}},
{	name="Auchenai Crypts", 
 	namecreatepartyraid="To AC",
	abbreviationrus="AC",
	abbreviationeng="AC",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"ac", "auchenai"}
}},
{	name="Mana Tombs", 
 	namecreatepartyraid="To MT",
	abbreviationrus="MT",
	abbreviationeng="MT",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"mt", "mana", "tombs"}
}},
{	name="Sethekk Halls", 
 	namecreatepartyraid="To Sethekk",
	abbreviationrus="SH",
	abbreviationeng="Sethekk",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"sethekk"}
}},
{	name="Shadow Labyrinth", 
 	namecreatepartyraid="To SL",
	abbreviationrus="SL",
	abbreviationeng="Lab",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"sl", "shadow", "labyrinth", "lab", "slabs", "slab"}
}},
{	name="The Arcatraz", 
 	namecreatepartyraid="To Arca",
	abbreviationrus="Arca",
	abbreviationeng="Arcatraz",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"arca", "arcatraz"}
}},
{	name="The Botanica", 
 	namecreatepartyraid="To Bota",
	abbreviationrus="Bota",
	abbreviationeng="Botanica",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"bota", "botanica"}
}},
{	name="The Mechanar", 
 	namecreatepartyraid="To Mech",
	abbreviationrus="Mech",
	abbreviationeng="Mechanar",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"mech", "mechanar"}
}},
{	name="Old Hillsbrad", 
 	namecreatepartyraid="To OHF",
	abbreviationrus="OHF",
	abbreviationeng="OHF",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CavernsOfTime",
	search={criteria={"ohb", "ohf", "hillsbrad"}
}},
{	name="The Black Morass", 
 	namecreatepartyraid="To BM",
	abbreviationrus="BM",
	abbreviationeng="BM",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CavernsOfTime",
	search={criteria={"bm", {"black", "morass"}}
}},
{	name="Hellfire Ramparts", 
 	namecreatepartyraid="To Ramps",
	abbreviationrus="Ramps",
	abbreviationeng="Ramps",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	search={criteria={"ramps", "ramparts"}
}},
{	name="The Blood Furnace", 
 	namecreatepartyraid="To BF",
	abbreviationrus="BF",
	abbreviationeng="BF",
	cutVname="true",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	search={criteria={"bf", "furnace"}
}},
{	name="The Shattered Halls", 
 	namecreatepartyraid="To SH",
	abbreviationrus="SH",
	abbreviationeng="SH",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	search={criteria={"shattered"}
}},
{	name="Magister's Terrace", 
 	namecreatepartyraid="To MgT",
	abbreviationrus="MgT",
	abbreviationeng="MgT",
	cutVname="true",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-MagistersTerrace",
	search={criteria={"mgt", "magister"}
}},
{	name="The Underbog", 
 	namecreatepartyraid="To UB",
	abbreviationrus="UB",
	abbreviationeng="UB",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
	search={criteria={"ub", "underbog"}
}},
{ 	name="The Steamvault", 
 	namecreatepartyraid="To SV",
 	abbreviationrus="SV",
 	abbreviationeng="SV",
 	difficulties="12",
	 patch="tbc",
 	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
 	search={criteria={"sv", "steamvault"}
}},
{	name="The Slave Pens", 
 	namecreatepartyraid="To SP",
	abbreviationrus="SP",
	abbreviationeng="SP",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
	search={criteria={"sp", "slave", "pens"}
}},
{	name="Zul'Gurub", 
 	namecreatepartyraid="To ZG",
	abbreviationrus="ZG",
	abbreviationeng="ZG",
	difficulties="7",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ZulGurub",
	search={criteria={"zg", "zul'gurub"}
}},
{	name="Ruins of Ahn'Qiraj", 
 	namecreatepartyraid="To AQ20",
	abbreviationrus="AQ20",
	abbreviationeng="AQ20",
	difficulties="7",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-AQRuins",
	search={criteria={"aq20", "ruins"}
}},
{	name="Temple of Ahn'Qiraj", 
 	namecreatepartyraid="To AQ40",
	abbreviationrus="AQ40",
	abbreviationeng="AQ40",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-AQTemple",
	search={criteria={"aq40"}
}},
{	name="Blackwing Lair", 
 	namecreatepartyraid="To BWL",
	abbreviationrus="BWL",
	abbreviationeng="BWL",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackwingLair",
	search={criteria={"bwl"}
}},
{	name="Molten Core", 
 	namecreatepartyraid="To MC",
	abbreviationrus="MC",
	abbreviationeng="MC",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-MoltenCore",
	search={criteria={"mc", "molten"}
}},
{	name="Gnomeregan", 
 	namecreatepartyraid="To Gnomer",
	abbreviationrus="Gnomer",
	abbreviationeng="Gnomer",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Gnomeregan",
	search={criteria={"gnomer"}
}},
{	name="Uldaman", 
 	namecreatepartyraid="To Uldaman",
	abbreviationrus="Uldaman",
	abbreviationeng="Uldaman",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Uldaman",
	search={criteria={"uldaman"}
}},
{	name="Stockades", 
 	namecreatepartyraid="To Stocks",
	abbreviationrus="Stocks",
	abbreviationeng="Stocks",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-StormwindStockades",
	search={criteria={"stocks", "stockades"}
}},
{	name="Stratholme", 
 	namecreatepartyraid="To Strat",
	abbreviationrus="Strat",
	abbreviationeng="Strat",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Stratholme",
	search={criteria={"strat", "stratholme"}
}},
{	name="Blackrock Spire", 
 	namecreatepartyraid="To BRS",
	abbreviationrus="BRS",
	abbreviationeng="BRS",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackrockSpire",
	search={criteria={"brs", "ubrs", "lbrs"}
}},
{	name="Blackrock Depths", 
 	namecreatepartyraid="To BRD",
	abbreviationrus="BRD",
	abbreviationeng="BRD",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackrockDepths",
	search={criteria={"brd", "depths"}
}},
{	name="Scholomance",
 	namecreatepartyraid="To Scholo",
	abbreviationrus="Scholo",
	abbreviationeng="Scholo",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Scholomance",
	search={criteria={"scholo"}
}},
{	name="Maraudon", 
 	namecreatepartyraid="To Mara",
	abbreviationrus="Mara",
	abbreviationeng="Mara",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Maraudon",
	search={criteria={"mara", "maraudon"}
}},
{	name="Deadmines", 
 	namecreatepartyraid="To VC",
	abbreviationrus="VC",
	abbreviationeng="VC",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Deadmines",
	search={criteria={"vc", "deadmines"}
}},
{	name="Wailing Caverns", 
 	namecreatepartyraid="To WC",
	abbreviationrus="WC",
	abbreviationeng="WC",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-WailingCaverns",
	search={criteria={"wc", "wailing"}
}},
{	name="Ragefire Chasm", 
 	namecreatepartyraid="To RFC",
	abbreviationrus="RFC",
	abbreviationeng="RFC",
	cutVname="true",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RagefireChasm",
	search={criteria={"rfc", "ragefire"}
}},
{	name="Blackfathom Deeps", 
 	namecreatepartyraid="To BFD",
	abbreviationrus="BFD",
	abbreviationeng="BFD",
 	cutVname="true",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackfathomDeeps",
	search={criteria={"bfd", "blackfathom"}
}},
{	name="Shadowfang Keep", 
 	namecreatepartyraid="To SFK",
	abbreviationrus="SFK",
	abbreviationeng="SFK",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ShadowFangKeep",
	search={criteria={"sfk", "shadowfang"}
}},
{	name="Zul'Farrak", 
 	namecreatepartyraid="To ZF",
	abbreviationrus="ZF",
	abbreviationeng="ZF",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ZulFarak",
	search={criteria={"zf", "zul'farrak"}
}},
{	name="Dire Maul", 
 	namecreatepartyraid="To DM",
	abbreviationrus="DM",
	abbreviationeng="DM",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-DireMaul",
	search={criteria={"dm", "dire", "maul"}
}},
{	name="Sunken Temple", 
 	namecreatepartyraid="To ST",
	abbreviationrus="ST",
	abbreviationeng="ST",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-SunkenTemple",
	search={criteria={"st", "sunken"}
}},
{	name="Scarlet Monastery", 
 	namecreatepartyraid="To SM",
	abbreviationrus="SM",
	abbreviationeng="SM",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ScarletMonastery",
	search={criteria={"sm", "scarlet"}
}},
{	name="Razorfen Downs", 
 	namecreatepartyraid="To RFD",
	abbreviationrus="RFD",
	abbreviationeng="RFD",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RazorfenDowns",
	search={criteria={"rfd", "razorfen"}
}},
{	name="Razorfen Kraul", 
 	namecreatepartyraid="To RFK",
	abbreviationrus="RFK",
	abbreviationeng="RFK",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RazorfenKraul",
	search={criteria={"rfk", "kraul"}
}}, 
{ 	 name="Midsummer Fire Festival", 
 	namecreatepartyraid="To Ahune",
	 abbreviationrus="Ahune",
	 abbreviationeng="Ahune",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="12",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Summer",
	 search={criteria={"ahune", "midsummer"}
}},
{ 	 name="Brewfest", 
 	namecreatepartyraid="To Coren",
	 abbreviationrus="Coren",
	 abbreviationeng="Coren",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="1",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Brew",
	 search={criteria={"coren", "direbrew", "brewfest"}
}},
{ 	 name="Hallow's End", 
 	namecreatepartyraid="To Horseman",
	 abbreviationrus="Horseman",
	 abbreviationeng="Horseman",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="1",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Halloween",
	 search={criteria={"horseman", "headless"}
}},
{ 	 name="Love is in the Air", 
 	namecreatepartyraid="To Hummel",
	 abbreviationrus="Hummel",
	 abbreviationeng="Hummel",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="1",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Love",
	 search={criteria={"hummel", "apothecary"}
}},
{	name="Random Dungeon", 
 	namecreatepartyraid="To RDF",
	abbreviationrus="RDF",
	abbreviationeng="RDF",
	difficulties="12",
	patch="random",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RANDOMDUNGEON",
	search={criteria={"rdf", "random", "rhc", "random dungeon", "random heroic"}
}},
}



FGL.db.add_instances={
{name="Party", difficulties="12"},
{name="Raid", difficulties="345678"},
{name="Any", difficulties="12345678"},
{name="With ach", difficulties="12345678"},
}

FGL.db.roles={
	heal={
		label="heal",
		search={
			criteria={"heal", "heals", "healer", "healers", "rsham", "hpala", "hpal", "hpriest", "holy priest", "rdruid", "rdru", "resto", "restoration", "disc", "discipline", "holy", "tree"},
			exception={"heal full", "healer full", "heals full", "healers full", "lf guild", "lfg"}
		}
	},
	attack={
		label="dps",
		search={
			criteria={"dps", "dd", "rdps", "mdps", "melee", "caster", "ret", "retri", "rogue", "hunter", "mage", "warlock", "lock", "spriest", "shadow priest", "boomie", "boomy", "moonkin", "feral", "cat", "enh", "enhance", "enhancement", "ele", "elemental", "dk", "warrior", "arms", "fury", "damage"},
			exception={"dps full", "dd full", "rdps full", "mdps full", "lf guild", "lfg"}
		}
	},
	tank={
		label="tank",
		search={
			criteria={"tank", "tanks", "mt", "ot", "prot", "protection", "bear", "blood dk", "blood", "pala tank", "paladin tank", "war tank", "dk tank"},
			exception={"tank full", "tanks full", "lf guild", "lfg"}
		}
	},
	all={
		label="all",
		search={
			criteria={"need all", "lf all", "all roles", "need more", "need any", "need all roles", "lfm all", "lfm any", "all welcome"},
			exception={}
		}
	},
} 


FGL.db.classfindtable = {
["DEATHKNIGHT"]={
				{},
				{"dk", "frost", "unholy"},
				{"blood"},
				},
["ROGUE"]={
				{},
				{"rogue", "assa", "combat", "sub"},
				{},
				},
["HUNTER"]={
				{},
				{"hunt", "hunter", "mm", "bm", "surv"},
				{},
				},
["MAGE"]={
				{},
				{"mage", "arcane", "fire", "frost mage"},
				{},
				},
["WARRIOR"]={
				{},
				{"warr", "warrior", "arms", "fury"},
				{"pwar", "prot warr", "prot warrior"},
				},
["WARLOCK"]={
				{},
				{"lock", "warlock", "affli", "demo", "destro"},
				{},
				},		
["DRUID"]={
				{"rdru", "resto druid", "tree"},
				{"druid", "cat", "feral", "boomie", "balance", "moonkin"},
				{"bear", "guardian"},
				},
["PALADIN"]={
				{"hpala", "hpal", "holy paladin"},
				{"pala", "ret", "retri"},
				{"ppal", "prot pala", "prot paladin"},
				},
["PRIEST"]={
				{"hpriest", "holy priest", "dc", "disc", "discipline"},
				{"priest", "spriest", "shadow"},
				{},
				},
["SHAMAN"]={
				{"rsham", "resto sham", "resto shaman"},
				{"sham", "shaman", "ele", "enh"},
				{},
				},			
}

FGL.db.submsgs = {
	"{diamond}",
	"{star}",
	"{circle}",
	"{skull}",
	"{cross}",
	"{triangle}",
	"{moon}",
	"{square}",
	"{Diamond}",
	"{Star}",
	"{Circle}",
	"{Skull}",
	"{Cross}",
	"{Triangle}",
	"{Moon}",
	"{Square}",
	"{DIAMOND}",
	"{STAR}",
	"{CIRCLE}",
	"{SKULL}",
	"{CROSS}",
	"{TRIANGLE}",
	"{MOON}",
	"{SQUARE}",
	"__",
	"**",
	"-".."-",
	"!!!",
	"!!",
}

FGL.db.exceptions={
	"wtb",
	"wts",
	"selling",
	"lf guild",
	"lfg",
	"lfp",
	"looking for guild",
	"looking for group",
	"sell",
	"buy",
	"trade",
	"trading",
	"gold",
	"coins",
	"cheap",
	"discord",
	"twitch",
	"youtube",
	"carry",
	"boost",
	"boosting",
	"2v2",
	"3v3",
	"5v5",
	"arena",
	"rating",
	"mmr",
	"recruit",
	"recruiting",
	"wtt",
	"guild",
	"social",
	"pvp guild",
	"pve guild",
	"casual guild",
	"hardcore",
	"join our",
	"looking for members",
	"gs ",
	"gearscore",
	"achievement seller",
	"sell run",
	"selling run",
	"server first",
}


FGL.db.heroic={
"hc",
"heroic",
"hm",
" hc",
"hc ",
" hc ",
"rhc",
"heroics",
}

FGL.db.normal={
"",
"nm",
"n ",
"norm ",
" nm",
"nm ",
"normal",
}

FGL.db.createtexts={
	full={
		start="To %s",
		cut="%s",
		need=" need: %s.",
		need1=" need %s.",
		need3=" need %s.",
		pm="PM: %s.",
		ddspd="dps",
	},
	splite={
		start="To %s",
		start2="To %s",
		cut="%s",
		need=" need %s",
		pm="(PM: %s)",
		spd="rdps",
		dd="mdps",
		rdd="rdps",
		ddspd="dps",
	},
	random={
		name="Random Dungeon",
		start="To %s",
	},
}

FGL.db.iconclasses={
	tank={
		"warrior",
		"deathknight",
		"paladin",
		"druid",
	},
	heal={
		"paladin",
		"shaman",
		"priest",
		"druid",
	},
	dd={
		"warrior",
		"deathknight",
		"paladin",
		"shaman",
		"hunter",
		"mage",
		"rogue",
		"warlock",
		"priest",
		"druid",
	},
}

FGL.db.classesprint={
	["TANK"]={
		"war",
		"dk",
		"pal",
		"dru",
	},
	["HEAL"]={
		"pal",
		"sham",
		"priest",
		"dru",
	},
	["DD"]={
		"war",
		"dk",
		"pal",
		"sham",
		"hunt",
		"mage",
		"rogue",
		"lock",
		"priest",
		"dru",
	},
}

FGL.db.classesgroup={
		1,
		1,
		1,
		3,
		4,
		2,
		1,
		2,
		2,
		3,
}


-- uppercase is allowed

FGL.db.achievements = {
	{criteria={"for ach", "for achievement", "achiev", "achievement"}},
	{ 	--Glory of the Ulduar Raider 10
		id=2957,
		checkdiff="34",
		criteria={"gotur", "gotur 10"}
	},
	{ 	--Glory of the Ulduar Raider 25
		id=2958,
		checkdiff="56",
		criteria={"gotur", "gotur 25"}
	},
	{ 	--Glory of the Icecrown Raider 10
		id=4602,
		checkdiff="34",
		criteria={"icc ach", "gotir", "gotir 10"}
	},
	{ 	--Glory of the Icecrown Raider 25
		id=4603,
		checkdiff="56",
		criteria={"icc ach", "gotir", "gotir 25"}
	},
}

FGL.db.defbackgroundfiles={
{"Nerubian Keep",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Nerubian.tga"},
{"Blade's Edge Arena",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Outland"},
{"Ruined City",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RuinedCity.tga"},
{"Hellfire Citadel",   	"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HellfireCitadelBack.tga"},
{"Forest Wilderness",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Enviroment.tga"},
{"Dungeon",    			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Dungeon.tga"},
{"Cave",     			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Cave.tga"},
{"Black Temple",  			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-blacktemplecitadel.tga"},
{"Outland",    			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-outlandrocks.tga"},
{"Planet",   			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-planet.tga"},
{"Houses",   			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Houses.tga"},
{"Arthas Menethil",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ArthasMenetil.tga"},
{"Lich King",     			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Artas.tga"},
{"Bronzebeard",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Bronzebeard.tga"},
{"Soulstone",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-SoulStone.tga"},
{"Goblin Sappers",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Goblins.tga"},
{"Undead Rising",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Undeads.tga"},
{"The Pit",      			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Pit.tga"},
{"Invincible",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Invincible.tga"},
{"Kael'thas",   			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Kaelthas.tga"},
{"Kel'Thuzad",      			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-KelTuzad.tga"},
{"Moonwell Guardian",      	"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-MoonwellGuardian.tga"},
{"Tireless Warlock",    	"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Warlock.tga"},
{"Battleground",      			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Bg.tga"},
{"Scourge Ziggurats",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Ziggurat.tga"},
{"Soul Prison",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-SoulPrison.tga"},
{"Blood Elf",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BloodElf.tga"},
{"Skull Wall",       		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Skullwall.tga"},
{"Deadlands",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-deadlands.tga"},
{"Horde Banner",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HordeFlag.tga"},
{"Kodo and Tiger",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Kodo.tga"},
{"Sylvanas",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Silvana.tga"},
{"Troll",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Troll.tga"},
{"Demon's House",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-demonshouse.tga"},
{"Fanglands",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Fanglands.tga"},

}

FGL.db.soundfiles={
{"Simon Bell",   		"Sound\\Spells\\SimonGame_Visual_GameTick.wav"},
{"Rubber Ducky", 		"Sound\\Doodad\\Goblin_Lottery_Open01.wav"},
{"Cartoon FX", 		"Sound\\Doodad\\Goblin_Lottery_Open03.wav"},
{"Explosion",		"Sound\\Doodad\\Hellfire_Raid_FX_Explosion05.wav"},
{"Shing!", 		"Sound\\Doodad\\PortcullisActive_Closed.wav"},
{"Wham!", 		"Sound\\Doodad\\PVP_Lordaeron_Door_Open.wav"},
{"War Drums", 		"Sound\\Event Sounds\\Event_wardrum_ogre.wav"},
{"Cheer", 			"Sound\\Event Sounds\\OgreEventCheerUnique.wav"},
{"Humm", 		"Sound\\Spells\\SimonGame_Visual_GameStart.wav"},
{"Short Circuit", 		"Sound\\Spells\\SimonGame_Visual_BadPress.wav"},
{"Fel Portal", 		"Sound\\Spells\\Sunwell_Fel_PortalStand.wav"},
{"Fel Nova", 		"Sound\\Spells\\SeepingGaseous_Fel_Nova.wav"},
{"Sonic Horn", 		"Sound\\Spells\\SonicHornCast.wav"},
{"Throw Impact", 		"Sound\\Spells\\Warrior_Heroic_Throw_Impact2.wav"},
{"Overload Effect", 		"Sound\\Spells\\Ulduar_IronConcil_OverloadEffect.wav"},
{"You Will Die!", 		"Sound\\Creature\\CThun\\CThunYouWillDIe.wav"},
{"Spawn", 		"Sound\\Events\\UD_DiscoBallSpawn.wav"},
{"Horn", 			"Sound\\Events\\scourge_horn.wav"},
{"Denied", 		"Sound\\Interface\\LFG_Denied.wav"},
{"Dungeon Ready", 	"Sound\\Interface\\LFG_DungeonReady.wav"},
{"Rewards", 		"Sound\\Interface\\LFG_Rewards.wav"},
{"Role Check", 		"Sound\\Interface\\LFG_RoleCheck.wav"},
{"Player Invite", 		"Sound\\Interface\\PlayerInviteA.wav"},
{"Ready Check",		"Sound\\Interface\\ReadyCheck.wav"},
{"Alarm Clock 1", 		"Sound\\Interface\\AlarmClockWarning1.wav"},
{"Alarm Clock 2", 		"Sound\\Interface\\AlarmClockWarning2.wav"},
{"Alarm Clock 3", 		"Sound\\Interface\\AlarmClockWarning3.wav"},
}

FGL.db.FindList={
"Dungeons",
"Dungeons (HC)",
"Raids",
"Raids (HC)",
}

FGL.db.msgforsaves = "Hi! Will you go to %s %s on CD (ID %d)?"
FGL.db.msgforsaves_notinvite = "Hi! [%s] is forming %s %s on CD (ID %d). PM them if you want to join!"
FGL.db.msgforprint = "%s %s ID-%s: "

FGL.db.tooltips={
["FindGroupOptionsViewFindFrameCheckButton1"] = {"ANCHOR_TOPLEFT", "Display all role icons", 
	"By selecting this, you will see ALL role icons needed in the group/raid. Search will still be based on your category."
	},
["FindGroupOptionsViewFindFrameCheckButton2"] = {"ANCHOR_TOPLEFT", "Display instance background", 
	"Uncheck this if you don't want to see images when hovering over an instance name."
	},
["FindGroupOptionsViewFindFrameCheckButton3"] = {"ANCHOR_TOPLEFT", "Display instances with CD", 
	"When checked, instances with an active CD are not hidden but colored gray (inactive)."
	},
["FindGroupOptionsViewFindFrameCheckButton4"] = {"ANCHOR_TOPLEFT", "Display abbreviations",
	"Show shortened instance names in the search window."
	},
["FindGroupOptionsFrameResetButton"] = {"ANCHOR_TOPLEFT", "Default",
	"Resets all values to default."
	},
["FindGroupOptionsViewFindFrameCheckButtonRaidFind"] = {"ANCHOR_TOPLEFT", "Display own messages",
	"Scan your own messages and messages from raid/party members."
	},
["FindGroupOptionsViewFindFrameCheckButtonClassFind"] = {"ANCHOR_TOPLEFT", "Display other classes",
	"Display messages where your class is presumably not needed."
	},
["FindGroupOptionsFindFrameCheckButtonCloseFind"] = {"ANCHOR_TOPLEFT", "Background Mode",
	"Addon will continue to work and search for messages even if closed."
	},
["FindGroupOptionsInterfaceFrameCheckButton1"] = {"ANCHOR_TOPLEFT", "Show tooltips",
	"Show these tooltips on buttons and other addon elements."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonSplite"] = {"ANCHOR_TOPLEFT", "Shorten LFG text",
	"Shorten the LFG sentence to a common jargon format."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonLider"] = {"ANCHOR_TOPLEFT", "Write Raid Leader name",
	"Append the raid leader's name if you are not the leader or assistant."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonFull"] = {"ANCHOR_TOPLEFT", "Auto Stop",
	"When the raid/party reaches the maximum players for the instance difficulty, a message is sent to chat that the group is full. LFG stops."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonId"] = {"ANCHOR_TOPLEFT", "Dungeon ID",
	"The dungeon lock ID will be appended to the instance name in the LFG text, if applicable."
	},
["FindGroupOptionsMinimapIconFrameCheckButtonShow"] = {"ANCHOR_TOPLEFT", "Show minimap button",
	"Show a minimap button for quick access to addon features."
	},
["FindGroupOptionsMinimapIconFrameCheckButtonFree"] = {"ANCHOR_TOPLEFT", "Free move",
	"The button will be detached from the minimap for free movement."
	},
["FindGroupOptionsAlarmFrameCheckButtonAlarmCD"] = {"ANCHOR_TOPLEFT", "Alert only without CD",
	"Alerts will ignore dungeons where you have an active ID."
	},






["FindGroupFrameAlarmButton"] = {"ANCHOR_TOPRIGHT", "Alerts",
	"When a new entry appears in the search table, the addon can alert you."
	},
["FindGroupFrameCreateButton1"] = {"ANCHOR_TOPRIGHT", "Create Window",
	"Click to switch to group/raid creation mode."
	},
["FindGroupFrameCreateButton2"] = {"ANCHOR_TOPRIGHT", "Search Window",
	"Click to switch to group/raid search mode."
	},
["FindGroupFrameCCDButton"] = {"ANCHOR_TOPRIGHT", "Saved Dungeons",
	"List of players and saved dungeons."
	},
["FindGroupFrameConfigButton1"] = {"ANCHOR_TOPRIGHT", "Auxiliary Search Panel",
	"Panel to help configure the search window."
	},
["FindGroupFrameConfigButton2"] = {"ANCHOR_TOPRIGHT", "Auxiliary Create Panel",
	"Panel to help configure the create window."
	},
["FindGroupFrameConfigFrameButton"] = {"ANCHOR_TOPRIGHT", "Settings",
	"Settings for all addon parameters."
	},
["FindGroupFramePinButton"] = {"ANCHOR_TOPRIGHT", "Lock",
	"Lock the window from being moved."
	},
["FindGroupFrameInfoButton"] = {"ANCHOR_TOPRIGHT", "Info",
	"Information about this addon."
	},
["FindGroupFrameCloseButton"] = {"ANCHOR_TOPRIGHT", "Close",
	"Click to close the window."
	},
["FindGroupConfigFrameHNeedsButton"] = {"ANCHOR_TOPRIGHT", "Roles",
	"Select the roles you want to search for."
	},
["FindGroupConfigFrameHTextButton"] = {"ANCHOR_TOPRIGHT", "Text sent to player",
	"inv"
	},
["FindGroupConfigFrameHOtherButton"] = {"ANCHOR_TOPRIGHT", "Alerts",
	"Create your own list for alerts."
	},
["FindGroupShadowClearButton"] = {"ANCHOR_TOPRIGHT", "Clear",
	"Clear the entire alert list."
	},
["FindGroupShadowAddButton"] = {"ANCHOR_TOPRIGHT", "Add",
	"Add another criteria to the alert list."
	},
["FindGroupConfigFrameHActButton"] = {"ANCHOR_TOPRIGHT", "Message duration",
	"Duration of player messages in the search window. (adjusted with left/right mouse clicks)"
	},
["FindGroupConfigFrameHChannelsButton"] = {"ANCHOR_TOPRIGHT", "Channels",
	"Select channels where the LFG message will be sent."
	},

["FindGroupConfigFrameHClassButton"] = {"ANCHOR_TOPRIGHT", "Classes",
	"Select classes needed for your group/raid."
	},

["FindGroupFrameCalculate"] = {"ANCHOR_TOPRIGHT", "Auto Calculate",
	"Helps in the create window to auto-calculate roles based on specs of nearby party/raid members."
	},
["FindGroupSavesFrameSendButton"] = {"ANCHOR_TOPRIGHT", "Mass Message",
	"All players online will be notified about the run for this CD."
	},
["FindGroupSavesFramePrintButton"] = {"ANCHOR_TOPRIGHT", "Print List",
	"The current player list will be sent to raid/party chat."
	},
["FindGroupSavesFrameCloseButton"] = {"ANCHOR_TOPRIGHT", "Close",
	"Click to close the window."
	},
["FindGroupSavesFrameBackButton"] = {"ANCHOR_TOPRIGHT", "Back",
	"Click to return to the previous window."
	},

["SavesPlus"] = {"ANCHOR_TOPRIGHT", "Invite",
	"Invite to group."
	},
["SavesSend"] = {"ANCHOR_TOPRIGHT", "Whisper Player",
	"The following text will be sent to the player:\n"
	},


["FindGroupFrameMinimapButton"] = 		{"ANCHOR_TOPRIGHT", "FindGroup: Link", ""},
["FindGroupFrameTextToolTip"] = 		{"ANCHOR_TOPRIGHT", "Send Request", ""},
["FindGroupFrameHeal"] = 			{"ANCHOR_TOPRIGHT", "Heal", ""},
["FindGroupFrameTank"] = 			{"ANCHOR_TOPRIGHT", "Tank", ""},
["FindGroupFrameDD"] = 			{"ANCHOR_TOPRIGHT", "Damage", ""},
["FindGroupFrameHead"] = 			{"ANCHOR_TOPRIGHT", "Heroic Difficulty", ""},
}

FGL.db.shadow={
	{
		texts={
			"Search for characters who can:",
			"Accept",
		},
		widgets={
			"FindGroupShadowCheckButton1",
			"FindGroupShadowCheckButton2",
			"FindGroupShadowCheckButton3",
			"FindGroupShadowCheckText1",
			"FindGroupShadowCheckText2",
			"FindGroupShadowCheckText3",
		}
	},
	{
		texts={
			"Message template editor:",
			"Accept",
		},
		widgets={
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
			"FindGroupShadowFastButton",
		}
	},
	{
		texts={
			"Alert:",
			"Accept",
		},
		widgets={
			"FindGroupShadowTitleInst",
			"FindGroupShadowTitleIR",
			"FindGroupShadowComboBox1",
			"FindGroupShadowComboBox3",
			
			"FindGroupShadowScrollFrame",
			"FindGroupShadowPanelFrame",
			"FindGroupShadowAddButton",
			"FindGroupShadowClearButton",
		}
	},
	{
		texts={
			"",
			"Send",
		},
		widgets={
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
		}
	},
	{
		texts={
			"",
			"Send",
		},
		widgets={
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
		}
	},
	{
		texts={
			"Edit classes",
			"Accept",
		},
		widgets={
			"FindGroupClasses",
		}
	},


}

FGL.db.wigets={

configframe="FindGroupConfigFrameH",
configbuttons={
"FindGroupConfigFrameHActButton",
"FindGroupConfigFrameHTextButton",
"FindGroupConfigFrameHNeedsButton",
"FindGroupConfigFrameHOtherButton",
"FindGroupConfigFrameHChannelsButton",
"FindGroupConfigFrameHClassButton",
},

mainwigets2={
"FindGroupFrameSlider",
"FindGroupFrameSliderButtonUp",
"FindGroupFrameSliderButtonDown",
{"FindGroupFrameTextToolTip"},
{"FindGroupFramePartyButton"},
{"FindGroupFramefPartyButton"},
{"FindGroupFrameHeal"},
{"FindGroupFrameDD"},
{"FindGroupFrameTank"},
{"FindGroupFrameHead"},
{"FindGroupFrameAchieve"},
},

mainwigets1={
"FindGroupConfigFrameHActButton",
"FindGroupConfigFrameHTextButton",
"FindGroupConfigFrameHNeedsButton",
"FindGroupConfigFrameHOtherButton",
"FindGroupTooltip",
{"FindGroupFramefText"},
{"FindGroupFrameText"},
},

createwigets={
"FindGroupConfigFrameHChannelsButton",
"FindGroupConfigFrameHClassButton",
"FindGroupConfigFrameHSecFrame",


"FindGroupFrameTitleInst",
"FindGroupFrameTitleIR",
"FindGroupFrameTime",

"FindGroupFrameComboBox1",
"FindGroupFrameComboBox3",
"FindGroupFrameSec",
"FindGroupFramePanel3",

"FindGroupFrameTriggerButton",
"FindGroupFrameTankh",
"FindGroupFrameHealh",
"FindGroupFrameDDh",
"FindGroupFrameTank",
"FindGroupFrameHeal",
"FindGroupFrameDD",
"FindGroupFrameEditTank",
"FindGroupFrameEditHeal",
"FindGroupFrameEditDD",
"FindGroupFramePanelHeal",
"FindGroupFramePanelTank",
"FindGroupFramePanelDD",
"FindGroupFrameDTank",
"FindGroupFrameUTank",
"FindGroupFrameDHeal",
"FindGroupFrameUHeal",
"FindGroupFrameDDD",
"FindGroupFrameUDD",

"FindGroupFrameCalculate",
"FindGroupFrameSliderTankHeal",
"FindGroupFrameSliderHealDD",
},

stringwigets={
"FindGroupFrameText",
"FindGroupFramefText",
"FindGroupFrameTextToolTip",
"FindGroupFrameHead",
"FindGroupFrameAchieve",
"FindGroupFrameHeal",
"FindGroupFrameTank",
"FindGroupFrameDD"
},

stringwigets2={
{"FindGroupFrameText"},
{"FindGroupFramefText"},
"FindGroupFramePartyButton",
"FindGroupFramefPartyButton",
"FindGroupFrameTextToolTip",
"FindGroupFrameHead",
"FindGroupFrameAchieve",
"FindGroupFrameHeal",
"FindGroupFrameTank",
"FindGroupFrameDD",
},

optionframes={
"Find",
"ViewFind",
"Alarm",
"CreateRule",
"CreateView",
"Interface",
"MinimapIcon",
},

}


FGL.db.nummsgsmax=0
FGL.db.boxshowstatus=0
FGL.db.enterline=0
FGL.db.framemove=0
FGL.db.createstatus=0
FGL.db.mtooltipstatus = 0

FGL.db.lastmsg={}
FGL.db.tooltippoints={}
FGL.db.needs={}
FGL.db.findlistvalues={}
FGL.db.findpatches={}
FGL.db.createpatches={}
FGL.db.alarmpatches={}
FGL.db.alarmlist={}

--[[
FGL.db.msgTEXT
FGL.db.msgTEXT2
FGL.db.includeaddon
FGL.db.timeleft
FGL.db.msgforparty
FGL.db.global_sender
FGL.db.framealpha
FGL.db.alarminst
FGL.db.alarmir
FGL.db.alarmsound
FGL.db.defbackground
FGL.db.framealphaback
FGL.db.framealphafon
FGL.db.framescale
FGL.db.linefadesec

FGL.db.configstatus
FGL.db.changebackdrop
FGL.db.showstatus
FGL.db.faststatus
FGL.db.pinstatus
FGL.db.raidcdstatus
FGL.db.iconstatus
FGL.db.closefindstatus
FGL.db.channelyellstatus
FGL.db.channelguildstatus
FGL.db.tooltipsstatus
FGL.db.alarmstatus
FGL.db.raidfindstatus
FGL.db.instsplitestatus
]]--



----------------------------------------------------------------------- Init---------------------------------------------

function FindGroup_LoadConfig()
		FindGroupFrameSlider:Disable()
		FindGroupFrameSlider:Hide()
		FindGroupFrameSliderButtonUp:Hide()
		FindGroupFrameSliderButtonDown:Hide()
for i=1, #FGL.db.wigets.optionframes do
getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[i].."Frame"):Hide()
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):UnlockHighlight()
end
	if not FindGroupDB then FindGroupDB = {} end -- fresh DB
	if not FindGroupDB.usingtime then FindGroupDB.usingtime = 0 end

	local x, y  = FindGroupDB.X, FindGroupDB.Y
	if not x or not y then
		FindGroupFrame:ClearAllPoints()
		FindGroupFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", UIParent:GetWidth()/2 - FindGroupFrame:GetWidth()/2, - UIParent:GetHeight()/2 + FindGroupFrame:GetHeight()/2)
		FindGroup_SaveAnchors()
	else
		FindGroupFrame:ClearAllPoints()
		FindGroupFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)

	end
		FindGroupFrame:SetWidth(280)
		FindGroupFrame:SetHeight(126)
	if not(type(FindGroupDB.NEEDS) == 'table') or not FindGroupDB.NEEDS then FindGroupDB.NEEDS=FGL.db.defparam["needs"] end

	for h=1,3 do FGL.db.needs[h] = FindGroupDB.NEEDS[h] end
	FindGroupShadowCheckButton1:SetChecked(FGL.db.needs[1])
	FindGroupShadowCheckButton2:SetChecked(FGL.db.needs[2])
	FindGroupShadowCheckButton3:SetChecked(FGL.db.needs[3])

	if not(type(FindGroupDB.findlistvalues) == 'table') or not FindGroupDB.findlistvalues then FindGroupDB.findlistvalues=FGL.db.defparam["findlistvalues"] end
	for h=1,#FindGroupDB.findlistvalues do FGL.db.findlistvalues[h] = FindGroupDB.findlistvalues[h] end

	if not(type(FindGroupDB.findpatches) == 'table') or not FindGroupDB.findpatches then FindGroupDB.findpatches=FGL.db.defparam["findpatches"] end
	for h=1, #FindGroupDB.findpatches do FGL.db.findpatches[h] = FindGroupDB.findpatches[h] end

	if not(type(FindGroupDB.createpatches) == 'table') or not FindGroupDB.createpatches then FindGroupDB.createpatches=FGL.db.defparam["createpatches"] end
	for h=1, #FindGroupDB.createpatches do FGL.db.createpatches[h] = FindGroupDB.createpatches[h] end

	if not(type(FindGroupDB.alarmpatches) == 'table') or not FindGroupDB.alarmpatches then FindGroupDB.alarmpatches=FGL.db.defparam["alarmpatches"] end
	for h=1, #FindGroupDB.alarmpatches do FGL.db.alarmpatches[h] = FindGroupDB.alarmpatches[h] end

	if not(type(FindGroupDB.ALARMLIST) == 'table') or not FindGroupDB.ALARMLIST then FindGroupDB.ALARMLIST=FGL.db.defparam["alarmlist"] end
	for h=1, #FindGroupDB.ALARMLIST do FGL.db.alarmlist[h] = FindGroupDB.ALARMLIST[h] end
		
	FGL.db.msgforparty = FindGroupDB.MSGFORPARTY
		if not FGL.db.msgforparty then FGL.db.msgforparty = FGL.db.defparam["msgforparty"] end
		FindGroupDB.MSGFORPARTY = FGL.db.msgforparty
		FindGroupShadowEditBox:SetText(FGL.db.msgforparty)

	FGL.db.showstatus = FindGroupDB.SHOWSTATUS
		if FGL.db.showstatus == nil then FGL.db.showstatus = FGL.db.defparam["showstatus"] end
		if FGL.db.showstatus == 1 then FindGroup_ShowWindow() end

	FGL.db.configstatus = FindGroupDB.CONFIGSTATUS
		if FGL.db.configstatus == nil then FGL.db.configstatus = FGL.db.defparam["configstatus"] end
		if FGL.db.configstatus == 1 then FGL.db.configstatus = 0 else FGL.db.configstatus = 1 end
		FindGroup_ConfigButton()

 	FGL.db.timeleft = FindGroupDB.TIMELEFT
		if not FGL.db.timeleft then FGL.db.timeleft = FGL.db.defparam["timeleft"] - 15 else FGL.db.timeleft = FGL.db.timeleft - 15 end
		FindGroup_ActButton(nil,"LeftButton")

 	FGL.db.faststatus = FindGroupDB.FASTSTATUS
		if FGL.db.faststatus == nil then FGL.db.faststatus = FGL.db.defparam["faststatus"] end
		if FGL.db.faststatus == 1 then FGL.db.faststatus = 0 else FGL.db.faststatus = 1 end
		FindGroup_FastButton()

	FGL.db.pinstatus = FindGroupDB.PINSTATUS
		if FGL.db.pinstatus == nil then FGL.db.pinstatus = FGL.db.defparam["pinstatus"] end
		if FGL.db.pinstatus == 1 then FGL.db.pinstatus = 0 else FGL.db.pinstatus = 1 end
		FindGroup_PinButton()

	FGL.db.alarmstatus = FindGroupDB.ALARMSTATUS
		if FGL.db.alarmstatus == nil then FGL.db.alarmstatus = FGL.db.defparam["alarmstatus"] end
		if FGL.db.alarmstatus == 1 then FGL.db.alarmstatus = 0 else FGL.db.alarmstatus = 1 end
		FindGroup_AlarmButton()

	FGL.db.raidcdstatus = FindGroupDB.RAIDCDSTATUS
		if FGL.db.raidcdstatus == nil then FGL.db.raidcdstatus = FGL.db.defparam["raidcdstatus"] end
		FindGroupDB.RAIDCDSTATUS = FGL.db.raidcdstatus

	FGL.db.changebackdrop = FindGroupDB.changebackdrop
		if FGL.db.changebackdrop == nil then FGL.db.changebackdrop = FGL.db.defparam["changebackdrop"] end
		FindGroupDB.changebackdrop = FGL.db.changebackdrop

	FGL.db.closefindstatus = FindGroupDB.CLOSEFINDSTATUS
		if FGL.db.closefindstatus == nil then FGL.db.closefindstatus = FGL.db.defparam["closefindstatus"] end
		FindGroupDB.CLOSEFINDSTATUS = FGL.db.closefindstatus

	FGL.db.iconstatus = FindGroupDB.ICONSTATUS
		if FGL.db.iconstatus == nil then FGL.db.iconstatus = FGL.db.defparam["iconstatus"] end
		FindGroupDB.ICONSTATUS = FGL.db.iconstatus

	FGL.db.channelyellstatus = FindGroupDB.CHANNELYELLSTATUS
		if FGL.db.channelyellstatus == nil then FGL.db.channelyellstatus = FGL.db.defparam["channelyellstatus"] end
		FindGroupDB.CHANNELYELLSTATUS = FGL.db.channelyellstatus

	FGL.db.channelguildstatus = FindGroupDB.CHANNELGUILDSTATUS
		if FGL.db.channelguildstatus == nil then FGL.db.channelguildstatus = FGL.db.defparam["channelguildstatus"] end
		FindGroupDB.CHANNELGUILDSTATUS = FGL.db.channelguildstatus

	FGL.db.tooltipsstatus = FindGroupDB.TOOLTIPSSTATUS
		if FGL.db.tooltipsstatus == nil then FGL.db.tooltipsstatus = FGL.db.defparam["tooltipsstatus"] end
		FindGroupDB.TOOLTIPSSTATUS = FGL.db.tooltipsstatus

	FGL.db.framealpha = FindGroupDB.FRAMEALPHA
		if FGL.db.framealpha == nil then FGL.db.framealpha = FGL.db.defparam["framealpha"] end
		FindGroupOptionsInterfaceFrameSlider:SetValue(FGL.db.framealpha)
		FindGroupDB.FRAMEALPHA = FGL.db.framealpha

	FGL.db.framealphaback = FindGroupDB.FRAMEALPHABACK
		if FGL.db.framealphaback == nil then	FGL.db.framealphaback = FGL.db.defparam["framealphaback"] end
		FindGroupOptionsInterfaceFrameSliderBack:SetValue(FGL.db.framealphaback)
		FindGroupDB.FRAMEALPHABACK = FGL.db.framealphaback

	FGL.db.framealphafon = FindGroupDB.FRAMEALPHAFON
		if FGL.db.framealphafon == nil then FGL.db.framealphafon = FGL.db.defparam["framealphafon"] end
		FindGroupOptionsInterfaceFrameSliderFon:SetValue(FGL.db.framealphafon)
		FindGroupDB.FRAMEALPHAFON = FGL.db.framealphafon

	FGL.db.framescale = FindGroupDB.FRAMESCALE
		if FGL.db.framescale == nil then FGL.db.framescale = FGL.db.defparam["framescale"] end
		FindGroupOptionsInterfaceFrameSliderScale:SetValue(FGL.db.framescale)
		FindGroup_ScaleUpdate()
		FindGroupDB.FRAMESCALE = FGL.db.framescale

	FGL.db.linefadesec = FindGroupDB.LINEFADESEC
		if FGL.db.linefadesec == nil then FGL.db.linefadesec = FGL.db.defparam["linefadesec"] end
		FindGroupOptionsViewFindFrameSliderFade:SetValue(FGL.db.linefadesec)
		FindGroup_FadeUpdate()
		FindGroupDB.LINEFADESEC = FGL.db.linefadesec

	FGL.db.alarminst = FindGroupDB.ALARMINST
		if FGL.db.alarminst == nil then FGL.db.alarminst = FGL.db.defparam["alarminst"] end
		FindGroupDB.ALARMINST = FGL.db.alarminst

	FGL.db.alarmsound = FindGroupDB.ALARMSOUND
		if FGL.db.alarmsound == nil then FGL.db.alarmsound = FGL.db.defparam["alarmsound"] end
		FindGroupDB.ALARMSOUND = FGL.db.alarmsound

	FGL.db.alarmcd = FindGroupDB.ALARMCD
		if FGL.db.alarmcd == nil then FGL.db.alarmcd = FGL.db.defparam["alarmcd"] end
		FindGroupDB.ALARMCD = FGL.db.alarmcd
		
	FGL.db.raidfindstatus = FindGroupDB.RAIDFINDSTATUS
		if FGL.db.raidfindstatus == nil then FGL.db.raidfindstatus = FGL.db.defparam["raidfindstatus"] end
		FindGroupDB.RAIDFINDSTATUS = FGL.db.raidfindstatus

	FGL.db.classfindstatus = FindGroupDB.CLASSFINDSTATUS
		if FGL.db.classfindstatus == nil then FGL.db.classfindstatus = FGL.db.defparam["classfindstatus"] end
		FindGroupDB.CLASSFINDSTATUS = FGL.db.classfindstatus
		
	FGL.db.instsplitestatus = FindGroupDB.instsplitestatus
		if FGL.db.instsplitestatus == nil then FGL.db.instsplitestatus = FGL.db.defparam["instsplitestatus"] end
		FindGroupDB.instsplitestatus = FGL.db.instsplitestatus

	FGL.db.defbackground = FindGroupDB.DEFBACKGROUND
		if FGL.db.defbackground == nil then FGL.db.defbackground = FGL.db.defparam["defbackground"] end
		FindGroupDB.DEFBACKGROUND = FGL.db.defbackground
		FindGroup_SetBackGround()

	FGL.db.alarmir = FindGroupDB.ALARMIR
		if FGL.db.alarmir == nil then FGL.db.alarmir = FGL.db.defparam["alarmir"] end
		FindGroupDB.ALARMIR = FGL.db.alarmir	

	FGL.db.minimapiconshow = FindGroupDB.MINIMAPICONSHOW
		if FGL.db.minimapiconshow == nil then FGL.db.minimapiconshow = FGL.db.defparam["minimapiconshow"] end
		FindGroupDB.MINIMAPICONSHOW = FGL.db.minimapiconshow

	FGL.db.minimapiconfree = FindGroupDB.MINIMAPICONFREE
		if FGL.db.minimapiconfree == nil then FGL.db.minimapiconfree = FGL.db.defparam["minimapiconfree"] end
		FindGroupDB.MINIMAPICONFREE = FGL.db.minimapiconfree

	FGL.db.configindex = FindGroupDB.CONFIGINDEX
		if FGL.db.configindex == nil then FGL.db.configindex = 1 end
		FindGroupDB.CONFIGINDEX = FGL.db.configindex
		getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[FGL.db.configindex].."Frame"):Show()
		getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[FGL.db.configindex]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
		getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[FGL.db.configindex]):LockHighlight()

	local flag=true
	for h=1,3 do 
		if not FGL.db.needs[h] then flag = false end
	end
	if flag then
		FindGroupOptionsViewFindFrameCheckButton1:Disable()
		FGL.db.iconstatus = 1
		FindGroupDB.ICONSTATUS = FGL.db.iconstatus
	else
		FindGroupOptionsViewFindFrameCheckButton1:Enable()
		FGL.db.iconstatus = 1
		FindGroupDB.ICONSTATUS = FGL.db.iconstatus
	end
end

local FindGroup_ResetAllConfig = function()
FindGroup_CreateOff()
FGL.db.createstatus = 1
FindGroup_CreateButton()

local buff = FindGroupDB.FGS
local buff2 = FindGroupDB.usingtime
local buff3 = FindGroupDB.setcode
local buff4 = FindGroupDB.firstrun
local buff5 = FindGroupDB.lowversion

FindGroupDB = {}

FindGroupDB.FGS = buff
FindGroupDB.usingtime = buff2
FindGroupDB.setcode = buff3
FindGroupDB.firstrun = buff4
FindGroupDB.lowversion = buff5
FindGroupDB.FGC =nil

FindGroup_LoadConfig()
FindGroup_CloseInfo()

FindGroupOptionsFrame:Hide()
FindGroupShadow:Hide()
FindGroupChannel:Hide()
FindGroupShowText:Hide()
FindGroupTooltip:Hide()
GameTooltip:Hide()
FindGroupConfigFrameH:Hide()
FindGroupFrame:Show()


FGC_OnLoad()

FindGroupSaves_OnLoad()
FindGroup_ShowMinimapIcon()
FindGroupOptionsFrame:ClearAllPoints()
FindGroupOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
FindGroupChannel:ClearAllPoints()
FindGroupChannel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
FindGroupShowText:ClearAllPoints()
FindGroupShowText:SetPoint("BOTTOMLEFT", FindGroupFrame, "TOPLEFT", 0, 2)
end

local FINDGROUP_CONFIRM_CLEAR_CONFIG = "Are you sure you want to reset all settings to default?"
StaticPopupDialogs["FINDGROUP_CONFIRM_CLEAR_CONFIG"] = {
	text = FINDGROUP_CONFIRM_CLEAR_CONFIG,
	button1 = YES,
	button2 = NO,
	enterClicksFirstButton = 0, -- YES on enter
	hideOnEscape = 1, -- NO on escape
	timeout = 0,
	OnAccept = FindGroup_ResetAllConfig,
}



function FindGroup_OnLoad()
	FindGroup_LoadConfig()

	-- slash command
	SLASH_FindGroup1 = "/FindGroup";
	SLASH_FindGroup2 = "/fg";  
	SlashCmdList["FindGroup"] = function (msg)
		if msg == "show" or msg == "open" then
			FindGroup_ShowWindow()
		elseif msg == "hide" or msg == "close" then
			FindGroup_HideWindow()
		elseif msg == "reset" then
			StaticPopup_Show("FINDGROUP_CONFIRM_CLEAR_CONFIG")
		elseif msg:find("conf") then
			FindGroup_ShowOptions()
		elseif msg == FindGroup_ShowText1(1) then
			FindGroup_ShowText1()
		elseif msg == "toggle" then
			if FGL.db.showstatus == 1 then
			FindGroup_HideWindow()
			else
			FindGroup_ShowWindow()
			end
		else
			FindGroup_ShowWindow()
		end
	end
FGL.db.includeaddon = 1
FindGroup_LoadMinimapIcon()
FindGroup_ScrollChanged(FindGroupFrameSlider:GetValue())
FindGroupFrame:EnableMouseWheel(true)
FindGroupFrame:SetScript("OnMouseWheel", function(self, delta)
if FindGroupFrameSlider:IsEnabled() then
	FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue()-delta) end
end)
				if FindGroupDB.setcode then 
					FindGroupInfofText5:Show() 
					FindGroupInfoText3:Show()
					FindGroupInfoButton5:Show()
					FindGroupInfoButton6:Show()
				end
				if FindGroupDB.lowversion then
					FindGroupInfoVesr:Show()
				end
end
