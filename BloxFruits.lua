if not game:IsLoaded() then
	game.Loaded:Wait()
end 
local function Start(Name, Async)
	local function Execute()
		local StartTime = tick()

		vu102[Name](vu102)

		print(Name, tick() - StartTime)
	end

	if Async then
		task.spawn(Execute)
	else
		Execute()
	end
end
getgenv().Settings = getgenv().Settings or {
	JoinTeam = "Pirates",
	Translator = true
}
local _ENV = (getgenv or getrenv or getfenv)()
local Connections = {}
Settings = Settings or {}
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local vu2 = game:GetService("VirtualInputManager")
local vu3 = game:GetService("LocalizationService")
local vu4 = game:GetService("CollectionService")
local vu5 = game:GetService("ReplicatedStorage")
local vu6 = game:GetService("VirtualUser")
local vu7 = game:GetService("HttpService")
local v8 = game:GetService("RunService")
local vu9 = game:GetService("Lighting")
local vu10 = game:GetService("Players")
local vu11 = game:GetService("CoreGui")
local vu12 = workspace.CurrentCamera
local vu13 = v8.Stepped
local vu14 = vu10.LocalPlayer
local vu15 = vu14:WaitForChild("Data")
vu15:WaitForChild("LastSpawnPoint")
vu15:WaitForChild("SpawnPoint")
local vu16 = vu15:WaitForChild("Fragments")
local vu17 = vu15:WaitForChild("Subclass")
local vu18 = vu15:WaitForChild("FruitCap")
local vu19 = vu15:WaitForChild("Level")
local vu20 = vu15:WaitForChild("Beli")
local vu21 = workspace:WaitForChild("Map")
local vu22 = workspace:WaitForChild("NPCs")
local vu23 = workspace:WaitForChild("Boats")
local vu24 = workspace:WaitForChild("SeaBeasts")
local vu25 = workspace:WaitForChild("Enemies")
local vu26 = workspace:WaitForChild("Characters")
local vu27 = workspace:WaitForChild("_WorldOrigin")
local vu28 = vu27:WaitForChild("Locations")
vu27:WaitForChild("PlayerSpawns")
local vu29 = vu5:WaitForChild("Remotes")
local vu30 = vu5:WaitForChild("Modules")
local vu31 = vu30:WaitForChild("Net")
local vu82 = nil
local vu464 = function() return false end
local Workspace = game:GetService("Workspace")
local FishReplicated = RS:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local Net = RS:WaitForChild("Modules"):WaitForChild("Net")
local CraftRemote = Net:WaitForChild("RF/Craft")
local JobsRemote = Net:WaitForChild("RF/JobsRemoteFunction")
local ToolAbilities = Net:WaitForChild("RF/JobToolAbilities")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui");
local Player = Players.LocalPlayer;
local Plr = Players.LocalPlayer
local plr = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Settings = _ENV.rz_settings or {
SmoothMode = false
}
local Settings = getgenv().Settings

local CountryFile = "PlayerCountry.txt"
local TranslatorURL = "https://raw.githubusercontent.com/PlockScripts/BloxFruits/refs/heads/main/Translator/"

_G.RedzTranslator = nil

local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local Plr = Players.LocalPlayer

local function Request(url)
	if syn and syn.request then
		return syn.request({
			Url = url,
			Method = "GET"
		}).Body
	elseif http_request then
		return http_request({
			Url = url,
			Method = "GET"
		}).Body
	elseif request then
		return request({
			Url = url,
			Method = "GET"
		}).Body
	else
		return game:HttpGet(url)
	end
end

local function GetCountry()
	local Country = "US"

	if isfile and isfile(CountryFile) then
		Country = readfile(CountryFile)
	else
		pcall(function()
			Country = LocalizationService:GetCountryRegionForPlayerAsync(Plr)
		end)

		if not Country or Country == "" then
			Country = "US"
		end

		if writefile then
			writefile(CountryFile, Country)
		end
	end

	if Country == "US" then
		Country = "BR"
	end

	return Country
end

if Settings.Translator then
	local Country = GetCountry()

	local Map = {
		BR = "Portuguese.json",
		PT = "Portuguese.json",
		TH = "Thai.json",
		VN = "Vietnamese.json"
	}

	local File = Map[Country]

	if File then
		local success, data = pcall(function()
			return HttpService:JSONDecode(Request(TranslatorURL .. File))
		end)

		if success and type(data) == "table" then
			_G.RedzTranslator = data
		end
	end
end

local function Translate(text)
	if _G.RedzTranslator and text then
		local v = _G.RedzTranslator[text]

		if v then
			if type(v) == "table" then
				return v[1]
			else
				return v
			end
		end
	end

	return text
end

local function TranslateDescription(name, desc)
	if _G.RedzTranslator and name then
		local v = _G.RedzTranslator[name]

		if v and type(v) == "table" then
			if v[2] then
				return v[2]
			end
		end
	end

	return desc
end

local function HookTranslator(Tab)
	if not Tab then
		return
	end

	local function FixConfig(config)
		if not config or type(config) ~= "table" then
			return config
		end

		local OriginalName = config.Name or config.Title or config[1]

		if config.Name then
			config.Name = Translate(config.Name)
		end

		if config.Title then
			config.Title = Translate(config.Title)
		end

		if config.Desc then
			config.Desc = TranslateDescription(OriginalName, config.Desc)
		end

		if config.Description then
			config.Description = TranslateDescription(OriginalName, config.Description)
		end

		if not config.Description and OriginalName then
			local translatedDescription = TranslateDescription(OriginalName)

			if translatedDescription then
				config.Description = translatedDescription
			end
		end

		if config[1] and type(config[1]) == "string" then
			config[1] = Translate(config[1])
		end

		return config
	end

	local oldAddToggle = Tab.AddToggle
	if oldAddToggle then
		Tab.AddToggle = function(self, config)
			return oldAddToggle(self, FixConfig(config))
		end
	end

	local oldAddButton = Tab.AddButton
	if oldAddButton then
		Tab.AddButton = function(self, config)
			return oldAddButton(self, FixConfig(config))
		end
	end

	local oldAddDropdown = Tab.AddDropdown
	if oldAddDropdown then
		Tab.AddDropdown = function(self, config)
			return oldAddDropdown(self, FixConfig(config))
		end
	end

	local oldAddParagraph = Tab.AddParagraph
	if oldAddParagraph then
		Tab.AddParagraph = function(self, config)
			return oldAddParagraph(self, FixConfig(config))
		end
	end

	local oldAddSection = Tab.AddSection
	if oldAddSection then
		Tab.AddSection = function(self, config)
			if type(config) == "string" then
				config = Translate(config)
			elseif type(config) == "table" and config[1] then
				config[1] = Translate(config[1])
			end

			return oldAddSection(self, config)
		end
	end

	local oldAddSlider = Tab.AddSlider
	if oldAddSlider then
		Tab.AddSlider = function(self, config)
			return oldAddSlider(self, FixConfig(config))
		end
	end
end

local function JoinTeam()
    local targetTeam = Settings.JoinTeam == "Pirates" and "Pirates" or "Marines"

    if not Plr.Team or (Plr.Team.Name ~= "Marines" and Plr.Team.Name ~= "Pirates") then
        pcall(function()
            ReplicatedStorage
                :WaitForChild("Remotes")
                :WaitForChild("CommF_")
                :InvokeServer("SetTeam", targetTeam)
        end)
    end
end

JoinTeam()

local function DistanceFromMyCharacter(Position)
local Character = Player.Character

if not Character or not Character.PrimaryPart then  
	return math.huge  
end  
  
local TargetPosition  
  
if typeof(Position) == "Instance" then  
	if Position:IsA("BasePart") then  
		TargetPosition = Position.Position  
	elseif Position:IsA("Model") and Position.PrimaryPart then  
		TargetPosition = Position.PrimaryPart.Position  
	else  
		return math.huge  
	end  
elseif typeof(Position) == "Vector3" then  
	TargetPosition = Position  
else  
	return math.huge  
end  
  
return (Character.PrimaryPart.Position - TargetPosition).Magnitude
end
     local Managers = {} do
     Managers.EspManager = (function()
     local EspManager = {}
          EspManager.__index = EspManager
          EspManager.__newindex = function(self, index, value)
if index == "Enabled" then
task.spawn(self.ToggleEsp, self, value)
else
rawset(self, index, value)
end
end

local CoreGuiEspFolder = Instance.new("Folder", CoreGui) do  
		CoreGuiEspFolder.Name = "redzHub-EspFolder"  
		  
		local _EspFolder = CoreGui:FindFirstChild(CoreGuiEspFolder.Name)  
		  
		if _EspFolder and _EspFolder ~= CoreGuiEspFolder then  
			_EspFolder:Destroy()  
		end  
	end  
	  
	local EspTemplate = Instance.new("BoxHandleAdornment") do  
		local BoxHandleAdornment = EspTemplate  
		BoxHandleAdornment.Size = Vector3.new(1, 0, 1, 0)  
		BoxHandleAdornment.AlwaysOnTop = true  
		BoxHandleAdornment.ZIndex = 10  
		BoxHandleAdornment.Transparency = 0  
		  
		local BillboardGui = Instance.new("BillboardGui", BoxHandleAdornment)  
		BillboardGui.Size = UDim2.new(0, 100, 0, 150)  
		BillboardGui.StudsOffset = Vector3.new(0, 2, 0)  
		BillboardGui.AlwaysOnTop = true  
		  
		local TextLabel = Instance.new("TextLabel", BillboardGui)  
		TextLabel.BackgroundTransparency = 1  
		TextLabel.Position = UDim2.new(0, 0, 0, -50)  
		TextLabel.Size = UDim2.new(0, 100, 0, 100)  
		TextLabel.TextSize = 10  
		TextLabel.TextStrokeTransparency = 0  
		TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom  
		TextLabel.Text = "..."  
		TextLabel.ZIndex = 15  
		TextLabel.RichText = true  
	end  
	  
	local DefaultEspColor = Color3.fromRGB(255, 255, 255)  
	local HumHealth = "%s<font color='rgb(160, 160, 160)'> [ %im ]</font>\n<font color='rgb(25, 240, 25)'>[%i/%i]</font>"  
	local CreatedEsps = {}  
    EspManager.CreatedEsps = CreatedEsps  
	local function GetBasePart(Instance)  
		if Instance:IsA("BasePart") then  
			return Instance  
		elseif Instance:IsA("Model") then  
			return Instance.PrimaryPart or Instance:GetPivot()  
		elseif Instance.Parent:IsA("Model") then  
			return Instance.Parent.PrimaryPart or Instance.Parent:GetPivot()  
		end  
	end  
	  
	function EspManager:SetCustomEspDisplay(Action)  
		self.CustomEspDisplay = Action  
		return self  
	end  
	  
	function EspManager:SetObjects(Objects)  
		self.GetObjectsAction = Objects  
		return self  
	end  
	  
	function EspManager:GetInstance(Action)  
		self.OnlyOneInstanceAction = Action  
		return self  
	end  
	  
	function EspManager:SetInstanceName(Instance, Name)  
		self.EspsNames[Instance] = Name  
		return self  
	end  
	  
	function EspManager:SetAllInstancesName(Name)  
		self.CustomInstanceName = Name  
		return self  
	end  
	  
	function EspManager:WaitChildsAdded()  
		self._WaitChildsAdded = true  
		return self  
	end  
	  
	function EspManager:SetEspColor(Action)  
		self.EspColor = Action  
		return self  
	end  
	  
	function EspManager:SetAlwaysValidate()  
		self.AlwaysValidateInstance = true  
		return self  
	end  
	  
	function EspManager:Validator(Action)  
		self.ValidateInstance = Action  
		return self  
	end  
	  
	function EspManager:ChangeEspSize(Size)  
		self.EspSize = Size  
		  
		for i = 1, #CreatedEsps do  
			for _, Esp in pairs(CreatedEsps[i].EspObjects) do  
				Esp.BoxHandleAdornment.BillboardGui.TextLabel.TextSize = Size  
			end  
		end  
		  
		return self  
	end  
	  
	function EspManager:StartRunningEsp(Esp)  
		local Instance = Esp.Instance  
		local BoxHandleAdornment = Esp.BoxHandleAdornment  
		local TextLabel = BoxHandleAdornment.BillboardGui.TextLabel  
		local Folder = self.EspFolder  
		local IsModel = Instance:IsA("Model")  
		local CachedBasePart = nil  
		  
		while task.wait(Settings.SmoothMode and 0.25 or 0) do  
			if not BoxHandleAdornment or not BoxHandleAdornment.Parent then  
				return self:Clear(Esp)  
			elseif self.AlwaysValidateInstance and not self.ValidateInstance(Instance) then  
				return self:Clear(Esp)  
			elseif not Instance:IsDescendantOf(workspace) and not Instance:IsDescendantOf(ReplicatedStorage) then  
				return self:Clear(Esp)  
			end  
			  
			CachedBasePart = CachedBasePart or GetBasePart(Instance)  
			  
			if not CachedBasePart then  
				return self:Clear(Esp)  
			end  
			  
			local Distance = math.floor((DistanceFromMyCharacter(CachedBasePart)) / 5)  
			local Humanoid = IsModel and Instance:FindFirstChildOfClass("Humanoid")  
			  
			if Humanoid then  
				TextLabel.Text = HumHealth:format(Instance.Name, Distance, math.floor(Humanoid.Health), math.floor(Humanoid.MaxHealth))  
			elseif self.CustomEspDisplay then  
				TextLabel.Text = self.CustomEspDisplay(Instance, Distance)  
			else  
				local Name = self.CustomInstanceName or self.EspsNames[Instance] or Instance.Name  
				TextLabel.Text = ("%s < %i >"):format(Name, Distance)  
			end  
		end  
	end  
	  
	function EspManager:Create(Instance)  
		if self.EspObjects[Instance] then return end  
		  
		local Esp = {  
			Instance = Instance,  
			BoxHandleAdornment = nil  
		}  
		  
		local BoxHandleAdornment = EspTemplate:Clone()  
		local BillboardGui = BoxHandleAdornment.BillboardGui  
		local TextLabel = BillboardGui.TextLabel  
		  
		BillboardGui.Adornee = (Instance:IsA("BasePart") or Instance:IsA("Model")) and Instance or Instance.Parent  
		TextLabel.TextColor3 = type(self.EspColor) == "function" and self.EspColor(Instance) or self.EspColor or DefaultEspColor  
		TextLabel.Text = self.CustomInstanceName or "..."  
		TextLabel.TextSize = self.EspSize or TextLabel.TextSize  
		BoxHandleAdornment.Parent = self.EspFolder  
		  
		self.EspObjects[Instance] = Esp  
		Esp.BoxHandleAdornment = BoxHandleAdornment  
		  
		task.spawn(self.StartRunningEsp, self, Esp)  
		  
		return Esp  
	end  
	  
	function EspManager:Clear(Esp)  
		if Esp then  
			self.EspObjects[Esp.Instance] = nil  
			if Esp.BoxHandleAdornment then Esp.BoxHandleAdornment:Destroy() end  
		else  
			table.clear(self.EspObjects)  
			self.EspFolder:ClearAllChildren()  
		end  
	end  
	  
	function EspManager:ToggleEsp(Value)  
		local Environment = "redzHub_Esp_" .. self.SpecialTag  
		_ENV[Environment] = Value  
  
		if not Value then  
			return self:Clear()  
		end  
  
		while _ENV[Environment] do  
			local ObjectsAction = self.GetObjectsAction  
	  
			if self.OnlyOneInstanceAction then  
				local Instance = self.OnlyOneInstanceAction()  
		  
				if Instance then  
					self:Create(Instance)  
				end  
		  
			elseif ObjectsAction then  
				local Instances  
		  
				if typeof(ObjectsAction) == "function" then
					Instances = ObjectsAction()
				elseif typeof(ObjectsAction) == "Instance" then
					Instances = ObjectsAction:GetChildren()
				else
					Instances = ObjectsAction
					end

				if type(Instances) ~= "table" then
					Instances = {}
				end
		  
				local Validate = self.ValidateInstance  
				local CreatedEsps = self.EspObjects  
				local CreatedNew = false  
		  
				for i = 1, #Instances do  
					local Instance = Instances[i]  
			  
					if not CreatedEsps[Instance] and (not Validate or Validate(Instance)) then  
						CreatedNew = true  
						self:Create(Instance)  
					end  
				end  
		  
				if not CreatedNew and self._WaitChildsAdded and typeof(ObjectsAction) == "Instance" then  
					ObjectsAction.ChildAdded:Wait()  
				end  
			end  
	  
			task.wait(0.25)  
		end  
	end  
	  
	function EspManager.new(Tag)  
		local EspFolder = Instance.new("Folder", CoreGuiEspFolder)  
		EspFolder.Name = Tag  
		  
		local self = setmetatable({  
			SpecialTag = Tag,  
			EspObjects = {},  
			EspsNames = {},  
			EspFolder = EspFolder  
		}, EspManager)  
		  
		table.insert(CreatedEsps, self)  
		  
		return self  
	end  
	  
	return EspManager  
end)()
end
local PlayerESP = Managers.EspManager.new("Players")

PlayerESP:SetObjects(function()
local PlayersTable = {}

for _,v in pairs(game:GetService("Players"):GetPlayers()) do  
	if v ~= Player and v.Character then  
		table.insert(PlayersTable, v.Character)  
	end  
end  

return PlayersTable

end)

PlayerESP:Validator(function(Character)
return Character
and Character:FindFirstChild("HumanoidRootPart")
and Character:FindFirstChildOfClass("Humanoid")
end)
local FruitESP = Managers.EspManager.new("Fruits")

local CachedFruits = {}

local function IsHeld(tool)
	local parent = tool.Parent
	return parent and parent:FindFirstChildOfClass("Humanoid") ~= nil
end

local function GetHandle(tool)
	local handle = tool:FindFirstChild("Handle")
	if handle and handle:IsA("BasePart") then
		return handle
	end

	if tool:IsA("Model") then
		return tool.PrimaryPart or tool:FindFirstChildWhichIsA("BasePart")
	end

	return nil
end

local function UpdateFruits()
	table.clear(CachedFruits)

	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Tool") and v.Name:find("Fruit") then
			if not Players:GetPlayerFromCharacter(v.Parent) and not IsHeld(v) then
				local handle = GetHandle(v)
				if handle then
					table.insert(CachedFruits, v)
				end
			end
		end
	end
end

UpdateFruits()

workspace.ChildAdded:Connect(function(v)
	if v:IsA("Tool") and v.Name:find("Fruit") then
		task.wait(0.1)
		UpdateFruits()
	end
end)

workspace.ChildRemoved:Connect(function(v)
	if v:IsA("Tool") and v.Name:find("Fruit") then
		UpdateFruits()
	end
end)

FruitESP:SetObjects(function()
	return CachedFruits
end)

FruitESP:Validator(function(Fruit)
	if not Fruit or not Fruit.Parent then return false end
	if Players:GetPlayerFromCharacter(Fruit.Parent) then return false end
	if IsHeld(Fruit) then return false end

	return GetHandle(Fruit) ~= nil
end)

FruitESP:SetEspColor(Color3.fromRGB(200, 0, 0))

FruitESP:SetCustomEspDisplay(function(Fruit, Distance)
	local handle = GetHandle(Fruit)
	if not handle then return end

	local char = Players.LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if not hrp then
		return ("Fruit [ %s ] < ?m >"):format(Fruit.Name:gsub(" Fruit", ""))
	end

	local dist = (hrp.Position - handle.Position).Magnitude
	dist = math.floor(dist / 5)

	return ("Fruit [ %s ] < %im >"):format(Fruit.Name:gsub(" Fruit", ""), dist)
end)

local BerryESP = Managers.EspManager.new("Berries")

BerryESP:SetObjects(function()
	return CollectionService:GetTagged("BerryBush")
end)

BerryESP:SetAlwaysValidate()

BerryESP:Validator(function(Bush)
	if not Bush or not Bush.Parent then
		return false
	end

	local BerryName

	for _, Value in pairs(Bush:GetAttributes()) do
		if typeof(Value) == "string" and Value ~= "" then
			BerryName = Value
			break
		end
	end

	if not BerryName then
		return false
	end

	local Parent = Bush.Parent

	if not Parent then
		return false
	end

	for _, Child in ipairs(Parent:GetChildren()) do
		if Child:IsA("BasePart") then
			return true
		end
	end

	return false
end)

BerryESP:SetEspColor(function()
	return Color3.fromRGB(255,255,0)
end)

BerryESP:SetCustomEspDisplay(function(Bush, Distance)
	local BerryName = "Unknown"

	for _, Value in pairs(Bush:GetAttributes()) do
		if typeof(Value) == "string" and Value ~= "" then
			BerryName = Value
			break
		end
	end

	return string.format(
		"%s < %im >",
		BerryName,
		math.floor(Distance)
	)
end)

local ChestESP = Managers.EspManager.new("ChestESP")

ChestESP:SetObjects(function()
    return game:GetService("CollectionService"):GetTagged("_ChestTagged")
end)

ChestESP:Validator(function(Chest)
    return Chest and Chest.Parent and not Chest:GetAttribute("IsDisabled")
end)

ChestESP:SetEspColor(function(Chest)
    local Name = string.lower(Chest.Name)

    if Name:find("chest3") then
        return Color3.fromRGB(0, 255, 255)
    elseif Name:find("chest2") then
        return Color3.fromRGB(255, 255, 0)
    else
        return Color3.fromRGB(150, 150, 150)
    end
end)

ChestESP:SetCustomEspDisplay(function(Chest, Distance)
    local Name = Chest.Name

    if Name:find("Chest3") then
        Name = "Chest 3"
    elseif Name:find("Chest2") then
        Name = "Chest 2"
    else
        Name = "Chest 1"
    end

    return string.format("%s\n%d M", Name, Distance)
end)

local IslandsESP = Managers.EspManager.new("IslandsESP")

IslandsESP:SetObjects(function()
    return workspace._WorldOrigin.Locations:GetChildren()
end)

IslandsESP:SetEspColor(function()
    return Color3.fromRGB(0, 255, 255)
end)

IslandsESP:SetCustomEspDisplay(function(Island, Distance)
    return string.format("%s < %d >", Island.Name, Distance)
end)

local MyBoatESP = Managers.EspManager.new("MyBoatESP")

MyBoatESP:GetInstance(function()
    local Character = vu14.Character

    if Character and Character:FindFirstChild("Humanoid") then
        local SeatPart = Character.Humanoid.SeatPart

        if SeatPart and SeatPart.Name == "VehicleSeat" then
            return SeatPart.Parent
        end
    end

    for _, Boat in ipairs(vu23:GetChildren()) do
        local Owner = Boat:FindFirstChild("Owner")

        if Owner and Owner.Value and Owner.Value.Name == vu14.Name then
            return Boat
        end
    end
end)

MyBoatESP:Validator(function(Boat)
    return Boat
        and Boat.Parent
        and Boat:IsDescendantOf(vu23)
end)

MyBoatESP:SetEspColor(function()
    return Color3.fromRGB(160,160,0)
end)

MyBoatESP:SetCustomEspDisplay(function(Boat, Distance)
    local Health = Boat:FindFirstChild("Health")

    if not Health then
        for _, v in ipairs(Boat:GetDescendants()) do
            if v.Name == "Health" then
                Health = v
                break
            end
        end
    end

    if Health then
        return string.format(
            "<font color='rgb(160,160,0)'>My Boat [ %im ]</font>\n<font color='rgb(25,240,25)'>[%i/%i]</font>",
            Distance,
            math.floor(Health.Value),
            math.floor(Health:GetAttribute('MaxHealth') or Health.Value)
        )
    end

    return string.format(
        "<font color='rgb(160,160,0)'>My Boat [ %im ]</font>",
        Distance
    )
end)

local LSDESP = Managers.EspManager.new("LegendarySwordDealerESP")

LSDESP:SetObjects(function()
    return workspace.NPCs:GetChildren()
end)

LSDESP:Validator(function(NPC)
    return NPC
        and NPC.Parent
        and NPC.Name == "Legendary Sword Dealer"
end)

LSDESP:SetEspColor(function()
    return Color3.fromRGB(80, 245, 245)
end)

LSDESP:SetCustomEspDisplay(function(NPC, Distance)
    return string.format(
        "%s\n%d M",
        NPC.Name,
        Distance
    )
end)

local FlowerESPManager = Managers.EspManager.new("FlowerESP")

FlowerESPManager:SetObjects(function()
    local Flowers = {}

    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Flower1" or v.Name == "Flower2" then
            table.insert(Flowers, v)
        end
    end

    return Flowers
end)

FlowerESPManager:SetEspColor(function(Flower)
    if Flower.Name == "Flower1" then
        return Color3.fromRGB(0, 0, 255)
    elseif Flower.Name == "Flower2" then
        return Color3.fromRGB(255, 0, 0)
    end

    return Color3.fromRGB(255, 255, 255)
end)

FlowerESPManager:SetCustomEspDisplay(function(Flower, Distance)
    local Name = Flower.Name

    if Name == "Flower1" then
        Name = "Blue Flower"
    elseif Name == "Flower2" then
        Name = "Red Flower"
    end

    return string.format(
        "%s\n%d Distance",
        Name,
        Distance
    )
end)

FlowerESPManager:SetAlwaysValidate()

FlowerESPManager:Validator(function(Flower)
    return Flower
        and Flower.Parent
        and (Flower.Name == "Flower1" or Flower.Name == "Flower2")
end)


if not _G.ActiveNotifies then
    _G.ActiveNotifies = {}
end

local MainNotifyGui = CoreGui:FindFirstChild("RedzNotifications")
if not MainNotifyGui then
    MainNotifyGui = Instance.new("ScreenGui")
    MainNotifyGui.Name = "RedzNotifications"
    MainNotifyGui.ResetOnSpawn = false
    MainNotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global 
    MainNotifyGui.DisplayOrder = 9999 
    MainNotifyGui.Parent = CoreGui
end

local function UpdatePositions()
    for i, v in ipairs(_G.ActiveNotifies) do
        v.Position = UDim2.new(1, -270, 1, -90 - ((i - 1) * 80))
    end
end

function RedzNotify(Title, Text, Image, Time)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,260,0,70)
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = MainNotifyGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0,40,0,40)
    icon.Position = UDim2.new(0,10,0.5,-20)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. Image
    icon.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-100,0,20)
    title.Position = UDim2.new(0,60,0,10)
    title.BackgroundTransparency = 1
    title.Text = Title
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1,-100,0,0)
    desc.Position = UDim2.new(0,60,0,28)
    desc.BackgroundTransparency = 1
    desc.Text = Text
    desc.TextColor3 = Color3.fromRGB(200,200,200)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 13
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.AutomaticSize = Enum.AutomaticSize.Y
    desc.Parent = frame

    local timer = Instance.new("TextLabel")
    timer.Size = UDim2.new(0,40,0,20)
    timer.Position = UDim2.new(1,-45,0,8)
    timer.BackgroundTransparency = 1
    timer.TextColor3 = Color3.fromRGB(150,150,150)
    timer.Font = Enum.Font.Gotham
    timer.TextSize = 12
    timer.TextXAlignment = Enum.TextXAlignment.Right
    timer.Parent = frame

    task.wait() 
    frame.Size = UDim2.new(0,260,0,math.max(70, desc.AbsoluteSize.Y + 40))

    table.insert(_G.ActiveNotifies, 1, frame)
    UpdatePositions()

    task.spawn(function()
        local t = Time
        while t > 0 do
            if not frame or not frame.Parent then break end
            timer.Text = string.format("%.1f", t)
            task.wait(0.1)
            t = t - 0.1
        end

        for i, v in ipairs(_G.ActiveNotifies) do
            if v == frame then
                table.remove(_G.ActiveNotifies, i)
                break
            end
        end

        frame:Destroy()
        UpdatePositions()
    end)
end

local Loader = {
    Owner = "https://raw.githubusercontent.com/PlockScripts/"
}

Loader.Repository = Loader.Owner .. "BloxFruits/main/"

local fetcher = {}

local function getExecutor()
    return identifyexecutor and identifyexecutor() or "Unknown"
end

local function throwError(msg)
    local m = Instance.new("Message", workspace)
    m.Text = msg:gsub(Loader.Owner, "")
    return error(msg, 2)
end

function __httpget(url)
    for k, v in pairs(Loader) do
        url = url:gsub("{" .. k .. "}", v)
    end

    local ok, res = pcall(game.HttpGet, game, url)

    if ok then
        return res, url
    else
        return throwError(("[HTTP] [%s] Failed: %s\n{{ %s }}"):format(getExecutor(), url, res))
    end
end

function fetcher.get(url)
    local src = __httpget(url)
    return src
end

function fetcher.load(Url, concat)
    local raw = fetcher.get(Url) .. (concat or "")
    local runFunction, errorText = loadstring(raw)

    if type(runFunction) ~= "function" then
        return throwError(("[LOAD] [%s] Syntax error: %s\n{{ %s }}"):format(getExecutor(), Url, errorText))
    end

    return runFunction
end
local executor = identifyexecutor and identifyexecutor() or "Unknown"

local RawBlackList = {
    XENO = true,
    Velocity = true,
    Solara = true
}

local function Normalize(str)
    return string.lower(str or "")
end

local execName = Normalize(executor)
local BlackListExecutors = false

for name, state in pairs(RawBlackList) do
    if state and string.find(execName, Normalize(name)) then
        BlackListExecutors = true
        break
    end
end

if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    World3 = true
end

QuestB = function()
		if World1 then
			if _G.FindBoss == "The Gorilla King" then
				bMon = "The Gorilla King";
				Qname = "JungleQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102);
				PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, .707079291, 0, 1, 0, -0.707079291, 0, -0.707134247);
			elseif _G.FindBoss == "Chef" then
				bMon = "Chef";
				Qname = "BuggyQuest1";
				Qdata = 3;
				PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188);
				PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344);
			elseif _G.FindBoss == "The Saw" then
				bMon = "The Saw";
				PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906);
			elseif _G.FindBoss == "Yeti" then
				bMon = "Yeti";
				Qname = "SnowQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156);
				PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172);
			elseif _G.FindBoss == "Mob Leader" then
				bMon = "Mob Leader";
				PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813);
			elseif _G.FindBoss == "Vice Admiral" then
				bMon = "Vice Admiral";
				Qname = "MarineQuest2";
				Qdata = 2;
				PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625);
				PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375);
			elseif _G.FindBoss == "Saber Expert" then
				bMon = "Saber Expert";
				PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564);
			elseif _G.FindBoss == "Warden" then
				bMon = "Warden";
				Qname = "ImpelQuest";
				Qdata = 1;
				PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, .220546961, -4.49946401e-06, .975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, .220546961);
				PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, .681965172, 0, 1, 0, -0.681965172, 0, -0.731384635);
			elseif _G.FindBoss == "Chief Warden" then
				bMon = "Chief Warden";
				Qname = "ImpelQuest";
				Qdata = 2;
				PosB = CFrame.new(5206.92578, .997753382, 814.976746, .342041343, -0.00062915677, .939684749, .00191645394, .999998152, -2.80422337e-05, -0.939682961, .00181045406, .342041939);
				PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, .681965172, 0, 1, 0, -0.681965172, 0, -0.731384635);
			elseif _G.FindBoss == "Swan" then
				bMon = "Swan";
				Qname = "ImpelQuest";
				Qdata = 3;
				PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, .951042235, 0, 1, 0, -0.951042235, 0, -0.309060812);
				PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, .681965172, 0, 1, 0, -0.681965172, 0, -0.731384635);
			elseif _G.FindBoss == "Magma Admiral" then
				bMon = "Magma Admiral";
				Qname = "MagmaQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875);
				PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875);
			elseif _G.FindBoss == "Fishman Lord" then
				bMon = "Fishman Lord";
				Qname = "FishmanQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
				PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984);
			elseif _G.FindBoss == "Wysper" then
				bMon = "Wysper";
				Qname = "SkyExp1Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094);
				PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531);
			elseif _G.FindBoss == "Thunder God" then
				bMon = "Thunder God";
				Qname = "SkyExp2Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125);
				PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188);
			elseif _G.FindBoss == "Cyborg" then
				bMon = "Cyborg";
				Qname = "FountainQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875);
				PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813);
			elseif _G.FindBoss == "Ice Admiral" then
				bMon = "Ice Admiral";
				Qdata = nil;
				PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, .81913656, 0, -0.573599219);
				PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, .81913656, 0, -0.573599219);
			elseif _G.FindBoss == "Greybeard" then
				bMon = "Greybeard";
				Qdata = nil;
				PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188);
				PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188);
			end;
		end;
		if World2 then
			if _G.FindBoss == "Diamond" then
				bMon = "Diamond";
				Qname = "Area1Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375);
				PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407);
			elseif _G.FindBoss == "Jeremy" then
				bMon = "Jeremy";
				Qname = "Area2Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063);
				PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109);
			elseif _G.FindBoss == "Fajita" then
				bMon = "Fajita";
				Qname = "MarineQuest3";
				Qdata = 3;
				PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031);
				PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625);
			elseif _G.FindBoss == "Don Swan" then
				bMon = "Don Swan";
				PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875);
			elseif _G.FindBoss == "Smoke Admiral" then
				bMon = "Smoke Admiral";
				Qname = "IceSideQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813);
				PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875);
			elseif _G.FindBoss == "Awakened Ice Admiral" then
				bMon = "Awakened Ice Admiral";
				Qname = "FrostQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813);
				PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125);
			elseif _G.FindBoss == "Tide Keeper" then
				bMon = "Tide Keeper";
				Qname = "ForgottenQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625);
				PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188);
			elseif _G.FindBoss == "Darkbeard" then
				bMon = "Darkbeard";
				Qdata = nil;
				PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531);
				PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531);
			elseif _G.FindBoss == "Cursed Captaim" then
				bMon = "Cursed Captain";
				Qdata = nil;
				PosQBoss = CFrame.new(916.928589, 181.092773, 33422);
				PosB = CFrame.new(916.928589, 181.092773, 33422);
			elseif _G.FindBoss == "Order" then
				bMon = "Order";
				Qdata = nil;
				PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875);
				PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875);
			end;
		end;
		if World3 then
			if _G.FindBoss == "Stone" then
				bMon = "Stone";
				Qname = "PiratePortQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625);
				PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438);
			elseif _G.FindBoss == "Hydra Leader" then
				bMon = "Hydra Leader";
				Qname = "AmazonQuest2";
				Qdata = 3;
				PosQBoss = CFrame.new(5821.8979492188, 1019.0950927734, -73.719230651855);
				PosB = CFrame.new(5821.8979492188, 1019.0950927734, -73.719230651855);
			elseif _G.FindBoss == "Kilo Admiral" then
				bMon = "Kilo Admiral";
				Qname = "MarineTreeIsland";
				Qdata = 3;
				PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938);
				PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125);
			elseif _G.FindBoss == "Captain Elephant" then
				bMon = "Captain Elephant";
				Qname = "DeepForestIsland";
				Qdata = 3;
				PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875);
				PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125);
			elseif _G.FindBoss == "Beautiful Pirate" then
				bMon = "Beautiful Pirate";
				Qname = "DeepForestIsland2";
				Qdata = 3;
				PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375);
				PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285);
			elseif _G.FindBoss == "Cake Queen" then
				bMon = "Cake Queen";
				Qname = "IceCreamIslandQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, .642767608, 0, 1, 0, -0.642767608, 0, -0.766061664);
				PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, .00149294338, .41757378, .00837114919, .999857843, .0146408929, -0.417492568, .0167988986, -0.90852499);
			elseif _G.FindBoss == "Longma" then
				bMon = "Longma";
				Qdata = nil;
				PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125);
				PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125);
			elseif _G.FindBoss == "Soul Reaper" then
				bMon = "Soul Reaper";
				Qdata = nil;
				PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813);
				PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813);
			end;
		end;
	end;
QuestBeta = function()
		local I = QuestB();
		return {
			[0] = _G.FindBoss,
			[1] = bMon,
			[2] = Qdata,
			[3] = Qname,
			[4] = PosB,
		};
	end;


