if Spawner == nil then
    _G.Spawner = class({})
end

--[[Human units
=============================================================================================================]]
function Spawner:SpawnHumanWaves()
    local human_waypoint_1 = Entities:FindByName(nil, "human_waypoint_undead_side")
    local human_waypoint_2 = Entities:FindByName(nil, "human_waypoint_orc_side")
    local human_waypoint_3 = Entities:FindByName(nil, "human_waypoint_night_elf_side")

    local footmans = 4
    local knights = 1
    local siege_engines = 1
    local riflemans = 1
    local sorcerrers = 1
    local healers = 1
    local team = DOTA_TEAM_GOODGUYS

    --Loop trough all human buildings and check the levels of all the abilities then add unit level and new units to spawn
    for position, building in ipairs(humanBuildings) do
        
        local ability_1
        local ability_2
        local ability_3
        local ability_4

        if IsValidEntity(building) then 
            ability_1 = building:GetAbilityByIndex(0):GetLevel()
            ability_2 = building:GetAbilityByIndex(1):GetLevel()
            ability_3 = building:GetAbilityByIndex(2):GetLevel()
            ability_4 = building:GetAbilityByIndex(3):GetLevel()
        else
            ability_1 = humanBuildingAbilities[position][1]
            ability_2 = humanBuildingAbilities[position][2]
            ability_3 = humanBuildingAbilities[position][3]
            ability_4 = humanBuildingAbilities[position][4]
        end
        
        local waypoint
        if humanBuildings[position] == humanBuildings[1] or humanBuildings[position] == humanBuildings[2] then
            waypoint = human_waypoint_1
        elseif humanBuildings[position] == humanBuildings[3] or humanBuildings[position] == humanBuildings[4] then
            waypoint = human_waypoint_2
        elseif humanBuildings[position] == humanBuildings[5] or humanBuildings[position] == humanBuildings[6] then
            waypoint = human_waypoint_3
        end

        if position % 2 ~= 0 then
            if ability_1 >= 2 then
                Spawner:SpawnAndMoveAtPosition(footmans, ("footman_"..ability_1), humanSpawners[position], waypoint, team)
            else
                Spawner:SpawnAndMoveAtPosition(footmans, "footman", humanSpawners[position], waypoint, team)
            end 
            if ability_4 > 2 then
                if ability_2 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(knights, ("knight_"..ability_2), humanSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(knights, "knight", humanSpawners[position], waypoint, team)
                end
            end
            if ability_4 > 3 then
                Spawner:SpawnAndMoveAtPosition(siege_engines, "human_siege_engine", humanSpawners[position], waypoint, team)
            end
        end

        if position % 2 == 0 then
            if ability_1 >= 2 then
                Spawner:SpawnAndMoveAtPosition(riflemans, ("rifleman_"..ability_1), humanSpawners[position], waypoint, team)
            else
                Spawner:SpawnAndMoveAtPosition(riflemans, "rifleman", humanSpawners[position], waypoint, team)
            end
            if ability_4 > 2 then
                if ability_2 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(sorcerrers, ("sorcerer_"..ability_2), humanSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(sorcerrers, "sorcerer", humanSpawners[position], waypoint, team)
                end
            end
            if ability_4 > 3 then
                if ability_3 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(sorcerrers, ("priest_"..ability_3), humanSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(sorcerrers, "priest", humanSpawners[position], waypoint, team)
                end
            end
        end
    end
end

--[[Undead units
=============================================================================================================]]
function Spawner:SpawnUndeadWaves()
    local undead_waypoint_1 = Entities:FindByName(nil, "undead_waypoint_night_elf_side")
    local undead_waypoint_2 = Entities:FindByName(nil, "undead_waypoint_human_side")
    local undead_waypoint_3 = Entities:FindByName(nil, "undead_waypoint_orc_side")
    local ghouls = 4
    local abominations = 1
    local meat_wagons = 1
    local crypt_fiends = 1
    local banshees = 1
    local necromancers = 1
    local team = DOTA_TEAM_BADGUYS

    --Loop trough all human buildings and check the levels of all the abilities then add unit level and new units to spawn
    for position, building in ipairs(undeadBuildings) do
        
        local ability_1
        local ability_2
        local ability_3
        local ability_4

        if IsValidEntity(building) then 
            ability_1 = building:GetAbilityByIndex(0):GetLevel()
            ability_2 = building:GetAbilityByIndex(1):GetLevel()
            ability_3 = building:GetAbilityByIndex(2):GetLevel()
            ability_4 = building:GetAbilityByIndex(3):GetLevel()
        else
            ability_1 = undeadBuildingAbilities[position][1]
            ability_2 = undeadBuildingAbilities[position][2]
            ability_3 = undeadBuildingAbilities[position][3]
            ability_4 = undeadBuildingAbilities[position][4]
        end
        
        local waypoint
        if undeadBuildings[position] == undeadBuildings[1] or undeadBuildings[position] == undeadBuildings[2] then
            waypoint = undead_waypoint_1
        elseif undeadBuildings[position] == undeadBuildings[3] or undeadBuildings[position] == undeadBuildings[4] then
            waypoint = undead_waypoint_2
        elseif undeadBuildings[position] == undeadBuildings[5] or undeadBuildings[position] == undeadBuildings[6] then
            waypoint = undead_waypoint_3
        end

        if position % 2 ~= 0 then
            if ability_1 >= 2 then
                Spawner:SpawnAndMoveAtPosition(ghouls, ("ghoul_"..ability_1), undeadSpawners[position], waypoint, team)
            else
                Spawner:SpawnAndMoveAtPosition(ghouls, "ghoul", undeadSpawners[position], waypoint, team)
            end 
            if ability_4 > 2 then
                if ability_2 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(abominations, ("abomination_"..ability_2), undeadSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(abominations, "abomination", undeadSpawners[position], waypoint, team)
                end
            end
            if ability_4 > 3 then
                Spawner:SpawnAndMoveAtPosition(meat_wagons, "undead_meat_wagon", undeadSpawners[position], waypoint, team)
            end
        end

        if position % 2 == 0 then
            if ability_1 >= 2 then
                Spawner:SpawnAndMoveAtPosition(crypt_fiends, ("crypt_fiend_"..ability_1), undeadSpawners[position], waypoint, team)
            else
                Spawner:SpawnAndMoveAtPosition(crypt_fiends, "crypt_fiend", undeadSpawners[position], waypoint, team)
            end
            if ability_4 > 2 then
                if ability_2 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(banshees, ("banshee_"..ability_2), undeadSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(banshees, "banshee", undeadSpawners[position], waypoint, team)
                end
            end
            if ability_4 > 3 then
                if ability_3 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(necromancers, ("necromancer_"..ability_3), undeadSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(necromancers, "necromancer", undeadSpawners[position], waypoint, team)
                end
            end
        end
    end
end

--[[Night Elf units
=============================================================================================================]]
function Spawner:SpawnNightElfWaves()
    local night_elf_mele_spawn_point_1 = Entities:FindByName( nil, "night_elf_mele_spawner_1"):GetAbsOrigin()
    local night_elf_mele_spawn_point_2 = Entities:FindByName( nil, "night_elf_mele_spawner_2"):GetAbsOrigin()
    local night_elf_mele_spawn_point_3 = Entities:FindByName( nil, "night_elf_mele_spawner_3"):GetAbsOrigin()
    local night_elf_range_spawn_point_1 = Entities:FindByName( nil, "night_elf_range_spawner_1"):GetAbsOrigin()
    local night_elf_range_spawn_point_2 = Entities:FindByName( nil, "night_elf_range_spawner_2"):GetAbsOrigin()
    local night_elf_range_spawn_point_3 = Entities:FindByName( nil, "night_elf_range_spawner_3"):GetAbsOrigin()
    local night_elf_waypoint_1 = Entities:FindByName(nil, "night_elf_waypoint_orc_side")
    local night_elf_waypoint_2 = Entities:FindByName(nil, "night_elf_waypoint_undead_side")
    local night_elf_waypoint_3 = Entities:FindByName(nil, "night_elf_waypoint_human_side")
    local mele_units_to_spawn = 4
    local range_units_to_spawn = 1
    local team = DOTA_TEAM_CUSTOM_1

    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "treant", night_elf_mele_spawn_point_1, night_elf_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "treant", night_elf_mele_spawn_point_2, night_elf_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "treant", night_elf_mele_spawn_point_3, night_elf_waypoint_3, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "archer", night_elf_range_spawn_point_1, night_elf_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "archer", night_elf_range_spawn_point_2, night_elf_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "archer", night_elf_range_spawn_point_3, night_elf_waypoint_3, team)
end

--[[Orc units
=============================================================================================================]]
function Spawner:SpawnOrcWaves()
    local orc_mele_spawn_point_1 = Entities:FindByName( nil, "orc_mele_spawner_1"):GetAbsOrigin()
    local orc_mele_spawn_point_2 = Entities:FindByName( nil, "orc_mele_spawner_2"):GetAbsOrigin()
    local orc_mele_spawn_point_3 = Entities:FindByName( nil, "orc_mele_spawner_3"):GetAbsOrigin()
    local orc_range_spawn_point_1 = Entities:FindByName( nil, "orc_range_spawner_1"):GetAbsOrigin()
    local orc_range_spawn_point_2 = Entities:FindByName( nil, "orc_range_spawner_2"):GetAbsOrigin()
    local orc_range_spawn_point_3 = Entities:FindByName( nil, "orc_range_spawner_3"):GetAbsOrigin()
    local orc_waypoint_1 = Entities:FindByName(nil, "orc_waypoint_human_side")
    local orc_waypoint_2 = Entities:FindByName(nil, "orc_waypoint_night_elf_side")
    local orc_waypoint_3 = Entities:FindByName(nil, "orc_waypoint_undead_side")
    local mele_units_to_spawn = 4
    local range_units_to_spawn = 1
    local team = DOTA_TEAM_CUSTOM_2

    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "grund", orc_mele_spawn_point_1, orc_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "grund", orc_mele_spawn_point_2, orc_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "grund", orc_mele_spawn_point_3, orc_waypoint_3, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "headhunter", orc_range_spawn_point_1, orc_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "headhunter", orc_range_spawn_point_2, orc_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "headhunter", orc_range_spawn_point_3, orc_waypoint_3, team)
end

function Spawner:SpawnAndMoveAtPosition( units_to_spawn, unit_name, spawn_point, waypoint, team )
    for i=1, units_to_spawn do
        Timers:CreateTimer(function()
            local unit = CreateUnitByName(unit_name, spawn_point+RandomVector(RandomInt(100,200)), true, nil, nil, team) --Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
            -- Give order to this unit
            unit:SetInitialGoalEntity(waypoint) -- The unit will fallow the path_corner links after this waypoint
            
            if team == DOTA_TEAM_GOODGUYS then
                -- Loop trough the blacksmith abilities and apply their modifiers to the unit
                local blacksmith = humanUpgradeBuildings[1]
                for i=0, 3 do
                    local ability = blacksmith:GetAbilityByIndex(i)
                    local ability_name = ability:GetName()
                    local ability_level = blacksmith:GetAbilityByIndex(i):GetLevel()
                    if ability_level > 1 then
                        ability:ApplyDataDrivenModifier(blacksmith, unit, (ability_name.."_modifier"), nil)
                        unit:SetModifierStackCount((ability_name.."_modifier"), blacksmith, (ability_level - 1))
                    end
                end
            end

            if team == DOTA_TEAM_BADGUYS then
            end
        end)
    end
end