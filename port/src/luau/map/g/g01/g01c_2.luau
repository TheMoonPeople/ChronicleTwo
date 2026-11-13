--!strict
--- Cutscene in which Mints and Monica discuss Atla and unlock the Carpenterion in the Sindain georama.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the playable characters, their motions and the backdrop sprite for the cutscene.
local function load_cutscene_characters()
	local playable_character: s32 = 0
	local image_block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_event.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	image_block = event.load_event_image_4(5, "textures/event/e200/e250/e250_1.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25002", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(2, 0)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Swaps the Mints and Monica character slots when the cutscene is skipped.
local function swap_character_slots()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Deletes the cutscene characters and backdrop image.
local function unload_cutscene_characters()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Plays the conversation about Atla and the Carpenterion and sets the music afterwards.
local function play_carpenterion_unlock_cutscene()
	local sound_bank: s32 = 0
	local flag: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.fade_out_screen(0)
		resume_step = 2
		vm.wait(2)
		event.set_save_flag(250, 1)
		event.initialize_event()
		event.load_map_sounds(2234)
		sound_bank = event.load_sound_effect_file_2(2234) or sound_bank
		flag = event.get_save_flag(43) or flag
		if flag ~= 0 then
			event.stop_music(0)
			resume_step = 3
			wait.frames(4)
			event.load_music(22)
			event.play_music(0)
			event.set_save_flag(43, 0)
			print("e250 change bgm-------------------\n")
		end
		load_cutscene_characters()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_character_position(mints_slot, x, y, z)
		event.set_character_position(monica_slot, x, y, z)
		event.set_camera_sequence_position(-663.41, 22.05, -973.57)
		event.set_camera_sequence_look_at(-664.94, 26.2, -1002.99)
		event.set_object_sequence_position(0, -639.63, -0.03, -1057.59)
		event.set_object_sequence_rotation(0, 0.0, -2.71, 0.0)
		event.set_object_sequence_position(1, -646.9, -0.0, -1083.44)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		resume_step = 4
		vm.wait(4)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 5
		message.show_voiced(2500500)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 6
		message.show_voiced(2500510)
		event.reset_mouth_texture_animations()
		resume_step = 7
		object.wait_until_done(1)
		event.set_character_active(0, monica_slot)
		event.set_camera_sequence_position(-701.14, 38.12, -985.84)
		event.set_camera_sequence_look_at(-699.63, 28.19, -1037.85)
		event.move_camera_sequence_eased(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 8
		message.show_voiced(2500520)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 9
		message.show_voiced(2500523)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 10
		message.show_voiced(2500525)
		event.reset_mouth_texture_animations()
		resume_step = 11
		camera.wait_until_done()
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_camera_sequence_position(-676.6, 19.02, -1089.83)
		event.set_camera_sequence_look_at(-659.95, 20.37, -1081.54)
		event.set_object_sequence_rotation(0, 0.0, -2.59, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -1.44, 0.0)
		event.set_object_sequence_motion(1, "左向くL", 4, -1.0, 1)
		event.set_character_cloth_animation_enabled(mints_slot, 0)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 12
		message.show_voiced(2500530)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 13
		message.show_voiced(2500540)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向き立ちからアトラ", 6)
		event.queue_object_sequence_next_motion(1, "左向き立ちからアトラＬ", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 14
		message.show_voiced(2500545)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(2, 128.0, 128.0, 128.0, 128.0, 10)
		resume_step = 15
		message.show_voiced(2500550)
		resume_step = 16
		message.show_voiced(2500555)
		resume_step = 17
		message.show_voiced(2500560)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_cloth_animation_enabled(mints_slot, 1)
		event.set_camera_sequence_position(-765.64, 99.33, -1010.96)
		event.set_camera_sequence_look_at(-727.55, 75.53, -1041.04)
		event.set_object_sequence_rotation(0, 0.0, -1.39, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 18
		message.show_voiced(2500570)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上→右見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 19
		message.show_voiced(2500580)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_character_active(0, mints_slot)
		event.set_camera_sequence_position(-673.77, 22.39, -1079.75)
		event.set_camera_sequence_look_at(-649.49, 22.05, -1082.79)
		event.play_sound_effect(sound_bank, 23)
		event.set_object_sequence_motion(1, "アトラ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "アトラ見るL", 0)
		resume_step = 20
		wait.frames(27)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 21
		message.show_voiced(2500590)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 22
		message.show_voiced(2500595)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "アトラ見から立ちに", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 23
		message.show_voiced(2500600)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		if mints_slot == 0 then
			event.set_character_active(0, 37)
		end
		event.set_camera_sequence_position(-664.87, 45.8, -1032.95)
		event.set_camera_sequence_look_at(-649.78, 27.94, -1048.88)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 24
		message.show_voiced(2500610)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_active(1, monica_slot)
		if mints_slot == 0 then
			event.set_character_active(1, 37)
		end
		event.set_camera_sequence_position(-685.99, 21.17, -1117.78)
		event.set_camera_sequence_look_at(-668.5, 20.23, -1096.88)
		event.set_object_sequence_rotation(0, 0.0, -2.59, 0.0)
		event.set_camera_sequence_position(-695.73, 21.17, -1136.67)
		event.set_camera_sequence_look_at(-685.84, 20.66, -1124.85)
		event.set_object_sequence_position(0, -649.07, -0.03, -1073.1)
		event.set_object_sequence_rotation(0, 0.0, -2.59, 0.0)
		event.set_object_sequence_position(1, -657.42, -0.0, -1101.87)
		event.set_object_sequence_rotation(1, 0.0, -1.8, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, -1.92, 0.0, 30)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 25
		message.show_voiced(2500620)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 26
		message.show_voiced(2500630)
		event.reset_mouth_texture_animations()
		event.set_character_cloth_animation_enabled(mints_slot, 0)
		event.play_sound_effect(sound_bank, 24)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 27
		message.show_voiced(2500640)
		event.reset_mouth_texture_animations()
		resume_step = 28
		object.wait_until_done(0)
		resume_step = 29
		wait.frames(30)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, 0.24, 0.0, 30)
		resume_step = 30
		wait.frames(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 31
		message.show_voiced(2500650)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 32
		message.show_voiced(2500655)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "アトラを持つ戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		resume_step = 33
		wait.frames(15)
		event.play_sound_effect(sound_bank, 25)
		event.set_object_sequence_motion(0, "うなづく", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, " 立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 34
		message.show_voiced(2500660)
		event.reset_mouth_texture_animations()
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Tu peux utiliser le Charpention.\n   Alors pourquoi ne pas essayer\n   de reconstruire Sindain ?"
		)
		resume_step = 35
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Quand tu changes Sindain, cela\n   peut avoir un impact sur divers\n   [UNI00e9]l[UNI00e9]ments du monde.<page>Pour voir le monde tel qu'il sera dans\n100 ans, passe par la Porte temporelle."
		)
		resume_step = 36
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Peut-[UNI00ea]tre rencontreras-tu des gens\n   encore inconnus ou d[UNI00e9]couvriras-tu des\n   [UNI00e9]v[UNI00e9]nements qui ne se sont pas d[UNI00e9]roul[UNI00e9]s.<page>Mais, chaque chose en son temps. Pour\nl'instant, il te faut ranimer Jurak."
		)
		resume_step = 37
		message.show(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_step = 38
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step <= 2 then
			wait.frames_skipping(4)
		end
		if resume_step <= 3 then
			print("e250 change bgm-------------------\n")
			swap_character_slots()
		end
		if resume_step <= 4 then
			message.show_voiced_skipping(2500500)
		end
		if resume_step <= 5 then
			message.show_voiced_skipping(2500510)
		end
		if resume_step <= 6 then
			cutscene.skip_command(1)
		end
		if resume_step <= 7 then
			message.show_voiced_skipping(2500520)
		end
		if resume_step <= 8 then
			message.show_voiced_skipping(2500523)
		end
		if resume_step <= 9 then
			message.show_voiced_skipping(2500525)
		end
		if resume_step <= 10 then
			wait.background_load_skipping()
		end
		if resume_step <= 11 then
			message.show_voiced_skipping(2500530)
		end
		if resume_step <= 12 then
			message.show_voiced_skipping(2500540)
		end
		if resume_step <= 13 then
			message.show_voiced_skipping(2500545)
		end
		if resume_step <= 14 then
			message.show_voiced_skipping(2500550)
		end
		if resume_step <= 15 then
			message.show_voiced_skipping(2500555)
		end
		if resume_step <= 16 then
			message.show_voiced_skipping(2500560)
		end
		if resume_step <= 17 then
			message.show_voiced_skipping(2500570)
		end
		if resume_step <= 18 then
			message.show_voiced_skipping(2500580)
		end
		if resume_step <= 19 then
			wait.frames_skipping(27)
		end
		if resume_step <= 20 then
			message.show_voiced_skipping(2500590)
		end
		if resume_step <= 21 then
			message.show_voiced_skipping(2500595)
		end
		if resume_step <= 22 then
			message.show_voiced_skipping(2500600)
		end
		if resume_step <= 23 then
			message.show_voiced_skipping(2500610)
		end
		if resume_step <= 24 then
			local _ = mints_slot == 0
			message.show_voiced_skipping(2500620)
		end
		if resume_step <= 25 then
			local _ = mints_slot == 0
			message.show_voiced_skipping(2500630)
		end
		if resume_step <= 26 then
			message.show_voiced_skipping(2500640)
		end
		if resume_step <= 27 then
			cutscene.skip_command(0)
		end
		if resume_step <= 28 then
			wait.frames_skipping(30)
		end
		if resume_step <= 29 then
			wait.frames_skipping(30)
		end
		if resume_step <= 30 then
			message.show_voiced_skipping(2500650)
		end
		if resume_step <= 31 then
			message.show_voiced_skipping(2500655)
		end
		if resume_step <= 32 then
			wait.frames_skipping(15)
		end
		if resume_step <= 33 then
			message.show_voiced_skipping(2500660)
		end
		if resume_step <= 34 then
			message.show_and_wait_skipping(0, -1, 8, 0, 0)
		end
		if resume_step <= 35 then
			message.show_and_wait_skipping(0, -1, 8, 0, 0)
		end
		if resume_step <= 36 then
			message.show_and_wait_skipping(0, -1, 8, 0, 0)
		end
		if resume_step <= 37 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 39
	vm.entry(39)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	resume_step = 40
	wait.frames(4)
	event.load_music(1)
	event.play_music(0)
	event.set_character_active(1, 120)
	event.set_character_active(1, 121)
	unload_cutscene_characters()
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Plays the Carpenterion unlock cutscene and then loads the Sindain event script.
function script.start_carpenterion_unlock_cutscene()
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		resume_step = 1
		vm.wait(1)
		resume_step = 2
		play_carpenterion_unlock_cutscene()
		resume_step = 3
		vm.wait(3)
		event.load_event_script("g01/g01_1.stb", -1)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				play_carpenterion_unlock_cutscene()
				return vm.continue_with(function()
					resume_step = 3
					vm.wait(3)
					event.load_event_script("g01/g01_1.stb", -1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[501] = script.start_carpenterion_unlock_cutscene

return script
