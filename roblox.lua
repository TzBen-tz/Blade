local plr = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local rgbSpeed = 0.15
local hue = 0

local function getRGB()
    return Color3.fromHSV(hue, 1, 1)
end

RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * rgbSpeed) % 1
end)

-- Pindahkan penyimpanan ke PlayerGui agar pasti muncul
local PlayerGui = plr:WaitForChild("PlayerGui", 5) or plr.PlayerGui

-- Hapus UI lama jika ada agar tidak menumpuk
if PlayerGui:FindFirstChild("STARGOD_HUB_V7") then
    PlayerGui["STARGOD_HUB_V7"]:Destroy()
end

-- ==========================================
-- UI CONFIGURATION & INTERFACE (THEME: CYBER ECLIPSE)
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "STARGOD_HUB_V7"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Theme Palettes
local Colors = {
    Background = Color3.fromRGB(13, 11, 23),     
    PanelBg = Color3.fromRGB(20, 18, 36),        
    Accent = Color3.fromRGB(157, 78, 221),       
    TextMain = Color3.fromRGB(240, 235, 255),     
    TextDark = Color3.fromRGB(138, 131, 168),     
    ButtonBg = Color3.fromRGB(28, 24, 48),       
    ButtonStroke = Color3.fromRGB(58, 48, 92),   
    Success = Color3.fromRGB(114, 9, 183)        
}

-- Main Frame (Landscape: Width 480, Height 290)
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Colors.Background
Frame.Position = UDim2.new(0.5, -240, 0.4, -145)
Frame.Size = UDim2.new(0, 480, 0, 290)
Frame.Active = true

-- Sistem Dragging Modern
local dragToggle, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(Frame, TweenInfo.new(0.1), {Position = position}):Play()
end
Frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)
Frame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if dragToggle then updateInput(input) end
    end
end)

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 14)
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Colors.Accent
FrameStroke.Thickness = 1.8
FrameStroke.Parent = Frame

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 14)
Title.Size = UDim2.new(0, 300, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "★ <font color='rgb(255, 255, 255)'>BEN UPDATE</font> <font color='rgb(187, 126, 250)'>HUB</font> ★"
Title.RichText = true
Title.TextColor3 = Colors.TextMain
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container Utama
local Container = Instance.new("Frame")
Container.Parent = Frame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 16, 0, 48)
Container.Size = UDim2.new(1, -32, 1, -64)

-- ==========================================
-- TOMBOL BULAT PERFECT (TOGGLE UI "STAR")
-- ==========================================
local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Name = "ToggleUI"
ToggleUIBtn.Parent = ScreenGui
ToggleUIBtn.Position = UDim2.new(0, 25, 1, -75)
ToggleUIBtn.Size = UDim2.new(0, 55, 0, 55) -- Ukuran aspek rasio sama (55x55) agar bulat sempurna
ToggleUIBtn.BackgroundColor3 = Colors.PanelBg
ToggleUIBtn.Font = Enum.Font.GothamBold
ToggleUIBtn.Text = "<font color='rgb(255, 255, 255)'>★</font><br/><font color='rgb(187, 126, 250)'>Ben_update</font>"
ToggleUIBtn.RichText = true
ToggleUIBtn.TextSize = 8
ToggleUIBtn.LineHeight = 1.1

-- Membuat tombol berbentuk lingkaran total (CornerRadius = 1)
local TCorner = Instance.new("UICorner") 
TCorner.CornerRadius = UDim.new(1, 0) 
TCorner.Parent = ToggleUIBtn

local TStroke = Instance.new("UIStroke") 
TStroke.Color = Colors.Accent 
TStroke.Thickness = 2 
TStroke.Parent = ToggleUIBtn

-- Menambahkan efek bayangan halus/glow pada pinggiran tombol bulat
local TGradient = Instance.new("UIGradient")
TGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 78, 221)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 9, 183))
}
TGradient.Parent = TStroke

local uiVisible = true
ToggleUIBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    Frame.Visible = uiVisible
    
    -- Mengubah warna border lingkaran saat UI ditutup/dibuka untuk indikator visual
    if uiVisible then
        TStroke.Color = Colors.Accent
        TGradient.Enabled = true
    else
        TStroke.Color = Color3.fromRGB(80, 70, 120) -- Warna redup saat tertutup
        TGradient.Enabled = false
    end
end)

-- ==========================================
-- PEMBAGIAN KOLOM (KIRI & KANAN)
-- ==========================================

