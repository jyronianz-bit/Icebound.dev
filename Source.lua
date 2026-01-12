-- Tundra UI Library v2.0 - FIXED VERSION
-- Modern macOS-inspired UI with acrylic blur, PFP area, and Fluent design

local Tundra = {
    Version = "2.0.0",
    Name = "Tundra",
    CurrentTheme = "Dark",
    LockedElements = {},
    Assets = {
        interFont = "rbxassetid://12187365364",
        userInfoBlurred = "rbxassetid://18824089198",
        toggleBackground = "rbxassetid://18772190202",
        togglerHead = "rbxassetid://18772309008",
        buttonImage = "rbxassetid://10709791437",
        searchIcon = "rbxassetid://86737463322606",
        colorWheel = "rbxassetid://2849458409",
        colorTarget = "rbxassetid://73265255323268",
        grid = "rbxassetid://121484455191370",
        globe = "rbxassetid://108952102602834",
        transform = "rbxassetid://90336395745819",
        dropdown = "rbxassetid://18865373378",
        sliderbar = "rbxassetid://18772615246",
        sliderhead = "rbxassetid://18772834246",
        
        -- Lucide Icons
        home = "rbxassetid://10709790925",
        sword = "rbxassetid://10709791277",
        eye = "rbxassetid://10709790603",
        robot = "rbxassetid://10709791112",
        settings = "rbxassetid://10709791047",
        info = "rbxassetid://10709790771",
        user = "rbxassetid://10709791437",
        bell = "rbxassetid://10709790417",
        check = "rbxassetid://10709790485",
        x = "rbxassetid://10709791575",
        chevron_down = "rbxassetid://10709790539",
        search = "rbxassetid://10709791099",
        sun = "rbxassetid://10709791234",
        moon = "rbxassetid://10709790839",
        warning = "rbxassetid://10709791499",
        lock = "rbxassetid://10709790803",
        unlock = "rbxassetid://10709791370",
        refresh = "rbxassetid://10709791013",
        filter = "rbxassetid://10709790671",
        zap = "rbxassetid://10709791541"
    }
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- ====================
-- THEME SYSTEM
-- ====================
Tundra.Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 30),
        SecondaryBackground = Color3.fromRGB(35, 35, 40),
        TertiaryBackground = Color3.fromRGB(45, 45, 50),
        CardBackground = Color3.fromRGB(30, 30, 35, 0.8),
        
        Primary = Color3.fromRGB(0, 122, 255),
        PrimaryHover = Color3.fromRGB(10, 132, 255),
        PrimaryPressed = Color3.fromRGB(0, 100, 220),
        
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Danger = Color3.fromRGB(255, 59, 48),
        
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        DisabledText = Color3.fromRGB(120, 120, 120),
        
        Border = Color3.fromRGB(60, 60, 65),
        Shadow = Color3.fromRGB(0, 0, 0, 0.4),
        
        ToggleOn = Color3.fromRGB(52, 199, 89),
        ToggleOff = Color3.fromRGB(60, 60, 65),
        
        Risky = Color3.fromRGB(255, 69, 58),
        Safe = Color3.fromRGB(52, 199, 89),
        
        Accent1 = Color3.fromRGB(175, 82, 222),
        Accent2 = Color3.fromRGB(255, 159, 10),
        Accent3 = Color3.fromRGB(50, 215, 75)
    },
    
    Light = {
        Background = Color3.fromRGB(242, 242, 247),
        SecondaryBackground = Color3.fromRGB(255, 255, 255),
        TertiaryBackground = Color3.fromRGB(248, 248, 248),
        CardBackground = Color3.fromRGB(255, 255, 255, 0.8),
        
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
        Safe = Color3.fromRGB(52, 199, 89),
        
        Accent1 = Color3.fromRGB(175, 82, 222),
        Accent2 = Color3.fromRGB(255, 159, 10),
        Accent3 = Color3.fromRGB(50, 215, 75)
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
    corner.CornerRadius = UDim.new(0, cornerRadius or 8)
    corner.Parent = obj
    return corner
end

function Tundra.CreateBlur(transparency)
    local blur = Instance.new("ImageLabel")
    blur.Name = "AcrylicBlur"
    blur.Image = Tundra.Assets.userInfoBlurred
    blur.ImageColor3 = Color3.new(1, 1, 1)
    blur.ImageTransparency = transparency or 0.2
    blur.ScaleType = Enum.ScaleType.Tile
    blur.TileSize = UDim2.new(0, 100, 0, 100)
    blur.BackgroundTransparency = 1
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.ZIndex = -1
    return blur
end

function Tundra.CreateShadow(obj, intensity)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = intensity or 0.5
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
-- SAVE MANAGER
-- ====================
Tundra.SaveManager = {
    Data = {}
}

function Tundra.SaveManager:Load()
    local success, data = pcall(function()
        if readfile and isfile then
            if isfile("TundraSettings.json") then
                return HttpService:JSONDecode(readfile("TundraSettings.json"))
            end
        end
        return {}
    end)
    
    if success then
        self.Data = data
        return data
    end
    return {}
end

function Tundra.SaveManager:Save()
    pcall(function()
        if writefile then
            writefile("TundraSettings.json", HttpService:JSONEncode(self.Data))
        end
    end)
end

function Tundra.SaveManager:Set(key, value)
    self.Data[key] = value
    self:Save()
end

function Tundra.SaveManager:Get(key, default)
    return self.Data[key] or default
end

-- ====================
-- WINDOW SYSTEM (WITH PFP AREA)
-- ====================
function Tundra.CreateWindow(options)
    options = options or {}
    
    -- Create ScreenGui
    local screenGui = Tundra.Create("ScreenGui", {
        Name = options.Name or "TundraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 999
    })
    
    -- Main container
    local mainContainer = Tundra.Create("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, options.Width or 750, 0, options.Height or 550),
        Position = UDim2.new(0.5, -((options.Width or 750)/2), 0.5, -((options.Height or 550)/2)),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].CardBackground,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    
    Tundra.Roundify(mainContainer, 16)
    Tundra.CreateShadow(mainContainer, 0.3)
    
    -- Add acrylic blur background
    local blur = Tundra.CreateBlur(0.3)
    blur.Parent = mainContainer
    
    -- Top bar with PFP area
    local topBar = Tundra.Create("Frame", {
        Parent = mainContainer,
        Size = UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0
    })
    
    Tundra.Create("UICorner", {
        Parent = topBar,
        CornerRadius = UDim.new(0, 16)
    })
    
    -- User PFP area (left side)
    local userSection = Tundra.Create("Frame", {
        Parent = topBar,
        Size = UDim2.new(0, 300, 1, 0),
        BackgroundTransparency = 1
    })
    
    -- PFP frame
    local pfpFrame = Tundra.Create("Frame", {
        Parent = userSection,
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0.5, -30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(pfpFrame, 30)
    
    -- PFP image
    local pfpImage = Tundra.Create("ImageLabel", {
        Parent = pfpFrame,
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(pfpImage, 28)
    
    -- User info
    local userName = Tundra.Create("TextLabel", {
        Parent = userSection,
        Size = UDim2.new(0, 200, 0, 25),
        Position = UDim2.new(0, 90, 0.5, -25),
        BackgroundTransparency = 1,
        Text = Players.LocalPlayer.Name,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    local userStatus = Tundra.Create("TextLabel", {
        Parent = userSection,
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 90, 0.5, 0),
        BackgroundTransparency = 1,
        Text = "Status: Online",
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    })
    
    -- Title area (center)
    local titleArea = Tundra.Create("Frame", {
        Parent = topBar,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0.5, -100, 0, 0),
        BackgroundTransparency = 1
    })
    
    local title = Tundra.Create("TextLabel", {
        Parent = titleArea,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Title or "Tundra UI",
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 24,
        Font = Enum.Font.GothamBold
    })
    
    local subtitle = Tundra.Create("TextLabel", {
        Parent = titleArea,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundTransparency = 1,
        Text = "v" .. Tundra.Version,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham
    })
    
    -- Action buttons (right side)
    local actionArea = Tundra.Create("Frame", {
        Parent = topBar,
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -160, 0, 0),
        BackgroundTransparency = 1
    })
    
    -- Minimize button
    local minimizeBtn = Tundra.Create("ImageButton", {
        Parent = actionArea,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 10, 0.5, -16),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Image = Tundra.Assets.sun,
        ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(minimizeBtn, 8)
    
    -- Close button
    local closeBtn = Tundra.Create("ImageButton", {
        Parent = actionArea,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -42, 0.5, -16),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Danger,
        Image = Tundra.Assets.x,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(closeBtn, 8)
    
    -- Tab bar
    local tabBar = Tundra.Create("Frame", {
        Parent = mainContainer,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 100),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0
    })
    
    -- Tab container
    local tabContainer = Tundra.Create("Frame", {
        Parent = tabBar,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1
    })
    
    local tabList = Tundra.Create("UIListLayout", {
        Parent = tabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 10)
    })
    
    -- Content area
    local contentArea = Tundra.Create("Frame", {
        Parent = mainContainer,
        Size = UDim2.new(1, -40, 1, -170),
        Position = UDim2.new(0, 20, 0, 160),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    
    -- Button interactions
    closeBtn.MouseButton1Click:Connect(function()
        Tundra.Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.2):Play()
        task.wait(0.2)
        screenGui:Destroy()
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        local isDark = Tundra.CurrentTheme == "Dark"
        Tundra.SetTheme(isDark and "Light" or "Dark")
        minimizeBtn.Image = isDark and Tundra.Assets.moon or Tundra.Assets.sun
    end)
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Store tabs
    local tabs = {}
    local currentTab = nil
    
    return {
        ScreenGui = screenGui,
        Container = mainContainer,
        Content = contentArea,
        TabContainer = tabContainer,
        Tabs = tabs,
        
        AddTab = function(self, name, icon)
            local tab = Tundra.CreateTab(self.TabContainer, self.Content, name, icon)
            tabs[name] = tab
            
            if #tabs == 1 then
                self:SelectTab(name)
            end
            
            return tab
        end,
        
        SelectTab = function(self, name)
            if tabs[name] then
                if currentTab then
                    tabs[currentTab].Deactivate()
                end
                tabs[name].Activate()
                currentTab = name
            end
        end
    }
end

-- ====================
-- TAB SYSTEM
-- ====================
function Tundra.CreateTab(parent, contentParent, name, icon)
    local tabButton = Tundra.Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        BackgroundTransparency = 0.8,
        Text = "",
        AutoButtonColor = false
    })
    
    Tundra.Roundify(tabButton, 8)
    
    -- Icon
    local tabIcon = Tundra.Create("ImageLabel", {
        Parent = tabButton,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 15, 0.5, -12),
        BackgroundTransparency = 1,
        Image = icon or Tundra.Assets.home,
        ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText
    })
    
    -- Text
    local tabText = Tundra.Create("TextLabel", {
        Parent = tabButton,
        Size = UDim2.new(0, 70, 0, 25),
        Position = UDim2.new(0, 50, 0.5, -12),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    -- Tab content
    local tabContent = Tundra.Create("ScrollingFrame", {
        Parent = contentParent,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Border,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    })
    
    local contentList = Tundra.Create("UIListLayout", {
        Parent = tabContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 15)
    })
    
    local contentPadding = Tundra.Create("UIPadding", {
        Parent = tabContent,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    -- State
    local active = false
    
    local function activate()
        active = true
        Tundra.Tween(tabButton, {BackgroundTransparency = 0}, 0.2)
        Tundra.Tween(tabIcon, {ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary}, 0.2)
        Tundra.Tween(tabText, {TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary}, 0.2)
        tabContent.Visible = true
    end
    
    local function deactivate()
        active = false
        Tundra.Tween(tabButton, {BackgroundTransparency = 0.8}, 0.2)
        Tundra.Tween(tabIcon, {ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText}, 0.2)
        Tundra.Tween(tabText, {TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText}, 0.2)
        tabContent.Visible = false
    end
    
    tabButton.MouseButton1Click:Connect(function()
        if not active then
            -- Notify parent to deactivate other tabs
            for _, sibling in ipairs(parent:GetChildren()) do
                if sibling:IsA("TextButton") and sibling ~= tabButton then
                    -- This would normally be handled by the window
                end
            end
            activate()
        end
    end)
    
    -- Hover effects
    tabButton.MouseEnter:Connect(function()
        if not active then
            Tundra.Tween(tabButton, {BackgroundTransparency = 0.5}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not active then
            Tundra.Tween(tabButton, {BackgroundTransparency = 0.8}, 0.2)
        end
    end)
    
    return {
        Button = tabButton,
        Content = tabContent,
        
        Activate = activate,
        Deactivate = deactivate,
        
        AddSection = function(self, title)
            return Tundra.CreateSection(self.Content, title)
        end,
        
        AddButton = function(self, text, callback, icon)
            return Tundra.CreateButton(self.Content, text, callback, icon)
        end,
        
        AddToggle = function(self, text, default, callback, risky)
            return Tundra.CreateToggle(self.Content, text, default, callback, risky)
        end,
        
        AddSlider = function(self, text, min, max, default, callback)
            return Tundra.CreateSlider(self.Content, text, min, max, default, callback)
        end,
        
        AddDropdown = function(self, text, options, default, callback)
            return Tundra.CreateDropdown(self.Content, text, options, default, callback)
        end,
        
        AddKeybind = function(self, text, defaultKey, callback, mode)
            return Tundra.CreateKeybind(self.Content, text, defaultKey, callback, mode)
        end,
        
        AddInput = function(self, text, placeholder, callback)
            return Tundra.CreateInput(self.Content, text, placeholder, callback)
        end,
        
        AddLabel = function(self, text)
            return Tundra.CreateLabel(self.Content, text)
        end
    }
end

-- ====================
-- SECTION
-- ====================
function Tundra.CreateSection(parent, title)
    local section = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].CardBackground,
        BackgroundTransparency = 0.1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    Tundra.Roundify(section, 12)
    Tundra.CreateShadow(section, 0.2)
    
    local titleLabel = Tundra.Create("TextLabel", {
        Parent = section,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    })
    
    return {
        Frame = section,
        Label = titleLabel
    }
end

-- ====================
-- BUTTON
-- ====================
function Tundra.CreateButton(parent, text, callback, icon)
    local button = Tundra.Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = parent:GetChildren().Size
    })
    
    Tundra.Roundify(button, 10)
    
    local buttonContent = Tundra.Create("Frame", {
        Parent = button,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1
    })
    
    if icon then
        local buttonIcon = Tundra.Create("ImageLabel", {
            Parent = buttonContent,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, 0, 0.5, -12),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Text
        })
    end
    
    local buttonText = Tundra.Create("TextLabel", {
        Parent = buttonContent,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    -- Hover effects
    local originalColor = button.BackgroundColor3
    local hoverColor = Color3.new(
        originalColor.R * 0.9,
        originalColor.G * 0.9,
        originalColor.B * 0.9
    )
    
    button.MouseEnter:Connect(function()
        Tundra.Tween(button, {BackgroundColor3 = hoverColor}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Tundra.Tween(button, {BackgroundColor3 = originalColor}, 0.2)
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return {
        Button = button,
        SetText = function(self, newText)
            buttonText.Text = newText
        end,
        SetCallback = function(self, newCallback)
            callback = newCallback
        end
    }
end

-- ====================
-- TOGGLE
-- ====================
function Tundra.CreateToggle(parent, text, default, callback, risky)
    local state = default or false
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local textLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = risky and Tundra.Themes[Tundra.CurrentTheme].Risky or Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    -- Use Fluent UI style toggle
    local toggleOuter = Tundra.Create("Frame", {
        Parent = container,
        Size = UDim2.new(0, 50, 0, 28),
        Position = UDim2.new(1, -50, 0.5, -14),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].ToggleOff,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(toggleOuter, 14)
    
    local toggleInner = Tundra.Create("Frame", {
        Parent = toggleOuter,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 2, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(toggleInner, 12)
    
    local function update()
        if state then
            Tundra.Tween(toggleOuter, {
                BackgroundColor3 = risky and Tundra.Themes[Tundra.CurrentTheme].Risky or Tundra.Themes[Tundra.CurrentTheme].ToggleOn
            }, 0.2)
            Tundra.Tween(toggleInner, {
                Position = UDim2.new(1, -26, 0.5, -12)
            }, 0.2)
        else
            Tundra.Tween(toggleOuter, {
                BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].ToggleOff
            }, 0.2)
            Tundra.Tween(toggleInner, {
                Position = UDim2.new(0, 2, 0.5, -12)
            }, 0.2)
        end
    end
    
    toggleOuter.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            update()
            if callback then
                callback(state)
            end
        end
    end)
    
    update()
    
    return {
        Container = container,
        GetValue = function()
            return state
        end,
        SetValue = function(self, value, trigger)
            state = value
            update()
            if trigger and callback then
                callback(state)
            end
        end,
        SetRisky = function(self, isRisky)
            risky = isRisky
            textLabel.TextColor3 = risky and Tundra.Themes[Tundra.CurrentTheme].Risky or Tundra.Themes[Tundra.CurrentTheme].Text
            update()
        end
    }
end

-- ====================
-- SLIDER
-- ====================
function Tundra.CreateSlider(parent, text, min, max, default, callback)
    local value = default or min
    local dragging = false
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local textLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    local valueLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham
    })
    
    local sliderTrack = Tundra.Create("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -35),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].ToggleOff,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(sliderTrack, 3)
    
    local sliderFill = Tundra.Create("Frame", {
        Parent = sliderTrack,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary,
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(sliderFill, 3)
    
    local sliderThumb = Tundra.Create("Frame", {
        Parent = sliderTrack,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, -10, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(sliderThumb, 10)
    Tundra.CreateShadow(sliderThumb, 0.3)
    
    local function setValue(newValue)
        value = math.clamp(newValue, min, max)
        local percentage = (value - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderThumb.Position = UDim2.new(percentage, -10, 0.5, -10)
        valueLabel.Text = string.format("%.1f", value)
        
        if callback then
            callback(value)
        end
    end
    
    local function updateFromMouse()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            
            local relative = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            setValue(min + (relative * (max - min)))
        end
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromMouse()
        end
    end)
    
    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse()
        end
    end)
    
    setValue(default or min)
    
    return {
        Container = container,
        GetValue = function()
            return value
        end,
        SetValue = function(self, newValue)
            setValue(newValue)
        end
    }
end

-- ====================
-- DROPDOWN
-- ====================
function Tundra.CreateDropdown(parent, text, options, default, callback)
    local selected = default or options[1]
    local open = false
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local textLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, -10, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    local dropdownButton = Tundra.Create("TextButton", {
        Parent = container,
        Size = UDim2.new(0, 150, 0, 40),
        Position = UDim2.new(1, -150, 0, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = selected,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        AutoButtonColor = false
    })
    
    Tundra.Roundify(dropdownButton, 8)
    
    local dropdownIcon = Tundra.Create("ImageLabel", {
        Parent = dropdownButton,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Image = Tundra.Assets.chevron_down,
        ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Text
    })
    
    local dropdownContent = Tundra.Create("ScrollingFrame", {
        Parent = container,
        Size = UDim2.new(0, 150, 0, 0),
        Position = UDim2.new(1, -150, 1, 5),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 10
    })
    
    Tundra.Roundify(dropdownContent, 8)
    Tundra.CreateShadow(dropdownContent, 0.3)
    
    local contentList = Tundra.Create("UIListLayout", {
        Parent = dropdownContent,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local function toggle()
        open = not open
        if open then
            Tundra.Tween(dropdownContent, {
                Size = UDim2.new(0, 150, 0, math.min(#options * 35, 150))
            }, 0.2)
            dropdownContent.Visible = true
        else
            Tundra.Tween(dropdownContent, {
                Size = UDim2.new(0, 150, 0, 0)
            }, 0.2)
            task.wait(0.2)
            dropdownContent.Visible = false
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(toggle)
    
    for _, option in ipairs(options) do
        local optionButton = Tundra.Create("TextButton", {
            Parent = dropdownContent,
            Size = UDim2.new(1, -10, 0, 35),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
            Text = option,
            TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
            TextSize = 14,
            AutoButtonColor = false,
            LayoutOrder = _
        })
        
        Tundra.Roundify(optionButton, 6)
        
        optionButton.MouseButton1Click:Connect(function()
            selected = option
            dropdownButton.Text = option
            toggle()
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
        Container = container,
        GetValue = function()
            return selected
        end,
        SetValue = function(self, value)
            if table.find(options, value) then
                selected = value
                dropdownButton.Text = value
                if callback then
                    callback(value)
                end
            end
        end
    }
end

-- ====================
-- KEYBIND
-- ====================
function Tundra.CreateKeybind(parent, text, defaultKey, callback, mode)
    mode = mode or "Toggle"
    local key = defaultKey or Enum.KeyCode.E
    local listening = false
    
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local textLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, -120, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    local keyButton = Tundra.Create("TextButton", {
        Parent = container,
        Size = UDim2.new(0, 110, 0, 40),
        Position = UDim2.new(1, -110, 0, 0),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = tostring(key):gsub("Enum.KeyCode.", ""),
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        AutoButtonColor = false
    })
    
    Tundra.Roundify(keyButton, 8)
    
    local function setKey(newKey)
        key = newKey
        keyButton.Text = tostring(key):gsub("Enum.KeyCode.", "")
        listening = false
        keyButton.BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground
    end
    
    keyButton.MouseButton1Click:Connect(function()
        listening = true
        keyButton.Text = "..."
        keyButton.BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].Primary
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            setKey(input.KeyCode)
        end
    end)
    
    return {
        Container = container,
        GetKey = function()
            return key
        end,
        SetKey = function(self, newKey)
            setKey(newKey)
        end
    }
end

-- ====================
-- INPUT
-- ====================
function Tundra.CreateInput(parent, text, placeholder, callback)
    local container = Tundra.Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = parent:GetChildren().Size
    })
    
    local textLabel = Tundra.Create("TextLabel", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold
    })
    
    local inputBox = Tundra.Create("TextBox", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].SecondaryBackground,
        Text = "",
        PlaceholderText = placeholder or "Enter text...",
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        PlaceholderColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        ClearTextOnFocus = false
    })
    
    Tundra.Roundify(inputBox, 8)
    
    inputBox.FocusLost:Connect(function()
        if callback then
            callback(inputBox.Text)
        end
    end)
    
    return {
        Container = container,
        GetText = function()
            return inputBox.Text
        end,
        SetText = function(self, text)
            inputBox.Text = text
        end
    }
end

-- ====================
-- LABEL
-- ====================
function Tundra.CreateLabel(parent, text)
    local label = Tundra.Create("TextLabel", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        TextWrapped = true,
        LayoutOrder = parent:GetChildren().Size,
        Font = Enum.Font.Gotham
    })
    
    return {
        Label = label,
        SetText = function(self, newText)
            label.Text = newText
        end
    }
end

-- ====================
-- NOTIFICATION SYSTEM
-- ====================
function Tundra.Notify(title, message, duration, type)
    duration = duration or 5
    type = type or "Info"
    
    local colors = {
        Info = Tundra.Themes[Tundra.CurrentTheme].Primary,
        Success = Tundra.Themes[Tundra.CurrentTheme].Success,
        Warning = Tundra.Themes[Tundra.CurrentTheme].Warning,
        Error = Tundra.Themes[Tundra.CurrentTheme].Danger
    }
    
    local screenGui = Tundra.Create("ScreenGui", {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 1000
    })
    
    local notification = Tundra.Create("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 320, 1, -100),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].CardBackground,
        BackgroundTransparency = 0.1
    })
    
    Tundra.Roundify(notification, 12)
    Tundra.CreateShadow(notification, 0.3)
    
    local accent = Tundra.Create("Frame", {
        Parent = notification,
        Size = UDim2.new(0, 4, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = colors[type],
        BorderSizePixel = 0
    })
    
    Tundra.Roundify(accent, 2)
    
    local titleLabel = Tundra.Create("TextLabel", {
        Parent = notification,
        Size = UDim2.new(1, -30, 0, 25),
        Position = UDim2.new(0, 25, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    })
    
    local messageLabel = Tundra.Create("TextLabel", {
        Parent = notification,
        Size = UDim2.new(1, -30, 0, 40),
        Position = UDim2.new(0, 25, 0, 35),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = Enum.Font.Gotham
    })
    
    -- Parent to CoreGui
    pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    
    -- Slide in
    Tundra.Tween(notification, {
        Position = UDim2.new(1, -320, 1, -100)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Wait and slide out
    task.wait(duration)
    
    Tundra.Tween(notification, {
        Position = UDim2.new(1, 320, 1, -100)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    
    task.wait(0.3)
    screenGui:Destroy()
end

-- ====================
-- WARNING BOX
-- ====================
function Tundra.ShowWarning(title, message, buttons)
    local screenGui = Tundra.Create("ScreenGui", {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 1001
    })
    
    local overlay = Tundra.Create("Frame", {
        Parent = screenGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5
    })
    
    local warningBox = Tundra.Create("Frame", {
        Parent = overlay,
        Size = UDim2.new(0, 400, 0, 220),
        Position = UDim2.new(0.5, -200, 0.5, -110),
        BackgroundColor3 = Tundra.Themes[Tundra.CurrentTheme].CardBackground,
        BackgroundTransparency = 0.1
    })
    
    Tundra.Roundify(warningBox, 16)
    Tundra.CreateShadow(warningBox, 0.5)
    
    local warningIcon = Tundra.Create("ImageLabel", {
        Parent = warningBox,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, -25, 0, 20),
        BackgroundTransparency = 1,
        Image = Tundra.Assets.warning,
        ImageColor3 = Tundra.Themes[Tundra.CurrentTheme].Warning
    })
    
    local titleLabel = Tundra.Create("TextLabel", {
        Parent = warningBox,
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 80),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextWrapped = true
    })
    
    local messageLabel = Tundra.Create("TextLabel", {
        Parent = warningBox,
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 110),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Tundra.Themes[Tundra.CurrentTheme].SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextWrapped = true
    })
    
    local buttonContainer = Tundra.Create("Frame", {
        Parent = warningBox,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 1, -50),
        BackgroundTransparency = 1
    })
    
    pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    
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
                AutoButtonColor = false
            })
            
            Tundra.Roundify(button, 8)
            
            button.MouseButton1Click:Connect(function()
                if buttonData.Callback then
                    buttonData.Callback()
                end
                screenGui:Destroy()
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
            AutoButtonColor = false
        })
        
        Tundra.Roundify(okButton, 8)
        
        okButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    end
    
    return screenGui
end

-- ====================
-- THEME MANAGER
-- ====================
function Tundra.SetTheme(themeName)
    if Tundra.Themes[themeName] then
        Tundra.CurrentTheme = themeName
        Tundra.SaveManager:Set("Theme", themeName)
        return true
    end
    return false
end

-- Initialize
Tundra.SaveManager:Load()
local savedTheme = Tundra.SaveManager:Get("Theme", "Dark")
Tundra.SetTheme(savedTheme)

return Tundra
