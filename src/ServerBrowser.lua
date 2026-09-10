local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)
local Notifications = require(script.Parent.Notifications)

local ServerBrowser = {}

function ServerBrowser.create(parent, owner)
    local win = Instance.new("Frame", parent)
    win.Size = UDim2.new(0, 260, 0, 320)
    win.Position = UDim2.new(0.5, 155, 0.12, 0)
    win.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    win.Visible = false
    win.Active = true
    win.Draggable = true
    Instance.new("UICorner", win).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", win)
    stroke.Thickness = 2

    task.spawn(function()
        while win and win.Parent do
            pcall(function() stroke.Color = Color3.fromHSV((tick() % 1), 0.8, 1) end)
            task.wait(0.02)
        end
    end)

    local title = Instance.new("TextLabel", win)
    title.Size = UDim2.new(1, -30, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ RST SECTOR SELECTOR"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0, 255, 100)
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton", win)
    close.Size = UDim2.new(0, 22, 0, 22)
    close.Position = UDim2.new(1, -28, 0, 4)
    close.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 100, 100)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 10
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 4)
    close.MouseButton1Click:Connect(function()
        win.Visible = false
    end)

    local scanBtn = Instance.new("TextButton", win)
    scanBtn.Size = UDim2.new(0.9, 0, 0, 28)
    scanBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
    scanBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
    scanBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    scanBtn.Text = "🔍 VARRER SETORES (SCAN)"
    scanBtn.Font = Enum.Font.GothamBold
    scanBtn.TextSize = 10
    Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame", win)
    scroll.Size = UDim2.new(0.9, 0, 0.70, 0)
    scroll.Position = UDim2.new(0.05, 0, 0.25, 0)
    scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness = 4
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)

    local function populateServers()
        for _, child in pairs(scroll:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local now = tick()
        for id, serverTime in pairs(getgenv().RST_VisitedServers) do
            if now - serverTime > 300 then
                getgenv().RST_VisitedServers[id] = nil
            end
        end

        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local res = game:HttpGet(url)
            local data = game:GetService("HttpService"):JSONDecode(res)
            if data and data.data then
                local count = 0
                for _, server in ipairs(data.data) do
                    if type(server) == "table" and server.id ~= game.JobId then
                        local visited = getgenv().RST_VisitedServers[server.id]
                        if not visited or (now - visited > 300) then
                            count = count + 1
                            local btn = Instance.new("TextButton", scroll)
                            btn.Size = UDim2.new(1, -4, 0, 26)
                            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                            btn.Font = Enum.Font.Gotham
                            btn.TextSize = 9
                            btn.Text = string.format("Setor: %s | Operadores: %d/%d", string.sub(server.id, 1, 8), server.playing, server.maxPlayers)
                            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

                            local sid = server.id
                            btn.MouseButton1Click:Connect(function()
                                btn.Text = "INFILTRANDO..."
                                getgenv().RST_VisitedServers[sid] = tick()
                                Services.Teleport:TeleportToPlaceInstance(game.PlaceId, sid, Services.Player)
                            end)
                        end
                    end
                end

                if count == 0 then
                    local lbl = Instance.new("TextLabel", scroll)
                    lbl.Size = UDim2.new(1, 0, 0, 30)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.fromRGB(200, 50, 50)
                    lbl.Text = "Nenhum setor disponível no momento."
                    lbl.Font = Enum.Font.Gotham
                    lbl.TextSize = 9
                end
            end
        end)
    end

    scanBtn.MouseButton1Click:Connect(function()
        scanBtn.Text = "VARRENDO..."
        populateServers()
        task.wait(0.5)
        scanBtn.Text = "🔍 VARRER SETORES (SCAN)"
    end)

    return {
        Frame = win,
        Visible = function(value)
            win.Visible = value
        end,
        Populate = populateServers,
    }
end

return ServerBrowser
