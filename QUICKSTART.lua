--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║          QUICK START - Como Executar o Script                ║
    ║     Coloque este código em um LocalScript no CoreGui          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

--[=[
    OPÇÃO 1: Se você tiver os arquivos em ReplicatedStorage
    
    Crie a estrutura em ReplicatedStorage:
    📁 ReplicatedStorage/
       └── 📁 KChaosStep/
           ├── 📄 main.lua
           ├── 📄 config.lua
           ├── 📄 services.lua
           ├── 📄 state.lua
           ├── 📁 ui/
           │   ├── 📄 panel.lua
           │   ├── 📄 components.lua
           │   └── 📄 notification.lua
           └── 📁 features/
               ├── 📄 antiafk.lua
               ├── 📄 esp.lua
               ├── 📄 jump.lua
               ├── 📄 movement.lua
               ├── 📄 camera.lua
               └── 📄 teleport.lua
    
    Depois execute:
]=]

-- Versão ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KChaosStep = ReplicatedStorage:WaitForChild("KChaosStep")
local main = require(KChaosStep:WaitForChild("main"))

--[=[
    OPÇÃO 2: Se você quiser carregar via HTTP (servidor remoto)
    
    Mude os nomes dos arquivos para um padrão HTTP-friendly
    e hospede-os em um servidor.
]=]

-- Versão HTTP (descomente se usar essa opção)
--[[
local function loadModule(moduleName)
    local url = "https://seu-servidor.com/KChaosStep/" .. moduleName .. ".lua"
    return loadstring(game:HttpGet(url))()
end

local config = loadModule("config")
local services = loadModule("services")
-- ... carregar todos os módulos e executar
]]

--[=[
    OPÇÃO 3: Script em linha (one-liner) - Não recomendado
    
    Se você absolutamente precisa de uma única linha,
    você pode minificar o código, mas isso não é recomendado
    para manutenção.
]=]

-- Para minificar, use ferramentas como:
-- - https://beautifier.io/ (remover comentários)
-- - https://www.minifier.org/ (minificação)

print("✓ Script KChaos Step carregado com sucesso!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📌 CONTROLES:")
print("  • CTRL: Toggle da interface")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
