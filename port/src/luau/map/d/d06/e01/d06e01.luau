--!strict
-- map/d/d06/e01/d06e01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2609f66b = require("@lib/event/helper_2609f66b")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_6d912f07 = require("@lib/event/helper_6d912f07")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_972d1084 = require("@lib/event/helper_972d1084")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a9eaf20e = require("@lib/event/helper_a9eaf20e")
local helper_abdda14b = require("@lib/event/helper_abdda14b")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f9968159 = require("@lib/event/helper_f9968159")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_29220()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_save_flag(702, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(21)
		event.play_music(0)
		event.load_map_sounds(7816)
		var1 = event.load_sound_effect_file_2(7816) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e702/")
		event.load_message_file(0, 5, "e702.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e702_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e702_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e702/e702_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e702/e702_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 10.0, 0.0, 600.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -10.0, 0.0, 600.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.move_object_sequence(0, 8, 0.0, 500, 90)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(1, -8, 0.0, 500, 90)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 44.63, 650.83)
		event.set_camera_sequence_look_at(0.0, 17.43, 579.14)
		event.move_camera_sequence_eased(0.0, 44.63, 650.83, 0.0, 48.22, 579.14, 60, 2, 0.2)
		event.fade_in_screen(30)
		wait_objects(0)
		event.set_camera_sequence_position(25.64, 9.7, 457.81)
		event.set_camera_sequence_look_at(-0.0, 19.0, 494.74)
		event.move_camera_sequence(25.64, 9.7, 357.81, 0.0, 19.0, 394.74, 160)
		event.move_object_sequence(0, 8, 0.0, 400, 160)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4)
		event.move_object_sequence(1, -8, 0.0, 400, 160)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(7020010, 100)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(7020020, 30)
		wait_objects(0)
		event.set_camera_sequence_position(0.0, 40.03, 416.7)
		event.set_camera_sequence_look_at(-18.0, 40.45, 363.59)
		event.move_camera_sequence_eased(0.0, 40.03, 416.7, -40.11, 40.45, 389.73, 60, 2, 0.4)
		wait_camera()
		event.set_camera_sequence_position(0.0, 40.03, 416.7)
		event.set_camera_sequence_look_at(18.0, 40.45, 363.59)
		event.move_camera_sequence_eased(0.0, 40.03, 416.7, 40.11, 40.45, 389.73, 60, 2, 0.4)
		wait_camera()
		event.set_camera_sequence_position(0.0, 18.82, 317.17)
		event.set_camera_sequence_look_at(0.0, 21.57, 360.74)
		event.move_object_sequence(0, 8, 0.0, 360, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "気がつく", 2)
		event.queue_object_sequence_next_motion(0, "そうか！！", 6)
		event.queue_object_sequence_next_motion(0, "そうか！！L", 4)
		event.delay_object_sequence_texture_animation_track(0, 40)
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.delay_object_sequence_sound_track(0, 82)
		event.play_object_sequence_sound(0, var1, 0)
		event.move_object_sequence(1, -8, 0.0, 350, 56)
		event.delay_object_sequence_rotation_track(1, 46)
		event.rotate_object_sequence(1, 0.0, 2.42, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 56)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_texture_animation_track(1, 50)
		event.set_object_sequence_texture_animation(1, 0, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "前向き～右向き")
		helper_888ab2a3(42)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020030)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(7020040)
		event.set_camera_sequence_position(-40.7, 35.07, 417.89)
		event.set_camera_sequence_look_at(-4.43, 24.95, 377.6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1, 1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 2.14, 0.0, 6)
		event.delay_object_sequence_position_track(0, 4)
		event.move_object_sequence(0, 210.81, 0.0, 225.65, 60)
		helper_888ab2a3(20)
		event.set_object_handle_footstep_sound(0, 2)
		wait_objects(0)
		event.set_object_sequence_position(0, 718.74, 0.0, -118.54)
		event.set_object_sequence_rotation(0, 0.0, 1.85, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1, 1)
		event.set_camera_sequence_position(24.13, 18.72, 352.73)
		event.set_camera_sequence_look_at(-5.12, 23.16, 345.48)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_sequence_rotation(1, 0.0, 2.06, 0.0)
		helper_888ab2a3(20)
		event.move_object_sequence(1, 52.38, 0.0, 313.0, 40)
		event.set_object_sequence_motion(1, "走り")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_handle_texture_animation(1, 1, "口とじ")
		helper_888ab2a3(40)
		event.set_camera_sequence_position(757.91, 16.92, -132.45)
		event.set_camera_sequence_look_at(694.19, 20.24, -121.26)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_rotation(1, 0.0, 1.73, 0.0)
		event.set_object_sequence_position(1, 597.66, 0.0, -109.91)
		event.move_object_sequence(1, 714.6, 0.0, -132.69, 40)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		helper_888ab2a3(44)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "前向き～左向き")
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(7020050)
		wait_objects(1)
		event.set_camera_sequence_position(640.61, 12.5, -112.65)
		event.set_camera_sequence_look_at(758.05, 45.97, -133.12)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020060)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(7020070)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020080)
		event.set_camera_sequence_position(757.91, 16.92, -132.45)
		event.set_camera_sequence_look_at(694.19, 20.24, -121.26)
		event.set_object_sequence_rotation(1, 0.0, 0.17, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "ホールを示す", 6)
		event.queue_object_sequence_next_motion(0, "ホールを示すL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020085)
		wait_objects(0)
		event.set_object_sequence_motion(0, "絵を指す", 6)
		event.queue_object_sequence_next_motion(0, "絵を指すL", 4)
		event.delay_object_sequence_motion_track(1, 24)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020090)
		wait_objects(0)
		wait_objects(1)
		event.set_camera_sequence_position(659.67, 80.0, -113.9)
		event.set_camera_sequence_look_at(778.51, 80.0, -136.24)
		event.move_camera_sequence_eased(659.67, 60.0, -113.9, 778.51, 60.0, -136.24, 200, 2, 0.2)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, 1.73, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020093)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020097)
		wait_camera()
		event.set_camera_sequence_position(738.56, 22.45, -93.25)
		event.set_camera_sequence_look_at(721.11, 22.0, -138.58)
		event.move_camera_sequence_eased(731.87, 22.45, -90.67, 714.42, 22.0, -136.01, 160, 2, 0.2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020100)
		wait_camera()
		event.set_camera_sequence_position(640.61, 12.5, -112.65)
		event.set_camera_sequence_look_at(758.05, 45.97, -133.12)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020110)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(7020120)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(7020130)
		wait_objects(0)
		wait_objects(1)
		event.play_sound_effect(var1, 1)
		event.set_object_sequence_motion(1, "面白くなって", 6)
		event.queue_object_sequence_next_motion(1, "面白くなってL", 4)
		event.delay_object_sequence_motion_track(1, 42)
		event.queue_object_sequence_next_motion(1, "面白く_待機", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(7020135)
		event.set_object_sequence_motion(0, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7020140)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
end

--- Helper function.
local function helper_2d6d4()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return 0
		end
		at = 3
		var1 = helper_ed4dc120(4, -1)
		if var1 == 0 then
			event.fade_out_screen(30)
			at = 4
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 3 then
				var1 = received[1] :: number
			end
			if at <= 3 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_2dafc()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var0 = helper_ed4dc120(5, 97)
		if var0 == 0 then
			event.fade_out_screen(30)
			at = 2
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_2eddc(arg0: s32)
	local block: s32 = 0
	event.set_character_motion(0, "立ち")
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	if arg0 == 0 then
		event.start_background_file_loads_1("textures/event/etc/heki401.json")
	end
	if arg0 == 1 then
		event.start_background_file_loads_1("textures/event/etc/heki402.json")
	end
	if arg0 == 2 then
		event.start_background_file_loads_1("textures/event/etc/heki403.json")
	end
	if arg0 == 3 then
		event.start_background_file_loads_1("textures/event/etc/heki404.json")
	end
	if arg0 == 4 then
		event.start_background_file_loads_1("textures/event/etc/heki405.json")
	end
	if arg0 == 5 then
		event.start_background_file_loads_1("textures/event/etc/heki406.json")
	end
	if arg0 == 6 then
		event.start_background_file_loads_1("textures/event/etc/heki407.json")
	end
	if arg0 == 7 then
		event.start_background_file_loads_1("textures/event/etc/heki408.json")
	end
	helper_479dc9e9()
	if arg0 == 0 then
		block = event.load_event_image_4(5, "textures/event/etc/heki401.json", 0) or block
		event.set_event_sprite_texture(0, "heki401", block)
	end
	if arg0 == 1 then
		block = event.load_event_image_4(5, "textures/event/etc/heki402.json", 0) or block
		event.set_event_sprite_texture(0, "heki402", block)
	end
	if arg0 == 2 then
		block = event.load_event_image_4(5, "textures/event/etc/heki403.json", 0) or block
		event.set_event_sprite_texture(0, "heki403", block)
	end
	if arg0 == 3 then
		block = event.load_event_image_4(5, "textures/event/etc/heki404.json", 0) or block
		event.set_event_sprite_texture(0, "heki404", block)
	end
	if arg0 == 4 then
		block = event.load_event_image_4(5, "textures/event/etc/heki405.json", 0) or block
		event.set_event_sprite_texture(0, "heki405", block)
	end
	if arg0 == 5 then
		block = event.load_event_image_4(5, "textures/event/etc/heki406.json", 0) or block
		event.set_event_sprite_texture(0, "heki406", block)
	end
	if arg0 == 6 then
		block = event.load_event_image_4(5, "textures/event/etc/heki407.json", 0) or block
		event.set_event_sprite_texture(0, "heki407", block)
	end
	if arg0 == 7 then
		block = event.load_event_image_4(5, "textures/event/etc/heki408.json", 0) or block
		event.set_event_sprite_texture(0, "heki408", block)
	end
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 128.0, 4)
	helper_888ab2a3(4)
	helper_c956b4a2(32)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 0.0, 4)
	helper_888ab2a3(4)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_104f0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_save_flag(608, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(51)
		event.play_music(0)
		event.load_map_sounds(7806)
		var0 = event.load_sound_effect_file_2(7806) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e608/")
		event.load_message_file(0, 5, "e608.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e608_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e608_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		block = event.load_event_image_4(5, "e608telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e608telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e600/e608/e608_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e600/e608/e608_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(10)
		event.load_character(5, "event/e600/e608/e608_f_sun.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2, 11)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e608/e608_sun.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3, 12)
		event.set_object_sequence_object(3, 3)
		event.set_object_handle_position(0, 18.8, 0.2, 627.69)
		event.set_object_handle_rotation(0, 0.0, 3.07, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -18.33, 0.2, 634.43)
		event.set_object_handle_rotation(1, 0.0, 3.11, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(2, -1.11, 280.0, -571.36)
		event.set_object_handle_rotation(2, 0.0, -0.01, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 21)
		event.set_object_handle_position(3, 0.59, 43.94, -81.95)
		event.set_object_handle_rotation(3, 0.0, -0.01, 0.0)
		event.set_object_handle_motion(3, "両手広げるＬ", 4)
		event.set_object_handle_footstep_sound(3, 21)
		event.enable_drama_skip()
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-3.47, 496.82, -690.82)
		event.set_camera_sequence_look_at(-5.22, 214.08, 91.62)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(10)
		event.set_character_active(11)
		event.set_character_active(0, 12)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 18.97, 0.2, 554.51, 90, 1)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -18.13, 0.2, 545.88, 90, 1)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		wait_objects(1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-2.06, 19.94, 249.02)
		event.set_camera_sequence_look_at(-1.59, 24.2, 291.92)
		event.set_object_sequence_position(1, -9.31, 0.2, 281.32)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 7.09, 0.2, 282.56)
		event.set_object_sequence_rotation(0, 0.0, -2.97, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait_objects(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		helper_0382f327(6080010, -1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-154.98, 28.42, 533.81)
		event.set_camera_sequence_look_at(-279.55, 40.6, 353.0)
		event.move_camera_sequence(225.39, 28.42, 472.47, 339.8, 36.75, 291.8, 360)
		wait_camera()
		event.move_camera_sequence(-3.33, 119.35, 266.15, -1.27, 158.81, 55.32, 90)
		wait_camera()
		helper_888ab2a3(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.36, 292.54, -536.23)
		event.set_camera_sequence_look_at(-2.12, 298.3, -575.85)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目")
		event.set_object_sequence_position(1, -18.46, 0.2, 55.61)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 14.5, 0.2, 63.44)
		event.reset_object_sequence_dynamic_animation(0)
		helper_888ab2a3(60)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -1.25, 130.16, -257.23, 400, 1)
		event.delay_object_sequence_motion_track(2, 400)
		event.set_object_sequence_motion(2, "立ち")
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-3.6, 35.33, 230.79)
		event.set_camera_sequence_look_at(-2.02, 46.97, 103.92)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		wait_objects(1)
		helper_888ab2a3(30)
		helper_0382f327(6080020, -1)
		event.set_object_sequence_motion(0, "左→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "右から上", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		helper_888ab2a3(30)
		helper_0382f327(6080025, -1)
		wait_objects(2)
		event.set_camera_sequence_position(42.03, 12.5, 8.79)
		event.set_camera_sequence_look_at(-17.69, 20.13, 73.01)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(6080030, -1)
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(6080035, -1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-1.98, 141.34, -232.47)
		event.set_camera_sequence_look_at(-1.03, 144.72, -259.94)
		helper_0382f327(6080040, -1)
		helper_888ab2a3(15)
		event.set_object_sequence_motion(2, "笑う", 6)
		event.queue_object_sequence_next_motion(2, "笑うL", 4)
		event.queue_object_sequence_next_motion(2, "笑う戻り", 4)
		event.queue_object_sequence_next_motion(2, "立ち")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目～わらい目")
		helper_0382f327(6080045, -1)
		event.set_camera_sequence_position(-3.6, 35.33, 230.79)
		event.set_camera_sequence_look_at(-2.02, 46.97, 103.92)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目")
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -0.89, 36.96, -59.99, 400, 1)
		event.delay_object_sequence_motion_track(2, 400)
		event.set_object_sequence_motion(2, "立ち")
		helper_0382f327(6080050, -1)
		helper_888ab2a3(30)
		helper_0382f327(6080060, -1)
		helper_888ab2a3(15)
		helper_0382f327(6080070, -1)
		helper_888ab2a3(30)
		helper_0382f327(6080075, -1)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, var0, 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "身構え", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		wait_objects(2)
		event.set_object_sequence_motion(2, "笑う", 6)
		event.queue_object_sequence_next_motion(2, "笑うL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目～わらい目")
		helper_0382f327(6080080, -1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目")
		helper_888ab2a3(15)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.56, 41.19, 0.3)
		event.set_camera_sequence_look_at(-0.5, 43.3, -50.78)
		event.move_camera_sequence_eased(-1.3, 37.59, -12.38, -0.5, 43.3, -50.78, 120, 2, 1.0)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		helper_888ab2a3(120)
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(13.66, 39.05, 16.1)
		event.set_camera_sequence_look_at(16.97, 18.33, 61.91)
		event.set_object_sequence_motion(2, "立ち")
		event.move_camera_sequence(-16.73, 39.05, 18.35, -15.62, 18.33, 64.27, 120)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(6080090, -1)
		event.set_camera_sequence_position(1.22, 23.49, 141.64)
		event.set_camera_sequence_look_at(1.34, 25.13, 39.83)
		event.set_object_sequence_motion(2, "フードに手をやる", 6)
		event.queue_object_sequence_next_motion(2, "フードに手をやるL", 4)
		helper_888ab2a3(60)
		event.play_sound_effect(var0, 5)
		event.set_camera_sequence_position(33.21, 53.76, -44.92)
		event.set_camera_sequence_look_at(3.6, 57.9, -78.66)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ")
		event.set_character_active(0, 11)
		event.set_character_active(12)
		event.set_object_sequence_motion(3, "頭ぶるぶる", 6)
		event.queue_object_sequence_next_motion(3, "両手広げる", 4)
		event.queue_object_sequence_next_motion(3, "両手広げるＬ", 4)
		wait_objects(3)
		event.set_object_sequence_motion(3, "両手広げ会話")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ～目あき")
		helper_0382f327(6080100, -1)
		helper_888ab2a3(20)
		event.delay_camera_sequence_position_track(60)
		event.set_camera_sequence_position(9.9, 35.11, 33.88)
		event.set_camera_sequence_look_at(15.48, 21.68, 64.42)
		event.move_camera_sequence(11.17, 31.65, 40.85, 15.48, 21.68, 64.42, 60)
		event.set_camera_sequence_position(-14.64, 35.21, 35.6)
		event.set_camera_sequence_look_at(-16.78, 21.68, 60.9)
		event.delay_object_sequence_texture_animation_track(3, 60)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "こわれ目パチ")
		event.move_camera_sequence(-14.36, 32.13, 37.22, -17.13, 20.52, 65.0, 60)
		event.set_camera_sequence_position(0.31, 58.43, -61.11)
		event.set_camera_sequence_look_at(0.74, 63.75, -85.24)
		event.set_object_sequence_motion(3, "両手広げ会話", 4)
		event.delay_object_sequence_motion_track(3, 240)
		event.queue_object_sequence_next_motion(3, "両手広げるＬ", 4)
		event.move_camera_sequence(0.73, 32.94, -12.13, 0.74, 63.75, -85.24, 60)
		helper_0382f327(6080105, 240)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(36)
	event.play_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	helper_9dafbc83(0.0, vm.f32(0.2), 400.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.2, 400.0)
	event.set_camera_position(0.0, 40.2, 520.0)
	event.reset_follow_camera(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_15394()
	local var0: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(610, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(7809)
		var0 = event.load_sound_effect_file_2(7809) or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.show_dungeon_status_bar(0, 1.0)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e600/e610/")
		event.load_message_file(0, 5, "e610.txt")
		event.change_directory("")
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(5, 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.load_character_motion_pack(5, "event/e600/e610/e610_mints.gltf", "info", 8)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.load_character_motion_pack(5, "event/e600/e610/e610_monica.gltf", "info", 10)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 10)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "event/e600/e610/e610_hana_sun_ex.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2, 12)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e610/e610_kiran.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3, 13)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e600/e610/e610_hanakudake.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(4, 14)
		event.clear_object_sequence(4, 14)
		event.set_object_sequence_object(4, 4)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -36.85, 0.2, 211.1)
		event.set_object_handle_rotation(0, 0.0, -1.13, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 4)
		event.set_object_handle_position(1, 32.44, 0.2, 194.73)
		event.set_object_handle_rotation(1, 0.0, 0.95, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-25.8, 19.87, 265.72)
		event.set_camera_sequence_look_at(-34.35, 19.8, 232.21)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.fade_in_screen(30)
		event.set_object_sequence_color(5, 0, 0, 0, 128, 0)
		helper_4116e6bb(6100010)
		event.set_object_sequence_color(5, 0, 0, 0, 0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "左向き目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "右向き目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_motion(0, "はっとする", 6)
		event.queue_object_sequence_next_motion(0, "はっとするL", 4)
		wait_objects(0)
		event.play_sound_effect(var0, 0)
		event.fade_out_screen(30, 255, 255, 255)
		helper_888ab2a3(30)
		event.fade_in_screen(15, 255, 255, 255)
		event.set_camera_sequence_position(24.23, 19.45, 233.89)
		event.set_camera_sequence_look_at(37.75, 19.84, 179.82)
		event.set_object_sequence_motion(1, "ふりかえり", 6)
		event.queue_object_sequence_next_motion(1, "ふりかえりL", 4)
		helper_0382f327(6100020, 15)
		wait_objects(1)
		event.play_sound_effect(var0, 1)
		event.fade_out_screen(30, 255, 255, 255)
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 2)
		event.fade_in_screen(30)
		event.set_object_sequence_color(5, 0, 0, 0, 128, 0)
		helper_888ab2a3(30)
		event.fade_out_camera_sequence(0)
		event.set_object_sequence_color(5, 0, 0, 0, 0, 0)
		helper_888ab2a3(60)
		event.fade_in_screen(30)
		event.set_dungeon_pause_flags(128, 1)
		event.set_camera_sequence_position(1.98, 6.53, 181.87)
		event.set_camera_sequence_look_at(1.06, 23.97, 120.97)
		event.set_object_sequence_position(1, 12.41, 0.2, 137.08)
		event.set_object_sequence_rotation(1, 0.0, -0.72, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, -9.58, 0.2, 135.04)
		event.set_object_sequence_rotation(0, 0.0, 0.71, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_dungeon_pause_flags(128, 1)
		event.set_event_sprite_draw_pass(0, 0)
		helper_888ab2a3(30)
		event.set_character_active(13)
		event.set_object_sequence_position(3, 1.8, 10.3, 168.28)
		event.set_object_sequence_rotation(3, 0.0, 0.48, 0.35)
		event.set_object_sequence_motion(3, "キラン", 4)
		event.set_character_active(14)
		event.set_object_sequence_position(4, 1.24, 13.3, 134.88)
		event.set_object_sequence_motion(4, "現れる", 6)
		event.queue_object_sequence_next_motion(4, "ループ", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_motion(0, "光る", 6)
		event.queue_object_sequence_next_motion(0, "下向き立ち", 4)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(1, "下見立ち", 4)
		helper_888ab2a3(15)
		event.set_character_active(12)
		event.set_object_sequence_position(2, 1.24, 13.3, 134.88)
		wait_objects(3)
		event.set_character_active(0, 13)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目とじ～おこり目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		helper_888ab2a3(60)
		event.set_object_sequence_motion(0, "さわろうとする", 6)
		event.queue_object_sequence_next_motion(0, "下向き立ち", 4)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "はじける", 6)
		event.queue_object_sequence_next_motion(1, "下見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.delay_object_sequence_motion_track(4, 15)
		event.set_object_sequence_motion(4, "花くだけ", 4)
		event.set_object_sequence_motion_step(4, 0.05)
		helper_888ab2a3(30)
		event.set_character_visible(12, 0, 1, 0.1)
		event.play_sound_effect(var0, 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口～口とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		helper_0382f327(6100030, 120)
		helper_0382f327(6100040, 60)
		event.fade_out_screen(420, 0, 0, 0)
		helper_0382f327(6100050, 240)
		event.set_character_active(0, 14)
		event.set_object_sequence_motion(0, "下→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(6100060, 120)
		helper_888ab2a3(60)
		event.fade_in_screen(15, 0, 0, 0)
		event.set_object_sequence_color(5, 0, 0, 0, 128, 0)
		event.set_event_sprite_draw_pass(0, 1)
		helper_4116e6bb(6100070)
		event.fade_out_screen(30, 255, 255, 255)
		helper_888ab2a3(30)
		event.fade_in_screen(15, 255, 255, 255)
		event.set_object_sequence_color(5, 255, 255, 255, 128, 0)
		helper_4116e6bb(6100080)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.load_music(36)
	event.play_music(0)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 4)
	event.set_dungeon_pause_flags(128, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_dungeon_pause_flags(128, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
end

--- Helper function.
local function helper_18964()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var6: s32 = 0
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(33)
		event.load_map_sounds(7810)
		var0 = event.load_sound_effect_file_2(7810) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_051.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_equipment_model(5, 0, 0, "info", 8, 10)
			event.load_equipment_model(5, 0, 1, "info", 8, 11)
			event.load_character_motion_pack(5, "event/e600/e612/e612_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_equipment_model(5, 1, 0, "info", 8, 10)
			event.load_equipment_model(5, 1, 1, "info", 8, 11)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(1, 10)
		event.set_character_active(1, 11)
		event.load_character(5, "event/e600/e612/e612_atora_a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2, 12)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e612/e612_atora_b.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3, 13)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e600/e612/e612_sun.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(4, 14)
		event.clear_object_sequence(4, 14)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(5, 15)
		event.clear_object_sequence(5, 15)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "event/e600/e612/e612_sun_ray.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(6, 16)
		event.clear_object_sequence(6, 16)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "event/e600/e612/e612_ghikari.gltf", "info", 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(7, 17)
		event.clear_object_sequence(7, 17)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "event/e600/e612/e612_hiraki.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_object_handle_to_character(8, 18)
		event.clear_object_sequence(8, 18)
		event.set_object_sequence_object(8, 8)
		event.load_character(5, "event/e600/e612/e612_sun_eye.gltf", "info", 19)
		event.set_character_active(19)
		event.attach_object_handle_to_character(9, 19)
		event.clear_object_sequence(9, 19)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_position(0, 18.48, 0.2, 307.68)
		event.set_object_handle_rotation(0, 0.0, -0.53, 0.0)
		event.set_object_handle_motion(0, "戦闘立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -23.14, 0.2, 308.89)
		event.set_object_handle_rotation(1, 0.0, 0.23, 0.0)
		event.set_object_handle_motion(1, "剣構え", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(4, 4.86, 0.2, 441.28)
		event.set_object_handle_rotation(4, 0.0, -3.13, 0.0)
		event.set_object_handle_motion(4, "よろよろ立ち", 4)
		event.set_object_handle_footstep_sound(4, 21)
		event.attach_character_to_frame(14, "hikari", 19)
		event.set_object_handle_visible(9, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-78.74, 78.05, 198.62)
		event.set_camera_sequence_look_at(13.39, 2.21, 381.09)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(14)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "くるし目パチ")
		at = 3
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-41.54, 14.05, 496.91)
		event.set_camera_sequence_look_at(12.6, 11.66, 379.4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "くるし目～目とじ")
		event.set_object_sequence_motion(4, "よろよろ会話", 6)
		event.queue_object_sequence_next_motion(4, "よろよろ立ち", 4)
		at = 4
		helper_0382f327(6120010, -1)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(4, "倒れる", 6)
		event.queue_object_sequence_next_motion(4, "倒れるＬ", 4)
		at = 5
		wait_objects(4)
		at = 6
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-88.01, 116.61, 327.84)
		event.set_camera_sequence_look_at(2.74, 11.66, 406.61)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(0, 33.71, 0.2, 365.11)
		event.set_object_sequence_rotation(0, 0.0, -0.17, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -23.96, 0.2, 368.34)
		event.set_object_sequence_rotation(1, 0.0, 0.23, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 28.35, 0.2, 422.7, 60, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, -0.89, 0.0, 50)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -23.16, 0.2, 421.62, 70, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, 0.95, 0.0, 50)
		event.delay_object_sequence_motion_track(1, 70)
		event.set_object_sequence_motion(1, "立ち")
		at = 7
		helper_888ab2a3(90)
		at = 8
		helper_4116e6bb(6120020)
		at = 9
		helper_4116e6bb(6120030)
		event.set_camera_sequence_position(-36.88, 13.32, 371.24)
		event.set_camera_sequence_look_at(-0.58, 15.51, 433.62)
		event.set_object_sequence_position(0, 24.07, 0.2, 434.14)
		event.set_object_sequence_rotation(0, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(0, "下見立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -16.95, 0.2, 431.66)
		event.set_object_sequence_rotation(1, 0.0, 1.19, 0.0)
		event.set_object_sequence_motion(1, "下向き立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 10
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_motion(4, "起き上がる", 6)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		event.set_object_sequence_motion(0, "のけぞる", 6)
		event.queue_object_sequence_next_motion(0, "のけぞるL", 4)
		event.set_object_sequence_motion(1, "のけぞり", 6)
		event.queue_object_sequence_next_motion(1, "のけぞりL", 4)
		at = 11
		wait_objects(4)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_camera_sequence_position(18.01, 15.67, 424.73)
		event.set_camera_sequence_look_at(26.69, 15.51, 433.92)
		event.set_character_active(12)
		event.set_object_sequence_position(4, 9.42, 0.2, 432.34)
		event.set_object_sequence_rotation(4, 0.0, 1.95, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 then
			event.show_atlamillia_frames(0, 0, 0)
		else
			event.show_atlamillia_frames(0, 8, 0)
		end
		event.set_object_sequence_position(2, 25.41, 12.88, 433.35)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.set_object_sequence_motion(4, "ユリスからもぎ取る", 6)
		event.set_object_sequence_motion_step(4, 0.4)
		at = 12
		helper_888ab2a3(16)
		event.play_sound_effect(var0, 2)
		event.move_object_sequence(2, 24.24, 8.61, 429.7, 3)
		at = 13
		helper_888ab2a3(6)
		event.set_character_active(0, 12)
		event.set_camera_sequence_position(-18.72, 20.05, 442.61)
		event.set_camera_sequence_look_at(-16.52, 16.03, 434.01)
		event.set_character_active(1, 13)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.show_atlamillia_frames(1, 0, 0)
		else
			event.show_atlamillia_frames(1, 8, 0)
		end
		event.set_object_sequence_position(4, -3.81, 0.2, 442.31)
		event.set_object_sequence_rotation(4, 0.0, -2.33, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_position(3, -15.16, 15.1, 434.91)
		event.set_object_sequence_rotation(3, -0.6, 0.72, 0.0)
		event.set_object_sequence_motion(1, "目で追うL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(4, "モニカから奪う", 4)
		event.set_object_sequence_motion_step(4, 0.4)
		event.set_scene_status_flags(1, 0, 256, 0)
		at = 14
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 3)
		event.move_object_sequence(3, -8.89, 18.29, 433.34, 3)
		at = 15
		helper_888ab2a3(8)
		event.set_camera_sequence_position(-32.04, 13.37, 229.44)
		event.set_camera_sequence_look_at(23.02, 3.56, 367.15)
		event.set_character_active(1, 12)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(14, "aka_null", 12)
		event.attach_character_to_frame(14, "ao_null", 13)
		event.set_object_sequence_position(0, 24.07, 0.2, 434.14)
		event.set_object_sequence_rotation(0, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(0, "のけぞるL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -16.95, 0.2, 431.66)
		event.set_object_sequence_rotation(1, 0.0, 1.19, 0.0)
		event.set_object_sequence_motion(1, "のけぞりL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(4, 4.86, 0.2, 441.28)
		event.set_object_sequence_rotation(4, 0.0, -3.13, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_motion(4, "ジャンプ", 4)
		at = 16
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 4)
		event.move_object_sequence(4, -4.5, 0.2, 273.3, 30)
		event.delay_object_sequence_motion_track(4, 30)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, var0, 5)
		event.set_object_sequence_motion(0, "しまった！", 6)
		event.queue_object_sequence_next_motion(0, "しまった！L", 4)
		event.set_object_sequence_motion(1, "目で追う", 6)
		event.queue_object_sequence_next_motion(1, "目で追うL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 17
		helper_0382f327(6120040, 45)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 18
		helper_0382f327(6120050, 70)
		event.play_music(0)
		event.set_camera_sequence_position(-33.83, 58.84, 228.9)
		event.set_camera_sequence_look_at(2.4, 12.62, 165.61)
		event.set_object_sequence_position(4, -0.94, 0.2, 167.47)
		event.reset_object_sequence_dynamic_animation(4)
		event.play_sound_effect(var0, 6)
		event.set_object_sequence_motion(4, "振り返る", 6)
		event.rotate_object_sequence(4, 0.0, -0.01, 0.0, 30)
		event.delay_object_sequence_motion_track(4, 30)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		at = 19
		wait_objects(4)
		at = 20
		helper_888ab2a3(30)
		event.set_object_sequence_motion(4, "不敵に笑う", 6)
		event.queue_object_sequence_next_motion(4, "不敵に笑うＬ", 4)
		event.delay_object_sequence_motion_track(4, 60)
		event.queue_object_sequence_next_motion(4, "不敵に笑う戻り", 4)
		event.queue_object_sequence_next_motion(4, "石持ち立ち", 4)
		at = 21
		helper_0382f327(6120060, -1)
		at = 22
		helper_888ab2a3(30)
		at = 23
		wait_objects(4)
		event.set_object_sequence_motion(4, "石持ち会話", 6)
		event.queue_object_sequence_next_motion(4, "石持ち立ち", 4)
		at = 24
		helper_0382f327(6120065, -1)
		at = 25
		wait_objects(4)
		event.set_camera_sequence_position(-1.12, 3.57, 211.52)
		event.set_camera_sequence_look_at(-1.09, 17.17, 165.43)
		event.set_object_sequence_motion(4, "力を込める", 6)
		event.queue_object_sequence_next_motion(4, "力を込めるＬ", 4)
		at = 26
		helper_888ab2a3(60)
		event.set_camera_sequence_position(30.46, 10.46, 194.28)
		event.set_camera_sequence_look_at(-4.46, 14.37, 169.28)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "こわれ目～赤目")
		event.set_object_handle_visible(9, 1)
		event.set_object_sequence_motion(4, "前傾姿勢", 6)
		event.queue_object_sequence_next_motion(4, "前傾姿勢Ｌ", 4)
		event.set_character_active(16)
		event.set_character_visible(16, 1, 1, 0.033333335)
		event.set_object_sequence_position(6, -0.95, 0.2, 164.64)
		event.set_object_sequence_motion(6, "前傾姿勢Ｌ")
		event.shake_camera_sequence_vertically(0.0, 0.2, 0.0, 360)
		event.play_sound_effect(var0, 7)
		at = 27
		helper_0382f327(6120070, 60)
		event.set_object_sequence_rotation(0, 0.0, -2.81, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 28
		helper_888ab2a3(60)
		event.start_crossfade(30)
		event.set_camera_sequence_position(27.23, 15.0, 106.78)
		event.set_camera_sequence_look_at(5.4, 11.56, 187.66)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		at = 29
		helper_888ab2a3(90)
		event.set_camera_sequence_position(1.44, 19.01, 221.87)
		event.set_camera_sequence_look_at(-0.86, 15.58, 174.12)
		event.set_object_sequence_motion(6, "アトラミリア光る")
		at = 30
		helper_888ab2a3(60)
		event.set_camera_sequence_position(69.6, 17.0, 511.44)
		event.set_camera_sequence_look_at(42.17, 15.58, 462.62)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_motion(6, "発光")
		event.set_object_sequence_motion_step(6, 0.2)
		at = 31
		helper_888ab2a3(15)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "！！", 6)
		event.queue_object_sequence_next_motion(0, "！！L", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(1, "まぶしいL", 4)
		at = 32
		helper_888ab2a3(15)
		at = 33
		helper_0382f327(6120080, 30)
		event.fade_out_screen(30, 255, 255, 255)
		at = 34
		helper_888ab2a3(30)
		event.fade_out_music(30)
		at = 35
		helper_888ab2a3(30)
		event.set_character_active(0, 14)
		event.set_character_active(0, 19)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 16)
		event.set_character_active(15)
		event.set_object_sequence_position(5, -0.95, 0.2, 164.64)
		event.set_camera_sequence_position(-1.32, 10.92, 232.98)
		event.set_camera_sequence_look_at(-1.51, 5.74, 176.6)
		event.set_object_sequence_motion(5, "立ち（前傾）")
		at = 36
		helper_888ab2a3(30)
		event.fade_in_screen(30, 255, 255, 255)
		event.play_sound_effect(var1, 0)
		event.move_camera_sequence_eased(-1.32, 10.92, 232.98, -1.51, 45.85, 176.6, 180, 0, 0.5)
		at = 37
		wait_camera()
		at = 38
		helper_888ab2a3(30)
		event.set_camera_sequence_position(83.44, 109.23, 85.27)
		event.set_camera_sequence_look_at(11.63, 44.02, 193.11)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_position(0, 16.61, 0.2, 323.16)
		event.set_object_sequence_rotation(0, 0.0, -2.81, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -19.07, 0.2, 324.55)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(5, "身を起こす", 6)
		event.queue_object_sequence_next_motion(5, "身を起こすＬ", 4)
		event.move_camera_sequence_eased(2.49, 42.34, 46.29, 5.69, 44.02, 193.66, 120, 0, 0.5)
		at = 39
		helper_0382f327(6120090, 180)
		at = 40
		wait_camera()
		event.set_camera_sequence_position(37.69, 39.48, 235.92)
		event.set_camera_sequence_look_at(-1.18, 50.99, 170.42)
		x = vm.f32(-22.54)
		y = vm.f32(20.9)
		z = vm.f32(332.85)
		do
			local out1, out2, out3 = event.subtract_vectors(x, y, z, -8.96, 10.09, 279.73)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_wind(10, x, y, z)
		event.set_motion_blur(100)
		event.play_sound_effect(var0, 8)
		event.set_object_sequence_motion(5, "開く", 6)
		event.queue_object_sequence_next_motion(5, "開くＬ", 4)
		event.set_character_active(18)
		event.delay_object_sequence_motion_track(8, 40)
		event.set_object_sequence_motion(8, "開くＬ", 6)
		event.set_object_sequence_motion(0, "！！L", 4)
		event.set_object_sequence_motion(1, "まぶしいL", 4)
		event.move_camera_sequence_eased(56.18, 9.11, 279.47, -1.71, 41.43, 163.58, 90, 0, 0.5)
		at = 41
		wait_camera()
		event.set_camera_sequence_position(-63.65, 24.75, 289.98)
		event.set_camera_sequence_look_at(19.98, 11.48, 346.64)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_motion(5, "立ち", 4)
		at = 42
		helper_888ab2a3(60)
		event.set_character_active(0, 18)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_wind(-1)
		event.set_motion_blur(0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(5, "会話１")
		at = 43
		helper_0382f327(6120100, -1)
		at = 44
		helper_888ab2a3(60)
		at = 45
		wait_objects(5)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.stop_music(0)
		at = 46
		helper_888ab2a3(4)
		event.load_music(167)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 47
		helper_4116e6bb(6120110)
		at = 48
		wait_objects(5)
		event.set_camera_sequence_position(-49.43, 5.59, 296.0)
		event.set_camera_sequence_look_at(-7.47, 21.65, 323.75)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "前～左～前")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 49
		helper_4116e6bb(6120120)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		helper_4116e6bb(6120125)
		at = 51
		wait_objects(1)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		at = 52
		helper_4116e6bb(6120130)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.delay_object_sequence_motion_track(5, 30)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 53
		helper_4116e6bb(6120135)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 54
		helper_4116e6bb(6120140)
		at = 55
		wait_objects(5)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.delay_object_sequence_motion_track(5, 60)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 56
		helper_0382f327(6120150, 150)
		at = 57
		wait_objects(5)
		event.set_camera_sequence_position(105.2, 163.52, 42.91)
		event.set_camera_sequence_look_at(-2.23, 23.98, 214.38)
		event.set_object_sequence_motion(5, "会話２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 58
		helper_0382f327(6120160, 150)
		event.set_object_sequence_motion(5, "立ち２から立ち１", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		at = 59
		helper_0382f327(6120165, 240)
		at = 60
		wait_objects(5)
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(4.09, 53.77, 197.71)
		event.set_camera_sequence_look_at(12.21, 56.05, 168.85)
		event.set_object_sequence_motion(5, "会話２")
		event.open_voice_stream_wave(1, 6120170)
		at = 61
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.move_camera_sequence(7.33, 53.77, 186.18, 12.21, 56.05, 168.85, 350)
		event.open_message_window_2(0, 6120170)
		open_message(0, -1, 8, 0, 0)
		while var6 < 350 do
			projection = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * var6) / 350) + vm.f32(524.9))
			event.set_event_projection(projection)
			var6 = var6 + 1
			at = 62
			vm.wait(62)
		end
		close_message(0)
		event.close_voice_stream(1)
		at = 63
		wait_camera()
		event.set_event_projection(524.9)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-26.16, 2.12, 260.08)
		event.set_camera_sequence_look_at(-0.76, 24.0, 324.82)
		event.set_object_sequence_motion(5, "立ち2", 4)
		at = 64
		helper_0382f327(6120180, 240)
		event.start_crossfade(30)
		event.set_camera_sequence_position(52.31, 50.13, 183.8)
		event.set_camera_sequence_look_at(-3.22, 50.82, 166.04)
		event.set_object_sequence_motion(5, "会話２", 6)
		event.delay_object_sequence_motion_track(5, 30)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 65
		helper_0382f327(6120185, 130)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.43, 137.04, 56.89)
		event.set_camera_sequence_look_at(-1.45, 10.06, 253.11)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 66
		helper_0382f327(6120190, 90)
		event.set_object_sequence_motion(5, "立ち２から立ち１", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.queue_object_sequence_next_motion(5, "会話１", 4)
		at = 67
		helper_0382f327(6120200, -1)
		at = 68
		helper_888ab2a3(15)
		at = 69
		helper_0382f327(6120205, -1)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(43.9, 23.5, 203.81)
		event.set_camera_sequence_look_at(-3.91, 54.72, 160.7)
		at = 70
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 9)
		event.set_object_sequence_motion(5, "握る", 6)
		event.queue_object_sequence_next_motion(5, "会話（握る）")
		event.delay_object_sequence_motion_track(5, 180)
		event.queue_object_sequence_next_motion(5, "握るL", 4)
		at = 71
		helper_0382f327(6120210, -1)
		at = 72
		helper_888ab2a3(30)
		at = 73
		wait_objects(5)
		event.delay_object_sequence_motion_track(5, 40)
		event.set_object_sequence_motion(5, "振り払う", 6)
		event.queue_object_sequence_next_motion(5, "会話（振り払う）", 4)
		event.delay_object_sequence_motion_track(5, 90)
		event.set_object_sequence_motion(5, "振り払うL")
		event.delay_object_sequence_sound_track(5, 40)
		event.play_object_sequence_sound(5, var0, 10)
		event.open_voice_stream_wave(1, 6120220)
		at = 74
		helper_9cbdc640(1)
		event.open_message_window_2(0, 6120220)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 75
		helper_888ab2a3(40)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.88, 46.09, 208.27)
		event.set_camera_sequence_look_at(-1.11, 54.76, 161.71)
		at = 76
		helper_61e5dba6(0, -1)
		close_message(0)
		event.close_voice_stream(1)
		at = 77
		wait_objects(5)
		at = 78
		helper_888ab2a3(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.43, 137.04, 56.89)
		event.set_camera_sequence_look_at(-1.45, 10.06, 253.11)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(5)
		at = 79
		helper_888ab2a3(15)
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 80
		helper_0382f327(6120230, -1)
		at = 81
		wait_objects(5)
		at = 82
		helper_888ab2a3(50)
		event.start_crossfade(30)
		event.set_camera_sequence_position(52.31, 50.13, 183.8)
		event.set_camera_sequence_look_at(-3.22, 50.82, 166.04)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.open_voice_stream_wave(1, 6120240)
		at = 83
		helper_9cbdc640(1)
		event.open_message_window_2(0, 6120240)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 84
		helper_888ab2a3(150)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.16, 53.95, 203.33)
		event.set_camera_sequence_look_at(-0.35, 56.22, 163.1)
		event.move_camera_sequence(-1.0, 53.95, 195.45, -0.35, 56.22, 163.1, 60)
		at = 85
		helper_61e5dba6(0, -1)
		close_message(0)
		event.close_voice_stream(1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		at = 86
		helper_888ab2a3(90)
		event.start_crossfade(30)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_object_sequence_motion(5, "見上げ", 6)
		event.queue_object_sequence_next_motion(5, "見上げＬ", 4)
		at = 87
		helper_0382f327(6120250, -1)
		at = 88
		wait_objects(5)
		at = 89
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-41.31, 31.65, 268.93)
		event.set_camera_sequence_look_at(5.77, 11.37, 343.93)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_object_sequence_motion(1, "なに言ってるの？", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 90
		helper_0382f327(6120260, -1)
		at = 91
		wait_objects(1)
		at = 92
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-0.97, 16.6, 262.08)
		event.set_camera_sequence_look_at(-1.15, 60.73, 165.4)
		event.set_object_sequence_motion(5, "会話２")
		at = 93
		helper_0382f327(6120270, -1)
		at = 94
		helper_888ab2a3(20)
		at = 95
		helper_0382f327(6120273, -1)
		at = 96
		helper_888ab2a3(50)
		at = 97
		helper_0382f327(6120277, -1)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 98
		wait_objects(5)
		at = 99
		helper_888ab2a3(30)
		event.set_camera_sequence_position(146.05, 155.76, 44.66)
		event.set_camera_sequence_look_at(7.17, 5.69, 214.11)
		event.set_object_sequence_motion(5, "見上げ", 6)
		event.queue_object_sequence_next_motion(5, "見上げＬ", 4)
		at = 100
		helper_0382f327(6120280, -1)
		at = 101
		helper_888ab2a3(40)
		at = 102
		helper_0382f327(6120285, -1)
		at = 103
		helper_888ab2a3(30)
		event.set_camera_sequence_position(6.43, 18.29, 287.68)
		event.set_camera_sequence_look_at(16.25, 19.34, 324.59)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.play_sound_effect(var0, 11)
		event.set_object_sequence_motion(0, "そんなこと", 6)
		event.queue_object_sequence_next_motion(0, "そんなことL", 4)
		event.delay_object_sequence_motion_track(0, 45)
		event.set_object_sequence_motion(0, "させない", 6)
		event.queue_object_sequence_next_motion(0, "させないL", 4)
		event.delay_object_sequence_sound_track(0, 70)
		event.play_object_sequence_sound(0, var0, 12)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 104
		helper_0382f327(6120290, -1)
		at = 105
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-6.44, 50.54, 216.04)
		event.set_camera_sequence_look_at(-1.0, 48.49, 160.07)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(5, "会話１", 4)
		at = 106
		helper_0382f327(6120300, -1)
		at = 107
		helper_888ab2a3(30)
		event.set_object_sequence_motion(5, "指す", 2)
		event.queue_object_sequence_next_motion(5, "指す会話", 4)
		at = 108
		helper_0382f327(6120305, -1)
		event.queue_object_sequence_next_motion(5, "指すＬ", 4)
		at = 109
		wait_objects(5)
		at = 110
		helper_888ab2a3(20)
		event.set_object_sequence_motion(5, "握る２", 6)
		event.queue_object_sequence_next_motion(5, "会話（握る２）", 4)
		event.delay_object_sequence_motion_track(5, 180)
		event.set_object_sequence_motion(5, "振り払う（握る2）", 6)
		event.set_object_sequence_motion(5, "振り払うＬ（握る2）")
		event.delay_object_sequence_sound_track(5, 200)
		event.play_object_sequence_sound(5, var0, 10)
		at = 111
		helper_0382f327(6120310, -1)
		at = 112
		wait_objects(5)
		at = 113
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.reset_object_sequence_dynamic_animation(5)
		at = 114
		helper_888ab2a3(20)
		event.set_object_sequence_motion(5, "会話２", 4)
		at = 115
		helper_0382f327(6120320, -1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		at = 116
		helper_888ab2a3(20)
		event.set_camera_sequence_position(22.17, 49.65, 213.77)
		event.set_camera_sequence_look_at(-1.95, 51.8, 171.81)
		event.set_object_sequence_motion(5, "会話２", 4)
		at = 117
		helper_0382f327(6120323, -1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		at = 118
		helper_888ab2a3(20)
		event.set_object_sequence_motion(5, "両手ゆっくり", 6)
		event.queue_object_sequence_next_motion(5, "両手ゆっくりＬ", 4)
		at = 119
		helper_0382f327(6120327, -1)
		at = 120
		wait_objects(5)
		event.set_camera_sequence_position(27.8, 20.33, 262.64)
		event.set_camera_sequence_look_at(4.57, 15.57, 325.51)
		at = 121
		helper_888ab2a3(15)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "身構え", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		at = 122
		helper_888ab2a3(60)
		event.set_camera_sequence_position(17.33, 128.97, 230.66)
		event.set_camera_sequence_look_at(0.33, 49.98, 168.45)
		event.set_character_active(17)
		event.set_character_visible(17, 1, 1, 0.033333335)
		event.set_object_sequence_position(7, -0.95, 0.2, 164.64)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(5, "天に", 6)
		event.queue_object_sequence_next_motion(5, "天にＬ", 4)
		event.play_sound_effect(var0, 14)
		event.play_sound_effect(var0, 15)
		at = 123
		helper_888ab2a3(30)
		event.shake_camera_sequence_vertically(0.0, 0.3, 0.0, -1)
		event.play_sound_effect(var0, 16)
		at = 124
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-6.24, 49.19, 375.53)
		event.set_camera_sequence_look_at(-1.83, 51.77, 225.87)
		at = 125
		helper_888ab2a3(90)
		event.set_camera_sequence_position(-31.26, 4.98, 277.65)
		event.set_camera_sequence_look_at(0.45, 22.39, 330.46)
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "ぐらり", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		at = 126
		helper_888ab2a3(90)
		event.set_camera_sequence_position(57.69, 37.12, 273.28)
		event.set_camera_sequence_look_at(0.0, 49.89, 171.27)
		at = 127
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-28.88, 35.65, 295.17)
		event.set_camera_sequence_look_at(-16.06, 17.38, 336.62)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 128
		helper_0382f327(6120330, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 129
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_038a2e4d(60)
		end
		if at <= 3 then
			helper_53ffe901(6120010, -1)
		end
		if at <= 4 then
			helper_238b5abc(4)
		end
		if at <= 5 then
			helper_038a2e4d(60)
		end
		if at <= 6 then
			helper_038a2e4d(90)
		end
		if at <= 7 then
			helper_8cd371d7(6120020)
		end
		if at <= 8 then
			helper_8cd371d7(6120030)
		end
		if at <= 9 then
			helper_038a2e4d(30)
		end
		if at <= 10 then
			helper_238b5abc(4)
		end
		if at <= 11 then
			helper_038a2e4d(16)
		end
		if at <= 12 then
			helper_038a2e4d(6)
		end
		if at <= 13 then
			helper_038a2e4d(10)
		end
		if at <= 14 then
			helper_038a2e4d(8)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_53ffe901(6120040, 45)
		end
		if at <= 17 then
			helper_53ffe901(6120050, 70)
		end
		if at <= 18 then
			helper_238b5abc(4)
		end
		if at <= 19 then
			helper_038a2e4d(30)
		end
		if at <= 20 then
			helper_53ffe901(6120060, -1)
		end
		if at <= 21 then
			helper_038a2e4d(30)
		end
		if at <= 22 then
			helper_238b5abc(4)
		end
		if at <= 23 then
			helper_53ffe901(6120065, -1)
		end
		if at <= 24 then
			helper_238b5abc(4)
		end
		if at <= 25 then
			helper_038a2e4d(60)
		end
		if at <= 26 then
			helper_53ffe901(6120070, 60)
		end
		if at <= 27 then
			helper_038a2e4d(60)
		end
		if at <= 28 then
			helper_038a2e4d(90)
		end
		if at <= 29 then
			helper_038a2e4d(60)
		end
		if at <= 30 then
			helper_038a2e4d(15)
		end
		if at <= 31 then
			helper_038a2e4d(15)
		end
		if at <= 32 then
			helper_53ffe901(6120080, 30)
		end
		if at <= 33 then
			helper_038a2e4d(30)
		end
		if at <= 34 then
			helper_038a2e4d(30)
		end
		if at <= 35 then
			helper_038a2e4d(30)
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			helper_038a2e4d(30)
		end
		if at <= 38 then
			helper_53ffe901(6120090, 180)
		end
		if at <= 39 then
			helper_344d6cd8()
		end
		if at <= 40 then
			x = vm.f32(-22.54)
			y = vm.f32(20.9)
			z = vm.f32(332.85)
			helper_344d6cd8()
		end
		if at <= 41 then
			helper_038a2e4d(60)
		end
		if at <= 42 then
			helper_53ffe901(6120100, -1)
		end
		if at <= 43 then
			helper_038a2e4d(60)
		end
		if at <= 44 then
			helper_238b5abc(5)
		end
		if at <= 45 then
			helper_038a2e4d(4)
		end
		if at <= 46 then
			helper_8cd371d7(6120110)
		end
		if at <= 47 then
			helper_238b5abc(5)
		end
		if at <= 48 then
			helper_8cd371d7(6120120)
		end
		if at <= 49 then
			helper_8cd371d7(6120125)
		end
		if at <= 50 then
			helper_238b5abc(1)
		end
		if at <= 51 then
			helper_8cd371d7(6120130)
		end
		if at <= 52 then
			helper_8cd371d7(6120135)
		end
		if at <= 53 then
			helper_8cd371d7(6120140)
		end
		if at <= 54 then
			helper_238b5abc(5)
		end
		if at <= 55 then
			helper_53ffe901(6120150, 150)
		end
		if at <= 56 then
			helper_238b5abc(5)
		end
		if at <= 57 then
			helper_53ffe901(6120160, 150)
		end
		if at <= 58 then
			helper_53ffe901(6120165, 240)
		end
		if at <= 59 then
			helper_238b5abc(5)
		end
		if at <= 60 then
			helper_238b5abc(1)
		end
		if at <= 61 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			projection = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * var6) / 350) + vm.f32(524.9))
			local _ = var6 < 350
			var6 = var6 + 1
		end
		if at <= 62 then
			helper_d16eef1e(0)
			helper_344d6cd8()
		end
		if at <= 63 then
			helper_53ffe901(6120180, 240)
		end
		if at <= 64 then
			helper_53ffe901(6120185, 130)
		end
		if at <= 65 then
			helper_53ffe901(6120190, 90)
		end
		if at <= 66 then
			helper_53ffe901(6120200, -1)
		end
		if at <= 67 then
			helper_038a2e4d(15)
		end
		if at <= 68 then
			helper_53ffe901(6120205, -1)
		end
		if at <= 69 then
			helper_038a2e4d(30)
		end
		if at <= 70 then
			helper_53ffe901(6120210, -1)
		end
		if at <= 71 then
			helper_038a2e4d(30)
		end
		if at <= 72 then
			helper_238b5abc(5)
		end
		if at <= 73 then
			helper_238b5abc(1)
		end
		if at <= 74 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_038a2e4d(40)
		end
		if at <= 75 then
			helper_972d1084(0, -1)
		end
		if at <= 76 then
			helper_d16eef1e(0)
			helper_238b5abc(5)
		end
		if at <= 77 then
			helper_038a2e4d(30)
		end
		if at <= 78 then
			helper_038a2e4d(15)
		end
		if at <= 79 then
			helper_53ffe901(6120230, -1)
		end
		if at <= 80 then
			helper_238b5abc(5)
		end
		if at <= 81 then
			helper_038a2e4d(50)
		end
		if at <= 82 then
			helper_238b5abc(1)
		end
		if at <= 83 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_038a2e4d(150)
		end
		if at <= 84 then
			helper_972d1084(0, -1)
		end
		if at <= 85 then
			helper_d16eef1e(0)
			helper_038a2e4d(90)
		end
		if at <= 86 then
			helper_53ffe901(6120250, -1)
		end
		if at <= 87 then
			helper_238b5abc(5)
		end
		if at <= 88 then
			helper_038a2e4d(60)
		end
		if at <= 89 then
			helper_53ffe901(6120260, -1)
		end
		if at <= 90 then
			helper_238b5abc(1)
		end
		if at <= 91 then
			helper_038a2e4d(30)
		end
		if at <= 92 then
			helper_53ffe901(6120270, -1)
		end
		if at <= 93 then
			helper_038a2e4d(20)
		end
		if at <= 94 then
			helper_53ffe901(6120273, -1)
		end
		if at <= 95 then
			helper_038a2e4d(50)
		end
		if at <= 96 then
			helper_53ffe901(6120277, -1)
		end
		if at <= 97 then
			helper_238b5abc(5)
		end
		if at <= 98 then
			helper_038a2e4d(30)
		end
		if at <= 99 then
			helper_53ffe901(6120280, -1)
		end
		if at <= 100 then
			helper_038a2e4d(40)
		end
		if at <= 101 then
			helper_53ffe901(6120285, -1)
		end
		if at <= 102 then
			helper_038a2e4d(30)
		end
		if at <= 103 then
			helper_53ffe901(6120290, -1)
		end
		if at <= 104 then
			helper_038a2e4d(30)
		end
		if at <= 105 then
			helper_53ffe901(6120300, -1)
		end
		if at <= 106 then
			helper_038a2e4d(30)
		end
		if at <= 107 then
			helper_53ffe901(6120305, -1)
		end
		if at <= 108 then
			helper_238b5abc(5)
		end
		if at <= 109 then
			helper_038a2e4d(20)
		end
		if at <= 110 then
			helper_53ffe901(6120310, -1)
		end
		if at <= 111 then
			helper_238b5abc(5)
		end
		if at <= 112 then
			helper_038a2e4d(30)
		end
		if at <= 113 then
			helper_038a2e4d(20)
		end
		if at <= 114 then
			helper_53ffe901(6120320, -1)
		end
		if at <= 115 then
			helper_038a2e4d(20)
		end
		if at <= 116 then
			helper_53ffe901(6120323, -1)
		end
		if at <= 117 then
			helper_038a2e4d(20)
		end
		if at <= 118 then
			helper_53ffe901(6120327, -1)
		end
		if at <= 119 then
			helper_238b5abc(5)
		end
		if at <= 120 then
			helper_038a2e4d(15)
		end
		if at <= 121 then
			helper_038a2e4d(60)
		end
		if at <= 122 then
			helper_038a2e4d(30)
		end
		if at <= 123 then
			helper_038a2e4d(30)
		end
		if at <= 124 then
			helper_038a2e4d(90)
		end
		if at <= 125 then
			helper_038a2e4d(90)
		end
		if at <= 126 then
			helper_038a2e4d(60)
		end
		if at <= 127 then
			helper_53ffe901(6120330, -1)
		end
		if at <= 128 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 130
	vm.entry(130)
	event.cancel_drama_scene_skip()
	event.set_motion_blur(0)
	event.set_wind(-1)
	event.stop_music(0)
	event.stop_sound_effect(var0, 15)
	event.stop_sound_effect(var0, 16)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.show_atlamillia_frames(0, 0, 0)
	else
		event.show_atlamillia_frames(1, 0, 0)
	end
	event.clear_camera_sequence()
	event.skip_next_music_load()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -1.02, 0.2, 111.04)
	event.set_character_rotation(0, 0.0, 3.11, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_2462c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7812)
		var0 = event.load_sound_effect_file_2(7812) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e608/e608_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2, 10)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e612/e612_ghikari.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5, 13)
		event.set_object_sequence_object(5, 5)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, 16.61, 0.2, 323.16)
		event.set_object_handle_rotation(0, 0.0, 3.11, 0.0)
		event.set_object_handle_motion(0, "かまえるL", 4)
		event.set_object_handle_footstep_sound(0, 4)
		event.set_object_handle_position(1, -19.07, 0.2, 324.55)
		event.set_object_handle_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_handle_motion(1, "身構えL", 4)
		event.set_object_handle_footstep_sound(1, 4)
		event.set_object_handle_position(2, -0.95, 0.2, 164.64)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "両手上げＬ", 4)
		event.set_object_handle_footstep_sound(2, 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(290.66, 22.4, 159.89)
		event.set_camera_sequence_look_at(-25.29, 32.09, 238.0)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(0, 13)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(2, "両手下ろす", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(27.47, 43.98, 229.92)
		event.set_camera_sequence_look_at(-0.83, 51.54, 164.19)
		event.set_object_sequence_motion(2, "すばらしい", 4)
		event.delay_object_sequence_motion_track(2, 120)
		event.queue_object_sequence_next_motion(2, "すばらしいＬ", 4)
		helper_0382f327(6120340, -1)
		wait_objects(2)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(75.01, 95.44, 105.8)
		event.set_camera_sequence_look_at(-40.9, 14.77, 261.94)
		event.set_object_sequence_motion(2, "立ち2", 4)
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_motion(1, "何をした？", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(6120350, -1)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "会話２", 6)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		helper_0382f327(6120360, -1)
		wait_objects(2)
		event.set_camera_sequence_position(-0.97, 16.6, 262.08)
		event.set_camera_sequence_look_at(-1.15, 60.73, 165.4)
		event.set_object_sequence_motion(2, "会話２")
		event.delay_object_sequence_motion_track(2, 240)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		helper_0382f327(6120365, -1)
		wait_objects(2)
		event.set_camera_sequence_position(17.77, 47.61, 211.35)
		event.set_camera_sequence_look_at(-1.62, 53.0, 164.21)
		event.set_character_active(13)
		event.set_character_visible(13, 1, 1, 0.033333335)
		event.set_object_sequence_position(5, -0.95, 0.2, 164.64)
		event.play_sound_effect(var0, 2)
		event.set_object_sequence_motion(2, "両手上げ", 6)
		event.queue_object_sequence_next_motion(2, "両手上げＬ", 4)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(-10.24, 9.39, 285.55)
		event.set_camera_sequence_look_at(3.63, 24.57, 346.84)
		event.set_object_sequence_position(0, 10.93, 0.2, 329.45)
		event.set_object_sequence_rotation(0, 0.0, -3.05, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -10.84, 0.2, 327.13)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.shake_camera_sequence_vertically(0.0, 0.2, 0.2, -1)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "ぐらり", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(30.72, 20.08, 266.27)
		event.set_camera_sequence_look_at(-3.69, 16.93, 344.36)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "びっくりキョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "きょろきょろ", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(6120370, 45)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(6120380, -1)
		event.set_camera_sequence_position(30.39, 12.88, 208.54)
		event.set_camera_sequence_look_at(-1.44, 44.98, 166.69)
		helper_888ab2a3(90)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.skip_next_music_load()
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 3)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_active(0)
	event.set_character_position(0, -1.02, 0.2, 111.04)
	event.set_character_rotation(0, 0.0, 3.11, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
end

--- Helper function.
local function helper_274c8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7814)
		var0 = event.load_sound_effect_file_2(7814) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e608/e608_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2, 10)
		event.set_object_sequence_object(2, 2)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, 10.61, 0.2, 323.16)
		event.set_object_handle_rotation(0, 0.0, -2.93, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -10.07, 0.2, 324.55)
		event.set_object_handle_rotation(1, 0.0, 3.11, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(2, -0.95, 0.2, 164.64)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "両手上げＬ", 4)
		event.set_object_handle_footstep_sound(2, 21)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.19, 19.21, 277.15)
		event.set_camera_sequence_look_at(-0.04, 20.06, 325.14)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(6120390, -1)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-0.94, 45.01, 219.98)
		event.set_camera_sequence_look_at(-0.16, 52.54, 162.81)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(2, "両手下ろす", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_0382f327(6120400, -1)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "ククク", 6)
		event.queue_object_sequence_next_motion(2, "ククク会話", 4)
		helper_0382f327(6120410, -1)
		wait_objects(2)
		helper_888ab2a3(20)
		event.set_object_sequence_motion(2, "ククク会話")
		event.delay_object_sequence_motion_track(2, 90)
		event.queue_object_sequence_next_motion(2, "クククＬ", 4)
		helper_0382f327(6120415, -1)
		wait_objects(2)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(1.81, 6.92, 260.18)
		event.set_camera_sequence_look_at(1.38, 17.89, 324.46)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, 12.18, 0.2, 569.18, 60, 1)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, -11.66, 0.2, 564.61, 60, 1)
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.show_dungeon_status_bar(1, 1.0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	event_99()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		helper_9dafbc83(20.0, 280.0, -600.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	else
		flag = event.get_save_flag(702) or flag
		if flag == 0 then
			helper_29220()
			helper_9dafbc83(vm.f32(649.7), 0.0, vm.f32(-122.2), vm.f32(1.71))
			event.reset_follow_camera(1, 3.14, 0.0)
			event.fade_in_screen(30)
			return
		end
		old_map_no = event.get_previous_map() or old_map_no
		var3 = event.get_map_type(old_map_no) or var3
		if var3 ~= -1 then
			if old_map_no == 128 or var3 == 7 or var3 == 8 then
				helper_9dafbc83(0.0, 280.0, -650.0, 0.0)
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			else
				helper_9dafbc83(0.0, 0.0, 600.0, vm.f32(3.14))
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			end
		end
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(36)
	event.play_music(0)
	event.attach_object_handle_to_map_part_2(0, "p05_d06e01-0")
	event.set_object_handle_visible(0, 1)
	event.fade_in_screen(30)
	event.load_dungeon_monster(515, 1)
	event.place_dungeon_monster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	event.finish_event()
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	event.initialize_event()
	vm.wait(1)
	event.set_dungeon_pause_flags(15, 1)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 0.0, 30)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 0.0, 0.0, 0.0, 128.0)
	event.set_message_window_mode(0, 7)
	event.fade_in_screen(15)
	event.open_message_window_2(0, "e610『グリフォンの言い分』")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_object_sequence_color(0, 0.0, 0.0, 0.0, 0.0, 30)
	helper_888ab2a3(30)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_dungeon_pause_flags(15, 0)
	event.finish_event()
