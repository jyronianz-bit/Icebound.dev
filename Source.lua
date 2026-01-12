--[[
    Nexus UI Library Beta
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local NexusUI = {}
NexusUI.__index = NexusUI

-- Theme Presets
local Themes = {
    ["Nexus Purple"] = {
        Background = Color3.fromRGB(20, 20, 25),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(30, 30, 38),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(200, 100, 255),
        AccentSecondary = Color3.fromRGB(150, 80, 220),
        AccentHover = Color3.fromRGB(220, 120, 255),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(160, 160, 175),
        Border = Color3.fromRGB(60, 60, 75),
    },
    ["Ocean Blue"] = {
        Background = Color3.fromRGB(15, 23, 42),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(30, 41, 59),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(56, 189, 248),
        AccentSecondary = Color3.fromRGB(14, 165, 233),
        AccentHover = Color3.fromRGB(125, 211, 252),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85),
    },
    ["Crimson Dark"] = {
        Background = Color3.fromRGB(25, 15, 20),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(38, 25, 30),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(239, 68, 68),
        AccentSecondary = Color3.fromRGB(220, 38, 38),
        AccentHover = Color3.fromRGB(252, 165, 165),
        Text = Color3.fromRGB(254, 242, 242),
        SubText = Color3.fromRGB(185, 148, 148),
        Border = Color3.fromRGB(75, 40, 50),
    },
    ["Emerald Forest"] = {
        Background = Color3.fromRGB(15, 25, 20),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(25, 38, 30),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(52, 211, 153),
        AccentSecondary = Color3.fromRGB(16, 185, 129),
        AccentHover = Color3.fromRGB(110, 231, 183),
        Text = Color3.fromRGB(240, 253, 244),
        SubText = Color3.fromRGB(156, 190, 169),
        Border = Color3.fromRGB(45, 75, 60),
    },
    ["Golden Sunset"] = {
        Background = Color3.fromRGB(30, 25, 15),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(45, 38, 25),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(251, 191, 36),
        AccentSecondary = Color3.fromRGB(245, 158, 11),
        AccentHover = Color3.fromRGB(253, 224, 71),
        Text = Color3.fromRGB(254, 252, 232),
        SubText = Color3.fromRGB(202, 191, 153),
        Border = Color3.fromRGB(78, 70, 45),
    },
    ["Midnight Purple"] = {
        Background = Color3.fromRGB(18, 15, 30),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(30, 25, 45),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(168, 85, 247),
        AccentSecondary = Color3.fromRGB(126, 58, 242),
        AccentHover = Color3.fromRGB(196, 181, 253),
        Text = Color3.fromRGB(250, 245, 255),
        SubText = Color3.fromRGB(175, 160, 200),
        Border = Color3.fromRGB(55, 48, 75),
    },
    ["Arctic Ice"] = {
        Background = Color3.fromRGB(15, 25, 30),
        BackgroundTransparency = 0.15,
        SecondaryBackground = Color3.fromRGB(25, 38, 45),
        SecondaryTransparency = 0.2,
        Accent = Color3.fromRGB(103, 232, 249),
        AccentSecondary = Color3.fromRGB(34, 211, 238),
        AccentHover = Color3.fromRGB(165, 243, 252),
        Text = Color3.fromRGB(240, 253, 255),
        SubText = Color3.fromRGB(155, 200, 210),
        Border = Color3.fromRGB(45, 70, 80),
    },
}

-- Default Configuration
local Config = Themes["Nexus Purple"]
Config.CurrentTheme = "Nexus Purple"

-- Animation settings
Config.AcrylicEnabled = true
Config.BlurIntensity = 20
Config.AnimationSpeed = 0.3
Config.HoverSpeed = 0.15

-- Sizes
Config.CornerRadius = UDim.new(0, 10)
Config.ButtonHeight = 32
Config.ToggleSize = 40
Config.SliderHeight = 4
Config.DropdownHeight = 32

-- Notification Queue System
local NotificationQueue = {}
local ActiveNotifications = 0
local MaxNotifications = 3

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
        Transparency = 0.5,
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

local function AddBlur(parent)
    if Config.AcrylicEnabled then
        local blur = CreateElement("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://8992230677",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.7,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.new(0, 128, 0, 128),
            ZIndex = 0,
            Parent = parent
        })
        AddCorner(blur, Config.CornerRadius)
        return blur
    end
