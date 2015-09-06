if item_spawn_siege_unit == nil then
	item_spawn_siege_unit = class({})
end

function SpawnSiegeUnit ( keys )
	local barracks = keys.caster
	local barracks_position = barracks:GetAbsOrigin()

	-- Setting the waypoints
	local human_waypoint_1 = Entities:FindByName(nil, "human_waypoint_undead_side")
    local human_waypoint_2 = Entities:FindByName(nil, "human_waypoint_orc_side")
    local human_waypoint_3 = Entities:FindByName(nil, "human_waypoint_night_elf_side")

    local waypoint = nil
    if barracks == humanBuildings[1] then
        waypoint = human_waypoint_1
    elseif barracks == humanBuildings[3] then
        waypoint = human_waypoint_2
    elseif barracks == humanBuildings[5] then
        waypoint = human_waypoint_3
    end

    Spawner:SpawnAndMoveAtPosition(1, "human_siege_unit", barracks_position, waypoint, barracks:GetTeamNumber())
end