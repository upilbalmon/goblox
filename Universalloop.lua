local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Main GUI
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "CompactCodeExecutor"
mainGui.Parent = player:WaitForChild("PlayerGui")

-- Main horizontal frame (always visible)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 50)
mainFrame.Position = UDim2.new(0.5, -150, 1, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = mainGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title bar (draggable area)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Title text
local title = Instance.new("TextLabel")
title.Text = "Code Executor"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Settings button (gear icon)
local settingsButton = Instance.new("TextButton")
settingsButton.Text = "⚙"
settingsButton.Size = UDim2.new(0, 20, 0, 20)
settingsButton.Position = UDim2.new(1, -25, 0, 0)
settingsButton.BackgroundTransparency = 1
settingsButton.TextColor3 = Color3.new(1, 1, 1)
settingsButton.Font = Enum.Font.SourceSansBold
settingsButton.TextSize = 14
settingsButton.Parent = titleBar

-- Content frame (main buttons)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -20)
contentFrame.Position = UDim2.new(0, 0, 0, 20)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Create compact buttons
local function createCompactButton(name, xPos, width, text, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, width, 0, 25)
    btn.Position = UDim2.new(0, xPos, 0, 5)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    return btn
end

-- Main action buttons
local executeButton = createCompactButton("ExecuteButton", 5, 140, "Execute", Color3.fromRGB(60, 80, 120))
local loopButton = createCompactButton("LoopButton", 155, 140, "Start Loop", Color3.fromRGB(60, 120, 80))

-- SETTINGS WINDOW (separate popup)
local settingsGui = Instance.new("ScreenGui")
settingsGui.Name = "SettingsWindow"
settingsGui.Enabled = false
settingsGui.Parent = mainGui

local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 350, 0, 200)
settingsFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
settingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
settingsFrame.BorderSizePixel = 0
settingsFrame.Active = true
settingsFrame.Draggable = true
settingsFrame.Visible = false
settingsFrame.Parent = settingsGui

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsFrame

-- Settings title bar
local settingsTitleBar = Instance.new("Frame")
settingsTitleBar.Size = UDim2.new(1, 0, 0, 25)
settingsTitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
settingsTitleBar.BorderSizePixel = 0
settingsTitleBar.Parent = settingsFrame

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Text = "Settings"
settingsTitle.Size = UDim2.new(1, -30, 1, 0)
settingsTitle.Position = UDim2.new(0, 10, 0, 0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.TextColor3 = Color3.new(1, 1, 1)
settingsTitle.Font = Enum.Font.SourceSansBold
settingsTitle.TextSize = 14
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = settingsTitleBar

local settingsCloseButton = Instance.new("TextButton")
settingsCloseButton.Text = "×"
settingsCloseButton.Size = UDim2.new(0, 25, 0, 25)
settingsCloseButton.Position = UDim2.new(1, -25, 0, 0)
settingsCloseButton.BackgroundTransparency = 1
settingsCloseButton.TextColor3 = Color3.new(1, 1, 1)
settingsCloseButton.Font = Enum.Font.SourceSansBold
settingsCloseButton.TextSize = 18
settingsCloseButton.Parent = settingsTitleBar

-- Settings content
local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1, -10, 1, -35)
settingsContent.Position = UDim2.new(0, 5, 0, 30)
settingsContent.BackgroundTransparency = 1
settingsContent.Parent = settingsFrame

-- Code input
local codeLabel = Instance.new("TextLabel")
codeLabel.Text = "Code:"
codeLabel.Size = UDim2.new(1, 0, 0, 20)
codeLabel.BackgroundTransparency = 1
codeLabel.TextColor3 = Color3.new(1, 1, 1)
codeLabel.Font = Enum.Font.SourceSans
codeLabel.TextSize = 12
codeLabel.TextXAlignment = Enum.TextXAlignment.Left
codeLabel.Parent = settingsContent

local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, 0, 0, 100)
codeInput.Position = UDim2.new(0, 0, 0, 20)
codeInput.PlaceholderText = "Enter Lua code here"
codeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
codeInput.TextColor3 = Color3.new(1, 1, 1)
codeInput.Font = Enum.Font.SourceSans
codeInput.TextSize = 12
codeInput.TextXAlignment = Enum.TextXAlignment.Left
codeInput.TextYAlignment = Enum.TextYAlignment.Top
codeInput.TextWrapped = true
codeInput.MultiLine = true
codeInput.ClearTextOnFocus = false
codeInput.Parent = settingsContent

