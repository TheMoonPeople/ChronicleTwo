--!strict
-- map/i/i04/h03/i04h03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_024677a1 = require("@lib/event/helper_024677a1")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_186669aa = require("@lib/event/helper_186669aa")
local helper_2a9040b5 = require("@lib/event/helper_2a9040b5")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_809643bd = require("@lib/event/helper_809643bd")
local helper_9b9d0c49 = require("@lib/event/helper_9b9d0c49")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_ad047ca5 = require("@lib/event/helper_ad047ca5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_39e38(chara_no: s32, arg1: s32)
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
	event.open_message_window_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	wait_objects(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
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
		"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
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
local function helper_3ab6c(chara_no: s32, arg1: s32)
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
	event.open_message_window_2(0, "H[UNI00e9] Max.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	wait_objects(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
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
	event.open_message_window_2(
		0,
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "Personne ne peut dessiner la vie.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 30)
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	event.open_message_window_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.rotate_object_sequence(1, 0.0, 0.17, 0.0, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.open_message_window_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
	)
	helper_0ffc2526(0, -1, chara_no, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
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
local function helper_3c03c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_39e38(arg0, arg1)
		return
	end
	helper_3ab6c(arg0, arg1)
	event.set_quest_request(0, 1, 1)
end

--- Helper function.
local function helper_3c1ac()
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	event.open_message_window_2(1, "Julia t'accompagne dans ton aventure.\nElle est mont[UNI00e9]e dans le train.")
	show_message(1, -1, 8, 0, 0)
end

--- Helper function.
local function helper_3c360(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local item: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.apply_message_window_preset(0, 0)
		helper_c8484b43(arg0, 0, 0)
		event.open_message_window_2(
			0,
			"Je suppose qu'une fille ne pourrait\ncomprendre les raisons qui poussent\nun homme [UNI00e0] poursuivre ses id[UNI00e9]aux."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
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
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
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
	event.open_message_window_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
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
	event.open_message_window_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_object_sequence_motion(2, "歩き")
	event.turn_object_sequence_toward(2, 30.52, 0.2, -56.3, 30)
	wait_objects(2)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(2, "会話")
	event.open_message_window_2(0, "Salut, moi c'est Julia. \nJe suis ravie de te rencontrer.")
	helper_0ffc2526(0, -1, 32, 0, 0)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 30.52, 0.2, -56.3, 30)
	wait_objects(1)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
	helper_0ffc2526(0, -1, var5, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_npc_party_status(5, 128)
	helper_024677a1(5)
	event.set_npc_party_status(22, 130)
	helper_3c1ac()
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
local function helper_3dec4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.open_message_window_2(
				0,
				"Je suppose qu'une fille ne pourrait\ncomprendre les raisons qui poussent\nun homme [UNI00e0] poursuivre ses id[UNI00e9]aux."
			)
		else
			event.open_message_window_2(0, "N'h[UNI00e9]site pas [UNI00e0] utiliser mes\nnouveaux pouvoirs quand tu le\nvoudras.")
		end
	else
		event.open_message_window_2(
			0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

--- Helper function.
local function helper_3e274(arg0: s32)
	local player_chara: s32 = 0
	local var2: s32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_9b9d0c49(arg0, player_chara)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_3c03c(arg0, player_chara)
		return
	end
	if var2 == 1 then
		helper_3c360(arg0, player_chara)
		return
	end
	if var2 == 2 then
		helper_3dec4(arg0, player_chara)
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
			helper_3e274(var1)
			event.set_villager_ai_enabled(1, var1)
		else
			at = 2
			helper_2a9040b5()
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
