-- Nebulatech UI Library - Accurate Recreation
-- Multi-column layout with horizontal tabs matching the screenshot

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Theme Colors (matching screenshot)
local Theme = {
    Background = Color3.fromRGB(20, 20, 24),
    Secondary = Color3.fromRGB(28, 28, 32),
    Tertiary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(115, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 165),
    Border = Color3.fromRGB(45, 45, 50),
    Hover = Color3.fromRGB(40, 40, 45)
}

-- Utility Functions
local function Tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function MakeElement(class, props)
    local element = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            element[k] = v
        end
    end
    element.Parent = props.Parent
    return element
end

-- Main Library
function Library:CreateWindow(config)
    config = config or {}
    local ConfigData = {}
    
    -- ScreenGui
    local ScreenGui = MakeElement("ScreenGui", {
        Name = "NebulatechUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = (gethui and gethui()) or game.CoreGui
    })
    
    -- Main Container
    local MainFrame = MakeElement("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 720, 0, 480),
        Position = UDim2.new(0.5, -360, 0.5, -240),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    MakeElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    })
    
    -- Shadow Effect
    MakeElement("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -20, 0, -20),
        Size = UDim2.new(1, 40, 1, 40),
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ZIndex = 0,
        Parent = MainFrame
    })
    
    -- Top Bar
    local TopBar = MakeElement("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    MakeElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar
    })
    
    -- Cover bottom corners of top bar
    MakeElement("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    -- Logo/Title
    local Title = MakeElement("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = "nebulatech",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Add underline to "nebula"
    local Underline = MakeElement("Frame", {
        Size = UDim2.new(0, 70, 0, 2),
        Position = UDim2.new(0, 20, 0, 32),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    -- Tab Container (horizontal tabs)
    local TabContainer = MakeElement("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 400, 1, 0),
        Position = UDim2.new(0, 200, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    })
    
    local TabLayout = MakeElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = TabContainer
    })
    
    -- Content Area
    local ContentFrame = MakeElement("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -40, 1, -70),
        Position = UDim2.new(0, 20, 0, 60),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Close Button
    local CloseBtn = MakeElement("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -45, 0, 5),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Theme.TextDark,
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {TextColor3 = Theme.Text})
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {TextColor3 = Theme.TextDark})
    end)
    
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Toggle UI
    local Visible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == (config.Keybind or Enum.KeyCode.RightShift) then
            Visible = not Visible
            MainFrame.Visible = Visible
        end
    end)
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        ConfigData = ConfigData
    }
    
    -- Create Tab
    function Window:CreateTab(tabConfig)
        local TabName = tabConfig.Name or "Tab"
        
        -- Tab Button
        local TabButton = MakeElement("TextButton", {
            Name = TabName,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = TabContainer
        })
        
        -- Tab Content Container (multi-column layout)
        local TabContent = MakeElement("ScrollingFrame", {
            Name = TabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentFrame
        })
        
        -- Grid layout for columns
        local ColumnContainer = MakeElement("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = TabContent
        })
        
        local Columns = {}
        
        -- Create 2-3 columns
        for i = 1, 3 do
            local Column = MakeElement("Frame", {
                Name = "Column" .. i,
                Size = UDim2.new(0.32, 0, 0, 0),
                Position = UDim2.new((i-1) * 0.34, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = ColumnContainer
            })
            
            MakeElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = Column
            })
            
            table.insert(Columns, Column)
        end
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.TextColor3 = Theme.TextDark
                tab.Content.Visible = false
            end
            
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
            Window.CurrentTab = TabName
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= TabName then
                Tween(TabButton, {TextColor3 = Theme.Text})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= TabName then
                Tween(TabButton, {TextColor3 = Theme.TextDark})
            end
        end)
        
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Columns = Columns,
            CurrentColumn = 1
        }
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
            Window.CurrentTab = TabName
        end
        
        -- Update canvas size when columns change
        ColumnContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ColumnContainer.AbsoluteSize.Y + 20)
        end)
        
        -- Create Section
        function Tab:CreateSection(sectionName, columnIndex)
            columnIndex = columnIndex or Tab.CurrentColumn
            local Column = Tab.Columns[columnIndex]
            
            -- Auto-cycle columns if not specified
            if not sectionName.Column then
                Tab.CurrentColumn = (Tab.CurrentColumn % 3) + 1
            end
            
            local Section = MakeElement("Frame", {
                Name = sectionName,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Column
            })
            
            MakeElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Section
            })
            
            -- Section Header
            local Header = MakeElement("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                Parent = Section
            })
            
            local HeaderIcon = MakeElement("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 10, 0, 7),
                BackgroundTransparency = 1,
                Text = "⚙",
                TextColor3 = Theme.Accent,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = Header
            })
            
            local HeaderText = MakeElement("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 35, 0, 0),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Header
            })
            
            -- Section Content
            local Content = MakeElement("Frame", {
                Name = "Content",
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Section
            })
            
            MakeElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                Parent = Content
            })
            
            local SectionObj = {
                Container = Section,
                Content = Content
            }
            
            -- Add Checkbox (Toggle)
            function SectionObj:AddToggle(config)
                config = config or {}
                local Name = config.Name or "Toggle"
                local Default = config.Default or false
                local Callback = config.Callback or function() end
                local Flag = config.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local Toggle = MakeElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    Parent = Content
                })
                
                -- Checkbox
                local Checkbox = MakeElement("TextButton", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(1, -20, 0, 5),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 1,
                    BorderColor3 = Theme.Border,
                    Text = "",
                    Parent = Toggle
                })
                
                MakeElement("UICorner", {
                    CornerRadius = UDim.new(0, 3),
                    Parent = Checkbox
                })
                
                -- Checkmark
                local Checkmark = MakeElement("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "✓",
                    TextColor3 = Theme.Accent,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Visible = Default,
                    Parent = Checkbox
                })
                
                -- Label
                local Label = MakeElement("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle
                })
                
                local toggled = Default
                
                Checkbox.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Checkmark.Visible = toggled
                    
                    if toggled then
                        Checkbox.BackgroundColor3 = Theme.Accent
                    else
                        Checkbox.BackgroundColor3 = Theme.Tertiary
                    end
                    
                    if Flag then
                        ConfigData[Flag] = toggled
                    end
                    
                    pcall(Callback, toggled)
                end)
                
                Checkbox.MouseEnter:Connect(function()
                    Tween(Checkbox, {BackgroundColor3 = toggled and Theme.Accent or Theme.Hover})
                end)
                
                Checkbox.MouseLeave:Connect(function()
                    Tween(Checkbox, {BackgroundColor3 = toggled and Theme.Accent or Theme.Tertiary})
                end)
                
                return {
                    SetValue = function(value)
                        toggled = value
                        Checkmark.Visible = value
                        Checkbox.BackgroundColor3 = value and Theme.Accent or Theme.Tertiary
                        if Flag then
                            ConfigData[Flag] = value
                        end
                    end
                }
            end
            
            -- Add Dropdown
            function SectionObj:AddDropdown(config)
                config = config or {}
                local Name = config.Name or "Dropdown"
                local Options = config.Options or {}
                local Default = config.Default or Options[1]
                local Callback = config.Callback or function() end
                local Flag = config.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local Dropdown = MakeElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Parent = Content
                })
                
                local DropButton = MakeElement("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = Dropdown
                })
                
                MakeElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = DropButton
                })
                
                local DropLabel = MakeElement("TextLabel", {
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropButton
                })
                
                local DropValue = MakeElement("TextLabel", {
                    Size = UDim2.new(0, 80, 1, 0),
                    Position = UDim2.new(1, -95, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Default or "",
                    TextColor3 = Theme.TextDark,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = DropButton
                })
                
                local Arrow = MakeElement("TextLabel", {
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = Theme.TextDark,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    Parent = DropButton
                })
                
                local OptionList = MakeElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 28),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 0,
                    Visible = false,
                    Parent = Dropdown
                })
                
                MakeElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = OptionList
                })
                
                local isOpen = false
                local currentValue = Default
                
                for _, option in ipairs(Options) do
                    local OptionBtn = MakeElement("TextButton", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = Theme.Tertiary,
                        BorderSizePixel = 0,
                        Text = option,
                        TextColor3 = Theme.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        Parent = OptionList
                    })
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        currentValue = option
                        DropValue.Text = option
                        
                        if Flag then
                            ConfigData[Flag] = option
                        end
                        
                        isOpen = false
                        OptionList.Visible = false
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 28)})
                        Tween(Arrow, {Rotation = 0})
                        
                        pcall(Callback, option)
                    end)
                    
                    OptionBtn.MouseEnter:Connect(function()
                        Tween(OptionBtn, {BackgroundColor3 = Theme.Hover})
                    end)
                    
                    OptionBtn.MouseLeave:Connect(function()
                        Tween(OptionBtn, {BackgroundColor3 = Theme.Tertiary})
                    end)
                end
                
                DropButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        OptionList.Visible = true
                        local listHeight = math.min(#Options * 26, 120)
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 28 + listHeight)})
                        Tween(OptionList, {Size = UDim2.new(1, 0, 0, listHeight)})
                        Tween(Arrow, {Rotation = 180})
                    else
                        OptionList.Visible = false
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 28)})
                        Tween(Arrow, {Rotation = 0})
                    end
                end)
                
                return {
                    SetValue = function(value)
                        currentValue = value
                        DropValue.Text = value
                        if Flag then
                            ConfigData[Flag] = value
                        end
                    end
                }
            end
            
            -- Add Slider
            function SectionObj:AddSlider(config)
                config = config or {}
                local Name = config.Name or "Slider"
                local Min = config.Min or 0
                local Max = config.Max or 100
                local Default = config.Default or Min
                local Increment = config.Increment or 1
                local Callback = config.Callback or function() end
                local Flag = config.Flag
                
                if Flag then
                    ConfigData[Flag] = Default
                end
                
                local Slider = MakeElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    Parent = Content
                })
                
                local Label = MakeElement("TextLabel", {
                    Size = UDim2.new(1, -40, 0, 20),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Slider
                })
                
                local Value = MakeElement("TextLabel", {
                    Size = UDim2.new(0, 35, 0, 20),
                    Position = UDim2.new(1, -35, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(Default),
                    TextColor3 = Theme.Accent,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Slider
                })
                
                local SliderBar = MakeElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0, 28),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 0,
                    Parent = Slider
                })
                
                MakeElement("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderBar
                })
                
                local Fill = MakeElement("Frame", {
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = SliderBar
                })
                
                MakeElement("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Fill
                })
                
                local Dot = MakeElement("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new((Default - Min) / (Max - Min), -6, 0.5, -6),
                    BackgroundColor3 = Theme.Text,
                    BorderSizePixel = 0,
                    Parent = SliderBar
                })
                
                MakeElement("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Dot
                })
                
                local dragging = false
                local currentValue = Default
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor((Min + (Max - Min) * pos) / Increment + 0.5) * Increment
                    value = math.clamp(value, Min, Max)
                    
                    currentValue = value
                    Value.Text = tostring(value)
                    
                    if Flag then
                        ConfigData[Flag] = value
                    end
                    
                    Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                    Tween(Dot, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
                    
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
                        Value.Text = tostring(value)
                        if Flag then
                            ConfigData[Flag] = value
                        end
                        local pos = (value - Min) / (Max - Min)
                        Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                        Tween(Dot, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
                    end
                }
            end
            
            -- Add Button
            function SectionObj:AddButton(config)
                config = config or {}
                local Name = config.Name or "Button"
                local Callback = config.Callback or function() end
                
                local Button = MakeElement("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 0,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = Content
                })
                
                MakeElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Button
                })
                
                Button.MouseButton1Click:Connect(function()
                    pcall(Callback)
                end)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Hover})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Tertiary})
                end)
            end
            
            return SectionObj
        end
        
        return Tab
    end
    
    -- Config Save/Load
    function Window:SaveConfig(name)
        name = name or "default"
        local success, err = pcall(function()
            writefile("nebulatech_" .. name .. ".json", HttpService:JSONEncode(ConfigData))
        end)
        return success
    end
    
    function Window:LoadConfig(name)
        name = name or "default"
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("nebulatech_" .. name .. ".json"))
        end)
        
        if success and data then
            for flag, value in pairs(data) do
                ConfigData[flag] = value
            end
            return true
        end
        return false
    end
    
    return Window
end

return Library
