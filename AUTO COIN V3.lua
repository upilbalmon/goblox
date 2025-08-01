------ GUI CREATION (Minimalist Version) ------
local function CreateMinimalistGUI()
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

    -- Main Window Frame (Compact Design)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 180, 0, 200) -- More compact size
    Frame.Position = UDim2.new(0.5, -90, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BackgroundTransparency = 0.1 -- Less transparent
    Frame.Parent = MainFrame
    Frame.Draggable = true
    Frame.Active = true

    -- Title Bar (Minimalist)
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

    -- Minimalist Control Buttons
    local function CreateMiniButton(text, size, pos, color)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = pos
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 12
        btn.Parent = Frame
        return btn
    end

    -- Close and Minimize Buttons
    local CloseButton = CreateMiniButton("X", UDim2.new(0, 25, 0, 25), UDim2.new(1, -25, 0, 0), Color3.fromRGB(180, 0, 0))
    local MinimizeButton = CreateMiniButton("-", UDim2.new(0, 25, 0, 25), UDim2.new(1, -50, 0, 0), Color3.fromRGB(40, 40, 45))

    -- Compact Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -35)
    Content.Position = UDim2.new(0, 5, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Parent = Frame

    -- Combined Input Fields
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

    -- Compact Status Indicators
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

    -- Compact Control Buttons
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 70)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 95)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Content

    local StartStopButton = Instance.new("TextButton")
    StartStopButton.Size = UDim2.new(1, 0, 0.4, 0)
    StartStopButton.Position = UDim2.new(0, 0, 0, 0)
    StartStopButton.Text = "START COIN"
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
    AutoTokenToggle.Text = "AUTO TOKEN"
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
    GUI = {
        MainFrame = MainFrame,
        Frame = Frame,
        Content = Content,
        TitleBar = TitleBar,
        MinimizeButton = MinimizeButton,
        CloseButton = CloseButton,
        HeightTextBox = HeightTextBox,
        DelayTextBox = DelayTextBox,
        CoinStatus = CoinStatus,
        WinStatus = WinStatus,
        TokenStatus = TokenStatus,
        StartStopButton = StartStopButton,
        AutoWinToggle = AutoWinToggle,
        AutoTokenToggle = AutoTokenToggle,
        MainStatus = MainStatus
    }

    return GUI
end

------ IMPROVED MINIMIZE FUNCTION ------
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
