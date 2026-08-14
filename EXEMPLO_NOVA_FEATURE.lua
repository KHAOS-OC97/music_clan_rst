--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     EXEMPLO: Como Adicionar uma Nova Feature                 ║
    ║            Passo a Passo Completo                             ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

--[=[
    CENÁRIO: Queremos adicionar uma feature de "Speed Boost"
    que aumenta a velocidade temporariamente quando ativado.

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    PASSO 1: Criar o arquivo features/speedboost.lua
]=]

--[[
-- features/speedboost.lua
local Config = require(script.Parent.Parent:WaitForChild("config"))
local Services = require(script.Parent.Parent:WaitForChild("services"))
local State = require(script.Parent.Parent:WaitForChild("state"))

local SpeedBoost = {}

-- Velocidade de boost
SpeedBoost.BoostMultiplier = 1.5

function SpeedBoost:Init()
    Services.RunService.Heartbeat:Connect(function()
        if not State:Get("SpeedBoost") then return end
        
        pcall(function()
            if Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = Services.LocalPlayer.Character:FindFirstChild("Humanoid")
                -- Aplicar multiplicador de velocidade
                humanoid.WalkSpeed = (State:Get("WalkSpeed") or Config.Movement.DefaultWalkSpeed) * self.BoostMultiplier
            end
        end)
    end)
end

return SpeedBoost
]]

--[=[
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    PASSO 2: Adicionar a configuração em config.lua

    Procure por:
    Config.Features = {
        AntiAFK = { ... },
        ESP = { ... },
        ...
    }

    E adicione:
]=]

--[[
Config.Features.SpeedBoost = {
    Enabled = false,
    Label = "⚡ SPEED BOOST",
    Key = "SpeedBoost",
}
]]

--[=[
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    PASSO 3: Importar e inicializar em main.lua

    Procure por:
    local Jump = require(script_root.features:WaitForChild("jump"))
    local Movement = require(script_root.features:WaitForChild("movement"))

    E adicione:
]=]

--[[
local SpeedBoost = require(script_root.features:WaitForChild("speedboost"))
]]

--[=[
    Depois procure por:
    print("✓ Ativando Features...")
    AntiAFK:Init()
    ESP:Init()
    Jump:Init()
    Movement:Init()
    Camera:Init()

    E adicione:
]=]

--[[
    SpeedBoost:Init()
]]

--[=[
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    ✅ PRONTO! Agora a feature será:
       • Adicionada automaticamente ao painel
       • Controlada pelo toggle
       • Sincronizada com o estado global

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=]

--[=[
    EXEMPLO AVANÇADO: Feature com Callback Customizado

    Se você quer executar uma ação quando a feature é ativada/desativada,
    modifique o toggle em Panel:AddToggles() em panel.lua:
]=]

--[[
-- Em panel.lua, dentro de AddToggles():

local callback = function(state)
    if toggleCfg.key == "SpeedBoost" then
        local msg = state and "⚡ BOOST: ATIVO" or "⚠️ BOOST: INATIVO"
        Notification:Show(msg, state)
    end
end

Components:CreateToggle(self.MainFrame, toggleCfg.label, yOffset, toggleCfg.key, callback)
]]

--[=[
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    DICAS IMPORTANTES:

    ✓ Use pcall() para operações que podem falhar
    ✓ Sempre verifique se character existe antes de acessar
    ✓ Mantenha features independentes umas das outras
    ✓ Use o State Manager para salvar/recuperar valores
    ✓ Documente seu código com comentários

    ✗ NÃO use variáveis globais - use State Manager
    ✗ NÃO acesse Services diretamente - importe o módulo
    ✗ NÃO repita código - crie componentes reutilizáveis

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=]

print("📖 Consulte ARQUITETURA.md para mais informações!")
