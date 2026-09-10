local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)
local Notifications = require(script.Parent.Notifications)
local Roster = require(script.Parent.Roster)
local ServerBrowser = require(script.Parent.ServerBrowser)

local Hud = {}

local function buildToggleRow(frame, labelText, rowOffset, key)
    local row = Instance.new("Frame", frame)
    row.Size = UDim2.new(0.9, 0, 0, 20)
    row.Position = UDim2.new(0.05, 0, rowOffset, 0)
    row.BackgroundTransparency = 1

    local txt = Instance.new("TextLabel", row)
    txt.Size = UDim2.new(0.66, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = labelText
    txt.TextColor3 = Color3.fromRGB(240, 240, 240)
    txt.Font = Enum.Font.Gotham
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.TextSize = 9

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 30, 0, 15)
    btn.Position = UDim2.new(0.8, 0, 0.15, 0)
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame", btn)
    thumb.Size = UDim2.new(0, 11, 0, 11)
    thumb.Position = UDim2.new(0, 2, 0.5, -5.5)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        getgenv().HNkUI[key] = not getgenv().HNkUI[key]
        local enabled = getgenv().HNkUI[key]
        Services.Tween:Create(thumb, TweenInfo.new(0.15), {Position = enabled and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)}):Play()
        Services.Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(150, 0, 0)}):Play()
        txt.TextColor3 = enabled and Color3.new(1, 1, 1) or Color3.fromRGB(240, 240, 240)
        Notifications.show(labelText .. ": " .. (enabled and "ATIVADO" or "DESATIVADO"))
    end)

    return btn
end

