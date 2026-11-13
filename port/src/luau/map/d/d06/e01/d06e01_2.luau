--!strict
--- Event script for the Moon Flower Palace griffon boss room, covering entry placement, the boss intro and outro scenes, the dungeon entrance, the wall images and the defeat dialogue.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local moon_flower_palace_griffon_event = require("@lib/event/moon_flower_palace_griffon_event")
local wait = require("@lib/event/wait")

--- Does nothing; it is the empty hook the default event calls on entry.
local function run_map_entry_hook() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded; nothing needs preparing.
function script.setup() end

script.run_map_entry_hook = run_map_entry_hook
script[99] = script.run_map_entry_hook

--- Places the player and camera according to how the room was entered, playing the palace entry scene on the first visit.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local palace_entry_flag: s32 = 0
	local previous_map_number: s32 = 0
	local previous_map_type: s32 = 0
	run_map_entry_hook()
	memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
	if memory_card_load_state == 1 then
		character.place_standing_and_reset_cloth(20.0, 280.0, -600.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	else
		palace_entry_flag = event.get_save_flag(702) or palace_entry_flag
		if palace_entry_flag == 0 then
			moon_flower_palace_griffon_event.play_palace_entry_scene()
			character.place_standing_and_reset_cloth(vm.f32(649.7), 0.0, vm.f32(-122.2), vm.f32(1.71))
			event.reset_follow_camera(1, 3.14, 0.0)
			event.fade_in_screen(30)
			return
		end
		previous_map_number = event.get_previous_map() or previous_map_number
		previous_map_type = event.get_map_type(previous_map_number) or previous_map_type
		if previous_map_type ~= -1 then
			if previous_map_number == 128 or previous_map_type == 7 or previous_map_type == 8 then
				character.place_standing_and_reset_cloth(0.0, 280.0, -650.0, 0.0)
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			else
				character.place_standing_and_reset_cloth(0.0, 0.0, 600.0, vm.f32(3.14))
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			end
		end
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button event with nothing.
function script.key_open() end

--- Loads and plays the room music, shows the arena map part and places the griffon monster.
function script.setup_griffon_arena()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(36)
	event.play_music(0)
	event.attach_object_handle_to_map_part_2(0, "p05_d06e01-0")
	event.set_object_handle_visible(0, 1)
	event.fade_in_screen(30)
	event.load_dungeon_monster(515, 1)
	event.place_dungeon_monster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	event.finish_event()
end
script[151] = script.setup_griffon_arena

--- Fades in a title card with a message about the griffon's account and fades it out again.
function script.show_griffon_account_title_card()
	event.initialize_event()
	vm.wait(1)
	event.set_dungeon_pause_flags(15, 1)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 0.0, 30)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 0.0, 0.0, 0.0, 128.0)
	event.set_message_window_mode(0, 7)
	event.fade_in_screen(15)
	event.open_message_window_2(0, "e610『グリフォンの言い分』")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_object_sequence_color(0, 0.0, 0.0, 0.0, 0.0, 30)
	wait.frames(30)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_dungeon_pause_flags(15, 0)
	event.finish_event()
end
script[152] = script.show_griffon_account_title_card

--- Shows a short victory message.
function script.show_victory_message()
	event.initialize_event()
	vm.wait(1)
	event.set_message_window_mode(0, 7)
	event.fade_in_screen(15)
	event.open_message_window_2(0, "勝利")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.finish_event()
end
script[153] = script.show_victory_message

--- Adds a fixed list of inventory items to the player.
function script.give_fixed_item_set()
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(19, 1)
	event.add_inventory_item(8, 1)
	event.add_inventory_item(30, 1)
	event.add_inventory_item(33, 1)
	event.add_inventory_item(38, 1)
	event.add_inventory_item(77, 1)
	event.add_inventory_item(80, 1)
	event.add_inventory_item(59, 1)
	event.add_inventory_item(87, 1)
	event.add_inventory_item(55, 1)
	event.add_inventory_item(72, 1)
	event.add_inventory_item(84, 1)
	event.add_inventory_item(63, 1)
	event.add_inventory_item(107, 1)
	event.add_inventory_item(96, 1)
	event.add_inventory_item(99, 1)
	event.add_inventory_item(105, 1)
	event.finish_event()
end
script[154] = script.give_fixed_item_set

--- Waits until the button is pressed.
function script.wait_for_button_press()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[155] = script.wait_for_button_press

