local ENT = {}

ENT.Type = "anim"
ENT.PrintName			= "Frag Grenade"
SWEP.Author				= "Sixx"
SWEP.Contact				= "eve-gaming.com"
SWEP.Instructions				= "LMB: Fire"

if SERVER then

AddCSLuaFile( "shared.lua" )

function ENT:Initialize()

	self.Owner = self.Entity.Owner

	self.Entity:SetModel("models/humangrenade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
	phys:Wake()
	end

	self.timeleft = CurTime() + 3
	self:Think()
end

 function ENT:Think()
	
	if self.timeleft < CurTime() then
		self:Explosion()	
	end

	self.Entity:NextThink( CurTime() )
	return true
end

function ENT:Explosion()
		
		self.Entity:EmitSound(Sound("weapons/nade/splode.wav"), 100,100)
		
	local thumper = EffectData()
		thumper:SetOrigin(self.Entity:GetPos())
		thumper:SetScale(500)
		thumper:SetMagnitude(500)
		util.Effect("ThumperDust", thumper)
		
		local ed = EffectData()
	ed:SetOrigin(self.Entity:GetPos())
	ed:SetScale(1.5)			// Size of explosion
	ed:SetMagnitude(18)	
	util.Effect("nade_explode", ed)
		
	local scorchstart = self.Entity:GetPos() + ((Vector(0,0,1)) * 5)
	local scorchend = self.Entity:GetPos() + ((Vector(0,0,-1)) * 5)
	
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), 500, 150)
	util.ScreenShake(self.Entity:GetPos(), 500, 500, 1.25, 500)
	self.Entity:Remove()
	-- loos like if I don't remove the entity before drawing this scorch, the scorch will draw on the entity 
	-- and disappear immediately after
	util.Decal("Scorch", scorchstart, scorchend)
end

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("weapons/nade/bounce.wav"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .2 + (data.OurOldVelocity * -10)
	phys:ApplyForceCenter(impulse)
	
end

end

if CLIENT then
function ENT:Draw()
	self.Entity:DrawModel()
end
end
scripted_ents.Register(ENT, "thrown_halo_grenade", true)


SWEP.Gun = ("halo_swep_grenade") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Halo"
SWEP.Author				= "Heavy-D"
SWEP.Contact				= "Don't"
SWEP.Purpose				= "AIDS"
SWEP.Instructions				= "SPLODE"
SWEP.PrintName				= "Frag Grenade"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 0				-- Slot in the weapon selection menu
SWEP.SlotPos				= 1			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "grenade"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_eq_fraggrenade.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_eq_fraggrenade.mdl"	-- Weapon world model
SWEP.Base				= "halo_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.RPM			= 40			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 4		-- Bullets you start with
SWEP.Primary.KickUp				= 0.4		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "grenade"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Damage		= 150	-- Base damage per bullet

//Enter iron sight info and bone mod info below
-- SWEP.IronSightsPos = Vector(-2.652, 0.187, -0.003)
-- SWEP.IronSightsAng = Vector(2.565, 0.034, 0) 		//not for the knife
-- SWEP.SightsPos = Vector(-2.652, 0.187, -0.003)		//just lower it when running
-- SWEP.SightsAng = Vector(2.565, 0.034, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-25.577, 0, 0)

SWEP.ViewModelBoneMods = {
	["v_weapon.pull_ring"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.Flashbang_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["nade"] = { type = "Model", model = "models/humangrenade.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(0.8, -5, 0), angle = Angle(0, -5.114, 90), size = Vector(0.449, 0.449, 0.449), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Deploy()
	self:SetIronsights(false, self.Owner)					-- Set the ironsight false
	
	if self.Silenced then
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
	else
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	end
	
	self.Weapon:SetNetworkedBool("Reloading", false)
	
	if !self.Owner:IsNPC() and self.Owner != nil then 
		if self.ResetSights and self.Owner:GetViewModel() != nil then
			self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration() 
		end
	end
	return true
end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() then return end
	if self:CanPrimaryAttack() then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		timer.Simple( 0.1, function() if SERVER then if not IsValid(self) then return end
		
		self.Weapon:EmitSound(Sound("weapons/nade/trow.wav"))
		
		end end)
		timer.Simple( 0.6, function() if SERVER then if not IsValid(self) then return end 
			if IsValid(self.Owner) then 
				if (self:AllIsWell()) then				
					self:Throw() 
				end 
			end
		end end )
	end
end

function SWEP:Throw()

	if SERVER then
	
	if self.Owner != nil and self.Weapon != nil then 
	if self.Owner:GetActiveWeapon():GetClass() == self.Gun then

	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	timer.Simple( 0.35, function() if not IsValid(self) then return end 
	if self.Owner != nil
	and self.Weapon != nil
	then if(self:AllIsWell()) then 
	self.Owner:SetAnimation(PLAYER_ATTACK1)
			aim = self.Owner:GetAimVector()
			side = aim:Cross(Vector(0,0,1))
			up = side:Cross(aim)
			pos = self.Owner:GetShootPos() + side * 5 + up * -1
			if SERVER then
				local rocket = ents.Create("thrown_halo_grenade")
				if !rocket:IsValid() then return false end
				rocket:SetNWEntity("Owner", self.Owner)
				rocket:SetAngles(aim:Angle()+Angle(90,0,0))
				rocket:SetPos(pos)
				rocket:SetOwner(self.Owner)
				rocket.Owner = self.Owner	-- redundancy department of redundancy checking in
				rocket:SetNWEntity("Owner", self.Owner)
				rocket:Spawn()
			
				local phys = rocket:GetPhysicsObject()
				if self.Owner:KeyDown(IN_ATTACK2) and (phys:IsValid()) then
					if phys != nil then phys:ApplyForceCenter(self.Owner:GetAimVector() * 55000) end
				else 
					if phys != nil then phys:ApplyForceCenter(self.Owner:GetAimVector() * 110000) end
				end
				self.Weapon:TakePrimaryAmmo(1)
		end
		self:checkitycheckyoself()
		end end
	end )
		
	end
	end
	end
end

function SWEP:SecondaryAttack()
end	

function SWEP:checkitycheckyoself()
	timer.Simple(.15, function() if not IsValid(self) then return end 
	if IsValid(self.Owner) then 
	if SERVER and (self:AllIsWell()) then	
		if self.Weapon:Clip1() == 0 
			and self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
					self.Owner:StripWeapon(self.Gun)
			else
				self.Weapon:DefaultReload( ACT_VM_DRAW )
			end
		end
	end end)
end

function SWEP:AllIsWell()

	if self.Owner != nil and self.Weapon != nil then
		if self.Weapon:GetClass() == self.Gun and self.Owner:Alive() then
			return true
			else return false
		end
		else return false
	end

end

function SWEP:Think()
end