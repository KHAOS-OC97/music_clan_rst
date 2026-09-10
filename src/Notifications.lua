local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)

local Notifications = {}

function Notifications.show(message)
    task.spawn(function()
        local gui = Services.PlayerGui:FindFirstChild(Config.UiName) or Services.Gui
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(0, 240, 0, 28)
        label.Position = UDim2.new(0.5, -120, 0, -40)
        label.BackgroundColor3 = Color3.fromRGB(12, 18, 12)
        label.TextColor3 = Color3.fromRGB(0, 255, 100)
        label.Text = "⚡ " .. message
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke", label)
        stroke.Color = Color3.fromRGB(0, 200, 80)
        stroke.Thickness = 1.5

        pcall(function()
            Services.Tween:Create(label, TweenInfo.new(0.25), {Position = UDim2.new(0.5, -120, 0, 15)}):Play()
            task.wait(2)
            Services.Tween:Create(label, TweenInfo.new(0.25), {Position = UDim2.new(0.5, -120, 0, -40)}):Play()
            task.wait(0.3)
            label:Destroy()
        end)
    end)
end

return Notifications