--- Moves the camera position and look-at to the origin and waits until the button is pressed.
function script.reset_camera_and_wait_for_button()
	event.set_camera_position(0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 0.0, 0.0)
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[160] = script.reset_camera_and_wait_for_button

--- Offers to leave the palace for map g05 in main loop mode 1, otherwise offers to enter Georama editing.
function script.leave_palace_or_enter_georama()
	local main_loop_mode: s32 = 0
	main_loop_mode = event.get_main_loop_mode() or main_loop_mode
	if main_loop_mode == 1 then
		if dungeon.confirm_exit_variant() ~= 0 then
			event.jump_to_map_2(-1, "g05")
			vm.wait(2)
		end
	elseif moon_flower_palace_griffon_event.confirm_georama_entry() ~= 0 then
		event.set_save_control_bits(1, 0)
		event.go_to_georama_edit(177, 100)
	end
end
script[200] = script.leave_palace_or_enter_georama

--- Confirms the dungeon entry, opens the floor menu and starts the chosen dungeon floor.
function script.enter_dungeon_from_palace()
	local selected_floor: s32 = 0
	if moon_flower_palace_griffon_event.confirm_dungeon_entry() ~= 0 then
		event.set_dungeon_stage_id(5)
		event.open_event_menu(3, 5)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			event.fade_in_screen(30)
			return
		else
			if selected_floor == 26 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(5, selected_floor, 1010)
		end
	end
end
script[210] = script.enter_dungeon_from_palace

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Shows the first wall image.
function script.examine_wall_image_0()
	moon_flower_palace_griffon_event.show_wall_image(0)
end
script[401] = script.examine_wall_image_0

--- Shows the second wall image.
function script.examine_wall_image_1()
	moon_flower_palace_griffon_event.show_wall_image(1)
end
script[402] = script.examine_wall_image_1

--- Shows the third wall image.
function script.examine_wall_image_2()
	moon_flower_palace_griffon_event.show_wall_image(2)
end
script[403] = script.examine_wall_image_2

--- Shows the fourth wall image.
function script.examine_wall_image_3()
	moon_flower_palace_griffon_event.show_wall_image(3)
end
script[404] = script.examine_wall_image_3

--- Shows the fifth wall image.
function script.examine_wall_image_4()
	moon_flower_palace_griffon_event.show_wall_image(4)
end
script[405] = script.examine_wall_image_4

--- Shows the sixth wall image.
function script.examine_wall_image_5()
	moon_flower_palace_griffon_event.show_wall_image(5)
end
script[406] = script.examine_wall_image_5

--- Shows the seventh wall image.
function script.examine_wall_image_6()
	moon_flower_palace_griffon_event.show_wall_image(6)
end
script[407] = script.examine_wall_image_6

--- Shows the eighth wall image.
function script.examine_wall_image_7()
	moon_flower_palace_griffon_event.show_wall_image(7)
end
script[408] = script.examine_wall_image_7

