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

--[[

-- Atlas Data  (Russian)
-- Compiled by StingerSoft
-- stingersoft@gmail.com
-- Last Update: 27.09.2008

--]]

if ( GetLocale() == "ruRU" ) then

AtlasDLLocale = {

	--Common
	["Battlegrounds"] = "Поля сражений";
	["Blue"] = "Синий";
	["Dungeon Locations"] = "Расположение подземелий";
	["Instances"] = "Инстансы";
	["White"] = "Белый";

	--Places
	["Ahn'kahet: The Old Kingdom"] = "Ан'кахет: Старое Королевство";
	["Alterac Mountains"] = "Альтеракские горы";
	["Alterac Valley"] = "Альтеракская долина";
	["Arathi Basin"] = "Низина Арати";
	["Arathi Highlands"] = "Нагорье Арати";
	["Ashenvale"] = "Ясеневый лес";
	["Auchenai Crypts"] = "Аукенайские гробницы";
	["Auchindoun"] = "Аукиндон";
	["Azjol-Nerub"] = "Азжол-Неруб";
	["Azjol-Nerub: The Upper Kingdom"] = "Азжол-Неруб: Верхнее Королевство";
	["Badlands"] = "Бесплодные земли";
	["Black Temple"] = "Черный храм";
	["Blackfathom Deeps"] = "Непроглядная Пучина";
	["Blackrock Depths"] = "Глубины Черной горы";
	["Blackrock Mountain"] = "Черная гора";
	["Blackrock Spire"] = "Вершина Черной горы";
	["Blackwing Lair"] = "Логово Крыла Тьмы";
	["Blade's Edge Mountains"] = "Острогорье";
	["Caverns of Time"] = "Пещеры Времени";
	["Coilfang Reservoir"] = "Резервуар Кривого Клыка";
	["Coldarra"] = "Хладарра";
	["Crusaders' Coliseum"] = "Колизей Авангарда";
	["Dalaran"] = "Даларан";
	["Deadwind Pass"] = "Перевал Мертвого Ветра";
	["Desolace"] = "Пустоши";
	["Dire Maul"] = "Забытый Город";
	["Dragonblight"] = "Драконий Погост";
	["Drak'Tharon Keep"] = "Крепость Драк'Тарон";
	["Dun Morogh"] = "Дун Морог";
	["Dustwallow Marsh"] = "Пылевые топи";
	["Eastern Kingdoms"] = "Восточные королевства";
	["Eastern Plaguelands"] = "Восточное Лихоземье";
	["Feralas"] = "Фералас";
	["Ghostlands"] = "Призрачные земли";
	["Gnomeregan"] = "Гномреган";
	["Grizzly Hills"] = "Седые холмы";
	["Gruul's Lair"] = "Логово Груула";
	["Gundrak"] = "Гундрак";
	["Halls of Lightning"] = "Чертоги Молний";
	["Halls of Reflection"] = "Залы Отражений";
	["Halls of Stone"] = "Чертоги Камня";
	["Hellfire Citadel"] = "Цитадель Адского Пламени";
	["Hellfire Peninsula"] = "Полуостров Адского Пламени";
	["Hellfire Ramparts"] = "Бастионы Адского Пламени";
	["Hillsbrad Foothills"] = "Предгорья Хилсбрада";
	["Howling Fjord"] = "Ревущий фьорд";
	["Hyjal Summit"] = "Вершина Хиджала";
	["Icecrown Citadel"] = "Цитадель Ледяной Короны";
	["Icecrown"] = "Ледяная корона";
	["Isle of Quel'Danas"] = "Остров Кель'Данас";
	["Kalimdor"] = "Калимдор";
	["Karazhan"] = "Каражан";
	["Magisters' Terrace"] = "Терраса Магистров";
	["Magtheridon's Lair"] = "Логово Магтеридона";
	["Mana-Tombs"] = "Гробницы Маны";
	["Maraudon"] = "Мародон";
	["Molten Core"] = "Огненные Недра";
	["Naxxramas"] = "Наксрамас";
	["Netherstorm"] = "Пустоверть";
	["Northrend"] = "Нордскол";
	["Old Hillsbrad Foothills"] = "Старые предгорья Хилсбрада";
	["Onyxia's Lair"] = "Логово Ониксии";
	["Orgrimmar"] = "Оргриммар";
	["Outland"] = "Запределье";
	["Pit of Saron"] = "Яма Сарона";
	["Ragefire Chasm"] = "Огненная пропасть";
	["Razorfen Downs"] = "Курганы Иглошкурых";
	["Razorfen Kraul"] = "Лабиринты Иглошкурых";
	["Ruins of Ahn'Qiraj"] = "Руины Ан'Киража";
	["Scarlet Monastery"] = "Монастырь Алого ордена";
	["Scholomance"] = "Некроситет";
	["Serpentshrine Cavern"] = "Змеиное святилище";
	["Sethekk Halls"] = "Сетеккские залы";
	["Shadow Labyrinth"] = "Темный Лабиринт";
	["Shadowfang Keep"] = "Крепость Темного Клыка";
	["Shadowmoon Valley"] = "Долина Призрачной Луны";
	["Silithus"] = "Силитус";
	["Silverpine Forest"] = "Серебряный бор";
	["Stormwind City"] = "Штормград";
	["Stranglethorn Vale"] = "Тернистая долина";
	["Stratholme"] = "Стратхольм";
	["Stratholme Past"] = "Прошлое Стратхольма";
	["Sunken Temple"] = "Затонувший храм";
	["Sunwell Plateau"] = "Плато Солнечного Колодца";
	["Swamp of Sorrows"] = "Болото Печали";
	["Tanaris"] = "Танарис";
	["Tempest Keep"] = "Крепость Бурь";
	["Temple of Ahn'Qiraj"] = "Храм Ан'Киража";
	["Terokkar Forest"] = "Лес Тероккар";
	["The Arcatraz"] = "Аркатрац";
	["The Barrens"] = "Степи";
	["The Black Morass"] = "Черные топи";
	["The Blood Furnace"] = "Кузня Крови";
	["The Botanica"] = "Ботаника";
	["The Deadmines"] = "Мертвые копи";
	["The Eye of Eternity"] = "Глаз Вечности";
	["The Eye"] = "Око";
	["The Forge of Souls"] = "Кузня Душ";
	["The Frozen Halls"] = "Ледяные залы";
	["The Mechanar"] = "Механар";
	["The Nexus"] = "Нексус";
	["The Obsidian Sanctum"] = "Обсидиановое убежищ";
	["The Oculus"] = "Окулус";
	["The Ruby Sanctum"] = "Рубиновое святилище";
	["The Shattered Halls"] = "Разрушенные залы";
	["The Slave Pens"] = "Узилище";
	["The Steamvault"] = "Паровое Подземелье";
	["The Stockade"] = "Тюрьма";
	["The Storm Peaks"] = "Грозовая Гряда";
	["The Underbog"] = "Нижетопь";
	["The Violet Hold"] = "Аметистовая крепость";
	["Tirisfal Glades"] = "Тирисфальские леса";
	["Trial of the Champion"] = "Испытание чемпиона";
	["Trial of the Crusader"] = "Испытание крестоносца";
	["Uldaman"] = "Ульдаман";
	["Ulduar"] = "Ульдуар";
	["Utgarde Keep"] = "Крепость Утгард";
	["Utgarde Pinnacle"] = "Вершина Утгард";
	["Vault of Archavon"] = "Склеп Аркавона";
	["Wailing Caverns"] = "Пещеры Стенаний";
	["Warsong Gulch"] = "Ущелье Песни Войны";
	["Western Plaguelands"] = "Западное Лихоземье";
	["Westfall"] = "Западный Край";
	["Wintergrasp"] = "Озеро Ледяных Оков";
	["Zangarmarsh"] = "Зангартопь";
	["Zul'Aman"] = "Зул'Аман";
	["Zul'Drak"] = "Зул'Драк";
	["Zul'Farrak"] = "Зул'Фаррак";
	["Zul'Gurub"] = "Зул'Гуруб";

};
end
