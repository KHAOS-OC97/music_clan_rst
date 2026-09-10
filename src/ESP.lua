local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)

local ESP = {}

local TAG_NAME = "HOC_ELITE_TAG"
local TARGET_TAG_NAME = "HOC_TARGET_TAG"

local function createTag(head, displayName, isTarget)
    local tag = Instance.new("BillboardGui")
    tag.Name = isTarget and TARGET_TAG_NAME or TAG_NAME
    tag.Size = UDim2.new(0, 300, 0, 70)
    tag.AlwaysOnTop = true
    tag.MaxDistance = 10000000
    tag.StudsOffset = Vector3.new(0, 4, 0)
    tag.LightInfluence = 0

    local lbl = Instance.new("TextLabel", tag)
    lbl.Name = "DisplayNameText"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = isTarget and ("🎯 " .. displayName) or displayName
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 18
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextColor3 = isTarget and Color3.fromRGB(255, 50, 50) or Color3.new(1, 1, 1)

    local ok = pcall(function() tag.Parent = head end)
    if not ok then
        pcall(function()
            tag.Parent = workspace
            tag.Adornee = head
        end)
    end

    return tag
end

function ESP.run()
    task.spawn(function()
        while true do
            task.wait(0.15)
            local espEnabled = getgenv().HNkUI.ESP
            local targetEspEnabled = getgenv().HNkUI.TargetESP

            for _, player in pairs(Services.Players:GetPlayers()) do
                if player ~= Services.Player and player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function()
                            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            humanoid.NameDisplayDistance = 0
                            humanoid.HealthDisplayDistance = 0
                        end)
                    end

                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local isTarget = table.find(getgenv().HkMultiTargets, player.Name) ~= nil
                        local targetTag = head:FindFirstChild(TARGET_TAG_NAME)
                        local eliteTag = head:FindFirstChild(TAG_NAME)

                        if isTarget then
                            if eliteTag then
                                pcall(function() eliteTag:Destroy() end)
                            end

                            if targetEspEnabled then
                                if not targetTag then
                                    createTag(head, player.DisplayName, true)
                                end
                            else
                                if targetTag then
                                    pcall(function() targetTag:Destroy() end)
                                end
                            end
                        else
                            if targetTag then
                                pcall(function() targetTag:Destroy() end)
                            end

                            if espEnabled then
                                if not eliteTag then
                                    eliteTag = createTag(head, player.DisplayName, false)
                                end
                                if eliteTag then
                                    local lbl = eliteTag:FindFirstChild("DisplayNameText")
                                    if lbl then
                                        pcall(function() lbl.TextColor3 = Color3.fromRGB(0, 200, 80) end)
                                    end
                                end
                            else
                                if eliteTag then
                                    pcall(function() eliteTag:Destroy() end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

return ESP
