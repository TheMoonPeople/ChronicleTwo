--!strict
--- French treasure chest scenes: unlocking a locked chest and presenting the found item.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local dungeon = vm.module("@lib/event/dungeon")
local flag = vm.module("@lib/event/flag")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local treasure_chest = {}

--- Plays the chest clown event that offers a big and a small chest holding the two items in random order and grants the item in the chosen chest.
function treasure_chest.offer_big_or_small(first_item_id: any, first_item_count: any, second_item_id: any, second_item_count: any)
	local sound_id: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_rotation: f32 = 0
	local lid_open: f32 = 0
	local chosen_chest: any = 0
	local random_value: s32 = 0
	local swap_temp: s32 = 0
	local model_scale: f32 = 0
	local received_item_id: any = 0
	local overflow_count: s32 = 0
	local received_count: s32 = 0
	event.set_dungeon_pause_flags(529, 1)
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_010.sound.json") or sound_id
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		first_item_id,
		1,
		second_item_id,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_41a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		event_x = out1 or event_x
		event_y = out2 or event_y
		event_z = out3 or event_z
		event_rotation = out4 or event_rotation
	end
	event.set_event_world_coordinate(event_x, event_y, event_z, event_rotation)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.frames(15)
	inventory.creak_chest_lid_open(0)
	wait.frames(5)
	wait.background_load()
	event.load_character(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(0, 12)
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 5)
	event.load_character(5, "event/tbox/p00_41a.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(1, 13)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "出現", 5)
	lid_open = inventory.fling_chest_lid_open(lid_open)
	event.play_sound_effect(sound_id, 0)
	event.play_sound_effect(sound_id, 1)
	event.set_character_active(12)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 6)
	event.set_character_active(13)
	event.set_object_sequence_motion(1, "出現", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.clear_camera_sequence()
	event.delay_camera_sequence_position_track(4)
	event.move_camera_sequence_eased(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.move_camera_sequence_eased(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	lid_open = inventory.open_treasure_box_lid(lid_open)
	wait.frames(10)
	event.set_character_active(0, 12)
	event.load_character(5, "event/tbox/p00_27a_ex_r.gltf", "info", 14)
	event.set_character_active(14)
	event.set_character_position(14, 0.0, 0.0, 0.0)
	event.set_character_rotation(14, 0.0, 0.0, 0.0)
	event.set_character_motion(14, "宝箱発生（右手）", 6)
	event.attach_character_to_frame(13, "s_pre", 14)
	event.load_character(5, "event/tbox/p00_27a_ex_l.gltf", "info", 15)
	event.set_character_active(15)
	event.set_character_position(15, 0.0, 0.0, 0.0)
	event.set_character_rotation(15, 0.0, 0.0, 0.0)
	event.set_character_motion(15, "宝箱出現（左手）", 6)
	event.attach_character_to_frame(13, "b_pre", 15)
	event.load_character(5, "event/tbox/r_box.gltf", "info", 18)
	event.set_character_active(18)
	event.set_character_position(18, 0.0, 0.0, 0.0)
	event.set_character_rotation(18, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(13, "s_pre", 18)
	event.set_scene_character_type(18, 4)
	event.load_character(5, "event/tbox/l_box.gltf", "info", 19)
	event.set_character_active(19)
	event.set_character_position(19, 0.0, 0.0, 0.0)
	event.set_character_rotation(19, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(13, "b_pre", 19)
	event.set_scene_character_type(19, 4)
	event.play_sound_effect(sound_id, 2)
	event.set_character_visible(18, 0)
	event.set_character_visible(19, 0)
	wait.frames(8)
	event.set_character_visible(18, 1, 1, 0.08)
	event.set_character_visible(19, 1, 1, 0.08)
	wait.frames(10)
	event.set_character_active(0, 14)
	event.set_character_active(0, 15)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	message.show_and_wait(0, 2230, 8, 256, 208)
	message.show_and_wait(0, 2231, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.play_sound_effect(sound_id, 3)
	local _ = message.open(0, 2232, 8, 0, 0)
	chosen_chest = message.choose_option(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	random_value = event.get_random_number_int(100) or random_value
	if vm.imod(random_value, 2) == 0 then
		swap_temp = first_item_id
		first_item_id = second_item_id
		second_item_id = swap_temp
		swap_temp = first_item_count
		first_item_count = second_item_count
		second_item_count = swap_temp
	end
	event.load_item_model(5, first_item_id, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	model_scale = inventory.get_model_fit_scale(16, first_item_id, model_scale)
	event.set_object_handle_scale(6, model_scale, model_scale, model_scale)
	event.load_item_model(5, second_item_id, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	model_scale = inventory.get_model_fit_scale(17, second_item_id, model_scale)
	event.set_object_handle_scale(6, model_scale, model_scale, model_scale)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if chosen_chest == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait.frames(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	event.play_sound_effect(sound_id, 4)
	event.play_sound_effect(sound_id, 5)
	wait.frames(60)
	event.play_sound_effect(sound_id, 7)
	wait.frames(6)
	event.play_sound_effect(sound_id, 6)
	object.wait_until_done(1)
	if chosen_chest == 0 then
		received_count = event.get_item_limit_status(second_item_id, second_item_count) or received_count
		if received_count >= 1 then
			inventory.show_obtained_message(second_item_id, received_count)
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.set_message_item_name(0, 1, second_item_id)
			event.open_message_window_2(0, "Tu as re[UNI00e7]u [アイテム１],\nmais il n'y avait plus de place.")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		received_item_id = second_item_id
	else
		received_count = event.get_item_limit_status(first_item_id, first_item_count) or received_count
		if received_count >= 1 then
			inventory.show_obtained_message(first_item_id, received_count)
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.set_message_item_name(0, 1, first_item_id)
			event.open_message_window_2(0, "Tu as re[UNI00e7]u [アイテム１],\nmais il n'y avait plus de place.")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		received_item_id = first_item_id
	end
	event.set_message_draw_speed(0, 0)
	event.add_inventory_item(received_item_id, received_count)
	overflow_count = event.get_overflow_item_count() or overflow_count
	if overflow_count >= 1 then
		event.fade_out_screen(10)
		wait.frames(10)
		event.open_event_menu(17)
		vm.wait(23)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(529, 0)
	for i = 0, 7 do
		event.delete_character(12 + i)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Opens the nearest treasure chest: spawns a mimic when flagged, runs the lock and trap prompts, and gives the item reward or the big-or-small offer, returning the first item.
function treasure_chest.open_nearest()
	local box_flags: s32 = 0
	local first_item_id: s32 = 0
	local second_item_id: s32 = 0
	local first_item_count: s32 = 0
	local second_item_count: s32 = 0
	local partner_id: s32 = 0
	local confirm_choice: any = 0
	local reward_given: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		do
			local out1, out2, out3, out4, out5 = event.get_nearest_treasure_box_contents()
			box_flags = out1 or box_flags
			first_item_id = out2 or first_item_id
			second_item_id = out3 or second_item_id
			first_item_count = out4 or first_item_count
			second_item_count = out5 or second_item_count
		end
		print("-----------------------------------------------------------------------------------------\n")
		print("tbox type = ", box_flags, "\n")
		print("item1 = ", first_item_id, ", ", first_item_count, "\n")
		print("item2 = ", second_item_id, ", ", second_item_count, "\n")
		print("-----------------------------------------------------------------------------------------\n")
		if bit32.band(box_flags, 256) ~= 0 then
			partner_id = event.get_party_npc() or partner_id
			if partner_id == 9 then
				event.set_dungeon_pause_flags(513, 1)
				character.reset_action_motion()
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(0, "Euh attends ! Y'a un truc bizarre !\n      Attention, on dirait un Simili !")
				resume_step = 1
				message.show_and_wait(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.set_message_window_option(0, 0, 1)
				event.set_message_window_option(0, 1, 1)
				event.open_message_window_2(0, "Tu veux toujours l'ouvrir ?\nOui.\nNon.")
				message.open(0, -1, 5, 0, 0)
				resume_step = 2
				confirm_choice = message.choose_option(0, 2, 2, 0)
				event.set_message_selection_top_line(0, 0)
				event.set_message_bubble_tail(0, 1)
				event.set_message_window_option(0, 0, 0)
				event.set_message_window_option(0, 1, 0)
				event.set_dungeon_pause_flags(513, 0)
				if confirm_choice == 1 then
				else
					return 0
				end
			end
			resume_step = 3
			dungeon.spawn_monster_from_chest(first_item_id, first_item_count)
			return 0
		end
		event.set_dungeon_pause_flags(513, 1)
		character.reset_action_motion()
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.set_message_window_option(0, 1, 1)
		if bit32.band(box_flags, 2) ~= 0 then
			resume_step = 4
			local lock_gave_up: s32
			lock_gave_up, box_flags = treasure_chest.unlock_treasure_chest(box_flags)
			if lock_gave_up ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return 0
			end
		end
		if bit32.band(box_flags, 4) ~= 0 then
			resume_step = 5
			local trap_gave_up: s32
			trap_gave_up, box_flags = inventory.try_open_trapped_chest(box_flags)
			if trap_gave_up ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return 0
			end
		end
		event.set_message_selection_top_line(0, 0)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 1, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.start_crossfade(30)
		event.show_dungeon_status_bar(0, 0.16666667)
		event.set_character_active(0, 0)
		reward_given = 0
		if bit32.band(box_flags, 512) ~= 0 then
			resume_step = 6
			treasure_chest.show_found_item(-1, -1)
			reward_given = 1
		end
		if bit32.band(box_flags, 128) ~= 0 then
			resume_step = 7
			treasure_chest.offer_big_or_small(first_item_id, first_item_count, second_item_id, second_item_count)
			reward_given = 1
		end
		if reward_given == 0 then
			resume_step = 8
			treasure_chest.show_found_item(first_item_id, first_item_count)
			reward_given = 1
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		return first_item_id
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step == 2 then
				confirm_choice = received[1] :: number
			end
			if resume_step <= 1 then
				message.open_skipping(0, -1, 5, 0, 0)
				confirm_choice = message.resume_choice(0, 2, 2, 0)
			end
			return 0
		end
		if resume_step <= 3 then
			return 0
		end
		if resume_step <= 4 then
			if resume_step == 4 then
				local _ = received[1] :: number
				box_flags = received[2] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step == 5 then
				local _ = received[1] :: number
				box_flags = received[2] :: number
			end
			return 0
		end
		if resume_step <= 8 then
			if resume_step <= 6 then
				reward_given = 1
				inventory.play_choice_treasure_box_skipping(first_item_id, first_item_count, second_item_id, second_item_count)
			end
			if resume_step <= 7 then
				reward_given = 1
				inventory.resume_obtained_sequence_skipping(first_item_id, first_item_count)
			end
			local _ = reward_given == 0
			reward_given = 1
			return first_item_id
		end
		return nil
	end)
end

--- Plays the treasure chest opening scene, then announces the found item or that the inventory has no room for it.
function treasure_chest.show_found_item(item: s32, count: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local lid_open: f32 = 0
	local item_scale: f32 = 0
	local item_limit_status: s32 = 0
	local overflow_item_count: s32 = 0
	local granted_count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_trial_version: s32 = 0
	local stage_id: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(535, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
			world_x = out1 or world_x
			world_y = out2 or world_y
			world_z = out3 or world_z
			world_rotation = out4 or world_rotation
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		step = 1
		vm.wait(1)
		if item >= 0 then
			event.start_background_file_loads_3(item, 1, "effect/itemget.gltf")
		else
			event.start_background_file_loads_1("effect/itemget.gltf")
		end
		event.set_nearest_treasure_box_lid_open(0.0)
		event.set_nearest_treasure_box_state(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 29.0, 57.0)
		event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
		event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
		step = 2
		wait.frames(15)
		step = 3
		inventory.creak_chest_lid_open(0)
		step = 4
		wait.frames(5)
		step = 5
		wait.background_load()
		event.load_character(5, "effect/itemget.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(1, 12)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "ゲット", 6)
		step = 6
		wait.frames(5)
		step = 7
		lid_open = inventory.fling_chest_lid_open(lid_open)
		if item >= 0 then
			event.load_item_model(5, item, "info", 13, 1)
			event.set_character_active(1, 13)
			event.attach_object_handle_to_character(0, 13)
			item_scale = inventory.get_weapon_display_scale(13, item, item_scale)
			event.set_object_handle_scale(0, item_scale, item_scale, item_scale)
			event.set_character_visible(13, 1, 1, 0.1)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 0.0, -2.5, 0.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.delay_object_sequence_position_track(0, 4)
			event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.3, 20)
			event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.4, 8)
			event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.2, 5)
		end
		step = 8
		lid_open = inventory.open_treasure_box_lid(lid_open)
		step = 9
		camera.wait_until_done()
		if item >= 0 then
			item_limit_status = 0
			overflow_item_count = 0
			granted_count = event.get_item_limit_status(item, count) or granted_count
			if granted_count >= 1 then
				event.add_inventory_item(item, granted_count)
				step = 10
				inventory.show_obtained_message(item, granted_count)
			else
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				event.set_message_item_name(0, 1, item)
				event.open_message_window_2(0, "Tu as trouv[UNI00e9] [アイテム１],\nmais il n'y avait plus de place.")
				step = 11
				message.show_and_wait(0, -1, 8, 0, 0)
				event.set_message_draw_speed(0, 0)
			end
			item_limit_status = event.get_item_limit_status() or item_limit_status
			overflow_item_count = event.get_overflow_item_count() or overflow_item_count
			print("CHECK_GET_ITEM_LIMIT = ", item_limit_status, "\n")
			print("CHECK_ITEM_OVER      = ", overflow_item_count, "\n")
			if overflow_item_count >= 1 then
				event.fade_out_screen(10)
				step = 12
				wait.frames(10)
				event.open_event_menu(17)
				step = 13
				vm.wait(13)
			end
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			step = 14
			message.show_and_wait(0, 2240, 8, 0, 0)
			event.set_message_draw_speed(0, 0)
		end
		event.set_character_active(1, 0)
		event.delete_character(12)
		event.delete_character(13)
		event.set_nearest_treasure_box_lid_open(1.0)
		event.start_crossfade(10)
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_position(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_look_at(position_x, position_y, position_z)
		event.reset_follow_camera(0)
		is_trial_version = event.is_trial_version() or is_trial_version
		stage_id = event.get_dungeon_stage_id() or stage_id
		if item == 306 and (stage_id == 0 or is_trial_version == 1) then
			event.set_message_window_mode(0, 4)
			step = 15
			message.show_and_wait(0, 2250, 8, 0, 0)
		end
		event.set_dungeon_pause_flags(535, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 15 then
			if step == 7 then
				lid_open = received[2] :: number
			end
			if step == 8 then
				lid_open = received[2] :: number
			end
			if step <= 1 then
				wait.frames_skipping(15)
			end
			if step <= 2 then
				inventory.resume_chest_lid_creak(0)
			end
			if step <= 3 then
				wait.frames_skipping(5)
			end
			if step <= 4 then
				wait.background_load_skipping()
			end
			if step <= 5 then
				wait.frames_skipping(5)
			end
			if step <= 6 then
				lid_open = inventory.resume_chest_lid_fling(lid_open)
			end
			if step <= 7 then
				item_scale = inventory.resume_model_scale(13, item, item_scale)
				lid_open = inventory.resume_chest_lid_wobble(lid_open)
			end
			if step <= 8 then
				wait.background_load_skipping()
			end
			if step <= 9 then
				item_limit_status = 0
				overflow_item_count = 0
				inventory.resume_obtained_message(item, granted_count)
			end
			if step <= 10 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if step <= 11 then
				print("CHECK_GET_ITEM_LIMIT = ", item_limit_status, "\n")
				print("CHECK_ITEM_OVER      = ", overflow_item_count, "\n")
				wait.frames_skipping(10)
			end
			if step <= 13 then
				message.show_and_wait_skipping(0, 2240, 8, 0, 0)
			end
			if step <= 14 then
				message.show_and_wait_skipping(0, 2250, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Lets the player open a locked treasure chest with Donny, a key item or force, applies the penalties flagged on the chest, and returns whether it stays locked with the updated chest flags.
function treasure_chest.unlock_treasure_chest(chest_flags: s32)
	local selection: any = 0
	local still_locked: s32 = 0
	local party_npc: s32 = 0
	local used_item: s32 = 0
	local playable_character: s32 = 0
	local chest_x: f32 = 0
	local chest_y: f32 = 0
	local chest_z: f32 = 0
	local sound_id: s32 = 0
	local step: number = 0
	return vm.guard(function()
		party_npc = event.get_party_npc() or party_npc
		if party_npc == 4 then
			event.open_message_window_2(
				0,
				"Le coffre semble verrouill[UNI00e9].\nLe faire ouvrir par Donny.\nLe forcer.\nLaisser tomber."
			)
			message.open(0, -1, 5, 0, 0)
		else
			message.open(0, 2220, 5, 0, 0)
		end
		step = 1
		selection = message.choose_option(0, 3, 3, 0)
		if selection == 1 then
			if party_npc == 4 then
				event.open_message_window_2(0, "Tr[UNI00e8]s bien ! Je m'en charge !")
				step = 2
				message.show_and_wait(0, -1, 5, 0, 0)
				chest_flags = flag.clear_bits(chest_flags, 2)
				still_locked = 0
			else
				event.show_dungeon_status_bar(0, 0.16666667)
				step = 3
				wait.frames(6)
				event.open_use_item_menu(297)
				step = 4
				vm.wait(4)
				used_item = vmhost.used_item() or used_item
				if used_item == 297 then
					chest_flags = flag.clear_bits(chest_flags, 2)
					still_locked = 0
				elseif used_item <= 0 then
					still_locked = 1
				else
					step = 5
					character.shake_head()
					still_locked = 1
				end
				event.show_dungeon_status_bar(1, 0.16666667)
			end
		end
		if selection == 2 then
			event.play_system_sound_effect(24)
			event.set_message_selection_top_line(0, 0)
			if bit32.band(chest_flags, 8) ~= 0 then
				playable_character = event.get_playable_character() or playable_character
				if playable_character == 0 or playable_character == 2 then
					step = 6
					message.show_and_wait(0, 2215, 5, 0, 0)
					event.set_character_status(0, 1, 0)
					event.add_character_hp_by_rate(0, -0.7)
				else
					step = 7
					message.show_and_wait(0, 2216, 5, 0, 0)
					event.set_character_status(1, 1, 0)
					event.add_character_hp_by_rate(1, -0.7)
				end
				still_locked = 0
			end
			if bit32.band(chest_flags, 16) ~= 0 then
				step = 8
				message.show_and_wait(0, 2211, 5, 0, 0)
				event.set_nearest_treasure_box_state(0)
				do
					local out1, out2, out3, _ = event.get_dungeon_event_point(1)
					chest_x = out1 or chest_x
					chest_y = out2 or chest_y
					chest_z = out3 or chest_z
				end
				sound_id = event.get_sound_id(4) or sound_id
				event.play_sound_effect(sound_id, 11)
				event.create_dungeon_effect("爆発", chest_x, chest_y + 4.0, chest_z, 5)
				still_locked = 1
			end
			if bit32.band(chest_flags, 32) ~= 0 then
				step = 9
				message.show_and_wait(0, 2212, 5, 0, 0)
				event.add_battle_weapon_durability(0, -999)
				event.add_battle_weapon_durability(1, -999)
				still_locked = 0
			end
			chest_flags = flag.clear_bits(chest_flags, 2)
		end
		if selection == -1 or selection == 3 then
			still_locked = 1
		end
		return still_locked, chest_flags
	end, function(received: { any })
		if step <= 9 then
			if step == 1 then
				selection = received[1] :: number
			end
			if step <= 1 then
				message.show_and_wait_skipping(0, -1, 5, 0, 0)
			end
			if step <= 2 then
				chest_flags = flag.resume_clear_bits(chest_flags, 2)
				still_locked = 0
				wait.frames_skipping(6)
			end
			if step <= 4 then
				chest_flags = flag.resume_clear_bits(chest_flags, 2)
				still_locked = 0
				still_locked = 1
				character.resume_shake_head()
			end
			if step <= 5 then
				still_locked = 1
				message.show_and_wait_skipping(0, 2215, 5, 0, 0)
			end
			if step <= 6 then
				message.show_and_wait_skipping(0, 2216, 5, 0, 0)
			end
			if step <= 7 then
				still_locked = 0
				message.show_and_wait_skipping(0, 2211, 5, 0, 0)
			end
			if step <= 8 then
				still_locked = 1
				message.show_and_wait_skipping(0, 2212, 5, 0, 0)
			end
			still_locked = 0
			local _ = bit32.band(chest_flags, 8)
			local _ = bit32.band(chest_flags, 16)
			local _ = bit32.band(chest_flags, 32)
			chest_flags = flag.resume_clear_bits(chest_flags, 2)
			still_locked = 1
			return still_locked, chest_flags
		end
		return nil, chest_flags
	end)
end

return treasure_chest
