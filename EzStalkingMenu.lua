if EzStalking == nil then EzStalking = { } end
local EzStalking = _G['EzStalking']
local L = EzStalking:GetLocale()

EzStalking.Menu = { }

function EzStalking.Menu:initialize()
    local LAM = LibAddonMenu2
    if not LAM then return end

    local libDialog = LibDialog

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
        width = "half",
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
    if libDialog then
        options_table[#options_table+1] =
        {
            type = "checkbox",
            width = "half",
            name = L.menu.veteran_only,
            tooltip = L.menu.veteran_only_tooltip,
            getFunc = function() return (not EzStalking.settings.log.veteran_only) end,
            setFunc = function(value) EzStalking.settings.log.veteran_only = not value end,
            disabled = function() return not EzStalking.settings.log.enabled end,
            requiresReload = false,
            default = not EzStalking.defaults.log.veteran_only,
        }
    end
    if libDialog then
        options_table[#options_table+1] =
        {
            type = "checkbox",
            width = "half",
            name = L.menu.use_dialog,
            tooltip = L.menu.use_dialog_tooltip,
            getFunc = function() return EzStalking.settings.log.use_dialog end,
            setFunc = function(value) EzStalking.settings.log.use_dialog = value end,
            disabled = function() return not EzStalking.settings.log.enabled end,
            requiresReload = false,
            default = EzStalking.defaults.log.use_dialog,
        }
    end
    if libDialog then
        options_table[#options_table+1] =
        {
            type = "checkbox",
            width = "half",
            name = L.menu.remember_zone,
            tooltip = L.menu.remember_zone_tooltip,
            getFunc = function() return EzStalking.settings.log.remember_zone end,
            setFunc = function(value) EzStalking.settings.log.remember_zone = value end,
            disabled = function()
                return not EzStalking.settings.log.use_dialog or not EzStalking.settings.log.enabled
            end,
            requiresReload = false,
            default = EzStalking.defaults.log.remember_zone,
        }
    end
    --[[
    if libDialog then
        options_table[#options_table+1] =
        {
            type = "checkbox",
            name = L.menu.upload_reminder,
            tooltip = L.menu.upload_reminder_tooltip,
            getFunc = function() return EzStalking.settings.upload_reminder end,
            setFunc = function(value)
                EzStalking.show_upload_reminder_dialog(value)
                EzStalking.settings.upload_reminder = value
            end,
            requiresReload = false,
            default = EzStalking.defaults.upload_reminder,
        }
    end
    --]]
    options_table[#options_table+1] =
    {
        type = "header",
        name = L.menu.location.header,
    }
    options_table[#options_table+1] =
    {
        type  = "header",
        width = "half",
        name  = "PvE", 
    }
    options_table[#options_table+1] =
    {
        type  = "header",
        width = "half",
        name  = "PvP",

    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        width = "half",
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
        width = "half",
        name = L.menu.location.battlegrounds,
        tooltip = L.menu.location.battlegrounds_tooltip,
        getFunc = function() return EzStalking.settings.log.battlegrounds end,
        setFunc = function(value) EzStalking.settings.log.battlegrounds = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.battlegrounds,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        width = "half",
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
        width = "half",
        name = L.menu.location.imperial_city,
        tooltip = L.menu.location.imperial_city_tooltip,
        getFunc = function() return EzStalking.settings.log.imperial_city end,
        setFunc = function(value) EzStalking.settings.log.imperial_city = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.imperial_city,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        width = "half",
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
        type = "checkbox",
        width = "half",
        name = L.menu.location.cyrodiil,
        tooltip = L.menu.location.cyrodiil_tooltip,
        getFunc = function() return EzStalking.settings.log.cyrodiil end,
        setFunc = function(value) EzStalking.settings.log.cyrodiil = value end,
        disabled = function() return not EzStalking.settings.log.enabled end,
        requiresReload = false,
        default = EzStalking.defaults.log.cyrodiil,
    }
    options_table[#options_table+1] =
    {
        type = "checkbox",
        width = "half",
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
        type = "divider",
        width = "half",
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