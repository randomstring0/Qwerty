

local maxAmmo=50 --how much ammo u get when u reload (setting it to huge numbers isnt nice)
local shootingSpeed=1.3 --speed of the shooting animation
local equipKeybind=Enum.KeyCode.E --the key u press when u want to equip the gun
local reloadKeybind=Enum.KeyCode.R --the key u press when u want to reload
local crouchKeybind=Enum.KeyCode.C --the key u press to crouch
local reloadSpeed=0.8 --speed of the reload animation
local autoReload=true --automatically reloading when ur trying to shoot and ammo is 0
local turningSpeed=20 --how fast your character turns towards your mouse when your shooting
local recoilStuds=0.05 --by how many studs ur gonna move backwards when u shoot
local recoilVelocityXfrom=math.rad(25) --highest simulated camera X axis rotvelocity when u shoot
local recoilVelocityXto=math.rad(-5) --lowest simulated camera X axis rotvelocity when u shoot
local recoilXcatch=math.rad(220) --how fast ur X axis recoil velocity will go back to 0
local recoilVelocityYfrom=math.rad(15) --highest simulated camera Y axis rotvelocity when u shoot
local recoilVelocityYto=math.rad(-15) --lowest simulated camera Y axis rotvelocity when u shoot
local recoilYcatch=math.rad(200) --how fast ur Y axis recoil velocity will go back to 0
local normalWalkspeed=18 --walkspeed when the gun is not equipped
local equippedWalkspeed=16 --walkspeed when the gun is equipped
local crouchingWalkspeed=13 --walkspeed when ur crouching
local reloadWalkspeed=10 --walkspeed when reloading
local maxHealth=100 --client sided health bars max health
local healthRegenerationSpeed=1 --client sided health bars regeneration speed
local damageTable={ --table containing client sided damage values for each body part when its shot
	Head=35,
	Torso=17,
	HumanoidRootPart=17,
	UpperTorso=17,
	LowerTorso=17,
	["Left Arm"]=11,
	LeftUpperArm=11,
	LeftLowerArm=11,
	LeftHand=11,
	["Right Arm"]=11,
	RightUpperArm=11,
	RightLowerArm=11,
	["Left Leg"]=8,
	LeftUpperLeg=8,
	LeftLowerLeg=8,
	LeftFoot=8,
	["Right Leg"]=8,
	RightUpperLeg=8,
	RightLowerLeg=8,
	RightFoot=8
}
local flingrotvel=Vector3.new(15000,16000,15000) --rotation velocity of ur character while flinging

local animationWeight=5
local animationFadeTime=0.5

local abs=math.abs
local min=math.min
local max=math.max
local sin=math.sin
local rad=math.rad
local twait=task.wait
local clamp=math.clamp
local round=math.round
local osclock=os.clock
local tmove=table.move
local tfind=table.find
local schar=string.char
local tspawn=task.spawn
local mrandom=math.random
local tinsert=table.insert
local pi=math.pi
local pi2=pi/2
local pi3=pi/3
local pi23=pi3*2

local cf=CFrame.new
local cfl=CFrame.lookAt
local angles=CFrame.Angles
local cf_0=cf()
local Lerp=cf_0.Lerp
local v3=Vector3.new
local v3_0=v3()
local v3_010=v3(0,1,0)
local v3_101=v3(1,0,1)
local i=Instance.new
local e=Enum
local v2=Vector2.new
local c3=Color3.new
local u2=UDim2.new
local u1=UDim.new
local ns=NumberSequence.new
local nsk=NumberSequenceKeypoint.new
local f=Font.new
local cs=ColorSequence.new
local csk=ColorSequenceKeypoint.new

local mb1=e.UserInputType.MouseButton1
local mouseBehaviorLockCenter=e.MouseBehavior.LockCenter

local IsA=game.IsA
local GetChildren=game.GetChildren
local GetDescendants=game.GetDescendants
local IsDescendantOf=game.IsDescendantOf
local FindFirstChildOfClass=game.FindFirstChildOfClass

local plrs=FindFirstChildOfClass(game,"Players")
local ws=FindFirstChildOfClass(game,"Workspace")
local gs=FindFirstChildOfClass(game,"GuiService")
local rs=FindFirstChildOfClass(game,"RunService")
local uis=FindFirstChildOfClass(game,"UserInputService")

local stepped=rs.Stepped
local heartbeat=rs.Heartbeat
local renderstepped=rs.RenderStepped
local lp=plrs.LocalPlayer

local mouse=lp:GetMouse()
local IsKeyDown=uis.IsKeyDown
local Connect=heartbeat.Connect
local GetFocusedTextBox=uis.GetFocusedTextBox
local IsMouseButtonPressed=uis.IsMouseButtonPressed

local gp=function(p,n,cn)
	for i,v in next,GetChildren(p) do
		if IsA(v,cn) and (v.Name==n) then
			return v
		end
	end
	return nil
end

local c=lp.Character
if not c then
	return nil,"character not found"
end
local hum=FindFirstChildOfClass(c,"Humanoid")
if not hum then
	return nil,"humanoid not found"
end
if hum.RigType~=e.HumanoidRigType.R15 then
	return nil,"humanoid not r15"
