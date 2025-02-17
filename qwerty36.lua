
--main fe satan script
for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
	if v:IsA("SpecialMesh") or v:IsA("Mesh") then
		v:Destroy()
	end
end

local c = game.Players.LocalPlayer.Character

c['VANS_Umbrella'].Name="yourecoolguy"
for i, v in pairs({"Right Arm", "Left Arm"}) do
    local arm = c[v]
    arm.Parent = nil
    arm.Transparency = 1
    arm.Parent = c
end

local c = game.Players.LocalPlayer.Character
for i, v in pairs({"Right Leg", "Left Leg"}) do
    local Leg = c[v]
    Leg.Parent = nil
    Leg.Transparency = 1
    Leg.Parent = c
end


local v3_net, v3_808 = Vector3.new(20000, 25.1, 0), Vector3.new(8, 0, 8)
    local function getNetlessVelocity(realPartVelocity)
        local mag = realPartVelocity.Magnitude
        if mag > 1 then
            local unit = realPartVelocity.Unit
            if (unit.Y > 0.25) or (unit.Y < -0.75) then
                return unit * (25.1 / unit.Y)
            end
        end
        return v3_net + realPartVelocity * v3_808
    end
local simradius = "shp" --simulation radius (net bypass) method
--simulation radius (net bypass) method
--"shp" - sethiddenproperty
--"ssr" - setsimulationradius
--false - disable
local antiragdoll = true --removes hingeConstraints and ballSocketConstraints from your character
local newanimate = false --disables the animate script and enables after reanimation
local discharscripts = true --disables all localScripts parented to your character before reanimation
local R15toR6 = true --tries to convert your character to r6 if its r15
local hatcollide = true --makes hats cancollide (only method 0)
local humState16 = true --enables collisions for limbs before the humanoid dies (using hum:ChangeState)
local addtools = false --puts all tools from backpack to character and lets you hold them after reanimation
local hedafterneck = false --disable aligns for head and enable after neck is removed
local loadtime = game:GetService("Players").RespawnTime + 0.5 --anti respawn delay
local method = 0 --reanimation method
--methods:
--0 - breakJoints (takes [loadtime] seconds to laod)
--1 - limbs
--2 - limbs + anti respawn
--3 - limbs + breakJoints after [loadtime] seconds
--4 - remove humanoid + breakJoints
--5 - remove humanoid + limbs
local alignmode = 3 --AlignPosition mode
--modes:
--1 - AlignPosition rigidity enabled true
--2 - 2 AlignPositions rigidity enabled both true and false
--3 - AlignPosition rigidity enabled false

healthHide = healthHide and ((method == 0) or (method == 2) or (method == 000)) and gp(c, "Head", "BasePart")

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local stepped = rs.Stepped
local heartbeat = rs.Heartbeat
local renderstepped = rs.RenderStepped
local sg = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local cf = CFrame.new
local v3 = Vector3.new
local v3_0 = v3(0, 0, 0)
local inf = math.huge

local c = lp.Character

if not (c and c.Parent) then
	return
end

c.Destroying:Connect(function()
	c = nil
end)

local function gp(parent, name, className)
	if typeof(parent) == "Instance" then
		for i, v in pairs(parent:GetChildren()) do
			if (v.Name == name) and v:IsA(className) then
				return v
			end
		end
	end
	return nil
end

local function align(Part0, Part1)
	Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)

	local att0 = Instance.new("Attachment", Part0)
	att0.Orientation = v3_0
	att0.Position = v3_0
	att0.Name = "att0_" .. Part0.Name
	local att1 = Instance.new("Attachment", Part1)
	att1.Orientation = v3_0
	att1.Position = v3_0
	att1.Name = "att1_" .. Part1.Name

	if (alignmode == 1) or (alignmode == 2) then
		local ape = Instance.new("AlignPosition", att0)
		ape.ApplyAtCenterOfMass = false
		ape.MaxForce = inf
		ape.MaxVelocity = inf
		ape.ReactionForceEnabled = false
		ape.Responsiveness = 200
		ape.Attachment1 = att1
		ape.Attachment0 = att0
		ape.Name = "AlignPositionRtrue"
		ape.RigidityEnabled = true
	end

	if (alignmode == 2) or (alignmode == 3) then
		local apd = Instance.new("AlignPosition", att0)
		apd.ApplyAtCenterOfMass = false
		apd.MaxForce = inf
		apd.MaxVelocity = inf
		apd.ReactionForceEnabled = false
		apd.Responsiveness = 200
		apd.Attachment1 = att1
		apd.Attachment0 = att0
		apd.Name = "AlignPositionRfalse"
		apd.RigidityEnabled = false
	end

	local ao = Instance.new("AlignOrientation", att0)
	ao.MaxAngularVelocity = inf
	ao.MaxTorque = inf
	ao.PrimaryAxisOnly = false
	ao.ReactionTorqueEnabled = false
	ao.Responsiveness = 200
	ao.Attachment1 = att1
	ao.Attachment0 = att0
	ao.RigidityEnabled = false

	if type(getNetlessVelocity) == "function" then
	    local realVelocity = v3_0
        local steppedcon = stepped:Connect(function()
            Part0.Velocity = realVelocity
        end)
        local heartbeatcon = heartbeat:Connect(function()
            realVelocity = Part0.Velocity
            Part0.Velocity = getNetlessVelocity(realVelocity)
        end)
        Part0.Destroying:Connect(function()
            Part0 = nil
            steppedcon:Disconnect()
            heartbeatcon:Disconnect()
        end)
    end
end

local function respawnrequest()
	local ccfr = ws.CurrentCamera.CFrame
	local c = lp.Character
	lp.Character = nil
	lp.Character = c
	local con = nil
	con = ws.CurrentCamera.Changed:Connect(function(prop)
	    if (prop ~= "Parent") and (prop ~= "CFrame") then
	        return
	    end
	    ws.CurrentCamera.CFrame = ccfr
	    con:Disconnect()
    end)
end

local destroyhum = (method == 4) or (method == 5)
local breakjoints = (method == 0) or (method == 4)
local antirespawn = (method == 0) or (method == 2) or (method == 3)

hatcollide = hatcollide and (method == 0)

addtools = addtools and gp(lp, "Backpack", "Backpack")

local fenv = getfenv()
local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.set_simulation_rad or fenv.setsimulationrad

if shp and (simradius == "shp") then
	spawn(function()
		while c and heartbeat:Wait() do
			shp(lp, "SimulationRadius", inf)
		end
	end)
elseif ssr and (simradius == "ssr") then
	spawn(function()
		while c and heartbeat:Wait() do
			ssr(inf)
		end
	end)
end

antiragdoll = antiragdoll and function(v)
	if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
		v.Parent = nil
	end
end

if antiragdoll then
	for i, v in pairs(c:GetDescendants()) do
		antiragdoll(v)
	end
	c.DescendantAdded:Connect(antiragdoll)
end

if antirespawn then
	respawnrequest()
end

if method == 0 then
	wait(loadtime)
	if not c then
		return
	end
end

if discharscripts then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("LocalScript") then
			v.Disabled = true
		end
	end
elseif newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate and (not animate.Disabled) then
		animate.Disabled = true
	else
		newanimate = false
	end
end