end

-- Create Gradient for Slider
local function CreateGradient(parent, colorStart, colorEnd)
    local gradient = CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colorStart or Config.Accent),
            ColorSequenceKeypoint.new(1, colorEnd or Config.AccentSecondary)
        }),
        Parent = parent
    })
    return gradient
end

-- Enhanced Notification System
local function CreateNotification(screenGui, options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 3
    local notifType = options.Type or "Info"
    
    local typeColors = {
        Info = Config.Accent,
        Success = Color3.fromRGB(40, 201, 64),
        Warning = Color3.fromRGB(255, 189, 46),
        Error = Color3.fromRGB(255, 95, 86)
    }
    
    local accentColor = typeColors[notifType] or Config.Accent
    local yOffset = -60 - (ActiveNotifications * 70)
    
    local NotificationFrame = CreateElement("Frame", {
        Size = UDim2.new(0, 320, 0, 60),
        Position = UDim2.new(1, 10, 1, yOffset),
        BackgroundColor3 = Config.SecondaryBackground,
        BackgroundTransparency = Config.SecondaryTransparency,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = screenGui
    })
    AddCorner(NotificationFrame, UDim.new(0, 10))
    AddStroke(NotificationFrame, accentColor, 2)
    AddBlur(NotificationFrame)
    
    local AccentBar = CreateElement("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = NotificationFrame
    })
    AddCorner(AccentBar, UDim.new(0, 10))
    
    local icons = {
        Info = "ℹ",
        Success = "✓",
        Warning = "⚠",
        Error = "✕"
    }
    
    local IconLabel = CreateElement("TextLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.8,
        Font = Enum.Font.GothamBold,
        Text = icons[notifType] or "ℹ",
        TextColor3 = accentColor,
        TextSize = 20,
        ZIndex = 101,
        Parent = NotificationFrame
    })
    AddCorner(IconLabel, UDim.new(1, 0))
    
    local TitleLabel = CreateElement("TextLabel", {
        Size = UDim2.new(1, -110, 0, 18),
        Position = UDim2.new(0, 58, 0, 8),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Config.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101,
        Parent = NotificationFrame
    })
    
    local MessageLabel = CreateElement("TextLabel", {
        Size = UDim2.new(1, -110, 0, 28),
        Position = UDim2.new(0, 58, 0, 26),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Config.SubText,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101,
        Parent = NotificationFrame
    })
    
    local CloseButton = CreateElement("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -32, 0, 8),
        BackgroundColor3 = Config.Background,
        BackgroundTransparency = 0.5,
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Config.SubText,
        TextSize = 16,
        ZIndex = 101,
        Parent = NotificationFrame
    })
    AddCorner(CloseButton, UDim.new(1, 0))
    
    local ProgressBar = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = NotificationFrame
    })
    
    local ProgressFill = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = 102,
        Parent = ProgressBar
    })
    
    ActiveNotifications = ActiveNotifications + 1
    
    Tween(NotificationFrame, {Position = UDim2.new(1, -330, 1, yOffset)}, 0.4)
    
    local progressTween = TweenService:Create(
        ProgressFill,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 1, 0)}
    )
    progressTween:Play()
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.2, TextColor3 = Config.Text}, 0.1)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.5, TextColor3 = Config.SubText}, 0.1)
    end)
    
    local function CloseNotification()
        progressTween:Cancel()
        Tween(NotificationFrame, {Position = UDim2.new(1, 10, 1, yOffset)}, 0.3)
        wait(0.3)
        ActiveNotifications = ActiveNotifications - 1
        NotificationFrame:Destroy()
    end
    
    CloseButton.MouseButton1Click:Connect(CloseNotification)
    
    spawn(function()
        wait(duration)
        if NotificationFrame.Parent then
            CloseNotification()
        end
    end)
    
    return NotificationFrame
end

-- Get FPS
local function GetFPS()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    return fps
end

-- Get Ping
local function GetPing()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    return ping
end

-- Get Current Date
local function GetDate()
    local dateTable = os.date("*t")
    return string.format("%02d/%02d/%04d", dateTable.month, dateTable.day, dateTable.year)
end

-- Get Current Time
local function GetTime()
    local dateTable = os.date("*t")
    local hour = dateTable.hour
    local minute = dateTable.min
    local ampm = hour >= 12 and "PM" or "AM"
    hour = hour % 12
    if hour == 0 then hour = 12 end
    return string.format("%02d:%02d %s", hour, minute, ampm)
