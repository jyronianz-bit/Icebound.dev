-- Nebulatech UI Library
-- Advanced UI Library with Config Saving, Themes, and Animations

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Default Configuration
local DefaultConfig = {
    Theme = "Dark",
    UIKeybind = Enum.KeyCode.RightShift,
    Position = UDim2.new(0.5, -300, 0.5, -250)
}

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 30),
        Secondary = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(115, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 190),
        Border = Color3.fromRGB(50, 50, 60),
        Hover = Color3.fromRGB(45, 45, 50),
        Toggle = Color3.fromRGB(115, 100, 255)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(90, 80, 220),
        Text = Color3.fromRGB(20, 20, 30),
        SubText = Color3.fromRGB(100, 100, 120),
        Border = Color3.fromRGB(220, 220, 230),
        Hover = Color3.fromRGB(230, 230, 240),
        Toggle = Color3.fromRGB(90, 80, 220)
    },
    Ocean = {
        Background = Color3.fromRGB(20, 30, 45),
        Secondary = Color3.fromRGB(30, 45, 65),
        Accent = Color3.fromRGB(50, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 190, 220),
        Border = Color3.fromRGB(40, 60, 85),
        Hover = Color3.fromRGB(35, 50, 70),
        Toggle = Color3.fromRGB(50, 150, 255)
    }
}

-- Utility Functions
local function Tween(obj, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Ripple(button, x, y)
    local ripple = Instance.new("ImageLabel")
    ripple.Name = "Ripple"
    ripple.BackgroundTransparency = 1
    ripple.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ripple.ImageTransparency = 0.5
    ripple.ZIndex = button.ZIndex + 1
    ripple.Position = UDim2.new(0, x - 10, 0, y - 10)
    ripple.Size = UDim2.new(0, 20, 0, 20)
    ripple.Parent = button
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(0, x - size/2, 0, y - size/2),
        ImageTransparency = 1
    }, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Create Main Window
