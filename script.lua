-- FlokzyHub V22 ULTIMATE - VERSÃO COMPLETA PARA GITHUB
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/Orion%20Hub%20Ui", true))()

-- Configurações Globais
_G.Speed = 16
_G.Jump = 50
_G.FlingForce = 80000
_G.KillAura = false
_G.KickAura = false
_G.AntiGrab = false
_G.GodMode = false
_G.KillAllMode = false
_G.ServerLag = false
_G.DayCycle = false
_G.Controlling = false
_G.Target = nil

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- [FUNÇÃO DE NOTIFICAÇÃO]
local function ActionNotify(t, m)
    OrionLib:MakeNotification({Name = t, Content = m, Time = 2})
end

-- [MOTOR DE FÍSICA E BYPASS - FORÇA BRUTA]
RunService.Stepped:Connect(function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            local root = char.HumanoidRootPart

            -- Forçar Atributos
            hum.WalkSpeed = _G.Speed
            hum.JumpPower = _G.Jump
            hum.UseJumpPower = true
            hum.PlatformStand = false -- Bypass de Ragdoll

            -- Kill Aura (Lançar Perto)
            if _G.KillAura then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 25 then
                            p.Character.HumanoidRootPart.Velocity = Vector3.new(0, _G.FlingForce, 0)
                        end
                    end
                end
            end

            -- Kick Aura (Empurrar Perto)
            if _G.KickAura then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then
                            p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 50)
                        end
                    end
                end
            end

            -- Anti-Grab e God Mode
            if _G.AntiGrab then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("Weld") or v:IsA("WeldConstraint") then v:Destroy() end
                end
            end
            if _G.GodMode then
                hum.Health = 100
                if root.Position.Y < -400 then root.CFrame = CFrame.new(0, 150, 0) end
            end

            -- Controle de Player (C)
            if _G.Controlling and _G.Target and _G.Target:FindFirstChild("HumanoidRootPart") then
                _G.Target.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, -12)
                _G.Target.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end)
end)

-- [SISTEMA KILL ALL]
task.spawn(function()
    while task.wait(0.5) do
        if _G.KillAllMode then
            local oldPos = Player.Character.HumanoidRootPart.CFrame
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
                    v.Character.HumanoidRootPart.Velocity = Vector3.new(0, _G.FlingForce, 0)
                    task.wait(0.1)
                end
            end
            Player.Character.HumanoidRootPart.CFrame = oldPos
            _G.KillAllMode = false
            ActionNotify("Combate", "Kill All Finalizado!")
        end
    end
end)

-- [SKY NUKE E DAY CYCLE]
task.spawn(function()
    while task.wait(0.1) do
        if _G.ServerLag then
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(5000, 5, 5000)
            p.Position = Player.Character.HumanoidRootPart.Position + Vector3.new(0, 300, 0)
            p.Anchored = true
            p.Color = Color3.new(0,0,0)
            p.Material = Enum.Material.Neon
            game:GetService("Debris"):AddItem(p, 0.2)
        end
        if _G.DayCycle then Lighting.ClockTime = Lighting.ClockTime + 0.1 end
    end
end)

-- [INTERFACE]
local Window = OrionLib:MakeWindow({Name = "FlokzyHub V22 - ULTIMATE", HidePremium = false, IntroText = "Carregando URL Externa..."})

local TabComb = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://4483345998" })
TabComb:AddButton({Name = "KILL ALL (Massacre)", Callback = function() _G.KillAllMode = true end})
TabComb:AddToggle({Name = "Kill Aura (Lançar)", Default = false, Callback = function(v) _G.KillAura = v end})
TabComb:AddToggle({Name = "Kick Aura (Empurrar)", Default = false, Callback = function(v) _G.KickAura = v end})
TabComb:AddSlider({Name = "Força", Min = 5000, Max = 300000, Default = 80000, Callback = function(v) _G.FlingForce = v end})

local TabWorld = Window:MakeTab({ Name = "World", Icon = "rbxassetid://4483345998" })
TabWorld:AddToggle({Name = "Sky Nuke (Lag Server)", Default = false, Callback = function(v) _G.ServerLag = v end})
TabWorld:AddToggle({Name = "Day Cycle", Default = false, Callback = function(v) _G.DayCycle = v end})
TabWorld:AddButton({Name = "Céu de Sangue", Callback = function() Lighting.Ambient = Color3.new(1,0,0) Lighting.FogColor = Color3.new(1,0,0) end})

local TabSet = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://4483345998" })
TabSet:AddSlider({Name = "Velocidade", Min = 16, Max = 500, Default = 16, Callback = function(v) _G.Speed = v end})
TabSet:AddSlider({Name = "Pulo", Min = 50, Max = 1000, Default = 50, Callback = function(v) _G.Jump = v end})
TabSet:AddToggle({Name = "Anti-Grab", Default = false, Callback = function(v) _G.AntiGrab = v end})
TabSet:AddToggle({Name = "God Mode", Default = false, Callback = function(v) _G.GodMode = v end})

local TabCred = Window:MakeTab({ Name = "Créditos", Icon = "rbxassetid://4483345998" })
TabCred:AddLabel("Dev: Flokzy")
TabCred:AddLabel("Exclusivo: Fling Things and People")

-- [CONTROLE DE TECLAS]
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.X then
        local gui = game:GetService("CoreGui"):FindFirstChild("Orion")
        if gui then
            gui.Enabled = not gui.Enabled
            UserInputService.MouseIconEnabled = gui.Enabled
            UserInputService.MouseBehavior = gui.Enabled and 0 or 1
        end
    elseif not gpe and input.KeyCode == Enum.KeyCode.C then
        if _G.Controlling then _G.Controlling = false else
            local m = Player:GetMouse()
            if m.Target and m.Target.Parent:FindFirstChild("Humanoid") then
                _G.Target = m.Target.Parent
                _G.Controlling = true
                ActionNotify("Controle", "Capturado: ".._G.Target.Name)
            end
        end
    end
end)

OrionLib:Init()
