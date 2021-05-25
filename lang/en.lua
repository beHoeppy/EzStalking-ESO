local strings = {

SI_EZS_PRE_ELSWEYR = "The feature this addon is using will only be implemented with the Elsweyr update.\n\nThis release is intended for use on the PTS.\nIf you meant to install it for PTS, you have to copy the EzStalking folder into your C:\\Users\\username\\Documents\\Elder Scrolls Online\\pts\\AddOns Folder.",
    
-- [[ Menu ]]
SI_EZS_MENU_HEADER = "Settings",
SI_EZS_MENU_DESCRIPTION = "Select if and where you want Encounter Logging to automatically start.\nPlease note: If enabled, it automatically disables logging outside of specified places.",

SI_EZS_MENU_ACCOUNTWIDE = "Accountwide settings",
SI_EZS_MENU_ACCOUNTWIDE_TOOLTIP = "Share settings across all characters.",
SI_EZS_MENU_AUTOMATIC_LOGGING = "Automatic logging",
SI_EZS_MENU_AUTOMATIC_LOGGING_TOOLTIP = "Enable automatic encounter logging",
--[[
SI_EZS_MENU_VETERAN_ONLY = "Veteran difficulty only",
SI_EZS_MENU_VETERAN_ONLY_TOOLTIP = "Check if you only want to log veteran difficulty in arenas, dungeons and trials.",
--]]
--SI_EZS_MENU_VETERAN_ONLY_TOOLTIP = "Addon currently supports automatic logging for veteran content only.",
SI_EZS_MENU_HOUSING = "Player Housing",
SI_EZS_MENU_HOUSING_TOOLTIP = "Enable automatic logging in player houses.",
SI_EZS_MENU_ARENAS = "Arenas",
SI_EZS_MENU_ARENAS_TOOLTIP = "Enable automatic logging in solo and group arenas.",
SI_EZS_MENU_DUNGEONS = "Dungeons",
SI_EZS_MENU_DUNGEONS_TOOLTIP = "Enable automatic logging in dungeons.",
SI_EZS_MENU_TRIALS = "Trials",
SI_EZS_MENU_TRIALS_TOOLTIP = "Enable automatic logging in trials.",

-- [[ Messages ]]
SI_EZS_MSG_LOGGING_ENABLED = "Encounter log enabled.",
SI_EZS_MSG_LOGGING_DISABLED = "Encounter log disabled.",

--[[
SI_EZS_MSG_ACTIVATE_HOUSING = "(Housing)",
SI_EZS_MSG_ACTIVATE_ARENAS = "(Solo Arena)",
SI_EZS_MSG_ACTIVATE_DUNGEONS = "(Dungeon)",
SI_EZS_MSG_ACTIVATE_TRIALS = "(Trial)",
--]]

-- [[ Keybindings ]]
SI_BINDING_NAME_EZS_TOGGLE_LOGGING = "Toggle Encounterlog",
}

for i, v in pairs(strings) do
    ZO_CreateStringId(i, v)
end