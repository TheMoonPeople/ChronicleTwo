--!strict
--- Character setup, exits and progress markers for the Fish Monster Swamp map.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local fish_monster_swamp = {}

--- Asks whether to leave and fades out when accepted, returning whether the player is leaving.
function fish_monster_swamp.confirm_exit()
	local exit_choice: any = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		step = 1
		exit_choice = message.ask_yes_no(6, 16)
		if exit_choice == 0 then
			event.fade_out_screen(30)
			step = 2
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if step <= 2 then
			if step == 1 then
				exit_choice = received[1] :: number
			end
			if step <= 1 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Deletes the swamp characters.
function fish_monster_swamp.delete_characters()
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
end

--- Disables every story function point of the swamp.
function fish_monster_swamp.disable_function_points()
	event.set_function_point_enabled("", "fc_e220", 0)
	event.set_function_point_enabled("", "fc_e230", 0)
	event.set_function_point_enabled("", "fc_e235", 0)
	event.set_function_point_enabled("", "fc_e247", 0)
	event.set_function_point_enabled("", "fc_e253", 0)
	event.set_function_point_enabled("", "next_floor", 0)
	event.set_function_point_enabled("", "item_e245", 0)
	event.set_function_point_enabled("", "itemget_paplle", 0)
	event.set_function_point_enabled("", "itemget_mimi", 0)
end

--- Returns the absolute value of a number.
function fish_monster_swamp.get_absolute_value(value: any)
	if value < 0 then
		value = vm.wrap(value * -1)
	end
	return value
end

--- Deactivates the four swamp resident characters.
function fish_monster_swamp.hide_residents()
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
end

--- Calls the empty toggle handler with 1 and then 0.
function fish_monster_swamp.ignore_both_toggles()
	fish_monster_swamp.ignore_toggle(1)
	fish_monster_swamp.ignore_toggle(0)
end

--- Accepts a toggle value and does nothing.
function fish_monster_swamp.ignore_toggle(enabled: s32) end

