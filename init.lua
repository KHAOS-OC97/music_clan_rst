--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     INIT.LUA - Entry Point (Funciona com LoadString)         ║
    ║        Carrega todos os módulos via HTTP corretamente         ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local baseUrl = "https://raw.githubusercontent.com/KHAOS-OC97/music_clan_rst/main"

local function makeFakeFolder(name, parent)
    local folder = {
        Name = name,
        Parent = parent,
    }

    function folder:WaitForChild(childName)
        return self[childName]
    end

    return folder
end

local function makeFakeRoot()
    local root = makeFakeFolder("root", nil)
    root.config = nil
    root.services = nil
    root.state = nil

    root.ui = makeFakeFolder("ui", root)
    root.features = makeFakeFolder("features", root)

    return root
end

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

-- Função para executar código Lua com o ambiente "script" correto
local function executeModule(code, parent)
    local func, err = loadstring(code)
    if not func then
        error("❌ Erro ao compilar o módulo: " .. err)
    end

    local previousScript = _G.script
    _G.script = { Parent = parent, Name = parent and parent.Name or "script" }

    local success, result = xpcall(function()
        return func()
    end, function(msg)
        return msg
    end)

    _G.script = previousScript

    if not success then
        error("❌ Erro ao executar módulo: " .. tostring(result))
    end

    return result
end

print("═══════════════════════════════════════════════════════════")
print("  🔥 KChaos CKhaos Step v8.2 - Inicializando...          ")
print("═══════════════════════════════════════════════════════════")

-- Carregar módulos na ordem correta
print("  📥 Carregando módulos...")

local root = makeFakeRoot()

local Config = executeModule(loadModule("config.lua"), root)
root.config = Config
root.services = executeModule(loadModule("services.lua"), root)
root.state = executeModule(loadModule("state.lua"), root)

local Notification = executeModule(loadModule("ui/notification.lua"), root.ui)
root.ui.notification = Notification
local Components = executeModule(loadModule("ui/components.lua"), root.ui)
root.ui.components = Components
local Panel = executeModule(loadModule("ui/panel.lua"), root.ui)
root.ui.panel = Panel

local AntiAFK = executeModule(loadModule("features/antiafk.lua"), root.features)
root.features.antiafk = AntiAFK
local ESP = executeModule(loadModule("features/esp.lua"), root.features)
root.features.esp = ESP
local Jump = executeModule(loadModule("features/jump.lua"), root.features)
root.features.jump = Jump
local Movement = executeModule(loadModule("features/movement.lua"), root.features)
root.features.movement = Movement
local Camera = executeModule(loadModule("features/camera.lua"), root.features)
root.features.camera = Camera
local Teleport = executeModule(loadModule("features/teleport.lua"), root.features)
root.features.teleport = Teleport
local Spam = executeModule(loadModule("features/spam.lua"), root.features)
root.features.spam = Spam

root.ui.Parent = root
root.features.Parent = root
root.config.Parent = root
root.services.Parent = root
root.state.Parent = root
root.ui.notification.Parent = root.ui
root.ui.components.Parent = root.ui
root.ui.panel.Parent = root.ui
root.features.antiafk.Parent = root.features
root.features.esp.Parent = root.features
root.features.jump.Parent = root.features
root.features.movement.Parent = root.features
root.features.camera.Parent = root.features
root.features.teleport.Parent = root.features
root.features.spam.Parent = root.features

_G.__HOC_BOOTSTRAP = { root = root }

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
