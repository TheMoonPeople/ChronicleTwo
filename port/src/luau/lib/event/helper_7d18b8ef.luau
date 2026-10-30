--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_7d18b8ef()
	local var6: s32 = 0
	local amplitude_2: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(540, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(116)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e500/e540/")
		event.load_character(5, "e540_jet.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.copy_character(5, 32, 33)
		event.set_character_active(0, 33)
		event.load_character(5, "e540_parm1.gltf", "info", 34)
		event.set_character_active(1, 34)
		event.load_character(5, "e540_parm2.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.load_character(5, "e540_parm3.gltf", "info", 36)
		event.set_character_active(1, 36)
		event.load_character(5, "e540_parm4.gltf", "info", 37)
		event.set_character_active(1, 37)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(0, "p10_f0401")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p20_f0401")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_3(1, "p22_f0401", "f0401_27-m-0")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_3(1, "p22_f0401", "f0401_27-m-1")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_3(1, "p22_f0401", "f0401_25-m")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm1")
		event.set_character_position(34, -2400.0, 1700.0, 2600.0)
		event.set_character_rotation(34, 0.0, 1.6, 0.0)
		event.set_character_motion(34, "射出1", 5)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm2")
		event.set_character_position(35, -2100.0, 1700.0, 5300.0)
		event.set_character_rotation(35, 0.0, 2.4, 0.0)
		event.set_character_motion(35, "射出1", 5)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm3")
		event.set_character_position(36, 2200.0, 1700.0, 5300.0)
		event.set_character_rotation(36, 0.0, -2.4, 0.0)
		event.set_character_motion(36, "射出1", 5)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm4")
		event.set_character_position(37, 2400.0, 1700.0, 2600.0)
		event.set_character_rotation(37, 0.0, -1.6, 0.0)
		event.set_character_motion(37, "射出1", 5)
		event.set_character_position(32, -930.0, 750.0, 2330.0)
		event.set_character_position(33, 930.0, 750.0, 2330.0)
		event.enable_drama_skip()
		event.set_event_projection(524.9)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 2449.87, -2065.79)
		event.set_camera_sequence_look_at(0.0, 2430.55, -2020.14)
		event.move_camera_sequence_eased(0.0, 2785.4, -2065.79, 0.0, 2787.08, -2020.14, 120, 2, 1.0)
		event.fade_in_screen(10)
		at = 2
		wait_camera()
		event.set_camera_sequence_position(-2108.31, 1992.04, 1136.27)
		event.set_camera_sequence_look_at(-2039.71, 1945.46, 1320.75)
		at = 3
		wait_frames(4)
		event.set_character_motion(34, "射出1", 6)
		at = 4
		wait_frames(10)
		event.set_character_motion(35, "射出1", 6)
		at = 5
		wait_frames(30)
		event.set_camera_sequence_position(1955.54, 2093.16, 785.71)
		event.set_camera_sequence_look_at(1839.34, 1936.52, 1240.3)
		at = 6
		wait_frames(4)
		event.set_character_motion(37, "射出1", 6)
		at = 7
		wait_frames(10)
		event.set_character_motion(36, "射出1", 6)
		at = 8
		wait_frames(30)
		event.set_camera_sequence_position(1709.28, 50.66, -919.25)
		event.set_camera_sequence_look_at(1370.18, 511.19, 109.87)
		event.set_event_projection(390.0)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_visible(32, 1, 1, 0.016666668)
		event.set_character_visible(33, 1, 1, 0.016666668)
		var6 = 0
		amplitude_2 = vm.f32(0.02)
		while var6 < 120 do
			var6 = var6 + 1
			at = 9
			vm.wait(9)
			if vm.imod(var6, 4) == 0 then
				event.clear_camera_sequence()
				event.shake_camera_sequence(0.0, amplitude_2, 0.0, -1)
				amplitude_2 = vm.f32(amplitude_2 * vm.f32(1.2))
			end
			if var6 == 110 then
				event.fade_out_screen(10)
			end
		end
		at = 10
		wait_frames(2)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			wait_frames_skipping(4)
		end
		if at <= 3 then
			wait_frames_skipping(10)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			wait_frames_skipping(4)
		end
		if at <= 6 then
			wait_frames_skipping(10)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		if at <= 8 then
			var6 = 0
			amplitude_2 = vm.f32(0.02)
			local _ = var6 < 120
			var6 = var6 + 1
		end
		if at <= 9 then
			amplitude_2 = vm.f32(amplitude_2 * vm.f32(1.2))
			wait_frames_skipping(2)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(524.9)
	event.set_character_active(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
end

return helper_7d18b8ef
