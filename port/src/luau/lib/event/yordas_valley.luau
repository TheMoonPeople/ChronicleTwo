--!strict
--- Event scenes and toggles shared by the maps of Yorda's Valley.

local vm = require("@lib/vm")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local yordas_valley = {}

--- Plays the scene in which a flying creature carries the character in and drops them to land on the ground.
function yordas_valley.play_flying_creature_drop_landing()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		sound_bank = event.load_sound_effect_file_2(3820) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.load_character_motion_pack(5, "event/e300/e308/e308_mints.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/e300/e308/e308_monica.gltf", "info", 0)
		end
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 8)
		event.set_character_active(1, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_shadow_enabled(1, 0)
		event.set_object_handle_position(0, -1306.0, 200.39, -546.0)
		event.set_object_handle_rotation(0, 0.0, 1.88, 0.0)
		event.set_object_handle_position(1, -169.01, 1296.7, 919.52)
		event.set_object_handle_rotation(1, 0.0, 2.52, 0.0)
		event.set_object_handle_motion(1, "肉つかみ飛び", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2137.92, 789.89, -634.43)
		event.set_camera_sequence_look_at(1501.16, 847.03, -450.95)
		event.move_object_sequence(1, -127.0, 1099.81, 692.26, 90)
		event.play_sound_effect(sound_bank, 0)
		event.play_sound_effect(sound_bank, 1)
		event.fade_in_screen(30)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-1182.17, 240.83, -585.56)
		event.set_camera_sequence_look_at(-1306.0, 230.83, -546.0)
		event.set_character_active(1, 0)
		event.play_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_position(1, -1272.85, 225.03, -556.23)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.move_object_sequence(1, -1272.85, 267.03, -556.23, 60)
		event.set_object_sequence_motion(0, "着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait.frames(60)
		event.fade_out_screen(20)
		wait.frames(20)
	end)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Enables or disables the reverse floor function point and spawns or removes the creature model standing beside it.
function yordas_valley.set_reverse_floor_enabled(enabled: s32)
	event.set_function_point_enabled("", "rev_floor", enabled)
	if enabled == 1 then
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/d03/p00_26a.gltf", "info", 8)
		event.set_character_active(1, 8)
		event.set_character_position(8, -1594.13, 282.8, -492.73)
		event.set_character_rotation(8, 0.0, 0.89, 0.0)
		event.set_character_motion(8, "立ち", 4)
		event.set_scene_status_flags(1, 8, 8)
	else
		event.delete_character(8)
	end
end

return yordas_valley
