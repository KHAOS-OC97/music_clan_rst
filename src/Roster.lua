local Services = require(script.Parent.Services)
local Notifications = require(script.Parent.Notifications)

local Roster = {}

function Roster.buildRosterFromPlayers(container, queryText)
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local count = 0
    local query = string.lower(queryText or "")

    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= Services.Player then
            local nameLower = string.lower(player.Name)
            local displayLower = string.lower(player.DisplayName)
            local matches = (query == "" or string.find(nameLower, query) or string.find(displayLower, query))

            if matches then
                count = count + 1
                local button = Instance.new("TextButton", container)
                button.Size = UDim2.new(1, -4, 0, 18)
                local targetSelected = table.find(getgenv().HkMultiTargets, player.Name) ~= nil
                button.BackgroundColor3 = targetSelected and Color3.fromRGB(0, 120, 50) or Color3.fromRGB(25, 30, 25)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Text = (targetSelected and "✅ " or "🎯 ") .. player.DisplayName .. " (@" .. player.Name .. ")"
                button.Font = Enum.Font.Gotham
                button.TextSize = 8
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 3)

                local special = (nameLower == "kchaos97" or nameLower == "ckhaos79")
                if special then
                    local stroke = Instance.new("UIStroke", button)
                    stroke.Thickness = 1.5
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    task.spawn(function()
                        while button and button.Parent do
                            pcall(function()
                                stroke.Color = Color3.fromRGB(0, 200, 80)
                                button.TextColor3 = Color3.fromRGB(0, 200, 80)
                            end)
                            task.wait(0.02)
                        end
                    end)
                end

                button.MouseButton1Click:Connect(function()
                    local idx = table.find(getgenv().HkMultiTargets, player.Name)
                    if idx then
                        table.remove(getgenv().HkMultiTargets, idx)
                        Notifications.show("Alvo Removido: " .. player.Name)
                    else
                        table.insert(getgenv().HkMultiTargets, player.Name)
                    end
                    Roster.buildRosterFromPlayers(container, queryText)
                end)
            end
        end
    end

    container.CanvasSize = UDim2.new(0, 0, 0, count * 20)
end

return Roster
