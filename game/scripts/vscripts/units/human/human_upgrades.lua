function ApplyKingUpgrade( event )
    local caster = event.caster -- Saving the Caster Handle]
    local ability = event.ability -- Saving The Ability Handle
    local ability_name = ability:GetName()

    ability:ApplyDataDrivenModifier(caster,caster, (ability_name.."_modifier"), nil)

    if ability_name == "human_king_health_upgrade" then
        local max_health = caster:GetMaxHealth()
        local current_health = caster:GetHealth()
        caster:SetMaxHealth(max_health + 200)
        caster:SetHealth(current_health + 200)
    end

    -- Setting stack couters
    if (caster:HasModifier(ability_name.."_modifier")) then
        caster:SetModifierStackCount((ability_name.."_modifier"), caster, (caster:GetModifierStackCount((ability_name.."_modifier"), caster) + 1))
    else 
        caster:SetModifierStackCount((ability_name.."_modifier"),caster,1)
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