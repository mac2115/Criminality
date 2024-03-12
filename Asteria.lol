repeat
	task.wait()
until game:IsLoaded()
--hey skid dont skid pls pls pls pls :DDDDDDD
do
	local function isAdonisAC(table)
		return rawget(table, "Detected")
			and typeof(rawget(table, "Detected")) == "function"
			and rawget(table, "RLocked")
	end

	for _, v in next, getgc(true) do
		if typeof(v) == "table" and isAdonisAC(v) then
			-- warn(warn, "founded")
			for i, v in next, v do
				if rawequal(i, "Detected") then
					-- warn(warn, "^^^^^^^")
					local old
					old = hookfunction(v, function(action, info, nocrash)
						if rawequal(action, "_") and rawequal(info, "_") and rawequal(nocrash, true) then
							-- warn("checkup")
							return old(action, info, nocrash)
						end
						-- warn(warn, "detected for :", action, info, nocrash)
						return task.wait(9e9)
					end)
					warn("bypassed")
					break
				end
			end
		end
	end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local plr = Players.LocalPlayer
local clonef = clonefunction
local format = clonef(string.format)
local gsub = clonef(string.gsub)
local match = clonef(string.match)
local append = clonef(appendfile)
local type = clonef(type)
local crunning = clonef(coroutine.running)
local cwrap = clonef(coroutine.wrap)
local cresume = clonef(coroutine.resume)
local cyield = clonef(coroutine.yield)
local pcall = clonef(pcall)
local pairs = clonef(pairs)
local Error = clonef(error)
local getnamecallmethod = clonef(getnamecallmethod)
local warn = clonef(warn)
local print = clonef(print)
local camera = Workspace.CurrentCamera
local mouse = plr:GetMouse()
local UIS = game:GetService("UserInputService")

getgenv().Settings = {
	SilentAim = { Toggle = false, Bone = "Head", Fov = 180 },
	Speed = 0.22,
	Jump = false,
	JumpHeight = 15,
	InfStamina = false,
	Nocombat = false,
	Noclip = false,
	Fovchanger = { Toggle = false, fov = 111 },
	Nospread = false,
	Instantlock = false,
	Spinbot = { Toggle = false, speed = 50 }, -- didnt add yet btw
}

--bypasses
local getupvalues = clonef(debug.getupvalues)
local getconstants = clonef(debug.getconstants)
local getprotos = clonef(debug.getprotos)

local module
do
	for i, v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name == "XIIX" then
			module = v
		end
	end
end

--no combat log
module = require(module)
local ac = module["XIIX"]
local glob = getfenv(ac)["_G"]
local combat = glob["InCombatCheck"]
local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]

function infstamina()
	if stamina ~= nil then
		hookfunction(stamina, function()
			return 100, 100
		end)
	end
end

function nocombat()
	if combat ~= nil and isfunctionhooked(combat) == false then
		hookfunction(combat, function()
			return nil
		end)
	end
end
--esp
local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/mac2115/dsadassda/main/s", true))()

esp:Load()

--silent aim functions yes yes
function getshoot()
	for i, v in getgc() do
		if
			type(v) == "function"
			and debug.info(v, "n") == "Shoot"
			and debug.info(v, "l") == 2100
			and type(getupvalues(v)) == "table"
			and string.find(debug.info(v, "s"), "Gun")
		then
			print("got the function")
			return v
		end
	end
end

function checkifvisible(target) --visibility check to fix ig
	local ray =
		Ray.new(plr.Character.Head.Position, (target.Character.Head.Position - plr.Character.Head.Position).Unit * 300)
	local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, { plr.Character }, false, true)
	if part then
		if target.Character.Humanoid.Health > 0 then
			local pos, visible = camera:WorldToScreenPoint(target.Character.HumanoidRootPart.Position)
			if visible then
				return true
			end
		end
	end
end

local yes = getshoot()
function norecoil()
	if getgenv().Settings.Nospread then
		if yes ~= nil then
			local camerashake = getupvalues(getupvalues(yes)[17])[17]
			if isfunctionhooked(camerashake) == false then
				hookfunction(camerashake, function()
					return 0
				end)
			end
		else
			yes = getshoot()
		end
	else
		if yes ~= nil then
			local camerashake = getupvalues(getupvalues(yes)[17])[17]
			if isfunctionhooked(camerashake) then
				restorefunction(camerashake)
			end
		else
			yes = getshoot()
		end
	end
