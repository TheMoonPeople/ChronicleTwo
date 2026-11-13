--!strict
--- Girard house interior script that handles the hide and seek events, the chapter ending and villager dialogue.

local vm = require("@lib/vm")
local i04_girard_house = require("@lib/event/i04_girard_house")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local villager_dialogue = require("@lib/event/french/villager_dialogue")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Updates the hide and seek state and resets the follow camera when the house is entered.
function script.default_event()
	i04_girard_house.update_hide_and_seek_state()
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = i04_girard_house.play_mints_letter_scene

--- Gives the player item 357 once and hides the map part it sat on.
function script.pick_up_map_item()
	local save_flag: s32 = 0
	event.set_character_motion(0, "立ち")
	save_flag = event.get_save_flag(38) or save_flag
	if save_flag == 0 then
		event.set_save_flag(38, 1)
		event.add_inventory_item(357)
		inventory.announce_received(357, 1)
		i04_girard_house.set_map_part_visible(0)
		inventory.resolve_overflow_alt(1)
	end
end
script[400] = script.pick_up_map_item

--- Plays the scene of Mints and Eina crying and enters the dungeon.
function script.cutscene_crying_scene_then_enter_dungeon()
	i04_girard_house.play_mints_and_eina_crying_scene()
	event.skip_next_loading_screen()
	event.go_to_dungeon(0, 3, 500)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(2)
end
script[500] = script.cutscene_crying_scene_then_enter_dungeon

--- Plays the potato pie scene and jumps to the g01i07 map.
function script.cutscene_potato_pie_then_go_to_g01i07()
	i04_girard_house.play_potato_pie_scene()
	event.jump_to_map_3(-1, "g01i07", 502)
	vm.wait(2)
end
script[501] = script.cutscene_potato_pie_then_go_to_g01i07

--- Plays the ending movie and the chapter 8 start file message and sets up the party for the next chapter.
function script.cutscene_chapter_ending()
	local block: s32 = 0
	i04_girard_house.play_mints_letter_scene()
	event.set_pause_enabled(0)
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_background_color(0, 0, 0)
	event.fade_in_screen(0)
	event.play_movie(5, "movie/end1.mp4")
	event.fade_out_screen(0)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	wait.frames(2)
	block = event.load_event_image_4(5, "textures/event/e700/e736/e73601_1.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e73601", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 224)
	event.set_event_sprite_draw_pass(1, 1)
	event.fade_in_screen(60)
	wait.frames(90)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_event_sprite_draw_pass(1, 0)
	event.fade_in_screen(0)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Sauvegarder - 1er fich. Chap. 8")
	message.show(0, -1, 8, 0, 0)
	event.fade_out_screen(0)
	wait.frames(2)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_save_flag(799, 1)
	event.set_save_data_value(0, 10)
	event.set_save_flag(736, 1)
	event.set_save_flag(800, 0)
	event.set_save_control_bits(1, 0)
	event.set_save_control_bits(8, 0)
	event.set_playable_character(0)
	event.return_monica_items_to_inventory()
	event.set_party_member(3, 0)
	event.set_character_change_enabled(3, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_party_member(1, 0)
	event.set_character_change_enabled(1, 0)
	event.set_character_change_unmasked(1, 0)
	event.set_save_data_value(3, 1)
	event.set_time_of_day(6.0)
	event.open_event_menu(7)
	vm.wait(8)
	event.set_sound_reverb_enabled(1)
	event.set_scene_exit_flag(1)
end
script[530] = script.cutscene_chapter_ending

--- Event 600, which map data, a script or the engine runs by number.
script[600] = i04_girard_house.play_potato_pie_scene

--- Event 610, which map data, a script or the engine runs by number.
script[610] = i04_girard_house.play_mints_and_eina_crying_scene

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

--- Plays the scene of Mints and Eina crying and enters the dungeon.
function script.cutscene_crying_scene_after_stopping_music()
	event.stop_music(0)
	i04_girard_house.play_mints_and_eina_crying_scene()
	event.skip_next_loading_screen()
	event.go_to_dungeon(0, -1, 500)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(2)
end
script[11020] = script.cutscene_crying_scene_after_stopping_music

return script