end
local hrp=hum.RootPart or gp(c,"HumanoidRootPart","BasePart")
if not hrp then
	return nil,"no rootpart"
end
local head=gp(c,"Head","BasePart")
if not head then
	return nil,"head not found"
end
local upperTorso=gp(c,"UpperTorso","BasePart")
if not upperTorso then
	return nil,"uppertorso not found"
end

local cam=ws.CurrentCamera
Connect(ws:GetPropertyChangedSignal("CurrentCamera"),function()
	local newcam=ws.CurrentCamera
	if newcam then
		cam=newcam
	end
end)

local rs=function(l) 
	l=l or mrandom(8,15) 
	local s="" 
	for i=1,l do 
		if mrandom(1,2)==1 then 
			s=s..schar(mrandom(65,90)) 
		else 
			s=s..schar(mrandom(97,122)) 
		end 
	end 
	return s 
end

local LoadAnimation=hum.LoadAnimation
local loadAnimationTrack=function(id)
	local animation=i("Animation")
	animation.AnimationId="rbxassetid://"..id
	return LoadAnimation(hum,animation)
end

local animationLayers={}
local switchCurrentAnimation=function(layerId,id,speed)
	local layerTable=animationLayers[layerId]
	if not layerTable then
		layerTable={t={}}
		animationLayers[layerId]=layerTable
	end
	local lastAnimationId=layerTable.i
	local lastAnimationTrack=layerTable.a
	if id==lastAnimationId then
		return lastAnimationTrack
	end
	layerTable.i=id
	if lastAnimationTrack then
		lastAnimationTrack:Stop(animationFadeTime)
	end
	if not id then
		layerTable.a=nil
		return nil
	end
	local track=layerTable.t[id]
	if track then
		layerTable.a=track
		if track.IsPlaying then
			return track
		end
		track:Play(animationFadeTime,animationWeight,speed)
		return track
	end
	track=loadAnimationTrack(id)
	track.Looped=true
	layerTable.t[id]=track
	layerTable.a=track
	track:Play(animationFadeTime,animationWeight,speed)
	return track
end

local movementModel=i("Model")
if not hrp.Archivable then
	hrp.Archivable=true
end
local movementHrp=hrp:Clone()
movementHrp:ClearAllChildren()
movementHrp.Parent=movementModel
if not hum.Archivable then
	hum.Archivable=true
end
local movementHum=hum:Clone()
movementHum:ClearAllChildren()
movementHum.Parent=movementModel
movementModel.Parent=ws

local i1=i("ScreenGui")
local i2=i("TextButton")
local i3=i("UICorner")
local i4=i("TextLabel")
local i5=i("Frame")
local i6=i("Frame")
local i7=i("UIGradient")
local i8=i("UICorner")
local i9=i("TextLabel")
local i10=i("TextButton")
local i11=i("UICorner")
local i12=i("TextLabel")
local i13=i("Frame")
local i14=i("Frame")
local i15=i("UIGradient")
local i16=i("UICorner")
local i17=i("TextLabel")
local i18=i("Frame")
local i19=i("UICorner")
local i20=i("TextLabel")
local i21=i("Frame")
local i22=i("Frame")
local i23=i("Frame")
local i24=i("Frame")
local i25=i("Frame")
local i26=i("Frame")
local i27=i("TextButton")
local i28=i("UICorner")
local i29=i("TextLabel")
local i30=i("Frame")
local i31=i("Frame")
local i32=i("UIGradient")
local i33=i("UICorner")
local i34=i("TextLabel")
local i35=i("TextButton")
local i36=i("UICorner")
local i37=i("TextLabel")
local i38=i("Frame")
local i39=i("Frame")
local i40=i("UIGradient")
local i41=i("UICorner")
local i42=i("TextLabel")
local i43=i("Frame")
local i44=i("UICorner")
local i45=i("TextLabel")

