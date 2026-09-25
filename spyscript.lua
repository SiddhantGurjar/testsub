-- Prison Logger for Update 30 verification
-- Paste in Delta, Execute, THEN portal to Prison and roam whole island
-- Output: Delta/Workspace/prisonlogs.txt

local LOG_FILE = "prisonlogs.txt"
local PRISON_CENTER = Vector3.new(4875.33, 5.65, 734.85)
local RADIUS = 3500
local INTERVAL = 3

local function safeWrite(txt)
    pcall(function() writefile(LOG_FILE, txt) end)
end
local function safeAppend(txt)
    pcall(function()
        if appendfile then
            appendfile(LOG_FILE, txt)
        else
            local old = ""
            pcall(function() old = readfile(LOG_FILE) end)
            writefile(LOG_FILE, old .. txt)
        end
    end)
end

local function fmtCF(cf)
    local p = cf.Position
    return string.format("CFrame.new(%s, %s, %s)", tostring(p.X), tostring(p.Y), tostring(p.Z))
end
local function fmtV3(v)
    return string.format("(%s, %s, %s)", tostring(v.X), tostring(v.Y), tostring(v.Z))
end

safeWrite("--- PRISON LOG STARTED ---\nTime: " .. tostring(os.date("%Y-%m-%d %H:%M:%S")) .. "\nPlaceId: " .. tostring(game.PlaceId) .. "\nJobId: " .. tostring(game.JobId) .. "\nPrisonCenter: " .. fmtV3(PRISON_CENTER) .. "\n\n")

-- Hook quest remotes so we capture real quest IDs when you talk to Jail Keeper / Head Jailer
pcall(function()
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "InvokeServer" or method == "FireServer" then
            local args = {...}
            pcall(function()
                local n = tostring(self.Name)
                if n == "CommF_" then
                    local a1 = tostring(args[1] or "")
                    if a1 == "StartQuest" or a1 == "AbandonQuest" then
                        safeAppend(string.format("[QUEST] %s | Args: %s, %s, %s\n", method, tostring(args[1]), tostring(args[2]), tostring(args[3])))
                    end
                end
                if string.find(n, "BonusMoments") then
                    safeAppend(string.format("[NPC] %s | %s | Args: %s, %s\n", n, method, tostring(args[1]), tostring(args[2])))
                end
            end)
        end
        return old(self, ...)
    end)
end)

local function getHRP()
    local c = game.Players.LocalPlayer.Character
    if c then return c:FindFirstChild("HumanoidRootPart") end
    return nil
end

