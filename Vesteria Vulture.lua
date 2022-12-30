repeat wait() until game:IsLoaded()

if game.GameId == 833209132 then
    local httpService = game:GetService("HttpService")
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

    local function saveConfig(data)
        if not isfolder("GameData/") then
            makefolder("GameData/")
        end
        writefile("GameData/Vulture Config.json", httpService:JSONEncode(data))
    end

    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

    local Window = Rayfield:CreateWindow({
        Name = "Vesteria Vulture",
        LoadingTitle = "Made by SweetyHush#0001, ",
        LoadingSubtitle = "Requested By User",
        ConfigurationSaving = {
            Enabled = false,
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

    local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
    local Tab2 = Window:CreateTab("Info", "11971057473") -- Title, Image
    local Tab3 = Window:CreateTab("Do Not Suggest", "11971263221")
    local Tab4 = Window:CreateTab("Updates", "11970691878")
    Tab2:CreateLabel("Future Ideas:")
    local futureIdeas = {
        "- Auto Fight",
        "- Auto Loadout Switch",
        "- Inventory Orginizer",
        "- Hotbar Swapper",
        "- UI Overhaul"
    }
    
    for i, v in pairs(futureIdeas) do
        Tab2:CreateLabel(v)
    end
    Tab2:CreateLabel("Made By: SweetyHush#0001 - Send bugs/suggestions")
    Tab2:CreateLabel("CHECK DO NOT SUGGEST TAB")
    Tab2:CreateLabel("Press RightShift to hide.")

    Tab3:CreateLabel("Do not suggest the following: ")
    local doNotRequest = {
        "- Infinite Currency",
        "- God Mode/Infinite Health",
        "- Item duplication/creation",
        "- Anything already listed in Future Ideas/Info",
        "- Anything you know for certain is server sided.",
    }
    for i,v in pairs(doNotRequest) do
        Tab3:CreateLabel(v)
    end
    Tab3:CreateLabel("FAILURE TO COMPLY WILL GET YOU BLACKLISTED FROM SUGGESTIONS")
    Tab3:CreateLabel("Not all suggestions will be added.")

    local updateInfo = {
        ["1.1.0"] = {
            "- Added Do Not Request Tab",
            "- Added Updates Tab",
            "- Added Custom Icons",
            "- Added Config Saving",
            "- Added Auto-Excute Compatability",
            "- Added New Info",
            "- Changed Signs Tab to Main",
            "- Changed Future Ideas/Info Tab to Info",
            "- Moved Kill Script button to Main",
            "- Removed User Data by request"
        }
    }
    for i,v in pairs(updateInfo) do
        Tab4:CreateLabel("Update " .. i)
        for i2,v2 in pairs(v) do
            Tab4:CreateLabel(v2)
        end
    end

    if isfolder("GameData/") and isfile("GameData/Vulture Config.json") then
        UIData = httpService:JSONDecode(readfile("GameData/Vulture Config.json"))
    else
        UIData = {}
    end
    local tmp = Tab:CreateToggle({
        Name = "Auto Collect Items",
        CurrentValue = UIData["autoCollect"] or false,
        Flag = "Toggle1",
        Callback = function(Value)
            UIData["autoCollect"] = Value
            while UIData["autoCollect"] do
                collectItems()
                wait()
            end
        end
    })
    task.spawn(function()
        tmp["Callback"](UIData["autoCollect"])
    end)

    Tab:CreateInput({
        Name = "Range",
        PlaceholderText = UIData["Range"] or "0",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            UIData["Range"] = Text
        end
    })

    tmp = Tab:CreateToggle({
        Name = "Collection Aura",
        CurrentValue = UIData["rangedCollect"] or false,
        Flag = "Toggle2",
        Callback = function(Value)
            UIData["rangedCollect"] = Value
            while UIData["rangedCollect"] do
                range = UIData["Range"] or 0
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
    task.spawn(function()
        tmp["Callback"](UIData["rangedCollect"])
    end)

    Tab:CreateButton({
        Name = "Collect Everything",
        Callback = function()
            collectItems()
        end
    })

    cDtct = player.CharacterAdded:Connect(function(character)
        chr = character
    end)

    pRemoving = game:GetService("Players").PlayerRemoving:Connect(function(removing)
        if removing == player then
            saveConfig(UIData)
        end
    end)

    Tab:CreateButton({
        Name = "Kill Script",
        Callback = function()
            saveConfig(UIData)
            pRemoving:Disconnect()
            cDtct:Disconnect()
            Rayfield:Destroy()
        end
    })
end