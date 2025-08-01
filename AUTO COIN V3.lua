--[[
    AUTO COIN V3 - With Magic Token
    New Feature:
    1. Auto Magic Token with same behavior as Auto Win
    All previous fixes and features preserved
--]]

------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

------ CONSTANTS ------
local PAUSE_INTERVAL = 10 * 60  -- 10 minutes
local PAUSE_DURATION = 30       -- 30 seconds
local WIN_DELAY = 10            -- 10 seconds for Auto Win
local TOKEN_DELAY = 10          -- 10 seconds for Auto Magic Token
local DEFAULT_HEIGHT = 6000
local DEFAULT_DELAY = 3

------ STATE MANAGEMENT ------
local State = {
    jumpID = nil,
    landingID = nil,
    winID = nil,
    magicTokenID = nil,
    isReady = false,
    running = false,
    autoWinEnabled = false,
    autoTokenEnabled = false,
    runTime = 0,
    lastLoopTime = 0,
    nextLoopTime = 0,
    lastWinTime = 0,
    lastTokenTime = 0,
    hookEnabled = true
}

------ GUI CREATION ------
local GUI = {} -- Will store our GUI references

local function CreateGUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Main GUI Container
    local MainFrame = Instance.new("ScreenGui")
    MainFrame.Name = "CoinClaimerGUI"
    MainFrame.Parent = playerGui
    MainFrame.ResetOnSpawn = false

    -- Main Window Frame (slightly taller to accommodate new button)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 250)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.7
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

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -10, 1, -35)
    Content.Position = UDim2.new(0, 5, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Parent = Frame

    -- Input Fields
    local function CreateInputField(parent, labelText, defaultValue, yPosition)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 20)
        container.Position = UDim2.new(0, 0, 0, yPosition)
        container.BackgroundTransparency = 1
        container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.Text = labelText
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSans
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.6, 0, 1, 0)
        textBox.Position = UDim2.new(0.4, 0, 0, 0)
        textBox.Text = tostring(defaultValue)
        textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        textBox.TextColor3 = Color3.new(1, 1, 1)
        textBox.BorderSizePixel = 0
        textBox.Parent = container

        return textBox
    end

    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(1, 0, 0, 50)
    InputContainer.Position = UDim2.new(0, 0, 0, 0)
    InputContainer.BackgroundTransparency = 1
    InputContainer.Parent = Content

    local HeightTextBox = CreateInputField(InputContainer, "Height:", DEFAULT_HEIGHT, 0)
    local DelayTextBox = CreateInputField(InputContainer, "Delay:", DEFAULT_DELAY, 25)

    -- Status Indicators
    local function CreateStatusLabel(parent, text, yPosition)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, yPosition)
        label.Text = text
        label.TextColor3 = Color3.new(1, 0.5, 0.5)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Parent = parent
        return label
    end

    local StatusContainer = Instance.new("Frame")
    StatusContainer.Size = UDim2.new(1, 0, 0, 60) -- Increased height for new status
    StatusContainer.Position = UDim2.new(0, 0, 0, 55)
    StatusContainer.BackgroundTransparency = 1
    StatusContainer.Parent = Content

    local CoinStatus = CreateStatusLabel(StatusContainer, "COIN: WAITING...", 0)
    local WinStatus = CreateStatusLabel(StatusContainer, "WIN: WAITING...", 20)
    local TokenStatus = CreateStatusLabel(StatusContainer, "TOKEN: WAITING...", 40) -- New status

    -- Control Buttons
    local function CreateControlButton(parent, text, xPosition, yPosition, widthMultiplier, height)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(widthMultiplier, 0, 0, height or 40)
        button.Position = UDim2.new(xPosition, 0, 0, yPosition or 0)
        button.Text = text
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 16
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        button.BorderSizePixel = 0
        button.Parent = parent
        return button
    end

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 90) -- Increased height for new button
    ButtonContainer.Position = UDim2.new(0, 0, 0, 120) -- Adjusted position
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Content

    local StartStopButton = CreateControlButton(ButtonContainer, "COIN", 0, 0, 0.48)
    local AutoWinToggle = CreateControlButton(ButtonContainer, "AUTO WIN", 0.52, 0, 0.48)
    local AutoTokenToggle = CreateControlButton(ButtonContainer, "AUTO TOKEN", 0, 50, 0.48) -- New button
    local SettingsButton = CreateControlButton(ButtonContainer, "SETTINGS", 0.52, 50, 0.48, 20) -- Small button

    -- Main Status Display
    local MainStatus = Instance.new("TextLabel")
    MainStatus.Size = UDim2.new(1, 0, 0, 20)
    MainStatus.Position = UDim2.new(0, 0, 0, 215) -- Adjusted position
    MainStatus.Text = "JUMP FROM THE TOWER FIRST!"
    MainStatus.TextColor3 = Color3.new(1, 1, 1)
    MainStatus.BackgroundTransparency = 1
    MainStatus.Font = Enum.Font.SourceSansBold
    MainStatus.TextSize = 14
    MainStatus.TextXAlignment = Enum.TextXAlignment.Center
    MainStatus.Parent = Content

    -- Store GUI references
    GUI.MainFrame = MainFrame
    GUI.Frame = Frame
    GUI.MinimizeButton = MinimizeButton
    GUI.CloseButton = CloseButton
    GUI.HeightTextBox = HeightTextBox
    GUI.DelayTextBox = DelayTextBox
    GUI.CoinStatus = CoinStatus
    GUI.WinStatus = WinStatus
    GUI.TokenStatus = TokenStatus -- New reference
    GUI.StartStopButton = StartStopButton
    GUI.AutoWinToggle = AutoWinToggle
    GUI.AutoTokenToggle = AutoTokenToggle -- New reference
    GUI.SettingsButton = SettingsButton
    GUI.MainStatus = MainStatus
