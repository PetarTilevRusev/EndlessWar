if HumanGuardsAI == nil then
    _G.HumanGuardsAI = class({})
end

function HumanGuardsAI:Start()
	for table_number,guard in pairs(humanMeleeGuards) do
		local spawn_position = Entities:FindByName(nil, ("human_melee_guard_"..table_number)):GetAbsOrigin()
		local distance = ( spawn_position - guard:GetAbsOrigin() ):Length()
		local leash_range = 1000
		print(distance)
		if guard:GetAbsOrigin() ~= spawn_position then
	    	-- If the guard is outside the leash_range, force him to retrun to the spawn point
			if distance > leash_range then
				guard:MoveToPosition(spawn_position)
	    	else
			-- If the guard has moved and there is no enemies arround, return him to the spawn point.
				local orderMoveToSpawnPosition = { 
	                UnitIndex = guard:GetEntityIndex(), 
	                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE, 
	                Position = spawn_position, 
	                Queue = true 
	            }
	    		ExecuteOrderFromTable(orderMoveToSpawnPosition)
	    	end
		end
	end
end