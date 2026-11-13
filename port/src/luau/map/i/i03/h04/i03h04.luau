--!strict
--- Fishing Town racing hall script that handles the Finny Frenzy race entry, tank choice, results ceremony and spectator dialogue.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local fishing_town_pinna_sprint = require("@lib/event/fishing_town_pinna_sprint")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local wait = require("@lib/event/wait")

local race_sound_bank: s32 = 0
local results_sound_bank: s32 = 0

--- Has the host announce the heat, lets the player pick the pre-race tank and starts the race, returning -1 when the player backs out.
local function choose_preparation_tank()
	local host_slot: s32 = 0
	local heat_stage: s32 = 0
	local tank_choice: any = 0
	local retire_choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		host_slot = 24
		heat_stage = event.get_gyorace_value(3) or heat_stage
		if heat_stage == 0 then
			event.open_message_window_2(0, "最終調整をする水槽はどれにする？")
		end
		if heat_stage == 1 then
			event.open_message_window_2(
				0,
				"おお！！やったじゃないか。\nそれじゃあ、続けて本戦に移るぞ。"
			)
			resume_step = 1
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(0, "本戦の前の最終調整水槽を選んでくれ。")
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"ひゃああ！！すごいじゃないか。\n次は、ついに決勝だぞ。\nさあ、慎重に最終調整水槽を\n選んでくれ。"
			)
		end
		resume_step = 2
		cutscene.talk(host_slot, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(
				0,
				"第一水槽： ペースを守れ \n第ニ水槽：   力の限り   \n第三水槽： 最初が勝負だ \n第四水槽：ラストにかけろ\n第五水槽：バトルで決めろ\n第六水槽：  中盤で行け  "
			)
			event.set_message_selection_top_line(0, 0)
			resume_step = 3
			tank_choice = message.ask_choice(0, -1, 8, 0, 0, 6, 0)
			if tank_choice == -1 then
				if heat_stage == 0 then
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
					resume_step = 4
					retire_choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
					event.set_message_window_mode(0, 1)
					if retire_choice == 0 then
						event.set_gyorace_value(3, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_selection_top_line(0, 0)
						event.set_message_window_option(0, 0, 0)
						event.set_message_window_option(0, 4, -1, -1)
						resume_step = 5
						vm.wait(5)
						return -1
					end
				end
			else
				break
			end
		end
		event.set_gyorace_value(0, tank_choice)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		if heat_stage == 0 then
			event.open_message_window_2(
				0,
				"まずは予戦だ。\n本戦への出場条件は１位通過だ。\nがんばってな～"
			)
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if heat_stage == 1 then
			event.open_message_window_2(
				0,
				"では、いよいよ本戦だ。\n決勝へ残る条件は、２位以上で通過だ。\nがんばってな～"
			)
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"さあ、覚悟は決まったかな。\nいよいよこれでラストだ。\n３位以上だと賞品がもらえるよ～。<page>でも、やるからには、\nやっぱり優勝を狙って行こうよ！"
			)
		end
		resume_step = 6
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_step = 7
		wait.for_frame_count(30)
		event.stop_music(0)
		fishing_town_pinna_sprint.warp_to_i03h05()
		resume_step = 8
		vm.wait(8)
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 3 then
				tank_choice = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 2 then
				tank_choice = message.open_choice_skipping(0, -1, 8, 0, 0, 6, 0)
			end
			return -1
		end
		if resume_step <= 5 then
			if resume_step == 4 then
				retire_choice = received[1] :: number
			end
			return -1
		end
		if resume_step <= 8 then
			if resume_step <= 6 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 7 then
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end

--- Handles the finishing rank of the heat: eliminates the fish, starts the next heat tank choice, or after the final shows the ranking board and awards the prize; returns 0 when eliminated, -1 when the player retires and 1 after the prize.
local function show_race_results()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(48, 0)
	local resume_step: number = 0
	return vm.guard(function()
		fishing_town_pinna_sprint.place_villagers()
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
			resume_step = 1
			if choose_preparation_tank() == -1 then
				return -1
			end
		end
		if frame[9] == 1 then
			if 1 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 2)
			resume_step = 2
			if choose_preparation_tank() == -1 then
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
		event.play_sound_effect(race_sound_bank, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		resume_step = 3
		wait.for_frame_count(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		resume_step = 4
		camera.wait_until_done()
		event.stop_sound_effect(race_sound_bank, 0)
		event.play_sound_effect(race_sound_bank, 3)
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
				frame[7] = event.get_random_number_int(24) or frame[7]
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
						frame[7] = event.get_random_number_int(24) or frame[7]
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
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
		)
		resume_step = 5
		message.show_timed_primary(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
		)
		resume_step = 6
		message.show_timed_primary(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
		)
		resume_step = 7
		message.show_timed_primary(1, -1, 4, 0, 0, 90)
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
		resume_step = 8
		wait.for_frame_count(90)
		event.set_object_handle_visible(8, 1)
		frame[48] = event.get_gyorace_value(2) or frame[48]
		do
			local out1, out2 = event.get_gyorace_value(4, frame[48], vm.i32(frame[8] + 1))
			frame[46] = out1 or frame[46]
			frame[47] = out2 or frame[47]
		end
		event.play_sound_effect(results_sound_bank, 0)
		resume_step = 9
		minigame.show_tournament_prize_with_variant(0, vm.i32(frame[8] + 1), frame[46], frame[47])
		event.add_inventory_item(frame[46], frame[47])
		resume_step = 10
		inventory.resolve_overflow(1)
		if frame[8] == 0 then
			event.set_gyorace_value(7)
		end
		event.fade_out_screen(30)
		resume_step = 11
		wait.for_frame_count(30)
		event.set_character_active(0, 8)
		event.delete_character(15)
		event.delete_character(16)
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		resume_step = 12
		wait.for_frame_count(30)
		return 1
	end, function(received: { any })
		if resume_step <= 1 then
			return -1
		end
		if resume_step <= 2 then
			return -1
		end
		if resume_step <= 12 then
			if resume_step <= 3 then
				wait.background_load_skipping()
			end
			if resume_step <= 4 then
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
				message.show_timed_skipping_primary(1, -1, 4, 0, 0, 60)
			end
			if resume_step <= 5 then
				message.show_timed_skipping_primary(1, -1, 4, 0, 0, 60)
			end
			if resume_step <= 6 then
				message.show_timed_skipping_primary(1, -1, 4, 0, 0, 90)
			end
			if resume_step <= 7 then
				wait.skip_frame_count(90)
			end
			if resume_step <= 8 then
				minigame.show_tournament_prize_skipping(0, vm.i32(frame[8] + 1), frame[46], frame[47])
			end
			if resume_step <= 9 then
				wait.skip_ten_frames(1)
			end
			if resume_step <= 10 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 11 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

--- Runs the race host's conversation covering the rules, the prizes and entering a fish in a class.
local function talk_to_race_host()
	local host_slot: s32 = 0
	local playable_character: s32 = 0
	local extra_mode: s32 = 0
	local menu_result: s32 = 0
	local completed_stage_count: s32 = 0
	local menu_choice: any = 0
	local class_choice: any = 0
	local first_prize_item: s32 = 0
	local second_prize_item: s32 = 0
	local third_prize_item: s32 = 0
	local first_prize_amount: s32 = 0
	local second_prize_amount: s32 = 0
	local third_prize_amount: s32 = 0
	local heat_stage: s32 = 0
	local fish_count: s32 = 0
	local selected_fish: s32 = 0
	local available_class_mask: s32 = 0
	local has_won_prize: s32 = 0
	local race_class: any = 0
	host_slot = event.get_triggered_event_data_2(13) or host_slot
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(0, "立ち", 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character ~= 0 then
		event.open_message_window_2(0, "お、お姉ちゃんもやるのかい？")
		cutscene.talk(host_slot, -1, 0, 0)
		event.open_message_window_2(0, "私はいいです。<page>ここはユリスの出番ね。")
		message.say_bubble(0, -1, 0, host_slot, 0)
		return
	end
	extra_mode = event.is_extra_mode() or extra_mode
	if extra_mode ~= 0 then
		event.open_event_menu(23, 0)
		vm.wait(3)
		event.fade_in_screen(15)
		do
			local out1, _, _, _ = event.get_menu_results_4()
			menu_result = out1 or menu_result
		end
		if menu_result == 1000 then
			event.fade_out_music(30)
			event.fade_out_screen(30)
			wait.for_frame_count(30)
			event.stop_music(0)
			fishing_town_pinna_sprint.warp_to_i03h05()
		end
		return
	end
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	if completed_stage_count >= 3 then
		event.open_message_window_2(
			0,
			"本大会のレースはすべて終了しました。\n次回の開催をお楽しみに！"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.stop_music(0)
		event.set_menu_value(1)
		fishing_town_pinna_sprint.clean_up_event()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(7)
	end
	event.open_message_window_2(0, "ギョレースがはじまるよ～。\n参加するかい？")
	cutscene.talk(host_slot, -1, 0, 0)
	while true do
		event.open_message_window_2(0, "レースに参加する\n説明をきく\n今回の賞品をチェック\nやめておく")
		menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 3)
		if menu_choice == -1 or menu_choice == 3 then
			event.open_message_window_2(0, "見るのも楽しいけど、参加すると、\nもっと熱中できますよ")
			cutscene.talk(host_slot, -1, 0, 0)
			return
		end
		if menu_choice == 1 then
			event.open_message_window_2(
				0,
				"１回のギョレース大会で、レース\nには３回チャレンジできる。<page>ただし、入賞して賞品を獲得した\n魚は、その大会の他のレースには\n出られなくなるぞ。"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"私に話しかけて、レースに参加\nすることを宣言したら、まずは\n出走させる魚を選ぶことになる。<page>魚はアクアリウムの生活水槽に\n入れてないとレースに出すことは\nできないからな。"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"出走させる魚が決まったら、\n次に出場するクラスを選ぶ。<page>ビギナーからマスタークラスまで、\n魚の強さに合ったクラスを選ぶといい。<page>ただし、あるクラスで優勝すると、\nそのクラスには２度と出場できなくなって、\n次のクラスに参加しないといけなくなる。"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"最強のマスタークラスだけは、\n優勝しても何度も出走させる\nことができる。<page>次にレース前に魚を入れて\n最終調整する水槽を選ぶんだ。\n水槽の水にはびみょ～な違いがあって、\n選んだ水槽によって魚の動きが変化する。"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"その魚の能力をおぎなう水槽に入れてやれば、\n意外な力を発揮するかも知れないな。<page>最終調整が終わるといよいよレース開始だ。\nここまでくるとあとは見ているだけとなる。\n自分の育てた魚を存分に応援してやってくれ。"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"レースは予戦、本戦、決勝の順番で進む。\n入賞するためには、予戦で１位通過、\n本戦で２位以上、決勝で３位以上に\n入る必要がある。<page>しかし、やるからには\n目標は「優勝」だ。\nがんばってくれ。"
			)
			cutscene.talk(host_slot, -1, 0, 0)
		end
		if menu_choice == 2 then
			event.open_message_window_2(
				0,
				"ビギナークラス\nジュニアクラス\nシニアクラス\nマスタークラス"
			)
			class_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 0)
			if class_choice ~= -1 then
				event.open_message_window_2(0, "今回の賞品は・・・")
				cutscene.talk(host_slot, -1, 0, 0)
				do
					local out1, out2 = event.get_gyorace_value(4, class_choice, 1)
					first_prize_item = out1 or first_prize_item
					first_prize_amount = out2 or first_prize_amount
				end
				do
					local out1, out2 = event.get_gyorace_value(4, class_choice, 2)
					second_prize_item = out1 or second_prize_item
					second_prize_amount = out2 or second_prize_amount
				end
				do
					local out1, out2 = event.get_gyorace_value(4, class_choice, 3)
					third_prize_item = out1 or third_prize_item
					third_prize_amount = out2 or third_prize_amount
				end
				fishing_town_pinna_sprint.show_prizes_message(first_prize_item, first_prize_amount, second_prize_item, second_prize_amount, third_prize_item, third_prize_amount)
			end
		end
		if menu_choice == 0 then
			break
		end
	end
	heat_stage = event.get_gyorace_value(3) or heat_stage
	fish_count = event.get_message_window_option(0, 2) or fish_count
	if fish_count < 1 then
		event.open_message_window_2(
			0,
			"おっと、出場できる魚を\nお持ちじゃないようだ。<page>魚を育てて、またおいで。"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	event.set_message_number(0, 1, vm.i32(completed_stage_count + 1))
	event.open_message_window_2(0, "本大会の第[数値１]ステージだ。\nさあ、出走させる魚を選んでくれ。")
	cutscene.talk(host_slot, -1, 0, 0)
	while true do
		event.open_event_menu(15, 0)
		vm.wait(22)
		do
			local out1, out2, out3 = event.get_menu_results_3()
			selected_fish = out1 or selected_fish
			available_class_mask = out2 or available_class_mask
			has_won_prize = out3 or has_won_prize
		end
		if selected_fish == -1 then
			return
		elseif has_won_prize ~= 0 then
			event.open_message_window_2(0, "この魚は入賞しているから、\n他の魚を選んでくれ。")
			cutscene.talk(host_slot, -1, 0, 0)
		else
			break
		end
	end
	if heat_stage == 0 then
		event.open_message_window_2(0, "次は出走させるクラスを選んでくれ。")
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "ビギナークラス\nジュニアクラス\nシニアクラス\nマスタークラス")
		event.set_message_selection_top_line(0, 0)
		race_class = message.ask_choice(0, -1, 8, 0, 0, 4, 0)
	else
		race_class = event.get_gyorace_value(2) or race_class
	end
	event.set_message_window_mode(0, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 4, -1, -1)
	if race_class == -1 then
		return
	end
	if race_class == 0 and bit32.band(available_class_mask, 1) == 0 then
		event.open_message_window_2(
			0,
			"この魚はビギナークラスで優勝しているから、\n別のクラスに出場してくれ。"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 1 and bit32.band(available_class_mask, 2) == 0 then
		event.open_message_window_2(
			0,
			"この魚はジュニアクラスで優勝しているから、\n別のクラスに出場してくれ。"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 2 and bit32.band(available_class_mask, 4) == 0 then
		event.open_message_window_2(
			0,
			"この魚はシニアクラスで優勝しているから、\n別のクラスに出場してくれ。"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if heat_stage == 0 then
		event.set_gyorace_value(2, race_class)
	end
	choose_preparation_tank()
	vm.wait(30)
end

--- Shows the spectator's dialogue for the character that was spoken to, depending on the chapter and extra mode.
local function talk_to_spectator()
	local spectator_slot: s32 = 0
	local spectator_id: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local extra_mode: s32 = 0
	event.get_player_character_slot()
	spectator_slot = event.get_triggered_event_data_2(13) or spectator_slot
	spectator_id = event.get_triggered_event_data_2(14) or spectator_id
	print("talk_chara_id=", spectator_slot, "talk_chara=", spectator_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, spectator_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	playable_character = event.get_playable_character() or playable_character
	chapter = event.get_chapter() or chapter
	extra_mode = event.is_extra_mode() or extra_mode
	if spectator_id == 161 then
		if chapter < 6 then
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
	if spectator_id == 171 then
		event.open_message_window_2(
			0,
			"また、ウチのだんながここに\n来てるんじゃないかと思って探しに来たのよ。\nあら、意外と面白そうね。"
		)
	end
	if spectator_id == 169 then
		if extra_mode == 0 then
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
	if spectator_id == 167 then
		if chapter < 7 then
			if playable_character ~= 1 then
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
		elseif playable_character ~= 1 then
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
	if spectator_id == 166 then
		event.open_message_window_2(
			0,
			"僕はギャンブルなんてしないよ。<page>彼女がどうしてもって言うから、\n仕方なくてね。"
		)
	end
	if spectator_id == 165 then
		if chapter < 7 then
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
	if spectator_id == 160 then
		event.open_message_window_2(
			0,
			"あれは、直線コースで伸びるな。\nどいつかって？ふふーん、秘密だよ。"
		)
	end
	if spectator_id == 172 then
		if extra_mode == 0 then
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
	if spectator_id == 158 then
		if chapter < 7 then
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
	if spectator_id == 159 then
		event.open_message_window_2(
			0,
			"ここはギョレース会場だよ。<page>あまり熱くならない方が\n身のためだぜ。"
		)
	end
	if spectator_id == 162 then
		event.open_message_window_2(
			0,
			"ここはギョレース会場だよ。<page>こういうもんは熱くなんなきゃ\nつまんねぇぜ。"
		)
	end
	if spectator_id == 168 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"魚なんて、どれもいっしょで\n見分けなんてつかないよ・・・<page>こうなったら、フィーリングで\n選ぶしかないわね！"
			)
		else
			event.open_message_window_2(0, "彼氏の魚が今度のレースに出るの。\nドキドキしちゃうわ。")
		end
	end
	cutscene.talk(spectator_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, spectator_slot)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Intentionally empty handler for event 99.
function script.do_nothing() end
script[99] = script.do_nothing

--- Initializes the race state, places the villagers and the player when the hall is entered.
function script.default_event()
	event.initialize_event()
	race_sound_bank = 0
	results_sound_bank = 0
	event.set_save_control_bits(1, 1)
	fishing_town_pinna_sprint.place_villagers()
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 1)
	event.set_gyorace_value(7)
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- Plays the consolation message and the race results board after the player was eliminated.
function script.key_open()
	race_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or race_sound_bank
	results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(race_sound_bank, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait.for_frame_count(90)
	event.stop_sound_effect(race_sound_bank, 0)
	event.play_sound_effect(race_sound_bank, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for i = 0, 5 do
		event.set_message_inserted_string(1, 1 + i, "０１２３４５６７８９ ")
		event.set_message_inserted_string(1, 7 + i, "９９：９９：９９")
	end
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	message.show_timed_primary(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	message.show_timed_primary(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
	)
	message.show(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait.for_frame_count(35)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Asks whether to leave the race hall and leaves for the town map or ends the extra mode scene when the player agrees.
function script.ask_to_leave_race_area()
	local extra_mode: s32 = 0
	local completed_stage_count: s32 = 0
	local choice: any = 0
	extra_mode = event.is_extra_mode() or extra_mode
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	if extra_mode == 0 then
		if completed_stage_count <= 0 then
			event.open_message_window_2(0, "『ギョレース会場』から出ますか？")
		else
			event.open_message_window_2(
				0,
				"会場を出ると、ギョレースは終わって\nしまいます。よろしいですか？"
			)
		end
	else
		event.fade_out_screen(10)
		wait.for_frame_count(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "タイトルに戻りますか？")
	end
	choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if choice == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.stop_music(0)
		if 0 < completed_stage_count then
			event.set_menu_value(1)
		end
		fishing_town_pinna_sprint.clean_up_event()
		event.fade_in_screen(30)
		if extra_mode == 0 then
			event.jump_to_map_2(-1, "s45")
			vm.wait(6)
		else
			event.set_scene_exit_flag(1)
		end
	end
	return 1
end
script[202] = script.ask_to_leave_race_area

--- Prints a debug marker for event 401.
function script.print_event_401_marker()
	print("---401----------------------------\n")
end
script[401] = script.print_event_401_marker

--- Shows the race results and plays the consolation message when the fish was eliminated.
function script.cutscene_finish_race()
	local race_result: s32 = 0
	local heat_stage: s32 = 0
	event.initialize_event()
	event.set_save_control_bits(1, 1)
	event.load_music(193)
	race_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or race_sound_bank
	results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
	race_result = show_race_results()
	event.play_music(0)
	if race_result == 0 then
		event.set_character_motion(0, "がっかりL", 0)
		heat_stage = event.get_gyorace_value(3) or heat_stage
		if heat_stage == 0 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(0, "残念だったね。\nこれにこりずにまた挑戦しな～。")
		end
		if heat_stage == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"やっぱり本戦に出てくる\nライバルたちは手強いね～\nこれにこりずにまた挑戦しな～"
			)
		end
		if heat_stage == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"残念。でも、決勝まで残れるだけでも\nすごいじゃないか。\nまた次も期待してるから\nがんばってくれよ。"
			)
		end
		message.say_bubble(0, -1, 24, 0, 0)
	end
	event.delete_character_extension_packs(0)
end
script[502] = script.cutscene_finish_race

--- Shows the ranking board for the race and fades the hall back in.
function script.cutscene_show_ranking_board()
	event.set_save_control_bits(1, 1)
	event.initialize_event()
	event.load_music(193)
	fishing_town_pinna_sprint.place_villagers()
	race_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or race_sound_bank
	results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(race_sound_bank, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait.for_frame_count(90)
	event.stop_sound_effect(race_sound_bank, 0)
	event.play_sound_effect(race_sound_bank, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for i = 0, 5 do
		event.set_gyorace_value(5, 1, 1 + i, i)
		event.set_gyorace_value(6, 1, 7 + i, i)
	end
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	message.show_timed_primary(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	message.show_timed_primary(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
	)
	message.show(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait.for_frame_count(35)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end
script[503] = script.cutscene_show_ranking_board

--- Starts the race host's conversation or a spectator's dialogue depending on who was spoken to.
function script.on_talk()
	local talk_slot: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_slot = event.get_triggered_event_data_2(13) or talk_slot
		if talk_slot == 24 then
			resume_step = 1
			talk_to_race_host()
		else
			resume_step = 2
			talk_to_spectator()
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				fishing_town_pinna_sprint.talk_to_npc()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.on_talk

return script
