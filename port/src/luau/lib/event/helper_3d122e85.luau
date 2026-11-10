--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_6cf80642 = require("@lib/event/helper_6cf80642")
local helper_b76e3b36 = require("@lib/event/helper_b76e3b36")
local helper_f97100db = require("@lib/event/helper_f97100db")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3d122e85()
	local var0: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		at = 2
		wait_frames(30)
		event.load_map_sounds(2237)
		var0 = event.load_sound_effect_file_2(2237) or var0
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		helper_f97100db()
		at = 3
		helper_b76e3b36()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 400.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(1, "p01_shadow-0")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(2, 32)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(3, 33)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-304.68, 110.91, -288.45)
		event.set_camera_sequence_look_at(-158.49, 89.18, -46.7)
		event.fade_in_screen(30)
		at = 4
		wait_frames(30)
		event.set_character_active(1, 32)
		event.set_object_sequence_position(2, 30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(3, -30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		event.move_object_sequence_eased(0, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(1, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(3, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.play_sound_effect(var0, 3)
		at = 5
		wait_objects(0)
		event.fade_out_screen(30)
		at = 6
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_1ef0d4b2()
			helper_6cf80642()
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_effect_manager()
	event.delete_character(32)
	event.delete_character(33)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_character_active(0)
end

return helper_3d122e85