end

-- Main Library Functions
function NexusUI:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "Nexus UI"
    local windowSize = options.Size or UDim2.new(0, 520, 0, 580)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    local showStatusBar = options.StatusBar ~= false
    
    local window = {
        Tabs = {},
        CurrentTab = nil,
        Elements = {},
        Flags = {},
        Configuration = {},
        ToggleKey = toggleKey,
        Config = Config,
    }
    
    -- Main ScreenGui
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game.CoreGui
    })
    
    function window:Notify(options)
        return CreateNotification(ScreenGui, options)
    end
    
    -- Main Frame
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Background,
        BackgroundTransparency = Config.BackgroundTransparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, UDim.new(0, 14))
    AddStroke(MainFrame, Config.Border, 1)
    
    -- Enhanced Blur Background
    local BackdropBlur = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Config.Background,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = MainFrame
    })
    AddCorner(BackdropBlur, UDim.new(0, 14))
    
    -- Glass effect overlay
    local GlassOverlay = CreateElement("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Config.Background,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 100, 0, 100),
        ZIndex = 0,
        Parent = MainFrame
    })
    AddCorner(GlassOverlay, UDim.new(0, 14))
    
    -- Noise texture for depth
    local NoiseTexture = CreateElement("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://16864939338",
        ImageTransparency = 0.95,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 200, 0, 200),
        ZIndex = 0,
        Parent = MainFrame
    })
    AddCorner(NoiseTexture, UDim.new(0, 14))
    
    -- Title Bar
    local TitleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- macOS style window controls
    local ControlsFrame = CreateElement("Frame", {
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(0, 12, 0, 10),
        BackgroundTransparency = 1,
        Parent = TitleBar
    })
    
    local controlColors = {
        {Color3.fromRGB(255, 95, 86), "Close"},
        {Color3.fromRGB(255, 189, 46), "Minimize"},
        {Color3.fromRGB(40, 201, 64), "Maximize"}
    }
    
    for i, data in ipairs(controlColors) do
        local button = CreateElement("TextButton", {
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(0, (i - 1) * 20, 0, 4),
            BackgroundColor3 = data[1],
            BorderSizePixel = 0,
            Text = "",
            Parent = ControlsFrame
        })
        AddCorner(button, UDim.new(1, 0))
        
        local icon = CreateElement("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = "",
            TextColor3 = data[1]:Lerp(Color3.fromRGB(0, 0, 0), 0.5),
            TextSize = 10,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = button
        })
        
        button.MouseEnter:Connect(function()
            if i == 1 then icon.Text = "×"
            elseif i == 2 then icon.Text = "−"
            else icon.Text = "+" end
        end)
        
        button.MouseLeave:Connect(function()
            icon.Text = ""
        end)
        
        if i == 1 then
            button.MouseButton1Click:Connect(function()
                Tween(MainFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                }, 0.3)
                wait(0.3)
                ScreenGui:Destroy()
            end)
        elseif i == 2 then
            button.MouseButton1Click:Connect(function()
                local originalSize = MainFrame.Size
                local originalPos = MainFrame.Position
                
                Tween(MainFrame, {
                    Size = UDim2.new(0, 300, 0, 60),
                    Position = UDim2.new(0.5, 0, 0, -30),
                    BackgroundTransparency = 0.5
                }, 0.3)
                
                if StatusBarFrame then
                    Tween(StatusBarFrame, {
                        Position = UDim2.new(0.5, 0, 0, 35),
                        BackgroundTransparency = 0.8
                    }, 0.3)
                end
                
                wait(0.3)
                MainFrame.Visible = false
                if StatusBarFrame then
                    StatusBarFrame.Visible = false
                end
                MainFrame.Size = originalSize
                MainFrame.Position = originalPos
                MainFrame.BackgroundTransparency = Config.BackgroundTransparency
                
                window:Notify({
                    Title = "UI Minimized",
                    Message = "Press " .. window.ToggleKey.Name .. " to restore",
                    Duration = 4,
                    Type = "Info"
                })
            end)
        end
    end
    
    -- Title
    local Title = CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 80, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = windowName,
        TextColor3 = Config.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Status Bar (if enabled) - Positioned BELOW main frame
    local StatusBar, UsernameLabel, FPSLabel, PingLabel, DateLabel, TimeLabel
    local StatusBarFrame
    
    if showStatusBar then
        StatusBarFrame = CreateElement("Frame", {
            Name = "StatusBarContainer",
            Size = UDim2.new(0, windowSize.X.Offset, 0, 32),
            Position = UDim2.new(0.5, 0, 0.5, windowSize.Y.Offset / 2 + 6),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Config.SecondaryBackground,
            BackgroundTransparency = Config.SecondaryTransparency,
            BorderSizePixel = 0,
            Parent = ScreenGui
        })
        AddCorner(StatusBarFrame, UDim.new(0, 10))
        AddStroke(StatusBarFrame, Config.Border, 1)
        AddBlur(StatusBarFrame)
        
        -- Function to update status bar position based on main frame
        local function UpdateStatusBarPosition()
            if MainFrame and StatusBarFrame then
                local mainPos = MainFrame.Position
                local mainSize = MainFrame.AbsoluteSize
                
                StatusBarFrame.Position = UDim2.new(
                    mainPos.X.Scale,
                    mainPos.X.Offset,
                    mainPos.Y.Scale,
                    mainPos.Y.Offset + mainSize.Y + 6
                )
            end
        end
        
        -- Update position whenever main frame moves
        MainFrame:GetPropertyChangedSignal("Position"):Connect(UpdateStatusBarPosition)
        MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdateStatusBarPosition)
        
        -- Initial position update
        UpdateStatusBarPosition()
        
        -- Username
        UsernameLabel = CreateElement("TextLabel", {
            Size = UDim2.new(0, 120, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = LocalPlayer.Name,
            TextColor3 = Config.Accent,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = StatusBarFrame
        })
        CreateGradient(UsernameLabel, Config.Accent, Config.AccentSecondary)
        
        -- FPS
        FPSLabel = CreateElement("TextLabel", {
            Size = UDim2.new(0, 70, 1, 0),
            Position = UDim2.new(0, 140, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = GetFPS() .. " FPS",
            TextColor3 = Config.Text,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = StatusBarFrame
        })
        
        -- Ping
        PingLabel = CreateElement("TextLabel", {
            Size = UDim2.new(0, 70, 1, 0),
            Position = UDim2.new(0, 220, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = GetPing() .. "ms",
            TextColor3 = Config.Text,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = StatusBarFrame
        })
        
        -- Date
        DateLabel = CreateElement("TextLabel", {
            Size = UDim2.new(0, 85, 1, 0),
            Position = UDim2.new(0, 300, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = GetDate(),
            TextColor3 = Config.SubText,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = StatusBarFrame
        })
        
        -- Time
        TimeLabel = CreateElement("TextLabel", {
            Size = UDim2.new(0, 75, 1, 0),
            Position = UDim2.new(1, -85, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = GetTime(),
            TextColor3 = Config.SubText,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = StatusBarFrame
        })
        
        -- Update status bar every second
        spawn(function()
            while StatusBarFrame and StatusBarFrame.Parent do
                wait(1)
                if FPSLabel then
                    FPSLabel.Text = GetFPS() .. " FPS"
                end
                if PingLabel then
                    PingLabel.Text = GetPing() .. "ms"
                end
                if TimeLabel then
                    TimeLabel.Text = GetTime()
                end
                if DateLabel then
                    DateLabel.Text = GetDate()
                end
            end
        end)
    end
    
    -- Tab Container
    local TabContainer = CreateElement("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 35),
        ScrollingDirection = Enum.ScrollingDirection.X,
        HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        VerticalScrollBarInset = Enum.ScrollBarInset.None,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        ScrollingEnabled = true,
        Parent = MainFrame
    })
    
    local TabLayout = CreateElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = TabContainer
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 10, 0, 35)
    end)
    
    TabContainer.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            local scrollAmount = -input.Position.Z * 30
            local newPosition = TabContainer.CanvasPosition.X + scrollAmount
            TabContainer.CanvasPosition = Vector2.new(
                math.clamp(newPosition, 0, math.max(0, TabContainer.CanvasSize.X.Offset - TabContainer.AbsoluteSize.X)),
                TabContainer.CanvasPosition.Y
            )
        end
    end)
    
    -- Content Container
    local ContentContainer = CreateElement("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
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
            local newPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            MainFrame.Position = newPosition
            
            -- Update status bar position in real-time while dragging
            if StatusBarFrame then
                local mainSize = MainFrame.AbsoluteSize
                StatusBarFrame.Position = UDim2.new(
                    newPosition.X.Scale,
                    newPosition.X.Offset,
                    newPosition.Y.Scale,
                    newPosition.Y.Offset + mainSize.Y + 6
                )
            end
        end
    end)
    
    -- Entrance animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Tween(MainFrame, {
        Size = windowSize,
        BackgroundTransparency = Config.BackgroundTransparency
    }, 0.5)
    
    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            if MainFrame.Visible then
                -- Hide with animation
                Tween(MainFrame, {
                    Size = UDim2.new(0, 300, 0, 60),
                    Position = UDim2.new(0.5, 0, 0, -30),
                    BackgroundTransparency = 0.8
                }, 0.25)
                
                if StatusBarFrame then
                    Tween(StatusBarFrame, {
                        Position = UDim2.new(0.5, 0, 0, 35),
                        BackgroundTransparency = 0.8
                    }, 0.25)
                end
                
                wait(0.25)
                MainFrame.Visible = false
                if StatusBarFrame then
                    StatusBarFrame.Visible = false
                end
            else
                -- Show with animation
                MainFrame.Visible = true
                if StatusBarFrame then
                    StatusBarFrame.Visible = true
                end
                
                MainFrame.Size = UDim2.new(0, 300, 0, 60)
                MainFrame.Position = UDim2.new(0.5, 0, 0, -30)
                MainFrame.BackgroundTransparency = 0.8
                
                if StatusBarFrame then
                    StatusBarFrame.Position = UDim2.new(0.5, 0, 0, 35)
                    StatusBarFrame.BackgroundTransparency = 0.8
                end
                
                Tween(MainFrame, {
                    Size = windowSize,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = Config.BackgroundTransparency
                }, 0.3)
                
                if StatusBarFrame then
                    wait(0.3)
                    -- Update to proper position after main frame is restored
                    local mainSize = MainFrame.AbsoluteSize
                    local mainPos = MainFrame.Position
                    Tween(StatusBarFrame, {
                        Position = UDim2.new(
                            mainPos.X.Scale,
                            mainPos.X.Offset,
                            mainPos.Y.Scale,
                            mainPos.Y.Offset + mainSize.Y + 6
                        ),
                        BackgroundTransparency = Config.SecondaryTransparency
                    }, 0.2)
                end
            end
        end
    end)
    
    -- Theme Changer Function
    function window:SetTheme(themeName)
        if not Themes[themeName] then return end
        
        local newTheme = Themes[themeName]
        
        -- Update Config
        for key, value in pairs(newTheme) do
            Config[key] = value
        end
        Config.CurrentTheme = themeName
        
        -- Update Main Frame
        Tween(MainFrame, {BackgroundColor3 = Config.Background}, 0.3)
        Tween(BackdropBlur, {BackgroundColor3 = Config.Background}, 0.3)
        Tween(GlassOverlay, {ImageColor3 = Config.Background}, 0.3)
        
        -- Update Status Bar if it exists
        if StatusBarFrame then
            Tween(StatusBarFrame, {BackgroundColor3 = Config.SecondaryBackground}, 0.3)
            if UsernameLabel then
                Tween(UsernameLabel, {TextColor3 = Config.Accent}, 0.3)
                -- Update gradient
                for _, child in ipairs(UsernameLabel:GetChildren()) do
                    if child:IsA("UIGradient") then
                        child.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Config.Accent),
                            ColorSequenceKeypoint.new(1, Config.AccentSecondary)
                        })
                    end
                end
            end
        end
        
        -- Update all tab indicators and their gradients
        for _, tab in pairs(window.Tabs) do
            if tab.Indicator then
                Tween(tab.Indicator, {BackgroundColor3 = Config.Accent}, 0.3)
                for _, child in ipairs(tab.Indicator:GetChildren()) do
                    if child:IsA("UIGradient") then
                        child.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Config.Accent),
                            ColorSequenceKeypoint.new(1, Config.AccentSecondary)
                        })
                    end
                end
            end
            
            -- Update current tab text color
            if window.CurrentTab == tab then
                Tween(tab.Button, {TextColor3 = Config.Text}, 0.3)
            end
            
            -- Update all sliders in this tab
            for _, element in ipairs(tab.Content:GetDescendants()) do
                if element.Name == "SliderFill" or element.Name == "ValueLabel" then
                    if element:IsA("Frame") then
                        Tween(element, {BackgroundColor3 = Config.Accent}, 0.3)
                    elseif element:IsA("TextLabel") then
                        Tween(element, {TextColor3 = Config.Accent}, 0.3)
                    end
                    
                    -- Update gradients
                    for _, child in ipairs(element:GetChildren()) do
                        if child:IsA("UIGradient") then
                            child.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Config.Accent),
                                ColorSequenceKeypoint.new(1, Config.AccentSecondary)
                            })
                        end
                    end
                end
            end
        end
        
        window:Notify({
            Title = "Theme Changed",
            Message = "Applied " .. themeName .. " theme",
            Duration = 3,
            Type = "Success"
        })
    end
    
    -- Tab Functions
    function window:CreateTab(tabName)
        local tab = {
            Name = tabName,
            Elements = {},
        }
        
        local TabButton = CreateElement("TextButton", {
            Name = tabName,
            Size = UDim2.new(0, 90, 0, 28),
            BackgroundColor3 = Config.SecondaryBackground,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Config.SubText,
            TextSize = 12,
            Parent = TabContainer
        })
        AddCorner(TabButton, UDim.new(0, 6))
        
        local TabIndicator = CreateElement("Frame", {
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0.5, 0, 1, -2),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Config.Accent,
            BorderSizePixel = 0,
            Parent = TabButton
        })
        AddCorner(TabIndicator, UDim.new(1, 0))
        CreateGradient(TabIndicator, Config.Accent, Config.AccentSecondary)
        
        local TabContent = CreateElement("ScrollingFrame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Config.Accent,
            ScrollBarImageTransparency = 0.5,
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
        
        AddPadding(TabContent, 5)
        
        TabButton.MouseEnter:Connect(function()
            if window.CurrentTab ~= tab then
                Tween(TabButton, {BackgroundTransparency = 0.3}, Config.HoverSpeed)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if window.CurrentTab ~= tab then
                Tween(TabButton, {BackgroundTransparency = 1}, Config.HoverSpeed)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1, TextColor3 = Config.SubText}, Config.AnimationSpeed)
                Tween(t.Indicator, {Size = UDim2.new(0, 0, 0, 2)}, Config.AnimationSpeed)
                t.Content.Visible = false
            end
            
            Tween(TabButton, {BackgroundTransparency = 0.2, TextColor3 = Config.Text}, Config.AnimationSpeed)
            Tween(TabIndicator, {Size = UDim2.new(0.8, 0, 0, 2)}, Config.AnimationSpeed)
            TabContent.Visible = true
            window.CurrentTab = tab
        end)
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.Indicator = TabIndicator
        
        if #window.Tabs == 0 then
            TabButton.BackgroundTransparency = 0.2
            TabButton.TextColor3 = Config.Text
            TabIndicator.Size = UDim2.new(0.8, 0, 0, 2)
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
                BackgroundTransparency = Config.SecondaryTransparency,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(ButtonFrame, UDim.new(0, 6))
            AddStroke(ButtonFrame)
            
            local Button = CreateElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = buttonName,
                TextColor3 = Config.Text,
                TextSize = 12,
                Parent = ButtonFrame
            })
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = 0.1}, Config.HoverSpeed)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = Config.SecondaryTransparency}, Config.HoverSpeed)
            end)
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Config.Accent}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Config.SecondaryBackground}, 0.1)
                spawn(callback)
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
                BackgroundTransparency = Config.SecondaryTransparency,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(ToggleFrame, UDim.new(0, 6))
            AddStroke(ToggleFrame)
            
            local ToggleLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -55, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = toggleName,
                TextColor3 = Config.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local ToggleButton = CreateElement("TextButton", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -48, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Border,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = "",
                Parent = ToggleFrame
            })
            AddCorner(ToggleButton, UDim.new(1, 0))
            
            local ToggleCircle = CreateElement("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0.5, 0),
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
                    Tween(ToggleButton, {BackgroundColor3 = Config.Accent, BackgroundTransparency = 0}, Config.AnimationSpeed)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, 0)}, Config.AnimationSpeed)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Config.Border, BackgroundTransparency = 0.3}, Config.AnimationSpeed)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, 0)}, Config.AnimationSpeed)
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
                Tween(ToggleFrame, {BackgroundTransparency = 0.1}, Config.HoverSpeed)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = Config.SecondaryTransparency}, Config.HoverSpeed)
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
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Config.SecondaryBackground,
                BackgroundTransparency = Config.SecondaryTransparency,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(SliderFrame, UDim.new(0, 6))
            AddStroke(SliderFrame)
            
            local SliderLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 12, 0, 6),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = sliderName,
                TextColor3 = Config.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = CreateElement("TextLabel", {
                Name = "ValueLabel",
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -58, 0, 6),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = Config.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            CreateGradient(ValueLabel, Config.Accent, Config.AccentSecondary)
            
            local SliderBar = CreateElement("Frame", {
                Size = UDim2.new(1, -24, 0, Config.SliderHeight),
                Position = UDim2.new(0, 12, 1, -16),
                BackgroundColor3 = Config.Border,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Parent = SliderFrame
            })
            AddCorner(SliderBar, UDim.new(1, 0))
            
            local SliderFill = CreateElement("Frame", {
                Name = "SliderFill",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Config.Accent,
                BorderSizePixel = 0,
                Parent = SliderBar
            })
            AddCorner(SliderFill, UDim.new(1, 0))
            CreateGradient(SliderFill, Config.Accent, Config.AccentSecondary)
            
            local initialPercentage = (default - min) / (max - min)
            
            local SliderButton = CreateElement("TextButton", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Config.Text,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 2,
                Parent = SliderBar
            })
            AddCorner(SliderButton, UDim.new(1, 0))
            
            local dragging = false
            local value = default
            
            local function UpdateSlider(val)
                val = math.clamp(val, min, max)
                val = math.floor(val / increment + 0.5) * increment
                value = val
                
                local percentage = (val - min) / (max - min)
                local fillSize = SliderBar.AbsoluteSize.X * percentage
                
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderButton.Position = UDim2.new(0, fillSize, 0.5, 0)
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
            
            local initialFillSize = SliderBar.AbsoluteSize.X * initialPercentage
            SliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
            SliderButton.Position = UDim2.new(0, initialFillSize, 0.5, 0)
            ValueLabel.Text = tostring(default)
            
            if flag then
                window.Flags[flag] = default
            end
            
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
                BackgroundTransparency = Config.SecondaryTransparency,
                BorderSizePixel = 0,
                Parent = TabContent,
                ClipsDescendants = true,
            })
            AddCorner(DropdownFrame, UDim.new(0, 6))
            AddStroke(DropdownFrame)
            
            local DropdownButton = CreateElement("TextButton", {
                Size = UDim2.new(1, 0, 0, Config.DropdownHeight),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = "",
                Parent = DropdownFrame
            })
            
            local DropdownLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -90, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = dropdownName,
                TextColor3 = Config.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownButton
            })
            
            local DropdownValue = CreateElement("TextLabel", {
                Size = UDim2.new(0, 80, 1, 0),
                Position = UDim2.new(1, -90, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = default,
                TextColor3 = Config.SubText,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DropdownButton
            })
            
            local Arrow = CreateElement("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = "▼",
                TextColor3 = Config.SubText,
                TextSize = 8,
                Parent = DropdownButton
            })
            
            local ItemsContainer = CreateElement("Frame", {
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, Config.DropdownHeight + 4),
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
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Config.Background,
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = item,
                    TextColor3 = Config.Text,
                    TextSize = 11,
                    Parent = ItemsContainer
                })
                AddCorner(ItemButton, UDim.new(0, 4))
                
                ItemButton.MouseEnter:Connect(function()
                    Tween(ItemButton, {BackgroundColor3 = Config.Accent, BackgroundTransparency = 0.1}, Config.HoverSpeed)
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    Tween(ItemButton, {BackgroundColor3 = Config.Background, BackgroundTransparency = 0.3}, Config.HoverSpeed)
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
                    
                    isOpen = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, Config.DropdownHeight)}, Config.AnimationSpeed)
                    Tween(Arrow, {Rotation = 0}, Config.AnimationSpeed)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local totalHeight = Config.DropdownHeight + 4 + (#items * 28)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, Config.AnimationSpeed)
                    Tween(Arrow, {Rotation = 180}, Config.AnimationSpeed)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, Config.DropdownHeight)}, Config.AnimationSpeed)
                    Tween(Arrow, {Rotation = 0}, Config.AnimationSpeed)
                end
            end)
            
            DropdownFrame.MouseEnter:Connect(function()
                if not isOpen then
                    Tween(DropdownFrame, {BackgroundTransparency = 0.1}, Config.HoverSpeed)
                end
            end)
            
            DropdownFrame.MouseLeave:Connect(function()
                if not isOpen then
                    Tween(DropdownFrame, {BackgroundTransparency = Config.SecondaryTransparency}, Config.HoverSpeed)
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
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Config.SecondaryBackground,
                BackgroundTransparency = Config.SecondaryTransparency,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(TextboxFrame, UDim.new(0, 6))
            AddStroke(TextboxFrame)
            
            local TextboxLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -20, 0, 18),
                Position = UDim2.new(0, 10, 0, 3),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = textboxName,
                TextColor3 = Config.SubText,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextboxFrame
            })
            
            local Textbox = CreateElement("TextBox", {
                Size = UDim2.new(1, -20, 0, 18),
                Position = UDim2.new(0, 10, 1, -21),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Config.SubText,
                Text = default,
                TextColor3 = Config.Text,
                TextSize = 12,
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
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Config.SecondaryBackground,
                BackgroundTransparency = Config.SecondaryTransparency,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            AddCorner(KeybindFrame, UDim.new(0, 6))
            AddStroke(KeybindFrame)
            
            local KeybindLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -90, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = keybindName,
                TextColor3 = Config.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            local KeybindButton = CreateElement("TextButton", {
                Size = UDim2.new(0, 70, 0, 24),
                Position = UDim2.new(1, -78, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Background,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Font = Enum.Font.Gotham,
                Text = default.Name,
                TextColor3 = Config.Accent,
                TextSize = 10,
                Parent = KeybindFrame
            })
            AddCorner(KeybindButton, UDim.new(0, 5))
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
                KeybindButton.TextColor3 = Config.SubText
                
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
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == currentKey then
                    spawn(function()
                        callback(currentKey)
                    end)
                end
            end)
            
            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundTransparency = 0.1}, Config.HoverSpeed)
            end)
            
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundTransparency = Config.SecondaryTransparency}, Config.HoverSpeed)
            end)
            
            UpdateKeybind(default)
            
            return {
                SetValue = UpdateKeybind,
                GetValue = function() return currentKey end
            }
        end
        
        function tab:AddLabel(text)
            local LabelFrame = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
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
                TextSize = 11,
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
                Size = UDim2.new(1, -10, 0, 1),
                BackgroundColor3 = Config.Border,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            return Divider
        end
        
        return tab
    end
    
    -- Add Interface tab for customization
    local InterfaceTab = window:CreateTab("Settings")
    
    InterfaceTab:AddLabel("UI Customization")
    InterfaceTab:AddDivider()
    
    -- Theme Dropdown
    local themeNames = {}
    for themeName, _ in pairs(Themes) do
        table.insert(themeNames, themeName)
    end
    
    InterfaceTab:AddDropdown({
        Name = "Theme",
        Items = themeNames,
        Default = Config.CurrentTheme,
        Callback = function(theme)
            window:SetTheme(theme)
        end
    })
    
    InterfaceTab:AddToggle({
        Name = "Acrylic Effect",
        Default = Config.AcrylicEnabled,
        Callback = function(value)
            Config.AcrylicEnabled = value
        end
    })
    
    local bgOpacityDefault = math.floor((1 - Config.BackgroundTransparency) * 100)
    InterfaceTab:AddSlider({
        Name = "Background Opacity",
        Min = 0,
        Max = 100,
        Default = bgOpacityDefault,
        Increment = 5,
        Callback = function(value)
            local transparency = 1 - (value / 100)
            Config.BackgroundTransparency = transparency
            MainFrame.BackgroundTransparency = transparency
        end
    })
    
    local elemOpacityDefault = math.floor((1 - Config.SecondaryTransparency) * 100)
    InterfaceTab:AddSlider({
        Name = "Element Opacity",
        Min = 0,
        Max = 100,
        Default = elemOpacityDefault,
        Increment = 5,
        Callback = function(value)
            local transparency = 1 - (value / 100)
            Config.SecondaryTransparency = transparency
        end
    })
    
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
