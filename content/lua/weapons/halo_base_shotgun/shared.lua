// Variables that are used on both client and server
-- just use the weapon base you already made on top of this?
SWEP.Category				= ""
SWEP.Author				= "Sixx"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.Base 				= "halo_base"
SWEP.MuzzleAttachment			= "1" 		// Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 		// Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false		// Hell no, crosshairs r 4 nubz!
SWEP.ViewModelFOV			= 65		// How big the gun will look
SWEP.ViewModelFlip			= true		// True for CSS models, False for HL2 models

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Sound 			= Sound("")				// Sound of the gun
SWEP.Primary.RPM				= 0					// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 0					// Size of a clip
SWEP.Primary.DefaultClip			= 0					// Default number of bullets in a clip
SWEP.Primary.KickUp			= 0					// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0					// Maximum side recoil (koolaid)
SWEP.Primary.Automatic			= true					// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"					// What kind of ammo
SWEP.Primary.Reloading			= false					// Reloading func

SWEP.Secondary.ClipSize			= 0					// Size of a clip
SWEP.Secondary.DefaultClip			= 0					// Default number of bullets in a clip
SWEP.Secondary.Automatic			= false					// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.IronFOV			= 0					// How much you 'zoom' in. Less is more! 

SWEP.data 				= {}					-- The starting firemode
SWEP.data.ironsights			= 1

SWEP.IronSightsPos = Vector (2.4537, 1.0923, 0.2696)
SWEP.IronSightsAng = Vector (0.0186, -0.0547, 0)

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.5
SWEP.ShellTime		= 0.35
SWEP.InsertingShell	=		false

SWEP.NextReload	=	0

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	--if the owner presses shoot while the timer is in effect, then...
	if (self.Owner:KeyPressed(IN_ATTACK)) and (timer.Exists("ShotgunReload")) and not (self.Owner:KeyDown(IN_SPEED)) then
		if self:CanPrimaryAttack() then --well first, if we actually can attack, then...
			timer.Destroy("ShotgunReload") -- kill the timer, and
			self:PrimaryAttack()-- ATTAAAAACK!
		end
	end
	
	if self.Weapon:GetClass() != self.Gun and (timer.Exists("ShotgunReload")) then
		timer.Destroy("ShotgunReload")
	end
	
	if self.InsertingShell == true and self.Owner:Alive() then
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD) --insert a shell
		self.InsertingShell = false
	end
	
	self:IronSight()
	
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	if (timer.Exists("ShotgunReload")) then
		timer.Destroy("ShotgunReload")
	end

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	self.Weapon:SetNextPrimaryFire(CurTime() + .25)
	self.Weapon:SetNextSecondaryFire(CurTime() + .25)
	self.ActionDelay = (CurTime() + .25)

	if (SERVER) then
		self:SetIronsights(false)
	end
	
	self.NextReload = CurTime() + 1

	return true
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	local maxcap = self.Primary.ClipSize
	local spaceavail = self.Weapon:Clip1()
	local shellz = (maxcap) - (spaceavail) + 1

	if (timer.Exists("ShotgunReload")) or self.NextReload > CurTime() or maxcap == spaceavail then return end
	
	if self.Owner:IsPlayer() then 

		self.Weapon:SetNextPrimaryFire(CurTime() + 1) -- wait one second before you can shoot again
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START) -- sending start reload anim
		self.Owner:SetAnimation( PLAYER_RELOAD )
		
		self.NextReload = CurTime() + 1
	
		if (SERVER) then
			self.Owner:SetFOV( 0, 0.15 )
			self:SetIronsights(false)
		end
	
		if SERVER and self.Owner:Alive() then
			timer.Create("ShotgunReload", 
			self.ShellTime, 
			shellz,
			function() if not IsValid(self) then return end  if IsValid(self.Owner) 
			and IsValid(self.Weapon) then 
			if self.Owner:Alive() then 
			self:InsertShell() end end end)
		end
	
	elseif self.Owner:IsNPC() then
		self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	end
	
end

function SWEP:InsertShell()
	
	if self.Owner:Alive() then
		local curwep = self.Owner:GetActiveWeapon()
		if curwep:GetClass() != self.Gun then 
			timer.Destroy("ShotgunReload")
		return end
	
		if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
		-- if clip is full or ammo is out, then...
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) -- send the pump anim
			timer.Destroy("ShotgunReload") -- kill the timer
		elseif (self.Weapon:Clip1() <= self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 0) then
			self.InsertingShell = true
			self.Owner:RemoveAmmo(1, self.Primary.Ammo, false) -- out of the frying pan
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1) --  into the fire
		end
	else
		timer.Destroy("ShotgunReload") -- kill the timer
	end
	
end
