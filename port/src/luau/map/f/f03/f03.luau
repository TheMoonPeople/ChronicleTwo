--!strict
--- Event script for the f03 town map, with its story scenes, door entrances and replay shortcuts.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local field_town_f03 = require("@lib/event/field_town_f03")
local georama = require("@lib/event/georama")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Shows or hides the map parts and door function points according to the analysis flags.
local function update_map_parts()
	local analysis_flag_305: s32 = 0
	event.attach_object_handle_to_map_part_2(1, "p04_f0301")
	analysis_flag_305 = georama.is_analysis_flag_305_set()
	if analysis_flag_305 == 0 then
		event.set_function_point_enabled("", "event_400", 0)
		event.set_function_point_enabled("", "event_401", 0)
		event.set_function_point_enabled("", "event_402", 0)
		event.set_function_point_enabled("", "event_403", 0)
		event.set_function_point_enabled("", "event_404", 0)
	else
		event.set_object_handle_visible(1, 0)
	end
	if field_town_f03.get_analysis_flag_300() == 0 then
		event.attach_object_handle_to_map_part_2(1, "p14_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p15_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p16_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p17_f0301")
		event.set_object_handle_visible(1, 0)
	end
	field_town_f03.update_character_activation()
end

--- Plays the e456 cutscene in which the party points ahead and runs off.
local function play_event_e456()
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(456, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e456/")
		event.load_message_file(0, 5, "e456.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e456_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e456_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e456/e456_mints.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e456/e456_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -15.0, 190.0, 980.0)
		event.set_object_handle_rotation(0, 0.0, 2.42, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 10.0, 190.0, 1010.0)
		event.set_object_handle_rotation(1, 0.0, 2.66, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-121.94, 324.32, 1079.66)
		event.set_camera_sequence_look_at(60.51, 330.31, 947.34)
		event.move_camera_sequence_eased(-121.94, 324.32, 1079.66, -127.07, 330.31, 851.61, 60, 0, 1.0)
		event.fade_in_screen(30)
		camera.wait_until_done()
		event.set_camera_sequence_position(-43.47, 251.31, 889.38)
		event.set_camera_sequence_look_at(0.73, 198.66, 1005.94)
		event.set_object_sequence_motion(0, "指さし", 6)
		event.queue_object_sequence_next_motion(0, "指さしL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4560010)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "指さし戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4560020)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -15.0, 190.0, 820.0, 60)
		event.rotate_object_sequence(0, 0.0, 3.14, 0.0, 10)
		wait.for_frame_count(4)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, 10.0, 190.0, 870.0, 56)
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 10)
		wait.for_frame_count(26)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, 190.0, 500.0, vm.f32(-3.14))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Plays the e460 cutscene in which the party walks up, looks into the distance and runs off.
local function play_event_e460()
	local sound_effect: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(460, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4514)
		sound_effect = event.load_sound_effect_file_2(4514) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e460/")
		event.load_message_file(0, 5, "e460.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e460_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e460_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e460/e460_mints.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e460/e460_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 10.0, 190.0, 1010.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -15.0, 190.0, 980.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1.18, 274.82, 1359.97)
		event.set_camera_sequence_look_at(120.59, 276.91, 1224.84)
		event.move_camera_sequence_eased(1.18, 274.82, 1359.97, -53.13, 276.91, 1185.49, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 70)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 10.0, 190.0, 950.0, 70)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 80)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -15.0, 190.0, 900.0, 60)
		event.fade_in_screen(30)
		camera.wait_until_done()
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-86.36, 229.97, 864.78)
		event.set_camera_sequence_look_at(-1.3, 198.75, 922.91)
		event.set_object_sequence_rotation(0, 0.0, -2.54, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.play_sound_effect(sound_effect, 0)
		event.set_object_sequence_rotation(1, 0.0, -2.18, 0.0)
		event.set_object_sequence_motion(1, "遠見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "遠見Ｌ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4600010)
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect, 1)
		event.set_object_sequence_motion(1, "遠見戻り", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4600020)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -15.0, 190.0, 740.0, 60)
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 10)
		wait.for_frame_count(4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 10.0, 190.0, 790.0, 56)
		event.rotate_object_sequence(0, 0.0, 3.14, 0.0, 10)
		wait.for_frame_count(26)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(12)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, 190.0, 500.0, vm.f32(-3.14))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.update_map_parts = update_map_parts