i1.Name=rs()
i1.ResetOnSpawn=false
i1.ZIndexBehavior=e.ZIndexBehavior.Sibling
i1.DisplayOrder=2147483647
i1.IgnoreGuiInset=true
i2.Name=rs()
i2.AnchorPoint=v2(1,0.5)
i2.BackgroundColor3=c3(0,0,0)
i2.BackgroundTransparency=0.85
i2.BorderColor3=c3(0,0,0)
i2.BorderSizePixel=0
i2.Position=u2(0.98,0,0.535,0)
i2.Size=u2(0.18,0,0.06,0)
i2.SizeConstraint=e.SizeConstraint.RelativeYY
i2.Text=""
i2.TextTransparency=1
i3.Name=rs()
i3.CornerRadius=u1(0.2,0)
i4.Name=rs()
i4.AnchorPoint=v2(0.5,0.5)
i4.BackgroundColor3=c3(1,1,1)
i4.BackgroundTransparency=1
i4.BorderColor3=c3(0,0,0)
i4.BorderSizePixel=0
i4.Position=u2(0.6,0,0.5,0)
i4.Size=u2(1,0,0.5,0)
i4.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
i4.Text="Reload"
i4.TextColor3=c3(1,1,1)
i4.TextScaled=true
i4.TextSize=14
i5.Name=rs()
i5.BackgroundColor3=c3(1,1,1)
i5.BackgroundTransparency=1
i5.BorderColor3=c3(0,0,0)
i5.BorderSizePixel=0
i5.Size=u2(1,0,1,0)
i5.SizeConstraint=e.SizeConstraint.RelativeYY
i6.Name=rs()
i6.AnchorPoint=v2(0.5,0.5)
i6.BackgroundColor3=c3(1,1,1)
i6.BorderColor3=c3(0,0,0)
i6.BorderSizePixel=0
i6.Position=u2(0.5,0,0.5,0)
i6.Size=u2(0.7,0,0.7,0)
i6.SizeConstraint=e.SizeConstraint.RelativeYY
i7.Name=rs()
i7.Color=cs({[1]=csk(0,c3(1,1,1)),[2]=csk(1,c3(0.624,0.624,0.624))})
i7.Rotation=90
i8.Name=rs()
i8.CornerRadius=u1(0.3,0)
i9.Name=rs()
i9.AnchorPoint=v2(0.5,0.5)
i9.BackgroundColor3=c3(1,1,1)
i9.BackgroundTransparency=1
i9.BorderColor3=c3(0,0,0)
i9.BorderSizePixel=0
i9.Position=u2(0.5,0,0.5,0)
i9.Size=u2(0.6,0,0.6,0)
i9.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Bold,e.FontStyle.Normal)
i9.Text=reloadKeybind.Name
i9.TextColor3=c3(0.22,0.22,0.22)
i9.TextScaled=true
i9.TextSize=14
i10.Name=rs()
i10.BackgroundColor3=c3(0,0,0)
i10.BackgroundTransparency=0.85
i10.BorderColor3=c3(0,0,0)
i10.BorderSizePixel=0
i10.Position=u2(0.02,0,0.485,0)
i10.Size=u2(0.3,0,0.065,0)
i10.SizeConstraint=e.SizeConstraint.RelativeYY
i10.Text=""
i10.TextTransparency=1
i11.Name=rs()
i11.CornerRadius=u1(0.2,0)
i12.Name=rs()
i12.AnchorPoint=v2(0.5,0.5)
i12.BackgroundColor3=c3(1,1,1)
i12.BackgroundTransparency=1
i12.BorderColor3=c3(0,0,0)
i12.BorderSizePixel=0
i12.Position=u2(0.6,0,0.5,0)
i12.Size=u2(1,0,0.5,0)
i12.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
i12.TextColor3=c3(1,1,1)
i12.TextScaled=true
i12.TextSize=14
i13.Name=rs()
i13.BackgroundColor3=c3(1,1,1)
i13.BackgroundTransparency=1
i13.BorderColor3=c3(0,0,0)
i13.BorderSizePixel=0
i13.Size=u2(1,0,1,0)
i13.SizeConstraint=e.SizeConstraint.RelativeYY
i14.Name=rs()
i14.AnchorPoint=v2(0.5,0.5)
i14.BackgroundColor3=c3(1,1,1)
i14.BorderColor3=c3(0,0,0)
i14.BorderSizePixel=0
i14.Position=u2(0.5,0,0.5,0)
i14.Size=u2(0.7,0,0.7,0)
i14.SizeConstraint=e.SizeConstraint.RelativeYY
i15.Name=rs()
i15.Color=cs({[1]=csk(0,c3(1,1,1)),[2]=csk(1,c3(0.624,0.624,0.624))})
i15.Rotation=90
i16.Name=rs()
i16.CornerRadius=u1(0.25,0)
i17.Name=rs()
i17.AnchorPoint=v2(0.5,0.5)
i17.BackgroundColor3=c3(1,1,1)
i17.BackgroundTransparency=1
i17.BorderColor3=c3(0,0,0)
i17.BorderSizePixel=0
i17.Position=u2(0.5,0,0.5,0)
i17.Size=u2(0.6,0,0.6,0)
i17.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Bold,e.FontStyle.Normal)
i17.Text=equipKeybind.Name
i17.TextColor3=c3(0.22,0.22,0.22)
i17.TextScaled=true
i17.TextSize=14
i18.Name=rs()
i18.AnchorPoint=v2(1,0.5)
i18.BackgroundColor3=c3(0,0,0)
i18.BackgroundTransparency=0.85
i18.BorderColor3=c3(0,0,0)
i18.BorderSizePixel=0
i18.Position=u2(0.98,0,0.605,0)
i18.Size=u2(0.18,0,0.06,0)
i18.SizeConstraint=e.SizeConstraint.RelativeYY
i19.Name=rs()
i19.CornerRadius=u1(0.2,0)
i20.Name=rs()
i20.AnchorPoint=v2(0.5,0.5)
i20.BackgroundColor3=c3(1,1,1)
i20.BackgroundTransparency=1
i20.BorderColor3=c3(0,0,0)
i20.BorderSizePixel=0
i20.Position=u2(0.5,0,0.5,0)
i20.Size=u2(1,0,0.5,0)
i20.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
i20.TextColor3=c3(1,1,1)
i20.TextScaled=true
i20.TextSize=14
i21.Name=rs()
i21.AnchorPoint=v2(0.5,0.5)
i21.BackgroundColor3=c3(1,1,1)
i21.BackgroundTransparency=1
i21.BorderColor3=c3(0,0,0)
i21.BorderSizePixel=0
i21.Position=u2(0.5,0,0.5,0)
i21.Size=u2(0.1,0,0.1,0)
i21.SizeConstraint=e.SizeConstraint.RelativeYY
i22.Name=rs()
i22.AnchorPoint=v2(0.5,0.5)
i22.BackgroundColor3=c3(0.714,0.714,0.714)
i22.BorderColor3=c3(0,0,0)
i22.BorderSizePixel=0
i22.Position=u2(0.5,0,0.3,0)
i22.Size=u2(0,1,0.15,0)
i23.Name=rs()
i23.AnchorPoint=v2(0.5,0.5)
i23.BackgroundColor3=c3(0.714,0.714,0.714)
i23.BorderColor3=c3(0,0,0)
i23.BorderSizePixel=0
i23.Position=u2(0.5,0,0.7,0)
i23.Size=u2(0,1,0.15,0)
i24.Name=rs()
i24.AnchorPoint=v2(0.5,0.5)
i24.BackgroundColor3=c3(0.714,0.714,0.714)
i24.BorderColor3=c3(0,0,0)
i24.BorderSizePixel=0
i24.Position=u2(0.3,0,0.5,0)
i24.Size=u2(0.15,0,0,1)
i25.Name=rs()
i25.AnchorPoint=v2(0.5,0.5)
i25.BackgroundColor3=c3(0.714,0.714,0.714)
i25.BorderColor3=c3(0,0,0)
i25.BorderSizePixel=0
i25.Position=u2(0.7,0,0.5,0)
i25.Size=u2(0.15,0,0,1)
i26.Name=rs()
i26.AnchorPoint=v2(0.5,0.5)
i26.BackgroundColor3=c3(0.714,0.714,0.714)
i26.BorderColor3=c3(0,0,0)
i26.BorderSizePixel=0
i26.Position=u2(0.5,0,0.5,0)
i26.Size=u2(0,1,0,1)
i27.Name=rs()
i27.AnchorPoint=v2(1,0.5)
i27.BackgroundColor3=c3(0,0,0)
i27.BackgroundTransparency=0.85
i27.BorderColor3=c3(0,0,0)
i27.BorderSizePixel=0
i27.Position=u2(0.98,0,0.395,0)
i27.Size=u2(0.18,0,0.06,0)
i27.SizeConstraint=e.SizeConstraint.RelativeYY
i27.Text=""
i27.TextTransparency=1
i28.Name=rs()
i28.CornerRadius=u1(0.2,0)
i29.Name=rs()
i29.AnchorPoint=v2(0.5,0.5)
i29.BackgroundColor3=c3(1,1,1)
i29.BackgroundTransparency=1
i29.BorderColor3=c3(0,0,0)
i29.BorderSizePixel=0
i29.Position=u2(0.6,0,0.5,0)
i29.Size=u2(1,0,0.5,0)
i29.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
i29.Text="Shoot"
i29.TextColor3=c3(1,1,1)
i29.TextScaled=true
i29.TextSize=14
i30.Name=rs()
i30.BackgroundColor3=c3(1,1,1)
i30.BackgroundTransparency=1
i30.BorderColor3=c3(0,0,0)
i30.BorderSizePixel=0
i30.Size=u2(1,0,1,0)
i30.SizeConstraint=e.SizeConstraint.RelativeYY
i31.Name=rs()
i31.AnchorPoint=v2(0.5,0.5)
i31.BackgroundColor3=c3(1,1,1)
i31.BorderColor3=c3(0,0,0)
i31.BorderSizePixel=0
i31.Position=u2(0.5,0,0.5,0)
i31.Size=u2(0.7,0,0.7,0)
i31.SizeConstraint=e.SizeConstraint.RelativeYY
i32.Name=rs()
i32.Color=cs({[1]=csk(0,c3(1,1,1)),[2]=csk(1,c3(0.624,0.624,0.624))})
i32.Rotation=90
i33.Name=rs()
i33.CornerRadius=u1(0.3,0)
i34.Name=rs()
i34.AnchorPoint=v2(0.5,0.5)
i34.BackgroundColor3=c3(1,1,1)
i34.BackgroundTransparency=1
i34.BorderColor3=c3(0,0,0)
i34.BorderSizePixel=0
i34.Position=u2(0.5,0,0.5,0)
i34.Size=u2(0.6,0,0.6,0)
i34.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Bold,e.FontStyle.Normal)
i34.Text="M1"
i34.TextColor3=c3(0.22,0.22,0.22)
i34.TextScaled=true
i34.TextSize=14
i35.Name=rs()
i35.AnchorPoint=v2(1,0.5)
i35.BackgroundColor3=c3(0,0,0)
i35.BackgroundTransparency=0.85
i35.BorderColor3=c3(0,0,0)
i35.BorderSizePixel=0
i35.Position=u2(0.98,0,0.465,0)
i35.Size=u2(0.18,0,0.06,0)
i35.SizeConstraint=e.SizeConstraint.RelativeYY
i35.Text=""
i35.TextTransparency=1
i36.Name=rs()
i36.CornerRadius=u1(0.2,0)
i37.Name=rs()
i37.AnchorPoint=v2(0.5,0.5)
i37.BackgroundColor3=c3(1,1,1)
i37.BackgroundTransparency=1
i37.BorderColor3=c3(0,0,0)
i37.BorderSizePixel=0
i37.Position=u2(0.6,0,0.5,0)
i37.Size=u2(1,0,0.5,0)
i37.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
i37.Text="Crouch"
i37.TextColor3=c3(1,1,1)
i37.TextScaled=true
i37.TextSize=14
i38.Name=rs()
i38.BackgroundColor3=c3(1,1,1)
i38.BackgroundTransparency=1
i38.BorderColor3=c3(0,0,0)
i38.BorderSizePixel=0
i38.Size=u2(1,0,1,0)
i38.SizeConstraint=e.SizeConstraint.RelativeYY
i39.Name=rs()
i39.AnchorPoint=v2(0.5,0.5)
i39.BackgroundColor3=c3(1,1,1)
i39.BorderColor3=c3(0,0,0)
i39.BorderSizePixel=0
i39.Position=u2(0.5,0,0.5,0)
i39.Size=u2(0.7,0,0.7,0)
i39.SizeConstraint=e.SizeConstraint.RelativeYY
i40.Name=rs()
i40.Color=cs({[1]=csk(0,c3(1,1,1)),[2]=csk(1,c3(0.624,0.624,0.624))})
i40.Rotation=90
i41.Name=rs()
i41.CornerRadius=u1(0.3,0)
i42.Name=rs()
i42.AnchorPoint=v2(0.5,0.5)
i42.BackgroundColor3=c3(1,1,1)
i42.BackgroundTransparency=1
i42.BorderColor3=c3(0,0,0)
i42.BorderSizePixel=0
i42.Position=u2(0.5,0,0.5,0)
i42.Size=u2(0.6,0,0.6,0)
i42.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Bold,e.FontStyle.Normal)
i42.Text=crouchKeybind.Name
i42.TextColor3=c3(0.22,0.22,0.22)
i42.TextScaled=true
i42.TextSize=14
i43.Name=rs()
i43.AnchorPoint=v2(0,1)
i43.BackgroundColor3=c3(0,0,0)
i43.BackgroundTransparency=0.8
i43.BorderColor3=c3(0,0,0)
i43.BorderSizePixel=0
i43.Position=u2(0.02,0,0.475,0)
i43.Size=u2(0.3,0,0.03,0)
i43.SizeConstraint=e.SizeConstraint.RelativeYY
i44.Name=rs()
i44.CornerRadius=u1(0.4,0)
i45.Name=rs()
i45.AnchorPoint=v2(0.5,0.5)
i45.BackgroundColor3=c3(0,0,0)
i45.BackgroundTransparency=1
i45.BorderColor3=c3(0,0,0)
i45.BorderSizePixel=0
i45.Position=u2(0.5,0,0.55,0)
i45.Size=u2(1,0,0.9,0)
i45.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
i45.Text="Gun script by MyWorld"
i45.TextColor3=c3(1,1,1)
i45.TextScaled=true
i45.TextSize=14
i45.TextStrokeColor3=c3(1,1,1)

