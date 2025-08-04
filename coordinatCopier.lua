local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------ GUI CREATION ------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordCopier"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

-- Main Frame (Compact size)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 180, 0, 60)  -- Smaller size
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -30)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Bar (Compact)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.15, 0, 0, 0)
titleText.Text = "Coordinate Copier"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 12

-- Control Buttons
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -40, 0, 0)
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 14
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -20, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

-- Main Button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0.9, 0, 0, 30)
copyButton.Position = UDim2.new(0.05, 0, 0, 25)
copyButton.Text = "COPY COORDINATES"
copyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 12

-- Parent all elements
titleText.Parent = titleBar
minimizeButton.Parent = titleBar
closeButton.Parent = titleBar
titleBar.Parent = mainFrame
copyButton.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = playerGui

------ COORDINATE FUNCTION ------
local function CopyCoordinates()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        local pos = rootPart.Position
        local coordinates = string.format("X:%.0f Y:%.0f Z:%.0f", pos.X, pos.Y, pos.Z)
        
        -- Try to copy to clipboard
        pcall(function()
            setclipboard(coordinates)
        end)
        
        -- Visual feedback
        copyButton.Text = "COPIED!"
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        task.wait(0.5)
        copyButton.Text = "COPY COORDINATES"
        copyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
        
        return coordinates
    end
    return nil
end

------ BUTTON FUNCTIONALITY ------
-- Copy Button
copyButton.MouseButton1Click:Connect(CopyCoordinates)

-- Minimize Button
minimizeButton.MouseButton1Click:Connect(function()
    if mainFrame.Size.Y.Offset == 60 then
        -- Minimize to bottom left
        mainFrame.Size = UDim2.new(0, 40, 0, 20)
        mainFrame.Position = UDim2.new(0, 5, 1, -25)
        copyButton.Visible = false
        minimizeButton.Text = "+"
    else
        -- Restore
        mainFrame.Size = UDim2.new(0, 180, 0, 60)
        mainFrame.Position = UDim2.new(0.5, -90, 0.5, -30)
        copyButton.Visible = true
        minimizeButton.Text = "_"
    end
end)

-- Close Button
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
