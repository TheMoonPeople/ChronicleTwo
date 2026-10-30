return {
    [100] = function()
        local v = action.get_program_value()
        action.set_program_value(v)
    end,
    [101] = function()
        action.set_program_value(if action.get_attack_type() == nil then 1 else 0)
    end,
    [102] = function()
        action.start_palette_flash(4, "テスト")
    end,
    [103] = function()
        action.set_move_speed(1.5)
    end,
    [104] = function()
        action.call_command(200, 1, 2.5, "x", true)
    end,
    [105] = function()
        action.set_program_value(action.reset_script_entries_1())
    end,
    [106] = function()
        action.reset_script_entries()
    end,
    [107] = function()
        print("a", 1, 2.5, true, nil, "b\n")
    end,
    [108] = function()
        action.set_effect_value(-1, 1, 12.0)
        action.set_effect_value_float(-1, 1, 12)
        action.set_effect_value_int_3(-1, 1, 3)
    end,
    [109] = function()
        local total = (monster.get_variable(1) or 0) + (monster.get_variable_int(1) or 0) + (monster.get_variable_float(1) or 0)
        action.set_effect_value_float(-1, 1, total)
    end,
    [110] = function()
        local x, y, z = monster.scale_vector(1, 2, 3, 2.0)
        action.set_program_value((x or 0) + (y or 0) + (z or 0))
    end,
    [111] = function()
        action.set_move_speed(cmath.sinf(0.779))
    end,
}
