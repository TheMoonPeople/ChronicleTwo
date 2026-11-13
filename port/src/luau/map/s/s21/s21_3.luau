--!strict
--- A small map holding an item pickup and the exit to the dungeon.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local garden = require("@lib/event/garden")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Loads the map sounds and shows the item part unless already obtained.
local function initialize_map()
	local owned_count: s32 = 0
	local obtained_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7689)
	owned_count = event.get_owned_item_count(374) or owned_count
	obtained_flag = event.get_save_flag(708) or obtained_flag
	if owned_count >= 1 or obtained_flag == 1 then
		event.set_function_point_enabled("", "item", 0)
	else
		event.attach_object_handle_to_map_part_2(0, "p06s21")
		event.set_object_handle_visible(0, 1)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_save_control_bits(1, 1)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script loads.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- Starts the map at one of two positions depending on whether the intro flag is set.
function script.default_event()
	local intro_flag: s32 = 0
	initialize_map()
	intro_flag = event.get_save_flag(704) or intro_flag
	if intro_flag == 0 then
		garden.play_andrea_sun_scene()
		character.place_standing_and_reset_cloth(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 30.8, -200.0)
		event.set_camera_position(0.0, 40.8, -80.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
	else
		character.place_standing_and_reset_cloth(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 38.4, 685.0)
		event.set_camera_position(0.0, 48.4, 565.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default.
function script.key_open() end

--- Leaves for the dungeon after confirming.
function script.leave_to_dungeon()
	if menu.confirm_leave_unless_blocked() ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d06/d06.stb", 1000)
	end
end
script[200] = script.leave_to_dungeon

--- Gives the player the item, or tells a non-lead character to ignore it.
function script.pick_up_item()
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 22, 5, 256, 208)
		else
			message.show_and_wait(0, 23, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	stage_id = event.get_dungeon_stage_id() or stage_id
	current_floor = event.get_dungeon_floor() or current_floor
	next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
	event.set_dungeon_floor(next_floor)
	event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
	event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
	wait.frames(6)
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	wait.frames(16)
	event.attach_object_handle_to_map_part_2(1, "p06s21")
	event.set_object_handle_visible(1, 0)
	event.add_inventory_item(374)
	inventory.show_obtained_message_for_item_id(374, 1)
	event.set_dungeon_floor_info(6, 11, 5, 2)
	event.set_function_point_enabled("", "item", 0)
	inventory.resolve_overflow_alt(1)
end
script[500] = script.pick_up_item

--- Runs the silent defeat sequence when the party is defeated here.
function script.on_defeat()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_defeat

--- Event 17040, which map data, a script or the engine runs by number.
script[17040] = garden.play_andrea_sun_scene

return script
