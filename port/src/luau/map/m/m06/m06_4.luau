--!strict
-- map/m/m06/m06_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_11b8f58c = require("@lib/event/helper_11b8f58c")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_8d25bb56 = require("@lib/event/helper_8d25bb56")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_bd088cc0 = require("@lib/event/helper_bd088cc0")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_fb53b407 = require("@lib/event/helper_fb53b407")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_message_answer = require("@lib/event/wait_message_answer")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_137ec()
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
		event.open_message_window_2(0, "[UNI00c8] da maleducati parlare a qualcuno\nstandogli dietro le spalle.")
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
	wait_frames(14)
	event.set_mouth_motions(1, "会話", 0, "座り", 0)
	event.open_message_window_2(0, "Che magnifico cielo stellato!")
	helper_0ffc2526(0, -1, 9, 0, 0)
	event.reset_mouth_motions()
end

--- Helper function.
local function helper_e9c4()
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
		event.open_message_window_2(0, "[UNI00c8] da maleducati parlare a qualcuno\nstandogli dietro le spalle.")
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
	wait_frames(14)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "Avete visto passare un ragazzino\ncoi capelli rossi?")
	helper_11b8f58c(10350, 100)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "座り", 4)
	event.open_message_window_2(0, "No. Visto niente?")
	helper_11b8f58c(10360, 60)
	event.open_message_window_2(0, "[UNI00c8] andato verso il Municipio.")
	helper_11b8f58c(10370, 80)
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
local function helper_1128c(arg0: s32)
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
		wait_frames(var16)
		event.open_voice_stream_wave(1, 10665)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, "Ti serve un biglietto per entrare.\n(Premi (#) per accedere al Menu.)")
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
				helper_fb53b407()
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
				wait_frames(var16)
			end
			event.set_object_sequence_motion(1, "帰ってくれ", 2)
			event.queue_object_sequence_next_motion(1, "立ち", 4)
			event.open_message_window_2(0, "Non puoi entrare senza biglietto!")
			helper_11b8f58c(10670, 90)
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
			wait_frames(10)
		end
		event.set_object_sequence_motion(1, "立ち")
		wait_objects(1)
	end
end

--- Helper function.
local function helper_15910()
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
		event.open_message_window_2(0, "Sbrigati o il circo\nfinir[UNI00e0]!")
	else
		event.open_message_window_2(0, "Non credo che il ragazzo dai\ncapelli rossi sia passato di qui.")
	end
	helper_75684dd8(0, -1, 5, 256, 208)
end

--- Helper function.
local function helper_141b0()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Il circo rende tutto\ncos[UNI00ec] allegro!")
	helper_bd088cc0(10, 9000050)
end

--- Helper function.
local function helper_f538()
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
		event.open_message_window_2(0, "[UNI00c8] da maleducati parlare a qualcuno\nstandogli dietro le spalle.")
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
	wait_frames(20)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "[UNI00c8] passato di qui un bambino coi capelli rossi?")
	helper_11b8f58c(10380, 80)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "Oh, s[UNI00ec]! Proprio ora.")
	helper_11b8f58c(10390, 100)
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
	event.open_message_window_2(0, "Non ho dubbi: correva da quella parte!")
	helper_11b8f58c(10400, 150)
	event.close_voice_stream(1)
	wait_objects(1)
	var14 = event.compare_angles(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var10, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait_frames(11)
end

--- Helper function.
local function helper_142e4()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Cosa stai facendo?")
	helper_bd088cc0(11, 9000060)
end

--- Helper function.
local function helper_10664()
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
	wait_frames(20)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "Ehi, ehi, hai visto\nun ragazzo coi capelli rossi?")
	helper_11b8f58c(10420, 90)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	wait_frames(10)
	event.open_message_window_2(0, "Chi io? No, mi spiace.")
	helper_11b8f58c(10430, 90)
	event.close_voice_stream(1)
	wait_objects(1)
	var14 = event.compare_angles(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var10, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait_frames(11)
end

--- Helper function.
local function helper_14408()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "C'[UNI00e8] qualcosa che non va?")
	helper_bd088cc0(13, 9000070)
end

--- Helper function.
local function helper_1453c()
	local flag: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Si riesce a vedere la\nluna da qui!")
	helper_bd088cc0(14, 9000080)
	flag = event.get_save_flag(32) or flag
	if flag == 0 then
		event.set_save_flag(32, 1)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "[(!)]Premi il [r2] per la\n   visuale in soggettiva.")
		helper_75684dd8(0, -1, 8, 256, 208)
	end
end

--- Helper function.
local function helper_1482c()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Avrei voluto vedere il circo!")
	helper_bd088cc0(15, 9000090)
end

--- Helper function.
local function helper_14950()
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
	wait_frames(20)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "Mi spiace, devo andare al Municipio!")
	helper_11b8f58c(10410, 80)
	event.close_voice_stream(1)
	wait_objects(1)
	var17 = event.compare_angles(var10, yaw_2, 0.1) or var17
	if var17 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var10, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait_frames(11)
end

--- Helper function.
local function helper_15698()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Vallecatini [UNI00e8] una citt[UNI00e0] magnifica!")
	helper_bd088cc0(17, 9000100)
end

--- Helper function.
local function helper_157dc()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Il circo [UNI00e8] gi[UNI00e0] iniziato!")
	helper_bd088cc0(18, 9000110)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 1, which map data, a script or the engine runs by number.
function script.event_1()
	local argc: s32 = 0
	argc = event.get_owned_item_count(353) or argc
	if argc >= 1 then
		helper_137ec()
	else
		event.set_save_flag(2, 1)
		helper_e9c4()
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
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1128c(0)
end

--- Event 510, which map data, a script or the engine runs by number.
script.event_510 = helper_15910

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Il Municipio sembra chiuso.")
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
		helper_1128c(1)
		return
	end
	argc = event.get_owned_item_count(353) or argc
	if var0 == 10 then
		if argc >= 1 then
			helper_141b0()
		else
			event.set_save_flag(3, 1)
			helper_f538()
		end
		return
	end
	if var0 == 11 then
		if argc >= 1 then
			helper_142e4()
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
				helper_10664()
			end
		end
		return
	end
	if var0 == 13 then
		helper_14408()
		return
	end
	if var0 == 14 then
		helper_1453c()
		return
	end
	if var0 == 15 then
		helper_1482c()
		return
	end
	if var0 == 16 then
		helper_14950()
		return
	end
	if var0 == 17 then
		helper_15698()
		return
	end
	if var0 == 18 then
		helper_157dc()
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
	wait_frames(6)
	event.load_event_script("m06/m06b.stb", 155)
end

return script
