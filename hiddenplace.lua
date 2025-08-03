local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Core functions (from previous extraction)
local function teleportToHidePlace()
    -- Implementation from previous extract
end

local function toggleFly()
    -- Implementation from previous extract
end

-- Create minimal GUI
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 80)
mainFrame.Position = UDim2.new(0, 10, 0.5, -40)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Parent = gui

-- Title bar with drag
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.Parent = mainFrame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -20, 0, 0)
closeBtn.Text = "X"
closeBtn.Parent = titleBar

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -40, 0, 0)
minimizeBtn.Text = "_"
minimizeBtn.Parent = titleBar

-- Action buttons
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.9, 0, 0, 25)
hideBtn.Position = UDim2.new(0.05, 0, 0, 25)
hideBtn.Text = "Hide Place"
hideBtn.Parent = mainFrame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9, 0, 0, 25)
flyBtn.Position = UDim2.new(0.05, 0, 0, 55)
flyBtn.Text = "Fly: OFF"
flyBtn.Parent = mainFrame

-- Dragging functionality
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize functionality
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 150, 0, 20)
        hideBtn.Visible = false
        flyBtn.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 150, 0, 80)
        hideBtn.Visible = true
        flyBtn.Visible = true
    end
end)

-- Close functionality
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Connect functionality
hideBtn.MouseButton1Click:Connect(teleportToHidePlace)
flyBtn.MouseButton1Click:Connect(function()
    toggleFly()
    flyBtn.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
end)
