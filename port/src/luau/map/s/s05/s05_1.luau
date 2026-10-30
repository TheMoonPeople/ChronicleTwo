--!strict
-- map/s/s05/s05_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0616fd34 = require("@lib/event/helper_0616fd34")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4fba7aa8 = require("@lib/event/helper_4fba7aa8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_6050d30e = require("@lib/event/helper_6050d30e")
local helper_683bd2fc = require("@lib/event/helper_683bd2fc")
local helper_73c9d0a3 = require("@lib/event/helper_73c9d0a3")
local helper_76f23193 = require("@lib/event/helper_76f23193")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_bb23ef44 = require("@lib/event/helper_bb23ef44")
local helper_bb522b21 = require("@lib/event/helper_bb522b21")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c9349531 = require("@lib/event/helper_c9349531")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d529ed92 = require("@lib/event/helper_d529ed92")
local helper_deba899b = require("@lib/event/helper_deba899b")
local helper_e509fa5e = require("@lib/event/helper_e509fa5e")
local helper_e52544df = require("@lib/event/helper_e52544df")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_fc5948a6 = require("@lib/event/helper_fc5948a6")
local helper_ffd118ae = require("@lib/event/helper_ffd118ae")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	event.set_save_control_bits(16, 1)
	event.fade_in_screen(15)
end

--- Helper function.
local function helper_12944()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e215/e215_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e215/e215_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e215/e215_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e215/e215_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_message_file(0, 5, "event/e200/e215/e215_1.txt")
end

--- Helper function.
local function helper_21e00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1266c()
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
end

--- Helper function.
local function helper_135a0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(215, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var13 = event.load_sound_effect_file_2(2800) or var13
		helper_12944()
		event.enable_drama_skip()
		event.stop_music(0)
		event.set_object_handle_sound_bank(0, var13)
		event.set_object_handle_sound_bank(1, var13)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2810.55, 19.2, 1417.95)
		event.set_camera_sequence_look_at(2838.92, 19.55, 1472.76)
		event.set_object_sequence_position(0, 3016.47, 0.01, 1619.33)
		event.set_object_sequence_rotation(0, 0.0, -2.17, 0.0)
		event.set_object_sequence_position(1, 3035.62, 0.01, 1589.73)
		event.set_object_sequence_rotation(1, 0.0, -2.28, 0.0)
		event.move_object_sequence(0, 2903.57, 0.01, 1552.25, 130)
		event.rotate_object_sequence(0, 0.0, -2.05, 0.0, 90)
		event.move_object_sequence(1, 2918.09, 0.01, 1527.87, 130)
		event.rotate_object_sequence(1, 0.0, -2.04, 0.0, 90)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "きょろきょろ歩き", 4, -1.0, 1)
		var9 = vm.f32(0.46)
		var10 = vm.f32(0.0066666664)
		var12 = 0
		while var12 < 121 do
			do
				local out1, out2, out3 = event.get_character_position(global0)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			do
				local out1, out2, out3 = event.get_character_position(global1)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var0, var1, var2, var6, var7, var8)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = event.scale_vector(var0, var1, var2, 0.5)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = event.add_vectors(var6, var7, var8, var0, var1, var2)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			var7 = vm.f32(var7 + 20.0)
			event.set_camera_sequence_look_at(var6, var7, var8)
			do
				local out1, out2, out3 = event.copy_vector(var6, var7, var8)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(var9)))
			vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(var9)))
			vector_y = vm.f32(vector_y + vm.f32(29.79))
			event.set_camera_sequence_position(vector_x, vector_y, vector_z)
			var9 = vm.f32(var9 + var10)
			if var9 > vm.f32(3.1415927) then
				var9 = vm.f32(var9 - vm.f32(6.2831855))
			end
			if var9 <= vm.f32(-3.1415927) then
				var9 = vm.f32(var9 + vm.f32(6.2831855))
			end
			var12 = var12 + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		wait_frames(10)
		event.set_camera_sequence_position(2803.91, 11.38, 1411.86)
		event.set_camera_sequence_look_at(2831.84, 19.55, 1460.49)
		event.set_object_sequence_position(0, 2831.19, 0.01, 1465.72)
		event.set_object_sequence_rotation(0, 0.0, -2.05, 0.0)
		event.set_object_sequence_position(1, 2837.63, 0.01, 1446.26)
		event.set_object_sequence_rotation(1, 0.0, -1.92, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 4
		helper_4116e6bb(2150010)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var13, 4)
		event.set_object_sequence_motion(0, "待って", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "待ってL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 5
		helper_4116e6bb(2150020)
		event.reset_mouth_texture_animations()
		at = 6
		wait_objects(0)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		at = 7
		wait_frames(6)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 8
		helper_4116e6bb(2150030)
		event.reset_mouth_texture_animations()
		at = 9
		wait_objects(1)
		event.set_object_sequence_motion(0, "待って戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 10
		wait_frames(10)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "左向く戻り", 2)
		event.wait_object_sequence_motion_end(1)
		at = 11
		wait_objects(1)
		event.play_sound_effect(var13, 5)
		event.queue_object_sequence_next_motion(1, "身を乗り出す", 2)
		event.queue_object_sequence_next_motion(1, "身を乗り出すＬ", 0)
		at = 12
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 13
		helper_4116e6bb(2150040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "身を乗り出す戻り", 6)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 14
		helper_4116e6bb(2150050)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(0, "右向くうなづき", 2)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		at = 15
		wait_frames(16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(2150060)
		event.reset_mouth_texture_animations()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21e00000()
			var9 = vm.f32(0.46)
			var10 = vm.f32(0.0066666664)
			var12 = 0
			var7 = vm.f32(var7 + 20.0)
			vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(var9)))
			vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(var9)))
			vector_y = vm.f32(vector_y + vm.f32(29.79))
			var9 = vm.f32(var9 + var10)
			local _ = var9 > vm.f32(3.1415927)
			var9 = vm.f32(var9 - vm.f32(6.2831855))
			local _ = var9 <= vm.f32(-3.1415927)
			var9 = vm.f32(var9 + vm.f32(6.2831855))
			local _ = var12 < 121
			var12 = var12 + 1
		end
		if at <= 2 then
			wait_frames_skipping(10)
		end
		if at <= 3 then
			helper_8cd371d7(2150010)
		end
		if at <= 4 then
			helper_8cd371d7(2150020)
		end
		if at <= 5 then
			helper_238b5abc(0)
		end
		if at <= 6 then
			wait_frames_skipping(6)
		end
		if at <= 7 then
			helper_8cd371d7(2150030)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			wait_frames_skipping(10)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_8cd371d7(2150040)
		end
		if at <= 13 then
			helper_8cd371d7(2150050)
		end
		if at <= 14 then
			wait_frames_skipping(16)
		end
		if at <= 15 then
			helper_8cd371d7(2150060)
		end
		return true
	end)
	at = 17
	vm.entry(17)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 18
	wait_frames(45)
	helper_1266c()
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

