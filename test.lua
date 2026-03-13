--[[
WARNING: Use at your own risk! Revamped v0.9 - Added Instant Steal Nearest button
Attempts to fire common steal remotes or simulate interaction on closest Brainrot.
May not work if remote name changed or server validates hard.
]]

-- [All previous services, GUI setup, title, frames, speed controls, safe toggle, tweenToCFrame, teleportToPlayer functions remain the same as v0.8 - copy them in if needed]

-- In refreshList(), after other exploit buttons (desync, noclip, god, clone, tp base, reset):

    -- Instant Steal Nearest Button
    local instantStealButton = Instance.new("TextButton")
    instantStealButton.Size = UDim2.new(1, -10, 0, 30)
    instantStealButton.Position = UDim2.new(0, 5, 0, yPos)
    instantStealButton.BackgroundColor3 = Color3.fromRGB(180, 100, 60)
    instantStealButton.Text = "Instant Steal Nearest Brainrot"
    instantStealButton.TextColor3 = Color3.new(1,1,1)
    instantStealButton.Font = Enum.Font.GothamSemibold
    instantStealButton.TextSize = 14
    instantStealButton.Parent = scrollFrame
    yPos = yPos + 35

    instantStealButton.MouseButton1Click:Connect(function()
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = localPlayer.Character.HumanoidRootPart
        local closestBrainrot = nil
        local minDist = math.huge

        -- Find closest Brainrot (assume Brainrots are models/parts named "Brainrot" or similar in workspace)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj.Name:lower():find("brainrot") or obj.Name:lower():find("pet")) and obj:IsA("BasePart") or obj:IsA("Model") then
                local pos = obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position or obj.Position
                if pos then
                    local dist = (root.Position - pos).Magnitude
                    if dist < minDist and dist < 50 then  -- limit to nearby
                        minDist = dist
                        closestBrainrot = obj
                    end
                end
            end
        end

        if closestBrainrot then
            -- Attempt 1: Fire common remote patterns (from 2026 hubs)
            local remotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")
            local possibleRemotes = {
                remotesFolder:FindFirstChild("StealBrainrot"),
                remotesFolder:FindFirstChild("DeliverySteal"),
                remotesFolder:FindFirstChild("Steal"),
                remotesFolder:FindFirstChild("GrabPet"),
                remotesFolder:FindFirstChild("ClaimBrainrot")
            }

            for _, remote in ipairs(possibleRemotes) do
                if remote and remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(closestBrainrot)  -- try firing with target as arg
                    end)
                elseif remote and remote:IsA("RemoteFunction") then
                    pcall(function()
                        remote:InvokeServer(closestBrainrot)
                    end)
                end
            end

            -- Attempt 2: Simulate interaction if prompt visible
            if closestBrainrot:FindFirstChild("ProximityPrompt") then
                pcall(function()
                    closestBrainrot.ProximityPrompt.Triggered:Fire()  -- client-side trigger attempt
                end)
            end

            -- Visual feedback
            instantStealButton.Text = "Steal Attempted! (check if worked)"
            task.delay(2, function() instantStealButton.Text = "Instant Steal Nearest Brainrot" end)
        else
            instantStealButton.Text = "No nearby Brainrot found!"
            task.delay(2, function() instantStealButton.Text = "Instant Steal Nearest Brainrot" end)
        end
    end)

    -- Optional: Add a toggle for auto-steal loop later if wanted
    -- e.g., local autoSteal = false; button for toggle, then loop find & fire every 0.5s

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
end

-- [Rest of your code: refreshList calls, connections, etc. remain the same]