if addtools then
	for i, v in pairs(addtools:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = c
		end
	end
end

pcall(function()
	settings().Physics.AllowSleep = false
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
end)

local OLDscripts = {}

for i, v in pairs(c:GetDescendants()) do
	if v.ClassName == "Script" then
		table.insert(OLDscripts, v)
	end
end

local scriptNames = {}

for i, v in pairs(c:GetDescendants()) do
	if v:IsA("BasePart") then
		local newName = tostring(i)
		local exists = true
		while exists do
			exists = false
			for i, v in pairs(OLDscripts) do
				if v.Name == newName then
					exists = true
				end
			end
			if exists then
				newName = newName .. "_"    
			end
		end
		table.insert(scriptNames, newName)
		Instance.new("Script", v).Name = newName
	end
end

c.Archivable = true
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then
	for i, v in pairs(hum:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end
local cl = c:Clone()
if hum and humState16 then
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    if destroyhum then
        wait(1.6)
    end
end
if hum and hum.Parent and destroyhum then
    hum:Destroy()
end

if not c then
    return
end

local head = gp(c, "Head", "BasePart")
local torso = gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart")
local root = gp(c, "HumanoidRootPart", "BasePart")
if hatcollide and c:FindFirstChildOfClass("Accessory") then
    local anything = c:FindFirstChildOfClass("BodyColors") or gp(c, "Health", "Script")
    if not (torso and root and anything) then
        return
    end
    torso:Destroy()
    root:Destroy()
    if shp then
        for i,v in pairs(c:GetChildren()) do
            if v:IsA("Accessory") then
                shp(v, "BackendAccoutrementState", 0)
            end 
        end
    end
    anything:Destroy()
    if head then
        
    end
end

for i, v in pairs(cl:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
		v.Anchored = false
	end
end

local model = Instance.new("Model", c)
model.Name = model.ClassName

model.Destroying:Connect(function()
	model = nil
end)

for i, v in pairs(c:GetChildren()) do
	if v ~= model then
		if addtools and v:IsA("Tool") then
			for i1, v1 in pairs(v:GetDescendants()) do
				if v1 and v1.Parent and v1:IsA("BasePart") then
					local bv = Instance.new("BodyVelocity", v1)
					bv.Velocity = v3_0
					bv.MaxForce = v3(1000, 1000, 1000)
					bv.P = 1250
					bv.Name = "bv_" .. v.Name
				end
			end
		end
		v.Parent = model
	end
end

if breakjoints then
	model:BreakJoints()
else
	if head and torso then
		for i, v in pairs(model:GetDescendants()) do
			if v:IsA("Weld") or v:IsA("Snap") or v:IsA("Glue") or v:IsA("Motor") or v:IsA("Motor6D") then
				local save = false
				if (v.Part0 == torso) and (v.Part1 == head) then
					save = true
				end
				if (v.Part0 == head) and (v.Part1 == torso) then
					save = true
				end
				if save then
					if hedafterneck then
						hedafterneck = v
					end
				else
					v:Destroy()
				end
			end
		end
	end
	if method == 3 then
		spawn(function()
			wait(loadtime)
			if model then
				model:BreakJoints()
			end
		end)
	end
end

cl.Parent = c
for i, v in pairs(cl:GetChildren()) do
	v.Parent = c
end
cl:Destroy()

local modelDes = {}
for i, v in pairs(model:GetDescendants()) do
	if v:IsA("BasePart") then
		i = tostring(i)
		v.Destroying:Connect(function()
			modelDes[i] = nil
		end)
		modelDes[i] = v
	end
end
local modelcolcon = nil
local function modelcolf()
	if model then
		for i, v in pairs(modelDes) do
			v.CanCollide = false
		end
	else
		modelcolcon:Disconnect()
	end
end
modelcolcon = stepped:Connect(modelcolf)
modelcolf()

for i, scr in pairs(model:GetDescendants()) do
	if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
		local Part0 = scr.Parent
		if Part0:IsA("BasePart") then
			for i1, scr1 in pairs(c:GetDescendants()) do
				if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
					local Part1 = scr1.Parent
					if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
						align(Part0, Part1)
						break
					end
				end
			end
		end
	end
end

if (typeof(hedafterneck) == "Instance") and head then
	local aligns = {}
	local con = nil
	con = hedafterneck.Changed:Connect(function(prop)
	    if (prop == "Parent") and not hedafterneck.Parent then
	        con:Disconnect()
    		for i, v in pairs(aligns) do
    			v.Enabled = true
    		end
		end
	end)
	for i, v in pairs(head:GetDescendants()) do
		if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
			i = tostring(i)
			aligns[i] = v
			v.Destroying:Connect(function()
			    aligns[i] = nil
			end)
			v.Enabled = false
		end
	end
end

for i, v in pairs(c:GetDescendants()) do
	if v and v.Parent then
		if v.ClassName == "Script" then
			if table.find(scriptNames, v.Name) then
				v:Destroy()
			end
		elseif not v:IsDescendantOf(model) then
			if v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ForceField") then
				v.Visible = false
			elseif v:IsA("Sound") then
				v.Playing = false
			elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			end
		end
	end
end

if newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate then
		animate.Disabled = false
	end
end

if addtools then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = addtools
		end
	end
end

local hum0 = model:FindFirstChildOfClass("Humanoid")
if hum0 then
    hum0.Destroying:Connect(function()
        hum0 = nil
    end)
end

local hum1 = c:FindFirstChildOfClass("Humanoid")
if hum1 then
    hum1.Destroying:Connect(function()
        hum1 = nil
    end)
end

if hum1 then
	ws.CurrentCamera.CameraSubject = hum1
	local camSubCon = nil
	local function camSubFunc()
		camSubCon:Disconnect()
		if c and hum1 then
			ws.CurrentCamera.CameraSubject = hum1
		end
	end
	camSubCon = renderstepped:Connect(camSubFunc)
	if hum0 then
		hum0.Changed:Connect(function(prop)
			if hum1 and (prop == "Jump") then
				hum1.Jump = hum0.Jump
			end
		end)
	else
		respawnrequest()
	end
end

local rb = Instance.new("BindableEvent", c)
rb.Event:Connect(function()
	rb:Destroy()
	sg:SetCore("ResetButtonCallback", true)
	if destroyhum then
		c:BreakJoints()
		return
	end
	if hum0 and (hum0.Health > 0) then
		model:BreakJoints()
		hum0.Health = 0
	end
	if antirespawn then
	    respawnrequest()
	end
end)
sg:SetCore("ResetButtonCallback", rb)

spawn(function()
	while c do
		if hum0 and hum1 then
			hum1.Jump = hum0.Jump
		end
		wait()
	end
	sg:SetCore("ResetButtonCallback", true)
end)

R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
if R15toR6 then
    local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
	if part then
	    local cfr = part.CFrame
		local R6parts = { 
			head = {
				Name = "Head",
				Size = v3(2, 1, 1),
				R15 = {
					Head = 0
				}
			},
			torso = {
				Name = "Torso",
				Size = v3(2, 2, 1),
				R15 = {
					UpperTorso = 0.2,
					LowerTorso = -0.7
				}
			},
			root = {
				Name = "HumanoidRootPart",
				Size = v3(2, 2, 1),
				R15 = {
					HumanoidRootPart = 0
				}
			},
			leftArm = {
				Name = "Left Arm",
				Size = v3(1, 2, 1),
				R15 = {
					LeftHand = -0.7,
					LeftLowerArm = -0.2,
					LeftUpperArm = 0.4
				}
			},
			rightArm = {
				Name = "Right Arm",
				Size = v3(1, 2, 1),
				R15 = {
					RightHand = -0.7,
					RightLowerArm = -0.2,
					RightUpperArm = 0.4
				}
			},
			leftLeg = {
				Name = "Left Leg",
				Size = v3(1, 2, 1),
				R15 = {
					LeftFoot = -0.7,
					LeftLowerLeg = -0.15,
					LeftUpperLeg = 0.6
				}
			},
			rightLeg = {
				Name = "Right Leg",
				Size = v3(1, 2, 1),
				R15 = {
					RightFoot = -0.7,
					RightLowerLeg = -0.15,
					RightUpperLeg = 0.6
				}
			}
		}
		for i, v in pairs(c:GetChildren()) do
			if v:IsA("BasePart") then
				for i1, v1 in pairs(v:GetChildren()) do
					if v1:IsA("Motor6D") then
						v1.Part0 = nil
					end
				end
			end
		end
		part.Archivable = true
		for i, v in pairs(R6parts) do
			local part = part:Clone()
			part.Name = v.Name
			part.Size = v.Size
			part.CFrame = cfr
			part.Anchored = false
			part.Transparency = 1
			part.CanCollide = false
			for i1, v1 in pairs(v.R15) do
				local R15part = gp(c, i1, "BasePart")
				local att = gp(R15part, "att1_" .. i1, "Attachment")
				if R15part then
					local weld = Instance.new("Weld", R15part)
					weld.Name = "Weld_" .. i1
					weld.Part0 = part
					weld.Part1 = R15part
					weld.C0 = cf(0, v1, 0)
					weld.C1 = cf(0, 0, 0)
					R15part.Massless = true
					R15part.Name = "R15_" .. i1
					R15part.Parent = part
					if att then
						att.Parent = part
						att.Position = v3(0, v1, 0)
					end
				end
			end
			part.Parent = c
			R6parts[i] = part
		end
		local R6joints = {
			neck = {
				Parent = R6parts.torso,
				Name = "Neck",
				Part0 = R6parts.torso,
				Part1 = R6parts.head,
				C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rootJoint = {
				Parent = R6parts.root,
				Name = "RootJoint" ,
				Part0 = R6parts.root,
				Part1 = R6parts.torso,
				C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rightShoulder = {
				Parent = R6parts.torso,
				Name = "Right Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightArm,
				C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftShoulder = {
				Parent = R6parts.torso,
				Name = "Left Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.leftArm,
				C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			},
			rightHip = {
				Parent = R6parts.torso,
				Name = "Right Hip",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightLeg,
				C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftHip = {
				Parent = R6parts.torso,
				Name = "Left Hip" ,
				Part0 = R6parts.torso,
				Part1 = R6parts.leftLeg,
				C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			}
		}
		for i, v in pairs(R6joints) do
			local joint = Instance.new("Motor6D")
			for prop, val in pairs(v) do
				joint[prop] = val
			end
			R6joints[i] = joint
		end
		hum1.RigType = Enum.HumanoidRigType.R6
		hum1.HipHeight = 0
	end
end



--find rig joints

local function fakemotor()
    return {C0=cf(), C1=cf()}
end

local torso = gp(c, "Torso", "BasePart")
local root = gp(c, "HumanoidRootPart", "BasePart")

local neck = gp(torso, "Neck", "Motor6D")
neck = neck or fakemotor()

local rootJoint = gp(root, "RootJoint", "Motor6D")
rootJoint = rootJoint or fakemotor()

local leftShoulder = gp(torso, "Left Shoulder", "Motor6D")
leftShoulder = leftShoulder or fakemotor()

local rightShoulder = gp(torso, "Right Shoulder", "Motor6D")
rightShoulder = rightShoulder or fakemotor()

local leftHip = gp(torso, "Left Hip", "Motor6D")
leftHip = leftHip or fakemotor()

local rightHip = gp(torso, "Right Hip", "Motor6D")
rightHip = rightHip or fakemotor()

--120 fps

local fps = 40
local event = Instance.new("BindableEvent", c)
event.Name = "120 fps"
local floor = math.floor
fps = 1 / fps
local tf = 0
local con = nil
con = game:GetService("RunService").RenderStepped:Connect(function(s)
	if not c then
		con:Disconnect()
		return
	end
    --tf += s
	if tf >= fps then
		for i=1, floor(tf / fps) do
			event:Fire(c)
		end
		tf = 0
	end
end)
local event = event.Event

local hedrot = v3(0, 5, 0)

local uis = game:GetService("UserInputService")
local function isPressed(key)
    return (not uis:GetFocusedTextBox()) and uis:IsKeyDown(Enum.KeyCode[key])
end

local biggesthandle = nil
for i, v in pairs(c:GetChildren()) do
    if v:IsA("Accessory") then
        local handle = gp(v, "Handle", "BasePart")
        if biggesthandle then
            if biggesthandle.Size.Magnitude < handle.Size.Magnitude then
                biggesthandle = handle
            end
        else
            biggesthandle = gp(v, "Handle", "BasePart")
        end
    end
end

if not biggesthandle then
    return
end

local handle1 = gp(gp(model, biggesthandle.Parent.Name, "Accessory"), "Handle", "BasePart")
if not handle1 then
    return
end

handle1.Destroying:Connect(function()
    handle1 = nil
end)
biggesthandle.Destroying:Connect(function()
    biggesthandle = nil
end)

biggesthandle:BreakJoints()
biggesthandle.Anchored = true

for i, v in pairs(handle1:GetDescendants()) do
    if v:IsA("AlignOrientation") then
        v.Enabled = false
    end
end

local mouse = lp:GetMouse()
local fling = false
mouse.Button1Down:Connect(function()
    fling = true
end)
mouse.Button1Up:Connect(function()
    fling = false
end)
local function doForSignal(signal, vel)
    spawn(function()
        while signal:Wait() and c and handle1 and biggesthandle do
            if fling and mouse.Target then
                biggesthandle.Position = mouse.Hit.Position
            end
            handle1.RotVelocity = vel
        end
    end)
end
doForSignal(stepped, v3(100, 100, 100))
doForSignal(renderstepped, v3(100, 100, 100))
doForSignal(heartbeat, v3(2000000000000, 200000000000, 20000000000))


_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['Lipstick_Bag_1.0'].Handle,char['Right Arm'],false)
local cf = char['Right Arm'].CFrame*CFrame.new(0,-0,-0)*CFrame.Angles(math.rad(0),math.rad(0),0)
hat[1].CFrame = cf:Inverse() * char['Right Arm'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end






_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['Wings'].Handle,char['Left Arm'],false)
local cf = char['Left Arm'].CFrame*CFrame.new(-0,-1.5,-0)*CFrame.Angles(math.rad(0),math.rad(0),30)
hat[1].CFrame = cf:Inverse() * char['Left Arm'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end








_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['PogoStick'].Handle,char['Torso'],false)
local cf = char['Torso'].CFrame*CFrame.new(0,0,-0)*CFrame.Angles(math.rad(0),math.rad(0),0)
hat[1].CFrame = cf:Inverse() * char['Torso'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end







_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['yourecoolguy'].Handle,char['Head'],false)
local cf = char['Head'].CFrame*CFrame.new(0,1.3,-0)*CFrame.Angles(math.rad(0),math.rad(-0),0)
hat[1].CFrame = cf:Inverse() * char['Head'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end






_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['Lipstick_Bag_3.0'].Handle,char['Right Leg'],false)
local cf = char['Right Leg'].CFrame*CFrame.new(0.4,-2.2,-0)*CFrame.Angles(math.rad(0),math.rad(90),0)
hat[1].CFrame = cf:Inverse() * char['Right Leg'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end









_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['VANS_Umbrella'].Handle,char['Left Leg'],false)
local cf = char['Left Leg'].CFrame*CFrame.new(0,-0.3,0)*CFrame.Angles(math.rad(90),math.rad(-90),0)
hat[1].CFrame = cf:Inverse() * char['Left Leg'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end


_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['LUAhEAD'].Handle,char['Right Leg'],false)
local cf = char['Right Leg'].CFrame*CFrame.new(0.4,0.5,-0)*CFrame.Angles(math.rad(0),math.rad(0),0)
hat[1].CFrame = cf:Inverse() * char['Right Leg'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end


_G.loop = true
local player = game.Players.LocalPlayer
local char = player.Character
local Align = function(Part0, Part1,Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }
    
    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }
    local m = Part0:FindFirstChildOfClass('SpecialMesh')--This will get the first "SpecialMesh" it finds if it does not find any, then it will return nil
    if Mesh and m then --If Mesh is set to true and it finds a mesh it will destroy it
        m:Destroy()
    end
    Part0:BreakJoints()
    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true
    
    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
        Aligns.AlignPosition.MaxForce = 999999999
        spawn(function()
            while _G.loop do 
                local mag = (Part0.Position - (Part1.CFrame*Attachments.Attach0.CFrame:Inverse()).p).magnitude--magnitude can get the distance between two cframe or position
                if mag >= 5 then 
                Part0.CFrame = Part1.CFrame*Attachments.Attach0.CFrame:Inverse()
                end
                Part0.Velocity = Vector3.new(0,35,0)
                game['Run Service'].Heartbeat:wait()
                end
        end)
 return {Attachments.Attach0, Attachments, Aligns}
        
end 
local hat = Align(char['Surfboard'].Handle,char['HumanoidRootPart'],false)
local cf = char['HumanoidRootPart'].CFrame*CFrame.new(0,2,7)*CFrame.Angles(math.rad(0),math.rad(0),0)
hat[1].CFrame = cf:Inverse() * char['HumanoidRootPart'].CFrame
spawn(function()
    char.AncestryChanged:wait()--if you respawn, it will stop the  loop to avoid lag of using it over and over
    _G.loop = false 
end)
for i,v in pairs (char:GetChildren()) do
	if v:IsA("Accessory") then
		v.Handle.Massless = true
		v.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local stepped = rs.Stepped
local heartbeat = rs.Heartbeat
local renderstepped = rs.RenderStepped
local sg = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local cf = CFrame.new
local v3 = Vector3.new
local v3_0 = Vector3.zero
local inf = math.huge

local cplayer = lp.Character

local v3 = Vector3.new

local function gp(parent, name, className)
    if typeof(parent) == "Instance" then
        for i, v in pairs(parent:GetChildren()) do
            if (v.Name == name) and v:IsA(className) then
                return v
            end
        end
    end
    return nil
end


local hat2 = gp(cplayer, "RedcliffKnight_HelmetAccessory", "Accessory")
local handle2 = gp(hat2, "Handle", "BasePart")
local att2 = gp(handle2, "att1_Handle", "Attachment")
att2.Parent = cplayer["Right Arm"]
att2.Position = Vector3.new(0, -1.8, 0)
att2.Rotation = Vector3.new(-0, 0, 0)



--//====================================================\\--
--||			   CREATED BY SHACKLUSTER
--\\====================================================//--

wait(0.2)

Player = game:GetService("Players").LocalPlayer
PlayerGui = Player.PlayerGui
Cam = workspace.CurrentCamera
Backpack = Player.Backpack
Character = Player.Character
Humanoid = Character:FindFirstChildOfClass("Humanoid")
Mouse = Player:GetMouse()
RootPart = Character["HumanoidRootPart"]
Torso = Character["Torso"]
Head = Character["Head"]
RightArm = Character["Right Arm"]
LeftArm = Character["Left Arm"]
RightLeg = Character["Right Leg"]
LeftLeg = Character["Left Leg"]
RootJoint = RootPart["RootJoint"]
Neck = Torso["Neck"]
RightShoulder = Torso["Right Shoulder"]
LeftShoulder = Torso["Left Shoulder"]
RightHip = Torso["Right Hip"]
LeftHip = Torso["Left Hip"]

IT = Instance.new
CF = CFrame.new
VT = Vector3.new
RAD = math.rad
C3 = Color3.new
UD2 = UDim2.new
BRICKC = BrickColor.new
ANGLES = CFrame.Angles
EULER = CFrame.fromEulerAnglesXYZ
COS = math.cos
ACOS = math.acos
SIN = math.sin
ASIN = math.asin
ABS = math.abs
MRANDOM = math.random
FLOOR = math.floor

--//=================================\\
--|| 	      USEFUL VALUES
--\\=================================//

Animation_Speed = 3
Frame_Speed = 1 / 60 -- (1 / 30) OR (1 / 60)
local Speed = 25
local SIZE = 3
local ROOTC0 = CF(0, 0, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local NECKC0 = CF(0, 1, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local RIGHTSHOULDERC0 = CF(-0.5, 0, 0) * ANGLES(RAD(0), RAD(90), RAD(0))
local LEFTSHOULDERC0 = CF(0.5, 0, 0) * ANGLES(RAD(0), RAD(-90), RAD(0))
local DAMAGEMULTIPLIER = 1
local ANIM = "Idle"
local ATTACK = false
local EQUIPPED = false
local HOLD = false
local COMBO = 1
local Rooted = false
local SINE = 0
local KEYHOLD = false
local CHANGE = 2 / Animation_Speed
local WALKINGANIM = false
local VALUE1 = false
local VALUE2 = false
local ROBLOXIDLEANIMATION = IT("Animation")
ROBLOXIDLEANIMATION.Name = "Roblox Idle Animation"
ROBLOXIDLEANIMATION.AnimationId = "http://www.roblox.com/asset/?id=180435571"
--ROBLOXIDLEANIMATION.Parent = Humanoid
local WEAPONGUI = IT("ScreenGui", PlayerGui)
WEAPONGUI.Name = "Weapon GUI"
local Weapon = IT("Folder")
Weapon.Name = "Adds"
local Effects = IT("Folder", Weapon)
Effects.Name = "Effects"
local ANIMATOR = Humanoid.Animator
local ANIMATE = Character.Animate
local UNANCHOR = true
local VOCALS_BASIC = {468972244,468972378,468972711,468972944}
local VOCALS_TAUNT = {468973055,468973159}
local VOCAL_GROWL = 468971411
local VOCALS_ENRAGES = {528589078,528589175,528589274,528589382}
local CHARGE = 459523787
local ROUGHBLAST = 461105534
local WALLSOUND = 424195952
local FORCEIDLE = false
Character.Archivable = true
script.Parent = WEAPONGUI
local CLONE = Character:Clone()
CLONE.Parent = nil
Character.Archivable = false
local sick = Instance.new("Sound",Character)
local XATTACK = false
Humanoid.JumpPower = 200

--//=================================\\
--\\=================================//


--//=================================\\
--|| SAZERENOS' ARTIFICIAL HEARTBEAT
--\\=================================//

ArtificialHB = Instance.new("BindableEvent", script)
ArtificialHB.Name = "ArtificialHB"

script:WaitForChild("ArtificialHB")

frame = Frame_Speed
tf = 0
allowframeloss = false
tossremainder = false
lastframe = tick()
script.ArtificialHB:Fire()

game:GetService("RunService").Heartbeat:connect(function(s, p)
	tf = tf + s
	if tf >= frame then
		if allowframeloss then
			script.ArtificialHB:Fire()
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do
				script.ArtificialHB:Fire()
			end
		lastframe = tick()
		end
		if tossremainder then
			tf = 0
		else
			tf = tf - frame * math.floor(tf / frame)
		end
	end
end)

--//=================================\\
--\\=================================//

--//=================================\\
--|| 	      SOME FUNCTIONS
--\\=================================//

function Raycast(POSITION, DIRECTION, RANGE, IGNOREDECENDANTS)
	return workspace:FindPartOnRay(Ray.new(POSITION, DIRECTION.unit * RANGE), IGNOREDECENDANTS)
end

function PositiveAngle(NUMBER)
	if NUMBER >= 0 then
		NUMBER = 0
	end
	return NUMBER
end

function NegativeAngle(NUMBER)
	if NUMBER <= 0 then
		NUMBER = 0
	end
	return NUMBER
end

function Swait(NUMBER)
	if NUMBER == 0 or NUMBER == nil then
		ArtificialHB.Event:wait()
	else
		for i = 1, NUMBER do
			ArtificialHB.Event:wait()
		end
	end
end

function CreateMesh(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
	local NEWMESH = IT(MESH)
	if MESH == "SpecialMesh" then
		NEWMESH.MeshType = MESHTYPE
		if MESHID ~= "nil" and MESHID ~= "" then
			NEWMESH.MeshId = "http://www.roblox.com/asset/?id="..MESHID
		end
		if TEXTUREID ~= "nil" and TEXTUREID ~= "" then
			NEWMESH.TextureId = "http://www.roblox.com/asset/?id="..TEXTUREID
		end
	end
	NEWMESH.Offset = OFFSET or VT(0, 0, 0)
	NEWMESH.Scale = SCALE
	NEWMESH.Parent = PARENT
	return NEWMESH
end

function CreatePart(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE, ANCHOR)
	local NEWPART = IT("Part")
	NEWPART.formFactor = FORMFACTOR
	NEWPART.Reflectance = REFLECTANCE
	NEWPART.Transparency = TRANSPARENCY
	NEWPART.CanCollide = false
	NEWPART.Locked = true
	NEWPART.Anchored = true
	if ANCHOR == false then
		NEWPART.Anchored = false
	end
	NEWPART.BrickColor = BRICKC(tostring(BRICKCOLOR))
	NEWPART.Name = NAME
	NEWPART.Size = SIZE
	NEWPART.Position = Torso.Position
	NEWPART.Material = MATERIAL
	NEWPART:BreakJoints()
	NEWPART.Parent = PARENT
	return NEWPART
end

	local function weldBetween(a, b)
	    local weldd = Instance.new("ManualWeld")
	    weldd.Part0 = a
	    weldd.Part1 = b
	    weldd.C0 = CFrame.new()
	    weldd.C1 = b.CFrame:inverse() * a.CFrame
	    weldd.Parent = a
	    return weldd
	end


function QuaternionFromCFrame(cf)
	local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
	local trace = m00 + m11 + m22
	if trace > 0 then 
		local s = math.sqrt(1 + trace)
		local recip = 0.5 / s
		return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
	else
		local i = 0
		if m11 > m00 then
			i = 1
		end
		if m22 > (i == 0 and m00 or m11) then
			i = 2
		end
		if i == 0 then
			local s = math.sqrt(m00 - m11 - m22 + 1)
			local recip = 0.5 / s
			return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
		elseif i == 1 then
			local s = math.sqrt(m11 - m22 - m00 + 1)
			local recip = 0.5 / s
			return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
		elseif i == 2 then
			local s = math.sqrt(m22 - m00 - m11 + 1)
			local recip = 0.5 / s return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
		end
	end
end
 
function QuaternionToCFrame(px, py, pz, x, y, z, w)
	local xs, ys, zs = x + x, y + y, z + z
	local wx, wy, wz = w * xs, w * ys, w * zs
	local xx = x * xs
	local xy = x * ys
	local xz = x * zs
	local yy = y * ys
	local yz = y * zs
	local zz = z * zs
	return CFrame.new(px, py, pz, 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy))
end
 
function QuaternionSlerp(a, b, t)
	local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
	local startInterp, finishInterp;
	if cosTheta >= 0.0001 then
		if (1 - cosTheta) > 0.0001 then
			local theta = ACOS(cosTheta)
			local invSinTheta = 1 / SIN(theta)
			startInterp = SIN((1 - t) * theta) * invSinTheta
			finishInterp = SIN(t * theta) * invSinTheta
		else
			startInterp = 1 - t
			finishInterp = t
		end
	else
		if (1 + cosTheta) > 0.0001 then
			local theta = ACOS(-cosTheta)
			local invSinTheta = 1 / SIN(theta)
			startInterp = SIN((t - 1) * theta) * invSinTheta
			finishInterp = SIN(t * theta) * invSinTheta
		else
			startInterp = t - 1
			finishInterp = t
		end
	end
	return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end

function Clerp(a, b, t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.x, a.y, a.z
	local bx, by, bz = b.x, b.y, b.z
	local _t = 1 - t
	return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end

function CreateFrame(PARENT, TRANSPARENCY, BORDERSIZEPIXEL, POSITION, SIZE, COLOR, BORDERCOLOR, NAME)
	local frame = IT("Frame")
	frame.BackgroundTransparency = TRANSPARENCY
	frame.BorderSizePixel = BORDERSIZEPIXEL
	frame.Position = POSITION
	frame.Size = SIZE
	frame.BackgroundColor3 = COLOR
	frame.BorderColor3 = BORDERCOLOR
	frame.Name = NAME
	frame.Parent = PARENT
	return frame
end

function CreateLabel(PARENT, TEXT, TEXTCOLOR, TEXTFONTSIZE, TEXTFONT, TRANSPARENCY, BORDERSIZEPIXEL, STROKETRANSPARENCY, NAME)
	local label = IT("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UD2(1, 0, 1, 0)
	label.Position = UD2(0, 0, 0, 0)
	label.TextColor3 = TEXTCOLOR
	label.TextStrokeTransparency = STROKETRANSPARENCY
	label.TextTransparency = TRANSPARENCY
	label.FontSize = TEXTFONTSIZE
	label.Font = TEXTFONT
	label.BorderSizePixel = BORDERSIZEPIXEL
	label.TextScaled = false
	label.Text = TEXT
	label.Name = NAME
	label.Parent = PARENT
	return label
end

function NoOutlines(PART)
	PART.TopSurface, PART.BottomSurface, PART.LeftSurface, PART.RightSurface, PART.FrontSurface, PART.BackSurface = 10, 10, 10, 10, 10, 10
end

function CreateWeldOrSnapOrMotor(TYPE, PARENT, PART0, PART1, C0, C1)
	local NEWWELD = IT(TYPE)
	NEWWELD.Part0 = PART0
	NEWWELD.Part1 = PART1
	NEWWELD.C0 = C0
	NEWWELD.C1 = C1
	NEWWELD.Parent = PARENT
	return NEWWELD
end

local S = IT("Sound")
function CreateSound(ID, PARENT, VOLUME, PITCH, DOESLOOP)
	local NEWSOUND = nil
	coroutine.resume(coroutine.create(function()
		NEWSOUND = S:Clone()
		NEWSOUND.Parent = PARENT
		NEWSOUND.Volume = VOLUME
		NEWSOUND.Pitch = PITCH
		NEWSOUND.SoundId = "http://www.roblox.com/asset/?id="..ID
		NEWSOUND:play()
		if DOESLOOP == true then
			NEWSOUND.Looped = true
		else
			repeat wait(1) until NEWSOUND.Playing == false
			NEWSOUND:remove()
		end
	end))
	return NEWSOUND
end

function CFrameFromTopBack(at, top, back)
	local right = top:Cross(back)
	return CF(at.x, at.y, at.z, right.x, top.x, back.x, right.y, top.y, back.y, right.z, top.z, back.z)
end

--WACKYEFFECT({EffectType = "", Size = VT(1,1,1), Size2 = VT(0,0,0), Transparency = 0, Transparency2 = 1, CFrame = CF(), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = C3(1,1,1), SoundID = nil, SoundPitch = nil, SoundVolume = nil})
function WACKYEFFECT(Table)
	local TYPE = (Table.EffectType or "Sphere")
	local SIZE = (Table.Size or VT(1,1,1))
	local ENDSIZE = (Table.Size2 or VT(0,0,0))
	local TRANSPARENCY = (Table.Transparency or 0)
	local ENDTRANSPARENCY = (Table.Transparency2 or 1)
	local CFRAME = (Table.CFrame or Torso.CFrame)
	local MOVEDIRECTION = (Table.MoveToPos or nil)
	local ROTATION1 = (Table.RotationX or 0)
	local ROTATION2 = (Table.RotationY or 0)
	local ROTATION3 = (Table.RotationZ or 0)
	local MATERIAL = (Table.Material or "Neon")
	local COLOR = (Table.Color or C3(1,1,1))
	local TIME = (Table.Time or 45)
	local SOUNDID = (Table.SoundID or nil)
	local SOUNDPITCH = (Table.SoundPitch or nil)
	local SOUNDVOLUME = (Table.SoundVolume or nil)
	coroutine.resume(coroutine.create(function()
		local PLAYSSOUND = false
		local SOUND = nil
		local EFFECT = CreatePart(3, Effects, MATERIAL, 0, TRANSPARENCY, BRICKC("Pearl"), "Effect", VT(1,1,1), true)
		if SOUNDID ~= nil and SOUNDPITCH ~= nil and SOUNDVOLUME ~= nil then
			PLAYSSOUND = true
			SOUND = CreateSound(SOUNDID, EFFECT, SOUNDVOLUME, SOUNDPITCH, false)
		end
		EFFECT.Color = COLOR
		local MSH = nil
		if TYPE == "Sphere" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "Sphere", "", "", SIZE, VT(0,0,0))
		elseif TYPE == "Block" then
			MSH = IT("BlockMesh",EFFECT)
			MSH.Scale = VT(SIZE.X,SIZE.X,SIZE.X)
		elseif TYPE == "Wave" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "20329976", "", SIZE, VT(0,0,-SIZE.X/8))
		elseif TYPE == "Ring" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "559831844", "", VT(SIZE.X,SIZE.X,0.1), VT(0,0,0))
		elseif TYPE == "Slash" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662586858", "", VT(SIZE.X/10,0,SIZE.X/10), VT(0,0,0))
		elseif TYPE == "Round Slash" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662585058", "", VT(SIZE.X/10,0,SIZE.X/10), VT(0,0,0))
		elseif TYPE == "Swirl" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "1051557", "", SIZE, VT(0,0,0))
		elseif TYPE == "Skull" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "4770583", "", SIZE, VT(0,0,0))
		elseif TYPE == "Crystal" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "9756362", "", SIZE, VT(0,0,0))
		end
		if MSH ~= nil then
			local MOVESPEED = nil
			if MOVEDIRECTION ~= nil then
				MOVESPEED = (CFRAME.p - MOVEDIRECTION).Magnitude/TIME
			end
			local GROWTH = SIZE - ENDSIZE
			local TRANS = TRANSPARENCY - ENDTRANSPARENCY
			if TYPE == "Block" then
				EFFECT.CFrame = CFRAME*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
			else
				EFFECT.CFrame = CFRAME
			end
			for LOOP = 1, TIME+1 do
				Swait()
				MSH.Scale = MSH.Scale - GROWTH/TIME
				if TYPE == "Wave" then
					MSH.Offset = VT(0,0,-MSH.Scale.X/8)
				end
				EFFECT.Transparency = EFFECT.Transparency - TRANS/TIME
				if TYPE == "Block" then
					EFFECT.CFrame = CFRAME*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
				else
					EFFECT.CFrame = EFFECT.CFrame*ANGLES(RAD(ROTATION1),RAD(ROTATION2),RAD(ROTATION3))
				end
				if MOVEDIRECTION ~= nil then
					local ORI = EFFECT.Orientation
					EFFECT.CFrame = CF(EFFECT.Position,MOVEDIRECTION)*CF(0,0,-MOVESPEED)
					EFFECT.Orientation = ORI
				end
			end
			EFFECT.Transparency = 1
			if PLAYSSOUND == false then
				EFFECT:remove()
			else
				repeat Swait() until SOUND.Playing == false
				EFFECT:remove()
			end
		else
			if PLAYSSOUND == false then
				EFFECT:remove()
			else
				repeat Swait() until SOUND.Playing == false
				EFFECT:remove()
			end
		end
	end))
end

function MakeForm(PART,TYPE)
	if TYPE == "Cyl" then
		local MSH = IT("CylinderMesh",PART)
	elseif TYPE == "Ball" then
		local MSH = IT("SpecialMesh",PART)
		MSH.MeshType = "Sphere"
	elseif TYPE == "Wedge" then
		local MSH = IT("SpecialMesh",PART)
		MSH.MeshType = "Wedge"
	end
end

Debris = game:GetService("Debris")

function CastProperRay(StartPos, EndPos, Distance, Ignore)
	local DIRECTION = CF(StartPos,EndPos).lookVector
	return Raycast(StartPos, DIRECTION, Distance, Ignore)
end

function turnto(position)
	RootPart.CFrame=CFrame.new(RootPart.CFrame.p,VT(position.X,RootPart.Position.Y,position.Z)) * CFrame.new(0, 0, 0)
end

local Particle = IT("ParticleEmitter",nil)
Particle.Enabled = false
Particle.LightEmission = 0.2
Particle.Rate = 150
Particle.ZOffset = 1
Particle.Rotation = NumberRange.new(-180, 180)

--ParticleEmitter({Speed = 5, RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 1, Size2 = 5, Lifetime1 = 1, Lifetime2 = 1.5, Parent = Torso, Emit = 100, Offset = 360, Enabled = false, Color1 = C3(1,1,1), Color2 = C3(1,1,1), Texture = ""})
function ParticleEmitter(Table)
	local PRTCL = Particle:Clone()
	local Color1 = Table.Color1 or C3(1,1,1)
	local Color2 = Table.Color2 or C3(1,1,1)
	local Speed = Table.Speed or 5
	local Drag = Table.Drag or 0
	local Size1 = Table.Size1 or 1
	local Size2 = Table.Size2 or 5
	local Lifetime1 = Table.Lifetime1 or 1
	local Lifetime2 = Table.Lifetime2 or 1.5
	local Parent = Table.Parent or Torso
	local Emit = Table.Emit or 100
	local Offset = Table.Offset or 360
	local Acel = Table.Acel or VT(0,0,0)
	local Enabled = Table.Enabled or false
	local Texture = Table.Texture or "281983280"
	local RotS = Table.RotSpeed or NumberRange.new(-15, 15)
	local Trans1 = Table.Transparency1 or 0
	local Trans2 = Table.Transparency2 or 0
	PRTCL.Parent = Parent
	PRTCL.RotSpeed = RotS
	PRTCL.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,Trans1),NumberSequenceKeypoint.new(1,Trans2)})
	PRTCL.Texture = "http://www.roblox.com/asset/?id="..Texture
	PRTCL.Color = ColorSequence.new(Color1,Color2)
	PRTCL.Size = NumberSequence.new(Size1,Size2)
	PRTCL.Lifetime = NumberRange.new(Lifetime1,Lifetime2)
	PRTCL.Speed = NumberRange.new(Speed)
	PRTCL.VelocitySpread = Offset
	PRTCL.Drag = Drag
	PRTCL.Acceleration = Acel
	if Enabled == false then
		PRTCL:Emit(Emit)
		Debris:AddItem(PRTCL,Lifetime2)
	else
		PRTCL.Enabled = true
	end
	return PRTCL
end

function AddChildrenToTable(FROM,PARENT,DIST,TABLE)
	for _, c in pairs(PARENT:GetDescendants()) do
		if c.ClassName == "Model" then
			if c ~= Character and c:FindFirstChildOfClass("Humanoid") and (c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")) then
				local HUMANOID = c:FindFirstChildOfClass("Humanoid")
				local TORSO = (c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
				if (TORSO.Position - FROM).Magnitude < DIST then
					table.insert(TABLE,c)
				end
			end
		end
	end
end

--//=================================\\
--||	     WEAPON CREATION
--\\=================================//

local DECAL = IT("Decal",nil)
DECAL.Transparency = 1
DECAL.Texture = "http://www.roblox.com/asset/?id=0"
--Head:ClearAllChildren()

--Humanoid.Parent = nil
RootPart.Size = RootPart.Size*SIZE
Torso.Size = Torso.Size*SIZE
RightArm.Size = RightArm.Size*SIZE
RightLeg.Size = RightLeg.Size*SIZE
LeftArm.Size = LeftArm.Size*SIZE
LeftLeg.Size = LeftLeg.Size*SIZE
RootJoint.C0 = ROOTC0 * CF(0 * SIZE, 0 * SIZE, 0 * SIZE) * ANGLES(RAD(0), RAD(0), RAD(0))
RootJoint.C1 = ROOTC0 * CF(0 * SIZE, 0 * SIZE, 0 * SIZE) * ANGLES(RAD(0), RAD(0), RAD(0))
Neck.C0 = NECKC0 * CF(0 * SIZE, 0 * SIZE, 0 + ((1 * SIZE) - 1)) * ANGLES(RAD(0), RAD(0), RAD(0))
Neck.C1 = CF(0 * SIZE, -0.5 * SIZE, 0 * SIZE) * ANGLES(RAD(-90), RAD(0), RAD(180))
RightShoulder.C1 = CF(0 * SIZE, 0.5 * SIZE, -0.35 * SIZE)
LeftShoulder.C1 = CF(0 * SIZE, 0.5 * SIZE, -0.35 * SIZE)
RightHip.C0 = CF(1 * SIZE, -1 * SIZE, 0 * SIZE) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0))
LeftHip.C0 = CF(-1 * SIZE, -1 * SIZE, 0 * SIZE) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0))
RightHip.C1 = CF(0.5 * SIZE, 1 * SIZE, 0 * SIZE) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0))
LeftHip.C1 = CF(-0.5 * SIZE, 1 * SIZE, 0 * SIZE) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0))
Head.Size = VT(Head.Size.Y,Head.Size.Y,Head.Size.Y)*SIZE
RootJoint.Parent = RootPart
Neck.Parent = Torso
RightShoulder.Parent = Torso
LeftShoulder.Parent = Torso
RightHip.Parent = Torso
LeftHip.Parent = Torso

