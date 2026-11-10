--!strict
-- map/s/s55/s55.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_16814()
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
				vm.imod(var5, 10) == 3
				or vm.imod(var5, 10) == 4
				or vm.imod(var5, 10) == 5
				or vm.imod(var5, 10) == 6
				or vm.imod(var5, 10) == 7
				or vm.imod(var5, 10) == 8
				or vm.imod(var5, 10) == 9
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
		helper_888ab2a3(90)
		at = 4
		helper_888ab2a3(30)
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
			local _ = vm.imod(var5, 10) == 3
			local _ = vm.imod(var5, 10) == 4
			local _ = vm.imod(var5, 10) == 5
			local _ = vm.imod(var5, 10) == 6
			local _ = vm.imod(var5, 10) == 7
			local _ = vm.imod(var5, 10) == 8
			local _ = vm.imod(var5, 10) == 9
			var5 = var5 + 1
			local _ = var5 == 0
			var5 = var5 + 1
			var5 = var5 + 1
			helper_038a2e4d(90)
		end
		if at <= 3 then
			helper_038a2e4d(30)
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

--- Helper function.
local function helper_189c4()
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
				or vm.imod(var5, 10) == 6
				or vm.imod(var5, 10) == 7
				or vm.imod(var5, 10) == 8
				or vm.imod(var5, 10) == 9
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
		helper_888ab2a3(90)
		at = 4
		helper_888ab2a3(30)
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
			local _ = vm.imod(var5, 10) == 6
			local _ = vm.imod(var5, 10) == 7
			local _ = vm.imod(var5, 10) == 8
			local _ = vm.imod(var5, 10) == 9
			var5 = var5 + 1
			local _ = var5 == 0
			var5 = var5 + 1
			var5 = var5 + 1
			helper_038a2e4d(90)
		end
		if at <= 3 then
			helper_038a2e4d(30)
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

--- Helper function.
local function helper_1ab74()
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
		helper_888ab2a3(90)
		at = 4
		helper_888ab2a3(30)
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
			helper_038a2e4d(90)
		end
		if at <= 3 then
			helper_038a2e4d(30)
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

