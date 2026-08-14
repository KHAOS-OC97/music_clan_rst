## 🎭 KChaos CKhaos Step v8.2 - Arquitetura Modular

Um script Roblox completamente refatorado em **Arquitetura Modular**, com separação clara de responsabilidades, fácil manutenção e extensibilidade.

---

## 📁 Estrutura do Projeto

```
📦 music_clan_rst/
│
├── 📄 main.lua              ← PONTO DE ENTRADA (importar este arquivo)
├── 📄 config.lua            ← Configurações centralizadas
├── 📄 services.lua          ← Serviços Roblox centralizados
├── 📄 state.lua             ← Gerenciador de estado global
│
├── 📁 ui/                   ← Módulos de Interface
│   ├── 📄 panel.lua         ← Painel principal
│   ├── 📄 components.lua    ← Componentes reutilizáveis (toggles, botões)
│   └── 📄 notification.lua  ← Sistema de notificações
│
└── 📁 features/             ← Módulos de Funcionalidades
    ├── 📄 antiafk.lua       ← Anti-AFK
    ├── 📄 esp.lua           ← ESP (visualização)
    ├── 📄 jump.lua          ← Salto infinito
    ├── 📄 movement.lua      ← Movimento (WalkSpeed, God Mode)
    ├── 📄 camera.lua        ← Câmera (FOV)
    └── 📄 teleport.lua      ← Teleporte para aliados
```

---

## 🚀 Como Usar

### **1. Copiar os arquivos**
Copie toda a pasta `music_clan_rst/` para seu explorador de scripts.

### **2. Executar o Script**
```lua
require(game:GetObjects("rbxassetid://YOUR_ASSET_ID")[1].main)
```

Ou simplesmente:
```lua
loadstring(game:HttpGet("https://seu-servidor/main.lua"))()
```

---

## 📚 Documentação por Módulo

### **config.lua**
Centraliza todas as configurações do script em um único lugar.

**O que contém:**
- Cores predefinidas
- Configurações de UI (tamanhos, posições)
- Estado padrão das features
- Valores de movimento/câmera
- Configurações de animação

**Como usar:**
```lua
local Config = require(script.Parent:WaitForChild("config"))
print(Config.Features.Jump.Label) -- "INFINITE JUMP"
print(Config.Movement.DefaultWalkSpeed) -- 16
```

---

### **services.lua**
Referências centralizadas de todos os serviços Roblox.

**O que contém:**
- Referências a serviços (Players, RunService, etc)
- Funções auxiliares para obter character/humanoid
- Listeners para atualizar referências

**Benefício:**
- Evita repetição de `game:GetService()`
- Mantém referencias sempre atualizadas
- Fácil debug

**Como usar:**
```lua
local Services = require(script.Parent:WaitForChild("services"))
Services.LocalPlayer.Character  -- Acesso rápido
Services:GetHumanoid()          -- Função auxiliar
```

---

### **state.lua**
Gerenciador centralizado do estado global (`getgenv().HNkUI`).

**O que faz:**
- Inicializa estado com valores padrão
- Fornece getters/setters seguros
- Método `Toggle()` para ativar/desativar features

**Como usar:**
```lua
local State = require(script.Parent:WaitForChild("state"))
State:Init()                        -- Inicializar
State:Get("Jump")                   -- Obter valor
State:Set("WalkSpeed", 25)          -- Alterar valor
State:Toggle("ESP")                 -- Ativar/desativar
```

---

### **ui/panel.lua**
Construtor do painel principal (interface gráfica).

**Responsabilidades:**
- Criar ScreenGui com efeito vidro
- Adicionar título e toggles
- Adicionar botões RGB
- Loop de cores RGB
- Toggle de visibilidade (CTRL)

**Métodos principais:**
```lua
Panel:Create()                      -- Criar painel
Panel:AddToggles()                  -- Adicionar toggles
Panel:AddButtons(fovCb, tpCb)       -- Adicionar botões com callbacks
Panel:StartRGBLoop()                -- Iniciar animação RGB
Panel:SetupVisibilityToggle()       -- CTRL para mostrar/esconder
```

---

### **ui/components.lua**
Componentes reutilizáveis da interface.

**Componentes disponíveis:**
- `CreateToggle()` - Botão ON/OFF com animação
- `CreateRGBButton()` - Botão com borda RGB dinâmica

**Como usar:**
```lua
local Components = require(script.Parent:WaitForChild("components"))

-- Criar um toggle
local toggle = Components:CreateToggle(
    parent,           -- Frame pai
    "Meu Toggle",     -- Texto do label
    0.2,              -- Posição Y relativa
    "MyKey",          -- Chave no state
    function(state)   -- Callback quando toggled
        print("Novo estado:", state)
    end
)
```

