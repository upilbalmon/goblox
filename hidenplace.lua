-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Player Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote Event
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Create GUI
local TeleportGUI = Instance.new("ScreenGui")
TeleportGUI.Name = "EnhancedTeleportGUI"
TeleportGUI.Parent = playerGui
TeleportGUI.ResetOnSpawn = false

-- Main Frame (Transparent with rounded corners)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 120)  -- Slightly taller for title bar
MainFrame.Position = UDim2.new(0, 20, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Parent = TeleportGUI

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar (for dragging and buttons)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BackgroundTransparency = 0.7
TitleBar.Parent = MainFrame

-- Title (Minimalist)
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

-- Close Button
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

-- Minimize Button
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

-- Add rounded corners to title bar buttons
local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

local MinimizeButtonCorner = Instance.new("UICorner")
MinimizeButtonCorner.CornerRadius = UDim.new(0, 6)
MinimizeButtonCorner.Parent = MinimizeButton

-- Hide Place Button
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 150, 0, 30)
HideButton.Position = UDim2.new(0.5, -75, 0, 35)
HideButton.Text = "HIDE PLACE"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
HideButton.BackgroundTransparency = 0.3
HideButton.Font = Enum.Font.Gotham
HideButton.TextSize = 12
HideButton.Parent = MainFrame

-- Fly Button
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

-- Add rounded corners to main buttons
local HideButtonCorner = Instance.new("UICorner")
HideButtonCorner.CornerRadius = UDim.new(0, 8)
HideButtonCorner.Parent = HideButton

local FlyButtonCorner = Instance.new("UICorner")
FlyButtonCorner.CornerRadius = UDim.new(0, 8)
FlyButtonCorner.Parent = FlyButton

-- Dragging Functionality
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Fly System Variables
local flyEnabled = false
local bodyVelocity = nil
local flyConnection = nil

-- Hide Place Function
local function teleportToHidePlace()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local currentPosition = character.HumanoidRootPart.Position
    local hidePosition = Vector3.new(currentPosition.X, 16000, currentPosition.Z)
    
    local success, err = pcall(function()
        remoteEvent:FireServer("TeleportMe", CFrame.new(hidePosition))
    end)
    
    if not success then
        warn("Teleport failed: "..tostring(err))
    end
end

-- Fly System
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
            
            flyConnection = UserInputService.InputBegan:Connect(function(input)
                if not flyEnabled then return end
                
                local rootPart = character.HumanoidRootPart
                local direction = Vector3.new(0, 0, 0)
                
                if input.KeyCode == Enum.KeyCode.W then
                    direction = direction + rootPart.CFrame.LookVector
                elseif input.KeyCode == Enum.KeyCode.S then
                    direction = direction - rootPart.CFrame.LookVector
                elseif input.KeyCode == Enum.KeyCode.A then
                    direction = direction - rootPart.CFrame.RightVector
                elseif input.KeyCode == Enum.KeyCode.D then
                    direction = direction + rootPart.CFrame.RightVector
                elseif input.KeyCode == Enum.KeyCode.Space then
                    direction = direction + Vector3.new(0, 1, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    direction = direction + Vector3.new(0, -1, 0)
                end
                
                if direction.Magnitude > 0 then
                    bodyVelocity.Velocity = direction.Unit * 50
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