function MaterialMon()
	if _G.SelectMaterial == "Angel Wings" then
		MMon = "Royal Soldier";
		MPos = CFrame.new(-7759.45898, 5606.93652, -1862.70276, -0.866007447, 0, -0.500031412, 0, 1, 0, 0.500031412, 0, -0.866007447);
		SP = "SkyArea2";
	elseif _G.SelectMaterial == "Mystic Droplet" then
		MMon = "Water Fighter";
		MPos = CFrame.new(-3331.70459, 239.138336, -10553.3564, -0.29242146, 0, 0.95628953, 0, 1, 0, -0.95628953, 0, -0.29242146);
		SP = "ForgottenIsland";
	elseif _G.SelectMaterial == "Vampire Fang" then
		MMon = "Vampire";
		MPos = CFrame.new(-6132.39453, 9.00769424, -1466.16919, -0.927179813, 0, -0.374617696, 0, 1, 0, 0.374617696, 0, -0.927179813);
		SP = "Graveyard";
	elseif _G.SelectMaterial == "Gunpowder" then
		MMon = "Pistol Billionaire";
		MPos = CFrame.new(-185.693283, 84.7088699, 6103.62744, 0.90629667, 0, -0.422642082, 0, 1, 0, 0.422642082, 0, 0.90629667);
		SP = "Mansion";
	elseif _G.SelectMaterial == "Mini Tusk" then
		MMon = "Mythological Pirate";
		MPos = CFrame.new(-13456.0498, 469.433228, -7039.96436, 0, 0, 1, 0, 1, 0, -1, 0, 0);
		SP = "BigMansion";
	elseif _G.SelectMaterial == "Conjured Cocoa" then
		MMon = "Chocolate Bar Battler";
		MPos = CFrame.new(582.828674, 25.5824986, -12550.7041, -0.766061664, 0, -0.642767608, 0, 1, 0, 0.642767608, 0, -0.766061664);
		SP = "Chocolate";
	elseif _G.SelectMaterial == "Radiactive Material" then
		MMon = "Factory Staff";
		MPos = CFrame.new(-105.889565, 72.8076935, -670.247986, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747);
		SP = "Bar";
	elseif _G.SelectMaterial == "Leather + Scrap Metal" then
		if game.PlaceId == 2753915549 then
			MMon = "Pirate";
			MPos = CFrame.new(-967.433105, 13.5999937, 4034.24707, -0.258864403, 0, -0.965913713, 0, 1, 0, 0.965913713, 0, -0.258864403);
			SP = "Pirate";
		elseif game.PlaceId == 4442272183 then
			MMon = "Mercenary";
			MPos = CFrame.new(-986.774475, 72.8755951, 1088.44653, -0.656062722, 0, 0.754706323, 0, 1, 0, -0.754706323, 0, -0.656062722);
			SP = "DressTown";
		elseif game.PlaceId == 7449423635 then
			MMon = "Pirate Millionaire";
			MPos = CFrame.new(-118.809372, 55.4874573, 5649.17041, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747);
			SP = "Default";
		end
	elseif _G.SelectMaterial == "Magma Ore" then
		if game.PlaceId == 2753915549 then
			MMon = "Military Soldier";
			MPos = CFrame.new(-5565.60156, 9.10001755, 8327.56934, -0.838688731, 0, -0.544611216, 0, 1, 0, 0.544611216, 0, -0.838688731);
			SP = "Magma";
		elseif game.PlaceId == 4442272183 then
			MMon = "Lava Pirate";
			MPos = CFrame.new(-5158.77051, 14.4791956, -4654.2627, -0.848060489, 0, -0.529899538, 0, 1, 0, 0.529899538, 0, -0.848060489);
			SP = "CircleIslandFire";
		end
	elseif _G.SelectMaterial == "Fish Tail" then
		if game.PlaceId == 2753915549 then
			MMon = "Fishman Warrior";
			MPos = CFrame.new(60943.9023, 17.9492188, 1744.11133, 0.826706648, 0, -0.562633216, 0, 1, 0, 0.562633216, 0, 0.826706648);
			SP = "Underwater City";
		elseif game.PlaceId == 7449423635 then
			MMon = "Fishman Captain";
			MPos = CFrame.new(-10828.1064, 331.825989, -9049.14648, -0.0912091732, 0, 0.995831788, 0, 1, 0, -0.995831788, 0, -0.0912091732);
			SP = "PineappleTown";
		end
	end
end

function CheckQuest()
	MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value;
	if World1 then
		if MyLevel >= 1 and MyLevel <= 9 or SelectMonster == "Bandit" then
			Mon = "Bandit";
			LevelQuest = 1;
			NameQuest = "BanditQuest1";
			NameMon = "Bandit";
			CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, -0, 1, -0, 0.341998369, -0, 0.939700544);
			CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125);
		elseif MyLevel >= 10 and MyLevel <= 14 or SelectMonster == "Monkey" then
			Mon = "Monkey";
			LevelQuest = 1;
			NameQuest = "JungleQuest";
			NameMon = "Monkey";
			CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, -0, -0, 1, -0, 1, -0, -1, -0, -0);
			CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209);
		elseif MyLevel >= 15 and MyLevel <= 29 or SelectMonster == "Gorilla" then
			Mon = "Gorilla";
			LevelQuest = 2;
			NameQuest = "JungleQuest";
			NameMon = "Gorilla";
			CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, -0, -0, 1, -0, 1, -0, -1, -0, -0);
			CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875);
		elseif MyLevel >= 30 and MyLevel <= 39 or SelectMonster == "Pirate" then
			Mon = "Pirate";
			LevelQuest = 1;
			NameQuest = "BuggyQuest1";
			NameMon = "Pirate";
			CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, -0, 1, -0, 0.258804798, -0, 0.965929627);
			CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125);
		elseif MyLevel >= 40 and MyLevel <= 59 or SelectMonster == "Brute" then
			Mon = "Brute";
			LevelQuest = 2;
			NameQuest = "BuggyQuest1";
			NameMon = "Brute";
			CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, -0, 1, -0, 0.258804798, -0, 0.965929627);
			CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875);
		elseif MyLevel >= 60 and MyLevel <= 74 or SelectMonster == "Desert Bandit" then
			Mon = "Desert Bandit";
			LevelQuest = 1;
			NameQuest = "DesertQuest";
			NameMon = "Desert Bandit";
			CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693);
			CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375);
		elseif MyLevel >= 75 and MyLevel <= 89 or SelectMonster == "Desert Officer" then
			Mon = "Desert Officer";
			LevelQuest = 2;
			NameQuest = "DesertQuest";
			NameMon = "Desert Officer";
			CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693);
			CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875);
		elseif MyLevel >= 90 and MyLevel <= 99 or SelectMonster == "Snow Bandit" then
			Mon = "Snow Bandit";
			LevelQuest = 1;
			NameQuest = "SnowQuest";
			NameMon = "Snow Bandit";
			CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, -0, 0.939684391, -0, 1, -0, -0.939684391, -0, -0.342042685);
			CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125);
		elseif MyLevel >= 100 and MyLevel <= 119 or SelectMonster == "Snowman" then
			Mon = "Snowman";
			LevelQuest = 2;
			NameQuest = "SnowQuest";
			NameMon = "Snowman";
			CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, -0, 0.939684391, -0, 1, -0, -0.939684391, -0, -0.342042685);
			CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625);
		elseif MyLevel >= 120 and MyLevel <= 149 or SelectMonster == "Chief Petty Officer" then
			Mon = "Chief Petty Officer";
			LevelQuest = 1;
			NameQuest = "MarineQuest2";
			NameMon = "Chief Petty Officer";
			CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625);
		elseif MyLevel >= 150 and MyLevel <= 174 or SelectMonster == "Sky Bandit" then
			Mon = "Sky Bandit";
			LevelQuest = 1;
			NameQuest = "SkyQuest";
			NameMon = "Sky Bandit";
			CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268);
			CFrameMon = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625);
		elseif MyLevel >= 175 and MyLevel <= 189 or SelectMonster == "Dark Master" then
			Mon = "Dark Master";
			LevelQuest = 2;
			NameQuest = "SkyQuest";
			NameMon = "Dark Master";
			CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268);
			CFrameMon = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625);
		elseif MyLevel >= 190 and MyLevel <= 209 or SelectMonster == "Prisoner" then
			Mon = "Prisoner";
			LevelQuest = 1;
			NameQuest = "PrisonerQuest";
			NameMon = "Prisoner";
			CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918E-9, -0.995993316, 1.60817859E-9, 1, -5.16744869E-9, 0.995993316, -2.06384709E-9, -0.0894274712);
			CFrameMon = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781);
		elseif MyLevel >= 210 and MyLevel <= 249 or SelectMonster == "Dangerous Prisoner" then
			Mon = "Dangerous Prisoner";
			LevelQuest = 2;
			NameQuest = "PrisonerQuest";
			NameMon = "Dangerous Prisoner";
			CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918E-9, -0.995993316, 1.60817859E-9, 1, -5.16744869E-9, 0.995993316, -2.06384709E-9, -0.0894274712);
			CFrameMon = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375);
		elseif MyLevel >= 250 and MyLevel <= 274 or SelectMonster == "Toga Warrior" then
			Mon = "Toga Warrior";
			LevelQuest = 1;
			NameQuest = "ColosseumQuest";
			NameMon = "Toga Warrior";
			CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, -0, -0.857167721, -0, 1, -0, 0.857167721, -0, -0.515037298);
			CFrameMon = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625);
		elseif MyLevel >= 275 and MyLevel <= 299 or SelectMonster == "Gladiator" then
			Mon = "Gladiator";
			LevelQuest = 2;
			NameQuest = "ColosseumQuest";
			NameMon = "Gladiator";
			CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, -0, -0.857167721, -0, 1, -0, 0.857167721, -0, -0.515037298);
			CFrameMon = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625);
		elseif MyLevel >= 300 and MyLevel <= 324 or SelectMonster == "Military Soldier" then
			Mon = "Military Soldier";
			LevelQuest = 1;
			NameQuest = "MagmaQuest";
			NameMon = "Military Soldier";
			CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, -0.499959469);
			CFrameMon = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875);
		elseif MyLevel >= 325 and MyLevel <= 374 or SelectMonster == "Military Spy" then
			Mon = "Military Spy";
			LevelQuest = 2;
			NameQuest = "MagmaQuest";
			NameMon = "Military Spy";
			CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, -0.499959469);
			CFrameMon = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375);
		elseif MyLevel >= 375 and MyLevel <= 399 or SelectMonster == "Fishman Warrior" then
			Mon = "Fishman Warrior";
			LevelQuest = 1;
			NameQuest = "FishmanQuest";
			NameMon = "Fishman Warrior";
			CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
			CFrameMon = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875));
			end
		elseif MyLevel >= 400 and MyLevel <= 449 or SelectMonster == "Fishman Commando" then
			Mon = "Fishman Commando";
			LevelQuest = 2;
			NameQuest = "FishmanQuest";
			NameMon = "Fishman Commando";
			CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
			CFrameMon = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875));
			end
		elseif MyLevel >= 450 and MyLevel <= 474 or SelectMonster == "God's Guard" then
			Mon = "God's Guard";
			LevelQuest = 1;
			NameQuest = "SkyExp1Quest";
			NameMon = "God's Guard";
			CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, -0, 1, -0, 0.0871884301, -0, 0.996191859);
			CFrameMon = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688));
			end
		elseif MyLevel >= 475 and MyLevel <= 524 or SelectMonster == "Shanda" then
			Mon = "Shanda";
			LevelQuest = 2;
			NameQuest = "SkyExp1Quest";
			NameMon = "Shanda";
			CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, -0, 0.906319618, -0, 1, -0, -0.906319618, -0, -0.422592998);
			CFrameMon = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047));
			end
		elseif MyLevel >= 525 and MyLevel <= 549 or SelectMonster == "Royal Squad" then
			Mon = "Royal Squad";
			LevelQuest = 1;
			NameQuest = "SkyExp2Quest";
			NameMon = "Royal Squad";
			CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875);
		elseif MyLevel >= 550 and MyLevel <= 624 or SelectMonster == "Royal Soldier" then
			Mon = "Royal Soldier";
			LevelQuest = 2;
			NameQuest = "SkyExp2Quest";
			NameMon = "Royal Soldier";
			CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625);
		elseif MyLevel >= 625 and MyLevel <= 649 or SelectMonster == "Galley Pirate" then
			Mon = "Galley Pirate";
			LevelQuest = 1;
			NameQuest = "FountainQuest";
			NameMon = "Galley Pirate";
			CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, 0.087131381);
			CFrameMon = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875);
		elseif MyLevel >= 650 or SelectMonster == "Galley Captain" then
			Mon = "Galley Captain";
			LevelQuest = 2;
			NameQuest = "FountainQuest";
			NameMon = "Galley Captain";
			CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, 0.087131381);
			CFrameMon = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375);
		end
	elseif World2 then
		if MyLevel >= 700 and MyLevel <= 724 or SelectMonster == "Raider" then
			Mon = "Raider";
			LevelQuest = 1;
			NameQuest = "Area1Quest";
			NameMon = "Raider";
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, -0, -0.974368095, -0, 1, -0, 0.974368095, -0, -0.22495985);
			CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125);
		elseif MyLevel >= 725 and MyLevel <= 774 or SelectMonster == "Mercenary" then
			Mon = "Mercenary";
			LevelQuest = 2;
			NameQuest = "Area1Quest";
			NameMon = "Mercenary";
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, -0, -0.974368095, -0, 1, -0, 0.974368095, -0, -0.22495985);
			CFrameMon = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625);
		elseif MyLevel >= 775 and MyLevel <= 799 or SelectMonster == "Swan Pirate" then
			Mon = "Swan Pirate";
			LevelQuest = 1;
			NameQuest = "Area2Quest";
			NameMon = "Swan Pirate";
			CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, -0, 0.99026376, -0, 1, -0, -0.99026376, -0, 0.139203906);
			CFrameMon = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625);
		elseif MyLevel >= 800 and MyLevel <= 874 or SelectMonster == "Factory Staff" then
			Mon = "Factory Staff";
			LevelQuest = 2;
			NameQuest = "Area2Quest";
			NameMon = "Factory Staff";
			CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881E-10, -0.999488771, 1.36326533E-10, 1, 8.92172336E-10, 0.999488771, -1.07732087E-10, -0.0319722369);
			CFrameMon = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875);
		elseif MyLevel >= 875 and MyLevel <= 899 or SelectMonster == "Marine Lieutenant" then
			Mon = "Marine Lieutenant";
			LevelQuest = 1;
			NameQuest = "MarineQuest3";
			NameMon = "Marine Lieutenant";
			CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268);
			CFrameMon = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125);
		elseif MyLevel >= 900 and MyLevel <= 949 or SelectMonster == "Marine Captain" then
			Mon = "Marine Captain";
			LevelQuest = 2;
			NameQuest = "MarineQuest3";
			NameMon = "Marine Captain";
			CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268);
			CFrameMon = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625);
		elseif MyLevel >= 950 and MyLevel <= 974 or SelectMonster == "Zombie" then
			Mon = "Zombie";
			LevelQuest = 1;
			NameQuest = "ZombieQuest";
			NameMon = "Zombie";
			CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, -0, -0.95628953, -0, 1, -0, 0.95628953, -0, -0.29242146);
			CFrameMon = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875);
		elseif MyLevel >= 975 and MyLevel <= 999 or SelectMonster == "Vampire" then
			Mon = "Vampire";
			LevelQuest = 2;
			NameQuest = "ZombieQuest";
			NameMon = "Vampire";
			CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, -0, -0.95628953, -0, 1, -0, 0.95628953, -0, -0.29242146);
			CFrameMon = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625);
		elseif MyLevel >= 1000 and MyLevel <= 1049 or SelectMonster == "Snow Trooper" then
			Mon = "Snow Trooper";
			LevelQuest = 1;
			NameQuest = "SnowMountainQuest";
			NameMon = "Snow Trooper";
			CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, -0, 0.92718488, -0, 1, -0, -0.92718488, -0, -0.374604106);
			CFrameMon = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875);
		elseif MyLevel >= 1050 and MyLevel <= 1099 or SelectMonster == "Winter Warrior" then
			Mon = "Winter Warrior";
			LevelQuest = 2;
			NameQuest = "SnowMountainQuest";
			NameMon = "Winter Warrior";
			CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, -0, 0.92718488, -0, 1, -0, -0.92718488, -0, -0.374604106);
			CFrameMon = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625);
		elseif MyLevel >= 1100 and MyLevel <= 1124 or SelectMonster == "Lab Subordinate" then
			Mon = "Lab Subordinate";
			LevelQuest = 1;
			NameQuest = "IceSideQuest";
			NameMon = "Lab Subordinate";
			CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, -0, 1, -0, 0.891015649, -0, 0.453972578);
			CFrameMon = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375);
		elseif MyLevel >= 1125 and MyLevel <= 1174 or SelectMonster == "Horned Warrior" then
			Mon = "Horned Warrior";
			LevelQuest = 2;
			NameQuest = "IceSideQuest";
			NameMon = "Horned Warrior";
			CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, -0, 1, -0, 0.891015649, -0, 0.453972578);
			CFrameMon = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375);
		elseif MyLevel >= 1175 and MyLevel <= 1199 or SelectMonster == "Magma Ninja" then
			Mon = "Magma Ninja";
			LevelQuest = 1;
			NameQuest = "FireSideQuest";
			NameMon = "Magma Ninja";
			CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213);
			CFrameMon = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375);
		elseif MyLevel >= 1200 and MyLevel <= 1249 or SelectMonster == "Lava Pirate" then
			Mon = "Lava Pirate";
			LevelQuest = 2;
			NameQuest = "FireSideQuest";
			NameMon = "Lava Pirate";
			CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213);
			CFrameMon = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875);
		elseif MyLevel >= 1250 and MyLevel <= 1274 or SelectMonster == "Ship Deckhand" then
			Mon = "Ship Deckhand";
			LevelQuest = 1;
			NameQuest = "ShipQuest1";
			NameMon = "Ship Deckhand";
			CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016);
			CFrameMon = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
			end
		elseif MyLevel >= 1275 and MyLevel <= 1299 or SelectMonster == "Ship Engineer" then
			Mon = "Ship Engineer";
			LevelQuest = 2;
			NameQuest = "ShipQuest1";
			NameMon = "Ship Engineer";
			CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016);
			CFrameMon = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
			end
		elseif MyLevel >= 1300 and MyLevel <= 1324 or SelectMonster == "Ship Steward" then
			Mon = "Ship Steward";
			LevelQuest = 1;
			NameQuest = "ShipQuest2";
			NameMon = "Ship Steward";
			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125);
			CFrameMon = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
			end
		elseif MyLevel >= 1325 and MyLevel <= 1349 or SelectMonster == "Ship Officer" then
			Mon = "Ship Officer";
			LevelQuest = 2;
			NameQuest = "ShipQuest2";
			NameMon = "Ship Officer";
			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125);
			CFrameMon = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
			end
		elseif MyLevel >= 1350 and MyLevel <= 1374 or SelectMonster == "Arctic Warrior" then
			Mon = "Arctic Warrior";
			LevelQuest = 1;
			NameQuest = "FrostQuest";
			NameMon = "Arctic Warrior";
			CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, -0, -0.358349502, -0, 1, -0, 0.358349502, -0, -0.933587909);
			CFrameMon = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125);
			if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-6508.5581054688, 5000.034996032715, -132.83953857422));
			end
		elseif MyLevel >= 1375 and MyLevel <= 1424 or SelectMonster == "Snow Lurker" then
			Mon = "Snow Lurker";
			LevelQuest = 2;
			NameQuest = "FrostQuest";
			NameMon = "Snow Lurker";
			CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, -0, -0.358349502, -0, 1, -0, 0.358349502, -0, -0.933587909);
			CFrameMon = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375);
		elseif MyLevel >= 1425 and MyLevel <= 1449 or SelectMonster == "Sea Soldier" then
			Mon = "Sea Soldier";
			LevelQuest = 1;
			NameQuest = "ForgottenQuest";
			NameMon = "Sea Soldier";
			CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, -0, 1, -0, 0.13915664, -0, 0.990270376);
			CFrameMon = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125);
		elseif MyLevel >= 1450 or SelectMonster == "Water Fighter" then
			Mon = "Water Fighter";
			LevelQuest = 2;
			NameQuest = "ForgottenQuest";
			NameMon = "Water Fighter";
			CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, -0, 1, -0, 0.13915664, -0, 0.990270376);
			CFrameMon = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875);
		end
	elseif World3 then
		if MyLevel >= 1500 and MyLevel <= 1524 or SelectMonster == "Pirate Millionaire" then
			Mon = "Pirate Millionaire";
			LevelQuest = 1;
			NameQuest = "PiratePortQuest";
			NameMon = "Pirate Millionaire";
			CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.957107544, -0, -0.289732844, -0, 1, -0, 0.289732844, -0, 0.957107544);
			CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375);
		elseif MyLevel >= 1525 and MyLevel <= 1574 or SelectMonster == "Pistol Billionaire" then
			Mon = "Pistol Billionaire";
			LevelQuest = 2;
			NameQuest = "PiratePortQuest";
			NameMon = "Pistol Billionaire";
			CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.957107544, -0, -0.289732844, -0, 1, -0, 0.289732844, -0, 0.957107544);
			CFrameMon = CFrame.new(-54.8110352, 83.7698746, 5947.84082, -0.965929747, -0, 0.258804798, -0, 1, -0, -0.258804798, -0, -0.965929747);
		elseif MyLevel >= 1575 and MyLevel <= 1599 or SelectMonster == "Dragon Crew Warrior" then
			Mon = "Dragon Crew Warrior";
			LevelQuest = 1;
			NameQuest = "DragonCrewQuest";
			NameMon = "Dragon Crew Warrior";
			CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625);
			CFrameMon = CFrame.new(6709.76367, 52.3442993, -1139.02966, -0.763515472, -0, 0.645789504, -0, 1, -0, -0.645789504, -0, -0.763515472);
		elseif MyLevel >= 1600 and MyLevel <= 1624 or SelectMonster == "Dragon Crew Archer" then
			Mon = "Dragon Crew Archer";
			LevelQuest = 2;
			NameQuest = "DragonCrewQuest";
			NameMon = "Dragon Crew Archer";
			CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625);
			CFrameMon = CFrame.new(6668.76172, 481.376923, 329.12207, -0.121787429, -0, -0.992556155, -0, 1, -0, 0.992556155, -0, -0.121787429);
		elseif MyLevel >= 1625 and MyLevel <= 1649 or SelectMonster == "Hydra Enforcer" then
			Mon = "Hydra Enforcer";
			LevelQuest = 1;
			NameQuest = "VenomCrewQuest";
			NameMon = "Hydra Enforcer";
			CFrameQuest = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875);
			CFrameMon = CFrame.new(4547.11523, 1003.10217, 334.194824, 0.388810456, -0, -0.921317935, -0, 1, -0, 0.921317935, -0, 0.388810456);
		elseif MyLevel >= 1650 and MyLevel <= 1699 or SelectMonster == "Venomous Assailant" then
			Mon = "Venomous Assailant";
			LevelQuest = 2;
			NameQuest = "VenomCrewQuest";
			NameMon = "Venomous Assailant";
			CFrameQuest = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875);
			CFrameMon = CFrame.new(4674.92676, 1134.82654, 996.308838, 0.731321394, -0, -0.682033002, -0, 1, -0, 0.682033002, -0, 0.731321394);
		elseif MyLevel >= 1700 and MyLevel <= 1724 or SelectMonster == "Marine Commodore" then
			Mon = "Marine Commodore";
			LevelQuest = 1;
			NameQuest = "MarineTreeIsland";
			NameMon = "Marine Commodore";
			CFrameQuest = CFrame.new(2481.09228515625, 74.27049255371094, -6779.640625);
			CFrameMon = CFrame.new(2577.25391, 75.6100006, -7739.87207, 0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, 0.499959469);
		elseif MyLevel >= 1725 and MyLevel <= 1774 or SelectMonster == "Marine Rear Admiral" then
			Mon = "Marine Rear Admiral";
			LevelQuest = 2;
			NameQuest = "MarineTreeIsland";
			NameMon = "Marine Rear Admiral";
			CFrameQuest = CFrame.new(2481.09228515625, 74.27049255371094, -6779.640625);
			CFrameMon = CFrame.new(3761.81006, 123.912003, -6823.52197, 0.961273968, -0, 0.275594592, -0, 1, -0, -0.275594592, -0, 0.961273968);
		elseif MyLevel >= 1775 and MyLevel <= 1799 or SelectMonster == "Fishman Raider" then
			Mon = "Fishman Raider";
			LevelQuest = 1;
			NameQuest = "DeepForestIsland3";
			NameMon = "Fishman Raider";
			CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213);
			CFrameMon = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625);
		elseif MyLevel >= 1800 and MyLevel <= 1824 or SelectMonster == "Fishman Captain" then
			Mon = "Fishman Captain";
			LevelQuest = 2;
			NameQuest = "DeepForestIsland3";
			NameMon = "Fishman Captain";
			CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213);
			CFrameMon = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625);
		elseif MyLevel >= 1825 and MyLevel <= 1849 or SelectMonster == "Forest Pirate" then
			Mon = "Forest Pirate";
			LevelQuest = 1;
			NameQuest = "DeepForestIsland";
			NameMon = "Forest Pirate";
			CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, -0, 1, -0, 0.707079291, -0, 0.707134247);
			CFrameMon = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625);
		elseif MyLevel >= 1850 and MyLevel <= 1899 or SelectMonster == "Mythological Pirate" then
			Mon = "Mythological Pirate";
			LevelQuest = 2;
			NameQuest = "DeepForestIsland";
			NameMon = "Mythological Pirate";
			CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, -0, 1, -0, 0.707079291, -0, 0.707134247);
			CFrameMon = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125);
		elseif MyLevel >= 1900 and MyLevel <= 1924 or SelectMonster == "Jungle Pirate" then
			Mon = "Jungle Pirate";
			LevelQuest = 1;
			NameQuest = "DeepForestIsland2";
			NameMon = "Jungle Pirate";
			CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, -0.0871315002);
			CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625);
		elseif MyLevel >= 1925 and MyLevel <= 1974 or SelectMonster == "Musketeer Pirate" then
			Mon = "Musketeer Pirate";
			LevelQuest = 2;
			NameQuest = "DeepForestIsland2";
			NameMon = "Musketeer Pirate";
			CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, -0.0871315002);
			CFrameMon = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375);
		elseif MyLevel >= 1975 and MyLevel <= 1999 or SelectMonster == "Reborn Skeleton" then
			Mon = "Reborn Skeleton";
			LevelQuest = 1;
			NameQuest = "HauntedQuest1";
			NameMon = "Reborn Skeleton";
			CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, -0, -0, 1, -0, 1, -0, -1, -0, -0);
			CFrameMon = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625);
		elseif MyLevel >= 2000 and MyLevel <= 2024 or SelectMonster == "Living Zombie" then
			Mon = "Living Zombie";
			LevelQuest = 2;
			NameQuest = "HauntedQuest1";
			NameMon = "Living Zombie";
			CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, -0, -0, 1, -0, 1, -0, -1, -0, -0);
			CFrameMon = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875);
		elseif MyLevel >= 2025 and MyLevel <= 2049 or SelectMonster == "Demonic Soul" then
			Mon = "Demonic Soul";
			LevelQuest = 1;
			NameQuest = "HauntedQuest2";
			NameMon = "Demonic Soul";
			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625);
		elseif MyLevel >= 2050 and MyLevel <= 2074 or SelectMonster == "Posessed Mummy" then
			Mon = "Posessed Mummy";
			LevelQuest = 2;
			NameQuest = "HauntedQuest2";
			NameMon = "Posessed Mummy";
			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625);
		elseif MyLevel >= 2075 and MyLevel <= 2099 or SelectMonster == "Peanut Scout" then
			Mon = "Peanut Scout";
			LevelQuest = 1;
			NameQuest = "NutsIslandQuest";
			NameMon = "Peanut Scout";
			CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875);
		elseif MyLevel >= 2100 and MyLevel <= 2124 or SelectMonster == "Peanut President" then
			Mon = "Peanut President";
			LevelQuest = 2;
			NameQuest = "NutsIslandQuest";
			NameMon = "Peanut President";
			CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875);
		elseif MyLevel >= 2125 and MyLevel <= 2149 or SelectMonster == "Ice Cream Chef" then
			Mon = "Ice Cream Chef";
			LevelQuest = 1;
			NameQuest = "IceCreamIslandQuest";
			NameMon = "Ice Cream Chef";
			CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125);
		elseif MyLevel >= 2150 and MyLevel <= 2199 or SelectMonster == "Ice Cream Commander" then
			Mon = "Ice Cream Commander";
			LevelQuest = 2;
			NameQuest = "IceCreamIslandQuest";
			NameMon = "Ice Cream Commander";
			CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, -0, -0, -1, -0, 1, -0, 1, -0, -0);
			CFrameMon = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625);
		elseif MyLevel >= 2200 and MyLevel <= 2224 or SelectMonster == "Cookie Crafter" then
			Mon = "Cookie Crafter";
			LevelQuest = 1;
			NameQuest = "CakeQuest1";
			NameMon = "Cookie Crafter";
			CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053E-8, 0.288177818, 6.9301187E-8, 1, 7.51931211E-8, -0.288177818, -5.2032135E-8, 0.957576931);
			CFrameMon = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375);
		elseif MyLevel >= 2225 and MyLevel <= 2249 or SelectMonster == "Cake Guard" then
			Mon = "Cake Guard";
			LevelQuest = 2;
			NameQuest = "CakeQuest1";
			NameMon = "Cake Guard";
			CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053E-8, 0.288177818, 6.9301187E-8, 1, 7.51931211E-8, -0.288177818, -5.2032135E-8, 0.957576931);
			CFrameMon = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875);
		elseif MyLevel >= 2250 and MyLevel <= 2274 or SelectMonster == "Baking Staff" then
			Mon = "Baking Staff";
			LevelQuest = 1;
			NameQuest = "CakeQuest2";
			NameMon = "Baking Staff";
			CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143E-8, 0.250778586, 4.74911062E-8, 1, 1.49904711E-8, -0.250778586, 2.64211941E-8, -0.96804446);
			CFrameMon = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375);
		elseif MyLevel >= 2275 and MyLevel <= 2299 or SelectMonster == "Head Baker" then
			Mon = "Head Baker";
			LevelQuest = 2;
			NameQuest = "CakeQuest2";
			NameMon = "Head Baker";
			CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143E-8, 0.250778586, 4.74911062E-8, 1, 1.49904711E-8, -0.250778586, 2.64211941E-8, -0.96804446);
			CFrameMon = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125);
		elseif MyLevel >= 2300 and MyLevel <= 2324 or SelectMonster == "Cocoa Warrior" then
			Mon = "Cocoa Warrior";
			LevelQuest = 1;
			NameQuest = "ChocQuest1";
			NameMon = "Cocoa Warrior";
			CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375);
			CFrameMon = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125);
		elseif MyLevel >= 2325 and MyLevel <= 2349 or SelectMonster == "Chocolate Bar Battler" then
			Mon = "Chocolate Bar Battler";
			LevelQuest = 2;
			NameQuest = "ChocQuest1";
			NameMon = "Chocolate Bar Battler";
			CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375);
			CFrameMon = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375);
		elseif MyLevel >= 2350 and MyLevel <= 2374 or SelectMonster == "Sweet Thief" then
			Mon = "Sweet Thief";
			LevelQuest = 1;
			NameQuest = "ChocQuest2";
			NameMon = "Sweet Thief";
			CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875);
			CFrameMon = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625);
		elseif MyLevel >= 2375 and MyLevel <= 2399 or SelectMonster == "Candy Rebel" then
			Mon = "Candy Rebel";
			LevelQuest = 2;
			NameQuest = "ChocQuest2";
			NameMon = "Candy Rebel";
			CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875);
			CFrameMon = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625);
		elseif MyLevel >= 2400 and MyLevel <= 2424 or SelectMonster == "Candy Pirate" then
			Mon = "Candy Pirate";
			LevelQuest = 1;
			NameQuest = "CandyQuest1";
			NameMon = "Candy Pirate";
			CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375);
			CFrameMon = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875);
		elseif MyLevel >= 2425 and MyLevel <= 2449 or SelectMonster == "Snow Demon" then
			Mon = "Snow Demon";
			LevelQuest = 2;
			NameQuest = "CandyQuest1";
			NameMon = "Snow Demon";
			CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375);
			CFrameMon = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375);
		elseif MyLevel >= 2450 and MyLevel <= 2474 or SelectMonster == "Isle Outlaw" then
			Mon = "Isle Outlaw";
			LevelQuest = 1;
			NameQuest = "TikiQuest1";
			NameMon = "Isle Outlaw";
			CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812);
			CFrameMon = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656);
		elseif MyLevel >= 2475 and MyLevel <= 2524 or SelectMonster == "Island Boy" then
			Mon = "Island Boy";
			LevelQuest = 2;
			NameQuest = "TikiQuest1";
			NameMon = "Island Boy";
			CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812);
			CFrameMon = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562);
		elseif MyLevel >= 2525 and MyLevel <= 2550 or SelectMonster == "Isle Champion" then
			Mon = "Isle Champion";
			LevelQuest = 2;
			NameQuest = "TikiQuest2";
			NameMon = "Isle Champion";
			CFrameQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625);
			CFrameMon = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375);
		elseif MyLevel >= 2551 and MyLevel <= 2574 or SelectMonster == "Serpent Hunter" then
			Mon = "Serpent Hunter";
			LevelQuest = 1;
			NameQuest = "TikiQuest3";
			NameMon = "Serpent Hunter";
			CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, -0, 1, -0, 0.308980465, -0, 0.951068401);
			CFrameMon = CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, -0, 0.882950008, -0, 1, -0, -0.882950008, -0, 0.469467044);
		elseif MyLevel >= 2575 or SelectMonster == "Skull Slayer" then
			Mon = "Skull Slayer";
			LevelQuest = 2;
			NameQuest = "TikiQuest3";
			NameMon = "Skull Slayer";
			CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, -0, 1, -0, 0.308980465, -0, 0.951068401);
			CFrameMon = CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, -0, -0.0348687991, -0, 1, -0, 0.0348687991, -0, -0.999392271);
		end
	end
end

function Hop()
    local placeId = game.PlaceId
    local http = game:GetService("HttpService")
    local ts = game:GetService("TeleportService")
    local data = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            ts:TeleportToPlaceInstance(placeId, server.id)
            break
        end
    end
end
function CheckItem(v14)
    for _, v16 in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if v16.Name == v14 then
            return v16
        end
    end
end
function isnil(v22)
    local v23 = nil
    if v22 ~= v23 then
        local _ = false
    end
    return true
end



--[[function UpdateAfdESP()
    for _, v318 in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        do
            local l_v318_0 = v318
            pcall(function()
                if not AfdESP then
                    if l_v318_0:FindFirstChild("NameEsp") then
                        l_v318_0:FindFirstChild("NameEsp"):Destroy()
                    end
                elseif l_v318_0.Name == "Advanced Fruit Dealer" then
                    if l_v318_0:FindFirstChild("NameEsp") then
                        l_v318_0.NameEsp.TextLabel.Text = l_v318_0.Name .. "   \n" .. v306((game:GetService("Players").LocalPlayer.Character.Head.Position - l_v318_0.Position).Magnitude / 3) .. " M"
                    else
                        local v320 = Instance.new("BillboardGui", l_v318_0)
                        v320.Name = "NameEsp"
                        v320.ExtentsOffset = Vector3.new(0, 1, 0)
                        v320.Size = UDim2.new(1, 200, 1, 30)
                        v320.Adornee = l_v318_0
                        v320.AlwaysOnTop = true
                        local v321 = Instance.new("TextLabel", v320)
                        v321.Font = "Code"
                        v321.FontSize = "Size14"
                        v321.TextWrapped = true
                        v321.Size = UDim2.new(1, 0, 1, 0)
                        v321.TextYAlignment = "Top"
                        v321.BackgroundTransparency = 1
                        v321.TextStrokeTransparency = 0.5
                        v321.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            end)
        end
    end
end
function UpdateAuraESP()
    for _, v323 in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        do
            local l_v323_0 = v323
            pcall(function()
                if AuraESP then
                    if l_v323_0.Name == "Master of Enhancement" then
                        if l_v323_0:FindFirstChild("NameEsp") then
                            l_v323_0.NameEsp.TextLabel.Text = l_v323_0.Name .. "   \n" .. v306((game:GetService("Players").LocalPlayer.Character.Head.Position - l_v323_0.Position).Magnitude / 3) .. " M"
                        else
                            local v325 = Instance.new("BillboardGui", l_v323_0)
                            v325.Name = "NameEsp"
                            v325.ExtentsOffset = Vector3.new(0, 1, 0)
                            v325.Size = UDim2.new(1, 200, 1, 30)
                            v325.Adornee = l_v323_0
                            v325.AlwaysOnTop = true
                            local v326 = Instance.new("TextLabel", v325)
                            v326.Font = "Code"
                            v326.FontSize = "Size14"
                            v326.TextWrapped = true
                            v326.Size = UDim2.new(1, 0, 1, 0)
                            v326.TextYAlignment = "Top"
                            v326.BackgroundTransparency = 1
                            v326.TextStrokeTransparency = 0.5
                            v326.TextColor3 = Color3.fromRGB(80, 245, 245)
                        end
                    end
                elseif l_v323_0:FindFirstChild("NameEsp") then
                    l_v323_0:FindFirstChild("NameEsp"):Destroy()
                end
            end)
        end
    end
end]]

