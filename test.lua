--[[
Spedian Clone Desync - Pure Clone Phase Script for Steal a Brainrot
Clone moves left/right outside wall, real body phases forward inside
Toggle with INSERT key (or hold Q as fallback)
Face base wall, get close, press INSERT to start
Press INSERT again to stop / cleanup
March 2026 - debug prints included
]]

print("Spedian Clone Desync loading...")

local toggleKey = Enum.KeyCode.Insert       -- Main toggle key (change to Home/PageUp if Insert conflicts)
local fallbackKey = "q"                     -- Hold this letter as mouse fallback

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

print("Services ready - waiting for character")

local cloneActive = false
local cloneInstance = nil
local cloneRoot = nil
local cloneMoveConn = nil

local phaseOffset = 45      -- studs forward (increase to 55-70 if not reaching inside, decrease if overshooting)
local cloneMoveSpeed = 12   -- clone left/right walk speed

local function startCloneDesync()
    print("startCloneDesync called")
    
    if cloneActive then
        print("Already active - cleaning up first")
        stopCloneDesync()
    end

    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        print("No character or root part yet - wait and try again")
        return
    end

    cloneActive = true
    print("Activating clone desync")

    local char = localPlayer.Character
    local root = char.HumanoidRootPart

    -- Create clone behind player (outside wall)
    cloneInstance = char:Clone()
    cloneInstance.Name = "GhostClone"
    cloneInstance.Parent = workspace
    print("Clone created in workspace")

    -- Position clone ~15 studs behind
    local behindCFrame = root.CFrame * CFrame.new(0, 0, 15)
    cloneInstance:PivotTo(behindCFrame)
    print("Clone positioned behind player")

    cloneRoot = cloneInstance:FindFirstChild("HumanoidRootPart")
    local cloneHum = cloneInstance:FindFirstChild("Humanoid")

    if cloneHum then
        cloneHum.WalkSpeed = 16
        cloneHum.AutoRotate = false
        print("Clone humanoid configured")
    end

    if cloneRoot then
        pcall(function()
            cloneRoot:SetNetworkOwner(localPlayer)
            print("Set clone network ownership to local player")
        end)
    end

    -- Clone left/right movement loop
    local direction = 1
    cloneMoveConn = RunService.Heartbeat:Connect(function(dt)
        if not cloneRoot or not cloneInstance.Parent then
            print("Clone lost - stopping movement")
            if cloneMoveConn then cloneMoveConn:Disconnect() end
            return
        end
        
        direction = direction * -1
        local moveVec = Vector3.new(direction * cloneMoveSpeed * dt, 0, 0)
        cloneRoot.CFrame = cloneRoot.CFrame + moveVec
        cloneRoot.AssemblyLinearVelocity = moveVec * 40
    end)
    print("Clone movement loop started (left/right)")

    -- Phase real body forward with desync boost
    print("Applying desync boost and phasing real body")
    root.AssemblyLinearVelocity = Vector3.zero
    root.Velocity = Vector3.zero

    local phaseCFrame = root.CFrame + root.CFrame.LookVector * phaseOffset + Vector3.new(0, 4, 0)
    root.CFrame = phaseCFrame
    print("Real body snapped forward " .. phaseOffset .. " studs - should be inside now")

    -- No auto-return - press key again to stop
end

local function stopCloneDesync()
    if not cloneActive then return end
    cloneActive = false
    print("Stopping clone desync - cleaning up")

    if cloneMoveConn then 
        cloneMoveConn:Disconnect() 
        cloneMoveConn = nil 
    end

    if cloneInstance then 
        cloneInstance:Destroy() 
        cloneInstance = nil 
    end

    cloneRoot = nil
    print("Cleanup complete")
end

-- Key listener
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then 
        print("Input processed by game - ignored")
        return 
    end
    
    print("Input detected: " .. tostring(input.KeyCode))
    
    if input.KeyCode == toggleKey then
        print("Toggle key pressed - calling function")
        if cloneActive then
            stopCloneDesync()
        else
            startCloneDesync()
        end
    end
end)

-- Fallback: hold Q
localPlayer:GetMouse().KeyDown:Connect(function(key)
    if key == fallbackKey then
        print("Fallback Q held - toggling clone")
        if cloneActive then
            stopCloneDesync()
        else
            startCloneDesync()
        end
    end
end)

print("Listeners connected")
print("Face base wall → Press INSERT (or hold Q) to start clone desync")
print("Press again to stop / cleanup")
print("Watch console for step-by-step messages (F9 in Roblox)")
