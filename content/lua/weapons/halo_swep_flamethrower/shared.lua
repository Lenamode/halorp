function SWEP:Initialize()

    self:SetWeaponHoldType( "shotgun" )

    
    self.EmittingSound = false
	
    if ( SERVER ) then
    self:SetNPCMinBurst( 30 )
    self:SetNPCMaxBurst( 30 )
    self:SetNPCFireRate( 0.01 )
    end

    self.Weapon:SetNWFloat("lastattack",CurTime())
	
		if CLIENT then
		local oldpath = "vgui/hud/name" -- the path goes here
		local newpath = string.gsub(oldpath, "name", "halo_swep_flamethrower")
		self.WepSelectIcon = surface.GetTextureID(newpath)
		end

	if CLIENT then
	
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end


if (CLIENT) then
local EFFECT={}

    function EFFECT:Init( data )
    
    self.Position = data:GetStart()
    self.WeaponEnt = data:GetEntity()
    self.Attachment = data:GetAttachment()
    

    local Pos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
    
    local Velocity     = data:GetNormal()
    local AddVel = self.WeaponEnt:GetOwner():GetVelocity()*0.5
    local jetlength = data:GetScale()
    
    local maxparticles1 = math.ceil(jetlength/81) + 1
    local maxparticles2 = math.ceil(jetlength/190) + 1

    Pos = Pos + Velocity * 2
    
    local emitter = ParticleEmitter( Pos )
        
        for i=1, maxparticles1 do
        
            local particle = emitter:Add( "particles/FireExplosion", Pos + Velocity * i * math.Rand(1.6,3) )
                local randvel = Velocity + Vector(math.Rand(-0.04,0.04),math.Rand(-0.04,0.04),math.Rand(-0.04,0.04))
                local partvel = randvel * math.Rand( jetlength/0.7, jetlength/0.8 ) + AddVel
                local partime = jetlength/partvel:Length()
                if partime > 0.85 then partime = 0.85 end
                particle:SetVelocity(partvel)
                particle:SetDieTime(partime)
                particle:SetStartAlpha( math.Rand( 100, 150 ) )
                particle:SetStartSize( 1.7 )
                particle:SetEndSize( math.Rand( 60, 80 ) )
                particle:SetRoll( math.Rand( 0, 360 ) )
                particle:SetRollDelta( math.Rand( -1, 1 ) )
                particle:SetColor( math.Rand( 130, 230 ), math.Rand( 100, 160 ), 120 )
                particle:VelocityDecay( false )
            
        end
        
        for i=0, maxparticles2 do
        
            local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Velocity * i * math.Rand(0.3,0.6))
                particle:SetVelocity(Velocity * math.Rand( 0.42*jetlength/0.3, 0.42*jetlength/0.4 ) + AddVel)
                particle:SetDieTime(math.Rand(0.3,0.4))
                particle:SetStartAlpha( 255 )
                particle:SetStartSize( 0.6*i )
                particle:SetEndSize( math.Rand( 24, 32 ) )
                particle:SetRoll( math.Rand( 0, 360 ) )
                particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
                particle:SetColor( 30, 15, math.Rand( 190, 225 ) )
                particle:VelocityDecay( false )
            
        end
        
      

    emitter:Finish()
    
end



function EFFECT:Think( )

  
    return false
    
end



function EFFECT:Render()


    
end
effects.Register( EFFECT, "flamepuffs" )

end