i45.Parent=i43
i44.Parent=i43
i43.Parent=i1
i42.Parent=i39
i41.Parent=i39
i40.Parent=i39
i39.Parent=i38
i38.Parent=i35
i37.Parent=i35
i36.Parent=i35
i35.Parent=i1
i34.Parent=i31
i33.Parent=i31
i32.Parent=i31
i31.Parent=i30
i30.Parent=i27
i29.Parent=i27
i28.Parent=i27
i27.Parent=i1
i26.Parent=i21
i25.Parent=i21
i24.Parent=i21
i23.Parent=i21
i22.Parent=i21
i21.Parent=i1
i20.Parent=i18
i19.Parent=i18
i18.Parent=i1
i17.Parent=i14
i16.Parent=i14
i15.Parent=i14
i14.Parent=i13
i13.Parent=i10
i12.Parent=i10
i11.Parent=i10
i10.Parent=i1
i9.Parent=i6
i8.Parent=i6
i7.Parent=i6
i6.Parent=i5
i5.Parent=i2
i4.Parent=i2
i3.Parent=i2
i2.Parent=i1
if not pcall(function()
	i1.Parent=FindFirstChildOfClass(game,"CoreGui")
end) then
	i1.Parent=FindFirstChildOfClass(lp,"PlayerGui")
