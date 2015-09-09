function ApplyKingUpgrade( event )
    local caster = event.caster -- Saving the Caster Handle]
    local ability = event.ability -- Saving The Ability Handle
    local ability_name = ability:GetName()
    local ability_modifier = ability_name.."_modifier"

    ability:ApplyDataDrivenModifier(caster, caster, ability_modifier, nil)

    local health_bonus = ability:GetLevelSpecialValueFor("health", ability:GetLevel())
    
    if ability_name == "human_king_health_upgrade" then
        local max_health = caster:GetMaxHealth()
        local current_health = caster:GetHealth()
        caster:SetMaxHealth(max_health + health_bonus)
        caster:SetHealth(current_health + health_bonus)
    end

    -- Setting stack couters
    if caster:HasModifier(ability_modifier) then
        local stack_count = caster:GetModifierStackCount(ability_modifier, caster)
        caster:SetModifierStackCount(ability_modifier, caster, (stack_count + 1))
    else 
        caster:SetModifierStackCount(ability_modifier, caster, 1)
    end
end

function UpgradeUnit( event )
    local caster = event.caster
    local caster_name = caster:GetName()
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
    if caster_name == "human_melee_barracks" then
        if ability_level == 3 then
            caster:FindAbilityByName("human_siege_unit_disabled"):SetLevel(1)
            caster:RemoveAbility("human_melee_barracks_upgrade")
            caster:AddAbility("human_melee_barracks_upgrade_disabled"):SetLevel(4)
        elseif ability_level == 2 then
            caster:FindAbilityByName("human_knight_upgrade"):SetLevel(1)
            caster:FindAbilityByName("human_melee_barracks_upgrade"):SetLevel(3)
        elseif ability_level == 1 then
            caster:FindAbilityByName("human_footman_upgrade"):SetLevel(1)
            caster:FindAbilityByName("human_melee_barracks_upgrade"):SetLevel(2)
        end
    end

    if caster_name == "human_ranged_barracks" then
        if ability_level == 3 then
            caster:FindAbilityByName("human_priest_upgrade"):SetLevel(1)
            caster:RemoveAbility("human_ranged_barracks_upgrade")
            caster:AddAbility("human_ranged_barracks_upgrade_disabled"):SetLevel(4)
        elseif ability_level == 2 then
            caster:FindAbilityByName("human_sorcerer_upgrade"):SetLevel(1)
            caster:FindAbilityByName("human_ranged_barracks_upgrade"):SetLevel(3)
        elseif ability_level == 1 then
            caster:FindAbilityByName("human_rifleman_upgrade"):SetLevel(1)
            caster:FindAbilityByName("human_ranged_barracks_upgrade"):SetLevel(2)
        end
    end
end

function ApplyUnitUpgrade( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetName()
    local ability_level = ability:GetLevel()
    local ability_modifier = ability_name.."_modifier"

    ability:SetLevel(ability_level + 1)
    caster:SetModifierStackCount(ability_modifier, caster, (ability_level - 1))

    -- Loop trough the guard and apply the datadriven modifier
    for _,guard in pairs(humanMeleeGuards) do
        -- Check if the guard is alive
        if IsValidEntity(guard) then
            ability:ApplyDataDrivenModifier(caster, guard, ability_modifier, nil)

            -- Set the stack counts
            if guard:HasModifier(ability_modifier) then
                local stack_count = guard:GetModifierStackCount(ability_modifier, caster)
                guard:SetModifierStackCount(ability_modifier, caster, (stack_count + 1))
            else
                guard:SetModifierStackCount(ability_modifier, caster, 1)
            end
        end
    end

    for _,guard in pairs(humanRangedGuards) do
        -- Check if the guard is alive
        if IsValidEntity(guard) then
            ability:ApplyDataDrivenModifier(caster, guard, ability_modifier, nil)

            -- Set the stack counts
            if guard:HasModifier(ability_modifier) then
                local stack_count = guard:GetModifierStackCount(ability_modifier, caster)
                guard:SetModifierStackCount(ability_modifier, caster, (stack_count + 1))
            else
                guard:SetModifierStackCount(ability_modifier, caster, 1)
            end
        end
    end
end