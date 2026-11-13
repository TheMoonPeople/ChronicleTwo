--!strict
--- Dungeon system script for the d05 dungeon: floor gates, treasure boxes, random circles, the geostone and the Sphida mini-game.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local dungeon_system_scripts = require("@lib/event/dungeon_system_scripts")
local dungeon_system_scripts_camera = require("@lib/event/dungeon_system_scripts_camera")
local dungeon_system_scripts_cutscene = require("@lib/event/dungeon_system_scripts_cutscene")
local dungeon_system_scripts_item = require("@lib/event/dungeon_system_scripts_item")
local dungeon_system_scripts_message = require("@lib/event/dungeon_system_scripts_message")
local dungeon_system_scripts_minigame = require("@lib/event/dungeon_system_scripts_minigame")
local dungeon_system_scripts_object = require("@lib/event/dungeon_system_scripts_object")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local visual_effect = require("@lib/event/visual_effect")
local wait = require("@lib/event/wait")

--- Opens the floor map, records the stage and floor numbers and loads the dungeon map.
local function enter_dungeon_floor()
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	event.initialize_event()
	event.set_local_event_flag(0, 0)
	event.set_local_event_flag(1, 0)
	event.set_local_event_flag(2, 0)
	event.set_local_event_flag(3, 0)
	event.set_local_event_flag(4, 0)
	event.open_dungeon_floor_map(3)
	vm.wait(1)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		stage_id = out2 or stage_id
		floor_number = out3 or floor_number
	end
	stage_id = 3
	event.set_dungeon_stage_id(stage_id)
	event.set_dungeon_floor(floor_number)
	dungeon.increment_floor_counter(stage_id, floor_number)
	event.load_dungeon_map("d05b01")
end

