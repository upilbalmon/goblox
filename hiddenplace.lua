-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Fly System Variables
local flyEnabled = false
local bodyVelocity

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "MinimalFlyTeleportGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.8, -70)
frame.BackgroundTransparency = 0.4
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.ZIndex = 10

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 8)

-- Title Bar (for drag + buttons)
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundTransparency = 0.2
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 6)

-- Close Button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 24, 1, 0)
closeBtn.Position = UDim2.new(1, -24, 0, 0)
closeBtn.Text = "✕"
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.ZIndex = 12

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 24, 1, 0)
minimizeBtn.Position = UDim2.new(1, -48, 0, 0)
minimizeBtn.Text = "—"
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 12

-- Fly Button
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 34)
flyButton.Text = "Toggle Fly"
flyButton.BackgroundTransparency = 0.3
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 16
flyButton.ZIndex = 10

local flyCorner = Instance.new("UICorner", flyButton)
flyCorner.CornerRadius = UDim.new(0, 6)

-- Teleport Button
local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 0, 80)
teleportButton.Text = "Teleport Hide"
teleportButton.BackgroundTransparency = 0.3
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.Gotham
teleportButton.TextSize = 16
teleportButton.ZIndex = 10

local teleportCorner = Instance.new("UICorner", teleportButton)
teleportCorner.CornerRadius = UDim.new(0, 6)

-- Fly Logic
local function updateFlyVelocity()
    if not flyEnabled or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += root.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= root.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= root.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += root.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir += Vector3.new(0, -1, 0) end

    bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * 50 or Vector3.zero
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
            if humanoid then humanoid.PlatformStand = false end
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
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
        if not success then warn("Teleport failed:", err) end
    end
end

-- Button Events
flyButton.MouseButton1Click:Connect(toggleFly)
teleportButton.MouseButton1Click:Connect(teleportToHidePlace)

-- Close & Minimize
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    flyButton.Visible = not minimized
    teleportButton.Visible = not minimized
    frame.Size = minimized and UDim2.new(0, 220, 0, 30) or UDim2.new(0, 220, 0, 140)
end)

-- Dragging
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Cleanup
player.CharacterRemoving:Connect(function()
    if flyEnabled then toggleFly() end
end)
