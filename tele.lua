-- Tele GUI (persist across respawn)
-- Lokasi penempatan ideal: StarterPlayerScripts atau dijalankan sebagai LocalScript

-- ==== Player / GUI bootstrap ====
local Players = game:GetService("Players")
local player  = Players.LocalPlayer
local pg      = player:WaitForChild("PlayerGui")

local GUI_NAME = "TeleGUI"

-- Reuse if exists to avoid duplicates on respawn
local ScreenGui = pg:FindFirstChild(GUI_NAME)
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GUI_NAME
    ScreenGui.Parent = pg
end

-- **Persist after respawn**
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder    = 9999 -- top layer

-- If already initialized in a previous spawn, do nothing
if ScreenGui:GetAttribute("Initialized") then
    return
end
ScreenGui:SetAttribute("Initialized", true)

-- ==== UI Elements ====
local Frame           = Instance.new("Frame")
local XBox            = Instance.new("TextBox")
local TeleportButton  = Instance.new("TextButton")
local ReturnButton    = Instance.new("TextButton")
local LokasiButton    = Instance.new("TextButton")
local CloseButton     = Instance.new("TextButton")
local MinimizeButton  = Instance.new("TextButton")
local BookmarkBox     = Instance.new("TextBox")
local SaveButton      = Instance.new("TextButton")
local BookmarkList    = Instance.new("Frame")
local Layout          = Instance.new("UIListLayout")

local isMinimized     = false
local originalPositionVec3 = nil
local originalFrameSize
local bookmarks       = {}

-- ==== Styling helper ====
local function styleElement(el)
    el.BackgroundTransparency = 0.5
    el.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    if el:IsA("TextBox") or el:IsA("TextButton") then
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    el.BorderSizePixel = 0
end

-- ==== Main frame ====
Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 240, 0, 340)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundTransparency = 0.4  -- sesuai preferensi transparansi frame
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true  -- draggable

-- ==== Title bar (dengan tombol close/minimize di top-layer) ====
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundTransparency = 0.2 -- title transparansi 0.2
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Text = "Teleport Tool"
TitleText.TextColor3 = Color3.fromRGB(255,255,255)

-- Close (merah), Minimize (hijau 0.5)
CloseButton.Parent = TitleBar
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -26, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 0, 0) -- merah
CloseButton.BackgroundTransparency = 0
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = true

MinimizeButton.Parent = TitleBar
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
MinimizeButton.Position = UDim2.new(1, -52, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- hijau
MinimizeButton.BackgroundTransparency = 0.5
MinimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.AutoButtonColor = true

-- ==== Input Koordinat ====
XBox.Parent = Frame
XBox.PlaceholderText = "X,Y,Z"
XBox.Position = UDim2.new(0, 10, 0, 38)
XBox.Size = UDim2.new(0, 220, 0, 28)
styleElement(XBox)
XBox.BackgroundTransparency = 0.2 -- text box transparansi 0.2

-- ==== Tombol biru ====
local function styleBlueButton(btn)
    styleElement(btn)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- biru
end

-- Teleport
TeleportButton.Parent = Frame
TeleportButton.Text = "Teleport"
TeleportButton.Position = UDim2.new(0, 10, 0, 72)
TeleportButton.Size = UDim2.new(0, 70, 0, 28)
styleBlueButton(TeleportButton)

-- Kembali
ReturnButton.Parent = Frame
ReturnButton.Text = "Kembali"
ReturnButton.Position = UDim2.new(0, 90, 0, 72)
ReturnButton.Size = UDim2.new(0, 70, 0, 28)
styleBlueButton(ReturnButton)

-- Get Loc
LokasiButton.Parent = Frame
LokasiButton.Text = "GetLoc"
LokasiButton.Position = UDim2.new(0, 170, 0, 72)
LokasiButton.Size = UDim2.new(0, 60, 0, 28)
styleBlueButton(LokasiButton)

-- Input nama bookmark
BookmarkBox.Parent = Frame
BookmarkBox.PlaceholderText = "Nama lokasi"
BookmarkBox.Position = UDim2.new(0, 10, 0, 108)
BookmarkBox.Size = UDim2.new(0, 150, 0, 28)
styleElement(BookmarkBox)
BookmarkBox.BackgroundTransparency = 0.2

-- Simpan bookmark
SaveButton.Parent = Frame
SaveButton.Text = "Simpan"
SaveButton.Position = UDim2.new(0, 170, 0, 108)
SaveButton.Size = UDim2.new(0, 60, 0, 28)
styleBlueButton(SaveButton)

-- Daftar bookmark
BookmarkList.Parent = Frame
BookmarkList.Position = UDim2.new(0, 10, 0, 144)
BookmarkList.Size = UDim2.new(0, 220, 0, 186)
BookmarkList.BackgroundTransparency = 0.5
BookmarkList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

Layout.Parent = BookmarkList
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 4)

-- ==== Minimize logic ====
originalFrameSize = Frame.Size
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        for _, child in ipairs(Frame:GetChildren()) do
            if child ~= TitleBar then
                child.Visible = false
            end
        end
        Frame.Size = UDim2.new(originalFrameSize.X.Scale, originalFrameSize.X.Offset, 0, 28)
    else
        for _, child in ipairs(Frame:GetChildren()) do
            child.Visible = true
        end
        Frame.Size = originalFrameSize
    end
end)

-- Close (destroy GUI sepenuhnya)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==== Util ====
local function parseCoordinates(input)
    local parts = string.split((input or ""), ",")
    if #parts == 3 then
        local x = tonumber(parts[1])
        local y = tonumber(parts[2])
        local z = tonumber(parts[3])
        if x and y and z then
            return Vector3.new(x, y, z)
        end
    end
    return nil
end

local function getCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    return character
end

-- ==== Actions ====
TeleportButton.MouseButton1Click:Connect(function()
    local coords = parseCoordinates(XBox.Text)
    if not coords then return end
    local character = getCharacter()
    if character and character.PrimaryPart then
        originalPositionVec3 = character.PrimaryPart.Position
        character:SetPrimaryPartCFrame(CFrame.new(coords))
    end
end)

ReturnButton.MouseButton1Click:Connect(function()
    if not originalPositionVec3 then return end
    local character = getCharacter()
    if character and character.PrimaryPart then
        character:SetPrimaryPartCFrame(CFrame.new(originalPositionVec3))
    end
end)

LokasiButton.MouseButton1Click:Connect(function()
    local character = getCharacter()
    if character and character.PrimaryPart then
        local pos = character.PrimaryPart.Position
        local formatted = string.format("%d,%d,%d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
        XBox.Text = formatted
        if setclipboard then
            setclipboard(formatted)
        end
    end
end)

SaveButton.MouseButton1Click:Connect(function()
    local name = (BookmarkBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local coords = parseCoordinates(XBox.Text)
    if name ~= "" and coords then
        bookmarks[name] = coords

        local b = Instance.new("TextButton")
        b.Text = name
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundTransparency = 0.4
        b.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- tombol biru agar konsisten
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.BorderSizePixel = 0
        b.Parent = BookmarkList

        b.MouseButton1Click:Connect(function()
            local character = getCharacter()
            if character and character.PrimaryPart then
                character:SetPrimaryPartCFrame(CFrame.new(coords))
            end
            local formatted = string.format("%d,%d,%d", math.floor(coords.X), math.floor(coords.Y), math.floor(coords.Z))
            XBox.Text = formatted
            if setclipboard then setclipboard(formatted) end
        end)

        BookmarkBox.Text = ""
        XBox.Text = ""
    end
end)
