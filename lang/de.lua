if EzStalking == nil then EzStalking = { } end
local EzStalking = _G['EzStalking']
local L = { }
local spacing = "\t\t\t\t\t "
spacing = ""

-- [[ Menu ]]
L.menu = { }
L.menu.header                       = "Einstellungen"
local substring_description1        = "Wähle aus ob und wo automatisch Begegnungslogs aktiviert werden soll."
local substring_description2        = "Achtung: Wenn aktiviert, deaktiviert dieses Addon Begegnungslogs wenn außerhalb der ausgewählten Orte."
L.menu.description                  = substring_description1 .. "\n" .. substring_description2 -- do not edit

L.menu.accountwide                  = "Charakterübergreifende Einstellungen"
L.menu.accountwide_tooltip          = "Nutzt die gleichen Einstellungen für alle Charaktere."

L.menu.logging_enabled              = "Automatisches aufzeichnen"
L.menu.logging_enabled_tooltip      = "Aktiviere automatisches aufzeichnen."

L.menu.location = { }               -- [[ Location Menu]]
L.menu.location.header              = "Einsatzorte"
local substring_housing             = "Spielerhäuser"
L.menu.location.housing_tooltip     = "Aktiviere automatisches aufzeichnen in Spielerhäusern."
L.menu.location.housing             = spacing .. substring_housing -- do not edit

local substring_arenas              = "Arenen"
L.menu.location.arenas_tooltip      = "Aktiviere automatisches aufzeichnen in Solo Arenen."
L.menu.location.arenas              = spacing .. substring_arenas -- do not edit

local substring_dungeons            = "Verliese"
L.menu.location.dungeons_tooltip    ="Aktiviere automatisches aufzeichnen in Verliesen."
L.menu.location.dungeons            = spacing .. substring_dungeons -- do not edit

local substring_trials              = "Prüfungen"
L.menu.location.trials_tooltip      = "Aktiviere automatisches aufzeichnen in Prüfungen."
L.menu.location.trials              = spacing .. substring_trials -- do not edit

L.menu.indicator = { }              -- [[ Indicator Menu ]]
L.menu.indicator.header             = "Indikator"
local substring_enabled            = "Aktiviert"
L.menu.indicator.enabled_tooltip    = "Zeigt einen kleinen Indikator an wenn aufzeichnen aktiviert ist."
L.menu.indicator.enabled            = spacing .. substring_enabled -- do not edit

local substring_locked             = "Position sperren"
L.menu.indicator.locked_tooltip     = "Sperrt die Position des Indikators. Solange der Indikator entsperrt ist, ist die Farbe invertiert."
L.menu.indicator.locked             = spacing .. substring_locked -- do not edit

local substring_color              = "Farbe"
L.menu.indicator.color_tooltip      = "Die Anzeigefarbe des Indikators."
L.menu.indicator.color              = spacing .. substring_color -- do not edit

-- [[ Slash Command Arguments]]
L.slash_command = { }               -- [[ Slash Command Arguments]]
L.slash_command.lock                = "sperren"
L.slash_command.unlock              = "entsperren"
L.slash_command.anonymous           = "anonym"
L.slash_command.named               = "namentlich"

-- [[ Messages ]]
L.message = { }
L.message.logging = { }             -- [[ Logging Messages ]]
L.message.logging.enabled           = GetString(SI_ENCOUNTER_LOG_ENABLED_ALERT) -- do not edit
L.message.logging.disabled          = GetString(SI_ENCOUNTER_LOG_DISABLED_ALERT) -- do not edit

L.message.anonymity = { }
L.message.anonymity.preamble        = "Du wirst nun"
L.message.anonymity.anonymous       = "als Anonym aufgezeichnet."
L.message.anonymity.named           = "mit deinem Charaketnamen aufgezeichnet."

L.message.indicator = { }           -- [[ Indicator Messages ]]
local substring_warn_unlocked       = "WARNUNG: Bildschirm-Indikator ist entsperrt!"
L.message.indicator.warn_unlocked   = "|cff0000" .. substring_warn_unlocked .. "|r" -- do not edit

local substring_or                  = "oder"
local substring_lock                = "sperrt den Bildschirm-Indikator"
local substring_unlock              = "entsperrt den Bildschirm-Indikator"
local substring_anonymous           = "du erscheinst als Anonym in Begegnugslogs."
local substring_named               = "du erscheinst mit deinem Charakternamen in Begegnungslogs"
local substring_note                = "ACHTUNG: Bereits laufende Begegnungslogs werden verwenden die Anonymitätseinstellung die beim Start des Logs gewählt war"
local substring_empty               = "nichts"
local substring_toggle              = "de-/aktiviere Begegnungslogs."

L.message.slash_command = { }       -- [[ Slash Command Messages]]
L.message.slash_command.options     = "Optionen sind:"
--[[
        Do not edit the following lines!
        They will be properly translated if you have translated everything above.
--]]
L.message.slash_command.lock        = "|cab7337" .. L.slash_command.lock .. "|r - " .. substring_lock
L.message.slash_command.unlock      = "|cab7337" .. L.slash_command.unlock .. "|r - " .. substring_unlock
L.message.slash_command.anonymous   = "|cab7337" .. L.slash_command.anonymous .. "|r " .. substring_or .. " |cab7337" .. zo_strsub(L.slash_command.anonymous, 1, 1) .. "|r - " .. substring_anonymous
L.message.slash_command.named       = "|cab7337" .. L.slash_command.named .. "|r " .. substring_or .. " |cab7337" .. zo_strsub(L.slash_command.named, 1, 1) .. "|r - " .. substring_named
L.message.slash_command.note        = spacing .. "|cff3737" .. substring_note .. "|r"
L.message.slash_command.toggle      = "|cab7337<" .. substring_empty .. ">|r - " .. substring_toggle
-- [[ continue editing below ]]

-- [[ Keybindings ]]
local kb = { }
kb.SI_BINDING_NAME_EZSTALKING_TOGGLE_LOGGING = "De-/Aktiviere Begegnungslogs"

for i, v in pairs(kb) do
    ZO_CreateStringId(i, v)
end

function EzStalking:GetLocale()
    return L
end