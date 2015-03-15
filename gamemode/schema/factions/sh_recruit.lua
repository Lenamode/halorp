-- The 'nice' name of the faction.
FACTION.name = "Recruit"
-- A description used in tooltips in various menus.
FACTION.desc = "The UNSCMC Recruits."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(20, 150, 15)
FACTION.modelsMale = {
		"models/dougan/blue002/male_01.mdl",
		"models/dougan/blue002/male_02.mdl",
		"models/dougan/blue002/male_03.mdl",
		"models/dougan/blue002/male_04.mdl",
		"models/dougan/blue002/male_05.mdl",
		"models/dougan/blue002/male_06.mdl",
		"models/dougan/blue002/male_07.mdl",
		"models/dougan/blue002/male_08.mdl",
		"models/dougan/blue002/male_09.mdl",
}
FACTION.modelsFemale = {
		"models/Humans/Group01/Female_01.mdl",
		"models/Humans/Group01/Female_02.mdl",
		"models/Humans/Group01/Female_03.mdl",
		"models/Humans/Group01/Female_04.mdl",
		"models/Humans/Group01/Female_05.mdl",
		"models/Humans/Group01/Female_06.mdl",
		"models/Humans/Group01/Female_07.mdl",
		"models/Humans/Group01/Female_08.mdl",
		"models/Humans/Group01/Female_09.mdl",
}
-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_RECRUIT = FACTION.index
