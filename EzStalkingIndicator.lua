local EZS = EZS
if EZS == nil then EZS = {} end

--local WM = GetWindowManager()

EZS.UI = { }

local function set_position()
    local x, y = settings.indicator.position.x, settings.indicator.position.y
    EZS.UI.indicator:ClearAnchors()
    EZS.UI.indicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
end

local function save_position()
    settings.indicator.position.x = EZS.UI.indicator:GetLeft()
    settings.indicator.position.y = EZS.UI.indicator:GetTop()
end

function EZS.UI.update_color()
    local r, g, b = unpack(settings.indicator.color)
    EZS.UI.indicator_fg:SetCenterColor(r, g, b, 0.7)
    EZS.UI.indicator_fg:SetEdgeColor(r, g, b, 0.37)
end

function EZS.UI.enable_indicator(value)
    EZS.UI.hide_indicator(not value)
    EZS.UI.toggle_fg_color(value)
    if value then
        SCENE_MANAGER:GetScene("hud"):AddFragment(EZS.UI.indicator_fragment)
        SCENE_MANAGER:GetScene("hudui"):AddFragment(EZS.UI.indicator_fragment)
    else
        SCENE_MANAGER:GetScene("hud"):RemoveFragment(EZS.UI.indicator_fragment)
        SCENE_MANAGER:GetScene("hudui"):RemoveFragment(EZS.UI.indicator_fragment)
    end
end

function EZS.UI.hide_indicator(value)
    EZS.UI.indicator_bg:SetHidden(value)
    EZS.UI.indicator_fg:SetHidden(value)
    EZS.UI.indicator:SetHidden(value)
end

function EZS.UI.toggle_fg_color(value)
    if value then
        EZS.UI.indicator_fg:SetCenterColor(unpack(settings.indicator.color))
    else
        EZS.UI.indicator_fg:SetCenterColor(0, 0, 0, 0)
    end
end

function EZS.UI.create_indicator()
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

    EZS.UI.indicator = _indicator
    EZS.UI.indicator_bg = _indicator_bg
    EZS.UI.indicator_fg = _indicator_fg
    EZS.UI.indicator_fragment = ZO_HUDFadeSceneFragment:New(_indicator)
    EZS.UI.enable_indicator(true)
    set_position()

    EZS.UI.enable_indicator(settings.indicator.enabled)
end

    