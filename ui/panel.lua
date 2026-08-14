--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║       UI/PANEL.LUA - Painel Principal (Glass Edition)        ║
    ║                 Interface do Script                           ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent.Parent:WaitForChild("config"))
local Services = require(script.Parent.Parent:WaitForChild("services"))
local Components = require(script.Parent:WaitForChild("components"))
local Notification = require(script.Parent:WaitForChild("notification"))

local Panel = {}

Panel.MainGui = nil
Panel.MainFrame = nil

-- ==================== LIMPEZA ====================
function Panel:Cleanup()
    for _, guiName in ipairs(Config.Cleanup.GuiNames) do
        local existing = Services.CoreGui:FindFirstChild(guiName)
        if existing then
            pcall(function() existing:Destroy() end)
        end
    end
end

-- ==================== CRIAR PAINEL ====================
function Panel:Create()
    self:Cleanup()
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui", Services.CoreGui)
    screenGui.Name = Config.UI.MainWindow.Name
    screenGui.ResetOnSpawn = false
    self.MainGui = screenGui
    
    -- Frame principal com efeito vidro
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "MainPanel"
    mainFrame.Size = Config.UI.MainWindow.Size
    mainFrame.Position = Config.UI.MainWindow.Position
    mainFrame.BackgroundColor3 = Config.UI.MainWindow.BackgroundColor
    mainFrame.BackgroundTransparency = Config.UI.MainWindow.BackgroundTransparency
    mainFrame.Active = true
    mainFrame.Draggable = Config.UI.MainWindow.Draggable
    mainFrame.ZIndex = 1
    
    Instance.new("UICorner", mainFrame).CornerRadius = Config.UI.MainWindow.CornerRadius
    
    -- Imagem de fundo (vidro)
    local bgImage = Instance.new("ImageLabel", mainFrame)
    bgImage.Name = "GlassBackground"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = Config.UI.BackgroundImage
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageTransparency = Config.UI.BackgroundImageTransparency
    bgImage.ZIndex = 0
    Instance.new("UICorner", bgImage).CornerRadius = Config.UI.MainWindow.CornerRadius
    
    -- Borda RGB
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Thickness = Config.UI.StrokeThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    self.MainStroke = stroke
    
    -- Título
    local title = Instance.new("TextLabel", mainFrame)
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = Config.UI.TitleText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = Config.Colors.White
    title.ZIndex = 2
    
    self.MainFrame = mainFrame
    
    return mainFrame
end

-- ==================== ADICIONAR TOGGLES ====================
function Panel:AddToggles()
    if not self.MainFrame then return end

    local togglesConfig = {
        {key = "AntiAFK", label = Config.Features.AntiAFK.Label, y = 40},
        {key = "ESP", label = Config.Features.ESP.Label, y = 80},
        {key = "God", label = Config.Features.God.Label, y = 120},
        {key = "Jump", label = Config.Features.Jump.Label, y = 160},
        {key = "Spam", label = Config.Features.Spam.Label, y = 200},
    }

    for _, toggleCfg in ipairs(togglesConfig) do
        local callback = function(state)
            if toggleCfg.key == "AntiAFK" then
                local msg = state and "🛡️ ANTI-AFK: ATIVO" or "⚠️ ANTI-AFK: INATIVO"
                Notification:Show(msg, state)
            elseif toggleCfg.key == "Spam" then
                local msg = state and "🔥 RST: TRANSMISSÃO ATIVA" or "⚠️ RST: TRANSMISSÃO CESSADA"
                Notification:Show(msg, state)
            end
        end

        Components:CreateToggle(self.MainFrame, toggleCfg.label, toggleCfg.y, toggleCfg.key, callback)
    end
end

-- ==================== ADICIONAR BOTÕES ====================
function Panel:AddButtons(onFOVClick, onTeleportClick)
    if not self.MainFrame then return end
    
    local fovButton = Components:CreateRGBButton(
        self.MainFrame,
        "DRONE VIEW (FOV): 70",
        275,
        onFOVClick
    )
    self.FOVButton = fovButton

    local tpButton = Components:CreateRGBButton(
        self.MainFrame,
        "🚀 EXTRAÇÃO ELITE (TP)",
        315,
        onTeleportClick
    )
    self.TeleportButton = tpButton
end

-- ==================== ADICIONAR CONTROLE DE CADÊNCIA SPAM ====================
function Panel:AddSpamControl(onCadenciaChange)
    if not self.MainFrame then return end
    
    -- Container
    local container = Instance.new("Frame", self.MainFrame)
    container.Size = UDim2.new(0.9, 0, 0, 28)
    container.Position = UDim2.new(0.05, 0, 0, 245)
    container.BackgroundTransparency = 1
    container.ZIndex = 2
    
    -- Label
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Cadência (s):"
    label.TextColor3 = Config.Colors.LightGray
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 11
    label.ZIndex = 2
    
    -- Input TextBox
    local inputBox = Instance.new("TextBox", container)
    inputBox.Size = UDim2.new(0.35, 0, 1, 0)
    inputBox.Position = UDim2.new(0.63, 0, 0, 0)
    inputBox.BackgroundColor3 = Config.Colors.DarkGray
    inputBox.TextColor3 = Config.Colors.Green
    inputBox.BorderColor3 = Config.Colors.Green
    inputBox.Text = tostring(Config.Features.Spam.DefaultCadencia)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 11
    inputBox.ZIndex = 2
    
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 4)
    
    -- Evento de mudança
    inputBox.FocusLost:Connect(function()
        local val = tonumber(inputBox.Text)
        if val then
            val = math.clamp(math.floor(val), Config.Features.Spam.MinCadencia, Config.Features.Spam.MaxCadencia)
            inputBox.Text = tostring(val)
            if onCadenciaChange then
                onCadenciaChange(val)
            end
        else
            inputBox.Text = tostring(Config.Features.Spam.DefaultCadencia)
        end
    end)
    
    self.SpamCadenciaInput = inputBox
end

-- ==================== LOOP RGB ====================
function Panel:StartRGBLoop()
    task.spawn(function()
        local h = 0
        while self.MainFrame and self.MainFrame.Parent do
            h = (h + Config.Animation.RGBCycleSpeed) % 1
            Config.Colors.RGBCycle = Color3.fromHSV(h, 0.8, 1)
            pcall(function() self.MainStroke.Color = Config.Colors.RGBCycle end)
            task.wait(0.02)
        end
    end)
end

-- ==================== TOGGLE VISIBILIDADE ====================
function Panel:SetupVisibilityToggle()
    Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.Input.ToggleVisibility then
            if self.MainFrame then
                self.MainFrame.Visible = not self.MainFrame.Visible
            end
        end
    end)
end

return Panel
