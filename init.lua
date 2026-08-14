--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     INIT.LUA - Entry Point (Funciona com LoadString)         ║
    ║        Carrega todos os módulos via HTTP corretamente         ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local baseUrl = "https://raw.githubusercontent.com/KHAOS-OC97/music_clan_rst/main"

-- Função para carregar módulos via HTTP
local function loadModule(path)
    local url = baseUrl .. "/" .. path
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("❌ Erro ao carregar " .. path .. ": " .. result)
    end
    
    return result
end

-- Função para executar código Lua
local function executeModule(code)
    local func, err = loadstring(code)
    if not func then
        error("❌ Erro ao compilar: " .. err)
    end
    return func()
end

print("═══════════════════════════════════════════════════════════")
print("  🔥 KChaos CKhaos Step v8.2 - Inicializando...          ")
print("═══════════════════════════════════════════════════════════")

-- Carregar módulos na ordem correta
print("  📥 Carregando módulos...")

local Config = executeModule(loadModule("config.lua"))
local Services = executeModule(loadModule("services.lua"))
local State = executeModule(loadModule("state.lua"))

local Notification = executeModule(loadModule("ui/notification.lua"))
local Components = executeModule(loadModule("ui/components.lua"))
local Panel = executeModule(loadModule("ui/panel.lua"))

local AntiAFK = executeModule(loadModule("features/antiafk.lua"))
local ESP = executeModule(loadModule("features/esp.lua"))
local Jump = executeModule(loadModule("features/jump.lua"))
local Movement = executeModule(loadModule("features/movement.lua"))
local Camera = executeModule(loadModule("features/camera.lua"))
local Teleport = executeModule(loadModule("features/teleport.lua"))
local Spam = executeModule(loadModule("features/spam.lua"))

print("  ✅ Todos os módulos carregados!")
print("")

-- ==================== INICIALIZAÇÃO PRINCIPAL ====================
local function Init()
    print("  ✓ Inicializando Estado Global...")
    State:Init()
    
    print("  ✓ Construindo Interface...")
    Panel:Create()
    Panel:AddToggles()
    Panel:AddSpamControl(function(cadencia)
        State:Set("SpamCadencia", cadencia)
    end)
    
    print("  ✓ Conectando Callbacks...")
    Panel:AddButtons(
        function()
            local newFOV = Camera:CycleFOV()
            Panel.FOVButton.Text = "DRONE VIEW (FOV): " .. newFOV
            Notification:Show("FOV alterado para: " .. newFOV, true)
        end,
        function()
            Teleport:ToAlly()
        end
    )
    
    print("  ✓ Iniciando Loops...")
    Panel:StartRGBLoop()
    Panel:SetupVisibilityToggle()
    
    -- Sincronizar estado global com toggles
    task.spawn(function()
        while _G_Running do
            _G_ESP = State:Get("ESP") or false
            _G_Spam = State:Get("Spam") or false
            task.wait(0.1)
        end
    end)
    
    print("  ✓ Ativando Features...")
    AntiAFK:Init()
    
    local ctx = {
        Services = Services,
        State = State,
    }
    
    ESP:Init(ctx)
    Jump:Init()
    Movement:Init()
    Camera:Init()
    Spam:Init(ctx)
    
    print("")
    print("═══════════════════════════════════════════════════════════")
    print("  ✅ Script Carregado com Sucesso!                        ")
    print("═══════════════════════════════════════════════════════════")
    print("  🎮 Pressione CTRL para mostrar/esconder painel           ")
    print("═══════════════════════════════════════════════════════════")
    print("")
    
    Notification:Show("🔥 SCRIPT ATIVADO - RST PRONTO! 🔥", true)
end

-- Inicializar variáveis globais
_G_Running = true
_G_ESP = false
_G_Spam = false

-- Executar inicialização
pcall(Init)
