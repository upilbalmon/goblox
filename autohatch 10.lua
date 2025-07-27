--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Variabel
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "DrawHeroLoopGUI"
MainFrame.Parent = playerGui
MainFrame.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Parent = MainFrame
Frame.Draggable = true
Frame.Active = true

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 10, 0, 10)
MinimizeButton.Position = UDim2.new(0.7, -20, 0.1, 0)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 7
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
MinimizeButton.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 10, 0, 10)
CloseButton.Position = UDim2.new(0.85, -20, 0.1, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 7
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
CloseButton.Parent = Frame

local StartStopButton = Instance.new("TextButton")
StartStopButton.Size = UDim2.new(0, 70, 0, 21)
StartStopButton.Position = UDim2.new(0.5, -35, 0.5, -10)
StartStopButton.Text = "Start"
StartStopButton.BackgroundColor3 = Color3.new(0, 0.7, 0)
StartStopButton.Parent = Frame

--// Variabel untuk mengontrol loop
local running = false
local coroutineLoop
local minimized = false
local originalSize = Frame.Size
local minimizedSize = UDim2.new(0, 70, 0, 20)

--// Fungsi untuk menjalankan loop
local function DrawHeroFunction()
    local args = {
        7000030,
        10
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero"):InvokeServer(unpack(args))
end

local function RunLoop()
    while running do
        DrawHeroFunction()
        wait(1) -- Delay 1 detik
    end
end

--// Fungsi untuk tombol Start/Stop
StartStopButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        StartStopButton.Text = "Stop"
        StartStopButton.BackgroundColor3 = Color3.new(0.7, 0, 0)
        coroutineLoop = coroutine.wrap(RunLoop)
        coroutineLoop()
    else
        StartStopButton.Text = "Start"
        StartStopButton.BackgroundColor3 = Color3.new(0, 0.7, 0)
        -- Tidak perlu menghentikan coroutine secara paksa, cukup set running ke false
    end
end)

--// Fungsi untuk tombol Minimize/Maximize
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame.Size = minimizedSize
        MinimizeButton.Text = "+"
		StartStopButton.Visible = false
    else
        Frame.Size = originalSize
        MinimizeButton.Text = "-"
		StartStopButton.Visible = true
    end
end)

--// Fungsi untuk tombol Close
CloseButton.MouseButton1Click:Connect(function()
    MainFrame:Destroy()
end)