--- Plays the sun title scene, disables the exit and item points and places the player at the palace entrance.
function script.cutscene_sun_telop_then_enter_palace()
	moon_flower_palace_griffon_event.play_sun_telop_scene()
	event.set_function_point_enabled("", "exit", 0)
	event.set_function_point_enabled("", "in_dng", 0)
	moon_flower_palace_griffon_event.disable_item_function_points()
	event.set_save_control_bits(1, 1)
	vm.wait(2)
	event.attach_object_handle_to_map_part_2(0, "p05_d06e01-0")
	event.set_object_handle_visible(0, 1)
	event.load_dungeon_monster(515, 1)
	event.place_dungeon_monster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	character.place_standing_and_reset_cloth(0.0, 0.0, 600.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 600.0)
	event.set_camera_position(0.0, 40.0, 720.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(20)
	event.finish_event()
end
script[500] = script.cutscene_sun_telop_then_enter_palace

--- Plays the flower shatter scene and restores the player and camera to where they were.
function script.cutscene_flower_shatter()
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local character_rotation_x: f32 = 0
	local character_rotation_y: f32 = 0
	local character_rotation_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(10)
		resume_point = 1
		wait.frames(10)
		event.stop_port_sound_effects(5)
		event.set_dungeon_pause_flags(1041, 1)
		event.clear_all_dungeon_effects()
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local out1, out2, out3 = event.get_character_rotation(0)
			character_rotation_x = out1 or character_rotation_x
			character_rotation_y = out2 or character_rotation_y
			character_rotation_z = out3 or character_rotation_z
		end
		do
			local out1, out2, out3 = event.get_camera_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			look_at_x = out1 or look_at_x
			look_at_y = out2 or look_at_y
			look_at_z = out3 or look_at_z
		end
		resume_point = 2
		moon_flower_palace_griffon_event.play_flower_shatter_scene()
		event.set_character_position(0, character_x, character_y, character_z)
		event.set_character_rotation(0, character_rotation_x, character_rotation_y, character_rotation_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.reset_follow_camera(0)
		event.set_dungeon_pause_flags(1041, 0)
		event.fade_in_screen(10)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				resume_point = 2
				moon_flower_palace_griffon_event.play_flower_shatter_scene()
				return vm.continue_with(function()
					event.set_character_position(0, character_x, character_y, character_z)
					event.set_character_rotation(0, character_rotation_x, character_rotation_y, character_rotation_z)
					event.set_camera_position(camera_x, camera_y, camera_z)
					event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
					event.reset_follow_camera(0)
					event.set_dungeon_pause_flags(1041, 0)
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
script[502] = script.cutscene_flower_shatter

--- Plays the sun ray griffon scene and loads the next map script.
function script.cutscene_sun_ray_griffon_then_load_s31()
	local active_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(10)
		resume_point = 1
		wait.frames(10)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.clear_event_battle_monsters(-1)
		resume_point = 2
		moon_flower_palace_griffon_event.play_sun_ray_griffon_scene()
		event.set_save_control_bits(8, 1)
		event.load_dungeon_map("s31")
		event.load_event_script("s31/s31.stb", 510)
		resume_point = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				resume_point = 2
				moon_flower_palace_griffon_event.play_sun_ray_griffon_scene()
				return vm.continue_with(function()
					event.set_save_control_bits(8, 1)
					event.load_dungeon_map("s31")
					event.load_event_script("s31/s31.stb", 510)
					resume_point = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[504] = script.cutscene_sun_ray_griffon_then_load_s31

--- Plays the awakening cutscene and loads the next map script.
function script.cutscene_awakening_then_load_s35()
	moon_flower_palace_griffon_event.play_awakening_cutscene()
	event.load_dungeon_map("s35")
	event.load_event_script("s35/s35.stb", 502)
	vm.wait(2)
end
script[506] = script.cutscene_awakening_then_load_s35

--- Plays the griffon appearance scene and enters Georama editing.
function script.cutscene_griffon_appearance_then_georama()
	moon_flower_palace_griffon_event.play_griffon_appearance_scene()
	event.set_save_control_bits(1, 0)
	event.go_to_georama_edit(187, 100)
end
script[508] = script.cutscene_griffon_appearance_then_georama

--- Picks the defeat dialogue by progress flags and a random roll.
function script.on_defeat_dialogue()
	local progress_flag: s32 = 0
	local second_progress_flag: s32 = 0
	local random_roll: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		progress_flag = event.get_save_flag(608) or progress_flag
		second_progress_flag = event.get_save_flag(612) or second_progress_flag
		if progress_flag ~= 0 and second_progress_flag == 0 then
			random_roll = event.get_random_number_int(100) or random_roll
			if random_roll < 50 then
				resume_point = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8550080)
			else
				resume_point = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8550090)
			end
			return
		end
		resume_point = 3
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8550090)
			end
			return 0
		end
		if resume_point <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_defeat_dialogue

--- Event 16080, which map data, a script or the engine runs by number.
script[16080] = moon_flower_palace_griffon_event.play_sun_telop_scene

--- Event 16100, which map data, a script or the engine runs by number.
script[16100] = moon_flower_palace_griffon_event.play_flower_shatter_scene

--- Plays the sun ray griffon scene and loads the next map script without fading out or switching the main character first.
function script.cutscene_sun_ray_griffon_then_load_s31_without_fade()
	moon_flower_palace_griffon_event.play_sun_ray_griffon_scene()
	event.set_save_control_bits(8, 1)
	event.load_dungeon_map("s31")
	event.load_event_script("s31/s31.stb", 510)
	vm.wait(2)
end
script[16120] = script.cutscene_sun_ray_griffon_then_load_s31_without_fade

--- Event 17020, which map data, a script or the engine runs by number.
script[17020] = moon_flower_palace_griffon_event.play_palace_entry_scene

return script
