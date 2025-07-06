local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("RageBar", "deDE")
if not L then return end

L["RageBar v1.02 loaded."] = "RageBar v1.02 laden."
L["has not been loaded, you are no warrior!"] = "nicht geladen, du bist kein Krieger!"
L["Options"] = "Optionen"
L["Frame lock"] = "Leiste sperren"
L["Locks the frame / unlocks the frame."] = "Sperrt die Leiste / gibt sie frei."
L["unlocked."] = "entsperrt." 
L["locked."] = "gesperrt."
L["Show only in combat"] = "Nur im Kampf anzeigen"
L["Show only if in combat?"] = "Nur anzeigen, wenn im Kampf?"
L["always visible."] = "wird immer angezeigt."
L["only visible in combat."] = "wird nur im Kampf angezeigt."
L["Full bar = rage kept when switching the stance or 100 rage?"] = "Volle Leiste = Wut, die man beim Haltungswechsel beh\195\164lt oder 100 Wut?"
L["Full bar "] = "Volle Leiste"
L["Bar width"] = "Leistenbreite"
L["Changes bar width."] = "Ver\195\164ndert die Breite der Leiste."
L["Bar height"] = "Leistenh\195\182he"
L["Changes bar height."] = "Ver\195\164ndert die H\195\182he der Leiste."
L["Font size"] = "Schriftgr\195\182\195\159e"
L["Changes the font size."] = "Ver\195\164ndert die Schriftgr\195\182\195\159e."
L["Background colour"] = "Hintergrundfarbe"
L["Changes background colour and opacity."] = "Ver\195\164ndert die Hintergrundfarbe und die Transparenz des Hintergrunds."
L["Resets all preferences."] = "Setzt alle Einstellungen auf ihre Standartwerte."
L["Font"] = "Schriftart"
L["Changes the font used."] = "Ver\195\164ndert die verwendete Schriftart."
L["Bar texture"] = "Leistentextur"
L["Changes the bar texture used."] = "Ver\195\164ndert die verwendete Leistentextur."
L[" rage"] = " Wut"
L["Rage kept"] = "behaltene Wut"
L["Maximum bar value"] = "Maximaler Leistenwert"
L["Vertical bar"] = "Vertikalleiste"
L["Displays vertical bar"] = "Leiste vertikalweise anschlagen"
L["vertical"] = "vertikal"
L["horizontal"] = "waag recht"
L["Preferences reset."] = "Alle Einstellungen zur\195\188ckgesetzt."
L["Show if you have rage"] = "Anzeigen falls es Wut gibt"
L["Show RageBar as long as you have rage after combat"] = "Anzeigt RageBar so lang Sie Wut haben nach dem Kampf"
L["only visible in combat and as long as you have rage."] = "wird nur im Kampf und so lang Sie Wut haben angezeigt"
L["Common"] = "Gemeinsam"
L["\n\nRageBar v1.02 by Navy EU Dalaran.\nAn additional rage bar, which shows how much rage would be lost by switching the stance.\n\nThe first time you load RageBar, you must reload UI to save Tactycal mastery rank\n\n"] = "\n\nRagebar v1.02 von Navy EU Dalaran.\nEine zusätzliche Wutleiste, die anzeigt, wie viel Wut man durch einen Haltungswechsel verlieren würde.\n\nDen ersten Mal RageBar wird geladet, Sie mussen UI wiederladen um Taktiker Rang abzuspeichern\n\n"
L["Bar options"] = "Leistenoptionen"
L["Configure bar options"] = "Leistenoptionen gestalten"
L["Font options"] = "Schriftart Optionen"
L["Configure font options"] = "Schriftart Optionen gestalten"
L["Reload UI"] = "UI wiederladen"
L["Save all preferences and reload user interface"] = "Alle Einstellungen abschpeichern und UI widerladen"
L["Disable health bar"] = "Lebensleist unsch\195\188ren"
L["Hide the health bar"] = "Lebensleist verdecken"
L["health bar enabled."] = "Lebensleist sch\195\188ren."
L["health bar disabled."] = "Lebensleist ungesch\195\188rt."

--[[
   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
   ã : \195\163    ë : \195\171    ï : \195\175    õ : \195\181    ü : \195\188
   ä : \195\164                    ñ : \195\177    ö : \195\182
   æ : \195\166                                    ø : \195\184
   ç : \195\167                                    œ : \197\147
   
   Ä : \195\132
   Ö : \195\150
   Ü : \195\156
   ß : \195\159
]]--