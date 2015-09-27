function StartAttack( keys )
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local cooldown = ability:GetCooldown(ability:GetLevel())

    if ability:IsCooldownReady() then
        caster:PerformAttack(target, true, true, true, true)
        ability:StartCooldown(cooldown)
    end
end