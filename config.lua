--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     CONFIG.LUA - Configurações Centralizadas do Script      ║
    ║              KChaos CKhaos Step v8.2 - Glass Edition         ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Config = {}

-- ==================== CONFIGURAÇÕES GERAIS ====================
Config.Script = {
    Name = "KChaos CKhaos Step",
    Version = "8.2 - GLASS EDITION",
    Edition = "Modular Architecture",
}

-- ==================== CORES ====================
Config.Colors = {
    White = Color3.new(1, 1, 1),
    Black = Color3.fromRGB(0, 0, 0),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(0, 255, 120),
    DarkGray = Color3.fromRGB(20, 20, 20),
    Gray = Color3.fromRGB(150, 150, 150),
    LightGray = Color3.fromRGB(240, 240, 240),
    RGBCycle = nil, -- será atualizado dinamicamente
}

-- ==================== UI ====================
Config.UI = {
    MainWindow = {
        Name = "HOC_NOC_ELITE_V2",
        Size = UDim2.new(0, 210, 0, 350),
        Position = UDim2.new(1, -470, 0, 10),
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        CornerRadius = UDim.new(0, 8),
        Draggable = true,
    },
    NotificationGui = {
        Name = "KChaos_Notify",
        Size = UDim2.new(0, 220, 0, 45),
        Position = UDim2.new(0.5, -110, 0.15, 0),
        Duration = 3,
        CornerRadius = UDim.new(0, 6),
    },
    BackgroundImage = "rbxassetid://138676643657782",
    BackgroundImageTransparency = 0.3,
    TitleText = "🇧🇷 KChaos CKhaos Step Dance 🇺🇸",
    StrokeThickness = 2,
}

-- ==================== FEATURES - ESTADO PADRÃO ====================
Config.Features = {
    AntiAFK = {
        Enabled = false,
        Label = "ANTI-AFK MARINES",
        Key = "AntiAFK",
    },
    ESP = {
        Enabled = false,
        Label = "ESP VISION",
        Key = "ESP",
    },
    God = {
        Enabled = false,
        Label = "GOD MODE",
        Key = "God",
    },
    Jump = {
        Enabled = false,
        Label = "INFINITE JUMP",
        Key = "Jump",
    },
    Spam = {
        Enabled = false,
        Label = "🔥 TRANSMISSÃO RST 🔥",
        Key = "Spam",
        DefaultCadencia = 5,
        MinCadencia = 3,
        MaxCadencia = 15,
    },
}

-- ==================== MOVIMENTO E CAMERA ====================
Config.Movement = {
    DefaultWalkSpeed = 16,
    MaxHealth = 100,
}

Config.Camera = {
    DefaultFOV = 70,
    Presets = {70, 90, 120},
}

-- ==================== TELEPORTE ====================
Config.Teleport = {
    AlliedPlayers = {"KChaos97", "CKhaos79"},
    Offset = Vector3.new(0, 0, 3), -- distância dos aliados
}

-- ==================== LIMPEZA ====================
Config.Cleanup = {
    GuiNames = {"HOC_NOC_ELITE_V2", "KChaos_Notify"},
}

-- ==================== INPUT ====================
Config.Input = {
    ToggleVisibility = Enum.KeyCode.LeftControl,
}

-- ==================== ANIMAÇÕES ====================
Config.Animation = {
    TweenDuration = 0.15,
    RGBCycleSpeed = 0.007, -- velocidade do ciclo RGB
    ESPCycleSpeed = 0.005,
}

return Config
