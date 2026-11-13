--!strict
--- Treasure chest helpers for the dungeon system scripts: lid animation, opening sounds and the clown chest event.

local vm = require("@lib/vm")
local dungeon_system_scripts_message = vm.module("@lib/event/dungeon_system_scripts_message")
local dungeon_system_scripts_sound = vm.module("@lib/event/dungeon_system_scripts_sound")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local dungeon_system_scripts_item = {}

--- Returns the scale that fits an item model to a character's hand.
function dungeon_system_scripts_item.get_item_display_scale(character: s32, item: any, scale: f32)
	local fit_scale: f32 = 0
	event.get_item_weapon_category(item)
	fit_scale = event.get_character_fit_scale(character, 8.0) or fit_scale
	fit_scale = vm.f32(fit_scale * vm.f32(0.6))
	scale = fit_scale
	return scale
end

--- Lifts the nearest treasure box lid slowly and plays the stage opening sound.
function dungeon_system_scripts_item.open_treasure_lid(unused_value: any)
	local frame: s32 = 0
	local lid_open: f32 = 0
	local sound_id: s32 = 0
	local sound_number: s32 = 0
	frame = 0
	lid_open = 0.0
	while frame <= 5 do
		event.set_nearest_treasure_box_lid_open(lid_open)
		lid_open = vm.f32(lid_open + vm.f32(0.01))
		frame = frame + 1
		vm.wait(1)
	end
	sound_number = dungeon_system_scripts_sound.get_stage_sound_number()
	sound_id = event.get_sound_id(3) or sound_id
	event.play_sound_effect(sound_id, sound_number)
	frame = 0
	while frame <= 4 do
		event.set_nearest_treasure_box_lid_open(lid_open)
		lid_open = vm.f32(lid_open - vm.f32(0.004))
		frame = frame + 1
		vm.wait(2)
	end
end

--- Flips the nearest treasure box lid open over eleven frames and returns the final opening amount.
function dungeon_system_scripts_item.open_treasure_lid_fast(lid_open: f32)
	local frame: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		frame = 0
		lid_open = vm.f32(0.04)
		while frame <= 10 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + vm.f32(0.18))
			frame = frame + 1
			resume_step = 1
			vm.wait(1)
		end
		return lid_open
	end, function(received: { any })
		if resume_step <= 1 then
			return 0, lid_open
		end
		return nil, lid_open
	end)
end

--- Plays the clown treasure chest event where the player picks between a large and a small chest holding two items.
function dungeon_system_scripts_item.play_clown_chest_event(item_a: any, item_b: s32)
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local lid_open: f32 = 0
	local selected_chest: any = 0
	local random_number: s32 = 0
	local swap_item: any = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		item_a,
		1,
		item_b,
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
		event_x = out1 or event_x
		event_y = out2 or event_y
		event_z = out3 or event_z
		event_angle = out4 or event_angle
	end
	event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
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
	lid_open = dungeon_system_scripts_item.open_treasure_lid_fast(lid_open)
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
	dungeon_system_scripts_message.show_and_wait(0, 2200, 8, 256, 208)
	dungeon_system_scripts_message.show_and_wait(0, 2210, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	local _ = message.open(0, 2220, 8, 0, 0)
	selected_chest = dungeon_system_scripts_message.select_option(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	random_number = event.get_random_number_int(100) or random_number
	if vm.imod(random_number, 2) == 0 then
		swap_item = item_a
		item_a = item_b
		item_b = swap_item
	end
	event.load_item_model(5, item_a, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(16, item_a, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.load_item_model(5, item_b, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(17, item_b, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if selected_chest == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait.for_frame_count(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	object.wait_until_done(1)
	if selected_chest == 0 then
		dungeon_system_scripts_message.show_item_obtained(item_b, 1)
		event.add_inventory_item(item_b, 1)
	else
		dungeon_system_scripts_message.show_item_obtained(item_a, 1)
		event.add_inventory_item(item_a, 1)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(17, 0)
	for i = 0, 7 do
		event.delete_character(12 + i)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

return dungeon_system_scripts_item
