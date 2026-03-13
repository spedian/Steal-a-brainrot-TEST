--[[
Spedian Scripts v0.92 - Full GUI for Steal a Brainrot
Features: Tween TP, Desync (cleaned), Noclip, God Mode, Clone Phase, TP to Own Base, Full Reset, Instant Steal + Spam Toggle
Use at your own risk - Updated for slowmo fix and better steal attempt
]]

local toggleKey     = Enum.KeyCode.F2
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local RunService    = game:GetService("RunService")

local localPlayer   = Players.LocalPlayer
local playerGui     = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpedianScriptsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 620)
mainFrame.Position = UDim2.new(0.5, -170, 0.35, -310)
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
titleLabel.Text = "Spedian Scripts v0.92"
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

-- Speed & Safe controls
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "TP Speed (studs/sec):"
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
safeToggle.Text = "Safe Mode: ON (slower)"
safeToggle.TextColor3 = Color3.new(1,1,1)
safeToggle.Font = Enum.Font.GothamSemibold
safeToggle.TextSize = 14
safeToggle.Parent = scrollFrame
local safeMode = true
safeToggle.MouseButton1Click:Connect(function()
    safeMode = not safeMode
    safeToggle.Text = "Safe Mode: " .. (safeMode and "ON (slower)" or "OFF (faster)")
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
    task.delay(tweenTime + 0.2, function()
        if myRoot then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, -5, 0)
            task.delay(0.3, function() if myRoot then myRoot.AssemblyLinearVelocity = Vector3.zero end end)
        end
    end)
end

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        tweenToCFrame(targetRoot.CFrame + Vector3.new(0, 3, 0))
    end
end

-- Refresh function with all buttons
local yPos = 90
local desyncEnabled = false
local desyncConn
local noclipEnabled = false
local noclipConn
local godEnabled = false
local autoStealEnabled = false
local autoStealConn

