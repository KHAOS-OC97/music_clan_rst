--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║          MAIN.LUA - Orquestrador Principal do Script          ║
    ║     Inicializa todos os módulos em ordem apropriada          ║
    ║                                                               ║
    ║        KChaos CKhaos Step v8.2 - Glass Edition               ║
    ║                 Arquitetura Modular                          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

-- ==================== CARREGAMENTO DE MÓDULOS ====================
local script_root = script and script.Parent or (_G.__HOC_BOOTSTRAP and _G.__HOC_BOOTSTRAP.root)

if not script_root then
    error("❌ Contexto de script inválido. Use init.lua ou um loader que defina a hierarquia do módulo.")
end

local Config = require(script_root:WaitForChild("config"))
local State = require(script_root:WaitForChild("state"))
local Services = require(script_root:WaitForChild("services"))

-- UI Modules
local Panel = require(script_root.ui:WaitForChild("panel"))
local Notification = require(script_root.ui:WaitForChild("notification"))

-- Feature Modules
local AntiAFK = require(script_root.features:WaitForChild("antiafk"))
local ESP = require(script_root.features:WaitForChild("esp"))
local Jump = require(script_root.features:WaitForChild("jump"))
local Movement = require(script_root.features:WaitForChild("movement"))
local Camera = require(script_root.features:WaitForChild("camera"))
local Teleport = require(script_root.features:WaitForChild("teleport"))
local Spam = require(script_root.features:WaitForChild("spam"))

-- ==================== INICIALIZAÇÃO PRINCIPAL ====================
local function Init()
    print("╔════════════════════════════════════════════════════════════╗")
    print("║  ".. Config.Script.Name .. " v" .. Config.Script.Version .."  ║")
    print("║                  " .. Config.Script.Edition .. "        ║")
    print("╚════════════════════════════════════════════════════════════╝")
    
    -- Inicializar variáveis globais
    _G_Running = true
    _G_ESP = false
    _G_Spam = false
    
    -- Criar contexto para features que precisam
    local ctx = {
        Services = Services,
        State = State,
    }
    
    -- 1. Inicializar Estado
    print("✓ Inicializando Estado Global...")
    State:Init()
    
    -- 2. Criar Painel UI
    print("✓ Construindo Interface...")
    Panel:Create()
    Panel:AddToggles()
    Panel:AddSpamControl(function(cadencia)
        State:Set("SpamCadencia", cadencia)
    end)
    
    -- 3. Adicionar callbacks dos botões
    Panel:AddButtons(
        function()
            -- FOV Button Callback
            local newFOV = Camera:CycleFOV()
            Panel.FOVButton.Text = "DRONE VIEW (FOV): " .. newFOV
            Notification:Show("FOV alterado para: " .. newFOV, true)
        end,
        function()
            -- Teleport Button Callback
            Teleport:ToAlly()
        end
    )
    
    -- 4. Iniciar loops
    print("✓ Iniciando loops de animação...")
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
    
    -- 5. Inicializar Features
    print("✓ Ativando Features...")
    AntiAFK:Init()
    ESP:Init(ctx)
    Jump:Init()
    Movement:Init()
    Camera:Init()
    Spam:Init(ctx)
    
    print("✓ Script carregado com sucesso!")
    print("  • Pressione CTRL para toggle da interface")
    print("  • Todos os features estão prontos")
    
    Notification:Show("SCRIPT ATIVADO", true)
end

-- ==================== EXECUTAR ====================
pcall(Init)
