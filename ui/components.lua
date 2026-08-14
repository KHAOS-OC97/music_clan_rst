--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║    UI/COMPONENTS.LUA - Componentes Reutilizáveis da UI       ║
    ║         Toggles, Botões, e outros elementos visuais          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = require(script.Parent.Parent:WaitForChild("config"))
local State = require(script.Parent.Parent:WaitForChild("state"))
local Services = require(script.Parent.Parent:WaitForChild("services"))

local Components = {}

-- ==================== CRIAR TOGGLE ====================
function Components:CreateToggle(parent, labelText, yOffset, stateKey, onToggle)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.9, 0, 0, 28)
    container.Position = UDim2.new(0.05, 0, yOffset, 0)
    container.BackgroundTransparency = 1
    container.ZIndex = 2
    
    -- Label do toggle
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.66, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Config.Colors.LightGray
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 11
    label.ZIndex = 2
    
    -- Botão de switch
    local switch = Instance.new("TextButton", container)
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(0.78, 0, 0.2, 0)
    switch.BackgroundColor3 = Config.Colors.Red
    switch.Text = ""
    switch.ZIndex = 2
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    -- Knob (bolinhas do switch)
    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Config.Colors.White
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    -- Conectar clique
    switch.MouseButton1Click:Connect(function()
        local newState = State:Toggle(stateKey)
        
        -- Animar knob
        Services.TweenService:Create(
            knob,
            TweenInfo.new(Config.Animation.TweenDuration),
            {Position = newState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}
        ):Play()
        
        -- Animar cor do switch
        Services.TweenService:Create(
            switch,
            TweenInfo.new(Config.Animation.TweenDuration),
            {BackgroundColor3 = newState and Config.Colors.Green or Config.Colors.Red}
        ):Play()
        
        -- Atualizar cor do label
        label.TextColor3 = newState and Config.Colors.White or Config.Colors.LightGray
        
        -- Callback personalizado
        if onToggle then
            onToggle(newState)
        end
    end)
    
    return {container = container, label = label, switch = switch, knob = knob}
end

-- ==================== CRIAR BOTÃO RGB ====================
function Components:CreateRGBButton(parent, text, yPos, onClicked)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 32)
    button.Position = UDim2.new(0.05, 0, yPos, 0)
    button.BackgroundColor3 = Config.Colors.DarkGray
    button.BackgroundTransparency = 0.2
    button.Text = text
    button.TextColor3 = Config.Colors.White
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.ZIndex = 2
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", button)
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Loop RGB para borda
    task.spawn(function()
        while button and button.Parent do
            pcall(function()
                stroke.Color = Config.Colors.RGBCycle or Config.Colors.White
            end)
            task.wait(0.02)
        end
    end)
    
    -- Clique
    if onClicked then
        button.MouseButton1Click:Connect(onClicked)
    end
    
    return button
end

return Components
