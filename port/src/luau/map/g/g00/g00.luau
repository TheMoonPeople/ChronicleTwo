--!strict
-- map/g/g00/g00.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1505ebf3 = require("@lib/event/helper_1505ebf3")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_73eddd6a = require("@lib/event/helper_73eddd6a")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bc227c8c = require("@lib/event/helper_bc227c8c")
local helper_c0869c7f = require("@lib/event/helper_c0869c7f")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d7885d22 = require("@lib/event/helper_d7885d22")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_1f748(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"わしはここに住む事になったが\nバース壱号の事も心配じゃ。<page>今まで通り、列車は\nわしが動かすからな。<page>ボルネオはちと荒っぽいし、\nトムはまだ若造じゃからの。<page>これからは、この家と列車を\n行き来する事になるのう。<page>大変じゃ・・・"
				)
			else
				event.open_message_window_2(arg0, "スティーブの調子はどうじゃな？")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "部屋でおとなしくしてるなんて、\nがまんできないぞ。")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"草木や花は世話した分だけ\nキッチリ育ちます。手を抜くなんて\nできませんぜ。"
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"秘密基地は大丈夫かな？\n誰かに確かめて来て欲しいけど、\n秘密だから頼めないよなぁ・・・"
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"むらさき色って素晴らしい色だよ。\n暖かいようで冷たくて、\n明るいようで暗くてさ。"
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "病に苦しむ人がいるなら、\nどこへでも行くつもりだよ。")
		end
		if arg1 == 7 then
			event.open_message_window_2(arg0, "どこに行っても美味い物を作るのが\nプロの料理人です。")
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "やっぱりお家はがんじょうな方が\n良いじゃない？")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"木の実も美味いけど、やっぱ\nあの赤いのが最高だ。\nまた、持ってきてくれよな。"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"書物にとって湿気は大敵です。\n水の近くに住むなんてとんでもない。"
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(
				arg0,
				"おしゃれでも可愛くもないけど、\n私にしか作れない服を作っていきます。"
			)
		end
		if arg1 == 12 then
			event.open_message_window_2(arg0, "新しい場所で心機一転だ。\n初心に戻ってパンを焼くよ。")
		end
		if arg1 == 13 then
			event.open_message_window_2(arg0, "何でも良いから\n派手にぶっ壊したいぜ。")
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "未知のモンスターを発見したら、\nただちに報告するように。")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"まだ男だ女だと区別する奴がいるけど、\n剣の道は剣の道だ。強い奴が正しいのさ。"
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "こんな小さな家に、家族だけで住むのも\n悪くないかもな。")
		end
		if arg1 == 17 then
			event.open_message_window_2(arg0, "モートンはちゃんとやっているかな。\n心配だ・・・")
		end
		if arg1 == 18 then
			event.open_message_window_2(arg0, "まだ教会のない町があるのなら、\n私がそこに赴きましょう。")
		end
		if arg1 == 19 then
			event.open_message_window_2(
				arg0,
				"最近はあまり月の事を考えなくなったよ。\nトモダチがたくさん出来たからかな？"
			)
		end
		if arg1 == 20 then
			event.open_message_window_2(arg0, "土地が違えば魚も変わる。\n釣りの仕方も工夫しないとな。")
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "ここの水は魚が良く育ちそうだわ。")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"パトリったら、また女の人の絵を\n描き始めたの。私以上の美人に\nするんですって。"
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(
				arg0,
				"虫ってどうしてあんな気味の悪い形を\nしているのかしら・・・"
			)
		end
		if arg1 == 24 then
			event.open_message_window_2(
				arg0,
				"もっとかわいいお家にしてちょうだい。\nかわいさに限界なんてないのよ！"
			)
		end
		if arg1 == 25 then
			event.open_message_window_2(arg0, "まさかこの歳になって引っ越すとは\n思わなかったよ。")
		end
	else
		helper_1505ebf3(arg0, arg1)
	end
end

--- Helper function.
local function helper_20a60()
	local var1: s32 = 0
	local var2: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	helper_1f748(0, var2)
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