local LeftCol = Instance.new("Frame")
LeftCol.Parent = Container
LeftCol.BackgroundTransparency = 1
LeftCol.Size = UDim2.new(0.46, 0, 1, 0)

local LeftList = Instance.new("UIListLayout")
LeftList.Parent = LeftCol
LeftList.Padding = UDim.new(0, 6)
LeftList.SortOrder = Enum.SortOrder.LayoutOrder

local RightCol = Instance.new("Frame")
RightCol.Parent = Container
RightCol.BackgroundTransparency = 1
RightCol.Position = UDim2.new(0.54, 0, 0, 0)
RightCol.Size = UDim2.new(0.46, 0, 1, 0)

-- Helper Pembuat Tombol Utama
local function createToggle(name, text, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = LeftCol
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Colors.ButtonBg
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Colors.TextDark
    btn.TextSize = 10
    btn.Text = text .. " : OFF"
    btn.LayoutOrder = order
    btn.AutoButtonColor = false

    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 6) btnCorner.Parent = btn
    local btnStroke = Instance.new("UIStroke") btnStroke.Color = Colors.ButtonStroke btnStroke.Thickness = 1 btnStroke.Parent = btn

    return btn, btnStroke
end

local ToggleFarm, StrokeFarm = createToggle("ToggleFarm", "AUTO FARM", 1)
local ToggleClick, StrokeClick = createToggle("ToggleClick", "AUTO ATTACK/CLICK", 2)
local ToggleSkillX, StrokeSkillX = createToggle("ToggleSkillX", "AUTO SKILL (X)", 3)
local ToggleSkillC, StrokeSkillC = createToggle("ToggleSkillC", "AUTO SKILL (C)", 4)
local ToggleSkill, StrokeSkill = createToggle("ToggleSkill", "AUTO SKILL (V)", 5)

-- SCROLLING FRAME 1: SELEKSI BOSS
local BossLabel = Instance.new("TextLabel")
BossLabel.Parent = RightCol
BossLabel.BackgroundTransparency = 1
BossLabel.Position = UDim2.new(0, 0, 0, 0)
BossLabel.Size = UDim2.new(1, 0, 0, 15)
BossLabel.Font = Enum.Font.GothamBold
BossLabel.Text = "TARGET BOSS SPECIFIC:"
BossLabel.TextColor3 = Colors.Accent
BossLabel.TextSize = 9
BossLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScrollBoss = Instance.new("ScrollingFrame")
ScrollBoss.Parent = RightCol
ScrollBoss.Position = UDim2.new(0, 0, 0, 18)
ScrollBoss.Size = UDim2.new(1, 0, 0, 95)
ScrollBoss.BackgroundColor3 = Colors.PanelBg
ScrollBoss.BorderSizePixel = 0
ScrollBoss.CanvasSize = UDim2.new(0, 0, 0, 520) 
ScrollBoss.ScrollBarThickness = 2
ScrollBoss.ScrollBarImageColor3 = Colors.Accent

local SBor = Instance.new("UICorner") SBor.CornerRadius = UDim.new(0, 6) SBor.Parent = ScrollBoss
local ListBoss = Instance.new("UIListLayout") ListBoss.Parent = ScrollBoss; ListBoss.Padding = UDim.new(0, 4)

-- SCROLLING FRAME 2: TELEPORTASI AREA
local WorldLabel = Instance.new("TextLabel")
WorldLabel.Parent = RightCol
WorldLabel.BackgroundTransparency = 1
WorldLabel.Position = UDim2.new(0, 0, 0, 120)
WorldLabel.Size = UDim2.new(1, 0, 0, 15)
WorldLabel.Font = Enum.Font.GothamBold
WorldLabel.Text = "TELEPORT LOCATIONS:"
WorldLabel.TextColor3 = Colors.Accent
WorldLabel.TextSize = 9
WorldLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScrollWorld = Instance.new("ScrollingFrame")
ScrollWorld.Parent = RightCol
ScrollWorld.Position = UDim2.new(0, 0, 0, 138)
ScrollWorld.Size = UDim2.new(1, 0, 0, 95)
ScrollWorld.BackgroundColor3 = Colors.PanelBg
ScrollWorld.BorderSizePixel = 0
ScrollWorld.CanvasSize = UDim2.new(0, 0, 0, 230)
ScrollWorld.ScrollBarThickness = 2
ScrollWorld.ScrollBarImageColor3 = Colors.Accent

local SWor = Instance.new("UICorner") SWor.CornerRadius = UDim.new(0, 6) SWor.Parent = ScrollWorld
local ListWorld = Instance.new("UIListLayout") ListWorld.Parent = ScrollWorld; ListWorld.Padding = UDim.new(0, 4)

