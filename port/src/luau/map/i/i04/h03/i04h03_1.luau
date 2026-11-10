--!strict
-- map/i/i04/h03/i04h03_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_024677a1 = require("@lib/event/helper_024677a1")
local helper_02d91c01 = require("@lib/event/helper_02d91c01")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_186669aa = require("@lib/event/helper_186669aa")
local helper_69b2a955 = require("@lib/event/helper_69b2a955")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_809643bd = require("@lib/event/helper_809643bd")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_ad047ca5 = require("@lib/event/helper_ad047ca5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_38218(chara_no: s32, arg1: s32)
	event.set_character_motion(arg1, "立ち")
	event.fade_out_screen(30)
	wait_frames(30)
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
	wait_frames(30)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "Hi there.\nIt's Monica, right?")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "I'm Parn.\nI'm a magical artist.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	wait_objects(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, 60.0, 0.0, -100.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(30)
	event.open_message_window_2(0, "...")
	show_message(0, -1, 2, 341, 416)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
	)
	show_message(0, -1, 8, 0, 0)
	event.fade_out_screen(30)
	wait_frames(30)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_38f0c(chara_no: s32, arg1: s32)
	event.set_character_motion(arg1, "立ち")
	event.fade_out_screen(30)
	wait_frames(30)
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
	wait_frames(30)
	event.open_message_window_2(0, "Hey Max.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	wait_objects(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, 60.0, 0.0, -100.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(30)
	event.open_message_window_2(0, "...")
	show_message(0, -1, 2, 341, 416)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "Even a magical artist can't draw life.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	event.open_message_window_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.rotate_object_sequence(1, 0.0, 0.17, 0.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
	)
	show_message(0, -1, 8, 0, 0)
	event.fade_out_screen(30)
	wait_frames(30)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_3a3ac(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_38218(arg0, arg1)
		return
	end
	helper_38f0c(arg0, arg1)
	event.set_quest_request(0, 1, 1)
end

--- Helper function.
local function helper_3a51c()
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	event.open_message_window_2(1, "Julia joined your party.\nJulia went to the train.")
	show_message(1, -1, 8, 0, 0)
end

--- Helper function.
local function helper_3a6c0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local item: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.apply_message_window_preset(0, 0)
		helper_c8484b43(arg0, 0, 0)
		event.open_message_window_2(0, "I guess girls just can't understand\nwhy men feel like they have to\npursue their ideals.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"I've been waiting for you.<page>Quick, give me the Paint so that\nI can give life to my picture."
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
		event.open_message_window_2(0, "You must be joking!<page>What I need is Golden Paint.\nGet it right!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.initialize_event()
	event.fade_out_screen(30)
	wait_frames(30)
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
	wait_frames(30)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "So this is Golden Paint...\nI'll try it straight away.")
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話")
	wait_frames(60)
	event.set_object_sequence_motion(1, "立ち")
	wait_frames(60)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(3, 45.0, 15.0, -90.0)
	event.set_object_sequence_motion(3, "ラフレシアの光", 6)
	event.play_sound_effect(var4, 2)
	wait_frames(60)
	event.fade_out_screen(30, 250.0, 250.0, 250.0)
	wait_frames(30)
	event.set_character_active(0, 33)
	event.set_character_active(1, 32)
	event.set_object_sequence_position(2, 45.0, 15.0, -90.0)
	event.set_object_sequence_rotation(2, 0.0, -0.7853982, 0.0)
	event.set_object_sequence_motion(2, "立ち")
	wait_frames(30)
	event.fade_in_screen(30, 255.0, 255.0, 255.0)
	wait_frames(30)
	wait_frames(30)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "Sh-she... She's real...<page>Amazing, she's perfect!")
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_object_sequence_motion(2, "歩き")
	event.turn_object_sequence_toward(2, 30.52, 0.2, -56.3, 30)
	wait_objects(2)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(2, "会話")
	event.open_message_window_2(0, "Hi, I'm Julia. \nIt's a pleasure to meet you.")
	helper_0ffc2526(0, -1, 32, 0, 0)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 30.52, 0.2, -56.3, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "Thanks, Max.\nI haven't forgotten my promise. Please use\nmy new power whenever you want.")
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_npc_party_status(5, 128)
	helper_024677a1(5)
	event.set_npc_party_status(22, 130)
	helper_3a51c()
	event.fade_out_screen(30)
	wait_frames(35)
	event.delete_character(32)
	event.delete_character(33)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
	event.set_villager_ai_enabled(1, var5)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_3c184(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.open_message_window_2(
				0,
				"I guess girls just can't understand\nwhy men feel like they have to\npursue their ideals."
			)
		else
			event.open_message_window_2(0, "Please use my new power\nwhenever you want.")
		end
	else
		event.open_message_window_2(
			0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

--- Helper function.
local function helper_3c4d4(arg0: s32)
	local player_chara: s32 = 0
	local var2: s32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_69b2a955(arg0, player_chara)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_3a3ac(arg0, player_chara)
		return
	end
	if var2 == 1 then
		helper_3a6c0(arg0, player_chara)
		return
	end
	if var2 == 2 then
		helper_3c184(arg0, player_chara)
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
		helper_a87eb945(1)
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
			helper_3c4d4(var1)
			event.set_villager_ai_enabled(1, var1)
		else
			at = 2
			helper_02d91c01()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ad047ca5()
			end
			return 0
		end
		return nil
	end)
end

return script
