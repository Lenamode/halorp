-- Variables that are used on both client and server
SWEP.Gun = ("halo_swep_dmr") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Halo" --Category where you will find your weapons
SWEP.Author				= "Sixx"
SWEP.Contact				= "eve-gaming.com"
SWEP.Instructions				= "LMB: Fire"
SWEP.PrintName				= "M392 DMR"		-- Weapon name (Shown on HUD)	
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
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.BoltAction				= false	
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV			= 66
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_tct_f2000.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "halo_base_sniper" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("weapons/magnum/shoot.mp3")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 400		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 15		-- Size of a clip
SWEP.Primary.DefaultClip			= 60	-- Bullets you start with
SWEP.Primary.KickUp			= .3				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= .2			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= .2		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 		-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire		= false


SWEP.Secondary.ScopeZoom			= 4
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= false	-- I mean it, only one	
SWEP.Secondary.UseSVD			= false	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false

SWEP.data 				= {}
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 0.6
SWEP.ReticleScale 				= 0.7

SWEP.Primary.Damage		= 30	--base damage per bullet
SWEP.Primary.Spread		= .003	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .003-- Ironsight accuracy, should be the same for shotguns

SWEP.IronSightsPos = Vector(3.319, -2.599, 0.119)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-11.851, -37.757, 0)
--Again, use the Swep Construction Kit

SWEP.ViewModelBoneMods = {
	["bone_mag"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["bone_trig"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["bone_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["f2000_trig"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["bone_ch"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bone R index base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["dmr"] = { type = "Model", model = "models/HaloReach/weapons/dmr.mdl", bone = "bone_body", rel = "", pos = Vector(0, -2.5, -0.16), angle = Angle(-90, 0, 90), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1, [3] = 1, [4] = 1} }
}

SWEP.WElements = {
	["ar"] = { type = "Model", model = "models/HaloReach/weapons/dmr.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.273, 1.363, 0.455), angle = Angle(0, 90, -172.842), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[3] = 1, [4] = 1} }
}

function SWEP:DetectionHUD(trace)

	if trace.Entity and trace.Entity:IsNPC() || trace.Entity:IsPlayer() then
	color = Color(255,0,0,255)

	else
	color = Color( 30, 80, 130, 255 )
	end
	
	surface.SetTexture(surface.GetTextureID("VGUI/crosshairs/dmr"))
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( ScrW()/2 - 35, ScrH()/2 - 35, 70, 70 )

end


if CLIENT then
function SWEP:DrawHUD()

	local Trace = {}
	Trace.start = self.Owner:GetShootPos()
	Trace.endpos = Trace.start + (self.Owner:GetAimVector() * 4500)
	Trace.filter = { self.Owner, self.Weapon, 0 }
	Trace.mask = MASK_SHOT
	local tr = util.TraceLine(Trace)
	
	self:DetectionHUD(tr)

	if self.Owner:KeyDown(IN_ATTACK2) and (self:GetIronsights() == true) and (!self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_USE)) then
	
	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
	surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
	
	end

end
end


function SWEP:Initialize()

	if CLIENT then
	
		-- We need to get these so we can scale everything to the player's current resolution.
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()
		
		-- The following code is only slightly riped off from Night Eagle
		-- These tables are used to draw things like scopes and crosshairs to the HUD.
		-- so DONT GET RID OF IT!

		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579/self.ReticleScale		-- Draws the texture at 512 when the resolution is 1600x900
		self.ReticleTable.x = (iScreenWidth/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.y = (iScreenHeight/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.w = iScreenHeight/self.ReticleTable.hdivider
		self.ReticleTable.h = iScreenHeight/self.ReticleTable.hdivider

		self.FilterTable = {}
		self.FilterTable.wdivider = 3.125
		self.FilterTable.hdivider = 1.7579/1.35	
		self.FilterTable.x = (iScreenWidth/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.y = (iScreenHeight/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.w = iScreenHeight/self.FilterTable.hdivider
		self.FilterTable.h = iScreenHeight/self.FilterTable.hdivider

		
	end
	
	self.Reloadaftershoot = 0 				-- Can't reload when firing
	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:SetNetworkedBool("Reloading", false)
	if SERVER and self.Owner:IsNPC() then
		self:SetNPCMinBurst(3)			
		self:SetNPCMaxBurst(10)			-- None of this really matters but you need it here anyway
		self:SetNPCFireRate(1/(self.Primary.RPM/60))	
		self:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
	end
	
	if CLIENT then

	
		-- // Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		
		-- // init view model bone build function
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
		if self.Owner:Alive() then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				-- // Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- // however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
			
		end
		end
		
	end
	
	if CLIENT then
		local oldpath = "vgui/hud/name" -- the path goes here
		local newpath = string.gsub(oldpath, "name", self.Gun)
		self.WepSelectIcon = surface.GetTextureID(newpath)
	end
	
	self.SightsPos = self.IronSightsPos
	self.SightsAng = self.IronSightsAng
	
end

function SWEP:Think()

	
	if self.Weapon:Clip1()== 15 then
	self.VElements["dmr"].skin = 0
	elseif self.Weapon:Clip1()== 14 then
	self.VElements["dmr"].skin = 1
	elseif self.Weapon:Clip1()== 13 then
	self.VElements["dmr"].skin = 2
	elseif self.Weapon:Clip1()== 12 then
	self.VElements["dmr"].skin = 3
	elseif self.Weapon:Clip1()== 11 then
	self.VElements["dmr"].skin = 4
	elseif self.Weapon:Clip1()== 10 then
	self.VElements["dmr"].skin = 5
	elseif self.Weapon:Clip1()== 9 then
	self.VElements["dmr"].skin = 6
	elseif self.Weapon:Clip1()== 8 then
	self.VElements["dmr"].skin = 7
	elseif self.Weapon:Clip1()== 7 then
	self.VElements["dmr"].skin = 8
	elseif self.Weapon:Clip1()== 6 then
	self.VElements["dmr"].skin = 9
	elseif self.Weapon:Clip1()== 5 then
	self.VElements["dmr"].skin = 10
	elseif self.Weapon:Clip1()== 4 then
	self.VElements["dmr"].skin = 11
	elseif self.Weapon:Clip1()== 3 then
	self.VElements["dmr"].skin = 12
	elseif self.Weapon:Clip1()== 2 then
	self.VElements["dmr"].skin = 13
	elseif self.Weapon:Clip1()== 1 then
	self.VElements["dmr"].skin = 14
	elseif self.Weapon:Clip1()== 0 then
	self.VElements["dmr"].skin = 15
	end
	
	self:IronSight()
	

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
			self.Weapon:EmitSound("weapons/dmr/fire"..math.random(1,5)..".mp3")
		end	

		self.Owner:SetAnimation( PLAYER_ATTACK1 )
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
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		self.RicochetCoin = (math.random(1,4))
	end
end