-- Delay input
local delayLabel = Instance.new("TextLabel")
delayLabel.Text = "Loop Delay (seconds):"
delayLabel.Size = UDim2.new(0, 120, 0, 20)
delayLabel.Position = UDim2.new(0, 0, 0, 125)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.new(1, 1, 1)
delayLabel.Font = Enum.Font.SourceSans
delayLabel.TextSize = 12
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = settingsContent

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 60, 0, 20)
delayInput.Position = UDim2.new(0, 130, 0, 125)
delayInput.Text = "0.1"
delayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.Font = Enum.Font.SourceSans
delayInput.TextSize = 12
delayInput.Parent = settingsContent

-- Clear button
local clearButton = Instance.new("TextButton")
clearButton.Text = "Clear Code"
clearButton.Size = UDim2.new(0, 100, 0, 25)
clearButton.Position = UDim2.new(0, 0, 0, 150)
clearButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
clearButton.TextColor3 = Color3.new(1, 1, 1)
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextSize = 12
clearButton.Parent = settingsContent

-- Save button
local saveButton = Instance.new("TextButton")
saveButton.Text = "Save & Close"
saveButton.Size = UDim2.new(0, 100, 0, 25)
saveButton.Position = UDim2.new(1, -100, 0, 150)
saveButton.BackgroundColor3 = Color3.fromRGB(60, 120, 80)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextSize = 12
saveButton.Parent = settingsContent

-- Add corners to settings elements
local settingsElementCorner = Instance.new("UICorner")
settingsElementCorner.CornerRadius = UDim.new(0, 4)

for _, element in pairs({codeInput, delayInput, clearButton, saveButton}) do
    settingsElementCorner:Clone().Parent = element
end

-- Variables
local runningLoop = false
local currentDelay = 0.1
local loopThread = nil
local lastExecutionTime = 0
local isDragging = false

-- Function to safely execute code
local function executeCode(code)
    local success, errorMsg = pcall(function()
        local func, err = loadstring("return function() "..code.."\nend")
        if func then
            func()()
        else
            error(err)
        end
    end)
    
    lastExecutionTime = os.clock()
    
    if not success then
        loopButton.Text = "Error!"
        loopButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
        task.wait(1)
        if runningLoop then
            loopButton.Text = "Stop Loop"
            loopButton.BackgroundColor3 = Color3.fromRGB(120, 60, 80)
        else
            loopButton.Text = "Start Loop"
            loopButton.BackgroundColor3 = Color3.fromRGB(60, 120, 80)
        end
    end
end

-- Toggle settings window
settingsButton.MouseButton1Click:Connect(function()
    settingsGui.Enabled = true
    settingsFrame.Visible = true
    codeInput:CaptureFocus()
end)

settingsCloseButton.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
    settingsGui.Enabled = false
end)

saveButton.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
    settingsGui.Enabled = false
end)

-- Button functions
executeButton.MouseButton1Click:Connect(function()
    if codeInput.Text ~= "" then
        executeCode(codeInput.Text)
    end
end)

loopButton.MouseButton1Click:Connect(function()
    if codeInput.Text == "" then return end
    
    runningLoop = not runningLoop
    
    if runningLoop then
        currentDelay = tonumber(delayInput.Text) or 0.1
        loopButton.Text = "Stop Loop"
        loopButton.BackgroundColor3 = Color3.fromRGB(120, 60, 80)
        
        loopThread = task.spawn(function()
            while runningLoop do
                executeCode(codeInput.Text)
                task.wait(currentDelay)
            end
        end)
    else
        if loopThread then task.cancel(loopThread) end
        loopButton.Text = "Start Loop"
        loopButton.BackgroundColor3 = Color3.fromRGB(60, 120, 80)
    end
end)

clearButton.MouseButton1Click:Connect(function()
    codeInput.Text = ""
    codeInput:CaptureFocus()
end)

-- Dragging functionality for main window
local dragStartPos, frameStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = Vector2.new(mainFrame.AbsolutePosition.X, mainFrame.AbsolutePosition.Y)
        
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                conn:Disconnect()
            end
        end)
    end
end)

-- Dragging functionality for settings window
local settingsDragStartPos, settingsFrameStartPos

settingsTitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        settingsDragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        settingsFrameStartPos = Vector2.new(settingsFrame.AbsolutePosition.X, settingsFrame.AbsolutePosition.Y)
        
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = mousePos - dragStartPos
        mainFrame.Position = UDim2.new(
            0, frameStartPos.X + delta.X,
            0, frameStartPos.Y + delta.Y
        )
    end
    
    if settingsDragStartPos and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = mousePos - settingsDragStartPos
        settingsFrame.Position = UDim2.new(
            0, settingsFrameStartPos.X + delta.X,
            0, settingsFrameStartPos.Y + delta.Y
        )
    end
end)