--- Helper function.
local function helper_20f2c()
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.set_character_motion(0, "立ち")
	event.set_character_motion(var1, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	var4 = 0
	if var2 == 10 or var2 == 18 then
		var4 = 8
	end
	if var2 == 1 or var2 == 6 or var2 == 17 then
		var4 = 16
	end
	if var2 == 2 or var2 == 15 or var2 == 16 or var2 == 19 or var2 == 20 or var2 == 21 or var2 == 22 then
		var4 = 24
	end
	if var2 == 3 or var2 == 4 or var2 == 5 or var2 == 7 or var2 == 8 or var2 == 23 or var2 == 24 then
		var4 = 32
	end
	if var2 == 9 or var2 == 11 or var2 == 13 then
		var4 = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
	event.set_message_window_option(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.get_character_position(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.get_character_rotation(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.get_character_position(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.get_character_rotation(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.get_look_angle(var5 - var11, var7 - var13) or var17
	event.set_character_rotation(0, var14, var17, var16)
	var18 = event.get_look_angle(var11 - var5, var13 - var7) or var18
	event.set_character_rotation(var1, var8, var18, var10)
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.get_function_point_position("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.set_camera_position(var20, var21, var22)
		event.set_camera_look_at(var5, var6 + 30.0, var7)
		var18 = event.get_look_angle(var20 - var5, var22 - var7) or var18
		event.set_character_rotation(var1, var8, var18, var10)
	else
		pos_x = vm.f32(vm.sin(var18) * 30.0)
		pos_x = vm.f32(pos_x + var5)
		pos_y = vm.f32(var6 + 33.0)
		pos_z = vm.f32(vm.cos(var18) * 30.0)
		pos_z = vm.f32(pos_z + var7)
		event.set_camera_position(pos_x, pos_y, pos_z)
		pos_x_2 = var5
		pos_y_2 = vm.f32(var6 + 30.0)
		pos_z_2 = var7
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	end
	event.set_character_active(0, 0)
	vm.wait(1)
	event.start_crossfade(10)
	var29 = 0
	while true do
		set_window_mode(3, 1)
		helper_1f748(3, var2)
		var30 = -1
		event.set_message_draw_speed(3, 0, 0)
		set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		var31 = event.get_npc_message_number_3(var2, 0) or var31
		event.set_message_item_system_message(1, 1, var31)
		open_message(1, 1, 1, 0, 0)
		set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.set_message_item_system_message(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.set_message_item_system_message(2, 1, var30)
			event.set_message_item_system_message(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_bac0e30d(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_d7885d22()
				event.start_crossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.fade_out_screen(25)
				helper_888ab2a3(30)
				event.set_npc_party_status(var2, 1)
				event.open_party_select_menu()
				vm.wait(4)
				helper_d7885d22()
				event.fade_in_screen(30)
				return
			end
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			show_message(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if var29 == 1 then
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			var30 = event.get_npc_message_number_3(var2, 3) or var30
			show_message(3, var30, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						show_message(3, -1, 3, 256, 208)
						helper_d7885d22()
						event.start_crossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_bc227c8c(6)
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_bc227c8c(23)
						return
					end
					if var2 == 4 then
						if helper_73eddd6a() ~= 0 then
							helper_bc227c8c(33)
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_bc227c8c(0)
					end
					if var2 == 12 then
						helper_bc227c8c(1)
					end
					if var2 == 6 then
						helper_bc227c8c(2)
					end
					if var2 == 7 then
						helper_bc227c8c(3)
					end
					if var2 == 2 then
						helper_bc227c8c(7)
					end
					if var2 == 3 then
						helper_bc227c8c(8)
					end
					if var2 == 5 then
						helper_bc227c8c(9)
					end
					if var2 == 8 then
						helper_bc227c8c(10)
					end
					if var2 == 10 then
						helper_bc227c8c(11)
					end
					if var2 == 11 then
						helper_bc227c8c(12)
					end
					if var2 == 13 then
						helper_bc227c8c(13)
					end
					if var2 == 16 then
						helper_bc227c8c(14)
					end
					if var2 == 18 then
						helper_bc227c8c(15)
					end
					if var2 == 19 then
						helper_bc227c8c(16)
					end
					if var2 == 20 then
						helper_bc227c8c(17)
					end
					if var2 == 21 then
						helper_bc227c8c(18)
					end
					if var2 == 22 then
						helper_bc227c8c(19)
					end
					if var2 == 23 then
						helper_bc227c8c(20)
					end
					if var2 == 24 then
						helper_bc227c8c(21)
					end
					if var2 == 25 then
						helper_bc227c8c(22)
					end
					if var2 == 17 then
						helper_bc227c8c(32)
					end
					if var2 == 9 then
						helper_c0869c7f()
						show_message(3, -1, 3, 256, 208)
						helper_d7885d22()
						event.start_crossfade(10)
					end
					if var2 == 14 then
						event.fade_out_screen(25)
						helper_888ab2a3(30)
						event.open_event_menu(25)
						vm.wait(35)
						helper_d7885d22()
						event.fade_in_screen(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_d7885d22()
	event.start_crossfade(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_c6c63376

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_c6c63376()
	event.reset_follow_camera(1, 0.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.open_message_window_2(0, "お洒落")
	show_message(0, -1, 8, 0, 0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	helper_20a60()
	helper_20f2c()
end

return script
