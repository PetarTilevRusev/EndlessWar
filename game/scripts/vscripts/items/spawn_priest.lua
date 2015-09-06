if item_spawn_priest == nil then
	item_spawn_priest = class({})
end

function SpawnPriest ( keys )
	local barracks = keys.caster
	local barracks_position = barracks:GetAbsOrigin()

	-- Setting the waypoints
	local human_waypoint_1 = Entities:FindByName(nil, "human_waypoint_undead_side")
    local human_waypoint_2 = Entities:FindByName(nil, "human_waypoint_orc_side")
    local human_waypoint_3 = Entities:FindByName(nil, "human_waypoint_night_elf_side")

	local priest_level = barracks:GetAbilityByIndex(2):GetLevel()

    local waypoint = nil
    if barracks == humanBuildings[2] then
        waypoint = human_waypoint_1
    elseif barracks == humanBuildings[4] then
        waypoint = human_waypoint_2
    elseif barracks == humanBuildings[6] then
        waypoint = human_waypoint_3
    end

	if priest_level >= 2 then
        Spawner:SpawnAndMoveAtPosition(1, ("priest_"..priest_level), barracks_position, waypoint, barracks:GetTeamNumber())
    else
        Spawner:SpawnAndMoveAtPosition(1, "priest", barracks_position, waypoint, barracks:GetTeamNumber())
    end
end