--[[
  AUTO COIN V3 - Enhanced Version
  Fitur:
  - Auto claim coin dengan height dan delay customizable
  - Monitoring cooldown real-time
  - Pause otomatis setiap 10 menit
  - GUI minimalis dengan dark mode
--]]

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// State tracking
local jumpID = nil
local landingID = nil
local isReady = false
local running = false
local coroutineLoop
local loopDelay = 0.2
local runTime = 0
local pauseInterval = 10 * 60  -- 10 menit
local pauseDuration = 30       -- 30 detik
local lastLoopTime = 0
local nextLoopTime = 0

--// GUI Setup
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "CoinClaimerGUI"
MainFrame.Parent = playerGui
MainFrame.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BackgroundTransparency = 0.2
Frame.Parent = MainFrame
Frame.Draggable = true
Frame.Active = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.15, 0, 0, 0)
TitleText.Text = "Auto Coin V3"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -20, 0, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

-- Main Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -30)
Content.Position = UDim2.new(0, 5, 0, 25)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-- Height Input
local HeightLabel = Instance.new("TextLabel")
HeightLabel.Size = UDim2.new(0.4, 0, 0, 20)
HeightLabel.Position = UDim2.new(0, 0, 0, 0)
HeightLabel.Text = "Height:"
HeightLabel.TextColor3 = Color3.new(1, 1, 1)
HeightLabel.BackgroundTransparency = 1
HeightLabel.Font = Enum.Font.SourceSans
HeightLabel.TextSize = 14
HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
HeightLabel.Parent = Content

local HeightTextBox = Instance.new("TextBox")
HeightTextBox.Size = UDim2.new(0.6, 0, 0, 20)
HeightTextBox.Position = UDim2.new(0.4, 0, 0, 0)
HeightTextBox.Text = "6000"
HeightTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
HeightTextBox.TextColor3 = Color3.new(1, 1, 1)
HeightTextBox.BorderSizePixel = 0
HeightTextBox.Parent = Content

-- Delay Input
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(0.4, 0, 0, 20)
DelayLabel.Position = UDim2.new(0, 0, 0, 25)
DelayLabel.Text = "Delay:"
DelayLabel.TextColor3 = Color3.new(1, 1, 1)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Font = Enum.Font.SourceSans
DelayLabel.TextSize = 14
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = Content

local DelayTextBox = Instance.new("TextBox")
DelayTextBox.Size = UDim2.new(0.6, 0, 0, 20)
DelayTextBox.Position = UDim2.new(0.4, 0, 0, 25)
DelayTextBox.Text = "3"
DelayTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
DelayTextBox.TextColor3 = Color3.new(1, 1, 1)
DelayTextBox.BorderSizePixel = 0
DelayTextBox.Parent = Content

-- Status
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 60)
StatusText.Text = "JUMP FROM THE TOWER FIRST!"
StatusText.TextColor3 = Color3.new(1, 1, 1)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.SourceSans
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.Parent = Content

-- Start/Stop Button
local StartStopButton = Instance.new("TextButton")
StartStopButton.Size = UDim2.new(1, 0, 0, 25)
StartStopButton.Position = UDim2.new(0, 0, 1, -25)
StartStopButton.Text = "Start"
StartStopButton.Font = Enum.Font.SourceSansBold
StartStopButton.TextSize = 16
StartStopButton.TextColor3 = Color3.new(1, 1, 1)
StartStopButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
StartStopButton.BorderSizePixel = 0
StartStopButton.Parent = Content
StartStopButton.Active = false
StartStopButton.Selectable = false

--// Core Functions
local function SendJumpData()
    local height = tonumber(HeightTextBox.Text)
    if jumpID and height then
        local args = {
            "JumpResults",
            jumpID,
            height
        }
        ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
end

local function SendLandingData()
    if landingID then
        local args = {
            "LandingResults",
            landingID
        }
        ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
end

local function RunLoop()
    while running do
        local internalDelay = tonumber(DelayTextBox.Text) or 3
        lastLoopTime = os.time()
        nextLoopTime = lastLoopTime + internalDelay
        
        SendJumpData()
        
        -- Update status selama delay
        while os.time() < nextLoopTime and running do
            local remaining = nextLoopTime - os.time()
            StatusText.Text = string.format("Running... (%.1fs)", remaining)
            wait(0.1)
        end
        
        if not running then break end
        
        SendLandingData()
        
        -- Auto-pause system
        runTime = runTime + (os.time() - lastLoopTime)
        if runTime >= pauseInterval then
            running = false
            StatusText.Text = "Pausing for 30 seconds..."
            wait(pauseDuration)
            runTime = 0
            running = true
        end
    end
    StatusText.Text = isReady and "PRESS START TO CONTINUE!" or "JUMP FROM THE TOWER FIRST!"
end

local function UpdateStatus()
    if jumpID and landingID then
        StatusText.Text = "PRESS START TO CONTINUE!"
        isReady = true
        StartStopButton.Active = true
        StartStopButton.Selectable = true
    else
        StatusText.Text = "JUMP FROM THE TOWER FIRST!"
        isReady = false
        StartStopButton.Active = false
        StartStopButton.Selectable = false
    end
end

--// Event Handlers
StartStopButton.MouseButton1Click:Connect(function()
    if isReady then
        running = not running
        if running then
            StartStopButton.Text = "Stop"
            StartStopButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
            coroutineLoop = coroutine.wrap(RunLoop)
            coroutineLoop()
        else
            StartStopButton.Text = "Start"
            StartStopButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            StatusText.Text = "PRESS START TO CONTINUE!"
        end
    else
        warn("Wait for Jump & Landing IDs first.")
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local minimized = Frame.Size == UDim2.new(0, 70, 0, 20)
    if minimized then
        Frame.Size = UDim2.new(0, 200, 0, 150)
        MinimizeButton.Text = "-"
        for _, child in pairs(Frame:GetChildren()) do
            if child ~= TitleBar then
                child.Visible = true
            end
        end
    else
        Frame.Size = UDim2.new(0, 70, 0, 20)
        MinimizeButton.Text = "+"
        for _, child in pairs(Frame:GetChildren()) do
            if child ~= TitleBar then
                child.Visible = false
            end
        end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame:Destroy()
end)

--// Remote Event Hook
local remoteEvent = ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent")
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = { ... }
    local method = getnamecallmethod()

    if self == remoteEvent and method == "FireServer" then
        if args[1] == "JumpResults" and typeof(args[2]) == "number" then
            jumpID = args[2]
            warn("Jump ID captured:", jumpID)
            UpdateStatus()
        elseif args[1] == "LandingResults" and typeof(args[2]) == "number" then
            landingID = args[2]
            warn("Landing ID captured:", landingID)
            UpdateStatus()
        end
    end

    return oldNamecall(self, ...)
end)

print("Auto Coin V3 Loaded Successfully!")