end

local equipped=false
local shootingCon=nil
local shootingRotation=nil
local reloading=false
local reloadPending=false
local reloadStopTime=nil
local crouching=false
local ammo=maxAmmo

local processInput=function(input)
	if input==reloadKeybind then
		reloadPending=true
	elseif input==equipKeybind then
		equipped=not equipped
		i12.Text=(equipped and "Unequip Gun") or "Equip Gun"
	elseif input==crouchKeybind then
		crouching=not crouching
	end
end

Connect(uis.InputBegan,function(input)
	if gs.MenuIsOpen or GetFocusedTextBox(uis) then
		return
	end
	processInput(input.KeyCode)
end)
Connect(i2.MouseButton1Click,function()
	processInput(reloadKeybind)
end)
Connect(i10.MouseButton1Click,function()
	processInput(equipKeybind)
end)
Connect(i35.MouseButton1Click,function()
	processInput(crouchKeybind)
end)
local shootGuiButtonDown=false
Connect(i27.MouseButton1Down,function()
	shootGuiButtonDown=true
end)
Connect(i27.MouseButton1Up,function()
	shootGuiButtonDown=false
end)

cam.CameraSubject=movementHum

local movementCfr=movementHrp.CFrame
local lastAntisleepMoveDirection=nil
local movementCfrOff=cf_0
local currentRecoilVelocityX=0
local currentRecoilVelocityY=0

