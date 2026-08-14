--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    FEATURES/JUMP.LUA - Sistema de Salto Infinito             ║
    ║              Permite pular infinitamente                      ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Services = require(script.Parent.Parent:WaitForChild("services"))
local State = require(script.Parent.Parent:WaitForChild("state"))

local Jump = {}

function Jump:Init()
    Services.UserInputService.JumpRequest:Connect(function()
        if not State:Get("Jump") then return end
        
        local character = Services.LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end)
end

return Jump