CreateMesh("SpecialMesh", Head, "FileMesh", "0", "0", VT(1.75, 1.75, 1.7)*SIZE, VT(0,0.4,0.1)*SIZE)
--CreateMesh("SpecialMesh", Head, "FileMesh", "62719736", "1566254101", VT(0.85,0.85,0.85)*SIZE, VT(0,1,-0.4))
Humanoid.DisplayDistanceType = "None"
local naeeym = IT("BillboardGui",Character)
naeeym.AlwaysOnTop = true
naeeym.Size = UDim2.new(5,35,2,15)
naeeym.StudsOffset = Vector3.new(0,5,0)
naeeym.MaxDistance = 75
naeeym.Adornee = Character.Head
naeeym.Name = "Name"
local tecks = IT("TextLabel",naeeym)
tecks.BackgroundTransparency = 1
tecks.TextScaled = true
tecks.BorderSizePixel = 0
tecks.Text = "///////////////////"
tecks.Font = "Fantasy"
tecks.TextSize = 30
tecks.TextTransparency = 0.5
tecks.TextStrokeTransparency = 0.5
tecks.TextColor3 = C3(0,0,0)
tecks.TextStrokeColor3 = C3(175/1275, 148/1275, 131/1275)
tecks.Size = UDim2.new(1,0,0.5,0)
tecks.Parent = naeeym
local naeeym2 = IT("BillboardGui",Character)
naeeym2.AlwaysOnTop = true
naeeym2.Size = UDim2.new(7,35,3,15)
naeeym2.StudsOffset = Vector3.new(0,5,0)
naeeym2.MaxDistance = 75
naeeym2.Adornee = Character.Head
naeeym2.Name = "Name2"
local tecks2 = IT("TextLabel",naeeym2)
tecks2.BackgroundTransparency = 1
tecks2.TextScaled = true
tecks2.BorderSizePixel = 0
tecks2.Text = "Satan"
tecks2.Font = "Fantasy"
tecks2.TextSize = 30
tecks2.TextStrokeTransparency = 0
tecks2.TextColor3 = C3(0,0,0)
tecks2.TextStrokeColor3 = C3(175/575, 148/675, 131/675)
tecks2.Size = UDim2.new(1,0,0.5,0)
tecks2.Parent = naeeym2

