if EZS == nil then EZS = {} end
local EZS = EZS

addon = {
    name = "EzStalking",
    title = "Easy Stalking",
    author = "muh",
    version = "0.1",
    var_version = 1,

    defaults =
    {
        automatic_logging = true,
        account_wide = false,
        log_housing = false,
        log_arenas = false,
        log_dungeons = false,
        log_trials = true,
        veteran_only = true,
    },
}

local api_version = GetAPIVersion()

local is_raid = false
local player_activated_fired = false
local raid_participation_fired = false

local function handle_automatic_activation()
    local is_instance = GetCurrentZoneDungeonDifficulty()
    local current = IsEncounterLogEnabled()
    local toggle = false
    local trigger = ""

    if is_instance ~= DUNGEON_DIFFICULTY_NONE then
        if settings.veteran_only and is_instance ~= DUNGEON_DIFFICULTY_VETERAN then
            toggle = false
        else  
            if settings.log_trials and (is_raid or IsPlayerInRaid()) then
                trigger = GetString(SI_EZS_MSG_ACTIVATE_TRIALS)
                toggle = true
            elseif settings.log_dungeons and not is_raid and IsActiveWorldGroupOwnable() then 
                trigger = GetString(SI_EZS_MSG_ACTIVATE_DUNGEONS)
                toggle = true
            elseif settings.log_arenas and not IsActiveWorldGroupOwnable() then
                trigger = GetString(SI_EZS_MSG_ACTIVATE_ARENAS)
                toggle = true
            end
        end
    elseif settings.log_housing and GetCurrentHouseOwner() ~= "" then
        trigger = GetString(SI_EZS_MSG_ACTIVATE_HOUSING)
        toggle = true
    else
        toggle = false
    end

    --[[
    local toggle_str = toggle and "true" or "false"
    local current_str = current and "true" or "false"
    CHAT_SYSTEM:AddMessage(toggle_str .. " / " .. current_str)
    --]]
    if current ~= toggle then
        if toggle then
            CHAT_SYSTEM:AddMessage(GetString(SI_EZS_MSG_LOGGING_ENABLED) .. " " .. trigger)
        else
            CHAT_SYSTEM:AddMessage(GetString(SI_EZS_MSG_LOGGING_DISABLED))
        end
    end

    SetEncounterLogEnabled(toggle)

    is_raid = false
end

local function safety_net()
    if raid_participation_fired and player_activated_fired and not IsEncounterLogEnabled() then handle_automatic_activation() end
end

local function reset_raid_participation_fired()
    raid_participation_fired = false
end

local function on_raid_participation(event)
    if IsActiveWorldGroupOwnable() then is_raid = true end
    raid_participation_fired = true
    zo_callLater(reset_raid_participation_fired, 7000)
    zo_callLater(safety_net, 3000)
end

local function reset_player_activated_fired()
    player_activated_fired = false
end

local function on_player_activated(event) 
    player_activated_fired = true
    zo_callLater(reset_player_activated_fired, 7000)
    zo_callLater(handle_automatic_activation, 1000)
end

function EZS.toggle_logging()
    if api_version < 100027 then return end

    local toggle = IsEncounterLogEnabled()
    toggle = not toggle

    if toggle then
        CHAT_SYSTEM:AddMessage(GetString(SI_EZS_MSG_LOGGING_ENABLED))
    else
        CHAT_SYSTEM:AddMessage(GetString(SI_EZS_MSG_LOGGING_DISABLED))
    end

    SetEncounterLogEnabled(toggle)
end

function EZS:initialize()
    EZS.build_menu()

    if api_version < 100027 then return end
    if settings.automatic_logging then
        if settings.log_trials then
            EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_RAID_PARTICIPATION_UPDATE, on_raid_participation)
        end
        EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_PLAYER_ACTIVATED, on_player_activated)
    end
end

local function on_addon_loaded(event, name)
    if name ~= addon.name then return end
    EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADDON_LOADED)

    settings = ZO_SavedVars:NewAccountWide("EzStalking_SavedVars", addon.var_version, nil, addon.defaults)
    if not settings.account_wide then settings = ZO_SavedVars:NewCharacterIdSettings("EzStalking_SavedVars", addon.var_version, nil, addon.defaults) end

    EZS:initialize()
end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, on_addon_loaded)
