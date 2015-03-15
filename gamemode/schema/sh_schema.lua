SCHEMA.name = "Halo Roleplay"
SCHEMA.author = "Sixx"
SCHEMA.desc = "In the beginning... You know the end."
SCHEMA.uniqueID = "HaloRP" -- Schema will be a unique identifier stored in the database.

function SCHEMA:IsSpartanFaction(faction)
 	return faction == FACTION_SPARTAN
end

nut.currency.SetUp("credit", "credits")
nut.config.menuMusic = "song/kickinhead.mp3"
nut.config.mainColor = Color(255, 137, 0)
nut.util.Include("sv_hooks.lua")
nut.util.Include("sv_schema.lua")
nut.util.Include("sh_config.lua")