local redzlib = fetcher.load("{Owner}Library/refs/heads/main/redz-V5-remake/main.luau")()
function AutoHaki()
    local l_Character_0 = game:GetService("Players").LocalPlayer.Character
    if l_Character_0 and not l_Character_0:FindFirstChild("HasBuso") then
        local l_CommF__0 = game:GetService("ReplicatedStorage").Remotes.CommF_
        if l_CommF__0 then
            l_CommF__0:InvokeServer("Buso")
        end
    end
end
function UnEquipWeapon(v357)
    if game.Players.LocalPlayer.Character:FindFirstChild(v357) then
        _G.NotAutoEquip = true
        wait(0.5)
        game.Players.LocalPlayer.Character:FindFirstChild(v357).Parent = game.Players.LocalPlayer.Backpack
        wait(0.1)
        _G.NotAutoEquip = false
    end
end
function EquipWeapon(v358)
    if not _G.NotAutoEquip and game.Players.LocalPlayer.Backpack:FindFirstChild(v358) then
        Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(v358)
        wait(0.1)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end
end
spawn(function()
    local v359 = getrawmetatable(game)
    local l___namecall_0 = v359.__namecall
    setreadonly(v359, false)
    v359.__namecall = newcclosure(function(...)
        local v361 = getnamecallmethod()
        local v362 = {...}
        if tostring(v361) == "FireServer" and tostring(v362[1]) == "RemoteEvent" and tostring(v362[2]) ~= "true" and tostring(v362[2]) ~= "false" and _G.UseSkill then
            if type(v362[2]) ~= "vector" then
                v362[2] = CFrame.new(PositionSkillMasteryDevilFruit)
            else
                v362[2] = PositionSkillMasteryDevilFruit
            end
            return l___namecall_0(unpack(v362))
        else
            return l___namecall_0(...)
        end
    end)
end)
spawn(function()
    pcall(function()
        while task.wait() do
            for _, v364 in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if v364:IsA("Tool") and v364:FindFirstChild("RemoteFunctionShoot") then
                    CurrentEquipGun = v364.Name
                end
            end
        end
    end)
end)

local TweenActive = false
local CurrentTween = nil

function StopTween(force)
    if force or not TweenActive then
        TweenActive = false
        NoClip = false
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
        
        local moversToDestroy = {
            "BodyClip", "Nigga", "PartTele", "BodyVelocity", 
            "BodyGyro", "BodyPosition", "BodyForce",
            "AlignPosition", "AlignOrientation"
        }
        
        for _, moverName in ipairs(moversToDestroy) do
            local mover = hrp:FindFirstChild(moverName)
            if mover then
                pcall(function() mover:Destroy() end)
            end
        end

        if character.Head and character.Head:FindFirstChild("BodyVelocity") then
            pcall(function() character.Head.BodyVelocity:Destroy() end)
        end
        
        local partTele = character:FindFirstChild("PartTele")
        if partTele then pcall(function() partTele:Destroy() end) end
        
        local block = character:FindFirstChild("Block")
        if block then pcall(function() block:Destroy() end) end

        if CurrentTween then
            pcall(function() CurrentTween:Cancel() end)
            CurrentTween = nil
        end

        pcall(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)

        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
        
        task.wait(0.05)
    end
end

v391 = false 
function CancelTween23()
    TweenActive = false
    NoClip = false
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    for _,v in pairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyPosition") or v:IsA("AlignPosition") then
            v:Destroy()
        end
    end
    if char:FindFirstChild("PartTele") then
        char.PartTele:Destroy()
    end
    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
        CurrentTween = nil
    end
end
_G.FarmDistance = _G.FarmDistance or 10
_G.FarmHeight = _G.FarmHeight or 15

_G.OrbitSpeed = _G.OrbitSpeed or 4

_G.StarIndex = _G.StarIndex or 1
_G.StarDelay = _G.StarDelay or 0.50
_G.LastStar = _G.LastStar or 0

local StarPoints = {
    Vector3.new(10, _G.FarmHeight, 0),
    Vector3.new(-10, _G.FarmHeight, 0),
    Vector3.new(0, _G.FarmHeight, 10),
    Vector3.new(0, _G.FarmHeight, -10),
    Vector3.new(7, _G.FarmHeight, 7),
    Vector3.new(-7, _G.FarmHeight, -7)
}

function FarmModePosition(basePos)
    local t = tick()
    local d = _G.FarmDistance
    local h = _G.FarmHeight

    if _G.FarmMode == "Orbit" then
        return CFrame.new(basePos + Vector3.new(
            math.cos(t * _G.OrbitSpeed) * d,
            h,
            math.sin(t * _G.OrbitSpeed) * d
        ))

    elseif _G.FarmMode == "Star" then
        if tick() - _G.LastStar > _G.StarDelay then
            _G.LastStar = tick()
            _G.StarIndex = (_G.StarIndex % #StarPoints) + 1
        end

        return CFrame.new(basePos + StarPoints[_G.StarIndex])

    else
        return CFrame.new(basePos + Vector3.new(0, h, 0))
    end
end
function KillMob(v373, v374)
    pcall(function()
        local thismob = DetectMob2(v373)
        if thismob and thismob:FindFirstChild("HumanoidRootPart") and thismob:FindFirstChild("Humanoid") and thismob.Humanoid.Health > 0 then
            repeat
                task.wait()
                Buso()
                EquipWeapon()
                NoClip = true

                local hrp = thismob.HumanoidRootPart
                local pos = hrp.Position
                
                local novaPosicao = FarmModePosition(pos)
                
                Tween23(CFrame.new(novaPosicao))
                BringPos = hrp.CFrame
                
                if _G.FarmMode == "Up" then
                    BringMob(v373)
                end

            until not thismob.Parent or not thismob:FindFirstChild("Humanoid") or thismob.Humanoid.Health <= 0 or not thismob:FindFirstChild("HumanoidRootPart") or v374()

            NoClip = false
            CancelTween23()
        end
    end)
end



function enableNoclip()
    if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
        local l_BodyVelocity_1 = Instance.new("BodyVelocity")
        l_BodyVelocity_1.Name = "BodyClip"
        l_BodyVelocity_1.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        l_BodyVelocity_1.MaxForce = Vector3.new(100000, 100000, 100000)
        l_BodyVelocity_1.Velocity = Vector3.new(0, 0, 0)
    end
end
function disableNoclip()
    local l_BodyClip_0 = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip")
    if l_BodyClip_0 then
        l_BodyClip_0:Destroy()
    end
end
function disableCollisions()
    for _, v385 in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
        if v385:IsA("BasePart") then
            v385.CanCollide = false
        end
    end
end
local _, _ = pcall(function()
    return getgenv().Module
end)
spawn(function()
    pcall(function()
        while task.wait(0.2) do
            if getgenv().Module or _G.DefendVolcano or getgenv().AutoFarm then
                enableNoclip()
                disableCollisions()
            else
                disableNoclip()
            end
        end
    end)
end)
function EquipAllWeapon()
    pcall(function()
        for _, v389 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v389:IsA("Tool") and v389.Name ~= "Summon Sea Beast" and v389.Name ~= "Water Body" and v389.Name ~= "Awakening" then
                local l_FirstChild_0 = game.Players.LocalPlayer.Backpack:FindFirstChild(v389.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(l_FirstChild_0)
                wait(1)
            end
        end
    end)
end
local v391 = false
function WaitHRP(v392)
    if v392 then
        return v392.Character:WaitForChild("HumanoidRootPart", 9)
    else
        return 
    end
end
function CheckNearestTeleporter(v393)
    local l_Position_1 = v393.Position
    local l_huge_0 = math.huge
    local v396 = nil
    local l_PlaceId_1 = game.PlaceId
    local v398 = {}
    if l_PlaceId_1 ~= 2753915549 then
        if l_PlaceId_1 ~= 4442272183 then
            if l_PlaceId_1 == 7449423635 then
                v398 = {
                    ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
                    ["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
                    Mansion = Vector3.new(-12462, 375, -7552),
                    Castle = Vector3.new(-5036, 315, -3179),
                    ["Dimensional Shift"] = Vector3.new(-2097.3447265625, 4776.24462890625, -15013.4990234375),
                    ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
                    ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276, 1, 2.14762768E-8, -1.99111154E-13, -2.14762768E-8, 1, -3.0510602E-8, 1.98455903E-13, 3.0510602E-8, 1),
                    ["Temple of Time"] = Vector3.new(28286, 14897, 103)
                }
            end
        else
            v398 = {
                ["Swan Mansion"] = Vector3.new(-390, 332, 673),
                ["Swan Room"] = Vector3.new(2285, 15, 905),
                ["Cursed Ship"] = Vector3.new(923, 126, 32852),
                ["Zombie Island"] = Vector3.new(-6509, 83, -133)
            }
        end
    else
        v398 = {
            Sky3 = Vector3.new(-7894, 5547, -380),
            Sky3Exit = Vector3.new(-4607, 874, -1667),
            UnderWater = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
            UnderwaterExit = Vector3.new(4050, -1, -1814)
        }
    end
    for _, v400 in pairs(v398) do
        local l_Magnitude_1 = (v400 - l_Position_1).Magnitude
        if l_Magnitude_1 < l_huge_0 then
            l_huge_0 = l_Magnitude_1
            v396 = v400
        end
    end
    if l_huge_0 <= (l_Position_1 - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude then
        return v396
    else
        return 
    end
end

function requestEntrance(v402)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", v402)
    local l_HumanoidRootPart_3 = game.Players.LocalPlayer.Character.HumanoidRootPart
    l_HumanoidRootPart_3.CFrame = l_HumanoidRootPart_3.CFrame + Vector3.new(0, 50, 0)
    task.wait(0.5)
end
function TelePPlayer(v404)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v404
end
local TweenService = game:GetService("TweenService")

function topos(v405)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (v405.Position - hrp.Position).Magnitude  
    local speed = Settings.TweenSpeed or _G.TweenSpeed or 300
    if speed == 0 then speed = 300 end

    local duration = distance / speed
    if duration < 0.1 then duration = 0.1 end

    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
        CurrentTween = nil
    end

    pcall(function()
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyPosition") or v.Name == "BodyClip" then
                v:Destroy()
            end
        end
        hrp.AssemblyLinearVelocity = Vector3.zero
    end)

    if distance < 50 or speed > 9000 then
        hrp.CFrame = v405
        return
    end

    CurrentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = v405})
    CurrentTween:Play()
    task.spawn(function()
        pcall(function()
            CurrentTween.Completed:Wait()
        end)
        CurrentTween = nil
    end)
end

function fastTopos(v405)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.CFrame = v405
end
function stopTeleport()
    v391 = false
    local l_LocalPlayer_2 = game.Players.LocalPlayer
    if l_LocalPlayer_2.Character:FindFirstChild("PartTele") then
        l_LocalPlayer_2.Character.PartTele:Destroy()
    end
end
spawn(function()
    while task.wait() do
        if not v391 then
            stopTeleport()
        end
    end
end)
spawn(function()
    local l_LocalPlayer_3 = game.Players.LocalPlayer
    while task.wait() do
        pcall(function()
            if l_LocalPlayer_3.Character:FindFirstChild("PartTele") and (l_LocalPlayer_3.Character.HumanoidRootPart.Position - l_LocalPlayer_3.Character.PartTele.Position).Magnitude >= 100 then
                stopTeleport()
            end
        end)
    end
end)
local l_LocalPlayer_4 = game.Players.LocalPlayer
local function v417(v416)
    v416:WaitForChild("Humanoid").Died:Connect(function()
        stopTeleport()
    end)
end
l_LocalPlayer_4.CharacterAdded:Connect(v417)
if l_LocalPlayer_4.Character then
    v417(l_LocalPlayer_4.Character)
end
function TP1(v418)
    topos(v418)
end

spawn(function()
    while wait() do
        if _G.SpinPos then
            Pos = CFrame.new(0, PosY, -20)
            wait(0.1)
            Pos = CFrame.new(-20, PosY, 0)
            wait(0.1)
            Pos = CFrame.new(0, PosY, 20)
            wait(0.1)
            Pos = CFrame.new(20, PosY, 0)
        else
            Pos = CFrame.new(0, PosY, 0)
        end
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.FarmBone or _G.AutoFarmMastery or _G.FarmAllBoss or _G.FarmMastery_S or _G.AutoFarm or _G.FarmAllBoss or _G.Pray or _G.Trylux or _G.Hallow or _G.FarmCake or  _G.FarmDaiBan or _G.Greybeard or _G.CursedCaptain or _G.AutoDarkBoss or _G.ChiefWarden or _G.Trident or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodCanvande or _G.SwodsBuddy or _G.FarmBlazeEM or _G.AutoFindPrehistoric or _G.TweenVolcano or _G.DefendVolcano or _G.KillGolem or _G.SwodTwinHooks or _G.Fullykatakuri or _G.AutoBoss or _G.SwodCanvander or _G.AutoFarmMaterial or _G.AutoSecondSea or _G.Autosaw or _G.ChiefWarden or _G.Trident or _G.AutoSaber or _G.ThirdSea or _G.AutoBartilo or _G.AutoFactory or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodTwinHooks or _G.SwodCanvander or _G.AutoRaidPirate or _G.AutoQuestYama or _G.AutoYamaQuest or _G.AutoSaber or _G.DefendVolcano or _G.TPB or _G.SailBoat or _G.Autoterrorshark or _G.KillShark or _G.KillPiranha or _G.KillFishCrew or _G.AutoQuestRace or _G.Dungeon or _G.AutoLawRaid or _G.Tweenfruit or ProjectTrialPro or _G.TweenMGear or _G.AutoMysticIsland or AutoUpgradeRace or AutoRaceEvo1 or _G.AutoFarmFruits or _G.Autopole or _G.Autosaw or _G.AutoElitehunter or FarmMtrFruit or _G.AutoNear or _G.CollectBerry or _G.RipIndraKill or _G.FarmChocola or SoulGuitar or _G.AutoHolyTorch or _G.AutoGetTushita or _G.AutoYama or _G.AutoMobDragon or _G.AutoHydraTree or _G.TweenToKitsune or _G.AutoDooHee or _G.AutoAzuerEmber or _G.TweenVolcano or _G.Dungeon or _G.AutoLawRaid or _G.TweenFruit or _G.Grabfruit or _G.TeleportIsland or _G.TeleportNPC or _G.SafeMode or _G.AutoPlayerHunter or _G.AutoKillPlayer or _G.TeleportPly or _G.AutoQuestBoss or _G.AutoAllBoss or _G.AutoFarmLevelNew or _G.FarmSummer or _G.FarmMastery_Dev or _G.FarmMastery_G or _G.SailBoats or _G.GrindSea or _G.SE_Piranha or _G.SE_SeaBeast or _G.SE_Shark or _G.SE_TerrorShark or _G.SE_HauntedShip or _G.SE_ShipRaid or _G.FrozenTP or _G.CollectEggs or _G.AutoMatSoul or _G.SelectedBoat or _G.DangerSc or _G.SailBoats or _G.Shark or _G.Piranha or _G.TerrorShark or _G.MobCrew or _G.HCM or _G.PGB or _G.FishBoat or _G.SeaBeast1 or _G.Leviathan1 then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local l_BodyVelocity_2 = Instance.new("BodyVelocity")
                    l_BodyVelocity_2.Name = "BodyClip"
                    l_BodyVelocity_2.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    l_BodyVelocity_2.MaxForce = Vector3.new(100000, 100000, 100000)
                    l_BodyVelocity_2.Velocity = Vector3.new(0, 1, 0)
                end
            else
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.FarmBone or _G.AutoFarmMastery or _G.FarmAllBoss or _G.FarmMastery_S or _G.AutoFarm or _G.FarmAllBoss or _G.Pray or _G.Trylux or _G.Hallow or _G.FarmCake or _G.FarmDaiBan or _G.Fullykatakuri or _G.AutoBoss or _G.AutoMateria or _G.AutoSecondSea or _G.Autosaw or _G.ChiefWarden or _G.Trident or _G.AutoSaber or _G.Greybeard or _G.CursedCaptain or _G.AutoDarkBoss or _G.ChiefWarden or _G.Trident or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodCanvande or _G.SwodTwinHooks or _G.ThirdSea or _G.AutoBartilo or _G.AutoFactory or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodTwinHooks or _G.SwodCanvander or _G.SwodsBuddy or _G.FarmBlazeEM or _G.AutoFindPrehistoric or _G.TweenVolcano or _G.DefendVolcano or _G.KillGolem or _G.AutoRaidPirate or _G.AutoQuestYama or _G.AutoYamaQuest or _G.AutoElitehunter or FarmMtrFruit or AutoUpgradeRace or _G.AutoFarmMaterial or AutoRaceEvo1 or AutoSaber or _G.Autopole or _G.SwodCanvander or _G.DefendVolcano or _G.SailBoat or _G.Autoterrorshark or _G.KillShark or _G.KillPiranha or _G.KillFishCrew or _G.AutoQuestRace or _G.Dungeon or _G.AutoLawRaid or _G.Tweenfruit or ProjectTrialPro or _G.AutoMysticIsland or _G.TweenMGear or _G.Autosaw or _G.AutoNear or _G.AutoFarmFruits or _G.CollectBerry or _G.RipIndraKill or _G.FarmChocola or SoulGuitar or _G.AutoHolyTorch or _G.AutoGetTushita or _G.AutoYama or _G.AutoMobDragon or _G.AutoHydraTree or _G.TweenToKitsune or _G.AutoDooHee or _G.AutoAzuerEmber or _G.TweenVolcano or _G.Dungeon or _G.AutoLawRaid or _G.TweenFruit or _G.Grabfruit or _G.TeleportIsland or _G.TeleportNPC or _G.SafeMode or _G.AutoPlayerHunter or _G.AutoKillPlayer or _G.TeleportPly or _G.AutoQuestBoss or _G.AutoAllBoss or _G.AutoFarmLevelNew or _G.FarmSummer or _G.FarmMastery_Dev or _G.FarmMastery_G or _G.SailBoats or _G.GrindSea or _G.SE_Piranha or _G.SE_SeaBeast or _G.SE_Shark or _G.SE_TerrorShark or _G.SE_HauntedShip or _G.SE_ShipRaid or _G.FrozenTP or _G.CollectEggs or _G.AutoMatSoul or _G.SelectedBoat or _G.DangerSc or _G.SailBoats or _G.Shark or _G.Piranha or _G.TerrorShark or _G.MobCrew or _G.HCM or _G.PGB or _G.FishBoat or _G.SeaBeast1 or _G.Leviathan1 then
                for _, v421 in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v421:IsA("BasePart") then
                        v421.CanCollide = false
                    end
                end
            end
        end)
    end)
end)
local v422 = {}
function TP13(v423)
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    local distance = (v423.Position - hrp.Position).Magnitude
    local duration = TweenSpeed > 0 and distance / TweenSpeed or 0.001

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(hrp, tweenInfo, {CFrame = v423})
    tween:Play()
    v422.Stop = function()
        tween:Cancel()
        hrp.CFrame = v423 
    end
    if TweenSpeed == 0 then
        tween:Cancel()
        hrp.CFrame = v423
    end

    return v422
end
function fastpos(v427)
    Distance = (v427.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    Speed = 1000
    game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), {CFrame = v427}):Play()
end
function slowpos(v428)
    Distance = (v428.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    Speed = 150
    game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), {CFrame = v428}):Play()
end
local _ = {}
function BTP(v430)
    pcall(function()
        if (v430.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1500 and not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
            repeat
                wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v430
                wait(0.05)
                game.Players.LocalPlayer.Character.Head:Destroy()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v430
            until (v430.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
        end
    end)
end
function TelePPlayer(v431)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v431
end
function TPB(v432)
    local v433 = game:service("TweenService")
    local v434 = TweenInfo.new((game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame.Position - v432.Position).Magnitude / 300, Enum.EasingStyle.Linear)
    tween = v433:Create(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat, v434, {CFrame = v432})
    tween:Play()
    return {Stop = function(_)
        tween:Cancel()
    end}
end
function TPP(v436)
    if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0 and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") then
        local v437 = game:service("TweenService")
        local v438 = TweenInfo.new((game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v436.Position).Magnitude / 325, Enum.EasingStyle.Linear)
        tween = v437:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v438, {CFrame = v436})
        tween:Play()
        return {Stop = function(_)
            tween:Cancel()
        end}
    else
        tween:Cancel()
        repeat
            wait()
        until game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Health > 0
        wait(7)
        return 
    end
end
function StopTween(v440)
    if not v440 then
        _G.StopTween = true
        wait()
        topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
        end
        _G.StopTween = false
        _G.Clip = false
    end
end
spawn(function()
    pcall(function()
        while wait() do
            for _, v442 in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if v442:IsA("Tool") and v442:FindFirstChild("RemoteFunctionShoot") then
                    _G.SelectWeaponGun = v442.Name
                end
            end
        end
    end)
end)
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
function CheckColorRipIndra()
    mmb = {}
    for _, v444 in next, game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:GetChildren() do
        if v444:IsA("Part") and v444:FindFirstChild("Part") and v444.Part.BrickColor.Name == "Dark stone grey" then
            mmb[v444.BrickColor.Name] = v444
        end
    end
    return mmb
end
function ActivateColor(v445)
    haki = {["Hot pink"] = "Winter Sky", ["Really red"] = "Pure Red", Oyster = "Snow White"}
    runnay = haki[v445]
    if runnay then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", runnay)
    end
end
function AutoActiveColorRip_Indra()
    for v446, v447 in pairs(CheckColorRipIndra()) do
        ActivateColor(v446)
        topos(v447.CFrame)
        firetouchinterest(v447.TouchInterest)
    end
end
function CheckRace()
    local v448 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    local v449 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1")
    if not game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        if v448 == -2 then
            return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V3"
        elseif v449 == -2 then
            return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V2"
        else
            return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V1"
        end
    else
        return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V4"
    end
end
_G.TargTrial = "TargTrial"
function targettrial()
    if _G.TargTrial == "TargTrial" then
        local v450 = nil
        local v451 = 450
        for _, v453 in pairs(game.Players:GetChildren()) do
            c = (v453.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if c <= v451 and v453 ~= game.Players.LocalPlayer then
                v451 = c
                v450 = v453
            end
        end
        if v450 == "c" then
            return 
        elseif _G.TargTrial == "c" then
            _G.TargTrial = v450
            return 
        else
            return 
        end
    else
        return 
    end
end
function CheckPirateBoat()
    local v454 = {"PirateBrigade", "PirateBrigade"}
    for _, v456 in next, game:GetService("Workspace").Enemies:GetChildren() do
        if table.find(v454, v456.Name) and v456:FindFirstChild("Health") and v456.Health.Value > 0 then
            return v456
        end
    end
end
function CheckPirateBoat()
    local v457 = {"FishBoat"}
    for _, v459 in next, game:GetService("Workspace").Enemies:GetChildren() do
        if table.find(v457, v459.Name) and v459:FindFirstChild("Health") and v459.Health.Value > 0 then
            return v459
        end
    end
end
function StoreFruit()
    for _, v461 in pairs(thelocal.Backpack:GetChildren()) do
        if v461:IsA("Tool") and string.find(v461.Name, "Fruit") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v461:GetAttribute("OriginalName"), v461)
        end
    end
end
function TpEntrance(v462)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", v462)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
    wait(0.5)
end
function CheckItemBPCRBPCR(v463)
    chbp = {game.Players.LocalPlayer.Character, game.Players.LocalPlayer.Backpack}
    for _, v465 in pairs(chbp) do
        if v465:FindFirstChild(v463) then
            return v465:FindFirstChild(v463)
        end
    end
end
local Module = fetcher.load("{Repository}Utils/Module.luau")(Settings, Connections)
local TweenModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Scripts3/refs/heads/main/Utils/Module/Tween-Module.luau"))()
local RejoinModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Scripts3/refs/heads/main/Utils/Module/AntiReset.luau"))()
local Window = redzlib:MakeWindow({
    Title = "redz Hub : Blox Fruits",
    SubTitle = "by real_redz",
    ScriptFolder = "redzHub-BloxFruits.json"
})
local oldMakeTab = Window.MakeTab
Window.MakeTab = function(self,config)
    if config and config[1] then
        config[1] = Translate(config[1])
    end
    local Tab = oldMakeTab(self,config)
    HookTranslator(Tab)
    return Tab
end
local Minimizer = Window:NewMinimizer({
  KeyCode = Enum.KeyCode.LeftControl
})

local MobileButton = Minimizer:CreateMobileMinimizer({
    Image = "rbxassetid://15298567397", 
    Size = UDim2.new(0,35,0,35),
    Corner = { CornerRadius = UDim.new(0,6) },
})

local LeftControl = Enum.KeyCode.LeftControl

Connections = Connections or {}

table.insert(Connections, UserInputService.InputBegan:Connect(function(Input, gp)
    if gp then return end
    if Input.KeyCode == LeftControl then
        if Window and Window.Minimize then
            Window:Minimize()
        end
    end
end))

local v484 = Window:MakeTab({Translate("Discord"), "rbxassetid://10723415903"})
local v485 = Window:MakeTab({Translate("Farm"), "rbxassetid://10723407389"})
local v489
if World3 then
    v489 = Window:MakeTab({Translate("Sea"), "waves"})
end
local v486
if not BlackListExecutors then
v486 = Window:MakeTab({Translate("Fishing"), "rbxassetid://127664059821666"})
end
local v500
if World3 then
    v500 = Window:MakeTab({Translate("Islands"), "rbxassetid://10734910680"})
end
local v487 = Window:MakeTab({Translate("Quest/Items"), "rbxassetid://10734975692"})
local v491 = Window:MakeTab({Translate("Fruits/Raid"), "rbxassetid://10709790875"})
local TabHop = Window:MakeTab({Translate("Hop"), "rbxassetid://10723396000"})
local v497 = Window:MakeTab({Translate("Stats"), "rbxassetid://10734961133"})
local v493 = Window:MakeTab({Translate("Teleport"), "rbxassetid://10723434557"})
local v499 = Window:MakeTab({Translate("Status"), "rbxassetid://10734943448"})
local v494 = Window:MakeTab({Translate("Visual"), "rbxassetid://10747373176"})
local v495 = Window:MakeTab({Translate("Shop"), "rbxassetid://10734952479"})
local v496 = Window:MakeTab({Translate("Misc"), "rbxassetid://10734950309"})
 
v484:AddDiscordInvite({
    Name = "redz Hub | Community",
    Description = "Join our discord community to receive information about the next update",
    Banner = Color3.fromRGB(233,37,69),
    Logo = "rbxassetid://84556257345790", 
    Invite = "https://discord.gg/redzhub",
    Members = 23347, 
    Online = 1548
})
local v999 = v484:AddParagraph("Mentions:", "")
v999:SetDesc("Honorable Mention: Plock4444\nHonorable Mention: sae.dev")

local v100 = v484:AddParagraph("mini notice", "")
v100:SetDesc("This Redz is FAKE, it's a fan-made version of Redz Hub")

_G.SelectWeapon = "Melee"
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon ~= "Melee" then
                if _G.SelectWeapon ~= "Sword" then
                    if _G.SelectWeapon == "Gun" then
                        for _, v499 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v499.ToolTip == "Gun" then
                                _G.SelectWeapon = v499.Name
                            end
                        end
                    elseif _G.SelectWeapon == "Fruit" or _G.SelectWeapon == "Blox Fruit" then
                        for _, v501 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v501.ToolTip == "Blox Fruit" then
                                _G.SelectWeapon = v501.Name
                            end
                        end
                    end
                else
                    for _, v503 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v503.ToolTip == "Sword" then
                            _G.SelectWeapon = v503.Name
                        end
                    end
                end
            else
                for _, v505 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v505.ToolTip == "Melee" then
                        _G.SelectWeapon = v505.Name
                    end
                end
            end
        end)
    end
end)
v485:AddDropdown({
    Name = "Select Tool",
    Description = "Choose the tool you want to use",
    Flag = "WeaponType",
    Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Callback = function(v506)
        _G.SelectWeapon = v506
    end
})

v485:AddSlider({
    Name = "UI Scale",
    Description = "Adjust the interface size",
    Flag = "UIScale",
    Min = 0.6,
    Max = 1.6,
    Increment = 0.01,
    Default = 1.0,
    Callback = function(Value)
        redzlib:SetUIScale(Value)
    end
})

v485:AddSection("Main Farm")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer


local SUBMERGED_Y = -1400
local SUB_NPC = CFrame.new(-16246.041, 38.48, 1376.539)
local TravelingSubmerged = false
local CurrentTween = nil

function HRP()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

function IsInSubmerged()
    local hrp = HRP()
    return hrp and hrp.Position.Y < SUBMERGED_Y
end

function StopTween(state)
    if not state and CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
        CurrentTween = nil
    end
end

function TweenTo(cf)
    if not _G.AutoFarm then return end
    local hrp = HRP()
    if not hrp then return end

    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
    end

    local dist = (hrp.Position - cf.Position).Magnitude
    local speed = 300
    local t = dist / speed

    CurrentTween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
    CurrentTween:Play()

    while _G.AutoFarm and CurrentTween and CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
        task.wait()
    end

    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
    end
    CurrentTween = nil
end

function GoSubmerged()
    if not _G.AutoFarm then return end
    if TravelingSubmerged or IsInSubmerged() or LocalPlayer.Data.Level.Value < 2600 then return end

    TravelingSubmerged = true
    TweenTo(SUB_NPC + Vector3.new(0, 60, 0))
    if not _G.AutoFarm then TravelingSubmerged = false return end
    TweenTo(SUB_NPC)
    if not _G.AutoFarm then TravelingSubmerged = false return end

    pcall(function()
        ReplicatedStorage.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
    end)

    while _G.AutoFarm and not IsInSubmerged() do
        task.wait(0.5)
    end

    TravelingSubmerged = false
end

function CheckQuestNew()
    local lvl = LocalPlayer.Data.Level.Value

    if lvl >= 2600 and lvl <= 2624 then
        MonNew = "Reef Bandit"
        LevelQuestNew = 1
        NameQuestNew = "SubmergedQuest1"
        NameMonNew = "Reef Bandit"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(10736.6191, -2087.8439, 9338.4882)

    elseif lvl >= 2650 and lvl <= 2674 then
        MonNew = "Sea Chanter"
        LevelQuestNew = 1
        NameQuestNew = "SubmergedQuest2"
        NameMonNew = "Sea Chanter"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(10621.0342, -2087.844, 10102.0332)

    elseif lvl >= 2675 and lvl <= 2699 then
        MonNew = "Ocean Prophet"
        LevelQuestNew = 2
        NameQuestNew = "SubmergedQuest2"
        NameMonNew = "Ocean Prophet"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(11056.1445, -2001.6717, 10117.4493)

    elseif lvl >= 2700 and lvl <= 2724 then
        MonNew = "High Disciple"
        LevelQuestNew = 1
        NameQuestNew = "SubmergedQuest3"
        NameMonNew = "High Disciple"
        CFrameQuestNew = CFrame.new(9636.524, -1992.195, 9609.528)
        CFrameMonNew = CFrame.new(9828.088, -1940.909, 9693.064)

    elseif lvl >= 2725 then
        MonNew = "Grand Devotee"
        LevelQuestNew = 2
        NameQuestNew = "SubmergedQuest3"
        NameMonNew = "Grand Devotee"
        CFrameQuestNew = CFrame.new(9636.524, -1992.195, 9609.528)
        CFrameMonNew = CFrame.new(9557.585, -1928.040, 9859.183)

    else
        MonNew = "Coral Pirate"
        LevelQuestNew = 2
        NameQuestNew = "SubmergedQuest1"
        NameMonNew = "Coral Pirate"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(10965.1025, -2158.8842, 9177.2597)
    end
end
v485:AddToggle({
    Name = "Auto Farm Level",
    Flag = "S-Level",
    Description = "Farm Level",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        StopTween(_G.AutoFarm)
    end
})
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local currentLevel = LocalPlayer.Data.Level.Value                
                if currentLevel >= 2600 and World3 then
                      if not IsInSubmerged() then
                           GoSubmerged()
                    end
              end                
                if currentLevel >= 2600 and World3 and IsInSubmerged() then
                    CheckQuestNew()
                    
                    local questGui = LocalPlayer.PlayerGui.Main.Quest
                    if not questGui.Visible then
                        StartBring = false
                        if (HRP().Position - CFrameQuestNew.Position).Magnitude > 20 then
                            TweenTo(CFrameQuestNew)
                        else
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuestNew, LevelQuestNew)
                        end
                    else
                        local questText = questGui.Container.QuestTitle.Title.Text
                        if not string.find(questText, NameMonNew) then
                            StartBring = false
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        else
                            for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if mob.Name == MonNew and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        AutoHaki()
                                        topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                        mob.HumanoidRootPart.CanCollide = false
                                        mob.Humanoid.WalkSpeed = 0
                                        mob.Head.CanCollide = false
                                        mob.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                        StartBring = true
                                        MonFarm = mob.Name
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    until not _G.AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent or not questGui.Visible
                                end
                            end
                            
                            if not game:GetService("Workspace").Enemies:FindFirstChild(MonNew) then
                                TweenTo(CFrameMonNew)
                                StartBring = false
                            end
                        end
                    end
                elseif not IsInSubmerged() then
                     local l_Text_0 = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    CheckQuest()
                    if not string.find(l_Text_0, NameMon) then
                        StartBring = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                            if not string.find(l_Text_0, "kissed") then
                                if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                                    for _, v512 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                        if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name == Mon then
                                            if not string.find(l_Text_0, NameMon) then
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            else
                                                repeat
                                                    task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    AutoHaki()
                                                    PosMon = v512.HumanoidRootPart.CFrame
                                                    topos(FarmModePosition(v512.HumanoidRootPart.Position))
                                                    v512.HumanoidRootPart.CanCollide = false
                                                    v512.Humanoid.WalkSpeed = 0
                                                    v512.Head.CanCollide = false
                                                    v512.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                                    StartBring = true
                                                    MonFarm = v512.Name
                                                    game:GetService("VirtualUser"):CaptureController()
                                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v512.Humanoid.Health <= 0 or not v512.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            end
                                        end
                                    end
                                else
                                    TP1(CFrameMon)
                                    StartBring = false
                                    if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                    end
                                end
                            else
                                for _, v514 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if string.find(v514.Name, "kissed Warrior") then
                                        if v514:FindFirstChild("HumanoidRootPart") and v514:FindFirstChild("Humanoid") and v514.Humanoid.Health > 0 then
                                            if string.find(l_Text_0, NameMon) then
                                                repeat
                                                    task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    PosMon = v514.HumanoidRootPart.CFrame
                                                    topos(FarmModePosition(v514.HumanoidRootPart.Position))
                                                    v514.HumanoidRootPart.CanCollide = false
                                                    v514.Humanoid.WalkSpeed = 0
                                                    v514.Head.CanCollide = false
                                                    v514.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                                    StartBring = true
                                                    MonFarm = v514.Name
                                                    game:GetService("VirtualUser"):CaptureController()
                                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v514.Humanoid.Health <= 0 or not v514.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            else
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    else
                                        TP1(CFrameMon)
                                        StartBring = false
                                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                        end
                                    end
                                end
                            end
                        end
                    else
                        StartBring = false
                        if BypassTP then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 1500 then
                                TP1(CFrameQuest)
                            else
                                TP1(CFrameQuest)
                            end
                        else
                            TP1(CFrameQuest)
                        end
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 20 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                        end
                    end
                end
            end)
        end
    end
end)

_G.AutoFarmDistance = 5000

v485:AddToggle({
    Name = "Auto Farm Nearest",
    Description = "Auto Farm Nearest Mobs",
    Default = false,
    Callback = function(v520)
        _G.AutoNear = v520
        StopTween(_G.AutoNear)
    end
})
spawn(function()
    while wait() do
        if _G.AutoNear then
            pcall(function()
                for _, v522 in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v522:FindFirstChild("Humanoid") and v522:FindFirstChild("HumanoidRootPart") and v522.Humanoid.Health > 0 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v522.HumanoidRootPart.Position).Magnitude <= _G.AutoFarmDistance then
                        repeat
                            wait(_G.Fast_Delay)
                            StartBring = true
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            topos(v522.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            v522.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v522.HumanoidRootPart.Transparency = 1
                            v522.Humanoid.JumpPower = 0
                            v522.Humanoid.WalkSpeed = 0
                            v522.HumanoidRootPart.CanCollide = false
                            FarmPos = v522.HumanoidRootPart.CFrame
                            MonFarm = v522.Name
                        until not _G.AutoNear or not v522.Parent or v522.Humanoid.Health <= 0 or not game.Workspace.Enemies:FindFirstChild(v522.Name)
                        StartBring = false
                    end
                end
            end)
        end
    end
end)