--- Loads and places the swamp characters and enables the function points for the current progress.
function fish_monster_swamp.load_characters(include_residents: s32)
	local flag_28: s32 = 0
	local flag_253: s32 = 0
	local flag_240: s32 = 0
	local flag_245: s32 = 0
	event.initialize_event()
	event.get_save_counter(3)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	if include_residents ~= 0 then
		event.load_character(4, "event/e200/e220/e220_noam.gltf", "info", 9)
		event.set_scene_character_number(9, 153)
		event.set_character_active(9)
		event.set_character_position(9, 2199.07, 29.83, 981.55)
		event.set_character_rotation(9, 0.0, 2.68, 0.0)
		event.set_character_motion(9, "釣り")
		flag_28 = event.get_save_flag(28) or flag_28
		if flag_28 == 0 then
			event.attach_object_handle_to_character(0, 9)
			event.set_object_handle_frame_draw_flag(0, "wine", 0)
		end
		event.change_directory("event/e200/e215/")
		event.load_character(4, "e215_wicky.gltf", "info", 11)
		event.set_scene_character_number(11, 152)
		event.set_character_active(11)
		event.set_character_position(11, 2022.78, 0.01, 1090.61)
		event.set_character_rotation(11, 0.0, 0.0, 0.0)
		event.set_character_motion(11, "寝そべってる")
		event.load_character(4, "e215_mogri.gltf", "info", 12)
		event.set_scene_character_number(12, 150)
		event.set_character_active(12)
		event.set_character_position(12, 1895.53, -3.91, 1206.14)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_motion(12, "座り")
		event.change_directory("")
		event.load_character(4, "event/nanahige/p02_07a.gltf", "info", 10)
		event.set_scene_character_number(10, 155)
		event.set_character_active(10)
		event.set_character_position(10, 1824.39, 0.01, 1158.94)
		event.set_character_rotation(10, 0.0, 0.04, 0.0)
		event.set_character_motion(10, "立ち")
		event.set_character_near_fade_distance(10, 15.0)
		event.load_character(4, "event/e200/e230/e230_dokuring.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.set_character_position(13, -1892.15, 3.14, 941.97)
		event.set_character_rotation(13, 3.1415927, 0.0, 0.0)
		event.set_character_scale(13, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 15)
		event.set_character_active(0, 15)
		event.set_character_position(15, -1883.07, 3.14, 938.36)
		event.set_character_rotation(15, 3.1415927, 0.0, 0.0)
		event.set_character_scale(15, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 16)
		event.set_character_active(0, 16)
		event.set_character_position(16, -1885.02, 3.14, 931.43)
		event.set_character_rotation(16, 3.1415927, 0.0, 0.0)
		event.set_character_scale(16, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 17)
		event.set_character_active(0, 17)
		event.set_character_position(17, -1896.36, 3.14, 935.12)
		event.set_character_rotation(17, 3.1415927, 0.0, 0.0)
		event.set_character_scale(17, 2.0, 2.0, 2.0)
	end
	event.load_character(4, "event/e200/e230/e230_utan.gltf", "info", 8)
	event.set_character_active(1, 8)
	flag_253 = event.get_save_flag(253) or flag_253
	if flag_253 == 0 then
		event.set_character_position(8, -1938.91, 0.4, 1036.52)
		event.set_character_rotation(8, 0.0, 2.44, 0.0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-0", 1)
		event.set_function_point_enabled("p01_s0501", "invent_2005-1", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa01-0", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa03-0", 0)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050119-c")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050120-c")
		event.set_object_handle_visible(0, 0)
	else
		event.set_character_position(8, -2202.71, 0.4, 759.61)
		event.set_character_rotation(8, 0.0, 2.16, 0.0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-0", 0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-1", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa01-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa03-0", 1)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050119-c")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050120-c")
		event.set_object_handle_visible(0, 1)
	end
	flag_240 = event.get_save_flag(240) or flag_240
	flag_245 = event.get_save_flag(245) or flag_245
	event.attach_object_handle_to_map_part_2(0, "p08_s0501")
	if flag_240 ~= 0 and flag_245 == 0 then
		event.load_character(4, "chara/b04a.gltf", "b04a", 14)
		event.set_character_active(1, 14)
		event.set_character_position(14, -127.39, 0.0, -701.37)
		event.set_character_rotation(14, 0.0, -1.68, 0.0)
		event.set_scene_status_flags(1, 14, 256, 0)
		event.set_character_draw_distance(14, 2400.0)
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 1)
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 0)
		event.set_object_handle_visible(0, 0)
	end
end

--- Loads the swamp characters, including residents only while the progress counter is below seven.
function fish_monster_swamp.load_characters_by_progress()
	local progress_counter: s32 = 0
	progress_counter = event.get_save_counter(3) or progress_counter
	if progress_counter < 7 then
		fish_monster_swamp.load_characters(1)
	else
		fish_monster_swamp.load_characters(0)
	end
end