function Hud.create(parent)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = Config.UiName
    screenGui.ResetOnSpawn = false
    screenGui.Parent = parent

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 550)
    frame.Position = UDim2.new(0.5, -150, 0.12, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BackgroundTransparency = 0.15
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local border = Instance.new("UIStroke", frame)
    border.Thickness = 2
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    task.spawn(function()
        local shift = 0
        while frame and frame.Parent do
            shift = (shift + 0.007) % 1
            pcall(function()
                border.Color = Color3.fromHSV(shift, 0.8, 1)
            end)
            task.wait(0.02)
        end
    end)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -60, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🇧🇷 RST TACTICAL HUD v8.2 🇺🇸"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2

    local minimize = Instance.new("TextButton", frame)
    minimize.Size = UDim2.new(0, 24, 0, 24)
    minimize.Position = UDim2.new(1, -34, 0, 3)
    minimize.BackgroundColor3 = Color3.fromRGB(30, 40, 30)
    minimize.Text = "-"
    minimize.TextColor3 = Color3.fromRGB(0, 255, 100)
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 14
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 4)

    local minimized = false
    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        minimize.Text = minimized and "+" or "-"
        for _, child in pairs(frame:GetChildren()) do
            if child ~= title and child ~= minimize and child ~= border and child:IsA("GuiObject") then
                child.Visible = not minimized
            end
        end
        frame.Size = minimized and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 550)
        Notifications.show(minimized and "HUD Minimizada" or "HUD Expandida")
    end)

    local pingLabel = Instance.new("TextLabel", frame)
    pingLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    pingLabel.Size = UDim2.new(0.9, 0, 0, 16)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "PING: 0ms | FPS: 60 | PLAYERS: 0"
    pingLabel.TextColor3 = Color3.fromRGB(150, 220, 150)
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 9

    task.spawn(function()
        while true do
            pcall(function()
                local ping = math.floor(Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                local fps = math.floor(1 / Services.Run.RenderStepped:Wait() + 0.5)
                local players = #Services.Players:GetPlayers()
                pingLabel.Text = string.format("PING: %dms | FPS: %d | PLAYERS: %d", ping, fps, players)
            end)
            task.wait(1)
        end
    end)

    local divider = Instance.new("Frame", frame)
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0.09, 0)
    divider.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    divider.BorderSizePixel = 0

    local transmissionTitle = Instance.new("TextLabel", frame)
    transmissionTitle.Position = UDim2.new(0.05, 0, 0.10, 0)
    transmissionTitle.Size = UDim2.new(0.9, 0, 0, 16)
    transmissionTitle.BackgroundTransparency = 1
    transmissionTitle.Text = "RST TRANSMISSION CENTER"
    transmissionTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    transmissionTitle.Font = Enum.Font.GothamBold
    transmissionTitle.TextSize = 9

    local cadenceLabel = Instance.new("TextLabel", frame)
    cadenceLabel.Position = UDim2.new(0.05, 0, 0.14, 0)
    cadenceLabel.Size = UDim2.new(0.55, 0, 0, 20)
    cadenceLabel.BackgroundTransparency = 1
    cadenceLabel.Text = "Cadence (5 to 15s):"
    cadenceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    cadenceLabel.Font = Enum.Font.Gotham
    cadenceLabel.TextSize = 9
    cadenceLabel.TextXAlignment = Enum.TextXAlignment.Left

    local cadenceBox = Instance.new("TextBox", frame)
    cadenceBox.Position = UDim2.new(0.65, 0, 0.14, 0)
    cadenceBox.Size = UDim2.new(0.3, 0, 0, 20)
    cadenceBox.BackgroundColor3 = Color3.fromRGB(30, 38, 30)
    cadenceBox.TextColor3 = Color3.fromRGB(0, 255, 100)
    cadenceBox.BorderColor3 = Color3.fromRGB(0, 200, 80)
    cadenceBox.Text = tostring(Config.Cadence)
    cadenceBox.Font = Enum.Font.GothamBold
    cadenceBox.TextSize = 9
    Instance.new("UICorner", cadenceBox).CornerRadius = UDim.new(0, 4)

    local transmissionButton = Instance.new("TextButton", frame)
    transmissionButton.Position = UDim2.new(0.05, 0, 0.19, 0)
    transmissionButton.Size = UDim2.new(0.9, 0, 0, 24)
    transmissionButton.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
    transmissionButton.Text = "START TRANSMISSION"
    transmissionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    transmissionButton.Font = Enum.Font.GothamBold
    transmissionButton.TextSize = 9
    Instance.new("UICorner", transmissionButton).CornerRadius = UDim.new(0, 6)

    local transmissionStatus = Instance.new("TextLabel", frame)
    transmissionStatus.Position = UDim2.new(0.05, 0, 0.24, 0)
    transmissionStatus.Size = UDim2.new(0.9, 0, 0, 16)
    transmissionStatus.BackgroundTransparency = 1
    transmissionStatus.Text = "STATUS: CEASEFIRE"
    transmissionStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
    transmissionStatus.Font = Enum.Font.Gotham
    transmissionStatus.TextSize = 9

    local transmissionEnabled = false
    cadenceBox.FocusLost:Connect(function()
        local value = tonumber(cadenceBox.Text)
        if value then
            Config.Cadence = math.clamp(math.floor(value), 5, 15)
        end
        cadenceBox.Text = tostring(Config.Cadence)
    end)

    transmissionButton.MouseButton1Click:Connect(function()
        transmissionEnabled = not transmissionEnabled
        if transmissionEnabled then
            transmissionButton.Text = "CEASE FIRE"
            transmissionButton.BackgroundColor3 = Color3.fromRGB(25, 130, 25)
            transmissionStatus.Text = "STATUS: OPERATIONAL (" .. Config.Cadence .. "s)"
            transmissionStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
            Notifications.show("Transmissão Ativada")
        else
            transmissionButton.Text = "START TRANSMISSION"
            transmissionButton.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
            transmissionStatus.Text = "STATUS: CEASEFIRE"
            transmissionStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
            Notifications.show("Transmissão Pausada")
        end
    end)

    local divider2 = Instance.new("Frame", frame)
    divider2.Size = UDim2.new(0.9, 0, 0, 1)
    divider2.Position = UDim2.new(0.05, 0, 0.28, 0)
    divider2.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    divider2.BorderSizePixel = 0

    local rows = {
        {label = "ANTI-AFK", key = "AntiAFK", y = 0.30},
        {label = "ESP VISION (ALL)", key = "ESP", y = 0.342},
        {label = "TARGET ESP (MULTI)", key = "TargetESP", y = 0.384},
        {label = "INFINITE JUMP", key = "Jump", y = 0.426},
        {label = "SPECTATE TARGET", key = "Spectate", y = 0.468},
    }

    local toggles = {}
    for i, row in ipairs(rows) do
        local toggle = buildToggleRow(frame, row.label, row.y, row.key)
        toggles[row.key] = toggle
    end

    local rosterTitle = Instance.new("TextLabel", frame)
    rosterTitle.Position = UDim2.new(0.05, 0, 0.52, 0)
    rosterTitle.Size = UDim2.new(0.9, 0, 0, 15)
    rosterTitle.BackgroundTransparency = 1
    rosterTitle.Text = "🎯 MULTI-TARGET ROSTER & SEARCH"
    rosterTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    rosterTitle.Font = Enum.Font.GothamBold
    rosterTitle.TextSize = 9
    rosterTitle.TextXAlignment = Enum.TextXAlignment.Left

    local searchBox = Instance.new("TextBox", frame)
    searchBox.Position = UDim2.new(0.05, 0, 0.55, 0)
    searchBox.Size = UDim2.new(0.9, 0, 0, 18)
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
    searchBox.TextColor3 = Color3.fromRGB(0, 255, 100)
    searchBox.BorderColor3 = Color3.fromRGB(0, 200, 80)
    searchBox.PlaceholderText = "Pesquisar operador..."
    searchBox.Text = ""
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 9
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

    local rosterFrame = Instance.new("ScrollingFrame", frame)
    rosterFrame.Position = UDim2.new(0.05, 0, 0.58, 0)
    rosterFrame.Size = UDim2.new(0.9, 0, 0.12, 0)
    rosterFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 15)
    rosterFrame.BorderSizePixel = 0
    rosterFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    rosterFrame.ScrollBarThickness = 4
    Instance.new("UICorner", rosterFrame).CornerRadius = UDim.new(0, 4)

    local rosterLayout = Instance.new("UIListLayout", rosterFrame)
    rosterLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rosterLayout.Padding = UDim.new(0, 2)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Roster.buildRosterFromPlayers(rosterFrame, searchBox.Text)
    end)
    Services.Players.PlayerAdded:Connect(function()
        Roster.buildRosterFromPlayers(rosterFrame, searchBox.Text)
    end)
    Services.Players.PlayerRemoving:Connect(function()
        Roster.buildRosterFromPlayers(rosterFrame, searchBox.Text)
    end)
    task.spawn(function()
        Roster.buildRosterFromPlayers(rosterFrame, searchBox.Text)
    end)

    local emoteTitle = Instance.new("TextLabel", frame)
    emoteTitle.Position = UDim2.new(0.05, 0, 0.71, 0)
    emoteTitle.Size = UDim2.new(0.9, 0, 0, 15)
    emoteTitle.BackgroundTransparency = 1
    emoteTitle.Text = "🕺 EMOTE SYNC CENTER"
    emoteTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    emoteTitle.Font = Enum.Font.GothamBold
    emoteTitle.TextSize = 9
    emoteTitle.TextXAlignment = Enum.TextXAlignment.Left

    local function createButton(text, y)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0.9, 0, 0, 22)
        btn.Position = UDim2.new(0.05, 0, y, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        task.spawn(function()
            while btn and btn.Parent do
                pcall(function() stroke.Color = Color3.fromHSV((tick() % 1), 0.8, 1) end)
                task.wait(0.02)
            end
        end)
        return btn
    end

    local syncButton = createButton("🔄 SYNCHRONIZE EMOTE (AUTO)", 0.74)
    local fovButton = createButton("DRONE VIEW (FOV): 70", 0.80)
    local extraButton = createButton("🚀 ELITE EXTRACTION (ALLY TP)", 0.86)

    local serverWindow = ServerBrowser.create(screenGui)
    local serverButton = createButton("🌐 SECTOR SELECTOR (SERVERS)", 0.92)
    serverButton.MouseButton1Click:Connect(function()
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

    return {
        screenGui = screenGui,
        frame = frame,
        title = title,
        minimize = minimize,
        pingLabel = pingLabel,
        transmissionButton = transmissionButton,
        transmissionStatus = transmissionStatus,
        transmissionCadence = cadenceBox,
        syncButton = syncButton,
        fovButton = fovButton,
        extractButton = extraButton,
        searchBox = searchBox,
        serverButton = serverButton,
        rosterFrame = rosterFrame,
        serverWindow = serverWindow,
        toggles = toggles,
    }
end

return Hud