if World3 then  
v485:AddToggle({  
    Name = "Auto Pirates Sea",  
    Description = "Auto Finish Pirate Raid in Sea Castle",  
    Default = false,  
    Callback = function(v543)  
        _G.AutoRaidPirate = v543  
        StopTween(_G.AutoRaidPirate)  
    end  
})  

spawn(function()  
    while wait() do  
        if _G.AutoRaidPirate then  
            pcall(function()  
                local v544 = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015E-9, 0.380223751, 3.5881019E-8, 1, -1.06665446E-7, -0.380223751, 1.12297109E-7, 0.924894512)  
                local CheckPos = CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125)  
                local Root = game.Players.LocalPlayer.Character.HumanoidRootPart  
                local HasEnemy = false  
                for _, e in pairs(workspace.Enemies:GetChildren()) do  
                    if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then  
                        if (e.HumanoidRootPart.Position - v544.Position).Magnitude <= 3000 then  
                            HasEnemy = true  
                            break  
                        end  
                    end  
                end  
                if not HasEnemy then  
                    TP1(v544)  
                    return  
                end  
                if (CheckPos.Position - Root.Position).Magnitude <= 500 then  
                    for _, v546 in pairs(workspace.Enemies:GetChildren()) do  
                        if _G.AutoRaidPirate and v546:FindFirstChild("HumanoidRootPart") and v546:FindFirstChild("Humanoid") and v546.Humanoid.Health > 0 and (v546.HumanoidRootPart.Position - Root.Position).Magnitude < 2000 then  
                            repeat  
                                task.wait()  
                                AutoHaki()  
                                EquipWeapon(_G.SelectWeapon)  
                                NeedAttacking = true  
                                StartMagnet = true  
                                v546.HumanoidRootPart.CanCollide = false  
                                v546.HumanoidRootPart.Size = Vector3.new(60, 60, 60)  
                                topos(FarmModePosition(mob.HumanoidRootPart.Position))
                            until v546.Humanoid.Health <= 0 or not v546.Parent or not _G.AutoRaidPirate  
                            NeedAttacking = false  
                            StartMagnet = false  
                        end  
                    end  
                else  
                    TP1(v544)  
                end  
            end)  
        end  
    end  
end)  
end
if World2 then
    v485:AddToggle({
        Name = "Auto Factory",
        Description = "Spawns Every 1:30 [hours, Minutes]",
        Default = false,
        Callback = function(v732)
            _G.AutoFactory = v732
            StopTween(_G.AutoFactory)
        end
    })
    spawn(function()
        while wait() do
            spawn(function()
                if _G.AutoFactory then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Core") then
                        for _, v734 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v734.Name == "Core" and v734.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    topos(CFrame.new(448.46756, 199.356781, -441.389252))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                until v734.Humanoid.Health <= 0 or _G.AutoFactory == false
                            end
                        end
                    else
                        topos(CFrame.new(448.46756, 199.356781, -441.389252))
                    end
                end
            end)
        end
    end)
 end
if World2 then
v485:AddSection("Ectoplasm")
v485:AddToggle({
    Name = "Auto Farm Ectoplasm",
    Flag = "S-FarnEcto",
    Description = "",
    Default = false,
    Callback = function(v1)
        _G.AutoEctoplasm = v1
        StopTween(_G.AutoEctoplasm)
    end
})

task.spawn(function()
    local MaterialMon = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}
    local MaterialPos = CFrame.new(911.35, 125.95, 33159.53)
    local Entrance = Vector3.new(923.21, 126.97, 32852.83)

    while task.wait(0.2) do
        if _G.AutoEctoplasm then
            pcall(function()
                local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
                local Found = false

                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if table.find(MaterialMon, v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        Found = true
                        repeat
                            task.wait()
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            topos(FarmModePosition(v.HumanoidRootPart.Position))
                        until not _G.AutoEctoplasm or not v.Parent or v.Humanoid.Health <= 0
                    end
                end

                if not Found then
                    UnEquipWeapon(_G.SelectWeapon)

                    if (MaterialPos.Position - Root.Position).Magnitude > 18000 then
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Entrance)
                    end

                    topos(MaterialPos)
                end
            end)
        end
    end
end)
end
if World3 then
v485:AddSection("Bones")
local Bone = v485:AddParagraph(
     "Bone",
     ""
)
spawn(function()
    pcall(function()
        while wait() do
            local bones = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
            Bone:SetDesc("You Have : " .. tostring(bones) .. " Bones")
        end
    end)
end)
v485:AddToggle({
    Name = "Auto Farm Bones",
    Description = "Farm Bones automatically",
    Default = false,
    Callback = function(v591)
        _G.FarmBone = v591
        StopTween(_G.FarmBone)
    end
})
spawn(function()
    while wait() do
        local v592 = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)
        do
            local l_v592_0 = v592
            if _G.FarmBone and World3 then
                pcall(function()
                    if not BypassTP then
                        TP1(l_v592_0)
                    elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - l_v592_0.Position).Magnitude > 2000 then
                        TP1(l_v592_0)
                        wait(0.1)
                        for _ = 1, 8 do
                            game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(l_v592_0)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            wait(0.1)
                        end
                    elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - l_v592_0.Position).Magnitude < 2000 then
                        TP1(l_v592_0)
                    end
                    if not game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") and not game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") and not game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") and not game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy") then
                        StartBring = false
                        topos(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
                        for _, v596 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                            if v596.Name == "Reborn Skeleton" then
                                topos(v596.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                            elseif v596.Name ~= "Living Zombie" then
                                if v596.Name ~= "Demonic Soul" then
                                    if v596.Name == "Posessed Mummy" then
                                        topos(v596.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                    end
                                else
                                    topos(v596.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                end
                            else
                                topos(v596.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                            end
                        end
                    else
                        for _, v598 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if (v598.Name == "Reborn Skeleton" or v598.Name == "Living Zombie" or v598.Name == "Demonic Soul" or v598.Name == "Posessed Mummy") and v598:FindFirstChild("Humanoid") and v598:FindFirstChild("HumanoidRootPart") and v598.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    NoAttackAnimation = true
                                    NeedAttacking = true
                                    EquipWeapon(_G.SelectWeapon)
                                    v598.HumanoidRootPart.CanCollide = false
                                    v598.Humanoid.WalkSpeed = 0
                                    v598.Head.CanCollide = false
                                    StartBring = true
                                    MonFarm = v598.Name
                                    PosMon = v598.HumanoidRootPart.CFrame
                                    topos(FarmModePosition(v598.HumanoidRootPart.Position))
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.FarmBone or not v598.Parent or v598.Humanoid.Health <= 0
                            end
                        end
                    end
                end)
            end
        end
    end
end)
v485:AddToggle({
    Name = "Auto Kill Soul Reaper",
    Description = "Spawning and killing Soul Reaper",
    Flag = "S-KillSoul",
    Default = false,
    Callback = function(v599)
        _G.Hallow = v599
        StopTween(_G.Hallow)
    end
})
spawn(function()
    while wait() do
        if _G.Hallow then
            pcall(function()
                if not game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                        repeat
                            TP1(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
                            wait()
                        until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8
                        EquipWeapon("Hallow Essence")
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                else
                    for _, v601 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if string.find(v601.Name, "Soul Reaper") then
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                AutoHaki()
                                v601.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                topos(v601.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                v601.HumanoidRootPart.Transparency = 1
                            until v601.Humanoid.Health <= 0 or _G.Hallow == false
                        end
                    end
                end
            end)
        end
    end
end)
v485:AddToggle({
    Name = "Auto Trade Bones",
    Description = "Automatically trade bones for rewards",
    Flag = "S-TradeB",
    Default = false,
    Callback = function(v602)
        _G.Rdbone = v602
        StopTween(_G.Rdbone)
    end
})
spawn(function()
    while wait(0.1) do
        if _G.Rdbone then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
        end
    end
end)
v485:AddToggle({
    Name = "Auto Pray",
    Flag = "S-Pry",
    Description = "Pray",
    Default = false,
    Callback = function(v603)
        _G.Pray = v603
        StopTween(_G.Pray)
    end
})
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Pray then
                TP1(CFrame.new(-8652.99707, 143.450119, 6170.50879, -0.983064115, -2.48005533E-10, 0.18326205, -1.78910387E-9, 1, -8.24392288E-9, -0.18326205, -8.43218029E-9, -0.983064115))
                wait()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 1)
            end
        end
    end)
end)
v485:AddToggle({
    Name = "Auto Try Luck",
    Flag = "S-Try",
    Description = "Try Luck",
    Default = false,
    Callback = function(v604)
        _G.Trylux = v604
        StopTween(_G.Trylux)
    end
})
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Trylux then
                TP1(CFrame.new(-8652.99707, 143.450119, 6170.50879, -0.983064115, -2.48005533E-10, 0.18326205, -1.78910387E-9, 1, -8.24392288E-9, -0.18326205, -8.43218029E-9, -0.983064115))
                wait()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
             end
         end
     end)
  end)
end


v485:AddSection("Chest")
v485:AddToggle({
    Name = "Auto Chest [ Tween ]",
    Flag = "AutoChest[Tween]",
    Default = false,
    Callback = function(v)
        FarmChest = v

        if not v then
            TweenModule:Stop()
        end
    end
})

task.spawn(function()
    while task.wait() do
        if FarmChest then
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

            if not Character then
                continue
            end

            local Position = Character:GetPivot().Position
            local Chests = game:GetService("CollectionService"):GetTagged("_ChestTagged")

            local ClosestChest
            local ClosestDistance = math.huge

            for _, Chest in ipairs(Chests) do
                if not Chest:GetAttribute("IsDisabled") then
                    local Distance = (Chest:GetPivot().Position - Position).Magnitude

                    if Distance < ClosestDistance then
                        ClosestDistance = Distance
                        ClosestChest = Chest
                    end
                end
            end

            if ClosestChest and not TweenModule:IsTweening() then
                TweenModule:Teleport(CFrame.new(ClosestChest:GetPivot().Position))
            end
        end
    end
end)
v485:AddToggle({
    Title = "Auto Chest [ Bypass ]",
    Value = false,
    Callback = function(v)
        ChestBypass = v
    end
})

task.spawn(function()
    while task.wait() do
        if ChestBypass then
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local CollectionService = game:GetService("CollectionService")

            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local startTick = tick()

            while ChestBypass and (tick() - startTick) < 4 do
                character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local charPos = character:GetPivot().Position
                local chests = CollectionService:GetTagged("_ChestTagged")

                local closest, dist = nil, math.huge
                for i = 1, #chests do
                    local chest = chests[i]
                    if not chest:GetAttribute("IsDisabled") then
                        local d = (chest:GetPivot().Position - charPos).Magnitude
                        if d < dist then
                            dist = d
                            closest = chest
                        end
                    end
                end

                if closest then
                    character:PivotTo(CFrame.new(closest:GetPivot().Position))
                    task.wait(0.2)
                else
                    break
                end
            end

            if ChestBypass and LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
                LocalPlayer.CharacterAdded:Wait()
            end
        end
    end
end)


local StopOnRare = false

v485:AddToggle({
    Name = "Stop When Get Item",
    Description = "Stop collecting Chests if you find God's Chalice or Fist of Darkness.",
    Default = true,
    Callback = function(v)
        StopOnRare = v
    end
})

task.spawn(function()
    while task.wait() do
        if StopOnRare then
            local plr = game:GetService("Players").LocalPlayer
            local char = plr.Character

            if plr.Backpack:FindFirstChild("God's Chalice")
            or plr.Backpack:FindFirstChild("Fist of Darkness")
            or (char and char:FindFirstChild("God's Chalice"))
            or (char and char:FindFirstChild("Fist of Darkness")) then

                _G.FarmChest = false
                ChestBypass = false

                StopTween(true)

                if char and char:FindFirstChild("HumanoidRootPart") then
                    topos(char.HumanoidRootPart.CFrame)
                end
            end
        end
    end
end)
v485:AddSection("Kill Player")
if World3 then
local v1123 = {}
for _, v1125 in pairs(game.Players:GetPlayers()) do
    table.insert(v1123, v1125.Name)
end
local _ = nil
v485:AddButton({
    Title = "⚠️Get Quest Elite Players",
    Description = "",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
    end
})
v485:AddToggle({
    Title = "Auto Kill Player Quest",
    Description = "Kill Player Quest",
    Flag = "Kill Player",
    Value = false,
    Callback = function(v1127)
        _G.AutoPlayerHunter = v1127
        StopTween(_G.AutoPlayerHunter)
    end
})
spawn(function()
    game:GetService("RunService").Heartbeat:connect(function()
        pcall(function()
            if _G.AutoPlayerHunter and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
                game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
            end
        end)
    end)
end)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.AutoPlayerHunter and game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
        end
    end)
end)
spawn(function()
    while wait() do
        if _G.AutoPlayerHunter then
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
            else
                for _, v1129 in pairs(game:GetService("Workspace").Characters:GetChildren()) do
                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, v1129.Name) then
                        repeat
                            wait()
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            Useskill = true
                            topos(v1129.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
                            v1129.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        until _G.AutoPlayerHunter == false or v1129.Humanoid.Health <= 0
                        Useskill = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                      end
                  end
              end
          end
      end
   end)
end
v485:AddToggle({
    Name = "Auto Safe Mode",
    Description = "",
    Default = false,
    Callback = function(v1130)
        _G.SafeMode = v1130
        StopTween(_G.SafeMode)
    end
})
spawn(function()
    pcall(function()
        while wait() do
            if _G.SafeMode then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 200, 0)
            end
        end
    end)
end)
local function EquipWeapon()
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")  
    if not hum then return end  

    if _G.SelectWeapon then  
        local tool = plr.Backpack:FindFirstChild(_G.SelectWeapon)  
            or char:FindFirstChild(_G.SelectWeapon)  
        if tool and tool.Parent ~= char then  
            hum:EquipTool(tool)  
        end  
    end
end

local function GoToBoss(targetBoss)
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not targetBoss or not hrp or not hum then return end
    
    local bossHRP = targetBoss:FindFirstChild("HumanoidRootPart") or targetBoss:FindFirstChild("Torso")
    if not bossHRP then return end

    local safeHeight = 22   
    local targetPos = bossHRP.Position + Vector3.new(0, safeHeight, 0)  
    local targetCFrame = CFrame.new(targetPos)  
    local distToSafeSpot = (hrp.Position - targetPos).Magnitude  

    EquipWeapon()  

    if distToSafeSpot <= 5 then  
        hrp.CFrame = targetCFrame  
        hrp.Velocity = Vector3.zero  
        hrp.AssemblyLinearVelocity = Vector3.zero 
        hum.AutoRotate = false 
       
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
    else  
        if TP1 then TP1(targetCFrame) else hrp.CFrame = targetCFrame end
    end
end
v485:AddSection("Bosses")
local v658 = {}

if World1 then
    v658 = {
        "The Gorilla King",
        "Chef",
        "Yeti",
        "Mob Leader",
        "Vice Admiral",
        "Warden",
        "Chief Warden",
        "Swan",
        "Magma Admiral",
        "Fishman Lord",
        "Wysper",
        "Thunder God",
        "Cyborg",
        "Saber Expert"
    }
elseif World2 then
    v658 = {
        "Diamond",
        "Jeremy",
        "Fajita",
        "Don Swan",
        "Smoke Admiral",
        "Cursed Captain",
        "Darkbeard",
        "Order",
        "Awakened Ice Admiral",
        "Tide Keeper"
    }
elseif World3 then
    v658 = {
        "",
        "Tyrant of the Skies",
        "Stone",
        "Island Empress",
        "Kilo Admiral",
        "Captain Elephant",
        "Beautiful Pirate",
        "rip_indra True Form",
        "Longma",
        "Soul Reaper",
        "Cake Queen"
    }
end

local function IsBossSpawned(name)
    return game:GetService("ReplicatedStorage"):FindFirstChild(name)
        or game:GetService("Workspace").Enemies:FindFirstChild(name)
end

local BossDropdown

local function UpdateBossList()
    local updated = {}

    for _, boss in ipairs(v658) do
        if boss ~= "" and IsBossSpawned(boss) then
            table.insert(updated, boss)
        end
    end

    if #updated == 0 then
        table.insert(updated, "...")
    end

    pcall(function()
        if BossDropdown then
            BossDropdown:Clear()
            BossDropdown:Add(updated)
        end
    end)
end

BossDropdown = v485:AddDropdown({
    Name = "Boss List",
    Options = {"..."},
    Default = nil,
    Callback = function(v)
        _G.SelectBoss = v
    end
})

task.spawn(function()
    while true do
        UpdateBossList()
        task.wait(3)
    end
end)
v485:AddToggle({
    Name = "Auto Kill Boss Selected",
    Description = "Kill boss Selected",
    Default = false,
    Callback = function(v)
        _G.AutoBoss = v
        StopTween(_G.AutoBoss)
    end
})

v485:AddToggle({
    Name = "Auto Farm All Bosses",
    Description = "",
    Default = false,
    Callback = function(v)
        _G.FarmAllBoss = v
        if v then _G.AutoBoss = false end
        _G.CurrentTargetBoss = nil
    end
})
spawn(function()
    while task.wait() do 
        if not _G.FarmAllBoss then
            task.wait(0.5)
            continue
        end

        if _G.CurrentTargetBoss and _G.CurrentTargetBoss.Parent and _G.CurrentTargetBoss:FindFirstChild("Humanoid") and _G.CurrentTargetBoss.Humanoid.Health > 0 then
            task.wait(0.2) 
            continue
        end

        local char = plr.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then task.wait(0.5) continue end

        local potentialBosses = {}
        local foundInWorkspace = false

        local function FastScan(container, isRS)
            for _, v in pairs(container:GetDescendants()) do
                if v:IsA("Model") and v:GetAttribute("IsBoss") == true then
                    if v.Name ~= "Cursed Skeleton Boss" then
                        local h = v:FindFirstChild("Humanoid")
                        local hrp = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso")
                        if h and h.Health > 0 and hrp then
                            local dist = (myHrp.Position - hrp.Position).Magnitude
                            if isRS then
                                table.insert(potentialBosses, {Model = v, Distance = dist + 10000})
                            else
                                table.insert(potentialBosses, {Model = v, Distance = dist})
                                foundInWorkspace = true
                            end
                        end
                    end
                end
            end
        end

        FastScan(WS, false)
        if not foundInWorkspace then FastScan(RS, true) end

        if #potentialBosses > 0 then
            table.sort(potentialBosses, function(a, b) return a.Distance < b.Distance end)
            _G.CurrentTargetBoss = potentialBosses[1].Model
        else
            _G.CurrentTargetBoss = nil
        end
        task.wait(0.2)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoBoss and _G.FindBoss then
                if QuestB then QuestB() end
                
                local NeedQuest = false
                local char = plr.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                if _G.AutoAcceptQuest and Qname and Qdata and PosQBoss then
                    local playerGui = plr.PlayerGui:FindFirstChild("Main") and plr.PlayerGui.Main:FindFirstChild("Quest")
                    local hasQuest = playerGui and playerGui.Visible
                    if not hasQuest then NeedQuest = true end
                end

                if NeedQuest then
                    if (PosQBoss.Position - char.HumanoidRootPart.Position).Magnitude <= 5 then
                        RS.Remotes.CommF_:InvokeServer("StartQuest", Qname, Qdata)
                    else
                        if TP1 then TP1(PosQBoss) else char.HumanoidRootPart.CFrame = PosQBoss end
                    end
                    return
                end

                local specificBoss = WS:FindFirstChild("Enemies") and WS.Enemies:FindFirstChild(_G.FindBoss) or WS:FindFirstChild(_G.FindBoss)
                if specificBoss and specificBoss:FindFirstChild("Humanoid") and specificBoss.Humanoid.Health > 0 then 
                    GoToBoss(specificBoss)
                elseif PosB then 
                    if TP1 then TP1(PosB) else char.HumanoidRootPart.CFrame = PosB end
                end        
            elseif _G.FarmAllBoss then
                if _G.CurrentTargetBoss then
                    GoToBoss(_G.CurrentTargetBoss)
                end
            end
        end)
    end
end)

spawn(function()
    while task.wait(0.5) do
        if plr.Backpack and _G.ChooseWP then
            for _, e in pairs(plr.Backpack:GetChildren()) do
                if e.ToolTip == _G.ChooseWP then _G.SelectWeapon = e.Name end
            end
        end
    end
end)

v485:AddToggle({
    Name = "Take Boss Quest",
    Description = "Auto takes the boss quest",
    Default = true,
    Flag = "B-Quest",
    Callback = function(v)
        _G.AutoAcceptQuest = v
    end
})

task.spawn(function()
    while task.wait() do
        if _G.AutoBoss and _G.SelectBoss then
            pcall(function()
                _G.FindBoss = _G.SelectBoss
                if QuestB then QuestB() end

                local plr = game.Players.LocalPlayer
                local char = plr.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                if _G.AutoAcceptQuest and Qname and Qdata and PosQBoss then
                    local questUI = plr.PlayerGui:FindFirstChild("Main")
                        and plr.PlayerGui.Main:FindFirstChild("Quest")

                    local hasQuest = questUI and questUI.Visible

                    if not hasQuest then
                        if (char.HumanoidRootPart.Position - PosQBoss.Position).Magnitude <= 5 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Qname, Qdata)
                        else
                            topos(PosQBoss)
                        end
                        return
                    end
                end

                if not game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
                    if game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
                        topos(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                else
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == _G.SelectBoss and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                topos(FarmModePosition(v.HumanoidRootPart.Position))
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            until not _G.AutoBoss or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

v485:AddSection("Material")
local v664 = {}
if not World1 then
    if World2 then
        v664 = {"Radioactive", "Mystic Droplet", "Magma Ore", "Leather", "Ectoplasm", "Scrap Metal"}
    elseif World3 then
        v664 = {"Leather", "Scrap Metal", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}
    end
else
    v664 = {"Magma Ore", "Angel Wings", "Leather", "Scrap Metal"}
end
function getConfigMaterial(v665)
    if v665 ~= "Radioactive" or not World2 then
    if v665 ~= "Mystic Droplet" or not World2 then
    if v665 == "Magma Ore" and World1 then
        MaterialMon = {"Military Spy"}
        MaterialPos = CFrame.new(-5850.28, 77.28, 8848.67)
 elseif v665 ~= "Magma Ore" or not World2 then
    if v665 ~= "Angel Wings" or not World1 then
    if v665 ~= "Leather" or not World1 then
    if v665 ~= "Leather" or not World2 then
    if v665 ~= "Leather" or not World3 then
    if v665 ~= "Ectoplasm" or not World2 then
    if v665 ~= "Scrap Metal" or not World1 then
    if v665 == "Scrap Metal" and World2 then
         MaterialMon = {"Mercenary"}
         MaterialPos = CFrame.new(-972.3, 73.04, 1419.29)
 elseif v665 == "Scrap Metal" and World3 then
         MaterialMon = {"Pirate Millionaire"}
         MaterialPos = CFrame.new(-289.63, 43.82, 5583.66)
 elseif v665 ~= "Conjured Cocoa" or not World3 then
    if v665 == "Dragon Scale" and World3 then
         MaterialMon = {"Dragon Crew Warrior"}
         MaterialPos = CFrame.new(7023.62, 55.75, -696.68)
 elseif v665 == "Gunpowder" and World3 then
         MaterialMon = {"Pistol Billionaire"}
         MaterialPos = CFrame.new(-379.61, 73.84, 5928.52)
 elseif v665 ~= "Fish Tail" or not World3 then
     if v665 == "Mini Tusk" and World3 then
         MaterialMon = {"Mithological Pirate"}
         MaterialPos = CFrame.new(-13516.04, 469.81, -6899.16)
      end
   else
         MaterialMon = {"Fishman Captain"}
         MaterialPos = CFrame.new(-10961.01, 331.79, -8914.29)
        end
     else
         MaterialMon = {"Chocolate Bar Battler"}
         MaterialPos = CFrame.new(744.79, 24.76, -12637.72)
      end
    else
        MaterialMon = {"Brute"}
        MaterialPos = CFrame.new(-1132.42, 14.84, 4293.3)
    end
else
       MaterialMon = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}
       MaterialPos = CFrame.new(911.35, 125.95, 33159.53)
   end
else
      MaterialMon = {"Jungle Pirate"}
      MaterialPos = CFrame.new(-11975.78, 331.77, -10620.03)
   end
else
     MaterialMon = {"Marine Captain"}
     MaterialPos = CFrame.new(-2010.5, 73, -3326.62)
   end
else
      MaterialMon = {"Pirate"}
      MaterialPos = CFrame.new(-1211.87, 4.78, 3916.83)
   end
else
      MaterialMon = {"Royal Soldier"}
      MaterialPos = CFrame.new(-7827.15, 5606.91, -1705.58)
   end
else
      MaterialMon = {"Lava Pirate"}
      MaterialPos = CFrame.new(-5234.6, 51.95, -4732.27)
   end
else
     MaterialMon = {"Water Fighter"}
     MaterialPos = CFrame.new(-3352.9, 285.01, -10534.84)
  end
else
     MaterialMon = {"Factory Staff"}
     MaterialPos = CFrame.new(-507.78, 73, -126.45)
    end
end
v485:AddDropdown({
    Name = "Material List",
    Description = "",
    Options = v664,
    Default = v664[1],
    Callback = function(v666)
        _G.SelectMaterial = v666
    end
})
v485:AddToggle({
    Name = "Auto Farm Material",
    Description = "Farm Material selected",
    Default = false,
    Callback = function(v667)
        _G.AutoFarmMaterial = v667
        StopTween(_G.AutoFarmMaterial)
    end
})
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarmMaterial and _G.SelectMaterial then
            pcall(function()
                getConfigMaterial(_G.SelectMaterial)
                for _, v669 in pairs(MaterialMon) do
                    if workspace.Enemies:FindFirstChild(v669) then
                        for _, v671 in pairs(workspace.Enemies:GetChildren()) do
                            if v671.Name == v669 and v671:FindFirstChild("Humanoid") and v671:FindFirstChild("HumanoidRootPart") and v671.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    PosMon = v671.HumanoidRootPart.CFrame
                                    MonFarm = v671.Name
                                    topos(FarmModePosition(v671.HumanoidRootPart.Position))
                                until not _G.AutoFarmMaterial or not v671.Parent or v671.Humanoid.Health <= 0
                            end
                        end
                    else
                        UnEquipWeapon(_G.SelectWeapon)
                        if _G.SelectMaterial == "Ectoplasm" and (MaterialPos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 18000 then
                            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21, 126.97, 32852.83))
                        end
                        topos(MaterialPos)
                    end
                end
            end)
        end
    end
end)

if not BlackListExecutors then
v486:AddSection("Fishing")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local FishReplicated = RS:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local FishingClientConfig = require(FishReplicated:WaitForChild("FishingClient"):WaitForChild("Config"))
local GetWaterHeight = require(RS:WaitForChild("Util"):WaitForChild("GetWaterHeightAtLocation"))

local Net = RS:WaitForChild("Modules"):WaitForChild("Net")
local CraftRemote = Net:WaitForChild("RF/Craft")
local JobsRemote = Net:WaitForChild("RF/JobsRemoteFunction")
local ToolAbilities = Net:WaitForChild("RF/JobToolAbilities")

_G.SelectedRod = "Fishing Rod"
_G.SelectedBait = "Basic Bait"
_G.MaxBaits = 10
_G.AutoBuyBait = false
_G.AutoFishingQuest = false
_G.TakeQuestOnlyWhenFishing = false
_G.SkipQuestMode = "None"
_G.AutoSellFish = false
_G.SelectedFishKind = "All Fish"
_G.InstantCatch = false
_G.AutoSkillZ = false
_G.AutoFishing = false
_G.SelectedRod = "Fishing Rod"
_G.SavedFishPosition = nil

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local function TP(cf)
    local char = plr.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = cf
end

local function StartFishingLoop()
    task.spawn(function()
        while _G.AutoFishing do
            task.wait(0.1)

            pcall(function()
                local char = plr.Character or plr.CharacterAdded:Wait()
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                if _G.SavedFishPosition then
                    if (hrp.Position - _G.SavedFishPosition.Position).Magnitude > 6 then
                        TP(_G.SavedFishPosition)
                        return
                    end
                end

                EquipRod()

                local rod = char:FindFirstChild(_G.SelectedRod)
                if not rod then return end

                local state =
                    rod:GetAttribute("ServerState")
                    or rod:GetAttribute("State")

                if state == "Biting" then
                    CatchFish()
                elseif state == "ReeledIn"
                or state == "Idle"
                or not state then
                    CastLine()
                end
            end)
        end
    end)
end


local function EquipRod()
    local char = plr.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if char:FindFirstChild(_G.SelectedRod) then return end

    local rod = plr.Backpack:FindFirstChild(_G.SelectedRod)
    if rod then
        hum:EquipTool(rod)
    end
end


local function CastLine()
    pcall(function()
        FishingRequest:InvokeServer("StartCasting")
        task.wait()
        FishingRequest:InvokeServer("CastLineAtLocation", workspace.CurrentCamera.CFrame.Position,100,true)
    end)
end


local function CatchFish()
    pcall(function()
        FishingRequest:InvokeServer("Catching",true)
        task.wait(0.05)
        FishingRequest:InvokeServer("Catch",1)

        RedzNotify("Auto Fish","New Item Caught!",127664059821666,5)
    end)
end

 v486:AddToggle({
    Name = "Auto Fish",
    Default = false,
    Callback = function(v)
       _G.AutoFishing = v
         if v then
         StartFishingLoop()
     end
  end
})

v486:AddToggle({
    Name = "Auto use skill of the rod",
    Flag = "S-skillrod",
    Default = false,
    Callback = function(Value)
        _G.AutoSkillZ = Value
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSkillZ then
            pcall(function()
                ToolAbilities:InvokeServer("Z", true)
            end)
        end
    end
end)

v486:AddButton({
    Name = "Save Fish Position",
    Callback = function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then

            local Dialog = Window:Dialog({
                Title = "Save Position",
                Text = "Confirm to save this as your fishing position",
                Options = {
                    {"Cancel", function() end},
                    {"Confirm", function()
                        _G.SavedFishPosition = char.HumanoidRootPart.CFrame
                        RedzNotify("Save Manager","Position Saved!",10734941499,5)
                    end}
                }
            })

        end
    end
})

v486:AddSection("Bait")

v486:AddDropdown({
Name = "Select Bait",
Options = {
"Basic Bait",
"Kelp Bait",
"Good Bait",
"Abyssal Bait",
"Frozen Bait",
"Epic Bait",
"Carnivore Bait"
},
Default = nil,
Callback = function(v)
_G.SelectedBait = v
end
})

v486:AddSlider({
Name = "Max Baits",
Min = 1,
Max = 90,
Default = 10,
Callback = function(v)
_G.MaxBaits = v
end
})

v486:AddToggle({
Name = "Auto Buy Baits",
Default = false,
Callback = function(v)
_G.AutoBuyBait = v
end
})

v486:AddButton({
Name = "Buy Bait",
Callback = function()
pcall(function()
CraftRemote:InvokeServer("Craft", _G.SelectedBait, {})
end)
end
})

task.spawn(function()
while task.wait(2) do
if _G.AutoBuyBait then
pcall(function()
for i = 1, _G.MaxBaits do
CraftRemote:InvokeServer("Craft", _G.SelectedBait, {})
task.wait(0.1)
end
end)
end
end
end)

task.spawn(function()
while task.wait(0.5) do
if _G.AutoFishing then

pcall(function()

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
local head = char:FindFirstChild("Head")

if hrp and hum and head then

if _G.SavedFishPosition then
hrp.CFrame = _G.SavedFishPosition
end

local equippedTool = char:FindFirstChildOfClass("Tool")

if _G.SelectedRod and (not equippedTool or equippedTool.Name ~= _G.SelectedRod) then
local rod = plr.Backpack:FindFirstChild(_G.SelectedRod)
if rod then
hum:EquipTool(rod)
equippedTool = rod
end
end

if equippedTool and equippedTool.Name == _G.SelectedRod then

local maxLaunch = FishingClientConfig.Rod.MaxLaunchDistance
local waterHeight = 0

pcall(function()
waterHeight = GetWaterHeight(hrp.Position)
end)

local rayOrigin = head.Position
local rayDirection = hrp.CFrame.LookVector * maxLaunch

local ignore = {char, Workspace:FindFirstChild("Characters"), Workspace:FindFirstChild("Enemies")}
local _, hitPos = Workspace:FindPartOnRayWithIgnoreList(Ray.new(rayOrigin, rayDirection), ignore)

local targetPos = hitPos and Vector3.new(hitPos.X, math.max(hitPos.Y, waterHeight), hitPos.Z)

local state = equippedTool:GetAttribute("State")
local serverState = equippedTool:GetAttribute("ServerState")

if targetPos and (state == "ReeledIn" or serverState == "ReeledIn") then
FishingRequest:InvokeServer("StartCasting")
task.wait()
FishingRequest:InvokeServer("CastLineAtLocation", targetPos, 100, true)

elseif serverState == "Biting" then
FishingRequest:InvokeServer("Catching", true)
task.wait(0.1)
FishingRequest:InvokeServer("Catch", 1)
end

end
end

end)

end
end
end)
v486:AddSection("Quest")

v486:AddDropdown({
    Name = "Skip Quests",
    Options = {
        "None",
        "Skip Get",
        "Skip Complete",
        "Skip Get, Complete"
    },
    Default = nil,
    Callback = function(v)
        _G.SkipQuestMode = v
    end
})

v486:AddToggle({
    Name = "Auto Quest [Skip Get, Complete]",
    Default = false,
    Callback = function(v)
        _G.AutoFishingQuest = v
    end
})

v486:AddToggle({
    Name = "Take Quest Only When Fishing",
    Default = false,
    Callback = function(v)
        _G.TakeQuestOnlyWhenFishing = v
    end
})

local function HasQuest()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local questGui = playerGui:FindFirstChild("Quest") or playerGui:FindFirstChild("QuestGui")
        if questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") then
            return true
        end
    end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFishingQuest then
            pcall(function()

                if _G.TakeQuestOnlyWhenFishing and not _G.AutoFishing then
                    return
                end

                if not HasQuest() then
                    if _G.SkipQuestMode ~= "Skip Get" and _G.SkipQuestMode ~= "Skip Get, Complete" then
                        JobsRemote:InvokeServer("FishingNPC","Angler","AskQuest")
                    end
                end

            end)
        end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if _G.AutoFishingQuest then
            pcall(function()

                if _G.SkipQuestMode ~= "Skip Complete" and _G.SkipQuestMode ~= "Skip Get, Complete" then
                    JobsRemote:InvokeServer("FishingNPC","FinishQuest")
                end

            end)
        end
    end
end)

v486:AddSection("Sell")

v486:AddDropdown({
    Name = "Select Fish Kind",
    Options = {
        "All Fish",
        "Common",
        "Rare",
        "Legendary"
    },
    Default = nil,
    Callback = function(v)
        _G.SelectedFishKind = v
    end
})

v486:AddToggle({
    Name = "Auto Sell Fish",
    Default = false,
    Callback = function(v)
        _G.AutoSellFish = v
    end
})

task.spawn(function()
    while task.wait(5) do
        if _G.AutoSellFish then
            pcall(function()

                if _G.SelectedFishKind == "All Fish" then
                    JobsRemote:InvokeServer("FishingNPC","SellFish")

                else
                    JobsRemote:InvokeServer(
                        "FishingNPC",
                        "SellFishByKind",
                        _G.SelectedFishKind
                    )
                end

            end)
        end
    end
end)
v486:AddSection("Manual")
v486:AddToggle({
    Name = "Instant Catch",
    Flag = "S-Insta",
    Default = false,
    Callback = function(v)
        _G.InstantCatch = v
    end
})

task.spawn(function()
    while task.wait(0.1) do
        if _G.InstantCatch then
            pcall(function()

                local plr = game.Players.LocalPlayer
                local char = plr.Character
                if not char then return end

                local tool = char:FindFirstChildOfClass("Tool")
                if not tool then return end

                if tool:GetAttribute("ServerState") == "Biting" then
                    FishingRequest:InvokeServer("Catching", true)
                    task.wait()
                    FishingRequest:InvokeServer("Catch", 1)
                end

            end)
        end
    end
end)
end

