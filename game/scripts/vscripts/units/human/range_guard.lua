function AssassinateRegisterTarget( event )
	local caster = event.caster
	local target = event.target

    caster.assassinate_target = target
end

function AssassinateRemoveTarget( event )
	local caster = event.caster

    if caster.assassinate_target then
        caster.assassinate_target:RemoveModifierByName( "assassinate_target_modifier" )
        caster.assassinate_target = nil
    end
end
