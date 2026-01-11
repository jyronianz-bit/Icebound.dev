--[[
    Icebound UI Library - Example Script
    This script demonstrates all available components and features
  -- note from ion, this example is made from ai as im way to lazy to fucking make an example lol
]]

-- Load the UI Library
local NexusUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/jyronianz-bit/Icebound.dev/refs/heads/main/Source.lua"))()

-- Create the main window
local Window = NexusUI:CreateWindow({
    Name = "Nexus UI Example",
    Size = UDim2.new(0, 550, 0, 600)
})

-- ========================================
-- TAB 1: Combat Features
-- ========================================
local CombatTab = Window:CreateTab("Combat")

CombatTab:AddLabel("⚔️ Combat Settings")
CombatTab:AddDivider()

-- Auto Attack Toggle
local AutoAttackToggle = CombatTab:AddToggle({
    Name = "Auto Attack",
    Default = false,
    Flag = "AutoAttack",
    Callback = function(value)
        print("Auto Attack:", value)
        if value then
            -- Enable auto attack logic here
            print("Starting auto attack...")
        else
            -- Disable auto attack logic here
            print("Stopping auto attack...")
        end
    end
})

-- Attack Speed Slider
local AttackSpeedSlider = CombatTab:AddSlider({
    Name = "Attack Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 0.5,
    Flag = "AttackSpeed",
    Callback = function(value)
        print("Attack Speed set to:", value)
    end
})

-- Weapon Selection Dropdown
local WeaponDropdown = CombatTab:AddDropdown({
    Name = "Weapon Type",
    Items = {"Sword", "Axe", "Spear", "Bow", "Staff"},
    Default = "Sword",
    Flag = "WeaponType",
    Callback = function(value)
        print("Selected weapon:", value)
    end
})

CombatTab:AddDivider()

-- Critical Hit Toggle
CombatTab:AddToggle({
    Name = "Critical Hits",
    Default = true,
    Flag = "CriticalHits",
    Callback = function(value)
        print("Critical Hits:", value)
    end
})

-- Critical Chance Slider
CombatTab:AddSlider({
    Name = "Crit Chance %",
    Min = 0,
    Max = 100,
    Default = 25,
    Increment = 5,
    Flag = "CritChance",
    Callback = function(value)
        print("Critical chance:", value .. "%")
    end
})

-- Auto Heal Button
CombatTab:AddButton({
    Name = "⚡ Emergency Heal",
    Callback = function()
        print("Emergency heal activated!")
        -- Add heal logic here
    end
})

-- ========================================
-- TAB 2: Movement Features
-- ========================================
local MovementTab = Window:CreateTab("Movement")

MovementTab:AddLabel("🏃 Movement Controls")
MovementTab:AddDivider()

-- Speed Toggle
local SpeedToggle = MovementTab:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Flag = "SpeedBoost",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            if value then
                player.Character.Humanoid.WalkSpeed = 50
            else
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
        print("Speed Boost:", value)
    end
})

-- Speed Amount Slider
local SpeedSlider = MovementTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 50,
    Increment = 5,
    Flag = "WalkSpeed",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
        print("Walk speed set to:", value)
    end
})

-- Jump Power Slider
MovementTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 10,
    Flag = "JumpPower",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
        print("Jump power set to:", value)
    end
})

MovementTab:AddDivider()

-- Infinite Jump Toggle
MovementTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        print("Infinite Jump:", value)
        local player = game.Players.LocalPlayer
        if value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

-- No Clip Toggle
MovementTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Flag = "NoClip",
    Callback = function(value)
        print("No Clip:", value)
        -- Add noclip logic here
    end
})

-- Reset Position Button
MovementTab:AddButton({
    Name = "🏠 Reset Position",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            print("Position reset!")
        end
    end
})

-- ========================================
-- TAB 3: Visual Features
-- ========================================
local VisualTab = Window:CreateTab("Visuals")

VisualTab:AddLabel("👁️ Visual Enhancements")
VisualTab:AddDivider()

-- ESP Toggle
VisualTab:AddToggle({
    Name = "ESP (Players)",
    Default = false,
    Flag = "PlayerESP",
    Callback = function(value)
        print("Player ESP:", value)
        -- Add ESP logic here
    end
})

-- ESP Type Dropdown
VisualTab:AddDropdown({
    Name = "ESP Type",
    Items = {"Box", "Name", "Distance", "Health", "All"},
    Default = "Box",
    Flag = "ESPType",
    Callback = function(value)
        print("ESP Type:", value)
    end
})

-- ESP Color (using textbox for hex color)
VisualTab:AddTextbox({
    Name = "ESP Color (Hex)",
    Default = "#FF0000",
    Placeholder = "#RRGGBB",
    Flag = "ESPColor",
    Callback = function(value)
        print("ESP Color set to:", value)
    end
})

VisualTab:AddDivider()

-- FOV Slider
VisualTab:AddSlider({
    Name = "Field of View",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Flag = "FOV",
    Callback = function(value)
        local camera = game.Workspace.CurrentCamera
        if camera then
            camera.FieldOfView = value
        end
        print("FOV set to:", value)
    end
})

