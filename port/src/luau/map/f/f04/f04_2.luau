--!strict
--- Event script for the f04 Gundorada field area, handling its elevators, jump gates and georama analysis event setup.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local georama = require("@lib/event/georama")
local gundorada = require("@lib/event/gundorada")
local message = require("@lib/event/message")
local time_gate = require("@lib/event/french/time_gate")
local wait = require("@lib/event/wait")
local workshop_villagers = require("@lib/event/french/workshop_villagers")

--- Hides the analysis map part when its flag is set and refreshes the analysis character visibility.
local function hide_analysis_part_and_update_characters()
	if georama.is_analysis_flag_410_set() ~= 0 then
		event.attach_object_handle_to_map_part_2(0, "p10_f0401")
		event.set_object_handle_visible(0, 0)
	end
	gundorada.update_analysis_character_visibility()
end

--- Asks which floor to ride to and returns the chosen floor or -1 when cancelled.
local function ask_elevator_floor()
	local current_floor: s32 = 0
	local selected_floor: any = 0
	local at: number = 0
	return vm.guard(function()
		current_floor = event.get_save_counter(14) or current_floor
		event.set_message_window_mode(1, 4)
		event.open_message_window_2(1, "Il y a des boutons d'ascenseur ici.")
		message.open(1, -1, 5, 0, 0)
		event.set_message_window_mode(0, 4)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.set_message_window_option(0, 1, 1)
		event.set_message_window_option(0, 5, current_floor, 2)
		event.open_message_window_2(0, "1er [UNI00e9]tage\n2e [UNI00e9]tage\n3e [UNI00e9]tage")
		at = 1
		selected_floor = message.ask_choice(0, -1, 8, 0, 0, 3, current_floor)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 1, 0)
		event.set_message_window_option(0, 5, current_floor, -1)
		message.close(1)
		if selected_floor < 0 or selected_floor == current_floor then
			return -1
		else
			event.set_save_counter(14, selected_floor)
			return selected_floor
		end
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				selected_floor = received[1] :: number
			end
			message.close_skipping(1)
			return -1
		end
		return nil
	end)
end

