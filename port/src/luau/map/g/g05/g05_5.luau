--!strict
--- Event script for the Moon Flower Palace map covering entries, exits and georama hint scenes.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local moon_flower_palace_georama = require("@lib/event/moon_flower_palace_georama")
local wait = require("@lib/event/wait")

--- Placeholder hook that the entry events call and that does nothing on this map.
local function empty_map_hook() end

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
	wait.until_button_pressed(64)
end

--- Asks to leave and jumps to the s34 map when confirmed.
function script.exit_to_s34()
	if moon_flower_palace_georama.confirm_leave_scene(155) ~= 0 then
		event.jump_to_map_2(-1, "s34")
	end
end
script[200] = script.exit_to_s34

--- Asks to leave and enters the d06e01 map when confirmed.
function script.exit_to_dungeon_d06e01()
	local flag: s32 = 0
	if moon_flower_palace_georama.confirm_leave_scene(109) ~= 0 then
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
		wait.frames(30)
		event.set_save_flag(744, 1)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 570)
		vm.wait(2)
	end
	if moon_flower_palace_georama.is_hint_pending_744() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_save_flag(744, 1)
		event.jump_to_map_3(-1, "s44", 550)
		vm.wait(4)
	end
	if moon_flower_palace_georama.is_hint_pending_748() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 560)
		vm.wait(6)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Plays scene e700 and places the player in the palace.
function script.play_scene_e700()
	moon_flower_palace_georama.play_scene_e700()
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
	wait.frames(30)
	event.add_inventory_item(198, 1)
	event.add_inventory_item(199, 1)
	inventory.announce_received(198, 1)
	inventory.announce_received(199, 1)
	inventory.resolve_overflow_alt(1)
end
script[560] = script.return_from_hint_scene_with_reward

return script
