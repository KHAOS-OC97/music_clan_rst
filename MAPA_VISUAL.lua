--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     MAPA VISUAL - Arquitetura Modular em ASCII                ║
    ║              KChaos CKhaos Step v8.2                          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

--[=[

┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│            📱 INTERFACE VISUAL DO SCRIPT (no Roblox)             │
│                                                                   │
│  ┌─────────────────────────────┐                                 │
│  │ 🇧🇷 KChaos CKhaos Step 🇺🇸  │ ← Panel (Glass Effect)         │
│  ├─────────────────────────────┤                                 │
│  │ 🔘 ANTI-AFK MARINES      [O]│ ← Toggle                        │
│  │ 🔘 ESP VISION            [O]│                                 │
│  │ 🔘 GOD MODE              [O]│                                 │
│  │ 🔘 INFINITE JUMP         [O]│                                 │
│  ├─────────────────────────────┤                                 │
│  │ 📡 DRONE VIEW (FOV): 70 [RGB]│ ← Botão RGB                    │
│  │ 🚀 EXTRAÇÃO ELITE (TP)  [RGB]│                                 │
│  └─────────────────────────────┘                                 │
│         ↑ RGB Loop (cores animadas)                              │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                      🗂️ ESTRUTURA DE PASTAS                       │
└─────────────────────────────────────────────────────────────────┘

music_clan_rst/
│
├─── 🔴 CORE (Carregados sempre)
│    ├── main.lua ........................... Orquestrador
│    ├── config.lua ......................... Configurações
│    ├── services.lua ....................... Serviços
│    └── state.lua .......................... Estado
│
├─── 🟢 UI (Interface)
│    └── ui/
│        ├── panel.lua ...................... Painel principal
│        ├── components.lua ................. Componentes
│        └── notification.lua ............... Notificações
│
├─── 🔵 FEATURES (Funcionalidades)
│    └── features/
│        ├── antiafk.lua ................... Anti-AFK
│        ├── esp.lua ....................... ESP
│        ├── jump.lua ...................... Jump
│        ├── movement.lua .................. Movimento
│        ├── camera.lua .................... Câmera
│        └── teleport.lua .................. TP
│
└─── 📚 DOCS (Documentação)
     ├── README.md .......................... Visão geral
     ├── ARQUITETURA.md ..................... Guia completo
     ├── DIAGRAMA_ARQUITETURA.lua .......... Fluxo
     ├── QUICKSTART.lua .................... Como usar
     ├── EXEMPLO_NOVA_FEATURE.lua .......... Tutorial
     ├── INDICE.md .......................... Mapa
     ├── VALIDACAO.lua ..................... Testes
     ├── SUMARIO_EXECUTIVO.lua ............ Resumo
     └── MAPA_VISUAL.lua ................... Este arquivo


┌─────────────────────────────────────────────────────────────────┐
│                  📊 FLUXO DE INICIALIZAÇÃO                        │
└─────────────────────────────────────────────────────────────────┘

    Usuário executa main.lua
              │
              ▼
    ┌─────────────────────┐
    │ Carregar Config     │ ← Valores padrão
    └──────────┬──────────┘
               │
               ▼
    ┌─────────────────────┐
    │ Carregar Services   │ ← Referências Roblox
    └──────────┬──────────┘
               │
               ▼
    ┌─────────────────────┐
    │ Carregar State      │ ← getgenv().HNkUI
    └──────────┬──────────┘
               │
               ▼
    ┌─────────────────────┐
    │ Criar UI Modules    │ ← Panel, Components, Notification
    └──────────┬──────────┘
               │
               ▼
    ┌─────────────────────┐
    │ Inicializar Features│ ← AntiAFK, ESP, Jump, Movement, Camera, Teleport
    └──────────┬──────────┘
               │
               ▼
    ✅ Script Pronto! (getenv().HNkUI preenchido)


┌─────────────────────────────────────────────────────────────────┐
│              🔄 FLUXO: Usuário Clica Toggle                      │
└─────────────────────────────────────────────────────────────────┘

    Usuário clica "ESP VISION" 
              │
              ▼
    Components:CreateToggle() ← Escuta MouseButton1Click
              │
              ▼
    State:Toggle("ESP") ← Alterna getgenv().HNkUI.ESP = false → true
              │
              ▼
    Animar knob (esquerda → direita)
              │
              ▼
    Animar cor (vermelho → verde)
              │
              ▼
    Executar callback personalizado
              │
              ▼
    ESP:Init() vê ESP = true no Heartbeat
              │
              ▼
    Para cada jogador, criar BillboardGui
              │
              ▼
    ✅ Nomes aparecem na tela com RGB


┌─────────────────────────────────────────────────────────────────┐
│                   🎨 DEPENDÊNCIAS VISUAIS                         │
└─────────────────────────────────────────────────────────────────┘

                           main.lua
                              │
                    ┌─────────┼─────────┐
                    │         │         │
                    ▼         ▼         ▼
                  config   services    state
                    │         │         │
                    │    ┌────┴─────┬──┘
                    │    │          │
                    ▼    ▼          ▼
                   panel   components   notification
                    │         │           │
                    └─────┬───┴───────┬───┘
                          │           │
                          ▼           ▼
                      features    (callbacks)
                    (6 modules)
                    │ │ │ │ │ │
                    └─┼─┼─┼─┼─┘
                      ▼ ▼ ▼ ▼ ▼ ▼
                   RunService Events
                   (Heartbeat, etc)


┌─────────────────────────────────────────────────────────────────┐
│                   🔀 ESTADO GLOBAL COMPARTILHADO                  │
└─────────────────────────────────────────────────────────────────┘

                    State Manager
                   State:Init()
                        │
        getgenv().HNkUI = {
            AntiAFK = false     ← Feature antiafk.lua lê aqui
            ESP = false         ← Feature esp.lua lê aqui
            God = false         ← Feature movement.lua lê aqui
            Jump = false        ← Feature jump.lua lê aqui
            WalkSpeed = 16      ← Feature movement.lua lê aqui
            FOV = 70            ← Feature camera.lua lê aqui
        }


┌─────────────────────────────────────────────────────────────────┐
│                   ⏱️ LOOPS E EVENTOS ATIVOS                        │
└─────────────────────────────────────────────────────────────────┘

RunService.Heartbeat (60x/sec)
    ├── ESP:Cycle Colors
    ├── ESP:Update BillboardGuis
    ├── Movement:Update WalkSpeed
    ├── Movement:Apply God Mode
    └── Camera:Sync FOV

RunService.RenderStepped (antes de render)
    └── Panel:RGB Loop (animar cores)

UserInputService.JumpRequest
    └── Jump:OnJump (se habilitado)

UserInputService.InputBegan
    └── Panel:OnKeyPress (CTRL toggle)

Players.PlayerRemoving
    └── ESP:Cleanup

LocalPlayer.Idled
    └── AntiAFK:OnIdle (se habilitado)


┌─────────────────────────────────────────────────────────────────┐
│                   🎯 COMO CADA FEATURE FUNCIONA                  │
└─────────────────────────────────────────────────────────────────┘

ANTIAFK.LUA
    LocalPlayer.Idled (evento)
         ↓
    Verificar State:Get("AntiAFK")
         ↓
    Se TRUE: Simular clique com VirtualUser
         ↓
    ✅ Não toma kick

ESP.LUA
    RunService.Heartbeat (loop)
         ↓
    Verificar State:Get("ESP")
         ↓
    Se FALSE: Limpar billboards
    Se TRUE: Para cada player criar/atualizar billboard
         ↓
    RGB Loop atualiza cores
         ↓
    ✅ Nomes com RGB aparecem

JUMP.LUA
    UserInputService.JumpRequest (evento)
         ↓
    Verificar State:Get("Jump")
         ↓
    Se TRUE: humanoid:ChangeState(Jumping)
         ↓
    ✅ Pula infinitamente

MOVEMENT.LUA
    RunService.Heartbeat (loop)
         ↓
    Aplicar humanoid.WalkSpeed = State:Get("WalkSpeed")
         ↓
    Se State:Get("God"): Recuperar HP continuamente
         ↓
    ✅ Velocidade e imortalidade

CAMERA.LUA
    RunService.Heartbeat (loop)
         ↓
    Sincronizar camera.FieldOfView = State:Get("FOV")
         ↓
    Buttons cicla através de presets (70 → 90 → 120)
         ↓
    ✅ FOV muda dinamicamente

TELEPORT.LUA
    Botão TP clicado
         ↓
    Procurar jogadores aliados
         ↓
    Se encontrado: Teleportar com offset
         ↓
    Notificação de sucesso/erro
         ↓
    ✅ Teleportado


┌─────────────────────────────────────────────────────────────────┐
│                   🔧 COMO ESTENDER                               │
└─────────────────────────────────────────────────────────────────┘

Passo 1: Criar novo módulo
    features/minha_feature.lua
         ├── require(state)
         ├── require(services)
         └── function MyFeature:Init()

Passo 2: Adicionar config
    config.lua
         └── Config.Features.MinhaFeature = {...}

Passo 3: Importar em main
    main.lua
         ├── local MyFeature = require(...)
         └── MyFeature:Init()

Pronto! ✅
    • Toggle aparece automaticamente
    • Funciona com State Manager
    • Integrado com UI


┌─────────────────────────────────────────────────────────────────┐
│                   ✅ CHECKLIST VISUAL                             │
└─────────────────────────────────────────────────────────────────┘

Setup:
    [✅] 10 módulos de código criados
    [✅] 6 features implementadas
    [✅] UI completa com Glass Effect
    [✅] State Manager centralizado
    [✅] Componentes reutilizáveis

Documentação:
    [✅] README.md (visão geral)
    [✅] ARQUITETURA.md (guia detalhado)
    [✅] DIAGRAMA_ARQUITETURA.lua (fluxo)
    [✅] QUICKSTART.lua (como usar)
    [✅] EXEMPLO_NOVA_FEATURE.lua (tutorial)
    [✅] INDICE.md (navegação)
    [✅] VALIDACAO.lua (testes)
    [✅] SUMARIO_EXECUTIVO.lua (resumo)
    [✅] MAPA_VISUAL.lua (este arquivo)

Funcionalidade:
    [✅] UI renderiza sem erros
    [✅] Toggles funcionam
    [✅] Features se ativam/desativam
    [✅] RGB Loop anima
    [✅] Notificações aparecem
    [✅] Estado persiste
    [✅] Código é limpo e documentado


]=]

print("📐 Mapa Visual da Arquitetura - Pronto!")
print("Consulte este arquivo para entender a estrutura visual")