--- Offers the jump gate destinations, plays the warp effect and moves the player to the chosen one.
local function use_jump_gate(current_gate: s32)
	local has_bridge_destination: s32 = 0
	local destination_count: s32 = 0
	local choice: any = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local sound_id: s32 = 0
	has_bridge_destination = georama.is_analysis_flag_410_set()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 4)
	event.set_message_selection_top_line(0, 1)
	event.set_message_window_option(0, 0, 1)
	event.set_message_window_option(0, 1, 1)
	if has_bridge_destination ~= 0 then
		event.open_message_window_2(
			0,
			"Destination du t[UNI00e9]l[UNI00e9]porteur ?\nT[UNI00e9]l[UNI00e9]porteur - Nord\nT[UNI00e9]l[UNI00e9]porteur - Est\nT[UNI00e9]l[UNI00e9]porteur - Ouest\nDevant la Porte temporelle\nPaznos, sur le pont"
		)
		destination_count = 5
	else
		event.open_message_window_2(
			0,
			"Destination du t[UNI00e9]l[UNI00e9]porteur ?\nT[UNI00e9]l[UNI00e9]porteur - Nord\nT[UNI00e9]l[UNI00e9]porteur - Est\nT[UNI00e9]l[UNI00e9]porteur - Ouest\nDevant la Porte temporelle"
		)
		destination_count = 4
	end
	choice = message.ask_choice(0, -1, 8, 0, 0, destination_count, vm.i32(current_gate + 1))
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 1, 0)
	if choice == -1 then
		return
	end
	if vm.wrap(choice - 1) == current_gate then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("サンワープ２")
	event.create_effect_work_buffer(5)
	event.create_effect("サンワープ２")
	do
		local out1, out2, out3 = event.get_character_position(0)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_effect_first_vector(position_x, position_y, position_z)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 120)
	wait.frames(15)
	event.set_character_visible(0, 0, 1, 0.05)
	event.set_character_visible(1, 0, 1, 0.05)
	event.set_character_visible(2, 0, 1, 0.05)
	event.set_character_visible(3, 0, 1, 0.05)
	wait.frames(30)
	event.fade_out_screen(15)
	wait.frames(15)
	event.clear_effect_manager()
	event.set_character_visible(0, 1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_visible(3, 1)
	if vm.wrap(choice - 1) == 1 then
		character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
	end
	if vm.wrap(choice - 1) == 2 then
		character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
	end
	if vm.wrap(choice - 1) == 3 then
		character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
	end
	if vm.wrap(choice - 1) == 0 then
		character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
	end
	if vm.wrap(choice - 1) == 4 then
		event.jump_to_map_2(-1, "s30")
		vm.wait(5)
		return
	end
	event.reset_follow_camera(1, 3.1415927)
	event.fade_in_screen(15)
end

--- Asks to move to Paznos Bridge and, when accepted, plays the warp effect and jumps to map s30.
local function ask_move_to_paznos_bridge()
	local choice: any = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 5)
	event.open_message_window_2(0, "Aller [UNI00e0] Paznos (pont) ?")
	choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
	if choice ~= 0 then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("サンワープ２")
	event.create_effect_work_buffer(5)
	event.create_effect("サンワープ２")
	do
		local out1, out2, out3 = event.get_character_position(0)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_effect_first_vector(position_x, position_y, position_z)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 120)
	wait.frames(15)
	event.set_character_visible(0, 0, 1, 0.05)
	event.set_character_visible(1, 0, 1, 0.05)
	event.set_character_visible(2, 0, 1, 0.05)
	event.set_character_visible(3, 0, 1, 0.05)
	wait.frames(30)
	event.fade_out_screen(15)
	wait.frames(15)
	event.clear_effect_manager()
	event.set_character_visible(0, 1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_visible(3, 1)
	event.jump_to_map_2(-1, "s30")
	vm.wait(5)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.hide_analysis_part_and_update_characters = hide_analysis_part_and_update_characters
script[99] = script.hide_analysis_part_and_update_characters

--- Runs the pending Gundorada scenes on entry and places the player according to the map they came from.
function script.default_event()
	local previous_map_number: s32 = 0
	local return_gate_index: s32 = 0
	local at: number = 0
	return vm.guard(function()
		previous_map_number = event.get_previous_map() or previous_map_number
		event.fade_in_screen(15)
		if previous_map_number == 3 then
			event.set_save_counter(14, 0)
		end
		hide_analysis_part_and_update_characters()
		gundorada.align_lift_parts_to_floor()
		if georama.can_start_event_548() ~= 0 then
			at = 1
			gundorada.play_event_548_scene()
		end
		if georama.can_start_event_552() ~= 0 then
			at = 2
			gundorada.play_event_552_scene()
		end
		if georama.can_start_event_556() ~= 0 then
			at = 3
			gundorada.play_event_556_scene()
		end
		if previous_map_number == 3 then
			character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, 0.0)
		end
		if previous_map_number == 105 then
			return_gate_index = event.get_save_counter(18) or return_gate_index
			event.set_save_counter(14, 0)
			gundorada.align_lift_parts_to_floor()
			if return_gate_index == 1 then
				character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			end
			if return_gate_index == 2 then
				character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			end
			if return_gate_index == 3 then
				character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			end
			if return_gate_index == 0 then
				character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
			end
		end
		if previous_map_number == 107 then
			event.set_save_counter(14, 2)
			gundorada.align_lift_parts_to_floor()
			character.place_standing_and_reset_cloth(0.0, 2460.0, 6000.0, vm.f32(3.14))
		end
		event.reset_follow_camera(1, 0.0, 10.0)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				local _ = georama.can_start_placeholder_event_a()
				at = 2
				gundorada.play_event_552_scene()
				return vm.continue_with(function()
					if georama.can_start_event_556() ~= 0 then
						at = 3
						gundorada.play_event_556_scene()
					end
					if previous_map_number == 3 then
						character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, 0.0)
					end
					if previous_map_number == 105 then
						return_gate_index = event.get_save_counter(18) or return_gate_index
						event.set_save_counter(14, 0)
						gundorada.align_lift_parts_to_floor()
						if return_gate_index == 1 then
							character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
						end
						if return_gate_index == 2 then
							character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
						end
						if return_gate_index == 3 then
							character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
						end
						if return_gate_index == 0 then
							character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
						end
					end
					if previous_map_number == 107 then
						event.set_save_counter(14, 2)
						gundorada.align_lift_parts_to_floor()
						character.place_standing_and_reset_cloth(0.0, 2460.0, 6000.0, vm.f32(3.14))
					end
					event.reset_follow_camera(1, 0.0, 10.0)
					return
				end)
			end
			if at <= 2 then
				local _ = georama.can_start_placeholder_event_a()
				at = 3
				gundorada.play_event_556_scene()
				return vm.continue_with(function()
					if previous_map_number == 3 then
						character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, 0.0)
					end
					if previous_map_number == 105 then
						return_gate_index = event.get_save_counter(18) or return_gate_index
						event.set_save_counter(14, 0)
						gundorada.align_lift_parts_to_floor()
						if return_gate_index == 1 then
							character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
						end
						if return_gate_index == 2 then
							character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
						end
						if return_gate_index == 3 then
							character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
						end
						if return_gate_index == 0 then
							character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
						end
					end
					if previous_map_number == 107 then
						event.set_save_counter(14, 2)
						gundorada.align_lift_parts_to_floor()
						character.place_standing_and_reset_cloth(0.0, 2460.0, 6000.0, vm.f32(3.14))
					end
					event.reset_follow_camera(1, 0.0, 10.0)
					return
				end)
			end
			local _ = georama.can_start_placeholder_event_a()
			cutscene.ignore_coordinates(0.0, 0.0, 0.0, 0.0)
			gundorada.do_nothing()
			cutscene.ignore_coordinates(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			cutscene.ignore_coordinates(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			cutscene.ignore_coordinates(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			cutscene.ignore_coordinates(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
			gundorada.do_nothing()
			cutscene.ignore_coordinates(0.0, 2460.0, 6000.0, vm.f32(3.14))
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = gundorada.play_event_548_scene

--- Event 151, which map data, a script or the engine runs by number.
script[151] = gundorada.play_event_508_scene

--- Resets the georama analysis flags and save flags and plays scene 548.
function script.reset_analysis_and_play_scene_548()
	event.set_georama_analyze_flag(3, 3, 0)
	event.set_georama_analyze_flag(3, 4, 0)
	event.set_georama_analyze_flag(3, 5, 0)
	event.set_georama_analyze_flag(3, 6, 0)
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_save_flag(548, 0)
	event.set_save_flag(552, 1)
	event.set_save_flag(556, 1)
	gundorada.play_event_548_scene()
end
script[152] = script.reset_analysis_and_play_scene_548

--- Warps through the time gate and jumps to map g04.
function script.enter_time_gate()
	time_gate.warp_through_gate(0.0, 0.0, 0.0, vm.f32(6.2831855))
	event.jump_to_map_2(-1, "g04")
	vm.wait(2)
end
script[300] = script.enter_time_gate

--- Asks for an elevator floor and places the player on that floor of the first elevator.
function script.ride_elevator_a()
	local sound_id: s32 = 0
	local floor: any = 0
	local at: number = 0
	local played_bomb_gift_scene: s32 = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		sound_id = event.get_sound_id(2) or sound_id
		at = 1
		floor = ask_elevator_floor()
		if floor >= 0 then
			event.play_sound_effect(sound_id, 70)
			event.fade_out_screen(10)
			at = 2
			wait.frames(10)
			if floor == 0 then
				character.place_standing_and_reset_cloth(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
			end
			if floor == 1 then
				character.place_standing_and_reset_cloth(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
				at = 3
				if gundorada.play_bomb_gift_scene_if_pending() ~= 0 then
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end
			end
			if floor == 2 then
				character.place_standing_and_reset_cloth(vm.f32(684.8), 2320.0, vm.f32(6024.3), vm.f32(-2.87))
			end
			event.play_sound_effect(sound_id, 71)
			gundorada.align_lift_parts_to_floor()
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(10)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				floor = received[1] :: number
			end
			if at == 3 then
				played_bomb_gift_scene = received[1] :: number
			end
			if at <= 1 then
				wait.frames_skipping(10)
			end
			if at <= 2 then
				cutscene.ignore_coordinates(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
				cutscene.ignore_coordinates(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
				at = 3
				played_bomb_gift_scene = gundorada.play_bomb_gift_scene_if_pending()
				return vm.continue_with(function()
					if played_bomb_gift_scene ~= 0 then
						gundorada.align_lift_parts_to_floor()
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(10)
						return
					end
					if floor == 2 then
						character.place_standing_and_reset_cloth(vm.f32(684.8), 2320.0, vm.f32(6024.3), vm.f32(-2.87))
					end
					event.play_sound_effect(sound_id, 71)
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end)
			end
			gundorada.do_nothing()
			return 0
		end
		return nil
	end)
end
script[550] = script.ride_elevator_a

--- Asks for an elevator floor and places the player on that floor of the second elevator.
function script.ride_elevator_b()
	local sound_id: s32 = 0
	local floor: any = 0
	local at: number = 0
	local played_bomb_gift_scene: s32 = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		sound_id = event.get_sound_id(2) or sound_id
		at = 1
		floor = ask_elevator_floor()
		if floor >= 0 then
			event.play_sound_effect(sound_id, 70)
			event.fade_out_screen(10)
			at = 2
			wait.frames(10)
			if floor == 0 then
				character.place_standing_and_reset_cloth(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
			end
			if floor == 1 then
				character.place_standing_and_reset_cloth(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
				at = 3
				if gundorada.play_bomb_gift_scene_if_pending() ~= 0 then
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end
			end
			if floor == 2 then
				character.place_standing_and_reset_cloth(vm.f32(-2553.7), 2320.0, vm.f32(3882.6), vm.f32(1.55))
			end
			event.play_sound_effect(sound_id, 71)
			gundorada.align_lift_parts_to_floor()
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(10)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				floor = received[1] :: number
			end
			if at == 3 then
				played_bomb_gift_scene = received[1] :: number
			end
			if at <= 1 then
				wait.frames_skipping(10)
			end
			if at <= 2 then
				cutscene.ignore_coordinates(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
				cutscene.ignore_coordinates(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
				at = 3
				played_bomb_gift_scene = gundorada.play_bomb_gift_scene_if_pending()
				return vm.continue_with(function()
					if played_bomb_gift_scene ~= 0 then
						gundorada.align_lift_parts_to_floor()
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(10)
						return
					end
					if floor == 2 then
						character.place_standing_and_reset_cloth(vm.f32(-2553.7), 2320.0, vm.f32(3882.6), vm.f32(1.55))
					end
					event.play_sound_effect(sound_id, 71)
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end)
			end
			gundorada.do_nothing()
			return 0
		end
		return nil
	end)
end
script[551] = script.ride_elevator_b

--- Fades out and jumps to map s39.
function script.leave_to_s39()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.jump_to_map_2(-1, "s39")
	vm.wait(2)
end
script[552] = script.leave_to_s39

--- Opens the jump gate menu from gate 1.
function script.use_jump_gate_1()
	use_jump_gate(1)
end
script[560] = script.use_jump_gate_1

--- Opens the jump gate menu from gate 3.
function script.use_jump_gate_3()
	use_jump_gate(3)
end
script[561] = script.use_jump_gate_3

--- Sets counter 13 to 2 and asks to move to Paznos Bridge.
function script.use_paznos_gate_2()
	event.set_save_counter(13, 2)
	ask_move_to_paznos_bridge()
end
script[562] = script.use_paznos_gate_2

--- Sets counter 13 to 3 and asks to move to Paznos Bridge.
function script.use_paznos_gate_3()
	event.set_save_counter(13, 3)
	ask_move_to_paznos_bridge()
end
script[563] = script.use_paznos_gate_3

--- Sets counter 13 to 4 and asks to move to Paznos Bridge.
function script.use_paznos_gate_4()
	event.set_save_counter(13, 4)
	ask_move_to_paznos_bridge()
end
script[564] = script.use_paznos_gate_4

--- Sets counter 13 to 5 and asks to move to Paznos Bridge.
function script.use_paznos_gate_5()
	event.set_save_counter(13, 5)
	ask_move_to_paznos_bridge()
end
script[565] = script.use_paznos_gate_5

--- Opens the jump gate menu from gate 2.
function script.use_jump_gate_2()
	use_jump_gate(2)
end
script[566] = script.use_jump_gate_2

--- Opens the jump gate menu from gate 0.
function script.use_jump_gate_0()
	use_jump_gate(0)
end
script[567] = script.use_jump_gate_0

--- Plays the jet launch scene and jumps to map s30.
function script.launch_jet_to_s30()
	gundorada.play_jet_launch_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s30", 600)
end
script[600] = script.launch_jet_to_s30

--- Plays the jet flyover scene and jumps to map s55.
function script.fly_jet_to_s55()
	gundorada.play_jet_flyover_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 600)
end
script[601] = script.fly_jet_to_s55

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = workshop_villagers.talk_to_villager

--- Resets the georama analysis flags and jumps to map 102 for event 151.
function script.reset_analysis_for_scene_508()
	event.set_georama_analyze_flag(3, 3, 0)
	event.set_georama_analyze_flag(3, 4, 0)
	event.set_georama_analyze_flag(3, 5, 0)
	event.set_georama_analyze_flag(3, 6, 0)
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_save_flag(508, 0)
	event.jump_to_map_3(-1, 102, 151)
	vm.wait(1)
end
script[15080] = script.reset_analysis_for_scene_508

--- Sets the story flags, clears the party member and warps through the time gate to map g04.
function script.warp_to_g04_after_flag_change()
	event.set_save_flag(520, 1)
	event.set_save_flag(522, 0)
	event.set_party_member(1, 0)
	time_gate.warp_through_gate(0.0, 0.0, 0.0, vm.f32(6.2831855))
	event.jump_to_map_2(-1, "g04")
	vm.wait(2)
end
script[15220] = script.warp_to_g04_after_flag_change

--- Resets the analysis flags, plays scene 548 and jumps to map 102.
function script.reset_analysis_and_play_scene_548_then_jump()
	event.set_georama_analyze_flag(3, 3, 0)
	event.set_georama_analyze_flag(3, 4, 0)
	event.set_georama_analyze_flag(3, 5, 0)
	event.set_georama_analyze_flag(3, 6, 0)
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_save_flag(548, 0)
	event.set_save_flag(552, 1)
	event.set_save_flag(556, 1)
	gundorada.play_event_548_scene()
	event.jump_to_map_3(-1, 102, 100)
	vm.wait(2)
end
script[15480] = script.reset_analysis_and_play_scene_548_then_jump

--- Sets the analysis flags for scene 552 and jumps to map 102.
function script.set_analysis_for_scene_552()
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_georama_analyze_flag(3, 3, 1)
	event.set_georama_analyze_flag(3, 4, 1)
	event.set_georama_analyze_flag(3, 5, 1)
	event.set_georama_analyze_flag(3, 6, 1)
	event.set_save_flag(548, 1)
	event.set_save_flag(552, 0)
	event.set_save_flag(556, 1)
	event.jump_to_map_3(-1, 102, 100)
	vm.wait(1)
end
script[15520] = script.set_analysis_for_scene_552

--- Sets the analysis flags for scene 556 and jumps to map 102.
function script.set_analysis_for_scene_556()
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_georama_analyze_flag(3, 3, 1)
	event.set_georama_analyze_flag(3, 4, 1)
	event.set_georama_analyze_flag(3, 5, 1)
	event.set_georama_analyze_flag(3, 6, 1)
	event.set_georama_analyze_flag(3, 7, 1)
	event.set_georama_analyze_flag(3, 8, 1)
	event.set_georama_analyze_flag(3, 9, 1)
	event.set_georama_analyze_flag(3, 10, 1)
	event.set_save_flag(548, 1)
	event.set_save_flag(552, 1)
	event.set_save_flag(556, 0)
	event.jump_to_map_3(-1, 102, 100)
	vm.wait(1)
end
script[15560] = script.set_analysis_for_scene_556

return script
