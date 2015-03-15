-- The ranks that belong to the infantry covenant class.
nut.config.cvUnitRanks = {"Minor", "Major", "Ultra"}
-- The ranks that belong to the elite covenant class.
nut.config.cvEliteRanks = {"General.", "Zealot", "Marshal"}
-- The ranks that scanners belong to.
-- The default radio frequency for the UNSC
nut.config.radioFreq = "117.7"
-- The starting weight for inventories.
nut.config.defaultInvWeight = 7.5
-- The rank(s) that are allowed to edit the objectives.
nut.config.objRanks = {"General.", "Zealot", "Marshal"}
-- The delay in second(s) between voice commands.
nut.config.voiceCmdDelay = 1

nut.config.cvRankModels = {
	{"Marshal", "models/npcs/marshall_armour_bad.mdl"},
	{"Zealot", "models/npcs/zealot_armour_bad.mdl"},
	{"General", "models/npcs/general_armour_bad.mdl"},
	{"Ultra", "models/npcs/ultra_armour_good.mdl"},
	{"Major", "models/npcs/specops_armour_bad.mdl"},
	{nut.config.cvUnitRanks, "models/npcs/minor_armour_bad.mdl"}
}

-- Overwrite the default NutScript configs here for our schema.
nut.config.menuMusic = "music/hl2_song27_trainstation2.mp3"