end

function getenemy()
	local target = nil
	local maxDist = getgenv().Settings.SilentAim.Fov
	for i, v in pairs(Players:GetPlayers()) do
		if v.Character then
			if
				v.Character:FindFirstChild("Humanoid")
				and v.Character.Humanoid.Health ~= 0
				and v.Character:FindFirstChild("HumanoidRootPart")
			then
				local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
				local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
				if dist < maxDist and vis then
					if checkifvisible(v) then
						target = v.Character
					end
					maxDist = dist
				end
			end
		end
	end
	return target
end

function setupsilent()
	local old
	local caller
	if getgenv().Settings.SilentAim.Toggle then
		if yes ~= nil then
			caller = getupvalues(yes)[34] --could find a better method testing now dont ask im autistic this is dumb code dont learn from it LOLLLLLLLL L ME
			print(caller)
			if not isfunctionhooked(caller)  then
				old = hookfunction(
					caller,
					newcclosure(function(self, ...)
						local target = getenemy()
						if target ~= nil then
							print(target.Name)
							return target[getgenv().Settings.SilentAim.Bone].Position
						else
							print("did not find target sadly unlucky: 0x0")
							return old(self, ...)
						end
					end)
				)
			else
				restorefunction(caller)
			end
		else
			print("no yes func so getting it again")
		end
	else
		if yes ~= nil then
			caller = getupvalues(yes)[34]
			if isfunctionhooked(caller) then
				restorefunction(caller)
			end
		end
	end
end

--misc functions
function lockpick()
	for i, v in getgc() do
		if type(v) == "function" and debug.info(v, "n") == "Complete" and debug.info(v, "l") == 329 then
			return v
		end
	end
end

function instantlockpick()
	local lockpicks = lockpick() -- this shit was mad easy and funny
	if lockpicks ~= nil then
		lockpicks()
	end
end

function jumpheight()
	if getgenv().Settings.Jump == true then --lmfaoooooo
		if plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") then
			plr.Character.Humanoid.UseJumpPower = false
			plr.Character.Humanoid.JumpHeight = getgenv().Settings.JumpHeight
		end
	else
		if plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") then
			plr.Character.Humanoid.UseJumpPower = true
		end
	end
end

function nofalldmg() -- no questions lmfao shit simple
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		local args = { ... }
		if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
			args[2] = 0
			args[3] = 0
		end
		return old(self, unpack(args))
	end)
end

function nofog()
	ReplicatedStorage.Values.SetFogValue.Value = 0
end

function fullbright()
	ReplicatedStorage.Values.BrightnessMulti.Value = 2
end

function fovchanger()
	if getgenv().Settings.Fovchanger.Toggle then
		Workspace.Camera.FieldOfView = getgenv().Settings.Fovchanger.fov
	end
end

--funny stuff lol

--speeed
_G.speed = 0.22

local movementVector = { 0, 0 }

getgenv().Control = {
	left = 0,
	right = 0,
	back = 0,
	forward = 0,
}

game:GetService("UserInputService").InputBegan:Connect(function(k, gameProcessedEvent)
	if not gameProcessedEvent then
		if k.KeyCode == Enum.KeyCode.W then
			getgenv().Control.forward = _G.speed
		elseif k.KeyCode == Enum.KeyCode.S then
			getgenv().Control.back = _G.speed
		elseif k.KeyCode == Enum.KeyCode.A then
			getgenv().Control.left = _G.speed
		elseif k.KeyCode == Enum.KeyCode.D then
			getgenv().Control.right = _G.speed
		end
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(k, gameProcessedEvent)
	if not gameProcessedEvent then
		if k.KeyCode == Enum.KeyCode.W then
			getgenv().Control.forward -= 0
		elseif k.KeyCode == Enum.KeyCode.S then
			getgenv().Control.backward = 0
		elseif k.KeyCode == Enum.KeyCode.A then
			getgenv().Control.left = 0
		elseif k.KeyCode == Enum.KeyCode.D then
			getgenv().Control.right = 0
		end
	end
end)

