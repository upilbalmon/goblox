-- Roblox RemoteEvent GUI + drag support
-- Letakkan di StarterPlayerScripts

local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = replicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent")

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRemoteEventGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 110)
frame.Position = UDim2.new(0, 30, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true -- penting untuk draggable
frame.Draggable = true -- untuk engine lama, tetap diset
frame.Parent = screenGui

local delayBox = Instance.new("TextBox")
delayBox.Name = "DelayBox"
delayBox.Size = UDim2.new(0, 60, 0, 30)
delayBox.Position = UDim2.new(0, 10, 0, 10)
delayBox.Text = "1"
delayBox.PlaceholderText = "Delay"
delayBox.TextColor3 = Color3.fromRGB(0,0,0)
delayBox.BackgroundColor3 = Color3.fromRGB(220,220,220)
delayBox.Parent = frame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 50, 0, 30)
delayLabel.Position = UDim2.new(0, 75, 0, 10)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Detik"
delayLabel.TextColor3 = Color3.fromRGB(255,255,255)
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = frame

local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(0, 100, 0, 32)
startButton.Position = UDim2.new(0, 10, 0, 50)
startButton.Text = "Start"
startButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
startButton.TextColor3 = Color3.fromRGB(255,255,255)
startButton.Parent = frame

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0, 100, 0, 32)
stopButton.Position = UDim2.new(0, 120, 0, 50)
stopButton.Text = "Stop"
stopButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
stopButton.TextColor3 = Color3.fromRGB(255,255,255)
stopButton.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 240, 0, 20)
infoLabel.Position = UDim2.new(0, 10, 0, 90)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Masukkan delay, klik Start!"
infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 16
infoLabel.Parent = frame

-- Tampilkan GUI ke player
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Logic loop
local running = { value = false }
local defaultDelay = 1

local function sendRemoteEvents()
    remoteEvent:FireServer("JumpResults", 1407123799460, 5811.33984375)
    remoteEvent:FireServer("LandingResults", 4212835749741)
end

local function repeatEvents()
    running.value = true
    infoLabel.Text = "Berjalan..."
    while running.value do
        sendRemoteEvents()
        local delayTime = tonumber(delayBox.Text) or defaultDelay
        task.wait(math.max(delayTime, 0.1))
    end
    infoLabel.Text = "Dihentikan."
end

startButton.MouseButton1Click:Connect(function()
    if not running.value then
        coroutine.wrap(repeatEvents)()
    end
end)

stopButton.MouseButton1Click:Connect(function()
    running.value = false
end)

delayBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = delayBox.Text
    if text ~= "" and not text:match("^%d*%.?%d*$") then
        delayBox.Text = text:match("[0-9%.]*") or ""
    end
end)

-- Fungsi draggable custom (untuk compatibility engine baru)
-- Kode ini membuat frame bisa digeser oleh mouse
do
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end