if (CLIENT) then
local EFFECT={}
    
    function EFFECT:Init( data )
    
    self.Position = data:GetStart()
    self.WeaponEnt = data:GetEntity()
    self.Attachment = data:GetAttachment()
    
    local Pos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
    
    local Velocity     = data:GetNormal()
    local AddVel = self.WeaponEnt:GetOwner():GetVelocity()*0.85
    local jetlength = data:GetScale()
    
    local maxparticles1 = math.ceil(jetlength/71) + 1
    local maxparticles2 = math.ceil(jetlength/190)

    Pos = Pos + Velocity * 2
    
    local emitter = ParticleEmitter( Pos )
        
        for i=4, maxparticles1 do
        
            local particle = emitter:Add( "particles/smokey", Pos + Velocity * i * math.Rand(1.5,2.6) )
                local partvel = Velocity * math.Rand( jetlength/0.5, jetlength/0.6 ) + AddVel
                local partime = jetlength/partvel:Length()
                if partime > 0.85 then partime = 0.85 end
                particle:SetVelocity(partvel)
                particle:SetDieTime(partime)
                particle:SetStartAlpha( math.Rand( 10, 20 ) )
                particle:SetStartSize( 2 )
                particle:SetEndSize( math.Rand( 96, 128 ) )
                particle:SetRoll( math.Rand( 0, 360 ) )
                particle:SetRollDelta( math.Rand( -1, 1 ) )
                particle:SetColor( 145, math.Rand( 160, 200 ), 70 )
                particle:VelocityDecay( false )
            
        end
        
        for i=0, maxparticles2 do
        
            local particle = emitter:Add( "particles/smokey", Pos + Velocity * i * math.Rand(0.35,0.55))
                particle:SetVelocity(Velocity * math.Rand( 0.6*jetlength/0.3, 0.6*jetlength/0.4 ) + AddVel)
                particle:SetDieTime(math.Rand(0.3,0.4))
                particle:SetStartAlpha( 90 )
                particle:SetStartSize( 0.6*i )
                particle:SetEndSize( math.Rand( 24, 48 ) )
                particle:SetRoll( math.Rand( 0, 360 ) )
                particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
                particle:SetColor( 135, math.Rand( 120, 140 ), 60 )
                particle:VelocityDecay( false )
            
        end

    emitter:Finish()
    
end

function EFFECT:Think( )

    
    return false
    
end

function EFFECT:Render()

    
    
end
effects.Register( EFFECT, "gaspuffs" )

end    

if (CLIENT) then
local EFFECT={}

