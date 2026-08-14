--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║          STATE.LUA - Gerenciador de Estado Global             ║
    ║        Centraliza o estado do script de forma segura          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent:WaitForChild("config"))
local State = {}

local function EnsureState()
    if type(getgenv) ~= "function" then
        return nil
    end

    if not getgenv().HNkUI then
        getgenv().HNkUI = {}
    end

    return getgenv().HNkUI
end

-- ==================== INICIALIZAÇÃO DO ESTADO ====================
function State:Init()
    local state = EnsureState()
    if not state then
        return nil
    end

    state.AntiAFK = state.AntiAFK or Config.Features.AntiAFK.Enabled
    state.ESP = state.ESP or Config.Features.ESP.Enabled
    state.God = state.God or Config.Features.God.Enabled
    state.Jump = state.Jump or Config.Features.Jump.Enabled
    state.Spam = state.Spam or Config.Features.Spam.Enabled
    state.WalkSpeed = state.WalkSpeed or Config.Movement.DefaultWalkSpeed
    state.FOV = state.FOV or Config.Camera.DefaultFOV
    state.SpamCadencia = state.SpamCadencia or Config.Features.Spam.DefaultCadencia

    return state
end

-- ==================== GETTERS ====================
function State:Get(key)
    local state = EnsureState()
    if not state then
        return nil
    end

    if state[key] == nil then
        if key == "AntiAFK" then return Config.Features.AntiAFK.Enabled end
        if key == "ESP" then return Config.Features.ESP.Enabled end
        if key == "God" then return Config.Features.God.Enabled end
        if key == "Jump" then return Config.Features.Jump.Enabled end
        if key == "Spam" then return Config.Features.Spam.Enabled end
        if key == "WalkSpeed" then return Config.Movement.DefaultWalkSpeed end
        if key == "FOV" then return Config.Camera.DefaultFOV end
        if key == "SpamCadencia" then return Config.Features.Spam.DefaultCadencia end
    end

    return state[key]
end

function State:GetAll()
    return EnsureState()
end

-- ==================== SETTERS ====================
function State:Set(key, value)
    local state = EnsureState()
    if not state then
        return nil
    end

    state[key] = value
    return value
end

function State:Toggle(key)
    local state = EnsureState()
    if not state then
        return false
    end

    local currentValue = state[key]
    local newValue = not currentValue
    state[key] = newValue
    return newValue
end

-- ==================== VALIDAÇÃO ====================
function State:IsValid()
    return EnsureState() ~= nil
end

return State
