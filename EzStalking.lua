if EZS == nil then EZS = {} end
local EZS = EZS

addon = {
    name = "EzStalking",
    title = "Easy Stalking",
    author = "muh",
    version = "0.3",
    var_version = 2,

    defaults =
    {
        account_wide = false,
        
        log = {
            enabled = false,
            housing = false,
            arenas = false,
            dungeons = false,
            trials = false,
            veteran_only = true,
        },

        indicator = {
            enabled = false,
            locked = true,

            position = {
                x = 500,
                y = 500,
            },
            color = {1, 0, 0, 0.7},
        },
    },
}

local api_version = GetAPIVersion()

local function on_player_activated(event) 
    local is_instance = GetCurrentZoneDungeonDifficulty()
    local toggle = false
    local trigger = ""

    if is_instance ~= DUNGEON_DIFFICULTY_NONE then
        local revive_counter = GetCurrentRaidStartingReviveCounters()
        revive_counter = revive_counter == nil and 0 or revive_counter

        local raid_id = GetCurrentParticipatingRaidId()
        
        if settings.log.veteran_only and is_instance ~= DUNGEON_DIFFICULTY_VETERAN then
            toggle = false
        else  
            if settings.log.trials and (revive_counter > 24 or raid_id < 4) and raid_id > 0 then
                toggle = true 
                trigger = GetString(EZS_MSG_ACTIVATE_TRIALS)
            elseif settings.log.arenas and revive_counter <= 24 and (raid_id >= 4 and raid_id > 0) then
                toggle = true
                trigger = GetString(EZS_MSG_ACTIVATE_ARENAS)
            elseif settings.log.dungeons and revive_counter == 0 and raid_id == 0 then
                toggle = true
                trigger = GetString(EZS_MSG_ACTIVATE_DUNGEONS)
            else
                toggle = false
            end
        end
    elseif settings.log.housing and GetCurrentHouseOwner() ~= "" then toggle = true
        trigger = GetString(EZS_MSG_ACTIVATE_HOUSING)
    else
        toggle = false
    end

    EZS.toggle_logging(toggle)
end

function EZS.toggle_logging(value)
    if api_version < 100027 then return end

    local toggle = (value == nil) and not IsEncounterLogEnabled() or value

    if settings.indicator.enabled then
        EZS.UI.toggle_fg_color(toggle)
    else
        local message = toggle and GetString(SI_EZS_MSG_LOGGING_ENABLED) or GetString(SI_EZS_MSG_LOGGING_DISABLED)
        CHAT_SYSTEM:AddMessage(message)
    end

    SetEncounterLogEnabled(toggle)
end

function EZS.register_player_activated(value)
    if value then
        EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_PLAYER_ACTIVATED, on_player_activated)
    else
        EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_PLAYER_ACTIVATED)
    end
end

function EZS:initialize()
    EZS.UI.create_indicator()
    EZS.build_menu()

    if api_version < 100027 then return end
    EZS.register_player_activated(settings.log.enabled)
end

local function on_addon_loaded(event, name)
    if name ~= addon.name then return end
    EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADDON_LOADED)

    settings = ZO_SavedVars:NewAccountWide("EzStalking_SavedVars", addon.var_version, nil, addon.defaults)
    if not settings.account_wide then settings = ZO_SavedVars:NewCharacterIdSettings("EzStalking_SavedVars", addon.var_version, nil, addon.defaults) end

    EZS:initialize()
end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, on_addon_loaded)
