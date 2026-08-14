--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║          STATE.LUA - Gerenciador de Estado Global             ║
    ║        Centraliza o estado do script de forma segura          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent:WaitForChild("config"))
local State = {}

-- ==================== INICIALIZAÇÃO DO ESTADO ====================
function State:Init()
    -- Garante que getgenv() está inicializado
    if not getgenv().HNkUI then
        getgenv().HNkUI = {}
    end
    
    local state = getgenv().HNkUI
    
    -- Define valores padrão para cada feature
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
    return getgenv().HNkUI[key]
end

function State:GetAll()
    return getgenv().HNkUI
end

-- ==================== SETTERS ====================
function State:Set(key, value)
    getgenv().HNkUI[key] = value
end

function State:Toggle(key)
    local currentValue = getgenv().HNkUI[key]
    getgenv().HNkUI[key] = not currentValue
    return getgenv().HNkUI[key]
end

-- ==================== VALIDAÇÃO ====================
function State:IsValid()
    return getgenv().HNkUI ~= nil
end

return State