local MSG = game.Chat:FilterStringForBroadcast(tecks2.Text,Player)
tecks2.Text = MSG

local MSG = game.Chat:FilterStringForBroadcast(tecks.Text,Player)
tecks.Text = MSG

local RINGFIRE = {}
local top = Instance.new("Shirt")
top.ShirtTemplate = "rbxassetid://791994658"
top.Parent = Character
top.Name = "Cloth"
local bottom = Instance.new("Pants")
bottom.PantsTemplate = "rbxassetid://1029442377"
bottom.Parent = Character
bottom.Name = "Cloth"
local FIRE = IT("Model",Weapon)
FIRE.Name = "RingOfFire"
local MAIN = CreatePart(3, FIRE, "Neon", 0, 1, "Lavender", "Center", VT(0,0,0))
FIRE.PrimaryPart = MAIN
for i = 1, 45 do
	local PRT = CreatePart(3, FIRE, "Neon", 0, 1, "Lavender", "RingPart", VT(1,1,1))
	PRT.CFrame = MAIN.CFrame*ANGLES(RAD(0),RAD((360/45)*i),RAD(0))*CF(0,0,8)
	local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0,Speed = 0.2, Acel = VT(8,18,6), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 0.8, Parent = PRT, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(0,0,0), Color2 = C3(0.5,0,0), Texture = "1523916715"})
	PRTCL.LockedToPart = true
	PRTCL.Rate = 35
	table.insert(RINGFIRE,PRTCL)
end
local A = IT("Attachment",RightArm)
A.Position = VT(0,-1*SIZE,0.1*SIZE)
local B = IT("Attachment",LeftArm)
B.Position = VT(0,-1*SIZE,0.1*SIZE)
local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0,Speed = 1, Acel = VT(0,-1,0), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1.4, Parent = A, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(0,0,0), Color2 = C3(0.3,0,0), Texture = "1523916715"})
PRTCL.LockedToPart = true
PRTCL.Rate = 85
table.insert(RINGFIRE,PRTCL)
local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0,Speed = 1, Acel = VT(0,-1,0), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1.4, Parent = B, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(0,0,0), Color2 = C3(0.3,0,0), Texture = "1523916715"})
PRTCL.LockedToPart = true
PRTCL.Rate = 85
table.insert(RINGFIRE,PRTCL)


local EYE1 = IT("Attachment",Head)
EYE1.Position = (VT(0.5, 0.900, -1.195)/2)*SIZE
local EYE2 = IT("Attachment",Head)
EYE2.Position = (VT(-0.5, 0.900, -1.195)/2)*SIZE
local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 0.2, Acel = VT(2,0.5,0.6), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 0.15, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1.4, Parent = EYE1, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(1,0,0), Color2 = C3(0.3,0,0), Texture = "1523916715"})
PRTCL.LockedToPart = true
PRTCL.Rate = 185
PRTCL.ZOffset = 0.1
table.insert(RINGFIRE,PRTCL)
local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 0.2, Acel = VT(-2,0.5,0.6), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 0.15, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1.4, Parent = EYE2, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(1,0,0), Color2 = C3(0.3,0,0), Texture = "1523916715"})
PRTCL.LockedToPart = true
PRTCL.Rate = 185
PRTCL.ZOffset = 0.1
local BODY = {}
table.insert(RINGFIRE,PRTCL)
for _, c in pairs(Character:GetDescendants()) do
	if c:IsA("BasePart") and c.Name ~= "Handle" then
		if c ~= RootPart and c ~= Torso and c ~= Head and c ~= RightArm and c ~= LeftArm and c ~= RightLeg and c ~= LeftLeg then
			c.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		end
		table.insert(BODY,{c,c.Parent,c.Material,c.Color,c.Transparency,c.Size,c.Name})
	elseif c:IsA("JointInstance") then
		table.insert(BODY,{c,c.Parent,nil,nil,nil,nil,nil})
	end
end
function refit()
	Character.Parent = workspace
	for e = 1, #BODY do
		if BODY[e] ~= nil then
			local STUFF = BODY[e]
			local PART = STUFF[1]
			local PARENT = STUFF[2]
			local MATERIAL = STUFF[3]
			local COLOR = STUFF[4]
			local TRANSPARENCY = STUFF[5]
			--local SIZE = STUFF[6]
			local NAME = STUFF[7]
			if PART.ClassName == "Part" and PART ~= RootPart then
				PART.Material = MATERIAL
				PART.Transparency = TRANSPARENCY
				PART.Name = NAME
			end
			if PART.Parent ~= PARENT then
				Humanoid:remove()
				PART.Parent = PARENT
				Humanoid = IT("Humanoid",Character)
			end
		end
	end
end



local SKILLTEXTCOLOR = C3(0,0,0)
local SKILLFONT = "Fantasy"
local SKILLTEXTSIZE = 6

