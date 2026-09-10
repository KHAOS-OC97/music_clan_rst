local Services = require(script.Parent.Services)
local Config = require(script.Parent.Config)

local Bootstrap = {}

function Bootstrap.setupEnv()
    getgenv().HNkUI = Config.UiState
    getgenv().HkMultiTargets = Config.MultiTargets
    getgenv().RST_VisitedServers = getgenv().RST_VisitedServers or Config.VisitedServers
end

function Bootstrap.cleanupOldUi()
    local UI = Services.PlayerGui:FindFirstChild(Config.UiName)
    if UI then
        pcall(function()
            UI:Destroy()
        end)
    end
end

function Bootstrap.startErrorPromptTeleportWatch()
    task.spawn(function()
        pcall(function()
            Services.Gui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    task.wait(1.5)
                    Services.Teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, Services.Player)
                end
            end)
        end)
    end)
end

return Bootstrap
