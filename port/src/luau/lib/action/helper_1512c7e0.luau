--!strict
-- Shared action helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_1512c7e0()
	print("DAMAGE!\n")
	action.set_charge_effect_mode(0)
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ後", -1, 2)
	helper_bac4ec65(8)
	action.set_program_value(0)
end

return helper_1512c7e0
