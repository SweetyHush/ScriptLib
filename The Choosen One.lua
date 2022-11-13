local orderPref = {"Build", "Delete", "Paint", "Detail", "Glaze", "Toxify"}

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local paintColor = Color3.fromRGB(128, 128, 128)
local sounds = {
    ["Create"] = "rbxassetid://9117183621",
    ["Modify"] = "rbxassetid://18473826"
}
local toolDetails = {
    ["Build"] = Color3.fromRGB(75, 151, 75),
    ["Delete"] = Color3.fromRGB(196, 40, 28),
    ["Paint"] = Color3.fromRGB(163, 162, 165),
    ["Detail"] = {Color3.fromRGB(75, 151, 75), Vector3.new(0.9, 0.9, 0.9), "Smooth"},
    ["Glaze"] = Color3.fromRGB(13, 105,172),
    ["Toxify"] = Color3.fromRGB(0, 255, 0)
}

-- Setup
local clrUi = player.PlayerGui:WaitForChild("Colors"):Clone()
clrUi.Name = "clrUi"
clrUi.Parent = player.PlayerGui
for i,v in pairs(clrUi:GetDescendants()) do
    if v:IsA("ImageButton") then
        v.MouseButton1Click:Connect(function()
            paintColor = v.BackgroundColor3
        end)
    end
end
-- Functions
local function getAdmin()
    local points = 0
    for i,v in pairs(game:GetService("Players"):GetChildren()) do
        if v.leaderstats.Time.Value >= points then
            points = v.leaderstats.Time.Value
            admin = v
        end
    end
    return admin
end

local function adjustPos(positon, part)
	positon = Vector3.new(positon.X, positon.Y - 1.5, positon.Z)
	if part.Name == "Back" then
		positon = Vector3.new(positon.X, positon.Y, positon.Z + 0.5) - Vector3.new(0, 0, 3)
	elseif part.Name == "Bottom" then
		positon = Vector3.new(positon.X, positon.Y - 0.5, positon.Z) + Vector3.new(0, 3, 0)
	elseif part.Name == "Front" then
		positon = Vector3.new(positon.X, positon.Y, positon.Z - 0.5) + Vector3.new(0, 0, 3)
	elseif part.Name == "Left" then
		positon = Vector3.new(positon.X - 0.5, positon.Y, positon.Z) + Vector3.new(3, 0, 0)
	elseif part.Name == "Right" then
		positon = Vector3.new(positon.X + 0.5, positon.Y, positon.Z) - Vector3.new(3, 0, 0)
	elseif part.Name == "Top" then
		positon = Vector3.new(positon.X, positon.Y + 0.5, positon.Z) - Vector3.new(0, 3, 0)
	end
	return Vector3.new(math.round(positon.X / 3) * 3, math.round(positon.Y / 3) * 3 + 1.5, math.round(positon.Z / 3) * 3)
end

local function performAction(mode, position)
    local args
    if mode == "Build" then
        args = {
            [1] = position,
            [2] = workspace.Baseplate,
            [3] = Enum.NormalId.Top
        }
    elseif mode == "Paint" then
        args = {
            [1] = position,
            [2] = mouse.Target,
            [3] = Enum.NormalId.Top,
            [4] = paintColor
        }
    else
        args = {
            [1] = position,
            [2] = mouse.Target,
            [3] = Enum.NormalId.Top
        }
    end
    local success, issue = pcall(function()
        getAdmin().Backpack[mode].RemoteEvent:FireServer(unpack(args))
    end)
    if not success then
        getAdmin().Character[mode].RemoteEvent:FireServer(unpack(args))
    end
end

-- Creation
local function giveTools()
    for i,v in pairs(player.Backpack:GetChildren()) do
        v:Destroy()
    end

    local preview = Instance.new("Part")
    preview.Anchored = true
    preview.CanCollide = false
    preview.CanQuery = false
    preview.Name = "Preview"
    preview.Size = Vector3.new(3, 3, 3)
    preview.Transparency = 1
    local selectionTime = time()

    for i,v in pairs(toolDetails) do
        local tool = Instance.new("Tool")
        tool.Name = i
        tool.Parent = player.Backpack
        
        local selectionBox = Instance.new("SelectionBox")
        selectionBox.Name = "SelectionBox"
        selectionBox.Color3 = Color3.fromRGB(255, 255, 255)
        selectionBox.SurfaceColor3 = Color3.fromRGB(0, 0, 0)
        selectionBox.LineThickness = 0.05
        selectionBox.Parent = tool
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        if tool.Name == "Detail" then
            handle.Color, handle.Size, handle.TopSurface = toolDetails[tool.Name][1], toolDetails[tool.Name][2], toolDetails[tool.Name][3]
        else
            handle.Color = toolDetails[tool.Name]
        end
        handle.Parent = tool
        
        local sound = Instance.new("Sound")
        if tool.Name == "Build" or tool.Name == "Delete" or tool.Name == "Detail" then
            sound.SoundId = sounds.Create
        else
            sound.SoundId = sounds.Modify
        end
        sound.Parent = handle

        if tool.Name == "Paint" then
            tool.Unequipped:Connect(function()
                clrUi.Enabled = false
            end)
        end
        
        tool.Activated:Connect(function()
            local mouseDown = false

            if time() - selectionTime > 0.15 and tool.Name ~= "Paint" then
                selectionTime = time()
                local success, issue = pcall(function()
                    getAdmin().Backpack[tool.Name].RemoteEvent:FireServer(mouse.Hit.Position, mouse.Target, mouse.TargetSurface)
                end)
                if not success then
                    getAdmin().Character[tool.Name].RemoteEvent:FireServer(mouse.Hit.Position, mouse.Target, mouse.TargetSurface)
                end
            end
            -- Hold build testing
            -- mouse.Button1Down:Connect(function()
            --     mouseDown = true
            --     while mouseDown do
            --         performAction(tool.Name, mouse.Hit.Position)
            --         tool.Handle.Sound:Play()
            --         tool.Handle.Sound.Ended:Wait()
            --     end
            -- end)

            -- mouse.Button1Up:Connect(function()
            --     mouseDown = false
            -- end)

            performAction(tool.Name, mouse.Hit.Position)
            tool.Handle.Sound:Play()
            tool.Handle.Sound.Ended:Wait()
        end)
        
        tool.Equipped:Connect(function()
            if tool.Name == "Paint" then
                clrUi.Enabled = true
            end

            workspace.Spawn.CanQuery = false

            while tool.Parent.Parent == workspace do
                local selectionPosition = mouse.Hit.Position
                local selectionTarget = mouse.Target
                if selectionTarget and (player.Character.HumanoidRootPart.Position - selectionPosition).Magnitude <= 32 then
                    if selectionTarget.Name == "Brick" then
                        tool.SelectionBox.Adornee = selectionTarget
                    else
                        tool.SelectionBox.Adornee = preview
                        preview.Position = adjustPos(selectionPosition, mouse.TargetSurface)
                    end
                else
                    tool.SelectionBox.Adornee = nil
                end
                wait()
            end
        end)
    end

    for i,v in pairs(player.Backpack:GetChildren()) do
        v.Parent = player
    end
    for i, v in pairs(orderPref) do
        player[v].Parent = player.Backpack
    end
end

-- Connections
player.CharacterAdded:Connect(function()
    giveTools()
end)
giveTools()