function getvector()
	return Vector3.new(
		getgenv().Control.left + getgenv().Control.right,
		0,
		getgenv().Control.forward + getgenv().Control.back
	)
end

--loops and uis so it works coolie coolie doolie woolie foolie
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")
)()

local Window = Fluent:CreateWindow({
	Title = "Asteria.lol Criminality v1.0.0",
	SubTitle = "by mac0014",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.Insert, -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "crosshair" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "info" }),
	Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options
local Toggle = Tabs.Main:AddToggle("Silentaim", { Title = "Silent Aim Toggle", Default = false })

Toggle:OnChanged(function()
	getgenv().Settings.SilentAim.Toggle = Options.Silentaim.Value
	setupsilent()
end)

Options.Silentaim:SetValue(false)

local Dropdown = Tabs.Main:AddDropdown("AimBone", {
	Title = "AimBone",
	Values = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
	Multi = false,
	Default = 1,
})

Dropdown:SetValue("Head")

Dropdown:OnChanged(function(Value)
	getgenv().Settings.SilentAim.Bone = Value
end)

local Toggle = Tabs.Main:AddToggle("nospr", { Title = "Nospread Toggle", Default = false })

Toggle:OnChanged(function()
	getgenv().Settings.Nospread = Options.nospr.Value
	norecoil()
end)

Options.nospr:SetValue(false)

local Toggle = Tabs.Main:AddToggle("Jump", { Title = "High jump Toggle", Default = false })

Toggle:OnChanged(function()
	getgenv().Settings.Jump = Options.Jump.Value
end)

Options.Jump:SetValue(false)

local Slider = Tabs.Main:AddSlider("Slider", {
	Title = "Jump height ",
	Description = "",
	Default = 15,
	Min = 0,
	Max = 50,
	Rounding = 0,
	Callback = function(Value)
		getgenv().Settings.JumpHeight = Value
	end,
})

local Slider = Tabs.Main:AddSlider("Slider", {
	Title = "Speed",
	Description = "",
	Default = 0,
	Min = 1,
	Max = 100,
	Rounding = 0,
	Callback = function(Value)
		_G.speed = Value / 100
	end,
})

_G.speed = 0 / 100

local Options = Fluent.Options
local Toggle = Tabs.Misc:AddToggle("fov", { Title = "Fov changer Toggle", Default = false })

Toggle:OnChanged(function()
	getgenv().Settings.Fovchanger.Toggle = Options.fov.Value
end)

Options.fov:SetValue(false)

local Slider = Tabs.Misc:AddSlider("Slider", {
	Title = "Fov slider",
	Description = "Changes fov",
	Default = 120,
	Min = 0,
	Max = 120,
	Rounding = 0,
	Callback = function(Value)
		getgenv().Settings.Fovchanger.fov = Value
	end,
})

Tabs.Misc:AddButton({
	Title = "Instant complete lockpick",
	Description = "Instantly completes lockpick",
	Callback = function()
		lockpick()
	end,
})

Tabs.Misc:AddButton({
	Title = "Chatlogger",
	Description = "Shows chat logs",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/mac2115/Cool-private/main/ESP"))()
	end,
})

Tabs.Misc:AddButton({
	Title = "InfStamina",
	Description = "Makes ur stamina infinite",
	Callback = function()
		infstamina()
	end,
})

Tabs.Misc:AddButton({
	Title = "No combat tag",
	Description = "Enables you to leave whenever you want without losing items",
	Callback = function()
		nocombat()
	end,
})

Tabs.Misc:AddButton({
	Title = "No fall damage",
	Description = "Gets rid of fall damage",
	Callback = function()
		nofalldmg()
	end,
})

Tabs.Misc:AddButton({
	Title = "No fog",
	Description = "Gets rid of fog",
	Callback = function()
		nofog()
	end,
})

Tabs.Misc:AddButton({
	Title = "Full bright",
	Description = "Makes everything brighter",
	Callback = function()
		fullbright()
	end,
})

local Toggle = Tabs.Visuals:AddToggle("esp", { Title = "ESP Master Toggle", Default = false })
Toggle:OnChanged(function()
	esp.options.enabled = Options.esp.Value
end)
Options.esp:SetValue(false)
esp.options.enabled = false

