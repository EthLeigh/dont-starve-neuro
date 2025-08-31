local Player = nil
local Camera = nil

AddPlayerPostInit(function(inst)
    Player = inst

    local controller = inst.components.playercontroller
    local locomotor = inst.components.locomotor

    -- controller:Enable(false)

    inst:DoPeriodicTask(0, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local dest = GLOBAL.Vector3(x + 5, y, z)

        locomotor:GoToPoint(dest, nil, true)
    end)
end)

AddSimPostInit(function()
    GLOBAL.TheCamera:SetHeadingTarget(270)
    Camera = GLOBAL.TheCamera
end)