Weapon.Parent = Character
Humanoid.Parent = Character

Humanoid.Died:connect(function()
	refit()
end)

local SKILL1FRAME = CreateFrame(WEAPONGUI, 1, 2, UD2(0.8, 0, 0.90, 0), UD2(0.26, 0, 0.07, 0), C3(0,0,0), C3(0, 0, 0), "Skill 1 Frame")
local SKILL2FRAME = CreateFrame(WEAPONGUI, 1, 2, UD2(0.8, 0, 0.86, 0), UD2(0.26, 0, 0.07, 0), C3(0,0,0), C3(0, 0, 0), "Skill 2 Frame")
local SKILL3FRAME = CreateFrame(WEAPONGUI, 1, 2, UD2(0.8, 0, 0.82, 0), UD2(0.26, 0, 0.07, 0), C3(0,0,0), C3(0, 0, 0), "Skill 3 Frame")
local SKILL4FRAME = CreateFrame(WEAPONGUI, 1, 2, UD2(0.8, 0, 0.78, 0), UD2(0.26, 0, 0.07, 0), C3(0,0,0), C3(0, 0, 0), "Skill 4 Frame")
local SKILL5FRAME = CreateFrame(WEAPONGUI, 1, 2, UD2(0.8, 0, 0.74, 0), UD2(0.26, 0, 0.07, 0), C3(0,0,0), C3(0, 0, 0), "Skill 5 Frame")

