function ShieldAttack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration", ability:GetLevel() )
	local wave_range = ability:GetLevelSpecialValueFor( "wave_range", ability:GetLevel() )

	local enemies = FindUnitsInRadius( caster:GetTeam(), 
											target:GetAbsOrigin(), 
											nil,
											wave_range, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_CLOSEST, 
											false )

	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, "shield_attack_modifier", nil)
	end
end