---@class CombatHelper
CombatHelper = {}

---@param ent Entity
function CombatHelper.AttackEntity(ent)
    PlayerCombat:SetTarget(ent)
end

---@param ent Entity
---@return boolean
function CombatHelper.CanAttackEntity(ent)
    return PlayerCombat:IsValidTarget(ent)
end