--- Runs a floor gate: opens it with the gate key, or asks whether to descend to the next floor once it is open.
local function operate_floor_gate(gate_index: s32)
	local gate_open_flag: s32 = 0
	local trigger_kind: s32 = 0
	local prompt_result: s32 = 0
	local item: s32 = 0
	local active_character: s32 = 0
	local descend_choice: any = 0
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	local is_e3_version: s32 = 0
	event.set_character_motion(0, "立ち")
	gate_open_flag = event.get_local_event_flag(gate_index) or gate_open_flag
	event.set_dungeon_pause_flags(1, 1)
	if gate_open_flag == 0 then
		trigger_kind = event.get_triggered_event_data_2(6) or trigger_kind
		if trigger_kind == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			prompt_result = dungeon_system_scripts_message.show_and_count_frames(0, 3, 5, 256, 208, prompt_result)
			event.set_message_window_mode(0, 7)
			event.set_message_draw_speed(0, 0)
			if prompt_result == 1 then
				trigger_kind = 2
			end
			event.finish_event()
		end
		if trigger_kind == 2 then
			event.open_use_item_menu(342)
			vm.wait(2)
			item = vmhost.used_item() or item
			if item == 342 then
				event.set_local_event_flag(gate_index, 1)
				dungeon_system_scripts_object.open_rotating_gate()
			elseif item <= 0 then
				event.finish_event()
			else
				dungeon_system_scripts_cutscene.play_miss_gesture_short_wait()
			end
		end
	else
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.initialize_event()
			character.set_idle_motion()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				dungeon_system_scripts_message.show_and_wait(0, 20, 5, 256, 208)
			else
				dungeon_system_scripts_message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		descend_choice = dungeon_system_scripts_message.ask_option(0, 10, 8, 256, 208, 2, 1)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		if descend_choice == 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			current_floor = event.get_dungeon_floor() or current_floor
			next_floor = event.get_dungeon_next_floor(current_floor, gate_index) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			dungeon_system_scripts_cutscene.run_away_and_fade_out()
			is_e3_version = event.is_e3_version() or is_e3_version
			if is_e3_version == 1 then
				event.set_scene_exit_flag(1)
				return
			else
				event.finish_event()
				enter_dungeon_floor()
			end
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Lets the player spend the star key on the star barrier, or explains that the barrier blocks the way.
local function use_star_key_on_barrier()
	local barrier_opened_flag: s32 = 0
	local trigger_kind: s32 = 0
	local item: s32 = 0
	local map_part_handle: s32 = 0
	local trigger_x: f32 = 0
	local trigger_y: f32 = 0
	local trigger_z: f32 = 0
	local trigger_angle: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_dungeon_pause_flags(1, 1)
	barrier_opened_flag = event.get_local_event_flag(4) or barrier_opened_flag
	if barrier_opened_flag == 0 then
		trigger_kind = event.get_triggered_event_data_2(6) or trigger_kind
		if trigger_kind == 2 then
			event.open_use_item_menu(342)
			vm.wait(1)
			item = vmhost.used_item() or item
			if item == 362 then
				event.set_local_event_flag(4, 1)
				map_part_handle = event.get_triggered_event_data_2(9) or map_part_handle
				event.attach_object_handle_to_map_part_3(0, map_part_handle, "star-m0")
				event.set_object_handle_visible(0, 0)
				event.attach_object_handle_to_map_part_3(0, map_part_handle, "d02wa13-a")
				event.set_object_handle_visible(0, 0)
				event.set_function_point_enabled(map_part_handle, "star", 0)
				trigger_x, trigger_y, trigger_z, trigger_angle =
					object.get_trigger_placement(trigger_x, trigger_y, trigger_z, trigger_angle)
				event.set_event_world_coordinate(trigger_x, trigger_y, trigger_z, trigger_angle)
				event.assign_memory_stack(5)
				event.clear_memory_stack(5)
				event.attach_object_handle_to_character(0, 0)
				event.clear_object_sequence(0)
				event.set_object_sequence_object(0, 0)
				event.turn_object_sequence_toward(0, 0.0, 0.0, 0.0, 0)
				event.load_character(5, "event/dng/key_star.gltf", "star", 12)
				event.set_character_active(12)
				event.attach_object_handle_to_character(1, 12)
				event.set_object_sequence_object(1, 1)
				event.set_object_handle_position(1, 0.0, 0.0, 160.0)
				event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
				event.set_object_handle_scale(1, 20.0, 20.0, 20.0)
				event.set_object_sequence_scale(1, 20.0, 0.0, 20.0, 60)
				event.set_camera_sequence_position(-31.46, 57.29, 350.67)
				event.set_camera_sequence_look_at(4.66, 31.72, 192.41)
				event.set_character_visible(12, 0, 1, 0.02)
				wait.for_frame_count(60)
				event.delete_character(12)
			elseif item <= 0 then
				event.finish_event()
			else
				dungeon_system_scripts_cutscene.play_miss_gesture_short_wait()
			end
		end
		if trigger_kind == 1 then
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(
				0,
				"星の不思議な力によって先へ進めない。\n（(#)ボタンでメニューを開く）"
			)
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 256, 208)
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
		end
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Plays the Happy Clown scene where the player picks the red or yellow box and receives one of two items.
local function play_clown_gift_choice(first_item: any, second_item: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_angle: f32 = 0
	local lid_open: f32 = 0
	local language_code: s32 = 0
	local chosen_box: any = 0
	local random_value: s32 = 0
	local swapped_item: any = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		first_item,
		1,
		second_item,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_27a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
		point_angle = out4 or point_angle
	end
	event.set_event_world_coordinate(point_x, point_y, point_z, point_angle)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	dungeon_system_scripts_item.open_treasure_lid(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "event/tbox/p00_27a_ex.gltf", "info", 8)
	event.set_character_active(0, 8)
	event.attach_object_handle_to_character(0, 8)
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 5)
	event.load_character(5, "event/tbox/p00_27a.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "出現", 5)
	lid_open = dungeon_system_scripts_item.open_treasure_lid_fast(lid_open)
	event.set_character_active(8)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 6)
	event.set_character_active(9)
	event.set_object_sequence_motion(1, "出現", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.clear_camera_sequence()
	event.delay_camera_sequence_position_track(4)
	event.move_camera_sequence_eased(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.move_camera_sequence_eased(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	lid_open = inventory.open_treasure_box_lid(lid_open)
	wait.for_frame_count(10)
	event.set_character_active(0, 8)
	event.load_character(5, "event/tbox/p00_27a_ex_r.gltf", "info", 10)
	event.set_character_active(10)
	event.set_character_position(10, 0.0, 0.0, 0.0)
	event.set_character_rotation(10, 0.0, 0.0, 0.0)
	event.set_character_motion(10, "宝箱発生（右手）", 6)
	event.attach_character_to_frame(9, "s_pre", 10)
	event.load_character(5, "event/tbox/p00_27a_ex_l.gltf", "info", 11)
	event.set_character_active(11)
	event.set_character_position(11, 0.0, 0.0, 0.0)
	event.set_character_rotation(11, 0.0, 0.0, 0.0)
	event.set_character_motion(11, "宝箱出現（左手）", 6)
	event.attach_character_to_frame(9, "b_pre", 11)
	event.load_character(5, "event/tbox/r_box.gltf", "info", 14)
	event.set_character_active(14)
	event.set_character_position(14, 0.0, 0.0, 0.0)
	event.set_character_rotation(14, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(9, "s_pre", 14)
	event.set_scene_character_type(14, 4)
	event.load_character(5, "event/tbox/l_box.gltf", "info", 15)
	event.set_character_active(15)
	event.set_character_position(15, 0.0, 0.0, 0.0)
	event.set_character_rotation(15, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(9, "b_pre", 15)
	event.set_scene_character_type(15, 4)
	event.set_character_visible(14, 0)
	event.set_character_visible(15, 0)
	wait.for_frame_count(8)
	event.set_character_visible(14, 1, 1, 0.08)
	event.set_character_visible(15, 1, 1, 0.08)
	wait.for_frame_count(10)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(
			0,
			"はぁーい！やってるかーい。\nハッピーピエロのプレゼントコーナー！\nさあ、好きな方どっちか選んで！"
		)
	else
		event.open_message_window_2(0, "Howdy!\nHow's it going?<page>Happy Clown's gonna give you a gift!\nHere, make your choice.")
	end
	dungeon_system_scripts_message.show_and_wait(0, -1, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	if language_code == 0 then
		event.open_message_window_2(0, "赤い箱を選ぶ\n黄色い箱を選ぶ")
	else
		event.open_message_window_2(0, "Pick the red box.\nPick the yellow box.")
	end
	local _ = message.open(0, -1, 8, 0, 0)
	chosen_box = dungeon_system_scripts_message.select_option(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	random_value = event.get_random_number_int(100) or random_value
	if vm.imod(random_value, 2) == 0 then
		swapped_item = first_item
		first_item = second_item
		second_item = swapped_item
	end
	event.load_item_model(5, first_item, "info", 12, 1)
	event.set_character_active(0, 12)
	event.set_character_position(12, 0.0, 0.0, 0.0)
	event.set_character_rotation(12, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 12)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(12, first_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.load_item_model(5, second_item, "info", 13, 1)
	event.set_character_active(0, 13)
	event.set_character_position(13, 0.0, 0.0, 0.0)
	event.set_character_rotation(13, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 13)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(13, second_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.set_character_active(1, 12)
	event.attach_character_to_frame(9, "s_pre", 12)
	event.set_character_active(1, 13)
	event.attach_character_to_frame(9, "b_pre", 13)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if chosen_box == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait.for_frame_count(10)
	event.set_character_visible(14, 0, 1, 0.04)
	event.set_character_visible(15, 0, 1, 0.04)
	object.wait_until_done(1)
	if chosen_box == 0 then
		dungeon_system_scripts_message.show_item_obtained(second_item, 1)
		event.add_inventory_item(second_item, 1)
	else
		dungeon_system_scripts_message.show_item_obtained(first_item, 1)
		event.add_inventory_item(first_item, 1)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(17, 0)
	for i = 0, 7 do
		event.delete_character(8 + i)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Sets up the Sphida course and spawns the ball and goal objects at their starting positions.
local function load_sphida_objects(course_mode: s32)
	local texture_block: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	texture_block = event.load_event_image_4(4, "textures/dungeon/sphida/sphida_bar.json", 0) or texture_block
	event.set_up_sphida(4, texture_block, course_mode)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	pin_color = event.get_sphida_pin_color() or pin_color
	ball_color = event.get_sphida_ball_color() or ball_color
	event.load_character(4, "dungeon/sphida/bball.gltf", "info", 8)
	event.load_character(4, "dungeon/sphida/rball.gltf", "info", 9)
	if ball_color == 0 then
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	else
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	end
	if pin_color == 0 then
		event.load_character(4, "dungeon/sphida/rgool.gltf", "info", 10)
		event.load_character(4, "dungeon/sphida/rgool2.gltf", "info", 11)
	else
		event.load_character(4, "dungeon/sphida/bgool.gltf", "info", 10)
		event.load_character(4, "dungeon/sphida/bgool2.gltf", "info", 11)
	end
	event.set_character_active(10)
	event.set_character_active(11)
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_character_position(10, pin_x, pin_y, pin_z)
	event.set_character_position(11, pin_x, pin_y, pin_z)
end

--- Plays the victory scene after every monster is defeated and explains how to reach the next floor.
local function play_floor_clear_cutscene()
	local active_character: s32 = 0
	local is_e3_version: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local final_camera_x: f32 = 0
	local final_camera_y: f32 = 0
	local final_camera_z: f32 = 0
	local language_code: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		active_character = event.get_playable_character() or active_character
		character.set_idle_motion()
		if active_character == 0 then
			progress_step = 1
			dungeon_system_scripts_cutscene.play_max_victory()
		end
		if active_character == 1 then
			progress_step = 2
			dungeon_system_scripts_cutscene.play_monica_victory()
		end
		if active_character == 2 or active_character == 3 then
			progress_step = 3
			dungeon_system_scripts_cutscene.play_follow_camera_victory(active_character)
		end
		is_e3_version = event.is_e3_version() or is_e3_version
		if is_e3_version ~= 1 then
			load_sphida_objects(0)
			do
				local out1, out2, out3 = event.get_previous_camera_next_position()
				camera_x = out1 or camera_x
				camera_y = out2 or camera_y
				camera_z = out3 or camera_z
			end
			event.set_camera_position(camera_x, camera_y, camera_z)
			do
				local out1, out2, out3 = event.get_previous_camera_next_look_at()
				camera_x = out1 or camera_x
				camera_y = out2 or camera_y
				camera_z = out3 or camera_z
			end
			event.set_camera_look_at(camera_x, camera_y, camera_z)
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			progress_step = 4
			dungeon_system_scripts_message.show_and_wait(0, 2100, 8, 0, 0)
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			final_camera_x = out1 or final_camera_x
			final_camera_y = out2 or final_camera_y
			final_camera_z = out3 or final_camera_z
		end
		event.set_camera_position(final_camera_x, final_camera_y, final_camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			final_camera_x = out1 or final_camera_x
			final_camera_y = out2 or final_camera_y
			final_camera_z = out3 or final_camera_z
		end
		event.set_camera_look_at(final_camera_x, final_camera_y, final_camera_z)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.open_message_window_2(
				0,
				"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
			)
			progress_step = 5
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(
				0,
				" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
			)
			progress_step = 6
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if progress_step <= 6 then
			if progress_step <= 1 then
				progress_step = 2
				dungeon_system_scripts_cutscene.play_monica_victory()
				return vm.continue_with(function()
					if active_character == 2 or active_character == 3 then
						progress_step = 3
						dungeon_system_scripts_cutscene.play_follow_camera_victory(active_character)
					end
					is_e3_version = event.is_e3_version() or is_e3_version
					if is_e3_version ~= 1 then
						load_sphida_objects(0)
						do
							local out1, out2, out3 = event.get_previous_camera_next_position()
							camera_x = out1 or camera_x
							camera_y = out2 or camera_y
							camera_z = out3 or camera_z
						end
						event.set_camera_position(camera_x, camera_y, camera_z)
						do
							local out1, out2, out3 = event.get_previous_camera_next_look_at()
							camera_x = out1 or camera_x
							camera_y = out2 or camera_y
							camera_z = out3 or camera_z
						end
						event.set_camera_look_at(camera_x, camera_y, camera_z)
						event.set_message_window_mode(0, 4)
						event.set_message_draw_speed(0, 1)
						progress_step = 4
						dungeon_system_scripts_message.show_and_wait(0, 2100, 8, 0, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_draw_speed(0, 0)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_position(final_camera_x, final_camera_y, final_camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_look_at(final_camera_x, final_camera_y, final_camera_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					language_code = event.get_language() or language_code
					if language_code == 0 then
						event.open_message_window_2(
							0,
							"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
						)
						progress_step = 5
						dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
					else
						event.open_message_window_2(
							0,
							" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
						)
						progress_step = 6
						dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if progress_step <= 2 then
				progress_step = 3
				dungeon_system_scripts_cutscene.play_follow_camera_victory(active_character)
				return vm.continue_with(function()
					is_e3_version = event.is_e3_version() or is_e3_version
					if is_e3_version ~= 1 then
						load_sphida_objects(0)
						do
							local out1, out2, out3 = event.get_previous_camera_next_position()
							camera_x = out1 or camera_x
							camera_y = out2 or camera_y
							camera_z = out3 or camera_z
						end
						event.set_camera_position(camera_x, camera_y, camera_z)
						do
							local out1, out2, out3 = event.get_previous_camera_next_look_at()
							camera_x = out1 or camera_x
							camera_y = out2 or camera_y
							camera_z = out3 or camera_z
						end
						event.set_camera_look_at(camera_x, camera_y, camera_z)
						event.set_message_window_mode(0, 4)
						event.set_message_draw_speed(0, 1)
						progress_step = 4
						dungeon_system_scripts_message.show_and_wait(0, 2100, 8, 0, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_draw_speed(0, 0)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_position(final_camera_x, final_camera_y, final_camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_look_at(final_camera_x, final_camera_y, final_camera_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					language_code = event.get_language() or language_code
					if language_code == 0 then
						event.open_message_window_2(
							0,
							"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
						)
						progress_step = 5
						dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
					else
						event.open_message_window_2(
							0,
							" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
						)
						progress_step = 6
						dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if progress_step <= 3 then
				dungeon_system_scripts_cutscene.noop(0)
				dungeon_system_scripts_message.finish_on_skip(0, 2100, 8, 0, 0)
			end
			if progress_step <= 4 then
				dungeon_system_scripts_message.finish_on_skip(0, -1, 8, 0, 0)
			end
			if progress_step <= 5 then
				dungeon_system_scripts_message.finish_on_skip(0, -1, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Tests whether a swing arc around a point is free of walls and has ground below, returning 1 if clear, 0 if blocked at the edge and -1 if blocked at the centre.
local function check_swing_clearance(origin_x: f32, origin_y: f32, origin_z: f32, start_angle: f32, end_angle: f32)
	local first_edge_x: f32 = 0
	local first_edge_y: f32 = 0
	local first_edge_z: f32 = 0
	local second_edge_x: f32 = 0
	local second_edge_y: f32 = 0
	local second_edge_z: f32 = 0
	local collision_result: s32 = 0
	start_angle = event.wrap_angle(start_angle) or start_angle
	start_angle = event.wrap_angle(start_angle) or start_angle
	end_angle = event.wrap_angle(end_angle) or end_angle
	end_angle = event.wrap_angle(end_angle) or end_angle
	first_edge_x = vm.f32(vm.sin(start_angle) * 16.0)
	first_edge_y = 10.0
	first_edge_z = vm.f32(vm.cos(start_angle) * 16.0)
	if end_angle ~= start_angle then
		if vm.f32(end_angle - start_angle) > 0.0 then
			end_angle = vm.f32(start_angle + vm.f32(0.6))
		else
			start_angle = vm.f32(start_angle + 0.25)
			end_angle = vm.f32(start_angle - vm.f32(0.6))
		end
	end
	end_angle = event.wrap_angle(end_angle) or end_angle
	second_edge_x = vm.f32(vm.sin(end_angle) * 16.0)
	second_edge_y = 10.0
	second_edge_z = vm.f32(vm.cos(end_angle) * 16.0)
	do
		local out1, out2, out3 = event.add_vectors(first_edge_x, first_edge_y, first_edge_z, origin_x, origin_y, origin_z)
		first_edge_x = out1 or first_edge_x
		first_edge_y = out2 or first_edge_y
		first_edge_z = out3 or first_edge_z
	end
	do
		local out1, out2, out3 = event.add_vectors(second_edge_x, second_edge_y, second_edge_z, origin_x, origin_y, origin_z)
		second_edge_x = out1 or second_edge_x
		second_edge_y = out2 or second_edge_y
		second_edge_z = out3 or second_edge_z
	end
	collision_result = event.get_segment_collision_9(12, first_edge_x, first_edge_y, first_edge_z, origin_x, origin_y + 10.0, origin_z, 1) or collision_result
	if collision_result >= 0 then
		return -1
	end
	collision_result = event.get_segment_collision_9(12, second_edge_x, second_edge_y, second_edge_z, origin_x, origin_y + 10.0, origin_z, 1) or collision_result
	if collision_result >= 0 then
		return -1
	end
	collision_result = event.get_segment_collision_9(12, first_edge_x, first_edge_y, first_edge_z, second_edge_x, second_edge_y, second_edge_z, 1) or collision_result
	if collision_result >= 0 then
		return 0
	end
	collision_result = event.get_segment_collision_9(12, first_edge_x, first_edge_y, first_edge_z, first_edge_x, first_edge_y - 20.0, first_edge_z, 1) or collision_result
	if collision_result < 0 then
		return 0
	end
	collision_result = event.get_segment_collision_9(12, second_edge_x, second_edge_y, second_edge_z, second_edge_x, second_edge_y - 20.0, second_edge_z, 1) or collision_result
	if collision_result < 0 then
		return 0
	end
	return 1
end

--- Places the golfer at the ball and turns them toward the pin, picking the nearest angle with a clear swing.
local function place_golfer_at_ball(ball_x: f32, ball_y: f32, ball_z: f32, aim_angle: f32)
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local angle_offset: f32 = 0
	local clearance: s32 = 0
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	aim_angle = event.get_direction_angle(ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or aim_angle
	angle_offset = 0.0
	while angle_offset <= vm.f32(3.1415927) do
		clearance = check_swing_clearance(
			ball_x,
			ball_y,
			ball_z,
			vm.f32(aim_angle + vm.f32(1.5707964)),
			vm.f32(vm.f32(aim_angle + angle_offset) + vm.f32(1.5707964))
		)
		if clearance == 1 then
			aim_angle = vm.f32(aim_angle + angle_offset)
			break
		else
			clearance = check_swing_clearance(
				ball_x,
				ball_y,
				ball_z,
				vm.f32(aim_angle + vm.f32(1.5707964)),
				vm.f32(vm.f32(aim_angle - angle_offset) + vm.f32(1.5707964))
			)
			if clearance == 1 then
				aim_angle = vm.f32(aim_angle - angle_offset)
				break
			else
				angle_offset = vm.f32(angle_offset + vm.f32(0.3926991))
			end
		end
	end
	event.set_character_position(0, ball_x, ball_y - 3.0, ball_z)
	event.set_character_rotation(0, 0.0, aim_angle, 0.0)
	event.set_character_motion(0, "かまえ", 4)
	return ball_x, ball_y, ball_z, aim_angle
end

--- Lets the player rotate the aim and adjust the launch angle until they confirm or cancel the shot.
local function aim_sphida_shot(aim_angle: f32, launch_angle_degrees: f32, texture_block: s32)
	local cancel_flag: s32 = 0
	local idle_timer: s32 = 0
	local aim_motion_delay: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local camera_angle: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local new_launch_angle: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		idle_timer = 60
		aim_motion_delay = 76
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		event.set_follow_camera_following(1)
		event.set_camera_control_enabled(1)
		event.set_camera_rotation_cancel_mask(43)
		event.set_camera_speed(6.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_target(start_x, start_y + 20.0, start_z)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.set_camera_control_range(10.0, 30.0, 80.0, 120.0)
		while true do
			do
				local out1, out2 = event.get_analog_sticks_2()
				stick_x = out1 or stick_x
				stick_y = out2 or stick_y
			end
			do
				local out1, out2, out3 = event.get_character_position(0)
				current_x = out1 or current_x
				current_y = out2 or current_y
				current_z = out3 or current_z
			end
			do
				local out1, out2, out3 = event.get_character_rotation(0)
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			if stick_x ~= 0.0 then
				if
					check_swing_clearance(
						current_x,
						current_y,
						current_z,
						vm.f32(rotation_y + vm.f32(1.5707964)),
						vm.f32(vm.f32(rotation_y - vm.f32(stick_x / 32.0)) + vm.f32(1.5707964))
					) == 1
				then
					rotation_y = vm.f32(rotation_y - vm.f32(stick_x / 32.0))
				else
					stick_x = 0.0
				end
			end
			event.set_character_rotation(0, rotation_x, rotation_y, rotation_z)
			if idle_timer <= 0 then
				event.set_character_motion(0, "待機")
				aim_motion_delay = 76
				idle_timer = 400
			else
				if stick_x ~= 0.0 then
					event.set_character_motion(0, "かまえバタバタ")
					idle_timer = 200
					aim_motion_delay = 0
				elseif aim_motion_delay <= 0 then
					event.set_character_motion(0, "かまえ")
				else
					aim_motion_delay = aim_motion_delay - 1
				end
				idle_timer = idle_timer - 1
			end
			new_launch_angle = launch_angle_degrees
			new_launch_angle = vm.f32(new_launch_angle + stick_y)
			if new_launch_angle <= 1.0 then
				new_launch_angle = 1.0
			end
			if new_launch_angle >= 15.0 then
				new_launch_angle = 15.0
			end
			aim_angle = rotation_y
			launch_angle_degrees = new_launch_angle
			event.set_sphida_carry_angle(vm.f32(launch_angle_degrees * vm.f32(3.1415927)) / 180.0)
			camera_angle = vm.f32(aim_angle - vm.f32(3.1415927))
			camera_angle = event.wrap_angle(camera_angle) or camera_angle
			event.set_camera_control_rotation(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			dungeon_system_scripts_minigame.draw_shot_guide(aim_angle, launch_angle_degrees, texture_block)
			if wait.is_button_pressed(32) ~= 0 then
				event.set_character_motion(0, "かまえ")
				cancel_flag = 0
				break
			elseif wait.is_button_pressed(64) ~= 0 then
				cancel_flag = 1
				break
			else
				progress_step = 1
				vm.wait(1)
			end
		end
		visual_effect.hide_all_sprites()
		progress_step = 2
		vm.wait(2)
		return cancel_flag, aim_angle, launch_angle_degrees
	end, function(received: { any })
		if progress_step <= 2 then
			if progress_step <= 1 then
				visual_effect.hide_all_sprites_skipping()
			end
			return cancel_flag, aim_angle, launch_angle_degrees
		end
		return nil, aim_angle, launch_angle_degrees
	end)
end

--- Cleans up the Sphida scene after a shot and shows the out-of-strokes message when no par remains.
local function finish_sphida_turn(pin_hit: s32)
	local remaining_par: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.start_crossfade(15)
	remaining_par = event.get_sphida_par() or remaining_par
	if pin_hit == 0 and remaining_par <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_look_at(camera_x, camera_y, camera_z)
		event.set_message_window_mode(0, 4)
		dungeon_system_scripts_message.show_and_wait(0, 2003, 8, 0, 0)
		event.reset_follow_camera(1)
	end
	event.finish_event()
end

--- Runs the power gauge and turns the player's timing into shot power, direction error and spin.
local function run_power_gauge(shot_power: f32, unused_value: any, aim_angle: f32, spin_x: f32, spin_y: f32, sound_effect_id: s32, shot_result: s32)
	local camera_angle: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local gauge_result: s32 = 0
	local press_count: s32 = 0
	local cursor_x: f32 = 0
	local cursor_y: f32 = 0
	local random_offset: f32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		camera_angle = vm.f32(aim_angle - vm.f32(3.1415927))
		camera_angle = event.wrap_angle(camera_angle) or camera_angle
		press_count = 0
		gauge_result = -10
		event.reset_sphida_power_gauge()
		event.start_sphida_power_gauge()
		while gauge_result == -10 do
			event.set_camera_control_rotation(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			do
				local out1, out2 = event.get_analog_sticks_2()
				stick_x = out1 or stick_x
				stick_y = out2 or stick_y
			end
			event.set_sphida_spin_mark_position(stick_x, stick_y)
			progress_step = 1
			vm.wait(1)
			if (if press_count == 0 then wait.is_button_pressed(64) else 0) ~= 0 then
				event.set_sphida_spin_mark_position(0.0, 0.0)
				event.reset_sphida_power_gauge()
				return 1, shot_power, aim_angle, spin_x, spin_y, shot_result
			end
			if wait.is_button_pressed(32) ~= 0 then
				event.play_sound_effect(sound_effect_id, 0)
				event.advance_sphida_power_gauge()
				do
					local out1, out2 = event.get_sphida_power_gauge_cursor_position()
					cursor_x = out1 or cursor_x
					cursor_y = out2 or cursor_y
				end
				event.set_event_sprite_type(10 + press_count, 0)
				event.set_event_sprite_alpha_blend(10 + press_count, 2)
				event.set_event_sprite_texture_rect(10 + press_count, 0, 224, 32, 32)
				event.set_event_sprite_draw_pass(10 + press_count, 1)
				event.set_event_sprite_size(10 + press_count, 32, 32)
				event.set_event_sprite_position(10 + press_count, cursor_x, cursor_y)
				event.set_event_sprite_scale(10 + press_count, 0.2, 0.2, 0.2)
				event.attach_object_handle_to_sprite(20, 10 + press_count)
				event.clear_object_sequence(20)
				event.set_object_sequence_object(20, 20)
				event.set_object_sequence_scale(20, 2, 2, 2, 10)
				event.set_object_sequence_color(20, 128, 128, 128, 128, 2)
				event.set_object_sequence_color(20, 128, 128, 128, 0, 8)
				press_count = 1
			end
			gauge_result = event.get_sphida_power_gauge_result() or gauge_result
		end
		if gauge_result == 5 then
			event.set_sphida_spin_mark_position(0.0, 0.0)
			event.reset_sphida_power_gauge()
			return 1, shot_power, aim_angle, spin_x, spin_y, shot_result
		end
		shot_power = event.get_sphida_shot_power() or shot_power
		if gauge_result == 4 then
			shot_power = vm.f32(shot_power * 0.0)
		end
		if gauge_result == -3 then
			shot_power = vm.f32(shot_power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			aim_angle = vm.f32(vm.f32(aim_angle - vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * shot_power)
		end
		if gauge_result == 3 then
			shot_power = vm.f32(shot_power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			aim_angle = vm.f32(vm.f32(aim_angle + vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * shot_power)
		end
		if gauge_result == -2 then
			shot_power = vm.f32(shot_power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			aim_angle = vm.f32(vm.f32(aim_angle - vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * shot_power)
		end
		if gauge_result == 2 then
			shot_power = vm.f32(shot_power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			aim_angle = vm.f32(vm.f32(aim_angle + vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * shot_power)
		end
		if gauge_result == -1 then
			shot_power = vm.f32(shot_power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			aim_angle = vm.f32(aim_angle - random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * shot_power)
		end
		if gauge_result == 1 then
			shot_power = vm.f32(shot_power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			aim_angle = vm.f32(aim_angle + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * shot_power)
		end
		if gauge_result == 0 then
			shot_power = vm.f32(shot_power * vm.f32(1.1))
			stick_x = vm.f32(stick_x * shot_power)
			stick_y = vm.f32(stick_y * shot_power)
		end
		shot_result = gauge_result
		aim_angle = event.wrap_angle(aim_angle) or aim_angle
		spin_x = stick_x
		spin_y = stick_y
		progress_step = 2
		wait.for_frame_count(10)
		return 0, shot_power, aim_angle, spin_x, spin_y, shot_result
	end, function(received: { any })
		if progress_step <= 1 then
			local _ = wait.is_button_pressed_skipping(64)
			local _ = wait.is_button_pressed_skipping(64)
			return 1, shot_power, aim_angle, spin_x, spin_y, shot_result
		end
		if progress_step <= 2 then
			return 0, shot_power, aim_angle, spin_x, spin_y, shot_result
		end
		return nil, shot_power, aim_angle, spin_x, spin_y, shot_result
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Waits for the confirm button press and then ends the event.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	wait.until_button_pressed(32)
	event.finish_event()
end

--- Runs the first floor gate.
function script.examine_gate_0()
	operate_floor_gate(0)
end
script[300] = script.examine_gate_0

--- Runs the second floor gate when the edit analysis finds changes.
function script.edit_analyze_changed()
	operate_floor_gate(1)
end

--- Runs the third floor gate.
function script.examine_gate_2()
	operate_floor_gate(2)
end
script[320] = script.examine_gate_2

--- Runs the fourth floor gate.
function script.examine_gate_3()
	operate_floor_gate(3)
end
script[330] = script.examine_gate_3

--- Event 340, which map data, a script or the engine runs by number.
script.use_star_key_on_barrier = use_star_key_on_barrier
script[340] = script.use_star_key_on_barrier

script.enter_dungeon_floor = enter_dungeon_floor
script[1000] = script.enter_dungeon_floor

--- Opens a treasure box, giving a single item or the clown's choice of two.
function script.treasure_box()
	local active_character: s32 = 0
	local move_type: s32 = 0
	local item_id: s32 = 0
	local second_item_id: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	event.set_character_active(0, 0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 then
		move_type = event.get_player_move_type() or move_type
		if move_type == 1 then
			event.set_character_motion(0, "立ち-足")
		end
		if move_type == 2 then
			event.set_character_motion(0, "立ち-キャタピラ")
		end
	end
	do
		local out1, out2 = event.get_treasure_box_item()
		item_id = out1 or item_id
		second_item_id = out2 or second_item_id
	end
	if second_item_id <= -1 then
		dungeon_system_scripts.play_treasure_get(item_id)
	else
		play_clown_gift_choice(item_id, second_item_id)
	end
end

--- Spins a coin over a random circle and applies a blessing or curse depending on which face lands up.
function script.random_circle()
	local language_code: s32 = 0
	local active_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local player_push_angle: f32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local sound_id: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_yaw: f32 = 0
	local coin_face: s32 = 0
	local step_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local camera_facing_angle: f32 = 0
	local minimum_spin_steps: s32 = 0
	local angle: f32 = 0
	local random_roll: s32 = 0
	local flip_threshold: s32 = 0
	local bright_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	event.initialize_event()
	language_code = event.get_language() or language_code
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		if language_code == 0 then
			if active_character == 2 then
				event.open_message_window_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.open_message_window_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif active_character == 2 then
			event.open_message_window_2(0, "Must get off the Ridepod.")
		else
			event.open_message_window_2(0, "Looks like you can't do it\nas a monster.")
		end
		dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			circle_x = out1 or circle_x
			circle_y = out2 or circle_y
			circle_z = out3 or circle_z
		end
		player_push_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or player_push_angle
		player_x = vm.f32(vm.f32(vm.sin(player_push_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(player_push_angle) * 25.0) + circle_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		center_x = out1 or center_x
		center_y = out2 or center_y
		center_z = out3 or center_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(center_x, center_y + 30.0, center_z)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	character.set_idle_motion()
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(2)
	wait.background_load()
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_id
	event.play_sound_effect(sound_id, 0)
	event.start_background_file_loads_2("event/dng/ring.gltf", "event/dng/randomcoin.gltf")
	vm.wait(4)
	wait.background_load()
	ring_motion_frame = event.get_random_circle_motion_frame() or ring_motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "event/dng/ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, center_x, center_y, center_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, ring_motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "event/dng/randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, center_x, center_y - 30.0, center_z)
	coin_yaw = event.get_random_number(6.2831855) or coin_yaw
	coin_yaw = vm.f32(coin_yaw - vm.f32(3.1415927))
	coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
	event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, center_x, center_y + 40.0, center_z, 30, 2, 0.5)
	step_count = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		if step_count == 30 then
			if language_code == 0 then
				dungeon_system_scripts_message.open_stop_hint_japanese()
			else
				event.set_message_window_mode(1, 7)
				event.apply_message_window_preset(1, 2)
				event.open_message_window_2(1, "It stops with (O) button.")
				message.open(1, -1, 15, 0, 0)
			end
		end
		if (if step_count >= 30 then wait.get_button_state(0) else 0) ~= 0 then
			event.stop_sound_effect(sound_id, 0)
			event.play_sound_effect(sound_id, 3)
			vm.wait(6)
			break
		else
			step_count = vm.i32(step_count + 1)
			vm.wait(7)
		end
	end
	message.close_second_window()
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
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	minimum_spin_steps = 0
	minimum_spin_steps = event.get_random_number_int(10) or minimum_spin_steps
	minimum_spin_steps = vm.i32(minimum_spin_steps + 4)
	step_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		vm.wait(8)
		if step_count >= minimum_spin_steps then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = camera_facing_angle
			angle = event.wrap_angle(angle) or angle
			if coin_yaw < angle and calc.is_angle_within(coin_yaw, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				coin_face = 0
				break
			end
			angle = vm.f32(camera_facing_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_yaw < angle and calc.is_angle_within(coin_yaw, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				coin_face = 1
				break
			end
		end
		step_count = vm.i32(step_count + 1)
	end
	wait.for_frame_count(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if random_roll < 6 then
		random_roll = event.get_random_number_int(10) or random_roll
		if coin_face == 0 then
			flip_threshold = 2
		else
			flip_threshold = 4
		end
		if random_roll < flip_threshold then
			camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
			camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
			event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 8)
			if coin_face == 0 then
				coin_face = 1
			else
				coin_face = 0
			end
			wait.for_frame_count(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 6)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				wait.for_frame_count(20)
			end
		end
	end
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, camera_facing_angle, 1.0) == 0 then
		coin_face = 0
	else
		coin_face = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	step_count = 0
	effect_id = event.get_random_circle_effect(coin_face) or effect_id
	if coin_face == 0 then
		event.play_sound_effect(sound_id, 1)
		while step_count < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			step_count = step_count + 1
			vm.wait(12)
		end
		if language_code == 0 then
			event.open_message_window_2(0, "コインは天使の面をこちらに向けた。")
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
			if effect_id == 1 then
				event.open_message_window_2(0, "ＡＢＳボーナス")
			end
			if effect_id == 2 then
				event.open_message_window_2(
					0,
					"天使は「体力」と「ステータス異常」を\n全回復してくれた。"
				)
			end
			if effect_id == 3 then
				event.open_message_window_2(0, "天使は「ＷＨＰ」を全回復してくれた。")
			end
			if effect_id == 4 then
				event.open_message_window_2(0, "天使は「宝箱」を置いていった。")
				event.place_treasure_box(center_x, center_y, center_z, camera_facing_angle, 294)
			end
		else
			event.open_message_window_2(0, "The coin flipped to the 'Angel'.")
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
			if effect_id == 1 then
				event.open_message_window_2(0, "ABS bonus!")
			end
			if effect_id == 2 then
				event.open_message_window_2(0, "Strength & status fully\nrecovered by the Angel.")
			end
			if effect_id == 3 then
				event.open_message_window_2(0, "WHP fully recovered by the Angel.")
			end
			if effect_id == 4 then
				event.open_message_window_2(0, "Angel left a treasure box.")
				event.place_treasure_box(center_x, center_y, center_z, camera_facing_angle, 294)
			end
		end
	else
		event.play_sound_effect(sound_id, 2)
		while step_count < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			step_count = step_count + 1
			vm.wait(15)
		end
		if language_code == 0 then
			event.open_message_window_2(0, "コインは悪魔の面をこちらに向けた。")
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
			if effect_id == 5 then
				if active_character == 0 or active_character == 2 then
					event.open_message_window_2(0, "悪魔はユリスに「毒」のステータス異常をあたえた。")
				end
				if active_character == 1 or active_character == 3 then
					event.open_message_window_2(0, "悪魔はモニカに「毒」のステータス異常をあたえた。")
				end
			end
			if effect_id == 6 then
				if active_character == 0 then
					event.open_message_window_2(0, "悪魔はユリスの体力を半分にした。")
				end
				if active_character == 1 or active_character == 3 then
					event.open_message_window_2(0, "悪魔はモニカの体力を半分にした。")
				end
				if active_character == 2 then
					event.open_message_window_2(0, "悪魔はスティーブの耐久力を半分にした。")
				end
			end
			if effect_id == 8 then
				event.open_message_window_2(0, "悪魔は銃の「ＷＨＰ」を半分にした。")
			end
			if effect_id == 9 then
				event.open_message_window_2(0, "悪魔はレンチの「ＷＨＰ」を半分にした。")
			end
			if effect_id == 10 then
				event.open_message_window_2(0, "悪魔は腕輪の「ＷＨＰ」を半分にした。")
			end
			if effect_id == 11 then
				event.open_message_window_2(0, "悪魔は剣の「ＷＨＰ」を半分にした。")
			end
			if effect_id == 12 then
				event.open_message_window_2(0, "悪魔は全モンスターを復活させた。")
			end
		else
			event.open_message_window_2(0, "The coin flipped to 'Devil'")
			dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
			if effect_id == 5 then
				if active_character == 0 or active_character == 2 then
					event.open_message_window_2(0, "Devil caused an abnormal status.")
				end
				if active_character == 1 or active_character == 3 then
					event.open_message_window_2(0, "Devil has poisoned Maximilian.")
				end
			end
			if effect_id == 6 then
				if active_character == 0 then
					event.open_message_window_2(0, "Devil takes half of Maximilian's health.")
				end
				if active_character == 1 or active_character == 3 then
					event.open_message_window_2(0, "Devil takes half of Monica's health.")
				end
				if active_character == 2 then
					event.open_message_window_2(0, "Devil takes half of Steve's health.")
				end
			end
			if effect_id == 8 then
				event.open_message_window_2(0, "Devil takes half of your gun's WHP.")
			end
			if effect_id == 9 then
				event.open_message_window_2(0, "Devil takes half of your wrench's WHP.")
			end
			if effect_id == 10 then
				event.open_message_window_2(0, "Devil takes half your bracelet's WHP.")
			end
			if effect_id == 11 then
				event.open_message_window_2(0, "Devil takes half of your sword's WHP.")
			end
			if effect_id == 12 then
				event.open_message_window_2(0, "Devil resurrected all monsters.")
			end
		end
	end
	effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
	dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(center_x, center_y, center_z, 1, 10, effect_amount / 10.0)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the scene of the player using the geostone and awards the geostone item.
function script.geostone()
	local active_character: s32 = 0
	local language_code: s32 = 0
	local original_x: f32 = 0
	local original_y: f32 = 0
	local original_z: f32 = 0
	local sound_id: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local geostone_x: f32 = 0
	local geostone_y: f32 = 0
	local geostone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	event.initialize_event()
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		language_code = event.get_language() or language_code
		if language_code == 0 then
			if active_character == 2 then
				event.open_message_window_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.open_message_window_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif active_character == 2 then
			event.open_message_window_2(0, "Must get off the Ridepod.")
		else
			event.open_message_window_2(0, "Looks like you can't do it\nas a monster.")
		end
		dungeon_system_scripts_message.show_and_wait(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		original_x = out1 or original_x
		original_y = out2 or original_y
		original_z = out3 or original_z
	end
	if active_character == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(2)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_character == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(4)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_id
	event.set_dungeon_pause_flags(17, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	event.copy_vector(character_x, character_y, character_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(character_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if active_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if active_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	character_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	character_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, character_x, character_y, character_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, character_x, character_y + 36.0, character_z)
	end
	if active_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + character_x)
		effect_y = vm.f32(character_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + character_z)
		event.set_character_position(12, effect_x, effect_y, effect_z)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.for_frame_count(16)
	event.play_sound_effect(sound_id, 0)
	wait.for_frame_count(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.for_frame_count(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	facing_angle = event.get_direction_angle(character_x, character_y, character_z, camera_x, camera_y, camera_z) or facing_angle
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.for_frame_count(20)
	event.play_sound_effect(sound_id, 1)
	object.wait_until_done(0)
	dungeon_system_scripts_message.show_item_obtained(358, 1)
	event.start_crossfade(10)
	if active_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(12)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, original_x, original_y, original_z)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.finish_event()
end

--- Shows the talk bubble of the monster being spoken to.
function script.monster_talk()
	local monster_slot: s32 = 0
	local message_index: s32 = 0
	do
		local out1, out2 = event.get_monster_talk_data_2()
		monster_slot = out1 or monster_slot
		message_index = out2 or message_index
	end
	dungeon_system_scripts_message.show_talk_bubble(monster_slot, vm.i32(message_index + 1000))
end

--- Event 1200, which map data, a script or the engine runs by number.
script[1200] = dungeon_system_scripts_cutscene.play_robot_breakdown_event

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = play_floor_clear_cutscene

--- Plays a full Sphida shot: aiming, power gauge, ball physics, and the hole, miss or treasure outcome.
function script.sphida_shot()
	local texture_block: s32 = 0
	local sound_id: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local ball_rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local ball_rotation_z: f32 = 0
	local golfer_x: f32 = 0
	local golfer_y: f32 = 0
	local golfer_z: f32 = 0
	local launch_angle_degrees: f32 = 0
	local club_power: f32 = 0
	local club_spin_factor: f32 = 0
	local gauge_level: s32 = 0
	local roll_spin_x: f32 = 0
	local curve_amount: f32 = 0
	local roll_spin_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local pin_hit: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local free_flight_height: f32 = 0
	local fall_limit_y: f32 = 0
	local failure_frames: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local previous_speed: f32 = 0
	local length: f32 = 0
	local collision_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local step_count: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local pin_distance: f32 = 0
	local pin_offset_x: f32 = 0
	local pin_offset_y: f32 = 0
	local pin_offset_z: f32 = 0
	local pin_line_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local follow_camera_angle: f32 = 0
	local par_count: s32 = 0
	local choice: any = 0
	vm.wait(1)
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	if dungeon_system_scripts.prepare_sphida_club() ~= 0 then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_3(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf"
	)
	vm.wait(3)
	wait.background_load()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	texture_block = event.get_sphida_texture_bank() or texture_block
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_id = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_id
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_character_position(0)
		golfer_x = out1 or golfer_x
		golfer_y = out2 or golfer_y
		golfer_z = out3 or golfer_z
	end
	ball_x, ball_y, ball_z, aim_angle = place_golfer_at_ball(ball_x, ball_y, ball_z, aim_angle)
	dungeon_system_scripts_camera.place_camera_behind_character(aim_angle)
	event.set_sphida_status_panel_visible(1)
	launch_angle_degrees = 7.0
	event.set_sphida_carry_angle(vm.f32(launch_angle_degrees * vm.f32(3.1415927)) / 180.0)
	club_power, club_spin_factor, gauge_level = minigame.get_equipped_club_definition(club_power, club_spin_factor, gauge_level)
	event.set_sphida_power_gauge_safe_level(gauge_level)
	do
		local out1, out2, out3 = event.zero_vector()
		roll_spin_x = out1 or roll_spin_x
		curve_amount = out2 or curve_amount
		roll_spin_z = out3 or roll_spin_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, launch_angle_degrees = aim_sphida_shot(aim_angle, launch_angle_degrees, texture_block)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_character_position(0, golfer_x, golfer_y, golfer_z)
			finish_sphida_turn(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, club_power, aim_angle, curve_amount, roll_spin_x, gauge_level = run_power_gauge(club_power, texture_block, aim_angle, curve_amount, roll_spin_x, sound_id, gauge_level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	pin_hit = 0
	if gauge_level ~= 1 and gauge_level ~= -1 and gauge_level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if gauge_level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if gauge_level == 2 or gauge_level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if gauge_level == 3 or gauge_level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait.for_frame_count(10)
	end
	if club_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.for_frame_count(25)
		event.play_sound_effect(sound_id, 3)
	elseif club_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.for_frame_count(34)
		event.play_sound_effect(sound_id, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.for_frame_count(39)
		if gauge_level == 0 then
			event.play_sound_effect(sound_id, 12)
		else
			event.play_sound_effect(sound_id, 1)
		end
	end
	if gauge_level == 4 then
		wait.for_frame_count(50)
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_id)
		event.set_character_position(0, golfer_x, golfer_y, golfer_z)
		finish_sphida_turn(0)
		return
	end
	if gauge_level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	club_power = minigame.scale_by_club_power(club_power)
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(club_power * vm.cos(vm.f32(vm.f32(launch_angle_degrees * vm.f32(3.1415927)) / 180.0))))
	velocity_y = vm.f32(club_power * vm.sin(vm.f32(vm.f32(launch_angle_degrees * vm.f32(3.1415927)) / 180.0)))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(club_power * vm.cos(vm.f32(vm.f32(launch_angle_degrees * vm.f32(3.1415927)) / 180.0))))
	curve_amount = vm.f32(vm.f32(curve_amount * vm.f32(3.1415927)) / 2.0)
	roll_spin_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin_factor) * roll_spin_x) * vm.f32(0.4))
	roll_spin_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin_factor) * roll_spin_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	free_flight_height = 180.0
	fall_limit_y = -50.0
	failure_frames = 0
	gauge_level = 0
	sound_cooldown = 0
	step_count = 0
	while true do
		if ball_y >= free_flight_height then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (step_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_result = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_result
			if gauge_level == 1 and collision_result >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (step_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + roll_spin_x)
				velocity_z = vm.f32(velocity_z + roll_spin_z)
				roll_spin_x = vm.f32(roll_spin_x * vm.f32(0.8))
				roll_spin_z = vm.f32(roll_spin_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (step_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_amount ~= 0.0 then
			launch_angle_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle_degrees
			launch_angle_degrees = vm.f32(launch_angle_degrees + curve_amount)
			launch_angle_degrees = event.wrap_angle(launch_angle_degrees) or launch_angle_degrees
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle_degrees) / 10.0) * club_spin_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle_degrees) / 10.0) * club_spin_factor))
		end
		roll_spin_x = vm.f32(roll_spin_x * vm.f32(0.994))
		roll_spin_z = vm.f32(roll_spin_z * vm.f32(0.994))
		length = event.get_vector_length(roll_spin_x, 0.0, roll_spin_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(roll_spin_x, 0.0, roll_spin_z) or speed
			launch_angle_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + roll_spin_x, previous_y, previous_z + roll_spin_z) or launch_angle_degrees
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rotation_x = out1 or ball_rotation_x
				aim_angle = out2 or aim_angle
				ball_rotation_z = out3 or ball_rotation_z
			end
			event.set_character_rotation(8, ball_rotation_x, launch_angle_degrees, ball_rotation_z)
			event.offset_character_rotation(8, speed * 14.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rotation_x, launch_angle_degrees, ball_rotation_z)
			event.offset_character_rotation(9, speed * 14.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			launch_angle_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle_degrees
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rotation_x = out1 or ball_rotation_x
				aim_angle = out2 or aim_angle
				ball_rotation_z = out3 or ball_rotation_z
			end
			event.set_character_rotation(8, ball_rotation_x, launch_angle_degrees, ball_rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rotation_x, launch_angle_degrees, ball_rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		previous_speed = speed
		launch_angle_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle_degrees
		direction_x = vm.f32(vm.sin(vm.f32(launch_angle_degrees - vm.f32(1.5707964))) * 3.0)
		direction_z = vm.f32(vm.cos(vm.f32(launch_angle_degrees - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - direction_x,
			ball_y,
			ball_z - direction_z,
			vm.f32(ball_x + direction_x) + direction_x,
			ball_y,
			vm.f32(ball_z + direction_z) + direction_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2 =
				event.get_segment_collision_10(0, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 0)
			collision_result = out1 or collision_result
			surface_type = out2 or surface_type
		end
		if collision_result >= 0 and surface_type == 1 then
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 11)
				sound_cooldown = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_result = out7 or collision_result
		end
		while collision_result >= 0 do
			curve_amount = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 6)
				sound_cooldown = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(velocity_x, velocity_y, velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, velocity_x, velocity_y, velocity_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			length = event.get_vector_length(previous_x, previous_y, previous_z) or length
			length = vm.f32(previous_speed - length)
			if length <= 0.0 then
				break
			else
				previous_speed = length
				velocity_x = vm.f32(vm.f32(normal_x * speed) * vm.f32(0.9))
				velocity_y = vm.f32(vm.f32(normal_y * speed) * vm.f32(0.58))
				velocity_z = vm.f32(vm.f32(normal_z * speed) * vm.f32(0.9))
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(velocity_x + roll_spin_x)
					velocity_z = vm.f32(velocity_z + roll_spin_z)
					roll_spin_x = vm.f32(roll_spin_x * vm.f32(0.8))
					roll_spin_z = vm.f32(roll_spin_z * vm.f32(0.8))
				elseif
					velocity_x < 0.0 and normal_x > 0.0
					or velocity_x > 0.0 and normal_x < 0.0
					or velocity_z < 0.0 and normal_z > 0.0
					or velocity_z > 0.0 and normal_z < 0.0
				then
					roll_spin_x = 0.0
					roll_spin_z = 0.0
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, length)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, normal_x, normal_y, normal_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						previous_x,
						previous_y,
						previous_z,
						ball_x + direction_x,
						ball_y + direction_y,
						ball_z + direction_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					collision_result = out7 or collision_result
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_result = out7 or collision_result
			surface_type = out8 or surface_type
		end
		if collision_result >= 0 then
			curve_amount = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				gauge_level = 1
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.9))
				velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
				velocity_z = vm.f32(velocity_z * vm.f32(0.9))
				velocity_x = vm.f32(velocity_x + roll_spin_x)
				velocity_z = vm.f32(velocity_z + roll_spin_z)
				roll_spin_x = vm.f32(roll_spin_x * vm.f32(0.8))
				roll_spin_z = vm.f32(roll_spin_z * vm.f32(0.8))
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_id, 5)
					sound_cooldown = 20
				end
			end
			length = event.get_vector_length(roll_spin_x, 0.0, roll_spin_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if not (surface_type == 6) then
					break
				end
				failure_frames = 1
				break
			end
		end
		if ball_y < -500.0 then
			failure_frames = 1
			break
		elseif step_count >= 300 then
			failure_frames = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			pin_offset_x = vm.f32(pin_x - ball_x)
			pin_offset_y = vm.f32(pin_y - ball_y)
			pin_offset_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(pin_offset_x, pin_offset_y, pin_offset_z) or pin_distance
			if ball_color ~= pin_color then
				pin_line_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_line_distance
				if pin_line_distance >= 0.0 and pin_line_distance <= 30.0 then
					pin_hit = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(pin_offset_x, pin_offset_y, pin_offset_z, vm.fdiv(vm.f32(0.6), pin_distance))
							pin_offset_x = out1 or pin_offset_x
							pin_offset_y = out2 or pin_offset_y
							pin_offset_z = out3 or pin_offset_z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, pin_offset_x, pin_offset_y, pin_offset_z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, pin_offset_x, pin_offset_y, pin_offset_z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					pin_hit = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(pin_offset_x, pin_offset_y, pin_offset_z, vm.fdiv(1.0, pin_distance))
						pin_offset_x = out1 or pin_offset_x
						pin_offset_y = out2 or pin_offset_y
						pin_offset_z = out3 or pin_offset_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, pin_offset_x, pin_offset_y, pin_offset_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, pin_offset_x, pin_offset_y, pin_offset_z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
				end
			end
			event.set_character_position(8, ball_x, ball_y, ball_z)
			event.set_character_position(9, ball_x, ball_y, ball_z)
			do
				local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			if ball_y <= fall_limit_y then
				event.set_follow_camera_following(0)
				if failure_frames >= 30 then
					if failure_frames >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				failure_frames = failure_frames + 1
			elseif step_count >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				follow_camera_angle = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or follow_camera_angle
				event.set_follow_camera_angle(follow_camera_angle)
				event.set_follow_camera_target_alternate(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			step_count = step_count + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	vm.wait(16)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if failure_frames == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		if pin_hit == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_id, 17)
			step_count = 0
			while step_count < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step_count = step_count + 1
				vm.wait(17)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			step_count = 0
			while step_count < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step_count = step_count + 1
				vm.wait(18)
			end
			event.set_character_active(0, 11)
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, launch_angle_degrees, 294)
			wait.for_frame_count(54)
			wait.for_frame_count(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_id
			event.stop_music(0)
			event.play_sound_effect(sound_id, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", texture_block)
			event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
			event.set_event_sprite_position(0, 256, 208)
			event.set_event_sprite_size(0, 254, 54)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			object.wait_until_done(0)
			wait.for_frame_count(90)
			vm.wait(23)
			event.play_music(0)
			event.set_character_position(0, golfer_x, golfer_y, golfer_z)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		else
			par_count = event.get_sphida_par() or par_count
			if par_count >= 2 then
				event.set_message_window_mode(0, 5)
				event.set_message_selection_top_line(0, 0)
				choice = dungeon_system_scripts_message.ask_option(0, 2002, 8, 256, 208, 2, 0)
				vm.wait(25)
				if choice == 0 then
					do
						local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
						collision_result = out1 or collision_result
						golfer_x = out2 or golfer_x
						golfer_y = out3 or golfer_y
						golfer_z = out4 or golfer_z
					end
					if collision_result == 0 then
						do
							local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
							golfer_x = out1 or golfer_x
							golfer_y = out2 or golfer_y
							golfer_z = out3 or golfer_z
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(golfer_x, golfer_y, golfer_z)
							pin_x = out1 or pin_x
							pin_y = out2 or pin_y
							pin_z = out3 or pin_z
							collision_result = out4 or collision_result
						end
						step_count = 0
						while collision_result >= 0 do
							do
								local out1, out2, out3 = event.copy_vector(golfer_x, golfer_y, golfer_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, pin_x, pin_y, pin_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.normalize_vector(previous_x, previous_y, previous_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.scale_vector(previous_x, previous_y, previous_z, 32.0)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.copy_vector(pin_x, pin_y, pin_z)
								golfer_x = out1 or golfer_x
								golfer_y = out2 or golfer_y
								golfer_z = out3 or golfer_z
							end
							do
								local out1, out2, out3 = event.add_vectors(golfer_x, golfer_y, golfer_z, previous_x, previous_y, previous_z)
								golfer_x = out1 or golfer_x
								golfer_y = out2 or golfer_y
								golfer_z = out3 or golfer_z
							end
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(golfer_x, golfer_y, golfer_z)
								pin_x = out1 or pin_x
								pin_y = out2 or pin_y
								pin_z = out3 or pin_z
								collision_result = out4 or collision_result
							end
							step_count = step_count + 1
							if step_count > 6 then
								break
							end
						end
					end
					aim_angle = event.get_direction_angle(golfer_x, golfer_y, golfer_z, ball_x, ball_y, ball_z) or aim_angle
					event.set_character_position(0, golfer_x, golfer_y, golfer_z)
					event.set_character_rotation(0, 0.0, aim_angle, 0.0)
					event.set_camera_look_at(golfer_x, golfer_y + 30.0, golfer_z)
					aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
					aim_angle = event.wrap_angle(aim_angle) or aim_angle
					golfer_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + golfer_x)
					golfer_y = vm.f32(golfer_y + 30.0)
					golfer_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + golfer_z)
					event.set_camera_position(golfer_x, golfer_y, golfer_z)
					event.reset_follow_camera(0)
				else
					event.set_character_position(0, golfer_x, golfer_y, golfer_z)
				end
			else
				event.set_character_position(0, golfer_x, golfer_y, golfer_z)
			end
		end
	else
		event.play_sound_effect(sound_id, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", texture_block)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		object.wait_until_done(0)
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.set_sphida_ball_position(ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(8, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(9, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(0, golfer_x, golfer_y, golfer_z)
		event.release_camera_sequence_follow_object()
	end
	if pin_hit == 1 then
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
	else
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_id)
	end
	finish_sphida_turn(pin_hit)
end

--- Asks whether to move the ball to the player's position and, if so, moves it and ends the stroke.
function script.sphida_near_ball()
	local choice: any = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	choice = dungeon_system_scripts_message.ask_option(0, 2004, 8, 256, 208, 2, 0)
	if choice == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.set_sphida_ball_position(ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(8, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(9, ball_x, ball_y + 3.0, ball_z)
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
		event.start_crossfade(15)
	end
end

return script
