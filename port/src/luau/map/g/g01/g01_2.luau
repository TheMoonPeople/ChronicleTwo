--!strict
--- Event script for the g01 Sindain town with its Rococo house visit, the Gordon conversation, house entrances and Georama transitions.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local georama = require("@lib/event/georama")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sindain = require("@lib/event/sindain")
local sound = require("@lib/event/sound")
local time_gate = require("@lib/event/french/time_gate")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Sets the save control bits according to save flag 250.
local function update_save_control_bits()
	local story_flag: s32 = 0
	story_flag = event.get_save_flag(250) or story_flag
	if story_flag ~= 0 then
		event.set_save_control_bits(2, 0)
	else
		event.set_save_control_bits(2, 1)
	end
end

--- Loads Max, Monica and the chat motions for the Gordon conversation.
local function load_chat_characters()
	local active_chr_no: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 38)
	end
	if active_chr_no == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
end

--- Leaves the Max and Monica slots swapped relative to their default values.
local function swap_character_slots()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Unloads the chat characters and restores the object handles.
local function unload_chat_characters()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(38)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
end

--- Plays the conversation where Max and Monica decide to ask Gordon the gardener to immigrate to Sindain.
local function play_gordon_conversation()
	local bubble_option: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(34, 1)
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.fade_out_screen(30)
		at = 2
		wait.frames(45)
		load_chat_characters()
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(770.06, 6.44, -898.09)
		event.set_camera_sequence_look_at(616.07, 68.13, -1043.77)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_object_sequence_position(0, 714.22, 0.0, -963.1)
		event.set_object_sequence_rotation(0, 0.0, -1.34, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, 695.34, 0.0, -949.18)
		event.set_object_sequence_rotation(1, 0.0, 1.58, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.fade_in_screen(30)
		at = 3
		wait.frames(30)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"Selon la g[UNI00e9]opierre que tu as\nrapport[UNI00e9]e cette fois, si nous\nvoulons ramener Jurak,<page>Il faut que quelqu'un qui s'y\nconna[UNI00ee]t en arbres s'installe\n[UNI00e0] Sindain."
		)
		at = 4
		message.show(0, -1, 3, 0, 416)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(680.02, 12.41, -968.76)
		event.set_camera_sequence_look_at(647.47, 24.66, -996.48)
		event.set_object_sequence_position(0, 656.27, 0.0, -1003.39)
		event.set_object_sequence_rotation(0, 0.0, -0.7853982, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, 641.27, 0.0, -988.39)
		event.set_object_sequence_rotation(1, 0.0, 2.3561945, 0.0)
		at = 5
		vm.wait(5)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Il faut faire venir quelqu'un ?")
		at = 6
		message.say_bubble(0, -1, mints_slot, monica_slot, bubble_option)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"C'est [UNI00e7]a. Il y a plein de gens\nqui vivent [UNI00e0] Palm Brinks,\nnon ?<page>Nous devons convaincre ces gens de\nmigrer vers le monde ext[UNI00e9]rieur.\nC'est ainsi qu'[UNI00e9]voluera l'avenir."
		)
		at = 7
		message.say_bubble(0, -1, monica_slot, mints_slot, bubble_option)
		event.reset_mouth_texture_animations()
		event.open_message_window_2(0, "Humm. Je vois.")
		at = 8
		message.say_bubble(0, -1, mints_slot, monica_slot, bubble_option)
		event.set_object_sequence_motion(1, "向き直り", 2)
		event.queue_object_sequence_next_motion(1, "向き直りL", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目～上向き目")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Ce qu'il nous faut donc maintenant,\nc'est quelqu'un qui s'y connaisse\nen arbres, hein ?")
		at = 9
		message.say_bubble(0, -1, monica_slot, mints_slot, bubble_option)
		event.reset_mouth_texture_animations()
		at = 10
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "顔向け", 2)
		event.queue_object_sequence_next_motion(1, "顔向けＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "上向き目～通常目")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Max, tu conna[UNI00ee]trais quelqu'un ?")
		at = 11
		message.say_bubble(0, -1, monica_slot, mints_slot, bubble_option)
		event.reset_mouth_texture_animations()
		at = 12
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Humm. Un grand sp[UNI00e9]cialiste des\narbres...")
		at = 13
		message.say_bubble(0, -1, mints_slot, monica_slot, bubble_option)
		event.reset_mouth_texture_animations()
		at = 14
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "そうだ！！", 2)
		event.queue_object_sequence_next_motion(0, "そうだ！！L", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(0, "わらい口パク")
		event.open_message_window_2(0, "Oh, je sais ! Gordon !")
		at = 15
		message.say_bubble(0, -1, mints_slot, monica_slot, bubble_option)
		event.reset_mouth_texture_animations()
		at = 16
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "そうだ！！戻り", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_motion(1, "もどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Gordon ?")
		at = 17
		message.say_bubble(0, -1, monica_slot, mints_slot, bubble_option)
		event.reset_mouth_texture_animations()
		at = 18
		object.wait_until_done(0)
		at = 19
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "モニカ見うなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(
			0,
			"Oui, c'est notre jardinier. Un\nvrai arboriste. Il est parfait !<page>Je parie qu'en ce moment il est\ndans notre jardin en train de\ns'occuper des fleurs."
		)
		at = 20
		message.say_bubble(0, -1, mints_slot, monica_slot, bubble_option)
		event.reset_mouth_texture_animations()
		at = 21
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "C'est vrai ? G[UNI00e9]nial ! Allons-y !")
		at = 22
		message.say_bubble(0, -1, monica_slot, mints_slot, bubble_option)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "モニカ見うなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.open_message_window_2(0, "OK !")
		at = 23
		message.say_bubble(0, -1, mints_slot, monica_slot, bubble_option)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Retourne [UNI00e0] Palm Brinks et va\n   chercher Gordon, le jardinier.\n   Il devrait [UNI00ea]tre dans le jardin de Max."
		)
		at = 24
		message.show(0, -1, 8, 0, 0)
		event.fade_out_screen(30)
		at = 25
		wait.frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.frames_skipping(45)
		end
		if at <= 2 then
			swap_character_slots()
			wait.frames_skipping(30)
		end
		if at <= 3 then
			message.show_and_wait_skipping(0, -1, 3, 0, 416)
		end
		if at <= 5 then
			message.show_then_close_variant(0, -1, mints_slot, monica_slot, bubble_option)
		end
		if at <= 6 then
			message.show_then_close_variant(0, -1, monica_slot, mints_slot, bubble_option)
		end
		if at <= 7 then
			message.show_then_close_variant(0, -1, mints_slot, monica_slot, bubble_option)
		end
		if at <= 8 then
			message.show_then_close_variant(0, -1, monica_slot, mints_slot, bubble_option)
		end
		if at <= 9 then
			cutscene.skip_command(1)
		end
		if at <= 10 then
			message.show_then_close_variant(0, -1, monica_slot, mints_slot, bubble_option)
		end
		if at <= 11 then
			cutscene.skip_command(1)
		end
		if at <= 12 then
			message.show_then_close_variant(0, -1, mints_slot, monica_slot, bubble_option)
		end
		if at <= 13 then
			cutscene.skip_command(0)
		end
		if at <= 14 then
			message.show_then_close_variant(0, -1, mints_slot, monica_slot, bubble_option)
		end
		if at <= 15 then
			cutscene.skip_command(0)
		end
		if at <= 16 then
			message.show_then_close_variant(0, -1, monica_slot, mints_slot, bubble_option)
		end
		if at <= 17 then
			cutscene.skip_command(0)
		end
		if at <= 18 then
			cutscene.skip_command(1)
		end
		if at <= 19 then
			message.show_then_close_variant(0, -1, mints_slot, monica_slot, bubble_option)
		end
		if at <= 20 then
			cutscene.skip_command(0)
		end
		if at <= 21 then
			message.show_then_close_variant(0, -1, monica_slot, mints_slot, bubble_option)
		end
		if at <= 22 then
			message.show_then_close_variant(0, -1, mints_slot, monica_slot, bubble_option)
		end
		if at <= 23 then
			message.show_and_wait_skipping(0, -1, 8, 0, 0)
		end
		if at <= 24 then
			wait.frames_skipping(30)
		end
		return true
	end)
	at = 26
	vm.entry(26)
	event.cancel_drama_scene_skip()
	unload_chat_characters()
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the characters, map parts and message file for the Rococo visit cutscene.
local function load_rococo_visit_assets()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_event.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e209/e209_rococo.gltf", "info", 33)
	event.attach_object_handle_to_character(2, 33)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_edit_map_part(6, "p01_g010701", "g010707-m")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 6)
	event.set_object_sequence_position(10, 1.0461, 59.1891, 78.8974)
	event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_edit_map_part(7, "p01_g010701", "g010708-m")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 7)
	event.set_object_sequence_position(11, 1.0461, 59.1891, 78.8974)
	event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
