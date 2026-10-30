--!strict
-- Shared action helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_de5acdcc()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local acumu_pad: s32 = 0
	local var5: f32 = 0
	prog = action.get_program_value() or prog
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
		var0 = action.get_button_state_2(56) or var0
		if var0 == 0 then
			action.set_invulnerable_time(30)
			action.play_motion("ため攻撃", -1, 6)
			action.create_effect_1("モニカ溜め攻撃")
			action.set_program_value(prog + 1)
		else
			action.run_charge_movement()
		end
		return
	end
	if prog == 1202 then
		var1 = action.get_motion_status() or var1
		var5 = action.get_motion_progress() or var5
		if var5 >= vm.f32(0.12) and var5 < vm.f32(0.626) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if var5 >= vm.f32(0.626) and var5 < vm.f32(0.67) then
			action.shake_camera(6.0, 20)
		end
		if var1 == 4 then
			action.set_program_value(0)
			helper_bac4ec65(2)
		end
		return
	end
end

return helper_de5acdcc
