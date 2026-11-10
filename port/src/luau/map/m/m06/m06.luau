--!strict
-- map/m/m06/m06.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_8132d034 = require("@lib/event/helper_8132d034")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8d25bb56 = require("@lib/event/helper_8d25bb56")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_message_answer = require("@lib/event/wait_message_answer")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_13428()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.get_character_rotation(9)
	yaw = event.get_direction_angle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.get_direction_angle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.compare_angles(yaw_2, 1.94, 1.5) or var14
	if var14 ~= 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "後ろから話し掛けるのは、失礼だよね。")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_message_bubble_tail(0, 1)
		return
	end
	var14 = event.compare_angles(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(14)
	event.set_mouth_motions(1, "会話", 0, "座り", 0)
	event.open_message_window_2(0, "きれいな星空ね・・・")
	helper_0ffc2526(0, -1, 9, 0, 0)
	event.reset_mouth_motions()
end

--- Helper function.
local function helper_e494(arg0: s32, arg1: s32)
	event.open_voice_stream_wave(1, arg0)
	helper_9cbdc640(1)
	open_message(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	helper_61e5dba6(0, arg1)
	close_message(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Helper function.
local function helper_e670()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.get_character_rotation(9)
	yaw = event.get_direction_angle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.get_direction_angle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.compare_angles(yaw_2, 1.94, 1.5) or var14
	if var14 ~= 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "後ろから話し掛けるのは、失礼だよね。")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_message_bubble_tail(0, 1)
		return
	end
	var14 = event.compare_angles(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(14)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "こっちに赤い髪の子来ませんでした？")
	helper_e494(10350, 80)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "座り", 4)
	event.open_message_window_2(0, "う～ん、見たかい？")
	helper_e494(10360, 60)
	event.open_message_window_2(0, "役所の方に走っていったよ。")
	helper_e494(10370, 70)
	event.close_voice_stream(1)
end

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	event.attach_object_handle_to_map_part_2(31, "街灯-14")
	event.set_object_handle_visible(31, 0)
	event.attach_object_handle_to_map_part_2(31, "街灯-15")
	event.set_object_handle_visible(31, 0)
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
end

--- Helper function.
local function helper_d1d0()
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		event.set_character_motion(0, "立ち")
		wait_camera()
		event.enable_drama_skip()
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p1/op1_5.txt")
		event.attach_object_handle_to_character(0, 8)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2265.38, 0.0, 2231.01)
		event.set_object_sequence_rotation(0, 0.0, -2.3, 0.0)
		event.load_character_motion_pack(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 2244.38, 0.0, 2216.71)
		event.set_object_sequence_rotation(4, 0.0, 1.08, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_motion(4, "旧・立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 1, "うれし口")
		event.load_character(5, "event/opening/p1/p1_5_ticket.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.attach_object_handle_to_character(5, 20)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 2244.38, 0.0, 2216.71)
		event.set_object_sequence_rotation(5, 0.0, 1.08, 0.0)
		event.set_camera_sequence_position(2261.3, 11.72, 2146.03)
		event.set_camera_sequence_look_at(2254.85, 18.38, 2223.77)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		wait_camera()
		event.set_object_sequence_motion(4, "チケットを渡す", 6)
		event.queue_object_sequence_next_motion(4, "チケットを渡すL", 4)
		event.set_character_active(20)
		event.set_object_sequence_motion(5, "チケットを渡す", 6)
		event.queue_object_sequence_next_motion(5, "チケットを渡すL", 4)
		event.set_mouth_texture_animations(4, "通常口パク", "うれし口")
		helper_0382f327(10680, 34)
		event.reset_mouth_texture_animations()
		wait_objects(4)
		event.set_object_sequence_motion(0, "もぎり", 6)
		event.queue_object_sequence_next_motion(0, "もぎりL", 4)
		helper_0382f327(10690, 60)
		wait_objects(0)
		event.set_character_active(0, 20)
		event.set_object_sequence_motion(4, "チケットを渡す戻り", 6)
		event.queue_object_sequence_next_motion(4, "旧・立ち", 4)
		event.set_object_sequence_motion(0, "もぎり戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(4, "通常口パク", "うれし口")
		helper_0382f327(10700, 30)
		event.reset_mouth_texture_animations()
		wait_objects(0)
		event.set_object_sequence_motion(4, "歩き")
		event.move_object_sequence(4, 2246.15, 0.0, 2250.53, 45)
		event.move_object_sequence(4, 2245.15, 8.0, 2295.52, 45)
		event.rotate_object_sequence(4, 0.0, 0.0, 0.0, 10)
		helper_888ab2a3(30)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.delete_character_extension_packs(0)
	event.load_message_file(0, -1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(20)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.stop_music(0)
	event.stop_environment_music()
	helper_888ab2a3(4)
end

--- Helper function.
local function helper_10ec8(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local item: s32 = 0
	local flag: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	var15 = 0
	var18 = 0
	var19 = event.get_triggered_event_data_2(6) or var19
	if var19 == 1 or arg0 == 1 then
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			var5 = out2 or var5
		end
		do
			local out1, out2, out3 = event.get_character_position(8)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		do
			local _, out2, _ = event.get_character_rotation(8)
			var11 = out2 or var11
		end
		yaw = event.get_direction_angle(var1, var2, var3, var7, var8, var9) or yaw
		yaw_2 = event.get_direction_angle(var7, var8, var9, var1, var2, var3) or yaw_2
		var16 = 0
		var17 = event.compare_angles(var5, yaw, 0.1) or var17
		if var17 ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
			var16 = 20
		end
		event.set_object_sequence_motion(0, "立ち")
		var17 = event.compare_angles(var11, yaw_2, 0.1) or var17
		if var17 ~= 0 then
			event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
			var16 = 20
		end
		event.set_object_sequence_motion(1, "立ち")
		helper_888ab2a3(var16)
		event.open_voice_stream_wave(1, 10665)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.open_message_window_2(
			0,
			"会場に入るにはチケットが必要だよ。\n（(#)ボタンでメニューを開く）"
		)
		open_message(0, -1, 8, 0, 0)
		do
			local _: any
			_, var20 = wait_message_answer(0, 1, var20)
		end
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		event.close_voice_stream(1)
		if var20 == 1 then
			var19 = 2
		else
			event.close_voice_stream(1)
		end
		var18 = 1
		var15 = 1
	end
	if var19 == 2 then
		event.open_use_item_menu(353)
		vm.wait(4)
		item = vmhost.used_item() or item
		if item == 353 then
			flag = event.get_save_flag(1) or flag
			if flag == 0 then
				event.set_save_flag(1, 1)
				event.load_event_script("m06/m06b.stb", 153)
				return
			else
				helper_d1d0()
				event.skip_next_music_load()
				event.skip_next_map_sound_load()
				event.remove_item(382)
				event.add_inventory_item(387)
				event.equip_character_item(0, 387)
				event.go_to_dungeon(0, 21, 1010)
				return
			end
		elseif item <= 0 then
		else
			if var18 ~= 1 then
				event.attach_object_handle_to_character(0, 0)
				event.clear_object_sequence(0)
				event.set_object_sequence_object(0, 0)
				event.attach_object_handle_to_character(1, 8)
				event.clear_object_sequence(1)
				event.set_object_sequence_object(1, 1)
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				do
					local _, out2, _ = event.get_character_rotation(0)
					var5 = out2 or var5
				end
				do
					local out1, out2, out3 = event.get_character_position(8)
					var7 = out1 or var7
					var8 = out2 or var8
					var9 = out3 or var9
				end
				do
					local _, out2, _ = event.get_character_rotation(8)
					var11 = out2 or var11
				end
				yaw = event.get_direction_angle(var1, var2, var3, var7, var8, var9) or yaw
				yaw_2 = event.get_direction_angle(var7, var8, var9, var1, var2, var3) or yaw_2
				var16 = 0
				var17 = event.compare_angles(var5, yaw, 0.1) or var17
				if var17 ~= 0 then
					event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
					event.set_object_sequence_motion(0, "歩き")
					event.delay_object_sequence_motion_track(0, 10)
					var16 = 20
				end
				event.set_object_sequence_motion(0, "立ち")
				var17 = event.compare_angles(var11, yaw_2, 0.1) or var17
				if var17 ~= 0 then
					event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
					event.set_object_sequence_motion(1, "歩き")
					event.delay_object_sequence_motion_track(1, 10)
					var16 = 20
				end
				event.set_object_sequence_motion(1, "立ち")
				helper_888ab2a3(var16)
			end
			event.set_object_sequence_motion(1, "帰ってくれ", 2)
			event.queue_object_sequence_next_motion(1, "立ち", 4)
			event.open_message_window_2(0, "チケットがないなら、帰ってくれ。")
			helper_e494(10670, 60)
			wait_objects(1)
			event.close_voice_stream(1)
			var15 = 1
		end
	end
	if var15 ~= 0 then
		var17 = event.compare_angles(var11, yaw_2, 0.1) or var17
		if var17 ~= 0 then
			event.rotate_object_sequence(1, 0.0, var11, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
			helper_888ab2a3(10)
		end
		event.set_object_sequence_motion(1, "立ち")
		wait_objects(1)
	end
end

--- Helper function.
local function helper_154fc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local argc: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var2)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, var3, var4, var5, 30, 1)
	event.turn_object_sequence_toward(0, var3, var4, var5, 10)
	event.set_object_sequence_motion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.set_camera_look_at(var0, var1, var2)
		var6 = var6 + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	argc = event.get_owned_item_count(353) or argc
	if argc >= 1 then
		event.open_message_window_2(0, "早く行かないとサーカス終わっちゃうよ。")
	else
		event.open_message_window_2(0, "さっきの赤い髪の子\nこっちには来てないと思うんだけどなぁ。")
	end
	helper_75684dd8(0, -1, 5, 256, 208)
end

--- Helper function.
local function helper_13dcc()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "サーカスがある日はにぎやかでいいわね。")
	helper_8132d034(10, 9000050)
end

--- Helper function.
local function helper_f1a4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 10)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.get_character_position(10)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.get_character_rotation(10)
		var10 = out2 or var10
	end
	yaw = event.get_direction_angle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.get_direction_angle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.compare_angles(yaw_2, 3.14, 1.5) or var14
	if var14 ~= 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "後ろから話し掛けるのは、失礼だよね。")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_message_bubble_tail(0, 1)
		return
	end
	var14 = event.compare_angles(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	var14 = event.compare_angles(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 16)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 16)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(20)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "赤い髪の子は見かけませんでしたか？")
	helper_e494(10380, 70)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "う～ん、どうだったかしら・・・")
	helper_e494(10390, 100)
	wait_objects(1)
	var14 = event.compare_angles(3.14, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 16)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 16)
		yaw_2 = vm.f32(3.14)
	else
		event.delay_object_sequence_motion_track(1, 16)
	end
	event.set_object_sequence_motion(1, "あっちの方に", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "確か、向こうのほうへ向かって\n行ったような気がするわ・・・")
	helper_e494(10400, 150)
	event.close_voice_stream(1)
	wait_objects(1)
	var14 = event.compare_angles(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var10, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(11)
end

--- Helper function.
local function helper_13f00()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "お兄ちゃんは、なにしてるの？")
	helper_8132d034(11, 9000060)
