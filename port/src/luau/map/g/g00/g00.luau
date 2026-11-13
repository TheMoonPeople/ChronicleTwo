--!strict
--- Event script for the g00 town that spawns its Georama character and handles villager talk.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local g00_town_shared_data = require("@lib/event/g00_town_shared_data")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local wait = require("@lib/event/wait")

--- Shows the remark a villager makes about their new home, or the story-chapter remark in the final chapter.
local function show_villager_remark(window_number: s32, villager_id: s32)
	local chapter: s32 = 0
	local flag: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_id == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window_number,
					"わしはここに住む事になったが\nバース壱号の事も心配じゃ。<page>今まで通り、列車は\nわしが動かすからな。<page>ボルネオはちと荒っぽいし、\nトムはまだ若造じゃからの。<page>これからは、この家と列車を\n行き来する事になるのう。<page>大変じゃ・・・"
				)
			else
				event.open_message_window_2(window_number, "スティーブの調子はどうじゃな？")
			end
		end
		if villager_id == 2 then
			event.open_message_window_2(window_number, "部屋でおとなしくしてるなんて、\nがまんできないぞ。")
		end
		if villager_id == 3 then
			event.open_message_window_2(
				window_number,
				"草木や花は世話した分だけ\nキッチリ育ちます。手を抜くなんて\nできませんぜ。"
			)
		end
		if villager_id == 4 then
			event.open_message_window_2(
				window_number,
				"秘密基地は大丈夫かな？\n誰かに確かめて来て欲しいけど、\n秘密だから頼めないよなぁ・・・"
			)
		end
		if villager_id == 5 then
			event.open_message_window_2(
				window_number,
				"むらさき色って素晴らしい色だよ。\n暖かいようで冷たくて、\n明るいようで暗くてさ。"
			)
		end
		if villager_id == 6 then
			event.open_message_window_2(window_number, "病に苦しむ人がいるなら、\nどこへでも行くつもりだよ。")
		end
		if villager_id == 7 then
			event.open_message_window_2(window_number, "どこに行っても美味い物を作るのが\nプロの料理人です。")
		end
		if villager_id == 8 then
			event.open_message_window_2(window_number, "やっぱりお家はがんじょうな方が\n良いじゃない？")
		end
		if villager_id == 9 then
			event.open_message_window_2(
				window_number,
				"木の実も美味いけど、やっぱ\nあの赤いのが最高だ。\nまた、持ってきてくれよな。"
			)
		end
		if villager_id == 10 then
			event.open_message_window_2(
				window_number,
				"書物にとって湿気は大敵です。\n水の近くに住むなんてとんでもない。"
			)
		end
		if villager_id == 11 then
			event.open_message_window_2(
				window_number,
				"おしゃれでも可愛くもないけど、\n私にしか作れない服を作っていきます。"
			)
		end
		if villager_id == 12 then
			event.open_message_window_2(window_number, "新しい場所で心機一転だ。\n初心に戻ってパンを焼くよ。")
		end
		if villager_id == 13 then
			event.open_message_window_2(window_number, "何でも良いから\n派手にぶっ壊したいぜ。")
		end
		if villager_id == 14 then
			event.open_message_window_2(window_number, "未知のモンスターを発見したら、\nただちに報告するように。")
		end
		if villager_id == 15 then
			event.open_message_window_2(
				window_number,
				"まだ男だ女だと区別する奴がいるけど、\n剣の道は剣の道だ。強い奴が正しいのさ。"
			)
		end
		if villager_id == 16 then
			event.open_message_window_2(window_number, "こんな小さな家に、家族だけで住むのも\n悪くないかもな。")
		end
		if villager_id == 17 then
			event.open_message_window_2(window_number, "モートンはちゃんとやっているかな。\n心配だ・・・")
		end
		if villager_id == 18 then
			event.open_message_window_2(window_number, "まだ教会のない町があるのなら、\n私がそこに赴きましょう。")
		end
		if villager_id == 19 then
			event.open_message_window_2(
				window_number,
				"最近はあまり月の事を考えなくなったよ。\nトモダチがたくさん出来たからかな？"
			)
		end
		if villager_id == 20 then
			event.open_message_window_2(window_number, "土地が違えば魚も変わる。\n釣りの仕方も工夫しないとな。")
		end
		if villager_id == 21 then
			event.open_message_window_2(window_number, "ここの水は魚が良く育ちそうだわ。")
		end
		if villager_id == 22 then
			event.open_message_window_2(
				window_number,
				"パトリったら、また女の人の絵を\n描き始めたの。私以上の美人に\nするんですって。"
			)
		end
		if villager_id == 23 then
			event.open_message_window_2(
				window_number,
				"虫ってどうしてあんな気味の悪い形を\nしているのかしら・・・"
			)
		end
		if villager_id == 24 then
			event.open_message_window_2(
				window_number,
				"もっとかわいいお家にしてちょうだい。\nかわいさに限界なんてないのよ！"
			)
		end
		if villager_id == 25 then
			event.open_message_window_2(window_number, "まさかこの歳になって引っ越すとは\n思わなかったよ。")
		end
	else
		message.show_villager_remark(window_number, villager_id)
	end
