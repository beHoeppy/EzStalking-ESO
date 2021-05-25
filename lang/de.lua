local strings = {
    
SI_EZS_PRE_ELSWEYR = "Die Funktion die dieses AddOn nutzt wird erst mit der Elsweyr Erweiterung implementiert. \n\nDiese Version is zur Zeit für den PTS vorgesehen.\nFalls du dieses Addon für den PTS installieren wolltest, kopiere den EzStalking Ordner nach C:\\Benutzer\\Benuztername\\Meine Dokumente\\Elder Scrolls Online\\pts\\AddOns.",

-- [[ Menu ]]
SI_EZS_MENU_HEADER = "Einstellungen",
SI_EZS_MENU_DESCRIPTION = "Wähle aus ob und wo automatisch Encounter Logging aktiviert werden soll.\n Achtung: Wenn aktiviert, deaktiviert dieses Addon Encounter Logging wenn außerhalb der ausgewählten Orte.",

SI_EZS_MENU_ACCOUNTWIDE = "Charakterübergreifende Einstellungen",
SI_EZS_MENU_ACCOUNTWIDE_TOOLTIP = "Nutzt die gleichen Einstellungen für alle Charaktere.",

SI_EZS_MENU_LOGGING_ENABLED = "Automatisches Logging",
SI_EZS_MENU_LOGGING_ENABLED_TOOLTIP = "Aktiviere automatisches Logging.",

SI_EZS_MENU_LOCATION_SUBHEADER = "",
SI_EZS_MENU_LOCATION_HOUSING = "\t\t\t\t\t Spielerhäuser",
SI_EZS_MENU_LOCATION_HOUSING_TOOLTIP = "Aktiviere automatisches Logging in Spielerhäusern.",
SI_EZS_MENU_LOCATION_ARENAS = "\t\t\t\t\t Arenen",
SI_EZS_MENU_LOCATION_ARENAS_TOOLTIP = "Aktiviere automatisches Logging in Solo Arenen.",
SI_EZS_MENU_LOCATION_DUNGEONS = "\t\t\t\t\t Verliese",
SI_EZS_MENU_LOCATION_DUNGEONS_TOOLTIP = "Aktiviere automatisches Logging in Verliesen.",
SI_EZS_MENU_LOCATION_TRIALS = "\t\t\t\t\t Prüfungen",
SI_EZS_MENU_LOCATION_TRIALS_TOOLTIP = "Aktiviere automatisches Logging in Prüfungen.",

-- [[ Indicator ]]
SI_EZS_MENU_INDICATOR_SUBHEADING = "Indikator",
SI_EZS_MENU_INDICATOR_ENABLED = "\t\t\t\t\t Sichtbar",
SI_EZS_MENU_INDICATOR_ENABLED_TOOLTIP = "Zeigt einen kleinen Indikator an wenn logging aktiviert ist.",
SI_EZS_MENU_INDICATOR_LOCKED = "\t\t\t\t\t Position sperren",
SI_EZS_MENU_INDICATOR_LOCKED_TOOLTIP = "Sperrt die Position des Indikators.",
SI_EZS_MENU_INDICATOR_COLOR = "\t\t\t\t\t Farbe",
SI_EZS_MENU_INDICATOR_COLOR_TOOLTIP = "Die Anzeigefarbe des Indikators.",

-- [[ Messages ]]
SI_EZS_MSG_LOGGING_ENABLED = "Encounter log aktiviert.",
SI_EZS_MSG_LOGGING_DISABLED = "Encounter log deaktiviert.",

--[[
SI_EZS_MSG_ACTIVATE_HOUSING = "(Spielerhäuser)",
SI_EZS_MSG_ACTIVATE_ARENAS = "(Solo Arena)",
SI_EZS_MSG_ACTIVATE_DUNGEONS = "(Verliese)",
SI_EZS_MSG_ACTIVATE_TRIALS = "(Prüfungen)",
--]]

-- [[ Keybindings ]]
SI_BINDING_NAME_EZS_TOGGLE_LOGGING = "De-/Aktiviere Encounterlog",
}

for i, v in pairs(strings) do
    ZO_CreateStringId(i, v)
end



--[[
SI_EZS_MENU_VETERAN_ONLY = "Nur Veteranen-Modus",
SI_EZS_MENU_VETERAN_ONLY_TOOLTIP = "Check if you only want to log veteran difficulty in arenas, dungeons and trials.",
--]]
--SI_EZS_MENU_VETERAN_ONLY_TOOLTIP = "Zur Zeit wird automatisches Logging nur im Veteranen-Modus unterstützt.",