---

### **ui/notification.lua**
Sistema de notificações elegante com cores dinâmicas.

**Como usar:**
```lua
local Notification = require(script.Parent:WaitForChild("notification"))

-- Notificação de sucesso
Notification:Show("Feature ativada!", true)

-- Notificação de erro
Notification:Show("Erro ao ativar", false)
```

---

### **features/antiafk.lua**
Anti-AFK usando VirtualUser.

**Conectado ao:**
- `PlayerIdled` signal
- State: `getgenv().HNkUI.AntiAFK`

---

### **features/esp.lua**
Visualização de jogadores com nomes em RGB.

**Características:**
- BillboardGui acima da cabeça
- Cores RGB sincronizadas
- Auto-cleanup quando jogador sai

**Connected to:**
- `RunService.Heartbeat` para update
- State: `getgenv().HNkUI.ESP`

---

### **features/jump.lua**
Salto infinito com toggle.

**Connected to:**
- `UserInputService.JumpRequest`
- State: `getgenv().HNkUI.Jump`

---

### **features/movement.lua**
Controla WalkSpeed e God Mode.

**Features:**
- Sincroniza WalkSpeed com state
- God Mode recupera HP constantemente

**Connected to:**
- `RunService.Heartbeat`
- State: `getgenv().HNkUI.WalkSpeed`, `getgenv().HNkUI.God`

---

### **features/camera.lua**
Controle de campo de visão (FOV).

**Presets:** 70 → 90 → 120 → 70 (ciclando)

**Métodos:**
```lua
Camera:Init()           -- Sincronizar FOV continuamente
Camera:CycleFOV()       -- Mudar para próximo FOV
```

---

### **features/teleport.lua**
Teleporte para jogadores aliados.

**Funcionalidade:**
- Procura aliados na lista de config
- Teleporta com offset configurável
- Notificação de sucesso/erro

---

### **main.lua**
Orquestrador principal - inicializa tudo na ordem correta.

**O que faz:**
1. Carrega todos os módulos
2. Inicializa estado
3. Cria interface
4. Conecta callbacks
5. Inicia features

---

## ⚙️ Como Adicionar Novas Features

### **Passo 1:** Criar novo arquivo em `features/`
```lua
-- features/minha_feature.lua
local Services = require(script.Parent.Parent:WaitForChild("services"))
local State = require(script.Parent.Parent:WaitForChild("state"))

local MinhaFeature = {}

function MinhaFeature:Init()
    Services.RunService.Heartbeat:Connect(function()
        if not State:Get("MinhaFeature") then return end
        -- Sua lógica aqui
    end)
end

return MinhaFeature
```

### **Passo 2:** Adicionar config em `config.lua`
```lua
Config.Features.MinhaFeature = {
    Enabled = false,
    Label = "MINHA FEATURE",
    Key = "MinhaFeature",
}
```

### **Passo 3:** Adicionar em `main.lua`
```lua
local MinhaFeature = require(script_root.features:WaitForChild("minha_feature"))

-- Em Init():
MinhaFeature:Init()
Panel:AddToggles() -- Já pega automaticamente
```

---

## 🎨 Customização de Cores

Edite `config.lua`:

```lua
Config.Colors = {
    White = Color3.new(1, 1, 1),
    Red = Color3.fromRGB(255, 60, 60),
    -- Suas cores aqui
}
```

---

## 🔧 Troubleshooting

### **"WaitForChild timeout"**
- Verifique que a estrutura de pastas está correta
- Certifique-se de que todos os arquivos existem

### **Features não funcionam**
- Verifique se `State:Init()` foi chamado
- Confirme que a feature está conectada ao state correto

### **UI não aparece**
- Verifique se `Panel:Create()` foi chamado
- Confirme que `CoreGui` não foi bloqueado

---

## 📝 Notas Importantes

✅ **Vantagens da Arquitetura Modular:**
- **Fácil Manutenção:** Cada módulo tem uma responsabilidade única
- **Reutilizável:** Components podem ser usados em múltiplos lugares
- **Escalável:** Adicionar novas features é simples
- **Testável:** Cada módulo pode ser testado isoladamente
- **Limpo:** Código organizado e documentado

⚠️ **Boas Práticas:**
- Sempre use `pcall()` para operações que podem falhar
- Mantenha referências de serviços centralizadas
- Use o state manager para todas as variáveis globais
- Documente novas features no README

---

## 📄 Licença

Esse script é fornecido como está. Sinta-se livre para usar e modificar.

---

**Desenvolvido com ❤️ por KChaos**