--- Loads and places the swamp characters and enables the function points for the current progress, with a wide near-fade distance for one resident.
function fish_monster_swamp.load_characters_wide_near_fade(include_residents: s32)
	local flag_28: s32 = 0
	local flag_253: s32 = 0
	local flag_240: s32 = 0
	local flag_245: s32 = 0
	event.initialize_event()
	event.get_save_counter(3)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	if include_residents ~= 0 then
		event.load_character(4, "event/e200/e220/e220_noam.gltf", "info", 9)
		event.set_scene_character_number(9, 153)
		event.set_character_active(9)
		event.set_character_position(9, 2199.07, 29.83, 981.55)
		event.set_character_rotation(9, 0.0, 2.68, 0.0)
		event.set_character_motion(9, "釣り")
		flag_28 = event.get_save_flag(28) or flag_28
		if flag_28 == 0 then
			event.attach_object_handle_to_character(0, 9)
			event.set_object_handle_frame_draw_flag(0, "wine", 0)
		end
		event.change_directory("event/e200/e215/")
		event.load_character(4, "e215_wicky.gltf", "info", 11)
		event.set_scene_character_number(11, 152)
		event.set_character_active(11)
		event.set_character_position(11, 2022.78, 0.01, 1090.61)
		event.set_character_rotation(11, 0.0, 0.0, 0.0)
		event.set_character_motion(11, "寝そべってる")
		event.load_character(4, "e215_mogri.gltf", "info", 12)
		event.set_scene_character_number(12, 150)
		event.set_character_active(12)
		event.set_character_position(12, 1895.53, -3.91, 1206.14)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_motion(12, "座り")
		event.change_directory("")
		event.load_character(4, "event/nanahige/p02_07a.gltf", "info", 10)
		event.set_scene_character_number(10, 155)
		event.set_character_active(10)
		event.set_character_position(10, 1824.39, 0.01, 1158.94)
		event.set_character_rotation(10, 0.0, 0.04, 0.0)
		event.set_character_motion(10, "立ち")
		event.set_character_near_fade_distance(10, 25.0)
		event.load_character(4, "event/e200/e230/e230_dokuring.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.set_character_position(13, -1892.15, 3.14, 941.97)
		event.set_character_rotation(13, 3.1415927, 0.0, 0.0)
		event.set_character_scale(13, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 15)
		event.set_character_active(0, 15)
		event.set_character_position(15, -1883.07, 3.14, 938.36)
		event.set_character_rotation(15, 3.1415927, 0.0, 0.0)
		event.set_character_scale(15, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 16)
		event.set_character_active(0, 16)
		event.set_character_position(16, -1885.02, 3.14, 931.43)
		event.set_character_rotation(16, 3.1415927, 0.0, 0.0)
		event.set_character_scale(16, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 17)
		event.set_character_active(0, 17)
		event.set_character_position(17, -1896.36, 3.14, 935.12)
		event.set_character_rotation(17, 3.1415927, 0.0, 0.0)
		event.set_character_scale(17, 2.0, 2.0, 2.0)
	end
	event.load_character(4, "event/e200/e230/e230_utan.gltf", "info", 8)
	event.set_character_active(1, 8)
	flag_253 = event.get_save_flag(253) or flag_253
	if flag_253 == 0 then
		event.set_character_position(8, -1938.91, 0.4, 1036.52)
		event.set_character_rotation(8, 0.0, 2.44, 0.0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-0", 1)
		event.set_function_point_enabled("p01_s0501", "invent_2005-1", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa01-0", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa03-0", 0)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050119-c")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050120-c")
		event.set_object_handle_visible(0, 0)
	else
		event.set_character_position(8, -2202.71, 0.4, 759.61)
		event.set_character_rotation(8, 0.0, 2.16, 0.0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-0", 0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-1", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa01-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa03-0", 1)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050119-c")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050120-c")
		event.set_object_handle_visible(0, 1)
	end
	flag_240 = event.get_save_flag(240) or flag_240
	flag_245 = event.get_save_flag(245) or flag_245
	event.attach_object_handle_to_map_part_2(0, "p08_s0501")
	if flag_240 ~= 0 and flag_245 == 0 then
		event.load_character(4, "chara/b04a.gltf", "b04a", 14)
		event.set_character_active(1, 14)
		event.set_character_position(14, -127.39, 0.0, -701.37)
		event.set_character_rotation(14, 0.0, -1.68, 0.0)
		event.set_scene_status_flags(1, 14, 256, 0)
		event.set_character_draw_distance(14, 2400.0)
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 1)
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 0)
		event.set_object_handle_visible(0, 0)
	end
end

