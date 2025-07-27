--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// State tracking
local jumpID = nil
local landingID = nil
local isReady = false

--// GUI
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "CoinClaimerGUI"
MainFrame.Parent = playerGui
MainFrame.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 180)
Frame.Position = UDim2.new(0.5, -100, 0.5, -90)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.BackgroundTransparency = 0.3
Frame.Parent = MainFrame
Frame.Draggable = true
Frame.Active = true

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 15
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 20)
CloseButton.Position = UDim2.new(0.7, -20, 0.05, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 15
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Frame

local StartStopButton = Instance.new("TextButton")
StartStopButton.Size = UDim2.new(0, 180, 0, 30)
StartStopButton.Position = UDim2.new(0.5, -90, 0.8, 0)
StartStopButton.Text = "Start"
StartStopButton.Font = Enum.Font.SourceSansBold
StartStopButton.TextSize = 20
StartStopButton.BackgroundColor3 = Color3.new(0, 0.7, 0)
StartStopButton.BorderSizePixel = 0
StartStopButton.Parent = Frame
StartStopButton.Active = false
StartStopButton.Selectable = false

local HeightLabel = Instance.new("TextLabel")
HeightLabel.Size = UDim2.new(0, 70, 0, 15)
HeightLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
HeightLabel.Text = "Height:"
HeightLabel.BackgroundColor3 = Color3.new(1, 1, 1)
HeightLabel.BackgroundTransparency = 1
HeightLabel.Parent = Frame

local HeightTextBox = Instance.new("TextBox")
HeightTextBox.Size = UDim2.new(0, 100, 0, 20)
HeightTextBox.Position = UDim2.new(0.4, 0, 0.3, 0)
HeightTextBox.Text = "6000"
HeightTextBox.BorderSizePixel = 0
HeightTextBox.Parent = Frame

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(0, 70, 0, 15)
DelayLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
DelayLabel.Text = "Int. Delay:"
DelayLabel.BackgroundColor3 = Color3.new(1, 1, 1)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Parent = Frame

local DelayTextBox = Instance.new("TextBox")
DelayTextBox.Size = UDim2.new(0, 100, 0, 20)
DelayTextBox.Position = UDim2.new(0.4, 0, 0.45, 0)
DelayTextBox.Text = "3"
DelayTextBox.BorderSizePixel = 0
DelayTextBox.Parent = Frame

--// Status Text (centered)
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 180, 0, 20)
StatusText.Position = UDim2.new(0.5, -90, 0.62, 0)
StatusText.Text = "JUMP FROM THE TOWER FIRST!"
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.new(1,1,1)
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.Font = Enum.Font.SourceSans
StatusText.TextSize = 14
StatusText.Parent = Frame

--// Functions
local function SendJumpData()
	local height = tonumber(HeightTextBox.Text)
	if jumpID and height then
		local args = {
			"JumpResults",
			jumpID,
			height
		}
		ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
	end
end

local function SendLandingData()
	if landingID then
		local args = {
			"LandingResults",
			landingID
		}
		ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
	end
end

--// Main Loop
local running = false
local coroutineLoop
local loopDelay = 0.2
local runTime = 0
local pauseInterval = 10 * 60
local pauseDuration = 30

local function RunLoop()
	while running do
		local internalDelay = tonumber(DelayTextBox.Text) or 3
		local startTime = os.clock()

		SendJumpData()
		wait(internalDelay)
		SendLandingData()

		local elapsedTime = os.clock() - startTime
		local remainingDelay = loopDelay - elapsedTime
		if remainingDelay > 0 then
			wait(remainingDelay)
		end

		runTime = runTime + elapsedTime + internalDelay
		if runTime >= pauseInterval then
			running = false
			print("Pausing for " .. pauseDuration .. " seconds...")
			wait(pauseDuration)
			runTime = 0
			running = true
		end
	end
end

--// Button Events
StartStopButton.MouseButton1Click:Connect(function()
	if isReady then
		running = not running
		if running then
			StartStopButton.Text = "Stop"
			StartStopButton.BackgroundColor3 = Color3.new(0.7, 0, 0)
			coroutineLoop = coroutine.wrap(RunLoop)
			coroutineLoop()
		else
			StartStopButton.Text = "Start"
			StartStopButton.BackgroundColor3 = Color3.new(0, 0.7, 0)
		end
	else
		warn("Wait for Jump & Landing IDs first.")
	end
end)

MinimizeButton.MouseButton1Click:Connect(function()
	local minimized = Frame.Size == UDim2.new(0, 70, 0, 20)
	if minimized then
		Frame.Size = UDim2.new(0, 200, 0, 180)
		MinimizeButton.Text = "-"
		MinimizeButton.Position = UDim2.new(0.7, -20, 0.05, 0)
		CloseButton.Position = UDim2.new(0.85, -20, 0.05, 0)
		for _, child in pairs(Frame:GetChildren()) do
			if child ~= MinimizeButton and child ~= CloseButton then
				child.Visible = true
			end
		end
	else
		Frame.Size = UDim2.new(0, 70, 0, 20)
		MinimizeButton.Text = "+"
		MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
		CloseButton.Position = UDim2.new(0.35, 0, 0, 0)
		for _, child in pairs(Frame:GetChildren()) do
			if child ~= MinimizeButton and child ~= CloseButton then
				child.Visible = false
			end
		end
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	MainFrame:Destroy()
end)

--// Status Update
local function UpdateStatus()
	if jumpID and landingID then
		StatusText.Text = "PRESS START TO CONTINUE!"
		isReady = true
		StartStopButton.Active = true
		StartStopButton.Selectable = true
	else
		StatusText.Text = "JUMP FROM THE TOWER FIRST!"
		isReady = false
		StartStopButton.Active = false
		StartStopButton.Selectable = false
	end
end

--// Remote Event Hook
local remoteEvent = ReplicatedStorage:WaitForChild("ProMgs"):WaitForChild("RemoteEvent")
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local args = { ... }
	local method = getnamecallmethod()

	if self == remoteEvent and method == "FireServer" then
		if args[1] == "JumpResults" and typeof(args[2]) == "number" then
			jumpID = args[2]
			warn("Jump ID captured:", jumpID)
			UpdateStatus()
		elseif args[1] == "LandingResults" and typeof(args[2]) == "number" then
			landingID = args[2]
			warn("Landing ID captured:", landingID)
			UpdateStatus()
		end
	end

	return oldNamecall(self, ...)
end)

print("GUI ready. Wait for status message, then GO!")