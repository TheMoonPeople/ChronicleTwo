--!strict
--- Handles items, weapons and treasure boxes.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local dungeon = vm.module("@lib/event/dungeon")
local flag = vm.module("@lib/event/flag")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local inventory = {}

--- Shows the item-received message for an item and count after playing the system sound, doing nothing for a count below one.
function inventory.announce_received(item_id: s32, count: s32)
	local message_id: s32 = 0
	local sound_id: s32 = 0
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	message_id = -1
	if count <= 0 then
		return
	end
	if count == 1 then
		message_id = 10
		event.set_message_item_name(1, 1, item_id)
	end
	if 1 < count then
		message_id = 11
		event.set_message_item_name(1, 1, item_id)
		event.set_message_number(1, 2, count)
	end
	if message_id == -1 then
		return
	end
	sound_id = event.get_system_sound_id() or sound_id
	event.play_sound_effect(sound_id, 18)
	message.show(1, message_id, 8, 0, 0)
end

--- Slowly raises the nearest chest lid, plays the chest-opening sound and lets the lid sink back slightly.
function inventory.creak_chest_lid_open(unused: any)
	local step: s32 = 0
	local lid_open: f32 = 0
	local sound_id: s32 = 0
	local voice_number: s32 = 0
	step = 0
	lid_open = 0.0
	while step <= 5 do
		event.set_nearest_treasure_box_lid_open(lid_open)
		lid_open = vm.f32(lid_open + vm.f32(0.01))
		step = step + 1
		vm.wait(1)
	end
	voice_number = sound.get_chest_open_voice()
	sound_id = event.get_sound_id(3) or sound_id
	event.play_sound_effect(sound_id, voice_number)
	step = 0
	while step <= 4 do
		event.set_nearest_treasure_box_lid_open(lid_open)
		lid_open = vm.f32(lid_open - vm.f32(0.004))
		step = step + 1
		vm.wait(2)
	end
end

--- Swings the nearest treasure chest lid open in eleven frames and returns the final openness.
function inventory.fling_chest_lid_open(lid_open: f32)
	local step: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		step = 0
		lid_open = vm.f32(0.04)
		while step <= 10 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + vm.f32(0.13))
			step = step + 1
			resume_point = 1
			vm.wait(1)
		end
		return lid_open
	end, function(received: { any })
		if resume_point <= 1 then
			return 0, lid_open
		end
		return nil, lid_open
	end)
end

--- Returns the scale that fits an item model to a character.
function inventory.get_model_fit_scale(character_slot: s32, item_id: any, scale: f32)
	local fit_scale: f32 = 0
	event.get_item_weapon_category(item_id)
	fit_scale = event.get_character_fit_scale(character_slot, 4.0) or fit_scale
	scale = fit_scale
	return scale
end

--- Returns the scale that fits a character to a size of 6, halved when the weapon's category is 0, 2 or 4.
function inventory.get_weapon_display_scale(character_id: s32, item_id: s32, scale: f32)
	local weapon_category: s32 = 0
	local fit_scale: f32 = 0
	weapon_category = event.get_item_weapon_category(item_id) or weapon_category
	fit_scale = event.get_character_fit_scale(character_id, 6.0) or fit_scale
	if weapon_category == 0 then
		fit_scale = vm.f32(fit_scale / 2.0)
	end
	if weapon_category == 2 then
		fit_scale = vm.f32(fit_scale / 2.0)
	end
	if weapon_category == 4 then
		fit_scale = vm.f32(fit_scale / 2.0)
	end
	scale = fit_scale
	return scale
end

--- Adds the inventory items granted up to the given story stage and, from stage 3, adds party member 1 with character switching enabled.
function inventory.grant_stage_supplies(stage: s32)
	if stage >= 2 then
		event.add_inventory_item(296, 2)
		event.add_inventory_item(388, 1)
	end
	if stage >= 3 then
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.add_inventory_item(296, 4)
		event.add_inventory_item(388, 2)
		event.add_inventory_item(389, 2)
	end
	if stage >= 4 then
		event.add_inventory_item(296, 8)
		event.add_inventory_item(388, 3)
		event.add_inventory_item(389, 3)
	end
	if stage >= 5 then
		event.add_inventory_item(296, 8)
		event.add_inventory_item(388, 3)
		event.add_inventory_item(389, 3)
	end
	if stage >= 6 then
		event.add_inventory_item(296, 8)
		event.add_inventory_item(388, 4)
		event.add_inventory_item(389, 4)
	end
	if stage >= 7 then
		event.add_inventory_item(296, 10)
		event.add_inventory_item(388, 5)
		event.add_inventory_item(389, 5)
	end
end

--- Opens the item overflow event menu for the current main loop mode when the item limit is reached or items have overflowed.
function inventory.open_overflow_menu()
	local limit_status: s32 = 0
	local overflow_count: s32 = 0
	local main_loop_mode: s32 = 0
	limit_status = event.get_item_limit_status() or limit_status
	overflow_count = event.get_overflow_item_count() or overflow_count
	if limit_status >= 1 or overflow_count >= 1 then
		main_loop_mode = event.get_main_loop_mode() or main_loop_mode
		if main_loop_mode == 1 then
			event.open_event_menu(16)
			vm.wait(1)
			return
		end
		if main_loop_mode == 2 then
			event.open_event_menu(17)
			vm.wait(2)
			return
		end
	end