if World1 then
    v487:AddSection("Second Sea")
    v487:AddToggle({
        Name = "Auto Second Sea",
        Description = "Unlocks access to the Second sea (requires Level 700)",
        Default = false,
        Callback = function(v693)
            _G.AutoSecondSea = v693
            StopTween(_G.AutoSecondSea)
        end
    })
    spawn(function()
        while wait() do
            if _G.AutoSecondSea then
                pcall(function()
                    if game.Players.LocalPlayer.Data.Level.Value >= 700 and World1 then
                        _G.AutoFarm = false
                        if game.Workspace.Map.Ice.Door.CanCollide == true and game.Workspace.Map.Ice.Door.Transparency == 0 then
                            repeat
                                wait()
                                topos(CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563))
                            until (CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoSecondSea
                            wait(1)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                            EquipWeapon("Key")
                            local v694 = CFrame.new(1347.7124, 37.3751602, -1325.6488)
                            repeat
                                wait()
                                topos(v694)
                            until (v694.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoSecondSea
                            wait(3)
                        elseif game.Workspace.Map.Ice.Door.CanCollide ~= false or game.Workspace.Map.Ice.Door.Transparency ~= 1 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
                        elseif game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral") then
                            for _, v696 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v696.Name == "Ice Admiral" and v696.Humanoid.Health > 0 then
                                    repeat
                                        wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v696.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v696.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v696.HumanoidRootPart.Transparency = 1
                                        topos(v696.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 870), workspace.CurrentCamera.CFrame)
                                    until v696.Humanoid.Health <= 0 or not v696.Parent or not _G.AutoSecondSea
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
                                end
                            end
                        else
                            topos(CFrame.new(1347.7124, 37.3751602, -1325.6488))
                        end
                    end
                end)
            end
        end
    end)
    v487:AddSection("Boss Greybeard")
    v487:AddToggle({
        Name = "Auto Kill Greybeard",
        Description = "Kill Greybeard",
        Default = false,
        Callback = function(v698)
            _G.Greybeard = v698
            StopTween(_G.Greybeard)
        end
    })
    spawn(function()
        while wait() do
            if _G.Greybeard then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Greybeard") then
                        for _, v700 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v700.Name == "Greybeard" and v700:FindFirstChild("Humanoid") and v700:FindFirstChild("HumanoidRootPart") and v700.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v700.HumanoidRootPart.CanCollide = false
                                    v700.Humanoid.WalkSpeed = 0
                                    v700.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.Greybeard or not v700.Parent or v700.Humanoid.Health <= 0
                            end
                        end
                    else
                        topos(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375))
                        if not game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard") then
                            if _G.Greybeardhop then
                                Hop()
                            end
                        else
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                end)
            end
        end
    end)
    v487:AddSection("Quest Sword")
    v487:AddToggle({
        Name = "Auto Get Saber",
        Description = "Auto Kill Saber Expert",
        Default = false,
        Callback = function(v702)
            _G.AutoSaber = v702
            StopTween(_G.AutoSaber)
        end
    })
    spawn(function()
        while task.wait() do
            if _G.AutoSaber and game.Players.LocalPlayer.Data.Level.Value >= 200 then
                pcall(function()
                    if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency ~= 0 then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert") then
                            for _, v704 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v704:FindFirstChild("Humanoid") and v704:FindFirstChild("HumanoidRootPart") and v704.Humanoid.Health > 0 and v704.Name == "Saber Expert" then
                                    repeat
                                        task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                        v704.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v704.HumanoidRootPart.Transparency = 1
                                        v704.Humanoid.JumpPower = 0
                                        v704.Humanoid.WalkSpeed = 0
                                        v704.HumanoidRootPart.CanCollide = false
                                        FarmPos = v704.HumanoidRootPart.CFrame
                                        MonFarm = v704.Name
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672), workspace.CurrentCamera.CFrame)
                                    until v704.Humanoid.Health <= 0 or not _G.AutoSaber
                                    if v704.Humanoid.Health <= 0 then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                                    end
                                end
                            end
                        end
                    elseif game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency == 0 then
                        if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151E-9, -0.928667724, 3.97099491E-8, 1, 1.91679348E-8, 0.928667724, -4.39869794E-8, 0.37091279).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 100 then
                            topos(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151E-9, -0.928667724, 3.97099491E-8, 1, 1.91679348E-8, 0.928667724, -4.39869794E-8, 0.37091279))
                        else
                            topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate1.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate2.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate3.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate4.Button.CFrame
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate5.Button.CFrame
                            wait(1)
                        end
                    elseif game:GetService("Workspace").Map.Desert.Burn.Part.Transparency == 0 then
                        if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
                            EquipWeapon("Torch")
                            topos(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094E-9, 0.761243105, -5.70652914E-10, 1, 1.20584542E-9, -0.761243105, 3.47544882E-10, -0.648466587))
                        else
                            topos(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805E-5, -0.258850515, 0.965917408))
                        end
                    elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") ~= 0 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
                        wait(0.5)
                        EquipWeapon("Cup")
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", game:GetService("Players").LocalPlayer.Character.Cup)
                        wait(0)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
                    elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == "RichSon" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                    elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= 0 then
                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                            wait(0.5)
                            EquipWeapon("Relic")
                            wait(0.5)
                            topos(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877E-9, 0.481375456, 2.53851997E-8, 1, -5.79995607E-8, -0.481375456, 6.30572643E-8, 0.876514494))
                        end
                    elseif game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") or game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
                        topos(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559))
                        for _, v706 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v706.Name == "Mob Leader" then
                                if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") and v706:FindFirstChild("Humanoid") and v706:FindFirstChild("HumanoidRootPart") and v706.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v706.HumanoidRootPart.CanCollide = false
                                        v706.Humanoid.WalkSpeed = 0
                                        v706.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until v706.Humanoid.Health <= 0 or not _G.AutoSaber
                                end
                                if game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader [Lv. 120] [Boss]") then
                                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader [Lv. 120] [Boss]").HumanoidRootPart.CFrame * Farm_Mode)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
    v487:AddToggle({
        Name = "Auto Get Sword Pole",
        Description = "Auto Kill Thunder God",
        Default = false,
        Callback = function(v707)
            _G.Autopole = v707
            StopTween(_G.Autopole)
        end
    })
    spawn(function()
        while wait() do
            if _G.Autopole then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Thunder God") then
                        for _, v709 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v709.Name == "Thunder God" and v709:FindFirstChild("Humanoid") and v709:FindFirstChild("HumanoidRootPart") and v709.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v709.HumanoidRootPart.CanCollide = false
                                    StartBring = true
                                    v709.Humanoid.WalkSpeed = 0
                                    v709.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.Autopole or not v709.Parent or v709.Humanoid.Health <= 0
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                end)
            end
        end
    end)
    v487:AddToggle({
        Name = "Auto Get Sword Saw",
        Description = "Auto Kill Saw",
        Default = false,
        Callback = function(v710)
            _G.Autosaw = v710
            StopTween(_G.Autosaw)
        end
    })
    local v711 = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)
    do
        local l_v711_0 = v711
        spawn(function()
            while wait() do
                if _G.Autosaw then
                    pcall(function()
                        if not game:GetService("Workspace").Enemies:FindFirstChild("The Saw") then
                            if BypassTP then
                                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - l_v711_0.Position).Magnitude > 1500 then
                                    BTP(l_v711_0)
                                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - l_v711_0.Position).Magnitude < 1500 then
                                    topos(l_v711_0)
                                end
                            else
                                topos(l_v711_0)
                            end
                            EquipWeapon(_G.SelectWeapon)
                            topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                            if game:GetService("ReplicatedStorage"):FindFirstChild("The Saw") then
                                topos(game:GetService("ReplicatedStorage"):FindFirstChild("The Saw").HumanoidRootPart.CFrame * CFrame.new(2, 40, 2))
                            end
                        else
                            for _, v714 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v714.Name == "The Saw" and v714:FindFirstChild("Humanoid") and v714:FindFirstChild("HumanoidRootPart") and v714.Humanoid.Health > 0 then
                                    repeat
                                        task.wait(_G.FastAttackDelay)
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v714.HumanoidRootPart.CanCollide = false
                                        v714.Humanoid.WalkSpeed = 0
                                        v714.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                        AttackNoCD()
                                    until not _G.Autosaw or not v714.Parent or v714.Humanoid.Health <= 0
                                end
                            end
                        end
                    end)
                end
            end
        end)
        v487:AddToggle({
            Name = "Auto Get Sword Wardens",
            Description = "Auto Kill Chief Warden",
            Default = false,
            Callback = function(v715)
                _G.ChiefWarden = v715
                StopTween(_G.ChiefWarden)
            end
        })
        spawn(function()
            while wait() do
                if _G.ChiefWarden then
                    pcall(function()
                        if game:GetService("Workspace").Enemies:FindFirstChild("Chief Warden") then
                            for _, v717 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v717.Name == "Chief Warden" and v717:FindFirstChild("Humanoid") and v717:FindFirstChild("HumanoidRootPart") and v717.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v717.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v717.Humanoid.WalkSpeed = 0
                                        v717.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.ChiefWarden or not v717.Parent or v717.Humanoid.Health <= 0
                                end
                            end
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    end)
                end
            end
        end)
        v487:AddToggle({
            Name = "Auto Get Sword Trident",
            Description = "Auto Kill Fishman Lord",
            Default = false,
            Callback = function(v718)
                _G.Trident = v718
                StopTween(_G.Trident)
            end
        })
        spawn(function()
            while wait() do
                if _G.Trident then
                    pcall(function()
                        if game:GetService("Workspace").Enemies:FindFirstChild("Fishman Lord") then
                            for _, v720 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v720.Name == "Fishman Lord" and v720:FindFirstChild("Humanoid") and v720:FindFirstChild("HumanoidRootPart") and v720.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v720.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v720.Humanoid.WalkSpeed = 0
                                        v720.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.Trident or not v720.Parent or v720.Humanoid.Health <= 0
                                end
                            end
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Lord") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Lord").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    end)
                end
            end
        end)
    end
end
if World2 then
    v487:AddSection("Third sea")
    v487:AddToggle({
        Name = "Auto Quest Sea Bartilo",
        Description = "Complete Bartilo Quest",
        Default = false,
        Callback = function(v722)
            _G.AutoBartilo = v722
            StopTween(_G.AutoBartilo)
        end
    })
    spawn(function()
        pcall(function()
            while wait(0.1) do
                if _G.AutoBartilo then
                    if game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
                        if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") or not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
                            repeat
                                topos(CFrame.new(-456.28952, 73.0200958, 299.895966))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10
                            wait(1.1)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
                        elseif game:GetService("Workspace").Enemies:FindFirstChild("Swan Pirate") then
                            Ms = "Swan Pirate"
                            for _, v724 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                do
                                    local l_v724_0 = v724
                                    if l_v724_0.Name == Ms then
                                        pcall(function()
                                            repeat
                                                task.wait()
                                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                                EquipWeapon(_G.SelectWeapon)
                                                AutoHaki()
                                                l_v724_0.HumanoidRootPart.Transparency = 1
                                                l_v724_0.HumanoidRootPart.CanCollide = false
                                                l_v724_0.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                                topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                                PosMonBarto = l_v724_0.HumanoidRootPart.CFrame
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                StartBring = true
                                            until not l_v724_0.Parent or l_v724_0.Humanoid.Health <= 0 or _G.AutoBartilo == false or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            StartBring = false
                                        end)
                                    end
                                end
                            end
                        else
                            repeat
                                topos(CFrame.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119E-8, -0.230443969, 2.67024713E-8, 1, 8.47491108E-8, 0.230443969, 7.63147128E-8, -0.973085582))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119E-8, -0.230443969, 2.67024713E-8, 1, 8.47491108E-8, 0.230443969, 7.63147128E-8, -0.973085582)).Magnitude <= 10
                        end
                    elseif game:GetService("Players").LocalPlayer.Data.Level.Value < 800 or game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 1 then
                        if game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
                            repeat
                                topos(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1850.49329, 13.1789551, 1750.89685)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1858.87305, 19.3777466, 1712.01807)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1803.94324, 16.5789185, 1750.89685)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1858.55835, 16.8604317, 1724.79541)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1869.54224, 15.987854, 1681.00659))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1869.54224, 15.987854, 1681.00659)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1800.0979, 16.4978027, 1684.52368)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1819.26343, 14.795166, 1717.90625))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1819.26343, 14.795166, 1717.90625)).Magnitude <= 10
                            wait(1)
                            repeat
                                topos(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1813.51843, 14.8604736, 1724.79541)).Magnitude <= 10
                        end
                    elseif not game:GetService("Workspace").Enemies:FindFirstChild("Jeremy") then
                        if not game:GetService("ReplicatedStorage"):FindFirstChild("Jeremy") then
                            repeat
                                topos(CFrame.new(2099.88159, 448.931, 648.997375))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
                        else
                            repeat
                                topos(CFrame.new(-456.28952, 73.0200958, 299.895966))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10
                            wait(1.1)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                            wait(1)
                            repeat
                                topos(CFrame.new(2099.88159, 448.931, 648.997375))
                                wait()
                            until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
                            wait(2)
                        end
                    else
                        Ms = "Jeremy"
                        for _, v727 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v727.Name == Ms then
                                OldCFrameBartlio = v727.HumanoidRootPart.CFrame
                                repeat
                                    task.wait()
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    v727.HumanoidRootPart.Transparency = 1
                                    v727.HumanoidRootPart.CanCollide = false
                                    v727.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    v727.HumanoidRootPart.CFrame = OldCFrameBartlio
                                    topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not v727.Parent or v727.Humanoid.Health <= 0 or _G.AutoBartilo == false
                            end
                        end
                    end
                end
            end
        end)
    end)
    v487:AddToggle({
        Name = "Auto Quest Sea 3",
        Description = "Unlocks access to the third sea (requires Level 1500)",
        Default = false,
        Callback = function(v728)
            _G.ThirdSea = v728
            StopTween(_G.ThirdSea)
        end
    })
    spawn(function()
        while wait() do
            if _G.ThirdSea then
                pcall(function()
                    if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1500 and World2 then
                        _G.AutoFarm = false
                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "General") == 0 then
                            topos(CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016))
                            if (CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                                wait(1.5)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                            end
                            wait(1.8)
                            if not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                                if not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") and (CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000 then
                                    TP1(CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016))
                                end
                            else
                                for _, v730 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v730.Name == "rip_indra" then
                                        OldCFrameThird = v730.HumanoidRootPart.CFrame
                                        repeat
                                            task.wait()
                                            AutoHaki()
                                            EquipWeapon(_G.SelectWeapon)
                                            topos(FarmModePosition(mob.HumanoidRootPart.Position))
                                            v730.HumanoidRootPart.CFrame = OldCFrameThird
                                            v730.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                            v730.HumanoidRootPart.CanCollide = false
                                            StartBring = true
                                            v730.Humanoid.WalkSpeed = 0
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
                                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                        until _G.ThirdSea == false or v730.Humanoid.Health <= 0 or not v730.Parent
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

v487:AddSection("Raid Law")
v487:AddButton({
    Title = "Auto Buy Chip Law",
    Description = "Buy Chip",
    Value = false,
    Callback = function()
        local v1069 = {[1] = "BlackbeardReward", [2] = "Microchip", [3] = "2"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1069))
    end
})
v487:AddButton({
    Title = "Auto Start Raid Law",
    Description = "Start Raid",
    Value = false,
    Callback = function()
        fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
    end
})
v487:AddToggle({
    Name = "Auto Farm Law Raid",
    Description = "Kill Boss Law (Order)",
    Default = false,
    Callback = function(v1070)
        _G.AutoLawRaid = v1070
    end
})
spawn(function()
    while wait() do
        if _G.AutoLawRaid then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Order") then
                    for _, v1072 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v1072.Name == "Order" and v1072:FindFirstChild("Humanoid") and v1072:FindFirstChild("HumanoidRootPart") and v1072.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v1072.HumanoidRootPart.CanCollide = false
                                v1072.Humanoid.WalkSpeed = 0
                                topos(FarmModePosition(v1072.HumanoidRootPart.Position))
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            until not _G.AutoLawRaid or not v1072.Parent or v1072.Humanoid.Health <= 0
                        end
                    end
                else
                    NeedAttacking = true
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
                        topos(game:GetService("ReplicatedStorage"):FindFirstChild("Order").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                end
            end)
        end
    end
end)

    v487:AddSection("Boss Dark Beard")
    v487:AddToggle({
        Name = "Auto Kill Dark Beard",
        Description = "Kill Dark Beard",
        Default = false,
        Callback = function(v736)
            _G.AutoDarkBoss = v736
            StopTween(_G.AutoDarkBoss)
        end
    })
    spawn(function()
        while wait() do
            if _G.AutoDarkBoss then
                pcall(function()
                    if not game:GetService("Workspace").Enemies:FindFirstChild("Darkbeard") then
                        NeedAttacking = true
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    else
                        for _, v738 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v738.Name == "Darkbeard" and v738:FindFirstChild("Humanoid") and v738:FindFirstChild("HumanoidRootPart") and v738.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    NeedAttacking = true
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v738.HumanoidRootPart.CanCollide = false
                                    v738.Humanoid.WalkSpeed = 0
                                    topos(v738.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.AutoDarkBoss or not v738.Parent or v738.Humanoid.Health <= 0
                            end
                        end
                    end
                end)
            end
        end
    end)
    v487:AddToggle({
        Name = "Auto Kill Cursed Captain",
        Description = "Kill Cursed Captain",
        Default = false,
        Callback = function(v739)
            _G.CursedCaptain = v739
            StopTween(_G.CursedCaptain)
        end
    })
    spawn(function()
        while wait() do
            if _G.CursedCaptain then
                pcall(function()
                    if not game:GetService("Workspace").Enemies:FindFirstChild("Cursed Captain") then
                        NeedAttacking = true
                        if (Vector3.new(911.35827636719, 125.95812988281, 33159.5390625) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 18000 and game:GetService("ReplicatedStorage"):FindFirstChild("Cursed Captain") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cursed Captain").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    else
                        for _, v741 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v741.Name == "Cursed Captain" and v741:FindFirstChild("Humanoid") and v741:FindFirstChild("HumanoidRootPart") and v741.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    NeedAttacking = true
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v741.HumanoidRootPart.CanCollide = false
                                    v741.Humanoid.WalkSpeed = 0
                                    topos(v741.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.CursedCaptain or not v741.Parent or v741.Humanoid.Health <= 0
                            end
                        end
                    end
                end)
            end
        end
    end)
    v487:AddSection("Auto Buy")
    v487:AddToggle({
        Name = "⚠️Auto Buy Haki Colors",
        Description = "Buy Haki Colors",
        Default = false,
        Callback = function(v743)
            _G.AutoBuyEnchancementColour = v743
            StopTween(_G.AutoBuyEnchancementColour)
        end
    })
    spawn(function()
        while wait() do
            if _G.AutoBuyEnchancementColour then
                local v744 = {[1] = "ColorsDealer", [2] = "2"}
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v744))
            end
        end
    end)
    v487:AddToggle({
        Title = "⚠️Auto Buy Legendary Sword",
        Description = "Buy Legendary Sword",
        Flag = "BuyLegendarySword",
        Default = false,
        Callback = function(v745)
            _G.AutoBuyLegendarySword = v745
        end
    })
    spawn(function()
        while wait() do
            if _G.AutoBuyLegendarySword then
                pcall(function()
                    local v746 = {[1] = "LegendarySwordDealer", [2] = "1"}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v746))
                    local v747 = {[1] = "LegendarySwordDealer", [2] = "2"}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v747))
                    local v748 = {[1] = "LegendarySwordDealer", [2] = "3"}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v748))
                end)
            end
        end
    end)
    v487:AddSection("Quest Sword")
    v487:AddToggle({
        Name = "Auto Get Longsword",
        Description = "Get Longsword",
        Default = false,
        Callback = function(v750)
            _G.Longsword = v750
            StopTween(_G.Longsword)
        end
    })
    spawn(function()
        while wait() do
            if _G.Longsword then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Diamond") then
                        for _, v752 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v752.Name == "Diamond" and v752:FindFirstChild("Humanoid") and v752:FindFirstChild("HumanoidRootPart") and v752.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v752.HumanoidRootPart.CanCollide = false
                                    StartBring = true
                                    v752.Humanoid.WalkSpeed = 0
                                    v752.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    topos(v752.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.Longsword or not v752.Parent or v752.Humanoid.Health <= 0
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Diamond") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diamond").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                end)
            end
        end
    end)
    v487:AddToggle({
        Name = "Auto Get Sword Gravity Blade",
        Description = "Kill Fajita to Get Sword Gravity Blade",
        Default = false,
        Callback = function(v753)
            _G.GravityBlade = v753
            StopTween(_G.GravityBlade)
        end
    })
    spawn(function()
        while wait() do
            if _G.GravityBlade then
                pcall(function()
                    if not game:GetService("Workspace").Enemies:FindFirstChild("Fajita") then
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Fajita") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Fajita").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    else
                        for _, v755 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v755.Name == "Fajita" and v755:FindFirstChild("Humanoid") and v755:FindFirstChild("HumanoidRootPart") and v755.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v755.HumanoidRootPart.CanCollide = false
                                    StartBring = true
                                    v755.Humanoid.WalkSpeed = 0
                                    v755.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    topos(v755.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.GravityBlade or not v755.Parent or v755.Humanoid.Health <= 0
                            end
                        end
                    end
                end)
            end
        end
    end)
    v487:AddToggle({
        Name = "Auto Get Sword Flail",
        Description = "Get Sword Flail",
        Default = false,
        Callback = function(v756)
            _G.SwodsFlail = v756
            StopTween(_G.SwodsFlail)
        end
    })
    spawn(function()
        while wait() do
            if _G.SwodsFlail then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Smoke Admiral") then
                        for _, v758 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v758.Name == "Smoke Admiral" and v758:FindFirstChild("Humanoid") and v758:FindFirstChild("HumanoidRootPart") and v758.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v758.HumanoidRootPart.CanCollide = false
                                    StartBring = true
                                    v758.Humanoid.WalkSpeed = 0
                                    v758.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    topos(v758.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.SwodsFlail or not v758.Parent or v758.Humanoid.Health <= 0
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Smoke Admiral") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Smoke Admiral").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                end)
            end
        end
    end)
    v487:AddToggle({
        Name = "Auto Get Sword Rengoku",
        Description = "Kill Awakened Ice Admiral to Get Sword Rengoku",
        Default = false,
        Callback = function(v759)
            _G.AutoRengoku = v759
            StopTween(_G.AutoRengoku)
        end
    })
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoRengoku then
                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
                        EquipWeapon("Hidden Key")
                        topos(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
                    elseif not game:GetService("Workspace").Enemies:FindFirstChild("Awakened Ice Admiral") then
                        StartBring = false
                        topos(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
                    else
                        for _, v761 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v761.Name == "Awakened Ice Admiral" and v761:FindFirstChild("Humanoid") and v761:FindFirstChild("HumanoidRootPart") and v761.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    v761.HumanoidRootPart.CanCollide = false
                                    v761.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    PosMon = v761.HumanoidRootPart.CFrame
                                    MonFarm = v761.Name
                                    topos(v761.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    AttackNoCD()
                                    StartBring = true
                                until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or _G.AutoRengoku == false or not v761.Parent or v761.Humanoid.Health <= 0
                                StartBring = false
                            end
                        end
                    end
                end
            end
        end)
    end)
    v487:AddToggle({
        Name = "Auto Get Sword Dragon Trident",
        Description = "Get Sword Dragon Trident",
        Default = false,
        Callback = function(v762)
            _G.SwodsDRTrident = v762
            StopTween(_G.SwodsDRTrident)
        end
    })
    spawn(function()
        while wait() do
            if _G.SwodsDRTrident then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Tide Keeper") then
                        for _, v764 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v764.Name == "Tide Keeper" and v764:FindFirstChild("Humanoid") and v764:FindFirstChild("HumanoidRootPart") and v764.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v764.HumanoidRootPart.CanCollide = false
                                    StartBring = true
                                    v764.Humanoid.WalkSpeed = 0
                                    v764.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    topos(v764.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.SwodsDRTrident or not v764.Parent or v764.Humanoid.Health <= 0
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                end)
            end
        end
    end)
end
if World3 then
    v487:AddSection("Boss Rip indra")
    v487:AddToggle({
        Name = "Auto kill Rip Indra",
        Description = "kill Rip Indra boss",
        Default = false,
        Callback = function(v767)
            _G.RipIndraKill = v767
            StopTween(_G.RipIndraKill)
        end
    })
    local v768 = CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781)
    do
        local l_v768_0 = v768
        spawn(function()
            pcall(function()
                while wait() do
                    if _G.RipIndraKill then
                        if not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form") and not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                            if BypassTP then
                                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - l_v768_0.Position).Magnitude > 1500 then
                                    TP1(l_v768_0)
                                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - l_v768_0.Position).Magnitude < 1500 then
                                    TP1(l_v768_0)
                                end
                            else
                                TP1(l_v768_0)
                            end
                            TP1(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
                        else
                            for _, v771 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                local l_Name_0 = v771.Name
                                local v773 = "rip_indra True Form"
                                if not v773 then
                                    if v771.Name ~= "rip_indra" then
                                        v773 = false
                                    end
                                    v773 = true
                                end
                                do
                                    local l_v771_0 = v771
                                    if l_Name_0 == v773 and l_v771_0.Humanoid.Health > 0 and l_v771_0:IsA("Model") and l_v771_0:FindFirstChild("Humanoid") and l_v771_0:FindFirstChild("HumanoidRootPart") then
                                        repeat
                                            task.wait()
                                            pcall(function()
                                                AutoHaki()
                                                EquipWeapon(_G.SelectWeapon)
                                                l_v771_0.HumanoidRootPart.CanCollide = false
                                                l_v771_0.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                                topos(l_v771_0.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670), workspace.CurrentCamera.CFrame)
                                            end)
                                        until _G.RipIndraKill == false or l_v771_0.Humanoid.Health <= 0
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end)
        v487:AddToggle({
            Name = "Auto Haki Colors",
            Description = "",
            Default = false,
            Callback = function(v775)
                _G.RipIndraKill = v775
                StopTween(_G.RipIndraKill)
            end
        })
        spawn(function()
            while wait() do
                if _G.AutoBuyEnchancementColour then
                    local v776 = {[1] = "ColorsDealer", [2] = "2"}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v776))
                end
            end
        end)

v487:AddSection("Farm")
        v487:AddToggle({
            Name = "Auto Kill Elite Hunter",
            Description = "Kill Elite Hunter spawned",
            Default = false,
            Callback = function(v793)
                _G.AutoElitehunter = v793
                StopTween(_G.AutoElitehunter)
            end
        })
        spawn(function()
            while wait() do
                if _G.AutoElitehunter and World3 then
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban") then
                                if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
                                    for _, v795 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                        if (v795.Name == "Diablo" or v795.Name == "Deandre" or v795.Name == "Urban") and v795:FindFirstChild("Humanoid") and v795:FindFirstChild("HumanoidRootPart") and v795.Humanoid.Health > 0 then
                                            repeat
                                                wait()
                                                AutoHaki()
                                                EquipWeapon(_G.SelectWeapon)
                                                NeedAttacking = true
                                                StartBring = true
                                                v795.HumanoidRootPart.CanCollide = false
                                                v795.Humanoid.WalkSpeed = 0
                                                topos(FarmModePosition(v795.HumanoidRootPart.Position))
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                            until _G.AutoElitehunter == false or v795.Humanoid.Health <= 0 or not v795.Parent
                                        end
                                    end
                                else
                                    NeedAttacking = false
                                    if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                    end
                                end
                            end
                        elseif _G.AutoEliteHunterHop and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter") == "I don't have anything for you right now. Come back later." then
                            Hop()
                        else
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                        end
                    end)
                end
            end
        end)

v487:AddToggle({
    Name = "Auto Cake Prince",
    Description = "Automatically summons the Cake Prince",
    Default = false,
    Callback = function(v608)
        _G.FarmCake = v608
        StopTween(_G.FarmCake)
    end
})
local v609 = CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375)
local _ = game:GetService("Workspace").Enemies
task.spawn(function()
    while task.wait() do
        if _G.FarmCake then
            pcall(function()
                if not game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") then
                    local v611 = false
                    for _, v613 in pairs({"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}) do
                        if game:GetService("Workspace").Enemies:FindFirstChild(v613) then
                            v611 = true
                            break
                        end
                    end
                    if v611 then
                        for _, v615 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if (v615.Name == "Cookie Crafter" or v615.Name == "Cake Guard" or v615.Name == "Baking Staff" or v615.Name == "Head Baker") and v615:FindFirstChild("Humanoid") and v615:FindFirstChild("HumanoidRootPart") and v615.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v615.HumanoidRootPart.CanCollide = false
                                    v615.Humanoid.WalkSpeed = 0
                                    StartBring = true
                                    v615.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    PosMon = v615.HumanoidRootPart.CFrame
                                    MonFarm = v615.Name
                                    v615.Head.CanCollide = false
                                    topos(FarmModePosition(v615.HumanoidRootPart.Position))
                                    NeedAttacking = true
                                    if v615.Name ~= "Cookie Crafter" then
                                        if v615.Name == "Cake Guard" then
                                            Bring(v615.Name, CFrame.new(-1693.98047, 35.2188225, -12436.8438, -0.716115236, 0, -0.697982132, 0, 1, 0, 0.697982132, 0, -0.716115236))
                                        elseif v615.Name == "Baking Staff" then
                                            Bring(v615.Name, CFrame.new(-1980.4375, 34.6653099, -12983.8408, -0.254338264, 0, -0.967115223, 0, 1, 0, 0.967115223, 0, -0.254338264))
                                        elseif v615.Name == "Head Baker" then
                                            Bring(v615.Name, CFrame.new(-2151.37793, 51.0095749, -13033.3975, -0.996587753, 0, 0.0825396702, 0, 1, 0, -0.0825396702, 0, -0.996587753))
                                        end
                                    else
                                        Bring(v615.Name, CFrame.new(-2212.88965, 37.0051041, -11969.2568, 0.458114207, 0, -0.888893366, 0, 1, 0, 0.888893366, 0, 0.458114207))
                                    end
                                until not _G.FarmCake or not v615.Parent or v615.Humanoid.Health <= 0 or game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0 or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]")
                                DamageAura = false
                            end
                        end
                    else
                        local v616 = math.random(1, 3)
                        if v616 ~= 1 then
                            if v616 ~= 2 then
                                if v616 == 3 then
                                    topos(CFrame.new(-2231.2793, 168.256653, -12845.7559))
                                end
                            else
                                topos(CFrame.new(-2383.78979, 150.450592, -12126.4961))
                            end
                        else
                            topos(CFrame.new(-1436.86011, 167.753616, -12296.9512))
                        end
                    end
                    if BypassTP then
                        if (playerPos - v609.Position).Magnitude <= 1500 then
                            topos(v609)
                        else
                            BTP(v609)
                        end
                    else
                        topos(v609)
                    end
                    UnEquipWeapon(_G.Selectweapon)
                    topos(CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375))
                else
                    for _, v618 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v618.Name == "Cake Prince" and v618:FindFirstChild("Humanoid") and v618:FindFirstChild("HumanoidRootPart") and v618.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v618.HumanoidRootPart.CanCollide = false
                                v618.Humanoid.WalkSpeed = 0
                                v618.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                if game:GetService("Workspace")._WorldOrigin:FindFirstChild("Ring") or game:GetService("Workspace")._WorldOrigin:FindFirstChild("Fist") or game:GetService("Workspace")._WorldOrigin:FindFirstChild("MochiSwirl") then
                                    topos(v618.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
                                else
                                    topos(v618.HumanoidRootPart.CFrame * CFrame.new(4, 10, 10))
                                end
                                NeedAttacking = true
                            until not _G.FarmCake or not v618.Parent or v618.Humanoid.Health <= 0
                            wait(1)
                        end
                    end
                end
            end)
        end
    end
end)
v487:AddToggle({
    Name = "Auto Dough King",
    Description = "Automatically summons the Dough King",
    Default = false,
    Callback = function(v619)
        _G.Fullykatakuri = v619
        StopTween(_G.Fullykatakuri)
    end
})
spawn(function()
    while wait() do
        if _G.Fullykatakuri then
            pcall(function()
                if not game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") and not game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice") then
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Sweet Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("Sweet Chalice") then
                        if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "Do you want to open the portal now?") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                        elseif game.Workspace.Enemies:FindFirstChild("Baking Staff") or game.Workspace.Enemies:FindFirstChild("Head Baker") or game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter") then
                            for _, v621 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if (v621.Name == "Baking Staff" or v621.Name == "Head Baker" or v621.Name == "Cake Guard" or v621.Name == "Cookie Crafter") and v621.Humanoid.Health > 0 then
                                    repeat
                                        wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        AutoHaki()
                                        PosMon = v621.HumanoidRootPart.CFrame
                                        topos(v621.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        v621.HumanoidRootPart.CanCollide = false
                                        v621.Humanoid.WalkSpeed = 0
                                        v621.Head.CanCollide = false
                                        attackGunEnemies(v621.Name, 5)
                                        v621.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                        StartBring = false
                                        MonFarm = v621.Name
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    until _G.Fullykatakuri == false or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or not v621.Parent or v621.Humanoid.Health <= 0
                                end
                            end
                        else
                            CakeBring = false
                            StartBring = false
                            topos(CFrame.new(-1820.0634765625, 210.74781799316406, -12297.49609375))
                        end
                    elseif game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                        if not game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                            topos(CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875))
                        else
                            for _, v623 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v623.Name == "Dough King" then
                                    repeat
                                        wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v623.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                        v623.HumanoidRootPart.CanCollide = false
                                        StartBring = false
                                        topos(v623.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    until _G.Fullykatakuri == false or not v623.Parent or v623.Humanoid.Health <= 0
                                end
                            end
                        end
                    elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Red Key") or game.Players.LocalPlayer.Character:FindFirstChild("Red Key") then
                        local v624 = {[1] = "CakeScientist", [2] = "Check"}
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v624))
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban") then
                        if not game:GetService("Workspace").Enemies:FindFirstChild("Diablo") and not game:GetService("Workspace").Enemies:FindFirstChild("Deandre") and not game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
                                topos(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                            elseif not game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
                                if game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
                                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                end
                            else
                                topos(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                            end
                        else
                            for _, v626 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if (v626.Name == "Diablo" or v626.Name == "Deandre" or v626.Name == "Urban") and v626:FindFirstChild("Humanoid") and v626:FindFirstChild("HumanoidRootPart") and v626.Humanoid.Health > 0 then
                                    repeat
                                        wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        PosMon = v626.HumanoidRootPart.CFrame
                                        topos(v626.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        v626.HumanoidRootPart.CanCollide = false
                                        v626.Humanoid.WalkSpeed = 0
                                        v626.Head.CanCollide = false
                                        attackGunEnemies(v626.Name, 5)
                                        v626.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                        StartBring = false
                                        MonFarm = v626.Name
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until _G.Fullykatakuri == false or v626.Humanoid.Health <= 0 or not v626.Parent or game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice")
                                end
                            end
                        end
                    end
                elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc"), "Where") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc")
                end
            end)
        end
    end
end)

