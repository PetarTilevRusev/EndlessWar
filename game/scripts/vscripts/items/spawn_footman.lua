if item_spawn_footman == nil then
	item_spawn_footman = class({})
end

function SpawnFootman ( keys )
	local barracks = keys.caster
	local barracks_position = barracks:GetAbsOrigin()

	-- Setting the waypoints
	local human_waypoint_1 = Entities:FindByName(nil, "undead_base"):GetAbsOrigin()
    local human_waypoint_2 = Entities:FindByName(nil, "orc_base"):GetAbsOrigin()
    local human_waypoint_3 = Entities:FindByName(nil, "middle"):GetAbsOrigin()

	local footman_level = barracks:GetAbilityByIndex(0):GetLevel()

    local waypoint = nil
    if barracks == humanBuildings[1] then
        waypoint = human_waypoint_1
    elseif barracks == humanBuildings[3] then
        waypoint = human_waypoint_2
    elseif barracks == humanBuildings[5] then
        waypoint = human_waypoint_3
    end

	if footman_level >= 2 then
        Spawner:SpawnAndMoveAtPosition(4, ("footman_"..footman_level), barracks_position, waypoint, barracks:GetTeamNumber())
    else
        Spawner:SpawnAndMoveAtPosition(4, "footman", barracks_position, waypoint, barracks:GetTeamNumber())
    end
end