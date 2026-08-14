--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    UI/NOTIFICATION.LUA - Sistema de Notificações             ║
    ║              Notificações estilizadas do script               ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent.Parent:WaitForChild("config"))
local Services = require(script.Parent.Parent:WaitForChild("services"))

local Notification = {}

local function GetGuiParent()
    if Services.CoreGui and Services.CoreGui.Parent then
        return Services.CoreGui
    end

    if Services.LocalPlayer and Services.LocalPlayer:FindFirstChild("PlayerGui") then
        return Services.LocalPlayer.PlayerGui
    end

    return nil
end

-- Função principal para exibir notificações
function Notification:Show(message, success)
    success = success or false

    local parent = GetGuiParent()
    if not parent then
        return
    end

    local existing = parent:FindFirstChild(Config.UI.NotificationGui.Name)
    if existing then
        pcall(function() existing:Destroy() end)
    end

    local gui = Instance.new("ScreenGui", parent)
    gui.Name = Config.UI.NotificationGui.Name
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = Config.UI.NotificationGui.Size
    frame.Position = Config.UI.NotificationGui.Position
    frame.BackgroundColor3 = Config.Colors.Black
    frame.BackgroundTransparency = 0.3
    frame.ZIndex = 100

    Instance.new("UICorner", frame).CornerRadius = Config.UI.NotificationGui.CornerRadius

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2

    task.spawn(function()
        while frame and frame.Parent do
            pcall(function()
                stroke.Color = Config.Colors.RGBCycle or Config.Colors.White
            end)
            task.wait(0.02)
        end
    end)

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = success and Config.Colors.Green or Config.Colors.Red
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 12
    textLabel.ZIndex = 101

    task.delay(Config.UI.NotificationGui.Duration, function()
        pcall(function() gui:Destroy() end)
    end)
end

return Notification
