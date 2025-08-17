--[[
    AUTO COIN V3 - Midpoint Token Timing
    Features:
    1. Auto Claim Coin with customizable height/delay
    2. Auto Win with 20-second delay
    3. Auto Magic Token fires at midpoint of Auto Coin delay
    4. Modern UI with minimize functionality
    5. Solid dot status indicators (●/○)
--]]

------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

------ CONSTANTS ------
local PAUSE_INTERVAL = 60 * 60  -- 1 hour
local PAUSE_DURATION = 30       -- 30 seconds
local WIN_DELAY = 20            -- 20 seconds for Auto Win
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
    hookEnabled = true,
    minimized = false
}

------ GUI CREATION ------
local function CreateGUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Clean up previous GUI
    if playerGui:FindFirstChild("CoinClaimerGUI") then
        playerGui:FindFirstChild("CoinClaimerGUI"):Destroy()
    end

    -- Main ScreenGui
    local MainFrame = Instance.new("ScreenGui")
    MainFrame.Name = "CoinClaimerGUI"
    MainFrame.Parent = playerGui
    MainFrame.ResetOnSpawn = false
    MainFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Window Frame
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 260, 0, 240)
    Frame.Position = UDim2.new(0.5, -130, 0.5, -120)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.Parent = MainFrame
    Frame.Draggable = true
    Frame.Active = true

    -- Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    TitleCorner.Parent = TitleBar

    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    TitleText.Position = UDim2.new(0.15, 0, 0, 0)
    TitleText.Text = "AUTO COIN V3"
    TitleText.TextColor3 = Color3.new(1, 1, 1)
    TitleText.BackgroundTransparency = 1
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 14
    TitleText.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 18
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    MinimizeButton.Parent = TitleBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton

    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -70)
    Content.Position = UDim2.new(0, 5, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Parent = Frame

    -- Input Section
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 60)
    InputFrame.Position = UDim2.new(0, 0, 0, 0)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = Content

    -- Height Input
    local HeightContainer = Instance.new("Frame")
    HeightContainer.Size = UDim2.new(1, 0, 0, 25)
    HeightContainer.Position = UDim2.new(0, 0, 0, 0)
    HeightContainer.BackgroundTransparency = 1
    HeightContainer.Parent = InputFrame

    local HeightLabel = Instance.new("TextLabel")
    HeightLabel.Size = UDim2.new(0.4, 0, 1, 0)
    HeightLabel.Position = UDim2.new(0, 0, 0, 0)
    HeightLabel.Text = "Height:"
    HeightLabel.TextColor3 = Color3.new(1, 1, 1)
    HeightLabel.BackgroundTransparency = 1
    HeightLabel.Font = Enum.Font.Gotham
    HeightLabel.TextSize = 12
    HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeightLabel.Parent = HeightContainer

    local HeightBox = Instance.new("TextBox")
    HeightBox.Size = UDim2.new(0.6, -5, 1, 0)
    HeightBox.Position = UDim2.new(0.4, 0, 0, 0)
    HeightBox.Text = tostring(DEFAULT_HEIGHT)
    HeightBox.PlaceholderText = "Value"
    HeightBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    HeightBox.TextColor3 = Color3.new(1, 1, 1)
    HeightBox.Font = Enum.Font.Gotham
    HeightBox.TextSize = 12
    HeightBox.Parent = HeightContainer

    local HeightCorner = Instance.new("UICorner")
    HeightCorner.CornerRadius = UDim.new(0, 4)
    HeightCorner.Parent = HeightBox

    -- Delay Input
    local DelayContainer = Instance.new("Frame")
    DelayContainer.Size = UDim2.new(1, 0, 0, 25)
    DelayContainer.Position = UDim2.new(0, 0, 0, 30)
    DelayContainer.BackgroundTransparency = 1
    DelayContainer.Parent = InputFrame

    local DelayLabel = Instance.new("TextLabel")
    DelayLabel.Size = UDim2.new(0.4, 0, 1, 0)
    DelayLabel.Position = UDim2.new(0, 0, 0, 0)
    DelayLabel.Text = "Delay:"
    DelayLabel.TextColor3 = Color3.new(1, 1, 1)
    DelayLabel.BackgroundTransparency = 1
    DelayLabel.Font = Enum.Font.Gotham
    DelayLabel.TextSize = 12
    DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DelayLabel.Parent = DelayContainer

    local DelayBox = Instance.new("TextBox")
    DelayBox.Size = UDim2.new(0.6, -5, 1, 0)
    DelayBox.Position = UDim2.new(0.4, 0, 0, 0)
    DelayBox.Text = tostring(DEFAULT_DELAY)
    DelayBox.PlaceholderText = "Seconds"
    DelayBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    DelayBox.TextColor3 = Color3.new(1, 1, 1)
    DelayBox.Font = Enum.Font.Gotham
    DelayBox.TextSize = 12
    DelayBox.Parent = DelayContainer

    local DelayCorner = Instance.new("UICorner")
    DelayCorner.CornerRadius = UDim.new(0, 4)
    DelayCorner.Parent = DelayBox

    -- Control Buttons
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 80)
    ButtonFrame.Position = UDim2.new(0, 0, 0, 65)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = Content

    -- Main Button
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(1, 0, 0, 35)
    MainButton.Position = UDim2.new(0, 0, 0, 0)
    MainButton.Text = "START AUTO COIN"
    MainButton.Font = Enum.Font.GothamBold
    MainButton.TextSize = 14
    MainButton.TextColor3 = Color3.new(1, 1, 1)
    MainButton.BackgroundColor3 = Color3.fromRGB(70, 140, 80)
    MainButton.Parent = ButtonFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainButton

    -- Toggle Frame
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.Position = UDim2.new(0, 0, 0, 45)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = ButtonFrame

    -- Win Button
    local WinButton = Instance.new("TextButton")
    WinButton.Size = UDim2.new(0.48, 0, 1, 0)
    WinButton.Position = UDim2.new(0, 0, 0, 0)
    WinButton.Text = "AUTO WIN OFF"
    WinButton.Font = Enum.Font.Gotham
    WinButton.TextSize = 12
    WinButton.TextColor3 = Color3.new(1, 1, 1)
    WinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    WinButton.Parent = ToggleFrame

    local WinCorner = Instance.new("UICorner")
    WinCorner.CornerRadius = UDim.new(0, 6)
    WinCorner.Parent = WinButton

    -- Token Button
    local TokenButton = Instance.new("TextButton")
    TokenButton.Size = UDim2.new(0.48, 0, 1, 0)
    TokenButton.Position = UDim2.new(0.52, 0, 0, 0)
    TokenButton.Text = "AUTO TOKEN OFF"
    TokenButton.Font = Enum.Font.Gotham
    TokenButton.TextSize = 12
    TokenButton.TextColor3 = Color3.new(1, 1, 1)
    TokenButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    TokenButton.Parent = ToggleFrame

    local TokenCorner = Instance.new("UICorner")
    TokenCorner.CornerRadius = UDim.new(0, 6)
    TokenCorner.Parent = TokenButton

    -- Hook Status
    local HookStatus = Instance.new("TextLabel")
    HookStatus.Size = UDim2.new(1, -10, 0, 20)
    HookStatus.Position = UDim2.new(0, 5, 1, -60)
    HookStatus.Text = "JUMP FROM THE TOWER FIRST!"
    HookStatus.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red
    HookStatus.BackgroundTransparency = 1
    HookStatus.Font = Enum.Font.Gotham
    HookStatus.TextSize = 12
    HookStatus.TextXAlignment = Enum.TextXAlignment.Center
    HookStatus.Parent = Frame

    -- Status Indicator
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -10, 0, 20)
    StatusLabel.Position = UDim2.new(0, 5, 1, -35)
    StatusLabel.Text = "Coin[○] Win[○] Token[○]" -- Default empty state
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = Frame

    -- Store references
    return {
        MainFrame = MainFrame,
        Frame = Frame,
        Content = Content,
        HeightTextBox = HeightBox,
        DelayTextBox = DelayBox,
        StatusLabel = StatusLabel,
        StartStopButton = MainButton,
        AutoWinToggle = WinButton,
        AutoTokenToggle = TokenButton,
        HookStatus = HookStatus,
        MinimizeButton = MinimizeButton,
        CloseButton = CloseButton
    }
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
    end