local function refreshList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end
    yPos = 90

    -- Player list label
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Size = UDim2.new(0.9, 0, 0, 30)
    playerLabel.Position = UDim2.new(0.05, 0, 0, yPos - 40)
    playerLabel.BackgroundTransparency = 1
    playerLabel.Text = "Teleport to Players"
    playerLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextSize = 16
    playerLabel.Parent = scrollFrame

    -- Player buttons
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

    -- Exploits label
    local exploitsLabel = Instance.new("TextLabel")
    exploitsLabel.Size = UDim2.new(0.9, 0, 0, 30)
    exploitsLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    exploitsLabel.BackgroundTransparency = 1
    exploitsLabel.Text = "Exploits"
    exploitsLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    exploitsLabel.Font = Enum.Font.GothamBold
    exploitsLabel.TextSize = 18
    exploitsLabel.Parent = scrollFrame
    yPos = yPos + 40

    -- Desync Toggle (improved)
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
    desyncButton.MouseButton1Click:Connect(function()
        desyncEnabled = not desyncEnabled
        desyncButton.Text = "Desync: " .. (desyncEnabled and "ON" or "OFF")
        desyncButton.BackgroundColor3 = desyncEnabled and Color3.fromRGB(60,180,60) or Color3.fromRGB(80,80,80)
        if desyncEnabled then
            desyncConn = RunService.Heartbeat:Connect(function()
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = localPlayer.Character.HumanoidRootPart
                    root.Velocity = Vector3.new(math.random(-10,10), 0, math.random(-10,10))
                    root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                end
            end)
        else
            if desyncConn then desyncConn:Disconnect() desyncConn = nil end
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
                localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)

    -- Auto-disable desync on death
    localPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            if desyncEnabled then
                desyncEnabled = false
                desyncButton.Text = "Desync: OFF"
                desyncButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
                if desyncConn then desyncConn:Disconnect() desyncConn = nil end
                task.wait(0.1)
                if char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.Velocity = Vector3.zero
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end)
    end)

    -- Noclip Toggle
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
    noclipButton.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        noclipButton.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
        noclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(60,180,60) or Color3.fromRGB(80,80,80)
        if noclipEnabled then
            noclipConn = RunService.Stepped:Connect(function()
                if localPlayer.Character then
                    for _, part in ipairs(localPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        end
    end)

    -- God Mode Toggle
    local godButton = Instance.new("TextButton")
    godButton.Size = UDim2.new(0.9, 0, 0, 35)
    godButton.Position = UDim2.new(0.05, 0, 0, yPos)
    godButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    godButton.Text = "God Mode: OFF"
    godButton.TextColor3 = Color3.new(1,1,1)
    godButton.Font = Enum.Font.GothamSemibold
    godButton.TextSize = 14
    godButton.Parent = scrollFrame
    yPos = yPos + 40
    godButton.MouseButton1Click:Connect(function()
        godEnabled = not godEnabled
        godButton.Text = "God Mode: " .. (godEnabled and "ON" or "OFF")
        godButton.BackgroundColor3 = godEnabled and Color3.fromRGB(60,180,60) or Color3.fromRGB(80,80,80)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            local hum = localPlayer.Character.Humanoid
            hum.MaxHealth = godEnabled and math.huge or 100
            hum.Health = godEnabled and math.huge or 100
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not godEnabled)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, not godEnabled)
        end
    end)

    -- Clone Phase Forward
    local cloneButton = Instance.new("TextButton")
    cloneButton.Size = UDim2.new(0.9, 0, 0, 35)
    cloneButton.Position = UDim2.new(0.05, 0, 0, yPos)
    cloneButton.BackgroundColor3 = Color3.fromRGB(100,60,100)
    cloneButton.Text = "Clone Phase Forward (60 studs)"
    cloneButton.TextColor3 = Color3.new(1,1,1)
    cloneButton.Font = Enum.Font.GothamSemibold
    cloneButton.TextSize = 14
    cloneButton.Parent = scrollFrame
    yPos = yPos + 40
    cloneButton.MouseButton1Click:Connect(function()
        if not localPlayer.Character then return end
        local char = localPlayer.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local forwardOffset = root.CFrame.LookVector * 60
        local targetCFrame = root.CFrame + forwardOffset + Vector3.new(0, 4, 0)
        root.CFrame = targetCFrame
        local clone = char:Clone()
        clone.Parent = workspace
        clone.Name = "PhaseClone"
        clone:PivotTo(targetCFrame)
        task.spawn(function()
            task.wait(3)
            if clone then clone:Destroy() end
        end)
        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0.7; part.CanCollide = false end
        end
    end)

    -- TP to Own Base Collect
    local tpBaseButton = Instance.new("TextButton")
    tpBaseButton.Size = UDim2.new(0.9, 0, 0, 35)
    tpBaseButton.Position = UDim2.new(0.05, 0, 0, yPos)
    tpBaseButton.BackgroundColor3 = Color3.fromRGB(60,100,180)
    tpBaseButton.Text = "TP to Own Base Collect"
    tpBaseButton.TextColor3 = Color3.new(1,1,1)
    tpBaseButton.Font = Enum.Font.GothamSemibold
    tpBaseButton.TextSize = 14
    tpBaseButton.Parent = scrollFrame
    yPos = yPos + 40
    tpBaseButton.MouseButton1Click:Connect(function()
        local collectPos = nil
        local keywords = {"collect", "delivery", "conveyor", "deposit", "drop", "zone", "pad", "dropoff", "sell", "output"}
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and (obj.Name:find(localPlayer.Name) or (obj:FindFirstChild("Owner") and obj.Owner.Value == localPlayer)) then
                for _, child in ipairs(obj:GetDescendants()) do
                    for _, kw in ipairs(keywords) do
                        if child.Name:lower():find(kw) and (child:IsA("BasePart") or child:IsA("MeshPart")) then
                            collectPos = child.Position + Vector3.new(0, 6, 0)
                            break
                        end
                    end
                    if collectPos then break end
                end
                if collectPos then break end
            end
        end

        if collectPos then
            tweenToCFrame(CFrame.new(collectPos))
        else
            local fallback = workspace:FindFirstChild("SpawnLocation") or Vector3.new(0, 100, 0)
            tweenToCFrame(CFrame.new(fallback))
        end
    end)

    -- Full Reset Character (enhanced)
    local resetButton = Instance.new("TextButton")
    resetButton.Size = UDim2.new(0.9, 0, 0, 35)
    resetButton.Position = UDim2.new(0.05, 0, 0, yPos)
    resetButton.BackgroundColor3 = Color3.fromRGB(180,80,80)
    resetButton.Text = "Full Reset (fix slowmo/stuck)"
    resetButton.TextColor3 = Color3.new(1,1,1)
    resetButton.Font = Enum.Font.GothamSemibold
    resetButton.TextSize = 14
    resetButton.Parent = scrollFrame
    yPos = yPos + 40
    resetButton.MouseButton1Click:Connect(function()
        if desyncConn then desyncConn:Disconnect() desyncConn = nil end
        desyncEnabled = false
        desyncButton.Text = "Desync: OFF"
        desyncButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
        if localPlayer.Character then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.Health = 0 end
        end
        task.wait(1.5)  -- wait for respawn
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
            localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        end
    end)

    -- Instant Steal Nearest + Spam Toggle
    local instantStealButton = Instance.new("TextButton")
    instantStealButton.Size = UDim2.new(0.9, 0, 0, 35)
    instantStealButton.Position = UDim2.new(0.05, 0, 0, yPos)
    instantStealButton.BackgroundColor3 = Color3.fromRGB(180, 100, 60)
    instantStealButton.Text = "Instant Steal Nearest"
    instantStealButton.TextColor3 = Color3.new(1,1,1)
    instantStealButton.Font = Enum.Font.GothamSemibold
    instantStealButton.TextSize = 14
    instantStealButton.Parent = scrollFrame
    yPos = yPos + 40

    local spamToggle = Instance.new("TextButton")
    spamToggle.Size = UDim2.new(0.9, 0, 0, 35)
    spamToggle.Position = UDim2.new(0.05, 0, 0, yPos)
    spamToggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
    spamToggle.Text = "Spam Steal: OFF (hold near target)"
    spamToggle.TextColor3 = Color3.new(1,1,1)
    spamToggle.Font = Enum.Font.GothamSemibold
    spamToggle.TextSize = 14
    spamToggle.Parent = scrollFrame
    yPos = yPos + 40

    local autoStealEnabled = false
    local autoStealConn

    local function attemptSteal()
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = localPlayer.Character.HumanoidRootPart
        local closest = nil
        local minDist = math.huge

        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj.Name:lower():find("brainrot") or obj.Name:lower():find("pet") or obj.Name:lower():find("steal") or obj.Name:lower():find("brain")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                local pos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:GetPivot().Position) or obj.Position
                local dist = (root.Position - pos).Magnitude
                if dist < minDist and dist < 40 then
                    minDist = dist
                    closest = obj
                end
            end
        end

        if closest then
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")
            local candidates = {
                "StealBrainrot", "Steal", "DeliverySteal", "Grab", "Claim", "StealPet", "TakeBrainrot", "StealItem", "CollectBrainrot", "BrainrotSteal", "PetSteal", "GrabBrain"
            }

            for _, name in ipairs(candidates) do
                local r = remotes:FindFirstChild(name, true)  -- recursive search
                if r then
                    pcall(function()
                        if r:IsA("RemoteEvent") then r:FireServer(closest) end
                        if r:IsA("RemoteFunction") then r:InvokeServer(closest) end
                    end)
                end
            end

            local prompt = closest:FindFirstChildOfClass("ProximityPrompt") or closest:FindFirstChild("Prompt", true)
            if prompt then
                pcall(function()
                    fireproximityprompt(prompt)
                end)
            end
        end
    end

    spamToggle.MouseButton1Click:Connect(function()
        autoStealEnabled = not autoStealEnabled
        spamToggle.Text = "Spam Steal: " .. (autoStealEnabled and "ON (hold near target)" or "OFF")
        spamToggle.BackgroundColor3 = autoStealEnabled and Color3.fromRGB(60,180,60) or Color3.fromRGB(80,80,80)
        if autoStealEnabled then
            autoStealConn = RunService.RenderStepped:Connect(function()
                if autoStealEnabled then
                    attemptSteal()
                end
            end)
        else
            if autoStealConn then autoStealConn:Disconnect() autoStealConn = nil end
        end
    end)

    instantStealButton.MouseButton1Click:Connect(function()
        attemptSteal()
        instantStealButton.Text = "Attempted!"
        task.delay(1.5, function() instantStealButton.Text = "Instant Steal Nearest" end)
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

print("Spedian Scripts v0.92 loaded - Press F2 to open")
