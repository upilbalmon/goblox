--[[
    AUTO FARM GUI v2.0
    Fitur:
    - Auto Coin dengan delay adjustable
    - Auto Win dengan delay adjustable
    - Sistem Pin Location
    - Deteksi remote event otomatis
    - Tema transparan minimalis
    - Draggable, minimize, close button
]]

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- State management
local State = {
    hookEnabled = true,
    autoCoinEnabled = false,
    autoWinEnabled = false,
    coinDelay = 1,
    winDelay = 15,
    pinLocation = nil,
    originalLocation = nil,
    remoteData = nil,
    isRunning = false
}

-- =============================================
-- GUI CREATION
-- =============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.BackgroundTransparency = 0.2
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0, 150, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "BLINK AUTO FARM"
TitleText.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -40)
ContentFrame.Position = UDim2.new(0, 10, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- =============================================
-- AUTO COIN SECTION
-- =============================================
local AutoCoinFrame = Instance.new("Frame")
AutoCoinFrame.Name = "AutoCoinFrame"
AutoCoinFrame.Size = UDim2.new(1, 0, 0, 80)
AutoCoinFrame.Position = UDim2.new(0, 0, 0, 10)
AutoCoinFrame.BackgroundTransparency = 1
AutoCoinFrame.Parent = ContentFrame

local AutoCoinLabel = Instance.new("TextLabel")
AutoCoinLabel.Name = "AutoCoinLabel"
AutoCoinLabel.Size = UDim2.new(0, 120, 0, 20)
AutoCoinLabel.Position = UDim2.new(0, 0, 0, 0)
AutoCoinLabel.BackgroundTransparency = 1
AutoCoinLabel.Text = "AUTO COIN"
AutoCoinLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
AutoCoinLabel.Font = Enum.Font.GothamBold
AutoCoinLabel.TextSize = 14
AutoCoinLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoCoinLabel.Parent = AutoCoinFrame

local AutoCoinToggle = Instance.new("TextButton")
AutoCoinToggle.Name = "AutoCoinToggle"
AutoCoinToggle.Size = UDim2.new(0, 70, 0, 25)
AutoCoinToggle.Position = UDim2.new(1, -70, 0, 0)
AutoCoinToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
AutoCoinToggle.Text = "OFF"
AutoCoinToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
AutoCoinToggle.Font = Enum.Font.GothamMedium
AutoCoinToggle.TextSize = 12
AutoCoinToggle.Parent = AutoCoinFrame

local AutoCoinDelayLabel = Instance.new("TextLabel")
AutoCoinDelayLabel.Name = "AutoCoinDelayLabel"
AutoCoinDelayLabel.Size = UDim2.new(0, 100, 0, 20)
AutoCoinDelayLabel.Position = UDim2.new(0, 0, 0, 30)
AutoCoinDelayLabel.BackgroundTransparency = 1
AutoCoinDelayLabel.Text = "Delay (seconds):"
AutoCoinDelayLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
AutoCoinDelayLabel.Font = Enum.Font.Gotham
AutoCoinDelayLabel.TextSize = 12
AutoCoinDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoCoinDelayLabel.Parent = AutoCoinFrame

local AutoCoinDelayBox = Instance.new("TextBox")
AutoCoinDelayBox.Name = "AutoCoinDelayBox"
AutoCoinDelayBox.Size = UDim2.new(0, 50, 0, 20)
AutoCoinDelayBox.Position = UDim2.new(0, 110, 0, 30)
AutoCoinDelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AutoCoinDelayBox.Text = "1"
AutoCoinDelayBox.TextColor3 = Color3.fromRGB(220, 220, 220)
AutoCoinDelayBox.Font = Enum.Font.Gotham
AutoCoinDelayBox.TextSize = 12
AutoCoinDelayBox.Parent = AutoCoinFrame

-- =============================================
-- AUTO WIN SECTION
-- =============================================
local AutoWinFrame = Instance.new("Frame")
AutoWinFrame.Name = "AutoWinFrame"
AutoWinFrame.Size = UDim2.new(1, 0, 0, 80)
AutoWinFrame.Position = UDim2.new(0, 0, 0, 100)
AutoWinFrame.BackgroundTransparency = 1
AutoWinFrame.Parent = ContentFrame

local AutoWinLabel = Instance.new("TextLabel")
AutoWinLabel.Name = "AutoWinLabel"
AutoWinLabel.Size = UDim2.new(0, 120, 0, 20)
AutoWinLabel.Position = UDim2.new(0, 0, 0, 0)
AutoWinLabel.BackgroundTransparency = 1
AutoWinLabel.Text = "AUTO WIN"
AutoWinLabel.TextColor3 = Color3.fromRGB(255, 180, 150)
AutoWinLabel.Font = Enum.Font.GothamBold
AutoWinLabel.TextSize = 14
AutoWinLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoWinLabel.Parent = AutoWinFrame

local AutoWinToggle = Instance.new("TextButton")
AutoWinToggle.Name = "AutoWinToggle"
AutoWinToggle.Size = UDim2.new(0, 70, 0, 25)
AutoWinToggle.Position = UDim2.new(1, -70, 0, 0)
AutoWinToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
AutoWinToggle.Text = "OFF"
AutoWinToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
AutoWinToggle.Font = Enum.Font.GothamMedium
AutoWinToggle.TextSize = 12
AutoWinToggle.Parent = AutoWinFrame

local AutoWinDelayLabel = Instance.new("TextLabel")
AutoWinDelayLabel.Name = "AutoWinDelayLabel"
AutoWinDelayLabel.Size = UDim2.new(0, 100, 0, 20)
AutoWinDelayLabel.Position = UDim2.new(0, 0, 0, 30)
AutoWinDelayLabel.BackgroundTransparency = 1
AutoWinDelayLabel.Text = "Delay (seconds):"
AutoWinDelayLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
AutoWinDelayLabel.Font = Enum.Font.Gotham
AutoWinDelayLabel.TextSize = 12
AutoWinDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoWinDelayLabel.Parent = AutoWinFrame

local AutoWinDelayBox = Instance.new("TextBox")
AutoWinDelayBox.Name = "AutoWinDelayBox"
AutoWinDelayBox.Size = UDim2.new(0, 50, 0, 20)
AutoWinDelayBox.Position = UDim2.new(0, 110, 0, 30)
AutoWinDelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AutoWinDelayBox.Text = "15"
AutoWinDelayBox.TextColor3 = Color3.fromRGB(220, 220, 220)
AutoWinDelayBox.Font = Enum.Font.Gotham
AutoWinDelayBox.TextSize = 12
AutoWinDelayBox.Parent = AutoWinFrame

-- =============================================
-- PIN LOCATION SECTION
-- =============================================
local PinLocFrame = Instance.new("Frame")
PinLocFrame.Name = "PinLocFrame"
PinLocFrame.Size = UDim2.new(1, 0, 0, 40)
PinLocFrame.Position = UDim2.new(0, 0, 0, 190)
PinLocFrame.BackgroundTransparency = 1
PinLocFrame.Parent = ContentFrame

local PinLocButton = Instance.new("TextButton")
PinLocButton.Name = "PinLocButton"
PinLocButton.Size = UDim2.new(1, 0, 0, 30)
PinLocButton.Position = UDim2.new(0, 0, 0, 0)
PinLocButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
PinLocButton.BackgroundTransparency = 0.3
PinLocButton.Text = "PIN CURRENT LOCATION"
PinLocButton.TextColor3 = Color3.fromRGB(220, 220, 220)
PinLocButton.Font = Enum.Font.GothamMedium
PinLocButton.TextSize = 12
PinLocButton.Parent = PinLocFrame

-- =============================================
-- STATUS BAR
-- =============================================
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, 0, 0, 40)
StatusFrame.Position = UDim2.new(0, 0, 0, 240)
StatusFrame.BackgroundTransparency = 1
StatusFrame.Parent = ContentFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Waiting to initialize..."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