end

------ REMOTE EVENT FUNCTIONS ------
local function SendRemoteEvent(eventName, ...)
    local args = {eventName, ...}
    ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

local function SendJumpData()
    if State.jumpID then
        local height = tonumber(GUI.HeightTextBox.Text) or DEFAULT_HEIGHT
        SendRemoteEvent("JumpResults", State.jumpID, height)
    end
end

local function SendLandingData()
    if State.landingID then
        SendRemoteEvent("LandingResults", State.landingID)
    end
end

local function SendWinData()
    if State.winID then
        SendRemoteEvent("ClaimRooftopWinsReward", State.winID)
        State.lastWinTime = os.time()
    end
end

local function SendTokenData() -- New function
    if State.magicTokenID then
        SendRemoteEvent("ClaimRooftopMagicToken", State.magicTokenID)
        State.lastTokenTime = os.time()
    end
end

------ CORE LOGIC ------
local function UpdateStatus()
    -- Update coin status
    if State.jumpID and State.landingID then
        GUI.CoinStatus.Text = "COIN: READY!"
        GUI.CoinStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
        State.isReady = true
        GUI.StartStopButton.Active = true
    else
        GUI.CoinStatus.Text = "COIN: WAITING..."
        GUI.CoinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
        State.isReady = false
    end

    -- Update win status
    if State.winID then
        GUI.WinStatus.Text = "WIN: READY!"
        GUI.WinStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
    else
        GUI.WinStatus.Text = "WIN: WAITING..."
        GUI.WinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    end

    -- Update token status (new)
    if State.magicTokenID then
        GUI.TokenStatus.Text = "TOKEN: READY!"
        GUI.TokenStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
    else
        GUI.TokenStatus.Text = "TOKEN: WAITING..."
        GUI.TokenStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    end

    -- Update main status
    GUI.MainStatus.Text = State.isReady and "READY TO START!" or "JUMP FROM THE TOWER FIRST!"
end

local function RunLoop()
    while State.running and State.hookEnabled do
        local internalDelay = tonumber(GUI.DelayTextBox.Text) or DEFAULT_DELAY
        State.lastLoopTime = os.time()
        State.nextLoopTime = State.lastLoopTime + internalDelay
        
        -- Execute coin actions
        SendJumpData()
        
        -- Handle auto win with separate delay
        if State.autoWinEnabled and os.time() - State.lastWinTime >= WIN_DELAY then
            SendWinData()
        end
        
        -- Handle auto token with separate delay (new)
        if State.autoTokenEnabled and os.time() - State.lastTokenTime >= TOKEN_DELAY then
            SendTokenData()
        end
        
        -- Update status during delay
        while os.time() < State.nextLoopTime and State.running and State.hookEnabled do
            local remaining = State.nextLoopTime - os.time()
            local winRemaining = WIN_DELAY - (os.time() - State.lastWinTime)
            local tokenRemaining = TOKEN_DELAY - (os.time() - State.lastTokenTime)
            local statusText = string.format("Running (%.1fs)", remaining)
            
            if State.autoWinEnabled then
                statusText = statusText..string.format(" | Win (%.1fs)", winRemaining > 0 and winRemaining or 0)
            end
            
            if State.autoTokenEnabled then
                statusText = statusText..string.format(" | Token (%.1fs)", tokenRemaining > 0 and tokenRemaining or 0)
            end
            
            GUI.MainStatus.Text = statusText
            task.wait(0.1)
        end
        
        if not State.running or not State.hookEnabled then break end
        
        SendLandingData()
        
        -- Handle auto-pause system
        State.runTime = State.runTime + (os.time() - State.lastLoopTime)
        if State.runTime >= PAUSE_INTERVAL then
            State.running = false
            GUI.MainStatus.Text = "Pausing for 30 seconds..."
            task.wait(PAUSE_DURATION)
            State.runTime = 0
            State.running = true
        end
    end
    
    if State.hookEnabled then
        GUI.MainStatus.Text = State.isReady and "READY TO START!" or "JUMP FROM THE TOWER FIRST!"
    end
