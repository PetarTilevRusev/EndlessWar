if item_spawn_sorcerer == nil then
	item_spawn_sorcerer = class({})
end

function SpawnSorcerer ( keys )
	local barracks = keys.caster
	local barracks_position = barracks:GetAbsOrigin()

	-- Setting the waypoints
	local human_waypoint_1 = Entities:FindByName(nil, "undead_base"):GetAbsOrigin()
    local human_waypoint_2 = Entities:FindByName(nil, "orc_base"):GetAbsOrigin()
    local human_waypoint_3 = Entities:FindByName(nil, "middle"):GetAbsOrigin()

	local sorcerer_level = barracks:GetAbilityByIndex(1):GetLevel()

    local waypoint = nil
    if barracks == humanBuildings[2] then
        waypoint = human_waypoint_1
    elseif barracks == humanBuildings[4] then
        waypoint = human_waypoint_2
    elseif barracks == humanBuildings[6] then
        waypoint = human_waypoint_3
    end

	if sorcerer_level >= 2 then
        Spawner:SpawnAndMoveAtPosition(1, ("sorcerer_"..sorcerer_level), barracks_position, waypoint, barracks:GetTeamNumber())
    else
        Spawner:SpawnAndMoveAtPosition(1, "sorcerer", barracks_position, waypoint, barracks:GetTeamNumber())
    end
end