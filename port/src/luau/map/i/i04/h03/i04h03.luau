--!strict
-- map/i/i04/h03/i04h03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_024677a1 = require("@lib/event/helper_024677a1")
local helper_09b10784 = require("@lib/event/helper_09b10784")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_186669aa = require("@lib/event/helper_186669aa")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_3087555a = require("@lib/event/helper_3087555a")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_809643bd = require("@lib/event/helper_809643bd")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_921858a1 = require("@lib/event/helper_921858a1")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_361ac(chara_no: s32, arg1: s32)
	event.set_character_motion(arg1, "立ち")
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.initialize_event()
	event.apply_message_window_preset(0, 0)
	event.attach_object_handle_to_character(0, arg1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, chara_no)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-41.63, 18.05, -20.16)
	event.set_camera_sequence_look_at(30.4, 34.28, -73.36)
	event.set_object_sequence_position(0, 30.52, 0.2, -56.3)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.set_object_sequence_motion(0, "立ち")
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_position(1, 23.52, 0.2, -84.52)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち")
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	wait_objects(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, 60.0, 0.0, -100.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(30)
	event.open_message_window_2(0, "・・・")
	show_message(0, -1, 2, 341, 416)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]モニカはこういうタイプが苦手みたい。\n   まぁ、無理ないかも。仕方ありません。\n   ユリスで話しかけてみましょう。"
	)
	show_message(0, -1, 8, 0, 0)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_36eb0(chara_no: s32, arg1: s32)
	event.set_character_motion(arg1, "立ち")
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.initialize_event()
	event.apply_message_window_preset(0, 0)
	event.attach_object_handle_to_character(0, arg1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, chara_no)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-41.63, 18.05, -20.16)
	event.set_camera_sequence_look_at(30.4, 34.28, -73.36)
	event.set_object_sequence_position(0, 30.52, 0.2, -56.3)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.set_object_sequence_motion(0, "立ち")
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_position(1, 23.52, 0.2, -84.52)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち")
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	event.open_message_window_2(0, "やぁ、ユリス、\nこんにちは。")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	wait_objects(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, 60.0, 0.0, -100.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(30)
	event.open_message_window_2(0, "・・・")
	show_message(0, -1, 2, 341, 416)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"ふっ、おかしいだろう、\n笑ってくれて良いよ。<page>絵の中の女性に惚れて\nしまったなんてさ。"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"でも、僕は魔法絵師だ。\n描いた物を本物にする力がある。<page>僕が描けば、それはそこに\n存在するんだ。それが\n生命のない物なら・・・"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "魔法絵師の力では、\n生命を描く事は\nどうしても出来ないんだ。")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	event.open_message_window_2(0, "ただ、聞いた事がある。\nいにしえの巨木に宿る\n黄金の卵。")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"そこから得られる金色を\n用いれば、描いた物に\n生命を与えられると。"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.rotate_object_sequence(1, 0.0, 0.17, 0.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"なぁ、ユリス、君は\n町の外に出かけている\nそうじゃないか。<page>この『金色の絵の具』\nどこかで手に\n入らないかな？"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"もちろん、ただとは\n言わない。<page>手に入れて来てくれたら、\n僕のこの能力を君のために\n使わせてもらうよ。"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]いにしえの巨木・・・\n   金の卵が宿っちゃうような、\n   そんなとんでもない木なんて、\n   どこに行けば生えているんでしょう。"
	)
	show_message(0, -1, 8, 0, 0)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_38350(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_361ac(arg0, arg1)
		return
	end
	helper_36eb0(arg0, arg1)
	event.set_quest_request(0, 1, 1)
end

--- Helper function.
local function helper_384c0()
	local var0: s32 = 0
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	event.set_message_window_buffer(1, 1, 1)
	var0 = event.get_npc_message_number_3(22, 0) or var0
	event.set_message_item_system_message(1, 1, var0)
	event.set_message_item_system_message(1, 2, var0)
	show_message(1, 51, 8, 0, 0)
	event.set_message_window_buffer(1, 1, 0)
end

--- Helper function.
local function helper_38714(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local item: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.apply_message_window_preset(0, 0)
		helper_4e93f9fc(arg0, 0, 0)
		event.open_message_window_2(
			0,
			"やっぱり、女の子には、\n理想を追い求める男の気持ちは\nわからないのかも知れないね。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(376)
	vm.wait(5)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 376 then
		event.open_message_window_2(
			0,
			"これは何の冗談なんだい？<page>僕が欲しいのは『金色の絵の具』だ。\n間違えないでくれ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.initialize_event()
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.load_map_sounds(2827)
	var4 = event.load_sound_effect_file_2(2827) or var4
	var5 = event.find_scene_character_slot(5) or var5
	event.set_villager_ai_enabled(0, var5)
	event.attach_object_handle_to_character(1, var5)
	event.clear_object_sequence(1, var5)
	event.set_object_sequence_object(1, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "chara/p01_25a.gltf", "info", 32)
	event.set_character_active(0, 32)
	event.attach_object_handle_to_character(2, 32)
	event.clear_object_sequence(2, 32)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e200/e255/e255_rafhikari.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_character(3, 33)
	event.clear_object_sequence(3, 33)
	event.set_object_sequence_object(3, 3)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-41.63, 18.05, -20.16)
	event.set_camera_sequence_look_at(30.4, 34.28, -73.36)
	event.set_character_position(0, 30.52, 0.2, -56.3)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.set_character_motion(0, "立ち")
	event.set_object_sequence_position(1, 23.52, 0.2, -84.52)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち")
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話")
	helper_888ab2a3(60)
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(60)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(3, 45.0, 15.0, -90.0)
	event.set_object_sequence_motion(3, "ラフレシアの光", 6)
	event.play_sound_effect(var4, 2)
	helper_888ab2a3(60)
	event.fade_out_screen(30, 250.0, 250.0, 250.0)
	helper_888ab2a3(30)
	event.set_character_active(0, 33)
	event.set_character_active(1, 32)
	event.set_object_sequence_position(2, 45.0, 15.0, -90.0)
	event.set_object_sequence_rotation(2, 0.0, -0.7853982, 0.0)
	event.set_object_sequence_motion(2, "立ち")
	helper_888ab2a3(30)
	event.fade_in_screen(30, 255.0, 255.0, 255.0)
	helper_888ab2a3(30)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_object_sequence_motion(2, "歩き")
	event.turn_object_sequence_toward(2, 30.52, 0.2, -56.3, 30)
	wait_objects(2)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(2, "会話")
	event.open_message_window_2(0, "こんにちは、ジュリアです。\n以後、お見知り置きを・・・")
	helper_0ffc2526(0, -1, 32, 0, 0)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 30.52, 0.2, -56.3, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_npc_party_status(5, 128)
	helper_024677a1(5)
	event.set_npc_party_status(22, 130)
	helper_384c0()
	event.fade_out_screen(30)
	helper_888ab2a3(35)
	event.delete_character(32)
	event.delete_character(33)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
	event.set_villager_ai_enabled(1, var5)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_3a1d8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.open_message_window_2(
				0,
				"やっぱり、女の子には、\n理想を追い求める男の気持ちは\nわからないのかも知れないね。"
			)
		else
			event.open_message_window_2(0, "僕のこの能力、えんりょなく\n存分に使ってくれ。")
		end
	else
		event.open_message_window_2(0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

--- Helper function.
local function helper_3a4f8(arg0: s32)
	local player_chara: s32 = 0
	local var2: s32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_921858a1(arg0, player_chara)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_38350(arg0, player_chara)
		return
	end
	if var2 == 1 then
		helper_38714(arg0, player_chara)
		return
	end
	if var2 == 2 then
		helper_3a1d8(arg0, player_chara)
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_809643bd

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local flag: s32 = 0
	event.set_character_motion(0, "立ち")
	flag = event.get_save_flag(37) or flag
	if flag == 0 then
		event.set_save_flag(37, 1)
		event.add_inventory_item(243, 20)
		helper_f38eabca(243, 20)
		helper_186669aa(0)
		helper_d61bc810(1)
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		if var0 == 5 then
			var1 = event.get_triggered_event_data_2(13) or var1
			event.stop_camera_control_movement()
			event.set_villager_ai_enabled(0, var1)
			at = 1
			helper_3a4f8(var1)
			event.set_villager_ai_enabled(1, var1)
		else
			at = 2
			helper_09b10784()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_3087555a()
			end
			return 0
		end
		return nil
	end)
end

return script
