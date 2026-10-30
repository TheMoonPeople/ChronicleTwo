--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_34f2af89()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var14: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(540, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(300.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e500/e540/")
		event.attach_object_handle_to_map_part_2(0, "p03_s55")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		var5 = 0
		var6 = -4
		var7 = 0
		var8 = -200
		var9 = 0
		while var5 < 100 do
			if var5 == 0 then
				event.load_character(5, "e540_golem.gltf", "e33a", 8)
			else
				event.copy_character(5, 8, 8 + var5)
			end
			event.set_character_active(8 + var5)
			event.attach_object_handle_to_character(1 + var5, 8 + var5)
			event.set_object_handle_shadow_enabled(1 + var5, 0)
			event.clear_object_sequence(1 + var5)
			event.set_object_sequence_object(1 + var5, 1 + var5)
			if vm.imod(var7, 2) == 0 then
				event.set_character_position(
					8 + var5,
					vm.i32(vm.i32(vm.i32(80 * var6) - 80) + vm.i32(80 * var6)),
					150.0,
					vm.i32(vm.i32(vm.i32(vm.i32(-var7) * 100) + var8) + 6500)
				)
			else
				event.set_character_position(
					8 + var5,
					vm.i32(vm.i32(80 * var6) + vm.i32(80 * var6)),
					150.0,
					vm.i32(vm.i32(vm.i32(vm.i32(-var7) * 100) + var8) + 6500)
				)
			end
			var6 = vm.i32(var6 + 1)
			if vm.imod(var5 + 1, 10) == 0 then
				var6 = -4
				var7 = vm.i32(var7 + 1)
				var8 = -200
				var9 = 0
			end
			if var9 == 0 and var8 == 0 then
				var9 = 2
			end
			if var9 ~= 2 then
				if var9 ~= 0 then
					var8 = vm.i32(var8 - 40)
				else
					var8 = vm.i32(var8 + 40)
				end
			else
				var9 = 1
			end
			do
				local out1, out2, out3 = event.get_character_position(8 + var5)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			var3 = event.get_random_number(40.0) or var3
			var3 = vm.f32(var3 - 20.0)
			var0 = vm.f32(var0 + var3)
			var3 = event.get_random_number(100.0) or var3
			var3 = vm.f32(var3 - 50.0)
			var2 = vm.f32(var2 + var3)
			event.set_character_position(8 + var5, var0, var1, var2)
			var4 = vm.float_bits(event.get_random_number(100)) or var4
			if vm.imod(var4, 2) == 0 then
				event.set_object_handle_motion(1 + var5, "走り", 4)
			else
				event.set_object_handle_motion(1 + var5, "走り2", 4)
			end
			event.step_object_handle_motion(1 + var5)
			var3 = event.get_random_number(10.0) or var3
			event.set_object_sequence_motion_time(1 + var5, var3)
			var5 = var5 + 1
		end
		at = 2
		vm.wait(2)
		var5 = 0
		while var5 < 100 do
			event.set_character_active(0, 8 + var5)
			var5 = var5 + 1
		end
		event.change_directory("")
		event.set_object_handle_visible(0, 1)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(24.0)
		event.set_time_of_day_advancing(0)
		event.set_event_map_visible(0)
		event.enable_drama_skip()
		event.fade_in_screen(0)
		event.set_camera_sequence_position(619.04, 258.8, 6128.66)
		event.set_camera_sequence_look_at(477.83, 335.0, 6237.76)
		event.move_camera_sequence_eased(619.04, 258.8, 6128.66, 516.77, 361.08, 6275.05, 60, 2, 1.0)
		var5 = 0
		while var5 < 100 do
			if
				vm.imod(var5, 10) == 0
				or vm.imod(var5, 10) == 1
				or vm.imod(var5, 10) == 2
				or vm.imod(var5, 10) == 3
				or vm.imod(var5, 10) == 4
				or vm.imod(var5, 10) == 5
			then
				event.set_character_active(0, 8 + var5)
				var5 = var5 + 1
				continue
			end
			if var5 == 0 then
				var5 = var5 + 1
				continue
			end
			event.set_character_active(8 + var5)
			event.reset_object_handle_dynamic_animation(1 + var5)
			do
				local out1, out2, out3 = event.get_object_handle_position(1 + var5)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var14 = vm.float_bits(event.get_random_number(100)) or var14
			if vm.imod(var14, 2) == 0 then
				event.set_object_handle_motion(1 + var5, "走り（坂）", 4)
			else
				event.set_object_handle_motion(1 + var5, "走り2（坂）", 4)
			end
			event.step_object_handle_motion(1 + var5)
			var3 = event.get_random_number(10.0) or var3
			event.set_object_sequence_motion_time(1 + var5, var3)
			event.move_object_sequence(1 + var5, pos_x, pos_y + 300, pos_z + 600.0, 120, 1)
			var5 = var5 + 1
		end
		event.set_object_sequence_position(1, -770.0, 249.39, 6317.22)
		event.move_object_sequence(1, -770.0, 270.4, 6373.33, 20)
		event.set_object_sequence_motion(1, "走り（坂）", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "振り返り", 2)
		event.queue_object_sequence_next_motion(1, "手をあげる", 6)
		event.queue_object_sequence_next_motion(1, "振り返りループ", 4)
		at = 3
		wait_frames(90)
		at = 4
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var5 = 0
			var6 = -4
			var7 = 0
			var8 = -200
			var9 = 0
			var6 = var6 + 1
			var6 = -4
			local _ = vm.imod(var7, 2) == 0
			var7 = var7 + 1
			var8 = -200
			var9 = 0
			local _ = var9 == 0
			var9 = 2
			local _ = var8 == 0
			var8 = var8 - 40
			var8 = var8 + 40
			local _ = var9 ~= 2
			local _ = var9
			var9 = 1
			var3 = vm.f32(var3 - 20.0)
			var0 = vm.f32(var0 + var3)
			var3 = vm.f32(var3 - 50.0)
			var2 = vm.f32(var2 + var3)
			local _ = var5 < 100
			local _ = var5 == 0
			local _ = vm.imod(var5 + 1, 10) == 0
			var5 = var5 + 1
		end
		if at <= 2 then
			var5 = 0
			local _ = var5 < 100
			var5 = var5 + 1
			var5 = 0
			local _ = var5 < 100
			local _ = vm.imod(var5, 10) == 0
			local _ = vm.imod(var5, 10) == 1
			local _ = vm.imod(var5, 10) == 2
			local _ = vm.imod(var5, 10) == 3
			local _ = vm.imod(var5, 10) == 4
			local _ = vm.imod(var5, 10) == 5
			var5 = var5 + 1
			local _ = var5 == 0
			var5 = var5 + 1
			var5 = var5 + 1
			wait_frames_skipping(90)
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 5
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.set_event_map_visible(1)
	event.set_event_projection(524.9)
	event.set_object_handle_visible(0, 1)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.set_character_active(0)
	var5 = 0
	while var5 < 100 do
		event.delete_character(8 + var5)
		var5 = var5 + 1
	end
end

return helper_34f2af89
