--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")

--- Helper function.
local function helper_22878665(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: f32, se_id: s32, arg6: s32)
	local angle: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local code: s32 = 0
	local var12: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local at: number = 0
	return vm.guard(function()
		angle = vm.f32(arg2 - vm.f32(3.1415927))
		angle = event.wrap_angle(angle) or angle
		var12 = 0
		code = -10
		event.reset_sphida_power_gauge()
		event.start_sphida_power_gauge()
		while code == -10 do
			event.set_camera_control_rotation(angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			do
				local out1, out2 = event.get_analog_sticks_2()
				var8 = out1 or var8
				var9 = out2 or var9
			end
			event.set_sphida_spin_mark_position(var8, var9)
			if (if var12 == 0 then helper_581cb30c(1) else 0) ~= 0 then
				event.set_sphida_spin_mark_position(0.0, 0.0)
				event.reset_sphida_power_gauge()
				return 1, arg0, arg2, arg3, arg4, arg6
			end
			if helper_581cb30c(0) ~= 0 then
				event.advance_sphida_power_gauge()
				at = 1
				vm.wait(1)
				code = event.get_sphida_power_gauge_result() or code
				if var12 == 0 or code ~= -10 then
					event.play_sound_effect(se_id, 0)
					do
						local out1, out2 = event.get_sphida_power_gauge_cursor_position()
						x = out1 or x
						y = out2 or y
					end
					event.set_event_sprite_type(10 + var12, 0)
					event.set_event_sprite_alpha_blend(10 + var12, 2)
					event.set_event_sprite_texture_rect(10 + var12, 0, 224, 32, 32)
					event.set_event_sprite_draw_pass(10 + var12, 1)
					event.set_event_sprite_size(10 + var12, 32, 32)
					event.set_event_sprite_position(10 + var12, x, y)
					event.set_event_sprite_scale(10 + var12, 0.2, 0.2, 0.2)
					event.attach_object_handle_to_sprite(20 + var12, 10 + var12)
					event.clear_object_sequence(20 + var12)
					event.set_object_sequence_object(20 + var12, 20 + var12)
					event.set_object_sequence_scale(20 + var12, 2, 2, 2, 10)
					event.set_object_sequence_color(20 + var12, 128, 128, 128, 128, 2)
					event.set_object_sequence_color(20 + var12, 128, 128, 128, 0, 8)
					var12 = 1
				end
			else
				at = 2
				vm.wait(2)
			end
			code = event.get_sphida_power_gauge_result() or code
		end
		if code == 5 then
			event.set_sphida_spin_mark_position(0.0, 0.0)
			event.reset_sphida_power_gauge()
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		arg0 = event.get_sphida_shot_power() or arg0
		var15 = event.get_debug_flag() or var15
		if var15 == 1 then
			var15 = event.get_buttons_held() or var15
			if bit32.band(var15, 16) ~= 0 then
				arg0 = 1.0
				code = 0
			end
		end
		if code == 4 then
			arg0 = vm.f32(arg0 * 0.0)
		end
		if code == -3 then
			arg0 = vm.f32(arg0 * vm.f32(0.4))
			var16 = event.get_random_number(0.2) or var16
			var16 = vm.f32(var16 - vm.f32(0.1))
			arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.4)) + var16)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
		end
		if code == 3 then
			arg0 = vm.f32(arg0 * vm.f32(0.4))
			var16 = event.get_random_number(0.2) or var16
			var16 = vm.f32(var16 - vm.f32(0.1))
			arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.4)) + var16)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
		end
		if code == -2 then
			arg0 = vm.f32(arg0 * vm.f32(0.8))
			var16 = event.get_random_number(0.05) or var16
			var16 = vm.f32(var16 - vm.f32(0.025))
			arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.1)) + var16)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
		end
		if code == 2 then
			arg0 = vm.f32(arg0 * vm.f32(0.8))
			var16 = event.get_random_number(0.05) or var16
			var16 = vm.f32(var16 - vm.f32(0.025))
			arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.1)) + var16)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
		end
		if code == -1 then
			arg0 = vm.f32(arg0 * 1.0)
			var16 = event.get_random_number(0.01) or var16
			arg2 = vm.f32(arg2 - var16)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
		end
		if code == 1 then
			arg0 = vm.f32(arg0 * 1.0)
			var16 = event.get_random_number(0.01) or var16
			arg2 = vm.f32(arg2 + var16)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
		end
		if code == 0 then
			arg0 = vm.f32(arg0 * vm.f32(1.1))
			var8 = vm.f32(var8 * arg0)
			var9 = vm.f32(var9 * arg0)
		end
		arg6 = code
		arg2 = event.wrap_angle(arg2) or arg2
		arg3 = var8
		arg4 = var9
		at = 3
		helper_888ab2a3(10)
		return 0, arg0, arg2, arg3, arg4, arg6
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				local _ = helper_dbff9fb6(0)
				local _ = var12 == 0
				var12 = 1
			end
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		if at <= 3 then
			return 0, arg0, arg2, arg3, arg4, arg6
		end
		return nil, arg0, arg2, arg3, arg4, arg6
	end)
end

return helper_22878665
