# 🚀 COMO USAR O EXECUTÁVEL

## ✅ Quick Start (30 segundos)

### Opção 1: Carregar do GitHub (MAIS FÁCIL)

1. **Abra seu Script Executor** (Synapse X, Script-Ware, etc)
2. **Copie e cole este código:**

```lua
LoaderHTTP = function(baseUrl)
    baseUrl = baseUrl or "https://raw.githubusercontent.com/KHAOS-OC97/music_clan_rst/main"
    local function loadModule(path)
        local url = baseUrl .. "/" .. path
        local success, result = pcall(function() return game:HttpGet(url) end)
        if not success then error("❌ Erro: " .. result) end
        return result
    end
    
    loadstring(loadModule("main.lua"))()
end

LoaderHTTP()
```

3. **Pressione Execute/Inject**
4. **Pronto! 🎉**

---

## 📁 Opção 2: Usar Arquivos Locais

### Passo 1: Copiar Arquivos

1. Copie a pasta `music_clan_rst` completa
2. Cole em `ReplicatedStorage` no Roblox Studio
3. Renomeie para `KChaosStep` (opcional)

### Passo 2: Usar Loader Local

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local root = ReplicatedStorage:WaitForChild("KChaosStep")
require(root:WaitForChild("main"))
```

---

## 🎮 Depois de Carregar

### Controles:
| Ação | Resultado |
|------|-----------|
| **CTRL** | Mostrar/Esconder painel |
| **Toggle ESP** | Ver nomes dos jogadores |
| **Toggle SPAM** | Ativar transmissão RST |
| **Toggle Jump** | Pular infinitamente |
| **FOV Button** | Ciclar FOV (70→90→120) |
| **TP Button** | Teleportar para aliado |

### O Que Aparecer Na Tela:
```
🇧🇷 KChaos CKhaos Step Dance 🇺🇸
├─ 🔘 ANTI-AFK MARINES      [OFF]
├─ 🔘 ESP VISION            [OFF]
├─ 🔘 GOD MODE              [OFF]
├─ 🔘 INFINITE JUMP         [OFF]
├─ 🔘 🔥 TRANSMISSÃO RST 🔥 [OFF]
├─ 📡 DRONE VIEW (FOV): 70
└─ 🚀 EXTRAÇÃO ELITE (TP)
```

---

## 🛠️ Arquivo Completo

Se preferir usar o arquivo **LOADER.lua** completo do repositório:

1. Acesse: `https://github.com/KHAOS-OC97/music_clan_rst`
2. Abra arquivo `LOADER.lua`
3. Copie todo o conteúdo
4. Cole em seu Script Executor
5. Descomente a opção desejada
6. Execute

---

## ⚠️ Troubleshooting

### "Erro: HttpGet disabled"
**Solução:** Seu executor não permite HttpGet. Use a opção local ou troque de executor.

### "Erro: Módulo não encontrado"
**Solução:** Verifique a estrutura de pastas. Deve ter:
```
music_clan_rst/
├── main.lua
├── config.lua
├── services.lua
├── state.lua
├── ui/
└── features/
```

### "Painel não aparece"
**Solução:** 
- Verifique se CoreGui não está bloqueado
- Pressione CTRL para mostrar painel
- Espere 3-5 segundos para script inicializar

### "Alguns features não funcionam"
**Solução:**
- Verifique console (F9) para erros
- Certifique-se que o game está carregado
- Reinicie o script

---

## 📚 Documentação Completa

Para mais informações, consulte:
- 📖 [README.md](README.md) - Visão geral
- 📖 [ARQUITETURA.md](ARQUITETURA.md) - Guia completo
- 💡 [EXEMPLO_NOVA_FEATURE.lua](EXEMPLO_NOVA_FEATURE.lua) - Como adicionar features
- 🚀 [QUICKSTART.lua](QUICKSTART.lua) - Quick start

---

## 🎁 Pronto Para Usar!

Agora você tem um **script profissional** e pronto para usar no Roblox! 🎉

**Divirta-se!** 🔥

---

*KChaos CKhaos Step v8.2 - Glass Edition*
*Arquitetura Modular Profissional*
*2026*
