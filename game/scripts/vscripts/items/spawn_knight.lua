if item_spawn_knight == nil then
	item_spawn_knight = class({})
end

function SpawnKnight ( keys )
	local barracks = keys.caster
	local barracks_position = barracks:GetAbsOrigin()

	-- Setting the waypoints
	local human_waypoint_1 = Entities:FindByName(nil, "human_waypoint_undead_side")
    local human_waypoint_2 = Entities:FindByName(nil, "human_waypoint_orc_side")
    local human_waypoint_3 = Entities:FindByName(nil, "human_waypoint_night_elf_side")

	local knight_level = barracks:GetAbilityByIndex(1):GetLevel()

    local waypoint = nil
    if barracks == humanBuildings[1] then
        waypoint = human_waypoint_1
    elseif barracks == humanBuildings[3] then
        waypoint = human_waypoint_2
    elseif barracks == humanBuildings[5] then
        waypoint = human_waypoint_3
    end

	if knight_level >= 2 then
        Spawner:SpawnAndMoveAtPosition(1, ("knight_"..knight_level), barracks_position, waypoint, barracks:GetTeamNumber())
    else
        Spawner:SpawnAndMoveAtPosition(1, "knight", barracks_position, waypoint, barracks:GetTeamNumber())
    end
end