--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local interpolate = require("@lib/event/interpolate")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c4f6430f()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(504, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(32)
		event.load_map_sounds(5203)
		var0 = event.load_sound_effect_file_2(5203) or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e504/")
		event.load_message_file(0, 5, "e504_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e504_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e504_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e504_ark_kage.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(7, 34)
		event.clear_object_sequence(7, 34)
		event.set_object_sequence_object(7, 7)
		event.set_scene_status_flags(1, 34, 512, 1)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e500/e504/e504_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e500/e504/e504_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_map_part_2(2, "p01_battleship")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_position(1, 2053.12, 0.0, -189.76)
		event.set_object_handle_rotation(1, 0.0, -1.58, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_position(0, 2033.55, 0.0, -166.12)
		event.set_object_handle_rotation(0, 0.0, -1.7, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_position(7, 1973.31, 18.13, -474.55)
		event.set_object_handle_rotation(7, 0.0, 2.9, 0.0)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_position(2, 3606.9, 843.3, -1400.5)
		event.set_object_handle_rotation(2, 0.0, -1.186824, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_character_model_lighting(0, 0)
		event.set_character_model_lighting(32, 0)
		event.set_character_model_lighting(33, 0)
		event.set_character_model_lighting(3, 0)
		event.set_character_model_color(0, 100.0, 100.0, 100.0, 128.0)
		event.set_character_model_color(32, 100.0, 100.0, 100.0, 128.0)
		event.set_character_model_color(33, 100.0, 100.0, 100.0, 128.0)
		event.set_character_model_color(3, 100.0, 100.0, 100.0, 128.0)
		event.enable_drama_skip()
		event.set_object_handle_visible(2, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1807.61, 141.62, -352.77)
		event.set_camera_sequence_look_at(1973.44, 14.96, -195.42)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 1960.74, 0.0, -178.61, 120)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, 1970.04, 0.0, -200.85, 120)
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		at = 2
		wait_frames(60)
		event.play_sound_effect(var0, 0)
		at = 3
		wait_frames(30)
		event.move_object_sequence(7, 1829.02, 18.13, 47.54, 150)
		event.set_character_model_lighting(0, 0)
		event.set_character_model_lighting(32, 0)
		event.set_character_model_lighting(33, 0)
		event.set_character_model_lighting(3, 0)
		var2 = 0
		while var2 < 60 do
			var3 = interpolate(100.0, 40.0, var2, 60)
			event.set_character_model_color(0, var3, var3, var3, 128.0)
			event.set_character_model_color(32, var3, var3, var3, 128.0)
			event.set_character_model_color(33, var3, var3, var3, 128.0)
			event.set_character_model_color(3, var3, var3, var3, 128.0)
			var2 = var2 + 1
			at = 4
			vm.wait(4)
		end
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 5
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おこり目")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_1584c528(5040010, 45)
		event.set_character_model_lighting(0, 1)
		event.set_character_model_lighting(32, 1)
		event.set_character_model_lighting(33, 1)
		event.set_character_model_lighting(3, 1)
		event.play_music(0)
		event.set_object_handle_visible(2, 1)
		event.set_object_sequence_scale(2, 0.8, 0.8, 0.8)
		event.set_object_handle_visible(7, 0)
		event.set_camera_sequence_position(-630.25, 1117.68, 190.22)
		event.set_camera_sequence_look_at(2862.65, 578.01, -1018.41)
		event.move_camera_sequence(-630.25, 1117.68, 190.22, -662.156, 1651.45, -2008.72, 180)
		event.move_object_sequence(2, -596.8, 1241.3, -2007.8, 180)
		event.rotate_object_sequence(2, 0.0, -1.9896754, 0.0, 180)
		at = 7
		wait_frames(180)
		event.set_camera_sequence_position(-2083.55, 144.26, 1858.12)
		event.set_camera_sequence_look_at(-972.92, 1902.75, -3946.41)
		event.set_object_sequence_position(2, -596.8, 1241.3, -2007.8)
		event.set_object_sequence_rotation(2, 0.0, -2.4609144, 0.0)
		event.move_object_sequence(2, -9640.1, 6816.1, -17522.8, 1200)
		event.rotate_object_sequence_eased(2, 0.0, -2.8099802, 0.0, 60, 0, 1.0)
		event.set_object_sequence_position(1, 1982.08, 0.0, -201.51)
		event.set_object_sequence_rotation(1, 0.0, -1.58, 0.0)
		event.set_object_sequence_position(0, 1979.69, 0.0, -181.39)
		event.set_object_sequence_rotation(0, 0.0, -1.7, 0.0)
		at = 8
		wait_frames(180)
		event.set_camera_sequence_position(1904.82, 53.4, -194.35)
		event.set_camera_sequence_look_at(1984.16, 13.62, -191.87)
		event.stop_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 1)
		event.set_object_sequence_motion(1, "怒り会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_4116e6bb(5040020)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(5040030)
		event.set_object_sequence_motion(1, "握りこぶし", 6)
		event.queue_object_sequence_next_motion(1, "握りこぶしL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(5040040)
		event.set_object_sequence_position(2, -5192.1, 12410.2, -23114.3)
		event.set_object_sequence_rotation(2, 0.0, 2.4870944, 0.0)
		event.set_object_sequence_scale(2, 0.5, 0.5, 0.5)
		event.move_object_sequence(2, -3988.6, 12410.2, -26396.5, 120)
		event.set_camera_sequence_position(1174.88, 7.04, 1268.65)
		event.set_camera_sequence_look_at(1158.55, 18.83, 1228.31)
		event.move_camera_sequence_angle_height_distance_eased(1.31, -11.79, 43.89, 120, 1, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		helper_1584c528(5040050, 120)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1932.53, 50.96, -195.43)
		event.set_camera_sequence_look_at(1975.85, 22.78, -192.38)
		event.set_object_sequence_motion(1, "上→左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 13
		helper_4116e6bb(5040060)
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 14
		helper_4116e6bb(5040065)
		at = 15
		wait_objects(1)
		event.set_object_sequence_motion(0, "右→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "左→上", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(5040070)
		at = 17
		wait_camera()
		at = 18
		wait_objects(1)
		event.set_camera_sequence_position(2031.54, 20.63, -189.44)
		event.set_camera_sequence_look_at(1980.42, 21.38, -191.05)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 19
		helper_4116e6bb(5040080)
		event.set_camera_sequence_position(1913.48, 18.68, -196.77)
		event.set_camera_sequence_look_at(1985.94, 18.83, -191.67)
		event.play_sound_effect(var0, 2)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.play_sound_effect(var0, 3)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 20
		helper_4116e6bb(5040090)
		at = 21
		wait_objects(1)
		event.set_object_sequence_motion(1, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.play_sound_effect(var0, 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 22
		helper_4116e6bb(5040100)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 23
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(60)
		end
		if at <= 2 then
			wait_frames_skipping(30)
		end
		if at <= 3 then
			var2 = 0
			var3 = interpolate(100.0, 40.0, var2, 60)
			local _ = var2 < 60
			var2 = var2 + 1
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			helper_52aadc70(5040010, 45)
		end
		if at <= 6 then
			wait_frames_skipping(180)
		end
		if at <= 7 then
			wait_frames_skipping(180)
		end
		if at <= 8 then
			helper_8cd371d7(5040020)
		end
		if at <= 9 then
			helper_8cd371d7(5040030)
		end
		if at <= 10 then
			helper_8cd371d7(5040040)
		end
		if at <= 11 then
			helper_52aadc70(5040050, 120)
		end
		if at <= 12 then
			helper_8cd371d7(5040060)
		end
		if at <= 13 then
			helper_8cd371d7(5040065)
		end
		if at <= 14 then
			helper_238b5abc(1)
		end
		if at <= 15 then
			helper_8cd371d7(5040070)
		end
		if at <= 16 then
			helper_344d6cd8()
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_8cd371d7(5040080)
		end
		if at <= 19 then
			helper_8cd371d7(5040090)
		end
		if at <= 20 then
			helper_238b5abc(1)
		end
		if at <= 21 then
			helper_8cd371d7(5040100)
		end
		if at <= 22 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(var0, 0)
	event.stop_sound_effect(var0, 1)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 3)
	event.stop_sound_effect(var0, 4)
	event.set_object_handle_position(2, 3139.7, 9.0, 918.2)
	event.call_command(703, 2, 2.4260077, 0.0) -- retail: the handler rejects 3 arguments
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_character_model_lighting(0, 1)
	event.set_character_model_lighting(32, 1)
	event.set_character_model_lighting(33, 1)
	event.set_character_model_lighting(3, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
end

return helper_c4f6430f
