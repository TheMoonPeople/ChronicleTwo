--!strict
--- Event script for the Heim Rada map covering entries, exits and the dungeon choice.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local georama = require("@lib/event/georama")
local heim_rada = require("@lib/event/heim_rada")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Placeholder hook that the entry events call and that does nothing on this map.
local function empty_map_hook() end

--- Fades in with the character running in along a path from the first entrance.
local function run_in_entrance_a()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1356.86, 83.9, -1168.92)
	event.set_camera_sequence_look_at(-1484.75, 27.8, -1316.45)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1627.77, 0.0, -1432.14)
	event.set_object_sequence_rotation(0, 0.0, 1.12, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 60)
	event.add_object_sequence_path_point(0, -1627.77, 0.0, -1432.14)
	event.add_object_sequence_path_point(0, -1529.23, 0.0, -1370.02)
	event.add_object_sequence_path_point(0, -1477.71, 0.0, -1329.77)
	event.start_object_sequence_path(0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait.for_frame_count(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Fades in with the character running in from the second entrance and stopping.
local function run_in_entrance_b()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2123.53, 0.0, -172.9)
	event.set_object_sequence_rotation(0, 0.0, -1.54, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2113.85, 58.0, -172.0)
	event.set_camera_sequence_look_at(1961.18, 30.0, -219.86)
	event.set_object_sequence_position(0, 2084.3, 0.0, -181.26)
	event.set_object_sequence_rotation(0, 0.0, -1.87, 0.0)
	event.move_object_sequence(0, 1961.18, 0.0, -219.86, 40)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.delay_object_sequence_motion_track(0, 40)
	event.set_object_sequence_motion(0, "立ち")
	event.fade_in_screen(15)
	wait.for_frame_count(50)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Asks leave prompt 87 and returns 1 after running the character out along a path with a fade when confirmed, otherwise walks a few steps and returns 0.
local function confirm_leave_area_87()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		progress = 1
		exit_choice = message.ask_yes_no(5, 87)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(1741.43, 158.18, -323.48)
			event.set_camera_sequence_look_at(1987.85, 77.48, -185.67)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 70)
			event.add_object_sequence_path_point(0, 2073.86, 0.0, -146.5)
			event.add_object_sequence_path_point(0, 2172.98, -1.14, -140.36)
			event.add_object_sequence_path_point(0, 2239.86, -9.63, -132.92)
			event.add_object_sequence_path_point(0, 2337.56, -22.03, -101.25)
			event.start_object_sequence_path(0)
			progress = 2
			wait.for_frame_count(50)
			event.fade_out_screen(20)
			progress = 3
			wait.for_frame_count(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-1.57)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-1.57)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				progress = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.skip_frame_count(50)
			end
			if progress <= 2 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Asks leave prompt 79 and returns 1 after running the character out along a path with a fade when confirmed, otherwise walks a few steps and returns 0.
local function confirm_leave_area_79()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		progress = 1
		exit_choice = message.ask_yes_no(5, 79)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-1344.5, 29.04, -1202.39)
			event.set_camera_sequence_look_at(-1454.01, 30.0, -1310.84)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.delay_object_sequence_motion_track(0, 60)
			event.set_object_sequence_motion(0, "立ち")
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1491.32, 0.0, -1347.87)
			event.add_object_sequence_path_point(0, -1566.57, 0.0, -1398.85)
			event.add_object_sequence_path_point(0, -1646.11, 0.0, -1452.77)
			event.start_object_sequence_path(0)
			progress = 2
			wait.for_frame_count(40)
			event.fade_out_screen(20)
			progress = 3
			wait.for_frame_count(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(0.9)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(0.9)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				progress = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.skip_frame_count(40)
			end
			if progress <= 2 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

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
					run_in_entrance_a()
				elseif previous_map_number == 102 then
					character.place_standing_and_reset_cloth(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(15)
				else
					run_in_entrance_b()
				end
			end
		end
	end
	heim_rada.show_hint_with_georama_state(1)
end

--- Waits for the menu button press instead of the default handler.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

--- Plays the red time gate effect and jumps to the s39 map or the f04 map depending on the georama state.
function script.use_time_gate()
	cutscene.play_time_gate_travel(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
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
script[400] = menu.open_type_7

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
	if confirm_leave_area_87() ~= 0 then
		event.jump_to_map_2(-1, "s10")
		vm.wait(2)
	end
end
script[551] = script.exit_to_s10

--- Lets the player choose a dungeon floor and enters it.
function script.choose_dungeon_floor()
	local selected_floor: s32 = 0
	if confirm_leave_area_79() ~= 0 then
		event.set_dungeon_stage_id(4)
		event.open_event_menu(3, 4)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			run_in_entrance_a()
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
