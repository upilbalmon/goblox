


local NEVERLOSE = loadstring(game:HttpGet("https://you.whimper.xyz/sources/ronix/ui.lua"))()

NEVERLOSE:Theme("nightly")
local Window = NEVERLOSE:AddWindow("Ronix Hub", "Text")

-- Tabs and Sections
local MainTab = Window:AddTab("Main", "home")
local MainSection = MainTab:AddSection("Home", "left")

MainSection:AddButton("Example Button", function()
    print("Successfully clicked the button!")
end)

MainSection:AddToggle("Example toggle", false, function(state)
    if state then
        print("Toggled on!")
    end
end)

MainSection:AddDropdown("Example dropdown", {"hi", "hi 2", "hi 3"}, function(selection)
    print("Selected:", selection)
end) local OtherTab = Window:AddTab("Other", "folder")
local OtherSection = OtherTab:AddSection("Additional", "left") OtherSection:AddButton("Example Button", function()
    print("Successfully clicked the button!")
end)  local ListTab = Window:AddTab("List", "list")
local Listsection = ListTab:AddSection("Idk", "left") Listsection:AddButton("Example Button", function()
    print("Successfully clicked the button!")
end)
