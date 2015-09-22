function ApplyKingUpgrade( event )
    local caster = event.caster -- Saving the Caster Handle
    local ability = event.ability -- Saving The Ability Handle
    local ability_name = ability:GetName()
    local modifier_name = ability_name.."_modifier"

    ability:ApplyDataDrivenModifier(caster, caster, modifier_name, nil)
    
    if ability_name == "human_king_health_upgrade" then
        ApplyHealthUpgrade( caster, ability )
    end

    SetStackCount( caster, caster, modifier_name)
end

-- Applues upgrades from the Barracks
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

    if caster_name == "human_melee_barracks" then
        if ability_level == 3 then
            caster:FindAbilityByName("human_siege_engine_disabled"):SetLevel(1)
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

-- Applyes upgrades from the Balacksmith
function ApplyBlacksmithUpgrade( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetName()
    local ability_level = ability:GetLevel()
    local modifier_name = ability_name.."_modifier"

    ability:SetLevel(ability_level + 1)
    caster:SetModifierStackCount(modifier_name, caster, (ability_level - 1))

    -- Loop trough the guard and apply the datadriven modifier
    for _,guard in pairs(humanMeleeGuards) do
        -- Check if the guard is alive
        if IsValidEntity(guard) then
            ability:ApplyDataDrivenModifier(caster, guard, modifier_name, nil)

            if ability_name == "human_units_health_upgrade" then
                ApplyHealthUpgrade( guard, ability )
            end

            SetStackCount( caster, guard, modifier_name)
        end
    end

    for _,guard in pairs(humanRangedGuards) do
        -- Check if the guard is alive
        if IsValidEntity(guard) then
            ability:ApplyDataDrivenModifier(caster, guard, modifier_name, nil)

            if ability_name == "human_units_health_upgrade" then
                ApplyHealthUpgrade( guard, ability )
            end

            SetStackCount( caster, guard, modifier_name)
        end
    end
end

-- Applyes the upgrades from Research Facility
function ResearchedUpgrades( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetName()
    local modifier_name = ability_name.."_modifier"

    for _,rax in pairs(humanBuildings) do
        if IsValidEntity(rax) then
            ability:ApplyDataDrivenModifier(caster, rax, modifier_name, nil)

            if ability_name == "human_facility_health_upgrade" then
                ApplyHealthUpgrade( rax, ability )
                print("Health upgraded!")
            end
        end

        SetStackCount( caster, rax, modifier_name)
    end
end

function ApplyHumanStrength( event )
    local caster = event.caster
    local ability = event.ability
    local ability_level = ability:GetLevel()

    -- Add human_strength ability melee to the guards
    for _,guard in pairs(humanMeleeGuards) do
        -- Check if the guard is alive
        if IsValidEntity(guard) then
            if guard:HasAbility("human_strength") then
                guard:FindAbilityByName("human_strength"):SetLevel( ability_level + 1)
            else
                guard:AddAbility("human_strength"):SetLevel( ability_level + 1)
            end
        end
    end

    if ability_level == 3 then
        caster:RemoveAbility(ability:GetName())
    else
        ability:SetLevel(ability_level + 1)
    end
end

function ApplyEagleEye( event )
    local caster = event.caster
    local ability = event.ability
    local ability_level = ability:GetLevel()

    -- Add eagle_eye ability to the ranged guards
    for _,guard in pairs(humanRangedGuards) do
        -- Check if the guard is alive
        if IsValidEntity(guard) then
            if guard:HasAbility("eagle_eye") then
                guard:FindAbilityByName("eagle_eye"):SetLevel( ability_level + 1)
            else
                guard:AddAbility("eagle_eye"):SetLevel( ability_level + 1)
            end
        end
    end

    if ability_level == 3 then
        caster:RemoveAbility(ability:GetName())
    else
        ability:SetLevel(ability_level + 1)
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