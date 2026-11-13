--!strict
--- Holds the Japanese treasure box event helpers.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local dungeon = vm.module("@lib/event/dungeon")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local treasure_box = {}

--- Runs the event for the nearest treasure box, including the mimic warning, lock prompts and item reveal.
function treasure_box.open_nearest()
	local box_flags: s32 = 0
	local first_item: s32 = 0
	local second_item: s32 = 0
	local first_count: s32 = 0
	local second_count: s32 = 0
	local party_npc_id: s32 = 0
	local answer: any = 0
	local revealed: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		do
			local out1, out2, out3, out4, out5 = event.get_nearest_treasure_box_contents()
			box_flags = out1 or box_flags
			first_item = out2 or first_item
			second_item = out3 or second_item
			first_count = out4 or first_count
			second_count = out5 or second_count
		end
		print("-----------------------------------------------------------------------------------------\n")
		print("tbox type = ", box_flags, "\n")
		print("item1 = ", first_item, ", ", first_count, "\n")
		print("item2 = ", second_item, ", ", second_count, "\n")
		print("-----------------------------------------------------------------------------------------\n")
		if bit32.band(box_flags, 256) ~= 0 then
			party_npc_id = event.get_party_npc() or party_npc_id
			if party_npc_id == 9 then
				event.set_dungeon_pause_flags(513, 1)
				character.reset_action_motion()
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(
					0,
					"パウ「ん？ちょっとまて！なんか匂うぞ。\n　　　ミミックかも知れないな、気をつけろ！」"
				)
				resume_point = 1
				message.show_and_wait(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.set_message_window_option(0, 0, 1)
				event.set_message_window_option(0, 1, 1)
				event.open_message_window_2(0, "パウ「それでも開けるのか？」\nはい\nいいえ")
				message.open(0, -1, 5, 0, 0)
				resume_point = 2
				answer = message.choose_option(0, 2, 2, 0)
				event.set_message_selection_top_line(0, 0)
				event.set_message_bubble_tail(0, 1)
				event.set_message_window_option(0, 0, 0)
				event.set_message_window_option(0, 1, 0)
				event.set_dungeon_pause_flags(513, 0)
				if answer == 1 then
				else
					return
				end
			end
			resume_point = 3
			dungeon.spawn_monster_from_chest_with_extra_frames(first_item, first_count)
			return
		end
		event.set_dungeon_pause_flags(513, 1)
		character.reset_action_motion()
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.set_message_window_option(0, 1, 1)
		if bit32.band(box_flags, 2) ~= 0 then
			resume_point = 4
			local t0: s32
			t0, box_flags = inventory.try_open_locked_chest(box_flags)
			if t0 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return
			end
		end
		if bit32.band(box_flags, 4) ~= 0 then
			resume_point = 5
			local t1: s32
			t1, box_flags = inventory.try_open_trapped_chest(box_flags)
			if t1 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return
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
		revealed = 0
		if bit32.band(box_flags, 512) ~= 0 then
			resume_point = 6
			inventory.show_treasure_obtained(-1, -1)
			revealed = 1
		end
		if bit32.band(box_flags, 128) ~= 0 then
			resume_point = 7
			treasure_box.play_clown_reveal(first_item, first_count, second_item, second_count)
			revealed = 1
		end
		if revealed == 0 then
			resume_point = 8
			inventory.show_treasure_obtained(first_item, first_count)
			revealed = 1
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point == 2 then
				answer = received[1] :: number
			end
			if resume_point <= 1 then
				message.open_skipping(0, -1, 5, 0, 0)
				answer = message.resume_choice(0, 2, 2, 0)
			end
			return 0
		end
		if resume_point <= 3 then
			return 0
		end
		if resume_point <= 4 then
			if resume_point == 4 then
				local _ = received[1] :: number
				box_flags = received[2] :: number
			end
			return 0
		end
		if resume_point <= 5 then
			if resume_point == 5 then
				local _ = received[1] :: number
				box_flags = received[2] :: number
			end
			return 0
		end
		if resume_point <= 8 then
			if resume_point <= 6 then
				revealed = 1
				treasure_box.skip_clown_reveal(first_item, first_count, second_item, second_count)
			end
			if resume_point <= 7 then
				revealed = 1
				inventory.resume_obtained_sequence(first_item, first_count)
			end
			local _ = revealed == 0
			revealed = 1
			return first_item
		end
		return nil
	end)
end

