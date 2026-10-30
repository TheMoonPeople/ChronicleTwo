--!strict
-- Shared action helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_d6400fa5()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local acumu_pad: s32 = 0
	local var8: f32 = 0
	prog = action.get_program_value() or prog
	var0 = action.get_button_state_2(56) or var0
	if prog == 1200 then
		action.play_motion("ためループ")
		acumu_pad = action.get_charge_steps() or acumu_pad
		if acumu_pad == 20 then
			action.start_palette_flash(220, 255, 255, 1, 12)
		end
		if acumu_pad > 20 then
			action.set_program_value(prog + 1)
		end
		if acumu_pad == 0 then
			action.set_program_value(0)
			helper_bac4ec65(2)
		end
		action.run_charge_movement()
		return
	end
	if prog == 1201 then
		if var0 == 0 then
			action.set_invulnerable_time(30)
			action.play_motion("ため攻撃", -1, 6)
			action.get_position()
			action.create_effect_1("ユリス溜め攻撃")
			action.set_program_value(prog + 1)
		else
			action.run_charge_movement()
		end
		return
	end
	if prog == 1202 then
		var8 = action.get_motion_progress() or var8
		if var8 >= vm.f32(0.202) and var8 <= vm.f32(0.472) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
			helper_bac4ec65(2)
		end
		return
	end
end

return helper_d6400fa5
