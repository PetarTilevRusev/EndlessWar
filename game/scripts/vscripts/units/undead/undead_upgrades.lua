function ApplyKingUpgrade( event )
    local caster = event.caster -- Saving the Caster Handle
    local ability = event.ability -- Saving The Ability Handle
    local ability_name = ability:GetName()
    local modifier_name = ability_name.."_modifier"

    ability:ApplyDataDrivenModifier(caster, caster, modifier_name, nil)
    
    if ability_name == "undead_king_health_upgrade" then
        ApplyHealthUpgrade( caster, ability )
    end

    SetStackCount( caster, caster, modifier_name)
end

function ApplyHealthUpgrade( unit, ability )
    local health_bonus = ability:GetLevelSpecialValueFor("health", ability:GetLevel())
    local max_health = unit:GetMaxHealth()
    local current_health = unit:GetHealth()
    unit:SetMaxHealth(max_health + health_bonus)
    unit:SetHealth(current_health + health_bonus)
end

function SetStackCount( caster, unit, modifier )
    if unit:HasModifier(modifier) then
        local stack_count = unit:GetModifierStackCount(modifier, caster)
        unit:SetModifierStackCount(modifier, caster, (stack_count + 1))
    else
        unit:SetModifierStackCount(modifier, caster, 1)
    end
end