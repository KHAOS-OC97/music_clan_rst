local Services = require(script.Parent.Services)
local Notifications = require(script.Parent.Notifications)

local EmoteSync = {}
local assetList = {
    "rbxassetid://507771019",
    "rbxassetid://3337994109",
    "rbxassetid://3338000675",
    "rbxassetid://507777268",
}
local assetIndex = 1

function EmoteSync.sync()
    local selected = nil
    local dist = 50
    local myHrp = Services.Player.Character and Services.Player.Character:FindFirstChild("HumanoidRootPart")

    if myHrp then
        for _, plr in pairs(Services.Players:GetPlayers()) do
            if plr ~= Services.Player and plr.Character then
                local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if targetHrp and hum then
                    local curDist = (targetHrp.Position - myHrp.Position).Magnitude
                    if curDist < dist then
                        local animator = hum:FindFirstChildOfClass("Animator")
                        if animator then
                            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                if track.IsPlaying and track.Animation and track.Animation.AnimationId ~= "" then
                                    if string.find(tostring(track.Priority), "Action") then
                                        local match = string.match(track.Animation.AnimationId, "%d+")
                                        if match then
                                            selected = "rbxassetid://" .. match
                                            dist = curDist
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if not selected then
        selected = assetList[assetIndex]
        assetIndex = (assetIndex % #assetList) + 1
        Notifications.show("Sem alvo de dança. Fallback Tático acionado.")
    else
        Notifications.show("Emote Interceptado e Sincronizado!")
    end

    pcall(function()
        local char = Services.Player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

                for _, stop in ipairs(animator:GetPlayingAnimationTracks()) do
                    if string.find(tostring(stop.Priority), "Action") then
                        pcall(function() stop:Stop() end)
                    end
                end

                local anim = Instance.new("Animation")
                anim.AnimationId = selected
                local load = animator:LoadAnimation(anim)
                load.Priority = Enum.AnimationPriority.Action4
                load.Looped = true
                load:Play()
            end
        end
    end)
end

return EmoteSync
