--!strict
--- Holds the bridge setup, entrance placement, dungeon prompts and cutscene helpers for Palm Brinks town.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local palm_brinks_town = {}

--- Attaches and positions the bridge map parts.
function palm_brinks_town.attach_bridge_parts()
	event.attach_object_handle_to_map_part_3(5, "p01_e01a04-1", "e01a04_02-m0")
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.7853982)
	event.attach_object_handle_to_map_part_3(6, "p01_e01a04-1", "e01a04_03-m0")
	event.set_object_handle_rotation(6, 0.0, 0.0, -0.24166098)
	event.attach_object_handle_to_map_part_3(7, "p01_e01a04-1", "e01a04_04-m0")
	event.set_object_handle_rotation(7, 0.0, 0.0, -0.24166098)
	event.set_object_handle_scale(7, 1.0, 0.65625, 1.0)
	event.attach_object_handle_to_map_part_3(8, "p01_e01a04-1", "e01a04_05-m0")
	event.set_object_handle_visible(8, 0)
	event.attach_object_handle_to_map_part_3(9, "p01_e01a04-1", "e01a04_06-m0")
	event.set_object_handle_visible(9, 1)
	event.attach_object_handle_to_map_part_3(10, "p01_e01a04-2", "e01a04_02-m0")
	event.set_object_handle_rotation(10, 0.0, 0.0, 0.7853982)
	event.attach_object_handle_to_map_part_3(11, "p01_e01a04-2", "e01a04_03-m0")
	event.set_object_handle_rotation(11, 0.0, 0.0, -0.24166098)
	event.attach_object_handle_to_map_part_3(12, "p01_e01a04-2", "e01a04_04-m0")
	event.set_object_handle_rotation(12, 0.0, 0.0, -0.24166098)
	event.set_object_handle_scale(12, 1.0, 0.65625, 1.0)
	event.attach_object_handle_to_map_part_3(13, "p01_e01a04-2", "e01a04_05-m0")
	event.set_object_handle_visible(13, 0)
	event.attach_object_handle_to_map_part_3(14, "p01_e01a04-2", "e01a04_06-m0")
	event.set_object_handle_visible(14, 1)
	event.attach_object_handle_to_map_part_2(15, "橋あたり")
	event.set_object_handle_visible(15, 1)
end

--- Asks the yes or no prompt for system message 160 and, when the first choice is picked, fades out and returns 1, otherwise returns 0.
function palm_brinks_town.confirm_dungeon_entry_160()
	local choice: any = 0
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		stage = 1
		choice = message.ask_item_choice(5, 160)
		if choice == 0 then
			event.fade_out_screen(30)
			stage = 2
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if stage <= 2 then
			if stage == 1 then
				choice = received[1] :: number
			end
			if stage <= 1 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Asks the yes or no prompt for system message 55 and, when the first choice is picked, fades out and returns 1, otherwise returns 0.
