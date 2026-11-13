--!strict
--- Palm Brinks town square with the contest announcements and gates.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local palm_brinks_square_event = require("@lib/event/palm_brinks_square_event")
local wait = require("@lib/event/wait")

--- Plays the fireworks and fishing contest announcement.
local function cutscene_fishing_contest_announcement()
	local sound_id: s32 = 0
	local saved_time_of_day: f32 = 0
	vm.section(function()
		event.attach_object_handle_to_map_part_2(0, "p06_e03h03-0")
		event.attach_object_handle_to_map_part_2(1, "p07_e03h03-0")
		event.set_object_handle_visible(0, 0)
		event.set_object_handle_visible(1, 1)
		event.set_save_flag(344, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_all_sounds()
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(0)
		event.play_music(0)
		event.load_map_sounds(1251)
		sound_id = event.load_sound_effect_file_2(1251) or sound_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e300/e344/")
		event.load_message_file(0, 5, "e344.txt")
		event.load_character(5, "e344_need.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e344_morton.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e344_hanabi.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e344_hanabi1.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e344_hanabi.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		event.set_object_handle_position(0, 2190.0, 0.0, 2160.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "後ろ手立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 2210.0, 0.0, 2160.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 2146.83, 245.98, 2255.25)
		event.set_object_handle_rotation(2, 0.0, 0.72, 0.0)
		event.set_object_handle_motion(2, "花火", 5)
		event.set_object_handle_position(3, 2276.07, 265.14, 2324.42)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "花火B", 5)
		event.set_object_handle_position(4, 2245.48, 221.91, 2338.94)
		event.set_object_handle_rotation(4, 0.0, -1.8, 0.0)
		event.set_object_handle_motion(4, "花火", 5)
		palm_brinks_square_event.spawn_crowd()
		event.enable_drama_skip()
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_time_of_day_advancing(0)
		event.set_time_of_day(12.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2164.39, 99.38, 1857.36)
		event.set_camera_sequence_look_at(2188.71, 85.83, 2173.89)
		event.move_camera_sequence_eased(2175.94, 58.96, 2007.92, 2188.71, 45.97, 2173.89, 80, 2, 1.0)
		event.fade_in_screen(30)
		event.set_character_active(0, 18)
		event.move_object_sequence(7, 2063.4, 0.0, 2269.49, 300)
		event.move_object_sequence(8, 2368.37, 0.0, 2200.11, 180)
		camera.wait_until_done()
		wait.for_frame_count(10)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(1, 0)
		vm.wait(4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(2162.71, 15.34, 2193.63)
		event.set_camera_sequence_look_at(2193.59, 20.71, 2166.19)
		event.set_object_sequence_motion(1, "右向き", 6)
		event.queue_object_sequence_next_motion(1, "右向き会話", 6)
		event.queue_object_sequence_next_motion(1, "右向きＬ", 4)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(3440010)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "後ろ手会話", 2)
		event.queue_object_sequence_next_motion(0, "後ろ手立ち", 4)
		event.set_mouth_texture_animations(0, "口パク")
		message.show_voiced(3440020)
		event.set_mouth_texture_animations(0, "口パク")
		message.show_voiced(3440030)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "右向き会話", 2)
		event.queue_object_sequence_next_motion(1, "右向きＬ", 4)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(3440040)
		object.wait_until_done(1)
		event.play_sound_effect(sound_id, 4)
		wait.for_frame_count(12)
		event.set_object_sequence_motion(0, "見上げ", 2)
		event.queue_object_sequence_next_motion(0, "見上げＬ", 4)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(1, "見上げ", 2)
		event.queue_object_sequence_next_motion(1, "見上げＬ", 4)
		object.wait_until_done(1)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(1, 18)
		event.set_object_sequence_motion(6, "会話", 4)
		event.move_object_sequence(10, 2210.66, 0.0, 2067.07, 150)
		event.set_object_handle_shadow_enabled(0, 1)
		event.set_object_handle_shadow_enabled(1, 1)
		event.set_camera_sequence_position(2200.0, 22.0, 2000.0)
		event.set_camera_sequence_look_at(2200.0, 32.0, 2060.0)
		event.move_camera_sequence_eased(2200.0, 64.0, 2000.0, 2200.0, 92.0, 2060.0, 60, 0, 1.0)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "花火", 4)
		event.delay_object_sequence_motion_track(2, 56)
		event.set_object_sequence_motion(2, "花火", 6)
		event.delay_object_sequence_position_track(2, 56)
		event.set_object_sequence_position(2, 2129.58, 169.43, 2213.1)
		event.set_object_sequence_rotation(2, 0.0, 2.04, 0.0)
		wait.for_frame_count(6)
		event.set_object_sequence_motion(3, "花火B", 4)
		event.delay_object_sequence_motion_track(3, 56)
		event.set_object_sequence_motion(3, "花火B", 6)
		event.delay_object_sequence_position_track(3, 56)
		event.set_object_sequence_position(3, 2175.47, 334.69, 2328.55)
		event.set_object_sequence_rotation(3, 0.0, -2.52, 0.0)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(4, "花火", 4)
		event.delay_object_sequence_motion_track(4, 56)
		event.set_object_sequence_motion(4, "花火", 6)
		event.delay_object_sequence_position_track(4, 56)
		event.set_object_sequence_position(4, 2298.38, 266.92, 2276.97)
		event.set_object_sequence_rotation(4, 0.0, -2.0, 0.0)
		wait.for_frame_count(2)
		event.play_sound_effect(sound_id, 4)
		camera.wait_until_done()
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]これから、釣り大会は、ゲーム内時間で\n   一定期間ごとに、パームブリンクス広場で\n   開催されます。<page>   釣り大会終了後、１０日のインターバルを\n   おいて、再び、次の釣り大会・・・という\n   繰り返しとなります。<page>   釣り大会などのイベントが\n   開催されている期間は、\n   メインメニューの左上に表示されます。"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		wait.for_frame_count(30)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_id, 4)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	palm_brinks_square_event.delete_crowd_characters()
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.show_dungeon_status_bar(1, 1.0)
end

