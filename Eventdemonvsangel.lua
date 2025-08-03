-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Player Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Player Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote Event
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Create GUI
local PetGUI = Instance.new("ScreenGui")
PetGUI.Name = "PetShopGUI"
PetGUI.Parent = playerGui
PetGUI.ResetOnSpawn = false

-- Main Frame (Transparent with rounded corners)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0, 20, 0.5, -55)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.4
MainFrame.Parent = PetGUI
MainFrame.Draggable = true
MainFrame.Active = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title (Minimalist)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "PET SHOP"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.Parent = MainFrame

-- Buy Pet Button (Rounded, transparent with accent)
local BuyPetButton = Instance.new("TextButton")
BuyPetButton.Size = UDim2.new(0, 160, 0, 35)
BuyPetButton.Position = UDim2.new(0.5, -80, 0, 30)
BuyPetButton.Text = "BUY PET"
BuyPetButton.TextColor3 = Color3.new(1, 1, 1)
BuyPetButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
BuyPetButton.BackgroundTransparency = 0.3
BuyPetButton.Font = Enum.Font.GothamMedium
BuyPetButton.TextSize = 13
BuyPetButton.Parent = MainFrame

-- Add rounded corners to button
local BuyPetCorner = Instance.new("UICorner")
BuyPetCorner.CornerRadius = UDim.new(0, 8)
BuyPetCorner.Parent = BuyPetButton

-- Add subtle stroke
local BuyPetStroke = Instance.new("UIStroke")
BuyPetStroke.Color = Color3.fromRGB(180, 120, 220)
BuyPetStroke.Thickness = 1
BuyPetStroke.Parent = BuyPetButton

-- Level Up Token Button
local LvlUpButton = Instance.new("TextButton")
LvlUpButton.Size = UDim2.new(0, 160, 0, 35)
LvlUpButton.Position = UDim2.new(0.5, -80, 0, 70)
LvlUpButton.Text = "LVL UP TOKEN"
LvlUpButton.TextColor3 = Color3.new(1, 1, 1)
LvlUpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
LvlUpButton.BackgroundTransparency = 0.3
LvlUpButton.Font = Enum.Font.GothamMedium
LvlUpButton.TextSize = 13
LvlUpButton.Parent = MainFrame

-- Add rounded corners to button
local LvlUpCorner = Instance.new("UICorner")
LvlUpCorner.CornerRadius = UDim.new(0, 8)
LvlUpCorner.Parent = LvlUpButton

-- Add subtle stroke
local LvlUpStroke = Instance.new("UIStroke")
LvlUpStroke.Color = Color3.fromRGB(120, 220, 180)
LvlUpStroke.Thickness = 1
LvlUpStroke.Parent = LvlUpButton

-- Button Hover Effects
local function buttonHoverEffect(button, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.2
        button.UIStroke.Color = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0.3
        button.UIStroke.Color = Color3.new(hoverColor.R * 0.7, hoverColor.G * 0.7, hoverColor.B * 0.7)
    end)
end

buttonHoverEffect(BuyPetButton, Color3.fromRGB(180, 120, 220))
buttonHoverEffect(LvlUpButton, Color3.fromRGB(120, 220, 180))

-- Buy Pet Function
local function buyPet()
    local args = {
        "\229\141\135\231\186\167\229\174\160\231\137\169"
    }
    remoteEvent:FireServer(unpack(args))
    
    -- Brief feedback animation
    BuyPetButton.Text = "PURCHASED!"
    task.wait(0.5)
    BuyPetButton.Text = "BUY PET"
end

-- Level Up Token Function
local function levelUpToken()
    local args = {
        "LvlUp_Tokens"
    }
    remoteEvent:FireServer(unpack(args))
    
    -- Brief feedback animation
    LvlUpButton.Text = "UPGRADED!"
    task.wait(0.5)
    LvlUpButton.Text = "LVL UP TOKEN"
end

-- Connect Buttons
BuyPetButton.MouseButton1Click:Connect(buyPet)
LvlUpButton.MouseButton1Click:Connect(levelUpToken)
-- Remote Event
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")

-- Wing IDs
local currentWingId = 13001
local maxWingId = 13010

-- Create GUI
local WingGUI = Instance.new("ScreenGui")
WingGUI.Name = "WingUpgradeGUI"
WingGUI.Parent = playerGui
WingGUI.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0, 20, 0.5, -65)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.4
MainFrame.Parent = WingGUI
MainFrame.Draggable = true
MainFrame.Active = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "WING UPGRADE"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.Parent = MainFrame

