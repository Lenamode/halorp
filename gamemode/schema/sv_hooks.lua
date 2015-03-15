function SCHEMA:GetDefaultInv(inventory, client, data)
	-- PrintTable(data) to see what information it contains.
	
	if (data.faction == FACTION_RECRUIT) then
		inventory:Add("cid", 1, {
			Digits = math.random(11111, 99999),
			Owner = data.charname
		})
end
if (data.faction == FACTION_MARINE or data.faction == FACTION_ODST) then
			inventory:Add("assaultrifle", 1)
			inventory:Add("AR Rounds", 1)

		end	

	end
end

-- Called when the default armour is needed
function SCHEMA:PlayerSpawn(client)
	if (client:Team() == FACTION_SPARTAN) then
			client:SetArmor(100)
		else
			client:SetArmor(200)
		end
	end
-- Big guys

function SCHEMA:PlayerSpawn(client)
	if (client:Team() == FACTION_ODST) then
			client:SetArmor(70)
		else
			client:SetArmor(150)
		end
	end
-- Baby Spartans

function SCHEMA:PlayerSpawn(client)
	if (client:Team() == FACTION_MARINE) then
			client:SetArmor(50)
		else
			client:SetArmor(100)
		end
	end
-- Prevents death by way of noscope NPC

function SCHEMA:PlayerFootstep(client, position, foot, soundName, volume)
	if (client:IsRunning()) then
		if (client:Team() == FACTION_SPARTAN) then
			client:EmitSound("npc/metropolice/gear"..math.random(1, 6)..".wav", 50) 		--cuz they're heavier innit

			return true
		elseif (client:Team() == FACTION_ODST) then
			client:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav", 40)		 --bc they're odst scumbags m8

			return true
		end
	end
end


function SCHEMA:PlayerSpawn(client)
	print("Hello, world.")
end
