-- Handles AutoCast Logic
function CurseAutocast( event )
	local caster = event.caster
	local ability = event.ability
	local autocast_radius = ability:GetSpecialValueFor("autocast_radius")
    local hero_search_radius = autocast_radius * 1.5
	local modifier_name = "banshee_curse_modifier"

	-- Get if the ability is on autocast mode and cast the ability on a valid target
	if ability:GetAutoCastState() and ability:IsFullyCastable() then
		-- Find enemy targets in radius
		local target
		local enemies = FindUnitsInRadius(
											caster:GetTeamNumber(), -- Enemy team number
											caster:GetAbsOrigin(), -- Enemy position
											nil, -- Enemy handle
											autocast_radius, -- Search radius
											DOTA_UNIT_TARGET_TEAM_ENEMY, -- Searching radius
											DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, -- Attack tipes
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, -- Order 
											false)

        local heroes = FindUnitsInRadius(
                                            caster:GetTeamNumber(), -- Enemy team number
                                            caster:GetAbsOrigin(), -- Enemy position
                                            nil, -- Enemy handle
                                            hero_search_radius, -- Search radius
                                            DOTA_UNIT_TARGET_TEAM_ENEMY, -- Searching radius
                                            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, -- Attack tipes
                                            DOTA_UNIT_TARGET_FLAG_NONE, 
                                            FIND_ANY_ORDER, -- Order 
                                            false)

        -- First search fro heroes and if there are no heroes in raidus, use the ability at random enemy unit in raidus
        if #heroes >= 1 then
    		for k,hero in pairs(heroes) do
    			if not caster:HasModifier(modifier_name) then
    				target = hero
    				break
    			end
    		end
        else
            for k,unit in pairs(enemies) do
                if not caster:HasModifier(modifier_name) then
                    target = unit
                    break
                end
            end
        end

		if not target then
			return
		else
			caster:CastAbilityOnTarget(target, ability, caster:GetEntityIndex())
		end
	end	
end

-- Automatically toggled on
function ToggleOnAutocast( event )
	local caster = event.caster
	local ability = event.ability

	ability:ToggleAutoCast()
end