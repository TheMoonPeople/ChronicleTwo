--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5877209d = require("@lib/event/helper_5877209d")
local helper_788e145d = require("@lib/event/helper_788e145d")
local helper_a9c4b39b = require("@lib/event/helper_a9c4b39b")
local helper_b669d1f8 = require("@lib/event/helper_b669d1f8")
local helper_f7b0da40 = require("@lib/event/helper_f7b0da40")

--- Helper function.
local function helper_f033341e(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local angle: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local at: number = 0
	return vm.guard(function()
		var4 = 60
		var5 = 76
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		event.set_follow_camera_following(1)
		event.set_camera_control_enabled(1)
		event.set_camera_rotation_cancel_mask(43)
		event.set_camera_speed(6.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_target(var6, var7 + 20.0, var8)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.set_camera_control_range(10.0, 30.0, 80.0, 120.0)
		while true do
			do
				local out1, out2 = event.get_analog_sticks_2()
				var14 = out1 or var14
				var15 = out2 or var15
			end
			do
				local out1, out2, out3 = event.get_character_position(0)
				var16 = out1 or var16
				var17 = out2 or var17
				var18 = out3 or var18
			end
			do
				local out1, out2, out3 = event.get_character_rotation(0)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			if var14 ~= 0.0 then
				if
					helper_b669d1f8(
						var16,
						var17,
						var18,
						vm.f32(var11 + vm.f32(1.5707964)),
						vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
					) == 1
				then
					var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
				else
					var14 = 0.0
				end
			end
			event.set_character_rotation(0, var10, var11, var12)
			if var4 <= 0 then
				event.set_character_motion(0, "待機")
				var5 = 76
				var4 = 400
			else
				if var14 ~= 0.0 then
					event.set_character_motion(0, "かまえバタバタ")
					var4 = 200
					var5 = 0
				elseif var5 <= 0 then
					event.set_character_motion(0, "かまえ")
				else
					var5 = var5 - 1
				end
				var4 = var4 - 1
			end
			var13 = arg1
			var13 = vm.f32(var13 + var15)
			if var13 <= 5.0 then
				var13 = 5.0
			end
			if var13 >= 30.0 then
				var13 = 30.0
			end
			arg0 = var11
			arg1 = var13
			event.set_sphida_carry_angle(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)
			angle = vm.f32(arg0 - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			event.set_camera_control_rotation(angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			helper_5877209d(arg0, arg1, arg2)
			if helper_f7b0da40(32) ~= 0 then
				event.set_character_motion(0, "かまえ")
				var3 = 0
				break
			elseif helper_f7b0da40(64) ~= 0 then
				var3 = 1
				break
			else
				at = 1
				vm.wait(1)
			end
		end
		helper_a9c4b39b()
		at = 2
		vm.wait(2)
		return var3, arg0, arg1
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_788e145d()
			end
			return var3, arg0, arg1
		end
		return nil, arg0, arg1
	end)
end

return helper_f033341e