--- Plays the clown treasure box cutscene where the player picks one of two boxes and receives its item.
function treasure_box.play_clown_reveal(first_item: s32, first_count: s32, second_item: any, second_count: any)
	local sound_bank: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation_y: f32 = 0
	local lid_open: f32 = 0
	local chosen_box: any = 0
	local random_value: s32 = 0
	local swap_temp: any = 0
	local item_scale: f32 = 0
	local received_item: any = 0
	local overflow_count: s32 = 0
	local receivable_count: s32 = 0
	event.set_dungeon_pause_flags(529, 1)
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_010.sound.json") or sound_bank
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
		world_x = out1 or world_x
		world_y = out2 or world_y
		world_z = out3 or world_z
		world_rotation_y = out4 or world_rotation_y
	end
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation_y)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	inventory.creak_chest_lid_open(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(0, 12)
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 5)
	event.load_character(5, "event/tbox/p00_27a.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(1, 13)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "出現", 5)
	lid_open = inventory.fling_chest_lid_open(lid_open)
	event.play_sound_effect(sound_bank, 0)
	event.play_sound_effect(sound_bank, 1)
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
	wait.for_frame_count(10)
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
	event.play_sound_effect(sound_bank, 2)
	event.set_character_visible(18, 0)
	event.set_character_visible(19, 0)
	wait.for_frame_count(8)
	event.set_character_visible(18, 1, 1, 0.08)
	event.set_character_visible(19, 1, 1, 0.08)
	wait.for_frame_count(10)
	event.set_character_active(0, 14)
	event.set_character_active(0, 15)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	message.show_and_wait(0, 2230, 8, 256, 208)
	message.show_and_wait(0, 2231, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.play_sound_effect(sound_bank, 3)
	local _ = message.open(0, 2232, 8, 0, 0)
	chosen_box = message.choose_option(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	random_value = event.get_random_number_int(100) or random_value
	if vm.imod(random_value, 2) == 0 then
		swap_temp = first_item
		first_item = second_item
		second_item = swap_temp
		swap_temp = first_count
		first_count = second_count
		second_count = swap_temp
	end
	event.load_item_model(5, first_item, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	item_scale = inventory.get_model_fit_scale(16, first_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.load_item_model(5, second_item, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	item_scale = inventory.get_model_fit_scale(17, second_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if chosen_box == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait.for_frame_count(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	event.play_sound_effect(sound_bank, 4)
	event.play_sound_effect(sound_bank, 5)
	wait.for_frame_count(60)
	event.play_sound_effect(sound_bank, 7)
	wait.for_frame_count(6)
	event.play_sound_effect(sound_bank, 6)
	object.wait_until_done(1)
	if chosen_box == 0 then
		receivable_count = event.get_item_limit_status(second_item, second_count) or receivable_count
		if receivable_count >= 1 then
			inventory.show_obtained_message(second_item, receivable_count)
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.set_message_item_name(0, 1, second_item)
			event.open_message_window_2(
				0,
				"『[アイテム１]』をもらったが、\nこれ以上このアイテムは持てなかった。"
			)
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		received_item = second_item
	else
		receivable_count = event.get_item_limit_status(first_item, first_count) or receivable_count
		if receivable_count >= 1 then
			inventory.show_obtained_message(first_item, receivable_count)
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.set_message_item_name(0, 1, first_item)
			event.open_message_window_2(
				0,
				"『[アイテム１]』をもらったが、\nこれ以上このアイテムは持てなかった。"
			)
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		received_item = first_item
	end
	event.set_message_draw_speed(0, 0)
	event.add_inventory_item(received_item, receivable_count)
	overflow_count = event.get_overflow_item_count() or overflow_count
	if overflow_count >= 1 then
		event.fade_out_screen(10)
		wait.for_frame_count(10)
		event.open_event_menu(17)
		vm.wait(23)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(529, 0)
	for index = 0, 7 do
		event.delete_character(12 + index)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Runs the clown treasure box reveal without its animations, showing the choice prompt and the item messages, when the cutscene is skipped.
function treasure_box.skip_clown_reveal(first_item: s32, first_count: s32, second_item: any, second_count: any)
	local index: s32 = 0
	local lid_open: f32 = 0
	local swap_temp: any = 0
	local item_scale: f32 = 0
	local received_count: s32 = 0
	wait.skip_frame_count(15)
	inventory.resume_chest_lid_creak(0)
	wait.skip_frame_count(5)
	wait.background_load_skipping()
	lid_open = inventory.resume_chest_lid_fling(lid_open)
	lid_open = inventory.resume_chest_lid_wobble(lid_open)
	wait.skip_frame_count(10)
	wait.skip_frame_count(8)
	wait.skip_frame_count(10)
	message.show_and_wait_skipping(0, 2230, 8, 256, 208)
	message.show_and_wait_skipping(0, 2231, 8, 256, 208)
	local _ = message.open_skipping(0, 2232, 8, 0, 0)
	local _ = message.resume_choice(0, 2, 0, 1)
	swap_temp = first_item
	first_item = second_item
	second_item = swap_temp
	swap_temp = first_count
	first_count = second_count
	second_count = swap_temp
	item_scale = inventory.resume_model_fit_scale(16, first_item, item_scale)
	item_scale = inventory.resume_model_fit_scale(17, second_item, item_scale)
	wait.skip_frame_count(10)
	wait.skip_frame_count(60)
	wait.skip_frame_count(6)
	cutscene.skip_command(1)
	inventory.resume_obtained_message(second_item, received_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	inventory.resume_obtained_message(first_item, received_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	wait.skip_frame_count(10)
	index = 0
	local _ = index <= 7
	index = index + 1
end

return treasure_box
