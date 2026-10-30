--!strict
-- dungeon/sys_script/d03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_06cb41a2 = require("@lib/event/helper_06cb41a2")
local helper_0e90ac27 = require("@lib/event/helper_0e90ac27")
local helper_1ebb0be6 = require("@lib/event/helper_1ebb0be6")
local helper_214de41f = require("@lib/event/helper_214de41f")
local helper_25d46bcc = require("@lib/event/helper_25d46bcc")
local helper_2a0361d4 = require("@lib/event/helper_2a0361d4")
local helper_2f6f8a35 = require("@lib/event/helper_2f6f8a35")
local helper_32de9d65 = require("@lib/event/helper_32de9d65")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_3cf99f2c = require("@lib/event/helper_3cf99f2c")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_558828de = require("@lib/event/helper_558828de")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_649c18cd = require("@lib/event/helper_649c18cd")
local helper_66f07360 = require("@lib/event/helper_66f07360")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7c78bc02 = require("@lib/event/helper_7c78bc02")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_975c8257 = require("@lib/event/helper_975c8257")
local helper_998c6893 = require("@lib/event/helper_998c6893")
local helper_99d04251 = require("@lib/event/helper_99d04251")
local helper_baa247a4 = require("@lib/event/helper_baa247a4")
local helper_bb794e6a = require("@lib/event/helper_bb794e6a")
local helper_c0fce92c = require("@lib/event/helper_c0fce92c")
local helper_d1646134 = require("@lib/event/helper_d1646134")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e6c23a00 = require("@lib/event/helper_e6c23a00")
local helper_f033341e = require("@lib/event/helper_f033341e")
local helper_f51aa7a3 = require("@lib/event/helper_f51aa7a3")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local helper_fd3a2124 = require("@lib/event/helper_fd3a2124")
local helper_fd9c4774 = require("@lib/event/helper_fd9c4774")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_417b4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
		var3 = out4 or var3
	end
	var3 = vm.f32(var3 + vm.f32(1.5707964))
	if var3 > vm.f32(3.1415927) then
		var3 = vm.f32(var3 - vm.f32(6.2831855))
	end
	event.set_event_world_coordinate(var0, var1, var2, var3)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -85.0, 0.0, 50.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_sequence_motion(0, "歩き")
	event.set_object_handle_footstep_sound(0, 16)
	event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d02.json", 0)
	event.set_event_image_texture(0, "logo_d02")
	event.set_event_image_source_rect(0, 0, 0, 384, 128)
	event.set_event_image_screen_rect(0, -24, 300, 384, 128)
	event.set_event_image_color(0, 128, 128, 128, 0)
	event.set_event_image_visible(1, 0)
	event.fade_event_image(0, 1, 30)
	event.clear_camera_sequence()
	event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
	event.set_camera_sequence_angle_height_distance(1.57, 5.0, 160.0)
	event.set_object_sequence_motion(0, "歩き")
	event.move_object_sequence(0, -170.0, 0.0, 50.0, 90)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30)
	helper_888ab2a3(30)
	event.fade_event_image(0, 1, 30)
	helper_888ab2a3(30)
	event.fade_event_image(0, 0, 30)
	wait_camera()
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(30)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Event 1000, which map data, a script or the engine runs by number.
local function event_1000()
	local var1: s32 = 0
	local var2: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	event.open_dungeon_floor_map(2)
	vm.wait(1)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var1 = 2
	event.set_dungeon_stage_id(var1)
	event.set_dungeon_floor(var2)
	helper_d1646134(var1, var2)
	if var2 == 23 then
		event.load_dungeon_map("d03b02")
		event.load_event_script("d03b02/d03b02.stb", 200)
		return
	else
		if var2 >= 1 and var2 <= 7 then
			event.load_dungeon_map("d03f01", "d03f01", 6)
		end
		if var2 >= 9 and var2 <= 14 or var2 >= 16 and var2 <= 17 then
			event.load_dungeon_map("d03f02")
		end
		if var2 >= 19 and var2 <= 22 then
			event.load_dungeon_map("d03f03")
		end
		if var2 == 0 then
			event.load_dungeon_map("d03f01")
		end
		if var2 == 8 then
			event.load_dungeon_map("s17")
			event.load_event_script("s17/s17.stb", 200)
			return
		end
		if var2 == 15 then
			event.load_dungeon_map("d03f02")
		end
		if var2 == 18 then
			event.load_dungeon_map("d03f02")
		end
		event.place_treasure_box_at_event_point(-1)
		event.load_dungeon_monster(0)
		event.place_dungeon_monster(-1)
		helper_417b4()
		event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
	end
end

--- Helper function.
local function helper_44d34()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local rot_x: f32 = 0
	local var5: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
		var3 = out4 or var3
	end
	event.set_event_world_coordinate(var0, var1, var2, var3)
	event.attach_object_handle_to_map_part_3(0, "way38", "d02w10_4-m0")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(1, "way38", "d02w10_3-m0")
	event.set_object_handle_visible(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.load_character(5, "effect/g01_gkey.chr", "info", 8)
	event.set_character_active(8)
	event.attach_object_handle_to_character(2, 8)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_position(2, -160.0, 0.0, 15.0)
	event.set_object_sequence_motion(2, "発動", 5)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.26, 47.33, -135.06)
	event.set_camera_sequence_look_at(-157.89, 18.41, 5.19)
	helper_888ab2a3(30)
	event.set_object_handle_visible(2, 1)
	event.set_object_sequence_motion(2, "発動", 6)
	event.wait_object_sequence_motion_end(2)
	helper_888ab2a3(40)
	event.set_object_handle_visible(0, 0)
	wait_objects(2)
	var5 = vm.f32(0.001)
	rot_x = 0.0
	while rot_x < vm.f32(1.57) do
		event.set_object_sequence_rotation(1, rot_x, 0.0, 0.0)
		var5 = vm.f32(var5 * vm.f32(1.06))
		rot_x = vm.f32(rot_x + var5)
		vm.wait(4)
	end
	for var6 = 0, 2 do
		while true do
			var5 = vm.f32(var5 * vm.f32(0.6))
			rot_x = vm.f32(rot_x - var5)
			event.set_object_sequence_rotation(1, rot_x, 0.0, 0.0)
			if var5 < vm.f32(0.001) then
				break
			else
				vm.wait(5)
			end
		end
		var5 = vm.f32(var5 + vm.f32(0.001))
		while true do
			var5 = vm.f32(var5 * vm.f32(1.2))
			rot_x = vm.f32(rot_x + var5)
			event.set_object_sequence_rotation(1, rot_x, 0.0, 0.0)
			if rot_x > vm.f32(1.57) then
				break
			else
				vm.wait(6)
			end
		end
	end
	helper_888ab2a3(30)
	event.delete_character(8)
	event.finish_event()
	event_1000()
