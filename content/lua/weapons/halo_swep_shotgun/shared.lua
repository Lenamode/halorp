-- Variables that are used on both client and server
SWEP.Gun = ("halo_swep_shotgun") -- must be the name of your swep
SWEP.Category				= "Halo" --Category where you will find your weapons
SWEP.Author				= "Sixx"
SWEP.Contact				= "eve-gaming.com"
SWEP.Instructions				= "LMB: Fire"
SWEP.PrintName				= "M90 Shotgun"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3		-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_halo_m3super90.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_shotgun.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "halo_base_shotgun" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.RPM				= 60		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6			-- Size of a clip
SWEP.Primary.DefaultClip			= 18	-- Default number of bullets in a clip
SWEP.Primary.KickUp			= 5				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.8		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 1	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.ShellTime			= .5

SWEP.Primary.NumShots	= 12		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 15	-- Base damage per bullet
SWEP.Primary.Spread		= .07	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .07	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

SWEP.IronSightsPos = Vector(4.28, -13.15, -6.531)
SWEP.IronSightsAng = Vector(70, -9.646, 14.055)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-7.993, -27.835, 0)

SWEP.VElements = {
	["shotgun"] = { type = "Model", model = "models/shotty.mdl", bone = "Spas12_Body", rel = "", pos = Vector(-3, -0.59, 0.1), angle = Angle(-90, 0, 90), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["coverup"] = { type = "Model", model = "models/hunter/plates/plate1x2.mdl", bone = "Spas12_Body", rel = "shotgun", pos = Vector(0.209, 2.799, 2.65), angle = Angle(0, 0, 0), size = Vector(0.019, 0.037, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/battle_rifle_ammo", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["shotgun"] = { type = "Model", model = "models/shotty.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.272, 1, -3.701), angle = Angle(-180, -85, 11), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["coverup"] = { type = "Model", model = "models/hunter/plates/plate1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shotgun", pos = Vector(0.209, 2.799, 2.65), angle = Angle(0, 0, 0), size = Vector(0.019, 0.037, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/battle_rifle_ammo", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["Shell"] = { scale = Vector(0.7, 0.7, 0.7), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Spas12_Body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

function SWEP:Deploy()

	if (timer.Exists("ShotgunReload")) then
		timer.Destroy("ShotgunReload")
	end

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	
			self.Weapon:EmitSound("weapons/sg17/draw.wav")

	self.Weapon:SetNextPrimaryFire(CurTime() + .25)
	self.Weapon:SetNextSecondaryFire(CurTime() + .25)
	self.ActionDelay = (CurTime() + .25)

	if (SERVER) then
		self:SetIronsights(false)
	end
	
	self.NextReload = CurTime() + 1

	return true
end

function SWEP:DetectionHUD(trace)

	if trace.Entity and trace.Entity:IsNPC() || trace.Entity:IsPlayer() then
	color = Color(255,0,0,255)

	else
	color = Color( 30, 80, 130, 255 )
	end
	
	surface.SetTexture(surface.GetTextureID("VGUI/crosshairs/shotgun"))
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( ScrW()/2 - 50, ScrH()/2 - 50, 100, 100 )

end


if CLIENT then
function SWEP:DrawHUD()

	local Trace = {}
	Trace.start = self.Owner:GetShootPos()
	Trace.endpos = Trace.start + (self.Owner:GetAimVector() * 700)
	Trace.filter = { self.Owner, self.Weapon, 0 }
	Trace.mask = MASK_SHOT
	local tr = util.TraceLine(Trace)
	
self:DetectionHUD(tr)

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
			timer.Simple(0.4, function()
			self.Weapon:EmitSound("weapons/sg17/pump.wav")
			end)
			timer.Destroy("ShotgunReload") -- kill the timer
		elseif (self.Weapon:Clip1() <= self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 0) then
			self.InsertingShell = true
			self.Weapon:EmitSound("weapons/sg17/insert.wav")
			self.Owner:RemoveAmmo(1, self.Primary.Ammo, false) -- out of the frying pan
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1) --  into the fire
		end
	else
		timer.Destroy("ShotgunReload") -- kill the timer
	end
	
end

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

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
	
	if SERVER then
	
		if self.Owner:KeyDown(IN_FORWARD) and self.Owner:KeyDown(IN_MOVELEFT) and self.Owner:KeyDown(IN_MOVERIGHT) and self.Owner:KeyDown(IN_DUCK) and self.Weapon:Clip1()==2 and self.Owner:KeyDown(IN_JUMP) then	
				self.Owner:SetHealth( self.Owner:Health() + 10 )
				self.Owner:GiveAmmo(100,self.Primary.Ammo)
			return 
		end
	end
	
	if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		
		if self.Silenced then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED )
			self.Weapon:EmitSound(self.Primary.SilencedSound)
		else
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Weapon:EmitSound("weapons/shotgun/fire"..math.random(1,5)..".mp3")
		end	
	
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		self.RicochetCoin = (math.random(1,4))
		if self.BoltAction then self:BoltBack() end
	end
	elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		self.RicochetCoin = (math.random(1,4))
	end
end