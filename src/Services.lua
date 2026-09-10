local Services = {}

Services.Players = game:GetService("Players")
Services.Tween = game:GetService("TweenService")
Services.Input = game:GetService("UserInputService")
Services.Run = game:GetService("RunService")
Services.Gui = game:GetService("CoreGui")
Services.Chat = game:GetService("TextChatService")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.Teleport = game:GetService("TeleportService")
Services.Stats = game:GetService("Stats")
Services.Player = Services.Players.LocalPlayer
Services.PlayerGui = gethui and gethui() or Services.Gui or Services.Player:WaitForChild("PlayerGui")

return Services
