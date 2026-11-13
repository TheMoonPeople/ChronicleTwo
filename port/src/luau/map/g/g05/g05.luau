--!strict
--- Event script for the Moon Flower Palace map covering entries, exits and georama hint scenes.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local moon_flower_palace_georama = require("@lib/event/moon_flower_palace_georama")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Placeholder hook that the entry events call and that does nothing on this map.
local function empty_map_hook() end

--- Asks the exit prompt with the given id and returns 1 after fading out when the player confirms, otherwise returns 0.
local function confirm_leave_scene(prompt_id: s32)
	local exit_choice: any = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		progress = 1
		exit_choice = message.ask_yes_no(5, prompt_id)
		if exit_choice == 0 then
			event.fade_out_screen(20)
			progress = 2
			wait.for_frame_count(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if progress <= 2 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		return nil
	end)
end

--- Plays event 700 with Andrea, Mints and Monica at noon, then restores the time of day and fades out.
local function play_scene_e700()
	local playable_character: s32 = 0
	local sound_effect_file: s32 = 0
	local time_of_day: f32 = 0
	vm.section(function()
		event.set_save_flag(700, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.load_map_sounds(7204)
		sound_effect_file = event.load_sound_effect_file_2(7204) or sound_effect_file
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e700/")
		event.load_message_file(0, 5, "e700.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e700_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e700_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e700_andrea.gltf", "info", 34)
		event.set_scene_status_flags(1, 34, 8, 1)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e700_a_hikari.gltf", "info", 35)
		event.set_scene_character_type(35, 4)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e700/e700_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e700/e700_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 7.0, 0.0, 200.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 7)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -7.0, 0.0, 198.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 7)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, 20.0, 160.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_motion(2, "両手開くＬ", 4)
		event.set_object_handle_position(3, 11.0, 40.0, 160.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "後光", 4)
		event.enable_drama_skip()
		time_of_day = event.get_scene_time_of_day() or time_of_day
		event.set_time_of_day(12.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(24.65, 49.97, 163.5)
		event.set_camera_sequence_look_at(-24.72, 49.99, 159.92)
		wait.for_frame_count(30)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目あけ～目とじ２")
		event.set_object_sequence_motion(2, "両手開いて深呼吸", 2)
		event.queue_object_sequence_next_motion(2, "両手開いて深呼吸Ｌ", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(7000140)
		event.set_camera_sequence_position(0.0, 17.98, 252.41)
		event.set_camera_sequence_look_at(0.0, 26.48, 201.7)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ３")
		event.set_object_sequence_position(3, 0.0, 40.0, 160.0)
		event.set_object_sequence_motion(2, "両手開く戻り", 6)
		event.queue_object_sequence_next_motion(2, "浮遊立ち", 4)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000150)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000155)
		object.wait_until_done(2)
		event.set_camera_sequence_position(0.0, 48.71, 192.39)
		event.set_camera_sequence_look_at(0.0, 48.68, 135.78)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000160)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000165)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目あき～さみし目とじ")
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000170)
		event.set_camera_sequence_position(0.0, 39.02, 371.19)
		event.set_camera_sequence_look_at(0.0, 38.99, 314.58)
		event.play_sound_effect(sound_effect_file, 2)
		event.set_character_visible(34, 0, 1, 0.033333335)
		event.set_object_sequence_motion(3, "消失", 2)
		wait.for_frame_count(30)
		event.move_camera_sequence_eased(0.0, 39.02, 371.19, 0.0, 61.67, 314.58, 60, 0, 0.2)
		camera.wait_until_done()
		wait.for_frame_count(20)
		event.set_time_of_day(time_of_day)
		event.start_crossfade(60)
		wait.for_frame_count(90)
		event.set_camera_sequence_position(23.26, 26.93, 164.88)
		event.set_camera_sequence_look_at(-0.0, 18.34, 203.74)
		wait.for_frame_count(40)
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_effect_file, 3)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, sound_effect_file, 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7000180)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(7000190)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, sound_effect_file, 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_effect_file, 5)
		wait.for_frame_count(10)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		wait.for_frame_count(10)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目～おこり目")
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.empty_map_hook = empty_map_hook
script[99] = script.empty_map_hook

--- Places the player depending on the map they came from.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local old_map_type: s32 = 0
	empty_map_hook()
	memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
	if memory_card_load_state == 1 then
		character.place_standing_and_reset_cloth(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	else
		previous_map_number = event.get_previous_map() or previous_map_number
		old_map_type = event.get_map_type(previous_map_number) or old_map_type
		if old_map_type ~= -1 and previous_map_number ~= 4 then
			if previous_map_number == 109 then
				character.place_standing_and_reset_cloth(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			else
				character.place_standing_and_reset_cloth(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			end
		end
	end
end

--- Waits for the menu button press instead of the default handler.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

--- Asks to leave and jumps to the s34 map when confirmed.
function script.exit_to_s34()
	if confirm_leave_scene(155) ~= 0 then
		event.jump_to_map_2(-1, "s34")
	end
end
script[200] = script.exit_to_s34

--- Asks to leave and enters the d06e01 map when confirmed.
function script.exit_to_dungeon_d06e01()
	local flag: s32 = 0
	if confirm_leave_scene(109) ~= 0 then
		flag = event.get_save_flag(702) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "d06e01")
	end
end
script[210] = script.exit_to_dungeon_d06e01

--- Plays the pending hint scene on the s44 map after a georama change.
function script.edit_analyze_changed()
	if (if moon_flower_palace_georama.is_hint_pending_744() ~= 0 then moon_flower_palace_georama.is_hint_pending_748() else 0) ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_save_flag(744, 1)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 570)
		vm.wait(2)
	end
	if moon_flower_palace_georama.is_hint_pending_744() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_save_flag(744, 1)
		event.jump_to_map_3(-1, "s44", 550)
		vm.wait(4)
	end
	if moon_flower_palace_georama.is_hint_pending_748() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 560)
		vm.wait(6)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Plays scene e700 and places the player in the palace.
function script.play_scene_e700()
	play_scene_e700()
	event.set_save_data_value(0, 9)
	event.load_map_sounds(7000)
	character.place_standing_and_reset_cloth(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, -1000.0)
	event.set_camera_position(0.0, 50.0, -880.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end
script[500] = script.play_scene_e700

--- Places the player and fades in after the first georama hint scene.
function script.return_from_hint_scene()
	character.place_standing_and_reset_cloth(0.0, 0.0, -1100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -1100.0)
	event.set_camera_position(0.0, 50.0, -1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end
script[550] = script.return_from_hint_scene

--- Places the player, fades in and gives the two reward items after the second georama hint scene.
function script.return_from_hint_scene_with_reward()
	character.place_standing_and_reset_cloth(0.0, 0.0, -1100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -1100.0)
	event.set_camera_position(0.0, 50.0, -1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	wait.for_frame_count(30)
	event.add_inventory_item(198, 1)
	event.add_inventory_item(199, 1)
	inventory.announce_received(198, 1)
	inventory.announce_received(199, 1)
	inventory.resolve_overflow(1)
end
script[560] = script.return_from_hint_scene_with_reward

return script