--- Asks about going to Main Street and returns whether the player left.
local function ask_move_to_main_street()
	local choice: any = 0
	local leave_x: f32 = 0
	local leave_y: f32 = 0
	local return_x: f32 = 0
	local return_y: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		event.open_message_window_2(0, "『メインストリート』に移動しますか？")
		resume_step = 1
		choice = message.open_and_ask_choice(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 15)
			do
				local out1, out2, _ = event.get_character_position(0)
				leave_x = out1 or leave_x
				leave_y = out2 or leave_y
			end
			event.move_object_sequence(0, leave_x, leave_y, 1700.0, 60)
			resume_step = 2
			wait.for_frame_count(15)
			event.fade_out_screen(30)
			resume_step = 3
			wait.for_frame_count(30)
			return 1
		end
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 15)
		resume_step = 4
		wait.for_frame_count(15)
		do
			local out1, out2, _ = event.get_character_position(0)
			return_x = out1 or return_x
			return_y = out2 or return_y
		end
		event.move_object_sequence(0, return_x, return_y, 2000.0, 45)
		resume_step = 5
		wait.for_frame_count(45)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.skip_frame_count(15)
			end
			if resume_step <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_step <= 5 then
			if resume_step <= 4 then
				wait.skip_frame_count(45)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the Finny Frenzy announcement scene.
