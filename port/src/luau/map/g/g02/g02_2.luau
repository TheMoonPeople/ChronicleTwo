--!strict
--- Event script for the Balance Valley map covering entries, exits and talking to villagers.

local vm = require("@lib/vm")
local balance_valley = require("@lib/event/balance_valley")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local partner_talk = require("@lib/event/french/partner_talk")
local time_gate = require("@lib/event/french/time_gate")
local town_villagers = require("@lib/event/french/town_villagers")

--- Places the player outside the house after leaving it and fades the screen in.
local function arrive_from_house()
	local sound_id: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_y: f32 = 0
	event.initialize_event()
	balance_valley.disable_extra_characters_and_run_georama()
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 61)
	do
		local out1, out2, out3 = event.get_function_point_position("", "func3")
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	rotation_y = event.get_function_point_rotation("", "func3") or rotation_y
	rotation_y = vm.f32(rotation_y - vm.f32(3.1415927))
	rotation_y = event.wrap_angle(rotation_y) or rotation_y
	event.set_character_position(0, x, y, z)
	event.set_character_rotation(0, 0.0, rotation_y, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Walks the player ahead and shows a hint about checking the last house.
local function walk_ahead_and_hint_at_house()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local frame: s32 = 0
	local flag: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + x)
	target_y = y
	target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + z)
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
	flag = event.get_save_flag(304) or flag
	if flag == 0 then
		event.open_message_window_2(
			0,
			"Il y a peut-[UNI00ea]tre quelqu'un dans la\nderni[UNI00e8]re maison. Allons v[UNI00e9]rifier."
		)
	else
		event.open_message_window_2(0, "On n'a pas le temps.\nIl faut se d[UNI00e9]p[UNI00ea]cher d'aider Lin !")
	end
	message.show(0, -1, 5, 256, 208)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = balance_valley.disable_extra_characters_and_run_georama

