AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Talker"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.Category = "NutScript"

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/mossman.mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)
		self:DropToFloor()

		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
			physicsObject:Sleep()
		end
	else
		self:CreateBubble()
	end

	self:SetAnim()
end

function ENT:SetAnim()
	for k, v in pairs(self:GetSequenceList()) do
		if (string.find(string.lower(v), "idle")) then
			if (v != "idlenoise") then
				self:ResetSequence(k)

				return
			end
		end
	end

	self:ResetSequence(4)
end

if (CLIENT) then
	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Think()
		if (!IsValid(self.bubble)) then
			self:CreateBubble()
		end

		self:SetEyeTarget(LocalPlayer():GetPos())
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetAngles(Angle(0, realTime * 120, 0))
			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.03))
		end

		self:DrawModel()
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end

	netstream.Hook("nut_DialogueEditor", function(data)
		if (IsValid(nut.gui.edialogue)) then
			nut.gui.dialogue:Remove()
			return
		end
		nut.gui.edialogue = vgui.Create("Nut_DialogueEditor")
		nut.gui.edialogue:Center()
		nut.gui.edialogue:SetEntity(data)
	end)
	
	netstream.Hook("nut_Dialogue", function(data)
		if (IsValid(nut.gui.dialogue)) then
			nut.gui.dialogue:Remove()
			return
		end
		nut.gui.dialogue = vgui.Create("Nut_Dialogue")
		nut.gui.dialogue:Center()
		nut.gui.dialogue:SetEntity(data)
	end)
else
	function ENT:Use(activator)
		local factionData = self:GetNetVar("factiondata", {})
		if (!factionData[activator:Team()]) then
			activator:ChatPrint( nut.lang.Get( "talker_refuse", self:GetNetVar( "name", "John Doe" ) ) )
			return
		end
		netstream.Start(activator, "nut_Dialogue", self)
	end

	netstream.Hook("nut_DialogueData", function( client, data )
		if (!client:IsAdmin()) then
			return
		end
		local entity = data[1]
		local dialogue = data[2]
		local factionData = data[3]
		local classData = data[4]
		local name = data[5]
		local desc = data[6]
		local model = data[7]

		
		if (IsValid(entity)) then
			entity:SetNetVar("dialogue", dialogue)
			entity:SetNetVar("factiondata", factionData)
			entity:SetNetVar("classdata", classData)
			entity:SetNetVar("name", name)
			entity:SetNetVar("desc", desc)
			entity:SetModel(model)
			entity:SetAnim()

			nut.util.Notify("You have updated this talking npc's data.", client)
		end
	end)

end