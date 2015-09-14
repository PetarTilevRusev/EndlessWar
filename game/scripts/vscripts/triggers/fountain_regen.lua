LinkLuaModifier( "human_base_regen_modifier", "triggers/regen_modifier.lua", LUA_MODIFIER_MOTION_NONE )

function OnBaseEnter( trigger )
    local player = trigger.activator
    if not player then return end
    if player:IsAlive() then
        player:AddNewModifier( ent, self, "human_base_regen_modifier", {} )
        return
    end
end

function OnBaseExit( trigger )
    local player = trigger.activator
    if not player then return end
    if player:IsAlive() then
        player:RemoveModifierByName("human_base_regen_modifier")
        return
    end
end