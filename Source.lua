--[[
    Nexus UI Library
    A modern, feature-rich Roblox UI library with smooth animations and polished visuals
    Version 1.0.0
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local NexusUI = {}
NexusUI.__index = NexusUI

-- Configuration
local Config = {
    -- Theme colors
    Background = Color3.fromRGB(18, 18, 24),
    SecondaryBackground = Color3.fromRGB(24, 24, 32),
    Accent = Color3.fromRGB(138, 98, 255),
    AccentHover = Color3.fromRGB(158, 118, 255),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(160, 160, 175),
    Border = Color3.fromRGB(45, 45, 55),
    Success = Color3.fromRGB(76, 209, 55),
    Warning = Color3.fromRGB(255, 184, 0),
    Error = Color3.fromRGB(255, 71, 87),
    
    -- Animation settings
    AnimationSpeed = 0.25,
    HoverSpeed = 0.15,
    
    -- Sizes
    CornerRadius = UDim.new(0, 8),
    ButtonHeight = 36,
    ToggleSize = 44,
    SliderHeight = 6,
    DropdownHeight = 36,
}

-- Utility Functions
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or Config.AnimationSpeed,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return CreateElement("UICorner", {
        CornerRadius = radius or Config.CornerRadius,
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return CreateElement("UIStroke", {
        Color = color or Config.Border,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function AddPadding(parent, padding)
    return CreateElement("UIPadding", {
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        Parent = parent
    })
end

-- Main Library Functions
function NexusUI:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "Nexus UI"
    local windowSize = options.Size or UDim2.new(0, 550, 0, 600)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    
    local window = {
        Tabs = {},
        CurrentTab = nil,
        Elements = {},
        Flags = {},
        Configuration = {},
        ToggleKey = toggleKey,
    }
    
    -- Main ScreenGui
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game.CoreGui
    })
    
    -- Main Frame
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, UDim.new(0, 12))
    AddStroke(MainFrame, Config.Border, 1)
    
    -- Shadow removed for cleaner look
    
    -- Title Bar
    local TitleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Config.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    AddCorner(TitleBar, UDim.new(0, 12))
    
    local TitleBarCover = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 1, -25),
        BackgroundColor3 = Config.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    local Title = CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = windowName,
        TextColor3 = Config.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Minimize Button
    local MinimizeButton = CreateElement("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -75, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Accent,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Config.Text,
        TextSize = 20,
        Parent = TitleBar
    })
    AddCorner(MinimizeButton, UDim.new(0, 6))
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Config.AccentHover}, Config.HoverSpeed)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Config.Accent}, Config.HoverSpeed)
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        
        -- Create notification
        local NotificationFrame = CreateElement("Frame", {
            Size = UDim2.new(0, 300, 0, 60),
            Position = UDim2.new(1, -310, 1, -70),
            BackgroundColor3 = Config.SecondaryBackground,
            BorderSizePixel = 0,
            Parent = ScreenGui
        })
        AddCorner(NotificationFrame, UDim.new(0, 8))
        AddStroke(NotificationFrame, Config.Accent, 2)
        
        local NotifText = CreateElement("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            Text = "UI Minimized - Press " .. (window.ToggleKey or "RightShift") .. " to reopen",
            TextColor3 = Config.Text,
            TextSize = 12,
            TextWrapped = true,
            Parent = NotificationFrame
        })
        
        -- Animate in
        NotificationFrame.Position = UDim2.new(1, 10, 1, -70)
        Tween(NotificationFrame, {Position = UDim2.new(1, -310, 1, -70)}, Config.AnimationSpeed)
        
        -- Auto remove after 3 seconds
        wait(3)
        Tween(NotificationFrame, {Position = UDim2.new(1, 10, 1, -70)}, Config.AnimationSpeed)
        wait(Config.AnimationSpeed)
        NotificationFrame:Destroy()
    end)
    
    -- Close Button
    local CloseButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Error,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Config.Text,
        TextSize = 20,
        Parent = TitleBar
    })
    AddCorner(CloseButton, UDim.new(0, 6))
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 91, 107)}, Config.HoverSpeed)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Config.Error}, Config.HoverSpeed)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed)
        wait(Config.AnimationSpeed)
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = CreateElement("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 150, 1, -70),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = MainFrame
    })
    
    local TabLayout = CreateElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = TabContainer
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    -- Content Container
    local ContentContainer = CreateElement("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -180, 1, -70),
        Position = UDim2.new(0, 170, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
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
    
    TitleBar.InputChanged:Connect(function(input)
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
    
    -- Entrance animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(MainFrame, {Size = windowSize}, Config.AnimationSpeed * 1.5)
    
    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Tab Functions
    function window:CreateTab(tabName, icon)
        local tab = {
            Name = tabName,
            Elements = {},
        }
        
        -- Tab Button
        local TabButton = CreateElement("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Config.SecondaryBackground,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamSemibold,
            Text = "  " .. tabName,
            TextColor3 = Config.SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabContainer
        })
        AddCorner(TabButton, UDim.new(0, 6))
        
        -- Tab Content
        local TabContent = CreateElement("ScrollingFrame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Config.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentContainer
        })
        
        local ContentLayout = CreateElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = TabContent
        })
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        AddPadding(TabContent, 10)
        
        TabButton.MouseEnter:Connect(function()
            if window.CurrentTab ~= tab then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, Config.HoverSpeed)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if window.CurrentTab ~= tab then
                Tween(TabButton, {BackgroundColor3 = Config.SecondaryBackground}, Config.HoverSpeed)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Button.BackgroundColor3 = Config.SecondaryBackground
                t.Button.TextColor3 = Config.SubText
                t.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Config.Accent
            TabButton.TextColor3 = Config.Text
            TabContent.Visible = true
            window.CurrentTab = tab
        end)
        
        tab.Button = TabButton
        tab.Content = TabContent
        
        -- Auto-select first tab
        if #window.Tabs == 0 then
            TabButton.BackgroundColor3 = Config.Accent
            TabButton.TextColor3 = Config.Text
            TabContent.Visible = true
            window.CurrentTab = tab
        end
        
        table.insert(window.Tabs, tab)
        
        -- Element Creation Functions
        function tab:AddButton(options)
            options = options or {}
            local buttonName = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local ButtonFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, Config.ButtonHeight),
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(ButtonFrame)
            AddStroke(ButtonFrame)
            
            local Button = CreateElement("TextButton", {
                Size = UDim2.new(1, -20, 1, -10),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = buttonName,
                TextColor3 = Config.Text,
                TextSize = 14,
                Parent = ButtonFrame
            })
            
            local Ripple = CreateElement("Frame", {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Config.Accent,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = ButtonFrame
            })
            AddCorner(Ripple, UDim.new(1, 0))
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, Config.HoverSpeed)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Config.SecondaryBackground}, Config.HoverSpeed)
            end)
            
            Button.MouseButton1Click:Connect(function()
                Ripple.Size = UDim2.new(0, 0, 0, 0)
                Ripple.BackgroundTransparency = 0.5
                
                Tween(Ripple, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.5)
                
                spawn(function()
                    callback()
                end)
            end)
            
            return ButtonFrame
        end
        
        function tab:AddToggle(options)
            options = options or {}
            local toggleName = options.Name or "Toggle"
            local default = options.Default or false
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local ToggleFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, Config.ToggleSize),
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(ToggleFrame)
            AddStroke(ToggleFrame)
            
            local ToggleLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -65, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = toggleName,
                TextColor3 = Config.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local ToggleButton = CreateElement("TextButton", {
                Size = UDim2.new(0, 45, 0, 24),
                Position = UDim2.new(1, -55, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Border,
                BorderSizePixel = 0,
                Text = "",
                Parent = ToggleFrame
            })
            AddCorner(ToggleButton, UDim.new(1, 0))
            
            local ToggleCircle = CreateElement("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Text,
                BorderSizePixel = 0,
                Parent = ToggleButton
            })
            AddCorner(ToggleCircle, UDim.new(1, 0))
            
            local toggled = default
            
            local function UpdateToggle(state)
                toggled = state
                if flag then
                    window.Flags[flag] = state
                end
                
                if state then
                    Tween(ToggleButton, {BackgroundColor3 = Config.Accent}, Config.AnimationSpeed)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, 0)}, Config.AnimationSpeed)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Config.Border}, Config.AnimationSpeed)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, 0)}, Config.AnimationSpeed)
                end
                
                spawn(function()
                    callback(state)
                end)
            end
            
            UpdateToggle(default)
            
            ToggleButton.MouseButton1Click:Connect(function()
                UpdateToggle(not toggled)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, Config.HoverSpeed)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Config.SecondaryBackground}, Config.HoverSpeed)
            end)
            
            return {
                SetValue = UpdateToggle,
                GetValue = function() return toggled end
            }
        end
        
        function tab:AddSlider(options)
            options = options or {}
            local sliderName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local increment = options.Increment or 1
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local SliderFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(SliderFrame)
            AddStroke(SliderFrame)
            
            local SliderLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = sliderName,
                TextColor3 = Config.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = CreateElement("TextLabel", {
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -65, 0, 8),
                BackgroundColor3 = Config.Background,
                BorderSizePixel = 0,
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = Config.Accent,
                TextSize = 13,
                Parent = SliderFrame
            })
            AddCorner(ValueLabel, UDim.new(0, 4))
            
            local SliderBar = CreateElement("Frame", {
                Size = UDim2.new(1, -24, 0, Config.SliderHeight),
                Position = UDim2.new(0, 12, 1, -18),
                BackgroundColor3 = Config.Border,
                BorderSizePixel = 0,
                Parent = SliderFrame
            })
            AddCorner(SliderBar, UDim.new(1, 0))
            
            local SliderFill = CreateElement("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Config.Accent,
                BorderSizePixel = 0,
                Parent = SliderBar
            })
            AddCorner(SliderFill, UDim.new(1, 0))
            
            local SliderButton = CreateElement("TextButton", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, -8, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Text,
                BorderSizePixel = 0,
                Text = "",
                ZIndex = 2,
                Parent = SliderFill
            })
            AddCorner(SliderButton, UDim.new(1, 0))
            
            local dragging = false
            local value = default
            
            local function UpdateSlider(val)
                val = math.clamp(val, min, max)
                val = math.floor(val / increment + 0.5) * increment
                value = val
                
                local percentage = (val - min) / (max - min)
                Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                ValueLabel.Text = tostring(val)
                
                if flag then
                    window.Flags[flag] = val
                end
                
                spawn(function()
                    callback(val)
                end)
            end
            
            local function UpdateSliderFromInput(input)
                local mousePos = input.Position.X
                local sliderPos = SliderBar.AbsolutePosition.X
                local sliderSize = SliderBar.AbsoluteSize.X
                local percentage = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                local newValue = min + (max - min) * percentage
                UpdateSlider(newValue)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSliderFromInput(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSliderFromInput(input)
                end
            end)
            
            UpdateSlider(default)
            
            return {
                SetValue = UpdateSlider,
                GetValue = function() return value end
            }
        end
        
        function tab:AddDropdown(options)
            options = options or {}
            local dropdownName = options.Name or "Dropdown"
            local items = options.Items or {"Option 1", "Option 2"}
            local default = options.Default or items[1]
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local DropdownFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, Config.DropdownHeight),
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = TabContent,
                ClipsDescendants = true,
            })
            AddCorner(DropdownFrame)
            AddStroke(DropdownFrame)
            
            local DropdownButton = CreateElement("TextButton", {
                Size = UDim2.new(1, 0, 0, Config.DropdownHeight),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = "",
                Parent = DropdownFrame
            })
            
            local DropdownLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = dropdownName,
                TextColor3 = Config.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownButton
            })
            
            local DropdownValue = CreateElement("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(1, -110, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = default,
                TextColor3 = Config.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DropdownButton
            })
            
            local Arrow = CreateElement("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -25, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = "▼",
                TextColor3 = Config.SubText,
                TextSize = 10,
                Parent = DropdownButton
            })
            
            local ItemsContainer = CreateElement("Frame", {
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, Config.DropdownHeight + 5),
                BackgroundTransparency = 1,
                Parent = DropdownFrame
            })
            
            local ItemsLayout = CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = ItemsContainer
            })
            
            local isOpen = false
            local selectedValue = default
            
            for _, item in ipairs(items) do
                local ItemButton = CreateElement("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Config.Background,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = "  " .. item,
                    TextColor3 = Config.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ItemsContainer
                })
                AddCorner(ItemButton, UDim.new(0, 4))
                
                ItemButton.MouseEnter:Connect(function()
                    Tween(ItemButton, {BackgroundColor3 = Config.Accent}, Config.HoverSpeed)
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    Tween(ItemButton, {BackgroundColor3 = Config.Background}, Config.HoverSpeed)
                end)
                
                ItemButton.MouseButton1Click:Connect(function()
                    selectedValue = item
                    DropdownValue.Text = item
                    
                    if flag then
                        window.Flags[flag] = item
                    end
                    
                    spawn(function()
                        callback(item)
                    end)
                    
                    -- Close dropdown
                    isOpen = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, Config.DropdownHeight)}, Config.AnimationSpeed)
                    Tween(Arrow, {Rotation = 0}, Config.AnimationSpeed)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local totalHeight = Config.DropdownHeight + 5 + (#items * 30)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, Config.AnimationSpeed)
                    Tween(Arrow, {Rotation = 180}, Config.AnimationSpeed)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, Config.DropdownHeight)}, Config.AnimationSpeed)
                    Tween(Arrow, {Rotation = 0}, Config.AnimationSpeed)
                end
            end)
            
            DropdownFrame.MouseEnter:Connect(function()
                if not isOpen then
                    Tween(DropdownFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, Config.HoverSpeed)
                end
            end)
            
            DropdownFrame.MouseLeave:Connect(function()
                if not isOpen then
                    Tween(DropdownFrame, {BackgroundColor3 = Config.SecondaryBackground}, Config.HoverSpeed)
                end
            end)
            
            return {
                SetValue = function(item)
                    if table.find(items, item) then
                        selectedValue = item
                        DropdownValue.Text = item
                        if flag then
                            window.Flags[flag] = item
                        end
                        callback(item)
                    end
                end,
                GetValue = function() return selectedValue end
            }
        end
        
        function tab:AddTextbox(options)
            options = options or {}
            local textboxName = options.Name or "Textbox"
            local default = options.Default or ""
            local placeholder = options.Placeholder or "Enter text..."
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local TextboxFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(TextboxFrame)
            AddStroke(TextboxFrame)
            
            local TextboxLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 4),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = textboxName,
                TextColor3 = Config.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextboxFrame
            })
            
            local Textbox = CreateElement("TextBox", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 1, -24),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Config.SubText,
                Text = default,
                TextColor3 = Config.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = TextboxFrame
            })
            
            Textbox.FocusLost:Connect(function()
                local text = Textbox.Text
                if flag then
                    window.Flags[flag] = text
                end
                spawn(function()
                    callback(text)
                end)
            end)
            
            return {
                SetValue = function(text)
                    Textbox.Text = text
                    if flag then
                        window.Flags[flag] = text
                    end
                    callback(text)
                end,
                GetValue = function() return Textbox.Text end
            }
        end
        
        function tab:AddKeybind(options)
            options = options or {}
            local keybindName = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.E
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local KeybindFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(KeybindFrame)
            AddStroke(KeybindFrame)
            
            local KeybindLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = keybindName,
                TextColor3 = Config.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            local KeybindButton = CreateElement("TextButton", {
                Size = UDim2.new(0, 80, 0, 28),
                Position = UDim2.new(1, -90, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Background,
                BorderSizePixel = 0,
                Font = Enum.Font.GothamBold,
                Text = default.Name,
                TextColor3 = Config.Accent,
                TextSize = 12,
                Parent = KeybindFrame
            })
            AddCorner(KeybindButton, UDim.new(0, 6))
            AddStroke(KeybindButton, Config.Accent, 1)
            
            local currentKey = default
            local listening = false
            
            local function UpdateKeybind(key)
                currentKey = key
                KeybindButton.Text = key.Name
                if flag then
                    window.Flags[flag] = key
                end
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                
                listening = true
                KeybindButton.Text = "..."
                KeybindButton.TextColor3 = Config.Warning
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        connection:Disconnect()
                        
                        UpdateKeybind(input.KeyCode)
                        KeybindButton.TextColor3 = Config.Accent
                        
                        spawn(function()
                            callback(input.KeyCode)
                        end)
                    end
                end)
            end)
            
            -- Listen for the keybind being pressed
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == currentKey then
                    spawn(function()
                        callback(currentKey)
                    end)
                end
            end)
            
            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, Config.HoverSpeed)
            end)
            
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Config.SecondaryBackground}, Config.HoverSpeed)
            end)
            
            UpdateKeybind(default)
            
            return {
                SetValue = UpdateKeybind,
                GetValue = function() return currentKey end
            }
        end
        
        function tab:AddLabel(text)
            local LabelFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = TabContent
            })
            
            local Label = CreateElement("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Config.SubText,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = LabelFrame
            })
            
            return {
                SetText = function(newText)
                    Label.Text = newText
                end
            }
        end
        
        function tab:AddDivider()
            local Divider = CreateElement("Frame", {
                Size = UDim2.new(1, -20, 0, 1),
                BackgroundColor3 = Config.Border,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            return Divider
        end
        
        return tab
    end
    
    -- Configuration Functions
    function window:SaveConfig(name)
        name = name or "default"
        window.Configuration[name] = {}
        
        for flag, value in pairs(window.Flags) do
            window.Configuration[name][flag] = value
        end
        
        return window.Configuration[name]
    end
    
    function window:LoadConfig(name)
        name = name or "default"
        local config = window.Configuration[name]
        
        if config then
            for flag, value in pairs(config) do
                window.Flags[flag] = value
            end
        end
    end
    
    return window
end

return NexusUI
