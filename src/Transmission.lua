local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)
local Notifications = require(script.Parent.Notifications)

local Transmission = {}

local function generateMessage()
    local emojis = {"🔥", "⚡", "🇧🇷", "🇺🇲", "🇬🇧", "❄️", "🌊", "🌪️", "☄️", "💥", "☢️", "🌋", "⚔️", "💀", "🩸", "🧊"}
    local out = ""
    local blocks = math.random(18, 24)

    for i = 1, blocks do
        local cluster = emojis[math.random(1, #emojis)]
        if math.random(1, 4) == 1 then
            cluster = cluster .. emojis[math.random(1, #emojis)]
        end
        local word = (math.random(1, 12) > 10) and "REAPER STRIKE TEAM" or "RST"
        out = out .. cluster .. word
    end

    out = out .. emojis[math.random(1, #emojis)]
    if string.len(out) > 195 then
        out = string.sub(out, 1, 195)
    end

    return out
end

function Transmission.send()
    local msg = generateMessage()

    pcall(function()
        if Services.Chat and Services.Chat.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = Services.Chat.TextChannels:FindFirstChild("RBXGeneral") or Services.Chat.TextChannels:FindFirstChildOfClass("TextChannel")
            if channel then
                channel:SendAsync(msg)
            end
        end
    end)

    pcall(function()
        local defaultChat = Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if defaultChat then
            local sayMessage = defaultChat:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(msg, "All")
            end
        end
    end)

    pcall(function()
        Services.Players:Chat(msg)
    end)
end

function Transmission.loop()
    task.spawn(function()
        while true do
            if Config.Enabled then
                pcall(function()
                    Transmission.send()
                end)
                task.wait(Config.Cadence)
            else
                task.wait(0.3)
            end
        end
    end)
end

return Transmission