function EFFECT:Init( data )
    
    self.Position = data:GetOrigin()
    local Pos = self.Position
    local Norm = Vector(0,0,1)
    
    Pos = Pos + Norm * 2
    
    local emitter = ParticleEmitter( Pos )
    
    
        for i=1, 28 do
        
            local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-80,80),math.random(-80,80),math.random(0,70)))

                particle:SetVelocity( Vector(math.random(-160,160),math.random(-160,160),math.random(250,300)) )
                particle:SetDieTime( math.Rand( 3.4, 3.7 ) )
                particle:SetStartAlpha( math.Rand( 220, 240 ) )
                particle:SetStartSize( 48 )
                particle:SetEndSize( math.Rand( 160, 192 ) )
                particle:SetRoll( math.Rand( 360, 480 ) )
                particle:SetRollDelta( math.Rand( -1, 1 ) )
                particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
                particle:VelocityDecay( false )
            
            end
        
    
        for i=1, 20 do
        
            local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,20)))

                particle:SetVelocity( Vector(math.random(-120,120),math.random(-120,120),math.random(170,250)) )
                particle:SetDieTime( math.Rand( 3, 3.4 ) )
                particle:SetStartAlpha( math.Rand( 220, 240 ) )
                particle:SetStartSize( 32 )
                particle:SetEndSize( math.Rand( 128, 160 ) )
                particle:SetRoll( math.Rand( 360, 480 ) )
                particle:SetRollDelta( math.Rand( -1, 1 ) )
                particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
                particle:VelocityDecay( false )
                
            end
        
    
        for i=1, 36 do
        
            local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(10,70)))

                particle:SetVelocity( Vector(math.random(-300,300),math.random(-300,300),math.random(-20,180)) )
                particle:SetDieTime( math.Rand( 1.8, 2 ) )
                particle:SetStartAlpha( math.Rand( 220, 240 ) )
                particle:SetStartSize( 48 )
                particle:SetEndSize( math.Rand( 128, 160 ) )
                particle:SetRoll( math.Rand( 360,480 ) )
                particle:SetRollDelta( math.Rand( -1, 1 ) )
                particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
                particle:VelocityDecay( true )    
                
            end
        
    
        for i=1, 24 do
        
            local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,10)))

            particle:SetVelocity( Vector(math.random(-280,280),math.random(-280,280),math.random(0,180)) )
            particle:SetDieTime( math.Rand( 1.9, 2.3 ) )
            particle:SetStartAlpha( math.Rand( 60, 80 ) )
            particle:SetStartSize( math.Rand( 32, 48 ) )
            particle:SetEndSize( math.Rand( 192, 256 ) )
            particle:SetRoll( math.Rand( 360, 480 ) )
            particle:SetRollDelta( math.Rand( -1, 1 ) )
            particle:SetColor( 170, 160, 160 )
            particle:VelocityDecay( false )
        
        end
        
    -- big smoke cloud
        for i=1, 24 do
        
            local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-40,40),math.random(-40,50),math.random(20,80)))

            particle:SetVelocity( Vector(math.random(-180,180),math.random(-180,180),math.random(260,340)) )
            particle:SetDieTime( math.Rand( 3.5, 3.7 ) )
            particle:SetStartAlpha( math.Rand( 60, 80 ) )
            particle:SetStartSize( math.Rand( 32, 48 ) )
            particle:SetEndSize( math.Rand( 192, 256 ) )
            particle:SetRoll( math.Rand( 480, 540 ) )
            particle:SetRollDelta( math.Rand( -1, 1 ) )
            particle:SetColor( 170, 170, 170 )
            particle:VelocityDecay( false )
            
        end
        
        
        
        for i=1, 18 do
        
            local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,60)))

            particle:SetVelocity( Vector(math.random(-200,200),math.random(-200,200),math.random(120,200)) )
            particle:SetDieTime( math.Rand( 3.1, 3.4 ) )
            particle:SetStartAlpha( math.Rand( 60, 80 ) )
            particle:SetStartSize( math.Rand( 32, 48 ) )
            particle:SetEndSize( math.Rand( 192, 256 ) )
            particle:SetRoll( math.Rand( 480, 540 ) )
            particle:SetRollDelta( math.Rand( -1, 1 ) )
            particle:SetColor( 170, 170, 170 )
            particle:VelocityDecay( false )
            
        end
            
    emitter:Finish()
    
end


function EFFECT:Think( )
    return false    
end


function EFFECT:Render()
    
end
effects.Register(EFFECT, "Explosion_Large" )

end

if (CLIENT) then
local EFFECT={}

function EFFECT:Init( data )
    
    self.Position = data:GetOrigin()
    
    local Pos = self.Position
    local Norm = Vector(0,0,1)
    
    Pos = Pos + Norm * 6

    local emitter = ParticleEmitter( Pos )
    
    --firecloud
        for i=1, 16 do
        
            local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-20,20),math.random(-20,20),math.random(-30,50)))

                particle:SetVelocity( Vector(math.random(-30,30),math.random(-30,30),math.random(90,120)) )
                particle:SetDieTime( math.Rand( 1.6, 1.8 ) )
                particle:SetStartAlpha( math.Rand( 200, 240 ) )
                particle:SetStartSize( 16 )
                particle:SetEndSize( math.Rand( 48, 64 ) )
                particle:SetRoll( math.Rand( 360, 480 ) )
                particle:SetRollDelta( math.Rand( -1, 1 ) )
                particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
                particle:VelocityDecay( false )
                
            end
        
    --smoke cloud
        for i=1, 18 do
        
        local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-25,25),math.random(-25,25),math.random(-30,70)))

            particle:SetVelocity( Vector(math.random(-30,30),math.random(-30,30),math.random(35,50)) )
            particle:SetDieTime( math.Rand( 2.4, 2.9 ) )
            particle:SetStartAlpha( math.Rand( 160, 200 ) )
            particle:SetStartSize( 24 )
            particle:SetEndSize( math.Rand( 32, 48 ) )
            particle:SetRoll( math.Rand( 360, 480 ) )
            particle:SetRollDelta( math.Rand( -1, 1 ) )
            particle:SetColor( 20, 20, 20 )
            particle:VelocityDecay( false )
            
        end
            
    emitter:Finish()
    
