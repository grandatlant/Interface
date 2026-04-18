import os

addon_dir = 'c:/CircleL/Interface/AddOns/FindGroup/'

# Dictionary of replacements
replacements = {
    # FindGroup.xml
    'text="Инст:"': 'text="Inst:"',
    'text="Режим:"': 'text="Mode:"',
    'text="Секунды"': 'text="Sec"',
    'text="Защита"': 'text="Tank"',
    'text="Лечение"': 'text="Healer"',
    'text="Атака"': 'text="DPS"',
    'text="Каналы:"': 'text="Channels:"',
    'text="ок"': 'text="OK"',
    'text="Запустить"': 'text="Start"',
    'text="каналы"': 'text="channels"',
    'text="классы"': 'text="classes"',
    'text="роли"': 'text="roles"',
    'text="текст"': 'text="text"',
    'text="опов.."': 'text="alerts"',
    'text="Лечить союзников"': 'text="Heal allies"',
    'text="Наносить урон врагам"': 'text="Damage enemies"',
    'text="Отводить все удары врагов на себя"': 'text="Take all enemy hits"',
    'text="Фоновый Режим"': 'text="Background Mode"',
    'text="Вкл/откл"': 'text="Toggle"',
    'text="Очистить"': 'text="Clear"',
    'text="Добавить"': 'text="Add"',
    'text="Принять"': 'text="Accept"',
    'text="Отменить"': 'text="Cancel"',
    'text="Версия"': 'text="Version"',
    'text="(Устарело)"': 'text="(Outdated)"',
    'text="Язык"': 'text="Language"',
    'text="Русский"': 'text="English"',
    'text="Авторы"': 'text="Authors"',
    'text="Пожертвование"': 'text="Donation"',
    'text="Пользователей"': 'text="Users"',
    'Кликните чтобы выделить, нажмите Ctrl+C для копирования.': 'Click to highlight, press Ctrl+C to copy.',
    'text="Закрыть"': 'text="Close"',
    'text="Пользователи аддона FindGroup: Link"': 'text="FindGroup: Link Addon Users"',
    'text="Билд"': 'text="Build"',
    'text="Уровень"': 'text="Level"',
    'text="Установка"': 'text="Setup"',
    'text="Используется"': 'text="Used"',
    'text="Имя"': 'text="Name"',
    'По-настоящему любит FindGroup!': 'Truly loves FindGroup!',

    # FindGroupOptions.xml
    'text="Отмена"': 'text="Cancel"',
    'text="Сохранить"': 'text="Save"',
    'text="По умолчанию"': 'text="Default"',
    'text="Поиск:"': 'text="Search:"',
    'text="   Правила"': 'text="   Rules"',
    'text="   Вид"': 'text="   View"',
    'text="   Оповещение"': 'text="   Alerts"',
    'text="Сбор:"': 'text="Create:"',
    'text="Интерфейс"': 'text="Interface"',
    'text="   Главное окно"': 'text="   Main Window"',
    'text="   Кнопка миникарты"': 'text="   Minimap Button"',
    'text="Правила поиска:"': 'text="Search Rules:"',
    'text="Производить поиск для:"': 'text="Search for:"',
    'text="Каналы для сканирования:"': 'text="Channels to scan:"',
    'text="Глобальные каналы"': 'text="Global Channels"',
    'text="Каналы Гильдии"': 'text="Guild Channels"',
    'text="Канал Yell (крикнуть)"': 'text="Yell Channel"',
    'text="Вид поиска:"': 'text="Search View:"',
    'text="Отображать иконки всех ролей"': 'text="Display all role icons"',
    'text="Отображать фон инста"': 'text="Display instance preview"',
    'text="Отображать инсты с КД"': 'text="Display instances with CD"',
    'text="Отображать сокращения"': 'text="Display abbreviations"',
    'text="Отображать свои сообщения"': 'text="Display own messages"',
    'text="Отображать чужие классы"': 'text="Display other classes"',
    'text="Скорость ухода строк:"': 'text="Line fade speed:"',
    'text="Интерфейс:"': 'text="Interface:"',
    'text="Показывать подсказки"': 'text="Show tooltips"',
    'text="Заставка:"': 'text="Background:"',
    'text="Прозрачность Окон:"': 'text="Window Opacity:"',
    'text="Прозрачность Заставки:"': 'text="Background Opacity:"',
    'text="Прозрачность Фона:"': 'text="Inner Background Opacity:"',
    'text="Масштаб Окон:"': 'text="Window Scale:"',
    'text="Оповещение:"': 'text="Alerts:"',
    'text="Оповещение для патчей:"': 'text="Alerts for patches:"',
    'text="Звук:"': 'text="Sound:"',
    'text="Оповещать только без КД"': 'text="Alert only without CD"',
    'Воспроизведение': 'Play',
    'Клик:': 'Click:',
    'text="Просмотр"': 'text="Preview"',
    'Тестовое сообщение!': 'Test message!',
    'text="Настройка вида для сбора:"': 'text="Create View Settings:"',
    'text="Отображать патчи в окне сбора:"': 'text="Display patches in create window:"',
    'text="Правила сбора:"': 'text="Create Rules:"',
    'text="Сокращать текст сбора"': 'text="Shorten create text"',
    'text="Писать ник рейд лидера"': 'text="Write Raid Leader name"',
    'text="Автостоп"': 'text="Auto Stop"',
    'text="ID подземелий"': 'text="Dungeon ID"',
    'text="Кнопка миникарты:"': 'text="Minimap Button:"',
    'text="Отображать кнопку у миникарты"': 'text="Display minimap button"',
    'text="Свободное перемещение"': 'text="Free move"',

    # FindGroup_Create.lua
    'return "ов"': 'return "s"',
    'return "а"': 'return "s"',
    'msg.." все"': 'msg.." all"',
    'msg.." гер."': 'msg.." HC"',
    'msg.." об."': 'msg.." NM"',
    'ТРИГЕР': 'TRIGGER',
    'spec = "Защита"': 'spec = "Protection"',
    'spec = "Исцеление"': 'spec = "Restoration"',
    'spec = "Свет"': 'spec = "Holy"',
    'spec = "Послушание"': 'spec = "Discipline"',
    'spec = "Баланс"': 'spec = "Balance"',
    'spec = "Оружие"': 'spec = "Arms"',
    'spec = "Неистовство"': 'spec = "Fury"',
    'spec = "Воздаяние"': 'spec = "Retribution"',
    'spec = "Совершенствование"': 'spec = "Enhancement"',
    'spec = "Стихии"': 'spec = "Elemental"',
    'spec = "Тьма"': 'spec = "Shadow"',

    # FindGroup_Find.lua
    'расстояние между словосочетаниями': 'distance between phrases',
    'баг с доп дд': 'bug with extra dps',

    # FindGroup_Init.lua
    '5об': '5nm',
    '5гер': '5hc',
    '10об': '10nm',
    '10гер': '10hc',
    '25об': '25nm',
    '25гер': '25hc',
    'допускается верхний регистр': 'uppercase is allowed',
    'Invinсible.tga': 'Invincible.tga', # Fix cyrillic c in filename

    # FindGroup_Main.lua
    '"нидд"': '"need"',
    '"пздц"': '"fuck"',
    '" и "': '" and "',
    '"желательно "': '""',
    '"желательно"': '""',
    'Изменение разрешения дисплея': 'Change display resolution',
    'Изменение уровня игрока': 'Change player level',
    'Список патчей': 'Patch list',
    'Оповещение патчи': 'Alert patches',
    'Сбор патчи': 'Create patches',

    # FindGroup_Minimap.lua
    'name="Открыть окно поиска"': 'name="Open Search Window"',
    'name="Выключить оповещение"': 'name="Disable Alerts"',
    'name="Открыть окно сбора"': 'name="Open Create Window"',
    'name="Кд список"': 'name="Saves List"',
    'name="Hастройки"': 'name="Settings"', # Has a cyrillic а
    'SetText("Выключить оповещение")': 'SetText("Disable Alerts")',
    'SetText("Включить оповещение")': 'SetText("Enable Alerts")',

    # FindGroup_Saves.lua
    'local headtext = "Сохраненные подземелья"': 'local headtext = "Saved Dungeons"',
    '-- Вонючка': '-- Festergut',
    '-- Прелесть': '-- Rotface',
    '-- скелеты у вали': '-- Valithria skeletons',
    '-- Балтар Рожденный в Битве': '-- Baltharus the Warborn',
    '-- Генерал Заритриан': '-- General Zarithrian',
    '-- Савиана Огненная Пропасть': '-- Saviana Ragefire',
    '-- Халион <Сумеречный разрушитель>': '-- Halion <The Twilight Destroyer>',
    'name="Алгалон"': 'name="Algalon"',
    'name="Фрейя"': 'name="Freya"',
    'name="Ходир"': 'name="Hodir"',
    'name="Мимирон"': 'name="Mimiron"',
    'name="Торим"': 'name="Thorim"',
    'name="Битва на Кораблях"': 'name="Gunship Battle"',
    '.."(гер.)"': '.." (HC)"',
    'spec = "Неизвестно"': 'spec = "Unknown"',
    ':find("гер")': ':find("HC")',
    '.." (гер.)"': '.." (HC)"',
    '.."д "..hours.."ч "..minutes.."м"': '.."d "..hours.."h "..minutes.."m"',
    'SetText("Пользователи")': 'SetText("Users")',
    'local msg = "Вы уверены что хотите отправить всем текущим игрокам:\\n"': 'local msg = "Are you sure you want to send to all current players:\\n"',
    '.."(гер.)"': '.." (HC)"', # Duplicate just in case
    '\\nБосов убито (': '\\nBosses killed (',
    '\\nИгроки (': '\\nPlayers (',
    'local msg = "Вы действительно хотите удалить игрока [%s%s|r] из этого списка с ID-%d?"': 'local msg = "Do you really want to remove player [%s%s|r] from this list with ID-%d?"',
    'name="Шепот"': 'name="Whisper"',
    'name="Пригласить"': 'name="Invite"',
    'name="Добавить друга"': 'name="Add friend"',
    'name="Черный список"': 'name="Ignore"',
    'name="Удалить"': 'name="Delete"',
    'name="Отмена"': 'name="Cancel"',
    '\\r|cffaaffaaКликните для проверки местоположения..."': '\\r|cffaaffaaClick to check location..."',
    '\\r|cffaaffaaПроверка местоположения..."': '\\r|cffaaffaaChecking location..."',
    # Hooks:
    '"должны быть вашими"': '"must be your"',
    '"уже есть в вашем списке"': '"is already on your"',
    '"Игрок не найден"': '"not found"',
    '"Вы добавили"': '"You have added"',
    '"Вы удалили"': '"You have removed"',
}

files_to_update = [
    'FindGroup.xml',
    'FindGroupOptions.xml',
    'FindGroup_Create.lua',
    'FindGroup_Find.lua',
    'FindGroup_Init.lua',
    'FindGroup_Main.lua',
    'FindGroup_Minimap.lua',
    'FindGroup_Saves.lua'
]

for f in files_to_update:
    path = os.path.join(addon_dir, f)
    try:
        with open(path, 'r', encoding='utf-8') as file:
            content = file.read()
            
        original_content = content
        
        for k, v in replacements.items():
            content = content.replace(k, v)
            
        if content != original_content:
            with open(path, 'w', encoding='utf-8') as file:
                file.write(content)
            print(f"Updated {f}")
        else:
            print(f"No changes matched in {f}")
    except Exception as e:
        print(f"Error processing {f}: {e}")
