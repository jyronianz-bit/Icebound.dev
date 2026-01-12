-- Tundra UI Library v1.0
-- Modern, macOS-inspired UI framework for Roblox
-- Features: Fluent design, theme system, save manager, notifications, keybinds, warnings, risky bools, element locking

local Tundra = {
    Version = "1.0.0",
    Name = "Tundra",
    CurrentTheme = "Dark",
    LockedElements = {}
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- ====================
-- THEME SYSTEM
-- ====================
Tundra.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 35),
        SecondaryBackground = Color3.fromRGB(40, 40, 45),
        TertiaryBackground = Color3.fromRGB(50, 50, 55),
        
        Primary = Color3.fromRGB(0, 122, 255),
        PrimaryHover = Color3.fromRGB(10, 132, 255),
        PrimaryPressed = Color3.fromRGB(0, 100, 220),
        
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Danger = Color3.fromRGB(255, 59, 48),
        
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        DisabledText = Color3.fromRGB(120, 120, 120),
        
        Border = Color3.fromRGB(70, 70, 75),
        Shadow = Color3.fromRGB(0, 0, 0, 0.3),
        
        ToggleOn = Color3.fromRGB(52, 199, 89),
        ToggleOff = Color3.fromRGB(70, 70, 75),
        
        Risky = Color3.fromRGB(255, 69, 58),
        Safe = Color3.fromRGB(52, 199, 89)
    },
    
    Light = {
        Background = Color3.fromRGB(242, 242, 247),
        SecondaryBackground = Color3.fromRGB(255, 255, 255),
        TertiaryBackground = Color3.fromRGB(248, 248, 248),
        
        Primary = Color3.fromRGB(0, 122, 255),
        PrimaryHover = Color3.fromRGB(10, 132, 255),
        PrimaryPressed = Color3.fromRGB(0, 100, 220),
        
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Danger = Color3.fromRGB(255, 59, 48),
        
        Text = Color3.fromRGB(0, 0, 0),
        SubText = Color3.fromRGB(60, 60, 67),
        DisabledText = Color3.fromRGB(142, 142, 147),
        
        Border = Color3.fromRGB(209, 209, 214),
        Shadow = Color3.fromRGB(0, 0, 0, 0.1),
        
        ToggleOn = Color3.fromRGB(52, 199, 89),
        ToggleOff = Color3.fromRGB(209, 209, 214),
        
        Risky = Color3.fromRGB(255, 69, 58),
        Safe = Color3.fromRGB(52, 199, 89)
    },
    
    Dracula = {
        Background = Color3.fromRGB(40, 42, 54),
        SecondaryBackground = Color3.fromRGB(68, 71, 90),
        TertiaryBackground = Color3.fromRGB(50, 52, 64),
        
        Primary = Color3.fromRGB(189, 147, 249),
        PrimaryHover = Color3.fromRGB(199, 157, 255),
        PrimaryPressed = Color3.fromRGB(179, 137, 239),
        
        Success = Color3.fromRGB(80, 250, 123),
        Warning = Color3.fromRGB(241, 250, 140),
        Danger = Color3.fromRGB(255, 85, 85),
        
        Text = Color3.fromRGB(248, 248, 242),
        SubText = Color3.fromRGB(139, 233, 253),
        DisabledText = Color3.fromRGB(98, 114, 164),
        
        Border = Color3.fromRGB(68, 71, 90),
        Shadow = Color3.fromRGB(0, 0, 0, 0.4),
        
        ToggleOn = Color3.fromRGB(80, 250, 123),
        ToggleOff = Color3.fromRGB(68, 71, 90),
        
        Risky = Color3.fromRGB(255, 121, 198),
        Safe = Color3.fromRGB(80, 250, 123)
    }
}

-- ====================
-- UTILITY FUNCTIONS
-- ====================
function Tundra.Create(class, properties)
    local obj = Instance.new(class)
    for property, value in pairs(properties) do
        obj[property] = value
    end
    return obj
end