end


function EFFECT:Think( )
    -- Die instantly
    return false    
end

function EFFECT:Render()
        
end
effects.Register( EFFECT, "immolate" )

end

function ParticleTrace(partrace)

if ( SERVER ) then

    if not partrace.func
    or not partrace.startpos
    or not (partrace.ang or partrace.velocity)
    then return end
    

    
    partrace.speed             =     partrace.speed             or 1024
    partrace.ang             =     partrace.ang              or partrace.velocity:GetNormalized() or Vector(0,0,0)
    partrace.owner            =     partrace.owner             or 0
    partrace.name            =     partrace.name             or ""
    partrace.collisionsize     =     partrace.collisionsize     or 1
    partrace.worldcollide    =    partrace.worldcollide    or true
    partrace.mask            =     partrace.mask             or 3
    partrace.killtime         =     partrace.killtime         or 12
    partrace.runonkill         =     partrace.runonkill      or false
    partrace.movetype         =     partrace.movetype         or MOVETYPE_FLY
    partrace.model             =     partrace.model             or "none"
    partrace.color             =     partrace.color          or Color(255,255,255,255)
    partrace.doblur            =     partrace.doblur             or false
    partrace.filter            =    partrace.filter            or {}
    

    
    partrace.starttime = CurTime()
    partrace.dodraw = false
    partrace.issprite = false
    
    partrace.entid = ents.Create( "trace_particle" ) 
        
        if partrace.model == "none" then 
            partrace.entid:SetModel("models/Items/combine_rifle_ammo01.mdl") 
        elseif string.find(partrace.model,".mdl") ~= nil then 
            partrace.entid:SetModel(partrace.model)
            partrace.dodraw = true 
        else 
            partrace.entid:SetModel("models/Items/combine_rifle_ammo01.mdl") 
            partrace.dodraw = true
            partrace.issprite = true
            partrace.model = string.gsub(string.gsub(string.gsub(partrace.model, ".vmt", ""), ".vtf", ""), ".spr", "")    
        end
        
    
    table.insert(partrace.filter,partrace.entid)
    
    
    if partrace.speed > 8192 then partrace.speed = 8192 end

    
    partrace.entid:SetVar("tracedata",partrace)

    
    partrace.entid:SetPos(partrace.startpos)
    partrace.entid:SetAngles(partrace.ang:Angle())
    partrace.entid:Spawn()
    partrace.entid:SetOwner(partrace.owner)
    partrace.entid:SetName(partrace.name)

    
    local physobj = partrace.entid:GetPhysicsObject()
    if partrace.velocity then
        partrace.ang = partrace.velocity:GetNormalized()
    else
        partrace.velocity = partrace.ang*partrace.speed
    end
    physobj:SetMass(1e-9) 
    physobj:EnableGravity(partrace.gravity)
    physobj:SetVelocity(partrace.velocity)
    partrace.entid:SetVelocity(partrace.velocity)
    
    
    if partrace.initfunc then
    partrace.initfunc(partrace.entid)
    end
    
end

end

function SWEP:GetViewModelPosition( origin, angles )

    if self:GetNWBool("Reloading") == true or self.Weapon:Clip1() == 0 then return end
    
    
    local wiggle = VectorRand();
    wiggle:Mul( 0.0001 )
    
    if self.Owner:KeyDown(IN_ATTACK) then
        
        wiggle:Mul( 1500 );
        
    end
    
    if self.Owner:KeyReleased(IN_ATTACK) then
        
        wiggle = vector_origin;
        
    end
    
    local offset = angles:Forward();

    offset:Add( wiggle );
    
    origin:Sub( offset );
    
    return origin, angles;
    
end

