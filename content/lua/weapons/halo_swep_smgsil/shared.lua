-- Variables that are used on both client and server
SWEP.Gun = ("halo_swep_smgsil") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Halo" --Category where you will find your weapons
SWEP.Author				= "Sixx"
SWEP.Contact				= "eve-gaming.com"
SWEP.Instructions				= "LMB: Fire"
SWEP.PrintName				= "M7 SMG Silenced"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false	-- set false if you want no crosshair
SWEP.Weight					= 30		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_smg_sil.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base				= "halo_base" --the Base this weapon will work on. PLEASE RENAME THE BASE! 
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/h3smgsil/mp5-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.SilencedSound 	= Sound("weapons/mk22/shoot.wav")		-- Sound if the weapon is silenced
SWEP.Primary.RPM			= 700			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 60		-- Size of a clip
SWEP.Primary.DefaultClip		= 180		-- Bullets you start with
SWEP.Primary.KickUp				= 0.3		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.2		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.2		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.UseMelee	= true
SWEP.SelectiveFire		= true


SWEP.Secondary.IronFOV			= 0		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Damage		= 13	-- Base damage per bullet
SWEP.Primary.Spread		= .03	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns


SWEP.IronSightsPos = Vector(0.36, 0.865, -10.66)
SWEP.IronSightsAng = Vector(39.409, 0, 0)

SWEP.WElements = {
	["smg"] = { type = "Model", model = "models/smg.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.399, -1.364), angle = Angle(-101.25, 0, 90), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
	
	surface.SetTexture(surface.GetTextureID("VGUI/crosshairs/smg"))
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( ScrW()/2 - 40, ScrH()/2 - 40, 80, 80 )

end


if CLIENT then
function SWEP:DrawHUD()

	local Trace = {}
	Trace.start = self.Owner:GetShootPos()
	Trace.endpos = Trace.start + (self.Owner:GetAimVector() * 1000)
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
					trace.Entity:TakeDamage(25, self.Owner, self.Owner)
					
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