local function describeModel(m)
    local hrp = m:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local pos = hrp.Position
    local dPrison = (pos - PRISON_CENTER).Magnitude
    local hum = m:FindFirstChildOfClass("Humanoid")
    local hp = hum and (tostring(math.floor(hum.Health)) .. "/" .. tostring(math.floor(hum.MaxHealth))) or "?"
    local attrs = {}
    pcall(function()
        for k,v in pairs(m:GetAttributes()) do
            table.insert(attrs, k.."="..tostring(v))
        end
    end)
    -- head tags (Magnetized etc)
    local tags = {}
    pcall(function()
        for _,d in pairs(m:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text ~= "" then
                table.insert(tags, d.Text)
            end
            if d:IsA("ParticleEmitter") or d:IsA("Highlight") or d:IsA("BillboardGui") then
                table.insert(tags, "["..d.ClassName..":"..d.Name.."]")
            end
        end
    end)
    return string.format("-- Enemy --\n[\"%s\"] = %s -- HP:%s distPrison:%d attrs:{%s} tags:{%s}\n",
        m.Name, fmtCF(hrp.CFrame), hp, math.floor(dPrison), table.concat(attrs, ","), table.concat(tags, "|"))
end

local function describeNPC(npc)
    local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head") or npc:IsA("BasePart") and npc
    local cf = nil
    local posStr = "?"
    if hrp and hrp:IsA("BasePart") then
        cf = hrp.CFrame
        posStr = fmtV3(hrp.Position) .. " distPrison:" .. math.floor((hrp.Position - PRISON_CENTER).Magnitude)
    elseif npc:IsA("Model") and npc.PrimaryPart then
        cf = npc.PrimaryPart.CFrame
        posStr = fmtV3(npc.PrimaryPart.Position)
    end
    local prompt = ""
    pcall(function()
        if npc:FindFirstChildOfClass("ProximityPrompt", true) then prompt = " +ProximityPrompt" end
        if npc:FindFirstChildOfClass("ClickDetector", true) then prompt = prompt .. " +ClickDetector" end
    end)
    if cf then
        return string.format("-- NPC --\n[\"%s\"] = %s -- %s%s\n", npc.Name, fmtCF(cf), posStr, prompt)
    else
        return string.format("-- NPC (no HRP) -- \"%s\" class=%s%s\n", npc.Name, npc.ClassName, prompt)
    end
end

-- One-time full dump in NewFirstSeaNPCs.txt format for easy diff
pcall(function()
    safeAppend("\n===== FULL DUMP (copy-paste format) =====\n-- NPCs --\n")
    local npcFolders = {"NPCs", "Npcs", "NPC", "Characters"}
    for _,fname in pairs(npcFolders) do
        local f = workspace:FindFirstChild(fname)
        if f then
            for _,n in pairs(f:GetChildren()) do
                local ok, txt = pcall(describeNPC, n)
                if ok and txt then safeAppend(txt) end
            end
        end
    end
    -- quest givers are often directly in Workspace/Map
    for _,n in pairs(workspace:GetChildren()) do
        if n:IsA("Model") and (string.find(n.Name, "Jail") or string.find(n.Name, "Keeper") or string.find(n.Name, "Head") or string.find(n.Name, "Prison") or n.Name == "Secrets Master") then
            local ok, txt = pcall(describeNPC, n)
            if ok and txt then safeAppend(txt) end
        end
    end
    safeAppend("\n-- Enemies --\n")
    local en = workspace:FindFirstChild("Enemies")
    if en then
        for _,m in pairs(en:GetChildren()) do
            local ok, txt = pcall(describeModel, m)
            if ok and txt then safeAppend(txt) end
        end
    end
    safeAppend("\n-- EnemySpawns (_WorldOrigin) --\n")
    pcall(function()
        local sp = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns")
        if sp then
            for _,s in pairs(sp:GetChildren()) do
                local pos = s:IsA("BasePart") and s.Position or (s.PrimaryPart and s.PrimaryPart.Position)
                if pos then
                    safeAppend(string.format("[Spawn:\"%s\"] = %s distPrison:%d\n", s.Name, fmtV3(pos), math.floor((pos - PRISON_CENTER).Magnitude)))
                else
                    safeAppend("Spawn: " .. s.Name .. " (no pos)\n")
                end
            end
        else
            safeAppend("No _WorldOrigin.EnemySpawns found\n")
        end
    end)
    safeAppend("===== END FULL DUMP =====\n\n")
end)

safeAppend("Logger running. Now portal to Prison and roam. Logging every " .. tostring(INTERVAL) .. "s within " .. tostring(RADIUS) .. " studs.\nTalk to Jail Keeper + Head Jailer and accept PrisonerQuest to capture quest IDs.\n\n")

local seen = {}
task.spawn(function()
    while true do
        task.wait(INTERVAL)
        pcall(function()
            local hrp = getHRP()
            if not hrp then
                safeAppend("[WARN] No character/HRP\n")
                return
            end
            local pp = hrp.Position
            safeAppend(string.format("[YOU] %s distPrison:%d\n", fmtV3(pp), math.floor((pp - PRISON_CENTER).Magnitude)))
            -- nearby enemies
            local en = workspace:FindFirstChild("Enemies")
            if en then
                for _,m in pairs(en:GetChildren()) do
                    local r = m:FindFirstChild("HumanoidRootPart")
                    if r then
                        local dYou = (r.Position - pp).Magnitude
                        local dPrison = (r.Position - PRISON_CENTER).Magnitude
                        if dYou < RADIUS or dPrison < RADIUS then
                            local key = m.Name .. "_" .. tostring(math.floor(r.Position.X)) .. "_" .. tostring(math.floor(r.Position.Z))
                            local hum = m:FindFirstChildOfClass("Humanoid")
                            local hp = hum and math.floor(hum.Health) or -1
                            safeAppend(string.format("  [MOB] %s HP:%s you:%d prison:%d pos:%s\n", m.Name, tostring(hp), math.floor(dYou), math.floor(dPrison), fmtV3(r.Position)))
                            if not seen[key] then
                                seen[key] = true
                                local ok, txt = pcall(describeModel, m)
                                if ok and txt then safeAppend("    NEW: " .. txt) end
                            end
                        end
                    end
                end
            end
            -- nearby NPCs (quest givers)
            for _,fname in pairs({"NPCs","Npcs","NPC","Characters"}) do
                local f = workspace:FindFirstChild(fname)
                if f then
                    for _,n in pairs(f:GetChildren()) do
                        pcall(function()
                            local r = n:FindFirstChild("HumanoidRootPart") or n:FindFirstChild("Head")
                            if r and r:IsA("BasePart") then
                                local dYou = (r.Position - pp).Magnitude
                                if dYou < 150 then
                                    safeAppend(string.format("  [NEAR-NPC] %s pos:%s you:%d\n", n.Name, fmtV3(r.Position), math.floor(dYou)))
                                end
                            end
                        end)
                    end
                end
            end
        end)
    end
end)

safeAppend("Hooks attached. Go to Prison now.\n")
