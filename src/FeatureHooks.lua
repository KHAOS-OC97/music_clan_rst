local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)
local Notifications = require(script.Parent.Notifications)
local EmoteSync = require(script.Parent.EmoteSync)
local ServerBrowser = require(script.Parent.ServerBrowser)
local ESP = require(script.Parent.ESP)

local FeatureHooks = {}

function FeatureHooks.bind(ui, serverWindow)
    local settings = {
        AntiAFK = false,
        ESP = false,
        TargetESP = false,
        Jump = false,
        Spectate = false,
    }

    -- jump request behavior
    Services.Input.JumpRequest:Connect(function()
        if not getgenv().HNkUI.Jump then return end
        local character = Services.Player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end)
            end
        end
    end)

    -- spectator loop
    local spectating = false
    local activeSpectate = nil
    task.spawn(function()
        while true do
            task.wait(0.5)
            if getgenv().HNkUI.Spectate then
                if not spectating and #getgenv().HkMultiTargets > 0 then
                    spectating = true
                    local target = Services.Players:FindFirstChild(getgenv().HkMultiTargets[1])
                    if target and target.Character then
                        pcall(function()
                            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
                            Notifications.show("Espectando: " .. target.DisplayName)
                            activeSpectate = target.Name
                        end)
                    end
                elseif spectating and activeSpectate and not table.find(getgenv().HkMultiTargets, activeSpectate) then
                    spectating = false
                    pcall(function()
                        workspace.CurrentCamera.CameraSubject = Services.Player.Character:FindFirstChildOfClass("Humanoid")
                    end)
                end
            else
                if spectating then
                    spectating = false
                    pcall(function()
                        workspace.CurrentCamera.CameraSubject = Services.Player.Character:FindFirstChildOfClass("Humanoid")
                    end)
                end
            end
        end
    end)

    -- anti-afk idles
    Services.Player.Idled:Connect(function()
        if getgenv().HNkUI.AntiAFK then
            pcall(function()
                local virtualUser = game:GetService("VirtualUser")
                virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                Notifications.show("Anti-AFK Bypass Ativado")
            end)
        end
    end)

    -- HUD hide/show toggle
    Services.Input.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            ui.frame.Visible = not ui.frame.Visible
            Notifications.show(ui.frame.Visible and "HUD Online" or "HUD Oculta")
        end
    end)

    -- FOV switch button
    if ui.fovButton then
        ui.fovButton.MouseButton1Click:Connect(function()
            local current = getgenv().HNkUI.FOV
            getgenv().HNkUI.FOV = (current == 70 and 90) or (current == 90 and 120) or 70
            ui.fovButton.Text = "DRONE VIEW (FOV): " .. getgenv().HNkUI.FOV
            pcall(function()
                workspace.CurrentCamera.FieldOfView = getgenv().HNkUI.FOV
            end)
        end)
    end

    -- emote sync button
    if ui.syncButton then
        ui.syncButton.MouseButton1Click:Connect(function()
            EmoteSync.sync()
        end)
    end

    -- extraction button
    if ui.extractButton then
        ui.extractButton.MouseButton1Click:Connect(function()
            for _, player in pairs(Services.Players:GetPlayers()) do
                if table.find(Config.TargetNames, player.Name) and player ~= Services.Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        Services.Player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end)
                    Notifications.show("Extraído para: " .. player.DisplayName)
                    break
                end
            end
        end)
    end

    -- server browser opener
    if ui.serverButton then
        ui.serverButton.MouseButton1Click:Connect(function()
            serverWindow.Frame.Visible = not serverWindow.Frame.Visible
            if serverWindow.Frame.Visible then
                local currentId = game.JobId
                if currentId and currentId ~= "" then
                    getgenv().RST_VisitedServers[currentId] = tick()
                end
                serverWindow.Populate()
                Notifications.show("Seletor de Setores Aberto")
            end
        end)
    end

    -- start ESP
    ESP.run()
end

return FeatureHooks