function Library:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Nebulatech"
    local CurrentTheme = Themes[config.Theme or "Dark"] or Themes.Dark
    local ConfigData = {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulatechUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Protect GUI
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Position = config.Position or UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Drop Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ZIndex = MainFrame.ZIndex - 1
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = CurrentTheme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 8)
    TopBarCover.Position = UDim2.new(0, 0, 1, -8)
    TopBarCover.BackgroundColor3 = CurrentTheme.Secondary
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = CurrentTheme.Accent
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = CurrentTheme.Text
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = CurrentTheme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 2)
    SidebarList.Parent = Sidebar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close Button Function
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 600, 0, 500)
    end)
    
    -- Toggle UI Keybind
    local UIOpen = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == (config.UIKeybind or Enum.KeyCode.RightShift) then
            UIOpen = not UIOpen
            if UIOpen then
                MainFrame.Visible = true
                MainFrame.Size = UDim2.new(0, 0, 0, 0)
                Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 500)}, 0.3)
            else
                Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
                task.wait(0.3)
                MainFrame.Visible = false
            end
        end
    end)
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        ConfigData = ConfigData,
        Theme = CurrentTheme
    }
    
    -- Create Tab
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Tab"
        local TabIcon = tabConfig.Icon or "👥"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = CurrentTheme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Size = UDim2.new(0, 30, 1, 0)
        TabIcon.Position = UDim2.new(0, 10, 0, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = tabConfig.Icon or "📁"
        TabIcon.TextColor3 = CurrentTheme.SubText
        TabIcon.TextSize = 16
        TabIcon.Font = Enum.Font.Gotham
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -50, 1, 0)
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = TabName
        TabLabel.TextColor3 = CurrentTheme.SubText
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabName .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = CurrentTheme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabList = Instance.new("UIListLayout")
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 8)
        TabList.Parent = TabContent
        
        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = CurrentTheme.Secondary
                tab.Content.Visible = false
                tab.Label.TextColor3 = CurrentTheme.SubText
                tab.Icon.TextColor3 = CurrentTheme.SubText
            end
            
            TabButton.BackgroundColor3 = CurrentTheme.Hover
            TabContent.Visible = true
            TabLabel.TextColor3 = CurrentTheme.Text
            TabIcon.TextColor3 = CurrentTheme.Accent
            Window.CurrentTab = TabName
            
            Ripple(TabButton, TabButton.AbsoluteSize.X / 2, TabButton.AbsoluteSize.Y / 2)
        end)
        
        -- Hover Effect
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= TabName then
                Tween(TabButton, {BackgroundColor3 = CurrentTheme.Hover}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= TabName then
                Tween(TabButton, {BackgroundColor3 = CurrentTheme.Secondary}, 0.2)
            end
        end)
        
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Label = TabLabel,
            Icon = TabIcon,
            Sections = {}
        }
        
        table.insert(Window.Tabs, Tab)
        
        -- Set first tab as active
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = CurrentTheme.Hover
            TabContent.Visible = true
            TabLabel.TextColor3 = CurrentTheme.Text
            TabIcon.TextColor3 = CurrentTheme.Accent
            Window.CurrentTab = TabName
        end
        
        -- Create Section
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.Size = UDim2.new(1, 0, 0, 0)
            Section.BackgroundColor3 = CurrentTheme.Secondary
            Section.BorderSizePixel = 0
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section
            
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 35)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = Section
            
            local SectionIcon = Instance.new("TextLabel")
            SectionIcon.Size = UDim2.new(0, 20, 0, 20)
            SectionIcon.Position = UDim2.new(0, 10, 0, 7.5)
            SectionIcon.BackgroundTransparency = 1
            SectionIcon.Text = "⚙"
            SectionIcon.TextColor3 = CurrentTheme.Accent
            SectionIcon.TextSize = 14
            SectionIcon.Font = Enum.Font.Gotham
            SectionIcon.Parent = SectionHeader
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -40, 1, 0)
            SectionTitle.Position = UDim2.new(0, 35, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = CurrentTheme.Text
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            SectionContent.Position = UDim2.new(0, 10, 0, 35)
            SectionContent.BackgroundTransparency = 1
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.Parent = Section
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 6)
            SectionList.Parent = SectionContent
            
            local SectionObj = {
                Container = Section,
                Content = SectionContent
            }
            
            -- Add Button
            function SectionObj:AddButton(buttonConfig)
                buttonConfig = buttonConfig or {}
                local ButtonName = buttonConfig.Name or "Button"
                local Callback = buttonConfig.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = ButtonName
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = CurrentTheme.Background
                Button.BorderSizePixel = 0
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                local ButtonLabel = Instance.new("TextLabel")
                ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
                ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Text = ButtonName
                ButtonLabel.TextColor3 = CurrentTheme.Text
                ButtonLabel.TextSize = 13
                ButtonLabel.Font = Enum.Font.Gotham
                ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
                ButtonLabel.Parent = Button
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button, Button.AbsoluteSize.X / 2, Button.AbsoluteSize.Y / 2)
                    pcall(Callback)
                end)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = CurrentTheme.Hover}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = CurrentTheme.Background}, 0.2)
                end)
                
                return Button
            end
            
            -- Add Toggle
            function SectionObj:AddToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local ToggleName = toggleConfig.Name or "Toggle"
                local Default = toggleConfig.Default or false
                local Callback = toggleConfig.Callback or function() end
                local Flag = toggleConfig.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local Toggle = Instance.new("Frame")
                Toggle.Name = ToggleName
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.BackgroundColor3 = CurrentTheme.Background
                Toggle.BorderSizePixel = 0
                Toggle.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                ToggleCorner.Parent = Toggle
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = ToggleName
                ToggleLabel.TextColor3 = CurrentTheme.Text
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = Toggle
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleButton.BackgroundColor3 = Default and CurrentTheme.Toggle or CurrentTheme.Border
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false
                ToggleButton.Parent = Toggle
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleButton
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle
                
                local toggled = Default
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    if Flag then
                        ConfigData[Flag] = toggled
                    end
                    
                    Tween(ToggleButton, {
                        BackgroundColor3 = toggled and CurrentTheme.Toggle or CurrentTheme.Border
                    }, 0.2)
                    
                    Tween(ToggleCircle, {
                        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }, 0.2)
                    
                    pcall(Callback, toggled)
                end)
                
                return {
                    SetValue = function(value)
                        toggled = value
                        if Flag then
                            ConfigData[Flag] = value
                        end
                        Tween(ToggleButton, {
                            BackgroundColor3 = value and CurrentTheme.Toggle or CurrentTheme.Border
                        }, 0.2)
                        Tween(ToggleCircle, {
                            Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                        }, 0.2)
                    end
                }
            end
            
            -- Add Slider
            function SectionObj:AddSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                local SliderName = sliderConfig.Name or "Slider"
                local Min = sliderConfig.Min or 0
                local Max = sliderConfig.Max or 100
                local Default = sliderConfig.Default or Min
                local Increment = sliderConfig.Increment or 1
                local Callback = sliderConfig.Callback or function() end
                local Flag = sliderConfig.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local Slider = Instance.new("Frame")
                Slider.Name = SliderName
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.BackgroundColor3 = CurrentTheme.Background
                Slider.BorderSizePixel = 0
                Slider.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 4)
                SliderCorner.Parent = Slider
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -60, 0, 20)
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = SliderName
                SliderLabel.TextColor3 = CurrentTheme.Text
                SliderLabel.TextSize = 13
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = Slider
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.Position = UDim2.new(1, -55, 0, 5)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(Default)
                SliderValue.TextColor3 = CurrentTheme.Accent
                SliderValue.TextSize = 13
                SliderValue.Font = Enum.Font.GothamSemibold
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = Slider
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -20, 0, 4)
                SliderBar.Position = UDim2.new(0, 10, 1, -15)
                SliderBar.BackgroundColor3 = CurrentTheme.Border
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = Slider
                
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = CurrentTheme.Toggle
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                local SliderDot = Instance.new("Frame")
                SliderDot.Size = UDim2.new(0, 12, 0, 12)
                SliderDot.Position = UDim2.new((Default - Min) / (Max - Min), -6, 0.5, -6)
                SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderDot.BorderSizePixel = 0
                SliderDot.Parent = SliderBar
                
                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = SliderDot
                
                local dragging = false
                local currentValue = Default
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor((Min + (Max - Min) * pos) / Increment + 0.5) * Increment
                    value = math.clamp(value, Min, Max)
                    
                    currentValue = value
                    SliderValue.Text = tostring(value)
                    
                    if Flag then
                        ConfigData[Flag] = value
                    end
                    
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                    Tween(SliderDot, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
                    
                    pcall(Callback, value)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                return {
                    SetValue = function(value)
                        value = math.clamp(value, Min, Max)
                        currentValue = value
                        SliderValue.Text = tostring(value)
                        if Flag then
                            ConfigData[Flag] = value
                        end
                        local pos = (value - Min) / (Max - Min)
                        Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                        Tween(SliderDot, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
                    end
                }
            end
            
            -- Add Dropdown
            function SectionObj:AddDropdown(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                local DropdownName = dropdownConfig.Name or "Dropdown"
                local Options = dropdownConfig.Options or {}
                local Default = dropdownConfig.Default or Options[1]
                local Callback = dropdownConfig.Callback or function() end
                local Flag = dropdownConfig.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = DropdownName
                Dropdown.Size = UDim2.new(1, 0, 0, 35)
                Dropdown.BackgroundColor3 = CurrentTheme.Background
                Dropdown.BorderSizePixel = 0
                Dropdown.ClipsDescendants = true
                Dropdown.Parent = SectionContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = Dropdown
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 35)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""
                DropdownButton.Parent = Dropdown
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, -60, 0, 35)
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = DropdownName
                DropdownLabel.TextColor3 = CurrentTheme.Text
                DropdownLabel.TextSize = 13
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = Dropdown
                
                local DropdownValue = Instance.new("TextLabel")
                DropdownValue.Size = UDim2.new(0, 150, 0, 35)
                DropdownValue.Position = UDim2.new(1, -160, 0, 0)
                DropdownValue.BackgroundTransparency = 1
                DropdownValue.Text = Default or "None"
                DropdownValue.TextColor3 = CurrentTheme.SubText
                DropdownValue.TextSize = 12
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                DropdownValue.TextTruncate = Enum.TextTruncate.AtEnd
                DropdownValue.Parent = Dropdown
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Size = UDim2.new(0, 20, 0, 35)
                DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = CurrentTheme.SubText
                DropdownArrow.TextSize = 10
                DropdownArrow.Font = Enum.Font.Gotham
                DropdownArrow.Parent = Dropdown
                
                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 0, 35)
                DropdownList.BackgroundTransparency = 1
                DropdownList.BorderSizePixel = 0
                DropdownList.ScrollBarThickness = 2
                DropdownList.ScrollBarImageColor3 = CurrentTheme.Accent
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownList.Visible = false
                DropdownList.Parent = Dropdown
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Parent = DropdownList
                
                local isOpen = false
                local currentValue = Default
                
                for _, option in ipairs(Options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.BackgroundColor3 = CurrentTheme.Background
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Text = option
                    OptionButton.TextColor3 = CurrentTheme.Text
                    OptionButton.TextSize = 12
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.AutoButtonColor = false
                    OptionButton.Parent = DropdownList
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        currentValue = option
                        DropdownValue.Text = option
                        
                        if Flag then
                            ConfigData[Flag] = option
                        end
                        
                        isOpen = false
                        DropdownList.Visible = false
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                        
                        pcall(Callback, option)
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = CurrentTheme.Hover}, 0.2)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = CurrentTheme.Background}, 0.2)
                    end)
                end
                
                ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
                end)
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        DropdownList.Visible = true
                        local listHeight = math.min(ListLayout.AbsoluteContentSize.Y, 120)
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 35 + listHeight)}, 0.2)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    else
                        DropdownList.Visible = false
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                return {
                    SetValue = function(value)
                        currentValue = value
                        DropdownValue.Text = value
                        if Flag then
                            ConfigData[Flag] = value
                        end
                    end
                }
            end
            
            -- Add Color Picker
            function SectionObj:AddColorPicker(colorConfig)
                colorConfig = colorConfig or {}
                local ColorName = colorConfig.Name or "Color"
                local Default = colorConfig.Default or Color3.fromRGB(255, 255, 255)
                local Callback = colorConfig.Callback or function() end
                local Flag = colorConfig.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local ColorFrame = Instance.new("Frame")
                ColorFrame.Name = ColorName
                ColorFrame.Size = UDim2.new(1, 0, 0, 35)
                ColorFrame.BackgroundColor3 = CurrentTheme.Background
                ColorFrame.BorderSizePixel = 0
                ColorFrame.Parent = SectionContent
                
                local ColorCorner = Instance.new("UICorner")
                ColorCorner.CornerRadius = UDim.new(0, 4)
                ColorCorner.Parent = ColorFrame
                
                local ColorLabel = Instance.new("TextLabel")
                ColorLabel.Size = UDim2.new(1, -50, 1, 0)
                ColorLabel.Position = UDim2.new(0, 10, 0, 0)
                ColorLabel.BackgroundTransparency = 1
                ColorLabel.Text = ColorName
                ColorLabel.TextColor3 = CurrentTheme.Text
                ColorLabel.TextSize = 13
                ColorLabel.Font = Enum.Font.Gotham
                ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorLabel.Parent = ColorFrame
                
                local ColorDisplay = Instance.new("TextButton")
                ColorDisplay.Size = UDim2.new(0, 30, 0, 20)
                ColorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
                ColorDisplay.BackgroundColor3 = Default
                ColorDisplay.BorderSizePixel = 0
                ColorDisplay.Text = ""
                ColorDisplay.Parent = ColorFrame
                
                local DisplayCorner = Instance.new("UICorner")
                DisplayCorner.CornerRadius = UDim.new(0, 4)
                DisplayCorner.Parent = ColorDisplay
                
                local currentColor = Default
                
                ColorDisplay.MouseButton1Click:Connect(function()
                    -- Simple color picker (you can expand this)
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(255, 255, 255),
                        Color3.fromRGB(0, 0, 0)
                    }
                    
                    local index = 1
                    for i, color in ipairs(colors) do
                        if currentColor == color then
                            index = i
                            break
                        end
                    end
                    
                    index = index % #colors + 1
                    currentColor = colors[index]
                    
                    ColorDisplay.BackgroundColor3 = currentColor
                    
                    if Flag then
                        ConfigData[Flag] = currentColor
                    end
                    
                    pcall(Callback, currentColor)
                end)
                
                return {
                    SetValue = function(color)
                        currentColor = color
                        ColorDisplay.BackgroundColor3 = color
                        if Flag then
                            ConfigData[Flag] = color
                        end
                    end
                }
            end
            
            table.insert(Tab.Sections, SectionObj)
            return SectionObj
        end
        
        return Tab
    end
    
    -- Config System
    function Window:SaveConfig(configName)
        configName = configName or "default"
        local success, err = pcall(function()
            writefile("nebulatech_" .. configName .. ".json", HttpService:JSONEncode(ConfigData))
        end)
        
        if success then
            print("Config saved: " .. configName)
        else
            warn("Failed to save config: " .. err)
        end
    end
    
    function Window:LoadConfig(configName)
        configName = configName or "default"
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("nebulatech_" .. configName .. ".json"))
        end)
        
        if success and data then
            for flag, value in pairs(data) do
                ConfigData[flag] = value
            end
            print("Config loaded: " .. configName)
            return true
        else
            warn("Failed to load config")
            return false
        end
    end
    
    function Window:SetTheme(themeName)
        if Themes[themeName] then
            CurrentTheme = Themes[themeName]
            Window.Theme = CurrentTheme
            -- Update all UI elements with new theme
            -- (Implementation would update all colors)
            print("Theme changed to: " .. themeName)
        end
    end
    
    return Window
end

return Library
