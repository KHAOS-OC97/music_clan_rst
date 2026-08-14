--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    FEATURES/ANTIAFK.LUA - Sistema Anti-AFK                   ║
    ║              Previne afk kick do servidor                     ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Services = require(script.Parent.Parent:WaitForChild("services"))
local State = require(script.Parent.Parent:WaitForChild("state"))

local AntiAFK = {}

function AntiAFK:Init()
    Services.LocalPlayer.Idled:Connect(function()
        if not State:Get("AntiAFK") then return end
        
        pcall(function()
            -- Simulando movimento do mouse
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:Button2Down(Vector2.new(0, 0), Services.Camera.CFrame)
            task.wait(0.5)
            Services.VirtualUser:Button2Up(Vector2.new(0, 0), Services.Camera.CFrame)
        end)
    end)
end

return AntiAFK