local SKILL1TEXT = CreateLabel(SKILL1FRAME, "[Z]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, 2, 1, "Text 1")
local SKILL2TEXT = CreateLabel(SKILL2FRAME, "[B]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, 2, 1, "Text 2")
local SKILL3TEXT = CreateLabel(SKILL3FRAME, "[C]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, 2, 1, "Text 3")
local SKILL4TEXT = CreateLabel(SKILL4FRAME, "[V]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, 2, 1, "Text 4")
local SKILL5TEXT = CreateLabel(SKILL5FRAME, "[X]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, 2, 1, "Text 5")

--//=================================\\
--||			DAMAGING
--\\=================================//

function ApplyDamage(Humanoid,Damage,TorsoPart)
	local defence = Instance.new("BoolValue",Humanoid.Parent)
	defence.Name = ("HitBy"..Player.Name)
	game:GetService("Debris"):AddItem(defence, 0.001)
	Damage = Damage * DAMAGEMULTIPLIER
	if Humanoid.Health ~= 0 then
		local CritChance = MRANDOM(0,0)
		if Damage > Humanoid.Health then
			Damage = math.ceil(Humanoid.Health)
			if Damage == 0 then
				Damage = 0.1
			end
		end
		Humanoid.Health = Humanoid.Health - Damage
	end
end

function ApplyAoE(POSITION,RANGE,MINDMG,MAXDMG,FLING,INSTAKILL)
	local CHILDREN = workspace:GetDescendants()
	for index, CHILD in pairs(CHILDREN) do
		if CHILD.ClassName == "Model" and CHILD ~= Character then
			local HUM = CHILD:FindFirstChildOfClass("Humanoid")
			if HUM then
				local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
				if TORSO then
					if (TORSO.Position - POSITION).Magnitude <= RANGE then
						if CHILD.Parent == Effects and CHILD:FindFirstChild("RealBody") then
							local BODY = CHILD.RealBody.Value
							if BODY then
								local HUM = BODY:FindFirstChildOfClass("Humanoid")
								if HUM then
									if INSTAKILL == true or (HUM.MaxHealth == math.huge and MAXDMG > 0) then
										BODY:BreakJoints()
									else
										local TORSO = BODY:FindFirstChild("Torso") or BODY:FindFirstChild("UpperTorso")
										if TORSO then
											local HITPLAYERSOUNDS = {--[["199149137", "199149186", "199149221", "199149235", "199149269", "199149297"--]]"263032172", "263032182", "263032200", "263032221", "263032252", "263033191"}
											local DMG = MRANDOM(MINDMG,MAXDMG)/2
											WACKYEFFECT({Time = 15, EffectType = "Sphere", Size = VT(1,1,1), Size2 = VT(1,85,1), Transparency = 0, Transparency2 = 1, CFrame = CF(TORSO.Position) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360))), MoveToPos = nil, RotationX = 0, RotationY = MRANDOM(-35,35), RotationZ = 0, Material = "Neon", Color = C3(0.3,0,0), SoundID = HITPLAYERSOUNDS[MRANDOM(1,#HITPLAYERSOUNDS)], SoundPitch = MRANDOM(7,15)/10, SoundVolume = 10})
											ApplyDamage(HUM,DMG,TORSO)
										end
									end
								end
							end
						else
							if INSTAKILL == true or (HUM.MaxHealth == math.huge and MAXDMG > 0) then
								CHILD:BreakJoints()
							else
								local DMG = MRANDOM(MINDMG,MAXDMG)
								ApplyDamage(HUM,DMG,TORSO)
							end
							if FLING > 0 then
								for _, c in pairs(CHILD:GetChildren()) do
									if c:IsA("BasePart") then
										local bv = Instance.new("BodyVelocity") 
										bv.maxForce = Vector3.new(1e9, 1e9, 1e9)
										bv.velocity = CF(POSITION,TORSO.Position).lookVector*FLING
										bv.Parent = c
										Debris:AddItem(bv,0.05)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

--//=================================\\
--||	ATTACK FUNCTIONS AND STUFF
--\\=================================//

function MissilesOfDespair()
	ATTACK = true
	Rooted = true
	local MAKERING = true
	local RINGGROW = false
	CreateSound(VOCALS_BASIC[MRANDOM(1,#VOCALS_BASIC)], Head, MRANDOM(9,11)/1.5, MRANDOM(9,11)/10, false)
	coroutine.resume(coroutine.create(function()
		repeat
			Swait()
			if ATTACK == false then
				break
			end
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		until MAKERING == false
		repeat
			Swait()
			if ATTACK == false then
				break
			end
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(43 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-42 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		until RINGGROW == true
	end))
	local FIRERING = IT("Model",Effects)
	FIRERING.Name = "RingOfFire"
	local MAIN = CreatePart(3, FIRERING, "Neon", 0, 1, "Lavender", "Center", VT(0,0,0))
	FIRERING.PrimaryPart = MAIN
	local RINGS = {}
	local EMITTERS = {}
	for i = 1, 45 do
		local PRT = CreatePart(3, FIRERING, "Neon", 0, 1, "Lavender", "RingPart", VT(1,1,1))
		PRT.CFrame = MAIN.CFrame*ANGLES(RAD(0),RAD((360/45)*i),RAD(0))*CF(0,0,0)
		table.insert(RINGS,PRT)
		local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0,Speed = 0.2, Acel = VT(8,18,6), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 0.8, Parent = PRT, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(0,0,0), Color2 = C3(0.5,0,0), Texture = "1523916715"})
		PRTCL.LockedToPart = true
		PRTCL.Rate = 35
		table.insert(EMITTERS,PRTCL)
	end
	FIRERING:SetPrimaryPartCFrame(RootPart.CFrame*CF(0,3,-3)*ANGLES(RAD(-75),RAD(0),RAD(0)))
	wait(0.5)
	MAKERING = false
	CreateSound(278641993, MAIN, 5, 1.2, false)
	for e = 1, 45 do
		Swait()
		FIRERING:SetPrimaryPartCFrame(RootPart.CFrame*CF(0,3,-3)*ANGLES(RAD(-75),RAD(0),RAD(0)))
		for i = 1, #RINGS do
			RINGS[i].CFrame = MAIN.CFrame*ANGLES(RAD(0),RAD((360/45)*i),RAD(0))*CF(0,0,e/10)
		end
	end
	RINGGROW = true
	wait(0.2)
	for i = 1, 15 do
		wait(0.08)
		coroutine.resume(coroutine.create(function()
			local POS = Mouse.Hit.p
			local MISSILE = CreatePart(3, Effects, "Neon", 0, 1, "Maroon", "Missile", VT(0.5,1,0.5))
			MISSILE.Color = C3(0.2,0,0)
			CreateSound(84005018, MISSILE, 0.2, 1.2, false)
			MakeForm(MISSILE,"Ball")
			MISSILE.CFrame = MAIN.CFrame*ANGLES(RAD(0),RAD(MRANDOM(0,360)),RAD(0))*CF(0,0,MRANDOM(1,5))
			for i = 1, 10 do
				Swait()
				MISSILE.Transparency = MISSILE.Transparency - 1/15
				MISSILE.CFrame = MISSILE.CFrame * CF(0,0.7,0)
			end
			for i = 1, 5 do
				Swait()
				MISSILE.Transparency = MISSILE.Transparency - 1/15
				MISSILE.CFrame = MISSILE.CFrame * CF(0,0.5,0)
			end
			MISSILE.Size = VT(0.2,0.2,1.5)
			MISSILE.CFrame = CF(MISSILE.Position,POS)
			for i = 1, 150 do
				Swait()
				MISSILE.CFrame = MISSILE.CFrame*CF(0,0,-3)
				local HIT = Raycast(MISSILE.Position, MISSILE.CFrame.lookVector, 4, Character)
				if HIT ~= nil then
					WACKYEFFECT({Time = 35, EffectType = "Sphere", Size = MISSILE.Size, Size2 = VT(25,25,25), Transparency = 0, Transparency2 = 1, CFrame = MISSILE.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = MISSILE.Color, SoundID = nil, SoundPitch = 1.3, SoundVolume = 3})
					WACKYEFFECT({Time = 25, EffectType = "Sphere", Size = MISSILE.Size, Size2 = VT(25,25,25), Transparency = 0, Transparency2 = 1, CFrame = MISSILE.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = MISSILE.Color, SoundID = nil, SoundPitch = 1.3, SoundVolume = 3})
					WACKYEFFECT({Time = 15, EffectType = "Sphere", Size = MISSILE.Size, Size2 = VT(25,25,25), Transparency = 0, Transparency2 = 1, CFrame = MISSILE.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = MISSILE.Color, SoundID = 165970126, SoundPitch = MRANDOM(7,15)/10, SoundVolume = MRANDOM(15,30)/10})
					for i = 1, 5 do
						WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0,0,0), Size2 = VT(35,2,35), Transparency = 0.8, Transparency2 = 1, CFrame = MISSILE.CFrame * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360))), MoveToPos = nil, RotationX = 0, RotationY = -5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
					end
					ApplyAoE(MISSILE.Position,15,15,25,35,false)
					break
				end
			end
			MISSILE:remove()
		end))
	end
	for i = 1, #EMITTERS do
		EMITTERS[i].Enabled = false
	end
	Debris:AddItem(FIRERING,3)
	ATTACK = false
	Rooted = false
end

function ShadowRoam()
	local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*SIZE, Character)
	if HITFLOOR then
		ATTACK = true
		CreateSound(VOCALS_BASIC[MRANDOM(1,#VOCALS_BASIC)], Head, MRANDOM(9,11)/1.5, MRANDOM(9,11)/10, false)
		local BUSY = false
		Rooted = true
		local CLOAKING = false
		local UNCLOAKED = true
		local LOOP = nil
		local FAKESHADOW = IT("Model",Effects)
		FAKESHADOW.Name = "Shadow"
		local POS = RootPart.Position
		local MOUSEHIT = nil
		--
			local TORS = CreatePart(3, FAKESHADOW, "Neon", 0, 1, "Maroon", "Spike", Torso.Size)
			TORS.Color = C3(0,0,0)
			TORS.CFrame = RootPart.CFrame*CF(0,-6.85,-0.8) * ANGLES(RAD(90), RAD(180), RAD(0))
			local HED = CreatePart(3, FAKESHADOW, "Neon", 0, 1, "Maroon", "Spike", VT(Head.Size.Y,Head.Size.Y,Head.Size.Y))
			HED.Color = C3(0,0,0)
			HED.CFrame = TORS.CFrame*CF(0,-TORS.Size.Y/2-HED.Size.Y/2,0)
			local RARM = CreatePart(3, FAKESHADOW, "Neon", 0, 1, "Maroon", "Spike", RightArm.Size)
			RARM.Color = C3(0,0,0)
			RARM.CFrame = TORS.CFrame*CF(TORS.Size.X/2+RARM.Size.X/1.9,-0.3,0) * ANGLES(RAD(0), RAD(0), RAD(-15))
			local LARM = CreatePart(3, FAKESHADOW, "Neon", 0, 1, "Maroon", "Spike", RightArm.Size)
			LARM.Color = C3(0,0,0)
			LARM.CFrame = TORS.CFrame*CF(-TORS.Size.X/2-RARM.Size.X/1.9,-0.3,0) * ANGLES(RAD(0), RAD(0), RAD(15))
			local RLEG = CreatePart(3, FAKESHADOW, "Neon", 0, 1, "Maroon", "Spike", RightLeg.Size)
			RLEG.Color = C3(0,0,0)
			RLEG.CFrame = TORS.CFrame*CF(TORS.Size.X/2.8,TORS.Size.Y,0) * ANGLES(RAD(0), RAD(0), RAD(-15))
			local LLEG = CreatePart(3, FAKESHADOW, "Neon", 0, 1, "Maroon", "Spike", RightLeg.Size)
			LLEG.Color = C3(0,0,0)
			LLEG.CFrame = TORS.CFrame*CF(-TORS.Size.X/2.8,TORS.Size.Y,0) * ANGLES(RAD(0), RAD(0), RAD(15))
		--
		coroutine.resume(coroutine.create(function()
			coroutine.resume(coroutine.create(function()
				while wait() do
					if RootPart.Position.Y > POS.Y then
						BUSY = true
						if MOUSEHIT then
							MOUSEHIT:disconnect()
						end
						for _, c in pairs(Character:GetChildren()) do
							if c.ClassName == "Part" and c ~= RootPart then
								c.Transparency = 0
								for _, q in pairs(c:GetChildren()) do
									if q.ClassName == "Decal" then
										q.Transparency = 0
									end
								end
							end
						end
						for i=0, 1.5, 0.1 / Animation_Speed do
							Swait()
							RootPart.Anchored = true
							UNCLOAKED = false
							RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.3 / Animation_Speed)
							Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
							RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
							LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
							RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
							LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
						end
						coroutine.resume(coroutine.create(function()
							for i = 1, 15 do
								Swait()
								if FAKESHADOW then
									for _, q in pairs(FAKESHADOW:GetChildren()) do
										if q.ClassName == "Part" then
											q.Transparency = q.Transparency + 1/15
										end
									end
								end
							end
							if FAKESHADOW then
								FAKESHADOW:remove()
							end
							FAKESHADOW = nil
						end))
						for i=0, 0.5, 0.1 / Animation_Speed do
							Swait()
							RootPart.Anchored = true
							UNCLOAKED = true
							if LOOP then
								LOOP.Pitch = LOOP.Pitch - 0.2
							end
							RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.3 / Animation_Speed)
							Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
							RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
							LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
							RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
							LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
						end
						LOOP:remove()
						LOOP = nil
						for i = 1, 35 do
							Swait()
							for _, c in pairs(Character:GetChildren()) do
								if c.ClassName == "Part" then
									for _, q in pairs(c:GetChildren()) do
										if q.ClassName == "Decal" then
											q.Transparency = q.Transparency + 1/35
										end
									end
								end
							end
						end
						UNANCHOR = true
						ATTACK = false
						Rooted = false
					end
					if FAKESHADOW then
						TORS.CFrame = RootPart.CFrame*CF(0,-6.85,-0.8) * ANGLES(RAD(90), RAD(180), RAD(0))
						HED.CFrame = TORS.CFrame*CF(0,-TORS.Size.Y/2-HED.Size.Y/2,0)
						RARM.CFrame = TORS.CFrame*CF(TORS.Size.X/2+RARM.Size.X/1.9,-0.3,0) * ANGLES(RAD(0), RAD(0), RAD(-15))
						LARM.CFrame = TORS.CFrame*CF(-TORS.Size.X/2-RARM.Size.X/1.9,-0.3,0) * ANGLES(RAD(0), RAD(0), RAD(15))
						RLEG.CFrame = TORS.CFrame*CF(TORS.Size.X/2.8,TORS.Size.Y,0) * ANGLES(RAD(0), RAD(0), RAD(-15))
						LLEG.CFrame = TORS.CFrame*CF(-TORS.Size.X/2.8,TORS.Size.Y,0) * ANGLES(RAD(0), RAD(0), RAD(15))
					end
					if LOOP ~= nil then
						LOOP.Parent = TORS
					end
					naeeym.Enabled = UNCLOAKED
					naeeym2.Enabled = UNCLOAKED
					for c = 1, #RINGFIRE do
						RINGFIRE[c].Enabled = UNCLOAKED
					end
					if ATTACK == false then
						break
					end
				end
			end))
			repeat
				Swait()
				if ATTACK == false then
					break
				end
				RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			until CLOAKING == true
		end))
		wait(0.3)
		for i = 1, 35 do
			Swait()
			for _, c in pairs(Character:GetChildren()) do
				if c.ClassName == "Part" then
					for _, q in pairs(c:GetChildren()) do
						if q.ClassName == "Decal" then
							q.Transparency = q.Transparency - 1/35
						end
					end
				end
			end
		end
		UNANCHOR = false
		RootPart.Anchored = true
		CLOAKING = true
		coroutine.resume(coroutine.create(function()
			for i = 1, 15 do
				Swait()
				for _, q in pairs(FAKESHADOW:GetChildren()) do
					if q.ClassName == "Part" then
						q.Transparency = q.Transparency - 1/15
					end
				end
			end
		end))
		for i=0, 0.2, 0.1 / Animation_Speed do
			Swait()
			RootPart.Anchored = true
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, -2*SIZE) * ANGLES(RAD(10), RAD(0), RAD(0)), 0.3 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		LOOP = CreateSound(487214658, TORS, 0, 1, true)
		for i=0, 0.6, 0.1 / Animation_Speed do
			Swait()
			RootPart.Anchored = true
			UNCLOAKED = false
			if LOOP then
				LOOP.Volume = LOOP.Volume + 0.1
			end
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, -7*SIZE) * ANGLES(RAD(90), RAD(0), RAD(0)), 0.3 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		for _, c in pairs(Character:GetChildren()) do
			if c.ClassName == "Part" then
				c.Transparency = 1
				for _, q in pairs(c:GetChildren()) do
					if q.ClassName == "Decal" then
						q.Transparency = 1
					end
				end
			end
		end
		MOUSEHIT = Mouse.Button1Down:connect(function(NEWKEY)
			local HITFLOOR,HITPOS = Raycast(RootPart.Position-VT(0,2.1*SIZE,0), (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*SIZE, Character)
			if HITFLOOR then
				local POS = HITPOS
				local WORKING = true
				coroutine.resume(coroutine.create(function()
					repeat
						Swait()
						WACKYEFFECT({Time = 25, EffectType = "Sphere", Size = VT(10,0.2,10), Size2 = VT(0,0.5,0), Transparency = 1, Transparency2 = 0, CFrame = CF(POS), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = MRANDOM(7,15)/10, SoundVolume = MRANDOM(15,30)/10})
					until WORKING == false
				end))
				wait(0.3)
				local SPIKE = CreatePart(3, Effects, "Fabric", 0, 0, "Maroon", "Spike", VT(2,32,2))
				SPIKE.Color = C3(0,0,0)
				local MSH = IT("SpecialMesh",SPIKE)
				MSH.MeshType = "FileMesh"
				MSH.MeshId = "http://www.roblox.com/asset/?id=785967755"
				MSH.Scale = SPIKE.Size/50
				SPIKE.CFrame = CF(POS+VT(0,15,0))
				ApplyAoE(SPIKE.Position,15,35,55,35,false)
				WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0,5,0), Size2 = VT(5,1,5), Transparency = 0, Transparency2 = 1, CFrame = CF(POS), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = 178452241, SoundPitch = MRANDOM(7,15)/10, SoundVolume = MRANDOM(15,30)/10})
				wait(0.2)
				for i = 1, 16 do
					Swait()
					SPIKE.CFrame = SPIKE.CFrame*CF(0,-2,0)
				end
				SPIKE:remove()
				WORKING = false
			end
		end)
		Mouse.KeyDown:connect(function(NEWKEY)
			if NEWKEY == "b" and BUSY == false then
				BUSY = true
				if MOUSEHIT then
					MOUSEHIT:disconnect()
				end
				for _, c in pairs(Character:GetChildren()) do
					if c.ClassName == "Part" and c ~= RootPart then
						c.Transparency = 0
						for _, q in pairs(c:GetChildren()) do
							if q.ClassName == "Decal" then
								q.Transparency = 0
							end
						end
					end
				end
				for i=0, 1.5, 0.1 / Animation_Speed do
					Swait()
					RootPart.Anchored = true
					UNCLOAKED = false
					RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.3 / Animation_Speed)
					Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
					RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
					LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
					RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
					LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
				end
				coroutine.resume(coroutine.create(function()
					for i = 1, 15 do
						Swait()
						for _, q in pairs(FAKESHADOW:GetChildren()) do
							if q.ClassName == "Part" then
								q.Transparency = q.Transparency + 1/15
							end
						end
					end
					FAKESHADOW:remove()
					FAKESHADOW = nil
				end))
				for i=0, 0.5, 0.1 / Animation_Speed do
					Swait()
					RootPart.Anchored = true
					UNCLOAKED = true
					LOOP.Pitch = LOOP.Pitch - 0.2
					RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.3 / Animation_Speed)
					Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
					RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
					LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(-15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
					RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
					LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
				end
				LOOP:remove()
				LOOP = nil
				for i = 1, 35 do
					Swait()
					for _, c in pairs(Character:GetChildren()) do
						if c.ClassName == "Part" then
							for _, q in pairs(c:GetChildren()) do
								if q.ClassName == "Decal" then
									q.Transparency = q.Transparency + 1/35
								end
							end
						end
					end
				end
				UNANCHOR = true
				ATTACK = false
				Rooted = false
			elseif NEWKEY == "w" and BUSY == false then
				repeat
					Swait()
					local HITFLOOR = Raycast(CF(RootPart.CFrame*CF(0,-2.1*SIZE,0).p,VT(Mouse.Hit.p.X,RootPart.Position.Y,Mouse.Hit.p.Z))*CF(0,0,-3).p, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 5*SIZE, Character)
					local FLOOR,HITPOS = Raycast(RootPart.Position-VT(0,-2.1*SIZE,0), (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 5*SIZE, Character)
					if HITFLOOR then
						WACKYEFFECT({Time = 35, EffectType = "Sphere", Size = VT(4,0.2,4), Size2 = VT(2,0.5,2), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = MRANDOM(7,15)/10, SoundVolume = MRANDOM(15,30)/10})
						RootPart.CFrame = CF(RootPart.Position,VT(Mouse.Hit.p.X,RootPart.Position.Y,Mouse.Hit.p.Z))*CF(0,0,-1)
					end
				until KEYHOLD == false or BUSY == true
			end
		end)
	end
end

function PillarOfDespair()
	ATTACK = true
	Rooted = true
	CreateSound(VOCALS_BASIC[MRANDOM(1,#VOCALS_BASIC)], Head, MRANDOM(9,11)/2.5, MRANDOM(9,11)/10, false)
	FORCEIDLE = true
	for i = 1, 5 do
		Swait()
		for _, c in pairs(Character:GetChildren()) do
			if c.ClassName == "Part" then
				for _, q in pairs(c:GetChildren()) do
					if q.ClassName == "Decal" then
						q.Transparency = q.Transparency - 1/5
					end
				end
			end
		end
	end
	local ORIGINPOS = RootPart.Position
	CreateSound(1447872444, Torso, 10, 1.2, false)
	for c = 1, #RINGFIRE do
		RINGFIRE[c].Enabled = false
	end
	for i = 1, 25 do
		Swait()
		coroutine.resume(coroutine.create(function()
			local POS = RootPart.Position
			WACKYEFFECT({Time = 15, EffectType = "Sphere", Size = VT(0,50,0), Size2 = VT(15+i,45,15+i), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position-VT(0,2.2*SIZE,0)), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = nil, SoundVolume = nil})
			WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0,25,0), Size2 = VT(25+i,0,25+i), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position-VT(0,2.2*SIZE,0)), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = nil, SoundVolume = nil})
			wait(0.3)
			ApplyAoE(POS,25+i,15,25,25,false)
		end))
		RootPart.CFrame = RootPart.CFrame*CF(0,0,5)
	end
	for c = 1, #RINGFIRE do
		RINGFIRE[c].Enabled = true
	end
	FORCEIDLE = false
	local BUILDUP = true
	coroutine.resume(coroutine.create(function()
		for i = 1, 35 do
			Swait()
			for _, c in pairs(Character:GetChildren()) do
				if c.ClassName == "Part" then
					for _, q in pairs(c:GetChildren()) do
						if q.ClassName == "Decal" then
							q.Transparency = q.Transparency + 1/35
						end
					end
				end
			end
		end
	end))
	coroutine.resume(coroutine.create(function()
		repeat
			Swait()
			if ATTACK == false then
				break
			end
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 0.2 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 0.2 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 0.2 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 0.2 / Animation_Speed)
		until BUILDUP == false
		repeat
			Swait()
			if ATTACK == false then
				break
			end
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(43 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-42 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		until ATTACK == false
	end))
	wait(0.5)
	BUILDUP = false
	coroutine.resume(coroutine.create(function()
		WACKYEFFECT({Time = 50, EffectType = "Sphere", Size = VT(15,15,15), Size2 = VT(0,0,0), Transparency = 1, Transparency2 = 0, CFrame = CF(ORIGINPOS), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = CHARGE, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/1.2})
		for i = 1, 5 do
			WACKYEFFECT({Time = 55, EffectType = "Wave", Size = VT(25,2,25), Size2 = VT(0,0,0), Transparency = 1, Transparency2 = 0.7, CFrame = CF(ORIGINPOS) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360))), MoveToPos = nil, RotationX = 1, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
		end
		wait(1.3)
		for i = 1, 6 do
			WACKYEFFECT({Time = 60, EffectType = "Sphere", Size = VT(25,25,25), Size2 = VT(85+(i*3),85+(i*3),85+(i*3)), Transparency = 0, Transparency2 = 1, CFrame = CF(ORIGINPOS-VT(0,2,0)) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)))*CF(0,25,0), MoveToPos = nil, RotationX = 0, RotationY = MRANDOM(-15,15), RotationZ = 0, Material = "Neon", Color = C3(i/120,0,0), SoundID = ROUGHBLAST, SoundPitch = MRANDOM(9,11)/10, SoundVolume = 10})
		end
		for i = 1, 25 do
			WACKYEFFECT({Time = 55, EffectType = "Wave", Size = VT(0,0,0), Size2 = VT(325,1,325), Transparency = 0.8, Transparency2 = 1, CFrame = CF(ORIGINPOS-VT(0,2,0)) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360))), MoveToPos = nil, RotationX = 1, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
		end
		ApplyAoE(ORIGINPOS,85,35,85,125,false)
	end))
	wait(0.4)
	ATTACK = false
	Rooted = false
end

