--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║        DIAGRAMA DA ARQUITETURA - Fluxo de Dados               ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

--[=[

┌─────────────────────────────────────────────────────────────────┐
│                         MAIN.LUA                                 │
│                    (Orquestrador Central)                        │
└──────────────┬──────────────────────────────────────────────────┘
               │
      ┌────────┴────────┐
      │                 │
      ▼                 ▼
  CONFIG.LUA        SERVICES.LUA
  (Valores)         (Referências)
      │                 │
      └────────┬────────┘
               │
               ▼
           STATE.LUA
    (Gerenciador de Estado)
      getgenv().HNkUI
               │
     ┌─────────┼─────────┐
     │         │         │
     ▼         ▼         ▼
   UI/      FEATURES/   FEATURES/
  PANEL      ANTIAFK     JUMP
     │
     ├─► COMPONENTS.lua
     │   (Toggles, Botões)
     │
     └─► NOTIFICATION.lua
         (Sistema de notificações)


┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO DE DADOS                                │
└─────────────────────────────────────────────────────────────────┘

1. INICIALIZAÇÃO:
   main.lua → Config:Init() → Services:Init() → State:Init()
            → Panel:Create() → Features:Init()

2. INTERAÇÃO DO USUÁRIO:
   Usuário clica Toggle
        ↓
   Components:CreateToggle() callback
        ↓
   State:Toggle("FeatureKey")
        ↓
   getgenv().HNkUI[FeatureKey] = true/false
        ↓
   Feature verifica State:Get() no loop
        ↓
   Feature executa ação

3. EXEMPLO - Ativar ESP:
   
   User clicks ESP Toggle
        │
        ▼
   Panel.CreateToggle() → mouseClick event
        │
        ▼
   State:Toggle("ESP") → getgenv().HNkUI.ESP = true
        │
        ▼
   ESP:Init() Heartbeat loop vê ESP = true
        │
        ▼
   Para cada jogador, cria BillboardGui
        │
        ▼
   Loop RGB atualiza cores constantemente
        │
        ▼
   Jogador sai → Players.PlayerRemoving
        │
        ▼
   ESP:Cleanup() remove BillboardGui


┌─────────────────────────────────────────────────────────────────┐
│              DEPENDÊNCIAS ENTRE MÓDULOS                          │
└─────────────────────────────────────────────────────────────────┘

main.lua (Nível 0 - Root)
    │
    ├── config.lua (Nível 1)
    │   └── Sem dependências
    │
    ├── services.lua (Nível 1)
    │   └── Sem dependências
    │
    ├── state.lua (Nível 1)
    │   └── Depende: config.lua
    │
    ├── ui/panel.lua (Nível 2)
    │   └── Depende: config.lua, services.lua
    │
    ├── ui/components.lua (Nível 2)
    │   └── Depende: config.lua, state.lua, services.lua
    │
    ├── ui/notification.lua (Nível 2)
    │   └── Depende: config.lua, services.lua
    │
    ├── features/antiafk.lua (Nível 2)
    │   └── Depende: services.lua, state.lua
    │
    ├── features/esp.lua (Nível 2)
    │   └── Depende: config.lua, services.lua, state.lua
    │
    ├── features/jump.lua (Nível 2)
    │   └── Depende: services.lua, state.lua
    │
    ├── features/movement.lua (Nível 2)
    │   └── Depende: config.lua, services.lua, state.lua
    │
    ├── features/camera.lua (Nível 2)
    │   └── Depende: config.lua, services.lua, state.lua
    │
    └── features/teleport.lua (Nível 2)
        └── Depende: config.lua, services.lua, notification.lua


┌─────────────────────────────────────────────────────────────────┐
│                ESTRUTURA DO ESTADO GLOBAL                        │
└─────────────────────────────────────────────────────────────────┘

getgenv().HNkUI = {
    -- Features (toggleáveis)
    AntiAFK = boolean,      ← Controla anti-AFK
    ESP = boolean,          ← Controla ESP
    God = boolean,          ← Controla God Mode
    Jump = boolean,         ← Controla Salto Infinito
    
    -- Valores Numéricos (configuráveis)
    WalkSpeed = number,     ← Velocidade de movimento (0-100)
    FOV = number,           ← Campo de visão (70, 90, 120)
}

Acesso:
    State:Get("ESP")                    → Retorna valor
    State:Set("WalkSpeed", 25)          → Altera valor
    State:Toggle("Jump")                → Alterna boolean
    State:GetAll()                      → Retorna todo o objeto


┌─────────────────────────────────────────────────────────────────┐
│                 CICLO DE VIDA DOS LOOPS                          │
└─────────────────────────────────────────────────────────────────┘

RunService.Heartbeat (60 vezes por segundo):
    ├── ESP:Cycle Colors
    ├── ESP:Update BillboardGuis
    ├── Movement:Update WalkSpeed
    ├── Movement:Apply God Mode
    └── Camera:Sync FOV

RunService.RenderStepped (Antes de renderizar):
    └── Panel:RGB Loop (animar cores da borda)

UserInputService.JumpRequest:
    └── Jump:OnJump (se habilitado)

UserInputService.InputBegan:
    └── Panel:OnKeyPress (CTRL para toggle interface)

Players.PlayerRemoving:
    └── ESP:Cleanup (remover BillboardGui)

LocalPlayer.Idled:
    └── AntiAFK:OnIdle (se habilitado)


┌─────────────────────────────────────────────────────────────────┐
│                   PRIORIDADE DE EXECUÇÃO                         │
└─────────────────────────────────────────────────────────────────┘

0. Config - Carregado primeiro (valores estáticos)
1. Services - Referências ao Roblox
2. State - Inicializa getgenv()
3. UI Modules - Criam interface visual
4. Features - Iniciam loops e conectam eventos

Isso garante que quando uma feature tenta acessar State ou Services,
eles já estão prontos.


┌─────────────────────────────────────────────────────────────────┐
│                    COMO ADICIONAR FEATURE                        │
└─────────────────────────────────────────────────────────────────┘

1. Criar: features/minha_feature.lua
   └── Depender apenas de: config, services, state, notification

2. Editar: config.lua
   └── Adicionar Config.Features.MinhaFeature

3. Editar: main.lua
   └── Require do novo módulo
   └── Chamar MinhaFeature:Init()

4. Panel automaticamente pega novos toggles!
   └── Panel:AddToggles() itera Config.Features


┌─────────────────────────────────────────────────────────────────┐
│                      PADRÕES DE CÓDIGO                           │
└─────────────────────────────────────────────────────────────────┘

Sempre use pcall() para proteção:
    pcall(function()
        -- código que pode falhar
    end)

Sempre verifique existência:
    if Services.LocalPlayer.Character and 
       Services.LocalPlayer.Character:FindFirstChild("Head") then
        -- seguro usar Character.Head
    end

Sempre use State Manager:
    State:Get("FeatureKey")  ← certo
    getgenv().HNkUI.FeatureKey  ← ainda funciona, mas não é ideal

Sempre limpe recursos:
    Services.Players.PlayerRemoving:Connect(function(plr)
        if billboard then billboard:Destroy() end
    end)

]=]

print("📐 Para visualizar esta arquitetura, abra este arquivo em um editor de texto.")