end

------ CORE LOGIC ------
local function UpdateStatus()
    -- Update status with solid dots (● = ready, ○ = not ready)
    local coinIcon = State.jumpID and State.landingID and "●" or "○"
    local winIcon = State.winID and "●" or "○"
    local tokenIcon = State.magicTokenID and "●" or "○"
    
    GUI.StatusLabel.Text = string.format("Coin[%s] Win[%s] Token[%s]", coinIcon, winIcon, tokenIcon)
    
    -- Update hook status
    if State.jumpID and State.landingID then
        State.isReady = true
        GUI.HookStatus.Text = "READY TO START!"
        GUI.HookStatus.TextColor3 = Color3.fromRGB(100, 255, 100) -- Green
    else
        State.isReady = false
        GUI.HookStatus.Text = "JUMP FROM THE TOWER FIRST!"
        GUI.HookStatus.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red
    end
end

local function RunLoop()
    while State.running and State.hookEnabled do
        local internalDelay = tonumber(GUI.DelayTextBox.Text) or DEFAULT_DELAY
        State.lastLoopTime = os.time()
        State.nextLoopTime = State.lastLoopTime + internalDelay
        
        -- Calculate midpoint for token (50% of delay)
        local tokenTime = State.lastLoopTime + (internalDelay / 2)
        
        -- Handle auto token at midpoint
        if State.autoTokenEnabled and State.magicTokenID then
            -- Wait until token time
            while os.time() < tokenTime and State.running and State.hookEnabled do
                local remaining = tokenTime - os.time()
                GUI.HookStatus.Text = string.format("Preparing Token (%.1fs)", remaining > 0 and remaining or 0)
                task.wait(0.1)
            end
            
            if State.running and State.hookEnabled then
                SendTokenData()
            end
        end
        
        -- Handle auto win
        if State.autoWinEnabled and os.time() - State.lastWinTime >= WIN_DELAY then
            SendWinData()
        end
        
        -- Wait remaining time until coin cycle
        while os.time() < State.nextLoopTime and State.running and State.hookEnabled do
            local remaining = State.nextLoopTime - os.time()
            local winRemaining = WIN_DELAY - (os.time() - State.lastWinTime)
            local statusText = string.format("Running (%.1fs)", remaining)
            
            if State.autoWinEnabled then
                statusText = statusText..string.format(" | Win (%.1fs)", winRemaining > 0 and winRemaining or 0)
            end
            
            GUI.HookStatus.Text = statusText
            task.wait(0.1)
        end
        
        if not State.running or not State.hookEnabled then break end
        
        -- Execute coin actions
        SendJumpData()
        SendLandingData()
        
        -- Handle auto-pause system
        State.runTime = State.runTime + (os.time() - State.lastLoopTime)
        if State.runTime >= PAUSE_INTERVAL then
            State.running = false
            GUI.HookStatus.Text = "Pausing for 30 seconds..."
            task.wait(PAUSE_DURATION)
            State.runTime = 0
            State.running = true
        end
    end
    
    if State.hookEnabled then
        UpdateStatus()
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
                coroutine.wrap(RunLoop)()
            else
                GUI.StartStopButton.Text = "AUTO COIN OFF"
                GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                UpdateStatus()
            end
        end
    end)

    -- Auto Win toggle
    GUI.AutoWinToggle.MouseButton1Click:Connect(function()
        if State.winID then
            State.autoWinEnabled = not State.autoWinEnabled
            if State.autoWinEnabled then
                GUI.AutoWinToggle.Text = "AUTO WIN ON"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                State.lastWinTime = os.time()
            else
                GUI.AutoWinToggle.Text = "AUTO WIN OFF"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            end
        end
    end)

    -- Auto Token toggle
    GUI.AutoTokenToggle.MouseButton1Click:Connect(function()
        if State.magicTokenID then
            State.autoTokenEnabled = not State.autoTokenEnabled
            if State.autoTokenEnabled then
                GUI.AutoTokenToggle.Text = "AUTO TOKEN ON"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            else
                GUI.AutoTokenToggle.Text = "AUTO TOKEN OFF"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            end
        end
    end)

    -- Minimize button
    GUI.MinimizeButton.MouseButton1Click:Connect(function()
        State.minimized = not State.minimized
        
        if State.minimized then
            GUI.Frame.Size = UDim2.new(0, 100, 0, 30)
            GUI.MinimizeButton.Text = "+"
            GUI.Content.Visible = false
            GUI.HookStatus.Visible = false
            GUI.StatusLabel.Visible = false
            GUI.TitleText.Position = UDim2.new(0.5, -25, 0, 0)
            GUI.TitleText.TextXAlignment = Enum.TextXAlignment.Center
        else
            GUI.Frame.Size = UDim2.new(0, 260, 0, 240)
            GUI.MinimizeButton.Text = "-"
            GUI.Content.Visible = true
            GUI.HookStatus.Visible = true
            GUI.StatusLabel.Visible = true
            GUI.TitleText.Position = UDim2.new(0.15, 0, 0, 0)
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
                elseif eventType == "LandingResults" then
                    State.landingID = eventID
                elseif eventType == "ClaimRooftopWinsReward" then
                    State.winID = eventID
                elseif eventType == "ClaimRooftopMagicToken" then
                    State.magicTokenID = eventID
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

print("Auto Coin V3 - Midpoint Token Timing Loaded Successfully!")