local moveDirection=hum.MoveDirection
local steppedCon=Connect(stepped,function()
	for i,v in next,GetDescendants(c) do
		if IsA(v,"BasePart") then
			v.CanCollide=false
		end
	end
end)
local flingpart=nil
local minY=ws.FallenPartsDestroyHeight+5
local Move=hum.Move
local heartbeatCon=Connect(heartbeat,function()
	Move(movementHum,moveDirection)
	Move(hum,v3(0,0,-1))
	movementHum.Jump=hum.Jump

	if flingpart then
		local fcf=flingpart.CFrame+flingpart.AssemblyLinearVelocity*(sin(osclock()*15)+1)
		if fcf.Y<minY then
			fcf=fcf+v3_010*(minY-fcf.Y)
		end
		hrp.CFrame=fcf
		hrp.AssemblyLinearVelocity=flingpart.AssemblyLinearVelocity*v3_101*75
		hrp.AssemblyAngularVelocity=flingrotvel
	else
		hrp.CFrame=movementCfr*movementCfrOff
		hrp.AssemblyLinearVelocity=v3_0
		hrp.AssemblyAngularVelocity=v3_0
	end
end)
local rendersteppedCon=Connect(renderstepped,function()
	moveDirection=hum.MoveDirection
end)

local GetConnectedParts=head.GetConnectedParts
Connect(movementHrp:GetPropertyChangedSignal("LocalTransparencyModifier"),function()
	local t=movementHrp.LocalTransparencyModifier
	for i,v in next,GetConnectedParts(head) do
		if v~=upperTorso then
			v.LocalTransparencyModifier=t
		end
	end
end)

i20.Text=ammo.." / "..maxAmmo
i12.Text=(equipped and "Unequip Gun") or "Equip Gun"

