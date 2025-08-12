-- Buat GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local XBox = Instance.new("TextBox")
local TeleportButton = Instance.new("TextButton")
local ReturnButton = Instance.new("TextButton")
local LokasiButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local BookmarkBox = Instance.new("TextBox")
local SaveButton = Instance.new("TextButton")
local BookmarkList = Instance.new("Frame")
local Layout = Instance.new("UIListLayout")
local isMinimized = false
local originalPosition = nil
local bookmarks = {}

-- Styling Transparan
local function styleElement(el)
    el.BackgroundTransparency = 0.7
    el.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    el.TextColor3 = Color3.fromRGB(255, 255, 255)
    el.BorderSizePixel = 0
end

-- GUI Parent
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 240, 0, 340)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundTransparency = 0.5
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

-- TextBox Koordinat
XBox.Parent = Frame
XBox.PlaceholderText = "X,Y,Z"
XBox.Position = UDim2.new(0, 10, 0, 30)
XBox.Size = UDim2.new(0, 220, 0, 25)
styleElement(XBox)

-- Tombol Teleport
TeleportButton.Parent = Frame
TeleportButton.Text = "Teleport"
TeleportButton.Position = UDim2.new(0, 10, 0, 60)
TeleportButton.Size = UDim2.new(0, 70, 0, 25)
styleElement(TeleportButton)

-- Tombol Kembali
ReturnButton.Parent = Frame
ReturnButton.Text = "Kembali"
ReturnButton.Position = UDim2.new(0, 90, 0, 60)
ReturnButton.Size = UDim2.new(0, 70, 0, 25)
styleElement(ReturnButton)

-- Tombol Lokasi Sekarang
LokasiButton.Parent = Frame
LokasiButton.Text = "GetLoc"
LokasiButton.Position = UDim2.new(0, 170, 0, 60)
LokasiButton.Size = UDim2.new(0, 60, 0, 25)
styleElement(LokasiButton)

-- Input Nama Bookmark
BookmarkBox.Parent = Frame
BookmarkBox.PlaceholderText = "Nama lokasi"
BookmarkBox.Position = UDim2.new(0, 10, 0, 95)
BookmarkBox.Size = UDim2.new(0, 150, 0, 25)
styleElement(BookmarkBox)

-- Tombol Simpan
SaveButton.Parent = Frame
SaveButton.Text = "Simpan"
SaveButton.Position = UDim2.new(0, 170, 0, 95)
SaveButton.Size = UDim2.new(0, 60, 0, 25)
styleElement(SaveButton)

-- Daftar Bookmark
BookmarkList.Parent = Frame
BookmarkList.Position = UDim2.new(0, 10, 0, 130)
BookmarkList.Size = UDim2.new(0, 220, 0, 160)
BookmarkList.BackgroundTransparency = 0.7
BookmarkList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Layout.Parent = BookmarkList
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tombol Close
CloseButton.Parent = Frame
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
styleElement(CloseButton)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tombol Minimize
MinimizeButton.Parent = Frame
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
styleElement(MinimizeButton)

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, child in pairs(Frame:GetChildren()) do
        if child:IsA("TextBox") or child:IsA("TextButton") or child:IsA("Frame") then
            if child ~= MinimizeButton and child ~= CloseButton then
                child.Visible = not isMinimized
            end
        end
    end
end)

-- Parsing input koordinat
local function parseCoordinates(input)
    local coords = string.split(input, ",")
    if #coords == 3 then
        local x = tonumber(coords[1])
        local y = tonumber(coords[2])
        local z = tonumber(coords[3])
        if x and y and z then
            return Vector3.new(x, y, z)
        end
    end
    return nil
end

-- Fungsi Teleport
TeleportButton.MouseButton1Click:Connect(function()
    local coords = parseCoordinates(XBox.Text)
    if coords then
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        if character.PrimaryPart then
            originalPosition = character.PrimaryPart.Position
            character:SetPrimaryPartCFrame(CFrame.new(coords))
        end
    end
end)

-- Fungsi Kembali
ReturnButton.MouseButton1Click:Connect(function()
    if originalPosition then
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        if character.PrimaryPart then
            character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
        end
    end
end)

-- Fungsi Lokasi Sekarang + clipboard
LokasiButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if character.PrimaryPart then
        local pos = character.PrimaryPart.Position
        local formatted = string.format("%d,%d,%d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
        XBox.Text = formatted
        if setclipboard then setclipboard(formatted) end
    end
end)

-- Fungsi Simpan Bookmark
SaveButton.MouseButton1Click:Connect(function()
    local name = BookmarkBox.Text
    local coords = parseCoordinates(XBox.Text)
    if name ~= "" and coords then
        bookmarks[name] = coords
        local button = Instance.new("TextButton")
        button.Text = name
        button.Size = UDim2.new(1, 0, 0, 25)
        button.BackgroundTransparency = 0.6
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.TextColor3 = Color3.fromRGB(255,255,255)
        button.Parent = BookmarkList

        button.MouseButton1Click:Connect(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            if character.PrimaryPart then
                character:SetPrimaryPartCFrame(CFrame.new(coords))
            end
            -- Isi ke textbox & salin ke clipboard
            local formatted = string.format("%d,%d,%d", math.floor(coords.X), math.floor(coords.Y), math.floor(coords.Z))
            XBox.Text = formatted
            if setclipboard then setclipboard(formatted) end
        end)

        BookmarkBox.Text = ""
        XBox.Text = ""
    end
end)
