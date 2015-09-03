-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')
require('building_spawner')
require('spawner')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]
    -- Human units
  PrecacheUnitByNameSync("human_king", context)
  PrecacheUnitByNameSync("footman", context)
  PrecacheUnitByNameSync("footman_4", context)
  PrecacheUnitByNameSync("knight", context)
  PrecacheUnitByNameSync("knight_4", context)
  PrecacheUnitByNameSync("human_siege_unit", context)
  PrecacheUnitByNameSync("rifleman", context)
  PrecacheUnitByNameSync("rifleman_4", context)
  PrecacheUnitByNameSync("sorcerer", context)
  PrecacheUnitByNameSync("sorcerer_4", context)
  PrecacheUnitByNameSync("priest", context)
  PrecacheUnitByNameSync("priest_4", context)
    -- Human buildings
  PrecacheUnitByNameSync("human_blacksmith", context)
  PrecacheUnitByNameSync("human_altar_of_strenth", context)
  PrecacheUnitByNameSync("human_building_research_center", context)
  PrecacheUnitByNameSync("human_melee_barracks", context)
  PrecacheUnitByNameSync("human_ranged_barracks", context)

    -- Undead units
  PrecacheUnitByNameSync("undead_king", context)
  PrecacheUnitByNameSync("ghoul", context)
  PrecacheUnitByNameSync("crypt_fiend", context)
    -- Undead buildings
  PrecacheUnitByNameSync("undead_melee_barracks", context)
  PrecacheUnitByNameSync("undead_ranged_barracks", context)

    -- Night Elf units
  PrecacheUnitByNameSync("treant", context)
  PrecacheUnitByNameSync("archer", context)
    -- Night Elf buildings

    -- Orc units
  PrecacheUnitByNameSync("grund", context)
  PrecacheUnitByNameSync("headhunter", context)
    --Orc buildings


    --Models
  PrecacheModel("models/items/hex/sheep_hex/sheep_hex.vmdl", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
end