--- Plays the entry sequence matching the map the player came from.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local old_map_type: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local previous_submap_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		balance_valley.disable_extra_characters_and_run_georama()
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			event.set_character_position(0, 1989.0, 0.0, -198.0)
			event.set_character_rotation(0, 0.0, -1.21, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			previous_map_number = event.get_previous_map() or previous_map_number
			old_map_type = event.get_map_type(previous_map_number) or old_map_type
			if old_map_type ~= -1 then
				if old_map_type == 7 or old_map_type == 8 then
					resume_step = 1
					balance_valley.play_entry_walk_east()
				elseif previous_map_number == 26 then
					event.set_camera_position(-741.9, 50.0, -592.0)
					event.set_camera_look_at(-741.9, 30.0, -712.0)
					event.set_character_position(0, -741.9, 0.0, -712.0)
					event.set_character_rotation(0, 0.0, 0.0, 0.0)
					event.fade_in_screen(30)
				else
					flag = event.get_save_flag(300) or flag
					flag_2 = event.get_save_flag(302) or flag_2
					if flag == 1 and flag_2 == 0 then
						resume_step = 2
						balance_valley.play_first_intro_cutscene()
					else
						resume_step = 3
						balance_valley.play_entry_walk_west()
					end
				end
			else
				previous_submap_number = event.get_previous_submap() or previous_submap_number
				if previous_submap_number == 100 then
					arrive_from_house()
				end
				if previous_submap_number == -1 then
					arrive_from_house()
				end
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", previous_submap_number, "\n")
			end
		end
		resume_step = 4
		balance_valley.show_gate_hint_if_pending(1)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				resume_step = 2
				balance_valley.play_first_intro_cutscene()
				return vm.continue_with(function()
					resume_step = 4
					balance_valley.show_gate_hint_if_pending(1)
					return
				end)
			end
			if resume_step <= 2 then
				balance_valley.wait_exit_fade()
			end
			if resume_step <= 3 then
				balance_valley.subtract_pi_from_unused_angle()
				balance_valley.subtract_pi_from_unused_angle()
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", previous_submap_number, "\n")
				message.clear_window_option(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the menu button is ignored.
function script.key_open() end

--- Enters Lin's house either by map jump or by interior transition depending on story flags.
function script.enter_lins_house()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local party_npc_id: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		flag = event.get_save_flag(300) or flag
		flag_2 = event.get_save_flag(304) or flag_2
		flag_3 = event.get_save_flag(306) or flag_3
		flag_4 = event.get_save_flag(324) or flag_4
		flag_5 = event.get_save_flag(328) or flag_5
		flag_6 = event.get_save_flag(330) or flag_6
		if flag == 1 then
			party_npc_id = event.get_party_npc() or party_npc_id
			if
				flag_2 == 0
				or flag_3 == 0 and party_npc_id == 6
				or flag_4 == 1 and flag_5 == 0
				or flag_4 == 1 and flag_6 == 0
			then
				if not (flag_4 == 1 and flag_5 == 0) then
					event.skip_next_music_load()
				end
				event.jump_to_map_3(-1, "g02i02", 100)
				resume_step = 1
				vm.wait(1)
				print("--- MAP_JUMP(g02i02) ---\n")
				return
			end
		end
		event.go_to_interior_map(-1, "g02i02", 100)
		resume_step = 2
		vm.wait(2)
		print("--- GOTO_INTERIOR(g02i02) ---\n")
		return
	end, function(received: { any })
		if resume_step <= 1 then
			print("--- MAP_JUMP(g02i02) ---\n")
			return 0
		end
		if resume_step <= 2 then
			print("--- GOTO_INTERIOR(g02i02) ---\n")
			return 0
		end
		return nil
	end)
end
script[200] = script.enter_lins_house

script.arrive_from_house = arrive_from_house
script[210] = script.arrive_from_house

--- Plays the red time gate effect and jumps to the f02 map.
function script.use_time_gate()
	time_gate.play_red_time_gate(vm.f32(-743.2), 0.0, vm.f32(-708.9), vm.f32(-0.64))
	event.jump_to_map_2(-1, "f02")
	vm.wait(2)
end
script[300] = script.use_time_gate

--- Shows the gate hint when pending after a georama change.
function script.edit_analyze_changed()
	balance_valley.show_gate_hint_if_pending(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Asks to leave to the west and jumps to the next map when confirmed.
function script.exit_west()
	if balance_valley.confirm_exit_west() ~= 0 then
		event.jump_to_map_2(-1, "s04")
	end
end
script[500] = script.exit_west

--- Shows the blocked path hint or lets the player choose a dungeon floor and enter it.
function script.exit_east()
	local flag: s32 = 0
	local selected_floor: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(306) or flag
	if flag == 0 then
		walk_ahead_and_hint_at_house()
	elseif balance_valley.confirm_exit_east() ~= 0 then
		event.set_dungeon_stage_id(2)
		event.open_event_menu(3, 2)
		vm.wait(3)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			balance_valley.play_entry_walk_east()
		else
			flag_2 = event.get_save_flag(307) or flag_2
			flag_3 = event.get_save_flag(344) or flag_3
			if selected_floor == 2 and flag_2 == 0 or selected_floor == 21 and flag_3 == 0 or selected_floor == 22 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(2, selected_floor, 1010)
		end
	end
end
script[501] = script.exit_east

--- Restores the valley state and the player after the house scene and shows the pending gate hint.
function script.return_from_house_scene()
	balance_valley.disable_extra_characters_and_run_georama()
	balance_valley.restore_player_and_finish_event()
	balance_valley.show_gate_hint_if_pending(1)
end
script[502] = script.return_from_house_scene

--- Plays the second introduction cutscene.
function script.play_second_intro_scene()
	balance_valley.disable_extra_characters_and_run_georama()
	balance_valley.play_second_intro_cutscene()
end
script[503] = script.play_second_intro_scene

--- Opens the dialogue of a villager and the companion menu.
function script.talk_to_villager()
	town_villagers.talk_to_villager()
	partner_talk.open_camp_companion_menu()
end
script[1000] = script.talk_to_villager

--- Event 13020, which map data, a script or the engine runs by number.
script[13020] = balance_valley.play_first_intro_cutscene

return script