-- Current Wing Display
local WingDisplay = Instance.new("TextLabel")
WingDisplay.Size = UDim2.new(1, -20, 0, 20)
WingDisplay.Position = UDim2.new(0, 10, 0, 30)
WingDisplay.Text = "Current: Wing "..(currentWingId-13000)
WingDisplay.TextColor3 = Color3.fromRGB(180, 180, 255)
WingDisplay.BackgroundTransparency = 1
WingDisplay.Font = Enum.Font.Gotham
WingDisplay.TextSize = 12
WingDisplay.Parent = MainFrame

-- Status Message
local StatusMessage = Instance.new("TextLabel")
StatusMessage.Size = UDim2.new(1, -20, 0, 20)
StatusMessage.Position = UDim2.new(0, 10, 0, 50)
StatusMessage.Text = "Ready to upgrade"
StatusMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusMessage.BackgroundTransparency = 1
StatusMessage.Font = Enum.Font.Gotham
StatusMessage.TextSize = 12
StatusMessage.Parent = MainFrame

-- Upgrade Button
local UpgradeButton = Instance.new("TextButton")
UpgradeButton.Size = UDim2.new(0, 180, 0, 35)
UpgradeButton.Position = UDim2.new(0.5, -90, 0, 75)
UpgradeButton.Text = "UPGRADE WING"
UpgradeButton.TextColor3 = Color3.new(1, 1, 1)
UpgradeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
UpgradeButton.BackgroundTransparency = 0.3
UpgradeButton.Font = Enum.Font.GothamMedium
UpgradeButton.TextSize = 13
UpgradeButton.Parent = MainFrame

-- Add rounded corners to button
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = UpgradeButton

-- Add subtle stroke
local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(150, 150, 255)
ButtonStroke.Thickness = 1
ButtonStroke.Parent = UpgradeButton

-- Button Hover Effect
UpgradeButton.MouseEnter:Connect(function()
    UpgradeButton.BackgroundTransparency = 0.2
    ButtonStroke.Color = Color3.fromRGB(180, 180, 255)
end)

UpgradeButton.MouseLeave:Connect(function()
    UpgradeButton.BackgroundTransparency = 0.3
    ButtonStroke.Color = Color3.fromRGB(150, 150, 255)
end)

-- Upgrade Function with Error Handling
local function upgradeWing()
    if currentWingId > maxWingId then
        UpgradeButton.Text = "MAX LEVEL REACHED"
        StatusMessage.Text = "You have the highest level wing"
        StatusMessage.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold color
        task.wait(1)
        UpgradeButton.Text = "UPGRADE WING"
        return
    end
    
    -- Visual feedback
    UpgradeButton.Text = "PROCESSING..."
    StatusMessage.Text = "Upgrading..."
    StatusMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    local args = {
        "BuyWing",
        currentWingId
    }
    
    -- Try to upgrade with error handling
    local success, errorMessage = pcall(function()
        remoteEvent:FireServer(unpack(args))
    end)
    
    if success then
        -- Success case
        StatusMessage.Text = "Upgrade successful!"
        StatusMessage.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Move to next wing
        currentWingId = currentWingId + 1
        WingDisplay.Text = "Current: Wing "..(currentWingId-13000)
        
        -- Check if reached max level
        if currentWingId > maxWingId then
            UpgradeButton.Text = "MAX LEVEL REACHED"
            StatusMessage.Text = "You've unlocked all wings!"
            StatusMessage.TextColor3 = Color3.fromRGB(255, 215, 0)
        else
            UpgradeButton.Text = "UPGRADE WING"
        end
    else
        -- Failure case (likely not enough coins)
        StatusMessage.Text = "Failed: "..tostring(errorMessage)
        StatusMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
        UpgradeButton.Text = "TRY AGAIN"
        
        -- Flash button red to indicate error
        local originalColor = UpgradeButton.BackgroundColor3
        UpgradeButton.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
        task.wait(0.3)
        UpgradeButton.BackgroundColor3 = originalColor
    end
    
    -- Reset button after delay
    task.wait(1)
    if currentWingId <= maxWingId and UpgradeButton.Text ~= "TRY AGAIN" then
        UpgradeButton.Text = "UPGRADE WING"
        StatusMessage.Text = "Ready to upgrade"
        StatusMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Connect Button
UpgradeButton.MouseButton1Click:Connect(upgradeWing)