--- Plays the skippable entrance scene where the player crosses a log and jumps down into the swamp.
function fish_monster_swamp.play_entrance_scene(
	world_x: f32,
	world_y: f32,
	world_z: f32,
	world_rotation: f32
)
	local sound_id: s32 = 0
	local angle: f32 = 0
	local playable_character: s32 = 0
	local camera_angle: f32 = 0
	local step: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		step = 1
		vm.wait(1)
		event.initialize_event()
		event.enable_drama_skip()
		sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or sound_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		angle = event.wrap_angle(angle) or angle
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.load_character_motion_pack(5, "dungeon/chara/mints_01in.gltf", "info", 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "dungeon/chara/monica_01in.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 116.96, 18.76, 19.22)
		event.set_object_sequence_rotation(0, 0.0, -1.96, 0.0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(186.89, 58.05, -1.19)
		event.set_camera_sequence_look_at(50.97, 32.07, 20.9)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		if playable_character == 0 then
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 140)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 130)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			step = 2
			object.wait_until_done(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.3)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		else
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 60)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 50)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			step = 3
			object.wait_until_done(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.2)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		end
		event.set_object_handle_footstep_sound(0, 16)
		step = 4
		wait.frames(14)
		event.play_sound_effect(sound_id, 2)
		event.jump_object_sequence(0, -85.0, 0.0, 50.0, -0.25, 30)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 20)
		step = 5
		wait.frames(16)
		step = 6
		object.wait_until_done(0)
		event.play_sound_effect(sound_id, 4)
		step = 7
		wait.frames(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -170.0, 0.0, 50.0, 50)
		step = 8
		camera.wait_until_done()
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			camera_angle = out2 or camera_angle
		end
		event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
		camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
		camera_angle = event.wrap_angle(camera_angle) or camera_angle
		event.set_camera_sequence_angle_height_distance(camera_angle, 5.0, 100.0)
		step = 9
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		step = 10
		wait.frames(15)
		event.cancel_drama_scene_skip()
	end, function(received: { any }): boolean
		if step <= 1 then
			cutscene.skip_command(0)
		end
		if step <= 2 then
			cutscene.skip_command(0)
		end
		if step <= 3 then
			wait.frames_skipping(14)
		end
		if step <= 4 then
			wait.frames_skipping(16)
		end
		if step <= 5 then
			cutscene.skip_command(0)
		end
		if step <= 6 then
			wait.frames_skipping(30)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
			cutscene.skip_command(0)
		end
		if step <= 9 then
			wait.frames_skipping(15)
		end
		return true
	end)
	step = 11
	vm.entry(11)
	event.fade_in_screen(0)
	event.clear_object_sequence(0)
	event.set_object_handle_motion(0, "立ち")
	event.set_object_handle_position(0, -170.0, 0.0, 50.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(-170.0, 30.0, 50.0)
	event.set_camera_position(-70.0, 35.0, 50.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
end

--- Turns the player toward the camera and plays a head-shake refusal motion.
function fish_monster_swamp.play_refuse_gesture()
	local playable_character: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if playable_character == 2 or playable_character == 3 then
		vm.wait(1)
		return
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 6)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	object.wait_until_done(0)
	if playable_character == 0 or playable_character == 1 then
		event.delete_character_extension_packs(0)
	end
end

--- Prints the progress counter and item markers to the debug output.
function fish_monster_swamp.print_progress_debug()
	local progress_counter: s32 = 0
	cutscene.noop()
	print("cnt=", progress_counter, "-------------------------------------\n")
	print("esaget-------------\n")
	print("apple-------------\n")
end

--- Enables the swamp function points, map parts and characters that match the progress counter and story flags.
function fish_monster_swamp.update_progress_function_points()
	local progress_counter: s32 = 0
	local item_count: s32 = 0
	local story_flag: s32 = 0
	event.initialize_event()
	fish_monster_swamp.disable_function_points()
	progress_counter = event.get_save_counter(3) or progress_counter
	print("cnt=", progress_counter, "-------------------------------------\n")
	if progress_counter >= 8 then
		event.attach_object_handle_to_map_part_3(0, "p05_s0501", "s050111-m0")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, -2274.43, 37.38, 712.87)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(0, "p05_s0501", "s050102-a")
		event.set_object_handle_position(0, -2274.43, 37.38, 712.87)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(0, "p05_s0501", "s050102-c")
		event.set_object_handle_position(0, -2274.43, 37.38, 712.87)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_function_point_enabled("", "next_floor", 1)
	end
	if progress_counter > 1 and progress_counter < 7 then
		print("esaget-------------\n")
		event.set_function_point_enabled("", "itemget_mimi", 1)
	end
	story_flag = event.get_save_flag(230) or story_flag
	if story_flag ~= 0 and progress_counter < 5 then
		item_count = event.get_item_count(291) or item_count
		if item_count <= 0 then
			print("apple-------------\n")
			event.set_function_point_enabled("", "itemget_paplle", 1)
			event.set_character_active(1, 13)
			event.set_character_active(1, 15)
			event.set_character_active(1, 16)
			event.set_character_active(1, 17)
		else
			event.set_character_active(0, 13)
			event.set_character_active(0, 15)
			event.set_character_active(0, 16)
			event.set_character_active(0, 17)
		end
	end
	if progress_counter <= 2 then
		item_count = event.get_item_count(302) or item_count
		if item_count <= 0 then
			event.set_function_point_enabled("", "fc_e220", 1)
		end
	end
	story_flag = event.get_save_flag(230) or story_flag
	if story_flag == 0 then
		event.set_function_point_enabled("", "fc_e230", 1)
		return
	end
	if progress_counter == 3 then
		event.set_function_point_enabled("", "fc_e235", 1)
		return
	end
	if progress_counter == 5 then
		print("haguhagu on--------------\n")
		event.set_function_point_enabled("", "item_e245", 1)
		return
	end
	if progress_counter == 6 then
		event.set_function_point_enabled("", "fc_e247", 1)
		fish_monster_swamp.hide_residents()
		return
	end
	if progress_counter == 7 then
		story_flag = event.get_save_flag(250) or story_flag
		if story_flag == 1 then
			event.set_function_point_enabled("", "fc_e253", 1)
		end
	end
