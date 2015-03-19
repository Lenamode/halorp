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

function SCHEMA:PlayerSpawn(client)
	if (client:Team() == FACTION_MARINE) then
			client:SetArmor(50)
		else
			client:SetArmor(100)
		end
	end


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

