require("unitAI/human_king_ai")

if BuildingSpawner == nil then
    _G.BuildingSpawner = class({})
end

function BuildingSpawner:CreateHumanBuildings()
    local team = DOTA_TEAM_GOODGUYS
    local king_spawn_point = Entities:FindByName(nil, "human_king"):GetAbsOrigin()
    local human_blacksmith_position = Entities:FindByName(nil, "human_blacksmith"):GetAbsOrigin()
    local melee_barracks_1 = Entities:FindByName(nil, "human_melee_barracks_1"):GetAbsOrigin()
    local ranged_barracks_1 = Entities:FindByName(nil, "human_ranged_barracks_1"):GetAbsOrigin()
    local melee_barracks_2 = Entities:FindByName(nil, "human_melee_barracks_2"):GetAbsOrigin()
    local ranged_barracks_2 = Entities:FindByName(nil, "human_ranged_barracks_2"):GetAbsOrigin()
    local melee_barracks_mid = Entities:FindByName(nil, "human_melee_barracks_mid"):GetAbsOrigin()
    local ranged_barracks_mid = Entities:FindByName(nil, "human_ranged_barracks_mid"):GetAbsOrigin()

    BuildingSpawner:CreateBuldingAtPosition("human_king", king_spawn_point, team)
    BuildingSpawner:CreateBuldingAtPosition("human_blacksmith", human_blacksmith_position, team)
    BuildingSpawner:CreateBuldingAtPosition("human_melee_barracks", melee_barracks_1, team)
    BuildingSpawner:CreateBuldingAtPosition("human_ranged_barracks", ranged_barracks_1, team)
    BuildingSpawner:CreateBuldingAtPosition("human_melee_barracks", melee_barracks_2, team)
    BuildingSpawner:CreateBuldingAtPosition("human_ranged_barracks", ranged_barracks_2, team)
    BuildingSpawner:CreateBuldingAtPosition("human_melee_barracks", melee_barracks_mid, team)
    BuildingSpawner:CreateBuldingAtPosition("human_ranged_barracks", ranged_barracks_mid, team)

end

function BuildingSpawner:CreateUndeadBuildings()
    local king_spawn_point = Entities:FindByName(nil, "undead_base"):GetAbsOrigin()
    local melee_barracks_1_spawn_point = Entities:FindByName(nil, "undead_melee_barracks_1"):GetAbsOrigin()
    local melee_barracks_2_spawn_point = Entities:FindByName(nil, "undead_melee_barracks_2"):GetAbsOrigin()
    local ranged_barracks_1_spawn_point = Entities:FindByName(nil, "undead_ranged_barracks_1"):GetAbsOrigin()
    local ranged_barracks_2_spawn_point = Entities:FindByName(nil, "undead_ranged_barracks_2"):GetAbsOrigin()
    local team = DOTA_TEAM_BADGUYS

    BuildingSpawner:CreateBuldingAtPosition("undead_king", king_spawn_point, team)
    BuildingSpawner:CreateBuldingAtPosition("undead_melee_barracks", melee_barracks_1_spawn_point, team)
    BuildingSpawner:CreateBuldingAtPosition("undead_melee_barracks", melee_barracks_2_spawn_point, team)
    BuildingSpawner:CreateBuldingAtPosition("undead_ranged_barracks", ranged_barracks_1_spawn_point, team)
    BuildingSpawner:CreateBuldingAtPosition("undead_ranged_barracks", ranged_barracks_2_spawn_point, team)
end

function BuildingSpawner:CreateBuldingAtPosition(building_name, building_location, team)
    local building = CreateUnitByName(building_name, building_location, false, nil, nil, team) --Returns:handle ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
    building:SetHasInventory(true)

    if team == DOTA_TEAM_GOODGUYS then
        if building_name == "human_king" then
            --Set the Human King AI system
            HumanKingAI:MakeInstance( building, { spawnPos = building_location, aggroRange = 800, leashRange = 1200 } )
        end

        if building_name == "human_melee_barracks" then
            -- Abilities for unit upgrades
            building:AddAbility("human_footman_upgrade"):SetLevel(0)
            building:AddAbility("human_knight_upgrade"):SetLevel(0)
            building:AddAbility("human_siege_unit_disabled"):SetLevel(0)
            building:AddAbility("human_melee_barracks_upgrade"):SetLevel(1)

            -- Items to spawn extra units
            building:AddItemByName("item_spawn_footman")
            building:AddItemByName("item_spawn_knight")
            building:AddItemByName("item_spawn_siege_unit")
        end

        if building_name == "human_ranged_barracks" then
            -- Abilities for unit upgrades
            building:AddAbility("human_rifleman_upgrade"):SetLevel(0)
            building:AddAbility("human_sorcerer_upgrade"):SetLevel(0)
            building:AddAbility("human_priest_upgrade"):SetLevel(0)
            building:AddAbility("human_ranged_barracks_upgrade"):SetLevel(1)

            -- Items to spawn extra units
            building:AddItemByName("item_spawn_rifleman")
            building:AddItemByName("item_spawn_sorcerer")
            building:AddItemByName("item_spawn_priest")
        end
        if building_name ~= "human_king" and building_name ~= "human_blacksmith" then
            table.insert(humanBuildings, building)
            print("The building: "..building_name.." is created and added into humanBuildings, table number: "..#humanBuildings)
        end
    end
end