-- ==========================================
-- DATA STATES & TARGET CONFIG
-- ==========================================

local flags = {autofarm = false, autoclick = false, autoskillX = false, autoskillC = false, autoskill = false}

local targetBosses = {
    ["nameless hero"] = false
    , ["moraros"] = false
    , ["magador"] = false,
    ["ragaros"] = false
    , ["velik"] = false
    , ["nivaron"] = false,
    ["gelaros"] = false
    , ["hraegon"] = false
    , ["surtrik"] = false
    , ["thorvak"] = false,
    ["niflor"] = false
    , ["artoria"] = false
    , ["veyrath"] = false, 
    ["mad dog"] = false
    , ["struggler"] = false
    , ["blackswordsman"] = false 
    , ["authur"] = false 
    , ["space invader"] = false
}

local worldLocations = {
    ["ORIGIN ISLAND"] = Vector3.new(0, 100, 0),
    ["HELHEIM"]       = Vector3.new(1500, 100, 1500),
    ["MUSPELHIM"]     = Vector3.new(-2000, 150, 1000),
    ["NIFLHEIM"]      = Vector3.new(3000, 100, -2500),
    ["NIDAVELLIR"]    = Vector3.new(-4000, 200, -4000),
    ["ECLIPS"]        = Vector3.new(5000, 300, 5000),
    ["JOTUNHEIM"]     = Vector3.new(7000, 120, -7000)
}

-- ==========================================
-- INTERACTION & SELECTION GENERATOR
-- ==========================================

local function tweenColor(instance, property, targetColor)
    TweenService:Create(instance, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = targetColor}):Play()
end

-- Generate Tombol Target Boss
for bossKey, _ in pairs(targetBosses) do
    local displayName = string.upper(bossKey)
    if bossKey == "blackswordsman" then displayName = "BLACK SWORDSMAN" end
    
    local bBtn = Instance.new("TextButton")
    bBtn.Parent = ScrollBoss
    bBtn.Size = UDim2.new(1, -6, 0, 26)
    bBtn.BackgroundColor3 = Colors.ButtonBg
    bBtn.Font = Enum.Font.GothamSemibold
    bBtn.Text = "  " .. displayName .. " : [OFF]"
    bBtn.TextColor3 = Colors.TextDark
    bBtn.TextSize = 10
    bBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 4) bc.Parent = bBtn
    local bs = Instance.new("UIStroke") bs.Color = Colors.ButtonStroke bs.Parent = bBtn

    bBtn.MouseButton1Click:Connect(function()
        targetBosses[bossKey] = not targetBosses[bossKey]
        if targetBosses[bossKey] then
            bBtn.Text = "  " .. displayName .. " : [TARGETED]"
            bBtn.TextColor3 = Colors.TextMain
            bs.Color = Colors.Accent
            tweenColor(bBtn, "BackgroundColor3", Colors.Success)
        else
            bBtn.Text = "  " .. displayName .. " : [OFF]"
            bBtn.TextColor3 = Colors.TextDark
            bs.Color = Colors.ButtonStroke
            tweenColor(bBtn, "BackgroundColor3", Colors.ButtonBg)
        end
    end)
end

-- Generate Tombol Teleport Dunia
for worldName, coords in pairs(worldLocations) do
    local wBtn = Instance.new("TextButton")
    wBtn.Parent = ScrollWorld
    wBtn.Size = UDim2.new(1, -6, 0, 26)
    wBtn.BackgroundColor3 = Colors.ButtonBg
    wBtn.Font = Enum.Font.GothamSemibold
    wBtn.Text = "  TELEPORT TO: " .. worldName
    wBtn.TextColor3 = Colors.TextMain
    wBtn.TextSize = 9
    wBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local wc = Instance.new("UICorner") wc.CornerRadius = UDim.new(0, 4) wc.Parent = wBtn
    local ws = Instance.new("UIStroke") ws.Color = Colors.ButtonStroke ws.Parent = wBtn

    wBtn.MouseButton1Click:Connect(function()
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local mapObject = workspace:FindFirstChild(worldName) or (workspace:FindFirstChild("Visuals") and workspace.Visuals:FindFirstChild(worldName))
            if mapObject and mapObject:IsA("BasePart") then
                hrp.CFrame = mapObject.CFrame * CFrame.new(0, 5, 0)
            else
                hrp.CFrame = CFrame.new(coords)
            end
        end
    end)
end