v487:AddToggle({
    Name = "Auto Farm Tyrant",
    Description = "Automatically farms the Tyrant target whenever it spawns or becomes available",
    Default = false,
    Callback = function(v553)
        _G.FarmDaiBan = v553
        StopTween(_G.FarmDaiBan)
    end
})
local v554 = CFrame.new(-16194.0048828125, 155.21844482421875, 1420.719970703125)
local _ = game:GetService("Workspace").Enemies
task.spawn(function()
    while task.wait() do
        if _G.FarmDaiBan then
            pcall(function()
                if not game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies") then
                    local v556 = false
                    for _, v558 in pairs({"Isle Outlaw", "Island Boy", "Isle Champion", "Serpent Hunter", "Skull Slayer"}) do
                        if game:GetService("Workspace").Enemies:FindFirstChild(v558) then
                            v556 = true
                            break
                        end
                    end
                    if not v556 then
                        local v559 = math.random(1, 3)
                        if v559 == 1 then
                            topos(CFrame.new(-1436.86011, 167.753616, -12296.9512))
                        elseif v559 ~= 2 then
                            if v559 == 3 then
                                topos(CFrame.new(-2231.2793, 168.256653, -12845.7559))
                            end
                        else
                            topos(CFrame.new(-2383.78979, 150.450592, -12126.4961))
                        end
                    else
                        for _, v561 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if (v561.Name == "Isle Outlaw" or v561.Name == "Island Boy" or v561.Name == "Isle Champion" or v561.Name == "Serpent Hunter" or v561.Name == "Skull Slayer") and v561:FindFirstChild("Humanoid") and v561:FindFirstChild("HumanoidRootPart") and v561.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v561.HumanoidRootPart.CanCollide = false
                                    v561.Humanoid.WalkSpeed = 0
                                    StartBring = true
                                    v561.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    PosMon = v561.HumanoidRootPart.CFrame
                                    MonFarm = v561.Name
                                    v561.Head.CanCollide = false
                                    topos(FarmModePosition(v561.HumanoidRootPart.Position))
                                    NeedAttacking = true
                                    if v561.Name ~= "Isle Outlaw" then
                                        if v561.Name == "Island Boy" then
                                            Bring(v561.Name, CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562))
                                        elseif v561.Name ~= "Isle Champion" then
                                            if v561.Name ~= "Serpent Hunter" then
                                                if v561.Name == "Skull Slayer" then
                                                    Bring(v561.Name, CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, 0, -0.0348687991, 0, 1, 0, 0.0348687991, 0, -0.999392271))
                                                end
                                            else
                                                Bring(v561.Name, CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, 0, 0.882950008, 0, 1, 0, -0.882950008, 0, 0.469467044))
                                            end
                                        else
                                            Bring(v561.Name, CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375))
                                        end
                                    else
                                        Bring(v561.Name, CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656))
                                    end
                                until not _G.FarmDaiBan or not v561.Parent or v561.Humanoid.Health <= 0 or game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0 or game:GetService("ReplicatedStorage"):FindFirstChild("Tyrant of the Skies [Lv. 2600] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies [Lv. 2600] [Raid Boss]")
                                DamageAura = false
                            end
                        end
                    end
                    if not BypassTP then
                        topos(v554)
                    elseif (playerPos - v554.Position).Magnitude > 1500 then
                        BTP(v554)
                    else
                        topos(v554)
                    end
                    UnEquipWeapon(_G.Selectweapon)
                    topos(CFrame.new(-16194.0048828125, 155.21844482421875, 1420.719970703125))
                else
                    for _, v563 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v563.Name == "Tyrant of the Skies" and v563:FindFirstChild("Humanoid") and v563:FindFirstChild("HumanoidRootPart") and v563.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v563.HumanoidRootPart.CanCollide = false
                                v563.Humanoid.WalkSpeed = 0
                                v563.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                topos(v563.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0))
                                NeedAttacking = true
                            until not _G.FarmDaiBan or not v563.Parent or v563.Humanoid.Health <= 0
                            wait(1)
                        end
                    end
                end
            end)
        end
    end
end)
v487:AddToggle({
    Name = "Summon Tyrant Of The Skies",
    Description = "Summons the Tyrant of the Skies when the required conditions are met",
    Default = false,
    Callback = function(v564)
        _G.Farm8Binhs = v564
        StopTween(_G.Farm8Binhs)
    end
})
local v565 = {
    CFrame.new(-16250.2354, 158.167007, 1313.01904, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
    CFrame.new(-16250.2354, 158.167007, 1313.01904, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
    CFrame.new(-16297.0596, 159.322998, 1317.224, -0.463313937, 0, 0.886194229, 0, 1, 0, -0.886194229, 0, -0.463313937),
    CFrame.new(-16335.0967, 159.334, 1324.88599, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
    CFrame.new(-16288.6094, 158.167007, 1470.36804, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
    CFrame.new(-16258.001, 156.761002, 1461.40405, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
    CFrame.new(-16245.4121, 158.436996, 1463.36597, -0.993159413, 0, 0.116766132, 0, 1, 0, -0.116766132, 0, -0.993159413),
    CFrame.new(-16212.4688, 158.167007, 1466.34399, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874)
}
function TweenToPosition(v566)
    local l_Character_5 = game.Players.LocalPlayer.Character
    local v568 = l_Character_5 and l_Character_5:FindFirstChild("HumanoidRootPart")
    if not v568 then
        return 
    else
        local l_TweenService_0 = game:GetService("TweenService")
        local v570 = (v568.Position - v566.Position).Magnitude / 300
        local v571 = l_TweenService_0:Create(v568, TweenInfo.new(v570, Enum.EasingStyle.Linear), {CFrame = v566})
        v571:Play()
        v571.Completed:Wait()
        return 
    end
end
function Skill(v572)
    local l_VirtualInputManager_0 = game:GetService("VirtualInputManager")
    l_VirtualInputManager_0:SendKeyEvent(true, Enum.KeyCode[v572], false, game)
    task.wait(0.05)
    l_VirtualInputManager_0:SendKeyEvent(false, Enum.KeyCode[v572], false, game)
end
function Click()
    local l_VirtualInputManager_1 = game:GetService("VirtualInputManager")
    l_VirtualInputManager_1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    l_VirtualInputManager_1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end
function FindWeapon(v575)
    local l_Backpack_0 = game.Players.LocalPlayer.Backpack
    for _, v578 in ipairs(l_Backpack_0:GetChildren()) do
        if v578:IsA("Tool") then
            if v575 ~= "Melee" or v578.ToolTip ~= "Melee" and v578.Name ~= "Combat" then
                if v575 ~= "Sword" or v578.ToolTip ~= "Sword" then
                    if v575 == "Gun" and v578.ToolTip == "Gun" then
                        return v578.Name
                    elseif v575 == "Fruit" and v578.ToolTip == "Blox Fruit" then
                        return v578.Name
                    end
                else
                    return v578.Name
                end
            else
                return v578.Name
            end
        end
    end
    return nil
end
function EquipWeapon(v579)
    if not v579 then
        return 
    else
        local l_LocalPlayer_7 = game.Players.LocalPlayer
        local l_FirstChild_1 = l_LocalPlayer_7:WaitForChild("Backpack"):FindFirstChild(v579)
        if l_FirstChild_1 then
            l_LocalPlayer_7.Character.Humanoid:EquipTool(l_FirstChild_1)
        end
        return 
    end
end
function AttackAllSkills()
    local v582 = FindWeapon("Melee")
    local v583 = FindWeapon("Sword")
    local v584 = FindWeapon("Fruit")
    local v585 = FindWeapon("Gun")
    if v582 then
        EquipWeapon(v582)
        Skill("Z")
        Skill("X")
        Skill("C")
        Skill("V")
        Click()
    end
    if v583 then
        EquipWeapon(v583)
        Skill("Z")
        Skill("X")
        Click()
    end
    if v584 then
        EquipWeapon(v584)
        Skill("Z")
        Skill("X")
        Skill("C")
        Skill("F")
        Click()
    end
    if v585 then
        EquipWeapon(v585)
        Skill("Z")
        Skill("X")
        Click()
    end
end
task.spawn(function()
    while task.wait(1) do
        if _G.Farm8Binhs then
            for _, v587 in ipairs(v565) do
                if _G.Farm8Binhs then
                    TweenToPosition(v587 * CFrame.new(0, 5, 0))
                    task.wait(0.5)
                    AttackAllSkills()
                    task.wait(3)
                else
                    break
                end
            end
        end
    end
end)

v487:AddSection("Quest Skull Guitar")
v487:AddToggle({
 Name = "Auto Quest Skull Guitar",
 Description = "Auto Complete Skull Guitar Quest",
 Default = false,
 Callback = function(v778)
      _G.AutoSkullGuitar = v778
         StopTween(_G.AutoSkullGuitar)
    end
 })
        spawn(function()
            while task.wait() do
                if getgenv().AutoSkullGuitar then
                    pcall(function()
                        if not GetWeaponInventory("Skull Guitar") then
                            local l_LocalPlayer_11 = game:GetService("Players").LocalPlayer
                            local v780 = l_LocalPlayer_11.Character and l_LocalPlayer_11.Character:FindFirstChild("HumanoidRootPart")
                            if v780 and (Vector3.new(-9681.458, 6.139, 6341.372) - v780.Position).Magnitude <= 5000 then
                                if game:GetService("Workspace").NPCs:FindFirstChild("Skeleton Machine") then
                                    game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("soulGuitarBuy", true)
                                else
                                    local l_FirstChild_3 = game:GetService("Workspace").Map:FindFirstChild("Haunted Castle")
                                    if not l_FirstChild_3 or l_FirstChild_3.Candle1.Transparency ~= 0 then
                                        if not l_FirstChild_3 or not l_FirstChild_3.Tablet or not l_FirstChild_3.Tablet:FindFirstChild("Segment1") then
                                            if game:GetService("Workspace").NPCs:FindFirstChild("Ghost") then
                                                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("GuitarPuzzleProgress", "Ghost")
                                            end
                                            local l_Enemies_2 = game.Workspace:FindFirstChild("Enemies")
                                            if l_Enemies_2 and l_Enemies_2:FindFirstChild("Living Zombie") then
                                                for _, v784 in pairs(l_Enemies_2:GetChildren()) do
                                                    if v784:FindFirstChild("HumanoidRootPart") and v784:FindFirstChild("Humanoid") and v784.Humanoid.Health > 0 and v784.Name == "Living Zombie" then
                                                        AutoHaki()
                                                        EquipWeapon(getgenv().SelectWeapon)
                                                        v784.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                                        v784.HumanoidRootPart.Transparency = 1
                                                        v784.Humanoid.JumpPower = 0
                                                        v784.Humanoid.WalkSpeed = 0
                                                        v784.HumanoidRootPart.CanCollide = false
                                                        v784.HumanoidRootPart.CFrame = v780.CFrame * CFrame.new(0, 20, 0)
                                                        topos(CFrame.new(-10160.787, 138.662, 5955.031))
                                                        task.wait(0.5)
                                                        local l_VirtualUser_0 = game:GetService("VirtualUser")
                                                        l_VirtualUser_0:CaptureController()
                                                        l_VirtualUser_0:Button1Down(Vector2.new(1280, 672))
                                                    end
                                                end
                                            else
                                                topos(CFrame.new(-10160.787, 138.662, 5955.031))
                                            end
                                        else
                                            local l_l_FirstChild_3_FirstChild_0 = l_FirstChild_3:FindFirstChild("Lab Puzzle")
                                            if not l_l_FirstChild_3_FirstChild_0 or not l_l_FirstChild_3_FirstChild_0.ColorFloor.Model.Part1:FindFirstChild("ClickDetector") then
                                                Quest3 = true
                                            else
                                                Quest4 = true
                                                topos(CFrame.new(-9553.599, 65.623, 6041.588))
                                                task.wait(1)
                                                for _, v788 in ipairs({3, 4, 4, 4, 6, 6, 8, 10, 10, 10}) do
                                                    local l_FirstChild_4 = l_l_FirstChild_3_FirstChild_0.ColorFloor.Model:FindFirstChild("Part" .. v788)
                                                    if l_FirstChild_4 and l_FirstChild_4:FindFirstChild("ClickDetector") then
                                                        topos(l_FirstChild_4.CFrame)
                                                        task.wait(1)
                                                        fireclickdetector(l_FirstChild_4.ClickDetector)
                                                        task.wait(0.5)
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        local l_Placard1_0 = l_FirstChild_3:FindFirstChild("Placard1")
                                        if l_Placard1_0 and l_Placard1_0.Left.Part.Transparency == 0 then
                                            Quest2 = true
                                            topos(CFrame.new(-8762.691, 176.847, 6171.308))
                                            task.wait(1)
                                            for v791 = 7, 1, -1 do
                                                local l_l_FirstChild_3_FirstChild_1 = l_FirstChild_3:FindFirstChild("Placard" .. v791)
                                                if l_l_FirstChild_3_FirstChild_1 and l_l_FirstChild_3_FirstChild_1:FindFirstChild("Left") and l_l_FirstChild_3_FirstChild_1.Left:FindFirstChild("ClickDetector") then
                                                    fireclickdetector(l_l_FirstChild_3_FirstChild_1.Left.ClickDetector)
                                                    task.wait(0.5)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        elseif not string.find(game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2), "Error") then
                            if string.find(game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2), "Nothing") then
                                topos("Wait Full Moon")
                            else
                                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2, true)
                            end
                        else
                            topos(CFrame.new(-8653.206, 140.985, 6160.033))
                        end
                    end)
                end
            end
        end)

v487:AddToggle({
    Title = "Auto Farm Material Skull Guitar",
    Description = "Farm Material Skull Guitar",
    Flag = "MaterialSkullGuitar";
    Default = false,
    Callback = function(Value)
        _G.AutoMatSoul = Value
    end
})

spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoMatSoul and GetWP("Skull Guitar") == false then
                if GetM("Bones") >= 500 and GetM("Ectoplasm") >= 250 and GetM("Dark Fragment") >= 1 then
                    replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
                else
                    if GetM("Ectoplasm") <= 250 then
                        if _G.AutoMatSoul and World2 then
                            local EctoTable = {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"}
                            local xz = GetConnectionEnemies(EctoTable)
                            if xz then
                                repeat task.wait()
                                    Attack.Kill(xz, _G.AutoMatSoul)
                                until not _G.AutoMatSoul or not xz.Parent or xz.Humanoid.Health <= 0
                            else
                                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.2125,126.9760,32852.8320))
                            end
                        else
                            replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                        end

                    elseif GetM("Dark Fragment") < 1 then
                        if _G.AutoMatSoul and World2 then
                            local black = GetConnectionEnemies("Darkbeard")
                            if black then
                                repeat task.wait()
                                    Attack.Kill(black, _G.AutoMatSoul)
                                until not _G.AutoMatSoul or black.Humanoid.Health <= 0
                            else
                                TP1(CFrame.new(3798.4575,13.8266,-3399.8066))
                            end
                        else
                            replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                        end

                        if not GetConnectionEnemies("Darkbeard") then
                            Hop()
                        end

                    elseif GetM("Bones") <= 500 then
                        if _G.AutoMatSoul and World3 then
                            local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}
                            local zx = GetConnectionEnemies(BonesTable)
                            if zx then
                                repeat task.wait()
                                    Attack.Kill(zx, _G.AutoMatSoul)
                                until not _G.AutoMatSoul or not zx.Parent or zx.Humanoid.Health <= 0
                            else
                                TP1(CFrame.new(-9504.8564,172.1429,6057.2597))
                            end
                        else
                            replicated.Remotes.CommF_:InvokeServer("TravelZou")
                        end
                    end
                end
            end
        end)
    end
end)
        v487:AddSection("Auto CDK")
        v487:AddToggle({
            Name = "Auto Get Yama",
            Description = "Auto Collect Yama [ requires 30 elite Hunters killed ]",
            Default = false,
            Callback = function(v807)
                _G.AutoYama = v807
                StopTween(_G.AutoYama)
            end
        })
        spawn(function()
            while wait() do
                if _G.AutoYama and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress") >= 30 then
                    repeat
                        wait()
                        fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
                    until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not _G.AutoYama
                end
            end
        end)
        v487:AddToggle({
            Name = "Auto Holy Torch Tushita",
            Description = "Auto completes the Holy Torch puzzle to unlock Tushita automatically",
            Default = false,
            Callback = function(v808)
                _G.AutoHolyTorch = v808
                StopTween(_G.AutoHolyTorch)
            end
        })
        spawn(function()
            while wait() do
                if _G.AutoHolyTorch then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625))
                        wait(1)
                        topos(CFrame.new(5711.87451171875, 45.82802963256836, 254.17005920410156))
                        wait(15)
                        EquipWeapon("Holy Torch")
                        repeat
                            topos(CFrame.new(-10752, 417, -9366))
                            wait()
                        until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-10752, 417, -9366)).Magnitude <= 10
                        wait(1)
                        repeat
                            topos(CFrame.new(-11672, 334, -9474))
                            wait()
                        until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-11672, 334, -9474)).Magnitude <= 10
                        wait(1)
                        repeat
                            topos(CFrame.new(-12132, 521, -10655))
                            wait()
                        until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-12132, 521, -10655)).Magnitude <= 10
                        wait(1)
                        repeat
                            topos(CFrame.new(-13336, 486, -6985))
                            wait()
                        until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-13336, 486, -6985)).Magnitude <= 10
                        wait(1)
                        repeat
                            topos(CFrame.new(-13489, 332, -7925))
                            wait()
                        until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-13489, 332, -7925)).Magnitude <= 10
                    end)
                end
            end
        end)
        v487:AddToggle({
            Name = "Auto Get Tushita",
            Description = "Auto Kill Longma",
            Default = false,
            Callback = function(v809)
                _G.AutoGetTushita = v809
                StopTween(_G.AutoGetTushita)
            end
        })
        spawn(function()
            while wait() do
                if _G.AutoGetTushita then
                    pcall(function()
                        if game:GetService("Workspace").Enemies:FindFirstChild("Longma") then
                            for _, v811 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v811.Name == "Longma" and v811:FindFirstChild("Humanoid") and v811:FindFirstChild("HumanoidRootPart") and v811.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v811.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v811.Humanoid.WalkSpeed = 0
                                        v811.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(v811.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.AutoGetTushita or not v811.Parent or v811.Humanoid.Health <= 0
                                end
                            end
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Longma") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    end)
                end
            end
        end)
    end



if World3 then
v487:AddSection("Quest Sword")
   v487:AddToggle({
    Name = "Auto Get Sword Twin Hooks",
    Description = "Auto Kill Captain Elephant to get Twin Hooks",
    Default = false,
    Callback = function(v813)
      _G.SwodTwinHooks = v813
    StopTween(_G.SwodTwinHooks)
  end
})
        spawn(function()
            while wait() do
                if _G.SwodTwinHooks then
                    pcall(function()
                        if not game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant") then
                                TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                            end
                        else
                            for _, v815 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v815.Name == "Captain Elephant" and v815:FindFirstChild("Humanoid") and v815:FindFirstChild("HumanoidRootPart") and v815.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v815.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v815.Humanoid.WalkSpeed = 0
                                        v815.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(v815.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.SwodTwinHooks or not v815.Parent or v815.Humanoid.Health <= 0
                                end
                            end
                        end
                    end)
                end
            end
        end)
        v487:AddToggle({
            Name = "Auto Get Sword Canvander",
            Description = "Auto Kill Beautiful Pirate",
            Default = false,
            Callback = function(v816)
                _G.SwodCanvander = v816
                StopTween(_G.SwodCanvander)
            end
        })
        spawn(function()
            while wait() do
                if _G.SwodCanvander then
                    pcall(function()
                        if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
                            for _, v818 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v818.Name == "Beautiful Pirate" and v818:FindFirstChild("Humanoid") and v818:FindFirstChild("HumanoidRootPart") and v818.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v818.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v818.Humanoid.WalkSpeed = 0
                                        v818.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(v818.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.SwodCanvander or not v818.Parent or v818.Humanoid.Health <= 0
                                end
                            end
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    end)
                end
            end
        end)
        v487:AddToggle({
            Name = "Auto Get Sword Buddy",
            Description = "Auto Kill Cake Queen",
            Default = false,
            Callback = function(v819)
                _G.SwodsBuddy = v819
                StopTween(_G.SwodsBuddy)
            end
        })
        spawn(function()
            while wait() do
                if _G.SwodsBuddy then
                    pcall(function()
                        if not game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen") then
                                TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                            end
                        else
                            for _, v821 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v821.Name == "Cake Queen" and v821:FindFirstChild("Humanoid") and v821:FindFirstChild("HumanoidRootPart") and v821.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v821.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v821.Humanoid.WalkSpeed = 0
                                        v821.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(v821.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.SwodsBuddy or not v821.Parent or v821.Humanoid.Health <= 0
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
v487:AddSection("Teleport V4")
v487:AddButton({
    Title = "Teleport To Top GreatTree",
    Value = false,
    Callback = function()
        Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3030.39453125, 2280.6171875, -7320.18359375)
    end
})
v487:AddButton({
    Title = "Teleport Lever Pull",
    Value = false,
    Callback = function()
        topos(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
    end
})
v487:AddButton({
    Title = "Teleport To The Clock",
    Value = false,
    Callback = function()
        topos(CFrame.new(29553.7812, 15066.6133, -88.2750015, 1, 0, 0, 0, 1, 0, 0, 0, 1))
    end
})
v487:AddSection("Trial V4")
v487:AddButton({
    Title = "Auto Race Door",
    Value = false,
    Callback = function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        wait(0.1)
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        wait(0.1)
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        wait(0.1)
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        wait(0.5)
        if game:GetService("Players").LocalPlayer.Data.Race.Value == "Human" then
            topos(CFrame.new(29221.822265625, 14890.9755859375, -205.99114990234375))
        elseif game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Skypiea" then
            if game:GetService("Players").LocalPlayer.Data.Race.Value == "Fishman" then
                topos(CFrame.new(28231.17578125, 14890.9755859375, -211.64173889160156))
            elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" then
                topos(CFrame.new(28502.681640625, 14895.9755859375, -423.7279357910156))
            elseif game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Ghoul" then
                if game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
                    topos(CFrame.new(29012.341796875, 14890.9755859375, -380.1492614746094))
                end
            else
                topos(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
            end
        else
            topos(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
        end
    end
})
v487:AddButton({
    Title = "⚠️Buy Acient One Quest",
    Value = false,
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
    end
})
v487:AddToggle({
    Name = "Auto Trial Human Ghost",
    Description = "Auto Kill NPCs/Boss",
    Default = false,
    Callback = function(v998)
        _G.Kill_Aura = v998
        StopTween(_G.Kill_Aura)
    end
})
v487:AddToggle({
    Name = "Auto Trial All Race",
    Description = "Auto Complete Trial",
    Default = false,
    Callback = function(v999)
        _G.AutoQuestRace = v999
        StopTween(_G.AutoQuestRace)
    end
})
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoQuestRace then
                if game:GetService("Players").LocalPlayer.Data.Race.Value == "Human" then
                    for _, v1001 in pairs(game.Workspace.Enemies:GetDescendants()) do
                        do
                            local l_v1001_0 = v1001
                            if l_v1001_0:FindFirstChild("Humanoid") and l_v1001_0:FindFirstChild("HumanoidRootPart") and l_v1001_0.Humanoid.Health > 0 then
                                pcall(function()
                                    repeat
                                        wait(0.1)
                                        l_v1001_0.Humanoid.Health = 0
                                        l_v1001_0.HumanoidRootPart.CanCollide = false
                                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                    until not _G.AutoQuestRace or not l_v1001_0.Parent or l_v1001_0.Humanoid.Health <= 0
                                end)
                            end
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Skypiea" then
                    for _, v1004 in pairs(game:GetService("Workspace").Map.SkyTrial.Model:GetDescendants()) do
                        if v1004.Name == "snowisland_Cylinder.081" then
                            topos(v1004.CFrame * CFrame.new(0, 0, 0))
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Fishman" then
                    if game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" then
                        topos(CFrame.new(28654, 14898.7832, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Ghoul" then
                        for _, v1006 in pairs(game.Workspace.Enemies:GetDescendants()) do
                            do
                                local l_v1006_0 = v1006
                                if l_v1006_0:FindFirstChild("Humanoid") and l_v1006_0:FindFirstChild("HumanoidRootPart") and l_v1006_0.Humanoid.Health > 0 then
                                    pcall(function()
                                        repeat
                                            wait(0.1)
                                            l_v1006_0.Humanoid.Health = 0
                                            l_v1006_0.HumanoidRootPart.CanCollide = false
                                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                        until not _G.AutoQuestRace or not l_v1006_0.Parent or l_v1006_0.Humanoid.Health <= 0
                                    end)
                                end
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
                        for _, v1009 in pairs(game:GetService("Workspace"):GetDescendants()) do
                            if v1009.Name == "StartPoint" then
                                topos(v1009.CFrame * CFrame.new(0, 3, 0))
                                _G.AutoQuestRace = false
                                StopTween(_G.AutoQuestRace)
                            end
                        end
                    end
                else
                    for _, v1011 in pairs(game:GetService("Workspace").SeaBeasts.SeaBeast1:GetDescendants()) do
                        if v1011.Name == "HumanoidRootPart" then
                            topos(v1011.CFrame * Pos)
                            for _, v1013 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v1013:IsA("Tool") and v1013.ToolTip == "Melee" then
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1013)
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            for _, v1015 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v1015:IsA("Tool") and v1015.ToolTip == "Blox Fruit" then
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1015)
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.5)
                            for _, v1017 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v1017:IsA("Tool") and v1017.ToolTip == "Sword" then
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1017)
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.5)
                            for _, v1019 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v1019:IsA("Tool") and v1019.ToolTip == "Gun" then
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1019)
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        end
                    end
                end
            end
        end
    end)
end)
v487:AddToggle({
    Name = "Auto Kill Player after Trial  V4",
    Description = "Auto Kill Players",
    Default = false,
    Callback = function(v1020)
        _G.AutoKillV4 = v1020
        StopTween(_G.AutoKillV4)
    end
})
spawn(function()
    while task.wait() do
        if _G.AutoKillV4 then
            pcall(function()
                for _, v1022 in pairs(game.Workspace.Characters:GetChildren()) do
                    if v1022.Name ~= game.Players.LocalPlayer.Name and v1022:FindFirstChild("Humanoid") and v1022:FindFirstChild("HumanoidRootPart") and v1022.Humanoid.Health > 0 and v1022.Parent and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v1022.HumanoidRootPart.Position).Magnitude <= 230 then
                        repeat
                            task.wait()
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            topos(v1022.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2))
                            v1022.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v1022.HumanoidRootPart.CanCollide = false
                            v1022.Head.CanCollide = false
                            v1022.Humanoid.WalkSpeed = 0
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        until not _G.AutoKillV4 or v1022.Humanoid.Health <= 0 or not v1022.Parent or not v1022:FindFirstChild("HumanoidRootPart") or not v1022:FindFirstChild("Humanoid")
                    end
                end
            end)
        end
    end
end)
v487:AddSection("Auto Skill")
v487:AddToggle({
    Name = "Auto Skill Z",
    Description = "Auto Use Skill Z",
    Default = false,
    Callback = function(v1024)
        _G.XaiSkillZ = v1024
        StopTween(_G.XaiSkillZ)
    end
})
v487:AddToggle({
    Name = "Auto Skill X",
    Description = "Auto Use Skill X",
    Default = false,
    Callback = function(v1025)
        _G.XaiSkillX = v1025
        StopTween(_G.XaiSkillX)
    end
})
v487:AddToggle({
    Name = "Auto Skill C",
    Description = "Auto Use Skill C",
    Default = false,
    Callback = function(v1026)
        _G.XaiSkillC = v1026
        StopTween(_G.XaiSkillC)
    end
})
end
v487:AddSection("Berrie")
v487:AddToggle({
    Name = "Auto Collect Berrie",
    Flag = "AutoCollectBerry",
    Description = "Collect Berries",
    Default = false,
    Callback = function(v628)
        CollectBerry = v628

        if not v628 then
            TweenModule:Stop()
        end
    end
})

local function BerryStillExists(Bush)
    if not Bush or not Bush.Parent then
        return false
    end

    for _, Part in ipairs(Bush:GetChildren()) do
        local Prompt = Part:FindFirstChildWhichIsA("ProximityPrompt")

        if Prompt and Prompt.Enabled then
            return true
        end
    end

    return false
end

task.spawn(function()
    while task.wait(Sec) do
        if CollectBerry and not TweenModule:IsTweening() then
            local CS = game:GetService("CollectionService")
            local Berries = CS:GetTagged("BerryBush")

            for _, Bush in ipairs(Berries) do
                if not CollectBerry then
                    break
                end

                local HasBerry = false

                for _, BerryName in pairs(Bush:GetAttributes()) do
                    if typeof(BerryName) == "string" and BerryName ~= "" then
                        if not BerryArray or table.find(BerryArray, BerryName) then
                            HasBerry = true
                            break
                        end
                    end
                end

                if HasBerry and Bush.Parent and BerryStillExists(Bush) then
                    TweenModule:Teleport(Bush.Parent:GetPivot())

                    while TweenModule:IsTweening() and CollectBerry do
                        task.wait(0.1)

                        if not BerryStillExists(Bush) then
                            TweenModule:Stop()
                            break
                        end
                    end

                    if not BerryStillExists(Bush) then
                        continue
                    end

                    for _, Part in ipairs(Bush:GetChildren()) do
                        if not CollectBerry then
                            break
                        end

                        local Prompt = Part:FindFirstChildWhichIsA("ProximityPrompt")

                        if Prompt and Prompt.Enabled then
                            TweenModule:Teleport(Part.CFrame)

                            while TweenModule:IsTweening() and CollectBerry do
                                task.wait(0.1)

                                if not Prompt.Parent or not Prompt.Enabled then
                                    TweenModule:Stop()
                                    break
                                end
                            end

                            if Prompt.Parent and Prompt.Enabled then
                                fireproximityprompt(Prompt, math.huge)
                            end
                        end
                    end
                end
            end
        end
    end
end)
if World3 then
v489:AddSection("Configs")
v489:AddToggle({
    Name = "Auto Drive Boats",
    Description = "",
    Default = false,
    Callback = function(v948)
        _G.SailBoat = v948
        StopTween(_G.SailBoat)
    end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.SailBoat and (not game:GetService("Workspace").Enemies:FindFirstChild("Shark") or not game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or not game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or not game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member")) then
                if game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
                    if game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
                        if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false then
                            TPP(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                        else
                            for _, v950 in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                                if v950.Name == "PirateBrigade" then
                                    repeat
                                        wait()
                                        if (CFrame.new(-17013.80078125, 10.962434768676758, 438.0169982910156).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                            TPB(CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581E-9, 0.967632651, 2.87320709E-8, 1, 3.21888249E-9, -0.967632651, 2.86144175E-8, -0.252362996))
                                        elseif (CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581E-9, 0.967632651, 2.87320709E-8, 1, 3.21888249E-9, -0.967632651, 2.86144175E-8, -0.252362996).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
                                            if (CFrame.new(-42250.2227, -0.3221744, 9247.07715, -0.45916447, 6.39043236E-8, 0.888351262, -3.36711423E-8, 1, -8.93395651E-8, -0.888351262, -7.09333605E-8, -0.45916447).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                                TPB(CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581E-9, 0.967632651, 2.87320709E-8, 1, 3.21888249E-9, -0.967632651, 2.86144175E-8, -0.252362996))
                                            end
                                        else
                                            TPB(CFrame.new(-42250.2227, -0.3221744, 9247.07715, -0.45916447, 6.39043236E-8, 0.888351262, -3.36711423E-8, 1, -8.93395651E-8, -0.888351262, -7.09333605E-8, -0.45916447))
                                        end
                                    until game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or _G.SailBoat == false
                                end
                            end
                        end
                    end
                else
                    buyb = TPP(CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781))
                    if (CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                        if buyb then
                            buyb:Stop()
                        end
                        local v951 = {[1] = "BuyBoat", [2] = "PirateBrigade"}
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v951))
                    end
                end
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.SailBoat and (game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member")) then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
        end
    end)
end)

v489:AddSection("Sea Events")
v489:AddToggle({
    Name = "Auto Kill Terror Shank",
    Description = "",
    Default = false,
    Callback = function(v952)
        _G.Autoterrorshark = v952
        StopTween(_G.Autoterrorshark)
    end
})
spawn(function()
    while wait() do
        if _G.Autoterrorshark and World3 then
            pcall(function()
                if not game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") and not game:GetService("Workspace").Enemies:FindFirstChild("Piranha") and not game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") and not game:GetService("Workspace").Enemies:FindFirstChild("Shark") and not game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") and not game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") and not game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                    topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))
                    for _, v954 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if v954.Name ~= "Terrorshark" then
                            game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        else
                            topos(v954.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                else
                    for _, v956 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v956.Name == "Terrorshark" and v956:FindFirstChild("Humanoid") and v956:FindFirstChild("HumanoidRootPart") and v956.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v956.HumanoidRootPart.CanCollide = false
                                v956.Humanoid.WalkSpeed = 0
                                v956.Head.CanCollide = false
                                topos(FarmModePosition(v956.HumanoidRootPart.Position))
                                MonFarm = v956.Name
                                PosMon = v956.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                if game:GetService("Workspace")._WorldOrigin:FindFirstChild("Typhoon Splash") then
                                    topos(v956.HumanoidRootPart.CFrame * CFrame.new(0, 300, 0))
                                else
                                    topos(v956.HumanoidRootPart.CFrame * CFrame.new(0, 60, 0))
                                end
                            until not _G.Autoterrorshark or not v956.Parent or v956.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.dao then
            pcall(function()
                if not game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.dao and game.Players.LocalPlayer.Character.Humanoid.Sit == true then
            TPB(CFrame.new(-25351.8418, 10.7575607, 26430.791, -0.998379767, -0.00721008703, -0.0564435199, -0.00722159958, 0.999973953, -1.53919405E-10, 0.0564420484, 4.07612359E-4, -0.998405814))
        end
    end
end)
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().SafeMode then
                local l_Character_9 = game.Players.LocalPlayer.Character
                if l_Character_9 and l_Character_9:FindFirstChild("Humanoid") and l_Character_9:FindFirstChild("HumanoidRootPart") then
                    local l_Humanoid_2 = l_Character_9.Humanoid
                    local l_HumanoidRootPart_5 = l_Character_9.HumanoidRootPart
                    if l_Humanoid_2.Health < 5500 then
                        while getgenv().SafeMode and l_Humanoid_2.Health < 5500 do
                            task.wait(0.1)
                            l_HumanoidRootPart_5.CFrame = l_HumanoidRootPart_5.CFrame + Vector3.new(0, 200, 0)
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        if _G.Nocliprock then
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                for _, v961 in pairs(game.Workspace.Boats:GetDescendants()) do
                    if v961:IsA("BasePart") and v961.CanCollide == true then
                        v961.CanCollide = false
                    end
                end
                for _, v963 in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v963:IsA("BasePart") and v963.CanCollide == true then
                        v963.CanCollide = false
                    end
                end
            elseif game.Players.LocalPlayer.Character.Humanoid.Sit == false then
                for _, v965 in pairs(game.Workspace.Boats:GetDescendants()) do
                    if v965:IsA("BasePart") and v965.CanCollide == false then
                        v965.CanCollide = true
                    end
                end
                for _, v967 in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v967:IsA("BasePart") and v967.CanCollide == false then
                        v967.CanCollide = true
                    end
                end
            end
        end
    end
end)
v489:AddToggle({
    Name = "Auto Kill Shark",
    Description = "",
    Default = false,
    Callback = function(v968)
        _G.KillShark = v968
        StopTween(_G.KillShark)
    end
})
spawn(function()
    while wait() do
        if _G.KillShark and World3 and _G.SailBoat then
            pcall(function()
                if not game:GetService("Workspace").Enemies:FindFirstChild("Shark") and not game:GetService("Workspace").Enemies:FindFirstChild("Piranha") and not game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") and not game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") and not game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") and not game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") and not game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                    topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))
                    for _, v970 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if not v970.Name == "Shark" then
                            game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        elseif v970.Name == "Shark" then
                            topos(v970.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                else
                    for _, v972 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v972.Name == "Shark" and v972:FindFirstChild("Humanoid") and v972:FindFirstChild("HumanoidRootPart") and v972.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v972.HumanoidRootPart.CanCollide = false
                                v972.Humanoid.WalkSpeed = 0
                                v972.Head.CanCollide = false
                                topos(FarmModePosition(v972.HumanoidRootPart.Position))
                                MonFarm = v972.Name
                                PosMon = v972.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.Humanoid.Sit = false
                            until not _G.KillShark or not v972.Parent or v972.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)
v489:AddToggle({
    Name = "Auto Kill Piranha",
    Description = "",
    Default = false,
    Callback = function(v973)
        _G.KillPiranha = v973
        StopTween(_G.KillPiranha)
    end
})
spawn(function()
    while wait() do
        if _G.KillPiranha and World3 then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                    for _, v975 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v975.Name == "Piranha" and v975:FindFirstChild("Humanoid") and v975:FindFirstChild("HumanoidRootPart") and v975.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v975.HumanoidRootPart.CanCollide = false
                                v975.Humanoid.WalkSpeed = 0
                                v975.Head.CanCollide = false
                                topos(FarmModePosition(v975.HumanoidRootPart.Position))
                                MonFarm = v975.Name
                                PosMon = v975.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.Humanoid.Sit = false
                            until not _G.KillPiranha or not v975.Parent or v975.Humanoid.Health <= 0
                        end
                    end
                else
                    topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))
                    for _, v977 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if not v977.Name == "Piranha" then
                            game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        elseif v977.Name == "Piranha" then
                            topos(v977.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                end
            end)
        end
    end
end)
v489:AddToggle({
    Name = "Auto Kill Fish Crew Member",
    Description = "",
    Default = false,
    Callback = function(v978)
        _G.KillFishCrew = v978
        StopTween(_G.KillFishCrew)
    end
})
spawn(function()
    while wait() do
        if _G.KillFishCrew and World3 then
            pcall(function()
                if not game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") and not game:GetService("Workspace").Enemies:FindFirstChild("Piranha") and not game:GetService("Workspace").Enemies:FindFirstChild("Shark") and not game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") and not game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") and not game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") and not game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                    topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))
                    for _, v980 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if not v980.Name == "Fish Crew Member" then
                            game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end
                else
                    for _, v982 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v982.Name == "Fish Crew Member" and v982:FindFirstChild("Humanoid") and v982:FindFirstChild("HumanoidRootPart") and v982.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v982.HumanoidRootPart.CanCollide = false
                                v982.Humanoid.WalkSpeed = 0
                                v982.Head.CanCollide = false
                                topos(FarmModePosition(v982.HumanoidRootPart.Position))
                                MonFarm = v982.Name
                                PosMon = v982.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.Humanoid.Sit = false
                            until not _G.KillFishCrew or not v982.Parent or v982.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
 end)