function InfernoWall()
	CreateSound(VOCALS_BASIC[MRANDOM(1,#VOCALS_BASIC)], Head, MRANDOM(9,11)/1.5, MRANDOM(9,11)/10, false)
	ATTACK = true
	Rooted = true
	local BUILDUP = true
	local WALL = IT("Model",Effects)
	WALL.Name = "Wall of Fire"
	local BASE = CreatePart(3, WALL, "Fabric", 0, 1, "Maroon", "FirePart", VT(0,0,0))
	BASE.CFrame = RootPart.CFrame*CF(0,-2.8*SIZE,8)
	local FIRES = {}
	local BODIES = {}
	local REPEATREMOVE = true
	WALL.PrimaryPart = BASE
	coroutine.resume(coroutine.create(function()
		repeat
			Swait()
			if ATTACK == false then
				break
			end
			turnto(Mouse.Hit.p)
			WALL:SetPrimaryPartCFrame(RootPart.CFrame*CF(0,-2.8*SIZE,8))
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 0.2 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 0.2 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 0.2 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 0.2 / Animation_Speed)
		until BUILDUP == false
		repeat
			Swait()
			if ATTACK == false then
				break
			end
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(43 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-42 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		until ATTACK == false
	end))
	CreateSound(278641993, BASE, 10, 0.8, false)
	coroutine.resume(coroutine.create(function()
		for i = 1, 45 do
			Swait()
			local PART = CreatePart(3, WALL, "Fabric", 0, 1, "Maroon", "FirePart", VT(2,0,2))
			PART.CFrame = BASE.CFrame * ANGLES(RAD(0), RAD(90+i), RAD(0))*CF(32,0,0)
			local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 0.2, Acel = VT(0,28+(i/5),6), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 3, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 2+(i/25), Parent = PART, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(0,0,0), Color2 = C3(0.5,0,0), Texture = "1523916715"})
			PRTCL.LockedToPart = true
			PRTCL.Rate = 35
			table.insert(FIRES,PRTCL)
		end
	end))
	coroutine.resume(coroutine.create(function()
		for i = 1, 45 do
			Swait()
			local PART = CreatePart(3, WALL, "Fabric", 0, 1, "Maroon", "FirePart", VT(2,0,2))
			PART.CFrame = BASE.CFrame * ANGLES(RAD(0), RAD(-90-i), RAD(0))*CF(-32,0,0)
			local PRTCL = ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 0.2, Acel = VT(0,28+(i/5),6), RotSpeed = NumberRange.new(-15, 15), Drag = 0, Size1 = 3, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 2+(i/25), Parent = PART, Emit = 100, Offset = 360, Enabled = true, Color1 = C3(0,0,0), Color2 = C3(0.5,0,0), Texture = "1523916715"})
			PRTCL.LockedToPart = true
			PRTCL.Rate = 35
			table.insert(FIRES,PRTCL)
		end
	end))
	repeat wait() until #WALL:GetChildren() == 91
	wait(0.3)
	BUILDUP = false
	coroutine.resume(coroutine.create(function()
		coroutine.resume(coroutine.create(function()
			repeat
				wait(1)
				for e = 1, #BODIES do
					if BODIES[e] ~= nil and REPEATREMOVE == true then
						local BOD = BODIES[e]
						local TORSO = BOD:FindFirstChild("Torso") or BOD:FindFirstChild("UpperTorso")
						if TORSO then
						local HITFLOOR,HITPOS = Raycast(TORSO.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*(TORSO.Size.Y/2), workspace)
							WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(5,0,5), Size2 = VT(5,5,5), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = MRANDOM(-35,35), RotationZ = 0, Material = "Neon", Color = C3(0.2,0,0), SoundID = nil, SoundPitch = MRANDOM(7,15)/10, SoundVolume = MRANDOM(15,30)/10})
						end
						for i = 1, 10 do
							for i = 1, #BODIES do
								if (BODIES[i] == BOD and i ~= e) then
									table.remove(BODIES,i)
								end
							end
						end
					end
				end
			until REPEATREMOVE == false
		end))
		CreateSound(WALLSOUND, BASE, 10, 0.8, false)
		for i = 1, 70 do
			Swait()
			AddChildrenToTable(BASE.Position,workspace,32,BODIES)
			WALL:SetPrimaryPartCFrame(BASE.CFrame*CF(0,0,-4))
		end
		for i = 1, #FIRES do
			FIRES[i].Enabled = false
		end
		Debris:AddItem(WALL,5)
		wait(1)
		REPEATREMOVE = false
		for e = 1, #BODIES do
			if BODIES[e] ~= nil then
				Swait()
				local BOD = BODIES[e]
				local TORSO = BOD:FindFirstChild("Torso") or BOD:FindFirstChild("UpperTorso")
				if TORSO then
					local HUM = BOD:FindFirstChildOfClass("Humanoid")
					if HUM then
						if HUM.Health > 0 then
							local HITFLOOR,HITPOS = Raycast(TORSO.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*(TORSO.Size.Y/2), BOD)
							if HITFLOOR then
								ApplyDamage(HUM,MRANDOM(0,0),TORSO)
								CreateSound(ROUGHBLAST, TORSO, 10, 1.2, false)
								ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 3, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 0.7, Parent = TORSO, Emit = 300, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0.5,0,0), Texture = "1523916715"})
							end
						end
					end
				end
			end
		end
	end))
	wait(1)
	ATTACK = false
	Rooted = false
end

