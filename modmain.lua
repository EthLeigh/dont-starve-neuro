AddPlayerPostInit(function(inst)
    local health = inst.components.health

    print("New world started, player entity created:", inst.prefab, inst.xp, inst.prefab.xp)
    print("Player health:", health.currenthealth)

    health:DoDelta(-100)

    -- local act = BufferedAction(inst, nil, ACTIONS.WALKTO, nil, inst.pos)
    -- act:Do()
end)