end

--- Opens the nearest treasure box, running the mimic warning and pre-open checks before the reward scene.
function inventory.open_treasure_box()
	local box_flags: s32 = 0
	local first_item: s32 = 0
	local second_item: s32 = 0
	local first_count: s32 = 0
	local second_count: s32 = 0
	local party_npc_id: s32 = 0
	local confirm_choice: any = 0
	local reward_shown: s32 = 0
	local progress_stage: number = 0
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
				progress_stage = 1
				message.show_and_wait(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.set_message_window_option(0, 0, 1)
				event.set_message_window_option(0, 1, 1)
				event.open_message_window_2(0, "パウ「それでも開けるのか？」\nはい\nいいえ")
				message.open(0, -1, 5, 0, 0)
				progress_stage = 2
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
			progress_stage = 3
			dungeon.spawn_monster_from_chest_with_extra_frames(first_item, first_count)
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
			progress_stage = 4
			local t0: s32
			t0, box_flags = inventory.try_open_locked_chest(box_flags)
			if t0 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return 0
			end
		end
		if bit32.band(box_flags, 4) ~= 0 then
			progress_stage = 5
			local t1: s32
			t1, box_flags = inventory.try_open_trapped_chest(box_flags)
			if t1 ~= 0 then
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
		reward_shown = 0
		if bit32.band(box_flags, 512) ~= 0 then
			progress_stage = 6
			inventory.show_treasure_obtained(-1, -1)
			reward_shown = 1
		end
		if bit32.band(box_flags, 128) ~= 0 then
			progress_stage = 7
			inventory.play_choice_treasure_box(first_item, first_count, second_item, second_count)
			reward_shown = 1
		end
		if reward_shown == 0 then
			progress_stage = 8
			inventory.show_treasure_obtained(first_item, first_count)
			reward_shown = 1
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		return first_item
	end, function(received: { any })
		if progress_stage <= 2 then
			if progress_stage == 2 then
				confirm_choice = received[1] :: number
			end
			if progress_stage <= 1 then
				message.open_skipping(0, -1, 5, 0, 0)
				confirm_choice = message.resume_choice(0, 2, 2, 0)
			end
			return 0
		end
		if progress_stage <= 3 then
			return 0
		end
		if progress_stage <= 4 then
			if progress_stage == 4 then
				local _ = received[1] :: number
				box_flags = received[2] :: number
			end
			return 0
		end
		if progress_stage <= 5 then
			if progress_stage == 5 then
				local _ = received[1] :: number
				box_flags = received[2] :: number
			end
			return 0
		end
		if progress_stage <= 8 then
			if progress_stage <= 6 then
				reward_shown = 1
				inventory.resume_choice_treasure_box(first_item, first_count, second_item, second_count)
			end
			if progress_stage <= 7 then
				reward_shown = 1
				inventory.resume_obtained_sequence(first_item, first_count)
			end
			local _ = reward_shown == 0
			reward_shown = 1
			return first_item
		end
		return nil
	end)
end

--- Animates the nearest treasure box lid opening from the given opening amount with a settling bounce.
function inventory.open_treasure_box_lid(lid_open: f32)
	local i: s32 = 0
	local velocity: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		i = 0
		while i < 10 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + vm.f32(0.18))
			i = i + 1
			resume_step = 1
			vm.wait(1)
		end
		i = 0
		velocity = vm.f32(0.06)
		while i <= 6 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open - velocity)
			velocity = vm.f32(velocity - vm.f32(0.008))
			i = i + 1
			resume_step = 2
			vm.wait(2)
		end
		i = 0
		velocity = vm.f32(0.005)
		while i <= 8 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + velocity)
			velocity = vm.f32(velocity + vm.f32(0.01))
			i = i + 1
			resume_step = 3
			vm.wait(3)
		end
		i = 0
		velocity = vm.f32(0.03)
		while i <= 6 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open - velocity)
			velocity = vm.f32(velocity - vm.f32(0.005))
			i = i + 1
			resume_step = 4
			vm.wait(4)
		end
		i = 0
		velocity = vm.f32(0.01)
		while i <= 4 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + velocity)
			velocity = vm.f32(velocity + vm.f32(0.01))
			i = i + 1
			resume_step = 5
			vm.wait(5)
		end
		return lid_open
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step <= 1 then
				i = 0
				velocity = vm.f32(0.06)
				lid_open = vm.f32(lid_open - velocity)
				velocity = vm.f32(velocity - vm.f32(0.008))
				local _ = i <= 6
				i = i + 1
			end
			if resume_step <= 2 then
				i = 0
				velocity = vm.f32(0.005)
				lid_open = vm.f32(lid_open + velocity)
				velocity = vm.f32(velocity + vm.f32(0.01))
				local _ = i <= 8
				i = i + 1
			end
			if resume_step <= 3 then
				i = 0
				velocity = vm.f32(0.03)
				lid_open = vm.f32(lid_open - velocity)
				velocity = vm.f32(velocity - vm.f32(0.005))
				local _ = i <= 6
				i = i + 1
			end
			if resume_step <= 4 then
				i = 0
				velocity = vm.f32(0.01)
				lid_open = vm.f32(lid_open + velocity)
				velocity = vm.f32(velocity + vm.f32(0.01))
				local _ = i <= 4
				i = i + 1
			end
			return 0, lid_open
		end
		return nil, lid_open
	end)
