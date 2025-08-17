--[[
    AUTO COIN V3 - Enhanced Version
    Features:
    1. Auto height calculation: (speed × 2.8) × delay (max 14400)
    2. Dynamic auto win delay: 10000 / speed
    3. Compact 200x200 GUI
    4. All original functionality preserved
    5. Height capped at 14400
    6. Anti-AFK system (every 5 minutes)
--]]

------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

------ CONSTANTS ------
local PAUSE_INTERVAL = 60 * 60  -- 1 hour
local PAUSE_DURATION = 30       -- 30 seconds
local WIN_DELAY_BASE = 10000    -- Base for auto win delay calculation
local DEFAULT_HEIGHT = 5000
local DEFAULT_DELAY = 5
local HEIGHT_MULTIPLIER = 2.8   -- Height calculation multiplier
local MAX_HEIGHT = 14400        -- Maximum height cap
local AFK_PREVENTION_INTERVAL = 300 -- 5 minutes in seconds

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
    minimized = false,
    climbSpeed = 0,
    climbing = false,
    climbStartY = 0,
    climbStartTime = 0,
    maxY = 0,
    lastAFKAction = 0
}

------ UTILITY FUNCTIONS ------
local function GetWinDelay()
    return State.climbSpeed > 0 and (WIN_DELAY_BASE / State.climbSpeed) or 20
end

local function CalculateHeight()
    local delay = tonumber(GUI.DelayTextBox.Text) or DEFAULT_DELAY
    local calculatedHeight = math.floor((State.climbSpeed * HEIGHT_MULTIPLIER) * delay)
    return math.min(calculatedHeight, MAX_HEIGHT)
end

local function UpdateHeight()
    if State.climbSpeed > 0 then
        GUI.HeightTextBox.Text = tostring(CalculateHeight())
    end
end

------ ANTI-AFK SYSTEM ------
local function PerformAntiAFK()
    -- Simulate mouse movement
    local virtualInput = UserInputService
    local currentPosition = virtualInput:GetMouseLocation()
    
    -- Move mouse slightly
    virtualInput:SetMouseLocation(currentPosition.X + 5, currentPosition.Y)
    task.wait(0.1)
    virtualInput:SetMouseLocation(currentPosition.X, currentPosition.Y + 5)
    task.wait(0.1)
    virtualInput:SetMouseLocation(currentPosition.X - 5, currentPosition.Y)
    task.wait(0.1)
    virtualInput:SetMouseLocation(currentPosition.X, currentPosition.Y - 5)
    task.wait(0.1)
    virtualInput:SetMouseLocation(currentPosition.X, currentPosition.Y)
    
    State.lastAFKAction = os.time()
    GUI.StatusMessage.Text = "ANTI-AFK ACTIVATED"
    task.wait(2)
    if State.running then
        GUI.StatusMessage.Text = "RUNNING..."
    end
end

local function AntiAFK()
    while State.hookEnabled do
        local now = os.time()
        if now - State.lastAFKAction >= AFK_PREVENTION_INTERVAL then
            PerformAntiAFK()
        end
        task.wait(10) -- Check every 10 seconds
    end
