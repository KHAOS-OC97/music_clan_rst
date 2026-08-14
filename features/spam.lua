--[[
    FEATURES/SPAM.LUA - Sistema de Transmissão Tática (Chat Spam)
    
    Envia mensagens automaticamente no chat com cadência configurável.
    Compatible com TextChatService (novo) e ReplicatedStorage (antigo).
]]

local Spam = {}
local _svc, _state
local _runtime

local MENSAGENS = {
    "🔥💀🔥RST🔥🔥RST🔥🔥RST🔥 REAPER STRIKE FORCE 🔥RST🔥🔥RST🔥🔥RST🔥💀🔥",
    "🔥💀🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥🔥RST🔥RST🔥RST🔥RST🔥RST🔥RST🔥RST🔥RST🔥RST🔥RST🔥💀🔥",
    "🔥💀🔥 REAPER STRIKE FORCE 🔥💀🔥 RST 🔥🔥 RST 🔥🔥 RST 🔥🔥 RST 🔥💀🔥"
}

-- ==================== ENVIAR MENSAGEM ====================
local function getGeneralChannel()
    local TextChatService = game:GetService("TextChatService")
    if not TextChatService or not TextChatService.TextChannels then
        return nil
    end

    local channels = TextChatService.TextChannels
    local names = {"RBXGeneral", "General", "All", "Default"}
    for _, name in ipairs(names) do
        local channel = channels:FindFirstChild(name)
        if channel then
            return channel
        end
    end

    local children = channels:GetChildren()
    if #children > 0 then
        return children[1]
    end

    return nil
end

local function dispatchMessage()
    if not _runtime then
        return false
    end

    local msg = MENSAGENS[_runtime.messageIndex]
    if not msg then
        _runtime.messageIndex = 1
        msg = MENSAGENS[1]
    end

    local sent = false

    local channel = getGeneralChannel()
    if channel then
        local ok = pcall(function()
            channel:SendAsync(msg)
        end)
        sent = ok
    end

    if not sent then
        local repStorage = game:GetService("ReplicatedStorage")
        local sayEvent = repStorage:FindFirstChild("SayMessageRequest", true)
        if sayEvent then
            local ok = pcall(function()
                sayEvent:FireServer(msg, "All")
            end)
            sent = ok
        end
    end

    if not sent then
        local repStorage = game:GetService("ReplicatedStorage")
        local chatRemote = repStorage:FindFirstChild("Chat", true)
        if chatRemote and chatRemote:IsA("RemoteEvent") then
            local ok = pcall(function()
                chatRemote:FireServer(msg)
            end)
            sent = ok
        end
    end

    _runtime.messageIndex = _runtime.messageIndex + 1
    if _runtime.messageIndex > #MENSAGENS then
        _runtime.messageIndex = 1
    end

    return sent
end

-- ==================== INICIALIZAR SPAM ====================
function Spam.Init(ctx)
    _svc = ctx.Services
    _state = ctx.State
    
    _G.__HOC_RUNTIME = _G.__HOC_RUNTIME or {}
    _G.__HOC_RUNTIME.Spam = _G.__HOC_RUNTIME.Spam or {
        SpamLoop = nil,
        messageIndex = 1,
    }
    _runtime = _G.__HOC_RUNTIME.Spam
    if not _runtime.messageIndex then
        _runtime.messageIndex = 1
    end
    
    if _runtime.SpamLoop then
        pcall(function() _runtime.SpamLoop:Disconnect() end)
        _runtime.SpamLoop = nil
    end
    
    -- Loop de spam
    _runtime.SpamLoop = _svc.RunService.Heartbeat:Connect(function()
        if not _G_Running then return end
        
        if _G_Spam then
            local lastSpam = _runtime.LastSpam or 0
            local now = tick()
            local cadencia = _state.SpamCadencia or 5
            
            if now - lastSpam >= cadencia then
                pcall(dispatchMessage)
                _runtime.LastSpam = now
            end
        end
    end)
end

return Spam
