--!strict
--- Boss room cutscenes of the Underground Water Channel.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local underground_water_channel_boss = {}

--- Loads the sound bank of the boss room.
function underground_water_channel_boss.load_sounds()
	event.load_map_sounds(1683)
end

--- Plays the cutscene in which the player enters the boss room as a gate rises.
function underground_water_channel_boss.play_entrance_cutscene()
	local sound_effect: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 1006.26, -27.71, -200.0)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.attach_object_handle_to_map_part_3(2, "p02_d01b01", "d01b01_9-m0")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_d01b01", "d01b01_2-a")
		event.set_object_handle_visible(3, 0)
		event.move_object_sequence(2, 0.0, 80.0, 0.0, 60)
		event.jump_object_sequence(2, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(2, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(2, 0.0, 0.0, 0.0, -0.4, 5)
		event.play_sound_effect(sound_effect, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(800.55, 83.98, -20.2)
		event.set_camera_sequence_look_at(868.65, 40.42, -105.22)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		camera.wait_until_done()
		wait.frames(4)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 962.88, -27.71, -191.57, 15)
		event.move_object_sequence(0, 928.6, -49.72, -185.79, 15)
		event.move_object_sequence(0, 904.87, -49.72, -180.71, 10)
		object.wait_until_done(2)
		object.wait_until_done(0)
		event.show_dungeon_status_bar(1)
		wait.frames(20)
		event.set_camera_sequence_position(969.7, -14.72, -202.32)
		event.set_camera_sequence_look_at(817.46, -19.72, -153.11)
		event.set_object_sequence_position(0, 880.95, -49.72, -173.03)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 840.81, -49.72, -161.41, 30)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(4)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_position(0, 840.81, -49.72, -161.41)
	event.set_character_rotation(0, 0.0, -1.32, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_map_part_3(2, "p02_d01b01", "d01b01_9-m0")
	event.set_object_handle_position(2, 0.0, 0.0, 0.0)
	event.set_camera_position(969.7, -14.72, -202.32)
	event.set_camera_look_at(817.46, -19.72, -153.11)
	event.reset_follow_camera(0)
	event.fade_in_screen(0)
	event.finish_event()
end

--- Plays the boss room cutscene with Mints, Halloween, Polcurse and Pierrot, with a short variant for the trial version.
function underground_water_channel_boss.play_halloween_cutscene()
	local playable_character: s32 = 0
	local move_type: s32 = 0
	local is_trial_for_music: s32 = 0
	local sound_effect: s32 = 0
	local is_trial_for_scene: s32 = 0
	local elapsed_frames: s32 = 0
	local resume_point: number = 0
	do
		local ret = vm.section(function()
			event.set_save_flag(111, 1)
			event.initialize_event()
			event.show_dungeon_status_bar(0, 0.033333335)
			playable_character = event.get_playable_character() or playable_character
			if playable_character == 2 then
				move_type = event.get_player_move_type() or move_type
				if move_type == 1 then
					event.set_character_motion(0, "立ち-足")
				end
				if move_type == 2 then
					event.set_character_motion(0, "立ち-キャタピラ")
				end
			else
				event.set_character_motion(0, "バトル立ち")
			end
			is_trial_for_music = event.is_trial_version() or is_trial_for_music
			if is_trial_for_music == 1 then
				event.fade_out_music(30)
			end
			event.fade_out_screen(30)
			resume_point = 1
			wait.frames(30)
			if playable_character == 2 then
				event.switch_dungeon_main_character(0)
				event.set_playable_character(0)
			end
			event.change_directory("event/e100/e111/")
			event.start_background_file_loads_9(
				"e111_mints.gltf",
				"e111_Halloween.gltf",
				"e111_polcurse.gltf",
				"e111_pierrot.gltf",
				"e111baku.gltf",
				"e111pikipiki.gltf",
				"e111_hahen01.gltf",
				"e111_hahen02.gltf",
				"e111_1.txt"
			)
			event.stop_port_sound_effects(7)
			event.set_dungeon_pause_flags(17, 1)
			is_trial_for_scene = event.is_trial_version() or is_trial_for_scene
			if is_trial_for_scene == 1 then
				event.assign_memory_stack(5)
				event.clear_memory_stack(5)
				event.set_character_active(0, 0)
				resume_point = 2
				wait.background_load()
				event.load_character(5, "e111_Halloween.gltf", "info", 9)
				event.set_character_active(9)
				event.attach_object_handle_to_character(1, 9)
				event.clear_object_sequence(1)
				event.set_object_sequence_object(1, 1)
				event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
				event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
				event.set_object_sequence_motion(1, "立ち", 4)
				event.load_character(5, "e111pikipiki.gltf", "info", 13)
				event.set_character_active(0, 13)
				event.set_character_position(13, 0.0, 0.0, 0.0)
				event.set_character_rotation(13, 0.0, 1.8, 0.0)
				event.load_character(5, "e111baku.gltf", "info", 14)
				event.set_character_active(0, 14)
				event.set_character_position(14, 0.0, 0.0, 0.0)
				event.set_character_rotation(14, 0.0, 1.8, 0.0)
				event.set_character_motion(14, "爆発", 5)
				event.set_current_directory("")
				sound_effect = event.load_sound_effect_file_2(1831) or sound_effect
				event.set_object_sequence_motion(1, "倒れ", 6)
				event.wait_object_sequence_motion_end(1)
				event.clear_camera_sequence()
				event.set_camera_sequence_position(229.93, 23.29, -84.91)
				event.set_camera_sequence_look_at(-23.55, 60.99, 1.2)
				event.mark_camera_sequence_fade_track()
				event.fade_in_camera_sequence(30)
				resume_point = 3
				camera.wait_until_done()
				resume_point = 4
				wait.frames(12)
				event.play_sound_effect(sound_effect, 18)
				resume_point = 5
				object.wait_until_done(1)
				event.set_character_active(13)
				event.play_object_sequence_sound(1, sound_effect, 31)
				event.delay_object_sequence_sound_track(1, 20)
				event.play_object_sequence_sound(1, sound_effect, 32)
				event.delay_object_sequence_sound_track(1, 8)
				event.play_object_sequence_sound(1, sound_effect, 31)
				resume_point = 6
				wait.frames(30)
				event.set_character_active(14)
				event.set_character_motion(14, "爆発", 6)
				resume_point = 7
				wait.frames(10)
				event.play_sound_effect(sound_effect, 33)
				resume_point = 8
				wait.frames(45)
				event.fade_out_music(90)
				event.fade_out_screen(30)
				resume_point = 9
				wait.frames(30)
				resume_point = 10
				wait.frames(60)
				event.stop_sound_effect(sound_effect, 31)
				event.stop_sound_effect(sound_effect, 32)
				event.stop_sound_effect(sound_effect, 33)
				event.set_character_active(0)
				event.set_scene_exit_flag(1)
				return table.pack()
			end
			event.stop_music(0)
			message.set_window_mode(0, 7)
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			resume_point = 11
			wait.background_load()
			event.load_message_file(0, 5, "e111_1.txt")
			event.load_character_motion_pack(5, "e111_mints.gltf", "info", 0)
			event.set_character_position(0, 202.87, 0.0, -74.61)
			event.set_character_rotation(0, 0.0, -1.2, 0.0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 2)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 202.87, 0.0, -74.61)
			event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
			event.set_object_sequence_motion(0, "旧・立ち", 4, -1, 1)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.load_character(5, "e111_Halloween.gltf", "info", 9)
			event.set_character_active(9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(1, "立ち", 4)
			event.load_character(5, "e111_polcurse.gltf", "info", 10)
			event.set_character_active(10)
			event.attach_object_handle_to_character(2, 10)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_position(2, 0.0, 170.0, 0.0)
			event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(2, "浮遊２", 4)
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "目・こまり")
			event.set_object_sequence_texture_animation(2, 1, "口・こまり")
			event.load_character(5, "e111_pierrot.gltf", "info", 11)
			event.set_character_active(0, 11)
			event.attach_object_handle_to_character(3, 11)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(3, "立ち", 4)
			event.copy_character(5, 11, 12)
			event.set_character_active(0, 12)
			event.attach_object_handle_to_character(4, 12)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(4, "立ち", 4)
			event.load_character(5, "e111pikipiki.gltf", "info", 13)
			event.set_character_active(0, 13)
			event.set_character_position(13, 0.0, 0.0, 0.0)
			event.set_character_rotation(13, 0.0, 1.8, 0.0)
			event.load_character(5, "e111baku.gltf", "info", 14)
			event.set_character_active(0, 14)
			event.set_character_position(14, 0.0, 0.0, 0.0)
			event.set_character_rotation(14, 0.0, 1.8, 0.0)
			event.set_character_motion(14, "爆発", 5)
			event.load_character(5, "e111_hahen01.gltf", "info", 15)
			event.set_character_active(0, 15)
			event.set_character_position(15, 0.0, 0.0, 0.0)
			event.set_character_rotation(15, 0.0, 1.0, 0.0)
			event.attach_object_handle_to_character(7, 15)
			event.clear_object_sequence(7)
			event.set_object_sequence_object(7, 7)
			event.copy_character(5, 15, 16)
			event.set_character_active(0, 16)
			event.set_character_position(16, 0.0, 0.0, 0.0)
			event.set_character_rotation(16, 0.0, 3.0, 0.0)
			event.attach_object_handle_to_character(8, 16)
			event.clear_object_sequence(8)
			event.set_object_sequence_object(8, 8)
			event.load_character(5, "e111_hahen02.gltf", "info", 17)
			event.set_character_active(0, 17)
			event.set_character_position(17, 0.0, 0.0, 0.0)
			event.set_character_rotation(17, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_character(9, 17)
			event.clear_object_sequence(9)
			event.set_object_sequence_object(9, 9)
			event.set_current_directory("")
			sound_effect = event.load_sound_effect_file_2(1831) or sound_effect
			event.set_object_handle_sound_bank(2, sound_effect)
			event.set_object_handle_sound_bank(3, sound_effect)
			event.set_object_handle_sound_bank(4, sound_effect)
			event.set_object_handle_sound_bank(7, -1)
			event.set_object_handle_sound_bank(8, -1)
			event.set_object_handle_sound_bank(9, -1)
			event.attach_object_handle_to_character(5, 1)
			event.set_object_handle_visible(5, 0)
			event.attach_object_handle_to_character(6, 2)
			event.set_object_handle_visible(6, 0)
			event.set_object_sequence_motion(1, "倒れ", 6)
			event.wait_object_sequence_motion_end(1)
			event.enable_drama_skip()
			event.clear_camera_sequence()
			event.set_camera_sequence_position(315.53, 60.49, -68.59)
			event.set_camera_sequence_look_at(-19.71, 69.17, 0.25)
			event.mark_camera_sequence_fade_track()
			event.fade_in_camera_sequence(30)
			resume_point = 12
			camera.wait_until_done()
			resume_point = 13
			wait.frames(12)
			event.play_sound_effect(sound_effect, 18)
			resume_point = 14
			object.wait_until_done(1)
			event.set_character_active(13)
			event.play_object_sequence_sound(1, sound_effect, 31)
			event.delay_object_sequence_sound_track(1, 20)
			event.play_object_sequence_sound(1, sound_effect, 32)
			event.delay_object_sequence_sound_track(1, 8)
			event.play_object_sequence_sound(1, sound_effect, 31)
			resume_point = 15
			wait.frames(30)
			event.set_camera_sequence_position(44.03, 197.99, -10.5)
			event.set_camera_sequence_look_at(0.02, 199.41, -0.53)
			event.set_object_sequence_motion(2, "両手広げる", 6)
			event.queue_object_sequence_next_motion(2, "両手広げるL", 4)
			event.set_object_handle_texture_animation(2, 0, "口・こまり")
			event.set_mouth_texture_animations(2, "口パク２", "口・こまり")
			resume_point = 16
			message.show_voiced(1110010)
			event.reset_mouth_texture_animations()
			resume_point = 17
			object.wait_until_done(2)
			event.set_camera_sequence_position(238.32, 116.37, -106.27)
			event.set_camera_sequence_look_at(-6.37, 50.07, -17.02)
			event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(2, "抱き着き", 6)
			event.queue_object_sequence_next_motion(2, "抱き着きL", 4)
			event.set_object_handle_texture_animation(2, 0, "口・こまり")
			event.set_mouth_texture_animations(2, "口パク２", "口・こまり")
			resume_point = 18
			message.show_voiced(1110020)
			event.reset_mouth_texture_animations()
			resume_point = 19
			object.wait_until_done(2)
			event.set_camera_sequence_position(230.72, 15.98, -98.52)
			event.set_camera_sequence_look_at(28.12, 61.49, 12.32)
			event.set_character_active(0)
			event.set_character_active(14)
			event.set_character_motion(14, "爆発", 6)
			resume_point = 20
			wait.frames(4)
			event.play_sound_effect(sound_effect, 33)
			elapsed_frames = 0
			resume_point = 21
			wait.frames(16 - elapsed_frames)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・フクザツ")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			event.set_object_sequence_motion(0, "爆発", 6)
			event.queue_object_sequence_next_motion(0, "爆発L", 4)
			resume_point = 22
			wait.frames(60)
			event.set_camera_sequence_position(224.0, 20.06, -43.69)
			event.set_camera_sequence_look_at(253.55, 21.35, -49.32)
			event.set_object_sequence_position(0, 250.0, 0.0, -50.0)
			event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
			event.reset_object_sequence_motion(0)
			event.set_object_sequence_motion(0, "爆発L", 4, -1.0, 1)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_character_active(0, 9)
			event.set_character_active(0, 10)
			event.set_character_active(0, 13)
			event.set_character_active(0, 14)
			event.set_character_active(1, 15)
			event.set_character_active(1, 16)
			event.set_character_active(1, 17)
			resume_point = 23
			wait.frames(40)
			event.reset_object_sequence_motion(7)
			event.set_object_sequence_motion(7, "破片", 6)
			resume_point = 24
			wait.frames(5)
			event.reset_object_sequence_motion(8)
			event.set_object_sequence_motion(8, "破片", 6)
			event.reset_object_sequence_motion(9)
			event.set_object_sequence_motion(9, "破片", 6)
			resume_point = 25
			wait.frames(15)
			event.set_camera_sequence_position(47.2, 92.89, -142.19)
			event.set_camera_sequence_look_at(85.43, 16.34, 45.38)
			event.set_object_sequence_position(7, -22.38, 0.0, -1.68)
			event.set_object_sequence_position(8, -5.05, 0.0, -21.05)
			event.set_object_sequence_position(9, -0.08, 0.0, -45.14)
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "目・閉じ")
			event.set_object_sequence_texture_animation(2, 1, "口・こまり")
			event.set_character_active(10)
			event.set_character_visible(10, 1)
			event.set_object_sequence_rotation(2, 0.0, -2.08, 0.0)
			event.move_object_sequence_eased(2, 84.29, 0.0, 53.13, 40, 2, 0.2)
			event.set_object_sequence_motion(2, "倒れる", 6)
			event.queue_object_sequence_next_motion(2, "倒れるL", 4)
			event.move_object_sequence(7, 221.23, 0.0, 41.5, 80)
			resume_point = 26
			wait.frames(5)
			event.move_object_sequence(8, 31.26, 0.0, 224.79, 68)
			event.move_object_sequence(9, 85.17, 0.0, 135.16, 60)
			resume_point = 27
			wait.frames(2)
			event.play_sound_effect(sound_effect, 37)
			resume_point = 28
			object.wait_until_done(2)
			resume_point = 29
			wait.frames(30)
			event.set_camera_sequence_position(198.72, 10.01, -8.33)
			event.set_camera_sequence_look_at(245.11, 19.47, -50.58)
			event.set_object_sequence_motion(0, "ポルカスに近づく")
			event.set_object_sequence_motion_blend_step(0, 0.04)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・真剣")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			resume_point = 30
			wait.frames(20)
			event.move_object_sequence_eased(0, 218.58, 0.0, -35.53, 40, 1, 0.4)
			resume_point = 31
			wait.frames(47)
			event.set_camera_sequence_position(109.18, 34.69, -86.0)
			event.set_camera_sequence_look_at(83.61, 7.22, 47.83)
			event.set_object_sequence_position(0, 71.02, 0.0, -22.65)
			event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
			event.move_object_sequence(0, 77.52, 0.0, 8.58, 50)
			event.reset_object_sequence_motion(0)
			event.set_object_sequence_motion(0, "ポルカスに近づく", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "振り向く", 6)
			event.queue_object_sequence_next_motion(0, "振り向くL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.delay_object_sequence_texture_animation_track(0, 30)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・振り向き")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			resume_point = 32
			wait.frames(40)
			resume_point = 33
			message.show_voiced(1110030)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			resume_point = 34
			message.show_voiced(1110040)
			event.reset_mouth_texture_animations()
			event.set_camera_sequence_position(204.37, 31.72, 9.99)
			event.set_camera_sequence_look_at(264.2, 27.01, -5.8)
			event.set_character_active(11)
			event.set_character_active(12)
			event.set_object_sequence_position(3, 375.73, 0.0, -22.37)
			event.set_object_sequence_rotation(3, 0.0, -1.32, 0.0)
			event.move_object_sequence(3, 224.72, 0.0, 9.78, 30)
			event.set_object_sequence_motion(3, "走り", 4)
			event.set_object_sequence_position(4, 436.56, 0.0, -64.46)
			event.set_object_sequence_rotation(4, 0.0, -1.32, 0.0)
			event.move_object_sequence(4, 268.47, 0.0, -20.1, 30)
			event.set_object_sequence_motion(4, "走り", 4)
			event.set_object_sequence_motion_time(4, 5.7)
			resume_point = 35
			object.wait_until_done(3)
			event.set_camera_sequence_position(80.24, 21.69, -11.79)
			event.set_camera_sequence_look_at(80.02, 22.6, 6.87)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			resume_point = 36
			message.show_voiced_for(1110050, -1)
			event.reset_mouth_texture_animations()
			event.set_camera_sequence_position(169.2, 49.46, -43.53)
			event.set_camera_sequence_look_at(78.35, 3.24, 42.02)
			event.set_object_sequence_motion(0, "こける", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "こけるL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・ビックリ")
			event.set_object_sequence_texture_animation(0, 1, "口・ビックリ")
			event.set_object_sequence_position(3, 139.55, 0.0, -50.54)
			event.set_object_sequence_rotation(3, 0.0, -0.24, 0.0)
			event.move_object_sequence(3, 112.86, 0.0, 70.42, 30)
			event.delay_object_sequence_rotation_track(3, 20)
			event.rotate_object_sequence(3, 0.0, -2.16, 0.0, 10)
			event.delay_object_sequence_motion_track(3, 30)
			event.set_object_sequence_motion(3, "立ち")
			event.set_object_sequence_position(4, 41.41, 0.0, -20.18)
			event.set_object_sequence_rotation(4, 0.0, 0.24, 0.0)
			event.move_object_sequence(4, 68.8, 0.0, 44.59, 30)
			event.delay_object_sequence_rotation_track(4, 20)
			event.rotate_object_sequence(4, 0.0, 1.08, 0.0, 10)
			event.delay_object_sequence_motion_track(4, 30)
			event.set_object_sequence_motion(4, "立ち")
			resume_point = 37
			object.wait_until_done(3)
			resume_point = 38
			object.wait_until_done(4)
			resume_point = 39
			wait.frames(2)
			event.set_object_sequence_motion(2, "持ち上げ", 6)
			event.set_object_sequence_motion(3, "頭持ち上げ", 6)
			event.set_object_sequence_motion(4, "足持ち上げ", 6)
			resume_point = 40
			wait.frames(78)
			event.set_object_sequence_motion(0, "見送る", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "見送るL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			event.set_object_sequence_motion(2, "運ばれる")
			event.set_object_sequence_motion(3, "頭持ち歩きL")
			event.set_object_sequence_motion(4, "足持ち歩き")
			event.move_object_sequence_eased(2, 140.22, 0.0, -53.49, 60, 1, 0.1)
			event.move_object_sequence_eased(3, 174.0, 0.0, -35.88, 60, 1, 0.1)
			event.move_object_sequence_eased(4, 128.99, 0.0, -59.89, 60, 1, 0.1)
			resume_point = 41
			message.show_voiced_for(1110060, 60)
			resume_point = 42
			object.wait_until_done(2)
			event.set_camera_sequence_position(12.04, 19.34, -2.84)
			event.set_camera_sequence_look_at(163.83, 7.62, -48.59)
			event.set_object_sequence_position(0, 71.02, 0.0, -22.65)
			event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_position(2, 233.65, 0.0, -50.46)
			event.set_object_sequence_rotation(2, 0.0, -2.92, 0.0)
			event.set_object_sequence_position(3, 241.55, 0.0, -12.36)
			event.set_object_sequence_rotation(3, 0.0, -3.0, 0.0)
			event.set_object_sequence_position(4, 230.89, 0.0, -63.54)
			event.set_object_sequence_rotation(4, 0.0, 0.24, 0.0)
			event.move_object_sequence(2, 671.22, 0.0, -131.94, 160)
			event.move_object_sequence(3, 678.84, 0.0, -94.13, 160)
			event.move_object_sequence(4, 668.34, 0.0, -144.99, 160)
			resume_point = 43
			message.show_voiced_for(1110060, 60)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			resume_point = 44
			message.show_voiced_for(1110080, 90)
			event.reset_mouth_texture_animations()
			resume_point = 45
			object.wait_until_done(2)
			event.set_character_active(0, 10)
			event.set_character_active(0, 11)
			event.set_character_active(0, 12)
			event.set_camera_sequence_position(115.02, 23.5, 34.8)
			event.set_camera_sequence_look_at(83.65, 15.41, -18.49)
			event.set_object_sequence_position(0, 83.74, 0.0, -19.9)
			event.set_object_sequence_rotation(0, 0.0, 0.84, 0.0)
			event.set_object_sequence_motion(0, "立ちあがる", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "ため息", 6)
			event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.delay_object_sequence_texture_animation_track(0, 34)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.set_object_sequence_texture_animation(0, 1, "口・ため息")
			resume_point = 46
			wait.frames(34)
			resume_point = 47
			message.show_voiced(1110090)
			resume_point = 48
			object.wait_until_done(0)
			event.set_camera_sequence_position(157.76, 23.5, -3.06)
			event.set_camera_sequence_look_at(61.27, 16.36, -2.61)
			event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
			event.set_object_sequence_motion(0, "振り返る", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・真剣")
			event.set_object_sequence_texture_animation(0, 1, "口・真剣")
			resume_point = 49
			object.wait_until_done(0)
			resume_point = 50
			wait.frames(30)
			event.set_camera_sequence_position(-430.32, 64.84, 57.91)
			event.set_camera_sequence_look_at(-921.56, 67.83, 181.76)
			event.move_camera_sequence(-526.57, 64.84, 82.17, -921.56, 67.83, 181.76, 120)
			resume_point = 51
			camera.wait_until_done()
			event.set_camera_sequence_position(58.55, 16.4, 0.48)
			event.set_camera_sequence_look_at(82.64, 21.24, -20.55)
			event.set_object_handle_texture_animation(0, 0, "口・真剣")
			event.set_mouth_texture_animations(0, "通常口パク", "口・真剣")
			resume_point = 52
			message.show_voiced(1110100)
			event.reset_mouth_texture_animations()
			event.start_crossfade(60)
			event.set_camera_sequence_position(69.71, 21.68, -9.26)
			event.set_camera_sequence_look_at(82.64, 24.57, -20.55)
			resume_point = 53
			wait.frames(120)
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(30)
			resume_point = 54
			camera.wait_until_done()
			return nil
		end, function(received: { any }): boolean
			if resume_point <= 10 then
				return false
			end
			if resume_point <= 11 then
				wait.background_load_skipping()
			end
			if resume_point <= 12 then
				wait.frames_skipping(12)
			end
			if resume_point <= 13 then
				cutscene.skip_command(1)
			end
			if resume_point <= 14 then
				wait.frames_skipping(30)
			end
			if resume_point <= 15 then
				message.show_voiced_skipping(1110010)
			end
			if resume_point <= 16 then
				cutscene.skip_command(2)
			end
			if resume_point <= 17 then
				message.show_voiced_skipping(1110020)
			end
			if resume_point <= 18 then
				cutscene.skip_command(2)
			end
			if resume_point <= 19 then
				wait.frames_skipping(4)
			end
			if resume_point <= 20 then
				elapsed_frames = 0
				wait.frames_skipping(16 - elapsed_frames)
			end
			if resume_point <= 21 then
				wait.frames_skipping(60)
			end
			if resume_point <= 22 then
				wait.frames_skipping(40)
			end
			if resume_point <= 23 then
				wait.frames_skipping(5)
			end
			if resume_point <= 24 then
				wait.frames_skipping(15)
			end
			if resume_point <= 25 then
				wait.frames_skipping(5)
			end
			if resume_point <= 26 then
				wait.frames_skipping(2)
			end
			if resume_point <= 27 then
				cutscene.skip_command(2)
			end
			if resume_point <= 28 then
				wait.frames_skipping(30)
			end
			if resume_point <= 29 then
				wait.frames_skipping(20)
			end
			if resume_point <= 30 then
				wait.frames_skipping(47)
			end
			if resume_point <= 31 then
				wait.frames_skipping(40)
			end
			if resume_point <= 32 then
				message.show_voiced_skipping(1110030)
			end
			if resume_point <= 33 then
				message.show_voiced_skipping(1110040)
			end
			if resume_point <= 34 then
				cutscene.skip_command(3)
			end
			if resume_point <= 35 then
				message.show_voiced_for_skipping(1110050, -1)
			end
			if resume_point <= 36 then
				cutscene.skip_command(3)
			end
			if resume_point <= 37 then
				cutscene.skip_command(4)
			end
			if resume_point <= 38 then
				wait.frames_skipping(2)
			end
			if resume_point <= 39 then
				wait.frames_skipping(78)
			end
			if resume_point <= 40 then
				message.show_voiced_for_skipping(1110060, 60)
			end
			if resume_point <= 41 then
				cutscene.skip_command(2)
			end
			if resume_point <= 42 then
				message.show_voiced_for_skipping(1110060, 60)
			end
			if resume_point <= 43 then
				message.show_voiced_for_skipping(1110080, 90)
			end
			if resume_point <= 44 then
				cutscene.skip_command(2)
			end
			if resume_point <= 45 then
				wait.frames_skipping(34)
			end
			if resume_point <= 46 then
				message.show_voiced_skipping(1110090)
			end
			if resume_point <= 47 then
				cutscene.skip_command(0)
			end
			if resume_point <= 48 then
				cutscene.skip_command(0)
			end
			if resume_point <= 49 then
				wait.frames_skipping(30)
			end
			if resume_point <= 50 then
				wait.background_load_skipping()
			end
			if resume_point <= 51 then
				message.show_voiced_skipping(1110100)
			end
			if resume_point <= 52 then
				wait.frames_skipping(120)
			end
			if resume_point <= 53 then
				wait.background_load_skipping()
			end
			return true
		end)
		if ret ~= nil then
			return
		end
	end
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.clear_event_battle_monsters(-1)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, -1)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.set_character_active(0)
	event.set_character_position(0, 83.74, 0.0, -19.9)
	event.set_character_rotation(0, 0.0, -1.32, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_action_character_motion(0)
	event.set_camera_position(209.67, 35.0, -52.16)
	event.set_camera_look_at(83.74, 30.0, -19.9)
	event.reset_follow_camera(0)
	event.load_map_sounds(1683)
	event.show_dungeon_status_bar(1)
	event.fade_in_screen(30)
	event.finish_event()
end

return underground_water_channel_boss
