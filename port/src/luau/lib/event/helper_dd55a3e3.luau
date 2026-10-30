--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ebb0be6 = require("@lib/event/helper_1ebb0be6")
local helper_2f8ace6d = require("@lib/event/helper_2f8ace6d")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_562b5326 = require("@lib/event/helper_562b5326")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_84fa6e6c = require("@lib/event/helper_84fa6e6c")
local helper_9594e622 = require("@lib/event/helper_9594e622")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_dd55a3e3(arg0: any, count: any, arg2: any, count_2: any)
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: any = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local item_no: any = 0
	local argc: s32 = 0
	local count_2_2: s32 = 0
	event.set_dungeon_pause_flags(529, 1)
	var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_010.sound.json") or var4
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		arg0,
		1,
		arg2,
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
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
		var8 = out4 or var8
	end
	event.set_event_world_coordinate(var5, var6, var7, var8)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait_frames(15)
	helper_84fa6e6c(0)
	wait_frames(5)
	helper_479dc9e9()
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
	var10 = helper_562b5326(var10)
	event.play_sound_effect(var4, 0)
	event.play_sound_effect(var4, 1)
	event.set_character_active(12)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 6)
	event.set_character_active(13)
	event.set_object_sequence_motion(1, "出現", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.clear_camera_sequence()
	event.delay_camera_sequence_position_track(4)
	event.move_camera_sequence_eased(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.move_camera_sequence_eased(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	var10 = helper_1ebb0be6(var10)
	wait_frames(10)
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
	event.play_sound_effect(var4, 2)
	event.set_character_visible(18, 0)
	event.set_character_visible(19, 0)
	wait_frames(8)
	event.set_character_visible(18, 1, 1, 0.08)
	event.set_character_visible(19, 1, 1, 0.08)
	wait_frames(10)
	event.set_character_active(0, 14)
	event.set_character_active(0, 15)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	helper_75684dd8(0, 2230, 8, 256, 208)
	helper_75684dd8(0, 2231, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.play_sound_effect(var4, 3)
	local _ = open_message(0, 2232, 8, 0, 0)
	var11 = helper_39af59c5(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	var13 = vm.float_bits(event.get_random_number(100)) or var13
	if vm.imod(var13, 2) == 0 then
		var14 = arg0
		arg0 = arg2
		arg2 = var14
		var14 = count
		count = count_2
		count_2 = var14
	end
	event.load_item_model(5, arg0, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	var15 = helper_2f8ace6d(16, arg0, var15)
	event.set_object_handle_scale(6, var15, var15, var15)
	event.load_item_model(5, arg2, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	var15 = helper_2f8ace6d(17, arg2, var15)
	event.set_object_handle_scale(6, var15, var15, var15)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if var11 == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait_frames(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	event.play_sound_effect(var4, 4)
	event.play_sound_effect(var4, 5)
	wait_frames(60)
	event.play_sound_effect(var4, 7)
	wait_frames(6)
	event.play_sound_effect(var4, 6)
	wait_objects(1)
	if var11 == 0 then
		count_2_2 = event.get_item_limit_status(arg2, count_2) or count_2_2
		if count_2_2 >= 1 then
			helper_9594e622(arg2, count_2_2)
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.set_message_item_name(0, 1, arg2)
			event.open_message_window_2(0, "You received [アイテム１],\nbut you didn't have any room left.")
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		item_no = arg2
	else
		count_2_2 = event.get_item_limit_status(arg0, count) or count_2_2
		if count_2_2 >= 1 then
			helper_9594e622(arg0, count_2_2)
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			event.set_message_item_name(0, 1, arg0)
			event.open_message_window_2(0, "You received [アイテム１],\nbut you didn't have any room left.")
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		item_no = arg0
	end
	event.set_message_draw_speed(0, 0)
	event.add_inventory_item(item_no, count_2_2)
	argc = event.get_overflow_item_count() or argc
	if argc >= 1 then
		event.fade_out_screen(10)
		wait_frames(10)
		event.open_event_menu(17)
		vm.wait(23)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(529, 0)
	for var9 = 0, 7 do
		event.delete_character(12 + var9)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.start_crossfade(10)
	event.finish_event()
end

return helper_dd55a3e3
