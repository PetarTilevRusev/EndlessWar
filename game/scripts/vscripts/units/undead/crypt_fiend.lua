function DoubleAttackCooldown( event )
	-- Variables
    local caster = event.caster
    local ability = event.ability
    local cooldown = ability:GetCooldown( ability:GetLevel() )
    local modifierName = "crypt_fiend_double_attack_modifier"
    
    -- Remove cooldown
    caster:RemoveModifierByName( modifierName )
    ability:StartCooldown( cooldown )
    Timers:CreateTimer( cooldown, function()
            ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
            return nil
        end
    )
end