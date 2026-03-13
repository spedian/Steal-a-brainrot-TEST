--[[
Spedian Scripts v0.95 - Your exact request
Full GUI + God Mode always on (no button) + Clone Phase Forward button only
God Mode runs silently in background
Press F2 to open GUI
]]

print("Spedian Scripts v0.95 loading...")

local toggleKey = Enum.KeyCode.F2
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpedianScriptsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 600)
mainFrame.Position = UDim2.new(0.5, -170, 0.35, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Spedian Scripts v0.95"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 28)
closeBtn.Position = UDim2.new(1, -46, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = titleBar

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 140, 0, 35)
openBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
openBtn.Text = "Spedian Scripts"
openBtn.Font = Enum.Font.GothamSemibold
openBtn.TextSize = 15
openBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
openBtn.Visible = false
openBtn.Parent = screenGui
openBtn.Draggable = true

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

-- Speed & Safe
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "TP Speed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = scrollFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.3, 0, 0, 30)
speedBox.Position = UDim2.new(0.6, 0, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Text = "30"
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Parent = scrollFrame

local safeToggle = Instance.new("TextButton")
safeToggle.Size = UDim2.new(0.9, 0, 0, 35)
safeToggle.Position = UDim2.new(0.05, 0, 0, 40)
safeToggle.BackgroundColor3 = Color3.fromRGB(60,180,60)
safeToggle.Text = "Safe Mode: ON"
safeToggle.TextColor3 = Color3.new(1,1,1)
safeToggle.Font = Enum.Font.GothamSemibold
safeToggle.TextSize = 14
safeToggle.Parent = scrollFrame
local safeMode = true
safeToggle.MouseButton1Click:Connect(function()
    safeMode = not safeMode
    safeToggle.Text = "Safe Mode: " .. (safeMode and "ON" or "OFF")
    safeToggle.BackgroundColor3 = safeMode and Color3.fromRGB(60,180,60) or Color3.fromRGB(180,60,60)
end)

-- Tween helper
local currentTween = nil
local function tweenToCFrame(goalCFrame)
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = localPlayer.Character.HumanoidRootPart
    if currentTween then currentTween:Cancel() end
    local distance = (myRoot.Position - goalCFrame.Position).Magnitude
    local baseSpeed = tonumber(speedBox.Text) or 30
    local tweenTime = distance / (safeMode and math.min(baseSpeed, 25) or baseSpeed)
    if tweenTime < 0.3 then tweenTime = 0.3 end
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(myRoot, tweenInfo, {CFrame = goalCFrame})
    currentTween:Play()
end

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        tweenToCFrame(targetRoot.CFrame + Vector3.new(0, 3, 0))
    end
end)

-- GOD MODE ALWAYS ON (no button, runs in background)
local function enableGodMode()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        local hum = localPlayer.Character.Humanoid
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
end

-- Keep god mode on after respawn
localPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    enableGodMode()
end)

enableGodMode() -- activate immediately

-- Clone Desync Phase
local cloneActive = false
local cloneInstance = nil
local cloneRoot = nil
local cloneMoveConn = nil

local phaseOffset = 45
local cloneMoveSpeed = 12

local function startCloneDesync()
    print("Clone Phase Forward button pressed")
    
    if cloneActive then
        stopCloneDesync()
        task.wait(0.5)
    end

    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        print("No character - cannot start")
        return
    end

    cloneActive = true
    print("Starting clone desync phase")

    local char = localPlayer.Character
    local root = char.HumanoidRootPart

    cloneInstance = char:Clone()
    cloneInstance.Name = "GhostClone"
    cloneInstance.Parent = workspace
    print("Clone created")

    local behindCFrame = root.CFrame * CFrame.new(0, 0, 15)
    cloneInstance:PivotTo(behindCFrame)
    print("Clone placed outside")

    cloneRoot = cloneInstance:FindFirstChild("HumanoidRootPart")
    local cloneHum = cloneInstance:FindFirstChild("Humanoid")
    if cloneHum then cloneHum.WalkSpeed = 16 end

    -- Clone moves left/right
    local direction = 1
    cloneMoveConn = RunService.Heartbeat:Connect(function(dt)
        if not cloneRoot then return end
        direction = direction * -1
        local move = Vector3.new(direction * cloneMoveSpeed * dt, 0, 0)
        cloneRoot.CFrame = cloneRoot.CFrame + move
        cloneRoot.AssemblyLinearVelocity = move * 40
    end)
    print("Clone is moving left/right outside")

    -- Phase real body inside
    root.AssemblyLinearVelocity = Vector3.zero
    root.Velocity = Vector3.zero

    local phaseCFrame = root.CFrame + root.CFrame.LookVector * phaseOffset + Vector3.new(0, 4, 0)
    root.CFrame = phaseCFrame
    print("Real body phased forward " .. phaseOffset .. " studs - you should be inside")
