-- GUI Master untuk Executor Delta (Roblox Lua)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MasterGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Sidebar + Content)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = ScreenGui

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 80, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Sidebar

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Position = UDim2.new(0, 80, 0, 0)
ContentFrame.Size = UDim2.new(1, -80, 1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
ContentFrame.Parent = MainFrame

-- Default Content
local DefaultLabel = Instance.new("TextLabel")
DefaultLabel.Name = "DefaultLabel"
DefaultLabel.Size = UDim2.new(1, 0, 1, 0)
DefaultLabel.Text = "Pilih menu dari sidebar"
DefaultLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
DefaultLabel.BackgroundTransparency = 1
DefaultLabel.Font = Enum.Font.SourceSansBold
DefaultLabel.TextSize = 24
DefaultLabel.Parent = ContentFrame

-- Create 6 buttons
local buttonContents = {
    "Ini adalah konten untuk Menu 1\n\nAnda memilih menu pertama",
    "Ini adalah konten untuk Menu 2\n\nFitur kedua tersedia di sini",
    "Ini adalah konten untuk Menu 3\n\nMenu ketiga dipilih",
    "Ini adalah konten untuk Menu 4\n\nIni adalah menu keempat",
    "Ini adalah konten untuk Menu 5\n\nMenu lima aktif",
    "Ini adalah konten untuk Menu 6\n\nMenu terakhir dipilih"
}

for i = 1, 6 do
    local Button = Instance.new("TextButton")
    Button.Name = "MenuButton"..i
    Button.Size = UDim2.new(1, -20, 0, 50)
    Button.Position = UDim2.new(0, 10, 0, 10 + (i-1)*60)
    Button.Text = "Menu "..i
    Button.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 14
    Button.Parent = Sidebar
    
    -- Button hover effects
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
    end)
    
    -- Button click action
    Button.MouseButton1Click:Connect(function()
        -- Clear previous content
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child.Name ~= "DefaultLabel" then
                child:Destroy()
            end
        end
        
        DefaultLabel.Visible = false
        
        -- Create new content
        local ContentText = Instance.new("TextLabel")
        ContentText.Name = "ContentText"
        ContentText.Size = UDim2.new(1, -100, 1, -100)
        ContentText.Position = UDim2.new(0, 50, 0, 50)
        ContentText.Text = buttonContents[i]
        ContentText.TextColor3 = Color3.fromRGB(0, 0, 0)
        ContentText.BackgroundTransparency = 1
        ContentText.TextXAlignment = Enum.TextXAlignment.Left
        ContentText.TextYAlignment = Enum.TextYAlignment.Top
        ContentText.Font = Enum.Font.SourceSans
        ContentText.TextSize = 18
        ContentText.Parent = ContentFrame
        
        -- Add some example widgets based on menu
        if i == 1 then
            local ExampleButton = Instance.new("TextButton")
            ExampleButton.Text = "Contoh Tombol"
            ExampleButton.Size = UDim2.new(0, 150, 0, 40)
            ExampleButton.Position = UDim2.new(0, 50, 0, 150)
            ExampleButton.Parent = ContentFrame
        elseif i == 2 then
            local ProgressBar = Instance.new("Frame")
            ProgressBar.Name = "ProgressBar"
            ProgressBar.Size = UDim2.new(0.5, 0, 0, 20)
            ProgressBar.Position = UDim2.new(0, 50, 0, 150)
            ProgressBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ProgressBar.Parent = ContentFrame
            
            local ProgressFill = Instance.new("Frame")
            ProgressFill.Name = "ProgressFill"
            ProgressFill.Size = UDim2.new(0.5, 0, 1, 0)
            ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            ProgressFill.Parent = ProgressBar
        end
    end)
end