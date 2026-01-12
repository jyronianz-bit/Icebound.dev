--hi veal
-- Tundra.win UI Library
-- A modern, transparent Roblox UI library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Tundra = {}
Tundra.__index = Tundra

-- Utility Functions
local function CreateTween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            CreateTween(frame, {
                Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            }, 0.1)
        end
    end)
end

local function RGBToHSV(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v = 0, 0, max
    local d = max - min
    s = max == 0 and 0 or d / max

    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end

    return h, s, v
end

local function HSVToRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return Color3.new(r, g, b)
end

-- Main Library Functions
function Tundra:CreateWindow(title)
    local window = {}
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TundraUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Blur Effect
    local BlurEffect = Instance.new("ImageLabel")
    BlurEffect.Name = "Blur"
    BlurEffect.Size = UDim2.new(1, 0, 1, 0)
    BlurEffect.BackgroundTransparency = 1
    BlurEffect.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    BlurEffect.ImageTransparency = 0.9
    BlurEffect.ScaleType = Enum.ScaleType.Slice
    BlurEffect.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TopBar.BackgroundTransparency = 0.2
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    -- Fix corner at bottom
    local CornerFix = Instance.new("Frame")
    CornerFix.Size = UDim2.new(1, 0, 0, 8)
    CornerFix.Position = UDim2.new(0, 0, 1, -8)
    CornerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    CornerFix.BackgroundTransparency = 0.2
    CornerFix.BorderSizePixel = 0
    CornerFix.Parent = TopBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Tundra.win"
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Mac Buttons Container
    local MacButtons = Instance.new("Frame")
    MacButtons.Name = "MacButtons"
    MacButtons.Size = UDim2.new(0, 60, 0, 20)
    MacButtons.Position = UDim2.new(1, -70, 0.5, -10)
    MacButtons.BackgroundTransparency = 1
    MacButtons.Parent = TopBar
    
    -- Close Button (Red)
    local CloseButton = Instance.new("Frame")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 12, 0, 12)
    CloseButton.Position = UDim2.new(0, 0, 0.5, -6)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = MacButtons
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton
    
    local CloseButton_Input = Instance.new("TextButton")
    CloseButton_Input.Size = UDim2.new(1, 0, 1, 0)
    CloseButton_Input.BackgroundTransparency = 1
    CloseButton_Input.Text = ""
    CloseButton_Input.Parent = CloseButton
    
    CloseButton_Input.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button (Yellow)
    local MinimizeButton = Instance.new("Frame")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 12, 0, 12)
    MinimizeButton.Position = UDim2.new(0, 20, 0.5, -6)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 189, 68)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = MacButtons
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(1, 0)
    MinimizeCorner.Parent = MinimizeButton
    
    local MinimizeButton_Input = Instance.new("TextButton")
    MinimizeButton_Input.Size = UDim2.new(1, 0, 1, 0)
    MinimizeButton_Input.BackgroundTransparency = 1
    MinimizeButton_Input.Text = ""
    MinimizeButton_Input.Parent = MinimizeButton
    
    local minimized = false
    MinimizeButton_Input.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, 550, 0, 35)})
        else
            CreateTween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)})
        end
    end)
    
    -- Maximize Button (Green)
    local MaximizeButton = Instance.new("Frame")
    MaximizeButton.Name = "Maximize"
    MaximizeButton.Size = UDim2.new(0, 12, 0, 12)
    MaximizeButton.Position = UDim2.new(0, 40, 0.5, -6)
    MaximizeButton.BackgroundColor3 = Color3.fromRGB(40, 201, 64)
    MaximizeButton.BorderSizePixel = 0
    MaximizeButton.Parent = MacButtons
    
    local MaximizeCorner = Instance.new("UICorner")
    MaximizeCorner.CornerRadius = UDim.new(1, 0)
    MaximizeCorner.Parent = MaximizeButton
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -45)
    TabContainer.Position = UDim2.new(0, 10, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -170, 1, -55)
    ContentContainer.Position = UDim2.new(0, 160, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    window.tabs = {}
    window.currentTab = nil
    
    function window:AddTab(name)
        local tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        TabButton.BackgroundTransparency = 0.4
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.tabs) do
                t.content.Visible = false
                CreateTween(t.button, {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(180, 180, 180)})
            end
            
            TabContent.Visible = true
            window.currentTab = tab
            CreateTween(TabButton, {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(220, 220, 220)})
        end)
        
        if not window.currentTab then
            TabButton.BackgroundTransparency = 0.15
            TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            TabContent.Visible = true
            window.currentTab = tab
        end
        
        tab.button = TabButton
        tab.content = TabContent
        table.insert(window.tabs, tab)
        
        function tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Button.BackgroundTransparency = 0.3
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            Button.TextSize = 13
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                CreateTween(Button, {BackgroundTransparency = 0.15})
            end)
            
            Button.MouseLeave:Connect(function()
                CreateTween(Button, {BackgroundTransparency = 0.3})
            end)
            
            Button.MouseButton1Click:Connect(function()
                CreateTween(Button, {BackgroundTransparency = 0.05})
                wait(0.1)
                CreateTween(Button, {BackgroundTransparency = 0.3})
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        function tab:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text
            SliderFrame.Size = UDim2.new(1, -10, 0, 55)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            SliderFrame.BackgroundTransparency = 0.3
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 40, 0, 20)
            SliderValue.Position = UDim2.new(1, -50, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(160, 160, 160)
            SliderValue.TextSize = 12
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("Frame")
            SliderButton.Size = UDim2.new(0, 12, 0, 12)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            SliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            SliderButton.BorderSizePixel = 0
            SliderButton.Parent = SliderBar
            
            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.CornerRadius = UDim.new(1, 0)
            SliderButtonCorner.Parent = SliderButton
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderButton.Position = UDim2.new(pos, -6, 0.5, -6)
                    SliderValue.Text = tostring(value)
                    
                    if callback then
                        callback(value)
                    end
                end
            end)
            
            return SliderFrame
        end
        
        function tab:AddDropdown(text, options, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = text
            DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            DropdownFrame.BackgroundTransparency = 0.3
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -35, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = text
            DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, 40)
            DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "v"
            DropdownArrow.TextColor3 = Color3.fromRGB(160, 160, 160)
            DropdownArrow.TextSize = 14
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.Parent = DropdownFrame
            
            local DropdownContainer = Instance.new("Frame")
            DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
            DropdownContainer.Position = UDim2.new(0, 0, 0, 40)
            DropdownContainer.BackgroundTransparency = 1
            DropdownContainer.Parent = DropdownFrame
            
            local DropdownList = Instance.new("UIListLayout")
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Parent = DropdownContainer
            
            local isOpen = false
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                OptionButton.BackgroundTransparency = 0.5
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = DropdownContainer
                
                OptionButton.MouseEnter:Connect(function()
                    CreateTween(OptionButton, {BackgroundTransparency = 0.3})
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    CreateTween(OptionButton, {BackgroundTransparency = 0.5})
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownLabel.Text = text .. ": " .. option
                    isOpen = false
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)})
                    CreateTween(DropdownArrow, {Rotation = 0})
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local contentHeight = #options * 30
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40 + contentHeight)})
                    CreateTween(DropdownArrow, {Rotation = 180})
                else
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)})
                    CreateTween(DropdownArrow, {Rotation = 0})
                end
            end)
            
            return DropdownFrame
        end
        
        function tab:AddColorPicker(text, defaultColor, callback)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = text
            ColorFrame.Size = UDim2.new(1, -10, 0, 40)
            ColorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            ColorFrame.BackgroundTransparency = 0.3
            ColorFrame.BorderSizePixel = 0
            ColorFrame.ClipsDescendants = true
            ColorFrame.Parent = TabContent
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 6)
            ColorCorner.Parent = ColorFrame
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -50, 1, 0)
            ColorLabel.Position = UDim2.new(0, 10, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = text
            ColorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ColorLabel.TextSize = 13
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            
            local ColorPreview = Instance.new("Frame")
            ColorPreview.Size = UDim2.new(0, 25, 0, 25)
            ColorPreview.Position = UDim2.new(1, -35, 0.5, -12.5)
            ColorPreview.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255)
            ColorPreview.BorderSizePixel = 0
            ColorPreview.Parent = ColorFrame
            
            local PreviewCorner = Instance.new("UICorner")
            PreviewCorner.CornerRadius = UDim.new(0, 4)
            PreviewCorner.Parent = ColorPreview
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 0, 40)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorFrame
            
            local isOpen = false
            local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)
            local h, s, v = RGBToHSV(currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
            
            -- Color Picker Panel
            local PickerPanel = Instance.new("Frame")
            PickerPanel.Size = UDim2.new(1, -20, 0, 180)
            PickerPanel.Position = UDim2.new(0, 10, 0, 45)
            PickerPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            PickerPanel.BackgroundTransparency = 0.1
            PickerPanel.BorderSizePixel = 0
            PickerPanel.Visible = false
            PickerPanel.Parent = ColorFrame
            
            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 6)
            PickerCorner.Parent = PickerPanel
            
            -- Saturation/Value Picker
            local SVPicker = Instance.new("ImageLabel")
            SVPicker.Size = UDim2.new(1, -60, 1, -15)
            SVPicker.Position = UDim2.new(0, 5, 0, 5)
            SVPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SVPicker.BorderSizePixel = 0
            SVPicker.Image = "rbxassetid://4155801252"
            SVPicker.Parent = PickerPanel
            
            local SVCorner = Instance.new("UICorner")
            SVCorner.CornerRadius = UDim.new(0, 4)
            SVCorner.Parent = SVPicker
            
            local SVCursor = Instance.new("Frame")
            SVCursor.Size = UDim2.new(0, 8, 0, 8)
            SVCursor.Position = UDim2.new(s, -4, 1 - v, -4)
            SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SVCursor.BorderSizePixel = 1
            SVCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SVCursor.Parent = SVPicker
            
            local SVCursorCorner = Instance.new("UICorner")
            SVCursorCorner.CornerRadius = UDim.new(1, 0)
            SVCursorCorner.Parent = SVCursor
            
            -- Hue Picker
            local HuePicker = Instance.new("ImageLabel")
            HuePicker.Size = UDim2.new(0, 20, 1, -15)
            HuePicker.Position = UDim2.new(1, -25, 0, 5)
            HuePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HuePicker.BorderSizePixel = 0
            HuePicker.Image = "rbxassetid://3641079629"
            HuePicker.Parent = PickerPanel
            
            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(0, 4)
            HueCorner.Parent = HuePicker
            
            local HueCursor = Instance.new("Frame")
            HueCursor.Size = UDim2.new(1, 4, 0, 3)
            HueCursor.Position = UDim2.new(0, -2, h, -1.5)
            HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueCursor.BorderSizePixel = 1
            HueCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            HueCursor.Parent = HuePicker
            
            local function updateColor()
                local newColor = HSVToRGB(h, s, v)
                currentColor = newColor
                ColorPreview.BackgroundColor3 = newColor
                SVPicker.BackgroundColor3 = HSVToRGB(h, 1, 1)
                
                if callback then
                    callback(newColor)
                end
            end
            
            local svDragging = false
            local hueDragging = false
            
            SVPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = true
                end
            end)
            
            SVPicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = false
                end
            end)
            
            HuePicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                end
            end)
            
            HuePicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if svDragging then
                        local posX = math.clamp((input.Position.X - SVPicker.AbsolutePosition.X) / SVPicker.AbsoluteSize.X, 0, 1)
                        local posY = math.clamp((input.Position.Y - SVPicker.AbsolutePosition.Y) / SVPicker.AbsoluteSize.Y, 0, 1)
                        
                        s = posX
                        v = 1 - posY
                        
                        SVCursor.Position = UDim2.new(s, -4, 1 - v, -4)
                        updateColor()
                    elseif hueDragging then
                        local posY = math.clamp((input.Position.Y - HuePicker.AbsolutePosition.Y) / HuePicker.AbsoluteSize.Y, 0, 1)
                        h = posY
                        
                        HueCursor.Position = UDim2.new(0, -2, h, -1.5)
                        updateColor()
                    end
                end
            end)
            
            ColorButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PickerPanel.Visible = isOpen
                
                if isOpen then
                    CreateTween(ColorFrame, {Size = UDim2.new(1, -10, 0, 235)})
                else
                    CreateTween(ColorFrame, {Size = UDim2.new(1, -10, 0, 40)})
                end
            end)
            
            return ColorFrame
        end
        
        function tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = text
            Label.Size = UDim2.new(1, -10, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = TabContent
            
            return Label
        end
        
        return tab
    end
    
    return window
end

return Tundra
