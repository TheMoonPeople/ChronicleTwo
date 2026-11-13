--!strict
--- Event script for the Veniccio map covering entries, exits to dungeons and scene triggers.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local georama = require("@lib/event/georama")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local time_gate = require("@lib/event/german/time_gate")
local veniccio = require("@lib/event/veniccio")

--- Walks the player ahead and shows a hint about searching the cave first.
local function walk_ahead_and_hint_at_cave()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local frame: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	target_x = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + x)
	target_y = y
	target_z = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + z)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	event.set_object_sequence_motion(0, "歩き")
	frame = 0
	while frame < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		y = vm.f32(y + 30.0)
		event.set_camera_look_at(x, y, z)
		frame = frame + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Was war das f[UNI00fc]r ein Weinen eben?\nSehen wir zuerst in der\nH[UNI00f6]hle nach, ja?")
	message.show(0, -1, 5, 256, 208)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = veniccio.update_map_state

--- Plays the entry sequence matching the map the player came from.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local old_map_type: s32 = 0
	local entry_handled: s32 = 0
	local previous_submap_number: s32 = 0
	local old_sub_map_type: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local previous_interior_map_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		veniccio.update_map_state()
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			character.place_standing_and_reset_cloth(vm.f32(1832.4), vm.f32(-5.2), vm.f32(-406.6), vm.f32(-1.16))
			event.reset_follow_camera(1, 0.0, 10.0)
		else
			previous_map_number = event.get_previous_map() or previous_map_number
			old_map_type = event.get_map_type(previous_map_number) or old_map_type
			print("old_map = ", previous_map_number, "\n")
			print("old_map_type = ", old_map_type, "\n")
			if old_map_type ~= -1 then
				if old_map_type == 7 or old_map_type == 8 or previous_map_number == 84 then
					resume_step = 1
					veniccio.run_in_entrance_a()
				else
					entry_handled = 0
					if previous_map_number == 82 then
						character.place_standing_and_reset_cloth(-140.0, 165.0, 1865.0, vm.f32(2.28))
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(30)
						entry_handled = 1
					end
					if previous_map_number == 75 then
						resume_step = 2
						veniccio.run_in_entrance_b()
						entry_handled = 1
					end
					previous_submap_number = event.get_previous_submap() or previous_submap_number
					old_sub_map_type = event.get_map_type(previous_submap_number) or old_sub_map_type
					if entry_handled == 0 and not (previous_map_number == 2 and old_sub_map_type == 2) then
						flag = event.get_save_flag(402) or flag
						flag_2 = event.get_save_flag(360) or flag_2
						if flag == 0 and flag_2 == 1 then
							resume_step = 3
							veniccio.play_scene_e402()
						else
							resume_step = 4
							veniccio.run_in_entrance_c()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				previous_interior_map_number = event.get_previous_interior_map() or previous_interior_map_number
				if 0 <= previous_interior_map_number then
				else
					resume_step = 5
					veniccio.run_in_entrance_c()
				end
			end
		end
		resume_step = 6
		veniccio.show_default_hint_message(1)
		return
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step <= 1 then
				entry_handled = 0
				cutscene.ignore_coordinates(-140.0, 165.0, 1865.0, vm.f32(2.28))
				entry_handled = 1
				veniccio.run_unused_look_at_loop()
			end
			if resume_step <= 2 then
				entry_handled = 1
				resume_step = 3
				veniccio.play_scene_e402()
				return vm.continue_with(function()
					resume_step = 6
					veniccio.show_default_hint_message(1)
					return
				end)
			end
			if resume_step <= 3 then
				veniccio.run_unused_look_at_loop_short()
			end
			if resume_step <= 4 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				veniccio.run_unused_look_at_loop_short()
			end
			if resume_step <= 5 then
				message.clear_window_option(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = veniccio.run_in_entrance_c

--- Shows the blocked path hint or lets the player choose a dungeon floor and enter it.
function script.choose_dungeon_floor()
	local flag: s32 = 0
	local dungeon_stage: s32 = 0
	local selected_floor: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local floor_info_value: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.get_save_flag(404) or flag
	if flag == 0 then
		walk_ahead_and_hint_at_cave()
	elseif veniccio.confirm_leave_area_64() ~= 0 then
		event.set_dungeon_stage_id(3)
		event.open_event_menu(3, 3)
		vm.wait(3)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			dungeon_stage = out2 or dungeon_stage
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			veniccio.run_in_entrance_a()
			return
		end
		if selected_floor == 20 then
			flag_2 = event.get_save_flag(438) or flag_2
			flag_3 = event.get_save_flag(444) or flag_3
			if flag_2 == 1 and flag_3 == 0 then
				event.go_to_dungeon(3, selected_floor, 1010)
			else
				dungeon_stage = 3
				selected_floor = 20
				floor_info_value = event.get_dungeon_floor_info(dungeon_stage, selected_floor, 7) or floor_info_value
				floor_info_value = vm.i32(floor_info_value + 1)
				event.set_dungeon_floor_info(dungeon_stage, selected_floor, 7, floor_info_value)
				event.jump_to_map_3(-1, "d04b01", 100)
			end
		else
			flag_4 = event.get_save_flag(406) or flag_4
			flag_5 = event.get_save_flag(424) or flag_5
			if selected_floor == 2 and flag_4 == 0 or selected_floor == 17 and flag_5 == 0 or selected_floor == 19 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(3, selected_floor, 1010)
		end
	end
end
script[201] = script.choose_dungeon_floor

--- Asks to leave and jumps to the s27 map when confirmed.
function script.exit_to_s27()
	local flag: s32 = 0
	if veniccio.confirm_leave_area_75() ~= 0 then
		flag = event.get_save_flag(404) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "s27")
	end
end
script[202] = script.exit_to_s27

--- Asks to leave and jumps to the s09 map when confirmed.
function script.exit_to_s09()
	if veniccio.confirm_leave_area_83() ~= 0 then
		event.jump_to_map_2(-1, "s09")
	end
end
script[203] = script.exit_to_s09

--- Plays the red time gate effect and jumps to the f03 map.
function script.use_time_gate()
	time_gate.play_red_time_gate(vm.f32(-136.7), 165.0, vm.f32(1866.8), 0.0)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end
script[300] = script.use_time_gate

--- Shows the default hint message after a georama change.
function script.edit_analyze_changed()
	veniccio.show_default_hint_message(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Updates the map state and plays scene e404.
function script.play_scene_e404()
	veniccio.update_map_state()
	veniccio.play_scene_e404()
end
script[500] = script.play_scene_e404

--- Places the player at the dungeon exit and fades in.
function script.enter_from_dungeon()
	veniccio.update_map_state()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, 1425.7, 0.0, 1034.8)
	event.set_character_rotation(0, 0.0, -2.37, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end
script[510] = script.enter_from_dungeon

--- Places the player at the time gate and explains the georama requirement when it is unmet.
function script.enter_from_time_gate()
	local is_condition_met: s32 = 0
	veniccio.update_map_state()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -140.0, 165.0, 1800.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	is_condition_met = georama.is_analysis_flag_305_set()
	if is_condition_met == 0 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Erf[UNI00fc]lle die Georama-Bedingungen\n   und nimm das Zentral-Labor wieder\n   in Betrieb, um fortzufahren."
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end
	veniccio.show_default_hint_message(1)
end
script[520] = script.enter_from_time_gate

--- Updates the map state and plays scene e402.
function script.play_scene_e402()
	veniccio.update_map_state()
	veniccio.play_scene_e402()
end
script[14020] = script.play_scene_e402

return script