local ENT = {}
ENT.Type = "anim"
function ENT:Initialize()

    local partent = self.Entity
    self.tracedata = partent:GetVar("tracedata",{couldnotfindtable = true})
    local data = self.tracedata --hurrr local variables are faster
    
    if data.couldnotfindtable then return end
    
    
    partent:SetMoveType(data.movetype)
    partent:PhysicsInitSphere(data.collisionsize, "default_silent")
    partent:SetCollisionBounds(Vector()*data.collisionsize*-1, Vector()*data.collisionsize)
    
    local phys = partent:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
    
    partent:SetTrigger(true)
    partent:SetNotSolid(true)
    partent:SetCollisionGroup(data.mask)

    if data.worldcollide then
        partent:SetMoveType(data.movetype) 
    end
    
    
    if data.runonkill then
        timer.Simple( data.killtime, calculatedata, data, Entity(0) )
    else
        partent:Fire("kill", "", data.killtime )
    end
    
    
    
    
    partent:SetNetworkedString("model",data.model)
    partent:SetNetworkedBool("dodraw",data.dodraw)
    partent:SetNetworkedBool("doblur",data.doblur)
    partent:SetNetworkedBool("issprite",data.issprite)
    partent:SetNetworkedFloat("collisionsize",data.collisionsize)
    partent:SetNetworkedInt("rcolor",data.color.r)
    partent:SetNetworkedInt("bcolor",data.color.b)
    partent:SetNetworkedInt("gcolor",data.color.g)
    partent:SetNetworkedInt("acolor",data.color.a)
    
    self.Color = Color(255,255,255,255)

end


function ENT:Draw()

    
    local dodraw = dodraw or self.Entity:GetNetworkedBool("dodraw")
    if not dodraw then return false end
    
    
    local issprite = issprite or self.Entity:GetNetworkedBool("issprite")
    local doblur = doblur or self.Entity:GetNetworkedBool("doblur")
    local model = model or self.Entity:GetNetworkedString("model")
    local color = color or Color( self.Entity:GetNetworkedInt("rcolor",255), self.Entity:GetNetworkedInt("gcolor",255), self.Entity:GetNetworkedInt("bcolor",255), self.Entity:GetNetworkedInt("acolor",255) )
    local collisionsize = collisionsize or self.Entity:GetNetworkedFloat("collisionsize")*2
    
    
    if issprite then
    
        local pos = self.Entity:GetPos()
        local vel = self.Entity:GetVelocity()
        render.SetMaterial(Material(model))

        if doblur then
            local lcolor = render.GetLightColor( pos ) * 2
            lcolor.x = color.r * mathx.Clamp( lcolor.x, 0, 1 )
            lcolor.y = color.g * mathx.Clamp( lcolor.y, 0, 1 )
            lcolor.z = color.b * mathx.Clamp( lcolor.z, 0, 1 )
            
            
            for i = 1, 7 do
                local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
                render.DrawSprite( pos + vel*(i*-0.004), collisionsize, collisionsize, col )
            end
        end
        
        render.DrawSprite(pos, collisionsize, collisionsize, color)

    else
    
        self.Entity:DrawModel() 
        
    end

    self.Entity:DrawShadow(false)
    
end

local lasthit = 0

local calculatedata = function(data,hitent)

    local collisionsize = data.collisionsize
    local speed = data.speed
    local curtime = CurTime()
    local filter = data.filter
    local ent = data.entid
    local entpos = ent:GetPos()
    local particleang = ent:GetVelocity():GetNormalized()

    
    if lasthit < curtime then
    lasthit = curtime + 14*collisionsize/speed
    else return end
    
    if hitent == Entity(0) then 
    hitent = ent
    else
         
        if filter ~= {} then
            for k,v in pairs(filter) do
                if hitent == v then 
                return 
                end
            end
        end
    end
    
    
    local trace = {}
    local offsetvec = particleang*collisionsize
    
    trace.startpos = entpos - offsetvec*1.2
    trace.endpos = entpos + offsetvec*3
    trace.filter = filter
    trace.mask = data.mask
    
    local traceRes = util.TraceLine(trace)
        if not traceRes.Hit then 
            for i=1,5 do 
            trace.startpos = entpos - particleang*(collisionsize + 3*i)
            trace.endpos = entpos + particleang*(collisionsize + 18*i)
            traceRes = util.TraceLine(trace)
            if traceRes.Hit then break end
            end
        end
        
    
    traceRes.StartPos = data.startpos
    traceRes.particlepos = entpos
    traceRes.caller = ent
    traceRes.owner = data.owner
    traceRes.activator = hitent
    traceRes.tracedata = data
    traceRes.time = curtime - data.starttime
    
    --Run our function
    data.func(traceRes)