local healthbarf={}
local healthBarsParent=i1
local clientDamage=function(dmg,hum,...)
	local head=gp(hum.Parent,"Head","BasePart")
	if not (head and IsDescendantOf(head,ws)) then
		return
	end
	local refresh=healthbarf[head]
	if not refresh then
		local i1=i("BillboardGui")
		local i2=i("Frame")
		local i3=i("Frame")
		local i4=i("Frame")
		local i5=i("UICorner")
		local i6=i("UIGradient")
		local i7=i("Frame")
		local i8=i("TextLabel")
		local i9=i("Frame")
		local i10=i("TextLabel")

		i1.Name=rs()
		i1.Active=true
		i1.Adornee=head
		i1.AlwaysOnTop=true
		i1.MaxDistance=50
		i1.Size=u2(5,0,1.2,0)
		i1.StudsOffset=v3(0,2.1,0)
		i2.Name=rs()
		i2.AnchorPoint=v2(0.5,0.5)
		i2.BackgroundColor3=c3(1,1,1)
		i2.BackgroundTransparency=1
		i2.BorderColor3=c3(0.106,0.165,0.208)
		i2.BorderSizePixel=0
		i2.Position=u2(0.5,0,0.5,0)
		i2.Size=u2(1,0,0.6,0)
		i3.Name=rs()
		i3.AnchorPoint=v2(0.5,0.5)
		i3.BackgroundColor3=c3(1,1,1)
		i3.BackgroundTransparency=1
		i3.BorderColor3=c3(0.106,0.165,0.208)
		i3.BorderSizePixel=0
		i3.Position=u2(0.5,0,0.5,0)
		i3.Size=u2(1,0,0.35,0)
		i4.Name=rs()
		i4.BackgroundColor3=c3(1,1,1)
		i4.BorderColor3=c3(0.106,0.165,0.208)
		i4.BorderSizePixel=0
		i4.Size=u2(0.9,0,1,0)
		i4.ZIndex=2
		i5.Name=rs()
		i5.CornerRadius=u1(0.35,0)
		i6.Name=rs()
		i6.Transparency=ns({[1]=nsk(0,0.65625,0),[2]=nsk(1,0,0)})
		i7.Name=rs()
		i7.AnchorPoint=v2(1,0)
		i7.BackgroundColor3=c3(1,1,1)
		i7.BackgroundTransparency=1
		i7.BorderColor3=c3(0,0,0)
		i7.BorderSizePixel=0
		i7.ClipsDescendants=true
		i7.Position=u2(0.9,0,0,0)
		i7.Size=u2(1,0,1,0)
		i8.Name=rs()
		i8.Active=true
		i8.AnchorPoint=v2(1,0.5)
		i8.BackgroundColor3=c3(1,1,1)
		i8.BackgroundTransparency=1
		i8.BorderColor3=c3(0.106,0.165,0.208)
		i8.BorderSizePixel=0
		i8.Position=u2(1.1,0,0.5,0)
		i8.Size=u2(1,0,0.8,0)
		i8.ZIndex=3
		i8.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
		i8.Text="100/100"
		i8.TextColor3=c3(0,0,0)
		i8.TextScaled=true
		i8.TextSize=24
		i8.TextStrokeColor3=c3(0.161,0.169,0.184)
		i8.TextXAlignment=e.TextXAlignment.Right
		i9.Name=rs()
		i9.BackgroundColor3=c3(1,1,1)
		i9.BackgroundTransparency=1
		i9.BorderColor3=c3(0,0,0)
		i9.BorderSizePixel=0
		i9.ClipsDescendants=true
		i9.Position=u2(0.9,0,0,0)
		i9.Size=u2(1,0,1,0)
		i10.Name=rs()
		i10.Active=true
		i10.AnchorPoint=v2(1,0.5)
		i10.BackgroundColor3=c3(1,1,1)
		i10.BackgroundTransparency=1
		i10.BorderColor3=c3(0.106,0.165,0.208)
		i10.BorderSizePixel=0
		i10.Position=u2(0.1,0,0.5,0)
		i10.Size=u2(1,0,0.8,0)
		i10.ZIndex=3
		i10.FontFace=f("rbxasset://fonts/families/GothamSSm.json",e.FontWeight.Regular,e.FontStyle.Normal)
		i10.Text="100/100"
		i10.TextColor3=c3(1,1,1)
		i10.TextScaled=true
		i10.TextSize=24
		i10.TextStrokeColor3=c3(0.161,0.169,0.184)
		i10.TextXAlignment=e.TextXAlignment.Right

		i10.Parent=i9
		i9.Parent=i3
		i8.Parent=i7
		i7.Parent=i3
		i6.Parent=i4
		i5.Parent=i4
		i4.Parent=i3
		i3.Parent=i2
		i2.Parent=i1
		i1.Parent=healthBarsParent

		local con=nil
		local health=maxHealth
		local lasth1=nil
		refresh=function(dmg,hum,f,...)
			if not i1 then
				return
			end
			health=clamp(health-dmg,0,maxHealth)
			local h1=health/maxHealth
			if h1==0 then
				i1:Destroy()
				con:Disconnect()
				i1=nil
				healthbarf[head]=nil
				return f(hum,...)
			elseif h1==1 then
				i1:Destroy()
				con:Disconnect()
				i1=nil
				healthbarf[head]=nil
				return
			end
			if h1==lasth1 then
				return
			end
			i4.Size=u2(h1,0,1,0)
			i7.Position=u2(h1,0,0,0)
			i8.Position=u2(2-h1,0,0.5,0)
			i9.Position=u2(h1,0,0,0)
			i10.Position=u2(1-h1,0,0.5,0)
			local t=round(health).."/"..round(maxHealth)
			i8.Text=t
			i10.Text=t
			lasth1=h1
		end
		tspawn(function()
			while i1 do
				refresh(twait()*-healthRegenerationSpeed)
			end
		end)
		con=Connect(head.AncestryChanged,function()
			if not IsDescendantOf(head,ws) then
				refresh(-maxHealth)
			end
		end)
		healthbarf[head]=refresh
	end
	return refresh(dmg,hum,...)
end

local flingtable={}
local fling=function(hum)
	tinsert(flingtable,hum)
end

