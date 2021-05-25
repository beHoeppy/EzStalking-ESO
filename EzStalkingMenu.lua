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
        name = GetString(SI_EZS_MENU_LOGGING_ENABLED),
        tooltip = GetString(SI_EZS_MENU_LOGGING_ENABLED_TOOLTIP),
        getFunc = function() return settings.log.enabled end,
        setFunc = function(value)
            EZS.register_player_activated(value)
            settings.log.enabled = value
        end,
        requiresReload = false,
        default = addon.defaults.log.enabled,
    }
    --[[
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_LOCATION_VETERAN_ONLY),
        tooltip = GetString(SI_EZS_MENU_LOCATION_VETERAN_ONLY_TOOLTIP),
        getFunc = function() return settings.veteran_only end,
        setFunc = function(value) settings.veteran_only = value end,
        --disabled = function() return not settings.log.enabled end,
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
        type = "description",
        title = GetString(SI_EZS_MENU_LOCATION_SUBHEADER),
        width = "half",
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_LOCATION_HOUSING),
        tooltip = GetString(SI_EZS_MENU_LOCATION_HOUSING_TOOLTIP),
        getFunc = function() return settings.log.housing end,
        setFunc = function(value) settings.log.housing = value end,
        disabled = function() return not settings.log.enabled end,
        requiresReload = false,
        default = addon.defaults.log.housing,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_LOCATION_ARENAS),
        tooltip = GetString(SI_EZS_MENU_LOCATION_ARENAS_TOOLTIP),
        getFunc = function() return settings.log.arenas end,
        setFunc = function(value) settings.log.arenas = value end,
        disabled = function() return not settings.log.enabled end,
        requiresReload = false,
        default = addon.defaults.log.arenas,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_LOCATION_DUNGEONS),
        tooltip = GetString(SI_EZS_MENU_LOCATION_DUNGEONS_TOOLTIP),
        getFunc = function() return settings.log.dungeons end,
        setFunc = function(value) settings.log.dungeons = value end,
        disabled = function() return not settings.log.enabled end,
        requiresReload = false,
        default = addon.defaults.log.dungeons,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_LOCATION_TRIALS),
        tooltip = GetString(SI_EZS_MENU_LOCATION_TRIALS_TOOLTIP),
        getFunc = function() return settings.log.trials end,
        setFunc = function(value) settings.log.trials = value end,
        disabled = function() return not settings.log.enabled end,
        requiresReload = false,
        default = addon.defaults.log.trials,
    }
    options_table[#options_table+1] =
    {
        type = "divider",
    }
    options_table[#options_table+1] =
    {
        type = "description",
        title = GetString(SI_EZS_MENU_INDICATOR_SUBHEADING),
        width = "half",
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_INDICATOR_ENABLED),
        tooltip = GetString(SI_EZS_MENU_INDICATOR_ENABLED_TOOLTIP),
        getFunc = function() return settings.indicator.enabled end,
        setFunc = function(value)
            settings.indicator.enabled = value
            EZS.UI.enable_indicator(value)
        end,
        requiresReload = false,
        default = addon.defaults.indicator.enabled,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_INDICATOR_LOCKED),
        tooltip = GetString(SI_EZS_MENU_INDICATOR_LOCKED_TOOLTIP),
        getFunc = function() return settings.indicator.locked end,
        setFunc = function(value)
            settings.indicator.locked = value
            EZS.UI.toggle_fg_color(not value)
            EZS.UI.indicator:SetMouseEnabled(not value)
            EZS.UI.indicator:SetMovable(not value)
        end,
        disabled = function() return not settings.indicator.enabled end,
        requiresReload = false,
        default = addon.defaults.indicator.locked,
    }
    options_table[#options_table+1] =
    {
        type = "colorpicker",
        name = GetString(SI_EZS_MENU_INDICATOR_COLOR),
        tooltip = GetString(SI_EZS_MENU_INDICATOR_COLOR_TOOLTIP),
        getFunc = function() return unpack(settings.indicator.color) end,
        setFunc = function(r, g, b) 
            settings.indicator.color = {r, g, b}
            EZS.UI.update_color()
        end,
        disabled = function() return not settings.indicator.enabled end,
        requiresReload = false,
        default = addon.defaults.indicator.color,
    }

    LAM:RegisterOptionControls(addon.name, options_table)
end