end

--- Deletes the characters loaded for the Rococo visit cutscene.
local function unload_rococo_visit_assets()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(33)
end

--- Plays the cutscene where Max and Monica knock on the door of Rococo and he beckons them in.
local function play_rococo_visit_cutscene()
	local sound_bank: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_2(2217) or sound_bank
		load_rococo_visit_assets()
		event.set_object_handle_sound_bank(0, sound_bank)
		do
			local out1, out2, out3, out4 = event.get_georama_part_position("p01_g010701")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
			rot_y = out4 or rot_y
		end
		event.set_event_world_coordinate(pos_x, pos_y, pos_z, rot_y)
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_camera_sequence_position(-152.18, 97.87, 182.55)
		event.set_camera_sequence_look_at(-14.08, 63.23, 79.66)
		event.set_object_sequence_position(0, -21.47, 35.67, 73.06)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -23.66, 35.67, 53.67)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "ノック", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		wait.frames(63)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "左・モニカ見", 6)
		event.queue_object_sequence_next_motion(0, "左・モニカ見L", 0)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "右を見る", 6)
		event.queue_object_sequence_next_motion(1, "右を見るL", 0)
		message.show_voiced(2090010)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(2.14, 52.68, 63.32)
		event.set_camera_sequence_look_at(-43.71, 54.31, 61.35)
		event.set_object_sequence_position(0, -44.21, 30.26, 69.36)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -40.8, 31.97, 53.53)
		event.set_object_sequence_rotation(1, 0.0, 1.24, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "ひそひそ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "ひそひそL", 0)
		wait.frames(14)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(2090020)
		event.reset_mouth_texture_animations()
		wait.frames(15)
		event.set_object_sequence_motion(1, "どうするのー！", 6)
		event.queue_object_sequence_next_motion(1, "どうするのー！L", 4)
		event.delay_object_sequence_motion_track(0, 15)
		event.set_object_sequence_motion(0, "左・モニカ見戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait.frames(14)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced_for(2090030, 150)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced_for(2090040, 120)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(-101.88, 58.31, 65.69)
		event.set_camera_sequence_look_at(-24.94, 60.87, 62.04)
		event.set_object_sequence_position(0, -38.21, 35.37, 69.15)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -40.8, 36.06, 53.53)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(2, 6.91, 35.67, 60.19)
		event.set_object_sequence_rotation(2, 0.0, -2.24, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.open_voice_stream_wave(1, 2090045)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		wait.frames(75)
		event.play_sound_effect(sound_bank, 5)
		wait.frames(30)
		wait.frames(60)
		event.play_sound_effect(sound_bank, 6)
		event.rotate_object_sequence(10, 0.0, 0.78, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, 0.78, 0.0, 30)
		wait.frames(30)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(-78.2, 56.82, 61.3)
		event.set_camera_sequence_look_at(-24.35, 59.62, 61.68)
		event.set_object_sequence_position(2, 2.98, 37.07, 62.41)
		event.set_object_sequence_rotation(2, 0.0, -2.6, 0.0)
		event.set_object_sequence_motion(2, "手招き", 4)
		message.show_voiced(2090050)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 37)
		event.set_character_active(0, 33)
		event.set_camera_sequence_position(1.94, 52.68, 65.96)
		event.set_camera_sequence_look_at(-43.71, 52.77, 61.35)
		event.set_object_sequence_position(0, -44.21, 30.26, 69.36)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -40.8, 31.97, 53.53)
		event.set_object_sequence_rotation(1, 0.0, 1.24, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "右を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右を見るL", 0)
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(2090060)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-98.54, 68.99, 103.67)
		event.set_camera_sequence_look_at(-31.83, 65.79, 66.42)
		event.set_object_sequence_position(0, -36.84, 35.67, 44.26)
		event.set_object_sequence_rotation(0, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(1, -15.62, 35.67, 55.4)
		event.set_object_sequence_rotation(1, 0.0, 1.36, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 1.2, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 1.2, 0.0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(1, 29.37, 35.67, 54.62, 60)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, 20.32, 35.67, 64.47, 75)
		wait.frames(45)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.play_sound_effect(sound_bank, 7)
		event.rotate_object_sequence(10, 0.0, 0.0, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, 0.0, 0.0, 30)
		wait.frames(15)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
	unload_rococo_visit_assets()
	event.fade_in_screen(30)
end

--- Plays the Rococo visit cutscene and then enters interior g01i07.
local function play_rococo_visit_then_enter_house()
	play_rococo_visit_cutscene()
	event.fade_out_screen(15)
	wait.frames(15)
	vm.wait(3)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g01i07", 501)
	vm.wait(4)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.update_save_control_bits = update_save_control_bits
script[99] = script.update_save_control_bits

--- Places the player and camera depending on the previous map and starts pending events.
function script.default_event()
	local previous_map_number: s32 = 0
	local previous_map_type: s32 = 0
	local at: number = 0
	return vm.guard(function()
		update_save_control_bits()
		previous_map_number = event.get_previous_map() or previous_map_number
		previous_map_type = event.get_map_type(previous_map_number) or previous_map_type
		if previous_map_type ~= -1 then
			if previous_map_type ~= 2 then
				if previous_map_number == 25 then
					sindain.restore_player_view_with_white_fade()
				elseif previous_map_number == 16 then
					at = 1
					sindain.run_player_in_with_camera()
				elseif previous_map_number == 71 then
					event.fade_in_screen(30)
					event.set_character_position(0, 275.0, 35.7, 465.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 0.0, 20.0)
				else
					at = 2
					sindain.run_player_in_with_camera()
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			event.get_previous_interior_map()
			event.fade_in_screen(30)
		end
		at = 3
		sindain.start_g01b_event_if_pending()
		sindain.update_door_and_character_visibility()
		at = 4
		sindain.show_gate_message_with_default_text(1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				sindain.skip_60_frame_wait()
			end
			if at <= 2 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				wait.background_load_skipping()
			end
			if at <= 3 then
				wait.background_load_skipping()
				message.clear_window_option(1)
			end
			return 0
		end
		return nil
	end)
end

--- Shows the travel caption and then plays the Gordon conversation.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		at = 1
		time_gate.show_travel_caption(1)
		at = 2
		play_gordon_conversation()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				play_gordon_conversation()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Enters interior g01i07 or plays the Rococo visit depending on story flags.
function script.enter_rococo_house()
	local flag: s32 = 0
	flag = event.get_save_flag(209) or flag
	if flag == 0 then
		play_rococo_visit_then_enter_house()
		return
	end
	flag = event.get_save_flag(247) or flag
	if flag == 1 then
		flag = event.get_save_flag(250) or flag
		if flag == 0 then
			event.set_save_control_bits(2, 0)
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "g01i07", 100)
			vm.wait(2)
			return
		end
	end
	flag = event.get_save_flag(250) or flag
	if flag == 0 then
		event.jump_to_map_3(-1, "g01i07", 100)
		vm.wait(3)
		return
	end
	vm.wait(4)
	event.go_to_interior_map(-1, "g01i07", 100)
	vm.wait(5)
end
script[200] = script.enter_rococo_house

--- Asks whether to leave and jumps to map s02 when accepted.
function script.ask_to_leave_town()
	if sindain.ask_and_leave_or_walk_back() == 1 then
		event.jump_to_map_2(-1, "s02")
		vm.wait(2)
	end
end
script[201] = script.ask_to_leave_town

--- Plays the time gate and jumps to map f01 while skipping music when events are pending.
function script.enter_time_gate()
	local is_analyzed: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	time_gate.play_red_time_gate(-700.0, 0.0, -1000.0, 1.0)
	is_analyzed = event.get_georama_analysis_flag(103) or is_analyzed
	flag = event.get_save_flag(270) or flag
	if (if is_analyzed ~= 0 then georama.can_start_event_270() else 0) ~= 0 and flag == 0 then
		event.skip_next_music_load()
	end
	flag_2 = event.get_save_flag(280) or flag_2
	if (if is_analyzed ~= 0 then georama.can_start_event_280() else 0) ~= 0 and flag_2 == 0 then
		event.skip_next_music_load()
	end
	event.jump_to_map_2(-1, "f01")
end
script[300] = script.enter_time_gate

--- Shows the gate message after the edit analysis changes.
function script.edit_analyze_changed()
	sindain.show_gate_message_with_default_text(0)
end

--- Asks whether to enter house i01h01 and goes inside when accepted.
function script.ask_to_enter_house()
	local choice: any = 0
	message.open_indexed_message(0)
	choice = sindain.show_option_prompt(0)
	message.close_third_window()
	if choice == 0 then
		event.go_to_interior_map(-1, "i01h01")
		vm.wait(2)
	end
end
script[500] = script.ask_to_enter_house

--- Loads the g01b event script at entry 501.
function script.load_g01b_event()
	vm.wait(1)
	event.load_event_script("g01/g01b_1.stb", 501)
end
script[501] = script.load_g01b_event

script.play_rococo_visit_then_enter_house = play_rococo_visit_then_enter_house
script[502] = script.play_rococo_visit_then_enter_house

--- Fades out and loads the g01c event script.
function script.load_g01c_event()
	event.set_camera_position(-715.15, 30.36, -736.79)
	event.set_camera_look_at(-715.13, 14.54, -733.45)
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("g01/g01c_1.stb", 501)
	event.fade_out_screen(0)
end
script[504] = script.load_g01c_event

--- Adds a set of items, opens the event menu when the item limit is exceeded and enters edit mode.
function script.give_items_and_enter_edit_mode()
	local item_limit_status: s32 = 0
	local overflow_count: s32 = 0
	event.add_inventory_item(210, 28)
	event.add_inventory_item(214)
	event.add_inventory_item(216)
	event.add_inventory_item(220)
	event.add_inventory_item(224)
	event.add_inventory_item(235)
	event.add_inventory_item(231, 20)
	item_limit_status = event.get_item_limit_status() or item_limit_status
	overflow_count = event.get_overflow_item_count() or overflow_count
	if item_limit_status >= 1 or overflow_count >= 1 then
		event.fade_out_screen(10)
		wait.frames(10)
		event.open_event_menu(16)
		vm.wait(2)
		event.fade_in_screen(10)
	end
	event.set_save_control_bits(2, 0)
	event.enter_edit_mode(0)
	vm.wait(3)
end
script[506] = script.give_items_and_enter_edit_mode

--- Sets save flag 42 and plays the Gordon conversation.
function script.set_flag_and_play_gordon_conversation()
	event.set_save_flag(42, 1)
	play_gordon_conversation()
end
script[507] = script.set_flag_and_play_gordon_conversation

--- Loads the g01b event script at entry 150.
function script.load_g01b_event_150()
	vm.wait(1)
	event.load_event_script("g01/g01b_1.stb", 150)
end
script[610] = script.load_g01b_event_150

--- Loads the rush g01 event script.
function script.load_rush_event()
	vm.wait(1)
	event.load_event_script("g01/rush_g01_1.stb", 500)
end
script[650] = script.load_rush_event

--- Event 651, which map data, a script or the engine runs by number.
script.play_rococo_visit_cutscene = play_rococo_visit_cutscene
script[651] = script.play_rococo_visit_cutscene

--- Event 690, which map data, a script or the engine runs by number.
script[690] = sindain.play_toryon_tree_planting_scene

--- Loads the g01b event script at entry 501.
function script.load_g01b_event_501()
	vm.wait(1)
	event.load_event_script("g01/g01b_1.stb", 501)
end
script[12080] = script.load_g01b_event_501

--- Plays the Rococo visit cutscene and jumps to interior g01i07.
function script.play_rococo_visit_then_jump()
	play_rococo_visit_cutscene()
	event.fade_out_screen(15)
	wait.frames(15)
	vm.wait(3)
	event.jump_to_map_3(-1, "g01i07", 501)
	vm.wait(4)
end
script[12090] = script.play_rococo_visit_then_jump

--- Event 12542, which map data, a script or the engine runs by number.
script.play_gordon_conversation = play_gordon_conversation
script[12542] = script.play_gordon_conversation

return script