end

--- Greets the villager the player talked to and shows their remark.
local function talk_to_villager()
	local villager_character: s32 = 0
	local villager_id: s32 = 0
	event.get_player_character_slot()
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_character, "talk_chara=", villager_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_character)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	show_villager_remark(0, villager_id)
	cutscene.talk(villager_character, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_character)
end

--- Turns the player and villager to face each other and lets the player ask the villager to join the party, trade or hear hints.
local function open_companion_menu()
	local villager_character: s32 = 0
	local villager_id: s32 = 0
	local now_party_chara_id: s32 = 0
	local window_offset: s32 = 0
	local villager_x: f32 = 0
	local villager_y: f32 = 0
	local villager_z: f32 = 0
	local villager_rotation_x: f32 = 0
	local villager_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_z: f32 = 0
	local angle_to_villager: f32 = 0
	local angle_to_player: f32 = 0
	local now_map_no: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local choice: any = 0
	local message_number: s32 = 0
	local greeting_message: s32 = 0
	local choice_count: s32 = 0
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.set_character_motion(0, "立ち")
	event.set_character_motion(villager_character, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	window_offset = 0
	if villager_id == 10 or villager_id == 18 then
		window_offset = 8
	end
	if villager_id == 1 or villager_id == 6 or villager_id == 17 then
		window_offset = 16
	end
	if villager_id == 2 or villager_id == 15 or villager_id == 16 or villager_id == 19 or villager_id == 20 or villager_id == 21 or villager_id == 22 then
		window_offset = 24
	end
	if villager_id == 3 or villager_id == 4 or villager_id == 5 or villager_id == 7 or villager_id == 8 or villager_id == 23 or villager_id == 24 then
		window_offset = 32
	end
	if villager_id == 9 or villager_id == 11 or villager_id == 13 then
		window_offset = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
	event.set_message_window_option(1, 9, 20 + window_offset, 16)
	do
		local out1, _, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_z = out3 or player_rotation_z
	end
	do
		local out1, out2, out3 = event.get_character_position(villager_character)
		villager_x = out1 or villager_x
		villager_y = out2 or villager_y
		villager_z = out3 or villager_z
	end
	do
		local out1, _, out3 = event.get_character_rotation(villager_character)
		villager_rotation_x = out1 or villager_rotation_x
		villager_rotation_z = out3 or villager_rotation_z
	end
	angle_to_villager = event.get_look_angle(villager_x - player_x, villager_z - player_z) or angle_to_villager
	event.set_character_rotation(0, player_rotation_x, angle_to_villager, player_rotation_z)
	angle_to_player = event.get_look_angle(player_x - villager_x, player_z - villager_z) or angle_to_player
	event.set_character_rotation(villager_character, villager_rotation_x, angle_to_player, villager_rotation_z)
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.get_function_point_position("", "gcamp")
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(villager_x, villager_y + 30.0, villager_z)
		angle_to_player = event.get_look_angle(camera_x - villager_x, camera_z - villager_z) or angle_to_player
		event.set_character_rotation(villager_character, villager_rotation_x, angle_to_player, villager_rotation_z)
	else
		pos_x = vm.f32(vm.sin(angle_to_player) * 30.0)
		pos_x = vm.f32(pos_x + villager_x)
		pos_y = vm.f32(villager_y + 33.0)
		pos_z = vm.f32(vm.cos(angle_to_player) * 30.0)
		pos_z = vm.f32(pos_z + villager_z)
		event.set_camera_position(pos_x, pos_y, pos_z)
		pos_x_2 = villager_x
		pos_y_2 = vm.f32(villager_y + 30.0)
		pos_z_2 = villager_z
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	end
	event.set_character_active(0, 0)
	vm.wait(1)
	event.start_crossfade(10)
	choice = 0
	while true do
		message.set_window_mode(3, 1)
		show_villager_remark(3, villager_id)
		message_number = -1
		event.set_message_draw_speed(3, 0, 0)
		message.set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		greeting_message = event.get_npc_message_number_3(villager_id, 0) or greeting_message
		event.set_message_item_system_message(1, 1, greeting_message)
		message.open(1, 1, 1, 0, 0)
		message.set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(villager_id, 4)
			message_number = out1 or message_number
			choice_count = out2 or choice_count
		end
		if choice_count == 3 then
			message_number = 30
		end
		if choice_count == 4 then
			event.set_message_item_system_message(2, 1, message_number)
			message_number = 31
		end
		if choice_count == 5 then
			event.set_message_item_system_message(2, 1, message_number)
			event.set_message_item_system_message(2, 2, vm.i32(message_number + 1))
			message_number = 32
		end
		choice = message.ask_choice(2, message_number, 7, 0, 0, choice_count, vm.i32(choice_count - 1))
		if choice == 0 then
			if villager_id == now_party_chara_id then
				message.end_conversation()
				event.start_crossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.fade_out_screen(25)
				wait.for_frame_count(30)
				event.set_npc_party_status(villager_id, 1)
				event.open_party_select_menu()
				vm.wait(4)
				message.end_conversation()
				event.fade_in_screen(30)
				return
			end
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			message.show(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if choice == 1 then
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			message_number = event.get_npc_message_number_3(villager_id, 3) or message_number
			message.show(3, message_number, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < choice_count then
			if choice_count == 5 then
				if choice == 2 then
					if villager_id == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						message.show(3, -1, 3, 256, 208)
						message.end_conversation()
						event.start_crossfade(10)
					end
					if not (villager_id == 4) then
						break
					end
					menu.open_shop(6)
					break
				end
				if choice == 3 then
					if villager_id == 1 then
						menu.open_shop(23)
						return
					end
					if villager_id == 4 then
						if minigame.report_scoop_progress() ~= 0 then
							menu.open_shop(33)
							return
						end
					end
				end
				if choice == 4 then
					break
				end
				if choice == -1 then
					break
				end
			else
				if choice == 2 then
					if villager_id == 15 then
						menu.open_shop(0)
					end
					if villager_id == 12 then
						menu.open_shop(1)
					end
					if villager_id == 6 then
						menu.open_shop(2)
					end
					if villager_id == 7 then
						menu.open_shop(3)
					end
					if villager_id == 2 then
						menu.open_shop(7)
					end
					if villager_id == 3 then
						menu.open_shop(8)
					end
					if villager_id == 5 then
						menu.open_shop(9)
					end
					if villager_id == 8 then
						menu.open_shop(10)
					end
					if villager_id == 10 then
						menu.open_shop(11)
					end
					if villager_id == 11 then
						menu.open_shop(12)
					end
					if villager_id == 13 then
						menu.open_shop(13)
					end
					if villager_id == 16 then
						menu.open_shop(14)
					end
					if villager_id == 18 then
						menu.open_shop(15)
					end
					if villager_id == 19 then
						menu.open_shop(16)
					end
					if villager_id == 20 then
						menu.open_shop(17)
					end
					if villager_id == 21 then
						menu.open_shop(18)
					end
					if villager_id == 22 then
						menu.open_shop(19)
					end
					if villager_id == 23 then
						menu.open_shop(20)
					end
					if villager_id == 24 then
						menu.open_shop(21)
					end
					if villager_id == 25 then
						menu.open_shop(22)
					end
					if villager_id == 17 then
						menu.open_shop(32)
					end
					if villager_id == 9 then
						message.show_story_hint()
						message.show(3, -1, 3, 256, 208)
						message.end_conversation()
						event.start_crossfade(10)
					end
					if villager_id == 14 then
						event.fade_out_screen(25)
						wait.for_frame_count(30)
						event.open_event_menu(25)
						vm.wait(35)
						message.end_conversation()
						event.fade_in_screen(30)
					end
					return
				end
				if choice == 3 then
					break
				end
				if choice == -1 then
					break
				end
			end
		else
			if choice == 2 then
				break
			end
			if choice == -1 then
				break
			end
		end
	end
	message.end_conversation()
	event.start_crossfade(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = g00_town_shared_data.spawn_georama_character

--- Spawns the Georama character, resets the camera and fades in.
function script.default_event()
	g00_town_shared_data.spawn_georama_character()
	event.reset_follow_camera(1, 0.0)
	event.fade_in_screen(30)
end

--- Shows the stylish-clothes message when square is pressed.
function script.key_open()
	event.open_message_window_2(0, "お洒落")
	message.show(0, -1, 8, 0, 0)
end

--- Plays the villager conversation and then the companion menu.
function script.talk_to_villager()
	talk_to_villager()
	open_companion_menu()
end
script[1000] = script.talk_to_villager

return script
