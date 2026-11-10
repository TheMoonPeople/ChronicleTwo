--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_56390e5a()
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local rot_x: f32 = 0
	local var9: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_031.sound.json")
	vm.wait(1)
	helper_479dc9e9()
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, var3 =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, var3)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, var3)
	var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or var4
	var5 = event.get_triggered_event_data_2(9) or var5
	event.attach_object_handle_to_map_part_3(0, var5, "d02w10_4-m0")
	event.attach_object_handle_to_map_part_3(1, var5, "d02w10_3-m0")
	event.set_object_handle_visible(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.load_character(5, "event/dng/g01_gkey.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(2, 12)
	event.set_object_handle_position(2, 0.0, 0.0, 145.0)
	event.set_object_handle_motion(2, "発動", 5)
	event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
	var6 = vm.bits_float(event.get_triggered_event_data_2(11)) or var6
	var7 = 0
	while var7 < 10 do
		event.swing_camera_control_to_angle(var6)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var7 = var7 + 1
		vm.wait(3)
	end
	event.play_sound_effect(var4, 0)
	event.set_object_handle_motion(2, "発動", 6)
	var7 = 0
	while var7 < 20 do
		event.swing_camera_control_to_angle(var6)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var7 = var7 + 1
		vm.wait(4)
	end
	wait_frames(20)
	event.set_object_handle_visible(0, 0)
	wait_frames(37)
	event.play_sound_effect(var4, 1)
	var9 = vm.f32(-0.001)
	rot_x = 0.0
	while rot_x > vm.f32(-1.57) do
		event.set_object_sequence_rotation(1, rot_x, var3, 0.0)
		var9 = vm.f32(var9 * vm.f32(1.06))
		rot_x = vm.f32(rot_x + var9)
		vm.wait(7)
	end
	event.play_sound_effect(var4, 5)
	var7 = 0
	while var7 < 3 do
		while true do
			var9 = vm.f32(var9 * vm.f32(0.6))
			rot_x = vm.f32(rot_x - var9)
			event.set_object_sequence_rotation(1, rot_x, var3, 0.0)
			if var9 > vm.f32(-0.001) then
				break
			else
				vm.wait(8)
			end
		end
		var9 = vm.f32(var9 + vm.f32(-0.001))
		while true do
			var9 = vm.f32(var9 * vm.f32(1.2))
			rot_x = vm.f32(rot_x + var9)
			event.set_object_sequence_rotation(1, rot_x, var3, 0.0)
			if rot_x < vm.f32(-1.57) then
				break
			else
				vm.wait(9)
			end
		end
		var7 = var7 + 1
	end
	wait_frames(10)
	event.delete_character(12)
	event.reset_follow_camera(0)
	event.finish_event()
end

return helper_56390e5a
