--!strict
-- map/g/g01/g01c.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_e1d0()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_event.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	block = event.load_event_image_4(5, "textures/event/e200/e250/e250.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25002", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(2, 0)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e200/e250/e250.txt")
end

--- Helper function.
local function helper_21800000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_dea4()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_f118()
	local var1: s32 = 0
	local flag: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.fade_out_screen(0)
		at = 2
		vm.wait(2)
		event.set_save_flag(250, 1)
		event.initialize_event()
		event.load_map_sounds(2234)
		var1 = event.load_sound_effect_file_2(2234) or var1
		flag = event.get_save_flag(43) or flag
		if flag ~= 0 then
			event.stop_music(0)
			at = 3
			helper_888ab2a3(4)
			event.load_music(22)
			event.play_music(0)
			event.set_save_flag(43, 0)
			print("e250 change bgm-------------------\n")
		end
		helper_e1d0()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		event.set_character_position(global0, var3, var4, var5)
		event.set_character_position(global1, var3, var4, var5)
		event.set_camera_sequence_position(-663.41, 22.05, -973.57)
		event.set_camera_sequence_look_at(-664.94, 26.2, -1002.99)
		event.set_object_sequence_position(0, -639.63, -0.03, -1057.59)
		event.set_object_sequence_rotation(0, 0.0, -2.71, 0.0)
		event.set_object_sequence_position(1, -646.9, -0.0, -1083.44)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		at = 4
		vm.wait(4)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 5
		helper_4116e6bb(2500500)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_4116e6bb(2500510)
		event.reset_mouth_texture_animations()
		at = 7
		wait_objects(1)
		event.set_character_active(0, global1)
		event.set_camera_sequence_position(-701.14, 38.12, -985.84)
		event.set_camera_sequence_look_at(-699.63, 28.19, -1037.85)
		event.move_camera_sequence_eased(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 8
		helper_4116e6bb(2500520)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 9
		helper_4116e6bb(2500523)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 10
		helper_4116e6bb(2500525)
		event.reset_mouth_texture_animations()
		at = 11
		wait_camera()
		event.set_character_active(1, global1)
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_camera_sequence_position(-676.6, 19.02, -1089.83)
		event.set_camera_sequence_look_at(-659.95, 20.37, -1081.54)
		event.set_object_sequence_rotation(0, 0.0, -2.59, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -1.44, 0.0)
		event.set_object_sequence_motion(1, "左向くL", 4, -1.0, 1)
		event.set_character_cloth_animation_enabled(global0, 0)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		helper_4116e6bb(2500530)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 13
		helper_4116e6bb(2500540)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向き立ちからアトラ", 6)
		event.queue_object_sequence_next_motion(1, "左向き立ちからアトラＬ", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 14
		helper_4116e6bb(2500545)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(2, 128.0, 128.0, 128.0, 128.0, 10)
		at = 15
		helper_4116e6bb(2500550)
		at = 16
		helper_4116e6bb(2500555)
		at = 17
		helper_4116e6bb(2500560)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_cloth_animation_enabled(global0, 1)
		event.set_camera_sequence_position(-765.64, 99.33, -1010.96)
		event.set_camera_sequence_look_at(-727.55, 75.53, -1041.04)
		event.set_object_sequence_rotation(0, 0.0, -1.39, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 18
		helper_4116e6bb(2500570)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上→右見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 19
		helper_4116e6bb(2500580)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 20
		helper_4116e6bb(2500585)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(-673.77, 22.39, -1079.75)
		event.set_camera_sequence_look_at(-649.49, 22.05, -1082.79)
		event.play_sound_effect(var1, 23)
		event.set_object_sequence_motion(1, "アトラ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "アトラ見るL", 0)
		at = 21
		helper_888ab2a3(27)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 22
		helper_4116e6bb(2500590)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 23
		helper_4116e6bb(2500595)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "アトラ見から立ちに", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 24
		helper_4116e6bb(2500600)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		if global0 == 0 then
			event.set_character_active(0, 37)
		end
		event.set_camera_sequence_position(-664.87, 45.8, -1032.95)
		event.set_camera_sequence_look_at(-649.78, 27.94, -1048.88)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 25
		helper_4116e6bb(2500610)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_active(1, global1)
		if global0 == 0 then
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
		at = 26
		helper_4116e6bb(2500620)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
		helper_4116e6bb(2500630)
		event.reset_mouth_texture_animations()
		event.set_character_cloth_animation_enabled(global0, 0)
		event.play_sound_effect(var1, 24)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 28
		helper_4116e6bb(2500640)
		event.reset_mouth_texture_animations()
		at = 29
		wait_objects(0)
		at = 30
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, 0.24, 0.0, 30)
		at = 31
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 32
		helper_4116e6bb(2500650)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 33
		helper_4116e6bb(2500655)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "アトラを持つ戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 34
		helper_888ab2a3(15)
		event.play_sound_effect(var1, 25)
		event.set_object_sequence_motion(0, "うなづく", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, " 立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 35
		helper_4116e6bb(2500660)
		event.reset_mouth_texture_animations()
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]カーペントリオンが使えるようになりました。\n   さぁ、シャーロットを作り変えてみましょう。"
		)
		at = 36
		show_message(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]シャーロットを作り変えると、それによって\n   どんな変化が起きるのでしょうか？<page>   タイムゲートを通って、１００年後へ\n   確かめに行ってみましょう。"
		)
		at = 37
		show_message(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]そこで、まだ会ったことのない人と出会ったり\n   新しい事件が起こったりするかも知れません。<page>   まずは、「ジュラクさま」を復活させる事が\n   先決ですね。"
		)
		at = 38
		show_message(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 39
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 2 then
			helper_038a2e4d(4)
		end
		if at <= 3 then
			print("e250 change bgm-------------------\n")
			helper_21800000()
		end
		if at <= 4 then
			helper_8cd371d7(2500500)
		end
		if at <= 5 then
			helper_8cd371d7(2500510)
		end
		if at <= 6 then
			helper_238b5abc(1)
		end
		if at <= 7 then
			helper_8cd371d7(2500520)
		end
		if at <= 8 then
			helper_8cd371d7(2500523)
		end
		if at <= 9 then
			helper_8cd371d7(2500525)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_8cd371d7(2500530)
		end
		if at <= 12 then
			helper_8cd371d7(2500540)
		end
		if at <= 13 then
			helper_8cd371d7(2500545)
		end
		if at <= 14 then
			helper_8cd371d7(2500550)
		end
		if at <= 15 then
			helper_8cd371d7(2500555)
		end
		if at <= 16 then
			helper_8cd371d7(2500560)
		end
		if at <= 17 then
			helper_8cd371d7(2500570)
		end
		if at <= 18 then
			helper_8cd371d7(2500580)
		end
		if at <= 19 then
			helper_8cd371d7(2500585)
		end
		if at <= 20 then
			helper_038a2e4d(27)
		end
		if at <= 21 then
			helper_8cd371d7(2500590)
		end
		if at <= 22 then
			helper_8cd371d7(2500595)
		end
		if at <= 23 then
			helper_8cd371d7(2500600)
		end
		if at <= 24 then
			helper_8cd371d7(2500610)
		end
		if at <= 25 then
			local _ = global0 == 0
			helper_8cd371d7(2500620)
		end
		if at <= 26 then
			local _ = global0 == 0
			helper_8cd371d7(2500630)
		end
		if at <= 27 then
			helper_8cd371d7(2500640)
		end
		if at <= 28 then
			helper_238b5abc(0)
		end
		if at <= 29 then
			helper_038a2e4d(30)
		end
		if at <= 30 then
			helper_038a2e4d(30)
		end
		if at <= 31 then
			helper_8cd371d7(2500650)
		end
		if at <= 32 then
			helper_8cd371d7(2500655)
		end
		if at <= 33 then
			helper_038a2e4d(15)
		end
		if at <= 34 then
			helper_8cd371d7(2500660)
		end
		if at <= 35 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 36 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 37 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 38 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 40
	vm.entry(40)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	at = 41
	helper_888ab2a3(4)
	event.load_music(1)
	event.play_music(0)
	event.set_character_active(1, 120)
	event.set_character_active(1, 121)
	helper_dea4()
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		at = 2
		helper_f118()
		at = 3
		vm.wait(3)
		event.load_event_script("g01/g01.stb", -1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_f118()
				return vm.continue_with(function()
					at = 3
					vm.wait(3)
					event.load_event_script("g01/g01.stb", -1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