end

--- Helper function.
local function helper_102b0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 11)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.get_character_position(11)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.get_character_rotation(11)
		var10 = out2 or var10
	end
	yaw = event.get_direction_angle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.get_direction_angle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.compare_angles(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	var14 = event.compare_angles(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(20)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "ね、ね、君、赤い髪の子見なかった？")
	helper_e494(10420, 90)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	helper_888ab2a3(10)
	event.open_message_window_2(0, "わたし、知らない・・・")
	helper_e494(10430, 60)
	event.close_voice_stream(1)
	wait_objects(1)
	var14 = event.compare_angles(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var10, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(11)
end

--- Helper function.
local function helper_14024()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "どうかしたかい？")
	helper_8132d034(13, 9000070)
end

--- Helper function.
local function helper_14148()
	local flag: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "ここからだと、お月様がよく見えるわ。")
	helper_8132d034(14, 9000080)
	flag = event.get_save_flag(32) or flag
	if flag == 0 then
		event.set_save_flag(32, 1)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "[(!)][r2]ボタンで主人公視点。")
		helper_75684dd8(0, -1, 8, 256, 208)
	end
end

--- Helper function.
local function helper_14428()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "ボクもサーカス見たかったなぁ。")
	helper_8132d034(15, 9000090)
end

--- Helper function.
local function helper_1454c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var17: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 16)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.get_character_position(16)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.get_character_rotation(16)
		var10 = out2 or var10
	end
	pos_x = vm.f32(vm.f32(vm.sin(2.5) * 140) + var0)
	pos_y = vm.f32(var1 + 10.0)
	pos_z = vm.f32(vm.f32(vm.cos(2.5) * 140) + var2)
	event.clear_camera_sequence()
	event.move_camera_sequence_eased(pos_x, pos_y, pos_z, var0, var1 + 50.0, var2, 14, 2, 1.0)
	yaw = event.get_direction_angle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.get_direction_angle(var3, var4, var5, var0, var1, var2) or yaw_2
	var17 = event.compare_angles(var7, yaw, 0.1) or var17
	if var17 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	var17 = event.compare_angles(var10, yaw_2, 0.1) or var17
	if var17 ~= 0 then
		event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(20)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "役所に用があったのにどうしましょう・・・")
	helper_e494(10410, 80)
	event.close_voice_stream(1)
	wait_objects(1)
	var17 = event.compare_angles(var10, yaw_2, 0.1) or var17
	if var17 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var10, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(11)
