--[[
  AUTO COIN V3 - Ultimate Version
  Fitur Utama:
  1. Auto Claim Coin dengan height/delay customizable
  2. Auto Win dengan delay tetap 10 detik
  3. Tampilan minimalis dengan status "READY"
  4. Tombol square dengan warna oranye
  5. Auto-pause setiap 10 menit
  6. Semua fungsi original tetap ada
--]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- State tracking
local jumpID = nil
local landingID = nil
local winID = nil
local isReady = false
local running = false
local autoWinEnabled = false
local coroutineLoop
local runTime = 0
local pauseInterval = 10 * 60
local pauseDuration = 30
local lastLoopTime = 0
local nextLoopTime = 0
local lastWinTime = 0
local winDelay = 15 -- Delay tetap 10 detik untuk Auto Win

-- GUI Setup
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "CoinClaimerGUI"
MainFrame.Parent = playerGui
MainFrame.ResetOnSpawn = false

-- Main Frame (Lebih kompak)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 220)
Frame.Position = UDim2.new(0.5, -100, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BackgroundTransparency = 0.4
Frame.Parent = MainFrame
Frame.Draggable = true
Frame.Active = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.15, 0, 0, 0)
TitleText.Text = "CAJT JAPRA"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

-- Main Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -35)
Content.Position = UDim2.new(0, 5, 0, 30)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-- Input Section
local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(1, 0, 0, 50)
InputContainer.Position = UDim2.new(0, 0, 0, 0)
InputContainer.BackgroundTransparency = 1
InputContainer.Parent = Content

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
HeightLabel.Parent = InputContainer

local HeightTextBox = Instance.new("TextBox")
HeightTextBox.Size = UDim2.new(0.6, 0, 0, 20)
HeightTextBox.Position = UDim2.new(0.4, 0, 0, 0)
HeightTextBox.Text = "6000"
HeightTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
HeightTextBox.TextColor3 = Color3.new(1, 1, 1)
HeightTextBox.BorderSizePixel = 0
HeightTextBox.Parent = InputContainer

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
DelayLabel.Parent = InputContainer

local DelayTextBox = Instance.new("TextBox")
DelayTextBox.Size = UDim2.new(0.6, 0, 0, 20)
DelayTextBox.Position = UDim2.new(0.4, 0, 0, 25)
DelayTextBox.Text = "3"
DelayTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
DelayTextBox.TextColor3 = Color3.new(1, 1, 1)
DelayTextBox.BorderSizePixel = 0
DelayTextBox.Parent = InputContainer

-- Status Indicators
local StatusContainer = Instance.new("Frame")
StatusContainer.Size = UDim2.new(1, 0, 0, 40)
StatusContainer.Position = UDim2.new(0, 0, 0, 55)
StatusContainer.BackgroundTransparency = 1
StatusContainer.Parent = Content

local CoinStatus = Instance.new("TextLabel")
CoinStatus.Size = UDim2.new(1, 0, 0, 20)
CoinStatus.Position = UDim2.new(0, 0, 0, 0)
CoinStatus.Text = "COIN: WAITING..."
CoinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
CoinStatus.BackgroundTransparency = 1
CoinStatus.Font = Enum.Font.SourceSansBold
CoinStatus.TextSize = 14
CoinStatus.TextXAlignment = Enum.TextXAlignment.Center
CoinStatus.Parent = StatusContainer

local WinStatus = Instance.new("TextLabel")
WinStatus.Size = UDim2.new(1, 0, 0, 20)
WinStatus.Position = UDim2.new(0, 0, 0, 20)
WinStatus.Text = "WIN: WAITING..."
WinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
WinStatus.BackgroundTransparency = 1
WinStatus.Font = Enum.Font.SourceSansBold
WinStatus.TextSize = 14
WinStatus.TextXAlignment = Enum.TextXAlignment.Center
WinStatus.Parent = StatusContainer

-- Button Container
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 50)
ButtonContainer.Position = UDim2.new(0, 0, 0, 100)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Content

-- Start/Stop Button (Square)
local StartStopButton = Instance.new("TextButton")
StartStopButton.Size = UDim2.new(0.48, 0, 0, 40)
StartStopButton.Position = UDim2.new(0, 0, 0, 0)
StartStopButton.Text = "COIN"
StartStopButton.Font = Enum.Font.SourceSansBold
StartStopButton.TextSize = 16
StartStopButton.TextColor3 = Color3.new(1, 1, 1)
StartStopButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75) -- Oren gelap
StartStopButton.BorderSizePixel = 0
StartStopButton.Parent = ButtonContainer
StartStopButton.Active = false