function Tundra.Tween(obj, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

function Tundra.Roundify(obj, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 6)
    corner.Parent = obj
    return corner
end

function Tundra.AddShadow(obj, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 14, 1, 14)
    shadow.Position = UDim2.new(0, -7, 0, -7)
    shadow.ZIndex = obj.ZIndex - 1
    shadow.Parent = obj
    return shadow
end

-- ====================
-- ELEMENT LOCKING SYSTEM
-- ====================
function Tundra.LockElement(element)
    Tundra.LockedElements[element] = true
    if element:IsA("GuiButton") then
        element.AutoButtonColor = false
        element.Active = false
        Tundra.Tween(element, {ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].DisabledText}, 0.2)
    end
end

function Tundra.UnlockElement(element)
    Tundra.LockedElements[element] = nil
    if element:IsA("GuiButton") then
        element.AutoButtonColor = true
        element.Active = true
        Tundra.Tween(element, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end
end

function Tundra.IsLocked(element)
    return Tundra.LockedElements[element] == true
end

-- ====================
-- SAVE MANAGER
-- ====================
Tundra.SaveManager = {
    DefaultFileName = "TundraSettings.json",
    Data = {}
}

function Tundra.SaveManager:Load(filename)
    local success, result = pcall(function()
        if not isfile then return {} end
        if isfile(filename or self.DefaultFileName) then
            local data = readfile(filename or self.DefaultFileName)
            return HttpService:JSONDecode(data)
        end
        return {}
    end)
    
    if success then
        self.Data = result
        return result
    else
        warn("[Tundra] Failed to load settings:", result)
        return {}
    end
end

function Tundra.SaveManager:Save(filename)
    local success, result = pcall(function()
        if not writefile then return false end
        local json = HttpService:JSONEncode(self.Data)
        writefile(filename or self.DefaultFileName, json)
        return true
    end)
    
    if not success then
        warn("[Tundra] Failed to save settings:", result)
    end
    return success
end

function Tundra.SaveManager:Set(key, value)
    self.Data[key] = value
    self:Save()
end

function Tundra.SaveManager:Get(key, default)
    return self.Data[key] or default
end

-- ====================
-- WINDOW SYSTEM
-- ====================
function Tundra.CreateWindow(options)
    options = options or {}
    
    local window = Tundra.Create("ScreenGui", {
        Name = options.Name or "TundraWindow",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local mainFrame = Tundra.Create("Frame", {
        Parent = window,
        Size = UDim2.new(0, options.Width or 500, 0, options.Height or 400),
        Position = UDim2.new(0.5, -((options.Width or 500)/2), 0.5, -((options.Height or 400)/2)),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Background,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(mainFrame, 12)
    Tundra.AddShadow(mainFrame, 0.3)
    
    -- Title Bar
    local titleBar = Tundra.Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        BorderSizePixel = 0
    })
    
    Tundra.Create("UICorner", {
        Parent = titleBar,
        CornerRadius = UDim.new(0, 12)
    })
    
    local title = Tundra.Create("TextLabel", {
        Parent = titleBar,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = options.Title or "Tundra Window",
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    -- Close Button
    local closeButton = Tundra.Create("TextButton", {
        Parent = titleBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Danger,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.SourceSansBold
    })
    
    Tundra.Roundify(closeButton, 8)
    
    closeButton.MouseButton1Click:Connect(function()
        Tundra.Tween(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.2):Play()
        task.wait(0.2)
        window:Destroy()
    end)
    
    -- Content Area
    local content = Tundra.Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Dragging
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    return {
        Window = window,
        Frame = mainFrame,
        Content = content,
        Title = title,
        Close = closeButton,
        
        AddTab = function(self, tabName, icon)
            return Tundra.CreateTab(self.Content, tabName, icon)
        end
    }
end

-- ====================
-- TAB SYSTEM
-- ====================
function Tundra.CreateTab(parent, tabName, icon)
    local tabButton = Tundra.Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(0, 120, 0, 35),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = tabName,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        Font = Enum.Font.SourceSansSemibold
    })
    
    Tundra.Roundify(tabButton, 6)
    
    local tabContent = Tundra.Create("ScrollingFrame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    })
    
    local listLayout = Tundra.Create("UIListLayout", {
        Parent = tabContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    local padding = Tundra.Create("UIPadding", {
        Parent = tabContent,
        PaddingLeft = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10)
    })
    
    tabButton.MouseButton1Click:Connect(function()
        -- Hide all tab contents
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("ScrollingFrame") and child.Name == "TabContent" then
                child.Visible = false
            end
        end
        
        -- Show this tab's content
        tabContent.Visible = true
        
        -- Update button appearance
        Tundra.Tween(tabButton, {
            BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary
        }, 0.2)
    end)
    
    return {
        Button = tabButton,
        Content = tabContent,
        
        AddSection = function(self, sectionName)
            return Tundra.CreateSection(self.Content, sectionName)
        end,
        
        AddButton = function(self, buttonName, callback)
            return Tundra.CreateButton(self.Content, buttonName, callback)
        end,
        
        AddToggle = function(self, toggleName, defaultValue, callback, risky)
            return Tundra.CreateToggle(self.Content, toggleName, defaultValue, callback, risky)
        end,
        
        AddSlider = function(self, sliderName, minValue, maxValue, defaultValue, callback)
            return Tundra.CreateSlider(self.Content, sliderName, minValue, maxValue, defaultValue, callback)
        end,
        
        AddDropdown = function(self, dropdownName, options, defaultOption, callback)
            return Tundra.CreateDropdown(self.Content, dropdownName, options, defaultOption, callback)
        end,
        
        AddKeybind = function(self, keybindName, defaultKey, callback, mode)
            return Tundra.CreateKeybind(self.Content, keybindName, defaultKey, callback, mode)
        end,
        
        AddInput = function(self, inputName, placeholder, callback)
            return Tundra.CreateInput(self.Content, inputName, placeholder, callback)
        end,
        
        AddLabel = function(self, labelText)
            return Tundra.CreateLabel(self.Content, labelText)
        end
    }
end

-- ====================
-- SECTION
-- ====================
function Tundra.CreateSection(parent, sectionName)
    local section = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].TertiaryBackground,
        LayoutOrder = parent:GetChildren().Size
    })
    
    Tundra.Roundify(section, 8)
    
    local label = Tundra.Create("TextLabel", {
        Parent = section,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = sectionName,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    return {
        Frame = section,
        Label = label
    }
end

-- ====================
-- BUTTON
-- ====================
function Tundra.CreateButton(parent, buttonName, callback)
    local button = Tundra.Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 35),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary,
        Text = buttonName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.SourceSansSemibold,
        LayoutOrder = parent:GetChildren().Size,
        AutoButtonColor = false
    })
    
    Tundra.Roundify(button, 6)
    
    local originalColor = button.BackgroundColor3
    local hoverColor = Tundra.Themes[Tundra.CurrentTheme].PrimaryHover
    local pressedColor = Tundra.Themes[Tundra.CurrentTheme].PrimaryPressed
    
    button.MouseEnter:Connect(function()
        if not Tundra.IsLocked(button) then
            Tundra.Tween(button, {BackgroundColor3 = hoverColor}, 0.2)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not Tundra.IsLocked(button) then
            Tundra.Tween(button, {BackgroundColor3 = originalColor}, 0.2)
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        if not Tundra.IsLocked(button) then
            Tundra.Tween(button, {BackgroundColor3 = pressedColor}, 0.1)
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        if not Tundra.IsLocked(button) then
            Tundra.Tween(button, {BackgroundColor3 = hoverColor}, 0.1)
            if callback then
                callback()
            end
        end
    end)
    
    return {
        Button = button,
        Lock = function()
            Tundra.LockElement(button)
        end,
        Unlock = function()
            Tundra.UnlockElement(button)
        end,
        SetText = function(text)
            button.Text = text
        end,
        SetCallback = function(newCallback)
            callback = newCallback
        end
    }
end

-- ====================
-- TOGGLE (WITH RISKY BOOL)
-- ====================
function Tundra.CreateToggle(parent, toggleName, defaultValue, callback, risky)
    local toggle = {
        Value = defaultValue or false,
        Risky = risky or false
    }
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 35),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local label = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = toggleName,
        TextColor3 = risky and Tundra.Themes[Tundra.CurrentTheme].Risky or Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    local toggleFrame = Tundra.Create("Frame", {
        Parent = container,
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].ToggleOff,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(toggleFrame, 10)
    
    local toggleCircle = Tundra.Create("Frame", {
        Parent = toggleFrame,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(toggleCircle, 8)
    
    local function updateToggle()
        if toggle.Value then
            Tundra.Tween(toggleFrame, {
                BackgroundColor3 = risky and Tundra.Themes[Tundra.CurrentTheme].Risky or Tundra.Themes[Tundra.CurrentTheme].ToggleOn
            }, 0.2)
            Tundra.Tween(toggleCircle, {
                Position = UDim2.new(1, -18, 0.5, -8)
            }, 0.2)
        else
            Tundra.Tween(toggleFrame, {
                BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].ToggleOff
            }, 0.2)
            Tundra.Tween(toggleCircle, {
                Position = UDim2.new(0, 2, 0.5, -8)
            }, 0.2)
        end
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not Tundra.IsLocked(toggleFrame) then
                toggle.Value = not toggle.Value
                updateToggle()
                if callback then
                    callback(toggle.Value)
                end
            end
        end
    end)
    
    updateToggle()
    
    return {
        Frame = container,
        Label = label,
        Toggle = toggleFrame,
        
        GetValue = function()
            return toggle.Value
        end,
        
        SetValue = function(value, triggerCallback)
            toggle.Value = value
            updateToggle()
            if triggerCallback and callback then
                callback(toggle.Value)
            end
        end,
        
        Toggle = function()
            toggle.Value = not toggle.Value
            updateToggle()
            if callback then
                callback(toggle.Value)
            end
        end,
        
        Lock = function()
            Tundra.LockElement(toggleFrame)
        end,
        
        Unlock = function()
            Tundra.UnlockElement(toggleFrame)
        end,
        
        SetRisky = function(isRisky)
            risky = isRisky
            label.TextColor3 = risky and Tundra.Themes[Tundra.CurrentTheme].Risky or Tundra.Themes[Tundra.CurrentTheme].Text
            updateToggle()
        end
    }
end

-- ====================
-- SLIDER
-- ====================
function Tundra.CreateSlider(parent, sliderName, minValue, maxValue, defaultValue, callback)
    local slider = {
        Value = defaultValue or minValue,
        Min = minValue or 0,
        Max = maxValue or 100,
        Dragging = false
    }
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local label = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = sliderName,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    local valueLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(defaultValue or minValue),
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        Font = Enum.Font.SourceSans
    })
    
    local track = Tundra.Create("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].ToggleOff,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(track, 3)
    
    local fill = Tundra.Create("Frame", {
        Parent = track,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(fill, 3)
    
    local thumb = Tundra.Create("Frame", {
        Parent = track,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(thumb, 8)
    Tundra.AddShadow(thumb, 0.3)
    
    local function updateSlider(value)
        slider.Value = math.clamp(value, slider.Min, slider.Max)
        local percentage = (slider.Value - slider.Min) / (slider.Max - slider.Min)
        
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        thumb.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = string.format("%.1f", slider.Value)
        
        if callback then
            callback(slider.Value)
        end
    end
    
    local function onInputChanged(input)
        if slider.Dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = slider.Min + (relativeX * (slider.Max - slider.Min))
            updateSlider(value)
        end
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not Tundra.IsLocked(track) then
                slider.Dragging = true
                onInputChanged(input)
            end
        end
    end)
    
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slider.Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(onInputChanged)
    
    updateSlider(defaultValue or minValue)
    
    return {
        Frame = container,
        GetValue = function()
            return slider.Value
        end,
        SetValue = function(value)
            updateSlider(value)
        end,
        Lock = function()
            Tundra.LockElement(track)
        end,
        Unlock = function()
            Tundra.UnlockElement(track)
        end
    }
end

-- ====================
-- DROPDOWN
-- ====================
function Tundra.CreateDropdown(parent, dropdownName, options, defaultOption, callback)
    local dropdown = {
        Value = defaultOption or options[1],
        Options = options,
        Open = false
    }
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 35),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local label = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = dropdownName,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    local button = Tundra.Create("TextButton", {
        Parent = container,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 100, 0, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = dropdown.Value,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        Font = Enum.Font.SourceSans
    })
    
    Tundra.Roundify(button, 6)
    
    local dropdownFrame = Tundra.Create("ScrollingFrame", {
        Parent = container,
        Size = UDim2.new(1, -100, 0, 0),
        Position = UDim2.new(0, 100, 1, 5),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Border,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10
    })
    
    Tundra.Roundify(dropdownFrame, 6)
    Tundra.AddShadow(dropdownFrame, 0.3)
    
    local listLayout = Tundra.Create("UIListLayout", {
        Parent = dropdownFrame,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local function toggleDropdown()
        if Tundra.IsLocked(button) then return end
        
        dropdown.Open = not dropdown.Open
        if dropdown.Open then
            Tundra.Tween(dropdownFrame, {
                Size = UDim2.new(1, -100, 0, math.min(#options * 30, 150))
            }, 0.2)
            dropdownFrame.Visible = true
        else
            Tundra.Tween(dropdownFrame, {
                Size = UDim2.new(1, -100, 0, 0)
            }, 0.2):Play()
            task.wait(0.2)
            dropdownFrame.Visible = false
        end
    end
    
    button.MouseButton1Click:Connect(toggleDropdown)
    
    for _, option in ipairs(options) do
        local optionButton = Tundra.Create("TextButton", {
            Parent = dropdownFrame,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
            Text = option,
            TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
            TextSize = 14,
            Font = Enum.Font.SourceSans,
            LayoutOrder = _
        })
        
        Tundra.Roundify(optionButton, 4)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.Value = option
            button.Text = option
            toggleDropdown()
            if callback then
                callback(option)
            end
        end)
        
        optionButton.MouseEnter:Connect(function()
            Tundra.Tween(optionButton, {
                BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].TertiaryBackground
            }, 0.2)
        end)
        
        optionButton.MouseLeave:Connect(function()
            Tundra.Tween(optionButton, {
                BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground
            }, 0.2)
        end)
    end
    
    return {
        Frame = container,
        GetValue = function()
            return dropdown.Value
        end,
        SetValue = function(value)
            if table.find(options, value) then
                dropdown.Value = value
                button.Text = value
                if callback then
                    callback(value)
                end
            end
        end,
        Lock = function()
            Tundra.LockElement(button)
        end,
        Unlock = function()
            Tundra.UnlockElement(button)
        end
    }
end

-- ====================
-- KEYBIND
-- ====================
function Tundra.CreateKeybind(parent, keybindName, defaultKey, callback, mode)
    mode = mode or "Toggle" -- Toggle, Hold, Always
    
    local keybind = {
        Value = defaultKey or Enum.KeyCode.E,
        Mode = mode,
        Active = false,
        Listening = false
    }
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 35),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local label = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = keybindName,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    local button = Tundra.Create("TextButton", {
        Parent = container,
        Size = UDim2.new(0, 90, 1, 0),
        Position = UDim2.new(1, -90, 0, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = tostring(keybind.Value):gsub("Enum.KeyCode.", ""),
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        Font = Enum.Font.SourceSans
    })
    
    Tundra.Roundify(button, 6)
    
    local function setKey(key)
        keybind.Value = key
        button.Text = tostring(key):gsub("Enum.KeyCode.", "")
        keybind.Listening = false
        button.BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground
    end
    
    button.MouseButton1Click:Connect(function()
        if not Tundra.IsLocked(button) then
            keybind.Listening = true
            button.Text = "..."
            button.BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if keybind.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                setKey(input.KeyCode)
            end
        elseif input.KeyCode == keybind.Value then
            if mode == "Toggle" then
                keybind.Active = not keybind.Active
                if callback then
                    callback(keybind.Active)
                end
            elseif mode == "Hold" then
                keybind.Active = true
                if callback then
                    callback(true)
                end
            elseif mode == "Always" then
                if callback then
                    callback()
                end
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if mode == "Hold" and input.KeyCode == keybind.Value then
            keybind.Active = false
            if callback then
                callback(false)
            end
        end
    end)
    
    return {
        Frame = container,
        GetKey = function()
            return keybind.Value
        end,
        SetKey = function(key)
            setKey(key)
        end,
        GetMode = function()
            return keybind.Mode
        end,
        SetMode = function(newMode)
            keybind.Mode = newMode
        end,
        Lock = function()
            Tundra.LockElement(button)
        end,
        Unlock = function()
            Tundra.UnlockElement(button)
        end
    }
end

-- ====================
-- INPUT FIELD
-- ====================
function Tundra.CreateInput(parent, inputName, placeholder, callback)
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local label = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = inputName,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    local textBox = Tundra.Create("TextBox", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = "",
        PlaceholderText = placeholder or "Enter text...",
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        PlaceholderColor3 = Tundra.Themes[Tundra.CurrentTheme].DisabledText,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        ClearTextOnFocus = false
    })
    
    Tundra.Roundify(textBox, 6)
    
    textBox.Focused:Connect(function()
        Tundra.Tween(textBox, {
            BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].TertiaryBackground
        }, 0.2)
    end)
    
    textBox.FocusLost:Connect(function()
        Tundra.Tween(textBox, {
            BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground
        }, 0.2)
        if callback then
            callback(textBox.Text)
        end
    end)
    
    return {
        Frame = container,
        GetText = function()
            return textBox.Text
        end,
        SetText = function(text)
            textBox.Text = text
        end,
        Lock = function()
            Tundra.LockElement(textBox)
            textBox.TextEditable = false
        end,
        Unlock = function()
            Tundra.UnlockElement(textBox)
            textBox.TextEditable = true
        end
    }
end

-- ====================
-- LABEL
-- ====================
function Tundra.CreateLabel(parent, labelText)
    local label = Tundra.Create("TextLabel", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSans,
        LayoutOrder = parent:GetChildren().Size,
        TextWrapped = true
    })
    
    return {
        Label = label,
        SetText = function(text)
            label.Text = text
        end
    }
end

-- ====================
-- WARNING BOX
-- ====================
function Tundra.ShowWarning(title, message, buttons)
    local warning = Tundra.Create("ScreenGui", {
        Name = "TundraWarning",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local overlay = Tundra.Create("Frame", {
        Parent = warning,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    
    local mainFrame = Tundra.Create("Frame", {
        Parent = overlay,
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Background,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(mainFrame, 12)
    Tundra.AddShadow(mainFrame, 0.5)
    
    -- Warning Icon
    local icon = Tundra.Create("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, -25, 0, 20),
        BackgroundTransparency = 1,
        Text = "⚠",
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Warning,
        TextSize = 40,
        Font = Enum.Font.SourceSansBold
    })
    
    -- Title
    local titleLabel = Tundra.Create("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 80),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 18,
        Font = Enum.Font.SourceSansSemibold,
        TextWrapped = true
    })
    
    -- Message
    local messageLabel = Tundra.Create("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 110),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextWrapped = true
    })
    
    -- Button Container
    local buttonContainer = Tundra.Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 1, -50),
        BackgroundTransparency = 1
    })
    
    local results = {}
    
    if buttons then
        for i, buttonData in ipairs(buttons) do
            local button = Tundra.Create("TextButton", {
                Parent = buttonContainer,
                Size = UDim2.new(0, 80, 1, 0),
                Position = UDim2.new(1 - (#buttons - i + 1) * 0.25, -10, 0, 0),
                BackgroundColor3 = buttonData.Risky and Tundra.Themes[Tundra.CurrentTheme].Danger or Tundra.Themes[Tundra.CurrentTheme].Primary,
                Text = buttonData.Text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.SourceSansSemibold
            })
            
            Tundra.Roundify(button, 6)
            
            button.MouseButton1Click:Connect(function()
                if buttonData.Callback then
                    buttonData.Callback()
                end
                warning:Destroy()
            end)
        end
    else
        local okButton = Tundra.Create("TextButton", {
            Parent = buttonContainer,
            Size = UDim2.new(0, 80, 1, 0),
            Position = UDim2.new(0.5, -40, 0, 0),
            BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary,
            Text = "OK",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.SourceSansSemibold
        })
        
        Tundra.Roundify(okButton, 6)
        
        okButton.MouseButton1Click:Connect(function()
            warning:Destroy()
        end)
    end
    
    warning.Parent = game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return warning
end

-- ====================
-- NOTIFICATION SYSTEM
-- ====================
function Tundra.Notify(title, message, duration, notificationType)
    duration = duration or 5
    notificationType = notificationType or "Info" -- Info, Success, Warning, Error
    
    local colors = {
        Info = Tundra.Themes[Tundra.CurrentTheme].Primary,
        Success = Tundra.Themes[Tundra.CurrentTheme].Success,
        Warning = Tundra.Themes[Tundra.CurrentTheme].Warning,
        Error = Tundra.Themes[Tundra.CurrentTheme].Danger
    }
    
    local notification = Tundra.Create("ScreenGui", {
        Name = "TundraNotification",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local mainFrame = Tundra.Create("Frame", {
        Parent = notification,
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -320, 1, -100),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Background,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(mainFrame, 8)
    Tundra.AddShadow(mainFrame, 0.3)
    
    local accent = Tundra.Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = colors[notificationType],
        BorderSizePixel = 0
    })
    
    Tundra.Create("UICorner", {
        Parent = accent,
        CornerRadius = UDim.new(0, 8)
    })
    
    local titleLabel = Tundra.Create("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansSemibold
    })
    
    local messageLabel = Tundra.Create("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 15, 0, 35),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSans,
        TextWrapped = true
    })
    
    notification.Parent = game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Slide in animation
    mainFrame.Position = UDim2.new(1, 300, 1, -100)
    Tundra.Tween(mainFrame, {
        Position = UDim2.new(1, -320, 1, -100)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Auto dismiss
    task.wait(duration)
    
    -- Slide out animation
    Tundra.Tween(mainFrame, {
        Position = UDim2.new(1, 300, 1, -100)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    
    task.wait(0.3)
    notification:Destroy()
    
    return notification
end

-- ====================
-- THEME MANAGER
-- ====================
function Tundra.SetTheme(themeName)
    if Tundra.Themes[themeName] then
        Tundra.CurrentTheme = themeName
        return true
    end
    return false
end

function Tundra.GetCurrentTheme()
    return Tundra.Themes[Tundra.CurrentTheme]
end

function Tundra.CreateCustomTheme(name, colors)
    Tundra.Themes[name] = colors
    return true
end

-- ====================
-- INITIALIZATION
-- ====================
function Tundra.Init()
    -- Load saved theme
    local savedTheme = Tundra.SaveManager:Get("Theme", "Dark")
    Tundra.SetTheme(savedTheme)
    
    -- Auto-save theme changes
    local oldTheme = Tundra.CurrentTheme
    while true do
        task.wait(1)
        if Tundra.CurrentTheme ~= oldTheme then
            Tundra.SaveManager:Set("Theme", Tundra.CurrentTheme)
            oldTheme = Tundra.CurrentTheme
        end
    end
end

-- Auto-initialize if possible
task.spawn(function()
    Tundra.Init()
end)

return Tundra
