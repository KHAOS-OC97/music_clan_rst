--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    FEATURES/MOVEMENT.LUA - Movimento do Jogador              ║
    ║          WalkSpeed e God Mode sincronizados                  ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent.Parent:WaitForChild("config"))
local Services = require(script.Parent.Parent:WaitForChild("services"))
local State = require(script.Parent.Parent:WaitForChild("state"))

local Movement = {}

function Movement:Init()
    Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            if Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = Services.LocalPlayer.Character:FindFirstChild("Humanoid")
                
                -- Aplicar WalkSpeed
                humanoid.WalkSpeed = State:Get("WalkSpeed") or Config.Movement.DefaultWalkSpeed
                
                -- Aplicar God Mode
                if State:Get("God") then
                    humanoid.Health = humanoid.MaxHealth or Config.Movement.MaxHealth
                end
            end
        end)
    end)
end

return Movement
