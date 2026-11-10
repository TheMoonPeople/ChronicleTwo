--!strict
-- map/i/i04/h01/i04h01_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_140b07c0 = require("@lib/event/helper_140b07c0")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_601a9055 = require("@lib/event/helper_601a9055")
local helper_65769ec0 = require("@lib/event/helper_65769ec0")
local helper_6af155ab = require("@lib/event/helper_6af155ab")
local helper_6c0ef236 = require("@lib/event/helper_6c0ef236")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_acffd9e4 = require("@lib/event/helper_acffd9e4")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_acffd9e4()
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_6af155ab

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local flag: s32 = 0
	event.set_character_motion(0, "立ち")
	flag = event.get_save_flag(38) or flag
	if flag == 0 then
		event.set_save_flag(38, 1)
		event.add_inventory_item(357)
		helper_f38eabca(357, 1)
		helper_6c0ef236(0)
		helper_a87eb945(1)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_140b07c0()
	event.skip_next_loading_screen()
	event.go_to_dungeon(0, 3, 500)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(2)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_65769ec0()
	event.jump_to_map_3(-1, "g01i07", 502)
	vm.wait(2)
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	local block: s32 = 0
	helper_6af155ab()
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
	wait_frames(2)
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
	wait_frames(90)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	wait_frames(30)
	event.set_event_sprite_draw_pass(1, 0)
	event.fade_in_screen(0)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Guardar - Cap[UNI00ed]tulo 8 Archivo de inicio")
	show_message(0, -1, 8, 0, 0)
	event.fade_out_screen(0)
	wait_frames(2)
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

--- Event 600, which map data, a script or the engine runs by number.
script.event_600 = helper_65769ec0

--- Event 610, which map data, a script or the engine runs by number.
script.event_610 = helper_140b07c0

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_601a9055

--- Event 11020, which map data, a script or the engine runs by number.
function script.event_11020()
	event.stop_music(0)
	helper_140b07c0()
	event.skip_next_loading_screen()
	event.go_to_dungeon(0, -1, 500)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(2)
end

return script
