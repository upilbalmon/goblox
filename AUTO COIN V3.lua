--[[
    AUTO COIN V3 - Minimalist Complete Version
    Features:
    1. Auto Claim Coin with customizable height/delay
    2. Auto Win with 10-second delay
    3. Auto Magic Token with 10-second delay
    4. Minimalist UI design
    5. Fully functional minimize button
--]]

------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

------ CONSTANTS ------
local PAUSE_INTERVAL = 10 * 60  -- 10 minutes
local PAUSE_DURATION = 30       -- 30 seconds
local WIN_DELAY = 20            -- 10 seconds for Auto Win
local TOKEN_DELAY = 1,7           -- 10 seconds for Auto Magic Token
local DEFAULT_HEIGHT = 5000
local DEFAULT_DELAY = 5

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
    hookEnabled = true,
    minimized = false
}

------ MINIMALIST GUI CREATION ------
local GUI = {}

local function CreateGUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Clean up previous GUI if exists
    if playerGui:FindFirstChild("CoinClaimerGUI") then
        playerGui:FindFirstChild("CoinClaimerGUI"):Destroy()
    end

    -- Main GUI Container
    local MainFrame = Instance.new("ScreenGui")
    MainFrame.Name = "CoinClaimerGUI"
    MainFrame.Parent = playerGui
    MainFrame.ResetOnSpawn = false
    MainFrame.DisplayOrder = 999

    -- Compact Main Window
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 180, 0, 220)
    Frame.Position = UDim2.new(0.5, -90, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BackgroundTransparency = 0.1
    Frame.Parent = MainFrame
    Frame.Draggable = true
    Frame.Active = true

    -- Minimalist Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0.6, 0, 1, 0)
    TitleText.Position = UDim2.new(0.2, 0, 0, 0)
    TitleText.Text = "AUTO COIN"
    TitleText.TextColor3 = Color3.new(1, 1, 1)
    TitleText.BackgroundTransparency = 1
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextSize = 14
    TitleText.Parent = TitleBar

    -- Control Buttons
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -25, 0, 0)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.SourceSans
    CloseButton.TextSize = 14
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.SourceSans
    MinimizeButton.TextSize = 14
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = TitleBar

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -35)
    Content.Position = UDim2.new(0, 5, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Parent = Frame

    -- Compact Input Fields
    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(1, 0, 0, 40)
    InputContainer.Position = UDim2.new(0, 0, 0, 0)
    InputContainer.BackgroundTransparency = 1
    InputContainer.Parent = Content

    local HeightLabel = Instance.new("TextLabel")
    HeightLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
    HeightLabel.Position = UDim2.new(0, 0, 0, 0)
    HeightLabel.Text = "Height:"
    HeightLabel.TextColor3 = Color3.new(1, 1, 1)
    HeightLabel.BackgroundTransparency = 1
    HeightLabel.Font = Enum.Font.SourceSans
    HeightLabel.TextSize = 12
    HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeightLabel.Parent = InputContainer

    local HeightTextBox = Instance.new("TextBox")
    HeightTextBox.Size = UDim2.new(0.6, 0, 0.5, 0)
    HeightTextBox.Position = UDim2.new(0.4, 0, 0, 0)
    HeightTextBox.Text = tostring(DEFAULT_HEIGHT)
    HeightTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    HeightTextBox.TextColor3 = Color3.new(1, 1, 1)
    HeightTextBox.BorderSizePixel = 0
    HeightTextBox.Parent = InputContainer

    local DelayLabel = Instance.new("TextLabel")
    DelayLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
    DelayLabel.Position = UDim2.new(0, 0, 0.5, 0)
    DelayLabel.Text = "Delay:"
    DelayLabel.TextColor3 = Color3.new(1, 1, 1)
    DelayLabel.BackgroundTransparency = 1
    DelayLabel.Font = Enum.Font.SourceSans
    DelayLabel.TextSize = 12
    DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DelayLabel.Parent = InputContainer

    local DelayTextBox = Instance.new("TextBox")
    DelayTextBox.Size = UDim2.new(0.6, 0, 0.5, 0)
    DelayTextBox.Position = UDim2.new(0.4, 0, 0.5, 0)
    DelayTextBox.Text = tostring(DEFAULT_DELAY)
    DelayTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    DelayTextBox.TextColor3 = Color3.new(1, 1, 1)
    DelayTextBox.BorderSizePixel = 0
    DelayTextBox.Parent = InputContainer

    -- Status Indicators
    local StatusContainer = Instance.new("Frame")
    StatusContainer.Size = UDim2.new(1, 0, 0, 45)
    StatusContainer.Position = UDim2.new(0, 0, 0, 45)
    StatusContainer.BackgroundTransparency = 1
    StatusContainer.Parent = Content

    local CoinStatus = Instance.new("TextLabel")
    CoinStatus.Size = UDim2.new(1, 0, 0.33, 0)
    CoinStatus.Position = UDim2.new(0, 0, 0, 0)
    CoinStatus.Text = "● Coin: WAITING"
    CoinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    CoinStatus.BackgroundTransparency = 1
    CoinStatus.Font = Enum.Font.SourceSans
    CoinStatus.TextSize = 12
    CoinStatus.TextXAlignment = Enum.TextXAlignment.Left
    CoinStatus.Parent = StatusContainer

    local WinStatus = Instance.new("TextLabel")
    WinStatus.Size = UDim2.new(1, 0, 0.33, 0)
    WinStatus.Position = UDim2.new(0, 0, 0.33, 0)
    WinStatus.Text = "● Win: WAITING"
    WinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    WinStatus.BackgroundTransparency = 1
    WinStatus.Font = Enum.Font.SourceSans
    WinStatus.TextSize = 12
    WinStatus.TextXAlignment = Enum.TextXAlignment.Left
    WinStatus.Parent = StatusContainer

    local TokenStatus = Instance.new("TextLabel")
    TokenStatus.Size = UDim2.new(1, 0, 0.34, 0)
    TokenStatus.Position = UDim2.new(0, 0, 0.66, 0)
    TokenStatus.Text = "● Token: WAITING"
    TokenStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    TokenStatus.BackgroundTransparency = 1
    TokenStatus.Font = Enum.Font.SourceSans
    TokenStatus.TextSize = 12
    TokenStatus.TextXAlignment = Enum.TextXAlignment.Left
    TokenStatus.Parent = StatusContainer

    -- Control Buttons
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 70)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 95)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Content

    local StartStopButton = Instance.new("TextButton")
    StartStopButton.Size = UDim2.new(1, 0, 0.4, 0)
    StartStopButton.Position = UDim2.new(0, 0, 0, 0)
    StartStopButton.Text = "AUTO COIN"
    StartStopButton.Font = Enum.Font.SourceSans
    StartStopButton.TextSize = 14
    StartStopButton.TextColor3 = Color3.new(1, 1, 1)
    StartStopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    StartStopButton.BorderSizePixel = 0
    StartStopButton.Parent = ButtonContainer

    local AutoWinToggle = Instance.new("TextButton")
    AutoWinToggle.Size = UDim2.new(0.48, 0, 0.5, 0)
    AutoWinToggle.Position = UDim2.new(0, 0, 0.5, 0)
    AutoWinToggle.Text = "AUTO WIN"
    AutoWinToggle.Font = Enum.Font.SourceSans
    AutoWinToggle.TextSize = 12
    AutoWinToggle.TextColor3 = Color3.new(1, 1, 1)
    AutoWinToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    AutoWinToggle.BorderSizePixel = 0
    AutoWinToggle.Parent = ButtonContainer

    local AutoTokenToggle = Instance.new("TextButton")
    AutoTokenToggle.Size = UDim2.new(0.48, 0, 0.5, 0)
    AutoTokenToggle.Position = UDim2.new(0.52, 0, 0.5, 0)
    AutoTokenToggle.Text = "AUTO MAGIC"
    AutoTokenToggle.Font = Enum.Font.SourceSans
    AutoTokenToggle.TextSize = 12
    AutoTokenToggle.TextColor3 = Color3.new(1, 1, 1)
    AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    AutoTokenToggle.BorderSizePixel = 0
    AutoTokenToggle.Parent = ButtonContainer

    -- Main Status
    local MainStatus = Instance.new("TextLabel")
    MainStatus.Size = UDim2.new(1, 0, 0, 20)
    MainStatus.Position = UDim2.new(0, 0, 0, 170)
    MainStatus.Text = "JUMP FROM THE TOWER FIRST!"
    MainStatus.TextColor3 = Color3.new(1, 1, 1)
    MainStatus.BackgroundTransparency = 1
    MainStatus.Font = Enum.Font.SourceSans
    MainStatus.TextSize = 12
    MainStatus.TextXAlignment = Enum.TextXAlignment.Center
    MainStatus.Parent = Content

    -- Store references
    GUI.MainFrame = MainFrame
    GUI.Frame = Frame
    GUI.Content = Content
    GUI.TitleBar = TitleBar
    GUI.TitleText = TitleText
    GUI.MinimizeButton = MinimizeButton
    GUI.CloseButton = CloseButton
    GUI.HeightTextBox = HeightTextBox
    GUI.DelayTextBox = DelayTextBox
    GUI.CoinStatus = CoinStatus
    GUI.WinStatus = WinStatus
    GUI.TokenStatus = TokenStatus
    GUI.StartStopButton = StartStopButton
    GUI.AutoWinToggle = AutoWinToggle
    GUI.AutoTokenToggle = AutoTokenToggle
    GUI.MainStatus = MainStatus

    return GUI
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

