SCHEMA.name = "Halo Roleplay"
SCHEMA.author = "Sixx"
SCHEMA.desc = "In the beginning... You know the end."
SCHEMA.uniqueID = "HaloRP" -- Schema will be a unique identifier stored in the database.
-- Using a uniqueID will allow for renaming the schema folder.

-- Configure some stuff specific to this schema.
nut.currency.SetUp("credit", "credits")
nut.config.menuMusic = "https://youtu.be/TM2YqbsEzp0"

nut.util.Include("sv_hooks.lua")