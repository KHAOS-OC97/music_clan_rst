--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    FEATURES/TELEPORT.LUA - Sistema de Teleporte              ║
    ║           Teleporta para jogadores aliados                    ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent.Parent:WaitForChild("config"))
local Services = require(script.Parent.Parent:WaitForChild("services"))
local Notification = require(script.Parent.Parent.ui:WaitForChild("notification"))

local Teleport = {}

-- ==================== TELEPORTAR PARA ALIADO ====================
function Teleport:ToAlly()
    local alliedPlayers = Config.Teleport.AlliedPlayers
    local offset = Config.Teleport.Offset
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        -- Verifica se é aliado
        if table.find(alliedPlayers, player.Name) and player ~= Services.LocalPlayer then
            local character = Services:GetCharacterByPlayer(player)
            if character and character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local targetPos = character:FindFirstChild("HumanoidRootPart").CFrame
                    Services.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(offset)
                    Notification:Show("LINK ESTABELECIDO: " .. player.Name, true)
                end)
                return true
            end
        end
    end
    
    Notification:Show("ALIADO NÃO ENCONTRADO", false)
    return false
end

return Teleport