end

--- Plays the clown treasure box scene in which the player picks the large or small box holding one of two items, then grants the chosen item.
function inventory.play_choice_treasure_box(first_item: any, first_count: any, second_item: any, second_count: any)
	local sound_bank: s32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_rotation_y: f32 = 0
	local scratch_value: f32 = 0
	local chosen_box_size: any = 0
	local random_value: s32 = 0
	local swap_temp: s32 = 0
	local model_scale: f32 = 0
	local granted_item: any = 0
	local overflow_item_count: s32 = 0
	local granted_count: s32 = 0
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
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
		point_rotation_y = out4 or point_rotation_y
	end
	event.set_event_world_coordinate(point_x, point_y, point_z, point_rotation_y)
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
	scratch_value = inventory.fling_chest_lid_open(scratch_value)
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
	scratch_value = inventory.open_treasure_box_lid(scratch_value)
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
	chosen_box_size = message.choose_option(0, 2, 0, 1)
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
	model_scale = inventory.get_model_fit_scale(16, first_item, model_scale)
	event.set_object_handle_scale(6, model_scale, model_scale, model_scale)
	event.load_item_model(5, second_item, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	model_scale = inventory.get_model_fit_scale(17, second_item, model_scale)
	event.set_object_handle_scale(6, model_scale, model_scale, model_scale)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if chosen_box_size == 0 then
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
	if chosen_box_size == 0 then
		granted_count = event.get_item_limit_status(second_item, second_count) or granted_count
		if granted_count >= 1 then
			inventory.show_obtained_message(second_item, granted_count)
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
		granted_item = second_item
	else
		granted_count = event.get_item_limit_status(first_item, first_count) or granted_count
		if granted_count >= 1 then
			inventory.show_obtained_message(first_item, granted_count)
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
		granted_item = first_item
	end
	event.set_message_draw_speed(0, 0)
	event.add_inventory_item(granted_item, granted_count)
	overflow_item_count = event.get_overflow_item_count() or overflow_item_count
	if overflow_item_count >= 1 then
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

--- Replays the second half of the choice treasure box scene with skip-mode frame waits.
function inventory.play_choice_treasure_box_skipping(first_item: any, first_count: any, second_item: any, second_count: any)
	local index: s32 = 0
	local scratch_value: f32 = 0
	local swap_temp: s32 = 0
	local model_scale: f32 = 0
	local granted_count: s32 = 0
	wait.frames_skipping(15)
	inventory.resume_chest_lid_creak(0)
	wait.frames_skipping(5)
	wait.background_load_skipping()
	scratch_value = inventory.resume_chest_lid_fling(scratch_value)
	scratch_value = inventory.resume_chest_lid_wobble(scratch_value)
	wait.frames_skipping(10)
	wait.frames_skipping(8)
	wait.frames_skipping(10)
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
	model_scale = inventory.resume_model_fit_scale(16, first_item, model_scale)
	model_scale = inventory.resume_model_fit_scale(17, second_item, model_scale)
	wait.frames_skipping(10)
	wait.frames_skipping(60)
	wait.frames_skipping(6)
	cutscene.skip_command(1)
	inventory.resume_obtained_message(second_item, granted_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	inventory.resume_obtained_message(first_item, granted_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	wait.frames_skipping(10)
	index = 0
	local _ = index <= 7
	index = index + 1
end

--- Opens the item-limit or overflow menu for the current loop mode when the inventory is over its limit, optionally fading around it.
function inventory.resolve_overflow(fade_screen: s32)
	local item_limit_status: s32 = 0
	local overflow_count: s32 = 0
	local loop_mode: s32 = 0
	item_limit_status = event.get_item_limit_status() or item_limit_status
	overflow_count = event.get_overflow_item_count() or overflow_count
	if item_limit_status >= 1 or overflow_count >= 1 then
		if fade_screen == 1 then
			event.fade_out_screen(10)
			wait.for_frame_count(10)
		end
		loop_mode = event.get_main_loop_mode() or loop_mode
		if loop_mode == 1 then
			event.open_event_menu(16)
			vm.wait(2)
		end
		if loop_mode == 2 then
			event.open_event_menu(17)
			vm.wait(3)
		end
		if fade_screen == 1 then
			event.fade_in_screen(10)
		end
	end
end

--- Opens the item-limit or overflow menu for the current loop mode when the inventory is over its limit, optionally fading around it using the standard frame wait.
function inventory.resolve_overflow_alt(fade_screen: s32)
	local item_limit_status: s32 = 0
	local overflow_count: s32 = 0
	local loop_mode: s32 = 0
	item_limit_status = event.get_item_limit_status() or item_limit_status
	overflow_count = event.get_overflow_item_count() or overflow_count
	if item_limit_status >= 1 or overflow_count >= 1 then
		if fade_screen == 1 then
			event.fade_out_screen(10)
			wait.frames(10)
		end
		loop_mode = event.get_main_loop_mode() or loop_mode
		if loop_mode == 1 then
			event.open_event_menu(16)
			vm.wait(2)
		end
		if loop_mode == 2 then
			event.open_event_menu(17)
			vm.wait(3)
		end
		if fade_screen == 1 then
			event.fade_in_screen(10)
		end
	end
end

--- Resume-path counterpart of creak_chest_lid_open.
function inventory.resume_chest_lid_creak(unused: any)
	local step: s32 = 0
	local lid_open: f32 = 0
	step = 0
	lid_open = 0.0
	lid_open = vm.f32(lid_open + vm.f32(0.01))
	local _ = step <= 5
	step = step + 1
	local _ = cutscene.get_fixed_value_skipping()
	step = 0
	lid_open = vm.f32(lid_open - vm.f32(0.004))
	local _ = step <= 4
	step = step + 1
end

--- Resume-path counterpart of fling_chest_lid_open; returns the final lid openness.
function inventory.resume_chest_lid_fling(lid_open: f32)
	local step: s32 = 0
	step = 0
	lid_open = vm.f32(0.04)
	lid_open = vm.f32(lid_open + vm.f32(0.13))
	local _ = step <= 10
	step = step + 1
	return lid_open
end

--- Resume-path counterpart of the chest lid settling wobble; returns the final lid openness.
function inventory.resume_chest_lid_wobble(lid_open: f32)
	local step: s32 = 0
	local lid_delta: f32 = 0
	step = 0
	lid_open = vm.f32(lid_open + vm.f32(0.18))
	local _ = step < 10
	step = step + 1
	step = 0
	lid_delta = vm.f32(0.06)
	lid_open = vm.f32(lid_open - lid_delta)
	lid_delta = vm.f32(lid_delta - vm.f32(0.008))
	local _ = step <= 6
	step = step + 1
	step = 0
	lid_delta = vm.f32(0.005)
	lid_open = vm.f32(lid_open + lid_delta)
	lid_delta = vm.f32(lid_delta + vm.f32(0.01))
	local _ = step <= 8
	step = step + 1
	step = 0
	lid_delta = vm.f32(0.03)
	lid_open = vm.f32(lid_open - lid_delta)
	lid_delta = vm.f32(lid_delta - vm.f32(0.005))
	local _ = step <= 6
	step = step + 1
	step = 0
	lid_delta = vm.f32(0.01)
	lid_open = vm.f32(lid_open + lid_delta)
	lid_delta = vm.f32(lid_delta + vm.f32(0.01))
	local _ = step <= 4
	step = step + 1
	return lid_open
end

--- Replays the second half of the choice treasure box scene on the resume path, without waiting.
function inventory.resume_choice_treasure_box(first_item: any, first_count: any, second_item: any, second_count: any)
	local index: s32 = 0
	local scratch_value: f32 = 0
	local swap_temp: s32 = 0
	local model_scale: f32 = 0
	local granted_count: s32 = 0
	wait.skip_frame_count(15)
	inventory.resume_chest_lid_creak(0)
	wait.skip_frame_count(5)
	wait.background_load_skipping()
	scratch_value = inventory.resume_chest_lid_fling(scratch_value)
	scratch_value = inventory.resume_chest_lid_wobble(scratch_value)
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
	model_scale = inventory.resume_model_fit_scale(16, first_item, model_scale)
	model_scale = inventory.resume_model_fit_scale(17, second_item, model_scale)
	wait.skip_frame_count(10)
	wait.skip_frame_count(60)
	wait.skip_frame_count(6)
	cutscene.skip_command(1)
	inventory.resume_obtained_message(second_item, granted_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	inventory.resume_obtained_message(first_item, granted_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	wait.skip_frame_count(10)
	index = 0
	local _ = index <= 7
	index = index + 1
end

--- Resume-path version of an item exchange sequence of two items using skippable frame waits.
function inventory.resume_exchange_skipping(item_a: s32, count_a: s32, item_b: any, count_b: any)
	local i: s32 = 0
	local lid_open: f32 = 0
	local swap_temp: any = 0
	local model_scale: f32 = 0
	local obtained_count: s32 = 0
	wait.frames_skipping(15)
	inventory.resume_chest_lid_creak(0)
	wait.frames_skipping(5)
	wait.background_load_skipping()
	lid_open = inventory.resume_chest_lid_fling(lid_open)
	lid_open = inventory.resume_chest_lid_wobble(lid_open)
	wait.frames_skipping(10)
	wait.frames_skipping(8)
	wait.frames_skipping(10)
	message.show_and_wait_skipping(0, 2230, 8, 256, 208)
	message.show_and_wait_skipping(0, 2231, 8, 256, 208)
	local _ = message.open_skipping(0, 2232, 8, 0, 0)
	local _ = message.resume_choice(0, 2, 0, 1)
	swap_temp = item_a
	item_a = item_b
	item_b = swap_temp
	swap_temp = count_a
	count_a = count_b
	count_b = swap_temp
	model_scale = inventory.resume_model_fit_scale(16, item_a, model_scale)
	model_scale = inventory.resume_model_fit_scale(17, item_b, model_scale)
	wait.frames_skipping(10)
	wait.frames_skipping(60)
	wait.frames_skipping(6)
	cutscene.skip_command(1)
	inventory.resume_obtained_message(item_b, obtained_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	inventory.resume_obtained_message(item_a, obtained_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	wait.frames_skipping(10)
	i = 0
	local _ = i <= 7
	i = i + 1
end

--- Resume-path counterpart of get_model_fit_scale.
function inventory.resume_model_fit_scale(character_slot: s32, item_id: any, scale: f32)
	local fit_scale: f32 = 0
	scale = fit_scale
	return scale
end

--- Resume-path counterpart of the item model fit scale computation.
function inventory.resume_model_scale(character_slot: s32, item_id: any, scale: f32)
	local fit_scale: f32 = 0
	fit_scale = vm.f32(fit_scale / 2.0)
	fit_scale = vm.f32(fit_scale / 2.0)
	fit_scale = vm.f32(fit_scale / 2.0)
	scale = fit_scale
	return scale
end

--- Resume-path counterpart of show_obtained_message that only sets up the item window.
function inventory.resume_obtained_message(item_id: any, count: s32)
	message.set_window_mode_skipping(1, 4)
end

--- Resume-path version of the treasure pickup sequence with its waits expressed as plain frame waits.
function inventory.resume_obtained_sequence(item_id: s32, count: s32)
	local lid_open: f32 = 0
	local model_scale: f32 = 0
	local limit_status: s32 = 0
	local overflow_count: s32 = 0
	local obtained_count: s32 = 0
	wait.skip_frame_count(15)
	inventory.resume_chest_lid_creak(0)
	wait.skip_frame_count(5)
	wait.background_load_skipping()
	wait.skip_frame_count(5)
	lid_open = inventory.resume_chest_lid_fling(lid_open)
	model_scale = inventory.resume_model_scale(13, item_id, model_scale)
	lid_open = inventory.resume_chest_lid_wobble(lid_open)
	wait.background_load_skipping()
	limit_status = 0
	overflow_count = 0
	inventory.resume_obtained_message(item_id, obtained_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	print("CHECK_GET_ITEM_LIMIT = ", limit_status, "\n")
	print("CHECK_ITEM_OVER      = ", overflow_count, "\n")
	wait.skip_frame_count(10)
	message.show_and_wait_skipping(0, 2240, 8, 0, 0)
	message.show_and_wait_skipping(0, 2250, 8, 0, 0)
end

--- Resume-path version of the treasure pickup sequence using skippable frame waits.
function inventory.resume_obtained_sequence_skipping(item_id: s32, count: s32)
	local lid_open: f32 = 0
	local model_scale: f32 = 0
	local limit_status: s32 = 0
	local overflow_count: s32 = 0
	local obtained_count: s32 = 0
	wait.frames_skipping(15)
	inventory.resume_chest_lid_creak(0)
	wait.frames_skipping(5)
	wait.background_load_skipping()
	wait.frames_skipping(5)
	lid_open = inventory.resume_chest_lid_fling(lid_open)
	model_scale = inventory.resume_model_scale(13, item_id, model_scale)
	lid_open = inventory.resume_chest_lid_wobble(lid_open)
	wait.background_load_skipping()
	limit_status = 0
	overflow_count = 0
	inventory.resume_obtained_message(item_id, obtained_count)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	print("CHECK_GET_ITEM_LIMIT = ", limit_status, "\n")
	print("CHECK_ITEM_OVER      = ", overflow_count, "\n")
	wait.frames_skipping(10)
	message.show_and_wait_skipping(0, 2240, 8, 0, 0)
	message.show_and_wait_skipping(0, 2250, 8, 0, 0)
end

--- Shows the message that an item (with a count) was obtained, with a sound effect.
function inventory.show_obtained_message(item_id: any, count: s32)
	local text_id: s32 = 0
	local sound_id: s32 = 0
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	text_id = -1
	if count <= 0 then
		return
	end
	if count == 1 then
		text_id = 10
		event.set_message_item_name(1, 1, item_id)
	end
	if 1 < count then
		text_id = 11
		event.set_message_item_name(1, 1, item_id)
		event.set_message_number(1, 2, count)
	end
	if text_id == -1 then
		return
	end
	sound_id = event.get_system_sound_id() or sound_id
	event.play_sound_effect(sound_id, 18)
	message.show_and_wait(1, text_id, 8, 0, 0)
end

--- Shows the obtained message for an item, with its count when above one, and plays the system sound. Takes the item as an integer id.
function inventory.show_obtained_message_for_item_id(item_id: s32, count: s32)
	local message_id: s32 = 0
	local system_sound_id: s32 = 0
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	message_id = -1
	if count <= 0 then
		return
	end
	if count == 1 then
		message_id = 10
		event.set_message_item_name(1, 1, item_id)
	end
	if 1 < count then
		message_id = 11
		event.set_message_item_name(1, 1, item_id)
		event.set_message_number(1, 2, count)
	end
	if message_id == -1 then
		return
	end
	system_sound_id = event.get_system_sound_id() or system_sound_id
	event.play_sound_effect(system_sound_id, 18)
	message.show_and_wait(1, message_id, 8, 0, 0)
end

--- Plays the chest-opening sequence, adds the item to the inventory and shows the obtained or inventory-full messages.
function inventory.show_treasure_obtained(item_id: s32, count: s32)
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_angle: f32 = 0
	local lid_open: f32 = 0
	local model_scale: f32 = 0
	local limit_status: s32 = 0
	local overflow_count: s32 = 0
	local obtainable_count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_trial_version: s32 = 0
	local stage_id: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(535, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
			event_point_x = out1 or event_point_x
			event_point_y = out2 or event_point_y
			event_point_z = out3 or event_point_z
			event_point_angle = out4 or event_point_angle
		end
		event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_angle)
		resume_point = 1
		vm.wait(1)
		if item_id >= 0 then
			event.start_background_file_loads_3(item_id, 1, "effect/itemget.gltf")
		else
			event.start_background_file_loads_1("effect/itemget.gltf")
		end
		event.set_nearest_treasure_box_lid_open(0.0)
		event.set_nearest_treasure_box_state(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 29.0, 57.0)
		event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
		event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
		resume_point = 2
		wait.for_frame_count(15)
		resume_point = 3
		inventory.creak_chest_lid_open(0)
		resume_point = 4
		wait.for_frame_count(5)
		resume_point = 5
		wait.background_load()
		event.load_character(5, "effect/itemget.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(1, 12)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "ゲット", 6)
		resume_point = 6
		wait.for_frame_count(5)
		resume_point = 7
		lid_open = inventory.fling_chest_lid_open(lid_open)
		if item_id >= 0 then
			event.load_item_model(5, item_id, "info", 13, 1)
			event.set_character_active(1, 13)
			event.attach_object_handle_to_character(0, 13)
			model_scale = inventory.get_weapon_display_scale(13, item_id, model_scale)
			event.set_object_handle_scale(0, model_scale, model_scale, model_scale)
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
		resume_point = 8
		lid_open = inventory.open_treasure_box_lid(lid_open)
		resume_point = 9
		camera.wait_until_done()
		if item_id >= 0 then
			limit_status = 0
			overflow_count = 0
			obtainable_count = event.get_item_limit_status(item_id, count) or obtainable_count
			if obtainable_count >= 1 then
				event.add_inventory_item(item_id, obtainable_count)
				resume_point = 10
				inventory.show_obtained_message(item_id, obtainable_count)
			else
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				event.set_message_item_name(0, 1, item_id)
				event.open_message_window_2(
					0,
					"『[アイテム１]』を見つけたが、\nこれ以上このアイテムは持てなかった。"
				)
				resume_point = 11
				message.show_and_wait(0, -1, 8, 0, 0)
				event.set_message_draw_speed(0, 0)
			end
			limit_status = event.get_item_limit_status() or limit_status
			overflow_count = event.get_overflow_item_count() or overflow_count
			print("CHECK_GET_ITEM_LIMIT = ", limit_status, "\n")
			print("CHECK_ITEM_OVER      = ", overflow_count, "\n")
			if overflow_count >= 1 then
				event.fade_out_screen(10)
				resume_point = 12
				wait.for_frame_count(10)
				event.open_event_menu(17)
				resume_point = 13
				vm.wait(13)
			end
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			resume_point = 14
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
		if item_id == 306 and (stage_id == 0 or is_trial_version == 1) then
			event.set_message_window_mode(0, 4)
			resume_point = 15
			message.show_and_wait(0, 2250, 8, 0, 0)
		end
		event.set_dungeon_pause_flags(535, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_point <= 15 then
			if resume_point == 7 then
				lid_open = received[2] :: number
			end
			if resume_point == 8 then
				lid_open = received[2] :: number
			end
			if resume_point <= 1 then
				wait.skip_frame_count(15)
			end
			if resume_point <= 2 then
				inventory.resume_chest_lid_creak(0)
			end
			if resume_point <= 3 then
				wait.skip_frame_count(5)
			end
			if resume_point <= 4 then
				wait.background_load_skipping()
			end
			if resume_point <= 5 then
				wait.skip_frame_count(5)
			end
			if resume_point <= 6 then
				lid_open = inventory.resume_chest_lid_fling(lid_open)
			end
			if resume_point <= 7 then
				model_scale = inventory.resume_model_scale(13, item_id, model_scale)
				lid_open = inventory.resume_chest_lid_wobble(lid_open)
			end
			if resume_point <= 8 then
				wait.background_load_skipping()
			end
			if resume_point <= 9 then
				limit_status = 0
				overflow_count = 0
				inventory.resume_obtained_message(item_id, obtainable_count)
			end
			if resume_point <= 10 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if resume_point <= 11 then
				print("CHECK_GET_ITEM_LIMIT = ", limit_status, "\n")
				print("CHECK_ITEM_OVER      = ", overflow_count, "\n")
				wait.skip_frame_count(10)
			end
			if resume_point <= 13 then
				message.show_and_wait_skipping(0, 2240, 8, 0, 0)
			end
			if resume_point <= 14 then
				message.show_and_wait_skipping(0, 2250, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Stands in for announce_received when events are skipped, only setting up the item message window and ignoring the item and count.
function inventory.skip_announce_received(item_id: any, count: s32)
	message.set_window_mode_stub(1, 4)
end

--- Offers the ways of opening a locked treasure chest and applies the outcome of the chosen one.
function inventory.try_open_locked_chest(trap_flags: s32)
	local choice: any = 0
	local outcome: s32 = 0
	local party_npc: s32 = 0
	local used_item_id: s32 = 0
	local playable_character: s32 = 0
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local sound_id: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		party_npc = event.get_party_npc() or party_npc
		if party_npc == 4 then
			event.open_message_window_2(
				0,
				"宝箱にはカギがかかっているようだ。\nドニーに開けてもらう。\n強引に開けてみる。\nあきらめる。"
			)
			message.open(0, -1, 5, 0, 0)
		else
			message.open(0, 2220, 5, 0, 0)
		end
		resume_point = 1
		choice = message.choose_option(0, 3, 3, 0)
		if choice == 1 then
			if party_npc == 4 then
				event.open_message_window_2(0, "ドニー「よし！まかせろ！！」")
				resume_point = 2
				message.show_and_wait(0, -1, 5, 0, 0)
				trap_flags = flag.clear_bits(trap_flags, 2)
				outcome = 0
			else
				event.show_dungeon_status_bar(0, 0.16666667)
				resume_point = 3
				wait.for_frame_count(6)
				event.open_use_item_menu(297)
				resume_point = 4
				vm.wait(4)
				used_item_id = vmhost.used_item() or used_item_id
				if used_item_id == 297 then
					trap_flags = flag.clear_bits(trap_flags, 2)
					outcome = 0
				elseif used_item_id <= 0 then
					outcome = 1
				else
					resume_point = 5
					character.shake_head()
					outcome = 1
				end
				event.show_dungeon_status_bar(1, 0.16666667)
			end
		end
		if choice == 2 then
			event.play_system_sound_effect(24)
			event.set_message_selection_top_line(0, 0)
			if bit32.band(trap_flags, 8) ~= 0 then
				playable_character = event.get_playable_character() or playable_character
				if playable_character == 0 or playable_character == 2 then
					resume_point = 6
					message.show_and_wait(0, 2215, 5, 0, 0)
					event.set_character_status(0, 1, 0)
					event.add_character_hp_by_rate(0, -0.7)
				else
					resume_point = 7
					message.show_and_wait(0, 2216, 5, 0, 0)
					event.set_character_status(1, 1, 0)
					event.add_character_hp_by_rate(1, -0.7)
				end
				outcome = 0
			end
			if bit32.band(trap_flags, 16) ~= 0 then
				resume_point = 8
				message.show_and_wait(0, 2211, 5, 0, 0)
				event.set_nearest_treasure_box_state(0)
				do
					local out1, out2, out3, _ = event.get_dungeon_event_point(1)
					event_point_x = out1 or event_point_x
					event_point_y = out2 or event_point_y
					event_point_z = out3 or event_point_z
				end
				sound_id = event.get_sound_id(4) or sound_id
				event.play_sound_effect(sound_id, 11)
				event.create_dungeon_effect("爆発", event_point_x, event_point_y + 4.0, event_point_z, 5)
				outcome = 1
			end
			if bit32.band(trap_flags, 32) ~= 0 then
				resume_point = 9
				message.show_and_wait(0, 2212, 5, 0, 0)
				event.add_battle_weapon_durability(0, -999)
				event.add_battle_weapon_durability(1, -999)
				outcome = 0
			end
			trap_flags = flag.clear_bits(trap_flags, 2)
		end
		if choice == -1 or choice == 3 then
			outcome = 1
		end
		return outcome, trap_flags
	end, function(received: { any })
		if resume_point <= 9 then
			if resume_point == 1 then
				choice = received[1] :: number
			end
			if resume_point <= 1 then
				message.show_and_wait_skipping(0, -1, 5, 0, 0)
			end
			if resume_point <= 2 then
				trap_flags = flag.resume_clear_bits(trap_flags, 2)
				outcome = 0
				wait.skip_frame_count(6)
			end
			if resume_point <= 4 then
				trap_flags = flag.resume_clear_bits(trap_flags, 2)
				outcome = 0
				outcome = 1
				character.resume_shake_head()
			end
			if resume_point <= 5 then
				outcome = 1
				message.show_and_wait_skipping(0, 2215, 5, 0, 0)
			end
			if resume_point <= 6 then
				message.show_and_wait_skipping(0, 2216, 5, 0, 0)
			end
			if resume_point <= 7 then
				outcome = 0
				message.show_and_wait_skipping(0, 2211, 5, 0, 0)
			end
			if resume_point <= 8 then
				outcome = 1
				message.show_and_wait_skipping(0, 2212, 5, 0, 0)
			end
			outcome = 0
			local _ = bit32.band(trap_flags, 8)
			local _ = bit32.band(trap_flags, 16)
			local _ = bit32.band(trap_flags, 32)
			trap_flags = flag.resume_clear_bits(trap_flags, 2)
			outcome = 1
			return outcome, trap_flags
		end
		return nil, trap_flags
	end)
end

--- Offers three ways of opening a trapped treasure chest and applies the trap or the damage the chosen way causes.
function inventory.try_open_trapped_chest(trap_flags: s32)
	local choice: any = 0
	local outcome: s32 = 0
	local choice_mask: s32 = 0
	local index: s32 = 0
	local playable_character: s32 = 0
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local sound_id: s32 = 0
	local weapon_owner: s32 = 0
	local weapon_absorption: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		message.open(0, 2200, 5, 0, 0)
		resume_point = 1
		choice = message.choose_option(0, 4, 4, 0)
		if choice == 1 then
			outcome = 0
		end
		if choice == 2 then
			outcome = 0
		end
		if choice == 3 then
			outcome = 0
		end
		if choice == -1 or choice == 4 then
			outcome = 1
		end
		if outcome ~= 1 then
			choice_mask = 8
			index = 1
			while index < choice do
				choice_mask = vm.i32(choice_mask * 2)
				index = vm.i32(index + 1)
			end
			event.set_message_selection_top_line(0, 0)
			if vm.i32(bit32.band(trap_flags, choice_mask)) ~= 0 then
				resume_point = 2
				message.show_and_wait(0, 2213, 5, 0, 0)
				outcome = 0
			else
				event.play_system_sound_effect(24)
				if bit32.band(trap_flags, 8) ~= 0 then
					playable_character = event.get_playable_character() or playable_character
					if playable_character == 0 or playable_character == 2 then
						resume_point = 3
						message.show_and_wait(0, 2215, 5, 0, 0)
						event.set_character_status(0, 1, 0)
						event.add_character_hp_by_rate(0, -0.7)
					else
						resume_point = 4
						message.show_and_wait(0, 2216, 5, 0, 0)
						event.set_character_status(1, 1, 0)
						event.add_character_hp_by_rate(1, -0.7)
					end
					outcome = 1
				end
				if bit32.band(trap_flags, 16) ~= 0 then
					resume_point = 5
					message.show_and_wait(0, 2211, 5, 0, 0)
					event.set_nearest_treasure_box_state(0)
					do
						local out1, out2, out3, _ = event.get_dungeon_event_point(1)
						event_point_x = out1 or event_point_x
						event_point_y = out2 or event_point_y
						event_point_z = out3 or event_point_z
					end
					sound_id = event.get_sound_id(4) or sound_id
					event.play_sound_effect(sound_id, 11)
					event.create_dungeon_effect("爆発", event_point_x, event_point_y + 4.0, event_point_z, 5)
					outcome = 1
				end
				if bit32.band(trap_flags, 32) ~= 0 then
					weapon_owner = event.get_playable_character() or weapon_owner
					if weapon_owner == 3 then
						weapon_owner = 1
					end
					event.add_weapon_durability(weapon_owner, 0, -999)
					event.add_weapon_durability(weapon_owner, 1, -999)
					do
						local _, out2 = event.get_weapon_absorption(weapon_owner, 0)
						weapon_absorption = out2 or weapon_absorption
					end
					event.add_weapon_absorption(weapon_owner, 0, vm.idiv(vm.i32(-weapon_absorption), 10))
					do
						local _, out2 = event.get_weapon_absorption(weapon_owner, 1)
						weapon_absorption = out2 or weapon_absorption
					end
					event.add_weapon_absorption(weapon_owner, 1, vm.idiv(vm.i32(-weapon_absorption), 10))
					resume_point = 6
					message.show_and_wait(0, 2212, 5, 0, 0)
					outcome = 1
				end
			end
		end
		return outcome, trap_flags
	end, function(received: { any })
		if resume_point <= 6 then
			if resume_point == 1 then
				choice = received[1] :: number
			end
			if resume_point <= 1 then
				outcome = 0
				outcome = 0
				outcome = 0
				outcome = 1
				choice_mask = 8
				index = 1
				choice_mask = choice_mask * 2
				local _ = index < choice
				index = index + 1
				message.show_and_wait_skipping(0, 2213, 5, 0, 0)
			end
			if resume_point <= 2 then
				local _ = outcome ~= 1
				outcome = 0
				message.show_and_wait_skipping(0, 2215, 5, 0, 0)
			end
			if resume_point <= 3 then
				message.show_and_wait_skipping(0, 2216, 5, 0, 0)
			end
			if resume_point <= 4 then
				outcome = 1
				message.show_and_wait_skipping(0, 2211, 5, 0, 0)
			end
			if resume_point <= 5 then
				outcome = 1
				local _ = weapon_owner == 3
				weapon_owner = 1
				message.show_and_wait_skipping(0, 2212, 5, 0, 0)
			end
			outcome = 1
			return outcome, trap_flags
		end
		return nil, trap_flags
	end)
end

return inventory
