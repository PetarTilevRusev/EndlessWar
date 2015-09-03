--[[
	Author: Noya
	Date: 11.02.2015.
	Creates a rally point flag for this unit, removing the old one if there was one
]]
function SetRallyPoint( event )
	local caster = event.caster
	local origin = caster:GetOrigin()
	print(origin)
	
	-- Need to wait one frame for the building to be properly positioned
	Timers:CreateTimer(0.03, function()

		-- If there's an old flag, remove
		if caster.flag and IsValidEntity(caster.flag) then
			caster.flag:RemoveSelf()
		end

		-- Make a new one
		caster.flag = Entities:CreateByClassname("prop_dynamic")

		-- Find vector towards 0,0,0 for the initial rally point
		if not IsValidEntity(caster) then
			return
		end
		origin = caster:GetOrigin()
		local forwardVec = Vector(0,0,0) - origin
		forwardVec = forwardVec:Normalized()

		local point = origin
		if not event.target_points then
			-- For the initial rally point, get point away from the building looking towards (0,0,0)
			point = origin + forwardVec * 220
			DebugDrawCircle(point, Vector(255,255,255), 255, 10, false, 10)
			DebugDrawCircle(point, Vector(255,255,255), 255, 20, false, 10)

			-- Keep track of this position so that every unit is autospawned there (avoids going around the)
			caster.initial_spawn_position = point
		else
			point = event.target_points[1]
			--caster.flag = nil
		end

		-- Make a flag dummy
        caster.flag = CreateUnitByName("dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
        caster.flag.type = "position"

        --[[local color = TEAM_COLORS[caster:GetTeamNumber()]
        local particle = ParticleManager:CreateParticleForTeam("particles/custom/rally_flag.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.flag, caster:GetTeamNumber())
        ParticleManager:SetParticleControl(particle, 0, point) -- Position
        ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin()) --Orientation
        ParticleManager:SetParticleControl(particle, 15, Vector(color[1], color[2], color[3])) --Color]]

		print(caster:GetUnitName().." sets rally point on ",point)
	end)
end

-- Queues a movement command for the spawned unit to the rally point
-- Also adds the unit to the players army and looks for upgrades
function MoveToRallyPoint( event )
	local caster = event.caster
	local target = event.target
	local entityIndex = target:GetEntityIndex() -- The spawned unit

	-- Set the builders idle when they spawn
	if IsBuilder(target) then 
		target.state = "idle" 
	end

	if caster.flag and IsValidEntity(caster.flag) then
		local flag = caster.flag
		local rally_type = flag.type
		print("Move to Rally Point", flag.type)
		-- If its a tree and this is a builder, cast gather
		if rally_type == "tree" then
			Timers:CreateTimer(0.05, function() 
				if IsBuilder(target) then
					local race = GetUnitRace(caster)
					local position = caster.flag:GetAbsOrigin()
					local empty_tree = FindEmptyNavigableTreeNearby(target, position, 150)
					if empty_tree then
						empty_tree.builder = target
				        target.skip_gather_check = true
				        local gather_ability = target:FindAbilityByName(race.."_gather")
				        if gather_ability then
				        	local tree_index = GetTreeIndexFromHandle(empty_tree)
				            print("Order: Cast on Tree ",tree_index)
				            ExecuteOrderFromTable({ UnitIndex = entityIndex, OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE, TargetIndex = tree_index, AbilityIndex = gather_ability:GetEntityIndex(), Queue = false})
				        end
				    end
				else
					-- Move
					print("MOVE TO TREE POSITION")
					local position = caster.flag:GetAbsOrigin()
					target:MoveToPosition(position)
				end
		    end)

	    elseif rally_type == "mine" then
	    	Timers:CreateTimer(0.05, function() 
	    		if IsBuilder(target) then
			    	local race = GetUnitRace(target)
			    	local gather_ability = target:FindAbilityByName(race.."_gather")
			    	for i=0,15 do
			    		local ab = target:GetAbilityByIndex(i)
			    		if ab then print(ab:GetAbilityName()) end
			    	end
			        if gather_ability then
			            print("Order: Cast on Mine ",flag)
			            ExecuteOrderFromTable({ UnitIndex = entityIndex, OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = flag:GetEntityIndex(), AbilityIndex = gather_ability:GetEntityIndex(), Queue = false})
			        end
			    else
			    	-- Move
			    	print("MOVE TO MINE POSITION")
			    	local position = flag:GetAbsOrigin()
					target:MoveToPosition(position)
				end
		    end)

		-- If its a dummy - Move to position
		elseif rally_type == "position" then
			print("MOVE TO MINE POSITION")
			local position = flag:GetAbsOrigin()
			Timers:CreateTimer(0.05, function() target:MoveToPosition(position) end)
			print(target:GetUnitName().." moving to position",position)
		elseif rally_type == "target" then
			print("MOVE TO TARGET POSITION")
			-- If its a target unit, Move to follow
			Timers:CreateTimer(0.05, function() target:MoveToNPC(flag) end)
			print(target:GetUnitName().." moving to follow",flag:GetUnitName())
		end
	end

	local player = caster:GetPlayerOwner()
	local hero = player:GetAssignedHero()
	target:SetOwner(hero)
	table.insert(player.units, target)
	CheckAbilityRequirements(target, player)
end

function GetInitialRallyPoint( event )
	local caster = event.caster
	local initial_spawn_position = caster.initial_spawn_position

	local result = {}
	if initial_spawn_position then
		table.insert(result,initial_spawn_position)
	else
		print("Fail, no initial rally point, this shouldn't happen")
	end

	return result
end


function DetectRightClick( event )
	local point = event.target_points[1]

	print("####",point)
end