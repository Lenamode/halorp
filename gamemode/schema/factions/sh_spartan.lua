-- The 'nice' name of the faction.
FACTION.name = "SPARTAN III"
-- A description used in tooltips in various menus.
FACTION.desc = "The true warriors of the UNSC."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(70, 70, 220)
-- Set the male model choices for character creation.
FACTION.femaleModels = {
		"models/halo/unsc/characters/playermodels/female/cqb_02.mdl",
		"models/halo/unsc/characters/playermodels/female/eva_01.mdl",
		"models/halo/unsc/characters/playermodels/female/kat_01.mdl",
	"models/halo/unsc/characters/playermodels/female/markvb_02.mdl",			
}
FACTION.maleModels = {
		"models/halo/unsc/characters/playermodels/male/cqb_01.mdl",
		"models/halo/unsc/characters/playermodels/male/eva_02.mdl",
		"models/halo/unsc/characters/playermodels/male/kat_02.mdl",
	"models/halo/unsc/characters/playermodels/male/markvb_01.mdl",
}

-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_SPARTAN = FACTION.index