script[99] = script.update_map_parts

--- Plays whichever story scene is due and otherwise places the player according to the map they came from.
function script.default_event()
	local scene_played: s32 = 0
	local previous_map_number: s32 = 0
	local entrance_slot: s32 = 0
	local previous_submap_number: s32 = 0
	local previous_interior_map_number: s32 = 0
	local step: number = 0
	return vm.guard(function()
		update_map_parts()
		field_town_f03.update_character_activation()
		event.get_georama_analysis_percent(2)
		scene_played = 0
		if georama.can_start_event_456() ~= 0 then
			scene_played = 1
			step = 1
			play_event_e456()
		end
		if georama.can_start_event_460() ~= 0 then
			scene_played = 1
			step = 2
			play_event_e460()
		end
		if georama.can_start_event_468() ~= 0 then
			scene_played = 1
			event.skip_next_music_play()
			event.jump_to_map_3(-1, "f03i0301", 504)
			step = 3
			vm.wait(3)
		end
		if scene_played == 1 then
			return
		end
		previous_map_number = event.get_previous_map() or previous_map_number
		if previous_map_number == 2 then
			event.initialize_event()
			step = 4
			vm.wait(4)
			character.place_standing(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			event.reset_follow_camera(1, 3.14, 2.0)
			event.fade_in_screen(30)
		end
		if previous_map_number == 110 then
			event.initialize_event()
			step = 5
			vm.wait(5)
			entrance_slot = event.get_save_counter(2) or entrance_slot
			if entrance_slot == 0 then
				character.place_standing(0.0, 360.0, -755.0, 0.0)
			end
			if entrance_slot == 1 then
				character.place_standing(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
			end
			if entrance_slot == 2 then
				character.place_standing(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
			end
			if entrance_slot == 3 then
				character.place_standing(315.0, 280.0, -1515.0, vm.f32(2.3561945))
			end
			if entrance_slot == 4 then
				character.place_standing(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if previous_map_number == 113 then
			event.initialize_event()
			step = 6
			vm.wait(6)
			character.place_standing(1080.0, 190.0, -120.0, vm.f32(-2.355))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if previous_map_number == 141 then
			event.initialize_event()
			step = 7
			vm.wait(7)
			character.place_standing(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if previous_map_number == 142 then
			event.initialize_event()
			step = 8
			vm.wait(8)
			character.place_standing(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if previous_map_number == 114 then
			event.initialize_event()
			step = 9
			vm.wait(9)
			character.place_standing(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		previous_submap_number = event.get_previous_submap() or previous_submap_number
		previous_interior_map_number = event.get_previous_interior_map() or previous_interior_map_number
		print("map_no=", previous_map_number, "##############\n")
		print("old_submap_no=", previous_submap_number, "##############\n")
		print("old_interior_map_no=", previous_interior_map_number, "##############\n")
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				local _ = georama.can_start_placeholder_event_b()
				scene_played = 1
				step = 2
				play_event_e460()
				return vm.continue_with(function()
					if georama.can_start_event_468() ~= 0 then
						scene_played = 1
						event.skip_next_music_play()
						event.jump_to_map_3(-1, "f03i0301", 504)
						step = 3
						vm.wait(3)
					end
					if scene_played == 1 then
						return
					end
					previous_map_number = event.get_previous_map() or previous_map_number
					if previous_map_number == 2 then
						event.initialize_event()
						step = 4
						vm.wait(4)
						character.place_standing(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
						event.reset_follow_camera(1, 3.14, 2.0)
						event.fade_in_screen(30)
					end
					if previous_map_number == 110 then
						event.initialize_event()
						step = 5
						vm.wait(5)
						entrance_slot = event.get_save_counter(2) or entrance_slot
						if entrance_slot == 0 then
							character.place_standing(0.0, 360.0, -755.0, 0.0)
						end
						if entrance_slot == 1 then
							character.place_standing(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
						end
						if entrance_slot == 2 then
							character.place_standing(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
						end
						if entrance_slot == 3 then
							character.place_standing(315.0, 280.0, -1515.0, vm.f32(2.3561945))
						end
						if entrance_slot == 4 then
							character.place_standing(315.0, 280.0, -885.0, vm.f32(0.7853982))
						end
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if previous_map_number == 113 then
						event.initialize_event()
						step = 6
						vm.wait(6)
						character.place_standing(1080.0, 190.0, -120.0, vm.f32(-2.355))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if previous_map_number == 141 then
						event.initialize_event()
						step = 7
						vm.wait(7)
						character.place_standing(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if previous_map_number == 142 then
						event.initialize_event()
						step = 8
						vm.wait(8)
						character.place_standing(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if previous_map_number == 114 then
						event.initialize_event()
						step = 9
						vm.wait(9)
						character.place_standing(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					previous_submap_number = event.get_previous_submap() or previous_submap_number
					previous_interior_map_number = event.get_previous_interior_map() or previous_interior_map_number
					print("map_no=", previous_map_number, "##############\n")
					print("old_submap_no=", previous_submap_number, "##############\n")
					print("old_interior_map_no=", previous_interior_map_number, "##############\n")
					return
				end)
			end
			if step <= 2 then
				local _ = georama.can_start_placeholder_event_c()
				scene_played = 1
			end
			return 0
		end
		if step <= 9 then
			if step <= 4 then
				cutscene.ignore_coordinates(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			end
			if step <= 5 then
				cutscene.ignore_coordinates(0.0, 360.0, -755.0, 0.0)
				cutscene.ignore_coordinates(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
				cutscene.ignore_coordinates(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
				cutscene.ignore_coordinates(315.0, 280.0, -1515.0, vm.f32(2.3561945))
				cutscene.ignore_coordinates(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			if step <= 6 then
				cutscene.ignore_coordinates(1080.0, 190.0, -120.0, vm.f32(-2.355))
			end
			if step <= 7 then
				cutscene.ignore_coordinates(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			end
			if step <= 8 then
				cutscene.ignore_coordinates(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			end
			cutscene.ignore_coordinates(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			print("map_no=", previous_map_number, "##############\n")
			print("old_submap_no=", previous_submap_number, "##############\n")
			print("old_interior_map_no=", previous_interior_map_number, "##############\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Tells the player the door will not open.
function script.key_open() end

--- Warps through the time gate and jumps to the g03 map.
function script.enter_time_gate()
	cutscene.play_time_gate_warp(160.0, vm.f32(286.2), 1849.5, 0.0)
	event.jump_to_map_2(-1, "g03")
	vm.wait(2)
end
script[300] = script.enter_time_gate

--- Leaves through a door into the f03i04 interior and records entrance slot 0.
function script.enter_f03i04_slot_0()
	map.fade_out_facing_door(vm.f32(3.1415927), 1)
	event.set_save_counter(2, 0)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end
script[400] = script.enter_f03i04_slot_0

--- Leaves through a door into the f03i04 interior and records entrance slot 2.
function script.enter_f03i04_slot_2()
	map.fade_out_facing_door(vm.f32(0.7853982), 0)
	event.set_save_counter(2, 2)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end
script[401] = script.enter_f03i04_slot_2

--- Leaves through a door into the f03i04 interior and records entrance slot 1.
function script.enter_f03i04_slot_1()
	map.fade_out_facing_door(vm.f32(2.3561945), 0)
	event.set_save_counter(2, 1)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end
script[402] = script.enter_f03i04_slot_1

--- Leaves through a door into the f03i04 interior and records entrance slot 4.
function script.enter_f03i04_slot_4()
	map.fade_out_facing_door(vm.f32(-2.3561945), 0)
	event.set_save_counter(2, 4)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end
script[403] = script.enter_f03i04_slot_4

--- Leaves through a door into the f03i04 interior and records entrance slot 3.
function script.enter_f03i04_slot_3()
	map.fade_out_facing_door(vm.f32(-0.7853982), 0)
	event.set_save_counter(2, 3)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end
script[404] = script.enter_f03i04_slot_3

--- Leaves through a door into the f03i0301 interior, keeping the music when event 412 is due next.
function script.enter_f03i0301()
	local osmond_awake_flag: s32 = 0
	local event_412_done_flag: s32 = 0
	map.fade_out_facing_door(vm.f32(0.7853982), 0)
	osmond_awake_flag = event.get_save_flag(408) or osmond_awake_flag
	event_412_done_flag = event.get_save_flag(412) or event_412_done_flag
	if osmond_awake_flag == 1 and event_412_done_flag == 0 then
		event.skip_next_music_load()
	end
	event.jump_to_map_3(-1, "f03i0301", 100)
	vm.wait(2)
end
script[405] = script.enter_f03i0301

--- Enters the f03i0302 interior unless the door is still locked by story flags.
function script.enter_f03i0302()
	local story_flag_400: s32 = 0
	local door_flag_420: s32 = 0
	local event_428_done_flag: s32 = 0
	story_flag_400 = event.get_save_flag(400) or story_flag_400
	door_flag_420 = event.get_save_flag(420) or door_flag_420
	if story_flag_400 == 1 and door_flag_420 == 0 then
		event.set_character_motion(0, "立ち")
		message.set_window_mode(0, 1)
		event.open_message_window_2(0, "開かない。後で来てみよう。")
		message.show(0, -1, 5, 256, 208)
		return
	else
		event_428_done_flag = event.get_save_flag(428) or event_428_done_flag
		if event_428_done_flag == 0 then
			event.skip_next_music_load()
		end
	end
	map.fade_out_facing_door(vm.f32(-2.3561945), 0)
	event.jump_to_map_3(-1, "f03i0302", 100)
	vm.wait(3)
end
script[406] = script.enter_f03i0302

--- Leaves through a door into the f03i0303 interior.
function script.enter_f03i0303()
	map.fade_out_facing_door(vm.f32(2.3561945), 0)
	event.jump_to_map_3(-1, "f03i0303", 100)
	vm.wait(2)
end
script[407] = script.enter_f03i0303

--- Leaves through a door into the f03i0304 interior.
function script.enter_f03i0304()
	map.fade_out_facing_door(vm.f32(-0.7853982), 0)
	event.jump_to_map_3(-1, "f03i0304", 100)
	vm.wait(2)
end
script[408] = script.enter_f03i0304

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = message.talk_to_lunar_lab_staff

--- Resets the analysis and save flags so event 456 is due again and jumps to map 82.
function script.replay_event_456()
	event.set_georama_analyze_flag(2, 2, 0)
	event.set_georama_analyze_flag(2, 3, 0)
	event.set_georama_analyze_flag(2, 4, 0)
	event.set_georama_analyze_flag(2, 5, 0)
	event.set_georama_analyze_flag(2, 6, 0)
	event.set_georama_analyze_flag(2, 7, 0)
	event.set_georama_analyze_flag(2, 8, 0)
	event.set_georama_analyze_flag(2, 9, 0)
	event.set_georama_analyze_flag(2, 0, 1)
	event.set_georama_analyze_flag(2, 1, 1)
	event.set_save_flag(456, 0)
	event.set_save_flag(460, 1)
	event.jump_to_map_3(-1, 82, 100)
	vm.wait(1)
end
script[14560] = script.replay_event_456

--- Resets the analysis and save flags so event 460 is due again and jumps to map 82.
function script.replay_event_460()
	event.set_georama_analyze_flag(2, 3, 0)
	event.set_georama_analyze_flag(2, 4, 0)
	event.set_georama_analyze_flag(2, 5, 0)
	event.set_georama_analyze_flag(2, 6, 0)
	event.set_georama_analyze_flag(2, 7, 0)
	event.set_georama_analyze_flag(2, 8, 0)
	event.set_georama_analyze_flag(2, 9, 0)
	event.set_georama_analyze_flag(2, 0, 1)
	event.set_georama_analyze_flag(2, 1, 1)
	event.set_georama_analyze_flag(2, 2, 1)
	event.set_save_flag(456, 1)
	event.set_save_flag(460, 0)
	event.jump_to_map_3(-1, 82, 100)
	vm.wait(1)
end
script[14600] = script.replay_event_460

return script