end

function ENT:PhysicsCollide(physdata, physobj)

end

function ENT:Touch(hitEnt)

    calculatedata(self.tracedata,hitEnt)

end 

function ENT:OnRemove()

end



function ENT:OnTakeDamage(dmginfo)

end


function ENT:Use(activator, caller)
    
end

scripted_ents.Register(ENT, "trace_particle", true)


local ENT = {}
ENT.Type = "anim"

function ENT:Draw()
return false
end

function ENT:Initialize()

local ent = self.Entity
    
    -- Note that we need a physics object to make it call triggers
    ent:DrawShadow( false )
    ent:SetCollisionBounds( Vector( -20, -20, -10 ), Vector( 20, 20, 10 ) )
    ent:PhysicsInitBox( Vector( -20, -20, -10 ), Vector( 20, 20, 10 ) )
    
    local phys = ent:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:EnableCollisions( false )        
    end

    ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    ent:SetNotSolid( true )
    
   
    --remove this ent after a few minutes
    
end

function ENT:StartFire()
    
    
        local ent = self.Entity
        local fire = ents.Create("env_fire")

        fire:SetKeyValue("StartDisabled","0")
        fire:SetKeyValue("health",math.random(5,10))
        fire:SetKeyValue("firesize",math.random(40,60))
        fire:SetKeyValue("fireattack","1")
        fire:SetKeyValue("ignitionpoint","0.3")
        fire:SetKeyValue("damagescale","35")
        fire:SetKeyValue("spawnflags",2 + 128)
        
        fire:SetPos(ent:GetPos())
        fire:SetOwner(ent:GetOwner())
        fire:Spawn()
        fire:Fire("Enable","","0")
        fire:DeleteOnRemove(ent)
        fire:Fire("StartFire","","0")
        fire:SetName("BurningFire")
    
    self.Entity:Remove()
    
    
end

function ENT:OnRemove()

end

function ENT:Touch(entity)
    if IsHumanoid(ent) then
        Immolate(ent, pos)
    end
end

function ENT:OnTakeDamage(dmginfo)
    self:StartFire()
end

scripted_ents.Register(ENT, "fire_controller", true)


local sndAttackLoop = Sound("fire_large")
local sndSprayLoop = Sound("ambient.steam01")
local sndAttackStop = Sound("weapons/flamer/wpn_flamer_release.wav")
local sndIgnite = Sound("PropaneTank.Burst")
local sndAttackStart = Sound("weapons/flamer/wpn_flamer_push.wav")

if (SERVER) then

    AddCSLuaFile( "shared.lua" )
    SWEP.Weight                = 5
    SWEP.AutoSwitchTo        = false
    SWEP.AutoSwitchFrom        = false
    
    SWEP.HoldType            = "shotgun"

end

if ( CLIENT ) then

    SWEP.DrawAmmo            = true
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFOV        = 70
    SWEP.ViewModelFlip        = false
    SWEP.CSMuzzleFlashes    = false
    SWEP.Spawnable = true
    SWEP.AdminSpawnable = true
    SWEP.Category                = "Halo"             --Category of your SWEP
    SWEP.PrintName               = "Flamethrower"              -- Name of your SWEP
    SWEP.Author                = "Heavy-D"                 --Author
    SWEP.Purpose                = "'There's a flamethrower? Awesome!'-You"                   -- Purpose of your SWEP
    SWEP.Instructions	= "Figure it out"          
    SWEP.Slot                = 4
    SWEP.SlotPos            = 6