end

        local function v701(p696, p697)
            local v698 = v500:AddParagraph(
                p696 .. " : not Spawn"
            )
            while task.wait() do
                local v699 = vu21:FindFirstChild(p697)
                if v699 then
                    local v700 = vu14
                    v698:SetTitle(p696 .. " : Spawned | Distance : " .. math.floor(v700:DistanceFromCharacter(v699.WorldPivot.Position) / 5))
                else
                    v698:SetTitle(p696 .. " : not Spawn")
                    vu21.ChildAdded:Wait()
                end
            end
        end
        if World3 then
        v500:AddSection("Islands Stats")
        task.spawn(v701, "Mirage Island", "MysticIsland")
        task.spawn(v701, "Kitsune Island", "KitsuneIsland")
        task.spawn(v701, "Prehistoric Island", "PrehistoricIsland")
v500:AddSection("Leviathan [ BETA ]")
v500:AddButton({
     Name = "Buy Spy",
     Callback = function()
         replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
    end
})

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

getgenv().LeviathanSpeed = 300

local function TeleportTo(targetCFrame)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    
    local tweenInfo = TweenInfo.new(distance / getgenv().LeviathanSpeed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Wait()
end

local function EquipWeapon()
    if _G.SelectWeapon and Player.Backpack:FindFirstChild(_G.SelectWeapon) then
        Player.Character.Humanoid:EquipTool(Player.Backpack:FindFirstChild(_G.SelectWeapon))
    end
end

local function ActivateBuso()
    if not Player.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

getgenv().AutoLeviathan = false

v500:AddToggle({
    Title = "Auto Attack Leviathan",
    Default = false,
    Callback = function(Value)
        getgenv().AutoLeviathan = Value
    end
})

spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoLeviathan then
            for _, leviathan in pairs(Workspace.SeaBeasts:GetChildren()) do
                if leviathan.Name == "Leviathan" and leviathan:FindFirstChild("HumanoidRootPart") then
                    
                    EquipWeapon()
                    ActivateBuso()
                    
                    local targetPos = leviathan.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)
                    TeleportTo(targetPos)
                    
                    repeat
                        task.wait(0.1)
                        
                        if (Player.Character.HumanoidRootPart.Position - leviathan.HumanoidRootPart.Position).Magnitude > 600 then
                            TeleportTo(leviathan.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
                        end
                        
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        
                    until not leviathan.Parent or not leviathan:FindFirstChild("Humanoid") or leviathan.Humanoid.Health <= 0 or not getgenv().AutoLeviathan
                end
            end
        end
    end
end)

v500:AddToggle({
    Name = "Teleport Frozen Dimension",
    Description = "Auto Tween to Frozen Dimension",
    Default =  false,
    Callback = function(Value)
      _G.FrozenTP = Value
        end
    })
    
    spawn(function()
        while wait(0.1) do
            if _G.FrozenTP then
                pcall(function()
                    if workspace.Map:FindFirstChild("LeviathanGate") then
                        TP1(workspace.Map.LeviathanGate.CFrame)
                        replicated.Remotes.CommF_:InvokeServer("OpenLeviathanGate")
                    end
                end)
            end
        end
    end)

v500:AddSection("Prehistoric Island")
v500:AddToggle({
    Name = "Auto Dragon Hunter Quests",
    Description = "turn on for farm blaze ember + auto collect blaze ember",
    Default = false,
    Callback = function(v)
        _G.FarmBlazeEM = v
    end,
})

checkQuesta = function()
    local args = { [1] = { Context = "Check" } }
    local result

    pcall(function()
        local req = { [1] = { Context = "RequestQuest" } }
        game:GetService("ReplicatedStorage").Modules.Net["RF/DragonHunter"]:InvokeServer(unpack(req))
    end)

    pcall(function()
        result = game:GetService("ReplicatedStorage").Modules.Net["RF/DragonHunter"]:InvokeServer(unpack(args))
    end)

    local hasQuest = false
    local mobName, amount, questType

    if result and result.Text then
        hasQuest = true
        local txt = tostring(result.Text)

        if txt:find("Defeat") then
            questType = 1
            amount = tonumber(string.sub(txt, 8, 9))

            local mobs = { "Hydra Enforcer", "Venomous Assailant" }
            for _, m in pairs(mobs) do
                if txt:find(m) then
                    mobName = m
                    break
                end
            end

        elseif txt:find("Destroy") then
            questType = 2
            amount = 10
        end
    end

    return hasQuest, mobName, amount, questType
end

BackTODoJo = function()
    for _, v in pairs(game.Players.LocalPlayer.PlayerGui.Notifications:GetChildren()) do
        if v.Name == "NotificationTemplate" and tostring(v.Text):find("Head back to the Dojo") then
            return true
        end
    end
    return false
end

DragonMobClear = function(useKill, mobName)
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            TP1(mob.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
            if useKill then
                G.Kill(mob, true)
            end
        end
    end
end

task.spawn(function()
    while task.wait() do
        if _G.FarmBlazeEM then
            pcall(function()
                local hasQuest, mobName, _, questType = checkQuesta()

                if hasQuest and not BackTODoJo() then

                    if questType == 1 and mobName then
                        repeat
                            task.wait()
                            DragonMobClear(true, mobName)
                        until not _G.FarmBlazeEM or BackTODoJo()

                    elseif questType == 2 then
                        local tree = workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true)

                        if tree then
                            repeat
                                task.wait()

                                TP1(tree.CFrame * CFrame.new(4,0,0))

                                if (tree.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 200 then
                                    MousePos = tree.Position

                                    Useskills("Melee","Z")
                                    Useskills("Melee","X")
                                    Useskills("Melee","C")

                                    task.wait(0.5)

                                    Useskills("Sword","Z")
                                    Useskills("Sword","X")

                                    task.wait(0.5)

                                    Useskills("Blox Fruit","Z")
                                    Useskills("Blox Fruit","X")
                                    Useskills("Blox Fruit","C")

                                    task.wait(0.5)

                                    Useskills("Gun","Z")
                                    Useskills("Gun","X")
                                end

                            until not _G.FarmBlazeEM or BackTODoJo()
                        end
                    end

                elseif BackTODoJo() then
                    TP1(CFrame.new(5813, 1208, 884))
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.FarmBlazeEM then
            pcall(function()
                local ember = workspace:FindFirstChild("EmberTemplate")
                if ember and ember:FindFirstChild("Part") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ember.Part.CFrame
                end
            end)
        end
    end
end)
v500:AddButton({
    Title = "Craft Volcanic Magnet",
    Value = false,
    Callback = function()
        local v849 = {[1] = "CraftItem", [2] = "Craft", [3] = "Volcanic Magnet"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v849))
    end
})

v500:AddToggle({
    Name = "Auto Find Prehistoric",
    Description = "",
    Default = false,
    Callback = function(v851)
        _G.Nocliprock = v851
        StopTween(_G.Nocliprock)
    end
})
local v852 = {}
local l_Players_0 = game:GetService("Players")
local l_RunService_0 = game:GetService("RunService")
local l_VirtualInputManager_3 = game:GetService("VirtualInputManager")
local l_Workspace_1 = game:GetService("Workspace")
local v857 = 350
l_RunService_0.RenderStepped:Connect(function()
    for v858, v859 in pairs(v852) do
        if v859 and v859.Parent and v859.Name == "VehicleSeat" and not v859.Occupant then
            v852[v858] = v859
        end
    end
end)
local _ = function()
    for _, v861 in pairs(v852) do
        if v861 and v861.Parent and v861.Name == "VehicleSeat" and not v861.Occupant then
            topos(v861.CFrame)
        end
    end
end
local v863 = false
local v864 = false
l_RunService_0.RenderStepped:Connect(function()
    if _G.AutoFindPrehistoric then
        local l_Character_8 = l_Players_0.LocalPlayer.Character
        if l_Character_8 and l_Character_8:FindFirstChild("Humanoid") then
            local function v868()
                if not v863 then
                    v863 = true
                    for _, v867 in pairs(v852) do
                        if v867 and v867.Parent and v867.Name == "VehicleSeat" and not v867.Occupant then
                            topos(v867.CFrame)
                            break
                        end
                    end
                    v863 = false
                    return 
                else
                    return 
                end
            end
            local l_Humanoid_1 = l_Character_8.Humanoid
            local v870 = false
            local v871 = nil
            for _, v873 in pairs(l_Workspace_1.Boats:GetChildren()) do
                local l_VehicleSeat_0 = v873:FindFirstChild("VehicleSeat")
                if l_VehicleSeat_0 and l_VehicleSeat_0.Occupant == l_Humanoid_1 then
                    v870 = true
                    v871 = l_VehicleSeat_0
                    v852[v873.Name] = l_VehicleSeat_0
                elseif l_VehicleSeat_0 and l_VehicleSeat_0.Occupant == "Name" then
                    v868()
                end
            end
            if v870 then
                v871.MaxSpeed = v857
                v871.CFrame = CFrame.new(Vector3.new(v871.Position.X, v871.Position.Y, v871.Position.Z)) * v871.CFrame.Rotation
                l_VirtualInputManager_3:SendKeyEvent(true, "W", false, game)
                for _, v876 in pairs(l_Workspace_1.Boats:GetDescendants()) do
                    if v876:IsA("BasePart") then
                        v876.CanCollide = false
                    end
                end
                for _, v878 in pairs(l_Character_8:GetDescendants()) do
                    if v878:IsA("BasePart") then
                        v878.CanCollide = false
                    end
                end
                for _, v880 in ipairs({
                    "ShipwreckIsland",
                    "SandIsland",
                    "TreeIsland",
                    "TinyIsland",
                    "MysticIsland",
                    "KitsuneIsland",
                    "FrozenDimension"
                }) do
                    local l_FirstChild_6 = l_Workspace_1.Map:FindFirstChild(v880)
                    if l_FirstChild_6 and l_FirstChild_6:IsA("Model") then
                        l_FirstChild_6:Destroy()
                    end
                end
                if l_Workspace_1.Map:FindFirstChild("PrehistoricIsland") then
                    l_VirtualInputManager_3:SendKeyEvent(false, "W", false, game)
                    _G.AutoFindPrehistoric = false
                    if not v864 then
                        v864 = true
                    end
                    return 
                else
                    return 
                end
            else
                return 
            end
        else
            return 
        end
    else
        v864 = false
        return 
    end
end)

v500:AddToggle({
    Name = "Auto Tween Prehistoric Island",
    Description = "Tween to Prehistoric Island",
    Default = false,
    Callback = function(v882)
        _G.TweenVolcano = v882
        StopTween(_G.TweenVolcano)
    end
})
spawn(function()
    local v883 = nil
    while not v883 do
        v883 = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
        wait()
    end
    while wait() do
        if _G.TweenVolcano then
            local l_PrehistoricIsland_0 = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
            if l_PrehistoricIsland_0 then
                local v885 = l_PrehistoricIsland_0:FindFirstChild("Core") and l_PrehistoricIsland_0.Core:FindFirstChild("PrehistoricRelic")
                local v886 = v885 and v885:FindFirstChild("Skull")
                if v886 then
                    TP1(CFrame.new(v886.Position))
                    _G.TweenVolcano = false
                end
            end
        end
    end
end)
v500:AddToggle({
    Name = "Auto Prehistoric",
    Description = "Auto Complete Prehistoric Island",
    Default = false,
    Callback = function(v887)
        _G.DefendVolcano = v887
        StopTween(_G.DefendVolcano)
    end
})
local function v889(v888)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, v888, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, v888, false, game)
end
local function v898()
    local l_InteriorLava_0 = game.Workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava")
    if l_InteriorLava_0 and l_InteriorLava_0:IsA("Model") then
        l_InteriorLava_0:Destroy()
    end
    local l_PrehistoricIsland_1 = game.Workspace.Map:FindFirstChild("PrehistoricIsland")
    if l_PrehistoricIsland_1 then
        for _, v893 in pairs(l_PrehistoricIsland_1:GetDescendants()) do
            if v893:IsA("Part") and v893.Name:lower():find("lava") then
                v893:Destroy()
            end
        end
    end
    if l_PrehistoricIsland_1 then
        for _, v895 in pairs(l_PrehistoricIsland_1:GetDescendants()) do
            if v895:IsA("Model") then
                for _, v897 in pairs(v895:GetDescendants()) do
                    if v897:IsA("MeshPart") and v897.Name:lower():find("lava") then
                        v897:Destroy()
                    end
                end
            end
        end
    end
end
local function v904()
    local l_VolcanoRocks_0 = game.Workspace.Map.PrehistoricIsland.Core.VolcanoRocks
    for _, v901 in pairs(l_VolcanoRocks_0:GetChildren()) do
        if v901:IsA("Model") then
            local l_volcanorock_0 = v901:FindFirstChild("volcanorock")
            if l_volcanorock_0 and l_volcanorock_0:IsA("MeshPart") then
                local l_Color_0 = l_volcanorock_0.Color
                if l_Color_0 == Color3.fromRGB(185, 53, 56) or l_Color_0 == Color3.fromRGB(185, 53, 57) then
                    return l_volcanorock_0
                end
            end
        end
    end
    return nil
end
local function v913(v905)
    local l_LocalPlayer_13 = game.Players.LocalPlayer
    local l_Backpack_2 = l_LocalPlayer_13.Backpack
    for _, v909 in pairs(l_Backpack_2:GetChildren()) do
        if v909:IsA("Tool") and v909.ToolTip == v905 then
            v909.Parent = l_LocalPlayer_13.Character
            for _, v911 in ipairs({"Z", "X", "C", "V", "F"}) do
                wait()
                do
                    local l_v911_0 = v911
                    pcall(function()
                        v889(l_v911_0)
                    end)
                end
            end
            v909.Parent = l_Backpack_2
            break
        end
    end
end
spawn(function()
    while wait() do
        if _G.DefendVolcano then
            AutoHaki()
            pcall(v898)
            local v914 = v904()
            if not v914 then
                _G.TpPrehistoric = true
            else
                local v915 = CFrame.new(v914.Position)
                TP1(v915)
                local l_Color_1 = v914.Color
                if l_Color_1 == Color3.fromRGB(185, 53, 56) or l_Color_1 == Color3.fromRGB(185, 53, 57) then
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v914.Position).Magnitude <= 1 then
                        if _G.UseMelee then
                            v913("Melee")
                        end
                        if _G.UseSword then
                            v913("Sword")
                        end
                        if _G.UseGun then
                            v913("Gun")
                        end
                    end
                    _G.TpPrehistoric = false
                else
                    v914 = v904()
                end
            end
        end
    end
end)
v500:AddToggle({
    Name = "Auto Use Melee",
    Description = "",
    Default = false,
    Callback = function(v918)
        _G.UseMelee = v918
        StopTween(_G.UseMelee)
    end
})
v500:AddToggle({
    Name = "Auto Use Sword",
    Description = "",
    Default = false,
    Callback = function(v919)
        _G.UseSword = v919
        StopTween(_G.UseSword)
    end
})
v500:AddToggle({
    Name = "Auto Use Gun",
    Description = "",
    Default = false,
    Callback = function(v920)
        _G.UseGun = v920
        StopTween(_G.UseGun)
    end
})
v500:AddToggle({
    Name = "Auto Kill Golem",
    Description = "Kill Golem",
    Default = false,
    Callback = function(v922)
        _G.KillGolem = v922
        StopTween(_G.KillGolem)
    end
})
spawn(function()
    while wait() do
        if _G.KillGolem and World3 then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Lava Golem") then
                    for _, v924 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v924.Name == "Lava Golem" and v924:FindFirstChild("Humanoid") and v924:FindFirstChild("HumanoidRootPart") and v924.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v924.HumanoidRootPart.CanCollide = false
                                v924.Humanoid.WalkSpeed = 0
                                v924.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                topos(v924.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                            until not _G.KillGolem or not v924.Parent or v924.Humanoid.Health <= 0
                        end
                    end
                else
                    UnEquipWeapon(_G.SelectWeapon)
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Lava Golem") then
                        topos(game:GetService("ReplicatedStorage"):FindFirstChild("Lava Golem").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end
            end)
        end
    end
end)
v500:AddToggle({
    Name = "Auto Kill Aura Golem",
    Description = "Kill Aura Golem",
    Default = false,
    Callback = function(v925)
        _G.Kill_Aura = v925
        StopTween(_G.Kill_Aura)
    end
})
spawn(function()
    pcall(function()
        while wait() do
            if _G.Kill_Aura then
                local l_LocalPlayer_14 = game:GetService("Players").LocalPlayer
                local l_Children_0 = game:GetService("Workspace").Enemies:GetChildren()
                local v928 = l_LocalPlayer_14.Character and l_LocalPlayer_14.Character:FindFirstChild("HumanoidRootPart") and l_LocalPlayer_14.Character.HumanoidRootPart.Position
                do
                    local l_l_LocalPlayer_14_0 = l_LocalPlayer_14
                    if v928 then
                        for _, v931 in pairs(l_Children_0) do
                            do
                                local l_v931_0 = v931
                                if l_v931_0:FindFirstChild("Humanoid") and l_v931_0:FindFirstChild("HumanoidRootPart") and l_v931_0.Humanoid.Health > 0 and (l_v931_0.HumanoidRootPart.Position - v928).Magnitude <= 1000 then
                                    pcall(function()
                                        repeat
                                            wait()
                                            sethiddenproperty(l_l_LocalPlayer_14_0, "SimulationRadius", math.huge)
                                            l_v931_0.Humanoid.Health = 0
                                            l_v931_0.HumanoidRootPart.CanCollide = false
                                        until not _G.Kill_Aura or not l_v931_0.Parent or l_v931_0.Humanoid.Health <= 0
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)
v500:AddToggle({
    Name = "Auto Collect Bone",
    Description = "",
    Default = false,
    Callback = function(v934)
        _G.AutoCollectBone = v934
        StopTween(_G.AutoCollectBone)
    end
})
spawn(function()
    while wait() do
        if _G.AutoCollectBone then
            for _, v936 in pairs(workspace:GetDescendants()) do
                if v936:IsA("BasePart") and v936.Name == "DinoBone" then
                    topos(CFrame.new(v936.Position))
                end
            end
        end
    end
end)
v500:AddToggle({
    Name = "Auto Collect Egg",
    Description = "",
    Default = false,
    Callback = function(v937)
        _G.CollectEgg = v937
        StopTween(_G.CollectEgg)
    end
})
spawn(function()
    while wait() do
        if _G.CollectEgg then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/CollectedDragonEgg"):FireServer()
            end)
        end
    end
end)
v500:AddSection("Kitsune Island")
v500:AddToggle({
    Name = "Auto Tween Kitsune island",
    Description = "Auto Tween to Kitsune island",
    Default = false,
    Callback = function(v940)
        _G.TweenToKitsune = v940
        StopTween(_G.TweenToKitsune)
    end
})
spawn(function()
    local v941 = nil
    while not v941 do
        v941 = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland")
        wait(1)
    end
    while wait() do
        if _G.TweenToKitsune then
            local v942 = v941.FindFirstChild(v941, "ShrineActive")
            if v942 then
                for _, v944 in pairs(v942:GetDescendants()) do
                    if v944:IsA("BasePart") and v944.Name:find("NeonShrinePart") then
                        Tween(v944.CFrame)
                    end
                end
            end
        end
    end
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.TweenToKitsune then
                topos(game.Workspace.Map.KitsuneIsland.ShrineActive.NeonShrinePart.CFrame * CFrame.new(0, 0, 10))
            end
        end
    end)
end)
v500:AddToggle({
    Name = "Auto Azuer Ember",
    Description = "Auto Collect Azuer Ember",
    Default = false,
    Callback = function(v946)
        _G.AutoAzuerEmber = v946
        StopTween(_G.AutoAzuerEmber)
    end
})
spawn(function()
    while wait() do
        if _G.AutoAzuerEmber then
            pcall(function()
                if game:GetService("Workspace"):FindFirstChild("AttachedAzureEmber") then
                    TP1(game.Workspace.EmberTemplate.Part.CFrame)
                end
            end)
        end
    end
end)
v500:AddToggle({
    Name = "Auto Trade Azure Ember",
    Description = "Trade Azure Ember",
    Default = false,
    Callback = function(I)
        _G.Trade_Ember = I       
    end,
})
spawn(function()
	while wait(.1) do
		if _G.Trade_Ember then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
					(replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray")):InvokeServer()
				end
			end)
		end
	end
end)

v500:AddSection("Mirage Island")
v500:AddToggle({
    Name = "Tween Mirage Island",
    Description = "Auto Tween to Mirage Island",
    Default = false,
    Callback = function(v985)
        _G.AutoMysticIsland = v985
        StopTween(_G.AutoMysticIsland)
    end
})
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.AutoMysticIsland then
                for _, v987 in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
                    if v987.Name == "Mirage Island" then
                        topos(v987.CFrame * CFrame.new(0, 333, 0))
                    end
                end
            end
        end)
    end
end)
v500:AddToggle({
    Name = "Look Moon",
    Description = "Auto Look Moon",
    Default = false,
    Callback = function(v989)
        _G.AutoDooHee = v989
        StopTween(_G.AutoDooHee)
    end
})
local l_VirtualInputManager_4 = game:GetService("VirtualInputManager")
spawn(function()
    while wait() do
        pcall(function()
            if getgenv()._G.AutoDooHee then
                local l_MoonDirection_0 = game.Lighting:GetMoonDirection()
                local v992 = game.Workspace.CurrentCamera.CFrame.p + l_MoonDirection_0 * 100
                game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.p, v992)
                wait(2)
                l_VirtualInputManager_4:SendKeyEvent(true, "T", false, game)
                wait(0.1)
                l_VirtualInputManager_4:SendKeyEvent(false, "T", false, game)
            end
        end)
    end
end)
v500:AddToggle({
    Name = "Auto Tween To Gear",
    Description = "",
    Default = false,
    Callback = function(v993)
        _G.TweenMGear = v993
        StopTween(_G.TweenMGear)
    end
})
spawn(function()
    pcall(function()
        while wait() do
            if _G.TweenMGear and game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
                for _, v995 in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do
                    if v995:IsA("MeshPart") and v995.Material == Enum.Material.Neon then
                        topos(v995.CFrame)
                    end
               end
            end
         end
     end)
  end)
end
v491:AddSection("Fruits")
v491:AddToggle({
    Title = "Auto Store Fruits",
    Description = "Automatically save fruits to inventory",
    Flag = "flag6",
    Value = false,
    Callback = function(v1075)
        getgenv().AutoStoreFruit = v1075
    end
})
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoStoreFruit then
            pcall(function()
                local l_LocalPlayer_16 = game:GetService("Players").LocalPlayer
                local v1077 = l_LocalPlayer_16.Character or l_LocalPlayer_16.CharacterAdded:Wait()
                local l_Backpack_3 = l_LocalPlayer_16:WaitForChild("Backpack")
                for _, v1080 in ipairs({
                    {"Rocket Fruit", "Rocket-Rocket"},
                    {"Spin Fruit", "Spin-Spin"},
                    {"Blade Fruit", "Blade-Blade"},
                    {"Spring Fruit", "Spring-Spring"},
                    {"Bomb Fruit", "Bomb-Bomb"},
                    {"Smoke Fruit", "Smoke-Smoke"},
                    {"Spike Fruit", "Spike-Spike"},
                    {"Flame Fruit", "Flame-Flame"},
                    {"Eagle Fruit", "Eagle-Eagle"},
                    {"Ice Fruit", "Ice-Ice"},
                    {"Sand Fruit", "Sand-Sand"},
                    {"Dark Fruit", "Dark-Dark"},
                    {"Diamond Fruit", "Diamond-Diamond"},
                    {"Light Fruit", "Light-Light"},
                    {"Rubber Fruit", "Rubber-Rubber"},
                    {"Creation Fruit", "Creation-Creation"},
                    {"Ghost Fruit", "Ghost-Ghost"},
                    {"Magma Fruit", "Magma-Magma"},
                    {"Quake Fruit", "Quake-Quake"},
                    {"Buddha Fruit", "Buddha-Buddha"},
                    {"Love Fruit", "Love-Love"},
                    {"Spider Fruit", "Spider-Spider"},
                    {"Sound Fruit", "Sound-Sound"},
                    {"Phoenix Fruit", "Phoenix-Phoenix"},
                    {"Portal Fruit", "Portal-Portal"},
                    {"Lightning Fruit", "Lightning-Lightning"},
                    {"Pain Fruit", "Pain-Pain"},
                    {"Blizzard Fruit", "Blizzard-Blizzard"},
                    {"Gravity Fruit", "Gravity-Gravity"},
                    {"Mammoth Fruit", "Mammoth-Mammoth"},
                    {"T-Rex Fruit", "T-Rex-T-Rex"},
                    {"Dough Fruit", "Dough-Dough"},
                    {"Shadow Fruit", "Shadow-Shadow"},
                    {"Venom Fruit", "Venom-Venom"},
                    {"Gas Fruit", "Gas-Gas"},
                    {"Control Fruit", "Control-Control"},
                    {"Spirit Fruit", "Spirit-Spirit"},
                    {"Leopard Fruit", "Leopard-Leopard"},
                    {"Yeti Fruit", "Yeti-Yeti"},
                    {"Kitsune Fruit", "Kitsune-Kitsune"},
                    {"Dragon Fruit", "Dragon-Dragon"}
                }) do
                    local v1081 = v1080[1]
                    local v1082 = v1080[2]
                    local v1083 = l_Backpack_3:FindFirstChild(v1081) or v1077:FindFirstChild(v1081)
                    if v1083 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v1082, v1083)
                        break
                    end
                end
            end)
        end
    end
end)
v491:AddToggle({
    Name = "Auto Teleport to Fruits",
    Description = "Collect Fruits on the Map",
    Flag = "S-TPfruits",
    Default = false,
    Callback = function(v1087)
        _G.Grabfruit = v1087
        if not v1087 then
            TweenModule:Stop()
            getgenv().OnFarm = false
            shouldTween = false
            if getgenv().currentTween then
                getgenv().currentTween:Cancel()
                getgenv().currentTween = nil
                getgenv().currentTarget = nil
            end
        end
    end
})

spawn(function()
    while task.wait(0.1) do
        if _G.Grabfruit then
            local FoundFruit = false
            local Char = game.Players.LocalPlayer.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then 
                task.wait(0.5)
                continue 
            end
            
            local hrp = Char.HumanoidRootPart
            
            for _, v1089 in pairs(workspace:GetChildren()) do  
                if string.find(v1089.Name, "Fruit") and v1089:FindFirstChild("Handle") then  
                    FoundFruit = true  
                    if _tp then
                        _tp(v1089.Handle.CFrame)
                    else
                        hrp.CFrame = v1089.Handle.CFrame
                    end
                    break
                end  
            end  

            if not FoundFruit then
                task.wait(0.5)
            end
        else
            task.wait(0.5)
        end
    end
end)
v491:AddSection("Gacha")
v491:AddToggle({
    Name = "⚠️Auto Random Fruits",
    Description = "Automatic Random Fruits",
    Default = false,
    Callback = function(v1074)
        _G.RandomAuto = v1074
    end
})
spawn(function()
    pcall(function()
        while wait() do
            if _G.RandomAuto then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end
        end
    end)
end)

v491:AddSection("Raid")
if World1 then
    v491:AddParagraph("Raids only works in Sea 2 or 3", "This only works in Sea 2 and 3")
else

_G.SelectChip = "Flame"
_G.AutoBuyChip = false
_G.StartRaid = false
_G.Dungeon = false

v491:AddDropdown({
    Name = "Select Chip",
    Options = {
        "Flame","Ice","Sand","Dark","Light","Magma",
        "Quake","Buddha","Spider","Phoenix","Lightning","Dough"
    },
    Default = "Flame",
    Callback = function(v)
        _G.SelectChip = v
    end
})

v491:AddButton({
    Name = "⚠️Buy Chip",
    Default = false,
    Callback = function(v)
        _G.AutoBuyChip = v
    end
})

v491:AddToggle({
    Name = "⚠️Auto Buy Chip",
    Default = false,
    Callback = function(v)
        _G.AutoBuyChip = v
    end
})

task.spawn(function()
    while task.wait(1) do
        if _G.AutoBuyChip and _G.SelectChip then
            pcall(function()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "RaidsNpc",
                    "Select",
                    _G.SelectChip
                )
            end)
        end
    end
end)

v491:AddToggle({
    Name = "Auto Start Raid",
    Default = false,
    Callback = function(v)
        _G.StartRaid = v
    end
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if not _G.StartRaid then return end

            local lp = game.Players.LocalPlayer
            local gui = lp.PlayerGui:FindFirstChild("Main")
            if not gui then return end

            if gui.Timer.Visible then return end
            if workspace._WorldOrigin.Locations:FindFirstChild("Island 1") then return end
            if not (lp.Backpack:FindFirstChild("Special Microchip") or lp.Character:FindFirstChild("Special Microchip")) then return end

            if World2 then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
                fireclickdetector(workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
            elseif World3 then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "requestEntrance",
                    Vector3.new(-5075.5, 314.51, -3150.02)
                )
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
                fireclickdetector(workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
            end
        end)
    end
end)

v491:AddToggle({
    Name = "Auto Complete Raid",
    Default = false,
    Callback = function(v)
        _G.Dungeon = v
    end
})

local function GetIsland(num)
    local closest, dist = nil, math.huge
    for _,v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
        if v.Name == "Island "..num then
            local mag = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = v
            end
        end
    end
    return closest
end

local function GetNextIsland()
    for _,i in ipairs({5,4,3,2,1}) do
        local isl = GetIsland(i)
        if isl and (isl.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4500 then
            return isl
        end
    end
end

local function FarmRaidEnemies()
    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart")
        and mob:FindFirstChild("Humanoid")
        and mob.Humanoid.Health > 0
        and (mob.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000 then
            repeat
                task.wait(0.1)
                if mob.Humanoid.Health > 0 then
                    EquipWeapon(_G.SelectWeapon)
                    topos(mob.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                end
            until mob.Humanoid.Health <= 0 or not _G.Dungeon
        end
    end
end

task.spawn(function()
    while task.wait() do
        if _G.Dungeon then
            FarmRaidEnemies()
            local isl = GetNextIsland()
            if isl then
                topos(isl.CFrame * CFrame.new(0,60,0))
            end
        end
    end
end)
end

TabHop:AddSection("Coming Soon")
local v1117 = nil
if not World1 then
    if World2 then
        v1117 = {
            "The Cafe",
            "Frist Spot",
            "Dark Area",
            "Flamingo Mansion",
            "Flamingo Room",
            "Green Zone",
            "Factory",
            "Colossuim",
            "Zombie Island",
            "Two Snow Mountain",
            "Punk Hazard",
            "Cursed Ship",
            "Ice Castle",
            "Forgotten Island",
            "Ussop Island",
            "Mini Sky Island"
        }
    elseif World3 then
        v1117 = {
            "Mansion",
            "Port Town",
            "Great Tree",
            "Castle On The Sea",
            "MiniSky",
            "Hydra Island",
            "Floating Turtle",
            "Haunted Castle",
            "Ice Cream Island",
            "Peanut Island",
            "Cake Island",
            "Cocoa Island",
            "Candy Island",
            "Tiki Outpost",
            "Dragon Dojo"
        }
    else
        v1117 = {"Spawn"}
    end
else
    v1117 = {
        "WindMill",
        "Marine",
        "Middle Town",
        "Jungle",
        "Pirate Village",
        "Desert",
        "Snow Island",
        "MarineFord",
        "Colosseum",
        "Sky Island 1",
        "Sky Island 2",
        "Sky Island 3",
        "Prison",
        "Magma Village",
        "Under Water Island",
        "Fountain City",
        "Shank Room",
        "Mob Island"
    }
end

local MansionCFrame = CFrame.new(-12471.17, 374.94, -7551.678)

local Islands = {
    ["WindMill"] = CFrame.new(979.799, 16.516, 1429.047),
    ["Marine"] = CFrame.new(-2566.43, 6.856, 2045.256),
    ["Middle Town"] = CFrame.new(-690.331, 15.094, 1582.238),
    ["Jungle"] = CFrame.new(-1612.796, 36.852, 149.128),
    ["Pirate Village"] = CFrame.new(-1181.309, 4.751, 3803.546),
    ["Desert"] = CFrame.new(944.158, 20.92, 4373.3),
    ["Snow Island"] = CFrame.new(1347.807, 104.668, -1319.737),
    ["MarineFord"] = CFrame.new(-4914.821, 50.964, 4281.028),
    ["Magma Village"] = CFrame.new(-5247.716, 12.884, 8504.969),
    ["Fountain City"] = CFrame.new(5127.128, 59.501, 4105.446),
    ["Sky Island 1"] = CFrame.new(-483.734, 332.038, 595.327),
    ["Sky Island 2"] = CFrame.new(2284.414, 15.152, 875.725),
    ["Sky Island 3"] = CFrame.new(-2448.53, 73.016, -3210.631),
    ["Prison"] = CFrame.new(4875.33, 5.652, 734.85),
    ["Colosseum"] = CFrame.new(-11.311, 29.277, 2771.522),
    ["Under Water Island"] = CFrame.new(-2850.201, 7.392, 5354.993),
    ["Shank Room"] = CFrame.new(-1442.166, 29.879, -28.355),
    ["Mob Island"] = CFrame.new(-2850.201, 7.392, 5354.993),
    ["The Cafe"] = CFrame.new(-380.479, 77.22, 255.826),
    ["Dark Area"] = CFrame.new(3780.03, 22.652, -3498.586),
    ["Factory"] = CFrame.new(424.127, 211.162, -427.54),
    ["Colossuim"] = CFrame.new(-1503.622, 219.796, 1369.31),
    ["Two Snow Mountain"] = CFrame.new(753.143, 408.236, -5274.615),
    ["Punk Hazard"] = CFrame.new(-6127.654, 15.952, -5040.286),
    ["Ussop Island"] = CFrame.new(4816.862, 8.46, 2863.82),
    ["Mini Sky Island"] = CFrame.new(-288.741, 49326.316, -35248.594),
    ["Great Tree"] = CFrame.new(2681.274, 1682.809, -7190.985),
    ["Port Town"] = CFrame.new(-226.751, 20.603, 5538.34),
    ["Hydra Island"] = CFrame.new(5291.249, 1005.443, 393.762),
    ["Floating Turtle"] = CFrame.new(-13274.528, 531.821, -7579.223),
    ["Mansion"] = MansionCFrame,
    ["Haunted Castle"] = CFrame.new(-9515.372, 164.006, 5786.061),
    ["Ice Cream Island"] = CFrame.new(-902.568, 79.932, -10988.848),
    ["Peanut Island"] = CFrame.new(-2062.748, 50.474, -10232.568),
    ["Cake Island"] = CFrame.new(-1884.775, 19.328, -11666.897),
    ["Cocoa Island"] = CFrame.new(87.943, 73.555, -12319.465),
    ["Candy Island"] = CFrame.new(-1014.424, 149.111, -14555.963),
    ["Tiki Outpost"] = CFrame.new(-16218.683, 9.086, 445.618),
    ["Dragon Dojo"] = CFrame.new(5743.319, 1206.91, 936.011)
}

local function TryPortal(position)
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return false end

    local hrp = Character.HumanoidRootPart
    local oldPos = hrp.Position

    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", position)
    end)

    task.wait(1)

    return (hrp.Position - oldPos).Magnitude > 500
end

local function TeleportToIsland()
    if not SelectIsland or not TeleportIsland then return end

    local cf = Islands[SelectIsland]
    if not cf then return end

    if SelectIsland == "Mansion" then
        if not TryPortal(Vector3.new(cf.X, cf.Y, cf.Z)) then
            TweenModule:Teleport(cf)
        end
        return
    end

    if SelectIsland == "Castle On The Sea" then
        local pos = Vector3.new(-5083.26, 314.606, -3175.673)
        if not TryPortal(pos) then
            TweenModule:Teleport(CFrame.new(pos))
        end
        return
    end

    TweenModule:Teleport(cf)
end

task.spawn(function()
    while task.wait(0.5) do
        if TeleportIsland then
            TeleportToIsland()
        end
    end
end)
v493:AddSection("Travel")
v493:AddButton({
    Name = "Teleport to Sea 1",
    Description = "Main",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end
})
v493:AddButton({
    Name = "Teleport to Sea 2",
    Description = "Dressrosa",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end
})
v493:AddButton({
    Name = "Teleport to Sea 3",
    Description = "Zou",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end
})

v493:AddSection("Islands")
v493:AddDropdown({
    Name = "Select Island",
    Description = "",
    Options = v1117,
    Default = nil,
    Callback = function(v1118)
        _G.SelectIsland = v1118
    end
})
v493:AddToggle({
    Name = "Teleport To Island",
    Description = "Auto Tween To Island selected",
    Default = false,
    Callback = function(v)
        TeleportToIsland = v
        if not v and TweenModule and TweenModule.Stop then
            TweenModule:Stop()
        end
    end
})


if World3 then
v493:AddSection("Race V4")
v493:AddButton({
    Name = "Teleport to Temple of Time",
    Callback = function()
        pcall(function()

            local plr = game.Players.LocalPlayer
            local replicated = game:GetService("ReplicatedStorage")
            if not workspace.Map:FindFirstChild("Temple of Time") then
                local MapStash = replicated:FindFirstChild("MapStash")
                if MapStash and MapStash:FindFirstChild("Temple of Time") then
                    MapStash["Temple of Time"].Parent = workspace.Map
                end
            end
            local args = {
                [1] = Vector3.new(28286.35546875,14895.301757812,102.62469482422)
            }
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", unpack(args))
        end)
    end
})
end

local MobCakePrince = v499:AddParagraph(
    "Katakuri",
     ""
)
spawn(function()
    while wait() do
        pcall(function()
            local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
            local len = string.len(response)
            if len == 88 then
                MobCakePrince:SetDesc("Katakuri: " .. string.sub(response, 39, 41))
            elseif len == 87 then
                MobCakePrince:SetDesc("Katakuri: " .. string.sub(response, 39, 40))
            elseif len == 86 then
                MobCakePrince:SetDesc("Katakuri: " .. string.sub(response, 39, 39) .. " ")
            else
                MobCakePrince:SetDesc("Cake Prince : ✅️")
            end
        end)
    end
end)

local TyrantStatus = v499:AddParagraph(
     "Tyrant of the Skies",
     "Status: "
)
spawn(function()
    pcall(function()
        while wait() do
            if game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies") then
                TyrantStatus:SetDesc("Status : ✅️")
            else
                TyrantStatus:SetDesc("Status : ❌️")
            end
        end
    end)
end)
local CheckRip = v499:AddParagraph(
    "Rip_Indra",
    "Status: "
)
spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") 
            or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                CheckRip:SetDesc("Status : ✅️")
            else
                CheckRip:SetDesc("Status : ❌️")
            end
        end)
    end
end)

local CheckDoughKing = v499:AddParagraph(
     "Dough King",
     "Status: "
)
spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") 
            or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                CheckDoughKing:SetDesc("Status : ✅️")
            else
                CheckDoughKing:SetDesc("Status : ❌️")
            end
        end)
    end