local function SendTokenData()
    if State.magicTokenID then
        SendRemoteEvent("ClaimRooftopMagicToken", State.magicTokenID)
        State.lastTokenTime = os.time()
    end
end

------ CORE LOGIC ------
local function UpdateStatus()
    -- Update coin status
    if State.jumpID and State.landingID then
        GUI.CoinStatus.Text = "● Auto Coin: READY!"
        GUI.CoinStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
        State.isReady = true
    else
        GUI.CoinStatus.Text = "● Auto Coin: WAITING . . ."
        GUI.CoinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
        State.isReady = false
    end

    -- Update win status
    if State.winID then
        GUI.WinStatus.Text = "● Auto Win: READY!"
        GUI.WinStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
    else
        GUI.WinStatus.Text = "● Auto Win: WAITING . . ."
        GUI.WinStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    end

    -- Update token status
    if State.magicTokenID then
        GUI.TokenStatus.Text = "● Auto Magic Token: READY!"
        GUI.TokenStatus.TextColor3 = Color3.new(0.5, 1, 0.5)
    else
        GUI.TokenStatus.Text = "● Auto Magic Token: WAITING . . ."
        GUI.TokenStatus.TextColor3 = Color3.new(1, 0.5, 0.5)
    end

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
        
        -- Handle auto token with separate delay
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
                GUI.StartStopButton.Text = "AUTO COIN ON"
                GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
                State.lastWinTime = os.time()
                State.lastTokenTime = os.time()
                coroutine.wrap(RunLoop)()
            else
                GUI.StartStopButton.Text = "AUTO COIN OFF"
                GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
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
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                State.lastWinTime = os.time()
            else
                GUI.AutoWinToggle.Text = "WIN OFF"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            end
        end
    end)

    -- Auto Token toggle
    GUI.AutoTokenToggle.MouseButton1Click:Connect(function()
        if State.magicTokenID then
            State.autoTokenEnabled = not State.autoTokenEnabled
            if State.autoTokenEnabled then
                GUI.AutoTokenToggle.Text = "MAGIC ON"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                State.lastTokenTime = os.time()
            else
                GUI.AutoTokenToggle.Text = "MAGIC OFF"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            end
        end
    end)

    -- Minimize button
    GUI.MinimizeButton.MouseButton1Click:Connect(function()
        State.minimized = not State.minimized
        
        if State.minimized then
            -- Minimize to just title bar
            GUI.Frame.Size = UDim2.new(0, 100, 0, 25)
            GUI.MinimizeButton.Text = "+"
            GUI.Content.Visible = false
            
            -- Center title text when minimized
            GUI.TitleText.Position = UDim2.new(0.5, -25, 0, 0)
            GUI.TitleText.TextXAlignment = Enum.TextXAlignment.Center
        else
            -- Restore to normal size
            GUI.Frame.Size = UDim2.new(0, 180, 0, 200)
            GUI.MinimizeButton.Text = "-"
            GUI.Content.Visible = true
            
            -- Restore title text position
            GUI.TitleText.Position = UDim2.new(0.2, 0, 0, 0)
            GUI.TitleText.TextXAlignment = Enum.TextXAlignment.Left
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
                elseif eventType == "ClaimRooftopMagicToken" then
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
GUI = CreateGUI()

-- Set up event handlers
InitializeEventHandlers()
InitializeRemoteHook()

print("Auto Coin V3 - Minimalist Complete Version Loaded Successfully!")