end

--- Event 153, which map data, a script or the engine runs by number.
function script.event_153()
	event.initialize_event()
	vm.wait(1)
	event.set_message_window_mode(0, 7)
	event.fade_in_screen(15)
	event.open_message_window_2(0, "勝利")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.finish_event()
end

--- Event 154, which map data, a script or the engine runs by number.
function script.event_154()
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(19, 1)
	event.add_inventory_item(8, 1)
	event.add_inventory_item(30, 1)
	event.add_inventory_item(33, 1)
	event.add_inventory_item(38, 1)
	event.add_inventory_item(77, 1)
	event.add_inventory_item(80, 1)
	event.add_inventory_item(59, 1)
	event.add_inventory_item(87, 1)
	event.add_inventory_item(55, 1)
	event.add_inventory_item(72, 1)
	event.add_inventory_item(84, 1)
	event.add_inventory_item(63, 1)
	event.add_inventory_item(107, 1)
	event.add_inventory_item(96, 1)
	event.add_inventory_item(99, 1)
	event.add_inventory_item(105, 1)
	event.finish_event()
end

--- Event 155, which map data, a script or the engine runs by number.
function script.event_155()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	event.set_camera_position(0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 0.0, 0.0)
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local argc: s32 = 0
	argc = event.get_main_loop_mode() or argc
	if argc == 1 then
		if helper_6d912f07() ~= 0 then
			event.jump_to_map_2(-1, "g05")
			vm.wait(2)
		end
	elseif helper_2d6d4() ~= 0 then
		event.set_save_control_bits(1, 0)
		event.go_to_georama_edit(177, 100)
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local var2: s32 = 0
	if helper_2dafc() ~= 0 then
		event.set_dungeon_stage_id(5)
		event.open_event_menu(3, 5)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var2 = out3 or var2
		end
		if var2 == 0 then
			event.fade_in_screen(30)
			return
		else
			if var2 == 26 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(5, var2, 1010)
		end
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	helper_2eddc(0)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	helper_2eddc(1)
end

