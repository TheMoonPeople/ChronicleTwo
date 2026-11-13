--!strict
--- Event script for the Heim Rada map covering entries, exits and the dungeon choice.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local georama = require("@lib/event/georama")
local heim_rada = require("@lib/event/heim_rada")
local menu = require("@lib/event/menu")
local time_gate = require("@lib/event/german/time_gate")
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
	local previous_map_number: s32 = 0
	local old_map_type: s32 = 0
	local memory_card_load_state: s32 = 0
	event.initialize_event()
	empty_map_hook()
	memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
	if memory_card_load_state == 1 then
		event.set_character_position(0, -1349.6, 0.0, -1351.7)
		event.set_character_rotation(0, 0.0, 1.03, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		previous_map_number = event.get_previous_map() or previous_map_number
		old_map_type = event.get_map_type(previous_map_number) or old_map_type
		if old_map_type ~= -1 then
			if previous_map_number ~= 3 then
				if old_map_type == 7 or old_map_type == 8 then
					heim_rada.run_in_entrance_a()
				elseif previous_map_number == 102 then
					character.place_standing_and_reset_cloth(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(15)
				else
					heim_rada.run_in_entrance_b()
				end
			end
		end
	end
	heim_rada.show_hint_with_georama_state(1)
end

--- Waits for the menu button press instead of the default handler.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(64)
end

--- Plays the red time gate effect and jumps to the s39 map or the f04 map depending on the georama state.
function script.use_time_gate()
	time_gate.play_red_time_gate(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
	if (if georama.can_start_event_548() == 0 and georama.can_start_event_552() == 0 then georama.can_start_event_556() else 0) ~= 0 then
		event.skip_next_music_play()
	end
	if georama.can_start_event_560() ~= 0 then
		event.jump_to_map_2(-1, "s39")
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "f04")
	vm.wait(3)
end
script[300] = script.use_time_gate

--- Shows the hint matching the georama state after a change.
function script.edit_analyze_changed()
	heim_rada.show_hint_with_georama_state(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Places the player at the time gate and fades in.
function script.enter_from_time_gate()
	event.initialize_event()
	empty_map_hook()
	character.place_standing_and_reset_cloth(1680.0, 0.0, -420.0, vm.f32(1.57))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	vm.wait(1)
	heim_rada.show_hint_with_georama_state(1)
end
script[500] = script.enter_from_time_gate

--- Places the player at the dungeon entrance and fades in.
function script.enter_from_dungeon()
	event.initialize_event()
	character.place_standing_and_reset_cloth(vm.f32(1982.08), 0.0, vm.f32(-201.51), vm.f32(-1.58))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	vm.wait(1)
end
script[510] = script.enter_from_dungeon

--- Asks to leave and jumps to the s10 map when confirmed.
function script.exit_to_s10()
	if heim_rada.confirm_leave_area_87() ~= 0 then
		event.jump_to_map_2(-1, "s10")
		vm.wait(2)
	end
end
script[551] = script.exit_to_s10

--- Lets the player choose a dungeon floor and enters it.
function script.choose_dungeon_floor()
	local selected_floor: s32 = 0
	if heim_rada.confirm_leave_area_79() ~= 0 then
		event.set_dungeon_stage_id(4)
		event.open_event_menu(3, 4)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			heim_rada.run_in_entrance_a()
		else
			if selected_floor == 21 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(4, selected_floor, 1010)
		end
	end
end
script[552] = script.choose_dungeon_floor

return script
