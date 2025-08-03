-- GUI Setup
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Fly System Variables
local flyEnabled = false
local bodyVelocity

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "MinimalFlyTeleportGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.8, -50)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)

-- UI Corner for rounded edges
local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 8)

-- Fly Button
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Toggle Fly"
flyButton.BackgroundTransparency = 0.3
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 16

local flyCorner = Instance.new("UICorner", flyButton)
flyCorner.CornerRadius = UDim.new(0, 6)

-- Teleport Button
local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 0, 50)
teleportButton.Text = "Teleport Hide"
teleportButton.BackgroundTransparency = 0.3
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.Gotham
teleportButton.TextSize = 16

local teleportCorner = Instance.new("UICorner", teleportButton)
teleportCorner.CornerRadius = UDim.new(0, 6)

-- Fly Logic
local function updateFlyVelocity()
    if not flyEnabled or not player.Character then return end

    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local direction = Vector3.new(0, 0, 0)

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction += humanoidRootPart.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction -= humanoidRootPart.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction -= humanoidRootPart.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction += humanoidRootPart.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction += Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction += Vector3.new(0, -1, 0)
    end

    bodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * 50 or Vector3.zero
end

local function toggleFly()
    flyEnabled = not flyEnabled
    local character = player.Character

    if flyEnabled then
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.zero
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")

                RunService.Heartbeat:Connect(updateFlyVelocity)
            end
        end
    else
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end
end

local function teleportToHidePlace()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local success, err = pcall(function()
            remoteEvent:FireServer("TeleportMe", CFrame.new(pos.X, 16000, pos.Z))
        end)
        if not success then
            warn("Teleport failed:", err)
        end
    end
end

-- Button Events
flyButton.MouseButton1Click:Connect(toggleFly)
teleportButton.MouseButton1Click:Connect(teleportToHidePlace)

-- Cleanup
player.CharacterRemoving:Connect(function()
    if flyEnabled then
        toggleFly()
    end
end)
