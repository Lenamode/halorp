FACTION.name = "ONI"
FACTION.desc = "The Office of Naval Intelligence."
FACTION.color = Color(70, 70, 220)
-- Set the male model choices for character creation.
FACTION.femaleModels = {
		"models/lt_c/sci_fi/humans/female_01.mdl",
		"models/lt_c/sci_fi/humans/female_02.mdl",
		"models/lt_c/sci_fi/humans/female_03.mdl",
		"models/lt_c/sci_fi/humans/female_04.mdl",
		"models/lt_c/sci_fi/humans/female_05.mdl",
		"models/lt_c/sci_fi/humans/female_06.mdl",
		"models/lt_c/sci_fi/humans/female_07.mdl",		
}
FACTION.maleModels = {
		"models/lt_c/sci_fi/humans/male_01.mdl",
		"models/lt_c/sci_fi/humans/male_02.mdl",
		"models/lt_c/sci_fi/humans/male_03.mdl",
		"models/lt_c/sci_fi/humans/male_04.mdl",
		"models/lt_c/sci_fi/humans/male_05.mdl",
		"models/lt_c/sci_fi/humans/male_06.mdl",
		"models/lt_c/sci_fi/humans/male_07.mdl",
}

-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_ONI = FACTION.index
