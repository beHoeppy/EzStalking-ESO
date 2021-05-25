local EZS = EZS
if EZS == nil then EZS = {} end

function EZS.build_menu()
    local LAM = LibStub("LibAddonMenu-2.0")
    if not LAM then return end

    local panel_data = {
        type = "panel",
        name = addon.title,
        displayName = addon.title,
        author = addon.author,
        version = addon.version,
        registerForDefaults = true,
        registerForRefresh = true,
    }
    LAM:RegisterAddonPanel(addon.name, panel_data)

    local options_table = { }
    if GetAPIVersion() < 100027 then
        options_table[#options_table+1] =
        {
            type = "description",
            text = GetString(SI_EZS_PRE_ELSWEYR),
        }
    else
        options_table[#options_table+1] =
        {
            type = "header",
            name = GetString(SI_EZS_MENU_HEADER),
        }
        -- [[
        options_table[#options_table+1] =
        {
            type = "description",
            text = GetString(SI_EZS_MENU_DESCRIPTION),
        }
        --]]
        options_table[#options_table+1] =
        {
            type = "divider",
        }
        options_table[#options_table+1] =
        {
            type = "checkbox",
            name = GetString(SI_EZS_MENU_ACCOUNTWIDE),
            tooltip = GetString(SI_EZS_MENU_ACCOUNTWIDE_TOOLTIP),
            getFunc = function() return EzStalking_SavedVars.Default[GetDisplayName()]['$AccountWide']["account_wide"] end,
            setFunc = function(value) EzStalking_SavedVars.Default[GetDisplayName()]['$AccountWide']["account_wide"] = value end,
            requiresReload = true,
            default = addon.defaults.account_wide,
        }
        options_table[#options_table+1] =
        {
            type = "divider",
        }
        options_table[#options_table+1] =
        {
            type = "checkbox",
            name = GetString(SI_EZS_MENU_AUTOMATIC_LOGGING),
            tooltip = GetString(SI_EZS_MENU_AUTOMATIC_LOGGING_TOOLTIP),
            getFunc = function() return settings.automatic_logging end,
            setFunc = function(value) settings.automatic_logging = value end,
            requiresReload = false,
            default = addon.defaults.automatic_logging,
        }
        --[[
        options_table[#options_table+1] =
        {
            type = "checkbox",
            reference = "EZS_LAM_VETERAN_ONLY",
            name = GetString(SI_EZS_MENU_VETERAN_ONLY),
            tooltip = GetString(SI_EZS_MENU_VETERAN_ONLY_TOOLTIP),
            getFunc = function() return settings.veteran_only end,
            setFunc = function(value) settings.veteran_only = value end,
            --disabled = function() return not settings.automatic_logging end,
            disabled = true,
            requiresReload = false,
            default = addon.defaults.veteran_only,
        }
        --]]
        options_table[#options_table+1] =
        {
            type = "divider",
        }
        options_table[#options_table+1] =
        {
            type = "checkbox",
            reference = "EZS_LAM_HOUSING",
            name = GetString(SI_EZS_MENU_HOUSING),
            tooltip = GetString(SI_EZS_MENU_HOUSING_TOOLTIP),
            getFunc = function() return settings.log_housing end,
            setFunc = function(value) settings.log_housing = value end,
            disabled = function() return not settings.automatic_logging end,
            requiresReload = false,
            default = addon.defaults.log_housing,
        }
        options_table[#options_table+1] =
        {
            type = "checkbox",
            reference = "EZS_LAM_ARENAS",
            name = GetString(SI_EZS_MENU_ARENAS),
            tooltip = GetString(SI_EZS_MENU_ARENAS_TOOLTIP),
            getFunc = function() return settings.log_arenas end,
            setFunc = function(value) settings.log_arenas = value end,
            disabled = function() return not settings.automatic_logging end,
            requiresReload = false,
            default = addon.defaults.log_arenas,
        }
        options_table[#options_table+1] =
        {
            type = "checkbox",
            reference = "EZS_LAM_DUNGEONS",
            name = GetString(SI_EZS_MENU_DUNGEONS),
            tooltip = GetString(SI_EZS_MENU_DUNGEONS_TOOLTIP),
            getFunc = function() return settings.log_dungeons end,
            setFunc = function(value) settings.log_dungeons = value end,
            disabled = function() return not settings.automatic_logging end,
            requiresReload = false,
            default = addon.defaults.log_dungeons,
        }
        options_table[#options_table+1] =
        {
            type = "checkbox",
            reference = "EZS_LAM_TRIALS",
            name = GetString(SI_EZS_MENU_TRIALS),
            tooltip = GetString(SI_EZS_MENU_TRIALS_TOOLTIP),
            getFunc = function() return settings.log_trials end,
            setFunc = function(value) settings.log_trials = value end,
            disabled = function() return not settings.automatic_logging end,
            requiresReload = false,
            default = addon.defaults.log_trials,
        }
        options_table[#options_table+1] =
        {
            type = "divider",
        }
    end
    LAM:RegisterOptionControls(addon.name, options_table)
end