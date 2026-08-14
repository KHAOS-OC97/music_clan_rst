--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║       SERVICES.LUA - Referências Centralizadas de Serviços   ║
    ║              Evita repetição e facilita manutenção            ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Services = {}

-- Captura dos serviços Roblox
Services.Players = game:GetService("Players")
Services.TweenService = game:GetService("TweenService")
Services.UserInputService = game:GetService("UserInputService")
Services.RunService = game:GetService("RunService")
Services.VirtualUser = game:GetService("VirtualUser")
Services.CoreGui = game:GetService("CoreGui")
Services.Workspace = workspace
Services.Camera = workspace.CurrentCamera

-- Jogador local
Services.LocalPlayer = Services.Players.LocalPlayer
Services.PlayerGui = Services.LocalPlayer and Services.LocalPlayer:FindFirstChild("PlayerGui")
Services.Character = Services.LocalPlayer and Services.LocalPlayer.Character
Services.HumanoidRootPart = Services.Character and Services.Character:FindFirstChild("HumanoidRootPart")

if not Services.CoreGui and Services.PlayerGui then
    Services.CoreGui = Services.PlayerGui
end

-- Funções auxiliares para atualizar referências
function Services:UpdateCharacter()
    self.Character = self.LocalPlayer.Character
    self.HumanoidRootPart = self.Character and self.Character:FindFirstChild("HumanoidRootPart")
end

function Services:GetHumanoid()
    if self.Character then
        return self.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

function Services:GetCharacterByPlayer(player)
    if player and player.Character then
        return player.Character
    end
    return nil
end

function Services:GetHumanoidRootPart(character)
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Listener para atualizar Character quando o jogador morre
Services.LocalPlayer.CharacterAdded:Connect(function(char)
    Services:UpdateCharacter()
end)

return Services
