--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    FEATURES/CAMERA.LUA - Sistema de Câmera (FOV)             ║
    ║              Controla o campo de visão                        ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent.Parent:WaitForChild("config"))
local Services = require(script.Parent.Parent:WaitForChild("services"))
local State = require(script.Parent.Parent:WaitForChild("state"))

local Camera = {}

function Camera:Init()
    -- Sincronizar FOV constantemente
    Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            local fov = State:Get("FOV") or Config.Camera.DefaultFOV
            Services.Camera.FieldOfView = fov
        end)
    end)
end

-- ==================== CICLAR FOV ====================
function Camera:CycleFOV()
    local currentFOV = State:Get("FOV") or Config.Camera.DefaultFOV
    local presets = Config.Camera.Presets
    
    local nextIndex = 1
    for i, fov in ipairs(presets) do
        if fov == currentFOV then
            nextIndex = (i % #presets) + 1
            break
        end
    end
    
    local newFOV = presets[nextIndex]
    State:Set("FOV", newFOV)
    return newFOV
end

return Camera
