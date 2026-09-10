local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)
local Bootstrap = require(script.Parent.Bootstrap)
local Hud = require(script.Parent.Hud)
local Notifications = require(script.Parent.Notifications)
local Transmission = require(script.Parent.Transmission)
local FeatureHooks = require(script.Parent.FeatureHooks)

Bootstrap.setupEnv()
Bootstrap.cleanupOldUi()
Bootstrap.startErrorPromptTeleportWatch()

local ui = Hud.create(Services.PlayerGui)

FeatureHooks.bind(ui, ui.serverWindow)

-- Start the message cadence loop if the UI toggles transmission.
local active = false
local function startTransmission()
    active = not active
    if active then
        ui.transmissionButton.Text = "CEASE FIRE"
        ui.transmissionButton.BackgroundColor3 = Color3.fromRGB(25, 130, 25)
        ui.transmissionStatus.Text = "STATUS: OPERATIONAL (" .. Config.Cadence .. "s)"
        ui.transmissionStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
        Notifications.show("Transmissão Ativada")
    else
        ui.transmissionButton.Text = "START TRANSMISSION"
        ui.transmissionButton.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
        ui.transmissionStatus.Text = "STATUS: CEASEFIRE"
        ui.transmissionStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
        Notifications.show("Transmissão Pausada")
    end
end

ui.transmissionButton.MouseButton1Click:Connect(function()
    startTransmission()
end)

-- Transmission loop from the original script pattern.
task.spawn(function()
    while true do
        if active then
            pcall(function()
                Transmission.send()
            end)
            task.wait(Config.Cadence)
        else
            task.wait(0.3)
        end
    end
end)

return {
    ui = ui,
    config = Config,
}
