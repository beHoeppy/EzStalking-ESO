if EzStalking == nil then EzStalking = { } end
local EzStalking = _G['EzStalking']
local L = EzStalking:GetLocale()

local libDialog = LibDialog

EzStalking.name         = 'EzStalking'
EzStalking.title        = 'Easy Stalking'
EzStalking.slash        = '/ezlog'
EzStalking.author       = 'muh'
EzStalking.version      = '1.4.5'
EzStalking.var_version  = 2

EzStalking.defaults = {
    account_wide = false,
    upload_reminder = false,

    log = {
        enabled = false,
        housing = false,
        battlegrounds = false,
        imperial_city = false,
        cyrodiil = false,
        arenas = false,
        dungeons = false,
        trials = false,
        normal_difficulty = false,
        use_dialog = false,
        remember_zone = false,
    },

    zone_id = { },

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

local ZoneType = { Overland = 0, Instance = 1, Cyrodiil = 2, ImperialCity = 3, Battleground = 4, House = 5 }
local InstanceType = { Uncategorized = 0, Trial = 1, Arena = 2, Dungeon = 3 }

EzStalking.defaults.zone_id[InstanceType.Trial] = { }
EzStalking.defaults.zone_id[InstanceType.Arena] = { }
EzStalking.defaults.zone_id[InstanceType.Dungeon] = { }

local function current_zone()
    return GetZoneId(GetUnitZoneIndex("player"))
end

local function determine_zone_type()
    local zone_type = ZoneType.Overland

    if GetCurrentZoneDungeonDifficulty() ~= DUNGEON_DIFFICULTY_NONE then
        zone_type = ZoneType.Instance
    elseif GetCurrentHouseOwner() ~= "" then
        zone_type = ZoneType.House
    elseif IsActiveWorldBattleground() then
        zone_type = ZoneType.Battleground
    elseif IsInImperialCity() then
        zone_type = ZoneType.ImperialCity
    elseif IsInCyrodiil() then
        zone_type = ZoneType.Cyrodiil
    end

    return zone_type
end

local function determine_instance_type()
    local instance_type = InstanceType.Uncategorized
    local zone = current_zone()

    if EzStalking.settings.zone_id[InstanceType.Dungeon][zone] then
        instance_type = InstanceType.Dungeon
    elseif EzStalking.settings.zone_id[InstanceType.Arena][zone] then
        instance_type = InstanceType.Arena
    elseif EzStalking.settings.zone_id[InstanceType.Trial][zone] then
        instance_type = InstanceType.Trial
    elseif GetCurrentZoneDungeonDifficulty() == DUNGEON_DIFFICULTY_VETERAN then
        local revive_counter = GetCurrentRaidStartingReviveCounters()
        revive_counter = revive_counter == nil and 0 or revive_counter

        local raid_id = GetCurrentParticipatingRaidId()

        if (revive_counter > 24 or raid_id < 4) and raid_id > 0 then
            instance_type = InstanceType.Trial
        elseif revive_counter <= 24 and raid_id >= 4 then
            instance_type = InstanceType.Arena
        elseif revive_counter == 0 and raid_id == 0 then
            instance_type = InstanceType.Dungeon
        end

        if instance_type ~= InstanceType.Uncategorized then
            EzStalking.settings.zone_id[instance_type][zone] = true
        end
    end

    return instance_type
end

EzStalking.remembered_zone = nil
EzStalking.previous_decision = nil
EzStalking.automatic_toggle = nil
local function on_player_activated()
    EzStalking.automatic_toggle = true
    local toggle = false
    local instance_difficulty = nil

    local zone_type = determine_zone_type()
    if zone_type == ZoneType.Instance then
        local instance_type = determine_instance_type()
        instance_difficulty = GetCurrentZoneDungeonDifficulty()

        if IsEncounterLogEnabled() then
            toggle = true
        elseif instance_difficulty == DUNGEON_DIFFICULTY_NORMAL and EzStalking.settings.log.normal_difficulty then
            toggle = true
            if (instance_type == InstanceType.Dungeon and not EzStalking.settings.log.dungeons)
                or (instance_type == InstanceType.Arena and not EzStalking.settings.log.arenas)
                or (instance_type == InstanceType.Trial and not EzStalking.settings.log.trials)
            then
                toggle = false
            end
        elseif instance_difficulty == DUNGEON_DIFFICULTY_VETERAN
            and ((instance_type == InstanceType.Dungeon and EzStalking.settings.log.dungeons)
                or (instance_type == InstanceType.Arena and EzStalking.settings.log.arenas)
                or (instance_type == InstanceType.Trial and EzStalking.settings.log.trials))
        then
            toggle = true
        end
    elseif (zone_type == ZoneType.Battleground and EzStalking.settings.log.battlegrounds)
        or (zone_type == ZoneType.ImperialCity and EzStalking.settings.log.imperial_city)
        or (zone_type == ZoneType.Cyrodiil and EzStalking.settings.log.cyrodiil)
        or (zone_type == ZoneType.House and EzStalking.settings.log.housing)
    then
        toggle = true
    end

    if libDialog and (EzStalking.settings.log.use_dialog or (EzStalking.settings.log.normal_difficulty and instance_difficulty == DUNGEON_DIFFICULTY_NORMAL)) then
        if toggle then
            if EzStalking.previous_decision == nil or EzStalking.remembered_zone ~= current_zone() then
                EzStalking.toggle_logging(false)
                zo_callLater(function()
                    libDialog:ShowDialog(EzStalking.name, EzStalking.name .. "LoggingConfirmationDialog")
                end, 3000)
            elseif EzStalking.remembered_zone == current_zone() then
                EzStalking.toggle_logging(EzStalking.previous_decision)
            end
        elseif zone_type == ZoneType.Overland and not EzStalking.settings.log.remember_zone then
            EzStalking.toggle_logging(false)
            EzStalking.remembered_zone = nil
            EzStalking.previous_decision = nil
        else
            EzStalking.toggle_logging(false)
        end
    else
        EzStalking.toggle_logging(toggle)
    end
end

EzStalking_print_previous_decision = function()
    d(EzStalking.previous_decision)
end

function EzStalking.toggle_logging(value)
    local toggle = (value == nil) and not IsEncounterLogEnabled() or value
    SetEncounterLogEnabled(toggle)
end
EzStalking_keybind_toggle = EzStalking.toggle_logging

function EzStalking.confirmation_dialog_callback(value)
    EzStalking.previous_decision = value
    EzStalking.remembered_zone = current_zone()
end

local function initialize_confirmation_dialog()
    if libDialog then
        local dialog_name = EzStalking.name .. "LoggingConfirmationDialog"
        libDialog:RegisterDialog(EzStalking.name, dialog_name,
                                 L.dialog.logging.title, L.dialog.logging.text,
                                 function() -- callBackYes
                                    EzStalking.toggle_logging(true)
                                    EzStalking.confirmation_dialog_callback(true)
                                 end,
                                 function() -- callBackNo
                                    EzStalking.confirmation_dialog_callback(false)
                                 end)
    end
end

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

    ZO_PostHook("SetEncounterLogEnabled", function()
            if EzStalking.settings.indicator.enabled then
                EzStalking.UI.toggle_fg_color()
                if not EzStalking.settings.indicator.locked then
                    CHAT_SYSTEM:AddMessage(L.message.indicator.warn_unlocked)
                end
            end

            if EzStalking.remembered_zone == current_zone() and not EzStalking.automatic_toggle and not (EzStalking.previous_decision == nil) then
                EzStalking.previous_decision = not EzStalking.previous_decision
            end

            EzStalking.automatic_toggle = false
            return false
      end)

    initialize_confirmation_dialog()

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