-- Auto Win Toggle (Square)
local AutoWinToggle = Instance.new("TextButton")
AutoWinToggle.Size = UDim2.new(0.48, 0, 0, 40)
AutoWinToggle.Position = UDim2.new(0.52, 0, 0, 0)
AutoWinToggle.Text = "AUTO WIN"
AutoWinToggle.Font = Enum.Font.SourceSansBold
AutoWinToggle.TextSize = 16
AutoWinToggle.TextColor3 = Color3.new(1, 1, 1)
AutoWinToggle.BackgroundColor3 = Color3.fromRGB(75, 75, 75) -- Oren gelap
AutoWinToggle.BorderSizePixel = 0
AutoWinToggle.Parent = ButtonContainer

-- Main Status
local MainStatus = Instance.new("TextLabel")
MainStatus.Size = UDim2.new(1, 0, 0, 20)
MainStatus.Position = UDim2.new(0, 0, 0, 155)
MainStatus.Text = "JUMP FROM THE TOWER FIRST!"
MainStatus.TextColor3 = Color3.new(1, 1, 1)
MainStatus.BackgroundTransparency = 1
MainStatus.Font = Enum.Font.SourceSansBold
MainStatus.TextSize = 14
MainStatus.TextXAlignment = Enum.TextXAlignment.Center
MainStatus.Parent = Content

-- Core Functions
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

local function SendWinData()
    if winID then
        local args = {
            "ClaimRooftopWinsReward",
            winID
        }
        ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
end

local function RunLoop()
    while running do
        local internalDelay = tonumber(DelayTextBox.Text) or 3
        lastLoopTime = os.time()
        nextLoopTime = lastLoopTime + internalDelay
        
        -- Auto Coin System
        SendJumpData()
        
        -- Auto Win System dengan delay terpisah
        if autoWinEnabled and os.time() - lastWinTime >= winDelay then
            SendWinData()
            lastWinTime = os.time()
        end
        
        -- Update status selama delay
        while os.time() < nextLoopTime and running do
            local remaining = nextLoopTime - os.time()
            local winRemaining = winDelay - (os.time() - lastWinTime)
            local statusText = string.format("Running (%.1fs)", remaining)
            
            if autoWinEnabled then
                statusText = statusText..string.format(" | Win (%.1fs)", winRemaining > 0 and winRemaining or 0)
            end
            
            MainStatus.Text = statusText
            wait(0.1)
        end
        
        if not running then break end
        
        SendLandingData()
        
        -- Auto-pause system
        runTime = runTime + (os.time() - lastLoopTime)
        if runTime >= pauseInterval then
            running = false
            MainStatus.Text = "Pausing for 30 seconds..."
            wait(pauseDuration)
            runTime = 0
            running = true
        end
    end
    MainStatus.Text = isReady and "READY TO START!" or "JUMP FROM THE TOWER FIRST!"
end

local function UpdateStatus()
    if jumpID and landingID then
        CoinStatus.Text = "COIN: READY!"
        CoinStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
        isReady = true
        StartStopButton.Active = true
    else
        CoinStatus.Text = "COIN: WAITING..."
        CoinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
        isReady = false
    end
    
    if winID then
        WinStatus.Text = "WIN: READY!"
        WinStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
    else
        WinStatus.Text = "WIN: WAITING..."
        WinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    end
    
    MainStatus.Text = isReady and "READY TO START!" or "JUMP FROM THE TOWER FIRST!"
end

-- Event Handlers
StartStopButton.MouseButton1Click:Connect(function()
    if isReady then
        running = not running
        if running then
            StartStopButton.Text = "COIN ON"
            StartStopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Oren merah saat aktif
            lastWinTime = os.time()
            coroutineLoop = coroutine.wrap(RunLoop)
            coroutineLoop()
        else
            StartStopButton.Text = "COIN OFF"
            StartStopButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Oren terang
            MainStatus.Text = "READY TO START!"
        end
    else
        warn("System not ready yet.")
    end
end)

AutoWinToggle.MouseButton1Click:Connect(function()
    if winID then
        autoWinEnabled = not autoWinEnabled
        if autoWinEnabled then
            AutoWinToggle.Text = "WIN ON"
            AutoWinToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Oren terang
            lastWinTime = os.time()
        else
            AutoWinToggle.Text = "WIN OFF"
            AutoWinToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Oren gelap
        end
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local minimized = Frame.Size == UDim2.new(0, 70, 0, 25)
    if minimized then
        Frame.Size = UDim2.new(0, 200, 0, 220)
        MinimizeButton.Text = "-"
        for _, child in pairs(Frame:GetChildren()) do
            if child ~= TitleBar then
                child.Visible = true
            end
        end
    else
        Frame.Size = UDim2.new(0, 70, 0, 25)
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

-- Remote Event Hook
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
        elseif args[1] == "ClaimRooftopWinsReward" and typeof(args[2]) == "number" then
            winID = args[2]
            warn("Win ID captured:", winID)
            UpdateStatus()
        end
    end

    return oldNamecall(self, ...)
end)

print("Auto Coin V3 (Modern UI) Loaded Successfully!")
