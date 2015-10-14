function StartAttack( event )
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local cooldown = ability:GetCooldown(ability:GetLevel())

    if ability:IsCooldownReady() then
        caster:PerformAttack(target, true, true, true, true)
        ability:StartCooldown(cooldown)
    end
end