end

--- Asks whether to leave and either runs the player out of the map with a camera pan and fade-out or walks a few steps back into the map, returning whether the player left.
function fish_monster_swamp.walk_to_map_exit()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local index: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		step = 1
		exit_choice = message.ask_yes_no(1, -1)
		if exit_choice == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-2144.16, 79.66, 654.8)
			event.set_camera_sequence_look_at(-2382.06, 11.3, 623.75)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, -2363.64, 0.4, 625.83)
			event.set_object_sequence_rotation(0, 0.0, -1.52, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.move_object_sequence(0, -2489.67, 0.4, 624.1, 60)
			event.move_camera_sequence_eased(-2144.16, 79.66, 654.8, -2388.46, 36.03, 632.32, 48, 60, 2.5)
			event.mark_camera_sequence_fade_track()
			event.delay_camera_sequence_fade_track(30)
			event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
			step = 2
			wait.frames(60)
			return 1
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		x = vm.f32(x + vm.f32(30.0 * vm.sin(vm.f32(1.59))))
		z = vm.f32(z + vm.f32(30.0 * vm.cos(vm.f32(1.59))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.59, 0.0, 15)
		event.move_object_sequence(0, x, y, z, 45)
		for i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			event.set_camera_sequence_look_at(x, y + 30.0, z)
			step = 3
			vm.wait(3)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if step <= 2 then
			if step == 1 then
				exit_choice = received[1] :: number
			end
			if step <= 1 then
				wait.frames_skipping(60)
			end
			return 1
		end
		if step <= 3 then
			local _ = index < 45
			index = index + 1
			return 0
		end
		return nil
	end)
end

--- Makes the player turn toward another character while walking, then stand.
function fish_monster_swamp.walk_turn_toward_character(character: s32)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local delta_x: f32 = 0
	local delta_y: f32 = 0
	local delta_z: f32 = 0
	local target_angle: f32 = 0
	local turn_frames: any = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_position(character)
		delta_x = out1 or delta_x
		delta_y = out2 or delta_y
		delta_z = out3 or delta_z
	end
	do
		local out1, out2, out3 = event.subtract_vectors(delta_x, delta_y, delta_z, player_x, player_y, player_z)
		delta_x = out1 or delta_x
		delta_y = out2 or delta_y
		delta_z = out3 or delta_z
	end
	target_angle = event.get_arc_tangent(delta_x, delta_z) or target_angle
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	print("angle=", vm.float(target_angle), "----------\n")
	turn_frames = vm.ftoi(vm.f32(target_angle / vm.f32(0.19634955)))
	turn_frames = fish_monster_swamp.get_absolute_value(turn_frames)
	print("frame=", turn_frames, "-------------\n")
	event.rotate_object_sequence(0, 0.0, target_angle, 0.0, turn_frames)
	wait.frames(turn_frames)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
end

return fish_monster_swamp
