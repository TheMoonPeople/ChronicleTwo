--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_e787350a = require("@lib/event/helper_e787350a")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_97d79c37()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(15)
		at = 1
		wait_frames(15)
		event.set_save_flag(434, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = 8
		do
			local out1, out2, out3 = event.get_character_position(var0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.get_character_rotation(var0)
			var5 = out2 or var5
		end
		event.set_event_world_coordinate(var1, var2, var3, var5)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		var8 = event.get_active_music_number() or var8
		if var8 ~= 3 then
			event.stop_music(0)
			at = 2
			wait_frames(4)
			event.load_music(3)
			event.play_music(0)
		end
		event.load_map_sounds(4817)
		var9 = event.load_sound_effect_file_2(4817) or var9
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e434/")
		event.load_message_file(0, 5, "e434_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e434_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e434_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.attach_object_handle_to_character(2, 8)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e434_honyaku_Y.gltf", "info", 18)
		event.set_character_active(18)
		event.load_character(5, "e434_honyaku_M.gltf", "info", 19)
		event.set_character_active(19)
		event.load_character(5, "e434_hiyaku.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 16)
			event.load_equipment_model(5, 0, 4, "info", 16)
			event.load_equipment_model(5, 0, 3, "info", 16)
			event.load_equipment_model(5, 0, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e434/e434_mints.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 16)
			event.attach_object_handle_to_character(0, 16)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 16)
			event.load_equipment_model(5, 1, 4, "info", 16)
			event.load_equipment_model(5, 1, 3, "info", 16)
			event.load_equipment_model(5, 1, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e434/e434_monica.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 16)
			event.attach_object_handle_to_character(1, 16)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(16)
		event.set_character_active(17)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_visible(4, 0)
		if active_chr_no == 0 then
			event.attach_character_to_frame(0, "item", 18)
			event.attach_character_to_frame(0, "item", 20)
			event.attach_character_to_frame(16, "item", 19)
		else
			event.attach_character_to_frame(0, "item", 19)
			event.attach_character_to_frame(16, "item", 18)
			event.attach_character_to_frame(16, "item", 20)
		end
		event.set_object_handle_position(0, 8.0, 0.0, 310.0)
		event.set_object_handle_rotation(0, 0.0, -2.9, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -8.0, 0.0, 310.0)
		event.set_object_handle_rotation(1, 0.0, 2.9, 0.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_motion(2, "立ち（下見）", 4)
		event.set_object_sequence_motion(0, "耳に当てる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "耳に当てるL", 4)
		event.set_object_sequence_motion(1, "耳に当てる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "耳に当てるL", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 22.0, 360.0)
		event.set_camera_sequence_look_at(0.0, 22.0, 236.0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		at = 3
		wait_frames(10)
		event.play_sound_effect(var9, 0)
		at = 4
		wait_objects(1)
		at = 5
		wait_frames(10)
		event.move_camera_sequence_eased(0.0, 130.0, 700.0, 0.0, 130.0, 100.0, 60, 0, 1.0)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		at = 6
		helper_4116e6bb(4340010)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		at = 7
		helper_4116e6bb(4340015)
		at = 8
		wait_camera()
		event.set_camera_sequence_position(0.0, 51.02, 278.53)
		event.set_camera_sequence_look_at(0.0, 17.44, 308.64)
		event.set_object_sequence_motion(0, "耳に当てる会話", 6)
		event.queue_object_sequence_next_motion(0, "耳に当てるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		helper_4116e6bb(4340020)
		at = 10
		wait_objects(0)
		event.set_camera_sequence_position(136.58, 282.08, 250.29)
		event.set_camera_sequence_look_at(103.01, 274.65, 222.02)
		event.set_object_sequence_motion(2, "立ち（下見）", 4)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		at = 11
		helper_4116e6bb(4340030)
		event.set_camera_sequence_position(532.81, 223.49, 220.44)
		event.set_camera_sequence_look_at(84.67, 164.89, 164.57)
		event.set_object_sequence_motion(0, "耳に当てる会話", 6)
		event.queue_object_sequence_next_motion(0, "耳に当てるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		helper_4116e6bb(4340040)
		at = 13
		wait_objects(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 14
		helper_4116e6bb(4340045)
		event.set_camera_sequence_position(136.58, 282.08, 250.29)
		event.set_camera_sequence_look_at(103.01, 274.65, 222.02)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "こまり顔")
		event.set_object_handle_texture_animation(0, 1, "こまり目パチ")
		event.set_object_sequence_motion(2, "立ち（下見）", 4)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		at = 15
		helper_4116e6bb(4340050)
		event.set_camera_sequence_position(0.0, 51.02, 278.53)
		event.set_camera_sequence_look_at(0.0, 17.44, 308.64)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(4340060)
		event.set_camera_sequence_position(136.58, 282.08, 250.29)
		event.set_camera_sequence_look_at(103.01, 274.65, 222.02)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "首ふる", 6)
		event.queue_object_sequence_next_motion(2, "首ふるL", 4)
		at = 17
		helper_4116e6bb(4340070)
		at = 18
		wait_objects(2)
		event.queue_object_sequence_next_motion(2, "首ふる戻り", 6)
		event.queue_object_sequence_next_motion(2, "会話入り", 4)
		event.queue_object_sequence_next_motion(2, "立ち（下見）", 4)
		at = 19
		wait_objects(2)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		at = 20
		helper_4116e6bb(4340075)
		event.set_object_sequence_motion(2, "会話戻り", 2)
		event.queue_object_sequence_next_motion(2, "首後ろにやる", 2)
		event.wait_object_sequence_motion_end(2)
		at = 21
		wait_frames(50)
		event.play_sound_effect(var9, 1)
		at = 22
		wait_objects(2)
		event.set_camera_sequence_position(63.79, 24.14, 233.74)
		event.set_camera_sequence_look_at(6.92, 16.71, 285.79)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(20)
		event.set_character_active(0, 19)
		event.set_character_active(0, 18)
		event.play_sound_effect(var9, 2)
		event.set_object_sequence_motion(2, "竜の秘薬を渡す2", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "竜の秘薬ゲット", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "秘薬見る", 4, -1.0, 1)
		at = 23
		wait_frames(30)
		at = 24
		helper_e787350a(375, 1)
		event.set_camera_sequence_position(258.67, 378.76, -28.84)
		event.set_camera_sequence_look_at(79.78, 245.69, 90.44)
		event.set_object_sequence_motion(2, "立ち（下見）", 4)
		event.set_object_sequence_motion(0, "上見る", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		at = 25
		wait_frames(4)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		at = 26
		helper_4116e6bb(4340080)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 27
		helper_4116e6bb(4340090)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 28
		helper_4116e6bb(4340100)
		event.set_object_sequence_motion(0, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見うなづく", 6)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 29
		helper_4116e6bb(4340110)
		event.fade_out_screen(30)
		at = 30
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var0 = 8
			wait_frames_skipping(4)
		end
		if at <= 2 then
			wait_frames_skipping(10)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			wait_frames_skipping(10)
		end
		if at <= 5 then
			helper_8cd371d7(4340010)
		end
		if at <= 6 then
			helper_8cd371d7(4340015)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			helper_8cd371d7(4340020)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_8cd371d7(4340030)
		end
		if at <= 11 then
			helper_8cd371d7(4340040)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_8cd371d7(4340045)
		end
		if at <= 14 then
			helper_8cd371d7(4340050)
		end
		if at <= 15 then
			helper_8cd371d7(4340060)
		end
		if at <= 16 then
			helper_8cd371d7(4340070)
		end
		if at <= 17 then
			helper_238b5abc(2)
		end
		if at <= 18 then
			helper_238b5abc(2)
		end
		if at <= 19 then
			helper_8cd371d7(4340075)
		end
		if at <= 20 then
			wait_frames_skipping(50)
		end
		if at <= 21 then
			helper_238b5abc(2)
		end
		if at <= 22 then
			wait_frames_skipping(30)
		end
		if at <= 23 then
			helper_5c12934f(375, 1)
		end
		if at <= 24 then
			wait_frames_skipping(4)
		end
		if at <= 25 then
			helper_8cd371d7(4340080)
		end
		if at <= 26 then
			helper_8cd371d7(4340090)
		end
		if at <= 27 then
			helper_8cd371d7(4340100)
		end
		if at <= 28 then
			helper_8cd371d7(4340110)
		end
		if at <= 29 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.play_music(0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.load_message_file(0, -1)
	if active_chr_no == 0 then
		event.set_object_sequence_position(0, 0.0, 0.0, 180.0)
	else
		event.set_object_sequence_position(1, 0.0, 0.0, 180.0)
	end
	event.set_camera_sequence_position(0.0, 30.0, 280.0)
	event.set_camera_sequence_look_at(0.0, 30.0, 180.0)
	at = 31
	vm.wait(31)
	at = 32
	helper_a87eb945(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_97d79c37
