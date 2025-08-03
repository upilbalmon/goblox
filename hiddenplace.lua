-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote Event
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Create GUI with AlwaysOnTop
local TeleportGUI = Instance.new("ScreenGui")
TeleportGUI.Name = "EnhancedTeleportGUI"
TeleportGUI.Parent = playerGui
TeleportGUI.ResetOnSpawn = false
TeleportGUI.DisplayOrder = 999  -- Ensures it's always on top
TeleportGUI.IgnoreGuiInset = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 120)
MainFrame.Position = UDim2.new(0, 20, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Parent = TeleportGUI

-- Rounded Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar (for dragging)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BackgroundTransparency = 0.7
TitleBar.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.Text = "TELEPORT TOOLS"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Control Buttons
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
CloseButton.BackgroundTransparency = 0.7
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
MinimizeButton.BackgroundTransparency = 0.7
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TitleBar

-- Action Buttons
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 150, 0, 30)
HideButton.Position = UDim2.new(0.5, -75, 0, 35)
HideButton.Text = "HIDDEN PLACE"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
HideButton.BackgroundTransparency = 0.3
HideButton.Font = Enum.Font.Gotham
HideButton.TextSize = 12
HideButton.Parent = MainFrame

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 150, 0, 30)
FlyButton.Position = UDim2.new(0.5, -75, 0, 70)
FlyButton.Text = "FLY: OFF"
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
FlyButton.BackgroundTransparency = 0.3
FlyButton.Font = Enum.Font.Gotham
FlyButton.TextSize = 12
FlyButton.Parent = MainFrame

-- Add rounded corners to all buttons
for _, button in ipairs({CloseButton, MinimizeButton, HideButton, FlyButton}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, button == CloseButton and 6 or 8)
    corner.Parent = button
end

-- Dragging Functionality (Fixed)
local dragStartPos, dragStartInputPos, isDragging

local function updateDrag(input)
    local delta = input.Position - dragStartInputPos
    MainFrame.Position = UDim2.new(
        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = MainFrame.Position
        dragStartInputPos = input.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- Fly System
local flyEnabled = false
local bodyVelocity, flyConnection

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
        bodyVelocity.Velocity = direction.Unit * 50
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
        FlyButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        
        if character and humanoid then
            humanoid.PlatformStand = true
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled and character and character:FindFirstChild("HumanoidRootPart") then
                    updateFlyVelocity(character)
                end
            end)
        end
    else
        FlyButton.Text = "FLY: OFF"
        FlyButton.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
        
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

-- Minimize Function
local minimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 180, 0, 25)

local function toggleMinimize()
    minimized = not minimized
    
    if minimized then
        MainFrame.Size = minimizedSize
        HideButton.Visible = false
        FlyButton.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = originalSize
        HideButton.Visible = true
        FlyButton.Visible = true
        MinimizeButton.Text = "-"
    end
end

-- Button Hover Effects
local function setupButtonHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
        button.BackgroundTransparency = 0.2
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = normalColor
        button.BackgroundTransparency = 0.3
    end)
end

setupButtonHover(HideButton, Color3.fromRGB(80, 80, 180), Color3.fromRGB(100, 100, 220))
setupButtonHover(FlyButton, 
    flyEnabled and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(180, 80, 80),
    flyEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(220, 100, 100)
)

setupButtonHover(CloseButton, Color3.fromRGB(180, 80, 80), Color3.fromRGB(220, 100, 100))
setupButtonHover(MinimizeButton, Color3.fromRGB(80, 80, 180), Color3.fromRGB(100, 100, 220))

-- Core Functions
local function teleportToHidePlace()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local currentPosition = character.HumanoidRootPart.Position
    local success = pcall(function()
        remoteEvent:FireServer("TeleportMe", CFrame.new(currentPosition.X, 16000, currentPosition.Z))
    end)
    
    if not success then
        warn("Teleport failed")
    end
end

-- Connect Buttons
HideButton.MouseButton1Click:Connect(teleportToHidePlace)
FlyButton.MouseButton1Click:Connect(toggleFly)
CloseButton.MouseButton1Click:Connect(function() TeleportGUI:Destroy() end)
MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Cleanup
player.CharacterRemoving:Connect(function()
    if flyEnabled then
        toggleFly()
    end
end)
