if HumanGuardsAI == nil then
    _G.HumanGuardsAI = class({})
end

function HumanGuardsAI:Start()
	-- Lopp trough all melee guards
	for table_number,guard in pairs(humanMeleeGuards) do
		if IsValidEntity(guard) then
			local spawn_position = Entities:FindByName(nil, ("human_melee_guard_"..table_number)):GetAbsOrigin()
			local guard_position = guard:GetAbsOrigin()

			-- Check if the guard has moved from his spawn position (Im using math.ceil to remove the floating point)
			if math.ceil(guard_position:Length()) ~= math.ceil(spawn_position:Length()) then
				
				HumanGuardsAI:GodsStrength( guard )
				HumanGuardsAI:ShieldAttack( guard )
				HumanGuardsAI:ReturnToSpawnPosition( guard , spawn_position)

			end
		end
	end

	-- Lopp trough all ranged guards
	for table_number,guard in pairs(humanRangedGuards) do
		if IsValidEntity(guard) then
			HumanGuardsAI:Assassinate( guard )
		end
	end
end

function HumanGuardsAI:GodsStrength( guard )
	local ability = guard:GetAbilityByIndex(0)
	local guard_health = guard:GetHealthPercent()
	
	-- Use the ability when it's out of cooldown and the guard's healt is bellow 25%
	if ability:GetCooldownTimeRemaining() == 0 and guard_health <= 25 then
		guard:CastAbilityNoTarget(ability, 0)
		print(ability:GetName().." is used")
	end
end

function HumanGuardsAI:ShieldAttack( guard )
	local ability = guard:GetAbilityByIndex(1)
	local guard_mana = guard:GetMana()
	local ability_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel())
	--Find enemy units around the guard inside the ability radius
	local enemies = FindUnitsInRadius( guard:GetTeam(), 
		guard:GetAbsOrigin(), 
		nil, 
		ability_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_ALL, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false )

	-- Use the ability when it's out of cooldown, the guard has enough mana for it and there are at least 4 enemies in ability radius
	if ability:GetCooldownTimeRemaining() == 0 and guard_mana > 120 and #enemies > 3 then
		guard:CastAbilityOnTarget(enemies[1], ability, 0)
		print(ability:GetName().." is used")
	end
end

function HumanGuardsAI:ReturnToSpawnPosition( guard, spawn_position )
	local distance = ( spawn_position - guard:GetAbsOrigin() ):Length()
	local leash_range = 1000

	-- If the guard is outside the leash_range, force him to retrun to the spawn point
	if distance > leash_range then
		guard:MoveToPosition(spawn_position)
	else
		-- If the guard has moved and there is no enemies arround, return him to the spawn point.
		local orderMoveToSpawnPosition = { UnitIndex = guard:GetEntityIndex(), 
										OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE, 
										Position = spawn_position, 
										Queue = true 
										}
		ExecuteOrderFromTable(orderMoveToSpawnPosition)
	end
end

function HumanGuardsAI:Assassinate( guard )
	local ability = guard:GetAbilityByIndex(0)
	local guard_mana = guard:GetMana()
    local ability_range = ability:GetLevelSpecialValueFor("range", ability:GetLevel())

	local heroes = FindUnitsInRadius( guard:GetTeamNumber(), 
		guard:GetAbsOrigin(), 
		nil, 
		ability_range, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST,
		false)

	for _,hero in pairs(heroes) do
		local hero_health = hero:GetHealthPercent()
		if hero_health < 50 then
			guard:CastAbilityOnTarget(hero, ability, 0)
		end
	end
end