function palm_brinks_town.confirm_dungeon_entry_55()
	local choice: any = 0
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		stage = 1
		vm.wait(1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		stage = 2
		choice = message.ask_item_choice(5, 55)
		event.set_message_window_mode(0, 1)
		if choice == 0 then
			event.fade_out_screen(30)
			stage = 3
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if stage <= 3 then
			if stage == 2 then
				choice = received[1] :: number
			end
			if stage <= 1 then
				choice = message.ask_prompt_choice(5, 55)
			end
			if stage <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Initializes the event and places the player and camera at the first entrance.
function palm_brinks_town.place_player_at_entrance_a()
	event.initialize_event()
	event.set_camera_look_at(225.0, 30.0, 280.0)
	event.set_camera_position(225.0, 30.0, 160.0)
	event.set_character_position(0, 225.0, 0.0, 280.0)
	event.set_character_rotation(0, 0.0, -3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- Initializes the event and places the player and camera at the second entrance.
function palm_brinks_town.place_player_at_entrance_b()
	event.initialize_event()
	event.set_camera_look_at(225.0, 30.0, 280.0)
	event.set_camera_position(225.0, 30.0, 160.0)
	event.set_character_position(0, 200.0, 0.0, -20.8)
	event.set_character_rotation(0, 0.0, 1.89, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- Raises the time of day from 6.5 to 6.8 hours, then pans the camera along a path while fading out.
function palm_brinks_town.play_dawn_camera_pan()
	local time_of_day: f32 = 0
	event.set_camera_sequence_position(396.92, 146.86, -175.05)
	event.set_camera_sequence_look_at(744.44, 257.9, -23.8)
	event.set_time_of_day(6.5)
	time_of_day = 6.5
	while true do
		time_of_day = vm.f32(time_of_day + vm.f32(0.004))
		event.set_time_of_day(time_of_day)
		vm.wait(1)
		if time_of_day > vm.f32(6.8) then
			break
		end
	end
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(190)
	event.fade_out_camera_sequence(60, 0.0, 0.0, 0.0)
	event.clear_camera_sequence_path()
	event.set_camera_sequence_path_frames(250)
	event.add_camera_sequence_path_point(396.92, 146.86, -175.05, 744.44, 257.9, -23.8)
	event.add_camera_sequence_path_point(104.88, 122.77, 6.77, 326.18, 70.53, 147.12)
	event.start_camera_sequence_path()
	camera.wait_until_done()
end

--- Plays the dawn camera pan as a skippable cutscene and clears save flag 56 afterwards.
function palm_brinks_town.play_dawn_cutscene()
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.clear_camera_sequence()
		vm.wait(1)
		event.set_camera_position(0.0, 0.0, 0.0)
		event.set_camera_look_at(1.0, 0.0, 0.0)
		event.set_character_active(0, 0)
		palm_brinks_town.play_dawn_camera_pan()
	end)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.set_save_flag(56, 0)
end

--- Plays the e800 cutscene between the player and Need with sprite overlays.
function palm_brinks_town.play_e800_cutscene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_save_flag(800, 1)
		event.set_camera_position(1863.34, -57.23, -1093.45)
		event.set_camera_look_at(1673.6, -34.95, -1596.24)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(193)
		event.play_music(0)
		sound_bank = event.load_sound_effect_file_2(1261) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e800/e800/")
		event.load_message_file(0, 5, "e800_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e800_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e800_need.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(2, 35)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		image_block = event.load_event_image_4(5, "e800.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e80001", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e80002", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(4, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		event.set_object_handle_position(0, 1471.93, -90.0, -1214.38)
		event.set_object_handle_rotation(0, 0.0, 2.95, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 1693.4, -48.85, -1747.04)
		event.set_object_handle_rotation(2, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1863.34, -57.23, -1093.45)
		event.set_camera_sequence_look_at(1673.6, -34.95, -1596.24)
		event.set_character_active(0)
		event.move_camera_sequence(1419.0, -57.23, -1121.53, 1673.6, -34.95, -1596.24, 300)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		wait.frames(180)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 1616.06, -90.0, -1552.76, 120, 1)
		camera.wait_until_done()
		event.set_camera_sequence_position(1819.9, 101.8, -1573.08)
		event.set_camera_sequence_look_at(1698.78, -1.69, -1732.94)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 1607.13, -77.8, -1633.37)
		event.set_object_sequence_rotation(0, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 1657.71, -48.85, -1704.67, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(30)
		event.set_object_sequence_motion(2, "振り向き", 6)
		event.rotate_object_sequence(2, 0.0, -0.33, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		object.wait_until_done(0)
		wait.frames(30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000010)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8000020)
		event.set_camera_sequence_position(1680.47, -37.85, -1706.19)
		event.set_camera_sequence_look_at(1694.26, -26.32, -1748.64)
		event.set_object_handle_frame_visible(2, "te_l", 0)
		event.set_object_handle_frame_visible(2, "te_r", 0)
		event.set_object_handle_frame_visible(2, "te_gl--v0", 1)
		event.set_object_handle_frame_visible(2, "te_gr--v0", 1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "しんけん顔")
		event.set_object_sequence_texture_animation(2, 1, "しんけん目パチ")
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_object_sequence_motion(2, "エキサイト", 6)
		event.queue_object_sequence_next_motion(2, "エキサイト戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000030)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000035)
		event.set_camera_sequence_position(1819.9, 101.8, -1573.08)
		event.set_camera_sequence_look_at(1698.78, -1.69, -1732.94)
		event.set_object_handle_frame_visible(2, "te_l", 1)
		event.set_object_handle_frame_visible(2, "te_r", 1)
		event.set_object_handle_frame_visible(2, "te_gl--v0", 0)
		event.set_object_handle_frame_visible(2, "te_gr--v0", 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000040)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(8000050)
		event.set_scene_status_flags(1, 0, 256, 0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000060)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000065)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(8000070)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000080)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000090)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000100)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(8000110)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000120)
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		event.set_camera_sequence_position(1704.99, -31.99, -1684.63)
		event.set_camera_sequence_look_at(1684.93, -26.32, -1741.26)
		event.set_object_sequence_position(0, 1678.13, -48.85, -1729.46)
		event.set_object_sequence_rotation(0, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000130)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(35)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 1678.13, -48.85, -1729.46)
	event.set_character_rotation(0, 0.0, 2.95, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene of Starbre walking away while the camera fades out.
function palm_brinks_town.play_starbre_walk_cutscene()
	vm.section(function()
		character.place_standing_and_reset_cloth(1798.0, 0.0, vm.f32(2611.2), vm.f32(1.23))
		event.reset_follow_camera(1, 0.0, 10.0)
		event.initialize_event()
		event.load_map_sounds(1240)
		event.load_sound_effect_file_2(1240)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
		event.set_character_active(1, 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.attach_object_handle_to_map_part_2(1, "p01_e03h03-0")
		event.set_object_handle_visible(1, 0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.set_camera_sequence_position(1992.97, 34.74, 2905.51)
		event.set_camera_sequence_look_at(2030.46, 40.14, 2965.77)
		event.set_object_sequence_position(0, 2129.53, 0.0, 3073.66)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.move_camera_sequence_eased(1713.52, 39.48, 2489.48, 1730.42, 46.55, 2524.75, 150, 2, 0.4)
		event.set_object_sequence_motion(0, "歩き２", 4)
		event.move_object_sequence(0, 2128.59, 26.83, 3265.59, 150, 1)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(120)
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
		event.clear_camera_sequence()
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character(32)
	event.set_character_active(1, 0)
end

--- Builds the bridge parts and enables the bridge function points when the save data value is 2 or 3 and disables them otherwise, with extra points for save flag 21 and value 100.
function palm_brinks_town.refresh_bridge_state()
	local save_flag: s32 = 0
	local story_progress: s32 = 0
	local current_story_progress: s32 = 0
	save_flag = event.get_save_flag(21) or save_flag
	if save_flag == 1 then
		event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	end
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 2 or story_progress == 3 then
		palm_brinks_town.attach_bridge_parts()
		palm_brinks_town.set_bridge_points_enabled(1)
	else
		event.set_function_point_enabled("", "event_550", 0)
		palm_brinks_town.set_bridge_points_enabled(0)
	end
	current_story_progress = event.get_save_data_value(0) or current_story_progress
	if current_story_progress == 100 then
		event.set_function_point_enabled("", "dun01", 0)
		event.set_function_point_enabled("", "event_550", 1)
		event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	end
end

--- Enables the bridge function points when built and the unbuilt point otherwise.
function palm_brinks_town.set_bridge_points_enabled(is_built: s32)
	event.set_function_point_enabled("p01_e01a04-1", "invent_15-0", if is_built == 0 then 1 else 0)
	event.set_function_point_enabled("p01_e01a04-1", "invent_15-1", is_built)
	event.set_function_point_enabled("p01_e01a04-1", "invent_15-2", is_built)
	event.set_function_point_enabled("p01_e01a04-2", "invent_15-0", if is_built == 0 then 1 else 0)
	event.set_function_point_enabled("p01_e01a04-2", "invent_15-1", is_built)
	event.set_function_point_enabled("p01_e01a04-2", "invent_15-2", is_built)
end

--- Sets the night, clears the villagers and starts the player walking and running toward a second character while the camera follows a path.
function palm_brinks_town.start_night_walk_scene()
	local i: s32 = 0
	event.initialize_event()
	event.set_time_of_day(22.0)
	event.set_time_of_day_advancing(0)
	while i < 30 do
		event.delete_villager(8 + i)
		event.delete_character(8 + i)
		i = i + 1
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_visible(122, 0)
	event.set_character_visible(123, 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -3191.87, 295.72, -1655.31)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.load_character(5, "event/lm/p01_11a.gltf", "info", 23)
	event.set_character_active(23)
	event.attach_object_handle_to_character(1, 23)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, -3632.46, 359.4, -1676.62)
	event.set_object_sequence_rotation(1, 0.0, 1.33, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_camera_sequence_position(-2984.99, 368.7, -1657.07)
	event.set_camera_sequence_look_at(-3149.01, 368.64, -1657.54)
	wait.frames(30)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.delay_object_sequence_motion_track(0, 90)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, -3260.27, 309.45, -1657.5, 90)
	event.delay_object_sequence_motion_track(0, 80)
	event.delay_object_sequence_position_track(0, 80)
	event.set_object_sequence_motion(0, "走り")
	event.move_object_sequence(0, -3299.08, 319.36, -1657.5, 20)
	event.move_object_sequence(0, -3497.2, 319.45, -1657.5, 60)
	event.move_object_sequence(0, -3559.21, 344.26, -1657.5, 20)
	event.delay_object_sequence_motion_track(1, 70)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.clear_camera_sequence_path()
	event.set_camera_sequence_path_frames(450)
	event.add_camera_sequence_path_point(-2984.99, 368.7, -1657.07, -3149.01, 368.64, -1657.54)
	event.add_camera_sequence_path_point(-3041.88, 368.7, -1657.23, -3205.9, 368.64, -1657.7)
	event.add_camera_sequence_path_point(-3079.68, 368.7, -1657.34, -3243.7, 368.99, -1657.57)
	event.add_camera_sequence_path_point(-3104.5, 368.7, -1657.37, -3268.51, 370.24, -1656.16)
	event.add_camera_sequence_path_point(-3138.38, 368.7, -1656.56, -3293.87, 379.2, -1645.98)
	event.add_camera_sequence_path_point(-3185.18, 368.7, -1650.32, -3318.89, 410.8, -1605.08)
	event.add_camera_sequence_path_point(-3249.8, 375.19, -1632.22, -3332.04, 457.09, -1579.83)
	event.add_camera_sequence_path_point(-3299.32, 424.82, -1601.37, -3378.0, 518.77, -1543.76)
	event.start_camera_sequence_path()
	event.move_camera_sequence(-3356.12, 493.4, -1559.76, -3378.0, 518.77, -1543.76, 120)
	vm.wait(2)
	wait.until_button_pressed(64)
	event.set_character_visible(122, 1)
	event.set_character_visible(123, 1)
end

return palm_brinks_town
