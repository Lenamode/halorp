-- Variables that are used on both client and server
SWEP.Gun = ("halo_swep_superassaultrifle") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Halo" --Category where you will find your weapons
SWEP.Author				= "Sixx"
SWEP.Contact				= "eve-gaming.com"
SWEP.Instructions				= "LMB: Fire"
SWEP.PrintName				= "Super MA37"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight					= 30		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV			= 68
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_tct_f2000.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "halo_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Sound			= Sound("weapons/ar/singleshot2.mp3")
SWEP.Primary.RPM				= 550		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 32		-- Size of a clip
SWEP.Primary.DefaultClip			= 2000	-- Bullets you start with
SWEP.Primary.KickUp			= 0				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 		-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire		= true	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Damage		= 50	--base damage per bullet
SWEP.Primary.Spread		= .01	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01-- Ironsight accuracy, should be the same for shotguns

SWEP.IronSightsPos = Vector(4.28, -13.15, -6.531)
SWEP.IronSightsAng = Vector(70, -9.646, 14.055)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-11.851, -37.757, 0)
--Again, use the Swep Construction Kit

SWEP.ViewModelBoneMods = {
	["bone_mag"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["bone_trig"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["bone_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["bone_ch"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["f2000_trig"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["ar"] = { type = "Model", model = "models/HaloReach/weapons/ma37.mdl", bone = "bone_body", rel = "", pos = Vector(0.6, -1.9, -0.201), angle = Angle(-91.024, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["ar"] = { type = "Model", model = "models/HaloReach/weapons/ma37.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, 0.4), angle = Angle(0, 90, -170.795), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Reload()
	if not IsValid(self) then return end if not IsValid(self.Owner) then return end
	
	if self.Owner:IsNPC() then
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	return end
	
	if self.Owner:KeyDown(IN_USE) then return end
	
	if self.Silenced then
		self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED) 
	else
		self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	end
	
	if !self.Owner:IsNPC() then
		if self.Owner:GetViewModel() == nil then self.ResetSights = CurTime() + 3 else
		self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration() 
		end
	end
	
	if SERVER and self.Weapon != nil then
	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
	-- When the current clip < full clip and the rest of your ammo > 0, then
		self.Owner:SetFOV( 0, 0.3 )
		-- Zoom = 0
		self:SetIronsights(false)
		-- Set the ironsight to false
		self.Weapon:SetNetworkedBool("Reloading", true)
	end
	local waitdammit = (self.Owner:GetViewModel():SequenceDuration())
	timer.Simple(waitdammit + .1, 
		function() 
		if self.Weapon == nil then return end
		self.Weapon:SetNetworkedBool("Reloading", false)
		if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then 
			if CLIENT then return end
			if self.Scoped == false then
				self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
				self.DrawCrosshair = false
			else return end
		elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then 
			self.Weapon:SetNextPrimaryFire(CurTime()+0.3)			-- Make it so you can't shoot for another quarter second
				-- Set the ironsight true
			self.Owner:SetFOV( 0, 0.3 )
		else return end
		end)
	end
end

function SWEP:DetectionHUD(trace)

	if trace.Entity and trace.Entity:IsNPC() || trace.Entity:IsPlayer() then
	color = Color(255,0,0,255)

	else
	color = Color( 30, 80, 130, 255 )
	end
	
	surface.SetTexture(surface.GetTextureID("VGUI/crosshairs/superar"))
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( ScrW()/2 - 40, ScrH()/2 - 40, 80, 80 )

end


if CLIENT then
function SWEP:DrawHUD()

	local Trace = {}
	Trace.start = self.Owner:GetShootPos()
	Trace.endpos = Trace.start + (self.Owner:GetAimVector() * 1500)
	Trace.filter = { self.Owner, self.Weapon, 0 }
	Trace.mask = MASK_SHOT
	local tr = util.TraceLine(Trace)
	
self:DetectionHUD(tr)

end
end

function SWEP:IronSight()
	
	
	if self.SelectiveFire and self.NextFireSelect < CurTime() and not (self.Weapon:GetNWBool("Reloading")) then
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_RELOAD) then
			self:SelectFireMode()
		end
	end
	

end

function SWEP:Think()

self:IronSight()

	if self.Weapon:Clip1()== 32 then
		self.VElements["ar"].skin = 0
	elseif self.Weapon:Clip1()== 31 then
	self.VElements["ar"].skin = 1
	elseif self.Weapon:Clip1()== 30 then
	self.VElements["ar"].skin = 2
	elseif self.Weapon:Clip1()== 29 then
	self.VElements["ar"].skin = 3
	elseif self.Weapon:Clip1()== 28 then
	self.VElements["ar"].skin = 4
	elseif self.Weapon:Clip1()== 27 then
	self.VElements["ar"].skin = 5
	elseif self.Weapon:Clip1()== 26 then
	self.VElements["ar"].skin = 6
	elseif self.Weapon:Clip1()== 25 then
	self.VElements["ar"].skin = 7
	elseif self.Weapon:Clip1()== 24 then
	self.VElements["ar"].skin = 8
	elseif self.Weapon:Clip1()== 23 then
	self.VElements["ar"].skin = 9
	elseif self.Weapon:Clip1()== 22 then
	self.VElements["ar"].skin = 10
	elseif self.Weapon:Clip1()== 21 then
	self.VElements["ar"].skin = 11
	elseif self.Weapon:Clip1()== 20 then
	self.VElements["ar"].skin = 12
	elseif self.Weapon:Clip1()== 19 then
	self.VElements["ar"].skin = 13
	elseif self.Weapon:Clip1()== 18 then
	self.VElements["ar"].skin = 14
	elseif self.Weapon:Clip1()== 17 then
	self.VElements["ar"].skin = 15
	elseif self.Weapon:Clip1()== 16 then
	self.VElements["ar"].skin = 16
	elseif self.Weapon:Clip1()== 15 then
	self.VElements["ar"].skin = 17
	elseif self.Weapon:Clip1()== 14 then
	self.VElements["ar"].skin = 18
	elseif self.Weapon:Clip1()== 13 then
	self.VElements["ar"].skin = 19
	elseif self.Weapon:Clip1()== 12 then
	self.VElements["ar"].skin = 20
	elseif self.Weapon:Clip1()== 11 then
	self.VElements["ar"].skin = 21
	elseif self.Weapon:Clip1()== 10 then
	self.VElements["ar"].skin = 22
	elseif self.Weapon:Clip1()== 9 then
	self.VElements["ar"].skin = 23
	elseif self.Weapon:Clip1()== 8 then
	self.VElements["ar"].skin = 24
	elseif self.Weapon:Clip1()== 7 then
	self.VElements["ar"].skin = 25
	elseif self.Weapon:Clip1()== 6 then
	self.VElements["ar"].skin = 26
	elseif self.Weapon:Clip1()== 5 then
	self.VElements["ar"].skin = 27
	elseif self.Weapon:Clip1()== 4 then
	self.VElements["ar"].skin = 28
	elseif self.Weapon:Clip1()== 3 then
	self.VElements["ar"].skin = 29
	elseif self.Weapon:Clip1()== 2 then
	self.VElements["ar"].skin = 30
	elseif self.Weapon:Clip1()== 1 then
	self.VElements["ar"].skin = 31
	elseif self.Weapon:Clip1()== 0 then
	self.VElements["ar"].skin = 32
	end
	

end

function SWEP:SecondaryAttack()
if SERVER then
	self:Melee()
end
end

if SERVER then
	function SWEP:Melee()

		
		
		CT = CurTime()
		

		self.Weapon:SetNextPrimaryFire(CT + 0.5)
		self.Weapon:SetNextSecondaryFire(CT + 0.5)
		
		self.Owner:EmitSound("npc/fast_zombie/claw_miss1.wav", 80, 100)
		self.Weapon:SetIronsights(true, self.Owner)
		self.Owner:ViewPunch(Angle(-5,0,0))

		
		timer.Simple(0.1, function()
		
		
			if not self.Weapon or not self.Owner or self.Owner:GetActiveWeapon():GetClass() != self.Weapon:GetClass() then
				return
			end
			
			tr = {}
			tr.start = self.Owner:GetShootPos()
			tr.endpos = tr.start + self.Owner:GetAimVector() * 50
			tr.filter = self.Owner
			tr.mins = Vector(-8, -8, -8)
			tr.maxs = Vector(8, 8, 8)
			
			trace = util.TraceHull(tr)
			
			if trace.Hit then
			
				physobj = trace.Entity:GetPhysicsObject()
					
				if physobj:IsValid() then
					physobj:AddVelocity(self.Owner:GetAimVector() * 250)
				end
					
				if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:Health() > 0 then
					trace.Entity:TakeDamage(250, self.Owner, self.Owner)
					
					if trace.Entity:IsNPC() then
						trace.Entity:SetVelocity(self.Owner:GetForward() * 2000)
					end
				end
				
				self.Owner:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav", 80, 100)
			end
			
		end)
		
		timer.Simple(0.25, function()
			self.Weapon:SetIronsights(false, self.Owner)
		end)
	end
end

local IRONSIGHT_TIME = 0.1

function SWEP:GetViewModelPosition( pos, ang )

    if ( !self.IronSightsPos ) then return pos, ang end

    local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
    
    if ( bIron != self.bLastIron ) then
    
    self.bLastIron = bIron 
    self.fIronTime = CurTime()
    if ( bIron ) then 
    self.SwayScale     = 0.3
    self.BobScale     = 0.1
    else 
    self.SwayScale     = 1.0
    self.BobScale     = 1.0
end
    
    end
    
    local fIronTime = self.fIronTime or 0

    if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
        return pos, ang 
    end
    
    local Mul = 1.0
    
    if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
    
    Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
    if (!bIron) then Mul = 1 - Mul end
    
    end

    local Offset    = self.IronSightsPos
    
    if ( self.IronSightsAng ) then
    
    ang = ang * 1
    ang:RotateAroundAxis( ang:Right(),         self.IronSightsAng.x * Mul )
    ang:RotateAroundAxis( ang:Up(),         self.IronSightsAng.y * Mul )
    ang:RotateAroundAxis( ang:Forward(),     self.IronSightsAng.z * Mul )
    
    
    end
    
    local Right     = ang:Right()
    local Up         = ang:Up()
    local Forward     = ang:Forward()
    
    

    pos = pos + Offset.x * Right * Mul
    pos = pos + Offset.y * Forward * Mul
    pos = pos + Offset.z * Up * Mul

    return pos, ang
    
end