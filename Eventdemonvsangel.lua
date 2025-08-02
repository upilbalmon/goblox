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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(0, 10, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = PetGUI
MainFrame.Draggable = true
MainFrame.Active = true

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "PET SHOP"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- Buy Pet Button
local BuyPetButton = Instance.new("TextButton")
BuyPetButton.Size = UDim2.new(0, 180, 0, 40)
BuyPetButton.Position = UDim2.new(0.5, -90, 0, 30)
BuyPetButton.Text = "BUY PET"
BuyPetButton.TextColor3 = Color3.new(1, 1, 1)
BuyPetButton.BackgroundColor3 = Color3.fromRGB(80, 30, 130)
BuyPetButton.Font = Enum.Font.GothamBold
BuyPetButton.TextSize = 14
BuyPetButton.Parent = MainFrame

-- Level Up Token Button
local LvlUpButton = Instance.new("TextButton")
LvlUpButton.Size = UDim2.new(0, 180, 0, 40)
LvlUpButton.Position = UDim2.new(0.5, -90, 0, 75)
LvlUpButton.Text = "LVL UP TOKEN"
LvlUpButton.TextColor3 = Color3.new(1, 1, 1)
LvlUpButton.BackgroundColor3 = Color3.fromRGB(30, 130, 80)
LvlUpButton.Font = Enum.Font.GothamBold
LvlUpButton.TextSize = 14
LvlUpButton.Parent = MainFrame

-- Buy Pet Function
local function buyPet()
    local args = {
        "\229\141\135\231\186\167\229\174\160\231\137\169"
    }
    remoteEvent:FireServer(unpack(args))
end

-- Level Up Token Function
local function levelUpToken()
    local args = {
        "LvlUp_Tokens"
    }
    remoteEvent:FireServer(unpack(args))
end

-- Connect Buttons
BuyPetButton.MouseButton1Click:Connect(buyPet)
LvlUpButton.MouseButton1Click:Connect(levelUpToken)
