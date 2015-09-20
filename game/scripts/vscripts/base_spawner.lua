require("unitAI/human_king_ai")
require("unitAI/undead_king_ai")

if Base == nil then
    _G.Base = class({})
end

function Base:CreateHumanBase()
    local team = DOTA_TEAM_GOODGUYS
    local king_spawn_point = Entities:FindByName(nil, "human_king"):GetAbsOrigin()
    local human_blacksmith_position = Entities:FindByName(nil, "human_blacksmith"):GetAbsOrigin()
    local human_research_facility_position = Entities:FindByName(nil, "human_research_facility"):GetAbsOrigin()

    Base:Spawn("human_king", king_spawn_point, team)
    Base:Spawn("human_blacksmith", human_blacksmith_position, team)
    Base:Spawn("human_research_facility", human_research_facility_position, team)

    -- Spawn the barracks
    for i=1,3 do
        local melee_rax_position = Entities:FindByName(nil, ("human_melee_barracks_"..i)):GetAbsOrigin()
        local ranged_rax_position = Entities:FindByName(nil, ("human_ranged_barracks_"..i)):GetAbsOrigin()

        Base:Spawn("human_melee_barracks", melee_rax_position, team)
        Base:Spawn("human_ranged_barracks", ranged_rax_position, team)

    end

    -- Spawn the guards
    for i=1,6 do
        local melee_guard_position = Entities:FindByName(nil, ("human_melee_guard_"..i)):GetAbsOrigin()
        local ranged_guard_position = Entities:FindByName(nil, ("human_ranged_guard_"..i)):GetAbsOrigin()

        Base:Spawn("human_melee_guard", melee_guard_position, team)
        Base:Spawn("human_ranged_guard", ranged_guard_position, team)
    end

    -- Set the Forward Vector
    for i = 1, 5 do
        humanBuildings[i]:SetForwardVector(humanSpawners[i + 1] * (-1))
        humanBuildings[i + 1]:SetForwardVector(humanSpawners[i] * (-1))
        i = i + 2
    end
end

function Base:CreateUndeadBase()
    local team = DOTA_TEAM_BADGUYS

    local king_spawn_point = Entities:FindByName(nil, "undead_king"):GetAbsOrigin()
    Base:Spawn("undead_king", king_spawn_point, team)

    for i=1,3 do
        local melee_rax_position = Entities:FindByName(nil, ("undead_melee_barracks_"..i)):GetAbsOrigin()
        local ranged_rax_position = Entities:FindByName(nil, ("undead_ranged_barracks_"..i)):GetAbsOrigin()

        Base:Spawn("undead_melee_barracks", melee_rax_position, team)
        Base:Spawn("undead_ranged_barracks", ranged_rax_position, team)
    end
end

function Base:Spawn(unit_name, unit_location, team)
    local unit = CreateUnitByName(unit_name, unit_location, false, nil, nil, team) --Returns:handle ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
    
    if team == DOTA_TEAM_GOODGUYS then
        if unit_name == "human_king" then
            unit:SetForwardVector(Vector(0.250427, 0.935186,  0.250426))
            --Start the Human King AI system
            HumanKingAI:MakeInstance( unit, { spawnPos = unit_location, aggroRange = 800, leashRange = 1200 } )
        end

        -- Add upgrade abilities and spawn items to the barracks
        if unit_name == "human_melee_barracks" then
            unit:AddAbility("human_footman_upgrade"):SetLevel(0)
            unit:AddAbility("human_knight_upgrade"):SetLevel(0)
            unit:AddAbility("human_siege_unit_disabled"):SetLevel(0)
            unit:AddAbility("human_melee_barracks_upgrade"):SetLevel(1)
            unit:AddAbility("building_magic_immune"):SetLevel(1)

            unit:AddItemByName("item_spawn_footman")
            unit:AddItemByName("item_spawn_knight")
            unit:AddItemByName("item_spawn_siege_unit")

            unit:SetHasInventory(true)

            table.insert(humanBuildings, unit)
            print("The building: "..unit_name.." is created and added into humanBuildings, table number: "..#humanBuildings)
        end

        if unit_name == "human_ranged_barracks" then
            unit:AddAbility("human_rifleman_upgrade"):SetLevel(0)
            unit:AddAbility("human_sorcerer_upgrade"):SetLevel(0)
            unit:AddAbility("human_priest_upgrade"):SetLevel(0)
            unit:AddAbility("human_ranged_barracks_upgrade"):SetLevel(1)
            unit:AddAbility("building_magic_immune"):SetLevel(1)

            unit:AddItemByName("item_spawn_rifleman")
            unit:AddItemByName("item_spawn_sorcerer")
            unit:AddItemByName("item_spawn_priest")

            unit:SetHasInventory(true)

            table.insert(humanBuildings, unit)
            humanBuildings[unit] = {}
            print("The building: "..unit_name.." is created and added into humanBuildings, table number: "..#humanBuildings)
        end

        -- Insert the buildings and the guards into a proper table, for later use
        if unit_name == "human_blacksmith" or unit_name == "human_research_facility" then
            table.insert(humanUpgradeBuildings, unit)
            print("The building: "..unit_name.." is created and added into humanUpgradeBuildings, table number: "..#humanUpgradeBuildings)
        elseif unit_name == "human_melee_guard" then
            table.insert(humanMeleeGuards, unit)
            print("The building: "..unit_name.." is created and added into humanMeleeGuards, table number: "..#humanMeleeGuards)
        elseif unit_name == "human_ranged_guard" then
            table.insert(humanRangedGuards, unit)
            print("The building: "..unit_name.." is created and added into humanRangedGuards, table number: "..#humanRangedGuards)
        end
    end

    if team == DOTA_TEAM_BADGUYS then
        if unit_name == "undead_king" then
            -- Start the Undead King AI system
            UndeadKingAI:MakeInstance( unit, { spawnPos = unit_location, aggroRange = 800, leashRange = 1200 } )
        end
    end
end