--- Event 403, which map data, a script or the engine runs by number.
function script.event_403()
	helper_2eddc(2)
end

--- Event 404, which map data, a script or the engine runs by number.
function script.event_404()
	helper_2eddc(3)
end

--- Event 405, which map data, a script or the engine runs by number.
function script.event_405()
	helper_2eddc(4)
end

--- Event 406, which map data, a script or the engine runs by number.
function script.event_406()
	helper_2eddc(5)
end

--- Event 407, which map data, a script or the engine runs by number.
function script.event_407()
	helper_2eddc(6)
end

--- Event 408, which map data, a script or the engine runs by number.
function script.event_408()
	helper_2eddc(7)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_104f0()
	event.set_function_point_enabled("", "exit", 0)
	event.set_function_point_enabled("", "in_dng", 0)
	helper_abdda14b()
	event.set_save_control_bits(1, 1)
	vm.wait(2)
	event.attach_object_handle_to_map_part_2(0, "p05_d06e01-0")
	event.set_object_handle_visible(0, 1)
	event.load_dungeon_monster(515, 1)
	event.place_dungeon_monster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	helper_9dafbc83(0.0, 0.0, 600.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 600.0)
	event.set_camera_position(0.0, 40.0, 720.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(20)
	event.finish_event()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(10)
		at = 1
		helper_888ab2a3(10)
		event.stop_port_sound_effects(5)
		event.set_dungeon_pause_flags(1041, 1)
		event.clear_all_dungeon_effects()
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.get_character_rotation(0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = event.get_camera_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		at = 2
		helper_15394()
		event.set_character_position(0, var0, var1, var2)
		event.set_character_rotation(0, var3, var4, var5)
		event.set_camera_position(pos_x, pos_y, pos_z)
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		event.reset_follow_camera(0)
		event.set_dungeon_pause_flags(1041, 0)
		event.fade_in_screen(10)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_15394()
				return vm.continue_with(function()
					event.set_character_position(0, var0, var1, var2)
					event.set_character_rotation(0, var3, var4, var5)
					event.set_camera_position(pos_x, pos_y, pos_z)
					event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
					event.reset_follow_camera(0)
					event.set_dungeon_pause_flags(1041, 0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	local active_chr_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(10)
		at = 1
		helper_888ab2a3(10)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_18964()
		event.set_save_control_bits(8, 1)
		event.load_dungeon_map("s31")
		event.load_event_script("s31/s31.stb", 510)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_18964()
				return vm.continue_with(function()
					event.set_save_control_bits(8, 1)
					event.load_dungeon_map("s31")
					event.load_event_script("s31/s31.stb", 510)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 506, which map data, a script or the engine runs by number.
function script.event_506()
	helper_2462c()
	event.load_dungeon_map("s35")
	event.load_event_script("s35/s35.stb", 502)
	vm.wait(2)
end

--- Event 508, which map data, a script or the engine runs by number.
function script.event_508()
	helper_274c8()
	event.set_save_control_bits(1, 0)
	event.go_to_georama_edit(187, 100)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(608) or flag
		flag_2 = event.get_save_flag(612) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var3 = vm.float_bits(event.get_random_number(100)) or var3
			if var3 < 50 then
				at = 1
				helper_a9eaf20e(0, 8550080)
			else
				at = 2
				helper_a9eaf20e(0, 8550090)
			end
			return
		end
		at = 3
		helper_f9968159(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_2609f66b(0, 8550090)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 16080, which map data, a script or the engine runs by number.
script.event_16080 = helper_104f0

--- Event 16100, which map data, a script or the engine runs by number.
script.event_16100 = helper_15394

--- Event 16120, which map data, a script or the engine runs by number.
function script.event_16120()
	helper_18964()
	event.set_save_control_bits(8, 1)
	event.load_dungeon_map("s31")
	event.load_event_script("s31/s31.stb", 510)
	vm.wait(2)
end

--- Event 17020, which map data, a script or the engine runs by number.
script.event_17020 = helper_29220

return script
