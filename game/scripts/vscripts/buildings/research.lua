--[[
	Author: Noya
	Date: 20.02.2015.
	Adds the search to the player research list
]]
function ResearchComplete( event )
	local caster = event.caster
	local player = caster:GetPlayerOwner()
	local ability = event.ability
	local research_name = ability:GetAbilityName()
	
	-- Go through all the upgradeable units and upgrade with the research
	-- These are just abilities set as lvl 0 _disabled until the tech is researched
	-- Some show as passives, while wc3 showed them as 0-1-2-3 ranks on the damage/armor indicator	
	for _,unit in pairs(player.units) do
		CheckAbilityRequirements( unit, player )
	end

	-- Also, on the buildings that have the upgrade, disable the upgrade and/or apply the next rank.
	for _,structure in pairs(player.structures) do
		CheckAbilityRequirements( structure, player )
	end
		
	for _,unit in pairs(player.units) do
		UpdateUnitUpgrades( unit, player, research_name)
	end

	for _,structure in pairs(player.structures) do
		UpdateUnitUpgrades( structure, player, research_name)
	end

end

-- When queing a research, disable it to prevent from being queued again
function DisableResearch( event )
	local ability = event.ability
	print("Set Hidden "..ability:GetAbilityName())
	ability:SetHidden(true)

	local caster = event.caster
	local hero = caster:GetOwner()
	print("##Firing ability_values_force_check for "..caster:GetUnitName())
	FireGameEvent( 'ability_values_force_check', { player_ID = pID })
end

-- Reenable the parent ability without item_ in its name
function ReEnableResearch( event )
	local caster = event.caster
	local ability = event.ability
	local item_name = ability:GetAbilityName()
	local research_ability_name = string.gsub(item_name, "item_", "")

	print("Unhide "..research_ability_name)
	local research_ability = caster:FindAbilityByName(research_ability_name)
	research_ability:SetHidden(false)

	local caster = event.caster
	local hero = caster:GetOwner()
	local pID = hero:GetPlayerID()
	print("##Firing ability_values_force_check for "..caster:GetUnitName())
	FireGameEvent( 'ability_values_force_check', { player_ID = pID })
end