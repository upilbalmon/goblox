local ArcvourHUB = {}

-- Fungsi untuk membuat window utama
function ArcvourHUB:CreateWindow(title)
    local library = {}
    local mainWindow = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local categoryLabel = Instance.new("TextLabel")
    local tabButtonsFrame = Instance.new("Frame")
    local contentFrame = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    
    -- Konfigurasi ScreenGui
    mainWindow.Name = "ArcvourHUB"
    mainWindow.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainWindow.DisplayOrder = 999
    mainWindow.Parent = game:GetService("CoreGui")
    
    -- Konfigurasi Main Frame
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    mainFrame.Size = UDim2.new(0, 300, 0, 350)
    mainFrame.Parent = mainWindow
    
    -- Konfigurasi Title Label
    titleLabel.Name = "TitleLabel"
    titleLabel.Text = title or "ArcvourHUB (PREMIUM)"
    titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleLabel.BorderSizePixel = 0
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Parent = mainFrame
    
    -- Konfigurasi Category Label
    categoryLabel.Name = "CategoryLabel"
    categoryLabel.Text = "Farming"
    categoryLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    categoryLabel.BorderSizePixel = 0
    categoryLabel.Position = UDim2.new(0, 0, 0, 30)
    categoryLabel.Size = UDim2.new(1, 0, 0, 20)
    categoryLabel.Font = Enum.Font.Gotham
    categoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    categoryLabel.TextSize = 12
    categoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    categoryLabel.Parent = mainFrame
    
    -- Konfigurasi Tab Buttons Frame
    tabButtonsFrame.Name = "TabButtonsFrame"
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 50)
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 150)
    tabButtonsFrame.Parent = mainFrame
    
    -- Konfigurasi UIListLayout untuk tab buttons
    UIListLayout.Parent = tabButtonsFrame
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    -- Konfigurasi Content Frame
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.Position = UDim2.new(0, 0, 0, 210)
    contentFrame.Size = UDim2.new(1, 0, 0, 140)
    contentFrame.Parent = mainFrame
    
    -- Fungsi untuk membuat tab button
    function library:CreateTabButton(name, isChecked)
        local tabButton = Instance.new("TextButton")
        local checkBox = Instance.new("Frame")
        local checkMark = Instance.new("TextLabel")
        
        -- Konfigurasi Tab Button
        tabButton.Name = name .. "TabButton"
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(0.9, 0, 0, 25)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = "  " .. name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 12
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = tabButtonsFrame
        
        -- Konfigurasi Checkbox
        checkBox.Name = "CheckBox"
        checkBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        checkBox.BorderSizePixel = 0
        checkBox.Position = UDim2.new(0.85, 0, 0.2, 0)
        checkBox.Size = UDim2.new(0, 16, 0, 16)
        checkBox.Parent = tabButton
        
        -- Konfigurasi Checkmark
        checkMark.Name = "CheckMark"
        checkMark.BackgroundTransparency = 1
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.Font = Enum.Font.GothamBold
        checkMark.Text = isChecked and "X" or ""
        checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
        checkMark.TextSize = 12
        checkMark.Parent = checkBox
        
        -- Toggle functionality
        tabButton.MouseButton1Click:Connect(function()
            isChecked = not isChecked
            checkMark.Text = isChecked and "X" or ""
        end)
        
        return tabButton
    end
    
    -- Fungsi untuk membuat content section
    function library:CreateContentSection(title)
        local contentSection = Instance.new("Frame")
        local sectionTitle = Instance.new("TextLabel")
        local sectionContent = Instance.new("Frame")
        
        -- Konfigurasi Content Section
        contentSection.Name = title .. "Section"
        contentSection.BackgroundTransparency = 1
        contentSection.Size = UDim2.new(1, 0, 1, 0)
        contentSection.Visible = false
        contentSection.Parent = contentFrame
        
        -- Konfigurasi Section Title
        sectionTitle.Name = "SectionTitle"
        sectionTitle.Text = title
        sectionTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        sectionTitle.BorderSizePixel = 0
        sectionTitle.Size = UDim2.new(1, 0, 0, 25)
        sectionTitle.Font = Enum.Font.Gotham
        sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionTitle.TextSize = 12
        sectionTitle.Parent = contentSection
        
        -- Konfigurasi Section Content
        sectionContent.Name = "SectionContent"
        sectionContent.BackgroundTransparency = 1
        sectionContent.Position = UDim2.new(0, 0, 0, 25)
        sectionContent.Size = UDim2.new(1, 0, 1, -25)
        sectionContent.Parent = contentSection
        
        -- Fungsi untuk menambahkan dropdown
        function contentSection:AddDropdown(optionName, options, defaultOption)
            local dropdown = Instance.new("TextButton")
            local dropdownList = Instance.new("Frame")
            local dropdownValue = Instance.new("TextLabel")
            
            -- Konfigurasi Dropdown Button
            dropdown.Name = optionName .. "Dropdown"
            dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            dropdown.BorderSizePixel = 0
            dropdown.Size = UDim2.new(0.9, 0, 0, 25)
            dropdown.Position = UDim2.new(0.05, 0, 0, 5)
            dropdown.Font = Enum.Font.Gotham
            dropdown.Text = optionName
            dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdown.TextSize = 12
            dropdown.Parent = sectionContent
            
            -- Konfigurasi Dropdown Value
            dropdownValue.Name = "DropdownValue"
            dropdownValue.BackgroundTransparency = 1
            dropdownValue.Position = UDim2.new(0.7, 0, 0, 0)
            dropdownValue.Size = UDim2.new(0.3, 0, 1, 0)
            dropdownValue.Font = Enum.Font.Gotham
            dropdownValue.Text = defaultOption or options[1]
            dropdownValue.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownValue.TextSize = 12
            dropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            dropdownValue.Parent = dropdown
            
            -- Konfigurasi Dropdown List (awalnya tersembunyi)
            dropdownList.Name = "DropdownList"
            dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownList.BorderSizePixel = 0
            dropdownList.Position = UDim2.new(0, 0, 1, 5)
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.ClipsDescendants = true
            dropdownList.Visible = false
            dropdownList.Parent = dropdown
            
            -- Toggle dropdown list
            local isOpen = false
            dropdown.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    dropdownList.Visible = true
                    dropdownList.Size = UDim2.new(1, 0, 0, #options * 25)
                else
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                    wait(0.2)
                    dropdownList.Visible = false
                end
            end)
            
            -- Tambahkan options ke dropdown
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                
                optionButton.Name = option .. "Option"
                optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                optionButton.BorderSizePixel = 0
                optionButton.Position = UDim2.new(0, 0, 0, (i-1)*25)
                optionButton.Size = UDim2.new(1, 0, 0, 25)
                optionButton.Font = Enum.Font.Gotham
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.TextSize = 12
                optionButton.Parent = dropdownList
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownValue.Text = option
                    isOpen = false
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                    wait(0.2)
                    dropdownList.Visible = false
                end)
            end
            
            return dropdown
        end
        
        -- Fungsi untuk menambahkan button
        function contentSection:AddButton(buttonName, callback)
            local button = Instance.new("TextButton")
            
            button.Name = buttonName .. "Button"
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.BorderSizePixel = 0
            button.Size = UDim2.new(0.9, 0, 0, 25)
            button.Position = UDim2.new(0.05, 0, 0, 5)
            button.Font = Enum.Font.Gotham
            button.Text = buttonName
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 12
            button.Parent = sectionContent
            
            button.MouseButton1Click:Connect(callback)
            
            return button
        end
        
        -- Fungsi untuk menambahkan toggle
        function contentSection:AddToggle(toggleName, isChecked, callback)
            local toggle = Instance.new("TextButton")
            local checkBox = Instance.new("Frame")
            local checkMark = Instance.new("TextLabel")
            
            -- Konfigurasi Toggle Button
            toggle.Name = toggleName .. "Toggle"
            toggle.BackgroundTransparency = 1
            toggle.Size = UDim2.new(0.9, 0, 0, 25)
            toggle.Position = UDim2.new(0.05, 0, 0, 5)
            toggle.Font = Enum.Font.Gotham
            toggle.Text = "  " .. toggleName
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.TextSize = 12
            toggle.TextXAlignment = Enum.TextXAlignment.Left
            toggle.Parent = sectionContent
            
            -- Konfigurasi Checkbox
            checkBox.Name = "CheckBox"
            checkBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            checkBox.BorderSizePixel = 0
            checkBox.Position = UDim2.new(0.85, 0, 0.2, 0)
            checkBox.Size = UDim2.new(0, 16, 0, 16)
            checkBox.Parent = toggle
            
            -- Konfigurasi Checkmark
            checkMark.Name = "CheckMark"
            checkMark.BackgroundTransparency = 1
            checkMark.Size = UDim2.new(1, 0, 1, 0)
            checkMark.Font = Enum.Font.GothamBold
            checkMark.Text = isChecked and "X" or ""
            checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
            checkMark.TextSize = 12
            checkMark.Parent = checkBox
            
            -- Toggle functionality
            toggle.MouseButton1Click:Connect(function()
                isChecked = not isChecked
                checkMark.Text = isChecked and "X" or ""
                if callback then callback(isChecked) end
            end)
            
            return toggle
        end
        
        return contentSection
    end
    
    -- Buat tab buttons sesuai gambar
    library:CreateTabButton("Hatching", false)
    library:CreateTabButton("Misc", true)
    library:CreateTabButton("Movement", false)
    library:CreateTabButton("Teleport", false)
    library:CreateTabButton("Visuals", false)
    
    -- Buat content section untuk Hatching
    local hatchingSection = library:CreateContentSection("Hatching")
    hatchingSection.Visible = true
    
    -- Tambahkan dropdown untuk Egg selection
    hatchingSection:AddDropdown("Egg", {"Egg 1", "Egg 2 (Mount Everest)", "Egg 3"}, "Egg 2 (Mount Everest)")
    
    -- Tambahkan dropdown untuk Hatch Amount
    hatchingSection:AddDropdown("Select Hatch Amount", {"1x Hatch", "5x Hatch", "10x Hatch (Gamepass...)"}, "10x Hatch (Gamepass...)")
    
    -- Tambahkan toggle untuk Auto Hatch
    hatchingSection:AddToggle("Auto Hatch", false)
    
    return library
end

return ArcvourHUB
