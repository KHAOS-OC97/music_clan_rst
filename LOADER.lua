--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║  🔥 KChaos CKhaos Step v8.2 - GLASS EDITION 🔥              ║
    ║                 LOADER EXECUTÁVEL                           ║
    ║                                                               ║
    ║  Copie este código e cole em um Script Executor              ║
    ║  (como Synapse X, Script-Ware, etc)                         ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    📦 OPÇÃO 1: LOADER LOCAL (Se tiver os arquivos em ReplicatedStorage)
    📡 OPÇÃO 2: LOADER HTTP (Carrega direto do GitHub)
    
    Escolha uma das opções abaixo ⬇️
]]

--[[
    ═══════════════════════════════════════════════════════════════
    OPÇÃO 1: LOADER LOCAL (Recomendado para desenvolvimento)
    ═══════════════════════════════════════════════════════════════
    
    Use esta opção se:
    • Você tiver copiado a pasta music_clan_rst para ReplicatedStorage
    • Quiser executar localmente
    
    Estrutura esperada:
    ReplicatedStorage/
    └── KChaosStep/
        ├── main.lua
        ├── config.lua
        ├── services.lua
        ├── state.lua
        ├── ui/
        └── features/
]]

-- OPÇÃO 1: Loader Local
local function LoaderLocal()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local root = ReplicatedStorage:WaitForChild("KChaosStep", 5)
    
    if not root then
        error("❌ Pasta KChaosStep não encontrada em ReplicatedStorage!")
        return
    end
    
    -- Carregar main.lua
    local main = require(root:WaitForChild("main", 5))
    print("✅ Script carregado com sucesso!")
end

--[[
    ═══════════════════════════════════════════════════════════════
    OPÇÃO 2: LOADER HTTP (Recomendado para uso direto)
    ═══════════════════════════════════════════════════════════════
    
    Use esta opção se:
    • Quiser carregar direto do GitHub
    • Não quiser configurar ReplicatedStorage
    
    ⚠️ Substitua YOUR_RAW_URL pela URL correta do seu repositório
]]

-- OPÇÃO 2: Loader HTTP
local function LoaderHTTP(baseUrl)
    baseUrl = baseUrl or "https://raw.githubusercontent.com/KHAOS-OC97/music_clan_rst/main"
    
    print("📡 Carregando init.lua do GitHub...")
    
    local url = baseUrl .. "/init.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("❌ Erro ao carregar init.lua: " .. result)
    end
    
    print("✅ Arquivo carregado! Executando...")
    loadstring(result)()
end

--[[
    ═══════════════════════════════════════════════════════════════
    INSTRUÇÕES DE USO
    ═══════════════════════════════════════════════════════════════
    
    Para usar OPÇÃO 1 (Local):
    ├─ Descomente a linha abaixo
    └─ LoaderLocal()
    
    Para usar OPÇÃO 2 (HTTP):
    ├─ Descomente a linha abaixo
    └─ LoaderHTTP()
    
    OU se tiver URL customizada:
    └─ LoaderHTTP("https://seu-servidor.com/KChaosStep")
]]

-- ═══════════════════════════════════════════════════════════════
-- 🎯 ESCOLHA SUA OPÇÃO E DESCOMENTE:
-- ═══════════════════════════════════════════════════════════════

-- Opção 1: Loader Local (descomente se tiver arquivos em ReplicatedStorage)
-- LoaderLocal()

-- Opção 2: Loader HTTP (descomente para carregar do GitHub)
LoaderHTTP()

-- Opção 2 com URL customizada (se tiver servidor próprio)
-- LoaderHTTP("https://raw.githubusercontent.com/KHAOS-OC97/music_clan_rst/main")

print("╔════════════════════════════════════════════════════════════╗")
print("║  ✅ KChaos CKhaos Step v8.2 - Pronto para usar!           ║")
print("║                                                            ║")
print("║  🎮 Controles:                                             ║")
print("║     • CTRL: Mostrar/Esconder painel                        ║")
print("║     • Clique nos toggles para ativar/desativar features   ║")
print("║                                                            ║")
print("╚════════════════════════════════════════════════════════════╝")
