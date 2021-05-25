if EzStalking == nil then EzStalking = { } end
local EzStalking = _G['EzStalking']
local L = EzStalking:GetLocale()

EzStalking.name         = 'EzStalking'
EzStalking.title        = 'Easy Stalking'
EzStalking.slash        = '/ezlog'
EzStalking.author       = 'muh'
EzStalking.version      = '1.2.7'
EzStalking.var_version  = 2

EzStalking.defaults = {
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
        unlocked_color = {0, 1, 1, 0.7}
    },
}

--[[
local function on_interface_setting_changed(event, setting_type)
    if setting_type = SETTING_TYPE_COMBAT then
        if EzStalking.settings.indicator.enabled then
            EzStalking.UI.toggle_fg_color()
        end
    end
end
--]]

local function on_player_activated(event)
    local is_instance = GetCurrentZoneDungeonDifficulty()
    local toggle = false

    if is_instance ~= DUNGEON_DIFFICULTY_NONE then
        if IsEncounterLogEnabled() then
            toggle = true
        elseif is_instance == DUNGEON_DIFFICULTY_VETERAN or not EzStalking.settings.log.veteran_only then
            local revive_counter = GetCurrentRaidStartingReviveCounters()
            revive_counter = revive_counter == nil and 0 or revive_counter

            local raid_id = GetCurrentParticipatingRaidId()

            if EzStalking.settings.log.trials and (revive_counter > 24 or raid_id < 4) and raid_id > 0 then
                toggle = true
            elseif EzStalking.settings.log.arenas and revive_counter <= 24 and raid_id >= 4 then
                toggle = true
            elseif EzStalking.settings.log.dungeons and revive_counter == 0 and raid_id == 0 then
                toggle = true
            end
        end
    elseif EzStalking.settings.log.housing and GetCurrentHouseOwner() ~= "" then
        toggle = true
    end

    EzStalking.toggle_logging(toggle)
end

function EzStalking.toggle_logging(value)
    local toggle = (value == nil) and not IsEncounterLogEnabled() or value
    SetEncounterLogEnabled(toggle)

    if EzStalking.settings.indicator.enabled then
        EzStalking.UI.toggle_fg_color()
        if not EzStalking.settings.indicator.locked then
            CHAT_SYSTEM:AddMessage(L.message.indicator.warn_unlocked)
        end
    else
        local message = toggle and L.message.logging.enabled or L.message.logging.disabled
        CHAT_SYSTEM:AddMessage(message)
    end
end
EzStalking_keybind_toggle = EzStalking.toggle_logging

function EzStalking.set_anonymity(value)
    value = value and "1" or "0"
    SetSetting(SETTING_TYPE_COMBAT, COMBAT_SETTING_ENCOUNTER_LOG_APPEAR_ANONYMOUS, value)
end

function EzStalking.slash_command(arg)
    local notify_anonymity = nil
    if (arg == '') then
        EzStalking.toggle_logging()
    elseif (arg == L.slash_command.anonymous --[['anonymous']]) or (arg == zo_strsub(L.slash_command.anonymous, 1, 1) --[['a']]) then
        EzStalking.set_anonymity(true)
        notify_anonymity = L.message.anonymity.anonymous
    elseif (arg == L.slash_command.named --[['named']]) or (arg == zo_strsub(L.slash_command.named, 1, 1) --[['n']]) then
        EzStalking.set_anonymity(false)
        notify_anonymity = L.message.anonymity.named
    elseif (arg == L.slash_command.unlock) and EzStalking.settings.indicator.enabled then
            EzStalking.UI.lock(false)
    elseif (arg == L.slash_command.lock) and EzStalking.settings.indicator.enabled then
            EzStalking.UI.lock(true)
    else
        CHAT_SYSTEM:AddMessage(L.message.slash_command.options)
        CHAT_SYSTEM:AddMessage(L.message.slash_command.toggle)
        if EzStalking.settings.indicator.enabled then
            CHAT_SYSTEM:AddMessage(L.message.slash_command.lock)
            CHAT_SYSTEM:AddMessage(L.message.slash_command.unlock)
        end
        CHAT_SYSTEM:AddMessage(L.message.slash_command.anonymous)
        CHAT_SYSTEM:AddMessage(L.message.slash_command.named)
        CHAT_SYSTEM:AddMessage(L.message.slash_command.note)
    end
    if notify_anonymity ~= nil then
        CHAT_SYSTEM:AddMessage(L.message.anonymity.preamble .. " |cffffff" .. notify_anonymity .. "|r")
    end
end

function EzStalking.enable_automatic_logging(value)
    if value then
        EVENT_MANAGER:RegisterForEvent(EzStalking.name, EVENT_PLAYER_ACTIVATED, on_player_activated)
    else
        EVENT_MANAGER:UnregisterForEvent(EzStalking.name, EVENT_PLAYER_ACTIVATED)
    end
end

function EzStalking:initialize()
    EzStalking.UI:initialize()
    EzStalking.Menu:initialize()

    SLASH_COMMANDS[EzStalking.slash] = EzStalking.slash_command

    --EVENT_MANAGER:RegisterForEvent(EzStalking.name, EVENT_INTERFACE_SETTING_CHANGED, on_interface_setting_changed)

    EzStalking.enable_automatic_logging(EzStalking.settings.log.enabled)
end

local function on_addon_loaded(event, name)
    if name ~= EzStalking.name then return end
    EVENT_MANAGER:UnregisterForEvent(EzStalking.name, EVENT_ADD_ON_LOADED)

    local var_file = "EzStalking_SavedVars"
    EzStalking.settings = ZO_SavedVars:NewAccountWide(var_file, EzStalking.var_version, nil, EzStalking.defaults)
    if not EzStalking.settings.account_wide then EzStalking.settings = ZO_SavedVars:NewCharacterIdSettings(var_file, EzStalking.var_version, nil, EzStalking.defaults) end

    EzStalking:initialize()
end

EVENT_MANAGER:RegisterForEvent(EzStalking.name, EVENT_ADD_ON_LOADED, on_addon_loaded)