local lastsine=osclock()
local delta=0
local sine=lastsine
local flingstartpos=nil
local flingstoptime=nil
while renderstepped:Wait() and IsDescendantOf(c,ws) do
	sine=osclock()
	delta=sine-lastsine
	lastsine=sine

	movementCfr=movementHrp.CFrame

	local walking=movementHum.MoveDirection~=v3_0
	local mouseLocked=uis.MouseBehavior==mouseBehaviorLockCenter

	i21.Visible=equipped and mouseLocked

	if reloading or reloadPending or (autoReload and ammo==0) then
		movementHum.WalkSpeed=reloadWalkspeed

		reloading=true
		local track=switchCurrentAnimation(1,3972131105,reloadSpeed)
		if not reloadStopTime then
			local tracklength=track.Length
			if tracklength>0 then --animation could be still loading
				reloadStopTime=sine+tracklength/reloadSpeed-animationFadeTime
			end
		elseif sine>reloadStopTime then
			reloading=false
			reloadPending=false
			reloadStopTime=nil
			ammo=maxAmmo
			i20.Text=ammo.." / "..maxAmmo
		end
		shootingRotation=nil
	elseif not equipped then
		switchCurrentAnimation(1,3972151362)
		shootingRotation=nil
	elseif ((shootGuiButtonDown or IsMouseButtonPressed(uis,mb1)) and not (gs.MenuIsOpen or GetFocusedTextBox(uis))) and (ammo>0) then
		local track=switchCurrentAnimation(1,4713811763,shootingSpeed)
		if not shootingCon then
			shootingCon=Connect(track.DidLoop,function()
				if ammo>0 then
					ammo=ammo-1
					i20.Text=ammo.." / "..maxAmmo
					movementHrp.CFrame=movementCfr-(shootingRotation or movementCfr).LookVector*recoilStuds
					currentRecoilVelocityX=currentRecoilVelocityX+(recoilVelocityXfrom+mrandom()*(recoilVelocityXto-recoilVelocityXfrom))
					currentRecoilVelocityY=currentRecoilVelocityY+(recoilVelocityYfrom+mrandom()*(recoilVelocityYto-recoilVelocityYfrom))
					local t=mouse.Target
					if not t then
						return
					end
					local p=t.Parent
					if IsA(p,"Accessory") then
						t=GetConnectedParts(t)[2]
						if not t then
							return
						end
						p=t.Parent
					end
					local h=FindFirstChildOfClass(p,"Humanoid")
					if (not h) or (h==hum) or (h==movementHum) or tfind(flingtable,h) then
						return
					end
					local dmg=damageTable[t.Name]
					if dmg then
						clientDamage(dmg,h,fling)
					end
				end
			end)
		end

		if shootGuiButtonDown then
			shootingRotation=nil
		else
			if not shootingRotation then
				shootingRotation=movementCfr.Rotation
			end
			shootingRotation=Lerp(shootingRotation,cfl(v3_0,(mouse.Hit.Position-movementCfr.Position)*v3_101),clamp(delta*10,0,1))
			movementCfr=shootingRotation+movementCfr.Position
		end
	elseif mouseLocked then
		local track=switchCurrentAnimation(1,3972164452,0)
		track.TimePosition=cam.CFrame.LookVector.Y+1
		shootingRotation=nil
	else
		switchCurrentAnimation(1,4713633512)
		shootingRotation=nil
	end

	if crouching then
		if reloading then
			movementHum.WalkSpeed=reloadWalkspeed
		else
			movementHum.WalkSpeed=crouchingWalkspeed
		end

		if walking then
			switchCurrentAnimation(2,3489173414,1)

			movementCfrOff=Lerp(movementCfrOff,cf(0,0.1,1)*angles(rad(9),0,0),delta*3)
		else
			switchCurrentAnimation(2,616086039,0)

			movementCfrOff=Lerp(movementCfrOff,cf(0,-0.5,0)*angles(rad(-15),0,0),delta*9)
		end
	else
		if reloading then
			movementHum.WalkSpeed=reloadWalkspeed
		else
			if equipped then
				movementHum.WalkSpeed=equippedWalkspeed
			else 
				movementHum.WalkSpeed=normalWalkspeed
			end
		end

		switchCurrentAnimation(2,nil)

		movementCfrOff=Lerp(movementCfrOff,cf_0,delta*3)
	end

	cam.CFrame=cam.CFrame*angles(currentRecoilVelocityX*delta,currentRecoilVelocityY*delta,0)
	if currentRecoilVelocityX>0 then
		currentRecoilVelocityX=max(0,currentRecoilVelocityX-recoilXcatch*delta)
	elseif currentRecoilVelocityX<0 then
		currentRecoilVelocityX=min(0,currentRecoilVelocityX+recoilXcatch*delta)
	end
	if currentRecoilVelocityY>0 then
		currentRecoilVelocityY=max(0,currentRecoilVelocityY-recoilYcatch*delta)
	elseif currentRecoilVelocityY<0 then
		currentRecoilVelocityY=min(0,currentRecoilVelocityY+recoilYcatch*delta)
	end

	if mouseLocked then
		movementCfr=cfl(v3_0,cam.CFrame.LookVector*v3_101)+movementCfr.Position
	end
	movementHrp.CFrame=movementCfr

	local flinghum=flingtable[1]
	if flinghum then
		flingpart=flinghum.RootPart
		if not flingpart then
			flingpart=flinghum.Parent
			if flingpart then
				flingpart=gp(flingpart,"HumanoidRootPart","BasePart")
			end
		end
		if flingpart then
			if not flingstartpos then
				flingstartpos=flingpart.CFrame.Position
				flingstoptime=sine+3
			end
			if (sine>flingstoptime) or flingpart:IsGrounded() or (not IsDescendantOf(flingpart,ws)) or ((flingstartpos-flingpart.CFrame.Position).Magnitude>200) then
				flingstartpos=nil
				local l=#flingtable
				tmove(flingtable,2,l,1,flingtable)
				flingtable[l]=nil
				flingpart=nil
			end
		else
			flingstartpos=nil
			local l=#flingtable
			tmove(flingtable,2,l,1,flingtable)
			flingtable[l]=nil
		end
	else
		flingpart=nil
	end
	if flingpart then
		local fcf=flingpart.CFrame+flingpart.AssemblyLinearVelocity*(sin(sine*15)+1)
		if fcf.Y<minY then
			fcf=fcf+v3_010*(minY-fcf.Y)
		end
		hrp.CFrame=fcf
		hrp.AssemblyLinearVelocity=flingpart.AssemblyLinearVelocity*v3_101*75
		hrp.AssemblyAngularVelocity=flingrotvel
	else
		hrp.CFrame=movementCfr*movementCfrOff
		hrp.AssemblyLinearVelocity=movementHrp.AssemblyLinearVelocity
		hrp.AssemblyAngularVelocity=movementHrp.AssemblyAngularVelocity
	end
end

if shootingCon then
	shootingCon:Disconnect()
end
for i,v in next,healthbarf do
	v(-maxHealth)
end
steppedCon:Disconnect()
rendersteppedCon:Disconnect()
heartbeatCon:Disconnect()
movementModel:Destroy()
i1:Destroy()

--i could have spent this time on other things instead of making this