end)
if World3 then
local EliteHunter = v499:AddParagraph(
    "Elite Hunter",
    "Status: "
)
spawn(function()
    while wait() do
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local ws = game:GetService("Workspace").Enemies
            local progress = rs.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
            if rs:FindFirstChild("Diablo") or rs:FindFirstChild("Deandre") or rs:FindFirstChild("Urban")
            or ws:FindFirstChild("Diablo") or ws:FindFirstChild("Deandre") or ws:FindFirstChild("Urban") then
                EliteHunter:SetDesc("Status :✅️ Elite progress: " .. progress)
            else
                EliteHunter:SetDesc("Status : ❌️ Elite progress: " .. progress)
            end
        end)
    end
end)
end
local Pullever = v499:AddParagraph(
    "Pull Lever",
    "Status: "
)
spawn(function()
    while wait() do
        pcall(function()
            if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") then
                Pullever:SetDesc("✅")
            else
                Pullever:SetDesc("❌")
            end
        end)
    end
end)
local FM = v499:AddParagraph(
    "Full Moon",
    ""
)
spawn(function()
    while wait() do
        pcall(function()
            local moonId = game:GetService("Lighting").Sky.MoonTextureId
            if moonId == "http://www.roblox.com/asset/?id=9709149431" then
                FM:SetDesc("Moon: 5/5")
            elseif moonId == "http://www.roblox.com/asset/?id=9709149052" then
                FM:SetDesc("Moon: 4/5")
            elseif moonId == "http://www.roblox.com/asset/?id=9709143733" then
                FM:SetDesc("Moon: 3/5")
            elseif moonId == "http://www.roblox.com/asset/?id=9709150401" then
                FM:SetDesc("Moon: 2/5")
            elseif moonId == "http://www.roblox.com/asset/?id=9709149680" then
                FM:SetDesc("Moon: 1/5")
            else
                FM:SetDesc("Moon: 0/5")
            end
        end)
    end
end)

if World2 then
local LegendarySword = v499:AddParagraph(
     "Legendary Sword",
     "Status: "
)
spawn(function()
    pcall(function()
        while wait() do
            local rs = game:GetService("ReplicatedStorage").Remotes.CommF_   
            if rs:InvokeServer("LegendarySwordDealer", "1") then
                LegendarySword:SetDesc("Shisui")
            elseif rs:InvokeServer("LegendarySwordDealer", "2") then
                LegendarySword:SetDesc("Wando")
            elseif rs:InvokeServer("LegendarySwordDealer", "3") then
                LegendarySword:SetDesc("Saddi")
            else
                LegendarySword:SetDesc("Not Found Legend Swords")
              end
          end
      end)
  end)
end

if World3 then
local Bone = v499:AddParagraph(
     "Bone",
     ""
)
spawn(function()
    pcall(function()
        while wait() do
            local bones = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
            Bone:SetDesc("You Have : " .. tostring(bones) .. " Bones")
        end
    end)
end)
end
local function FormatNumber(num)
    local str = tostring(num)
    repeat
        str = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
    until not str:find("^(-?%d+)(%d%d%d)")
    return str
end

local CommF = game:GetService("ReplicatedStorage").Remotes.CommF_

local function GetStock()
    local text = "Advance Stock:\n"

    local ok1, result1 = pcall(function()
        return CommF:InvokeServer("GetFruits", true)
    end)

    if ok1 and result1 then
        local found = false
        for _, v in pairs(result1) do
            if v.OnSale then
                found = true
                text = text .. v.Name .. " - $" .. FormatNumber(v.Price) .. "\n"
            end
        end
        if not found then
            text = text .. "None\n"
        end
    else
        text = text .. "Error\n"
    end

    text = text .. "\nNormal Stock:\n"

    local ok2, result2 = pcall(function()
        return CommF:InvokeServer("GetFruits")
    end)

    if ok2 and result2 then
        local found = false
        for _, v in pairs(result2) do
            if v.OnSale then
                found = true
                text = text .. v.Name .. " - $" .. FormatNumber(v.Price) .. "\n"
            end
        end
        if not found then
            text = text .. "None\n"
        end
    else
        text = text .. "Error\n"
    end

    return text
end

local StockUI = v499:AddParagraph(
 "Stock",
 ""
)

spawn(function()
    while wait(60) do
        pcall(function()
            StockUI:SetDesc(GetStock())
        end)
    end
end)

pcall(function()
    StockUI:SetDesc(GetStock())
end)
local function AutoStats()
    local Remote = ReplicatedStorage:WaitForChild("Remotes", 9e9):WaitForChild("CommF_", 9e9)
    
    local function AddStats(Stats)
        if Player.Data.Points.Value >= 1 then
            local Points = math.clamp(PointsSlider, 1, Player.Data.Points.Value)
            Remote:InvokeServer("AddPoint", Stats, Points)
        end
    end
    
    while getgenv().AutoStats do task.wait()
        if Melee then
            AddStats("Melee")
        end
        if Defense then
            AddStats("Defense")
        end
        if Sword then
            AddStats("Sword")
        end
        if Gun then
            AddStats("Gun")
        end
        if DemonFruit then
            AddStats("Demon Fruit")
        end
    end
end

v497:AddToggle({
    Title = "Auto Stats",
    Flag = "S-AutoStats",
    Callback = function(Value)
        getgenv().AutoStats = Value
        AutoStats()
    end
})

v497:AddSlider({
    Title = "Select Points",
    Flag = "S-Points",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = 1,
    Callback = function(Value)
        PointsSlider = Value
    end
})

v497:AddSection("Select Stats")

v497:AddToggle({
    Title = "Melee",
    Flag = "S-Melee",
    Callback = function(Value)
        Melee = Value
    end
})

v497:AddToggle({
    Title = "Defense",
    Flag = "S-Defense",
    Callback = function(Value)
        Defense = Value
    end
})

v497:AddToggle({
    Title = "Sword",
    Flag = "S-Sword",
    Callback = function(Value)
        Sword = Value
    end
})

v497:AddToggle({
    Title = "Gun",
    Flag = "S-Gun",
    Callback = function(Value)
        Gun = Value
    end
})

v497:AddToggle({
    Title = "Demon Fruit",
    Flag = "S-DemonFruit",
    Callback = function(Value)
        DemonFruit = Value
    end
})
if not BlackListExecutors then
v494:AddSection("Aimbot Nearest")
--[[Settings.NoAimMobs = true

v494:AddToggle({
    Name = "Aimbot Gun",
    Default = false,
    Callback = function(v)
        _ENV.AimBot_Gun = v
    end
})

v494:AddToggle({
    Name = "Aimbot Tap",
    Default = false,
    Callback = function(v)
        _ENV.AimBot_Tap = v
    end
})

v494:AddToggle({
    Name = "Aimbot Skills",
    Default = false,
    Callback = function(v)
        _ENV.AimBot_Skills = v
    end
})

v494:AddToggle({
    Name = "Ignore Mobs",
    Default = true,
    Callback = function(v)
        Settings.NoAimMobs = v
    end
})]]

v494:AddToggle({Name = "Aimbot Gun", Default = false})
v494:AddToggle({Name = "Aimbot Tap", Default = false})
v494:AddToggle({Name = "Aimbot Skills", Default = false})
v494:AddToggle({Name = "Ignore Mobs", Default = true})

end
v494:AddSection("ESP")
v494:AddSlider({
	Name = "ESP Size",
	Flag = "S-EspSize",
	Min = 7,
	Max = 15,
	Default = 10,
	Increment = 1,
	Callback = function(v)
		for i = 1, #Managers.EspManager.CreatedEsps do
			Managers.EspManager.CreatedEsps[i]:ChangeEspSize(v)
		end
	end
})
if World2 then
v494:AddToggle({
    Name = "ESP Flowers",
    Description = "Display Flowers",
    Flag = "S-ESPFlowers",
    Default = false,
    Callback = function(v)
        FlowerESPManager.Enabled = v
    end
})

v494:AddToggle({
    Name = "ESP Legendary Sword Dealer",
    Description = "Display Legendary Sword Dealer",
    Flag = "S-ESPLSD",
    Default = false,
    Callback = function(v)
        LSDESP.Enabled = v
    end
})
end

v494:AddToggle({
    Name = "ESP My Boat",
    Description = "Display my boat on the Map",
    Flag = "M-EspMyBoat",
    Default = false,
    Callback = function(v)
        MyBoatESP.Enabled = v
    end
})

v494:AddToggle({
  Name = "ESP Players",
  Description = "Display Players on the Map",
  Flag = "B-EspPlayers",
  Default = false,
  Callback = function(v)
      PlayerESP.Enabled = v
  end
})

v494:AddToggle({
	Name = "ESP Fruits",
    Description = "Display Fruits on the Map",
	Flag = "S-ESPfruits",
	Default = false,
	Callback = function(v)
		FruitESP.Enabled = v
	end
})

v494:AddToggle({
	Name = "ESP Berry",
	Description = "Display Berries Ready to Collect",
	Flag = "Flag3",
	Default = false,
	Callback = function(v)
		BerryESP.Enabled = v
	end
})

v494:AddToggle({
    Name = "ESP Chests",
    Description = "Display Chests on the Map",
    Flag = "S-ESPChest",
    Default = false,
    Callback = function(v)
        ChestESP.Enabled = v
    end
})

v494:AddToggle({
    Name = "ESP Islands",
    Description = "Display Islands on the Map",
    Flag = "S-ESPislands",
    Default = false,
    Callback = function(v)
        IslandsESP.Enabled = v
    end
})
v494:AddSection("Visual")
vu14 = game.Players.LocalPlayer

v494:AddButton({
    "Meteor Rain",
    function()
        if vu14.Character and vu14.Character.PrimaryPart then
            require(game:GetService("ReplicatedStorage").Effect.Container.UzothSpec)({
                Position = vu14.Character.PrimaryPart.Position
            })
        end
    end
})

v494:AddButton({
    "Remove Portal Dash Cooldown",
    function()
        local portal = vu14.Backpack:FindFirstChild("Portal-Portal") or (vu14.Character and vu14.Character:FindFirstChild("Portal-Portal"))
        if not portal then return end

        for _,conn in pairs(getconnections(portal.Activated)) do
            local func = conn.Function
            if func then
                task.spawn(function()
                    while portal and portal:IsDescendantOf(game) do
                        for i = 1,20 do
                            local ok,val = pcall(debug.getupvalue,func,i)
                            if ok and type(val) == "number" then
                                pcall(debug.setupvalue,func,i,0)
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end
        end
    end
})

v494:AddButton({
    Name = "Enable Roblox Emote Menu",
    Callback = function()
        pcall(function()
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
        end)
    end
})
v494:AddButton({
    Name = "Rain Fruit (Old)",
    Description = "",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart

        for _,v in pairs(game:GetObjects("rbxassetid://14759368201")[1]:GetChildren()) do
            local c = v:Clone()
            c.Parent = workspace.Map
            c:MoveTo(root.Position + Vector3.new(math.random(-50,50),100,math.random(-50,50)))

            if c:FindFirstChild("Fruit") and c.Fruit:FindFirstChild("AnimationController") then
                c.Fruit.AnimationController:LoadAnimation(c.Fruit:FindFirstChild("Idle")):Play()
            end

            if c:FindFirstChild("Handle") then
                c.Handle.Touched:Connect(function(hit)
                    if hit.Parent == char then
                        c.Parent = LocalPlayer.Backpack
                        char.Humanoid:EquipTool(c)
                    end
                end)
            end
        end
    end
})

v494:AddButton({
   Name = "Kamui",
   Description = "It gives the player an item called KAMUI",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Scripts3/main/Utils/Module/Kamui.luau"))()
  end
})

v495:AddSection("Fighting Style")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
LP = Players.LocalPlayer

local SEA
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
	SEA = 1
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
	SEA = 2
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
	SEA = 3
else
	return
end

_G.BuyFly = false
BV, BG = nil, nil
TargetPos = nil

NPCS = {
	BlackLeg = {[1] = {Vector3.new(-988,13,3996)}, [2] = {Vector3.new(-4750.61,35.08,-4846.33)}, [3] = {Vector3.new(-5043.64,371.35,-3183.40)}},
	Electro = {[1] = {Vector3.new(-5382.27,14.15,-2150.34)}, [2] = {Vector3.new(-4863.81,35.08,-4767.54)}, [3] = {Vector3.new(-4993.20,314.56,-3198.06)}},
	FishmanKarate = {[1] = {Vector3.new(61584.35,18.85,988.89)}, [2] = {Vector3.new(-4960.04,35.08,-4662.67)}, [3] = {Vector3.new(-5017.39,371.35,-3187.53)}},
	Superhuman = {[2] = {Vector3.new(1378.05,247.43,-5189.37)}, [3] = {Vector3.new(-4997.53,371.35,-3197.46)}},
	DeathStep = {[2] = {Vector3.new(6360.04,296.67,-6763.93)}, [3] = {Vector3.new(-4997.64,314.56,-3220.37)}},
	SharkmanKarate = {[2] = {Vector3.new(-2602.40,239.22,-10314.75)}, [3] = {Vector3.new(-4970.48,314.56,-3225.04)}},
	ElectricClaw = {[3] = {Vector3.new(-10369.83,331.69,-10126.49)}},
	DragonTalon = {[3] = {Vector3.new(5662.03,1211.32,858.60)}},
	GodHuman = {[3] = {Vector3.new(-13775.56,334.66,-9877.67)}},
	SanguineArt = {[3] = {Vector3.new(-16514.86,23.18,-190.84)}}
}

function HRP()
	return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
end

LV, AO = nil, nil
TargetPos = nil

function EnsureFly()
	local hrp = HRP()
	if not hrp then return end

	if not LV or LV.Parent ~= hrp then
		if LV then LV:Destroy() end
		LV = Instance.new("LinearVelocity")
		LV.Attachment0 = hrp:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", hrp)
		LV.MaxForce = math.huge
		LV.VectorVelocity = Vector3.zero
		LV.Parent = hrp
	end

	if not AO or AO.Parent ~= hrp then
		if AO then AO:Destroy() end
		AO = Instance.new("AlignOrientation")
		AO.Attachment0 = hrp:FindFirstChildOfClass("Attachment")
		AO.MaxTorque = math.huge
		AO.Responsiveness = 200
		AO.Parent = hrp
	end
end

function StopFly()
	RunService:UnbindFromRenderStep("BuyFly")
	if LV then LV:Destroy() LV=nil end
	if AO then AO:Destroy() AO=nil end
	TargetPos = nil
end

function FlyTo(pos)
	TargetPos = pos

	RunService:BindToRenderStep("BuyFly", Enum.RenderPriority.Character.Value + 1, function()
		if not _G.BuyFly then StopFly() return end

		local hrp = HRP()
		if not hrp then return end

		EnsureFly()

		for _,v in ipairs(LP.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end

		local delta = TargetPos - hrp.Position
		local dist = delta.Magnitude

		if dist <= 3 then
			LV.VectorVelocity = Vector3.zero
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.CFrame = CFrame.new(TargetPos)
			return
		end

		local dir = delta.Unit
		LV.VectorVelocity = dir * math.clamp(dist * 6, 120, 330)
		AO.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + dir)
	end)
end

function Buy(style, remote)
	task.spawn(function()
		local pos = NPCS[style] and NPCS[style][SEA]
		if not pos then return end

		FlyTo(pos[1])

		repeat task.wait()
		until (HRP() and (HRP().Position - pos[1]).Magnitude <= 4) or not _G.BuyFly

		if _G.BuyFly then
			ReplicatedStorage.Remotes.CommF_:InvokeServer(remote)
		end
	end)
end

LP.CharacterAdded:Connect(function()
	task.wait(0.4)
	if _G.BuyFly and TargetPos then
		FlyTo(TargetPos)
	end
end)
function StopAllBuy()
	_G.BuyFly = false
	StopFly()
end

v495:AddToggle({
	Title = "Buy Black Leg",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("BlackLeg","BuyBlackLeg")
		end
	end
})

v495:AddToggle({
	Title = "Buy Electro",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("Electro","BuyElectro")
		end
	end
})

v495:AddToggle({
	Title = "Buy Fishman Karate",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("FishmanKarate","BuyFishmanKarate")
		end
	end
})

v495:AddToggle({
	Title = "Buy Superhuman",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("Superhuman","BuySuperhuman")
		end
	end
})

v495:AddToggle({
	Title = "Buy Death Step",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("DeathStep","BuyDeathStep")
		end
	end
})

v495:AddToggle({
	Title = "Buy Sharkman Karate",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("SharkmanKarate","BuySharkmanKarate")
		end
	end
})

v495:AddToggle({
	Title = "Buy Electric Claw",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("ElectricClaw","BuyElectricClaw")
		end
	end
})

v495:AddToggle({
	Title = "Buy Dragon Talon",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("DragonTalon","BuyDragonTalon")
		end
	end
})

v495:AddToggle({
	Title = "Buy God Human",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("GodHuman","BuyGodhuman")
		end
	end
})

v495:AddToggle({
	Title = "Buy Sanguine Art",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("SanguineArt","BuySanguineArt")
		end
	end
})
v495:AddSection("Buy Sea Event Crafting")
v495:AddButton({
    Title = "⚠️Craft Dragonheart",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart")
    end
})
v495:AddButton({
    Title = "⚠️Craft Dragonstorm",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm")
    end
})
v495:AddButton({
    Title = "⚠️Craft DinoHood",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood")
    end
})
v495:AddButton({
    Title = "⚠️Craft SharkTooth",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth")
    end
})
v495:AddButton({
    Title = "⚠️Craft TerrorJaw",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw")
    end
})
v495:AddButton({
    Title = "⚠️Craft SharkAnchor",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor")
    end
})
v495:AddButton({
    Title = "⚠️Craft LeviathanCrown",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown")
    end
})
v495:AddButton({
    Title = "⚠️Craft LeviathanShield",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield")
    end
})
v495:AddButton({
    Title = "⚠️Craft LeviathanBoat",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat")
    end
})
v495:AddButton({
    Title = "⚠️Craft LegendaryScroll",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LegendaryScroll")
    end
})
v495:AddButton({
    Title = "⚠️Craft MythicalScroll",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "MythicalScroll")
    end
})
v495:AddSection("Buy Haki")
v495:AddButton({
    Title = "⚠️Buy Geppo $10,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
    end
})
v495:AddButton({
    Title = "⚠️Buy Buso Haki $25,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
    end
})
v495:AddButton({
    Title = "⚠️Buy Soru $25,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
    end
})
v495:AddButton({
    Title = "⚠️Buy Observation Haki $750,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Buy")
    end
})
v495:AddSection("Buy Sword/Gun")
v495:AddButton({
    Title = "⚠️Buy Cutlass $1,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
    end
})
v495:AddButton({
    Title = "⚠️Buy Katana $1,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Katana")
    end
})
v495:AddButton({
    Title = "⚠️Buy Iron Mace $25,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
    end
})
v495:AddButton({
    Title = "⚠️Buy Dual Katana $12,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
    end
})
v495:AddButton({
    Title = "⚠️Buy Triple Katana $60,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
    end
})
v495:AddButton({
    Title = "⚠️Buy Pipe $100,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
    end
})
v495:AddButton({
    Title = "⚠️Buy Dual-Headed Blade $400,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
    end
})
v495:AddButton({
    Title = "⚠️Buy Bisento $1,200,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
    end
})
v495:AddButton({
    Title = "⚠️Buy Soul Cane $750,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
    end
})
v495:AddButton({
    Title = "⚠️Buy Pole V2 5,000F",
    Callback = function()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ThunderGodTalk")
    end
})
v495:AddButton({
    Title = "⚠️Buy Slingshot $5,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
    end
})
v495:AddButton({
    Title = "⚠️Buy Musket $8,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Musket")
    end
})
v495:AddButton({
    Title = "⚠️Buy Flintlock $10,500",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
    end
})
v495:AddButton({
    Title = "⚠️Refined Slingshot $30,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
    end
})
v495:AddButton({
    Title = "⚠️Buy Refined Flintlock $65,000",
    Callback = function()
        local v1157 = {[1] = "BuyItem", [2] = "Refined Flintlock"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1157))
    end
})
v495:AddButton({
    Title = "⚠️Buy Cannon $100,000",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
    end
})
v495:AddButton({
    Title = "⚠️Buy Kabucha 1,500F",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
    end
})
v495:AddButton({
    Title = "⚠️Buy Bizarre Rifle 250 Ectoplasm",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)
    end
})
v495:AddButton({
    Title = "⚠️Buy Black Cape $50,000",
    Callback = function()
        local v1158 = {[1] = "BuyItem", [2] = "Black Cape"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1158))
    end
})
v495:AddButton({
    Title = "⚠️Swordsman Hat $150,000",
    Callback = function()
        local v1159 = {[1] = "BuyItem", [2] = "Swordsman Hat"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1159))
    end
})
v495:AddButton({
    Title = "⚠️Buy Tomoe Ring $500,000",
    Callback = function()
        local v1160 = {[1] = "BuyItem", [2] = "Tomoe Ring"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1160))
    end
})
v495:AddSection("Frag")
v495:AddButton({
    Title = "⚠️buy Ghoul",
    Description = "",
    Callback = function()
        local v1162 = {[1] = "Ectoplasm", [2] = "Change", [3] = 4}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1162))
    end
})
v495:AddButton({
    Title = "⚠️buy Cyborg",
    Description = "",
    Callback = function()
        local v1163 = {[1] = "CyborgTrainer", [2] = "Buy"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1163))
    end
})
v495:AddButton({
    Title = "⚠️Reset Stats 2,500F",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
    end
})
v495:AddButton({
    Title = "⚠️Random Race 3,000F",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
    end
})

v496:AddSection("Join Server")
v496:AddTextBox({
    Name = "Job ID",
    PlaceholderText = "Paste the Job ID here...",
    Callback = function(input)
        if input == "" then return end

        local jobId = input

        if string.find(input, "H2O2SERVER|") then
            local split = string.split(input, "|")
            jobId = split[2]
        end

        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId)
        end)
    end
})
v496:AddButton({
    Title = "Join Clipboard",
    Description = "Join server from copied JobId",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local jobId = tostring(getclipboard())

        if jobId and jobId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        else
            warn("")
        end
    end
})

v496:AddSection("Settings")

v496:AddDropdown({
    Name = "Farm Mode ",
    Flag = "S-FarmMode",
    Options = {"Up", "Orbit", "Star"},
    Default = "Up",
    Callback = function(v)
        _G.FarmMode = v
    end
})

v496:AddSlider({
    Name = "Farm Distance",
    Flag = "Farm-Distance",
    Min = 10,
    Max = 25,
    Default = 15,
    Increase = 1,
    Callback = function(v)
        _G.FarmHeight = v
    end
})

v496:AddSlider({
   Name = "Bring Mobs Distance",
   Flag = "S-BringDistance",
   Min = 50,
   Max = 400,
   Increase = 1,
   Default = 250,
   Callback = function(Value)
       _G.BringDistance = Value
   end
})

Settings.TweenSpeed = 250
_G.TweenSpeed = 250

TweenSpeedSlider = v496:AddSlider({
    Name = "Tween Speed",
    Min = 10,
    Max = 300,
    Default = 250,
    Increase = 1,
    Callback = function(value)
        Settings.TweenSpeed = value
        _G.TweenSpeed = value

        TweenModule:SetSpeed(value)
    end
})

_G.BringDistance = 320
v496:AddToggle({
    Name = "Bring Mobs",
    Flag = "S-BringMobs",
    Description = "",
    Default = true,
    Callback = function(v)
        _G.BringMonster = v
        StopTween(v)
    end
})
spawn(function()
    while task.wait() do
        pcall(function()
            CheckQuest()
            for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if _G.BringMonster
                and StartBring
                and (mob.Name == MonFarm or mob.Name == Mon)
                and mob:FindFirstChild("Humanoid")
                and mob:FindFirstChild("HumanoidRootPart")
                and mob.Humanoid.Health > 0 then
                    local hrp = mob.HumanoidRootPart
                    local hum = mob.Humanoid
                    if (hrp.Position - PosMon.Position).Magnitude <= _G.BringDistance then
                        hrp.CFrame = PosMon
                        hrp.Size = Vector3.new(60,60,60)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                        mob.Head.CanCollide = false
                        hum.JumpPower = 0
                        hum.WalkSpeed = 0
                        hum:ChangeState(11)
                        hum:ChangeState(14)
                        local anim = hum:FindFirstChild("Animator")
                        if anim then
                            anim:Destroy()
                        end
                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                    end
                end
            end
        end)
    end
end)

v496:AddToggle({
    Name = "Auto Haki",
    Flag = "S-AutoHaki",
    Default = false,
    Callback = function()
        AutoHaki()
    end
})

v496:AddToggle({
    Name = "Auto Attack",
    Flag = "S-AutoAttack",
    Default = true,
    Callback = function(v)
        Settings.AutoClick = v
    end
})

v496:AddToggle({
    Name = "Auto Shoot",
    Description = "",
    Flag = "S-AutoShoot",
    Default = false,
    Callback = function(v)
        _G.AutoShootGun = v
    end
})

spawn(function()
    while task.wait() do
        if _G.AutoShootGun then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local char = plr.Character
                if not char then return end

                local tool = char:FindFirstChildOfClass("Tool")
                if not tool or tool.ToolTip ~= "Gun" then return end

                local mob = workspace.Enemies:FindFirstChild(MonFarm)
                if not mob then return end
                if not mob:FindFirstChild("HumanoidRootPart") then return end
                if mob.Humanoid.Health <= 0 then return end

                local pos = mob.HumanoidRootPart.Position

                local Net = game.ReplicatedStorage:FindFirstChild("Modules")
                Net = Net and Net:FindFirstChild("Net")
                local shoot = Net and Net:FindFirstChild("RE/ShootGunEvent")

                if tool.Name == "Skull Guitar" and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer("TAP", pos)
                else
                    if shoot then
                        shoot:FireServer(pos)
                    else
                        tool:Activate()
                    end
                end
            end)
        end
    end
end)

--FastAttack = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Scripts3/refs/heads/main/Utils/Module/FastAttack.luau"))()

--[[v496:AddToggle({
   Name = "Fast Attack",
   Flag = "FastAttack",
   Callback = function(v)
        Settings.FastAttack(v)
   end
})]]

v496:AddSection("Codes")

v496:AddButton({
    Title = "Redeem all codes",
    Callback = function()
        pcall(function()
            if not getgenv().CodesCache then
                getgenv().CodesCache = game:GetService("HttpService"):JSONDecode(
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/BloxFruits/main/Utils/Codes.json"))()
                )
            end

            for _, code in ipairs(getgenv().CodesCache) do
                task.spawn(function()
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
                    end)
                end)
            end
        end)
    end
})

v496:AddSection("Server")
v496:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
})

v496:AddButton({
	Name = "Server Hop",
	Callback = function()
		Hop()
	end
})


v496:AddSection("Cheat Bypass")
v496:AddToggle({
    Name = "Anti-reset",
    Description = "Rejoin Server every 30 minutes",
    Flag = "reset",
    Default = false,
    Callback = function(v)
        RejoinModule.SetEnabled(v)
    end
})

v496:AddSection("Config")
v496:AddToggle({
    Title = "Auto Execute",
    Description = "The script automatically execute if you switch servers",
    Flag = "S-AutoExecute",
    Default = false,
    Callback = function(Value)
        getgenv().AutoExecute = Value
    end
})

if getgenv().AutoExecute == nil then
    getgenv().AutoExecute = false
end

local function setupAutoExecute()
    local player = game.Players.LocalPlayer
    local queue = syn and syn.queue_on_teleport or queue_on_teleport or queueteleport
    local executed = false

    if not queue then 
        return 
    end

    player.OnTeleport:Connect(function()
        if getgenv().AutoExecute and not executed then
            executed = true
            queue([[
                loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/BloxFruits/refs/heads/main/main.luau"))()
            ]])
        end
    end)
end

spawn(function()
    wait(1)
    pcall(setupAutoExecute)
end)

v496:AddSection("Team")
v496:AddButton({
    Title = "Join Pirates Team",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
})
v496:AddButton({
    Title = "Join Marines Team",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
    end
})

v496:AddSection("Race")
v496:AddToggle({
    Title = "Auto Active Race V3",
    Flag = "AutoActiveRaceV3",
    Description = "",
    Value = false,
    Callback = function(v1171)
        _G.AutoRaceV3 = v1171
    end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoRaceV3 then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)

_G.AutoRaceV4 = false

v496:AddToggle({
    Title = "Auto Active Race V4",
    Description = "",
    Flag = "AutoActiveRaceV4",
    Default = false,
    Callback = function(state)
        _G.AutoRaceV4 = state
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if not _G.AutoRaceV4 then continue end

        pcall(function()
            local player = game:GetService("Players").LocalPlayer
            local char = player.Character
            if not char then return end

            local energy = char:FindFirstChild("RaceEnergy")
            local transformed = char:FindFirstChild("RaceTransformed")

            if energy and transformed then
                if energy.Value >= 1 and not transformed.Value then
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
                    task.wait(0.1)
                    vim:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
                    task.wait(5)
                end
            end
        end)
    end
end)

v496:AddSection("Local-Player")
Movement = loadstring(game:HttpGet("https://pastefy.app/AUTo6O5h/raw"))()

v496:AddToggle({
    Name = "Enable Speed and Jump",
    Flag = "S-SpeedJump",
    Description = "",
    Default = false,
    Callback = function(v)
        Movement:Toggle(v)
    end
})

v496:AddSlider({
    Name = "WalkSpeed",
    Flag = "S-WalkSpeed",
    Min = 16,
    Max = 300,
    Default = 58,
    Callback = function(v)
        Movement:SetSpeed(v)
    end
})

v496:AddSlider({
    Name = "JumpPower",
    Flag = "S-JumpPower",
    Min = 50,
    Max = 400,
    Default = 58,
    Callback = function(v)
        Movement:SetJump(v)
    end
})

v496:AddSection("Menu")
v496:AddButton({
    Name = "Devil Fruit Shop",
    Callback = function()
        require(vu14.PlayerGui.Main.UIController.FruitShop):Open("FruitDealer")
    end
})
v496:AddButton({
    Name = "Advanced Fruit Dealer",
    Callback = function()
        require(vu14.PlayerGui.Main.UIController.FruitShop):Open("AdvancedFruitDealer")
    end
})
v496:AddButton({
    Name = "Titles",
   Callback = function()
            vu808("getTitles")
            vu14.PlayerGui.Main.Titles.Visible = true
        end
    })
v496:AddSection("Visual")

getgenv().FullBright = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Scripts3/main/Utils/Module/FullBright.luau"))()

v496:AddToggle({
	Name = "Full Bright",
	Flag = "Full",
	Default = false,
	Callback = function(v)
		getgenv().FullBright:Toggle(v)
	end
})

getgenv().FogModule = loadstring(game:HttpGet("https://pastefy.app/Jbnyc72V/raw"))()

v496:AddButton({
    Title = "Remove Sky Fog",
    Callback = function()
        getgenv().FogModule.Remove()
    end
})

v496:AddToggle({
    Name = "Auto Remove Sky Fog",
    Flag = "AutoRemoveFog",
    Default = false,
    Callback = function(v)
        getgenv().FogModule.SetEnabled(v)
    end
})
v496:AddSection("More FPS")
v496:AddToggle({
    Name = "Smooth Mode",
    Description = "Reduces calculation speed to improve FPS",
    Flag = "SmoothMode",
    Default = false,
    Callback = function(v)
       Settings.SmoothMode = v
  end
})

v496:AddToggle({
	Name = "White Screen",
	Default = false,
	Callback = function(Value)
		_G.WhiteScreen = Value
		game:GetService("RunService"):Set3dRenderingEnabled(not Value)
	end
})

v496:AddToggle({
    Name = "Remove Damage",
    Flag = "M-DamageCounter",
    Description = "",
    Default = false,
    Callback = function(v)
        game:GetService("ReplicatedStorage").Assets.GUI.DamageCounter.Enabled = not v
    end
})

v496:AddToggle({
    Name = "Remove Notifications",
    Flag = "M-Notifications",
    Description = "",
    Default = false,
    Callback = function(v)
        game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Enabled = not v
    end
})

v496:AddButton({
	Name = "FPS Boost",
	Callback = function()
		for _, v in ipairs(game:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v:Destroy()
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Enabled = false
			elseif v:IsA("Lighting") then
				v.GlobalShadows = false
				v.FogEnd = 1e10
				v.Brightness = 0
			end
		end
		setfpscap(60)
	end
})

v496:AddSection("Others")

v496:AddToggle({
    Name = "Delete Lava",
    Description = "",
    Default = false,
    Callback = function(v1141)
        _G.RemoveLava = v1141
    end
})
spawn(function()
    while task.wait(1) do
        if _G.RemoveLava then
            for _, v1143 in pairs(workspace:GetDescendants()) do
                do
                    local l_v1143_0 = v1143
                    if l_v1143_0:IsA("BasePart") and string.lower(l_v1143_0.Name):find("lava") then
                        pcall(function()
                            l_v1143_0:Destroy()
                        end)
                    end
                end
            end
        end
    end
end)

v496:AddToggle({
    Title = "Walk on Water",
    Default = true,
    Callback = function(v1188)
        _G.WalkWater = v1188
    end
})

_G.WalkWater = true

spawn(function()
    while task.wait() do
        pcall(function()
            if not _G.WalkWater then
                game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
            else
                game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
            end
        end)
    end
end)

--[[Start("Initialize")
Start("StartFarm")
Start("StartFunctions")
Start("Webhooks", true)
Start("LoadLibrary", true)]]
RedzNotify(Translate('Script Loaded'),Translate('redz hub loaded successfully! "LeftControl" to minimize.'),112146984347920,5)
--[[Window:Notify({
    Title = 'Script Loaded',
    Content = 'redz hub loaded successfully! Press "LeftControl" to minimize.',
    Icon = 'rbxassetid://112146984347920',
    Time = 5
})]]
return redzlib