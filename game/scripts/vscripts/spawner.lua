if Spawner == nil then
    _G.Spawner = class({})
end

--[[Human units
=============================================================================================================]]
function Spawner:SpawnHumanWaves()
    local human_waypoint_1 = Entities:FindByName(nil, "human_waypoint_undead_side")
    local human_waypoint_2 = Entities:FindByName(nil, "human_waypoint_orc_side")
    local human_waypoint_3 = Entities:FindByName(nil, "human_waypoint_night_elf_side")

    local footmans_to_spawn = 4
    local knights_to_spawn = 1
    local siege_units_to_spawn = 1
    local riflemans_to_spawn = 1
    local sorcerrers_to_spawn = 1
    local healers_to_spawn = 1
    local team = DOTA_TEAM_GOODGUYS

    --Loop trough all human buildings and check the levels of all the abilities then add unit level and new units to spawn
    for position, building in ipairs(humanBuildings) do
        print(position, building)
        local ability_1 = building:GetAbilityByIndex(0):GetLevel()
        local ability_2 = building:GetAbilityByIndex(1):GetLevel()
        local ability_3 = building:GetAbilityByIndex(2):GetLevel()
        local ability_4 = building:GetAbilityByIndex(3):GetLevel()
        
        local waypoint = nil
        if humanBuildings[position] == humanBuildings[1] or humanBuildings[position] == humanBuildings[2] then
            waypoint = human_waypoint_1
        elseif humanBuildings[position] == humanBuildings[3] or humanBuildings[position] == humanBuildings[4] then
            waypoint = human_waypoint_2
        elseif humanBuildings[position] == humanBuildings[5] or humanBuildings[position] == humanBuildings[6] then
            waypoint = human_waypoint_3
        end

        if building:GetUnitName() == "human_melee_barracks" then
            if ability_1 >= 2 then
                Spawner:SpawnAndMoveAtPosition(footmans_to_spawn, ("footman_"..ability_1), humanSpawners[position], waypoint, team)
            else
                Spawner:SpawnAndMoveAtPosition(footmans_to_spawn, "footman", humanSpawners[position], waypoint, team)
            end 
            if ability_4 > 2 then
                if ability_2 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(knights_to_spawn, ("knight_"..ability_2), humanSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(knights_to_spawn, "knight", humanSpawners[position], waypoint, team)
                end
            end
            if ability_4 > 3 then
                Spawner:SpawnAndMoveAtPosition(siege_units_to_spawn, "human_siege_unit", humanSpawners[position], waypoint, team)
            end
        end

        if building:GetUnitName() == "human_ranged_barracks" then
            if ability_1 >= 2 then
                Spawner:SpawnAndMoveAtPosition(riflemans_to_spawn, ("rifleman_"..ability_1), humanSpawners[position], waypoint, team)
            else
                Spawner:SpawnAndMoveAtPosition(riflemans_to_spawn, "rifleman", humanSpawners[position], waypoint, team)
            end
            if ability_4 > 2 then
                if ability_2 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(sorcerrers_to_spawn, ("sorcerer_"..ability_2), humanSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(sorcerrers_to_spawn, "sorcerer", humanSpawners[position], waypoint, team)
                end
            end
            if ability_4 > 3 then
                if ability_3 >= 2 then
                    Spawner:SpawnAndMoveAtPosition(sorcerrers_to_spawn, ("priest_"..ability_3), humanSpawners[position], waypoint, team)
                else
                    Spawner:SpawnAndMoveAtPosition(sorcerrers_to_spawn, "priest", humanSpawners[position], waypoint, team)
                end
            end
        end
    end
end

--[[Undead units
=============================================================================================================]]
function Spawner:SpawnUndeadWaves()
    local undead_mele_spawn_point_1 = Entities:FindByName( nil, "undead_mele_spawner_1"):GetAbsOrigin()
    local undead_mele_spawn_point_2 = Entities:FindByName( nil, "undead_mele_spawner_2"):GetAbsOrigin()
    local undead_range_spawn_point_1 = Entities:FindByName( nil, "undead_range_spawner_1"):GetAbsOrigin()
    local undead_range_spawn_point_2 = Entities:FindByName( nil, "undead_range_spawner_2"):GetAbsOrigin()
    local undead_waypoint_1 = Entities:FindByName(nil, "undead_waypoint_night_elf_side")
    local undead_waypoint_2 = Entities:FindByName(nil, "undead_waypoint_human_side")
    local mele_units_to_spawn = 20
    local range_units_to_spawn = 1
    local team = DOTA_TEAM_BADGUYS

    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "ghoul", undead_mele_spawn_point_1, undead_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "crypt_fiend", undead_range_spawn_point_1, undead_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "ghoul", undead_mele_spawn_point_2, undead_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "crypt_fiend", undead_range_spawn_point_2, undead_waypoint_2, team)
end

--[[Night Elf units
=============================================================================================================]]
function Spawner:SpawnNightElfWaves()
    local night_elf_mele_spawn_point_1 = Entities:FindByName( nil, "night_elf_mele_spawner_1"):GetAbsOrigin()
    local night_elf_mele_spawn_point_2 = Entities:FindByName( nil, "night_elf_mele_spawner_2"):GetAbsOrigin()
    local night_elf_range_spawn_point_1 = Entities:FindByName( nil, "night_elf_range_spawner_1"):GetAbsOrigin()
    local night_elf_range_spawn_point_2 = Entities:FindByName( nil, "night_elf_range_spawner_2"):GetAbsOrigin()
    local night_elf_waypoint_1 = Entities:FindByName(nil, "orc_base"):GetAbsOrigin()
    local night_elf_waypoint_2 = Entities:FindByName(nil, "undead_base"):GetAbsOrigin()
    local mele_units_to_spawn = 4
    local range_units_to_spawn = 1
    local team = DOTA_TEAM_CUSTOM_1

    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "treant", night_elf_mele_spawn_point_1, night_elf_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "treant", night_elf_mele_spawn_point_2, night_elf_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "archer", night_elf_range_spawn_point_1, night_elf_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "archer", night_elf_range_spawn_point_2, night_elf_waypoint_2, team)
end

--[[Orc units
=============================================================================================================]]
function Spawner:SpawnOrcWaves()
    local orc_mele_spawn_point_1 = Entities:FindByName( nil, "orc_mele_spawner_1"):GetAbsOrigin()
    local orc_mele_spawn_point_2 = Entities:FindByName( nil, "orc_mele_spawner_2"):GetAbsOrigin()
    local orc_range_spawn_point_1 = Entities:FindByName( nil, "orc_range_spawner_1"):GetAbsOrigin()
    local orc_range_spawn_point_2 = Entities:FindByName( nil, "orc_range_spawner_2"):GetAbsOrigin()
    local orc_waypoint_1 = Entities:FindByName(nil, "human_king"):GetAbsOrigin()
    local orc_waypoint_2 = Entities:FindByName(nil, "night_elf_base"):GetAbsOrigin()
    local mele_units_to_spawn = 4
    local range_units_to_spawn = 1
    local team = DOTA_TEAM_CUSTOM_2

    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "grund", orc_mele_spawn_point_1, orc_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(mele_units_to_spawn, "grund", orc_mele_spawn_point_2, orc_waypoint_2, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "headhunter", orc_range_spawn_point_1, orc_waypoint_1, team)
    Spawner:SpawnAndMoveAtPosition(range_units_to_spawn, "headhunter", orc_range_spawn_point_2, orc_waypoint_2, team)
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
        end)
    end
end