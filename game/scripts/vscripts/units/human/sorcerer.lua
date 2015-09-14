function HexStart( keys )
	local target = keys.target
    local model = keys.model

    if target:IsIllusion() then
        target:ForceKill(true)
    else
        if target.target_model == nil then
            target.target_model = target:GetModelName()
        end

        target:SetOriginalModel(model)
    end
end

function HexEnd( keys )
	local target = keys.target

    -- Checking for errors
    if target.target_model ~= nil then
        target:SetModel(target.target_model)
        target:SetOriginalModel(target.target_model)
    end
end

function HideWearables( event )
	local unit = event.target
    local ability = event.ability
    local duration = ability:GetLevelSpecialValueFor( "hex_duration", ability:GetLevel() )
    --hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable

    unit.wearableNames = {} -- In here we'll store the wearable names to revert the change
    unit.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system
    local model = unit:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            if string.find(modelName, "invisiblebox") == nil then
                -- Add the original model name to revert later
                table.insert(unit.wearableNames,modelName)

                -- Set model invisible
                model:SetModel("models/development/invisiblebox.vmdl")
                table.insert(unit.hiddenWearables,model)
            end
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
	local hero = event.target

    -- Iterate on both tables to set each item back to their original modelName
    for i,v in ipairs(hero.hiddenWearables) do
        for index,modelName in ipairs(hero.wearableNames) do
            if i==index then
                v:SetModel(modelName)
            end
        end
    end
end

-- Handles AutoCast Logic
function HexAutocast( event )
	local caster = event.caster
	local ability = event.ability
	local autocast_radius = ability:GetSpecialValueFor("autocast_radius")
	local modifier_name = "sorcerer_hex_modifier"

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
		for k,unit in pairs(enemies) do
			if not caster:HasModifier(modifier_name) then
				target = unit
				break
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