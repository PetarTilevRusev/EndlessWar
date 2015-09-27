function SummonSkeletons( event )
	local caster = event.caster
	local ability = event.ability
	local ability_level = ability:GetLevel()
	local spawn_position = caster:GetAbsOrigin()
	local melee_skeleton = "necromancer_melee_skeleton_"..ability_level
	local ranged_skeleton = "necromancer_ranged_skeleton_"..ability_level

    local melee_unit = CreateUnitByName(melee_skeleton, spawn_position, true, caster, caster, caster:GetTeamNumber())
	melee_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = 60})
	melee_unit:SetInitialGoalEntity(caster:GetInitialGoalEntity())

	local ranged_unit = CreateUnitByName(ranged_skeleton, spawn_position, true, caster, caster, caster:GetTeamNumber())
	ranged_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = 60})
	ranged_unit:SetInitialGoalEntity(caster:GetInitialGoalEntity())
end

-- Handles AutoCast Logic
function SummonAutocast( event )
	local caster = event.caster
	local ability = event.ability
	local autocast_radius = ability:GetSpecialValueFor("autocast_radius")

	-- Get if the ability is on autocast mode and cast the ability on a valid target
	if ability:GetAutoCastState() and ability:IsFullyCastable() then
		-- Find enemy targets in radius
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, autocast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		
		if #enemies > 2 then
			caster:CastAbilityNoTarget(ability, caster:GetPlayerOwnerID())
		end
	end	
end

-- Automatically toggled on
function ToggleOnAutocast( event )
	local caster = event.caster
	local ability = event.ability

	ability:ToggleAutoCast()
end