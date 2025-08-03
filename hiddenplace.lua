local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ControlPanel"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10

-- Main Frame with rounded corners
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Parent = ScreenGui
MainFrame.Draggable = true
MainFrame.Active = true

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(80, 80, 90)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BackgroundTransparency = 0.3
TitleBar.Parent = MainFrame

-- Top-only rounded corners
local TitleBarCorners = Instance.new("UICorner")
TitleBarCorners.CornerRadius = UDim.new(0, 4)
TitleBarCorners.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 120, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.Text = "CONTROL PANEL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundTransparency = 0.7
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -20, 0, 0)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.5
CloseButton.Font = Enum.Font.GothamMedium
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -20)
ContentFrame.Position = UDim2.new(0, 0, 0, 20)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Main Button
local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 160, 0, 30)
MainButton.Position = UDim2.new(0.5, -80, 0, 10)
MainButton.Text = "HIDE"
MainButton.TextColor3 = Color3.new(0, 0, 0)
MainButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
MainButton.BackgroundTransparency = 0.2
MainButton.Font = Enum.Font.GothamMedium
MainButton.TextSize = 12
MainButton.Parent = ContentFrame

-- Button rounded corners
local ButtonCorners = Instance.new("UICorner")
ButtonCorners.CornerRadius = UDim.new(0, 4)
ButtonCorners.Parent = MainButton

-- Coordinates Label
local CoordLabel = Instance.new("TextLabel")
CoordLabel.Size = UDim2.new(1, -10, 0, 16)
CoordLabel.Position = UDim2.new(0, 5, 1, -20)
CoordLabel.Text = "Pos: (0, 0, 0)"
CoordLabel.TextColor3 = Color3.new(1, 1, 1)
CoordLabel.BackgroundTransparency = 1
CoordLabel.Font = Enum.Font.Gotham
CoordLabel.TextSize = 10
CoordLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordLabel.Parent = ContentFrame

-- Variables
local originalPosition = nil
local bodyVelocity = nil
local flyConnection = nil
local isHidden = false
local isMinimized = false

-- Update coordinates label
local function updateCoordinates()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        CoordLabel.Text = string.format("Pos: (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
    else
        CoordLabel.Text = "Pos: (No character)"
    end
end

-- Fly control functions
local function enableFly(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    humanoid.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.Parent = character.HumanoidRootPart
    
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
            bodyVelocity.Velocity = direction.Unit * 50
        end
    end)
end

local function disableFly(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    humanoid.PlatformStand = false
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- Minimize functionality
local function toggleMinimize()
    if isMinimized then
        -- Restore window
        MainFrame.Size = UDim2.new(0, 180, 0, 100)
        MainFrame.Position = UDim2.new(0.5, -90, 0.5, -50)
        ContentFrame.Visible = true
        MinimizeButton.Text = "_"
        isMinimized = false
    else
        -- Minimize window
        MainFrame.Size = UDim2.new(0, 180, 0, 20)
        MainFrame.Position = UDim2.new(0.5, -90, 1, -25)
        ContentFrame.Visible = false
        MinimizeButton.Text = "+"
        isMinimized = true
    end
end

-- Main button functionality
MainButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        
        if not isHidden then
            -- Save original position and teleport to hidden place
            originalPosition = rootPart.CFrame
            local hiddenPosition = CFrame.new(
                rootPart.Position.X,
                16000,
                rootPart.Position.Z
            )
            rootPart.CFrame = hiddenPosition
            
            -- Enable fly
            enableFly(character)
            
            -- Update button appearance
            MainButton.Text = "RETURN"
            MainButton.TextColor3 = Color3.new(1, 1, 1)
            MainButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            isHidden = true
        else
            -- Return to original position
            if originalPosition then
                rootPart.CFrame = originalPosition
            end
            
            -- Disable fly
            disableFly(character)
            
            -- Update button appearance
            MainButton.Text = "HIDE"
            MainButton.TextColor3 = Color3.new(0, 0, 0)
            MainButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            isHidden = false
        end
    end
end)

-- Minimize button functionality
MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    -- Clean up fly system if active
    if isHidden then
        local character = player.Character
        if character then
            disableFly(character)
        end
    end
    
    -- Destroy GUI
    ScreenGui:Destroy()
end)

-- Update coordinates continuously
RunService.Heartbeat:Connect(updateCoordinates)

-- Initial update
updateCoordinates()