end

--- Helper function.
local function helper_152a4()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "パームブリンクスっていい町だよな。")
	helper_8132d034(17, 9000100)
end

--- Helper function.
local function helper_153d8()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "サーカスは、もう始まってるよ。")
	helper_8132d034(18, 9000110)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 1, which map data, a script or the engine runs by number.
function script.event_1()
	local argc: s32 = 0
	argc = event.get_owned_item_count(353) or argc
	if argc >= 1 then
		helper_13428()
	else
		event.set_save_flag(2, 1)
		helper_e670()
	end
end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	helper_7334e9f5()
	helper_8d25bb56()
	event_99()
	event.take_memory_card_load_state()
	event.set_character_position(0, 2100.0, 0.0, 2200.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(2100.0, 30.0, 2200.0)
	event.set_camera_position(2100.0, 30.0, 2080.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.set_time_of_day(24.0)
	event.load_event_script("m06/m06b.stb", 154)
end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("m06/m06b.stb", 151)
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	event.set_save_counter(5, 1)
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("m06/m06b.stb", 152)
end

--- Event 153, which map data, a script or the engine runs by number.
function script.event_153()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("m06/m06b.stb", 155)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_10ec8(0)
end

--- Event 510, which map data, a script or the engine runs by number.
script.event_510 = helper_154fc

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "役所は閉まっているようだ。")
	helper_75684dd8(0, -1, 5, 0, 0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	event.get_triggered_event_data_2(14)
	if var0 == 8 then
		helper_10ec8(1)
		return
	end
	argc = event.get_owned_item_count(353) or argc
	if var0 == 10 then
		if argc >= 1 then
			helper_13dcc()
		else
			event.set_save_flag(3, 1)
			helper_f1a4()
		end
		return
	end
	if var0 == 11 then
		if argc >= 1 then
			helper_13f00()
		else
			flag = event.get_save_flag(2) or flag
			flag_2 = event.get_save_flag(3) or flag_2
			if flag == 1 and flag_2 == 1 then
				do
					local out1, out2, out3 = event.get_previous_camera_position()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local out1, out2, out3 = event.get_previous_camera_look_at()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				event.set_camera_position(pos_x, pos_y, pos_z)
				event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
				event.initialize_event()
				vm.wait(5)
				event.load_event_script("m06/m06b.stb", 154)
			else
				helper_102b0()
			end
		end
		return
	end
	if var0 == 13 then
		helper_14024()
		return
	end
	if var0 == 14 then
		helper_14148()
		return
	end
	if var0 == 15 then
		helper_14428()
		return
	end
	if var0 == 16 then
		helper_1454c()
		return
	end
	if var0 == 17 then
		helper_152a4()
		return
	end
	if var0 == 18 then
		helper_153d8()
		return
	end
end

--- Event 10020, which map data, a script or the engine runs by number.
function script.event_10020()
	event.initialize_event()
	vm.wait(1)
	event.set_save_flag(1, 0)
	event.set_save_flag(2, 0)
	event.set_save_flag(3, 0)
	event.add_inventory_item(353)
	event.load_event_script("m06/m06b.stb", 152)
end

--- Event 10060, which map data, a script or the engine runs by number.
function script.event_10060()
	event.stop_music(0)
	event.stop_environment_music()
	helper_888ab2a3(6)
	event.load_event_script("m06/m06b.stb", 155)
end

return script