function FormerShadow()
	CreateSound(VOCALS_BASIC[MRANDOM(1,#VOCALS_BASIC)], Head, MRANDOM(9,11)/1.5, MRANDOM(9,11)/10, false)
	XATTACK = true
	ATTACK = true
	Rooted = true
	local BODIES = {}
	local SHADOWS = {}
	local BUILDUP = true
	local DONE = false
	coroutine.resume(coroutine.create(function()
		repeat
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(15)) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(-10), RAD(0), RAD(-15)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.15*SIZE, 0.65*SIZE, -0.75*SIZE) * ANGLES(RAD(15), RAD(0), RAD(-90)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.15*SIZE, 0.1*SIZE, -0.75*SIZE) * ANGLES(RAD(-15), RAD(0), RAD(90)) * ANGLES(RAD(25), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(20), RAD(55), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(10), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		until DONE == true
	end))
	local MOUSEHIT = Mouse.Button1Down:connect(function(NEWKEY)
		if Mouse.Target.Parent ~= Character and Mouse.Target.Parent.Parent ~= Character and Mouse.Target.Parent:FindFirstChildOfClass("Humanoid") ~= nil then
			local HUM = Mouse.Target.Parent:FindFirstChildOfClass("Humanoid")
			local TORSO = HUM.Parent:FindFirstChild("Torso") or HUM.Parent:FindFirstChild("UpperTorso")
			if TORSO and HUM then
				local PASS = true
				for e = 1, #BODIES do
					if BODIES[e] ~= nil then
						if BODIES[e] == Mouse.Target.Parent then
							PASS = false
						end
					end
				end
				if PASS == true then
					table.insert(BODIES,Mouse.Target.Parent)
				end
			end
		end
	end)
	local KEYDOWN = Mouse.KeyDown:connect(function(NEWKEY)
		if NEWKEY == "x" then
			DONE = true
		end
	end)
	repeat wait() until DONE == true or #BODIES == 3
	DONE = true
	MOUSEHIT:disconnect()
	KEYDOWN:disconnect()
	if #BODIES > 0 then
		coroutine.resume(coroutine.create(function()
			repeat
				Swait()
				if ATTACK == false then
					break
				end
				ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = RightArm, Emit = 25, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = LeftArm, Emit = 25, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = RightLeg, Emit = 25, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = LeftLeg, Emit = 25, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = Torso, Emit = 25, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 1, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = Head, Emit = 25, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*SIZE, Character)
				WACKYEFFECT({Time = 35, EffectType = "Wave", Size = VT(0,2,0), Size2 = VT(35,12,35), Transparency = 0.2, Transparency2 = 1, CFrame = CF(HITPOS) * ANGLES(RAD(MRANDOM(-15,15)), RAD(MRANDOM(0,360)), RAD(MRANDOM(-15,15))), MoveToPos = nil, RotationX = 0, RotationY = MRANDOM(-15,15), RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
				RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-15 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(15 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			until BUILDUP == false
		end))
		CreateSound(WALLSOUND, Torso, 10, 0.8, false)
		CreateSound(ROUGHBLAST, Torso, 10, 0.8, false)
		for i = 1, #BODIES do
			if BODIES[i] ~= nil then
				local TORSO = BODIES[i]:FindFirstChild("HumanoidRootPart") or BODIES[i]:FindFirstChild("Torso") or BODIES[i]:FindFirstChild("UpperTorso")
				if TORSO then
					CreateSound(WALLSOUND, TORSO, 10, 1, false)
					ParticleEmitter({Transparency1 = 1, Transparency2 = 0, Speed = 5, Acel = VT(0,12,0), RotSpeed = NumberRange.new(-150, 150), Drag = 0, Size1 = 3, Size2 = 0, Lifetime1 = 0.4, Lifetime2 = 1, Parent = TORSO, Emit = 300, Offset = 360, Enabled = false, Color1 = C3(0,0,0), Color2 = C3(0,0,0), Texture = "1523916715"})
				end
			end
		end
		wait(1)
		local SHADOWFADE = false
		for i = 1, #BODIES do
			if BODIES[i] ~= nil then
				local TORSO = BODIES[i]:FindFirstChild("HumanoidRootPart") or BODIES[i]:FindFirstChild("Torso") or BODIES[i]:FindFirstChild("UpperTorso")
				if TORSO then
					local SHADOW = CLONE:Clone()
					SHADOW.Parent = Effects
					SHADOW.HumanoidRootPart.CFrame = TORSO.CFrame*CF(0,6,0)
					--SHADOW.HumanoidRootPart.CFrame = RootPart.CFrame * ANGLES(RAD(0), RAD((360/#SHADOWS)*i), RAD(0))*CF(0,0,15)
					SHADOW.Humanoid.WalkSpeed = 35
					SHADOW.Humanoid.Health = 1
					SHADOW.Humanoid.MaxHealth = 1
					SHADOW.Name = BODIES[i].Name
					for i = 1, 3 do
						for _, c in pairs(SHADOW:GetChildren()) do
							if c.ClassName == "Part" then
								c.Material = "Neon"
								c.Color = C3(0,0,0)
								c.Transparency = 1
								if c.Name == "Head" then
									c:ClearAllChildren()
									local MSH = IT("BlockMesh",c)
									MSH.Scale = VT(0.5,1,1)
								end
							elseif c.ClassName ~= "Part" and c.ClassName ~= "Humanoid" and c.Name ~= "Animate" then
								c:remove()
							end
						end
					end
					local BODY = IT("ObjectValue",SHADOW)
					BODY.Name = "RealBody"
					BODY.Value = BODIES[i]
					table.insert(SHADOWS,SHADOW)
				end
			end
		end
		coroutine.resume(coroutine.create(function()
			local LOOP = 0
			for i = 1, 25 do
				Swait()
				for i = 1, #SHADOWS do
					if SHADOWS[i] ~= nil then
						for _, c in pairs(SHADOWS[i]:GetChildren()) do
							if c.ClassName == "Part" and c.Name ~= "HumanoidRootPart" then
								c.Color = C3(0,0,0)
								c.Transparency = c.Transparency - 1/25
							end
						end
					end
				end
			end
			local KEYDOWN = Mouse.KeyDown:connect(function(NEWKEY)
				if NEWKEY == "x" then
					SHADOWFADE = true
				end
			end)
			repeat
				LOOP = LOOP + 2
				local JUMPIES = {}
				for i = 1, #SHADOWS do
					if SHADOWS[i] ~= nil then
						SHADOWS[i].Humanoid:MoveTo(CF(RootPart.Position) * ANGLES(RAD(0), RAD(((360/#SHADOWS)*i)+LOOP), RAD(0))*CF(0,0,25).p)
						local BODY = SHADOWS[i].RealBody.Value
						if BODY then
							local HUM = BODY:FindFirstChildOfClass("Humanoid")
							if HUM then
								local TRIGGER = HUM.Changed:connect(function(Jump)
									if HUM.Jump == true then
										SHADOWS[i].Humanoid.JumpPower = HUM.JumpPower
										SHADOWS[i].Humanoid.Jump = true
									end
								end)
								table.insert(JUMPIES,TRIGGER)
								if HUM.Health == 0 then
									SHADOWS[i].Humanoid.Health = 0
								end
							end
						end
						if SHADOWS[i].Humanoid.Health == 0 then
							if BODY then
								BODY:BreakJoints()
							end
							SHADOWS[i]:remove()
							table.remove(SHADOWS,i)
						end
					end
				end
				Swait()
				for i = 1, #JUMPIES do
					if JUMPIES[i] ~= nil then
						JUMPIES[i]:disconnect()
					end
				end
			until SHADOWFADE == true or #SHADOWS == 0
			KEYDOWN:disconnect()
			if #SHADOWS > 0 then
				for i = 1, 45 do
					Swait()
					for i = 1, #SHADOWS do
						if SHADOWS[i] ~= nil then
							for _, c in pairs(SHADOWS[i]:GetChildren()) do
								if c.ClassName == "Part" then
									c.Transparency = c.Transparency + 1/45
								end
							end
							SHADOWS[i].Humanoid.WalkSpeed = 12
							SHADOWS[i].Humanoid:MoveTo(CF(RootPart.Position,SHADOWS[i].HumanoidRootPart.Position+VT(0,2,0))*CF(0,0,-5).p)
						end
					end
				end
				for i = 1, #SHADOWS do
					if SHADOWS[i] ~= nil then
						SHADOWS[i]:remove()
					end
				end
			end
			XATTACK = false
		end))
	else
		XATTACK = false
	end
	ATTACK = false
	Rooted = false
end

function Taunt()
	ATTACK = true
	Rooted = true
	local VIOLENCE = 1
	FORCEIDLE = true
	repeat Swait() VIOLENCE = VIOLENCE + 1 until KEYHOLD == false
	FORCEIDLE = false
	if VIOLENCE <= 10 then
		for i=0, 0.2, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(15)) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(-10), RAD(0), RAD(-15)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.15*SIZE, 0.65*SIZE, -0.75*SIZE) * ANGLES(RAD(15), RAD(0), RAD(-90)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.15*SIZE, 0.1*SIZE, -0.75*SIZE) * ANGLES(RAD(-15), RAD(0), RAD(90)) * ANGLES(RAD(25), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(20), RAD(55), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(10), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		local TAUNT = CreateSound(VOCALS_TAUNT[MRANDOM(1,#VOCALS_TAUNT)], Head, 10, 1, false)
		repeat
			Swait()
			TAUNT.Parent = Head
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(15)) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(-10-(TAUNT.PlaybackLoudness/55)), RAD(0), RAD(-15)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.15*SIZE, 0.65*SIZE, -0.75*SIZE) * ANGLES(RAD(15), RAD(0), RAD(-90)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.15*SIZE, 0.1*SIZE, -0.75*SIZE) * ANGLES(RAD(-15), RAD(0), RAD(90)) * ANGLES(RAD(25), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(20), RAD(55), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(10), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		until TAUNT.Playing == false
	else
		for i=0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(22)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(135), RAD(0), RAD(-22)) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE, -0.01*SIZE) * ANGLES(RAD(0), RAD(75), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE, -0.01*SIZE) * ANGLES(RAD(0), RAD(-75), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		end
		local TAUNT = CreateSound(VOCALS_ENRAGES[MRANDOM(1,#VOCALS_ENRAGES)], Head, 10, 1, false)
		repeat Swait() until TAUNT.TimeLength > 0
		repeat
			Swait()
			ApplyAoE(Head.Position,15,0,0,200,false)
			local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*SIZE, Character)
			WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0,2,0), Size2 = VT(15,0,15), Transparency = 1-(TAUNT.PlaybackLoudness/1250), Transparency2 = 1, CFrame = CF(Head.Position) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360))), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(1,1,1), SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
			WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0,2,0), Size2 = VT(35,0,35), Transparency = 0.2, Transparency2 = 1, CFrame = CF(HITPOS) * ANGLES(RAD(0), RAD(MRANDOM(0,360)), RAD(0)), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(1,1,1), SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
			TAUNT.Parent = Head
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, -0.2*SIZE, -0.1*SIZE) * ANGLES(RAD(35), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(-25+MRANDOM(-(TAUNT.PlaybackLoudness/25),(TAUNT.PlaybackLoudness/25))), RAD(MRANDOM(-(TAUNT.PlaybackLoudness/15),(TAUNT.PlaybackLoudness/15))), RAD(MRANDOM(-(TAUNT.PlaybackLoudness/25),(TAUNT.PlaybackLoudness/25)))), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.5*SIZE, 0.1*SIZE) * ANGLES(RAD(-35), RAD(0), RAD(42)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.5*SIZE, 0.1*SIZE) * ANGLES(RAD(-35), RAD(0), RAD(-42)) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE, -0.01*SIZE) * ANGLES(RAD(25), RAD(75), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE, -0.01*SIZE) * ANGLES(RAD(45), RAD(-75), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 1 / Animation_Speed)
		until TAUNT.TimePosition > TAUNT.TimeLength - 2
	end
	ATTACK = false
	Rooted = false
end

--//=================================\\
--||	  ASSIGN THINGS TO KEYS
--\\=================================//

function MouseDown(Mouse)
	if ATTACK == false then
	end
end

function MouseUp(Mouse)
HOLD = false
end

function KeyDown(Key)
	KEYHOLD = true
	if Key == "no" and ATTACK == false then
		Taunt()
	end

	if Key == "z" and ATTACK == false then
		MissilesOfDespair()
	end

	if Key == "b" and ATTACK == false and XATTACK == false then
		ShadowRoam()
	end

	if Key == "c" and ATTACK == false then
		PillarOfDespair()
	end

	if Key == "v" and ATTACK == false then
		InfernoWall()
	end

	if Key == "x" and ATTACK == false and XATTACK == false then
		FormerShadow()
	end
end

function KeyUp(Key)
	KEYHOLD = false
end

	Mouse.Button1Down:connect(function(NEWKEY)
		MouseDown(NEWKEY)
	end)
	Mouse.Button1Up:connect(function(NEWKEY)
		MouseUp(NEWKEY)
	end)
	Mouse.KeyDown:connect(function(NEWKEY)
		KeyDown(NEWKEY)
	end)
	Mouse.KeyUp:connect(function(NEWKEY)
		KeyUp(NEWKEY)
	end)

--//=================================\\
--\\=================================//

function unanchor()
	if UNANCHOR == true then
		RootPart.Anchored = false
	end
	g = Character:GetChildren()
	for i = 1, #g do
		if g[i].ClassName == "Part" and g[i] ~= RootPart then
			g[i].Anchored = false
		end
	end
	g = Weapon:GetChildren()
	for i = 1, #g do
		if g[i].ClassName == "Part" then
			g[i].Anchored = false
		end
	end
end


--//=================================\\
--||	WRAP THE WHOLE SCRIPT UP
--\\=================================//

Humanoid.Changed:connect(function(Jump)
	if Jump == "Jump" and (Disable_Jump == true) then
		Humanoid.Jump = false
	end
end)

while true do
	Swait()
	script.Parent = WEAPONGUI
	ANIMATE.Parent = nil
	for _,v in next, Humanoid:GetPlayingAnimationTracks() do
	    v:Stop();
	end
	SINE = SINE + CHANGE
	local TORSOVELOCITY = (RootPart.Velocity * VT(1, 0, 1)).magnitude
	local TORSOVERTICALVELOCITY = RootPart.Velocity.y
	local HITFLOOR = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*SIZE, Character)
	local FLOOR1,HITPOS,NORMAL = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 8*SIZE, Character)
	local FLOOR2,HITPOS2 = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 8*SIZE, Character)
	local WALKSPEEDVALUE = 8 / (Humanoid.WalkSpeed / 16)
	if ANIM == "Walk" and TORSOVELOCITY > 1 then
		RootJoint.C1 = Clerp(RootJoint.C1, ROOTC0 * CF(0, 0, -0.15 * COS(SINE / (WALKSPEEDVALUE / 2))) * ANGLES(RAD(0), RAD(0) - RootPart.RotVelocity.Y / 75, RAD(0)), 2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
		Neck.C1 = Clerp(Neck.C1, CF(0, -0.5, 0) * ANGLES(RAD(-90), RAD(0), RAD(180)) * ANGLES(RAD(2.5 * SIN(SINE / (WALKSPEEDVALUE / 2))), RAD(0), RAD(0) - Head.RotVelocity.Y / 30), 0.2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
		RightHip.C1 = Clerp(RightHip.C1, CF(0.5*SIZE, 0.875*SIZE - 0.125 * SIN(SINE / WALKSPEEDVALUE)*SIZE - 0.15 * COS(SINE / WALKSPEEDVALUE*2), -0.125 * COS(SINE / WALKSPEEDVALUE) +0.7+ 0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0) - RightLeg.RotVelocity.Y / 75, RAD(0), RAD(76 * COS(SINE / WALKSPEEDVALUE))), 0.2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
		LeftHip.C1 = Clerp(LeftHip.C1, CF(-0.5*SIZE, 0.875*SIZE + 0.125 * SIN(SINE / WALKSPEEDVALUE)*SIZE - 0.15 * COS(SINE / WALKSPEEDVALUE*2), 0.125 * COS(SINE / WALKSPEEDVALUE) +0.7+ -0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0) + LeftLeg.RotVelocity.Y / 75, RAD(0), RAD(76 * COS(SINE / WALKSPEEDVALUE))), 0.2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
	elseif (ANIM ~= "Walk") or (TORSOVELOCITY < 1) then
		RootJoint.C1 = Clerp(RootJoint.C1, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
		Neck.C1 = Clerp(Neck.C1, CF(0, -0.5, 0) * ANGLES(RAD(-90), RAD(0), RAD(180)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightHip.C1 = Clerp(RightHip.C1, CF(0.5*SIZE, 1*SIZE, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		LeftHip.C1 = Clerp(LeftHip.C1, CF(-0.5*SIZE, 1*SIZE, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
	end
	if TORSOVERTICALVELOCITY > 1 and HITFLOOR == nil and FORCEIDLE == false then
		ANIM = "Jump"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0*SIZE, 0*SIZE, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(-20), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.55*SIZE, 0*SIZE) * ANGLES(RAD(15), RAD(0), RAD(12)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.55*SIZE, 0*SIZE) * ANGLES(RAD(15), RAD(0), RAD(-12)) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -0.3*SIZE, -0.5*SIZE) * ANGLES(RAD(15), RAD(90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(-20)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE, -0.1*SIZE) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(20)), 1 / Animation_Speed)
	    end
	elseif TORSOVERTICALVELOCITY < -1 and HITFLOOR == nil and FORCEIDLE == false then
		ANIM = "Fall"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0*SIZE, 0*SIZE, 0*SIZE) * ANGLES(RAD(-25), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0*SIZE, 0*SIZE, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(20), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(35), RAD(0), RAD(42)) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(35), RAD(0), RAD(-42)) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -0.5*SIZE, -0.5*SIZE) * ANGLES(RAD(15), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(20)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE, 0*SIZE) * ANGLES(RAD(-25), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(10)), 1 / Animation_Speed)
		end
	elseif (TORSOVELOCITY < 1 and HITFLOOR ~= nil) or FORCEIDLE == true then
		ANIM = "Idle"
		if ATTACK == false or FORCEIDLE == true then
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(15)) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(-15)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(45), RAD(0), RAD(52 - 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(35), RAD(0), RAD(-42 + 3 * COS(SINE / 12))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1.02*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(20), RAD(55), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(10), RAD(-74), RAD(0)) * ANGLES(RAD(-3), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
	elseif TORSOVELOCITY > 1 and HITFLOOR ~= nil and FORCEIDLE == false then
		ANIM = "Walk"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0*SIZE, 0*SIZE, -0.1*SIZE) * ANGLES(RAD(15), RAD(0), RAD(-8*SIN(SINE/WALKSPEEDVALUE))), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1*SIZE) - 1)) * ANGLES(RAD(5), RAD(-2*SIN(SINE/WALKSPEEDVALUE)), RAD(8*SIN(SINE/WALKSPEEDVALUE))), 1/ Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.5*SIZE + 0.15 * COS(SINE/WALKSPEEDVALUE*2), 0.1*SIZE-0.3*SIN(SINE/WALKSPEEDVALUE)) * ANGLES(RAD(35), RAD(0), RAD(22 + 3* SIN(SINE/WALKSPEEDVALUE))) * ANGLES(RAD(0), RAD(-70), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.5*SIZE + 0.15 * COS(SINE/WALKSPEEDVALUE*2), 0.1*SIZE+0.3*SIN(SINE/WALKSPEEDVALUE)) * ANGLES(RAD(35), RAD(0), RAD(-22 - 3* SIN(SINE/WALKSPEEDVALUE))) * ANGLES(RAD(0), RAD(70), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE , -1*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(75), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(-15)), 2 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE, 0*SIZE) * ANGLES(RAD(0), RAD(-75), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(15)), 2 / Animation_Speed)
		end
	end
	unanchor()
	Humanoid.MaxHealth = "inf"
	Humanoid.Health = "inf"
	if Rooted == false then
		Disable_Jump = false
		Humanoid.WalkSpeed = Speed
	elseif Rooted == true then
		Disable_Jump = true
		Humanoid.WalkSpeed = 0
	end
	for _, c in pairs(Character:GetChildren()) do
		if c.ClassName == "Part" and c.Name ~= "Eye" then
			c.Material = "Granite"
			if c ~= Head and c ~= Torso and c ~= RightArm and c ~= LeftArm and c ~= RightLeg and c ~= LeftLeg then
				c.Color = C3(175/575, 148/675, 131/675)
			else
				c.Color = C3(0,0,0)
			end
			if c == Head then
				if c:FindFirstChild("face") then
					c.face:remove()
				end
			end
		elseif (c.ClassName == "CharacterMesh" or c.ClassName == "ShirtGraphic" or c.ClassName == "Accessory" or c.Name == "Body Colors") and c.Name ~= "Pressimus" then
			
		elseif (c.ClassName == "Shirt" or c.ClassName == "Pants") and c.Name ~= "Cloth" then
			c:remove()
		end
	end
	sick.Parent = Character
	sick.SoundId = "rbxassetid://9048378262"
	sick.Looped = true
	sick.Pitch = 0.95
	sick.Volume = 1
	sick.Playing = true
	if FLOOR1 ~= nil then
		FIRE:SetPrimaryPartCFrame(CF(HITPOS,HITPOS+NORMAL) * ANGLES(RAD(-90), RAD(0), RAD(0)))
	else
		FIRE:SetPrimaryPartCFrame(CF(HITPOS2))
	end
	SKILL1FRAME.Rotation = MRANDOM(-25,25)/2
	SKILL2FRAME.Rotation = MRANDOM(-25,25)/2
	SKILL3FRAME.Rotation = MRANDOM(-25,25)/2
	SKILL4FRAME.Rotation = MRANDOM(-25,25)/2
	SKILL5FRAME.Rotation = MRANDOM(-25,25)/2
	tecks2.Rotation = MRANDOM(-25,25)/8
	tecks.Rotation = MRANDOM(-25,25)/8
	Humanoid.Name = MRANDOM(1000000,99999999)
	FIRE.Parent = Weapon
	refit()
end

--//===============sound 9048378262==================\\
--\\=================================//





--//====================================================\\--
--||			  		 END OF SCRIPT
--\\====================================================//--
