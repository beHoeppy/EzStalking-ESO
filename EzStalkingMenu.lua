if EzStalking == nil then EzStalking = { } end
local EzStalking = _G['EzStalking']
local L = EzStalking:GetLocale()

EzStalking.Menu = { }

function EzStalking.Menu:initialize()
    local LAM = LibAddonMenu2
    if not LAM then return end

    local panel_data = {
        type = "panel",
        name = EzStalking.title,
        displayName = EzStalking.title,
        author = EzStalking.author,
        version = EzStalking.version,
        registerForDefaults = true,
        registerForRefresh = true,
    }
    LAM:RegisterAddonPanel(EzStalking.name, panel_data)

    local options_table = { }
    options_table[#options_table+1] =
    {
        type = "header",
        name = L.menu.header,
    }
    -- [[
    options_table[#options_table+1] =
    {
        type = "description",
        text = L.menu.description,
    }
    --]]
    options_table[#options_table+1] =
    {
        type = "divider",
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.accountwide,
        tooltip = L.menu.accountwide_tooltip,
        getFunc = function() return EzStalking_SavedVars.Default[GetDisplayName()]['$AccountWide']["account_wide"] end,
        setFunc = function(value) EzStalking_SavedVars.Default[GetDisplayName()]['$AccountWide']["account_wide"] = value end,
        requiresReload = true,
        default = EzStalking.defaults.account_wide,
    }
    options_table[#options_table+1] =
    {
        type = "divider",
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.logging_enabled,
        tooltip = L.menu.logging_enabled_tooltip,
        getFunc = function() return EzStalking.settings.log.enabled end,
        setFunc = function(value)
            EzStalking.enable_automatic_logging(value)
            EzStalking.settings.log.enabled = value
        end,
        requiresReload = false,
        default = EzStalking.defaults.log.enabled,
    }
    --[[
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = GetString(SI_EZS_MENU_LOCATION_VETERAN_ONLY),
        tooltip = GetString(SI_EZS_MENU_LOCATION_VETERAN_ONLY_TOOLTIP),
        getFunc = function() return EzStalking.settings.veteran_only end,
        setFunc = function(value) EzStalking.settings.veteran_only = value end,
        --disabled = function() return not EzStalking.settings.log.enabled end,
        disabled = true,
        requiresReload = false,
        default = addon.defaults.veteran_only,
    }
    --]]
    options_table[#options_table+1] =
    {
        type = "header",
        name = L.menu.location.header,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.location.housing,
        tooltip = L.menu.location.housing_tooltip,
        getFunc = function() return EzStalking.settings.log.housing end,
        setFunc = function(value) EzStalking.settings.log.housing = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.housing,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name =  L.menu.location.arenas,
        tooltip = L.menu.location.arenas_tooltip,
        getFunc = function() return EzStalking.settings.log.arenas end,
        setFunc = function(value) EzStalking.settings.log.arenas = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.arenas,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.location.dungeons,
        tooltip = L.menu.location.dungeons_tooltip,
        getFunc = function() return EzStalking.settings.log.dungeons end,
        setFunc = function(value) EzStalking.settings.log.dungeons = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.dungeons,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.location.trials,
        tooltip = L.menu.location.trials_tooltip,
        getFunc = function() return EzStalking.settings.log.trials end,
        setFunc = function(value) EzStalking.settings.log.trials = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.trials,
    }
    options_table[#options_table+1] =
    {
        type = "header",
        name = L.menu.indicator.header,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.indicator.enabled,
        tooltip = L.menu.indicator.enabled_tooltip,
        getFunc = function() return EzStalking.settings.indicator.enabled end,
        setFunc = function(value)
            EzStalking.settings.indicator.enabled = value
            EzStalking.UI.enable_indicator(value)
        end,
        requiresReload = false,
        default = EzStalking.defaults.indicator.enabled,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        name = L.menu.indicator.locked,
        tooltip = L.menu.indicator.locked_tooltip,
        getFunc = function() return EzStalking.settings.indicator.locked end,
        setFunc = function(value)
            EzStalking.UI.lock(value)
        end,
        disabled = function() return not EzStalking.settings.indicator.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.indicator.locked,
    }
    options_table[#options_table+1] =
    {
        type = "colorpicker",
        name = L.menu.indicator.color,
        tooltip = L.menu.indicator.color_tooltip,
        getFunc = function() return unpack(EzStalking.settings.indicator.color) end,
        setFunc = function(r, g, b) 
            EzStalking.settings.indicator.color = {r, g, b}
            EzStalking.settings.indicator.unlocked_color = {1 - r, 1 - g, 1 - b}
            EzStalking.UI.update_color()
        end,
        disabled = function() return not EzStalking.settings.indicator.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.indicator.color,
    }

    LAM:RegisterOptionControls(EzStalking.name, options_table)
end