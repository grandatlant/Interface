-- -------------------------------------------------------------------------- --
-- FREAK Gear Data                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- Notes:                                                                     --
-- The main gear validation is done in FREAK:ValidateItem().                  --
--                                                                            --
-- If you find a wrong itemID or if an itemID is missing please contact me at --
-- wowace.com forum. Thanks.                                                  --
--                                                                            --
-- -------------------------------------------------------------------------- --


FREAK_GearData = {}
-- ------------------------------------------------------------------------------------------------------------------ --
-- 4080 - A Tribute to Dedicated Insanity START                                                                       --
-- ------------------------------------------------------------------------------------------------------------------ --
--                                                                                                                    --
-- Achievement Description:                                                                                           --
-- Meet the criteria for A Tribute to Insanity without any raid member having used an item only obtainable from       --
-- 25-player Coliseum, or any more powerful item.                                                                     --
--                                                                                                                    --
--                                                                                                                    --
-- From Daelo, Lead Designer Encounter:                                                                               --
-- (Source: http://forums.worldofwarcraft.com/thread.html?topicId=19820876298&pageNo=2&sid=1#21)                      --
--                                                                                                                    --
-- You can use:                                                                                                       --
-- - Any item below item level 245.                                                                                   --
-- - The item level 245 set pieces that drop from 25-player Trial of the Crusader but also appear in the 10-player    --
--   Tribute Chest.                                                                                                   --
-- - Any gear that drops in 10-player Trial of the Crusader or Trial of the Grand Crusader, including item level 245  --
--   Trial of the Grand Crusader drops and item level 258 cloaks from the 10-player Tribute Chest.                    --
-- - Any item level 245 items purchased with Badges of Triumph.                                                       --
-- - Any item level 245 Bind on Equip item, including crafted pieces.                                                 --
--                                                                                                                    --
-- You cannot use:                                                                                                    --
-- - Any item level 245 item not included above (primarily Bind on Pickup drops from 25-player Trial of the Crusader, --
--   but also notably Val'anyr).                                                                                      --
-- - Any item over item level 245 except for the 10-player Tribute cloak.                                             --
-- - Any higher item level loot introduced in future patches (25 player Onyxia 245s, Icecrown loot in the future,     --
--   etc.)                                                                                                            --
--                                                                                                                    --
-- ------------------------------------------------------------------------------------------------------------------ --
FREAK_GearData[1] = {}
FREAK_GearData[1].achievementID = 4080 -- A Tribute to Dedicated Insanity
FREAK_GearData[1].gear = {
-- Trial of the Crusader 25player / Vault of Archavon (Set Pieces - 'Trophy of the Crusade' Items - ItemLevel 245)
[47753] = 1, -- Khadgar's Gauntlets of Triumph
[47754] = 1, -- Khadgar's Hood of Triumph
[47755] = 1, -- Khadgar's Leggings of Triumph
[47756] = 1, -- Khadgar's Robe of Triumph
[47757] = 1, -- Khadgar's Shoulderpads of Triumph
[47768] = 1, -- Sunstrider's Shoulderpads of Triumph
[47769] = 1, -- Sunstrider's Robe of Triumph
[47770] = 1, -- Sunstrider's Leggings of Triumph
[47771] = 1, -- Sunstrider's Hood of Triumph
[47772] = 1, -- Sunstrider's Gauntlets of Triumph
[47778] = 1, -- Kel'Thuzad's Hood of Triumph
[47779] = 1, -- Kel'Thuzad's Robe of Triumph
[47780] = 1, -- Kel'Thuzad's Leggings of Triumph
[47781] = 1, -- Kel'Thuzad's Shoulderpads of Triumph
[47782] = 1, -- Kel'Thuzad's Gloves of Triumph
[47803] = 1, -- Gul'dan's Gloves of Triumph
[47804] = 1, -- Gul'dan's Hood of Triumph
[47805] = 1, -- Gul'dan's Leggings of Triumph
[47806] = 1, -- Gul'dan's Robe of Triumph
[47807] = 1, -- Gul'dan's Shoulderpads of Triumph
[47983] = 1, -- Velen's Gloves of Triumph
[47984] = 1, -- Velen's Cowl of Triumph
[47985] = 1, -- Velen's Leggings of Triumph
[47986] = 1, -- Velen's Robe of Triumph
[47987] = 1, -- Velen's Shoulderpads of Triumph
[48062] = 1, -- Zabra's Shoulderpads of Triumph
[48063] = 1, -- Zabra's Robe of Triumph
[48064] = 1, -- Zabra's Leggings of Triumph
[48065] = 1, -- Zabra's Cowl of Triumph
[48066] = 1, -- Zabra's Gloves of Triumph
[48077] = 1, -- Velen's Handwraps of Triumph
[48078] = 1, -- Velen's Circlet of Triumph
[48079] = 1, -- Velen's Pants of Triumph
[48080] = 1, -- Velen's Raiments of Triumph
[48081] = 1, -- Velen's Mantle of Triumph
[48092] = 1, -- Zabra's Mantle of Triumph
[48093] = 1, -- Zabra's Raiments of Triumph
[48094] = 1, -- Zabra's Pants of Triumph
[48095] = 1, -- Zabra's Circlet of Triumph
[48096] = 1, -- Zabra's Handwraps of Triumph
[48133] = 1, -- Malfurion's Handguards of Triumph
[48134] = 1, -- Malfurion's Headpiece of Triumph
[48135] = 1, -- Malfurion's Leggings of Triumph
[48136] = 1, -- Malfurion's Robe of Triumph
[48137] = 1, -- Malfurion's Spaulders of Triumph
[48148] = 1, -- Runetotem's Spaulders of Triumph
[48149] = 1, -- Runetotem's Robe of Triumph
[48150] = 1, -- Runetotem's Leggings of Triumph
[48151] = 1, -- Runetotem's Headpiece of Triumph
[48152] = 1, -- Runetotem's Handguards of Triumph
[48163] = 1, -- Malfurion's Gloves of Triumph
[48164] = 1, -- Malfurion's Cover of Triumph
[48165] = 1, -- Malfurion's Trousers of Triumph
[48166] = 1, -- Malfurion's Vestments of Triumph
[48167] = 1, -- Malfurion's Mantle of Triumph
[48178] = 1, -- Runetotem's Mantle of Triumph
[48179] = 1, -- Runetotem's Vestments of Triumph
[48180] = 1, -- Runetotem's Trousers of Triumph
[48181] = 1, -- Runetotem's Cover of Triumph
[48182] = 1, -- Runetotem's Gloves of Triumph
[48193] = 1, -- Runetotem's Handgrips of Triumph
[48194] = 1, -- Runetotem's Headguard of Triumph
[48195] = 1, -- Runetotem's Legguards of Triumph
[48196] = 1, -- Runetotem's Raiments of Triumph
[48197] = 1, -- Runetotem's Shoulderpads of Triumph
[48208] = 1, -- Malfurion's Shoulderpads of Triumph
[48209] = 1, -- Malfurion's Raiments of Triumph
[48210] = 1, -- Malfurion's Legguards of Triumph
[48211] = 1, -- Malfurion's Headguard of Triumph
[48212] = 1, -- Malfurion's Handgrips of Triumph
[48223] = 1, -- VanCleef's Breastplate of Triumph
[48224] = 1, -- VanCleef's Gauntlets of Triumph
[48225] = 1, -- VanCleef's Helmet of Triumph
[48226] = 1, -- VanCleef's Legplates of Triumph
[48227] = 1, -- VanCleef's Pauldrons of Triumph
[48238] = 1, -- Garona's Pauldrons of Triumph
[48239] = 1, -- Garona's Legplates of Triumph
[48240] = 1, -- Garona's Helmet of Triumph
[48241] = 1, -- Garona's Gauntlets of Triumph
[48242] = 1, -- Garona's Breastplate of Triumph
[48255] = 1, -- Windrunner's Tunic of Triumph
[48256] = 1, -- Windrunner's Handguards of Triumph
[48257] = 1, -- Windrunner's Headpiece of Triumph
[48258] = 1, -- Windrunner's Legguards of Triumph
[48259] = 1, -- Windrunner's Spaulders of Triumph
[48270] = 1, -- Windrunner's Spaulders of Triumph
[48271] = 1, -- Windrunner's Legguards of Triumph
[48272] = 1, -- Windrunner's Headpiece of Triumph
[48273] = 1, -- Windrunner's Handguards of Triumph
[48274] = 1, -- Windrunner's Tunic of Triumph
[48285] = 1, -- Nobundo's Tunic of Triumph
[48286] = 1, -- Nobundo's Handguards of Triumph
[48287] = 1, -- Nobundo's Headpiece of Triumph
[48288] = 1, -- Nobundo's Legguards of Triumph
[48289] = 1, -- Nobundo's Spaulders of Triumph
[48300] = 1, -- Thrall's Tunic of Triumph
[48301] = 1, -- Thrall's Handguards of Triumph
[48302] = 1, -- Thrall's Headpiece of Triumph
[48303] = 1, -- Thrall's Legguards of Triumph
[48304] = 1, -- Thrall's Spaulders of Triumph
[48316] = 1, -- Nobundo's Hauberk of Triumph
[48317] = 1, -- Nobundo's Gloves of Triumph
[48318] = 1, -- Nobundo's Helm of Triumph
[48319] = 1, -- Nobundo's Kilt of Triumph
[48320] = 1, -- Nobundo's Shoulderpads of Triumph
[48331] = 1, -- Thrall's Shoulderpads of Triumph
[48332] = 1, -- Thrall's Kilt of Triumph
[48333] = 1, -- Thrall's Helm of Triumph
[48334] = 1, -- Thrall's Gloves of Triumph
[48335] = 1, -- Thrall's Hauberk of Triumph
[48346] = 1, -- Nobundo's Chestguard of Triumph
[48347] = 1, -- Nobundo's Grips of Triumph
[48348] = 1, -- Nobundo's Faceguard of Triumph
[48349] = 1, -- Nobundo's War-Kilt of Triumph
[48350] = 1, -- Nobundo's Shoulderguards of Triumph
[48361] = 1, -- Thrall's Shoulderguards of Triumph
[48362] = 1, -- Thrall's War-Kilt of Triumph
[48363] = 1, -- Thrall's Faceguard of Triumph
[48364] = 1, -- Thrall's Grips of Triumph
[48365] = 1, -- Thrall's Chestguard of Triumph
[48376] = 1, -- Wrynn's Battleplate of Triumph
[48377] = 1, -- Wrynn's Gauntlets of Triumph
[48378] = 1, -- Wrynn's Helmet of Triumph
[48379] = 1, -- Wrynn's Legplates of Triumph
[48380] = 1, -- Wrynn's Shoulderplates of Triumph
[48391] = 1, -- Hellscream's Battleplate of Triumph
[48392] = 1, -- Hellscream's Gauntlets of Triumph
[48393] = 1, -- Hellscream's Helmet of Triumph
[48394] = 1, -- Hellscream's Legplates of Triumph
[48395] = 1, -- Hellscream's Shoulderplates of Triumph
[48430] = 1, -- Wrynn's Greathelm of Triumph
[48446] = 1, -- Wrynn's Legguards of Triumph
[48450] = 1, -- Wrynn's Breastplate of Triumph
[48452] = 1, -- Wrynn's Handguards of Triumph
[48454] = 1, -- Wrynn's Pauldrons of Triumph
[48461] = 1, -- Hellscream's Breastplate of Triumph
[48462] = 1, -- Hellscream's Handguards of Triumph
[48463] = 1, -- Hellscream's Greathelm of Triumph
[48464] = 1, -- Hellscream's Legguards of Triumph
[48465] = 1, -- Hellscream's Pauldrons of Triumph
[48481] = 1, -- Thassarian's Battleplate of Triumph
[48482] = 1, -- Thassarian's Gauntlets of Triumph
[48483] = 1, -- Thassarian's Helmet of Triumph
[48484] = 1, -- Thassarian's Legplates of Triumph
[48485] = 1, -- Thassarian's Shoulderplates of Triumph
[48496] = 1, -- Koltira's Shoulderplates of Triumph
[48497] = 1, -- Koltira's Legplates of Triumph
[48498] = 1, -- Koltira's Helmet of Triumph
[48499] = 1, -- Koltira's Gauntlets of Triumph
[48500] = 1, -- Koltira's Battleplate of Triumph
[48538] = 1, -- Thassarian's Chestguard of Triumph
[48539] = 1, -- Thassarian's Handguards of Triumph
[48540] = 1, -- Thassarian's Faceguard of Triumph
[48541] = 1, -- Thassarian's Legguards of Triumph
[48542] = 1, -- Thassarian's Pauldrons of Triumph
[48553] = 1, -- Koltira's Pauldrons of Triumph
[48554] = 1, -- Koltira's Legguards of Triumph
[48555] = 1, -- Koltira's Faceguard of Triumph
[48556] = 1, -- Koltira's Handguards of Triumph
[48557] = 1, -- Koltira's Chestguard of Triumph
[48575] = 1, -- Turalyon's Tunic of Triumph
[48576] = 1, -- Turalyon's Gloves of Triumph
[48577] = 1, -- Turalyon's Headpiece of Triumph
[48578] = 1, -- Turalyon's Greaves of Triumph
[48579] = 1, -- Turalyon's Spaulders of Triumph
[48590] = 1, -- Liadrin's Spaulders of Triumph
[48591] = 1, -- Liadrin's Greaves of Triumph
[48592] = 1, -- Liadrin's Headpiece of Triumph
[48593] = 1, -- Liadrin's Gloves of Triumph
[48594] = 1, -- Liadrin's Tunic of Triumph
[48607] = 1, -- Turalyon's Battleplate of Triumph
[48608] = 1, -- Turalyon's Gauntlets of Triumph
[48609] = 1, -- Turalyon's Helm of Triumph
[48610] = 1, -- Turalyon's Legplates of Triumph
[48611] = 1, -- Turalyon's Shoulderplates of Triumph
[48622] = 1, -- Liadrin's Shoulderplates of Triumph
[48623] = 1, -- Liadrin's Legplates of Triumph
[48624] = 1, -- Liadrin's Helm of Triumph
[48625] = 1, -- Liadrin's Gauntlets of Triumph
[48626] = 1, -- Liadrin's Battleplate of Triumph
[48637] = 1, -- Turalyon's Shoulderguards of Triumph
[48638] = 1, -- Turalyon's Legguards of Triumph
[48639] = 1, -- Turalyon's Faceguard of Triumph
[48640] = 1, -- Turalyon's Handguards of Triumph
[48641] = 1, -- Turalyon's Breastplate of Triumph
[48657] = 1, -- Liadrin's Breastplate of Triumph
[48658] = 1, -- Liadrin's Handguards of Triumph
[48659] = 1, -- Liadrin's Faceguard of Triumph
[48660] = 1, -- Liadrin's Legguards of Triumph
[48661] = 1, -- Liadrin's Shoulderguards of Triumph

-- Trial of the Crusader 10player Heroic
-- Tribute Chest:
-- ItemLevel 258: (This are the only ilvl >245 items that are allowed.)
[48666] = 1, -- Drape of the Sunreavers
[48667] = 1, -- Shawl of the Devout Crusader
[48668] = 1, -- Cloak of Serrated Blades
[48669] = 1, -- Cloak of the Triumphant Combatant
[48670] = 1, -- Cloak of the Unflinching Guardian
[48671] = 1, -- Drape of Bitter Incantation
[48672] = 1, -- Shawl of Fervent Crusader
[48673] = 1, -- Cloak of the Silver Covenant
[48674] = 1, -- Cloak of the Victorious Combatant
[48675] = 1, -- Cloak of the Unmoving Guardian
-- ItemLevel 245:
[48693] = 1, -- Heartsmasher
[48695] = 1, -- Mor'kosh, the Bloodreaver
[48697] = 1, -- Frenzystrike Longbow
[48699] = 1, -- Blood and Glory
[48701] = 1, -- Spellharvest
[48703] = 1, -- The Facebreaker
[48705] = 1, -- Attrition
[48708] = 1, -- Spellstorm Blade
[48709] = 1, -- Heartcrusher
[48710] = 1, -- Paragon's Breadth
[48711] = 1, -- Rhok'shalla, the Shadow's Bane
[48712] = 1, -- The Spinebreaker
[48713] = 1, -- Lothar's Edge
[48714] = 1, -- Honor of the Fallen
-- Drops:
-- ItemLevel 245: (Trial of the Crusader 10player Heroic)
[47915] = 1, -- Collar of Ceaseless Torment
[47916] = 1, -- Armbands of the Northern Stalker
[47917] = 1, -- Gauntlets of Rising Anger
[47918] = 1, -- Dreadscale Armguards
[47919] = 1, -- Acidmaw Boots
[47920] = 1, -- Carnivorous Band
[47921] = 1, -- Icehowl Cinch
[47922] = 1, -- Rod of Imprisoned Souls
[47923] = 1, -- Shoulderpads of the Glacial Wilds
[47924] = 1, -- Belt of the Frozen Reach
[47925] = 1, -- Girdle of the Impaler
[47926] = 1, -- Shoulderguards of the Spirit Walker
[47927] = 1, -- Felspark Bindings
[47928] = 1, -- Firestorm Ring
[47929] = 1, -- Belt of the Winter Solstice
[47930] = 1, -- Amulet of Binding Elements
[47931] = 1, -- Leggings of the Demonic Messenger
[47932] = 1, -- Girdle of the Farseer
[47933] = 1, -- Sentinel Scouting Greaves
[47934] = 1, -- Planestalker Signet
[47935] = 1, -- Armguards of the Nether Lord
[47937] = 1, -- Girdle of the Nether Champion
[47938] = 1, -- Dirk of the Night Watch
[47939] = 1, -- Endurance of the Infernal
[47940] = 1, -- Sandals of the Silver Magus
[47941] = 1, -- Blade of the Silver Disciple
[47942] = 1, -- Helm of the Silver Ranger
[47943] = 1, -- Faceplate of the Silver Champion
[47944] = 1, -- Pauldrons of the Silver Defender
[47945] = 1, -- Gloves of the Silver Assassin
[47946] = 1, -- Talisman of Volatile Power
[47947] = 1, -- Binding Light
[47948] = 1, -- Victor's Call
[47949] = 1, -- Fervor of the Frostborn
[47950] = 1, -- The Diplomat
[47951] = 1, -- Reckoning
[47952] = 1, -- Sabatons of the Lingering Vortex
[47953] = 1, -- Icefall Blade
[47954] = 1, -- Armor of Shifting Shadows
[47955] = 1, -- Loop of the Twin Val'kyr
[47956] = 1, -- Gloves of Looming Shadow
[47957] = 1, -- Darkbane Pendant
[47958] = 1, -- Chalice of Benedictus
[47959] = 1, -- Helm of the Snowy Grotto
[47960] = 1, -- Enlightenment
[47961] = 1, -- Gloves of the Azure Prophet
[47962] = 1, -- Argent Resolve
[47963] = 1, -- Vigilant Ward
[47964] = 1, -- Chestguard of the Warden
[47965] = 1, -- Helmet of the Crypt Lord
[47966] = 1, -- The Lion's Maw
[47967] = 1, -- Crusader's Glory
[47968] = 1, -- Cold Convergence
[47969] = 1, -- Pauldrons of the Timeless Hunter
[47970] = 1, -- Legplates of the Silver Hand
[47971] = 1, -- Westfall Saber
[47972] = 1, -- Spaulders of the Snow Bandit
[47973] = 1, -- The Grinder"
[47974] = 1, -- Vestments of the Sleepless
[47975] = 1, -- Baelgun's Heavy Crossbow
[47976] = 1, -- Legplates of the Immortal Spider
[47977] = 1, -- Cinch of the Undying
[47978] = 1, -- Bulwark of the Royal Guard
[47979] = 1, -- Fordragon Blades
[47988] = 1, -- Collar of Unending Torment
[47989] = 1, -- Bracers of the Northern Stalker
[47990] = 1, -- Gauntlets of Mounting Anger
[47991] = 1, -- Dreadscale Bracers
[47992] = 1, -- Acidmaw Treads
[47993] = 1, -- Gormok's Band
[47994] = 1, -- Icehowl Binding
[47995] = 1, -- Scepter of Imprisoned Souls
[47996] = 1, -- Pauldrons of the Glacial Wilds
[47997] = 1, -- Girdle of the Frozen Reach
[47998] = 1, -- Belt of the Impaler
[47999] = 1, -- Pauldrons of the Spirit Walker
[48000] = 1, -- Felspark Bracers
[48001] = 1, -- Firestorm Band
[48002] = 1, -- Belt of the Bloodhoof Emissary
[48003] = 1, -- Pendant of Binding Elements
[48004] = 1, -- Legwraps of the Demonic Messenger
[48005] = 1, -- Darkspear Ritual Binding
[48006] = 1, -- Warsong Poacher's Greaves
[48007] = 1, -- Planestalker Band
[48008] = 1, -- Armplates of the Nether Lord
[48009] = 1, -- Belt of the Nether Champion
[48010] = 1, -- Orcish Deathblade
[48011] = 1, -- Fortitude of the Infernal
[48012] = 1, -- Sunreaver Magus' Sandals
[48013] = 1, -- Sunreaver Disciple's Blade
[48014] = 1, -- Sunreaver Ranger's Helm
[48015] = 1, -- Sunreaver Champion's Faceplate
[48016] = 1, -- Sunreaver Defender's Pauldrons
[48017] = 1, -- Sunreaver Assassin's Gloves
[48018] = 1, -- Fetish of Volatile Power
[48019] = 1, -- Binding Stone
[48020] = 1, -- Vengeance of the Forsaken
[48021] = 1, -- Eitrigg's Oath
[48022] = 1, -- Widebarrel Flintlock
[48023] = 1, -- Edge of Agony
[48024] = 1, -- Greaves of the Lingering Vortex
[48025] = 1, -- Nemesis Blade
[48026] = 1, -- Vest of Shifting Shadows
[48027] = 1, -- Band of the Twin Val'kyr
[48028] = 1, -- Looming Shadow Wraps
[48030] = 1, -- Darkbane Amulet
[48032] = 1, -- Lightbane Focus
[48034] = 1, -- Helm of the High Mesa
[48036] = 1, -- Illumination
[48038] = 1, -- Sen'jin Ritualist Gloves
[48039] = 1, -- Mace of the Earthborn Chieftain
[48040] = 1, -- Pride of the Kor'kron
[48041] = 1, -- Stoneskin Chestplate
[48042] = 1, -- Helm of the Crypt Lord
[48043] = 1, -- Frostblade Hatchet
[48044] = 1, -- Ardent Guard
[48045] = 1, -- Perdition
[48046] = 1, -- Pauldrons of the Shadow Hunter
[48047] = 1, -- Legplates of the Redeemed Blood Knight
[48048] = 1, -- Forsaken Bonecarver
[48049] = 1, -- Shoulderpads of the Snow Bandit
[48050] = 1, -- Blackhorn Bludgeon
[48051] = 1, -- Robes of the Sleepless
[48052] = 1, -- Darkmaw Crossbow
[48053] = 1, -- Sunwalker Legguards
[48054] = 1, -- Belt of the Eternal
[48055] = 1, -- Aegis of the Coliseum
[48056] = 1, -- Anguish
--48693, -- Heartsmasher                   (ilvl 245 Tribute Chest - look above)
--48695, -- Mor'kosh, the Bloodreaver      (ilvl 245 Tribute Chest - look above)
--48697, -- Frenzystrike Longbow           (ilvl 245 Tribute Chest - look above)
--48699, -- Blood and Glory                (ilvl 245 Tribute Chest - look above)
--48701, -- Spellharvest                   (ilvl 245 Tribute Chest - look above)
--48703, -- The Facebreaker                (ilvl 245 Tribute Chest - look above)
--48705, -- Attrition                      (ilvl 245 Tribute Chest - look above)
--48708, -- Spellstorm Blade               (ilvl 245 Tribute Chest - look above)
--48709, -- Heartcrusher                   (ilvl 245 Tribute Chest - look above)
--48710, -- Paragon's Breadth              (ilvl 245 Tribute Chest - look above)
--48711, -- Rhok'shalla, the Shadow's Bane (ilvl 245 Tribute Chest - look above)
--48712, -- The Spinebreaker               (ilvl 245 Tribute Chest - look above)
--48713, -- Lothar's Edge                  (ilvl 245 Tribute Chest - look above)
--48714, -- Honor of the Fallen            (ilvl 245 Tribute Chest - look above)
[49233] = 1, -- Sandals of the Grieving Soul
[49234] = 1, -- Boots of the Grieving Soul
[49237] = 1, -- Sabatons of Tortured Space
[49238] = 1, -- Boots of Tortured Space

-- Emblem of Triumph Items
-- ItemLevel 245:
[47658] = 1, -- Brimstone Igniter
[47659] = 1, -- Crimson Star
[47660] = 1, -- Blades of the Sable Cross
[47661] = 1, -- Libram of Valiance
[47662] = 1, -- Libram of Veracity
[47664] = 1, -- Libram of Defiance
[47665] = 1, -- Totem of Calming Tides
[47666] = 1, -- Totem of Electrifying Wind
[47667] = 1, -- Totem of Quaking Earth
[47668] = 1, -- Idol of Mutilation
[47670] = 1, -- Idol of Lunar Fury
[47671] = 1, -- Idol of Flaring Growth
[47672] = 1, -- Sigil of Insolence
[47673] = 1, -- Sigil of Virulence
[47674] = 1, -- Helm of Thunderous Rampage
[47675] = 1, -- Faceplate of Thunderous Rampage
[47677] = 1, -- Faceplate of the Honorbound
[47678] = 1, -- Headplate of the Honorbound
[47681] = 1, -- Heaume of the Restless Watch
[47682] = 1, -- Helm of the Restless Watch
[47684] = 1, -- Coif of the Brooding Dragon
[47685] = 1, -- Helm of the Brooding Dragon
[47686] = 1, -- Helm of Inner Warmth
[47687] = 1, -- Headguard of Inner Warmth
[47688] = 1, -- Mask of Lethal Intent
[47689] = 1, -- Hood of Lethal Intent
[47690] = 1, -- Helm of Abundant Growth
[47691] = 1, -- Mask of Abundant Growth
[47692] = 1, -- Hood of Smoldering Aftermath
[47693] = 1, -- Hood of Fiery Aftermath
[47694] = 1, -- Helm of Clouded Sight
[47695] = 1, -- Hood of Clouded Sight
[47696] = 1, -- Shoulderplates of Trembling Rage
[47697] = 1, -- Pauldrons of Trembling Rage
[47698] = 1, -- Shoulderplates of Enduring Order
[47699] = 1, -- Shoulderguards of Enduring Order
[47701] = 1, -- Shoulderplates of the Cavalier
[47702] = 1, -- Pauldrons of the Cavalier
[47704] = 1, -- Epaulets of the Devourer
[47705] = 1, -- Pauldrons of the Devourer
[47706] = 1, -- Shoulders of the Groundbreaker
[47707] = 1, -- Mantle of the Groundbreaker
[47708] = 1, -- Duskstalker Shoulderpads
[47709] = 1, -- Duskstalker Pauldrons
[47710] = 1, -- Epaulets of the Fateful Accord
[47712] = 1, -- Shoulders of the Fateful Accord
[47713] = 1, -- Mantle of Catastrophic Emanation
[47714] = 1, -- Pauldrons of Catastrophic Emanation
[47715] = 1, -- Pauldrons of Revered Mortality
[47716] = 1, -- Mantle of Revered Mortality
[47729] = 1, -- Bloodshed Band
[47730] = 1, -- Dexterous Brightstone Ring
[47731] = 1, -- Clutch of Fortification
[47732] = 1, -- Band of the Invoker
[47733] = 1, -- Heartmender Circle
[47734] = 1, -- Mark of Supremacy
[47735] = 1, -- Glyph of Indomitability
[48722] = 1, -- Shard of the Crystal Heart
[48724] = 1, -- Talisman of Resurgence

-- Bind on Equip items, including crafted pieces
-- ItemLevel 245:
-- Bind on Equip (drops)
[46970] = 1, -- Drape of the Untamed Predator
[47089] = 1, -- Cloak of Displacement
[47105] = 1, -- The Executioner's Malice
[47149] = 1, -- Signet of the Traitor King
[47223] = 1, -- Ring of the Darkmender
[47257] = 1, -- Cloak of the Untamed Predator
[47278] = 1, -- Circle of the Darkmender
[47291] = 1, -- Shroud of Displacement
[47297] = 1, -- The Executioner's Vice
[47315] = 1, -- Band of the Traitor King
-- Bind on Equip (crafted)
[47570] = 1, -- Saronite Swordbreakers
[47571] = 1, -- Saronite Swordbreakers
[47572] = 1, -- Titanium Spikeguards
[47573] = 1, -- Titanium Spikeguards
[47574] = 1, -- Sunforged Bracers
[47575] = 1, -- Sunforged Bracers
[47576] = 1, -- Crusader's Dragonscale Bracers
[47577] = 1, -- Crusader's Dragonscale Bracers
[47579] = 1, -- Black Chitin Bracers
[47580] = 1, -- Black Chitin Bracers
[47581] = 1, -- Bracers of Swift Death
[47582] = 1, -- Bracers of Swift Death
[47583] = 1, -- Moonshadow Armguards
[47584] = 1, -- Moonshadow Armguards
[47585] = 1, -- Bejeweled Wizard's Bracers
[47586] = 1, -- Bejeweled Wizard's Bracers
[47587] = 1, -- Royal Moonshroud Bracers
[47588] = 1, -- Royal Moonshroud Bracers
[47589] = 1, -- Titanium Razorplate
[47590] = 1, -- Titanium Razorplate
[47591] = 1, -- Breastplate of the White Knight
[47592] = 1, -- Breastplate of the White Knight
[47593] = 1, -- Sunforged Breastplate
[47594] = 1, -- Sunforged Breastplate
[47595] = 1, -- Crusader's Dragonscale Breastplate
[47596] = 1, -- Crusader's Dragonscale Breastplate
[47597] = 1, -- Ensorcelled Nerubian Breastplate
[47598] = 1, -- Ensorcelled Nerubian Breastplate
[47599] = 1, -- Knightbane Carapace
[47600] = 1, -- Knightbane Carapace
[47601] = 1, -- Lunar Eclipse Robes
[47602] = 1, -- Lunar Eclipse Robes
[47603] = 1, -- Merlin's Robe
[47604] = 1, -- Merlin's Robe
[47605] = 1, -- Royal Moonshroud Robe
[47606] = 1, -- Royal Moonshroud Robe
}
-- ------------------------------------------------------------------------------------------------------------------ --
-- 4080 - A Tribute to Dedicated Insanity END                                                                         --
-- ------------------------------------------------------------------------------------------------------------------ --

-- ------------------------------------------------------------------------------------------------------------------ --
-- 3316 - Herald of the Titans START                                                                                  --
-- ------------------------------------------------------------------------------------------------------------------ --
--                                                                                                                    --
-- Achievement Description:                                                                                           --
-- Defeat Algalon the Observer in 10-player mode without anyone in the raid wearing any equipment with an item level  --
-- higher than is available in 10-player Ulduar.                                                                      --
--                                                                                                                    --
--                                                                                                                    --
-- This gear check is easy:                                                                                           --
-- (Source: The Internet ;) )                                                                                         --
-- - MainHandSlot, SecondaryHandSlot and RangedSlot can have items with max. ItemLevel 232.                           --
-- - Every other slot can have items with max. ItemLevel 226.                                                         --
--                                                                                                                    --
-- ------------------------------------------------------------------------------------------------------------------ --
FREAK_GearData[2] = {}
FREAK_GearData[2].achievementID = 3316 -- Herald of the Titans
-- FREAK_GearData[2].gear = {
-- nothing here
-- }
-- ------------------------------------------------------------------------------------------------------------------ --
-- 3316 - Herald of the Titans END                                                                                    --
-- ------------------------------------------------------------------------------------------------------------------ --