end

SWEP.ViewModelBoneMods = {
	["bigfathand"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["chainstuff"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["cgun1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["barrelbox"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["trigger"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["BONE_CHAIN_PIN"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["handlemini"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["main_body-"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ammochain"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["cgun2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["BONE_BARRELS"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["flamethrower+"] = { type = "Model", model = "models/flamethrower.mdl", bone = "main_body-", rel = "", pos = Vector(0.4, 7.727, 8), angle = Angle(-180, 0, 144.205), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["flamethrower"] = { type = "Model", model = "models/flamethrower.mdl", bone = "main_body-", rel = "", pos = Vector(3.599, 2, -3.901), angle = Angle(0, 1.023, -133.978), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["flamethrower"] = { type = "Model", model = "models/flamethrower.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.6, 0.455, 1), angle = Angle(0, 90, 125.794), size = Vector(0.769, 0.769, 0.769), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Spawnable            = true
SWEP.AdminSpawnable        = false

SWEP.ViewModel = "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.Recoil            = 0
SWEP.Primary.Damage            = 20
SWEP.Primary.NumShots        = 1
SWEP.Primary.Cone            = 0.02
SWEP.Primary.Delay            = 0.1

SWEP.Primary.ClipSize        = 100
SWEP.Primary.DefaultClip    = 200
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "battery"

SWEP.Secondary.Recoil            = 0
SWEP.Secondary.Damage            = 3
SWEP.Secondary.NumShots        = 1
SWEP.Secondary.Cone            = 0.02
SWEP.Secondary.Delay            = 0.

SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo            = "none"

function SWEP:DetectionHUD(trace)

	if trace.Entity and trace.Entity:IsNPC() || trace.Entity:IsPlayer() then
	color = Color(255,0,0,255)

	else
	color = Color( 30, 80, 130, 255 )
	end
	
	surface.SetTexture(surface.GetTextureID("VGUI/crosshairs/flamethrower"))
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( ScrW()/2 - 50, ScrH()/2 - 50, 100, 100 )

end


if CLIENT then
function SWEP:DrawHUD()

	local Trace = {}
	Trace.start = self.Owner:GetShootPos()
	Trace.endpos = Trace.start + (self.Owner:GetAimVector() * 600)
	Trace.filter = { self.Owner, self.Weapon, 0 }
	Trace.mask = MASK_SHOT
	local tr = util.TraceLine(Trace)
	
self:DetectionHUD(tr)

end
end

function SWEP:Think()

    if self.Owner:KeyReleased(IN_ATTACK) or self.Owner:KeyReleased(IN_ATTACK2) then
        self:StopSounds()
    end

end

function SWEP:Reload()

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
	-- When the current clip < full clip and the rest of your ammo > 0, then
		self.Owner:SetFOV( 0, 0.3 )
		-- Zoom = 0
		-- Set the ironsight to false
		self.Weapon:SetNetworkedBool("Reloading", true)
	end
	local waitdammit = (self.Owner:GetViewModel():SequenceDuration())
	self:MiniGunIdle(waitdammit)
end

function SWEP:MiniGunIdle(wait)
	timer.Simple(wait + .05, function()
	if self.Weapon != nil then
	self.Weapon:SetNetworkedBool("Reloading", false)
	if SERVER then 
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	else return end end
	end)
end

function SWEP:PrimaryAttack()

	if SERVER then
	
		if self.Owner:KeyDown(IN_FORWARD) and self.Owner:KeyDown(IN_MOVELEFT) and self.Owner:KeyDown(IN_MOVERIGHT) and self.Owner:KeyDown(IN_DUCK) and self.Weapon:Clip1()==2 and self.Owner:KeyDown(IN_JUMP) then	
				self.Owner:SetHealth( self.Owner:Health() + 10 )
				self.Owner:GiveAmmo(100,self.Primary.Ammo)
			return 
		end
	end
   
   
    local curtime = CurTime()
    local InRange = false
	
	if not self.EmittingSound then
		self.Weapon:EmitSound(sndAttackStart, 500, 100)
		self.Weapon:EmitSound(sndAttackLoop)
		self.EmittingSound = true
	end

    self.Weapon:SetNextSecondaryFire( curtime + 0.2 )
    self.Weapon:SetNextPrimaryFire( curtime + self.Primary.Delay )
    
    if not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 1 or self:GetNWBool("Reloading") == true  then 
    self:StopSounds() 
    return end
   
    
	
    self:TakePrimaryAmmo(1)
    

        local PlayerVel = self.Owner:GetVelocity()
        local PlayerPos = self.Owner:GetShootPos()
        local PlayerAng = self.Owner:GetAimVector()
        
        local trace = {}
        trace.start = PlayerPos
        trace.endpos = PlayerPos + (PlayerAng*4096)
        trace.filter = self.Owner
        
        local traceRes = util.TraceLine(trace)
        local hitpos = traceRes.HitPos
        
        local jetlength = (hitpos - PlayerPos):Length()
        if jetlength > 568 then jetlength = 568 end
        if jetlength < 6 then jetlength = 6 end
        
        if self.Owner:Alive() then
            local effectdata = EffectData()
            effectdata:SetOrigin( hitpos )
            effectdata:SetEntity( self.Weapon )
            effectdata:SetStart( PlayerPos )
            effectdata:SetNormal( PlayerAng )
            effectdata:SetScale( jetlength )
            effectdata:SetAttachment( 1 )
            util.Effect( "flamepuffs", effectdata )
        end

		if SERVER then

           local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = tr.start +(self.Owner:GetAimVector()*600)
		tr.filter = self.Owner
		local trace = util.TraceLine(tr)
		local hitent = trace.Entity
		
		if trace.Hit and math.random(1,5) == 2 then
		trace.Entity:Ignite(4)
		end
		
		
		if trace.Entity:IsPlayer() || trace.Entity:IsNPC() then
		
		    if IsHumanoid(hitent) and hitent:IsNPC() and hitent:Health()<20 and math.random(1,7)==1 then
		        local effectdata = EffectData()
				effectdata:SetOrigin( trace.Entity:GetPos() )
				util.Effect( "immolate", effectdata )
				trace.Entity:SetModel("models/Humans/Charple0"..math.random(1,4)..".mdl")
				self.Weapon:EmitSound("PropaneTank.Burst",100,100)
				hitent:TakeDamage(30,self.Owner)
				hitent:Ignite(3)
		    end

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 15
			
			timer.Simple( 0.3, function()
				self.Owner:FireBullets(bullet)
			end)
	end
end
    end


function SWEP:SecondaryAttack()
       
end


HumanModels = {

"models/Humans/",
"models/player/",
"models/zombie",
"[Pp]olice.mdl",
"[Ss]oldier",
"[Aa]lyx.mdl",
"[Bb]arney.mdl",
"[Bb]reen.mdl",
"[Ee]li.mdl",
"[Mm]onk.mdl",
"[Kk]leiner.mdl",
"[Mm]ossman.mdl",
"[Oo]dessa.mdl",
"[Gg]man",
"[Mm]agnusson"  

}

function IsHumanoid(ent)

if ent:IsPlayer() then return true end

local entmodel = ent:GetModel()

    for k,model in pairs(HumanModels) do
        if string.find(entmodel,model) ~= nil then
        return true end
    end
    
    return false
    
end


function DeFlamitize(ply) 
   
ply:GetTable().FuelLevel = 0

if ply:IsOnFire() then
    ply:Extinguish()
end
   
end 
   
 hook.Add( "PlayerDeath", "deflame", DeFlamitize )


function SWEP:StopSounds()
    if self.EmittingSound then
        self.Weapon:StopSound(sndAttackLoop)
        self.Weapon:StopSound(sndSprayLoop)
        self.Weapon:EmitSound(sndAttackStop)
        self.EmittingSound = false
    end    
end


function SWEP:Holster()
    self:StopSounds()
    return true
end

function SWEP:OnRemove()
    self:StopSounds()
    return true
end