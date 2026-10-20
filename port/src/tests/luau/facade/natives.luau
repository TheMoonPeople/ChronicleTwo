return {
    [100] = function()
        local v = action.ProgGet()
        action.ProgSet(v)
    end,
    [101] = function()
        action.ProgSet(if action.GetAttkType() == nil then 1 else 0)
    end,
    [102] = function()
        action.SetPallet(4, "テスト")
    end,
    [103] = function()
        action.SetMoveSpeed(1.5)
    end,
    [104] = function()
        action.Ext(200, 1, 2.5, "x", true)
    end,
    [105] = function()
        action.ProgSet(action.InitScript_1())
    end,
    [106] = function()
        action.InitScript()
    end,
    [107] = function()
        print("a", 1, 2.5, true, nil, "b\n")
    end,
    [108] = function()
        action.EsmSetValue(-1, 1, 12.0)
        action.EsmSetValueFloat(-1, 1, 12)
        action.EsmSetValueInt_3(-1, 1, 3)
    end,
    [109] = function()
        local total = (monster.VPop(1) or 0) + (monster.VPopInt(1) or 0) + (monster.VPopFloat(1) or 0)
        action.EsmSetValueFloat(-1, 1, total)
    end,
    [110] = function()
        local x, y, z = monster.ScaleVector(1, 2, 3, 2.0)
        action.ProgSet((x or 0) + (y or 0) + (z or 0))
    end,
    [111] = function()
        action.SetMoveSpeed(cmath.sinf(0.779))
    end,
}
