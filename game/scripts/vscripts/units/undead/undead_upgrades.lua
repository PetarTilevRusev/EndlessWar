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

function UpgradeUnit( event )
    local caster = event.caster
    local ability = event.ability
    local ability_level = ability:GetLevel()
    local ability_name = ability:GetName()

    --Don't upgrade if the ability is maxed and replace it with empty one
    if ability_level == 3 then
        caster:RemoveAbility(ability_name)
        caster:AddAbility(ability_name.."_disabled"):SetLevel(ability_level + 1)
    else
        ability:SetLevel(ability_level + 1)
    end
end

function ApplyBuildingUpgrade( event )
    local caster = event.caster
    local caster_name = caster:GetUnitName()
    local ability = event.ability
    local ability_level = ability:GetLevel()
    local ability_name = ability:GetName()

    if caster_name == "undead_melee_barracks" then
        if ability_level == 3 then
            caster:FindAbilityByName("undead_meat_wagon_disabled"):SetLevel(1)
            caster:RemoveAbility("undead_melee_barracks_upgrade")
            caster:AddAbility("undead_melee_barracks_upgrade_disabled"):SetLevel(4)
        elseif ability_level == 2 then
            caster:FindAbilityByName("undead_abomination_upgrade"):SetLevel(1)
            caster:FindAbilityByName("undead_melee_barracks_upgrade"):SetLevel(3)
        elseif ability_level == 1 then
            caster:FindAbilityByName("undead_ghoul_upgrade"):SetLevel(1)
            caster:FindAbilityByName("undead_melee_barracks_upgrade"):SetLevel(2)
        end
    end

    if caster_name == "undead_ranged_barracks" then
        if ability_level == 3 then
            caster:FindAbilityByName("undead_necromancer_upgrade"):SetLevel(1)
            caster:RemoveAbility("undead_ranged_barracks_upgrade")
            caster:AddAbility("undead_ranged_barracks_upgrade_disabled"):SetLevel(4)
        elseif ability_level == 2 then
            caster:FindAbilityByName("undead_banshee_upgrade"):SetLevel(1)
            caster:FindAbilityByName("undead_ranged_barracks_upgrade"):SetLevel(3)
        elseif ability_level == 1 then
            caster:FindAbilityByName("undead_crypt_fiend_upgrade"):SetLevel(1)
            caster:FindAbilityByName("undead_ranged_barracks_upgrade"):SetLevel(2)
        end
    end
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