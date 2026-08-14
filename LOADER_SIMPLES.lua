--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║  🔥 KChaos CKhaos Step v8.2 - GLASS EDITION 🔥              ║
    ║                 LOADER SIMPLIFICADO                         ║
    ║                                                               ║
    ║  Copie este código e cole em um Script Executor              ║
    ║  (como Synapse X, Script-Ware, etc)                         ║
    ║                                                               ║
    ║  ⚠️  NOTA: A forma mais simples é apenas:                   ║
    ║  loadstring(game:HttpGet("https://raw.githubusercontent     ║
    ║     .com/KHAOS-OC97/music_clan_rst/main/init.lua"))()       ║
    ║                                                               ║
    ║  Este arquivo também funciona!                              ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

print("═══════════════════════════════════════════════════════════")
print("  🔥 KChaos CKhaos Step v8.2 - Glass Edition              ")
print("═══════════════════════════════════════════════════════════")

-- Carregar init.lua do GitHub
local baseUrl = "https://raw.githubusercontent.com/KHAOS-OC97/music_clan_rst/main"
local url = baseUrl .. "/init.lua"

print("  📡 Conectando ao GitHub...")
local success, result = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    error("❌ Erro ao carregar do GitHub:\n" .. result)
end

print("  ✅ Arquivo baixado com sucesso!")
print("  🚀 Executando script...\n")

-- Executar o código carregado
local executeSuccess, executeError = pcall(function()
    loadstring(result)()
end)

if not executeSuccess then
    error("❌ Erro ao executar script:\n" .. executeError)
end

print("\n═══════════════════════════════════════════════════════════")
print("  🎮 Script Ativo! Pressione CTRL para mostrar painel     ")
print("═══════════════════════════════════════════════════════════")