local function cutscene_finny_frenzy_announcement()
	vm.section(function()
		event.set_save_flag(424, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_all_sounds()
		event.stop_music(0)
		event.load_map_sounds(1253)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.load_message_file(0, 5, "event/e400/e424/e424.txt")
		event.load_character(5, "event/e300/e344/e344_need.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e400/e424/e424_morton.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_2(10, "p06_e03h03-0")
		event.attach_object_handle_to_map_part_2(11, "p07_e03h03-0")
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 0)
		event.set_object_handle_position(0, 2190.0, 0.0, 2160.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "後ろ手立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "目パチ")
		event.set_object_handle_position(1, 2210.0, 0.0, 2160.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.stop_music(0)
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(80)
		event.add_camera_sequence_path_point(2200.29, 143.98, 1871.42, 2199.34, 111.2, 2162.75)
		event.add_camera_sequence_path_point(2199.85, 143.98, 2007.37, 2199.34, 111.2, 2162.75)
		event.start_camera_sequence_path()
		event.fade_in_screen(30)
		camera.wait_until_done()
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		event.set_object_sequence_motion(1, "右向き歩き", 4)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 800)
		event.add_object_sequence_path_point(1, 2649.81, 0.0, 2745.79)
		event.add_object_sequence_path_point(1, 2569.46, 0.0, 2431.71)
		event.add_object_sequence_path_point(1, 2359.06, 0.0, 2278.55)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 800)
		event.add_object_sequence_path_point(0, 2670.81, 0.0, 2739.61)
		event.add_object_sequence_path_point(0, 2585.76, 0.0, 2406.99)
		event.add_object_sequence_path_point(0, 2368.7, 0.0, 2242.24)
		event.start_object_sequence_path(0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(800)
		event.add_camera_sequence_path_point(2707.18, 23.28, 2717.95, 2587.81, 30.11, 2773.32)
		event.add_camera_sequence_path_point(2609.31, 23.28, 2381.58, 2519.89, 30.11, 2465.71)
		event.add_camera_sequence_path_point(2365.94, 23.28, 2198.82, 2363.56, 30.11, 2299.54)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced_for_stopping(4240010, -1)
		event.set_mouth_texture_animations(0, "口パク")
		message.show_voiced_for_stopping(4240020, -1)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced_for_stopping(4240030, -1)
		event.set_mouth_texture_animations(0, "口パク")
		message.show_voiced_for_stopping(4240040, -1)
		wait.for_frame_count(30)
		event.clear_camera_sequence()
		event.clear_object_sequence(1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2192.6, 0.0, 2256.59)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 2218.18, 0.0, 2250.95)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(2318.18, 63.77, 2144.79)
		event.set_camera_sequence_look_at(2246.72, 30.11, 2277.0)
		event.move_object_sequence(0, 2188.39, 18.0, 2374.73, 240, 1)
		event.move_object_sequence(1, 2213.69, 18.0, 2374.73, 240, 1)
		message.show_voiced_for_stopping(4240050, -1)
		message.show_voiced_for_stopping(4240055, -1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_motion(1, "立ち", 4)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.fade_in_screen(1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]ギョレースは、パームブリンクス広場で\n   開催されます。<page>   これからは、ゲーム内時間で、\n   一定期間ごとに釣り大会とギョレースが\n   交互に行われることになります。"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.load_message_file(0, -1)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
	event.set_character_active(0)
	event.show_dungeon_status_bar(1, 1.0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Places the player by the previous map.
function script.default_event()
	local previous_map_number: s32 = 0
	palm_brinks_square_event.show_map_part_by_save_data()
	previous_map_number = event.get_previous_map() or previous_map_number
	if previous_map_number == 99 or previous_map_number == 95 then
		event.set_character_position(0, 2200.0, 18.0, 2350.0)
		event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
		event.fade_in_screen(30)
		event.reset_follow_camera(1, 0.0, 10.0)
	elseif previous_map_number == -1 then
		event.set_character_position(0, 2085.0, 65.0, 3470.0)
		event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
		event.fade_in_screen(30)
		event.reset_follow_camera(1, 0.0, 10.0)
	else
		event.set_character_position(0, 2200.0, 0.0, 2000.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.fade_in_screen(30)
		event.reset_follow_camera(1, 3.1415927, 10.0)
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = cutscene_fishing_contest_announcement

--- Asks about Main Street and jumps to m01.
function script.leave_for_main_street()
	if ask_move_to_main_street() ~= 0 then
		event.fade_out_screen(0)
		vm.wait(2)
		event.jump_to_map_2(-1, "m01")
		return
	end
end
script[202] = script.leave_for_main_street

--- Offers entry to the contest grounds or races.
function script.examine_contest_gate()
	local contest_type: s32 = 0
	local choice: any = 0
	event.set_character_motion(0, "立ち", 4)
	contest_type = event.get_menu_value_2(1) or contest_type
	if contest_type == 0 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "ただいま撤去作業中につき\n関係者以外立ち入り禁止")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		return
	end
	event.set_message_window_mode(0, 5)
	if contest_type == 1 then
		event.open_message_window_2(0, "『釣り大会会場』に入りますか？")
	else
		event.open_message_window_2(0, "『ギョレース会場』に入りますか？")
	end
	choice = message.open_and_ask_choice(0, -1, 8, 256, 208, 2, 1)
	if choice ~= 0 then
		return
	end
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	if contest_type == 1 then
		event.jump_to_map_2(-1, "i03h03")
	else
		event.jump_to_map_2(-1, "i03h04")
	end
	vm.wait(4)
end
script[203] = script.examine_contest_gate

--- Plays the Starbre walk and jumps to i03h01a.
function script.cutscene_starbre_walk()
	palm_brinks_square_event.play_starbre_walk()
	event.skip_villager_loading()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i03h01a", 500)
end
script[501] = script.cutscene_starbre_walk

--- Plays the fishing contest scene and loads d03f03.
function script.cutscene_fishing_contest_to_d03()
	cutscene_fishing_contest_announcement()
	event.load_dungeon_map("d03f03", "d03f03", 6)
	event.load_event_script("d03/d03.stb", 500)
end
script[510] = script.cutscene_fishing_contest_to_d03

--- Plays the Finny Frenzy scene and loads d04f02.
function script.cutscene_finny_frenzy_to_d04()
	cutscene_finny_frenzy_announcement()
	event.load_dungeon_map("d04f02", "d04f02", 40)
	event.load_event_script("d04/d04.stb", 500)
end
script[520] = script.cutscene_finny_frenzy_to_d04

--- Replays the Starbre walk and jumps to i03h01a.
function script.replay_starbre_walk()
	palm_brinks_square_event.play_starbre_walk()
	event.skip_villager_loading()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i03h01a", 500)
end
script[11091] = script.replay_starbre_walk

--- Event 13440, which map data, a script or the engine runs by number.
script.cutscene_fishing_contest_announcement = cutscene_fishing_contest_announcement
script[13440] = script.cutscene_fishing_contest_announcement

--- Event 14240, which map data, a script or the engine runs by number.
script.cutscene_finny_frenzy_announcement = cutscene_finny_frenzy_announcement
script[14240] = script.cutscene_finny_frenzy_announcement

return script