local function updateToggleVisual(btn, stroke, state, text)
    if state then
        btn.Text = text .. " : ON"
        btn.TextColor3 = Colors.TextMain
        stroke.Color = Colors.Accent
        tweenColor(btn, "BackgroundColor3", Colors.Success)
    else
        btn.Text = text .. " : OFF"
        btn.TextColor3 = Colors.TextDark
        stroke.Color = Colors.ButtonStroke
        tweenColor(btn, "BackgroundColor3", Colors.ButtonBg)
    end
end

ToggleFarm.MouseButton1Click:Connect(function() flags.autofarm = not flags.autofarm updateToggleVisual(ToggleFarm, StrokeFarm, flags.autofarm, "AUTO FARM") end)
ToggleClick.MouseButton1Click:Connect(function() flags.autoclick = not flags.autoclick updateToggleVisual(ToggleClick, StrokeClick, flags.autoclick, "AUTO ATTACK") end)
ToggleSkillX.MouseButton1Click:Connect(function() flags.autoskillX = not flags.autoskillX updateToggleVisual(ToggleSkillX, StrokeSkillX, flags.autoskillX, "AUTO SKILL (X)") end)
ToggleSkillC.MouseButton1Click:Connect(function() flags.autoskillC = not flags.autoskillC updateToggleVisual(ToggleSkillC, StrokeSkillC, flags.autoskillC, "AUTO SKILL (C)") end)
ToggleSkill.MouseButton1Click:Connect(function() flags.autoskill = not flags.autoskill updateToggleVisual(ToggleSkill, StrokeSkill, flags.autoskill, "AUTO SKILL (V)") end)

-- ==========================================
-- SMART MULTI-MAP SCANNER (ANTI-STUCK)
-- ==========================================

local function getValidTargetInCurrentMap()
    local instances = workspace:GetChildren()
    
    for _, obj in pairs(instances) do
        if obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChild("HumanoidRootPart")) then
            for _, subObj in pairs(obj:GetChildren()) do
                table.insert(instances, subObj)
            end
        end
    end

    for _, v in pairs(instances) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") then
            local cleanName = string.gsub(string.lower(v.Name), "%s+", "")
            
            for bossName, isSelected in pairs(targetBosses) do
                local cleanBossName = string.gsub(string.lower(bossName), "%s+", "")
                if isSelected and string.find(cleanName, cleanBossName) then
                    local hum = v:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        return v.HumanoidRootPart
                    end
                end
            end
        end
    end
    
    return nil
end

-- ==========================================
-- AUTOMATION LOOPS (NOCLIP & MOVEMENT)
-- ==========================================

RunService.Stepped:Connect(function()
    if flags.autofarm then
        local char = plr.Character
        if char then
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
    end
end)

-- LOOP 1: Teleportation & CFrame Locking
task.spawn(function()
    while true do
        task.wait(0.01)
        if flags.autofarm then
            pcall(function()
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetHRP = getValidTargetInCurrentMap()
                    
                    if targetHRP then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 1.5, 4.5)
                    end
                end
            end)
        end
    end
end)

-- LOOP 2: Auto Attack (M1 Click Spam)
task.spawn(function()
    while true do
        task.wait(0.1)
        if flags.autofarm and flags.autoclick then
            pcall(function()
                if getValidTargetInCurrentMap() then
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.01)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end)
        end
    end
end)

-- LOOP 3: Auto Skill X
task.spawn(function()
    while true do
        task.wait(0.5)
        if flags.autofarm and flags.autoskillX then
            pcall(function()
                if getValidTargetInCurrentMap() then
                    vim:SendKeyEvent(true, Enum.KeyCode.X, false, game)
                    task.wait(0.02)
                    vim:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                end
            end)
        end
    end
end)

-- LOOP 4: Auto Skill C
task.spawn(function()
    while true do
        task.wait(0.55)
        if flags.autofarm and flags.autoskillC then
            pcall(function()
                if getValidTargetInCurrentMap() then
                    vim:SendKeyEvent(true, Enum.KeyCode.C, false, game)
                    task.wait(0.02)
                    vim:SendKeyEvent(false, Enum.KeyCode.C, false, game)
                end
            end)
        end
    end
end)

-- LOOP 5: Auto Skill V
task.spawn(function()
    while true do
        task.wait(0.6)
        if flags.autofarm and flags.autoskill then
            pcall(function()
                if getValidTargetInCurrentMap() then
                    vim:SendKeyEvent(true, Enum.KeyCode.V, false, game)
                    task.wait(0.02)
                    vim:SendKeyEvent(false, Enum.KeyCode.V, false, game)
                end
            end)
        end
    end
end)