-- =============================================
-- FUNCTIONALITY
-- =============================================
ScreenGui.Parent = game:GetService("CoreGui")

-- Update toggle buttons appearance
local function UpdateToggleButtons()
    AutoCoinToggle.BackgroundColor3 = State.autoCoinEnabled and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(80, 30, 30)
    AutoCoinToggle.Text = State.autoCoinEnabled and "ON" or (State.remoteData and "READY" or "OFF")
    
    AutoWinToggle.BackgroundColor3 = State.autoWinEnabled and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(80, 30, 30)
    AutoWinToggle.Text = State.autoWinEnabled and "ON" or (State.pinLocation and "READY" or "OFF")
end

-- Update status display
local function UpdateStatus()
    local statusParts = {}
    
    -- Remote data status
    if State.remoteData then
        table.insert(statusParts, "✅ Remote Data: "..string.len(State.remoteData).." bytes")
    else
        table.insert(statusParts, "❌ Waiting for remote data...")
    end
    
    -- Location status
    if State.pinLocation then
        table.insert(statusParts, "📍 Location pinned")
    else
        table.insert(statusParts, "❌ No location pinned")
    end
    
    -- Running status
    if State.autoCoinEnabled or State.autoWinEnabled then
        local runningParts = {}
        if State.autoCoinEnabled then table.insert(runningParts, "Auto Coin") end
        if State.autoWinEnabled then table.insert(runningParts, "Auto Win") end
        table.insert(statusParts, "▶️ Running: "..table.concat(runningParts, " + "))
    end
    
    StatusLabel.Text = "Status: "..table.concat(statusParts, " | ")
