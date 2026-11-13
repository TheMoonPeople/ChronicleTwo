--!strict
--- Event script for the Sleeping Water Chamber boss room, handling the boss intro, the lapis reward and the gate to the next dungeon.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Stops the music, loads the room sounds and hides the rapis point once the boss is beaten.
local function init_map()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(4694)
	flag = event.get_save_flag(632) or flag
	if flag == 1 then
		object.hide_rapis_point()
	end
end

--- Plays the boss introduction cutscene with its title banner.
local function play_boss_intro()
	local monster_sound_bank: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(190)
		event.play_music(0)
		monster_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_284.sound.json") or monster_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_character(5, "dungeon/monster/e54e.gltf", "e54e", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_sound_bank(2, monster_sound_bank)
		image_block = event.load_event_image_4(5, "textures/event/e600/e632/e632telop01.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e632telop01", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_active(0, 0)
		event.set_object_sequence_position(2, 0.0, 0.0, -800.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "待機")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 10.0, 1200.0)
		event.set_camera_sequence_look_at(0.0, -700.0, -800.0)
		event.move_camera_sequence_eased(0.0, 8.7, -698.83, 0.0, 40.0, -800.0, 150, 2, 0.2)
		event.fade_in_screen(30)
		wait.for_frame_count(75)
		event.set_object_sequence_motion(2, "立ち", 2)
		wait.for_frame_count(30)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "攻撃１", 6)
		event.queue_object_sequence_next_motion(2, "避け", 6)
		event.queue_object_sequence_next_motion(2, "避け戻り", 6)
		event.queue_object_sequence_next_motion(2, "攻撃２", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait.for_frame_count(150)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		wait.for_frame_count(30)
		wait.for_frame_count(30)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character(10)
	event.delete_event_image(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_active(0)
end

--- Plays the cutscene of the party receiving the water lapis.
local function play_lapis_acquired()
	local special_sound_bank: s32 = 0
	local event_sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(632, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		special_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or special_sound_bank
		event_sound_bank = event.load_sound_effect_file_2(4831) or event_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.show_dungeon_status_bar(0, 1.0)
		event.change_directory("event/e600/e624/")
		event.load_message_file(0, 5, "e624.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e624_mints.gltf", "info", 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e624_monica.gltf", "info", 0)
		end
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e632_lapis_mizu.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_sequence_to_object_frame(1, 0, "item", 0.0, 0.0, 0.0, -1)
		event.change_directory("")
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, 0.0, 4.0, -920.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-40.26, 20.64, -866.67)
		event.set_camera_sequence_look_at(-1.7, 36.27, -951.09)
		event.move_camera_sequence_eased(-29.36, 23.4, -890.54, -1.7, 36.27, -951.09, 90, 2, 1.0)
		event.play_sound_effect(event_sound_bank, 0)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		if playable_character == 0 then
			message.show_voiced(6240010)
		else
			message.show_voiced(6240020)
		end
		event.clear_camera_sequence()
		event.stop_sound_effect(event_sound_bank, 0)
		event.pause_music()
		event.attach_object_handle_to_map_part_3(30, "p01_s1301-m-m", "s1301_3-m0")
		event.set_object_handle_visible(30, 0)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		if playable_character == 0 then
			event.set_camera_sequence_position(0.0, 51.31, -963.58)
			event.set_camera_sequence_look_at(0.0, 28.64, -917.36)
			event.move_camera_sequence_eased(0.0, 46.94, -952.38, 0.0, 28.64, -917.36, 120, 2, 0.4)
			event.set_character_position(9, 7.74, 35.0, -918.0)
			event.set_character_rotation(9, 0.2, 0.24, 0.0)
		else
			event.set_camera_sequence_position(0.0, 53.31, -963.58)
			event.set_camera_sequence_look_at(0.0, 30.64, -917.36)
			event.move_camera_sequence_eased(0.0, 48.94, -952.38, 0.0, 30.64, -917.36, 120, 2, 0.4)
			event.set_character_position(9, -4.45, 37.0, -918.0)
			event.set_character_rotation(9, 0.2, -0.24, 0.0)
		end
		event.set_character_motion(9, "発動", 6)
		event.set_object_sequence_motion(0, "ラピスゲット", 4, -1.0, 1)
		wait.for_frame_count(2)
		event.play_sound_effect(special_sound_bank, 0)
		wait.for_frame_count(120)
		event.play_sound_effect(event_sound_bank, 1)
		inventory.show_obtained_message_for_item_id(366, 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.stop_sound_effect(event_sound_bank, 0)
	event.stop_sound_effect(special_sound_bank, 0)
	event.play_music(0)
	event.set_object_handle_visible(2, 1)
	event.set_object_handle_visible(3, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	object.hide_rapis_point()
	character.place_standing_and_reset_cloth(0.0, 4.0, -920.0, 0.0)
	event.set_camera_look_at(0.0, 34.0, -920.0)
	event.set_camera_position(0.0, 44.0, -800.0)
	event.reset_follow_camera(0)
	inventory.resolve_overflow(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.init_map = init_map
script[99] = script.init_map

--- Sets up the boss room on entry, starting the boss intro when the boss is alive, and places the player.
function script.default_event()
	local flag: s32 = 0
	event.initialize_event()
	init_map()
	flag = event.get_save_flag(632) or flag
	if flag == 0 then
		play_boss_intro()
		event.set_function_point_enabled("", "rapis", 0)
		event.load_dungeon_monster(612, 1)
		event.place_dungeon_monster(612, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.set_save_control_bits(1, if flag == 0 then 1 else 0)
	character.place_standing_and_reset_cloth(0.0, 0.0, 1100.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 1100.0)
	event.set_camera_position(0.0, 40.0, 1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_boss_intro

--- Asks whether to enter the dungeon once the boss is beaten, or refuses when the gem is not yet held.
function script.examine_dungeon_gate()
	local active_character: s32 = 0
	local flag: s32 = 0
	local answer: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	flag = event.get_save_flag(632) or flag
	if flag == 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "まだラピスを手に入れてないよ！")
		message.show_and_wait(0, -1, 5, 256, 208)
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(15)
		wait.for_frame_count(15)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d04/d04.stb", 1000)
	end
	event.finish_event()
end
script[200] = script.examine_dungeon_gate

--- Gives the lapis, records the floor result and plays the acquisition scene.
function script.pick_up_lapis()
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local dungeon_floor: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				resume_step = 1
				message.show_and_wait(0, 22, 5, 256, 208)
			else
				resume_step = 2
				message.show_and_wait(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.add_inventory_item(366, 1)
		event.fade_out_screen(10)
		resume_step = 3
		wait.for_frame_count(10)
		stage_id = event.get_dungeon_stage_id() or stage_id
		dungeon_floor = event.get_dungeon_floor() or dungeon_floor
		event.set_dungeon_floor_info(stage_id, dungeon_floor, 5, 2)
		resume_step = 4
		play_lapis_acquired()
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(10)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 23, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				resume_step = 4
				play_lapis_acquired()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.pick_up_lapis

--- Runs the defeat sequence when the party is defeated.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_party_defeated

--- Enables the rapis point and starts the victory music when the floor is cleared.
function script.floor_clear()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.clear_event_battle_monsters(-1)
	event.set_function_point_enabled("", "rapis", 1)
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	wait.background_load()
	event.load_music_pack(193)
	event.play_music(0)
	event.finish_event()
end

--- Loads and places the boss and starts the battle music.
function script.start_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.load_dungeon_monster(612, 1)
	event.place_dungeon_monster(612, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.set_dungeon_pause_flags(16384, 1)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.finish_event()
end
script[26030] = script.start_boss_battle

return script
