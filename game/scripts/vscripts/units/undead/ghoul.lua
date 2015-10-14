function Lifesteal( event )
  local target = event.target
  local ability = event.ability
  local attacker = event.attacker
  local modifier_duration = {duration = 0.03}

    if target.GetInvulnCount == nil and not target:IsMechanical() then
        ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_ghoul_lifesteal", modifier_duration)
    end
end