if EZS == nil then EZS = {} end
local EZS = EZS

addon = {
    name = "EzStalking",
    title = "Easy Stalking",
    author = "muh",
    version = "0.2",
    var_version = 2,

    defaults =
    {
        account_wide = false,
        
        log = {
            enabled = true,
            housing = false,
            arenas = false,
            dungeons = false,
            trials = true,
            veteran_only = true,
        },

        indicator = {
            enabled = true,
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
        raid_id = raid_id > 0 and raid_id or 10
        
        if settings.veteran_only and is_instance ~= DUNGEON_DIFFICULTY_VETERAN then
            toggle = false
        else  
            if settings.log.trials and (revive_counter > 24 or raid_id < 4) and raid_id ~= 10 then
                toggle = true 
                trigger = GetString(EZS_MSG_ACTIVATE_TRIALS)
            elseif settings.log.arenas and revive_counter <= 24 and (raid_id >= 4 and raid_id ~= 10) then
                toggle = true
                trigger = GetString(EZS_MSG_ACTIVATE_ARENAS)
            elseif settings.log.dungeons and revive_counter == 0 and raid_id == 10 then
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

    if value == nil then
        toggle = not IsEncounterLogEnabled()
    else
        toggle = value
    end

    if settings.indicator.enabled and toggle then
        EZS.UI.indicator_fg:SetCenterColor(unpack(settings.indicator.color))
    else
        EZS.UI.indicator_fg:SetCenterColor(0, 0, 0, 0)
    end
    if toggle then
        CHAT_SYSTEM:AddMessage(GetString(SI_EZS_MSG_LOGGING_ENABLED))
    else
        CHAT_SYSTEM:AddMessage(GetString(SI_EZS_MSG_LOGGING_DISABLED))
    end

    SetEncounterLogEnabled(toggle)
end

function EZS:initialize()
    EZS.UI.create_indicator()
    EZS.build_menu()

    if api_version < 100027 then return end
    if settings.log.enabled then
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
