local player = game:GetService("Players").LocalPlayer
local chr = player.Character
if not chr or not chr.Parent then
    chr = player.CharacterAdded:Wait()
end
local running = true
local items = game:GetService("Workspace").placeFolders.items

local function collectItems()
    for i, v in pairs(items:GetChildren()) do
        local args = {
            [1] = "pickUpItemRequest",
            [2] = v
        }
        
        game:GetService("ReplicatedStorage").playerRequest:InvokeServer(unpack(args))
        wait(.3)
    end
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Vesteria Vulture",
	LoadingTitle = "Made by SweetyHush#0001, ",
	LoadingSubtitle = "Requested by: A.A.A#3581",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = makefolder("GameData/"), -- Create a custom folder for your hub/game
		FileName = "Vestaria Config.json"
	},
        Discord = {
        	Enabled = false,
        	Invite = "sirius", -- The Discord invite code, do not include discord.gg/
        	RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Sirius Hub",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/sirius)",
		FileName = "SiriusKey",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = "Hello"
	}
})

local Tab = Window:CreateTab("Signs", 4483362458) -- Title, Image
local Tab2 = Window:CreateTab("Future Ideas/Info", 4483362458) -- Title, Image
Tab2:CreateLabel("Auto Fight")
Tab2:CreateLabel("Auto Loadout Switch")
Tab2:CreateLabel("Inventory Orginizer")
Tab2:CreateLabel("Hotbar Swapper")
Tab2:CreateLabel("Made By: SweetyHush#0001")
Tab2:CreateLabel("Press RightShift to hide.")
 
Tab:CreateToggle({
    Name = "Auto Collect Items",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Toggle1 = Value
        while Toggle1 do
            collectItems()
            wait(5)
        end
    end
})

Tab:CreateInput({
    Name = "Range",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        range = Text
    end
})

Tab:CreateToggle({
    Name = "Collection Aura",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function(Value)
        Toggle2 = Value
        while Toggle2 do
            range = range or 0
            for i,v in pairs(items:GetChildren()) do
                if v:IsA("BasePart") then
                    local root = chr:WaitForChild("hitbox")
                    local distance = (v.Position - root.Position).Magnitude
                    if distance <= tonumber(range) then
                        local args = {
                            [1] = "pickUpItemRequest",
                            [2] = v
                        }
                        
                        game:GetService("ReplicatedStorage").playerRequest:InvokeServer(unpack(args))
                    end
                end
            end
            wait()
        end
    end
})

Tab:CreateButton({
    Name = "Collect Everything",
    Callback = function()
        collectItems()
    end
})

cDtct = player.CharacterAdded:Connect(function(character)
    chr = character
end)

Tab2:CreateButton({
	Name = "Kill Script",
	Callback = function()
        cDtct:Disconnect()
		Rayfield:Destroy()
	end
})