end

-- Auto Coin Function
local function AutoCoinLoop()
    while State.autoCoinEnabled and State.remoteData do
        local args = {
            State.remoteData,
            {}
        }
        
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("BLINK_UNRELIABLE_REMOTE"):FireServer(unpack(args))
        end)
        
        if not success then
            warn("[AutoCoin] Error:", err)
            State.autoCoinEnabled = false
            UpdateToggleButtons()
            UpdateStatus()
            break
        end
        
        local delay = tonumber(AutoCoinDelayBox.Text) or 1
        task.wait(delay)
    end
end

-- Auto Win Function
local function AutoWinLoop()
    while State.autoWinEnabled and State.pinLocation do
        -- Save original location if not already saved
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not State.originalLocation then
                State.originalLocation = LocalPlayer.Character.HumanoidRootPart.Position
            end
            
            -- Teleport to pinned location
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(State.pinLocation)
            task.wait(0.5)
            
            -- Teleport back to original location
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(State.originalLocation)
            task.wait(0.5)
        end
        
        local delay = tonumber(AutoWinDelayBox.Text) or 15
        task.wait(delay)
    end
end

-- Initialize Remote Hook
local function InitializeRemoteHook()
    local oldNamecall
    local remoteEvent = ReplicatedStorage:WaitForChild("BLINK_UNRELIABLE_REMOTE")
    
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not State.hookEnabled then
            return oldNamecall(self, ...)
        end
        
        local args = {...}
        local method = getnamecallmethod()
        
        if self == remoteEvent and method == "FireServer" then
            if type(args[1]) == "string" then
                -- Check if this is the data pattern we want
                if string.find(args[1], "\n\000\000\000 \204\234\167@\000\000\000\240Gj\018@") then
                    State.remoteData = args[1]
                    warn("[Hook] Captured remote data (", string.len(State.remoteData), "bytes)")
                    UpdateToggleButtons()
                    UpdateStatus()
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    UpdateStatus()
end

-- =============================================
-- EVENT CONNECTIONS
-- =============================================
-- Auto Coin Toggle
AutoCoinToggle.MouseButton1Click:Connect(function()
    if not State.remoteData then
        StatusLabel.Text = "Status: Error - No remote data captured yet!"
        task.wait(2)
        UpdateStatus()
        return
    end
    
    State.autoCoinEnabled = not State.autoCoinEnabled
    UpdateToggleButtons()
    UpdateStatus()
    
    if State.autoCoinEnabled then
        coroutine.wrap(AutoCoinLoop)()
    end
end)

-- Auto Win Toggle
AutoWinToggle.MouseButton1Click:Connect(function()
    if not State.pinLocation then
        StatusLabel.Text = "Status: Error - No location pinned yet!"
        task.wait(2)
        UpdateStatus()
        return
    end
    
    State.autoWinEnabled = not State.autoWinEnabled
    UpdateToggleButtons()
    UpdateStatus()
    
    if State.autoWinEnabled then
        coroutine.wrap(AutoWinLoop)()
    end
end)

-- Pin Location Button
PinLocButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        State.pinLocation = LocalPlayer.Character.HumanoidRootPart.Position
        UpdateToggleButtons()
        UpdateStatus()
    end
end)

-- TextBox Validation
AutoCoinDelayBox.FocusLost:Connect(function()
    local num = tonumber(AutoCoinDelayBox.Text)
    if not num or num <= 0 then
        AutoCoinDelayBox.Text = "1"
    end
    State.coinDelay = tonumber(AutoCoinDelayBox.Text)
end)

AutoWinDelayBox.FocusLost:Connect(function()
    local num = tonumber(AutoWinDelayBox.Text)
    if not num or num <= 0 then
        AutoWinDelayBox.Text = "15"
    end
    State.winDelay = tonumber(AutoWinDelayBox.Text)
end)

-- Window Controls
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local contentVisible = true
MinimizeButton.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    ContentFrame.Visible = contentVisible
    if contentVisible then
        MainFrame.Size = UDim2.new(0, 280, 0, 320)
    else
        MainFrame.Size = UDim2.new(0, 280, 0, 30)
    end
end)

-- =============================================
-- INITIALIZATION
-- =============================================
UpdateToggleButtons()
InitializeRemoteHook()
