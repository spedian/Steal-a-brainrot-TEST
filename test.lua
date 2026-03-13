--[[
Spedian Scripts v0.95 - ONLY Clone Phase + Permanent God Mode
GUI with single button: Clone Phase Forward (Desync)
God Mode + anti-ragdoll always running in background (no button)
Press F2 to open GUI
]]

print("Spedian Scripts v0.95 loading...")

local toggleKey = Enum.KeyCode.F2
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpedianScriptsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.4, -110)
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
titleLabel.Size = UDim2.new(1, -70, 1, 0)
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
scrollFrame.Size = UDim2.new(1, -20, 1, -90)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

-- GOD MODE ALWAYS ON (silent, permanent)
local function enableGodMode()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        local hum = localPlayer.Character.Humanoid
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
end

localPlayer.CharacterAdded:Connect(enableGodMode)
enableGodMode()  -- activate immediately and forever

-- Clone Desync Phase
local cloneActive = false
local cloneInstance = nil
local cloneRoot = nil
local cloneMoveConn = nil

local phaseOffset = 48
local cloneMoveSpeed = 14

local function startCloneDesync()
    print("Clone Phase Forward button clicked")
    
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
    print("Clone moving left/right outside")

    -- Phase real body
    root.AssemblyLinearVelocity = Vector3.zero
    root.Velocity = Vector3.zero

    local phaseCFrame = root.CFrame + root.CFrame.LookVector * phaseOffset + Vector3.new(0, 4, 0)
    root.CFrame = phaseCFrame
    print("Real body phased forward " .. phaseOffset .. " studs - inside now!")
end

local function stopCloneDesync()
    if not cloneActive then return end
    cloneActive = false
    if cloneMoveConn then cloneMoveConn:Disconnect() end
    if cloneInstance then cloneInstance:Destroy() end
    cloneRoot = nil
    print("Clone phase stopped")
end

-- GUI with only the clone button
local yPos = 10
local function refreshList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end
    yPos = 10

    local exploitsLabel = Instance.new("TextLabel")
    exploitsLabel.Size = UDim2.new(0.9, 0, 0, 30)
    exploitsLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    exploitsLabel.BackgroundTransparency = 1
    exploitsLabel.Text = "Clone Phase"
    exploitsLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    exploitsLabel.Font = Enum.Font.GothamBold
    exploitsLabel.TextSize = 18
    exploitsLabel.Parent = scrollFrame
    yPos = yPos + 40

    local clonePhaseButton = Instance.new("TextButton")
    clonePhaseButton.Size = UDim2.new(0.9, 0, 0, 50)
    clonePhaseButton.Position = UDim2.new(0.05, 0, 0, yPos)
    clonePhaseButton.BackgroundColor3 = Color3.fromRGB(100,60,100)
    clonePhaseButton.Text = "Clone Phase Forward (Desync)"
    clonePhaseButton.TextColor3 = Color3.new(1,1,1)
    clonePhaseButton.Font = Enum.Font.GothamSemibold
    clonePhaseButton.TextSize = 16
    clonePhaseButton.Parent = scrollFrame
    yPos = yPos + 60

    clonePhaseButton.MouseButton1Click:Connect(function()
        print("Clone Phase button clicked")
        startCloneDesync()
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

refreshList()

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

print("Spedian Scripts v0.95 loaded")
print("God Mode is always on in background")
print("Press F2 to open GUI")
print("Face base wall → Click 'Clone Phase Forward (Desync)'")