end

local function stopCloneDesync()
    if not cloneActive then return end
    cloneActive = false
    if cloneMoveConn then cloneMoveConn:Disconnect() end
    if cloneInstance then cloneInstance:Destroy() end
    cloneRoot = nil
    print("Clone phase stopped")
end

-- GUI refresh
local yPos = 90
local function refreshList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end
    yPos = 90

    -- Player list
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Size = UDim2.new(0.9, 0, 0, 30)
    playerLabel.Position = UDim2.new(0.05, 0, 0, yPos - 40)
    playerLabel.BackgroundTransparency = 1
    playerLabel.Text = "Teleport to Players"
    playerLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextSize = 16
    playerLabel.Parent = scrollFrame

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 35)
            btn.Position = UDim2.new(0.05, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,80)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Text = p.Name
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 14
            btn.Parent = scrollFrame
            yPos = yPos + 40
            btn.MouseButton1Click:Connect(function() teleportToPlayer(p) end)
        end
    end

    local exploitsLabel = Instance.new("TextLabel")
    exploitsLabel.Size = UDim2.new(0.9, 0, 0, 30)
    exploitsLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    exploitsLabel.BackgroundTransparency = 1
    exploitsLabel.Text = "Exploits & Clone"
    exploitsLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    exploitsLabel.Font = Enum.Font.GothamBold
    exploitsLabel.TextSize = 18
    exploitsLabel.Parent = scrollFrame
    yPos = yPos + 40

    -- Desync, Noclip, God (no god button - it's always on)
    local desyncButton = Instance.new("TextButton")
    desyncButton.Size = UDim2.new(0.9, 0, 0, 35)
    desyncButton.Position = UDim2.new(0.05, 0, 0, yPos)
    desyncButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    desyncButton.Text = "Desync: OFF"
    desyncButton.TextColor3 = Color3.new(1,1,1)
    desyncButton.Font = Enum.Font.GothamSemibold
    desyncButton.TextSize = 14
    desyncButton.Parent = scrollFrame
    yPos = yPos + 40

    local noclipButton = Instance.new("TextButton")
    noclipButton.Size = UDim2.new(0.9, 0, 0, 35)
    noclipButton.Position = UDim2.new(0.05, 0, 0, yPos)
    noclipButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    noclipButton.Text = "Noclip: OFF"
    noclipButton.TextColor3 = Color3.new(1,1,1)
    noclipButton.Font = Enum.Font.GothamSemibold
    noclipButton.TextSize = 14
    noclipButton.Parent = scrollFrame
    yPos = yPos + 40

    -- Clone Phase Forward button
    local clonePhaseButton = Instance.new("TextButton")
    clonePhaseButton.Size = UDim2.new(0.9, 0, 0, 35)
    clonePhaseButton.Position = UDim2.new(0.05, 0, 0, yPos)
    clonePhaseButton.BackgroundColor3 = Color3.fromRGB(100,60,100)
    clonePhaseButton.Text = "Clone Phase Forward (Desync)"
    clonePhaseButton.TextColor3 = Color3.new(1,1,1)
    clonePhaseButton.Font = Enum.Font.GothamSemibold
    clonePhaseButton.TextSize = 14
    clonePhaseButton.Parent = scrollFrame
    yPos = yPos + 40

    clonePhaseButton.MouseButton1Click:Connect(function()
        print("Clone Phase button clicked")
        startCloneDesync()
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)
end

refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == toggleKey then
        mainFrame.Visible = not mainFrame.Visible
        openBtn.Visible = not mainFrame.Visible
    end
end)

openBtn.Visible = not mainFrame.Visible

print("Spedian Scripts v0.95 loaded - God Mode is always on")
print("Press F2 to open GUI")
print("Face base wall → Click 'Clone Phase Forward (Desync)'")
