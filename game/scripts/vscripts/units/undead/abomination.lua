function DiseaseCloudStartSound( keys )
    local caster = keys.caster
    local sound = "Hero_Pudge.Rot"

    StartSoundEvent(sound, caster)

    Timers:CreateTimer( function()
    	if not caster:HasModifier("abomination_disease_cloud_debuff_modifier") then
    		DiseaseCloudStopSound(sound, caster)
    	else
    		return 1
    	end
    end)
end

function DiseaseCloudStopSound( sound, caster )
    StopSoundEvent(sound, caster)
end