-- Fullbright Toggle
VisualTab:AddToggle({
    Name = "Fullbright",
    Default = false,
    Flag = "Fullbright",
    Callback = function(value)
        print("Fullbright:", value)
        local lighting = game:GetService("Lighting")
        if value then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            lighting.Brightness = 1
            lighting.ClockTime = 12
            lighting.FogEnd = 100000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end
})

-- Tracers Toggle
VisualTab:AddToggle({
    Name = "Tracers",
    Default = false,
    Flag = "Tracers",
    Callback = function(value)
        print("Tracers:", value)
        -- Add tracers logic here
    end
})

-- ========================================
-- TAB 4: Miscellaneous
-- ========================================
local MiscTab = Window:CreateTab("Misc")

MiscTab:AddLabel("⚙️ Miscellaneous Options")
MiscTab:AddDivider()

-- Auto Farm Toggle
MiscTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        print("Auto Farm:", value)
        -- Add auto farm logic here
    end
})

-- Farm Mode Dropdown
MiscTab:AddDropdown({
    Name = "Farm Mode",
    Items = {"Coins", "XP", "Items", "Bosses", "All"},
    Default = "Coins",
    Flag = "FarmMode",
    Callback = function(value)
        print("Farm Mode:", value)
    end
})

MiscTab:AddDivider()

-- Auto Collect Toggle
MiscTab:AddToggle({
    Name = "Auto Collect Items",
    Default = false,
    Flag = "AutoCollect",
    Callback = function(value)
        print("Auto Collect:", value)
    end
})

-- Collection Range Slider
MiscTab:AddSlider({
    Name = "Collection Range",
    Min = 10,
    Max = 100,
    Default = 30,
    Increment = 5,
    Flag = "CollectionRange",
    Callback = function(value)
        print("Collection range:", value)
    end
})

MiscTab:AddDivider()

-- Player Name Textbox
MiscTab:AddTextbox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter player name...",
    Flag = "TargetPlayer",
    Callback = function(value)
        print("Target player:", value)
    end
})

-- Teleport to Player Button
MiscTab:AddButton({
    Name = "📍 Teleport to Player",
    Callback = function()
        local targetName = Window.Flags["TargetPlayer"]
        print("Attempting to teleport to:", targetName)
        -- Add teleport logic here
    end
})

MiscTab:AddDivider()

-- Anti-AFK Toggle
MiscTab:AddToggle({
    Name = "Anti-AFK",
    Default = true,
    Flag = "AntiAFK",
    Callback = function(value)
        print("Anti-AFK:", value)
        if value then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

-- ========================================
-- TAB 5: Configuration
-- ========================================
local ConfigTab = Window:CreateTab("Config")

ConfigTab:AddLabel("💾 Configuration Management")
ConfigTab:AddDivider()

-- Config Name Textbox
local configName = "default"
local ConfigNameBox = ConfigTab:AddTextbox({
    Name = "Config Name",
    Default = "default",
    Placeholder = "Enter config name...",
    Callback = function(value)
        configName = value
    end
})

ConfigTab:AddDivider()

-- Save Config Button
ConfigTab:AddButton({
    Name = "💾 Save Configuration",
    Callback = function()
        Window:SaveConfig(configName)
        print("Configuration saved as:", configName)
        
        -- Show all saved flags
        print("Saved settings:")
        for flag, value in pairs(Window.Flags) do
            print("  " .. flag .. ":", value)
        end
    end
})

-- Load Config Button
ConfigTab:AddButton({
    Name = "📂 Load Configuration",
    Callback = function()
        Window:LoadConfig(configName)
        print("Configuration loaded:", configName)
        
        -- Update UI with loaded values
        print("Loaded settings:")
        for flag, value in pairs(Window.Flags) do
            print("  " .. flag .. ":", value)
        end
    end
})

ConfigTab:AddDivider()

-- Example of using the SetValue methods
ConfigTab:AddButton({
    Name = "🔄 Reset to Defaults",
    Callback = function()
        -- Reset all toggles and sliders to default values
        AutoAttackToggle:SetValue(false)
        AttackSpeedSlider:SetValue(5)
        WeaponDropdown:SetValue("Sword")
        SpeedToggle:SetValue(false)
        SpeedSlider:SetValue(50)
        
        print("All settings reset to defaults!")
    end
})

-- Print Flag Values Button
ConfigTab:AddButton({
    Name = "📋 Print All Flags",
    Callback = function()
        print("=== Current Flag Values ===")
        for flag, value in pairs(Window.Flags) do
            print(flag .. ":", tostring(value))
        end
        print("=========================")
    end
})

ConfigTab:AddDivider()
ConfigTab:AddLabel("Thank you for using Nexus UI!")
ConfigTab:AddLabel("Made with ❤️ for the Roblox community")

-- ========================================
-- Example: Accessing flags from outside
-- ========================================

-- You can access any flag value at any time using:
-- Window.Flags["FlagName"]

-- Example loop that checks flags
spawn(function()
    while wait(1) do
        -- Check if auto attack is enabled
        if Window.Flags["AutoAttack"] then
            print("Auto attacking with speed:", Window.Flags["AttackSpeed"])
        end
        
        -- Check if auto farm is enabled
        if Window.Flags["AutoFarm"] then
            print("Auto farming:", Window.Flags["FarmMode"])
        end
    end
end)

print("Nexus UI Example loaded successfully!")
print("All tabs and features are ready to use!")
