-- The 'nice' name of the faction.
FACTION.name = "ODST"
-- A description used in tooltips in various menus.
FACTION.desc = "Orbital Drop Shock Troopers. Baby Spartans, basically."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(70, 70, 220)
-- Set the male model choices for character creation.
FACTION.maleModels = {
		"models/odststandard.mdl",
		"models/odstcqb.mdl",
		"models/odstsniper.mdl",
		"models/odstpilot.mdl",
}
-- Set the female models to be the same as male models.
FACTION.femaleModels = FACTION.maleModels
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_ODST = FACTION.index
