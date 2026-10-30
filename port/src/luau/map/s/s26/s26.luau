--!strict
-- map/s/s26/s26.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_6b9da980 = require("@lib/event/helper_6b9da980")
local helper_6e932de7 = require("@lib/event/helper_6e932de7")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_b27b2bd8 = require("@lib/event/helper_b27b2bd8")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_10da8()
	local active_chr_no: s32 = 0
	local block_2: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "effect/giostone.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(5, 35)
	event.clear_object_sequence(4, 35)
	event.set_object_sequence_object(4, 5)
	print("00000000000000000000000000000000000000000000\n")
	event.load_event_image_4(5, "textures/menu/eventdl.json", 0)
	block_2 = event.load_event_image_4(5, "textures/event/e200/e254/e254.json", 1) or block_2
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25401", block_2)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e25402", block_2)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	print("1111111111111111111111111111111111111111111111\n")
end

--- Helper function.
local function helper_21700000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
	print("00000000000000000000000000000000000000000000\n")
	print("1111111111111111111111111111111111111111111111\n")
end

--- Helper function.
local function helper_10920()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(38)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_event_image(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(1)
end

--- Helper function.
local function helper_12310()
	local var0: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(88.14, 44.81, 0.0)
		event.set_camera_sequence_look_at(0.0, 19.45, 0.0)
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.load_map_sounds(2239)
		var5 = event.load_sound_effect_file_2(2239) or var5
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(57)
		helper_10da8()
		event.enable_drama_skip()
		event.play_music(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(88.14, 44.81, 0.0)
		event.set_camera_sequence_look_at(0.0, 19.45, 0.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_character_active(1, 35)
		event.set_object_sequence_position(0, -20.0, 0.0, 20.0)
		event.set_object_sequence_rotation(0, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 20.0, 0.0, 20.0)
		event.set_object_sequence_rotation(1, 0.0, -2.3561945, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(3, -20.0, 0.0, -20.0)
		event.set_object_sequence_rotation(3, 0.0, 0.7853982, 0.0)
		event.set_object_sequence_motion(3, "ジオストーン持ち", 4)
		event.attach_character_to_frame(36, "gio", 35)
		event.fade_in_screen(30)
		at = 3
		helper_888ab2a3(30)
		event.open_message_window_2(
			0,
			"これがジオストーンじゃ。\nこの中には、古代人たちの\n知恵がつまっておる。<page>これをこの炉にくべることで\nカーペントリオンでつくれる\n建物の種類が増えるのじゃ。"
		)
		at = 4
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_object_sequence_motion(3, "炉にくべる", 2)
		at = 5
		helper_888ab2a3(23)
		event.play_sound_effect(var5, 9)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(4, "gio")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.detach_character_from_frame(35)
		print("x=", vm.float(pos_x), "y=", vm.float(pos_y), "z=", vm.float(pos_z), "\n")
		event.set_object_sequence_position(4, pos_x, pos_y, pos_z)
		event.jump_object_sequence(4, 0.0, 0.0, 0.0, -0.25, 30)
		at = 6
		helper_888ab2a3(30)
		event.play_sound_effect(var5, 10)
		event.set_character_active(0, 35)
		at = 7
		helper_888ab2a3(15)
		event.set_menu_value(5, 5, 74)
		var0 = 0
		while var0 == 0 do
			at = 8
			vm.wait(8)
			var0 = event.get_menu_value_2(8) or var0
		end
		event.set_menu_value(4)
		event.set_menu_value(3, 1)
		var0 = 0
		while var0 == 0 do
			at = 9
			vm.wait(9)
			var9 = helper_6e932de7(32)
			var0 = event.get_menu_value(7, var9) or var0
		end
		event.set_menu_value(3, 0)
		event.set_menu_value(7)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "そうじゃ！\n忘れるところじゃった。")
		at = 10
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"ジオストーンには建物のつくり方だけではなく\nよりよく未来を発展に導く方法も\n記録されておるのじゃ。<page>おまえさんたちが新しい世界をつくる\n指針となるじゃろう。"
		)
		at = 11
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_event_map_visible(0)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0)
		event.start_crossfade(15)
		at = 12
		helper_888ab2a3(15)
		event.open_message_window_2(
			0,
			"ジオラマメニューの中の「ぶんせき」で\nチェックすることができるぞ。"
		)
		at = 13
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0)
		event.start_crossfade(15)
		at = 14
		helper_888ab2a3(15)
		event.set_event_sprite_draw_pass(0, 0)
		event.open_message_window_2(
			0,
			"それとな、ジオラマメニューの\n右上に、「のこりポリン数」と\nいう物が出ておる。"
		)
		at = 15
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"「物」は、そこに存在するだけで\nある種のエネルギーを使う。<page>わしらはそれを「ポリン」と\n呼んでおるのじゃ。"
		)
		at = 16
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"ジオラマフィールドにはポリン数の限界が\nあって、いくらカーペントリオンでも\n「のこりポリン数」を超えて\n物を配置する事は、無理なんじゃよ。<page>覚えておく事じゃな。"
		)
		at = 17
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_event_map_visible(1)
		event.set_event_sprite_draw_pass(1, 0)
		event.start_crossfade(15)
		at = 18
		helper_888ab2a3(15)
		event.open_message_window_2(
			0,
			"まあ、くわしいことは、おまえさんの持っている\nヘルプレシーバーを使って聞いてくれれば、\nいつでも教えてやるからの。"
		)
		at = 19
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"さて、こいつは若い衆に任せて\nわしは「列車」とやらに\n乗せてもらうとするかの。"
		)
		at = 20
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"一番後ろの車両にいるから、\nたまには顔を見せてくれ。<page>ジオラマの材料くらいなら、\nなんとかしてやれるじゃろう。"
		)
		at = 21
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_camera_sequence_position(15.0, 17.57, 15.0)
		event.set_camera_sequence_look_at(-20.0, 15.0, -20.0)
		event.move_camera_sequence(4.35, 17.57, 4.35, -20.0, 15.0, -20.0, 300)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "では、早速やってみるぞ。\n準備はいいかのぉ～")
		at = 22
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_object_sequence_motion(3, "立ち")
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 23
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_21700000()
			helper_038a2e4d(30)
		end
		if at <= 3 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 4 then
			helper_038a2e4d(23)
		end
		if at <= 5 then
			print("x=", vm.float(pos_x), "y=", vm.float(pos_y), "z=", vm.float(pos_z), "\n")
			helper_038a2e4d(30)
		end
		if at <= 6 then
			helper_038a2e4d(15)
		end
		if at <= 7 then
			var0 = 0
		end
		if at <= 8 then
			local _ = if var0 == 0 then 1 else 0
			var0 = 0
		end
		if at <= 9 then
			var9 = helper_6b9da980(32)
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 10 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 11 then
			helper_038a2e4d(15)
		end
		if at <= 12 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 13 then
			helper_038a2e4d(15)
		end
		if at <= 14 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 15 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 16 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 17 then
			helper_038a2e4d(15)
		end
		if at <= 18 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 19 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 20 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 21 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 22 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_map_visible(1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_menu_value(4)
	event.set_menu_value(7)
	helper_10920()
	event.finish_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_cd90()
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
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
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
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	block = event.load_event_image_4(5, "textures/event/e200/e250/e250.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25001", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(9, 0)
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_frame_visible(5, "tue", 0)
	event.load_message_file(0, 5, "event/e200/e250/e250.txt")
end

--- Helper function.
local function helper_ca40()
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
	event.delete_character(39)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_ddd8()
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2231)
		helper_cd90()
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(192)
		event.play_environment_music(220)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_save_flag(43, 1)
		event.set_function_point_enabled("", "fire-0", 0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(61.11, 28.64, 11.99)
		event.set_camera_sequence_look_at(34.15, 26.92, 87.57)
		event.move_camera_sequence_eased(61.11, 28.64, 11.99, -6.39, 26.92, -14.44, 90, 2, 0.2)
		event.set_object_sequence_position(0, -24.93, 0.0, -74.55)
		event.set_object_sequence_rotation(0, 0.0, -0.77, 0.0)
		event.set_object_sequence_position(1, -6.49, 0.0, -68.74)
		event.set_object_sequence_rotation(1, 0.0, -0.24, 0.0)
		event.set_object_sequence_position(5, -36.31, 0.0, -7.52)
		event.set_object_sequence_rotation(5, 0.0, 2.52, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -28.68, 0.0, -40.21, 90)
		event.rotate_object_sequence(0, 0.0, 0.19, 0.0, 30)
		event.move_object_sequence(1, -28.95, 0.0, -26.6, 90)
		event.rotate_object_sequence(1, 0.0, 0.12, 0.0, 30)
		helper_888ab2a3(90)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 1, "うれし半口")
		event.set_object_sequence_motion(0, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "かなりキョロキョロ", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_object_sequence_motion(5, "会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		helper_4116e6bb(2500300)
		event.set_camera_sequence_position(-8.78, 24.17, 51.3)
		event.set_camera_sequence_look_at(-16.28, 24.17, 38.68)
		event.move_camera_sequence_eased(-8.78, 24.17, 51.3, 4.48, 24.17, 43.59, 210, 2, 0.4)
		helper_4116e6bb(2500310)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(61.11, 28.64, 11.99)
		event.set_camera_sequence_look_at(-6.39, 26.92, -14.44)
		helper_4116e6bb(2500320)
		event.set_camera_sequence_position(7.29, 21.91, 58.86)
		event.set_camera_sequence_look_at(-28.35, 17.54, 8.66)
		event.set_object_sequence_position(0, -25.04, 0.0, -22.19)
		event.set_object_sequence_rotation(0, 0.0, 1.39, 0.0)
		event.set_object_sequence_position(1, -42.75, 0.0, -17.11)
		event.set_object_sequence_rotation(1, 0.0, 0.36, 0.0)
		event.set_object_sequence_position(5, -35.97, 0.0, 6.92)
		event.set_object_sequence_rotation(5, 0.0, 2.88, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "→下見立ち", 6, -1.0, 1)
		event.call_command(466, 0, "下見立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(2500330)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500340)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(2500350)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "これは？", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "これは？L", 4)
		event.delay_camera_sequence_position_track(10)
		event.move_camera_sequence_eased(7.29, 21.91, 58.86, -13.44, 17.54, 2.84, 30, 2, 0.4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(2500360)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500370)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(2500380)
		event.reset_mouth_texture_animations()
		wait_camera()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(9, 128.0, 128.0, 128.0, 128.0, 10)
		helper_4116e6bb(2500390)
		helper_4116e6bb(2500400)
		helper_4116e6bb(2500410)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_camera_sequence_position(52.08, 130.61, 41.85)
		event.set_camera_sequence_look_at(2.22, 22.34, 3.5)
		event.set_object_sequence_position(0, -23.71, -1.07, -19.28)
		event.set_object_sequence_rotation(0, 0.0, 0.91, 0.0)
		event.set_object_sequence_position(1, -28.62, 0.82, 11.54)
		event.set_object_sequence_rotation(1, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(5, -2.8, -0.0, 32.42)
		event.set_object_sequence_rotation(5, 0.0, 3.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.move_camera_sequence_eased(45.54, 116.59, 36.82, -4.32, 8.32, -1.53, 330, 2, 0.4)
		helper_0382f327(2500420, 260)
		helper_0382f327(2500425, 90)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(12.93, 17.36, -15.66)
		event.set_camera_sequence_look_at(8.82, 17.73, -6.03)
		event.move_camera_sequence_eased(12.93, 17.36, -15.66, 2.22, 17.73, -16.01, 270, 2, 0.4)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		helper_0382f327(2500430, 300)
		event.fade_out_music(30)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "メインメニューのヘルプに\n「ジオラマ」が増えた。")
		helper_75684dd8(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(22)
		event.play_music(0)
		event.set_save_flag(43, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(4.11, 22.66, -17.12)
		event.set_camera_sequence_look_at(0.71, 19.07, 8.38)
		event.move_camera_sequence_eased(2.27, 22.66, -3.34, -1.12, 19.07, 22.16, 180, 2, 0.4)
		helper_0382f327(2500440, 210)
		helper_0382f327(2500450, 252)
		event.set_camera_sequence_position(-45.1, 19.94, -58.7)
		event.set_camera_sequence_look_at(-8.21, 23.23, 19.97)
		event.set_object_sequence_position(0, -34.66, 0.0, 3.86)
		event.set_object_sequence_rotation(0, 0.0, 1.15, 0.0)
		event.set_object_sequence_position(1, -22.93, -0.0, 24.09)
		event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_sequence_position(5, 21.52, -0.0, 23.04)
		event.set_object_sequence_rotation(5, 0.0, -1.96, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2500460)
		event.reset_mouth_texture_animations()
		wait_objects(1)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(2500470)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2500480)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500490)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_function_point_enabled("", "fire-0", 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_ca40()
	event.stop_environment_music()
	event.fade_out_screen(0)
end

--- Helper function.
local function helper_18268()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e600/e616/e616_konda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e600/e616/e616_nomu.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e600/e616/e616_zakku.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e600/e616/e616_whikki.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e600/e616/e616_moguri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e600/e616/e616_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e600/e616/e616_rokoko.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_message_file(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_18b9c()
	local var0: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_2(7201) or var0
		helper_18268()
		event.set_character_active(0, 0)
		event.enable_drama_skip()
		event.set_character_active(0, 39)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_position(5, 0.0, -1.79, -22.77)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(6, -74.9, 0.0, 55.92)
		event.set_object_sequence_rotation(6, 0.0, -0.84, 0.0)
		event.set_object_sequence_motion(6, "座り", 4)
		event.set_object_sequence_position(8, -30.74, -0.0, 94.88)
		event.set_object_sequence_rotation(8, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(8, "座り", 4)
		event.set_object_sequence_position(4, 75.6, 0.0, 56.38)
		event.set_object_sequence_rotation(4, 0.0, 0.88, 0.0)
		event.set_object_sequence_motion(4, "座り", 4)
		event.set_object_sequence_position(7, 29.93, 0.0, 90.74)
		event.set_object_sequence_rotation(7, 0.0, 0.36, 0.0)
		event.set_object_sequence_motion(7, "座り", 4)
		event.set_object_sequence_position(2, -95.26, 0.0, 0.75)
		event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_position(3, 96.35, 0.0, 0.25)
		event.set_object_sequence_rotation(3, 0.0, 1.44, 0.0)
		event.set_object_sequence_motion(3, "座り", 4)
		event.fade_in_screen(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(0.71, 26.98, -38.91, 67.53, 23.31, -5.86)
		event.add_camera_sequence_path_point(0.71, 26.98, -38.91, 45.47, 23.31, 20.84)
		event.add_camera_sequence_path_point(0.71, 26.98, -38.91, 16.34, 23.31, 34.32)
		event.add_camera_sequence_path_point(0.71, 26.98, -38.91, -16.58, 23.31, 34.18)
		event.add_camera_sequence_path_point(0.71, 26.98, -38.91, -45.53, 23.31, 20.41)
		event.add_camera_sequence_path_point(0.71, 26.98, -38.91, -68.63, 23.31, -9.13)
		event.start_camera_sequence_path()
		wait_camera()
		event.set_object_sequence_motion(5, "援護するのじゃ", 6)
		event.delay_object_sequence_motion_track(5, 60)
		event.set_object_sequence_motion(5, "撃て！！", 2)
		event.queue_object_sequence_next_motion(5, "撃て！！Ｌ", 4)
		event.delay_object_sequence_sound_track(5, 60)
		event.play_object_sequence_sound(5, var0, 11)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(61.6, 45.22, 21.01)
		event.set_camera_sequence_look_at(18.5, 27.58, -10.21)
		helper_4116e6bb(6160120)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	helper_b27b2bd8()
end

--- Helper function.
local function helper_14504()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e280/e280_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e280/e280_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e280/e280_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e280/e280_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e280/e280_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e280/e280_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e280/e280_rococo.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_message_file(0, 5, "event/e200/e280/e280b.txt")
end

--- Helper function.
local function helper_21b00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_140d8()
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
	event.delete_character(39)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(40)
	event.delete_character(41)
	event.jump_to_map_3(-1, "s02", 503)
end

--- Helper function.
local function helper_15954()
	local var0: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(112)
		event.load_map_sounds(2514)
		var0 = event.load_sound_effect_file_2(2514) or var0
		event.play_music(0)
		helper_14504()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 39)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_position(0, -6.46, 0.0, 61.2)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, 7.05, 0.0, 67.92)
		event.set_object_sequence_rotation(1, 0.0, -2.92, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(5, 0.0, 0.0, -28.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "手紙を閉じるL", 4)
		event.set_object_sequence_position(6, 23.39, 0.0, -13.65)
		event.set_object_sequence_rotation(6, 0.0, -1.08, 0.0)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_position(8, 25.95, 0.0, 9.52)
		event.set_object_sequence_rotation(8, 0.0, -1.92, 0.0)
		event.set_object_sequence_motion(8, "立ち", 4)
		event.set_object_sequence_position(4, 7.8, 0.0, 25.45)
		event.set_object_sequence_rotation(4, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_position(7, -14.77, 0.0, 24.05)
		event.set_object_sequence_rotation(7, 0.0, 2.68, 0.0)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(2, -25.0, 0.0, 11.97)
		event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(3, -24.95, 0.0, -10.56)
		event.set_object_sequence_rotation(3, 0.0, 0.96, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(15)
		at = 3
		helper_888ab2a3(90)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_motion(5, "手紙を開く", 2)
		event.queue_object_sequence_next_motion(5, "手紙を開くL", 4)
		at = 4
		helper_888ab2a3(60)
		event.set_camera_sequence_position(0.0, 17.78, 7.71)
		event.set_camera_sequence_look_at(0.0, 17.46, 0.0)
		event.set_object_sequence_motion(5, "手紙を読む", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(8, "ぷるぷる", 4)
		event.set_object_sequence_motion(4, "下向き立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_motion(2, "泣く", 4)
		event.set_object_sequence_motion(3, "泣く", 4)
		event.start_crossfade(30)
		at = 5
		helper_888ab2a3(15)
		at = 6
		helper_888ab2a3(60)
		at = 7
		helper_4116e6bb(2800220)
		event.set_camera_speed(0)
		event.clear_camera_sequence()
		event.move_camera_sequence_angle_height_distance_eased(-1.6, 0.32, 7.71, 250, 1, 1.0)
		event.move_camera_sequence_angle_height_distance(1.6, 0.32, 7.71, 500)
		event.delay_camera_sequence_angle_track(1)
		event.move_camera_sequence_angle_height_distance_eased(0.0, 0.32, 7.71, 250, 2, 1.0)
		at = 8
		helper_0382f327(2800225, -1)
		at = 9
		helper_0382f327(2800230, -1)
		at = 10
		helper_0382f327(2800240, -1)
		at = 11
		helper_0382f327(2800250, -1)
		at = 12
		helper_0382f327(2800260, -1)
		at = 13
		helper_0382f327(2800270, -1)
		at = 14
		helper_0382f327(2800275, -1)
		event.set_object_sequence_motion(5, "手紙を開くL")
		at = 15
		wait_camera()
		at = 16
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 17)
		event.set_object_sequence_motion(5, "手紙を閉じる", 4)
		event.queue_object_sequence_next_motion(5, "手紙を閉じるL", 4)
		at = 17
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_motion(6, "泣く", 4)
		event.set_object_sequence_motion(8, "泣く", 4)
		event.set_object_sequence_motion(4, "泣く", 4)
		event.set_object_sequence_motion(7, "泣く", 4)
		at = 18
		helper_888ab2a3(15)
		at = 19
		helper_4116e6bb(2800288)
		at = 20
		helper_888ab2a3(30)
		event.set_object_handle_frame_visible(5, "letter", 0)
		event.set_object_handle_frame_visible(5, "letter4", 0)
		event.set_camera_sequence_position(-13.25, 21.72, -2.6)
		event.set_camera_sequence_look_at(3.29, 19.71, -29.35)
		event.set_object_sequence_motion(5, "グスッ", 4)
		at = 21
		helper_888ab2a3(15)
		at = 22
		helper_4116e6bb(2800290)
		at = 23
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-12.64, 27.88, 28.23)
		event.set_camera_sequence_look_at(-0.15, 19.71, 58.96)
		event.set_object_sequence_motion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 24
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 25
		helper_4116e6bb(2800300)
		event.reset_mouth_texture_animations()
		at = 26
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-13.25, 21.72, -2.6)
		event.set_camera_sequence_look_at(3.29, 19.71, -29.35)
		event.set_object_sequence_motion(5, "座り", 4)
		at = 27
		helper_888ab2a3(15)
		at = 28
		helper_4116e6bb(2800310)
		at = 29
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		at = 30
		helper_888ab2a3(15)
		at = 31
		helper_4116e6bb(2800320)
		at = 32
		helper_4116e6bb(2800330)
		at = 33
		helper_888ab2a3(60)
		event.set_object_sequence_motion(5, "見をのりだす", 4)
		event.queue_object_sequence_next_motion(5, "見をのりだすL", 4)
		at = 34
		helper_0382f327(2800340, 60)
		at = 35
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-12.64, 27.88, 28.23)
		event.set_camera_sequence_look_at(-0.15, 19.71, 58.96)
		event.set_object_sequence_motion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 36
		helper_4116e6bb(2800350)
		event.reset_mouth_texture_animations()
		at = 37
		helper_888ab2a3(30)
		event.set_camera_sequence_position(0.0, 20.92, -6.23)
		event.set_camera_sequence_look_at(0.0, 19.86, -20.55)
		at = 38
		helper_888ab2a3(15)
		at = 39
		helper_4116e6bb(2800360)
		at = 40
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-5.07, 23.48, 27.69)
		event.set_camera_sequence_look_at(2.31, 23.67, 72.31)
		at = 41
		helper_888ab2a3(15)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 42
		helper_4116e6bb(2800370)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 43
		helper_4116e6bb(2800375)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "歩き")
		event.rotate_object_sequence(1, 0.0, 2.28, 0.0, 20)
		at = 44
		wait_objects(1)
		event.move_object_sequence(1, 29.3, 0.0, 46.07, 60)
		event.move_camera_sequence_eased(-18.11, 17.54, 36.58, -0.8, 23.67, 74.6, 480, 0, 0)
		at = 45
		helper_0382f327(2800380, 120)
		at = 46
		helper_0382f327(2800390, 270)
		at = 47
		helper_4116e6bb(2800400)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21b00000()
			helper_038a2e4d(15)
		end
		if at <= 2 then
			helper_038a2e4d(90)
		end
		if at <= 3 then
			helper_038a2e4d(60)
		end
		if at <= 4 then
			helper_038a2e4d(15)
		end
		if at <= 5 then
			helper_038a2e4d(60)
		end
		if at <= 6 then
			helper_8cd371d7(2800220)
		end
		if at <= 7 then
			helper_53ffe901(2800225, -1)
		end
		if at <= 8 then
			helper_53ffe901(2800230, -1)
		end
		if at <= 9 then
			helper_53ffe901(2800240, -1)
		end
		if at <= 10 then
			helper_53ffe901(2800250, -1)
		end
		if at <= 11 then
			helper_53ffe901(2800260, -1)
		end
		if at <= 12 then
			helper_53ffe901(2800270, -1)
		end
		if at <= 13 then
			helper_53ffe901(2800275, -1)
		end
		if at <= 14 then
			helper_344d6cd8()
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_038a2e4d(60)
		end
		if at <= 17 then
			helper_038a2e4d(15)
		end
		if at <= 18 then
			helper_8cd371d7(2800288)
		end
		if at <= 19 then
			helper_038a2e4d(30)
		end
		if at <= 20 then
			helper_038a2e4d(15)
		end
		if at <= 21 then
			helper_8cd371d7(2800290)
		end
		if at <= 22 then
			helper_038a2e4d(30)
		end
		if at <= 23 then
			helper_038a2e4d(15)
		end
		if at <= 24 then
			helper_8cd371d7(2800300)
		end
		if at <= 25 then
			helper_038a2e4d(30)
		end
		if at <= 26 then
			helper_038a2e4d(15)
		end
		if at <= 27 then
			helper_8cd371d7(2800310)
		end
		if at <= 28 then
			helper_038a2e4d(30)
		end
		if at <= 29 then
			helper_038a2e4d(15)
		end
		if at <= 30 then
			helper_8cd371d7(2800320)
		end
		if at <= 31 then
			helper_8cd371d7(2800330)
		end
		if at <= 32 then
			helper_038a2e4d(60)
		end
		if at <= 33 then
			helper_53ffe901(2800340, 60)
		end
		if at <= 34 then
			helper_038a2e4d(30)
		end
		if at <= 35 then
			helper_8cd371d7(2800350)
		end
		if at <= 36 then
			helper_038a2e4d(30)
		end
		if at <= 37 then
			helper_038a2e4d(15)
		end
		if at <= 38 then
			helper_8cd371d7(2800360)
		end
		if at <= 39 then
			helper_038a2e4d(30)
		end
		if at <= 40 then
			helper_038a2e4d(15)
		end
		if at <= 41 then
			helper_8cd371d7(2800370)
		end
		if at <= 42 then
			helper_8cd371d7(2800375)
		end
		if at <= 43 then
			helper_238b5abc(1)
		end
		if at <= 44 then
			helper_53ffe901(2800380, 120)
		end
		if at <= 45 then
			helper_53ffe901(2800390, 270)
		end
		if at <= 46 then
			helper_8cd371d7(2800400)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	helper_140d8()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_12310

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_ddd8()
	event.fade_out_screen(0)
	vm.wait(2)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g01", 504)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_12310()
	event.jump_to_map_3(-1, "g01", 506)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_18b9c()
	event.jump_to_map_3(-1, "s70", 532)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_ddd8()
	event.fade_in_screen(30)
end

--- Event 700, which map data, a script or the engine runs by number.
function script.event_700()
	event.remove_item(385)
	helper_15954()
	event.fade_in_screen(30)
end

return script