end

--- Helper function.
local function helper_46c98()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
		var3 = out4 or var3
	end
	event.set_event_world_coordinate(var0, var1, var2, var3)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -158.37, 0.0, -21.16)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち")
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.26, 47.33, -135.06)
	event.set_camera_sequence_look_at(-157.89, 18.41, 5.19)
	event.move_camera_sequence(-111.68, 45.66, -74.92, -167.33, 37.66, 86.08, 155)
	helper_888ab2a3(10)
	event.jump_object_sequence(0, -159.92, 29.88, 36.38, -0.2, 25)
	wait_objects(0)
	helper_888ab2a3(10)
	event.move_object_sequence(0, -159.92, 27.83, 183.87, 120)
	event.set_object_sequence_motion(0, "歩き")
	helper_888ab2a3(60)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(60)
	wait_camera()
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(1)
	wait_camera()
	event.finish_event()
end

--- Helper function.
local function helper_5100(arg0: any, arg1: s32, arg2: s32)
	local stream_playing: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		stream_playing = event.is_voice_stream_playing() or stream_playing
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		var7 = 0
		argc_2 = event.get_voice_stream_state(1) or argc_2
		while true do
			if stream_playing ~= 0 then
				argc = event.get_voice_stream_state(1) or argc
				if argc_2 ~= 0 and argc == 0 then
					event.trigger_mouth_texture_animation(0)
					event.trigger_mouth_motion(2)
				end
				argc_2 = argc
			end
			var6 = helper_fd9c4774(arg0, arg1)
			if var6 ~= 0 then
				if var6 == 2 then
					arg2 = 1
				else
					arg2 = 0
				end
				var7 = vm.i32(var7 + 1)
				break
			else
				at = 1
				vm.wait(1)
				var7 = vm.i32(var7 + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		stream_playing = event.is_voice_stream_playing() or stream_playing
		if stream_playing ~= 0 then
			event.stop_voice_stream(1)
		end
		return var7, arg2
	end, function(received: { any })
		if at <= 1 then
			var7 = var7 + 1
			return var7, arg2
		end
		return nil, arg2
	end)
end

