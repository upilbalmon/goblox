-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Player Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI
local TeleportGUI = Instance.new("ScreenGui")
TeleportGUI.Name = "SimpleTeleportGUI"
TeleportGUI.Parent = playerGui
TeleportGUI.ResetOnSpawn = false

-- Main Frame (Compact size)
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
TitleBar.Position = UDim2.new(0, 0, 0, 0)
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
CoordInput.Text = "-16.66, 3.39, -4953.99"
CoordInput.PlaceholderText = "X, Y, Z"
CoordInput.TextColor3 = Color3.new(1, 1, 1)
CoordInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
CoordInput.BorderSizePixel = 0
CoordInput.Font = Enum.Font.Gotham
CoordInput.TextSize = 12
CoordInput.TextXAlignment = Enum.TextXAlignment.Center
CoordInput.Parent = MainFrame

-- Action Buttons (arranged in a grid)
local buttonY = 70
local buttonWidth = 80
local buttonHeight = 25
local buttonSpacing = 10

-- Row 1
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
TeleportButton.Position = UDim2.new(0.5, -buttonWidth-buttonSpacing/2, 0, buttonY)
TeleportButton.Text = "GO"
TeleportButton.TextColor3 = Color3.new(1, 1, 1)
TeleportButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
TeleportButton.BorderSizePixel = 0
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.TextSize = 12
TeleportButton.Parent = MainFrame

local BaseButton = Instance.new("TextButton")
BaseButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
BaseButton.Position = UDim2.new(0.5, buttonSpacing/2, 0, buttonY)
BaseButton.Text = "BASE"
BaseButton.TextColor3 = Color3.new(1, 1, 1)
BaseButton.BackgroundColor3 = Color3.fromRGB(80, 80, 30)
BaseButton.BorderSizePixel = 0
BaseButton.Font = Enum.Font.GothamBold
BaseButton.TextSize = 12
BaseButton.Parent = MainFrame

-- Row 2
buttonY = buttonY + buttonHeight + buttonSpacing

local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
HideButton.Position = UDim2.new(0.5, -buttonWidth-buttonSpacing/2, 0, buttonY)
HideButton.Text = "HIDE"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
HideButton.BorderSizePixel = 0
HideButton.Font = Enum.Font.GothamBold
HideButton.TextSize = 12
HideButton.Parent = MainFrame

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
FlyButton.Position = UDim2.new(0.5, buttonSpacing/2, 0, buttonY)
FlyButton.Text = "FLY: OFF"
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
FlyButton.BorderSizePixel = 0
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 12
FlyButton.Parent = MainFrame

-- Row 3
buttonY = buttonY + buttonHeight + buttonSpacing

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 180, 0, buttonHeight)
CopyButton.Position = UDim2.new(0.5, -90, 0, buttonY)
CopyButton.Text = "COPY POSITION"
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
CopyButton.BorderSizePixel = 0
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

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

-- Core Functions
local function parseCoordinates(text)
    local coords = {}
    for num in text:gmatch("[-]?%d+[.]?%d*") do
        table.insert(coords, tonumber(num))
    end
    return coords[1] or 0, coords[2] or 0, coords[3] or 0
end

local function teleportToCoords()
    local text = CoordInput.Text
    local x, y, z = parseCoordinates(text)
    
    local args = {
        "TeleportMe",
        CFrame.new(x, y, z)
    }
    
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end)
    
    StatusLabel.Text = success and "Teleported!" or "Error: "..tostring(err)
end

local function teleportToBase()
    CoordInput.Text = "-16.66, 3.39, -4953.99"
    teleportToCoords()
end

-- Hide System
local isHidden = false
local originalPosition = nil
local hidePosition = CFrame.new(-49.47, 14329.43, -5780.3)

local function toggleHide()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    if not isHidden then
        originalPosition = character.HumanoidRootPart.CFrame
        ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer("TeleportMe", hidePosition)
        HideButton.Text = "RETURN"
        HideButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
        StatusLabel.Text = "Hidden!"
    else
        if originalPosition then
            ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer("TeleportMe", originalPosition)
        end
        HideButton.Text = "HIDE"
        HideButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
        StatusLabel.Text = "Returned!"
    end
    isHidden = not isHidden
end

-- Fly System
local flyEnabled = false
local flySpeed = 50
local bodyVelocity

local function toggleFly()
    flyEnabled = not flyEnabled
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if flyEnabled then
        FlyButton.Text = "FLY: ON"
        FlyButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
        StatusLabel.Text = "Fly enabled - WASD+Space"
        
        if character and humanoid then
            humanoid.PlatformStand = true
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            local flyConnection
            flyConnection = UserInputService.InputBegan:Connect(function(input)
                local direction = Vector3.new(0, 0, 0)
                if input.KeyCode == Enum.KeyCode.W then
                    direction = direction + character.HumanoidRootPart.CFrame.LookVector
                elseif input.KeyCode == Enum.KeyCode.S then
                    direction = direction - character.HumanoidRootPart.CFrame.LookVector
                elseif input.KeyCode == Enum.KeyCode.A then
                    direction = direction - character.HumanoidRootPart.CFrame.RightVector
                elseif input.KeyCode == Enum.KeyCode.D then
                    direction = direction + character.HumanoidRootPart.CFrame.RightVector
                elseif input.KeyCode == Enum.KeyCode.Space then
                    direction = direction + Vector3.new(0, 1, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    direction = direction + Vector3.new(0, -1, 0)
                end
                
                if direction.Magnitude > 0 then
                    bodyVelocity.Velocity = direction.Unit * flySpeed
                end
            end)
            
            FlyButton:GetPropertyChangedSignal("Text"):Connect(function()
                if FlyButton.Text == "FLY: OFF" then
                    flyConnection:Disconnect()
                end
            end)
        end
    else
        FlyButton.Text = "FLY: OFF"
        FlyButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        StatusLabel.Text = "Fly disabled"
        
        if character and humanoid then
            humanoid.PlatformStand = false
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end
end

-- Copy Position
local function copyCurrentPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local coordText = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
        CoordInput.Text = coordText
        
        pcall(function()
            local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
            if clipBoard then
                clipBoard(coordText)
                StatusLabel.Text = "Copied to clipboard!"
            else
                StatusLabel.Text = "Position copied!"
            end
        end)
    else
        StatusLabel.Text = "No character!"
    end
end

-- Connect Buttons
CloseButton.MouseButton1Click:Connect(function() TeleportGUI:Destroy() end)
TeleportButton.MouseButton1Click:Connect(teleportToCoords)
BaseButton.MouseButton1Click:Connect(teleportToBase)
HideButton.MouseButton1Click:Connect(toggleHide)
FlyButton.MouseButton1Click:Connect(toggleFly)
CopyButton.MouseButton1Click:Connect(copyCurrentPosition)

-- Initial teleport
ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer("TeleportMe", CFrame.new(-16.66, 3.39, -4953.99))