end

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

    -- Main Frame (200x200)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 200)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -100)
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
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
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
    TitleText.TextSize = 13
    TitleText.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -25, 0, 0)
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 16
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    MinimizeButton.Parent = TitleBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 4)
    MinimizeCorner.Parent = MinimizeButton

    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -35)
    Content.Position = UDim2.new(0, 5, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Parent = Frame

    -- Input Frame
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 50)
    InputFrame.Position = UDim2.new(0, 0, 0, 0)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = Content

    -- Height Input
    local HeightLabel = Instance.new("TextLabel")
    HeightLabel.Size = UDim2.new(0.4, 0, 0, 20)
    HeightLabel.Position = UDim2.new(0, 0, 0, 0)
    HeightLabel.Text = "Height:"
    HeightLabel.TextColor3 = Color3.new(1, 1, 1)
    HeightLabel.BackgroundTransparency = 1
    HeightLabel.Font = Enum.Font.Gotham
    HeightLabel.TextSize = 11
    HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeightLabel.Parent = InputFrame

    local HeightBox = Instance.new("TextBox")
    HeightBox.Size = UDim2.new(0.6, 0, 0, 20)
    HeightBox.Position = UDim2.new(0.4, 0, 0, 0)
    HeightBox.Text = tostring(DEFAULT_HEIGHT)
    HeightBox.PlaceholderText = "Auto"
    HeightBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    HeightBox.TextColor3 = Color3.new(1, 1, 1)
    HeightBox.Font = Enum.Font.Gotham
    HeightBox.TextSize = 11
    HeightBox.Parent = InputFrame

    local HeightCorner = Instance.new("UICorner")
    HeightCorner.CornerRadius = UDim.new(0, 4)
    HeightCorner.Parent = HeightBox

    -- Delay Input
    local DelayLabel = Instance.new("TextLabel")
    DelayLabel.Size = UDim2.new(0.4, 0, 0, 20)
    DelayLabel.Position = UDim2.new(0, 0, 0, 25)
    DelayLabel.Text = "Delay:"
    DelayLabel.TextColor3 = Color3.new(1, 1, 1)
    DelayLabel.BackgroundTransparency = 1
    DelayLabel.Font = Enum.Font.Gotham
    DelayLabel.TextSize = 11
    DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DelayLabel.Parent = InputFrame

    local DelayBox = Instance.new("TextBox")
    DelayBox.Size = UDim2.new(0.6, 0, 0, 20)
    DelayBox.Position = UDim2.new(0.4, 0, 0, 25)
    DelayBox.Text = tostring(DEFAULT_DELAY)
    DelayBox.PlaceholderText = "Sec"
    DelayBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    DelayBox.TextColor3 = Color3.new(1, 1, 1)
    DelayBox.Font = Enum.Font.Gotham
    DelayBox.TextSize = 11
    DelayBox.Parent = InputFrame

    local DelayCorner = Instance.new("UICorner")
    DelayCorner.CornerRadius = UDim.new(0, 4)
    DelayCorner.Parent = DelayBox

    -- Status Indicator
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 15)
    StatusLabel.Position = UDim2.new(0, 0, 0, 55)
    StatusLabel.Text = "Coin[○] Win[○] Token[○]"
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 11
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = Content

    -- Speed Indicator
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(1, 0, 0, 15)
    SpeedLabel.Position = UDim2.new(0, 0, 0, 70)
    SpeedLabel.Text = "Speed: 0 studs/s"
    SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.TextSize = 11
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
    SpeedLabel.Parent = Content

    -- Main Button
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(1, 0, 0, 30)
    MainButton.Position = UDim2.new(0, 0, 0, 90)
    MainButton.Text = "START AUTO COIN"
    MainButton.Font = Enum.Font.GothamBold
    MainButton.TextSize = 12
    MainButton.TextColor3 = Color3.new(1, 1, 1)
    MainButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainButton.Parent = Content

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainButton

    -- Toggle Buttons Frame
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
    ToggleFrame.Position = UDim2.new(0, 0, 0, 125)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = Content

    -- Auto Win Toggle
    local WinButton = Instance.new("TextButton")
    WinButton.Size = UDim2.new(0.48, 0, 1, 0)
    WinButton.Position = UDim2.new(0, 0, 0, 0)
    WinButton.Text = "WIN: OFF"
    WinButton.Font = Enum.Font.Gotham
    WinButton.TextSize = 11
    WinButton.TextColor3 = Color3.new(1, 1, 1)
    WinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    WinButton.Parent = ToggleFrame

    local WinCorner = Instance.new("UICorner")
    WinCorner.CornerRadius = UDim.new(0, 6)
    WinCorner.Parent = WinButton

    -- Auto Token Toggle
    local TokenButton = Instance.new("TextButton")
    TokenButton.Size = UDim2.new(0.48, 0, 1, 0)
    TokenButton.Position = UDim2.new(0.52, 0, 0, 0)
    TokenButton.Text = "TOKEN: OFF"
    TokenButton.Font = Enum.Font.Gotham
    TokenButton.TextSize = 11
    TokenButton.TextColor3 = Color3.new(1, 1, 1)
    TokenButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    TokenButton.Parent = ToggleFrame

    local TokenCorner = Instance.new("UICorner")
    TokenCorner.CornerRadius = UDim.new(0, 6)
    TokenCorner.Parent = TokenButton

    -- Status Message
    local StatusMessage = Instance.new("TextLabel")
    StatusMessage.Size = UDim2.new(1, 0, 0, 15)
    StatusMessage.Position = UDim2.new(0, 0, 0, 155)
    StatusMessage.Text = "JUMP FROM TOWER FIRST"
    StatusMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusMessage.BackgroundTransparency = 1
    StatusMessage.Font = Enum.Font.Gotham
    StatusMessage.TextSize = 11
    StatusMessage.TextXAlignment = Enum.TextXAlignment.Center
    StatusMessage.Parent = Content

    -- Store references
    return {
        MainFrame = MainFrame,
        Frame = Frame,
        Content = Content,
        HeightTextBox = HeightBox,
        DelayTextBox = DelayBox,
        StatusLabel = StatusLabel,
        SpeedLabel = SpeedLabel,
        StartStopButton = MainButton,
        AutoWinToggle = WinButton,
        AutoTokenToggle = TokenButton,
        StatusMessage = StatusMessage,
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
        local height = tonumber(GUI.HeightTextBox.Text) or CalculateHeight()
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
    local coinIcon = State.jumpID and State.landingID and "●" or "○"
    local winIcon = State.winID and "●" or "○"
    local tokenIcon = State.magicTokenID and "●" or "○"
    
    GUI.StatusLabel.Text = string.format("Coin[%s] Win[%s] Token[%s]", coinIcon, winIcon, tokenIcon)
    
    if State.jumpID and State.landingID then
        State.isReady = true
        GUI.StartStopButton.BackgroundColor3 = State.running and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(70, 140, 80)
        GUI.StatusMessage.Text = State.running and "RUNNING..." or "READY TO START!"
        GUI.StatusMessage.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        State.isReady = false
        GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        GUI.StatusMessage.Text = "JUMP FROM TOWER FIRST"
        GUI.StatusMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function RunLoop()
    while State.running and State.hookEnabled do
        local internalDelay = tonumber(GUI.DelayTextBox.Text) or DEFAULT_DELAY
        State.lastLoopTime = os.time()
        State.nextLoopTime = State.lastLoopTime + internalDelay
        
        -- Handle auto token at midpoint
        if State.autoTokenEnabled and State.magicTokenID then
            local tokenTime = State.lastLoopTime + (internalDelay / 2)
            while os.time() < tokenTime and State.running and State.hookEnabled do
                task.wait(0.1)
            end
            if State.running and State.hookEnabled then
                SendTokenData()
            end
        end
        
        -- Handle auto win with dynamic delay
        local currentWinDelay = GetWinDelay()
        if State.autoWinEnabled and os.time() - State.lastWinTime >= currentWinDelay then
            SendWinData()
        end
        
        -- Wait remaining time
        while os.time() < State.nextLoopTime and State.running and State.hookEnabled do
            local remaining = State.nextLoopTime - os.time()
            local winRemaining = currentWinDelay - (os.time() - State.lastWinTime)
            local statusText = string.format("RUNNING (%.1fs)", remaining)
            
            if State.autoWinEnabled then
                statusText = statusText..string.format(" | WIN (%.1fs)", winRemaining > 0 and winRemaining or 0)
            end
            
            GUI.StatusMessage.Text = statusText
            task.wait(0.1)
        end
        
        if not State.running or not State.hookEnabled then break end
        
        -- Execute coin actions
        SendJumpData()
        SendLandingData()
        
        -- Auto-pause system
        State.runTime = State.runTime + (os.time() - State.lastLoopTime)
        if State.runTime >= PAUSE_INTERVAL then
            State.running = false
            GUI.StatusMessage.Text = "PAUSING FOR 30 SECONDS..."
            task.wait(PAUSE_DURATION)
            State.runTime = 0
            State.running = true
        end
    end
    
    if State.hookEnabled then
        UpdateStatus()
    end
end

------ CLIMB SPEED METER LOGIC ------
local function SetupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")

    humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Climbing then
            -- Start climbing session
            State.climbStartY = char:WaitForChild("HumanoidRootPart").Position.Y
            State.climbStartTime = tick()
            State.maxY = State.climbStartY
            State.climbing = true
        else
            if State.climbing then
                -- End climbing session
                local climbEndY = State.maxY
                local climbEndTime = tick()
                local totalY = climbEndY - State.climbStartY
                local totalTime = climbEndTime - State.climbStartTime

                if totalY > 0 and totalTime > 0 then
                    State.climbSpeed = totalY / totalTime
                    GUI.SpeedLabel.Text = string.format("Speed: %.2f studs/s", State.climbSpeed)
                    UpdateHeight()
                    
                    -- Show updated win delay if auto win is enabled
                    if State.autoWinEnabled then
                        GUI.StatusMessage.Text = string.format("WIN DELAY: %.1fs", GetWinDelay())
                        task.wait(2)
                        if State.running then
                            GUI.StatusMessage.Text = "RUNNING..."
                        end
                    end
                end
                State.climbing = false
            end
        end
    end)

    -- Track maximum height during climb
    RunService.Heartbeat:Connect(function()
        if State.climbing and char:FindFirstChild("HumanoidRootPart") then
            local y = char.HumanoidRootPart.Position.Y
            if y > State.maxY then
                State.maxY = y
            end
        end
    end)
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
                GUI.StartStopButton.Text = "START AUTO COIN"
                GUI.StartStopButton.BackgroundColor3 = Color3.fromRGB(70, 140, 80)
                UpdateStatus()
            end
        end
    end)

    -- Auto Win toggle
    GUI.AutoWinToggle.MouseButton1Click:Connect(function()
        if State.winID then
            State.autoWinEnabled = not State.autoWinEnabled
            if State.autoWinEnabled then
                GUI.AutoWinToggle.Text = "WIN: ON"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                State.lastWinTime = os.time()
                if State.climbSpeed > 0 then
                    GUI.StatusMessage.Text = string.format("WIN DELAY: %.1fs", GetWinDelay())
                    task.wait(2)
                    if State.running then
                        GUI.StatusMessage.Text = "RUNNING..."
                    end
                end
            else
                GUI.AutoWinToggle.Text = "WIN: OFF"
                GUI.AutoWinToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            end
        end
    end)

    -- Auto Token toggle
    GUI.AutoTokenToggle.MouseButton1Click:Connect(function()
        if State.magicTokenID then
            State.autoTokenEnabled = not State.autoTokenEnabled
            if State.autoTokenEnabled then
                GUI.AutoTokenToggle.Text = "TOKEN: ON"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            else
                GUI.AutoTokenToggle.Text = "TOKEN: OFF"
                GUI.AutoTokenToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            end
        end
    end)

    -- Delay box change handler
    GUI.DelayTextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if State.climbSpeed > 0 then
            UpdateHeight()
        end
    end)

    -- Minimize button
    GUI.MinimizeButton.MouseButton1Click:Connect(function()
        State.minimized = not State.minimized
        if State.minimized then
            GUI.Frame.Size = UDim2.new(0, 100, 0, 25)
            GUI.MinimizeButton.Text = "+"
            GUI.Content.Visible = false
            GUI.StatusMessage.Visible = false
            GUI.TitleText.Position = UDim2.new(0.5, -25, 0, 0)
            GUI.TitleText.TextXAlignment = Enum.TextXAlignment.Center
        else
            GUI.Frame.Size = UDim2.new(0, 200, 0, 200)
            GUI.MinimizeButton.Text = "-"
            GUI.Content.Visible = true
            GUI.StatusMessage.Visible = true
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

-- Set up character climbing detection
local LocalPlayer = Players.LocalPlayer
if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)

-- Start anti-AFK system
coroutine.wrap(AntiAFK)()

print("Auto Coin V3 - Enhanced Version Loaded Successfully!")