--- Helper function.
local function helper_5abc(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _ = open_message(arg0, arg1, arg2, arg3, arg4)
	do
		local _: any
		_, var6 = helper_5100(arg0, 0, var6)
	end
	close_message(arg0)
end

--- Helper function.
local function helper_95ac(arg0: any, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.set_message_item_name(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.set_message_item_name(1, 1, arg0)
		event.set_message_number(1, 2, arg1)
	end
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	helper_5abc(1, var2, 8, 0, 0)
end

--- Helper function.
local function helper_e3d0(item_no: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	event.set_dungeon_pause_flags(23, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
		var4 = out4 or var4
	end
	event.set_event_world_coordinate(var1, var2, var3, var4)
	vm.wait(1)
	event.add_inventory_item(item_no, 1)
	event.start_background_file_loads_3(item_no, 1, "effect/itemget.gltf")
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_888ab2a3(15)
	helper_66f07360(0)
	helper_888ab2a3(5)
	helper_479dc9e9()
	event.load_character(5, "effect/itemget.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(1, 12)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "ゲット", 5)
	event.set_object_sequence_motion(1, "ゲット", 2)
	helper_888ab2a3(5)
	var5 = helper_c0fce92c(var5)
	event.load_item_model(5, item_no, "info", 13, 1)
	event.set_character_active(1, 13)
	event.attach_object_handle_to_character(0, 13)
	var6 = helper_e6c23a00(13, item_no, var6)
	event.set_object_handle_scale(0, var6, var6, var6)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -5.0, 0.0)
	event.delay_object_sequence_position_track(0, 4)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.3, 20)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.4, 8)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.2, 5)
	var5 = helper_1ebb0be6(var5)
	wait_camera()
	helper_95ac(item_no, 1)
	event.start_crossfade(10)
	event.set_dungeon_pause_flags(23, 0)
	event.set_character_active(1, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Helper function.
local function helper_f198(arg0: any, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local language_code: s32 = 0
	local var9: any = 0
	local var11: s32 = 0
	local var12: any = 0
	local var13: f32 = 0
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		arg0,
		1,
		arg1,
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
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.set_event_world_coordinate(var2, var3, var4, var5)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_888ab2a3(15)
	helper_66f07360(0)
	helper_888ab2a3(5)
	helper_479dc9e9()
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
	var7 = helper_c0fce92c(var7)
	event.set_character_active(12)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 6)
	event.set_character_active(13)
	event.set_object_sequence_motion(1, "出現", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.clear_camera_sequence()
	event.delay_camera_sequence_position_track(4)
	event.move_camera_sequence_eased(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.move_camera_sequence_eased(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	var7 = helper_1ebb0be6(var7)
	helper_888ab2a3(10)
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
	helper_888ab2a3(8)
	event.set_character_visible(18, 1, 1, 0.08)
	event.set_character_visible(19, 1, 1, 0.08)
	helper_888ab2a3(10)
	event.set_character_active(0, 14)
	event.set_character_active(0, 15)
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
	helper_5abc(0, -1, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	if language_code == 0 then
		event.open_message_window_2(0, "赤い箱を選ぶ\n黄色い箱を選ぶ")
	else
		event.open_message_window_2(0, "Pick the red box.\nPick the yellow box.")
	end
	local _ = open_message(0, -1, 8, 0, 0)
	var9 = helper_f51aa7a3(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	var11 = vm.float_bits(event.get_random_number(100)) or var11
	if vm.imod(var11, 2) == 0 then
		var12 = arg0
		arg0 = arg1
		arg1 = var12
	end
	event.load_item_model(5, arg0, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	var13 = helper_32de9d65(16, arg0, var13)
	event.set_object_handle_scale(6, var13, var13, var13)
	event.load_item_model(5, arg1, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	var13 = helper_32de9d65(17, arg1, var13)
	event.set_object_handle_scale(6, var13, var13, var13)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if var9 == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	helper_888ab2a3(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	wait_objects(1)
	if var9 == 0 then
		helper_95ac(arg1, 1)
		event.add_inventory_item(arg1, 1)
	else
		helper_95ac(arg0, 1)
		event.add_inventory_item(arg0, 1)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(17, 0)
	for var6 = 0, 7 do
		event.delete_character(12 + var6)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Helper function.
local function helper_5660(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(arg0, 0)
	event.open_message_window_2(arg0, arg1)
	event.place_message_bubble(arg0, arg2, arg3)
	do
		local _: any
		_, var5 = helper_5100(arg0, 0, var5)
	end
	close_message(arg0)
end

--- Helper function.
local function helper_7e48(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	if arg3 ~= 0 then
		event.attach_object_handle_to_character(0, arg0)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.get_player_character_slot() or player_chara
	helper_baa247a4(player_chara, arg0, arg1, arg2)
	helper_5660(0, arg1, arg0, player_chara, 0)
	if arg3 ~= 0 then
		helper_06cb41a2(arg0, rot_y)
	end
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
	if arg2 ~= 0 then
		event.start_crossfade(10)
	end
end

--- Helper function.
local function helper_93ec(arg0: s32)
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	helper_5abc(1, vm.i32(60 + arg0), 8, 0, 0)
end

--- Helper function.
local function helper_17754()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local active_chr_no_2: s32 = 0
	local var5: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_character_motion(0, "故障", 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("ロボ故障")
		event.create_effect_work_buffer(5)
	end
	var1 = event.get_event_sound_bank(4) or var1
	event.stop_sound_effect(var1, 0)
	event.set_dungeon_pause_flags(17, 1)
	event.create_effect("ロボ故障")
	var2 = event.get_active_music_number() or var2
	var3 = vm.bits_float(event.get_music_master_volume()) or var3
	event.stop_music(0)
	event.start_background_file_loads_1("snd2/bgm/bg_060.sound.json")
	helper_888ab2a3(4)
	helper_479dc9e9()
	event.load_music_pack(60)
	event.play_music(0)
	active_chr_no_2 = event.get_playable_character() or active_chr_no_2
	helper_93ec(active_chr_no_2)
	if active_chr_no == 2 or active_chr_no == 3 then
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.clear_effect_manager()
		event.open_dungeon_character_change_menu(-1)
		vm.wait(5)
	else
		var5 = event.is_e3_version() or var5
		if var5 == 1 then
			event.fade_out_screen(30)
			helper_888ab2a3(30)
			event.set_scene_exit_flag(1)
			return
		else
			event.run_dungeon_debug_command(0)
		end
	end
	event.stop_music(0)
	event.clear_effect_manager()
	event.set_dungeon_pause_flags(17, 1)
	helper_888ab2a3(4)
	event.load_music(var2)
	event.play_music(0)
	event.set_music_master_volume(var3)
	event.play_sound_effect(var1, 0)
	event.set_dungeon_pause_flags(17, 0)
	event.finish_event()
end

--- Helper function.
local function helper_166fc()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local stage_id: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local language_code: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		helper_52115bbf()
		if active_chr_no == 0 then
			at = 1
			helper_99d04251()
		end
		if active_chr_no == 1 then
			at = 2
			helper_2f6f8a35()
		end
		if active_chr_no == 2 or active_chr_no == 3 then
			at = 3
			helper_649c18cd(active_chr_no)
		end
		var1 = event.is_e3_version() or var1
		if var1 ~= 1 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			event.get_dungeon_floor()
			if stage_id ~= 3 then
				helper_fd3a2124(0)
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
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				at = 4
				helper_5abc(0, 2100, 8, 0, 0)
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 0)
			end
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.set_camera_position(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.open_message_window_2(
				0,
				"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
			)
			at = 5
			helper_5abc(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(
				0,
				" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
			)
			at = 6
			helper_5abc(0, -1, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 6 then
			if at <= 1 then
				at = 2
				helper_2f6f8a35()
				return vm.continue_with(function()
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 3
						helper_649c18cd(active_chr_no)
					end
					var1 = event.is_e3_version() or var1
					if var1 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							helper_fd3a2124(0)
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
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							at = 4
							helper_5abc(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_position(position_x_2, position_y_2, position_z_2)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					language_code = event.get_language() or language_code
					if language_code == 0 then
						event.open_message_window_2(
							0,
							"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
						)
						at = 5
						helper_5abc(0, -1, 8, 0, 0)
					else
						event.open_message_window_2(
							0,
							" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
						)
						at = 6
						helper_5abc(0, -1, 8, 0, 0)
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_649c18cd(active_chr_no)
				return vm.continue_with(function()
					var1 = event.is_e3_version() or var1
					if var1 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							helper_fd3a2124(0)
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
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							at = 4
							helper_5abc(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_position(position_x_2, position_y_2, position_z_2)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					language_code = event.get_language() or language_code
					if language_code == 0 then
						event.open_message_window_2(
							0,
							"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
						)
						at = 5
						helper_5abc(0, -1, 8, 0, 0)
					else
						event.open_message_window_2(
							0,
							" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
						)
						at = 6
						helper_5abc(0, -1, 8, 0, 0)
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 3 then
				helper_975c8257(0)
				helper_2a0361d4(0, 2100, 8, 0, 0)
			end
			if at <= 4 then
				helper_2a0361d4(0, -1, 8, 0, 0)
			end
			if at <= 5 then
				helper_2a0361d4(0, -1, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_2be3c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.set_message_window_mode(0, 4)
			at = 1
			helper_5abc(0, 2000, 8, 0, 0)
			return 1
		end
		var1 = event.get_equipped_item(0, 0) or var1
		if var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
			event.set_message_window_mode(0, 4)
			at = 2
			helper_5abc(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(var1)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_32540(arg0: s32)
	local count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.show_dungeon_status_bar(1.0)
	event.start_crossfade(15)
	count = event.get_sphida_par() or count
	if arg0 == 0 and count <= 0 then
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
		event.set_message_window_mode(0, 4)
		helper_5abc(0, 2003, 8, 0, 0)
		event.reset_follow_camera(1)
	end
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 10, which map data, a script or the engine runs by number.
function script.event_10()
	local argc: s32 = 0
	local item: s32 = 0
	argc = event.get_local_event_flag(0) or argc
	if argc == 0 then
		event.open_use_item_menu(341)
		vm.wait(1)
		item = vmhost.used_item() or item
		if item == 341 then
			event.set_local_event_flag(0, 1)
			helper_44d34()
		end
		if item <= 0 then
			return
		end
		if item ~= 341 then
			helper_0e90ac27()
			return
		end
	else
		helper_46c98()
	end
end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Event 102, which map data, a script or the engine runs by number.
function script.event_102()
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.open_use_item_menu(278)
		at = 1
		vm.wait(1)
		item = vmhost.used_item() or item
		if item <= 0 then
			print("----cancel----\n")
			return
		end
		if item ~= 278 then
			print("----CHIGAU=", item, "----\n")
			return
		end
		print("----OK----\n")
		return
	end, function(received: { any })
		if at <= 1 then
			print("----cancel----\n")
			return 0
		end
		return nil
	end)
end

script.event_1000 = event_1000

--- The dungeon system event run when the player opens a treasure box.
function script.treasure_box()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	event.set_character_active(0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		var1 = event.get_player_move_type() or var1
		if var1 == 1 then
			event.set_character_motion(0, "立ち-足")
		end
		if var1 == 2 then
			event.set_character_motion(0, "立ち-キャタピラ")
		end
	end
	do
		local out1, out2 = event.get_treasure_box_item()
		var2 = out1 or var2
		var3 = out2 or var3
	end
	if var3 <= -1 then
		helper_e3d0(var2)
	else
		helper_f198(var2, var3)
	end
end

--- The dungeon system event run when the player steps into a random circle.
function script.random_circle()
	local language_code: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var12: s32 = 0
	local weight: f32 = 0
	local var15: f32 = 0
	local circle_id: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local angle: f32 = 0
	local var29: s32 = 0
	local var30: s32 = 0
	local bright_rate: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	event.initialize_event()
	language_code = event.get_language() or language_code
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_52115bbf()
		if language_code == 0 then
			if active_chr_no == 2 then
				event.open_message_window_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.open_message_window_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif active_chr_no == 2 then
			event.open_message_window_2(0, "Must get off the Ridepod.")
		else
			event.open_message_window_2(0, "Looks like you can't do it\nas a monster.")
		end
		helper_5abc(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.get_direction_angle(pos_x, pos_y, pos_z, var2, var3, var4) or yaw
		var2 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var3 = pos_y
		var4 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.set_character_position(0, var2, var3, var4)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	helper_52115bbf()
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(2)
	helper_479dc9e9()
	var12 = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or var12
	event.start_background_file_loads_2("event/dng/ring.gltf", "event/dng/randomcoin.gltf")
	vm.wait(4)
	helper_479dc9e9()
	weight = event.get_random_circle_motion_frame() or weight
	event.deactivate_random_circle(-1)
	event.load_character(5, "event/dng/ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, weight)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "event/dng/randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var15 = event.get_random_number(6.2831855) or var15
	var15 = vm.f32(var15 - vm.f32(3.1415927))
	var15 = event.wrap_angle(var15) or var15
	event.set_character_rotation(13, 0.0, var15, 0.0)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var15 = out2 or var15
		end
		var15 = vm.f32(var15 + var19)
		var15 = event.wrap_angle(var15) or var15
		event.set_character_rotation(13, 0.0, var15, 0.0)
		if var18 == 10 then
			event.play_sound_effect(var12, 0)
		end
		if var18 == 30 then
			if language_code == 0 then
				helper_25d46bcc()
			else
				event.set_message_window_mode(1, 7)
				event.apply_message_window_preset(1, 2)
				event.open_message_window_2(1, "It stops with (O) button.")
				open_message(1, -1, 15, 0, 0)
			end
		end
		if (if var18 >= 30 then helper_581cb30c(0) else 0) ~= 0 or var18 > 300 then
			event.stop_sound_effect(var12, 0)
			event.play_sound_effect(var12, 3)
			vm.wait(6)
			break
		else
			var18 = var18 + 1
			vm.wait(7)
		end
	end
	helper_3cf99f2c()
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	var27 = 0
	var27 = vm.float_bits(event.get_random_number(10)) or var27
	var27 = vm.i32(var27 + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var15 = out2 or var15
		end
		var15 = vm.f32(var15 + var19)
		var15 = event.wrap_angle(var15) or var15
		event.set_character_rotation(13, 0.0, var15, 0.0)
		vm.wait(8)
		if var18 >= var27 then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.wrap_angle(angle) or angle
			if var15 < angle and helper_f7fba8ce(var15, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if var15 < angle and helper_f7fba8ce(var15, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	helper_888ab2a3(20)
	var29 = vm.float_bits(event.get_random_number(10)) or var29
	if var29 < 6 then
		var29 = vm.float_bits(event.get_random_number(10)) or var29
		if circle_id == 0 then
			var30 = 2
		else
			var30 = 4
		end
		if var29 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.wrap_angle(var26) or var26
			event.rotate_object_sequence(5, 0.0, var26, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			helper_888ab2a3(10)
		else
			var29 = vm.float_bits(event.get_random_number(10)) or var29
			if var29 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				helper_888ab2a3(20)
			end
		end
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var15 = out2 or var15
	end
	if helper_f7fba8ce(var15, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	var18 = 0
	var32 = event.get_random_circle_effect(circle_id) or var32
	if circle_id == 0 then
		event.play_sound_effect(var12, 1)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(12)
		end
		if language_code == 0 then
			event.open_message_window_2(0, "コインは天使の面をこちらに向けた。")
			helper_5abc(0, -1, 8, 0, 0)
			if var32 == 1 then
				event.open_message_window_2(0, "ＡＢＳボーナス")
			end
			if var32 == 2 then
				event.open_message_window_2(
					0,
					"天使は「体力」と「ステータス異常」を\n全回復してくれた。"
				)
			end
			if var32 == 3 then
				event.open_message_window_2(0, "天使は「ＷＨＰ」を全回復してくれた。")
			end
			if var32 == 4 then
				event.open_message_window_2(0, "天使は「宝箱」を置いていった。")
				event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			end
		else
			event.open_message_window_2(0, "The coin flipped to the 'Angel'.")
			helper_5abc(0, -1, 8, 0, 0)
			if var32 == 1 then
				event.open_message_window_2(0, "ABS bonus!")
			end
			if var32 == 2 then
				event.open_message_window_2(0, "Strength & status fully\nrecovered by the Angel.")
			end
			if var32 == 3 then
				event.open_message_window_2(0, "WHP fully recovered by the Angel.")
			end
			if var32 == 4 then
				event.open_message_window_2(0, "Angel left a treasure box.")
				event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			end
		end
	else
		event.play_sound_effect(var12, 2)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(15)
		end
		if language_code == 0 then
			event.open_message_window_2(0, "コインは悪魔の面をこちらに向けた。")
			helper_5abc(0, -1, 8, 0, 0)
			if var32 == 5 then
				if active_chr_no == 0 or active_chr_no == 2 then
					event.open_message_window_2(0, "悪魔はユリスに「毒」のステータス異常をあたえた。")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.open_message_window_2(0, "悪魔はモニカに「毒」のステータス異常をあたえた。")
				end
			end
			if var32 == 6 then
				if active_chr_no == 0 then
					event.open_message_window_2(0, "悪魔はユリスの体力を半分にした。")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.open_message_window_2(0, "悪魔はモニカの体力を半分にした。")
				end
				if active_chr_no == 2 then
					event.open_message_window_2(0, "悪魔はスティーブの耐久力を半分にした。")
				end
			end
			if var32 == 8 then
				event.open_message_window_2(0, "悪魔は銃の「ＷＨＰ」を半分にした。")
			end
			if var32 == 9 then
				event.open_message_window_2(0, "悪魔はレンチの「ＷＨＰ」を半分にした。")
			end
			if var32 == 10 then
				event.open_message_window_2(0, "悪魔は腕輪の「ＷＨＰ」を半分にした。")
			end
			if var32 == 11 then
				event.open_message_window_2(0, "悪魔は剣の「ＷＨＰ」を半分にした。")
			end
			if var32 == 12 then
				event.open_message_window_2(0, "悪魔は全モンスターを復活させた。")
			end
		else
			event.open_message_window_2(0, "The coin flipped to 'Devil'")
			helper_5abc(0, -1, 8, 0, 0)
			if var32 == 5 then
				if active_chr_no == 0 or active_chr_no == 2 then
					event.open_message_window_2(0, "Devil caused an abnormal status.")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.open_message_window_2(0, "Devil has poisoned Maximilian.")
				end
			end
			if var32 == 6 then
				if active_chr_no == 0 then
					event.open_message_window_2(0, "Devil takes half of Maximilian's health.")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.open_message_window_2(0, "Devil takes half of Monica's health.")
				end
				if active_chr_no == 2 then
					event.open_message_window_2(0, "Devil takes half of Steve's health.")
				end
			end
			if var32 == 8 then
				event.open_message_window_2(0, "Devil takes half of your gun's WHP.")
			end
			if var32 == 9 then
				event.open_message_window_2(0, "Devil takes half of your wrench's WHP.")
			end
			if var32 == 10 then
				event.open_message_window_2(0, "Devil takes half your bracelet's WHP.")
			end
			if var32 == 11 then
				event.open_message_window_2(0, "Devil takes half of your sword's WHP.")
			end
			if var32 == 12 then
				event.open_message_window_2(0, "Devil resurrected all monsters.")
			end
		end
	end
	result = event.apply_random_circle_effect(var32) or result
	helper_5abc(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if var32 == 1 then
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- The dungeon system event run when the player uses the geostone.
function script.geostone()
	local active_chr_no: s32 = 0
	local language_code: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var18: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	event.initialize_event()
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_52115bbf()
		language_code = event.get_language() or language_code
		if language_code == 0 then
			if active_chr_no == 2 then
				event.open_message_window_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.open_message_window_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif active_chr_no == 2 then
			event.open_message_window_2(0, "Must get off the Ridepod.")
		else
			event.open_message_window_2(0, "Looks like you can't do it\nas a monster.")
		end
		helper_5abc(0, -1, 8, 0, 0)
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
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	if active_chr_no == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(2)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(4)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var5 = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or var5
	event.set_dungeon_pause_flags(17, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	event.copy_vector(var9, var10, var11)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var10 + 18.0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	var18 = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var18
	var18 = event.wrap_angle(var18) or var18
	if active_chr_no == 0 then
		var18 = vm.f32(var18 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var18 = vm.f32(var18 + vm.f32(2.4))
	end
	var18 = event.wrap_angle(var18) or var18
	var9 = vm.f32(vm.f32(vm.sin(var18) * 14.0) + pos_x_2)
	var11 = vm.f32(vm.f32(vm.cos(var18) * 14.0) + pos_z_2)
	event.set_character_position(0, var9, var10, var11)
	var18 = vm.f32(var18 - vm.f32(3.1415927))
	var18 = event.wrap_angle(var18) or var18
	event.set_character_rotation(0, 0.0, var18, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_chr_no == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var9, var10 + 18.0, var11)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, var9, var10 + 36.0, var11)
	end
	if active_chr_no == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var9, var10 + 18.0, var11)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		pos_x_3 = vm.f32(vm.f32(vm.sin(var18) * 8.0) + var9)
		pos_y_3 = vm.f32(var10 + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(var18) * 8.0) + var11)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	helper_888ab2a3(16)
	event.play_sound_effect(var5, 0)
	helper_888ab2a3(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	helper_888ab2a3(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var18 = event.get_direction_angle(var9, var10, var11, pos_x, pos_y, pos_z) or var18
	event.set_character_rotation(12, 0.0, var18, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	helper_888ab2a3(20)
	event.play_sound_effect(var5, 1)
	wait_objects(0)
	helper_95ac(358, 1)
	event.start_crossfade(10)
	if active_chr_no == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(12)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, var2, var3, var4)
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

--- The dungeon system event run for a monster that can be talked to.
function script.monster_talk()
	local var0: s32 = 0
	local var1: s32 = 0
	do
		local out1, out2 = event.get_monster_talk_data_2()
		var0 = out1 or var0
		var1 = out2 or var1
	end
	helper_7e48(var0, vm.i32(var1 + 1000), 1, 1)
end

--- Event 1200, which map data, a script or the engine runs by number.
script.event_1200 = helper_17754

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = helper_166fc

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local level: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: s32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: f32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local var49: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var53: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var59: any = 0
	vm.wait(1)
	event.initialize_event()
	helper_52115bbf()
	event.set_character_motion(0, "立ち")
	if helper_2be3c() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_3(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf"
	)
	vm.wait(3)
	helper_479dc9e9()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var2, var3, var4, var6 = helper_558828de(var2, var3, var4, var6)
	helper_998c6893(var6)
	event.set_sphida_status_panel_visible(1)
	var11 = 12.5
	event.set_sphida_carry_angle(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12, var13, level = helper_39ab7f1f(var12, var13, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, var6, var11 = helper_f033341e(var6, var11, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_character_position(0, var8, var9, var10)
			helper_32540(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, var12, var6, var16, var15, level = helper_214de41f(var12, tex_bank, var6, var16, var15, var1, level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(var2, var3, var4)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var21 = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, var2, var3 + 30.0, var4)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		helper_888ab2a3(10)
	end
	if var12 <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		helper_888ab2a3(25)
		if level ~= 4 then
			event.play_sound_effect(var1, 3)
		end
	elseif var12 <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		helper_888ab2a3(34)
		event.play_sound_effect(var1, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		helper_888ab2a3(39)
		if level == 0 then
			event.play_sound_effect(var1, 12)
		else
			event.play_sound_effect(var1, 1)
		end
	end
	if level == 4 then
		helper_888ab2a3(50)
		helper_bb794e6a(var1)
		event.set_character_position(0, var8, var9, var10)
		helper_32540(0)
		return
	end
	if level == 0 then
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
	var12 = helper_dff48a5c(var12)
	var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12 = vm.f32(var12 - vm.f32(var12 * var11))
	var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
	var23 = vm.f32(var12 * vm.sin(var11))
	var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
	var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
	var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
	var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var29 = 180.0
	var30 = -50.0
	var31 = 0
	level = 0
	var44 = 0
	var46 = 0
	while true do
		if var3 >= var29 then
			var22 = vm.f32(var22 * vm.f32(0.999))
			var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
			var24 = vm.f32(var24 * vm.f32(0.999))
		else
			var43 = event.get_segment_collision_9(12, var2, var3, var4, var2, vm.f32(var3 - 3.0) - vm.f32(0.01), var4, 0)
				or var43
			if level == 1 and var43 >= 0 then
				var22 = vm.f32(var22 * vm.f32(0.94))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.94))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
			else
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(var2, var3, var4, var22, var23, var24)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		if var16 ~= 0.0 then
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			var11 = vm.f32(var11 + var16)
			var11 = event.wrap_angle(var11) or var11
			var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
			var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
		end
		var42 = event.get_vector_length(var15, 0.0, var17) or var42
		if var42 > vm.f32(0.01) then
			var25 = event.get_vector_length(var15, 0.0, var17) or var25
			var11 = event.get_direction_angle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.set_character_rotation(8, var5, var11, var7)
			event.offset_character_rotation(8, var25 * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, var5, var11, var7)
			event.offset_character_rotation(9, var25 * 12.0, 0.0, 0.0)
		else
			var25 = event.get_vector_length(var22, 0.0, var24) or var25
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.set_character_rotation(8, var5, var11, var7)
			event.offset_character_rotation(8, var25 / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, var5, var11, var7)
			event.offset_character_rotation(9, var25 / 10.0, 0.0, 0.0)
		end
		var25 = event.get_vector_length(var22, var23, var24) or var25
		var41 = var25
		var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
		var38 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		var40 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			var2 - var38,
			var3,
			var4 - var40,
			vm.f32(var2 + var38) + var38,
			var3,
			vm.f32(var4 + var40) + var40
		)
		do
			local out1, out2, out3 = event.copy_vector(var22, var23, var24)
			var38 = out1 or var38
			var39 = out2 or var39
			var40 = out3 or var40
		end
		do
			local out1, out2, out3 = event.normalize_vector(var38, var39, var40)
			var38 = out1 or var38
			var39 = out2 or var39
			var40 = out3 or var40
		end
		do
			local out1, out2, out3 = event.scale_vector(var38, var39, var40, 3.0)
			var38 = out1 or var38
			var39 = out2 or var39
			var40 = out3 or var40
		end
		do
			local out1, out2 =
				event.get_segment_collision_10(0, var18, var19, var20, var2 + var38, var3 + var39, var4 + var40, 0)
			var43 = out1 or var43
			var45 = out2 or var45
		end
		if var43 >= 0 and var45 == 1 then
			if var44 <= 0 then
				event.play_sound_effect(var1, 11)
				var44 = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var18, var19, var20, var2 + var38, var3 + var39, var4 + var40, 1)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
			var35 = out4 or var35
			var36 = out5 or var36
			var37 = out6 or var37
			var43 = out7 or var43
		end
		while var43 >= 0 do
			var16 = 0.0
			if var25 > 8.0 then
				helper_79d90c82()
			end
			if var44 <= 0 then
				event.play_sound_effect(var1, 6)
				var44 = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.normalize_vector(var22, var23, var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.scale_vector(var22, var23, var24, 3.0)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.add_vectors(var32, var33, var34, var22, var23, var24)
				var32 = out1 or var32
				var33 = out2 or var33
				var34 = out3 or var34
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var32, var33, var34)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var42 = event.get_vector_length(var18, var19, var20) or var42
			var42 = vm.f32(var41 - var42)
			if var42 <= 0.0 then
				break
			else
				var41 = var42
				do
					local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				if var23 < 0.0 and var36 > 0.0 then
					var22 = vm.f32(var15 * 2.0)
					var23 = 0.0
					var24 = vm.f32(var17 * 2.0)
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					if
						var22 < 0.0 and var35 > 0.0
						or var22 > 0.0 and var35 < 0.0
						or var24 < 0.0 and var37 > 0.0
						or var24 > 0.0 and var37 < 0.0
					then
						var15 = 0.0
						var17 = 0.0
					end
					var22 = 0.0
					var23 = 0.0
					var24 = 0.0
				end
				var22 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var22)
				var23 = vm.f32(vm.f32(vm.f32(var36 * var25) * vm.f32(0.58)) + var23)
				var24 = vm.f32(vm.f32(vm.f32(var37 * var25) * vm.f32(0.9)) + var24)
				do
					local out1, out2, out3 = event.copy_vector(var32, var33, var34)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				do
					local out1, out2, out3 = event.copy_vector(var22, var23, var24)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
				end
				do
					local out1, out2, out3 = event.normalize_vector(var38, var39, var40)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
				end
				do
					local out1, out2, out3 = event.scale_vector(var38, var39, var40, 3.0)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
				end
				do
					local out1, out2, out3 = event.scale_vector(var35, var36, var37, var42)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
				do
					local out1, out2, out3 = event.copy_vector(var32, var33, var34)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3 = event.add_vectors(var2, var3, var4, var35, var36, var37)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						var18,
						var19,
						var20,
						var2 + var38,
						var3 + var39,
						var4 + var40,
						1
					)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
					var35 = out4 or var35
					var36 = out5 or var36
					var37 = out6 or var37
					var43 = out7 or var43
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
			var35 = out4 or var35
			var36 = out5 or var36
			var37 = out6 or var37
			var43 = out7 or var43
			var45 = out8 or var45
		end
		if var43 >= 0 then
			var16 = 0.0
			var3 = vm.f32(var33 + 3.0)
			var42 = event.get_vector_length(var22, 0.0, var24) or var42
			if var42 < vm.f32(2.4) or var23 >= -1.0 and var23 <= 0.0 then
				var23 = 0.0
				level = 1
			else
				var22 = vm.f32(var22 * vm.f32(0.9))
				var23 = -vm.f32(var23 * vm.f32(0.58))
				var24 = vm.f32(var24 * vm.f32(0.9))
				var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
				var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
				var15 = vm.f32(var15 * vm.f32(0.2))
				var17 = vm.f32(var17 * vm.f32(0.2))
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var44 <= 0 then
					event.play_sound_effect(var1, 5)
					var44 = 20
				end
			end
			var42 = event.get_vector_length(var15, 0.0, var17) or var42
			if var23 == 0.0 and var25 < vm.f32(1.6) and var42 < vm.f32(0.4) then
				if not (var45 == 6) then
					break
				end
				var31 = 1
				break
			end
		end
		if var3 < -500.0 then
			var31 = 1
			break
		elseif var46 >= 300 then
			var31 = 1
			break
		else
			pin_col = event.get_sphida_pin_color() or pin_col
			ball_col = event.get_sphida_ball_color() or ball_col
			x = vm.f32(pos_x - var2)
			y = vm.f32(pos_y - var3)
			z = vm.f32(pos_z - var4)
			var49 = event.get_vector_length(x, y, z) or var49
			if ball_col ~= pin_col then
				var53 = event.get_point_to_segment_distance(var18, var19, var20, var2, var3, var4, pos_x, pos_y, pos_z) or var53
				if var53 >= 0.0 and var53 <= 30.0 then
					var21 = 1
					break
				end
				if var49 ~= 0.0 then
					if var49 <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var49))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.add_vectors(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				else
					var21 = 1
					break
				end
			elseif var49 ~= 0.0 then
				if var49 <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var49))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var2, var3, var4, x, y, z)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var22, var23, var24, x, y, z)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
				end
			end
			event.set_character_position(8, var2, var3, var4)
			event.set_character_position(9, var2, var3, var4)
			do
				local out1, out2, out3 = event.copy_vector(var2, var3, var4)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			if var3 <= var30 then
				event.set_follow_camera_following(0)
				if var31 >= 30 then
					if var31 >= 50 then
						break
					end
				else
					event.set_camera_look_at(var2, var3, var4)
				end
				var31 = var31 + 1
			elseif var46 >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				yaw = event.get_direction_angle(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_follow_camera_angle(yaw)
				event.set_follow_camera_target_alternate(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(var2, var3, var4)
			vm.wait(15)
			if var44 > 0 then
				var44 = var44 - 1
			end
			var46 = var46 + 1
		end
	end
	event.set_character_position(8, var2, var3, var4)
	event.set_character_position(9, var2, var3, var4)
	vm.wait(16)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if var31 == 0 then
		event.set_sphida_ball_position(var2, var3, var4)
		if var21 == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pos_x, pos_y, pos_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(var1, 17)
			var46 = 0
			while var46 < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var46 = var46 + 1
				vm.wait(17)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var46 = 0
			while var46 < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var46 = var46 + 1
				vm.wait(18)
			end
			event.set_character_active(0, 11)
			event.place_treasure_box(pos_x, pos_y - 30.0, pos_z, var11, 294)
			helper_888ab2a3(54)
			helper_888ab2a3(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var1
			event.stop_music(0)
			event.play_sound_effect(var1, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
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
			wait_objects(0)
			helper_888ab2a3(90)
			vm.wait(23)
			event.play_music(0)
			event.set_character_position(0, var8, var9, var10)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		else
			count = event.get_sphida_par() or count
			if count >= 2 then
				event.set_message_window_mode(0, 5)
				event.set_message_selection_top_line(0, 0)
				var59 = helper_7c78bc02(0, 2002, 8, 256, 208, 2, 0)
				vm.wait(25)
				if var59 == 0 then
					do
						local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(var2, var3, var4, 100.0, "point")
						var43 = out1 or var43
						var8 = out2 or var8
						var9 = out3 or var9
						var10 = out4 or var10
					end
					if var43 == 0 then
						do
							local out1, out2, out3 = event.get_nearest_map_parts_position(var2, var3, var4, 100.0)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
					end
					do
						local out1, out2, out3 = event.get_sphida_pin_position()
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					var25 = event.get_distance_between(var8, var9, var10, pos_x, pos_y, pos_z) or var25
					if var25 < 40.0 then
						var11 = event.get_random_number(6.2831855) or var11
						var11 = vm.f32(var11 - vm.f32(3.1415927))
						var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
						var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
					else
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var8, var9, var10)
							var32 = out1 or var32
							var33 = out2 or var33
							var34 = out3 or var34
							var43 = out4 or var43
						end
						var46 = 0
						while var43 >= 0 do
							do
								local out1, out2, out3 = event.copy_vector(var8, var9, var10)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var32, var33, var34)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.normalize_vector(var18, var19, var20)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.scale_vector(var18, var19, var20, 32.0)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.copy_vector(var32, var33, var34)
								var8 = out1 or var8
								var9 = out2 or var9
								var10 = out3 or var10
							end
							do
								local out1, out2, out3 = event.add_vectors(var8, var9, var10, var18, var19, var20)
								var8 = out1 or var8
								var9 = out2 or var9
								var10 = out3 or var10
							end
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var8, var9, var10)
								var32 = out1 or var32
								var33 = out2 or var33
								var34 = out3 or var34
								var43 = out4 or var43
							end
							var46 = var46 + 1
							if var46 > 6 then
								break
							end
						end
					end
					var6 = event.get_direction_angle(var8, var9, var10, var2, var3, var4) or var6
					event.set_character_position(0, var8, var9, var10)
					event.set_character_rotation(0, 0.0, var6, 0.0)
					event.set_camera_look_at(var8, var9 + 30.0, var10)
					var6 = vm.f32(var6 - vm.f32(3.1415927))
					var6 = event.wrap_angle(var6) or var6
					var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
					var9 = vm.f32(var9 + 30.0)
					var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
					event.set_camera_position(var8, var9, var10)
					event.reset_follow_camera(0)
				else
					event.set_character_position(0, var8, var9, var10)
				end
			else
				event.set_character_position(0, var8, var9, var10)
			end
		end
	else
		event.play_sound_effect(var1, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
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
		wait_objects(0)
		helper_888ab2a3(20)
		event.set_event_sprite_draw_pass(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.set_sphida_ball_position(var2, var3 + 3.0, var4)
		event.set_character_position(8, var2, var3 + 3.0, var4)
		event.set_character_position(9, var2, var3 + 3.0, var4)
		event.set_character_position(0, var8, var9, var10)
		event.release_camera_sequence_follow_object()
	end
	if var21 == 1 then
		helper_bb794e6a(-1)
	else
		helper_bb794e6a(var1)
	end
	helper_32540(var21)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_52115bbf()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	var0 = helper_7c78bc02(0, 2004, 8, 256, 208, 2, 0)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		helper_bb794e6a(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

return script
