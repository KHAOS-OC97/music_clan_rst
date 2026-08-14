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
local function dispatchMessage()
    if not _runtime then
        return
    end

    local msg = MENSAGENS[(_runtime.messageIndex % #MENSAGENS) + 1]
    _runtime.messageIndex = (_runtime.messageIndex + 1) % #MENSAGENS

    local ok, err = pcall(function()
        local TextChatService = game:GetService("TextChatService")
        local channels = TextChatService and TextChatService.TextChannels

        if channels then
            local candidates = {"RBXGeneral", "General", "All", "Default"}
            local channel = nil

            for _, name in ipairs(candidates) do
                local candidate = channels:FindFirstChild(name)
                if candidate then
                    channel = candidate
                    break
                end
            end

            if not channel then
                channel = channels:GetChildren()[1]
            end

            if channel then
                channel:SendAsync(msg)
                return
            end
        end

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local sayEvent = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
        if sayEvent then
            sayEvent:FireServer(msg, "All")
            return
        end

        local fallbackChat = ReplicatedStorage:FindFirstChild("Chat", true)
        if fallbackChat and fallbackChat:IsA("RemoteEvent") then
            fallbackChat:FireServer(msg)
        end
    end)

    if not ok and err then
        warn("[RST SPAM] Erro ao enviar mensagem: " .. tostring(err))
    end
end

-- ==================== INICIALIZAR SPAM ====================
function Spam.Init(ctx)
    _svc = ctx.Services
    _state = ctx.State
    
    _G.__HOC_RUNTIME = _G.__HOC_RUNTIME or {}
    _G.__HOC_RUNTIME.Spam = _G.__HOC_RUNTIME.Spam or {
        SpamLoop = nil,
        messageIndex = 0,
    }
    _runtime = _G.__HOC_RUNTIME.Spam
    
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
