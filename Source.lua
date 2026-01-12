-- Tundra.win UI Library v2.0
-- Enhanced with mobile support, configs, themes, and more

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Tundra = {}
Tundra.__index = Tundra

-- Create Blur Effect for entire screen
local function CreateScreenBlur()
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Name = "TundraBlur"
    BlurEffect.Size = 10
    BlurEffect.Parent = game:GetService("Lighting")
    return BlurEffect
end

-- Icon Library (Lucide Icons via URL)
local Icons = {
    Settings = "rbxassetid://11295291707",
    Home = "rbxassetid://11293981586",
    User = "rbxassetid://11293977557",
    Lock = "rbxassetid://11295277671",
    Unlock = "rbxassetid://11295278077",
    Eye = "rbxassetid://11293982008",
    EyeOff = "rbxassetid://11293982008",
    Check = "rbxassetid://11293981605",
    X = "rbxassetid://11293981828",
    Alert = "rbxassetid://11293978029",
    Shield = "rbxassetid://11293978730",
    Target = "rbxassetid://11293979869",
    Menu = "rbxassetid://11293977416",
    Palette = "rbxassetid://11293978404",
    Save = "rbxassetid://11293978682",
    Folder = "rbxassetid://11293982096",
    Keyboard = "rbxassetid://11293979584",
}

-- Themes
local Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromRGB(20, 20, 25),
        TopBar = Color3.fromRGB(25, 25, 30),
        SideBar = Color3.fromRGB(22, 22, 27),
        Element = Color3.fromRGB(35, 35, 40),
        ElementHover = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(138, 102, 204),
        Text = Color3.fromRGB(220, 220, 220),
        SubText = Color3.fromRGB(160, 160, 160),
        Border = Color3.fromRGB(40, 40, 45),
        Success = Color3.fromRGB(40, 201, 64),
        Warning = Color3.fromRGB(255, 189, 68),
        Error = Color3.fromRGB(255, 95, 87),
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(15, 25, 35),
        TopBar = Color3.fromRGB(20, 30, 45),
        SideBar = Color3.fromRGB(18, 28, 40),
        Element = Color3.fromRGB(30, 45, 60),
        ElementHover = Color3.fromRGB(40, 55, 70),
        Accent = Color3.fromRGB(52, 152, 219),
        Text = Color3.fromRGB(220, 230, 240),
        SubText = Color3.fromRGB(150, 170, 190),
        Border = Color3.fromRGB(35, 50, 65),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
    },
    Purple = {
        Name = "Purple",
        Background = Color3.fromRGB(25, 15, 35),
        TopBar = Color3.fromRGB(35, 20, 50),
        SideBar = Color3.fromRGB(30, 18, 45),
        Element = Color3.fromRGB(45, 30, 65),
        ElementHover = Color3.fromRGB(55, 40, 75),
        Accent = Color3.fromRGB(155, 89, 182),
        Text = Color3.fromRGB(230, 220, 240),
        SubText = Color3.fromRGB(180, 160, 200),
        Border = Color3.fromRGB(50, 35, 70),
        Success = Color3.fromRGB(142, 68, 173),
        Warning = Color3.fromRGB(230, 126, 34),
        Error = Color3.fromRGB(192, 57, 43),
    },
    Forest = {
        Name = "Forest",
        Background = Color3.fromRGB(20, 28, 20),
        TopBar = Color3.fromRGB(25, 35, 25),
        SideBar = Color3.fromRGB(22, 32, 22),
        Element = Color3.fromRGB(35, 50, 35),
        ElementHover = Color3.fromRGB(45, 60, 45),
        Accent = Color3.fromRGB(76, 175, 80),
        Text = Color3.fromRGB(220, 230, 220),
        SubText = Color3.fromRGB(160, 180, 160),
        Border = Color3.fromRGB(40, 55, 40),
        Success = Color3.fromRGB(102, 187, 106),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(239, 83, 80),
    },
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(10, 10, 15),
        TopBar = Color3.fromRGB(15, 15, 22),
        SideBar = Color3.fromRGB(12, 12, 18),
        Element = Color3.fromRGB(25, 25, 35),
        ElementHover = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(100, 100, 220),
        Text = Color3.fromRGB(230, 230, 240),
        SubText = Color3.fromRGB(140, 140, 160),
        Border = Color3.fromRGB(30, 30, 40),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 50),
        Error = Color3.fromRGB(255, 70, 70),
    },
}

-- Mobile Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Config System
local ConfigFolder = "TundraConfigs"
local function SaveConfig(windowName, config)
    if not isfolder or not writefile then return end
    
    if not isfolder(ConfigFolder) then
        makefolder(ConfigFolder)
    end
    
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(config)
    end)
    
    if success then
        writefile(ConfigFolder .. "/" .. windowName .. ".json", encoded)
    end
end

local function LoadConfig(windowName)
    if not isfile or not readfile then return nil end
    
    local path = ConfigFolder .. "/" .. windowName .. ".json"
    if isfile(path) then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success then
            return decoded
        end
    end
    return nil
end

