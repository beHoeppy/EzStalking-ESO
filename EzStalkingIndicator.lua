if EzStalking == nil then EzStalking = { } end
local EzStalking = _G['EzStalking']
local L = EzStalking:GetLocale()

EzStalking.UI = { }

local function set_position()
    local x, y = EzStalking.settings.indicator.position.x, EzStalking.settings.indicator.position.y
    EzStalking.UI.indicator:ClearAnchors()
    EzStalking.UI.indicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
end

local function save_position()
    EzStalking.settings.indicator.position.x = EzStalking.UI.indicator:GetLeft()
    EzStalking.settings.indicator.position.y = EzStalking.UI.indicator:GetTop()
end

function EzStalking.UI.lock(value)
    EzStalking.settings.indicator.locked = value
    EzStalking.UI.update_color()
    EzStalking.UI.toggle_fg_color()
    EzStalking.UI.indicator:SetMouseEnabled(not value)
    EzStalking.UI.indicator:SetMovable(not value)
end

function EzStalking.UI.update_color()
    local r, g, b = unpack(EzStalking.settings.indicator.color)
    EzStalking.UI.indicator_fg:SetCenterColor(r, g, b, 0.7)
    EzStalking.UI.indicator_fg:SetEdgeColor(r, g, b, 0.37)
end

function EzStalking.UI.enable_indicator(value)
    EzStalking.UI.hide_indicator(not value)
    EzStalking.UI.toggle_fg_color()
    if value then
        SCENE_MANAGER:GetScene("hud"):AddFragment(EzStalking.UI.indicator_fragment)
        SCENE_MANAGER:GetScene("hudui"):AddFragment(EzStalking.UI.indicator_fragment)
    else
        SCENE_MANAGER:GetScene("hud"):RemoveFragment(EzStalking.UI.indicator_fragment)
        SCENE_MANAGER:GetScene("hudui"):RemoveFragment(EzStalking.UI.indicator_fragment)
    end
end

function EzStalking.UI.hide_indicator(value)
    EzStalking.UI.indicator_bg:SetHidden(value)
    EzStalking.UI.indicator_fg:SetHidden(value)
    EzStalking.UI.indicator:SetHidden(value)
end

function EzStalking.UI.toggle_fg_color()
    if (not EzStalking.settings.indicator.locked or IsEncounterLogEnabled()) then
        local color = EzStalking.settings.indicator.locked and EzStalking.settings.indicator.color or EzStalking.settings.indicator.unlocked_color
        EzStalking.UI.indicator_fg:SetCenterColor(unpack(color))
    else
        EzStalking.UI.indicator_fg:SetCenterColor(0, 0, 0, 0)
    end
end

function EzStalking.UI:initialize()
    local dimensions = 17

    local _indicator = WINDOW_MANAGER:CreateTopLevelWindow("EZS_indicator")
    _indicator:SetClampedToScreen(true)
    _indicator:SetDimensions(dimensions, dimensions)
    _indicator:ClearAnchors()
    _indicator:SetMouseEnabled(false)
    _indicator:SetMovable(false)
    --_indicator:SetHidden(false)
    _indicator:SetDimensionConstraints(dimensions, dimensions, dimensions, dimensions)
    _indicator:SetHandler("OnMoveStop", function(...) save_position() end)

    local _indicator_bg = WINDOW_MANAGER:CreateControl("EZS_backdrop", _indicator, CT_BACKDROP)
    _indicator_bg:SetAnchorFill()
    _indicator_bg:SetCenterColor(0, 0, 0, 0.25)
    _indicator_bg:SetEdgeColor(0, 0, 0, 0.25)
    _indicator_bg:SetEdgeTexture(nil, 1, 1, 0, 0)
    --_indicator_bg:SetHidden(false)

    local _indicator_fg = WINDOW_MANAGER:CreateControl("EZS_foreground", _indicator, CT_BACKDROP)
    _indicator_fg:SetAnchor(CENTER, _indicator, CENTER, 0, 0)
    _indicator_fg:SetDimensions(dimensions, dimensions)
    _indicator_fg:SetCenterColor(1, 0, 0, 0.7)
    _indicator_fg:SetEdgeColor(1, 0, 0, 0.3)
    _indicator_fg:SetEdgeTexture(nil, 1, 1, 0, 0)
    --_indicator_fg:SetHidden(false)

    EzStalking.UI.indicator = _indicator
    EzStalking.UI.indicator_bg = _indicator_bg
    EzStalking.UI.indicator_fg = _indicator_fg
    EzStalking.UI.indicator_fragment = ZO_HUDFadeSceneFragment:New(_indicator)
    EzStalking.UI.enable_indicator(true)
    set_position()

    EzStalking.UI.enable_indicator(EzStalking.settings.indicator.enabled)
    EzStalking.UI.lock(EzStalking.settings.indicator.locked)
end

    