--- Event 501, which map data, a script or the engine runs by number.
local function event_501()
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		at = 2
		helper_135a0()
		event.set_save_counter(3, 1)
		helper_bb23ef44()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_135a0()
				return vm.continue_with(function()
					event.set_save_counter(3, 1)
					helper_bb23ef44()
					return
				end)
			end
			helper_fc5948a6()
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_19654()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e240/e240_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e240/e240_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e240/e240_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e240/e240_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e240/e240_madan.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e200/e240/e240_sao.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(3, 35)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/e200/e240/e240_wink.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.set_scene_character_type(38, 4)
	event.load_character(5, "event/e200/e240/mizubasira.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e240/hamon.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e240/e240_line.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(5, 41)
	event.clear_object_sequence(4, 41)
	event.set_object_sequence_object(4, 5)
	event.load_character(5, "event/e200/e240/e240_line1.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.load_message_file(0, 5, "event/e200/e240/e240_1.txt")
end

--- Helper function.
local function helper_22c00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_19280()
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
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
end

--- Helper function.
local function helper_1a8cc()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(240, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(193)
		event.play_music(1)
		event.load_map_sounds(2812)
		var4 = event.load_sound_effect_file_2(2812) or var4
		event.fade_out_screen(30)
		at = 2
		wait_frames(45)
		helper_19654()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 35)
		event.set_character_active(0, 34)
		event.set_character_active(1, 41)
		event.set_camera_position(-111.63, 33.95, -443.55)
		event.set_camera_look_at(-297.56, 30.0, -373.68)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(0, -303.57, 0.0, -356.14)
		event.set_object_sequence_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(1, -327.35, 0.0, -377.28)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(2, -127.39, 0.0, -701.37)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.set_character_rotation(41, 0.0, 0.0, 1.57)
		event.attach_character_to_frame(35, "ito", 41)
		at = 3
		vm.wait(3)
		event.attach_character_to_frame(global0, "gun_hand", 35)
		event.play_sound_effect(var4, 4)
		event.play_sound_effect(var4, 6)
		event.fade_in_screen(30)
		event.set_character_motion(41, "糸切れる", 5, -1, 1)
		event.set_object_sequence_motion(0, "竿を引く", 4, -1.0, 1)
		event.set_object_sequence_motion(3, "竿を引く", 4)
		event.set_object_sequence_motion(1, "釣り観戦", 4, -1.0, 1)
		at = 4
		wait_frames(15)
		event.move_object_sequence(0, -300.7, 0.0, -364.52, 90)
		event.play_sound_effect(var4, 5)
		at = 5
		wait_objects(0)
		at = 6
		wait_frames(30)
		event.set_camera_sequence_position(-331.46, 23.14, -254.41)
		event.set_camera_sequence_look_at(-295.08, 10.97, -376.82)
		event.move_object_sequence(0, -297.56, 0.0, -373.68, 90)
		event.play_sound_effect(var4, 8)
		at = 7
		wait_objects(0)
		at = 8
		wait_frames(60)
		event.stop_sound_effect(var4, 4)
		event.stop_sound_effect(var4, 6)
		event.play_sound_effect(var4, 7)
		event.set_character_motion(41, "糸切れる", 2, -1, 1)
		event.set_character_active(1, 42)
		event.set_character_position(42, -184.19, -4.56, -446.98)
		event.set_character_rotation(42, 0.0, 2.57, 0.0)
		event.set_character_motion(42, "糸切れる", 2, -1, 1)
		event.set_object_sequence_motion(0, "糸切れる", 2)
		event.set_object_sequence_motion(3, "糸切れる", 2)
		event.set_object_sequence_motion(1, "ユリス追う（顔）", 2)
		at = 9
		wait_frames(15)
		event.play_sound_effect(var4, 5)
		at = 10
		wait_frames(30)
		event.set_character_active(0, 42)
		event.set_character_active(0, 41)
		event.set_character_active(0, 35)
		event.delete_character(35)
		event.delete_character(41)
		event.delete_character(42)
		event.set_object_sequence_position(0, -284.58, 0.0, -370.78)
		event.set_object_sequence_rotation(0, 0.0, 2.93, 0.0)
		event.set_object_sequence_position(1, -370.53, 0.0, -348.56)
		event.set_object_sequence_rotation(1, 0.0, 0.89, 0.0)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(1, -334.31, 0.0, -340.4, 60)
		event.set_camera_sequence_position(-390.3, 27.35, -176.88)
		event.set_camera_sequence_look_at(-290.9, 59.06, -387.86)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 90)
		event.set_character_active(1, 40)
		event.set_character_position(40, -127.39, -18.0, -701.37)
		event.set_character_rotation(40, 0.0, -1.68, 0.0)
		at = 11
		wait_frames(30)
		at = 12
		wait_frames(30)
		event.set_character_active(1, 34)
		event.set_object_sequence_motion(2, "浮かび笑", 6)
		event.queue_object_sequence_next_motion(2, "待機")
		event.set_character_active(1, 39)
		event.set_character_position(39, -241.56, -9.72, -479.54)
		event.set_character_rotation(39, 0.0, 0.0, 0.0)
		event.set_character_motion(39, "水柱", 2, -1, 1)
		at = 13
		wait_objects(1)
		event.play_sound_effect(var4, 9)
		event.rotate_object_sequence(1, 0.0, 2.45, 0.0, 10)
		at = 14
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(0, "マーダン出現", 2)
		event.set_object_sequence_motion(3, "マーダン出現", 2)
		event.queue_object_sequence_next_motion(0, "マーダン出現L")
		event.queue_object_sequence_next_motion(3, "マーダン出現L")
		at = 15
		wait_frames(30)
		at = 16
		wait_frames(15)
		event.fade_out_music(60)
		at = 17
		wait_frames(60)
		event.stop_music(1)
		at = 18
		vm.wait(18)
		at = 19
		vm.wait(19)
		at = 20
		vm.wait(20)
		at = 21
		vm.wait(21)
		event.load_music(193)
		event.play_music(0)
		event.stop_sound_effect(var4, 9)
		event.play_sound_effect(var4, 10)
		at = 22
		wait_frames(60)
		event.set_character_active(0, 39)
		event.delete_character(39)
		event.set_object_sequence_motion(2, "あせる")
		at = 23
		wait_frames(10)
		at = 24
		helper_1584c528(2400010, -1)
		at = 25
		helper_1584c528(2400015, -1)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		at = 26
		wait_frames(30)
		event.set_object_sequence_motion(2, "モニカを見る", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見るL")
		at = 27
		wait_frames(120)
		event.set_camera_sequence_position(-312.91, 53.63, -372.03)
		event.set_camera_sequence_look_at(-334.31, 16.44, -340.4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 28
		helper_4116e6bb(2400020)
		event.reset_mouth_texture_animations()
		at = 29
		wait_objects(1)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		helper_4116e6bb(2400025)
		event.reset_mouth_texture_animations()
		at = 31
		wait_objects(1)
		at = 32
		wait_frames(15)
		event.set_camera_sequence_position(-390.3, 27.35, -176.88)
		event.set_camera_sequence_look_at(-290.9, 59.06, -387.86)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_position(0, -305.91, 0.0, -329.68)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(2, "目ほそめ", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめL", 4)
		at = 33
		wait_objects(2)
		event.set_object_sequence_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 34
		helper_1584c528(2400030, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		at = 35
		wait_frames(30)
		event.set_object_sequence_motion(2, "目とじ", 2)
		event.queue_object_sequence_next_motion(2, "目とじL", 4)
		at = 36
		wait_objects(2)
		event.set_object_sequence_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		at = 37
		helper_1584c528(2400035, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_motion(2, "目とじ戻り", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見る", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見るL")
		event.set_object_sequence_motion(1, "上向く", 2)
		event.queue_object_sequence_next_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		at = 38
		helper_4116e6bb(2400040)
		at = 39
		wait_objects(1)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		at = 40
		helper_4116e6bb(2400045)
		at = 41
		wait_objects(1)
		event.set_object_sequence_motion(2, "会話")
		at = 42
		helper_1584c528(2400050, -1)
		event.set_object_sequence_motion(2, "目ほそめ", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめL", 4)
		at = 43
		wait_objects(2)
		event.set_object_sequence_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 44
		helper_1584c528(2400055, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(-292.54, 67.5, -392.04)
		event.set_camera_sequence_look_at(-319.35, 18.11, -332.98)
		event.set_object_sequence_motion(1, "上向きから頭抱え", 2)
		event.queue_object_sequence_next_motion(1, "頭かかえＬ", 4)
		event.set_object_sequence_motion(0, "左向く", 2)
		event.queue_object_sequence_next_motion(0, "左向くL")
		at = 45
		helper_4116e6bb(2400060)
		at = 46
		wait_objects(1)
		event.set_object_sequence_motion(0, "左向く戻り", 2)
		event.queue_object_sequence_next_motion(0, "上向く", 2)
		event.queue_object_sequence_next_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 47
		helper_4116e6bb(2400070)
		event.reset_mouth_texture_animations()
		at = 48
		wait_objects(0)
		event.set_camera_sequence_position(-348.01, 19.24, -271.83)
		event.set_camera_sequence_look_at(-309.88, 30.88, -357.76)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "ユリスを見る", 6)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL", 4)
		at = 49
		wait_objects(2)
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 50
		helper_1584c528(2400080, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ぶちゅー", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		event.wait_object_sequence_motion_end(2)
		at = 51
		helper_1584c528(2400085, -1)
		event.set_character_active(0, 38)
		at = 52
		wait_objects(2)
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 53
		helper_1584c528(2400090, -1)
		at = 54
		helper_1584c528(2400095, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		at = 55
		wait_objects(2)
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 56
		helper_1584c528(2400100, -1)
		event.set_character_active(0, 38)
		at = 57
		helper_1584c528(2400105, -1)
		at = 58
		helper_4116e6bb(2400110)
		at = 59
		helper_1584c528(2400115, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		at = 60
		wait_frames(60)
		event.set_character_active(0, 38)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 61
		helper_4116e6bb(2400120)
		at = 62
		wait_objects(0)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 63
		helper_4116e6bb(2400125)
		at = 64
		wait_objects(0)
		event.set_object_sequence_motion(0, "上向くL")
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 65
		helper_4116e6bb(2400130)
		event.set_object_sequence_motion(1, "上向きから驚き", 2)
		event.queue_object_sequence_next_motion(1, "驚きＬ")
		event.queue_object_sequence_next_motion(2, "モニカを見る", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見るL")
		event.play_sound_effect(var4, 11)
		at = 66
		helper_4116e6bb(2400140)
		at = 67
		wait_objects(1)
		at = 68
		wait_frames(30)
		event.set_camera_sequence_position(-756.17, 221.27, 17.93)
		event.set_camera_sequence_look_at(-308.68, 56.91, -420.42)
		event.stop_sound_effect(var4, 10)
		at = 69
		wait_frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 70
		helper_1584c528(2400150, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ユリスを見るL")
		event.fade_out_music(60)
		at = 71
		wait_frames(60)
		event.fade_out_screen(30)
		at = 72
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(45)
		end
		if at <= 2 then
			helper_22c00000()
		end
		if at <= 3 then
			wait_frames_skipping(15)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			helper_238b5abc(0)
		end
		if at <= 7 then
			wait_frames_skipping(60)
		end
		if at <= 8 then
			wait_frames_skipping(15)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			wait_frames_skipping(30)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_238b5abc(1)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			wait_frames_skipping(15)
		end
		if at <= 16 then
			wait_frames_skipping(60)
		end
		if at <= 21 then
			wait_frames_skipping(60)
		end
		if at <= 22 then
			wait_frames_skipping(10)
		end
		if at <= 23 then
			helper_52aadc70(2400010, -1)
		end
		if at <= 24 then
			helper_52aadc70(2400015, -1)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			wait_frames_skipping(120)
		end
		if at <= 27 then
			helper_8cd371d7(2400020)
		end
		if at <= 28 then
			helper_238b5abc(1)
		end
		if at <= 29 then
			helper_8cd371d7(2400025)
		end
		if at <= 30 then
			helper_238b5abc(1)
		end
		if at <= 31 then
			wait_frames_skipping(15)
		end
		if at <= 32 then
			helper_238b5abc(2)
		end
		if at <= 33 then
			helper_52aadc70(2400030, -1)
		end
		if at <= 34 then
			wait_frames_skipping(30)
		end
		if at <= 35 then
			helper_238b5abc(2)
		end
		if at <= 36 then
			helper_52aadc70(2400035, -1)
		end
		if at <= 37 then
			helper_8cd371d7(2400040)
		end
		if at <= 38 then
			helper_238b5abc(1)
		end
		if at <= 39 then
			helper_8cd371d7(2400045)
		end
		if at <= 40 then
			helper_238b5abc(1)
		end
		if at <= 41 then
			helper_52aadc70(2400050, -1)
		end
		if at <= 42 then
			helper_238b5abc(2)
		end
		if at <= 43 then
			helper_52aadc70(2400055, -1)
		end
		if at <= 44 then
			helper_8cd371d7(2400060)
		end
		if at <= 45 then
			helper_238b5abc(1)
		end
		if at <= 46 then
			helper_8cd371d7(2400070)
		end
		if at <= 47 then
			helper_238b5abc(0)
		end
		if at <= 48 then
			helper_238b5abc(2)
		end
		if at <= 49 then
			helper_52aadc70(2400080, -1)
		end
		if at <= 50 then
			helper_52aadc70(2400085, -1)
		end
		if at <= 51 then
			helper_238b5abc(2)
		end
		if at <= 52 then
			helper_52aadc70(2400090, -1)
		end
		if at <= 53 then
			helper_52aadc70(2400095, -1)
		end
		if at <= 54 then
			helper_238b5abc(2)
		end
		if at <= 55 then
			helper_52aadc70(2400100, -1)
		end
		if at <= 56 then
			helper_52aadc70(2400105, -1)
		end
		if at <= 57 then
			helper_8cd371d7(2400110)
		end
		if at <= 58 then
			helper_52aadc70(2400115, -1)
		end
		if at <= 59 then
			wait_frames_skipping(60)
		end
		if at <= 60 then
			helper_8cd371d7(2400120)
		end
		if at <= 61 then
			helper_238b5abc(0)
		end
		if at <= 62 then
			helper_8cd371d7(2400125)
		end
		if at <= 63 then
			helper_238b5abc(0)
		end
		if at <= 64 then
			helper_8cd371d7(2400130)
		end
		if at <= 65 then
			helper_8cd371d7(2400140)
		end
		if at <= 66 then
			helper_238b5abc(1)
		end
		if at <= 67 then
			wait_frames_skipping(30)
		end
		if at <= 68 then
			wait_frames_skipping(15)
		end
		if at <= 69 then
			helper_52aadc70(2400150, -1)
		end
		if at <= 70 then
			wait_frames_skipping(60)
		end
		if at <= 71 then
			wait_frames_skipping(35)
		end
		return true
	end)
	at = 73
	vm.entry(73)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var4, 4)
	event.stop_sound_effect(var4, 6)
	event.stop_sound_effect(var4, 10)
	event.stop_music(0)
	helper_19280()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_158f0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e220/e220_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e220/e220_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e220/e220_noam.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, 34, "wine")
	event.load_character(5, "item/f_rod.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(3, 35)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(5, 36)
	event.clear_object_sequence(4, 36)
	event.set_object_sequence_object(4, 5)
	event.load_message_file(0, 5, "event/e200/e220/e220_1.txt")
end

--- Helper function.
local function helper_155ac()
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
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
end

--- Helper function.
local function helper_22500000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_22900000() end

--- Helper function.
local function helper_16814()
	local item: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local flag_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var5 = event.load_sound_effect_file_2(2803) or var5
		var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var4
		event.fade_out_screen(30)
		at = 1
		wait_frames(45)
		helper_158f0()
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_character_active(0, 9)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(2187.89, 60.39, 925.42)
		event.set_camera_sequence_look_at(2234.31, 29.74, 1032.94)
		event.set_object_sequence_position(0, 2298.04, 0.0, 1110.65)
		event.set_object_sequence_rotation(0, 0.0, -2.41, 0.0)
		event.set_object_sequence_position(1, 2311.91, 0.0, 1092.4)
		event.set_object_sequence_rotation(1, 0.0, -2.28, 0.0)
		event.set_object_sequence_position(2, 2199.07, 29.83, 981.55)
		event.set_object_sequence_rotation(2, 0.0, 2.68, 0.0)
		var2 = event.is_object_handle_frame_visible(2, "wine") or var2
		event.set_object_handle_frame_visible(2, "wine", 0)
		event.set_object_handle_sound_bank(2, var5)
		event.fade_in_screen(30)
		flag = event.get_save_flag(220) or flag
		if flag == 0 then
			event.set_save_flag(220, 1)
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "釣り", 4)
			at = 2
			wait_frames(15)
			event.set_object_sequence_motion(2, "釣り会話", 0)
			event.delay_object_sequence_motion_track(2, 195)
			event.set_object_sequence_motion(2, "釣り", 0)
			at = 3
			helper_4116e6bb(2200010)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_motion(2, "釣り", 0)
			event.set_object_sequence_motion(0, "会話", 2)
			event.queue_object_sequence_next_motion(0, "立ち", 0)
			event.set_mouth_texture_animations(0, "通常口パク")
			at = 4
			helper_4116e6bb(2200020)
			event.reset_mouth_texture_animations()
			at = 5
			wait_objects(0)
			event.set_object_sequence_motion(2, "釣り会話", 0)
			event.delay_object_sequence_motion_track(2, 270)
			event.set_object_sequence_motion(2, "釣り", 0)
			at = 6
			helper_4116e6bb(2200030)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_motion(2, "釣り", 0)
			event.set_object_sequence_motion(2, "釣り会話", 0)
			event.delay_object_sequence_motion_track(2, 180)
			event.set_object_sequence_motion(2, "釣り", 0)
			at = 7
			helper_4116e6bb(2200040)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_motion(2, "釣り", 0)
		else
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "釣り", 4)
		end
		at = 8
		wait_frames(15)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "右向く", 6)
		event.queue_object_sequence_next_motion(2, "右向くL", 0)
		at = 9
		wait_frames(10)
		at = 10
		helper_4116e6bb(2200050)
		at = 11
		helper_4116e6bb(2200055)
		event.set_object_sequence_motion(0, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "左向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		at = 12
		wait_frames(16)
		event.open_use_item_menu(370)
		at = 13
		vm.wait(13)
		item = vmhost.used_item() or item
		if item == 370 then
			event.set_save_flag(28, 1)
			event.set_object_handle_frame_draw_flag(2, "wine", var2)
			event.set_object_handle_frame_visible(2, "wine", 1)
			event.set_camera_sequence_position(2256.03, 46.87, 1157.6)
			event.set_camera_sequence_look_at(2209.88, 21.76, 1049.74)
			event.set_object_sequence_position(0, 2212.29, 0.0, 1088.81)
			event.set_object_sequence_rotation(0, 0.0, 3.03, 0.0)
			event.set_object_sequence_position(1, 2241.69, 0.0, 1085.4)
			event.set_object_sequence_rotation(1, 0.0, -2.64, 0.0)
			event.set_object_sequence_position(2, 2211.11, -1.43, 1044.24)
			event.set_object_sequence_rotation(2, 0.0, 0.16, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "とびおり", 6)
			event.set_mouth_texture_animations(0, "通常口パク")
			at = 14
			helper_4116e6bb(2200080)
			event.reset_mouth_texture_animations()
			event.set_mouth_texture_animations(0, "通常口パク")
			at = 15
			helper_4116e6bb(2200085)
			event.reset_mouth_texture_animations()
			event.play_sound_effect(var5, 5)
			event.set_object_sequence_motion(2, "竿やる", 2)
			event.queue_object_sequence_next_motion(2, "竿やるL", 0)
			at = 16
			helper_4116e6bb(2200090)
			event.set_object_handle_frame_visible(2, "rod", 0)
			event.set_object_handle_frame_visible(2, "obj3", 0)
			event.set_object_handle_frame_visible(2, "obj4", 0)
			event.set_character_active(0, global1)
			event.set_character_active(0, 34)
			event.set_character_active(1, 35)
			event.set_character_active(1, 36)
			event.set_camera_sequence_position(2216.13, 50.5, 1037.69)
			event.set_camera_sequence_look_at(2211.23, 28.7, 1078.48)
			event.set_object_sequence_position(4, 2209.46, 34.32, 1071.72)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
			event.play_sound_effect(var5, 6)
			event.play_sound_effect(var4, 0)
			event.attach_character_to_frame(global0, "gun_hand", 35)
			event.set_object_sequence_motion(0, "釣り竿ゲット", 4, -1.0, 1)
			event.set_object_sequence_motion(4, "発動", 6)
			at = 17
			helper_f38eabca(302, 1)
			at = 18
			helper_f38eabca(313, 1)
			event.set_character_active(1, global1)
			event.set_character_active(1, 34)
			event.set_character_active(0, 35)
			event.set_character_active(0, 36)
			event.set_camera_sequence_position(2256.03, 46.87, 1157.6)
			event.set_camera_sequence_look_at(2209.88, 21.76, 1049.74)
			event.set_object_handle_frame_visible(2, "chn64", 0)
			event.set_object_sequence_position(0, 2212.29, 0.0, 1088.81)
			event.set_object_sequence_rotation(0, 0.0, 3.03, 0.0)
			event.set_object_sequence_position(1, 2241.69, 0.0, 1085.4)
			event.set_object_sequence_rotation(1, 0.0, -2.64, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "立ち", 4)
			event.set_object_sequence_motion(2, "会話", 6)
			event.queue_object_sequence_next_motion(2, "立ち", 0)
			at = 19
			helper_4116e6bb(2200095)
			event.set_message_window_mode(0, 8)
			event.open_message_window_2(
				0,
				"[(!)]To fish, first equip a Fishing Rod.\n   Don't forget to attach bait (Mimi) in\n   the Item Menu, or you can't fish."
			)
			at = 20
			show_message(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"[(!)]Once this is done, stand at the edge of\n   the water and press (O) to begin fishing."
			)
			at = 21
			show_message(0, -1, 8, 0, 0)
			event.set_message_window_mode(0, 7)
		else
			event.set_object_sequence_motion(0, "右向く戻り", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "立ち", 4)
			event.set_object_sequence_motion(1, "左向く戻り", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(1, "立ち", 4)
			at = 22
			wait_frames(16)
			if item <= 0 then
				event.set_object_sequence_motion(2, "そっぽ向く", 2)
				event.queue_object_sequence_next_motion(2, "そっぽ向くL", 0)
				at = 23
				wait_frames(5)
				at = 24
				helper_4116e6bb(2200060)
				at = 25
				wait_objects(2)
				event.set_camera_sequence_position(2342.69, 17.58, 1135.11)
				event.set_camera_sequence_look_at(2285.51, 29.74, 1075.97)
			else
				event.set_object_sequence_motion(2, "首を振る", 6)
				event.queue_object_sequence_next_motion(2, "釣り", 0)
				at = 26
				wait_frames(15)
				at = 27
				helper_4116e6bb(2200070)
				at = 28
				wait_objects(2)
				event.set_camera_sequence_position(2342.69, 17.58, 1135.11)
				event.set_camera_sequence_look_at(2285.51, 29.74, 1075.97)
			end
		end
		event.fade_out_screen(30)
		at = 29
		wait_frames(45)
		helper_155ac()
		event.set_character_active(1, 9)
		flag_2 = event.get_save_flag(28) or flag_2
		if flag_2 ~= 0 then
			event.add_inventory_item(302, 1)
			event.add_inventory_item(313, 1)
			at = 30
			helper_d529ed92()
			event.remove_item(370, 1)
			event.attach_object_handle_to_character(0, 9)
			event.set_object_handle_frame_draw_flag(0, "wine", 1)
		end
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		return
	end, function(received: { any })
		if at <= 30 then
			if at <= 1 then
				helper_22500000()
				wait_frames_skipping(15)
			end
			if at <= 2 then
				helper_8cd371d7(2200010)
			end
			if at <= 3 then
				helper_8cd371d7(2200020)
			end
			if at <= 4 then
				helper_238b5abc(0)
			end
			if at <= 5 then
				helper_8cd371d7(2200030)
			end
			if at <= 6 then
				helper_8cd371d7(2200040)
			end
			if at <= 7 then
				wait_frames_skipping(15)
			end
			if at <= 8 then
				wait_frames_skipping(10)
			end
			if at <= 9 then
				helper_8cd371d7(2200050)
			end
			if at <= 10 then
				helper_8cd371d7(2200055)
			end
			if at <= 11 then
				wait_frames_skipping(16)
			end
			if at <= 13 then
				helper_8cd371d7(2200080)
			end
			if at <= 14 then
				helper_8cd371d7(2200085)
			end
			if at <= 15 then
				helper_8cd371d7(2200090)
			end
			if at <= 16 then
				helper_5c12934f(302, 1)
			end
			if at <= 17 then
				helper_5c12934f(313, 1)
			end
			if at <= 18 then
				helper_8cd371d7(2200095)
			end
			if at <= 19 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 20 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 21 then
				wait_frames_skipping(16)
			end
			if at <= 22 then
				wait_frames_skipping(5)
			end
			if at <= 23 then
				helper_8cd371d7(2200060)
			end
			if at <= 24 then
				helper_238b5abc(2)
			end
			if at <= 25 then
				wait_frames_skipping(15)
			end
			if at <= 26 then
				helper_8cd371d7(2200070)
			end
			if at <= 27 then
				helper_238b5abc(2)
			end
			if at <= 28 then
				wait_frames_skipping(45)
			end
			if at <= 29 then
				helper_22900000()
				helper_e52544df()
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_1f3c4()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
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
	event.load_character(5, "event/e200/e245/e245_madan.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(4, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "event/e200/e245/e245_ma_kaeru.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(6, 39)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 6)
	event.set_scene_character_type(39, 4)
	event.load_character(5, "event/e200/e245/e245_ma_hamon.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e245/e245_magicwink.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e245/e245_pink.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.load_message_file(0, 5, "event/e200/e245/e245_1.txt")
end

--- Helper function.
local function helper_23100000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1f038()
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
	event.delete_character(34)
	event.delete_character(38)
	event.delete_character(41)
	event.delete_character(39)
	event.delete_character(40)
end

--- Helper function.
local function helper_202b0()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(245, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(193)
		event.play_music(0)
		var4 = event.load_sound_effect_file_2(2815) or var4
		event.fade_out_screen(30)
		at = 3
		wait_frames(45)
		helper_1f3c4()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-390.3, 27.35, -176.88)
		event.set_camera_sequence_look_at(-290.9, 59.06, -387.86)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_character_active(1, 40)
		event.set_character_position(40, -127.39, -18.0, -701.37)
		event.set_character_rotation(40, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(0, -289.3, 0.0, -369.79)
		event.set_object_sequence_rotation(0, 0.0, 2.93, 0.0)
		event.set_object_sequence_position(1, -320.6, 0.0, -374.1)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(2, -127.39, 0.0, -701.37)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(var4, 4)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 2, -1.0, 1)
		event.set_object_sequence_motion(2, "笑う", 2)
		event.queue_object_sequence_next_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 4
		wait_frames(15)
		at = 5
		helper_1584c528(2450010, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 4)
		event.set_object_sequence_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 6
		helper_1584c528(2450015, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 4)
		at = 7
		wait_objects(2)
		event.set_object_sequence_motion(2, "笑う", 4)
		at = 8
		helper_1584c528(2450020, -1)
		event.set_object_sequence_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL", 4)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 9
		helper_4116e6bb(2450030)
		at = 10
		wait_objects(0)
		event.set_object_sequence_motion(0, "上向くL")
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 11
		helper_1584c528(2450040, -1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		event.queue_object_sequence_next_motion(2, "待機")
		at = 12
		wait_frames(30)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "魔法解く", 2, -1, 1)
		event.set_character_active(1, 41)
		event.set_character_position(41, -127.39, 0.0, -701.37)
		event.set_character_rotation(41, 0.0, -1.68, 0.0)
		event.set_character_motion(41, "桃色世界", 2, -1, 1)
		event.play_sound_effect(var4, 5)
		at = 13
		wait_frames(150)
		event.set_character_visible(41, 0, 1, 0.025)
		at = 14
		wait_frames(40)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 15
		helper_4116e6bb(2450050)
		at = 16
		wait_objects(0)
		event.set_object_sequence_motion(0, "上向くL")
		event.set_object_sequence_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見会話")
		at = 17
		wait_objects(2)
		at = 18
		helper_1584c528(2450060, -1)
		event.set_object_sequence_position(4, -127.39, 0.0, -701.37)
		event.set_object_sequence_rotation(4, 0.0, -1.68, 0.0)
		event.set_character_scale(39, 2.0, 2.0, 2.0)
		event.delay_object_sequence_motion_track(2, 70)
		event.set_object_sequence_motion(2, "帰る", 2)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(4, "帰る", 5)
		event.delay_object_sequence_motion_track(4, 70)
		event.set_object_sequence_motion(4, "帰る", 6)
		event.delay_object_sequence_sound_track(2, 70)
		event.play_object_sequence_sound(2, var4, 6)
		at = 19
		helper_1584c528(2450070, -1)
		at = 20
		wait_objects(2)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -324.44, 0.0, -385.55)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_camera_sequence_position(-247.47, 25.33, -442.62)
		event.set_camera_sequence_look_at(-302.69, 22.64, -384.86)
		event.set_object_sequence_motion(0, "左向く", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		helper_4116e6bb(2450080)
		event.reset_mouth_texture_animations()
		at = 22
		wait_objects(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 23
		helper_4116e6bb(2450090)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 24
		helper_4116e6bb(2450100)
		event.reset_mouth_texture_animations()
		at = 25
		wait_objects(1)
		event.fade_out_music(60)
		at = 26
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			wait_frames_skipping(45)
		end
		if at <= 3 then
			helper_23100000()
			wait_frames_skipping(15)
		end
		if at <= 4 then
			helper_52aadc70(2450010, -1)
		end
		if at <= 5 then
			helper_52aadc70(2450015, -1)
		end
		if at <= 6 then
			helper_238b5abc(2)
		end
		if at <= 7 then
			helper_52aadc70(2450020, -1)
		end
		if at <= 8 then
			helper_8cd371d7(2450030)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_52aadc70(2450040, -1)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			wait_frames_skipping(150)
		end
		if at <= 13 then
			wait_frames_skipping(40)
		end
		if at <= 14 then
			helper_8cd371d7(2450050)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_238b5abc(2)
		end
		if at <= 17 then
			helper_52aadc70(2450060, -1)
		end
		if at <= 18 then
			helper_52aadc70(2450070, -1)
		end
		if at <= 19 then
			helper_238b5abc(2)
		end
		if at <= 20 then
			helper_8cd371d7(2450080)
		end
		if at <= 21 then
			helper_238b5abc(0)
		end
		if at <= 22 then
			helper_8cd371d7(2450090)
		end
		if at <= 23 then
			helper_8cd371d7(2450100)
		end
		if at <= 24 then
			helper_238b5abc(1)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 27
	vm.entry(27)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 28
	wait_frames(35)
	event.stop_music(0)
	event.stop_sound_effect(var4, 4)
	helper_1f038()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 506, which map data, a script or the engine runs by number.
local function event_506()
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		event.fade_out_screen(15)
		at = 2
		wait_frames(15)
		event.delete_character(14)
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 0)
		event.attach_object_handle_to_map_part_2(0, "p08_s0501")
		event.set_object_handle_visible(0, 0)
		at = 3
		helper_202b0()
		event.set_save_counter(3, 6)
		helper_bb23ef44()
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				wait_frames_skipping(15)
			end
			if at <= 2 then
				at = 3
				helper_202b0()
				return vm.continue_with(function()
					event.set_save_counter(3, 6)
					helper_bb23ef44()
					return
				end)
			end
			helper_fc5948a6()
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local var0: s32 = 0
	local old_map_no: s32 = 0
	local flag: s32 = 0
	local mc_load: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.initialize_event()
		var0 = event.get_dungeon_floor_info(1, 6, 7) or var0
		event.set_dungeon_floor_info(1, 6, 7, vm.i32(var0 + 1))
		print("s05StartEvent kita------------------------------------------\n")
		event_99()
		helper_683bd2fc()
		helper_bb23ef44()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, 2808.3, 0.0, 1609.9)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			event.get_map_type(old_map_no)
			flag = event.get_save_flag(215) or flag
			if flag ~= 0 then
				at = 1
				helper_c9349531(vm.f32(3205.97), 0.0, vm.f32(1599.83), 0.0)
			end
			event.fade_in_screen(15)
			flag = event.get_save_flag(209) or flag
			if flag == 1 then
				flag = event.get_save_flag(215) or flag
				if flag == 0 then
					at = 2
					event_501()
					event.fade_in_screen(15)
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				event_501()
				return vm.continue_with(function()
					event.fade_in_screen(15)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_1a8cc()
	event.load_event_script("s05/s05b_1.stb", 504)
end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.set_save_counter(3, 0)
	event.set_save_flag(215, 0)
	event.set_save_flag(220, 0)
	event.set_save_flag(230, 0)
	event.set_save_flag(235, 0)
	event.remove_item(302, 1)
	helper_bb23ef44()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

script.event_501 = event_501

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local flag: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		at = 1
		helper_16814()
		argc = event.get_item_count(302) or argc
		flag = event.get_save_flag(230) or flag
		if argc ~= 0 and flag == 1 then
			event.set_save_counter(3, 3)
			helper_bb23ef44()
		end
		if argc > 0 and flag == 0 then
			event.set_save_counter(3, 2)
			helper_bb23ef44()
		end
		helper_bb23ef44()
		return
	end, function(received: { any })
		if at <= 1 then
			helper_fc5948a6()
			helper_fc5948a6()
			helper_fc5948a6()
			return 0
		end
		return nil
	end)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 501)
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 502)
end

--- Event 505, which map data, a script or the engine runs by number.
function script.event_505()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_1a8cc()
		event.set_save_counter(3, 5)
		helper_683bd2fc()
		helper_bb23ef44()
		return
	end, function(received: { any })
		if at <= 1 then
			helper_deba899b()
			helper_fc5948a6()
			return 0
		end
		return nil
	end)
end

script.event_506 = event_506

--- Event 507, which map data, a script or the engine runs by number.
function script.event_507()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 503)
end

--- Event 508, which map data, a script or the engine runs by number.
function script.event_508()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 504)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		print("use item--------------\n")
		var0 = event.get_triggered_event_data_2(6) or var0
		if var0 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Let's give the Holy One the\nPriscleen Fish.\n(Press the (#) button to use items.)")
			at = 1
			var1 = helper_c292fa16(0, -1, 5, 256, 208, var1)
			event.set_message_bubble_tail(0, 1)
			if var1 == 1 then
				var0 = 2
			end
		end
		if var0 == 2 then
			event.open_use_item_menu(310)
			at = 2
			vm.wait(2)
			item = vmhost.used_item() or item
			if item == 310 then
				at = 3
				event_506()
			elseif item <= 0 then
			else
				at = 4
				helper_0616fd34()
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var1 = received[2] :: number
			end
			if at <= 1 then
				local _ = var0 == 1
				var0 = 2
			end
			if at <= 2 then
				at = 3
				event_506()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 3 then
				helper_4fba7aa8()
			end
			return 0
		end
		return nil
	end)
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	event.initialize_event()
	if helper_ffd118ae() == 1 then
		event.set_save_control_bits(16, 0)
		var0 = 1
		var2 = 4
		var1 = 6
		event.set_dungeon_floor(var2)
		event.set_dungeon_floor_info(var0, var1, 5, 2)
		event.set_dungeon_floor_info(var0, var2, 5, 1)
		event.set_function_point_enabled("", "next_floor", 0)
		event.go_to_dungeon(1, var2, 1000)
		vm.wait(2)
	end
end

--- Event 552, which map data, a script or the engine runs by number.
function script.event_552()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		print("e552--------------\n")
		var0 = event.get_triggered_event_data_2(6) or var0
		if var0 == 1 then
			event.set_camera_position(-203.52, 16.84, -181.02)
			event.set_camera_look_at(-184.65, 30.0, -343.81)
			player_chara = event.get_player_character_slot() or player_chara
			var3 = 14
			event.set_message_bubble_tail(0, 1)
			event.apply_message_window_preset(0, 0)
			do
				local out1, _, out3 = event.get_character_position(player_chara)
				var4 = out1 or var4
				var6 = out3 or var6
			end
			do
				local out1, _, out3 = event.get_character_position(var3)
				var7 = out1 or var7
				var9 = out3 or var9
			end
			var10 = event.get_look_angle(var7 - var4, var9 - var6) or var10
			at = 1
			helper_76f23193(player_chara, var10)
			event.set_character_rotation(player_chara, 0.0, var10, 0.0)
			event.set_character_motion(player_chara, "立ち")
			event.set_character_motion(14, "会話")
			event.open_message_window_2(
				0,
				"Did you get your hands on\na little Priscleen?<page>When my beauty is marred, it is\ntruly a worldwide catastrophe.<page>Be a dear and hurry and find it\nfor me, okey-dokey?\n(Press the (#) button to use items.)"
			)
			at = 2
			show_message(0, -1, 3, 170, 208)
			event.set_character_motion(14, "立ち")
		end
		if var0 == 2 then
			event.open_use_item_menu(310)
			at = 3
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 310 then
				at = 4
				event_506()
			elseif 0 < item then
				at = 5
				helper_0616fd34()
			end
		end
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				helper_ee1c51d0(0, -1, 3, 170, 208)
			end
			if at <= 3 then
				at = 4
				event_506()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 4 then
				helper_4fba7aa8()
			end
			return 0
		end
		return nil
	end)
end

--- Event 553, which map data, a script or the engine runs by number.
function script.event_553()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var1 = 8
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	do
		local out1, _, out3 = event.get_character_position(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.get_character_position(var1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.get_look_angle(var5 - var2, var7 - var4) or var8
	helper_76f23193(player_chara, var8)
	event.set_character_rotation(player_chara, 0.0, var8, 0.0)
	event.set_character_motion(player_chara, "立ち")
	flag = event.get_save_flag(240) or flag
	if flag == 0 then
		event.open_message_window_2(0, 'The great "Holy One" of\nthe swamps is a divine\nconsecrated fish.')
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.open_message_window_2(
			0,
			'Should you care to meet the "Holy One",\ntake care as to not fish it\noutta the water. That would be bad.'
		)
	else
		flag_2 = event.get_save_flag(253) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(
				0,
				"Alright, it appears as though you\nhave paid a visit to the Holy One\nI pray you were very polite, yes?"
			)
		else
			event.open_message_window_2(
				0,
				"When I was but a little one, I could\nhurl rocks like these as far as the\neye could see. I hate getting old..."
			)
		end
	end
	helper_0ffc2526(0, -1, var1, player_chara, 0)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		argc = event.get_item_count(291) or argc
		if argc <= 0 then
			event.set_character_motion(0, "立ち")
			at = 1
			helper_f38eabca(291, 4)
			event.add_inventory_item(291, 4)
			at = 2
			helper_a87eb945(1)
			event.set_message_window_mode(0, 7)
		end
		helper_bb23ef44()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_bb522b21(1)
			end
			helper_fc5948a6()
			return 0
		end
		return nil
	end)
end

--- Event 561, which map data, a script or the engine runs by number.
function script.event_561()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local player_chara: s32 = 0
	event.set_character_motion(0, "立ち", 4)
	var0 = 9
	helper_e509fa5e(var0)
	event.set_message_window_mode(0, 1)
	argc = event.get_item_count(313) or argc
	var2 = event.get_save_data_value(3, 302) or var2
	if argc <= 0 and var2 ~= 313 then
		event.open_message_window_2(0, "No more bait?\nFer cryin' out...!\nWell, here you go.")
	else
		event.open_message_window_2(0, "Some days you catch 'em,\nsome days you don't.\nDon't worry about bait, though.")
	end
	player_chara = event.get_player_character_slot() or player_chara
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	if argc <= 0 and var2 ~= 313 then
		event.set_message_window_mode(0, 7)
		helper_f38eabca(313, 5)
		event.add_inventory_item(313, 5)
		helper_a87eb945(1)
	end
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	if helper_73c9d0a3() == 1 then
		event.set_dungeon_stage_id(1)
		event.set_dungeon_floor(0)
		event.set_save_control_bits(16, 0)
		event.jump_to_map_2(-1, "s02")
		vm.wait(2)
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var2: s32 = 0
	local player_chara: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local player_chara_2: s32 = 0
	local player_chara_3: s32 = 0
	local player_chara_4: s32 = 0
	var0 = event.get_message_window_frame(0) or var0
	event.set_message_window_mode(0, 1)
	var2 = event.get_triggered_event_data_2(13) or var2
	event.get_triggered_event_data_2(14)
	event.set_character_motion(0, "立ち", 4)
	helper_e509fa5e(var2)
	if var2 == 8 then
		flag = event.get_save_flag(240) or flag
		if flag == 0 then
			event.open_message_window_2(0, 'The great "Holy One" of\nthe swamps is a divine\nconsecrated fish.')
			event.open_message_window_2(
				0,
				'Should you care to meet the "Holy One",\ntake care as to not fish it\noutta the water. That would be bad.'
			)
		else
			flag_2 = event.get_save_flag(253) or flag_2
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"Alright, it appears as though you\nhave paid a visit to the Holy One\nI pray you were very polite, yes?"
				)
			else
				event.open_message_window_2(
					0,
					"When I was but a little one, I could\nhurl rocks like these as far as the\neye could see. I hate getting old..."
				)
			end
		end
		player_chara = event.get_player_character_slot() or player_chara
		helper_0ffc2526(0, -1, 10, player_chara, 0)
	end
	if var2 == 10 then
		event.open_message_window_2(0, "I'm happy here!\nJust go away and leave me alone!")
		player_chara_2 = event.get_player_character_slot() or player_chara_2
		helper_0ffc2526(0, -1, 10, player_chara_2, 0)
	end
	if var2 == 11 then
		event.open_message_window_2(
			0,
			"I ain't going back.\nI'm gonna live here forever,\nand there ain't a thing you can do about it!"
		)
		player_chara_3 = event.get_player_character_slot() or player_chara_3
		helper_0ffc2526(0, -1, 11, player_chara_3, 0)
	end
	if var2 == 12 then
		event.open_message_window_2(
			0,
			"This place is amazing!\nJust being here gives me this\nincredible feeling of happiness.<page>Ain't no way we're\ngoing back..."
		)
		player_chara_4 = event.get_player_character_slot() or player_chara_4
		helper_0ffc2526(0, -1, 12, player_chara_4, 0)
	end
	event.set_message_window_mode(0, var0)
end

--- Event 12150, which map data, a script or the engine runs by number.
function script.event_12150()
	event.set_save_flag(215, 0)
	event.set_save_counter(3, 0)
	helper_6050d30e(1)
	helper_135a0()
end

--- Event 12200, which map data, a script or the engine runs by number.
function script.event_12200()
	event.set_save_flag(220, 0)
	event.set_save_flag(28, 0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_motion(0, "立ち")
	helper_16814()
end

--- Event 12300, which map data, a script or the engine runs by number.
function script.event_12300()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 501)
end

--- Event 12350, which map data, a script or the engine runs by number.
function script.event_12350()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 502)
end

--- Event 12400, which map data, a script or the engine runs by number.
function script.event_12400()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_1a8cc()
		event.set_save_counter(3, 5)
		helper_bb23ef44()
		return
	end, function(received: { any })
		if at <= 1 then
			helper_fc5948a6()
			return 0
		end
		return nil
	end)
end

--- Event 12450, which map data, a script or the engine runs by number.
script.event_12450 = helper_202b0

--- Event 12470, which map data, a script or the engine runs by number.
function script.event_12470()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 503)
end

--- Event 12530, which map data, a script or the engine runs by number.
function script.event_12530()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b_1.stb", 504)
end

return script