-- Utility Functions
local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            CreateTween(frame, {
                Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            }, 0.15)
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
function Tundra:CreateWindow(config)
    local window = {}
    
    config = config or {}
    local title = config.Title or "Tundra.win"
    local subtitle = config.Subtitle or "by Creator"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local theme = config.Theme or "Dark"
    local size = config.Size or (isMobile and UDim2.new(0, 380, 0, 600) or UDim2.new(0, 650, 0, 550))
    
    window.currentTheme = Themes[theme] or Themes.Dark
    window.config = {
        Title = title,
        Subtitle = subtitle,
        ToggleKey = toggleKey,
        Theme = theme,
        Elements = {}
    }
    
    -- Create screen blur effect
    local ScreenBlur = CreateScreenBlur()
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TundraUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    MainFrame.BackgroundColor3 = window.currentTheme.Background
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = false
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = window.currentTheme.Border
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.7
    MainStroke.Parent = MainFrame
    
    -- Glass/Acrylic effect overlay
    local GlassEffect = Instance.new("Frame")
    GlassEffect.Name = "GlassEffect"
    GlassEffect.Size = UDim2.new(1, 0, 1, 0)
    GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassEffect.BackgroundTransparency = 0.98
    GlassEffect.BorderSizePixel = 0
    GlassEffect.Parent = MainFrame
    GlassEffect.ZIndex = 0
    
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 12)
    GlassCorner.Parent = GlassEffect
    
    -- Noise texture for acrylic effect
    local NoiseTexture = Instance.new("ImageLabel")
    NoiseTexture.Name = "NoiseTexture"
    NoiseTexture.Size = UDim2.new(1, 0, 1, 0)
    NoiseTexture.BackgroundTransparency = 1
    NoiseTexture.Image = "rbxassetid://5158447980"
    NoiseTexture.ImageTransparency = 0.97
    NoiseTexture.ScaleType = Enum.ScaleType.Tile
    NoiseTexture.TileSize = UDim2.new(0, 100, 0, 100)
    NoiseTexture.Parent = MainFrame
    NoiseTexture.ZIndex = 1
    
    local NoiseCorner = Instance.new("UICorner")
    NoiseCorner.CornerRadius = UDim.new(0, 12)
    NoiseCorner.Parent = NoiseTexture
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = window.currentTheme.TopBar
    TopBar.BackgroundTransparency = 0.4
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    TopBar.ZIndex = 2
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    local TopBarStroke = Instance.new("UIStroke")
    TopBarStroke.Color = window.currentTheme.Border
    TopBarStroke.Thickness = 1
    TopBarStroke.Transparency = 0.8
    TopBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TopBarStroke.Parent = TopBar
    
    local CornerFix = Instance.new("Frame")
    CornerFix.Size = UDim2.new(1, 0, 0, 12)
    CornerFix.Position = UDim2.new(0, 0, 1, -12)
    CornerFix.BackgroundColor3 = window.currentTheme.TopBar
    CornerFix.BackgroundTransparency = 0.4
    CornerFix.BorderSizePixel = 0
    CornerFix.Parent = TopBar
    CornerFix.ZIndex = 2
    
    -- Title with Icon and Subtitle
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Size = UDim2.new(1, -120, 1, 0)
    TitleContainer.Position = UDim2.new(0, 15, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = TopBar
    TitleContainer.ZIndex = 3
    
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 20, 0, 20)
    TitleIcon.Position = UDim2.new(0, 0, 0.5, -10)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = Icons.Menu
    TitleIcon.ImageColor3 = window.currentTheme.Accent
    TitleIcon.Parent = TitleContainer
    TitleIcon.ZIndex = 3
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Position = UDim2.new(0, 30, 0, 2)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = window.currentTheme.Text
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleContainer
    TitleLabel.ZIndex = 3
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 30, 0, 20)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = window.currentTheme.SubText
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TitleContainer
    SubtitleLabel.ZIndex = 3
    
    -- Mac Buttons
    local MacButtons = Instance.new("Frame")
    MacButtons.Name = "MacButtons"
    MacButtons.Size = UDim2.new(0, 70, 0, 20)
    MacButtons.Position = UDim2.new(1, -85, 0.5, -10)
    MacButtons.BackgroundTransparency = 1
    MacButtons.Parent = TopBar
    MacButtons.ZIndex = 3
    
    local function CreateMacButton(name, color, position, callback)
        local Button = Instance.new("Frame")
        Button.Name = name
        Button.Size = UDim2.new(0, 14, 0, 14)
        Button.Position = position
        Button.BackgroundColor3 = color
        Button.BorderSizePixel = 0
        Button.Parent = MacButtons
        Button.ZIndex = 3
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Button
        
        local ButtonInput = Instance.new("TextButton")
        ButtonInput.Size = UDim2.new(1, 0, 1, 0)
        ButtonInput.BackgroundTransparency = 1
        ButtonInput.Text = ""
        ButtonInput.Parent = Button
        ButtonInput.ZIndex = 4
        
        ButtonInput.MouseEnter:Connect(function()
            CreateTween(Button, {Size = UDim2.new(0, 16, 0, 16)}, 0.15)
        end)
        
        ButtonInput.MouseLeave:Connect(function()
            CreateTween(Button, {Size = UDim2.new(0, 14, 0, 14)}, 0.15)
        end)
        
        ButtonInput.MouseButton1Click:Connect(callback)
        
        return Button
    end
    
    CreateMacButton("Close", window.currentTheme.Error, UDim2.new(0, 0, 0.5, -7), function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        wait(0.3)
        ScreenBlur:Destroy()
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    CreateMacButton("Minimize", window.currentTheme.Warning, UDim2.new(0, 24, 0.5, -7), function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 45)}, 0.3, Enum.EasingStyle.Quad)
        else
            CreateTween(MainFrame, {Size = size}, 0.3, Enum.EasingStyle.Quad)
        end
    end)
    
    CreateMacButton("Maximize", window.currentTheme.Success, UDim2.new(0, 48, 0.5, -7), function()
        -- Placeholder for maximize functionality
    end)
    
    -- Side Bar
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 160, 1, -125)
    SideBar.Position = UDim2.new(0, 10, 0, 50)
    SideBar.BackgroundColor3 = window.currentTheme.SideBar
    SideBar.BackgroundTransparency = 0.5
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame
    SideBar.ZIndex = 1
    
    local SideBarCorner = Instance.new("UICorner")
    SideBarCorner.CornerRadius = UDim.new(0, 8)
    SideBarCorner.Parent = SideBar
    
    local SideBarStroke = Instance.new("UIStroke")
    SideBarStroke.Color = window.currentTheme.Border
    SideBarStroke.Thickness = 1
    SideBarStroke.Transparency = 0.8
    SideBarStroke.Parent = SideBar
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = window.currentTheme.Accent
    TabContainer.Parent = SideBar
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ZIndex = 2
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer
    
    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
    end)
    
    -- User Profile Section at bottom
    local LocalPlayer = Players.LocalPlayer
    local ProfileSection = Instance.new("Frame")
    ProfileSection.Name = "ProfileSection"
    ProfileSection.Size = UDim2.new(0, 160, 0, 60)
    ProfileSection.Position = UDim2.new(0, 10, 1, -70)
    ProfileSection.BackgroundColor3 = window.currentTheme.Element
    ProfileSection.BackgroundTransparency = 0.5
    ProfileSection.BorderSizePixel = 0
    ProfileSection.Parent = MainFrame
    ProfileSection.ZIndex = 1
    
    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 8)
    ProfileCorner.Parent = ProfileSection
    
    local ProfileStroke = Instance.new("UIStroke")
    ProfileStroke.Color = window.currentTheme.Border
    ProfileStroke.Thickness = 1
    ProfileStroke.Transparency = 0.8
    ProfileStroke.Parent = ProfileSection
    
    -- User Avatar
    local UserAvatar = Instance.new("ImageLabel")
    UserAvatar.Size = UDim2.new(0, 40, 0, 40)
    UserAvatar.Position = UDim2.new(0, 10, 0.5, -20)
    UserAvatar.BackgroundColor3 = window.currentTheme.Background
    UserAvatar.BackgroundTransparency = 0.3
    UserAvatar.BorderSizePixel = 0
    UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    UserAvatar.Parent = ProfileSection
    UserAvatar.ZIndex = 2
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 8)
    AvatarCorner.Parent = UserAvatar
    
    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = window.currentTheme.Accent
    AvatarStroke.Thickness = 2
    AvatarStroke.Transparency = 0.5
    AvatarStroke.Parent = UserAvatar
    
    -- Username
    local Username = Instance.new("TextLabel")
    Username.Size = UDim2.new(0, 95, 0, 18)
    Username.Position = UDim2.new(0, 55, 0, 12)
    Username.BackgroundTransparency = 1
    Username.Text = "@" .. LocalPlayer.Name
    Username.TextColor3 = window.currentTheme.Text
    Username.TextSize = 12
    Username.Font = Enum.Font.GothamBold
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.TextTruncate = Enum.TextTruncate.AtEnd
    Username.Parent = ProfileSection
    Username.ZIndex = 2
    
    -- Display Name
    local DisplayName = Instance.new("TextLabel")
    DisplayName.Size = UDim2.new(0, 95, 0, 16)
    DisplayName.Position = UDim2.new(0, 55, 0, 30)
    DisplayName.BackgroundTransparency = 1
    DisplayName.Text = LocalPlayer.DisplayName
    DisplayName.TextColor3 = window.currentTheme.SubText
    DisplayName.TextSize = 10
    DisplayName.Font = Enum.Font.Gotham
    DisplayName.TextXAlignment = Enum.TextXAlignment.Left
    DisplayName.TextTruncate = Enum.TextTruncate.AtEnd
    DisplayName.Parent = ProfileSection
    DisplayName.ZIndex = 2
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -190, 1, -65)
    ContentContainer.Position = UDim2.new(0, 180, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    ContentContainer.ZIndex = 1
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Toggle Visibility with Keybind
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == window.config.ToggleKey then
            visible = not visible
            if visible then
                MainFrame.Visible = true
                CreateTween(MainFrame, {Size = size}, 0.3, Enum.EasingStyle.Back)
            else
                CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
                wait(0.3)
                MainFrame.Visible = false
            end
        end
    end)
    
    window.tabs = {}
    window.currentTab = nil
    window.elements = {}
    
    -- Theme Switching Function
    function window:SetTheme(themeName)
        local newTheme = Themes[themeName]
        if not newTheme then return end
        
        window.currentTheme = newTheme
        window.config.Theme = themeName
        
        -- Update colors with animations
        CreateTween(MainFrame, {BackgroundColor3 = newTheme.Background})
        CreateTween(GlassEffect, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
        CreateTween(TopBar, {BackgroundColor3 = newTheme.TopBar})
        CreateTween(CornerFix, {BackgroundColor3 = newTheme.TopBar})
        CreateTween(SideBar, {BackgroundColor3 = newTheme.SideBar})
        CreateTween(ProfileSection, {BackgroundColor3 = newTheme.Element})
        CreateTween(TitleLabel, {TextColor3 = newTheme.Text})
        CreateTween(SubtitleLabel, {TextColor3 = newTheme.SubText})
        CreateTween(TitleIcon, {ImageColor3 = newTheme.Accent})
        CreateTween(MainStroke, {Color = newTheme.Border})
        CreateTween(Username, {TextColor3 = newTheme.Text})
        CreateTween(DisplayName, {TextColor3 = newTheme.SubText})
        CreateTween(AvatarStroke, {Color = newTheme.Accent})
        
        -- Update all tabs
        for _, tab in pairs(window.tabs) do
            if tab.button then
                CreateTween(tab.button, {
                    BackgroundColor3 = tab == window.currentTab and newTheme.Element or newTheme.Element
                })
                CreateTween(tab.label, {
                    TextColor3 = tab == window.currentTab and newTheme.Text or newTheme.SubText
                })
                if tab.icon then
                    CreateTween(tab.icon, {ImageColor3 = tab == window.currentTab and newTheme.Accent or newTheme.SubText})
                end
            end
        end
        
        SaveConfig(title, window.config)
    end
    
    -- Config Management
    function window:SaveConfig()
        SaveConfig(title, window.config)
    end
    
    function window:LoadConfig()
        local loadedConfig = LoadConfig(title)
        if loadedConfig then
            window.config = loadedConfig
            if loadedConfig.Theme then
                window:SetTheme(loadedConfig.Theme)
            end
            if loadedConfig.ToggleKey then
                window.config.ToggleKey = Enum.KeyCode[loadedConfig.ToggleKey]
            end
        end
    end
    
    function window:AddTab(name, icon)
        local tab = {}
        
        icon = icon or Icons.Home
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 38)
        TabButton.BackgroundColor3 = window.currentTheme.Element
        TabButton.BackgroundTransparency = 0.6
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.Parent = TabContainer
        TabButton.ZIndex = 3
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = window.currentTheme.Border
        TabStroke.Thickness = 1
        TabStroke.Transparency = 0.8
        TabStroke.Parent = TabButton
        
        -- Icon
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ImageColor3 = window.currentTheme.SubText
        TabIcon.Parent = TabButton
        TabIcon.ZIndex = 4
        
        -- Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 35, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = window.currentTheme.SubText
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        TabLabel.ZIndex = 4
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 5
        TabContent.ScrollBarImageColor3 = window.currentTheme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ZIndex = 2
        
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
                CreateTween(t.button, {BackgroundTransparency = 0.6})
                CreateTween(t.label, {TextColor3 = window.currentTheme.SubText})
                if t.icon then
                    CreateTween(t.icon, {ImageColor3 = window.currentTheme.SubText})
                end
            end
            
            TabContent.Visible = true
            window.currentTab = tab
            CreateTween(TabButton, {BackgroundTransparency = 0.3})
            CreateTween(TabLabel, {TextColor3 = window.currentTheme.Text})
            CreateTween(TabIcon, {ImageColor3 = window.currentTheme.Accent})
        end)
        
        TabButton.MouseEnter:Connect(function()
            if tab ~= window.currentTab then
                CreateTween(TabButton, {BackgroundTransparency = 0.4})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if tab ~= window.currentTab then
                CreateTween(TabButton, {BackgroundTransparency = 0.6})
            end
        end)
        
        if not window.currentTab then
            TabButton.BackgroundTransparency = 0.3
            TabLabel.TextColor3 = window.currentTheme.Text
            TabIcon.ImageColor3 = window.currentTheme.Accent
            TabContent.Visible = true
            window.currentTab = tab
        end
        
        tab.button = TabButton
        tab.content = TabContent
        tab.label = TabLabel
        tab.icon = TabIcon
        table.insert(window.tabs, tab)
        
        function tab:AddButton(text, callback, icon)
            icon = icon or Icons.Check
            
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Size = UDim2.new(1, -10, 0, 42)
            Button.BackgroundColor3 = window.currentTheme.Element
            Button.BackgroundTransparency = 0.6
            Button.BorderSizePixel = 0
            Button.Text = ""
            Button.Parent = TabContent
            Button.ZIndex = 3
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = window.currentTheme.Border
            ButtonStroke.Thickness = 1
            ButtonStroke.Transparency = 0.8
            ButtonStroke.Parent = Button
            
            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
            ButtonIcon.Position = UDim2.new(0, 12, 0.5, -10)
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Image = icon
            ButtonIcon.ImageColor3 = window.currentTheme.Accent
            ButtonIcon.Parent = Button
            ButtonIcon.ZIndex = 4
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -45, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 40, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = text
            ButtonLabel.TextColor3 = window.currentTheme.Text
            ButtonLabel.TextSize = 13
            ButtonLabel.Font = Enum.Font.GothamMedium
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = Button
            ButtonLabel.ZIndex = 4
            
            Button.MouseEnter:Connect(function()
                CreateTween(Button, {BackgroundTransparency = 0.4})
                CreateTween(ButtonIcon, {ImageColor3 = window.currentTheme.Text})
            end)
            
            Button.MouseLeave:Connect(function()
                CreateTween(Button, {BackgroundTransparency = 0.6})
                CreateTween(ButtonIcon, {ImageColor3 = window.currentTheme.Accent})
            end)
            
            Button.MouseButton1Click:Connect(function()
                CreateTween(Button, {BackgroundTransparency = 0.3}, 0.1)
                CreateTween(ButtonIcon, {Size = UDim2.new(0, 24, 0, 24)}, 0.1)
                wait(0.1)
                CreateTween(Button, {BackgroundTransparency = 0.6}, 0.2)
                CreateTween(ButtonIcon, {Size = UDim2.new(0, 20, 0, 20)}, 0.2)
                if callback then
                    pcall(callback)
                end
            end)
            
            return Button
        end
        
        function tab:AddToggle(text, default, callback, risky, locked)
            default = default or false
            risky = risky or false
            locked = locked or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text
            ToggleFrame.Size = UDim2.new(1, -10, 0, 42)
            ToggleFrame.BackgroundColor3 = window.currentTheme.Element
            ToggleFrame.BackgroundTransparency = risky and 0.5 or 0.6
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            ToggleFrame.ZIndex = 3
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = window.currentTheme.Border
            ToggleStroke.Thickness = 1
            ToggleStroke.Transparency = 0.8
            ToggleStroke.Parent = ToggleFrame
            
            if risky then
                local RiskyStroke = Instance.new("UIStroke")
                RiskyStroke.Color = window.currentTheme.Warning
                RiskyStroke.Thickness = 1
                RiskyStroke.Transparency = 0.6
                RiskyStroke.Parent = ToggleFrame
            end
            
            -- Lock Icon
            local LockIcon
            if locked then
                LockIcon = Instance.new("ImageLabel")
                LockIcon.Size = UDim2.new(0, 16, 0, 16)
                LockIcon.Position = UDim2.new(0, 12, 0.5, -8)
                LockIcon.BackgroundTransparency = 1
                LockIcon.Image = Icons.Lock
                LockIcon.ImageColor3 = window.currentTheme.Error
                LockIcon.Parent = ToggleFrame
                LockIcon.ZIndex = 4
            end
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -90, 1, 0)
            ToggleLabel.Position = UDim2.new(0, locked and 35 or 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text .. (risky and " ⚠" or "")
            ToggleLabel.TextColor3 = window.currentTheme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.ZIndex = 4
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 26)
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -13)
            ToggleButton.BackgroundColor3 = default and window.currentTheme.Accent or window.currentTheme.Border
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            ToggleButton.ZIndex = 4
            
            if locked then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            end
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            ToggleCircle.ZIndex = 5
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                if locked then
                    -- Show warning notification
                    return
                end
                
                toggled = not toggled
                
                if toggled then
                    CreateTween(ToggleButton, {BackgroundColor3 = window.currentTheme.Accent})
                    CreateTween(ToggleCircle, {Position = UDim2.new(1, -23, 0.5, -10)})
                else
                    CreateTween(ToggleButton, {BackgroundColor3 = window.currentTheme.Border})
                    CreateTween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)})
                end
                
                window.config.Elements[text] = toggled
                SaveConfig(window.config.Title, window.config)
                
                if callback then
                    pcall(callback, toggled)
                end
            end)
            
            ToggleButton.MouseEnter:Connect(function()
                if not locked then
                    CreateTween(ToggleCircle, {Size = UDim2.new(0, 22, 0, 22)}, 0.15)
                end
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                CreateTween(ToggleCircle, {Size = UDim2.new(0, 20, 0, 20)}, 0.15)
            end)
            
            window.config.Elements[text] = toggled
            
            return ToggleFrame
        end
        
        function tab:AddSlider(text, min, max, default, callback, icon)
            icon = icon or Icons.Settings
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text
            SliderFrame.Size = UDim2.new(1, -10, 0, 65)
            SliderFrame.BackgroundColor3 = window.currentTheme.Element
            SliderFrame.BackgroundTransparency = 0.6
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            SliderFrame.ZIndex = 3
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Color = window.currentTheme.Border
            SliderStroke.Thickness = 1
            SliderStroke.Transparency = 0.8
            SliderStroke.Parent = SliderFrame
            
            local SliderIcon = Instance.new("ImageLabel")
            SliderIcon.Size = UDim2.new(0, 18, 0, 18)
            SliderIcon.Position = UDim2.new(0, 12, 0, 8)
            SliderIcon.BackgroundTransparency = 1
            SliderIcon.Image = icon
            SliderIcon.ImageColor3 = window.currentTheme.Accent
            SliderIcon.Parent = SliderFrame
            SliderIcon.ZIndex = 4
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -100, 0, 25)
            SliderLabel.Position = UDim2.new(0, 38, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = window.currentTheme.Text
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.GothamMedium
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            SliderLabel.ZIndex = 4
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 25)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = window.currentTheme.SubText
            SliderValue.TextSize = 13
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            SliderValue.ZIndex = 4
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 1, -20)
            SliderBar.BackgroundColor3 = window.currentTheme.Border
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            SliderBar.ZIndex = 4
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = window.currentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            SliderFill.ZIndex = 5
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("Frame")
            SliderButton.Size = UDim2.new(0, 14, 0, 14)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
            SliderButton.BackgroundColor3 = window.currentTheme.Text
            SliderButton.BorderSizePixel = 0
            SliderButton.Parent = SliderBar
            SliderButton.ZIndex = 6
            
            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.CornerRadius = UDim.new(1, 0)
            SliderButtonCorner.Parent = SliderButton
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    CreateTween(SliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    CreateTween(SliderButton, {Size = UDim2.new(0, 14, 0, 14)}, 0.15)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderButton.Position = UDim2.new(pos, -7, 0.5, -7)
                    SliderValue.Text = tostring(value)
                    
                    window.config.Elements[text] = value
                    
                    if callback then
                        pcall(callback, value)
                    end
                end
            end)
            
            window.config.Elements[text] = default
            
            return SliderFrame
        end
        
        function tab:AddDropdown(text, options, callback, icon)
            icon = icon or Icons.Menu
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = text
            DropdownFrame.Size = UDim2.new(1, -10, 0, 45)
            DropdownFrame.BackgroundColor3 = window.currentTheme.Element
            DropdownFrame.BackgroundTransparency = 0.6
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            DropdownFrame.ZIndex = 3
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownStroke = Instance.new("UIStroke")
            DropdownStroke.Color = window.currentTheme.Border
            DropdownStroke.Thickness = 1
            DropdownStroke.Transparency = 0.8
            DropdownStroke.Parent = DropdownFrame
            
            local DropdownIcon = Instance.new("ImageLabel")
            DropdownIcon.Size = UDim2.new(0, 18, 0, 18)
            DropdownIcon.Position = UDim2.new(0, 12, 0, 13)
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Image = icon
            DropdownIcon.ImageColor3 = window.currentTheme.Accent
            DropdownIcon.Parent = DropdownFrame
            DropdownIcon.ZIndex = 4
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 45)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            DropdownButton.ZIndex = 4
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -70, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 38, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = text
            DropdownLabel.TextColor3 = window.currentTheme.Text
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.GothamMedium
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            DropdownLabel.ZIndex = 4
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 30, 0, 45)
            DropdownArrow.Position = UDim2.new(1, -40, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "⌄"
            DropdownArrow.TextColor3 = window.currentTheme.SubText
            DropdownArrow.TextSize = 18
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.Parent = DropdownFrame
            DropdownArrow.ZIndex = 4
            
            local DropdownContainer = Instance.new("Frame")
            DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
            DropdownContainer.Position = UDim2.new(0, 0, 0, 45)
            DropdownContainer.BackgroundTransparency = 1
            DropdownContainer.Parent = DropdownFrame
            DropdownContainer.ZIndex = 4
            
            local DropdownList = Instance.new("UIListLayout")
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Parent = DropdownContainer
            
            local isOpen = false
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 35)
                OptionButton.BackgroundColor3 = window.currentTheme.Background
                OptionButton.BackgroundTransparency = 0.5
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = window.currentTheme.SubText
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = DropdownContainer
                OptionButton.ZIndex = 5
                
                OptionButton.MouseEnter:Connect(function()
                    CreateTween(OptionButton, {BackgroundTransparency = 0.3, TextColor3 = window.currentTheme.Text})
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    CreateTween(OptionButton, {BackgroundTransparency = 0.5, TextColor3 = window.currentTheme.SubText})
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownLabel.Text = text .. ": " .. option
                    isOpen = false
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 45)})
                    CreateTween(DropdownArrow, {Rotation = 0})
                    
                    window.config.Elements[text] = option
                    SaveConfig(window.config.Title, window.config)
                    
                    if callback then
                        pcall(callback, option)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local contentHeight = #options * 35
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 45 + contentHeight)}, 0.3)
                    CreateTween(DropdownArrow, {Rotation = 180}, 0.3)
                else
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 45)}, 0.3)
                    CreateTween(DropdownArrow, {Rotation = 0}, 0.3)
                end
            end)
            
            return DropdownFrame
        end
        
        function tab:AddColorPicker(text, defaultColor, callback)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = text
            ColorFrame.Size = UDim2.new(1, -10, 0, 45)
            ColorFrame.BackgroundColor3 = window.currentTheme.Element
            ColorFrame.BackgroundTransparency = 0.6
            ColorFrame.BorderSizePixel = 0
            ColorFrame.ClipsDescendants = true
            ColorFrame.Parent = TabContent
            ColorFrame.ZIndex = 3
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorFrame
            
            local ColorStroke = Instance.new("UIStroke")
            ColorStroke.Color = window.currentTheme.Border
            ColorStroke.Thickness = 1
            ColorStroke.Transparency = 0.8
            ColorStroke.Parent = ColorFrame
            
            local ColorIcon = Instance.new("ImageLabel")
            ColorIcon.Size = UDim2.new(0, 18, 0, 18)
            ColorIcon.Position = UDim2.new(0, 12, 0, 13)
            ColorIcon.BackgroundTransparency = 1
            ColorIcon.Image = Icons.Palette
            ColorIcon.ImageColor3 = window.currentTheme.Accent
            ColorIcon.Parent = ColorFrame
            ColorIcon.ZIndex = 4
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -90, 1, 0)
            ColorLabel.Position = UDim2.new(0, 38, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = text
            ColorLabel.TextColor3 = window.currentTheme.Text
            ColorLabel.TextSize = 13
            ColorLabel.Font = Enum.Font.GothamMedium
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            ColorLabel.ZIndex = 4
            
            local ColorPreview = Instance.new("Frame")
            ColorPreview.Size = UDim2.new(0, 30, 0, 30)
            ColorPreview.Position = UDim2.new(1, -42, 0.5, -15)
            ColorPreview.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255)
            ColorPreview.BorderSizePixel = 0
            ColorPreview.Parent = ColorFrame
            ColorPreview.ZIndex = 4
            
            local PreviewCorner = Instance.new("UICorner")
            PreviewCorner.CornerRadius = UDim.new(0, 6)
            PreviewCorner.Parent = ColorPreview
            
            local PreviewStroke = Instance.new("UIStroke")
            PreviewStroke.Color = window.currentTheme.Border
            PreviewStroke.Thickness = 2
            PreviewStroke.Parent = ColorPreview
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 0, 45)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorFrame
            ColorButton.ZIndex = 4
            
            local isOpen = false
            local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)
            local h, s, v = RGBToHSV(currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
            
            -- Color Picker Panel
            local PickerPanel = Instance.new("Frame")
            PickerPanel.Size = UDim2.new(1, -20, 0, 200)
            PickerPanel.Position = UDim2.new(0, 10, 0, 50)
            PickerPanel.BackgroundColor3 = window.currentTheme.Background
            PickerPanel.BackgroundTransparency = 0.4
            PickerPanel.BorderSizePixel = 0
            PickerPanel.Visible = false
            PickerPanel.Parent = ColorFrame
            PickerPanel.ZIndex = 5
            
            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 8)
            PickerCorner.Parent = PickerPanel
            
            local PickerStroke = Instance.new("UIStroke")
            PickerStroke.Color = window.currentTheme.Border
            PickerStroke.Thickness = 1
            PickerStroke.Transparency = 0.7
            PickerStroke.Parent = PickerPanel
            
            -- SV Picker
            local SVPicker = Instance.new("ImageLabel")
            SVPicker.Size = UDim2.new(1, -70, 1, -20)
            SVPicker.Position = UDim2.new(0, 8, 0, 8)
            SVPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SVPicker.BorderSizePixel = 0
            SVPicker.Image = "rbxassetid://4155801252"
            SVPicker.Parent = PickerPanel
            SVPicker.ZIndex = 6
            
            local SVCorner = Instance.new("UICorner")
            SVCorner.CornerRadius = UDim.new(0, 6)
            SVCorner.Parent = SVPicker
            
            local SVCursor = Instance.new("Frame")
            SVCursor.Size = UDim2.new(0, 10, 0, 10)
            SVCursor.Position = UDim2.new(s, -5, 1 - v, -5)
            SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SVCursor.BorderSizePixel = 2
            SVCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SVCursor.Parent = SVPicker
            SVCursor.ZIndex = 7
            
            local SVCursorCorner = Instance.new("UICorner")
            SVCursorCorner.CornerRadius = UDim.new(1, 0)
            SVCursorCorner.Parent = SVCursor
            
            -- Hue Picker
            local HuePicker = Instance.new("ImageLabel")
            HuePicker.Size = UDim2.new(0, 25, 1, -20)
            HuePicker.Position = UDim2.new(1, -33, 0, 8)
            HuePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HuePicker.BorderSizePixel = 0
            HuePicker.Image = "rbxassetid://3641079629"
            HuePicker.Parent = PickerPanel
            HuePicker.ZIndex = 6
            
            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(0, 6)
            HueCorner.Parent = HuePicker
            
            local HueCursor = Instance.new("Frame")
            HueCursor.Size = UDim2.new(1, 6, 0, 4)
            HueCursor.Position = UDim2.new(0, -3, h, -2)
            HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueCursor.BorderSizePixel = 2
            HueCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            HueCursor.Parent = HuePicker
            HueCursor.ZIndex = 7
            
            local function updateColor()
                local newColor = HSVToRGB(h, s, v)
                currentColor = newColor
                ColorPreview.BackgroundColor3 = newColor
                SVPicker.BackgroundColor3 = HSVToRGB(h, 1, 1)
                
                window.config.Elements[text] = {R = newColor.R, G = newColor.G, B = newColor.B}
                
                if callback then
                    pcall(callback, newColor)
                end
            end
            
            local svDragging = false
            local hueDragging = false
            
            SVPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = true
                end
            end)
            
            SVPicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = false
                end
            end)
            
            HuePicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                end
            end)
            
            HuePicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if svDragging then
                        local posX = math.clamp((input.Position.X - SVPicker.AbsolutePosition.X) / SVPicker.AbsoluteSize.X, 0, 1)
                        local posY = math.clamp((input.Position.Y - SVPicker.AbsolutePosition.Y) / SVPicker.AbsoluteSize.Y, 0, 1)
                        
                        s = posX
                        v = 1 - posY
                        
                        SVCursor.Position = UDim2.new(s, -5, 1 - v, -5)
                        updateColor()
                    elseif hueDragging then
                        local posY = math.clamp((input.Position.Y - HuePicker.AbsolutePosition.Y) / HuePicker.AbsoluteSize.Y, 0, 1)
                        h = posY
                        
                        HueCursor.Position = UDim2.new(0, -3, h, -2)
                        updateColor()
                    end
                end
            end)
            
            ColorButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PickerPanel.Visible = isOpen
                
                if isOpen then
                    CreateTween(ColorFrame, {Size = UDim2.new(1, -10, 0, 260)}, 0.3)
                else
                    CreateTween(ColorFrame, {Size = UDim2.new(1, -10, 0, 45)}, 0.3)
                end
            end)
            
            window.config.Elements[text] = {R = currentColor.R, G = currentColor.G, B = currentColor.B}
            
            return ColorFrame
        end
        
        function tab:AddLabel(text, icon)
            icon = icon or nil
            
            local Label = Instance.new("Frame")
            Label.Name = text
            Label.Size = UDim2.new(1, -10, 0, 35)
            Label.BackgroundTransparency = 1
            Label.Parent = TabContent
            Label.ZIndex = 3
            
            if icon then
                local LabelIcon = Instance.new("ImageLabel")
                LabelIcon.Size = UDim2.new(0, 18, 0, 18)
                LabelIcon.Position = UDim2.new(0, 5, 0.5, -9)
                LabelIcon.BackgroundTransparency = 1
                LabelIcon.Image = icon
                LabelIcon.ImageColor3 = window.currentTheme.Accent
                LabelIcon.Parent = Label
                LabelIcon.ZIndex = 4
            end
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(1, icon and -30 or -10, 1, 0)
            LabelText.Position = UDim2.new(0, icon and 28 or 5, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = text
            LabelText.TextColor3 = window.currentTheme.SubText
            LabelText.TextSize = 13
            LabelText.Font = Enum.Font.GothamMedium
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.TextWrapped = true
            LabelText.Parent = Label
            LabelText.ZIndex = 4
            
            return Label
        end
        
        function tab:AddWarning(text, warningText)
            local WarningFrame = Instance.new("Frame")
            WarningFrame.Name = text
            WarningFrame.Size = UDim2.new(1, -10, 0, 70)
            WarningFrame.BackgroundColor3 = window.currentTheme.Warning
            WarningFrame.BackgroundTransparency = 0.85
            WarningFrame.BorderSizePixel = 0
            WarningFrame.Parent = TabContent
            WarningFrame.ZIndex = 3
            
            local WarningCorner = Instance.new("UICorner")
            WarningCorner.CornerRadius = UDim.new(0, 8)
            WarningCorner.Parent = WarningFrame
            
            local WarningStroke = Instance.new("UIStroke")
            WarningStroke.Color = window.currentTheme.Warning
            WarningStroke.Thickness = 2
            WarningStroke.Transparency = 0.4
            WarningStroke.Parent = WarningFrame
            
            local WarningIcon = Instance.new("ImageLabel")
            WarningIcon.Size = UDim2.new(0, 24, 0, 24)
            WarningIcon.Position = UDim2.new(0, 12, 0, 10)
            WarningIcon.BackgroundTransparency = 1
            WarningIcon.Image = Icons.Alert
            WarningIcon.ImageColor3 = window.currentTheme.Warning
            WarningIcon.Parent = WarningFrame
            WarningIcon.ZIndex = 4
            
            local WarningTitle = Instance.new("TextLabel")
            WarningTitle.Size = UDim2.new(1, -50, 0, 25)
            WarningTitle.Position = UDim2.new(0, 45, 0, 8)
            WarningTitle.BackgroundTransparency = 1
            WarningTitle.Text = text
            WarningTitle.TextColor3 = window.currentTheme.Warning
            WarningTitle.TextSize = 14
            WarningTitle.Font = Enum.Font.GothamBold
            WarningTitle.TextXAlignment = Enum.TextXAlignment.Left
            WarningTitle.Parent = WarningFrame
            WarningTitle.ZIndex = 4
            
            local WarningDescription = Instance.new("TextLabel")
            WarningDescription.Size = UDim2.new(1, -50, 0, 30)
            WarningDescription.Position = UDim2.new(0, 45, 0, 32)
            WarningDescription.BackgroundTransparency = 1
            WarningDescription.Text = warningText
            WarningDescription.TextColor3 = window.currentTheme.Text
            WarningDescription.TextSize = 11
            WarningDescription.Font = Enum.Font.Gotham
            WarningDescription.TextXAlignment = Enum.TextXAlignment.Left
            WarningDescription.TextWrapped = true
            WarningDescription.Parent = WarningFrame
            WarningDescription.ZIndex = 4
            
            return WarningFrame
        end
        
        function tab:AddKeybind(text, default, callback)
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = text
            KeybindFrame.Size = UDim2.new(1, -10, 0, 45)
            KeybindFrame.BackgroundColor3 = window.currentTheme.Element
            KeybindFrame.BackgroundTransparency = 0.6
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            KeybindFrame.ZIndex = 3
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindStroke = Instance.new("UIStroke")
            KeybindStroke.Color = window.currentTheme.Border
            KeybindStroke.Thickness = 1
            KeybindStroke.Transparency = 0.8
            KeybindStroke.Parent = KeybindFrame
            
            local KeybindIcon = Instance.new("ImageLabel")
            KeybindIcon.Size = UDim2.new(0, 18, 0, 18)
            KeybindIcon.Position = UDim2.new(0, 12, 0.5, -9)
            KeybindIcon.BackgroundTransparency = 1
            KeybindIcon.Image = Icons.Keyboard
            KeybindIcon.ImageColor3 = window.currentTheme.Accent
            KeybindIcon.Parent = KeybindFrame
            KeybindIcon.ZIndex = 4
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -140, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 38, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = text
            KeybindLabel.TextColor3 = window.currentTheme.Text
            KeybindLabel.TextSize = 13
            KeybindLabel.Font = Enum.Font.GothamMedium
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            KeybindLabel.ZIndex = 4
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 100, 0, 32)
            KeybindButton.Position = UDim2.new(1, -110, 0.5, -16)
            KeybindButton.BackgroundColor3 = window.currentTheme.Background
            KeybindButton.BackgroundTransparency = 0.5
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = default and default.Name or "None"
            KeybindButton.TextColor3 = window.currentTheme.Text
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.Parent = KeybindFrame
            KeybindButton.ZIndex = 4
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
            KeybindButtonCorner.Parent = KeybindButton
            
            local KeybindButtonStroke = Instance.new("UIStroke")
            KeybindButtonStroke.Color = window.currentTheme.Border
            KeybindButtonStroke.Thickness = 1
            KeybindButtonStroke.Transparency = 0.8
            KeybindButtonStroke.Parent = KeybindButton
            
            local currentKey = default
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
                CreateTween(KeybindButton, {BackgroundColor3 = window.currentTheme.Accent})
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        listening = false
                        CreateTween(KeybindButton, {BackgroundColor3 = window.currentTheme.Background})
                        
                        window.config.Elements[text] = input.KeyCode.Name
                        SaveConfig(window.config.Title, window.config)
                        
                        if callback then
                            pcall(callback, input.KeyCode)
                        end
                    end
                end
            end)
            
            window.config.Elements[text] = default and default.Name or "None"
            
            return KeybindFrame
        end
        
        return tab
    end
    
    -- Load saved config
    window:LoadConfig()
    
    return window
end

return Tundra
