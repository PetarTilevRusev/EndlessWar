if human_base_regen_modifier == nil then
    human_base_regen_modifier = class({})
end

function human_base_regen_modifier:OnCreated( kv )  
    if IsServer() then
        self:StartIntervalThink( 0.3 )
    end
end

function human_base_regen_modifier:IsHidden() return true end
function human_base_regen_modifier:IsBuff() return true end

function human_base_regen_modifier:OnIntervalThink()
    if IsServer() and self:GetParent():IsAlive() then 
        local player = self:GetParent()

        if player:GetHealth() < player:GetMaxHealth() or player:GetMana() < player:GetMaxMana() then
            local health = player:GetMaxHealth() * ( 3 / 100 )
            local mana = player:GetMaxMana() * ( 3 / 100 )
            player:Heal(health, player)
            player:GiveMana(mana)
            print(player:GetUnitName().." is healed with "..health)
        end
    end
end