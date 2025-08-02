-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cache frequently used variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Constants
local BUTTON_WIDTH = 80
local BUTTON_HEIGHT = 25
local BUTTON_SPACING = 10
local BASE_POSITION = CFrame.new(-16.66, 3.39, -4953.99)
local HIDE_POSITION = CFrame.new(-49.47, 14329.43, -5780.3)
local FLY_SPEED = 50

-- State variables
local isHidden = false
local originalPosition = nil
local flyEnabled = false
local bodyVelocity = nil
local flyConnection = nil

-- Create GUI
local TeleportGUI = Instance.new("ScreenGui")
TeleportGUI.Name = "SimpleTeleportGUI"
TeleportGUI.Parent = playerGui
TeleportGUI.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = TeleportGUI
MainFrame.Draggable = true
MainFrame.Active = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 180, 1, 0)
TitleText.Position = UDim2.new(0.5, -90, 0, 0)
TitleText.Text = "SIMPLE TELEPORT"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

-- Coordinate Input
local CoordInput = Instance.new("TextBox")
CoordInput.Size = UDim2.new(0, 180, 0, 25)
CoordInput.Position = UDim2.new(0.5, -90, 0, 35)
CoordInput.Text = tostring(BASE_POSITION.Position)
CoordInput.PlaceholderText = "X, Y, Z"
CoordInput.TextColor3 = Color3.new(1, 1, 1)
CoordInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
CoordInput.BorderSizePixel = 0
CoordInput.Font = Enum.Font.Gotham
CoordInput.TextSize = 12
CoordInput.TextXAlignment = Enum.TextXAlignment.Center
CoordInput.Parent = MainFrame

-- Action Buttons
local function createButton(name, positionX, positionY, color, text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, BUTTON_WIDTH, 0, BUTTON_HEIGHT)
    button.Position = UDim2.new(positionX, positionY, 0, 0)
    button.Text = text or name
    button.Name = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = MainFrame
    return button
end

-- Create buttons in a grid
local TeleportButton = createButton("TeleportButton", 0.5, -BUTTON_WIDTH-BUTTON_SPACING/2, Color3.fromRGB(30, 80, 30), "GO")
TeleportButton.Position = UDim2.new(0.5, -BUTTON_WIDTH-BUTTON_SPACING/2, 0, 70)

local BaseButton = createButton("BaseButton", 0.5, BUTTON_SPACING/2, Color3.fromRGB(80, 80, 30), "BASE")
BaseButton.Position = UDim2.new(0.5, BUTTON_SPACING/2, 0, 70)

local HideButton = createButton("HideButton", 0.5, -BUTTON_WIDTH-BUTTON_SPACING/2, Color3.fromRGB(100, 60, 60), "HIDE")
HideButton.Position = UDim2.new(0.5, -BUTTON_WIDTH-BUTTON_SPACING/2, 0, 105)

local FlyButton = createButton("FlyButton", 0.5, BUTTON_SPACING/2, Color3.fromRGB(80, 30, 30), "FLY: OFF")
FlyButton.Position = UDim2.new(0.5, BUTTON_SPACING/2, 0, 105)

local CopyButton = createButton("CopyButton", 0.5, -90, Color3.fromRGB(50, 50, 90), "COPY POSITION")
CopyButton.Size = UDim2.new(0, 180, 0, BUTTON_HEIGHT)
CopyButton.Position = UDim2.new(0.5, -90, 0, 140)

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 180)
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- Helper functions
local function parseCoordinates(text)
    local coords = {}
    for num in text:gmatch("[-]?%d+[.]?%d*") do
        table.insert(coords, tonumber(num))
    end
    return coords[1] or 0, coords[2] or 0, coords[3] or 0
end

local function updateStatus(message, duration)
    StatusLabel.Text = message
    if duration then
        delay(duration, function()
            if StatusLabel.Text == message then
                StatusLabel.Text = "Ready"
            end
        end)
    end
end

local function safeTeleport(cframe)
    local success, err = pcall(function()
        remoteEvent:FireServer("TeleportMe", cframe)
    end)
    updateStatus(success and "Teleported!" or "Error: "..tostring(err))
    return success
end

-- Teleport functions
local function teleportToCoords()
    local x, y, z = parseCoordinates(CoordInput.Text)
    safeTeleport(CFrame.new(x, y, z))
end

local function teleportToBase()
    CoordInput.Text = tostring(BASE_POSITION.Position)
    safeTeleport(BASE_POSITION)
end

-- Hide system
local function toggleHide()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        updateStatus("No character found!")
        return
    end
    
    if not isHidden then
        originalPosition = character.HumanoidRootPart.CFrame
        if safeTeleport(HIDE_POSITION) then
            HideButton.Text = "RETURN"
            HideButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
            isHidden = true
        end
    else
        if originalPosition then
            if safeTeleport(originalPosition) then
                HideButton.Text = "HIDE"
                HideButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
                isHidden = false
            end
        else
            updateStatus("No original position saved!")
        end
    end
end

-- Fly system
local function updateFlyVelocity(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local direction = Vector3.new(0, 0, 0)
    local rootPart = character.HumanoidRootPart
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + rootPart.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - rootPart.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - rootPart.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + rootPart.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction = direction + Vector3.new(0, -1, 0)
    end
    
    if direction.Magnitude > 0 then
        bodyVelocity.Velocity = direction.Unit * FLY_SPEED
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

local function toggleFly()
    flyEnabled = not flyEnabled
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if flyEnabled then
        FlyButton.Text = "FLY: ON"
        FlyButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
        updateStatus("Fly enabled - WASD+Space")
        
        if character and humanoid then
            humanoid.PlatformStand = true
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            -- More efficient fly control using RunService
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled and character and character:FindFirstChild("HumanoidRootPart") then
                    updateFlyVelocity(character)
                end
            end)
        end
    else
        FlyButton.Text = "FLY: OFF"
        FlyButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        updateStatus("Fly disabled")
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if character and humanoid then
            humanoid.PlatformStand = false
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end
end

-- Copy position
local function copyCurrentPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local coordText = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
        CoordInput.Text = coordText
        
        local success = pcall(function()
            local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
            if clipBoard then
                clipBoard(coordText)
                updateStatus("Copied to clipboard!", 2)
            else
                updateStatus("Position copied!", 2)
            end
        end)
        
        if not success then
            updateStatus("Position copied!", 2)
        end
    else
        updateStatus("No character found!")
    end
end

-- Connect buttons
CloseButton.MouseButton1Click:Connect(function() TeleportGUI:Destroy() end)
TeleportButton.MouseButton1Click:Connect(teleportToCoords)
BaseButton.MouseButton1Click:Connect(teleportToBase)
HideButton.MouseButton1Click:Connect(toggleHide)
FlyButton.MouseButton1Click:Connect(toggleFly)
CopyButton.MouseButton1Click:Connect(copyCurrentPosition)

-- Initial teleport
safeTeleport(BASE_POSITION)

-- Cleanup on player leaving
player.CharacterRemoving:Connect(function()
    if flyEnabled then
        toggleFly() -- Turn off fly when character is removed
    end
end)