end

------ EVENT HANDLERS ------
local function InitializeEventHandlers()
    -- Start/Stop button
    GUI.StartStopButton.MouseButton1Click:Connect(function()
        if State.isReady then
            State.running = not State.running
            if State.running then
                GUI.StartStopButton.Text = "COIN ON"
                GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(0, 175, 200)
                State.lastWinTime = os.time()
                State.lastTokenTime = os.time()
                coroutine.wrap(RunLoop)()
            else
                GUI.StartStopButton.Text = "COIN OFF"
                GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                GUI.MainStatus.Text = "READY TO START!"
            end
        end
    end)

    -- Auto Win toggle
    GUI.AutoWinToggle.MouseButton1Click:Connect(function()
        if State.winID then
            State.autoWinEnabled = not State.autoWinEnabled
            if State.autoWinEnabled then
                GUI.AutoWinToggle.Text = "WIN ON"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(0, 175, 200)
                State.lastWinTime = os.time()
            else
                GUI.AutoWinToggle.Text = "WIN OFF"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            end
        end
    end)

    -- Auto Token toggle (new)
    GUI.AutoTokenToggle.MouseButton1Click:Connect(function()
        if State.magicTokenID then
            State.autoTokenEnabled = not State.autoTokenEnabled
            if State.autoTokenEnabled then
                GUI.AutoTokenToggle.Text = "TOKEN ON"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(0, 175, 200)
                State.lastTokenTime = os.time()
            else
                GUI.AutoTokenToggle.Text = "TOKEN OFF"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            end
        end
    end)

    -- Settings button (placeholder)
    GUI.SettingsButton.MouseButton1Click:Connect(function()
        -- Placeholder for future settings
        print("Settings button clicked")
    end)

    -- Minimize button
GUI.MinimizeButton.MouseButton1Click:Connect(function()
    State.minimized = not State.minimized
    
    if State.minimized then
        -- Saat minimize
        GUI.Frame.Size = UDim2.new(0, 70, 0, 30) -- Hanya title bar
        GUI.MinimizeButton.Text = "+"
        
        -- Sembunyikan semua children kecuali TitleBar
        for _, child in pairs(GUI.Frame:GetChildren()) do
            if child ~= GUI.TitleBar then
                child.Visible = false
            end
        end
        
        -- Pastikan TitleBar dan tombolnya tetap visible
        GUI.TitleBar.Visible = true
        GUI.MinimizeButton.Visible = true
        GUI.CloseButton.Visible = true
    else
        -- Saat restore
        GUI.Frame.Size = UDim2.new(0, 220, 0, 270) -- Ukuran normal
        
        -- Tampilkan kembali semua children
        for _, child in pairs(GUI.Frame:GetChildren()) do
            child.Visible = true
        end
        
        GUI.MinimizeButton.Text = "-"
    end
end)

    -- Close button
    GUI.CloseButton.MouseButton1Click:Connect(function()
        State.hookEnabled = false
        GUI.MainFrame:Destroy()
    end)
end

------ REMOTE EVENT HOOK ------
local function InitializeRemoteHook()
    local remoteEvent = ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent")
    local oldNamecall
    
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not State.hookEnabled then
            return oldNamecall(self, ...)
        end
        
        local args = {...}
        local method = getnamecallmethod()

        if self == remoteEvent and method == "FireServer" then
            local eventType = args[1]
            local eventID = args[2]
            
            if typeof(eventID) == "number" then
                if eventType == "JumpResults" then
                    State.jumpID = eventID
                    warn("Jump ID captured:", eventID)
                elseif eventType == "LandingResults" then
                    State.landingID = eventID
                    warn("Landing ID captured:", eventID)
                elseif eventType == "ClaimRooftopWinsReward" then
                    State.winID = eventID
                    warn("Win ID captured:", eventID)
                elseif eventType == "ClaimRooftopMagicToken" then -- New condition
                    State.magicTokenID = eventID
                    warn("Magic Token ID captured:", eventID)
                end
                
                UpdateStatus()
            end
        end

        return oldNamecall(self, ...)
    end)
end

------ INITIALIZATION ------
-- Create GUI
CreateGUI()

-- Set up event handlers
InitializeEventHandlers()
InitializeRemoteHook()

print("Auto Coin V3 (With Magic Token) Loaded Successfully!")
