local assets =
{
    Asset("ANIM", "anim/ghost.zip"),
    Asset("ANIM", "anim/ghost_wendy_build.zip"),
    Asset("SOUND", "sound/ghost.fsb"),
}

local CONSTANTS = {}
CONSTANTS.HEALTH = 50
CONSTANTS.DAMAGE = 25
CONSTANTS.WALK_SPEED = 2
CONSTANTS.RUN_SPEED = 5

local function Retarget(inst)
    local newtarget = FindEntity(inst, 20, function(guy)
        return guy.components.combat and
            inst.components.combat:CanTarget(guy) and
            (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function auratest(inst, target)
    if target == GetPlayer() then return false end

    local leader = inst.components.follower.leader
    if target.components.combat.target and
        (target.components.combat.target == inst or target.components.combat.target == leader) then
        return true
    end
    if inst.components.combat.target == target then return true end

    if leader then
        if leader == target then return false end
        if target.components.follower and target.components.follower.leader == leader then return false end
    end

    return (target:HasTag("monster") or target:HasTag("prey")) and inst.components.combat:CanTarget(target)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

    local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()

    light:SetIntensity(.6)
    light:SetRadius(.5)
    light:SetFalloff(.6)
    light:Enable(true)
    light:SetColour(240 / 255, 120 / 255, 232 / 255)

    local brain = require "brains/neuro_ghost_brain"
    inst:SetBrain(brain)

    anim:SetBank("ghost")
    anim:SetBuild("ghost_wendy_build")
    anim:SetBloomEffectHandle("shaders/anim.ksh")
    anim:PlayAnimation("idle", true)

    MakeGhostPhysics(inst, 1, .5)

    inst:AddTag("neuro")
    inst:AddTag("girl")
    inst:AddTag("ghost")
    inst:AddTag("scarytoprey")
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = CONSTANTS.WALK_SPEED
    inst.components.locomotor.runspeed = CONSTANTS.RUN_SPEED

    inst:SetStateGraph("neuro_ghost_sg")

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CONSTANTS.HEALTH)
    inst.components.health:StartRegen(1, 1)

    inst:AddComponent("combat")
    inst.components.combat.defaultdamage = CONSTANTS.DAMAGE
    inst.components.combat.playerdamagepercent = CONSTANTS.DAMAGE / 100
    inst.components.combat:SetRetargetFunction(3, Retarget)

    inst:AddComponent("aura")
    inst.components.aura.radius = 3
    inst.components.aura.tickperiod = 1
    inst.components.aura.ignoreallies = true
    inst.components.aura.auratestfn = auratest

    inst:AddComponent("follower")
    local player = GetPlayer()
    if player and player.components.leader then
        player.components.leader:AddFollower(inst)
    end

    -- inst:ListenForEvent("newcombattarget", OnAttacked)
    -- inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("neuro_ghost", fn, assets)