local Slider = Tabs.Visuals:AddSlider("Slider", {
	Title = "Font size ",
	Description = "",
	Default = 13,
	Min = 1,
	Max = 25,
	Rounding = 0,
	Callback = function(Value)
		esp.options.fontSize = Value
	end,
})
esp.options.fontSize = 13

local Toggle = Tabs.Visuals:AddToggle("arr", { Title = "Offscreen arrows Toggle", Default = false })
Toggle:OnChanged(function()
	esp.options.outOfViewArrows = Options.arr.Value
end)
Options.arr:SetValue(false)
esp.options.outOfViewArrows = false

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Arrow outline color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.outOfViewArrowsOutlineColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("dw", { Title = "Filled", Default = false })
Toggle:OnChanged(function()
	esp.options.outOfViewArrowsFilled = Options.dw.Value
end)
Options.dw:SetValue(false)
esp.options.outOfViewArrowsFilled = false

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Arrow fill color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.outOfViewArrowsColor = Colorpicker.Value
end)

Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

local Toggle = Tabs.Visuals:AddToggle("w", { Title = "Names esp", Default = false })
Toggle:OnChanged(function()
	esp.options.names = Options.w.Value
end)
Options.w:SetValue(false)
esp.options.names = false

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Names color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.nameColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("z", { Title = "Boxes", Default = false })
Toggle:OnChanged(function()
	esp.options.boxes = Options.z.Value
end)
Options.z:SetValue(false)
esp.options.boxes = false

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Boxes color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.boxesColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("q", { Title = "Filled", Default = false })
Toggle:OnChanged(function()
	esp.options.boxFill = Options.q.Value
end)
Options.q:SetValue(false)
esp.options.boxFill = false

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Boxes  fill color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.boxFillColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("v", { Title = "Healthbars", Default = false })
Toggle:OnChanged(function()
	esp.options.healthBars = Options.v.Value
end)
Options.v:SetValue(false)
esp.options.healthBars = false

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Health bar color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.healthBarsColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("bio", { Title = "Health text", Default = false })
Toggle:OnChanged(function()
	esp.options.healthText = Options.bio.Value
end)
Options.bio:SetValue(false)
esp.options.healthText = false
local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Health text color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.healthTextColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("qe", { Title = "Distance", Default = false })
Toggle:OnChanged(function()
	esp.options.distance = Options.qe.Value
end)
Options.qe:SetValue(false)
esp.options.distance = false

esp.options.healthText = false
local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Distance color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.distanceColor = Colorpicker.Value
end)

local Toggle = Tabs.Visuals:AddToggle("dras", { Title = "Chams toggle", Default = false })
Toggle:OnChanged(function()
	esp.options.chams = Options.dras.Value
end)
Options.dras:SetValue(false)

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Chams fill  color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.chamsFillColor = Colorpicker.Value
end)

local Colorpicker = Tabs.Visuals:AddColorpicker("Colorpicker", {
	Title = "Chams outline color",
	Default = Color3.fromRGB(96, 205, 255),
})

Colorpicker:OnChanged(function()
	esp.options.chamsOutlineColor = Colorpicker.Value
end)

Tabs.Settings:AddButton({
	Title = "Copy discord invite",
	Description = "Copies the invite to the asteria.lol discord",
	Callback = function()
		setclipboard("discord.gg/t2cXFpkGBh")
	end,
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Asteria.lol")
SaveManager:SetFolder("Asteria.lol/Criminality")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
	Title = "Criminality",
	Content = "The script has been loaded.",
	Duration = 5,
})

setupsilent()
task.spawn(function()
	RunService.RenderStepped:Connect(function()
		jumpheight()
		fovchanger()
	end)
end)

task.spawn(function()
	plr.Character.ChildAdded:Connect(function()
		setupsilent()
		norecoil()
	end)
end)

task.spawn(function()
	RunService.RenderStepped:Connect(function()
		if plr.Character.Humanoid.Health > 0 then
			movementVector = getvector()
			plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
				+ plr.Character.HumanoidRootPart.CFrame.LookVector * movementVector.X
			plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
				+ plr.Character.HumanoidRootPart.CFrame.RightVector * movementVector.Z
				+ plr.Character.HumanoidRootPart.CFrame.RightVector * -movementVector.Z
			plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
		end
	end)
end)
