--!strict
-- Shared action helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9d1f223a()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local acumu_pad: s32 = 0
	local var6: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("5剣1", -1, 6)
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.309) and var4 <= vm.f32(0.394) then
			action.set_move_impulse(4.75, 0.0, 1)
		end
		if var4 >= vm.f32(0.647) and var4 <= 1.0 then
			action.set_move_impulse(0.92, 0.0, 1)
		end
		acumu_pad = action.get_charge_steps() or acumu_pad
		if acumu_pad > 10 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if var4 >= 0.5 and var4 <= vm.f32(0.562) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5剣2", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 101 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.238) and var4 <= vm.f32(0.418) then
			action.set_move_impulse(2.56, 0.0, 1)
		end
		if var4 >= vm.f32(0.476) and var4 <= vm.f32(0.529) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				var6 = action.get_stick_facing_alignment() or var6
				if var6 > vm.f32(0.6) then
					action.play_motion("ふっとばし", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5剣3", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(prog + 1)
					action.reset_button_history()
					action.set_murderous(0, 3)
				end
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 102 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.27) and var4 <= vm.f32(0.33) then
			action.set_move_impulse(3.89, 0.0, 1)
		end
		if var4 >= vm.f32(0.54) and var4 <= 1.0 then
			action.set_move_impulse(-0.919, 0.0, 1)
		end
		if var4 >= vm.f32(0.51) and var4 <= vm.f32(0.57) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5剣4", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 103 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.291) and var4 <= vm.f32(0.423) then
			action.set_move_impulse(2.25, 0.0, 1)
		end
		if var4 >= vm.f32(0.609) and var4 <= 1.0 then
			action.set_move_impulse(0.57, 0.0, 1)
		end
		if var4 >= vm.f32(0.58) and var4 <= vm.f32(0.609) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5剣5", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 104 then
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.225) and var4 <= vm.f32(0.637) then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		if var4 >= 0.75 and var4 <= 1.0 then
			action.set_move_impulse(0.825, 0.0, 1)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
	if prog == 105 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.6) then
			action.set_move_impulse(2.5, 0.0, 1)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

return helper_9d1f223a
