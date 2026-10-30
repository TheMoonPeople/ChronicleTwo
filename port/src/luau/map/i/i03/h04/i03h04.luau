--!strict
-- map/i/i03/h04/i03h04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0263ba85 = require("@lib/event/helper_0263ba85")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_183cf34f = require("@lib/event/helper_183cf34f")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_6a61b74b = require("@lib/event/helper_6a61b74b")
local helper_6f1a51c5 = require("@lib/event/helper_6f1a51c5")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_81437291 = require("@lib/event/helper_81437291")
local helper_87260223 = require("@lib/event/helper_87260223")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8aa6dccc = require("@lib/event/helper_8aa6dccc")
local helper_9aa8a95a = require("@lib/event/helper_9aa8a95a")
local helper_ac9af6e9 = require("@lib/event/helper_ac9af6e9")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bc9be28d = require("@lib/event/helper_bc9be28d")
local helper_c7fcb51a = require("@lib/event/helper_c7fcb51a")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_fd981dba = require("@lib/event/helper_fd981dba")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_125bc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: any = 0
	local var3: any = 0
	local at: number = 0
	return vm.guard(function()
		var0 = 24
		var1 = event.get_gyorace_value(3) or var1
		if var1 == 0 then
			event.open_message_window_2(0, "最終調整をする水槽はどれにする？")
		end
		if var1 == 1 then
			event.open_message_window_2(
				0,
				"おお！！やったじゃないか。\nそれじゃあ、続けて本戦に移るぞ。"
			)
			at = 1
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(0, "本戦の前の最終調整水槽を選んでくれ。")
		end
		if var1 == 2 then
			event.open_message_window_2(
				0,
				"ひゃああ！！すごいじゃないか。\n次は、ついに決勝だぞ。\nさあ、慎重に最終調整水槽を\n選んでくれ。"
			)
		end
		at = 2
		helper_1c04a0eb(var0, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(
				0,
				"第一水槽： ペースを守れ \n第ニ水槽：   力の限り   \n第三水槽： 最初が勝負だ \n第四水槽：ラストにかけろ\n第五水槽：バトルで決めろ\n第六水槽：  中盤で行け  "
			)
			event.set_message_selection_top_line(0, 0)
			at = 3
			var2 = helper_bac0e30d(0, -1, 8, 0, 0, 6, 0)
			if var2 == -1 then
				if var1 == 0 then
					event.set_message_window_mode(0, 1)
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_option(0, 0, 0)
					event.set_message_window_option(0, 4, -1, -1)
					return -1
				else
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_mode(0, 5)
					event.set_message_draw_speed(0, 1)
					event.open_message_window_2(
						0,
						"水槽を選ばないと、このレースは\nリタイヤになってしまいます。\nよろしいですか？"
					)
					at = 4
					var3 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
					event.set_message_window_mode(0, 1)
					if var3 == 0 then
						event.set_gyorace_value(3, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_selection_top_line(0, 0)
						event.set_message_window_option(0, 0, 0)
						event.set_message_window_option(0, 4, -1, -1)
						at = 5
						vm.wait(5)
						return -1
					end
				end
			else
				break
			end
		end
		event.set_gyorace_value(0, var2)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		if var1 == 0 then
			event.open_message_window_2(
				0,
				"まずは予戦だ。\n本戦への出場条件は１位通過だ。\nがんばってな～"
			)
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if var1 == 1 then
			event.open_message_window_2(
				0,
				"では、いよいよ本戦だ。\n決勝へ残る条件は、２位以上で通過だ。\nがんばってな～"
			)
		end
		if var1 == 2 then
			event.open_message_window_2(
				0,
				"さあ、覚悟は決まったかな。\nいよいよこれでラストだ。\n３位以上だと賞品がもらえるよ～。<page>でも、やるからには、\nやっぱり優勝を狙って行こうよ！"
			)
		end
		at = 6
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 7
		helper_888ab2a3(30)
		event.stop_music(0)
		helper_81437291()
		at = 8
		vm.wait(8)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 3 then
				var2 = received[1] :: number
			end
			if at <= 1 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 2 then
				var2 = helper_7d54f41c(0, -1, 8, 0, 0, 6, 0)
			end
			return -1
		end
		if at <= 5 then
			if at == 4 then
				var3 = received[1] :: number
			end
			return -1
		end
		if at <= 8 then
			if at <= 6 then
				helper_038a2e4d(30)
			end
			if at <= 7 then
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_15b54()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(48, 0)
	local at: number = 0
	return vm.guard(function()
		helper_bc9be28d()
		frame[8] = event.get_gyorace_value(1) or frame[8]
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		frame[9] = event.get_gyorace_value(3) or frame[9]
		if frame[9] == 0 then
			if 0 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 1)
			at = 1
			if helper_125bc() == -1 then
				return -1
			end
		end
		if frame[9] == 1 then
			if 1 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 2)
			at = 2
			if helper_125bc() == -1 then
				return -1
			end
		end
		if frame[9] == 2 then
			if 2 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 0)
		end
		event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
		event.set_object_handle_visible(8, 0)
		event.play_sound_effect(global0, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		at = 3
		helper_888ab2a3(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		at = 4
		wait_camera()
		event.stop_sound_effect(global0, 0)
		event.play_sound_effect(global0, 3)
		frame[6] = 1
		event.set_message_window_mode(1, 0)
		event.set_message_window_option(1, 7, 20, 100, 20, 128)
		event.set_message_window_option(1, 8, 0)
		frame[6] = 0
		frame[12] = 0
		frame[13] = 0
		frame[14] = 0
		while frame[6] < 6 do
			event.set_gyorace_value(5, 1, vm.i32(1 + frame[6]), frame[6])
			event.set_gyorace_value(6, 1, vm.i32(7 + frame[6]), frame[6])
			if frame[6] == frame[8] then
				frame[12] = 1
			else
				frame[7] = vm.float_bits(event.get_random_number(24)) or frame[7]
				while true do
					frame[45] = 0
					while frame[14] > frame[45] do
						if frame[vm.index(vm.i32(frame[45] + 14), 48)] == frame[7] then
							break
						else
							frame[45] = vm.i32(frame[45] + 1)
						end
					end
					if frame[14] == frame[45] then
						break
					else
						frame[7] = vm.float_bits(event.get_random_number(24)) or frame[7]
					end
				end
				frame[vm.index(vm.i32(frame[14] + 14), 48)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				if vm.i32(frame[6] + 1) <= 3 then
					if frame[13] == 0 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 15)
					end
					if frame[13] == 1 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 16)
					end
					frame[13] = vm.i32(frame[13] + 1)
				end
			end
			frame[6] = vm.i32(frame[6] + 1)
		end
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
		)
		at = 5
		helper_183cf34f(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
		)
		at = 6
		helper_183cf34f(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
		)
		at = 7
		helper_183cf34f(1, -1, 4, 0, 0, 90)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		if frame[8] == 0 then
			event.set_character_active(1, 8)
			event.set_character_position(8, 0.0, 68.97, -470.0)
			event.set_save_flag(41, 1)
			event.set_character_position(15, 30.0, 20.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 0.0, 36.0, -470.0)
			event.set_character_motion(0, "1位", 0)
		end
		if frame[8] == 1 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 30.0, 20.0, -470.0)
			event.set_character_motion(0, "2位", 0)
		end
		if frame[8] == 2 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, 30.0, 20.0, -470.0)
			event.set_character_position(0, -30.0, 16.0, -470.0)
			event.set_character_motion(0, "3位", 0)
		end
		event.set_character_active(15)
		event.set_character_active(16)
		event.set_camera_sequence_position(-1.26, 25.59, -336.37)
		event.set_camera_sequence_look_at(0.0, 36.39, -471.19)
		event.start_crossfade(60)
		at = 8
		helper_888ab2a3(90)
		event.set_object_handle_visible(8, 1)
		frame[48] = event.get_gyorace_value(2) or frame[48]
		do
			local out1, out2 = event.get_gyorace_value(4, frame[48], vm.i32(frame[8] + 1))
			frame[46] = out1 or frame[46]
			frame[47] = out2 or frame[47]
		end
		event.play_sound_effect(global1, 0)
		at = 9
		helper_ac9af6e9(0, vm.i32(frame[8] + 1), frame[46], frame[47])
		event.add_inventory_item(frame[46], frame[47])
		at = 10
		helper_d61bc810(1)
		if frame[8] == 0 then
			event.set_gyorace_value(7)
		end
		event.fade_out_screen(30)
		at = 11
		helper_888ab2a3(30)
		event.set_character_active(0, 8)
		event.delete_character(15)
		event.delete_character(16)
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		at = 12
		helper_888ab2a3(30)
		return 1
	end, function(received: { any })
		if at <= 1 then
			return -1
		end
		if at <= 2 then
			return -1
		end
		if at <= 12 then
			if at <= 3 then
				helper_344d6cd8()
			end
			if at <= 4 then
				frame[6] = 1
				frame[6] = 0
				frame[12] = 0
				frame[13] = 0
				frame[14] = 0
				local _ = frame[6] < 6
				local _ = frame[6] == frame[8]
				frame[12] = 1
				frame[45] = 0
				local _ = frame[14] > frame[45]
				local _ = frame[vm.index(vm.i32(frame[45] + 14), 48)] == frame[7]
				frame[45] = vm.i32(frame[45] + 1)
				local _ = frame[14] == frame[45]
				frame[vm.index(vm.i32(frame[14] + 14), 48)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				local _ = vm.i32(frame[6] + 1) <= 3
				local _ = frame[13] == 0
				local _ = frame[13] == 1
				frame[13] = vm.i32(frame[13] + 1)
				frame[6] = vm.i32(frame[6] + 1)
				helper_0263ba85(1, -1, 4, 0, 0, 60)
			end
			if at <= 5 then
				helper_0263ba85(1, -1, 4, 0, 0, 60)
			end
			if at <= 6 then
				helper_0263ba85(1, -1, 4, 0, 0, 90)
			end
			if at <= 7 then
				helper_038a2e4d(90)
			end
			if at <= 8 then
				helper_c7fcb51a(0, vm.i32(frame[8] + 1), frame[46], frame[47])
			end
			if at <= 9 then
				helper_6f1a51c5(1)
			end
			if at <= 10 then
				helper_038a2e4d(30)
			end
			if at <= 11 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_136e4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local omake_flag: s32 = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: any = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local var21: any = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(0, "立ち", 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 0 then
		event.open_message_window_2(0, "お、お姉ちゃんもやるのかい？")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.open_message_window_2(0, "私はいいです。<page>ここはユリスの出番ね。")
		helper_0ffc2526(0, -1, 0, var0, 0)
		return
	end
	omake_flag = event.is_extra_mode() or omake_flag
	if omake_flag ~= 0 then
		event.open_event_menu(23, 0)
		vm.wait(3)
		event.fade_in_screen(15)
		do
			local out1, _, _, _ = event.get_menu_results_4()
			var3 = out1 or var3
		end
		if var3 == 1000 then
			event.fade_out_music(30)
			event.fade_out_screen(30)
			helper_888ab2a3(30)
			event.stop_music(0)
			helper_81437291()
		end
		return
	end
	var7 = event.get_gyorace_value(5) or var7
	if var7 >= 3 then
		event.open_message_window_2(
			0,
			"本大会のレースはすべて終了しました。\n次回の開催をお楽しみに！"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.stop_music(0)
		event.set_menu_value(1)
		helper_fd981dba()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(7)
	end
	event.open_message_window_2(0, "ギョレースがはじまるよ～。\n参加するかい？")
	helper_1c04a0eb(var0, -1, 0, 0)
	while true do
		event.open_message_window_2(0, "レースに参加する\n説明をきく\n今回の賞品をチェック\nやめておく")
		var8 = helper_8aa6dccc(0, -1, 0, var0, 4, 3)
		if var8 == -1 or var8 == 3 then
			event.open_message_window_2(0, "見るのも楽しいけど、参加すると、\nもっと熱中できますよ")
			helper_1c04a0eb(var0, -1, 0, 0)
			return
		end
		if var8 == 1 then
			event.open_message_window_2(
				0,
				"１回のギョレース大会で、レース\nには３回チャレンジできる。<page>ただし、入賞して賞品を獲得した\n魚は、その大会の他のレースには\n出られなくなるぞ。"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"私に話しかけて、レースに参加\nすることを宣言したら、まずは\n出走させる魚を選ぶことになる。<page>魚はアクアリウムの生活水槽に\n入れてないとレースに出すことは\nできないからな。"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"出走させる魚が決まったら、\n次に出場するクラスを選ぶ。<page>ビギナーからマスタークラスまで、\n魚の強さに合ったクラスを選ぶといい。<page>ただし、あるクラスで優勝すると、\nそのクラスには２度と出場できなくなって、\n次のクラスに参加しないといけなくなる。"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"最強のマスタークラスだけは、\n優勝しても何度も出走させる\nことができる。<page>次にレース前に魚を入れて\n最終調整する水槽を選ぶんだ。\n水槽の水にはびみょ～な違いがあって、\n選んだ水槽によって魚の動きが変化する。"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"その魚の能力をおぎなう水槽に入れてやれば、\n意外な力を発揮するかも知れないな。<page>最終調整が終わるといよいよレース開始だ。\nここまでくるとあとは見ているだけとなる。\n自分の育てた魚を存分に応援してやってくれ。"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"レースは予戦、本戦、決勝の順番で進む。\n入賞するためには、予戦で１位通過、\n本戦で２位以上、決勝で３位以上に\n入る必要がある。<page>しかし、やるからには\n目標は「優勝」だ。\nがんばってくれ。"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
		end
		if var8 == 2 then
			event.open_message_window_2(
				0,
				"ビギナークラス\nジュニアクラス\nシニアクラス\nマスタークラス"
			)
			var9 = helper_8aa6dccc(0, -1, 0, var0, 4, 0)
			if var9 ~= -1 then
				event.open_message_window_2(0, "今回の賞品は・・・")
				helper_1c04a0eb(var0, -1, 0, 0)
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 1)
					var10 = out1 or var10
					var13 = out2 or var13
				end
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 2)
					var11 = out1 or var11
					var14 = out2 or var14
				end
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 3)
					var12 = out1 or var12
					var15 = out2 or var15
				end
				helper_6a61b74b(var10, var13, var11, var14, var12, var15)
			end
		end
		if var8 == 0 then
			break
		end
	end
	var16 = event.get_gyorace_value(3) or var16
	var17 = event.get_message_window_option(0, 2) or var17
	if var17 < 1 then
		event.open_message_window_2(
			0,
			"おっと、出場できる魚を\nお持ちじゃないようだ。<page>魚を育てて、またおいで。"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	var7 = event.get_gyorace_value(5) or var7
	event.set_message_number(0, 1, vm.i32(var7 + 1))
	event.open_message_window_2(0, "本大会の第[数値１]ステージだ。\nさあ、出走させる魚を選んでくれ。")
	helper_1c04a0eb(var0, -1, 0, 0)
	while true do
		event.open_event_menu(15, 0)
		vm.wait(22)
		do
			local out1, out2, out3 = event.get_menu_results_3()
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		if var18 == -1 then
			return
		elseif var20 ~= 0 then
			event.open_message_window_2(0, "この魚は入賞しているから、\n他の魚を選んでくれ。")
			helper_1c04a0eb(var0, -1, 0, 0)
		else
			break
		end
	end
	if var16 == 0 then
		event.open_message_window_2(0, "次は出走させるクラスを選んでくれ。")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "ビギナークラス\nジュニアクラス\nシニアクラス\nマスタークラス")
		event.set_message_selection_top_line(0, 0)
		var21 = helper_bac0e30d(0, -1, 8, 0, 0, 4, 0)
	else
		var21 = event.get_gyorace_value(2) or var21
	end
	event.set_message_window_mode(0, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 4, -1, -1)
	if var21 == -1 then
		return
	end
	if var21 == 0 and bit32.band(var19, 1) == 0 then
		event.open_message_window_2(
			0,
			"この魚はビギナークラスで優勝しているから、\n別のクラスに出場してくれ。"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var21 == 1 and bit32.band(var19, 2) == 0 then
		event.open_message_window_2(
			0,
			"この魚はジュニアクラスで優勝しているから、\n別のクラスに出場してくれ。"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var21 == 2 and bit32.band(var19, 4) == 0 then
		event.open_message_window_2(
			0,
			"この魚はシニアクラスで優勝しているから、\n別のクラスに出場してくれ。"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var16 == 0 then
		event.set_gyorace_value(2, var21)
	end
	helper_125bc()
	vm.wait(30)
end

--- Helper function.
local function helper_dedc()
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local var4: s32 = 0
	local omake_flag: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	active_chr_no = event.get_playable_character() or active_chr_no
	var4 = event.get_chapter() or var4
	omake_flag = event.is_extra_mode() or omake_flag
	if var2 == 161 then
		if var4 < 6 then
			event.open_message_window_2(
				0,
				"かみさんは、どうしてギョレースの\n面白さが分からないのかねえ。\nこんなに面白いものはないのにな。"
			)
		else
			event.open_message_window_2(
				0,
				"オレさまの魚は、\nマスタークラスで連勝中なんだ。\nま、今回のレースでも優勝まちがいなしさ。"
			)
		end
	end
	if var2 == 171 then
		event.open_message_window_2(
			0,
			"また、ウチのだんながここに\n来てるんじゃないかと思って探しに来たのよ。\nあら、意外と面白そうね。"
		)
	end
	if var2 == 169 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"レースの結果は、最終調整の\nやり方で大きく違って来るの。\n選ぶ時は良く考えてね。<page>もっとも、私の魚には\nかなわないでしょうけど・・・"
			)
		else
			event.open_message_window_2(
				0,
				"しょうこりもなく、\nまたいらしたの？<page>まぁ、レースに出るのは\nかまいませんけど、私の魚の\n進路妨害だけはなさらないでね。"
			)
		end
	end
	if var2 == 167 then
		if var4 < 7 then
			if active_chr_no ~= 1 then
				event.open_message_window_2(
					0,
					"ユリスお兄ちゃんは、レースに参加しないの？\n参加するんだったら教えてよ。\nワタチ、応援しちゃうわよ。"
				)
			else
				event.open_message_window_2(
					0,
					"モニカお姉ちゃんは、レースに参加しないの？\n参加するんだったら教えてよ。\nワタチ、応援しちゃうわよ。"
				)
			end
		elseif active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"ワタチ、お魚なんて\n大キライ。\n早く帰りたいよー。<page>大人は何が楽しいのかしら。\nねえ、ユリスお兄ちゃん\n教えてよぉ。"
			)
		else
			event.open_message_window_2(
				0,
				"ワタチ、お魚なんて\n大キライ。\n早く帰りたいよー。<page>大人は何が楽しいのかしら。\nねえ、モニカお姉ちゃん\n教えてよぉ。"
			)
		end
	end
	if var2 == 166 then
		event.open_message_window_2(
			0,
			"僕はギャンブルなんてしないよ。<page>彼女がどうしてもって言うから、\n仕方なくてね。"
		)
	end
	if var2 == 165 then
		if var4 < 7 then
			event.open_message_window_2(
				0,
				"ワシはなぜか、魚が泳ぐのを見てると、\n元気になるのじゃ。\n若さを保つ秘訣って訳じゃな。"
			)
		else
			event.open_message_window_2(
				0,
				"今日は、孫を連れて来ておるんじゃ。\nはて、どこに行ったのかのう。\nちょっと目を離したすきに・・・"
			)
		end
	end
	if var2 == 160 then
		event.open_message_window_2(
			0,
			"あれは、直線コースで伸びるな。\nどいつかって？ふふーん、秘密だよ。"
		)
	end
	if var2 == 172 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"見て、３番のウロコ！\nピカピカしてナイフみたい。<page>これは絶対クルわね、\n間違いないわ！"
			)
		else
			event.open_message_window_2(
				0,
				"一回のはずが、はまっちゃってね。\n今じゃ、毎回レースに参加してるの。\nあー、さっきの最終調整、失敗したかしら・・・"
			)
		end
	end
	if var2 == 158 then
		if var4 < 7 then
			event.open_message_window_2(
				0,
				"パパとよく釣りに行くんだけど、\n今まで見たことのないお魚さんが\nたくさんいるよ！！"
			)
		else
			event.open_message_window_2(
				0,
				"うわー、かわいい魚が\nたくさん泳いでるー！\n何だ、あの魚、馬みたーい！！<page>・・・あれ？おじいちゃんが\nいなくなっちゃった、\nどうしよう。"
			)
		end
	end
	if var2 == 159 then
		event.open_message_window_2(
			0,
			"ここはギョレース会場だよ。<page>あまり熱くならない方が\n身のためだぜ。"
		)
	end
	if var2 == 162 then
		event.open_message_window_2(
			0,
			"ここはギョレース会場だよ。<page>こういうもんは熱くなんなきゃ\nつまんねぇぜ。"
		)
	end
	if var2 == 168 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"魚なんて、どれもいっしょで\n見分けなんてつかないよ・・・<page>こうなったら、フィーリングで\n選ぶしかないわね！"
			)
		else
			event.open_message_window_2(0, "彼氏の魚が今度のレースに出るの。\nドキドキしちゃうわ。")
		end
	end
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	global0 = 0
	global1 = 0
	event.set_save_control_bits(1, 1)
	helper_bc9be28d()
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 1)
	event.set_gyorace_value(7)
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(global0, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	helper_888ab2a3(90)
	event.stop_sound_effect(global0, 0)
	event.play_sound_effect(global0, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for var0 = 0, 5 do
		event.set_message_inserted_string(1, 1 + var0, "０１２３４５６７８９ ")
		event.set_message_inserted_string(1, 7 + var0, "９９：９９：９９")
	end
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_183cf34f(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_183cf34f(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
	)
	show_message(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	helper_888ab2a3(35)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local omake_flag: s32 = 0
	local var1: s32 = 0
	local var2: any = 0
	omake_flag = event.is_extra_mode() or omake_flag
	var1 = event.get_gyorace_value(5) or var1
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	if omake_flag == 0 then
		if var1 <= 0 then
			event.open_message_window_2(0, "『ギョレース会場』から出ますか？")
		else
			event.open_message_window_2(
				0,
				"会場を出ると、ギョレースは終わって\nしまいます。よろしいですか？"
			)
		end
	else
		event.fade_out_screen(10)
		helper_888ab2a3(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "タイトルに戻りますか？")
	end
	var2 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if var2 == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.stop_music(0)
		if 0 < var1 then
			event.set_menu_value(1)
		end
		helper_fd981dba()
		event.fade_in_screen(30)
		if omake_flag == 0 then
			event.jump_to_map_2(-1, "s45")
			vm.wait(6)
		else
			event.set_scene_exit_flag(1)
		end
	end
	return 1
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	print("---401----------------------------\n")
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local var0: s32 = 0
	local var1: s32 = 0
	event.initialize_event()
	event.set_save_control_bits(1, 1)
	event.load_music(193)
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	var0 = helper_15b54()
	event.play_music(0)
	if var0 == 0 then
		event.set_character_motion(0, "がっかりL", 0)
		var1 = event.get_gyorace_value(3) or var1
		if var1 == 0 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(0, "残念だったね。\nこれにこりずにまた挑戦しな～。")
		end
		if var1 == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"やっぱり本戦に出てくる\nライバルたちは手強いね～\nこれにこりずにまた挑戦しな～"
			)
		end
		if var1 == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"残念。でも、決勝まで残れるだけでも\nすごいじゃないか。\nまた次も期待してるから\nがんばってくれよ。"
			)
		end
		helper_0ffc2526(0, -1, 24, 0, 0)
	end
	event.delete_character_extension_packs(0)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.set_save_control_bits(1, 1)
	event.initialize_event()
	event.load_music(193)
	helper_bc9be28d()
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(global0, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	helper_888ab2a3(90)
	event.stop_sound_effect(global0, 0)
	event.play_sound_effect(global0, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for var0 = 0, 5 do
		event.set_gyorace_value(5, 1, 1 + var0, var0)
		event.set_gyorace_value(6, 1, 7 + var0, var0)
	end
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_183cf34f(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_183cf34f(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
	)
	show_message(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	helper_888ab2a3(35)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		if var0 == 24 then
			at = 1
			helper_136e4()
		else
			at = 2
			helper_dedc()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_87260223()
			end
			return 0
		end
		return nil
	end)
end

return script