--- Helper function.
local function helper_db30()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
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
		var0 = 0
		var1 = -4
		var2 = 0
		var3 = -200
		var4 = 0
		while var0 < 100 do
			if var0 == 0 then
				event.load_character(5, "e540_golem.gltf", "e33a", 8)
			else
				event.copy_character(5, 8, 8 + var0)
			end
			event.set_character_active(8 + var0)
			event.attach_object_handle_to_character(1 + var0, 8 + var0)
			event.set_object_handle_shadow_enabled(1 + var0, 0)
			event.clear_object_sequence(1 + var0)
			event.set_object_sequence_object(1 + var0, 1 + var0)
			if vm.imod(var2, 2) == 0 then
				event.set_character_position(
					8 + var0,
					vm.i32(vm.i32(vm.i32(80 * var1) - 80) + vm.i32(80 * var1)),
					0.0,
					vm.i32(vm.i32(vm.i32(-var2) * 140) + var3)
				)
			else
				event.set_character_position(
					8 + var0,
					vm.i32(vm.i32(80 * var1) + vm.i32(80 * var1)),
					0.0,
					vm.i32(vm.i32(vm.i32(-var2) * 140) + var3)
				)
			end
			var1 = vm.i32(var1 + 1)
			if vm.imod(var0 + 1, 10) == 0 then
				var1 = -4
				var2 = vm.i32(var2 + 1)
				var3 = -200
				var4 = 0
			end
			if var4 == 0 and var3 == 0 then
				var4 = 2
			end
			if var4 ~= 2 then
				if var4 ~= 0 then
					var3 = vm.i32(var3 - 40)
				else
					var3 = vm.i32(var3 + 40)
				end
			else
				var4 = 1
			end
			do
				local out1, out2, out3 = event.get_character_position(8 + var0)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			var8 = event.get_random_number(40.0) or var8
			var8 = vm.f32(var8 - 20.0)
			var5 = vm.f32(var5 + var8)
			var8 = event.get_random_number(100.0) or var8
			var8 = vm.f32(var8 - 50.0)
			var7 = vm.f32(var7 + var8)
			event.set_character_position(8 + var0, var5, var6, var7)
			var9 = vm.float_bits(event.get_random_number(100)) or var9
			if vm.imod(var9, 2) == 0 then
				event.set_object_handle_motion(1 + var0, "走り", 4)
			else
				event.set_object_handle_motion(1 + var0, "走り2", 4)
			end
			event.step_object_handle_motion(1 + var0)
			var8 = event.get_random_number(10.0) or var8
			event.set_object_sequence_motion_time(1 + var0, var8)
			var0 = var0 + 1
		end
		at = 1
		vm.wait(1)
		var0 = 0
		while var0 < 100 do
			event.set_character_active(0, 8 + var0)
			var0 = var0 + 1
		end
		event.change_directory("")
		event.set_object_handle_position(0, 0.0, 2245.12, 8141.98)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(24.0)
		event.set_time_of_day_advancing(0)
		event.move_object_sequence_eased(0, 0.0, 2645.12, 8141.98, 60, 2, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(694.02, 1258.41, 4866.14)
		event.set_camera_sequence_look_at(684.32, 1267.0, 4889.3)
		event.enable_drama_skip()
		event.fade_in_screen(10)
		at = 2
		wait_objects(0)
		at = 3
		helper_888ab2a3(30)
		event.set_camera_sequence_position(2.65, 4414.65, 8676.77)
		event.set_camera_sequence_look_at(2.44, 4392.18, 8614.16)
		at = 4
		helper_888ab2a3(60)
		event.set_camera_sequence_position(0.0, 44.56, 492.2)
		event.set_camera_sequence_look_at(0.0, 52.46, 293.84)
		event.move_camera_sequence_eased(0.0, 93.66, 876.4, 0.0, 50.99, 676.98, 100, 2, 1.0)
		event.set_object_handle_visible(0, 0)
		var0 = 0
		while var0 < 100 do
			event.set_character_active(0, 8 + var0)
			do
				local out1, out2, out3 = event.get_object_handle_position(1 + var0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			event.move_object_sequence(1 + var0, pos_x, pos_y, pos_z + 1200.0, 180)
			var0 = var0 + 1
		end
		at = 5
		helper_888ab2a3(150)
		at = 6
		helper_888ab2a3(20)
		at = 7
		helper_888ab2a3(10)
		event.fade_out_screen(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			var0 = 0
			local _ = var0 < 100
			var0 = var0 + 1
			helper_238b5abc(0)
		end
		if at <= 2 then
			helper_038a2e4d(30)
		end
		if at <= 3 then
			helper_038a2e4d(60)
		end
		if at <= 4 then
			var0 = 0
			local _ = var0 < 100
			var0 = var0 + 1
			helper_038a2e4d(150)
		end
		if at <= 5 then
			helper_038a2e4d(20)
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(524.9)
	event.set_object_handle_visible(0, 1)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.set_character_active(0)
	var0 = 0
	while var0 < 100 do
		event.delete_character(8 + var0)
		var0 = var0 + 1
	end
end

--- Helper function.
local function helper_148e0()
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
					vm.i32(vm.i32(vm.i32(vm.i32(-var7) * 100) + var8) + 6600)
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
		at = 1
		vm.wait(1)
		var5 = 0
		while var5 < 100 do
			event.set_character_active(0, 8 + var5)
			var5 = var5 + 1
		end
		event.change_directory("")
		event.set_object_handle_position(0, 0.0, 1045.1201, 8141.98)
		event.set_object_handle_visible(0, 1)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(24.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.enable_drama_skip()
		event.fade_in_screen(0)
		event.set_camera_sequence_position(619.04, 258.8, 6128.66)
		event.set_camera_sequence_look_at(477.83, 335.0, 6237.76)
		event.move_camera_sequence_eased(619.04, 258.8, 6128.66, 516.77, 361.08, 6275.05, 60, 2, 1.0)
		var5 = 0
		while var5 < 100 do
			if var5 == 0 then
				var5 = var5 + 1
				continue
			end
			event.set_character_active(0, 8 + var5)
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
			event.move_object_sequence(1 + var5, pos_x, pos_y + 300, pos_z + 600.0, 150, 1)
			var5 = var5 + 1
		end
		event.set_character_active(0, 8)
		event.set_object_sequence_position(1, -770.0, 249.39, 6317.22)
		event.move_object_sequence(1, -770.0, 270.4, 6373.33, 20)
		event.set_object_sequence_motion(1, "走り（坂）", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "振り返り", 2)
		event.queue_object_sequence_next_motion(1, "手をあげる", 6)
		event.queue_object_sequence_next_motion(1, "振り返りループ", 4)
		at = 2
		helper_888ab2a3(90)
		at = 3
		helper_888ab2a3(20)
		at = 4
		helper_888ab2a3(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			var5 = 0
			local _ = var5 < 100
			var5 = var5 + 1
			var5 = 0
			local _ = var5 < 100
			local _ = var5 == 0
			var5 = var5 + 1
			var5 = var5 + 1
			helper_038a2e4d(90)
		end
		if at <= 2 then
			helper_038a2e4d(20)
		end
		if at <= 3 then
			helper_038a2e4d(10)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
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

--- Helper function.
local function helper_1ccd0()
	local time: f32 = 0
	vm.section(function()
		event.set_save_flag(540, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(300.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		vm.wait(1)
		event.change_directory("event/e500/e540/")
		event.attach_object_handle_to_map_part_2(0, "p03_s55")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.change_directory("")
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(24.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-403.87, 5081.46, 8018.1)
		event.set_camera_sequence_look_at(-207.83, 4340.06, 7830.0)
		event.enable_drama_skip()
		event.fade_in_screen(0)
		helper_888ab2a3(60)
		helper_888ab2a3(10)
		event.fade_out_screen(0)
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(524.9)
	event.set_object_handle_visible(0, 1)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.set_character_active(0)
end

--- Helper function.
local function helper_1d1d8()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { any } = table.create(29, 0)
	local at: number = 0
	vm.section(function()
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
		event.load_character(5, "e540_canon_l.gltf", "info", 24)
		event.set_character_active(1, 24)
		event.set_scene_character_type(24, 4)
		event.attach_object_handle_to_character(1, 24)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e540_bakuha01.gltf", "info", 13)
		event.set_character_active(1, 13)
		event.attach_object_handle_to_character(2, 13)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		frame[1] = 0
		while frame[1] < 10 do
			if frame[1] == 0 then
				event.load_character(5, "e540_bakuha02.gltf", "info", 14)
			else
				event.copy_character(5, 14, vm.i32(14 + frame[1]))
			end
			event.set_character_active(1, vm.i32(14 + frame[1]))
			event.set_scene_character_type(vm.i32(14 + frame[1]), 4)
			event.attach_object_handle_to_character(vm.i32(10 + frame[1]), vm.i32(14 + frame[1]))
			event.clear_object_sequence(vm.i32(10 + frame[1]))
			event.set_object_sequence_object(vm.i32(10 + frame[1]), vm.i32(10 + frame[1]))
			frame[2] = event.get_random_number(58.0) or frame[2]
			event.set_object_sequence_motion(vm.i32(10 + frame[1]), "爆破02", 4)
			event.set_object_sequence_normal_drive(vm.i32(10 + frame[1]))
			event.set_object_sequence_motion_time(vm.i32(10 + frame[1]), frame[2])
			frame[1] = vm.i32(frame[1] + 1)
		end
		event.load_character(5, "e540_golem.gltf", "e33a", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(3, 8)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.copy_character(5, 8, 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(4, 9)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.copy_character(5, 8, 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(5, 10)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.copy_character(5, 8, 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(6, 11)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		frame[1] = 0
		while frame[1] < 16 do
			if frame[1] == 0 then
				event.load_character(5, "e540_canon_new.gltf", "info", 25)
			else
				event.copy_character(5, 25, vm.i32(25 + frame[1]))
			end
			event.set_character_active(1, vm.i32(25 + frame[1]))
			event.set_scene_character_type(vm.i32(25 + frame[1]), 4)
			event.attach_object_handle_to_character(vm.i32(20 + frame[1]), vm.i32(25 + frame[1]))
			event.clear_object_sequence(vm.i32(20 + frame[1]))
			event.set_object_sequence_object(vm.i32(20 + frame[1]), vm.i32(20 + frame[1]))
			frame[3] = event.get_random_number(6.0) or frame[3]
			if frame[1] >= 8 then
				frame[4] = event.get_random_number(6.0) or frame[4]
				frame[3] = vm.f32(frame[3] + frame[4])
			end
			event.set_object_sequence_motion(vm.i32(20 + frame[1]), "発射", 4)
			event.set_object_sequence_normal_drive(vm.i32(20 + frame[1]))
			event.set_object_sequence_motion_time(vm.i32(20 + frame[1]), frame[3])
			frame[1] = vm.i32(frame[1] + 1)
		end
		event.change_directory("")
		event.set_character_position(25, 450.35, 3680.96, 7972.66)
		event.set_character_rotation(25, 0.96, 1.46, 0.0)
		event.set_character_position(26, 435.87, 3680.96, 7802.53)
		event.set_character_rotation(26, 0.96, 2.24, 0.0)
		event.set_character_position(27, 305.04, 3680.96, 7691.47)
		event.set_character_rotation(27, 0.96, 3.0, 0.0)
		event.set_character_position(28, 132.67, 3680.96, 7703.67)
		event.set_character_rotation(28, 0.96, -2.44, 0.0)
		event.set_character_position(29, -167.88, 3680.96, 7686.37)
		event.set_character_rotation(29, 0.96, 3.0, 0.0)
		event.set_character_position(30, -340.18, 3680.96, 7705.62)
		event.set_character_rotation(30, 0.96, -2.48, 0.0)
		event.set_character_position(31, -449.71, 3680.96, 7837.29)
		event.set_character_rotation(31, 0.96, -1.7, 0.0)
		event.set_character_position(32, -437.68, 3680.96, 8010.44)
		event.set_character_rotation(32, 0.96, -0.92, 0.0)
		event.set_character_position(33, 455.83, 3604.71, 7973.68)
		event.set_character_rotation(33, 0.96, 1.46, 0.0)
		event.set_character_position(34, 443.35, 3603.73, 7795.28)
		event.set_character_rotation(34, 0.96, 2.24, 0.0)
		event.set_character_position(35, 305.48, 3604.05, 7685.46)
		event.set_character_rotation(35, 0.96, 3.0, 0.0)
		event.set_character_position(36, 129.93, 3603.34, 7702.09)
		event.set_character_rotation(36, 0.96, -2.44, 0.0)
		event.set_character_position(37, -167.88, 3602.73, 7686.37)
		event.set_character_rotation(37, 0.96, 3.0, 0.0)
		event.set_character_position(38, -343.8, 3601.56, 7701.06)
		event.set_character_rotation(38, 0.96, -2.48, 0.0)
		event.set_character_position(39, -459.5, 3600.35, 7835.23)
		event.set_character_rotation(39, 0.96, -1.7, 0.0)
		event.set_character_position(40, -442.8, 3599.23, 8012.61)
		event.set_character_rotation(40, 0.96, -0.92, 0.0)
		event.set_function_point_enabled("", "func", 1)
		event.set_function_point_enabled("", "func1", 1)
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		event.set_function_point_enabled("", "func4", 1)
		event.set_function_point_enabled("", "func5", 1)
		event.set_function_point_enabled("", "func6", 1)
		event.set_function_point_enabled("", "func7", 1)
		event.set_function_point_enabled("", "func8", 1)
		event.set_function_point_enabled("", "func9", 1)
		event.set_function_point_enabled("", "func10", 1)
		event.set_function_point_enabled("", "func11", 1)
		event.set_function_point_enabled("", "func12", 1)
		event.set_function_point_enabled("", "func13", 1)
		event.set_function_point_enabled("", "func14", 1)
		event.set_function_point_enabled("", "func15", 1)
		event.set_function_point_enabled("", "func16", 1)
		at = 1
		helper_888ab2a3(7)
		frame[5] = event.get_scene_time_of_day() or frame[5]
		event.set_time_of_day(24.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_look_at(0.0, 3840.0, 8000.0)
		event.set_camera_sequence_angle_height_distance(2.2, -260.0, 700.0)
		event.move_camera_sequence_angle_height_distance_eased(-2.2, -260.0, 700.0, 200, 0, 0.1)
		event.enable_drama_skip()
		event.fade_in_screen(10)
		frame[6] = vm.f32(1.46)
		frame[7] = vm.f32(2.24)
		frame[8] = 3.0
		frame[9] = vm.f32(-2.44)
		frame[10] = 3.0
		frame[11] = vm.f32(-2.48)
		frame[12] = vm.f32(-1.7)
		frame[13] = vm.f32(-0.92)
		frame[14] = vm.f32(1.46)
		frame[15] = vm.f32(2.24)
		frame[16] = 3.0
		frame[17] = vm.f32(-2.44)
		frame[18] = 3.0
		frame[19] = vm.f32(-2.48)
		frame[20] = vm.f32(-1.7)
		frame[21] = vm.f32(-0.92)
		while true do
			frame[22] = 0
			while frame[22] < 16 do
				frame[23] = event.is_character_motion_finished(vm.i32(25 + frame[22])) or frame[23]
				if frame[23] == 1 then
					frame[24] = event.get_random_number(0.8) or frame[24]
					frame[24] = vm.f32(frame[24] - vm.f32(0.4))
					frame[24] = vm.f32(frame[24] + frame[vm.index(vm.i32(frame[22] + 5), 29)])
					frame[24] = event.wrap_angle(frame[24]) or frame[24]
					event.set_object_sequence_rotation(vm.i32(20 + frame[22]), 0.96, frame[24], 0.0)
				end
				frame[22] = vm.i32(frame[22] + 1)
			end
			frame[25] = event.is_camera_sequence_running() or frame[25]
			if frame[25] == 0 then
				break
			else
				at = 2
				vm.wait(2)
			end
		end
		event.set_camera_sequence_position(-129.3, 4840.78, 7873.86)
		event.set_camera_sequence_look_at(-97.75, 4461.75, 7845.38)
		event.move_camera_sequence(-129.3, 4840.78, 7873.86, -97.75, 4461.75, 7845.38, 60)
		while true do
			frame[26] = 0
			while frame[26] < 16 do
				frame[27] = event.is_character_motion_finished(vm.i32(25 + frame[26])) or frame[27]
				if frame[27] == 1 then
					frame[28] = event.get_random_number(0.8) or frame[28]
					frame[28] = vm.f32(frame[28] - vm.f32(0.4))
					frame[28] = vm.f32(frame[28] + frame[vm.index(vm.i32(frame[26] + 5), 29)])
					frame[28] = event.wrap_angle(frame[28]) or frame[28]
					event.delay_object_sequence_rotation_track(vm.i32(20 + frame[26]), 1)
					event.set_object_sequence_rotation(vm.i32(20 + frame[26]), 0.96, frame[28], 0.0)
				end
				frame[26] = vm.i32(frame[26] + 1)
			end
			frame[29] = event.is_camera_sequence_running() or frame[29]
			if frame[29] == 0 then
				break
			else
				at = 3
				vm.wait(3)
			end
		end
		event.set_camera_sequence_position(-838.46, 443.91, 6728.31)
		event.set_camera_sequence_look_at(-626.97, 456.9, 6698.64)
		event.set_character_position(25, 177.21, 2042.6, 7491.21)
		event.set_character_rotation(25, 0.96, 3.14, 0.0)
		event.set_character_position(26, 9.56, 2042.6, 7310.69)
		event.set_character_rotation(26, 0.96, -2.78, 0.0)
		event.set_character_position(27, 248.57, 2042.6, 7876.09)
		event.set_character_rotation(27, 0.96, 2.3, 0.0)
		event.set_character_position(28, 420.71, 2042.6, 7546.56)
		event.set_character_rotation(28, 0.96, -2.42, 0.0)
		event.set_character_position(29, -946.92, 2206.47, 7990.45)
		event.set_character_rotation(29, 0.96, 3.02, 0.0)
		frame[1] = 5
		while frame[1] < 16 do
			event.set_character_active(0, vm.i32(25 + frame[1]))
			frame[1] = vm.i32(frame[1] + 1)
		end
		event.set_object_sequence_position(10, -460.86, 489.96, 6733.35)
		event.set_object_sequence_rotation(10, 0.0, 0.8, 0.0)
		event.set_object_sequence_position(11, -90.64, 396.44, 6295.7)
		event.set_object_sequence_rotation(11, 0.0, 0.08, 0.0)
		event.set_object_sequence_position(12, -264.7, 634.72, 6998.68)
		event.set_object_sequence_rotation(12, 0.0, 0.2, 0.0)
		event.set_object_sequence_position(13, -598.43, 420.84, 6492.57)
		event.set_object_sequence_rotation(13, 0.0, 2.28, 0.0)
		event.set_object_sequence_position(14, -388.61, 444.94, 6499.41)
		event.set_object_sequence_rotation(14, 0.0, -0.88, 0.0)
		event.set_object_sequence_position(15, -413.31, 550.94, 6853.8)
		event.set_object_sequence_rotation(15, 0.0, 0.2, 0.0)
		event.set_object_sequence_position(16, -417.64, 471.91, 6610.58)
		event.set_object_sequence_rotation(16, 0.0, -2.32, 0.0)
		event.set_object_sequence_position(17, -605.07, 555.41, 6886.0)
		event.set_object_sequence_rotation(17, 0.0, -0.4, 0.0)
		event.set_object_sequence_position(18, -673.92, 519.48, 6767.61)
		event.set_object_sequence_rotation(18, 0.0, -2.08, 0.0)
		event.set_object_sequence_position(19, -831.64, 403.7, 6627.72)
		event.set_object_sequence_rotation(19, 0.0, -0.28, 0.0)
		event.set_character_active(8)
		event.set_object_sequence_position(3, -608.57, 411.25, 6691.84)
		event.set_object_sequence_motion(3, "立ち（坂）", 4)
		event.delay_object_sequence_motion_track(3, 16)
		event.set_object_sequence_motion(3, "貫き", 6)
		event.queue_object_sequence_next_motion(3, "貫きループ", 4)
		event.set_object_sequence_position(1, -609.01, 806.46, 6905.24)
		event.set_object_sequence_rotation(1, 1.0, 3.14, 0.0)
		event.delay_object_sequence_position_track(1, 10)
		event.move_object_sequence(1, -606.13, 219.37, 6528.8, 14)
		event.set_object_sequence_position(2, -604.04, 444.49, 6679.45)
		event.set_object_sequence_rotation(2, 0.1, -1.36, 0.0)
		event.set_object_sequence_motion(2, "爆破01", 5)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "爆破01", 4)
		event.set_character_active(10)
		event.set_object_sequence_position(5, -512.25, 453.1, 6750.9)
		event.set_object_sequence_rotation(5, 1.1, 0.0, 0.0)
		event.set_object_sequence_motion(5, "立ち", 1)
		event.set_character_active(9)
		event.set_object_sequence_position(4, -456.64, 452.11, 6732.83)
		event.set_object_sequence_motion(4, "貫き", 6)
		event.queue_object_sequence_next_motion(4, "貫きループ", 4)
		event.set_character_active(11)
		event.set_object_sequence_position(6, -717.2, 357.24, 6583.9)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "走り（坂）", 4)
		event.move_object_sequence(6, -693.84, 475.24, 6889.62, 130, 1)
		at = 4
		helper_888ab2a3(20)
		event.jump_object_sequence(4, -494.52, 397.5, 6251.11, -0.8, 24)
		event.rotate_object_sequence(4, -0.8, 0.0, 0.0, 8)
		at = 5
		helper_888ab2a3(64)
		event.fade_out_screen(4)
		at = 6
		helper_888ab2a3(4)
	end, function(received: { any }): boolean
		if at <= 1 then
			frame[6] = vm.f32(1.46)
			frame[7] = vm.f32(2.24)
			frame[8] = 3.0
			frame[9] = vm.f32(-2.44)
			frame[10] = 3.0
			frame[11] = vm.f32(-2.48)
			frame[12] = vm.f32(-1.7)
			frame[13] = vm.f32(-0.92)
			frame[14] = vm.f32(1.46)
			frame[15] = vm.f32(2.24)
			frame[16] = 3.0
			frame[17] = vm.f32(-2.44)
			frame[18] = 3.0
			frame[19] = vm.f32(-2.48)
			frame[20] = vm.f32(-1.7)
			frame[21] = vm.f32(-0.92)
			frame[22] = 0
			local _ = frame[22] < 16
			local _ = frame[23] == 1
			frame[24] = vm.f32(frame[24] - vm.f32(0.4))
			frame[24] = vm.f32(frame[24] + frame[vm.index(vm.i32(frame[22] + 5), 29)])
			frame[22] = vm.i32(frame[22] + 1)
		end
		if at <= 2 then
			local _ = frame[25] == 0
			frame[26] = 0
			local _ = frame[26] < 16
			local _ = frame[27] == 1
			frame[28] = vm.f32(frame[28] - vm.f32(0.4))
			frame[28] = vm.f32(frame[28] + frame[vm.index(vm.i32(frame[26] + 5), 29)])
			frame[26] = vm.i32(frame[26] + 1)
		end
		if at <= 3 then
			local _ = frame[29] == 0
			frame[1] = 5
			local _ = frame[1] < 16
			frame[1] = vm.i32(frame[1] + 1)
			helper_038a2e4d(20)
		end
		if at <= 4 then
			helper_038a2e4d(64)
		end
		if at <= 5 then
			helper_038a2e4d(4)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(524.9)
	event.set_object_handle_visible(0, 1)
	event.set_time_of_day(frame[5])
	event.set_time_of_day_advancing(1)
	event.set_character_active(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(24)
	event.delete_character(13)
	frame[1] = 0
	while frame[1] < 10 do
		event.delete_character(vm.i32(14 + frame[1]))
		frame[1] = vm.i32(frame[1] + 1)
	end
	frame[1] = 0
	while frame[1] < 16 do
		event.delete_character(vm.i32(25 + frame[1]))
		frame[1] = vm.i32(frame[1] + 1)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_16814()
		at = 3
		helper_189c4()
		at = 4
		helper_1ab74()
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				at = 2
				helper_16814()
				return vm.continue_with(function()
					at = 3
					helper_189c4()
					at = 4
					helper_1ab74()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_189c4()
				return vm.continue_with(function()
					at = 4
					helper_1ab74()
					return
				end)
			end
			if at <= 3 then
				at = 4
				helper_1ab74()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_db30()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 601)
end

--- Event 601, which map data, a script or the engine runs by number.
function script.event_601()
	helper_148e0()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 602)
end

--- Event 602, which map data, a script or the engine runs by number.
function script.event_602()
	helper_1ccd0()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 603)
end

--- Event 603, which map data, a script or the engine runs by number.
function script.event_603()
	helper_1d1d8()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 604)
end

return script
