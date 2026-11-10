--!strict
-- map/d/d02/b02/d02b02_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4bd7f01a = require("@lib/event/helper_4bd7f01a")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_89dcac54 = require("@lib/event/helper_89dcac54")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9e49aefe = require("@lib/event/helper_9e49aefe")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_ad8b424a = require("@lib/event/helper_ad8b424a")
local helper_bb522b21 = require("@lib/event/helper_bb522b21")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local interpolate = require("@lib/event/interpolate")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_10e64(arg0: s32)
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e257/e257_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e257/e257_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e257/e257_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e257/e257_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.load_character(5, "dungeon/monster/b02a.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(3, 11)
	event.set_object_handle_sound_bank(3, arg0)
	event.clear_object_sequence(3, 11)
	event.set_object_sequence_object(3, 3)
	block = event.load_event_image_4(5, "textures/event/e200/e257/e257telop01_1.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e257telop01", block)
	event.set_event_sprite_position(0, 256, 312)
	event.set_event_sprite_size(0, 512, 128)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_scale(0, 1.0, 1.0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.load_message_file(0, 5, "event/e200/e257/e257_1.txt")
end

--- Helper function.
local function helper_22300000(arg0: s32)
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_10ae4()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(13)
	end
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.delete_character(11)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_11fd8()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local rot_y: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_z_3: f32 = 0
	local var15: s32 = 0
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local pos_x_4: f32 = 0
	local pos_z_4: f32 = 0
	local rot_y_2: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local pos_x_5: f32 = 0
	local pos_y: f32 = 0
	local pos_z_5: f32 = 0
	local var30: f32 = 0
	local rot_y_3: f32 = 0
	local rot_y_4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(257, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.load_map_sounds(2833)
		var1 = event.load_sound_effect_file_2(2833) or var1
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(31)
		helper_10e64(var1)
		event.set_object_sequence_motion(11, "歩き")
		event.set_character_active(0, 11)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(222.66, 860.66, 315.48)
		event.set_camera_sequence_look_at(386.81, 799.84, 241.69)
		event.fade_in_screen(30)
		at = 3
		wait_frames(60)
		event.set_character_active(1, global1)
		event.set_object_handle_footstep_sound(1, 17)
		event.set_object_sequence_position(1, 459.65, 700.0, 314.9)
		event.set_object_sequence_rotation(1, 0.0, -1.63, 0.0)
		event.jump_object_sequence(1, 338.06, 791.14, 270.62, -0.6, 30)
		event.set_object_sequence_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "着地2", 6)
		event.queue_object_sequence_next_motion(1, "着地2Ｌ", 6)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		at = 4
		wait_frames(10)
		event.move_camera_sequence_eased(222.66, 860.66, 315.48, 374.28, 799.84, 218.4, 30, 2, 1.0)
		event.play_sound_effect(var1, 0)
		event.set_character_active(1, global0)
		event.set_object_sequence_position(0, 465.64, 700.0, 251.72)
		event.set_object_sequence_rotation(0, 0.0, -1.63, 0.0)
		event.jump_object_sequence(0, 345.04, 787.93, 219.25, -0.6, 30)
		event.set_object_sequence_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "こける", 6)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_character_cloth_animation_enabled(global0, 0)
		at = 5
		wait_frames(20)
		event.play_sound_effect(var1, 1)
		at = 6
		wait_frames(10)
		event.play_sound_effect(var1, 2)
		at = 7
		wait_frames(30)
		event.set_character_cloth_animation_enabled(global1, 0)
		event.set_character_cloth_animation_enabled(global0, 1)
		event.enable_drama_skip()
		var2 = vm.f32(0.116339)
		var3 = vm.f32(0.074309)
		var4 = vm.f32(0.124094)
		var5 = vm.f32(496.65527)
		var6 = vm.f32(526.85187)
		var7 = vm.f32(483.53925)
		rot_y = vm.f32(-1.63)
		pos_x = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
		pos_z = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
		pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
		pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
		pos_x_3 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
		pos_z_3 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
		event.set_camera_sequence_position(pos_x_2, 809.42, pos_z_2)
		event.set_camera_sequence_look_at(pos_x_3, 815.5, pos_z_3)
		event.set_object_sequence_position(1, pos_x, 791.14, pos_z)
		event.set_object_sequence_rotation(1, 0.0, rot_y, 0.0)
		event.set_object_sequence_motion(1, "着地2Ｌ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ちあがり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 8
		vm.wait(8)
		event.set_character_cloth_animation_enabled(global1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.delay_object_sequence_motion_track(1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.delay_object_sequence_motion_track(1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		at = 9
		wait_frames(60)
		event.set_object_sequence_motion(1, "きょろきょろ歩き", 2)
		event.queue_object_sequence_next_motion(1, "歩き", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目～ひき目")
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		var15 = 2570010
		event.open_voice_stream_wave(1, var15)
		while true do
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			else
				at = 10
				vm.wait(10)
			end
		end
		event.ready_voice_stream(1)
		while true do
			stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
			if stream_open_state_2 == 0 then
				break
			else
				at = 11
				vm.wait(11)
			end
		end
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, var15)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		var0 = 0
		while var0 < 180 do
			pos_x = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
			pos_z = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
			pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
			pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
			pos_x_3 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
			pos_z_3 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
			event.set_object_sequence_position(1, pos_x, 791.14, pos_z)
			event.set_object_sequence_rotation(1, 0.0, rot_y, 0.0)
			event.set_camera_sequence_position(pos_x_2, 809.42, pos_z_2)
			event.set_camera_sequence_look_at(pos_x_3, 815.5, pos_z_3)
			var0 = var0 + 1
			at = 12
			vm.wait(12)
			var2 = helper_4bd7f01a(vm.f32(var2 - vm.f32(0.002)))
			rot_y = helper_4bd7f01a(vm.f32(rot_y - vm.f32(0.002)))
			var3 = helper_4bd7f01a(vm.f32(var3 - vm.f32(0.002)))
			var4 = helper_4bd7f01a(vm.f32(var4 - vm.f32(0.002)))
			if var0 == 158 then
				event.set_object_sequence_texture_animation(1, 0, "通常口パク")
			end
		end
		close_message(0)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		var18 = vm.f32(var2 + 0.0625)
		var19 = vm.f32(var5 - 100.0)
		pos_x_4 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
		pos_z_4 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
		rot_y_2 = 2.0
		event.set_object_sequence_position(0, pos_x_4, 783.25, pos_z_4)
		event.set_object_sequence_rotation(0, 0.0, rot_y_2, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き")
		event.set_object_handle_footstep_sound(0, 17)
		var0 = 0
		while var0 < 90 do
			var23 = interpolate(-0.125, 0.0625, var0, 90)
			var18 = helper_4bd7f01a(vm.f32(var2 + var23))
			pos_x_4 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
			pos_z_4 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
			pos_x = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
			pos_z = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
			pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
			pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
			pos_x_3 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
			pos_z_3 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
			event.set_object_sequence_position(0, pos_x_4, 783.25, pos_z_4)
			event.set_object_sequence_rotation(0, 0.0, rot_y_2, 0.0)
			event.set_object_sequence_position(1, pos_x, 791.14, pos_z)
			event.set_object_sequence_rotation(1, 0.0, rot_y, 0.0)
			event.set_camera_sequence_position(pos_x_2, 809.42, pos_z_2)
			event.set_camera_sequence_look_at(pos_x_3, 815.5, pos_z_3)
			var0 = var0 + 1
			at = 13
			vm.wait(13)
			rot_y_2 = helper_4bd7f01a(vm.f32(rot_y_2 - vm.f32(0.002)))
			var2 = helper_4bd7f01a(vm.f32(var2 - vm.f32(0.002)))
			rot_y = helper_4bd7f01a(vm.f32(rot_y - vm.f32(0.002)))
			var3 = helper_4bd7f01a(vm.f32(var3 - vm.f32(0.002)))
			var4 = helper_4bd7f01a(vm.f32(var4 - vm.f32(0.002)))
		end
		event.play_music(0)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(0, "指さす", 2)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		at = 14
		helper_4116e6bb(2570020)
		event.set_object_sequence_motion(1, "右振りかえり180度（ＰＧ）", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		rot_y = vm.f32(-2.17)
		var0 = 0
		while var0 < 30 do
			event.set_object_sequence_rotation(1, 0.0, rot_y, 0.0)
			at = 15
			vm.wait(15)
			rot_y = helper_4bd7f01a(vm.f32(rot_y - vm.f32(0.07)))
			var0 = var0 + 1
		end
		at = 16
		wait_frames(30)
		close_message(0)
		event.close_voice_stream(1)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(1, 11)
		event.set_camera_sequence_position(356.04, 805.96, -432.95)
		event.set_camera_sequence_look_at(414.81, 835.96, -493.23)
		var0 = 0
		while var0 < 240 do
			pos_y = interpolate(vm.f32(1691.85), vm.f32(858.57), var0, 240)
			var30 = interpolate(vm.f32(-3.926991), vm.f32(-1.5707964), var0, 240)
			pos_x_5 = vm.f32(vm.sin(var30) * vm.f32(1476.7))
			pos_z_5 = vm.f32(vm.cos(var30) * vm.f32(1476.7))
			pos_x_5 = vm.f32(pos_x_5 + vm.f32(1970.21))
			pos_z_5 = vm.f32(pos_z_5 + vm.f32(-576.77))
			var24 = event.get_look_angle(pos_x_5 - var25, pos_z_5 - var26) or var24
			event.set_object_sequence_position(3, pos_x_5, pos_y, pos_z_5)
			event.set_object_sequence_rotation(3, 0.0, var24, 0.0)
			at = 17
			vm.wait(17)
			var0 = var0 + 1
			var25 = pos_x_5
			var26 = pos_z_5
		end
		event.clear_camera_sequence()
		event.set_camera_sequence_position(564.06, 1040.4275, -876.85254)
		event.set_camera_sequence_look_at(535.89, 1075.06, -944.46)
		event.move_camera_sequence_eased(648.57, 936.53, -674.03, 535.89, 1075.06, -944.46, 150, 2, 1.0)
		event.set_object_sequence_position(3, 500.0, 1100.0, -1000.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.play_sound_effect(var1, 4)
		at = 18
		wait_frames(30)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
		at = 19
		wait_frames(240)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(0, 11)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-242.49, 801.47, -239.88)
		event.set_camera_sequence_look_at(-175.51, 815.89, -178.94)
		event.set_object_sequence_position(0, -219.74, 784.37, -209.85)
		event.set_object_sequence_rotation(0, 0.0, -1.95, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_position(1, -215.91, 784.38, -225.43)
		event.set_object_sequence_rotation(1, 0.0, -1.39, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 20
		wait_frames(60)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		helper_4116e6bb(2570030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向くL")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "かまえる", 2)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		at = 22
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 23
		helper_4116e6bb(2570040)
		event.reset_mouth_texture_animations()
		at = 24
		wait_frames(15)
		event.set_camera_sequence_position(-212.52, 803.06, -183.32)
		event.set_camera_sequence_look_at(-203.01, 814.64, -250.93)
		event.set_object_sequence_position(0, -214.38, 784.37, -234.13)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(0, "かまえるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_position(1, -202.79, 784.38, -212.64)
		event.set_object_sequence_rotation(1, 0.0, -3.07, 0.0)
		event.set_object_sequence_motion(1, "構えＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おこり目とじ")
		event.set_character_active(1, 11)
		event.set_object_sequence_position(3, 115.96, 1381.16, -3665.01)
		event.set_object_sequence_rotation(3, 0.7853982, -0.15, 0.0)
		event.move_object_sequence(3, -243.09, 926.4, 17.21, 120)
		at = 25
		wait_frames(30)
		event.play_sound_effect(var1, 5)
		at = 26
		wait_frames(30)
		event.set_object_sequence_motion(0, "蝶迫る", 2)
		event.queue_object_sequence_next_motion(0, "蝶迫るL", 4)
		event.set_object_sequence_motion(1, "構えから顔覆う", 2)
		event.queue_object_sequence_next_motion(1, "覆うＬ", 4)
		at = 27
		wait_frames(30)
		event.set_motion_blur(96)
		event.set_wind(40.0, -9.51001, 0.0, 67.609985)
		event.shake_camera_sequence_vertically(0.0, 1.0, 0.0, 30)
		at = 28
		wait_frames(30)
		event.set_motion_blur(0)
		event.set_character_active(0, 11)
		event.set_object_sequence_motion(0, "振り返る", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "覆いから右回り右180", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		var0 = 0
		while var0 < 30 do
			rot_y_3 = interpolate(vm.f32(3.13), vm.f32(-0.15), var0, 30.0)
			rot_y_4 = interpolate(vm.f32(-3.07), vm.f32(-0.62), var0, 30.0)
			event.set_object_sequence_rotation(0, 0.0, rot_y_3, 0.0)
			event.set_object_sequence_rotation(1, 0.0, rot_y_4, 0.0)
			at = 29
			vm.wait(29)
			var0 = var0 + 1
		end
		event.set_wind(-1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ～おこり目あき")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		helper_4116e6bb(2570050)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		at = 31
		wait_frames(45)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			helper_22300000(var1)
			wait_frames_skipping(60)
		end
		if at <= 3 then
			wait_frames_skipping(10)
		end
		if at <= 4 then
			wait_frames_skipping(20)
		end
		if at <= 5 then
			wait_frames_skipping(10)
		end
		if at <= 6 then
			wait_frames_skipping(30)
		end
		if at <= 7 then
			var2 = vm.f32(0.116339)
			var3 = vm.f32(0.074309)
			var4 = vm.f32(0.124094)
			var5 = vm.f32(496.65527)
			var6 = vm.f32(526.85187)
			var7 = vm.f32(483.53925)
			rot_y = vm.f32(-1.63)
			pos_x = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
			pos_z = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
			pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
			pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
			pos_x_3 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
			pos_z_3 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
		end
		if at <= 8 then
			wait_frames_skipping(60)
		end
		if at <= 9 then
			var15 = 2570010
		end
		if at <= 11 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			var0 = 0
			pos_x = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
			pos_z = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
			pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
			pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
			pos_x_3 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
			pos_z_3 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
			local _ = var0 < 180
			var0 = var0 + 1
		end
		if at <= 12 then
			var2 = helper_9e49aefe(vm.f32(var2 - vm.f32(0.002)))
			rot_y = helper_9e49aefe(vm.f32(rot_y - vm.f32(0.002)))
			var3 = helper_9e49aefe(vm.f32(var3 - vm.f32(0.002)))
			var4 = helper_9e49aefe(vm.f32(var4 - vm.f32(0.002)))
			helper_d16eef1e(0)
			var18 = vm.f32(var2 + 0.0625)
			var19 = vm.f32(var5 - 100.0)
			pos_x_4 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
			pos_z_4 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
			rot_y_2 = 2.0
			local _ = var0 == 158
			var0 = 0
			var23 = interpolate(-0.125, 0.0625, var0, 90)
			var18 = helper_9e49aefe(vm.f32(var2 + var23))
			pos_x_4 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
			pos_z_4 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
			pos_x = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
			pos_z = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
			pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
			pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
			pos_x_3 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
			pos_z_3 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
			local _ = var0 < 90
			var0 = var0 + 1
		end
		if at <= 13 then
			rot_y_2 = helper_9e49aefe(vm.f32(rot_y_2 - vm.f32(0.002)))
			var2 = helper_9e49aefe(vm.f32(var2 - vm.f32(0.002)))
			rot_y = helper_9e49aefe(vm.f32(rot_y - vm.f32(0.002)))
			var3 = helper_9e49aefe(vm.f32(var3 - vm.f32(0.002)))
			var4 = helper_9e49aefe(vm.f32(var4 - vm.f32(0.002)))
			helper_8cd371d7(2570020)
		end
		if at <= 14 then
			rot_y = vm.f32(-2.17)
			var0 = 0
		end
		if at <= 15 then
			rot_y = helper_9e49aefe(vm.f32(rot_y - vm.f32(0.07)))
			local _ = var0 < 30
			var0 = var0 + 1
			wait_frames_skipping(30)
		end
		if at <= 16 then
			helper_d16eef1e(0)
			var0 = 0
			pos_y = interpolate(vm.f32(1691.85), vm.f32(858.57), var0, 240)
			var30 = interpolate(vm.f32(-3.926991), vm.f32(-1.5707964), var0, 240)
			pos_x_5 = vm.f32(vm.sin(var30) * vm.f32(1476.7))
			pos_z_5 = vm.f32(vm.cos(var30) * vm.f32(1476.7))
			pos_x_5 = vm.f32(pos_x_5 + vm.f32(1970.21))
			pos_z_5 = vm.f32(pos_z_5 + vm.f32(-576.77))
		end
		if at <= 17 then
			local _ = var0 < 240
			var0 = var0 + 1
			var25 = pos_x_5
			var26 = pos_z_5
			wait_frames_skipping(30)
		end
		if at <= 18 then
			wait_frames_skipping(240)
		end
		if at <= 19 then
			wait_frames_skipping(60)
		end
		if at <= 20 then
			helper_8cd371d7(2570030)
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_8cd371d7(2570040)
		end
		if at <= 23 then
			wait_frames_skipping(15)
		end
		if at <= 24 then
			wait_frames_skipping(30)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		if at <= 27 then
			wait_frames_skipping(30)
		end
		if at <= 28 then
			var0 = 0
			rot_y_3 = interpolate(vm.f32(3.13), vm.f32(-0.15), var0, 30.0)
			rot_y_4 = interpolate(vm.f32(-3.07), vm.f32(-0.62), var0, 30.0)
		end
		if at <= 29 then
			local _ = var0 < 30
			var0 = var0 + 1
			helper_8cd371d7(2570050)
		end
		if at <= 30 then
			wait_frames_skipping(45)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_character_cloth_animation_enabled(global1, 1)
	event.set_event_sprite_draw_pass(0, 0)
	helper_10ae4()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_motion_blur(0)
	event.play_music(0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_17bac()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e260/e260_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 14)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e260/e260_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 14)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 14)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e260/e260_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 14)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e260/e260_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.load_character(5, "event/e200/e260/e260_holly.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4, 12)
	event.set_object_sequence_object(4, 4)
	event.set_object_handle_frame_draw_flag(4, "kami", 0)
	event.load_character(5, "event/e200/e260/e260_lettr1.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5, 13)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "dungeon/monster/b02a1.gltf", "b02a1", 15)
	event.set_character_active(0, 15)
	event.attach_object_handle_to_character(6, 15)
	event.clear_object_sequence(6, 15)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "dungeon/monster/b02a2.gltf", "b02a2", 16)
	event.set_character_active(0, 16)
	event.attach_object_handle_to_character(7, 16)
	event.clear_object_sequence(7, 16)
	event.set_object_sequence_object(7, 7)
	event.load_character(5, "dungeon/monster/b02a3.gltf", "b02a3", 17)
	event.set_character_active(0, 17)
	event.attach_object_handle_to_character(8, 17)
	event.clear_object_sequence(8, 17)
	event.set_object_sequence_object(8, 8)
	event.load_character(5, "dungeon/monster/b02a4.gltf", "b02a4", 18)
	event.set_character_active(0, 18)
	event.attach_object_handle_to_character(9, 18)
	event.clear_object_sequence(9, 18)
	event.set_object_sequence_object(9, 9)
	event.load_character(5, "dungeon/monster/b02a5.gltf", "b02a5", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(10, 19)
	event.clear_object_sequence(10, 19)
	event.set_object_sequence_object(10, 10)
	event.load_character(5, "dungeon/monster/b02a6.gltf", "b02a6", 20)
	event.set_character_active(0, 20)
	event.attach_object_handle_to_character(11, 20)
	event.clear_object_sequence(11, 20)
	event.set_object_sequence_object(11, 11)
	event.load_character(5, "dungeon/monster/b02a7.gltf", "b02a7", 21)
	event.set_character_active(0, 21)
	event.attach_object_handle_to_character(12, 21)
	event.clear_object_sequence(12, 21)
	event.set_object_sequence_object(12, 12)
	event.load_character(5, "event/e200/e260/e260_hohikari.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.attach_object_handle_to_character(13, 22)
	event.clear_object_sequence(13, 22)
	event.set_object_sequence_object(13, 13)
	event.load_character(5, "event/e200/e260/e260_hohikari1.gltf", "info", 23)
	event.set_character_active(0, 23)
	event.attach_object_handle_to_character(14, 23)
	event.clear_object_sequence(14, 23)
	event.set_object_sequence_object(14, 14)
	block = event.load_event_image_4(5, "textures/event/e200/e260/e260.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e26001", block)
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
	event.set_event_sprite_texture(1, "e26002", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e26003", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(22, 2)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e26004", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(23, 3)
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e26005", block)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(24, 4)
	event.clear_object_sequence(24)
	event.set_object_sequence_object(24, 24)
	event.load_message_file(0, 5, "event/e200/e260/e260_1.txt")
end

--- Helper function.
local function helper_22a00000()
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_175bc()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character(global1)
		event.delete_character(14)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(14)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.delete_character(23)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_1a400()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(260, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 2
		wait_frames(30)
		event.load_map_sounds(2836)
		var0 = event.load_sound_effect_file_2(2836) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var1
		event.stop_music(0)
		at = 3
		wait_frames(4)
		event.load_music(53)
		event.set_environment_music_volume(0.6)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		helper_17bac()
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 19)
		event.set_character_active(0, 20)
		event.set_character_active(0, 21)
		event.set_character_active(0, 22)
		event.set_character_active(0, 23)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 950.0, 200.0)
		event.set_camera_sequence_look_at(0.0, 1000.0, 0.0)
		event.play_sound_effect(var0, 0)
		event.fade_in_screen(30)
		at = 4
		wait_frames(30)
		event.set_character_active(1, 15)
		event.set_character_active(1, 16)
		event.set_character_active(1, 17)
		event.set_character_active(1, 18)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		event.set_character_active(1, 21)
		event.set_object_handle_scale(6, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(7, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(8, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(9, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(10, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(11, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(12, 0.5, 0.5, 0.5)
		event.set_object_sequence_position(6, 0.0, 1000.0, 200.0)
		event.set_object_sequence_rotation(6, 0.0, 3.1415927, 0.0)
		event.set_object_sequence_motion(6, "飛行", 4)
		event.set_object_sequence_position(7, 141.4, 950.0, 141.4)
		event.set_object_sequence_rotation(7, 0.0, 3.926991, 0.0)
		event.set_object_sequence_motion(7, "飛行", 4)
		event.set_object_sequence_position(8, -141.4, 950.0, 141.4)
		event.set_object_sequence_rotation(8, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_motion(8, "飛行", 4)
		event.set_object_sequence_position(9, 70.7, 925.0, 170.7)
		event.set_object_sequence_rotation(9, 0.0, 3.5342917, 0.0)
		event.set_object_sequence_motion(9, "飛行", 4)
		event.set_object_sequence_position(10, 70.7, 975.0, 170.7)
		event.set_object_sequence_rotation(10, 0.0, 3.5342917, 0.0)
		event.set_object_sequence_motion(10, "飛行", 4)
		event.set_object_sequence_position(11, -70.7, 925.0, 170.7)
		event.set_object_sequence_rotation(11, 0.0, 27.488937, 0.0)
		event.set_object_sequence_motion(11, "飛行", 4)
		event.set_object_sequence_position(12, -70.7, 975.0, 170.7)
		event.set_object_sequence_rotation(12, 0.0, 27.488937, 0.0)
		event.set_object_sequence_motion(12, "飛行", 4)
		event.move_object_sequence(10, 0.0, 1000.0, 0.0, 120)
		at = 5
		wait_frames(3)
		event.move_object_sequence(11, 0.0, 1000.0, 0.0, 120)
		at = 6
		wait_frames(3)
		event.move_object_sequence(6, 0.0, 1000.0, 0.0, 120)
		at = 7
		wait_frames(3)
		event.move_object_sequence(7, 0.0, 1000.0, 0.0, 120)
		at = 8
		wait_frames(3)
		event.move_object_sequence(12, 0.0, 1000.0, 0.0, 120)
		at = 9
		wait_frames(3)
		event.move_object_sequence(9, 0.0, 1000.0, 0.0, 120)
		at = 10
		wait_frames(3)
		event.move_object_sequence(8, 0.0, 1000.0, 0.0, 120)
		at = 11
		wait_frames(60)
		event.set_character_active(1, 22)
		event.set_object_sequence_position(13, 0.0, 1000.0, 0.0)
		event.set_object_sequence_motion(13, "ホーリーの光", 6)
		event.stop_sound_effect(var0, 0)
		at = 12
		wait_objects(10)
		event.set_character_active(0, 19)
		at = 13
		wait_objects(11)
		event.set_character_active(0, 20)
		at = 14
		wait_objects(6)
		event.set_character_active(0, 15)
		at = 15
		wait_objects(7)
		event.set_character_active(0, 16)
		at = 16
		wait_objects(12)
		event.set_character_active(0, 21)
		at = 17
		wait_objects(9)
		event.set_character_active(0, 18)
		at = 18
		wait_objects(8)
		event.set_character_active(0, 17)
		event.play_sound_effect(var0, 1)
		event.set_character_active(1, 12)
		event.set_character_visible(12, 1, 1, 0.05)
		event.set_object_sequence_position(4, 0.0, 980.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "現れる", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ")
		event.set_character_active(1, 23)
		event.set_object_sequence_position(14, 0.0, 980.0, 0.0)
		event.set_object_sequence_rotation(14, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(14, "光MAX", 4)
		at = 19
		wait_frames(60)
		event.set_object_sequence_motion(14, "消える", 2)
		at = 20
		wait_frames(60)
		event.set_character_active(0, 22)
		event.set_character_active(0, 23)
		event.set_camera_sequence_position(0.0, 1010.0, 35.0)
		event.set_camera_sequence_look_at(0.0, 1010.0, 0.0)
		event.set_object_sequence_position(4, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ")
		event.move_camera_sequence(0.0, 1025.0, 35.0, 0.0, 1025.0, 0.0, 150)
		at = 21
		wait_frames(150)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ～目あき")
		event.play_music(0)
		event.set_mouth_texture_animations(4, "口パク")
		at = 22
		helper_4116e6bb(2600010)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 14)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(0, -42.69, 774.65, -517.65)
		event.set_object_sequence_rotation(0, 0.0, 2.13, 0.0)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, -28.93, 774.65, -505.13)
		event.set_object_sequence_rotation(1, 0.0, 2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 23
		helper_4116e6bb(2600020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(19.58, 1019.28, 33.73)
		event.set_camera_sequence_look_at(-28.59, 1038.2, -27.4)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(4, "会話2", 2)
		event.queue_object_sequence_next_motion(4, "立ち")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(4, "口パク")
		at = 24
		helper_4116e6bb(2600030)
		event.set_object_sequence_motion(4, "立ち")
		event.reset_mouth_texture_animations()
		at = 25
		wait_objects(4)
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 14)
		event.set_character_active(0, 12)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		helper_4116e6bb(2600040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
		helper_4116e6bb(2600045)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(0.0, 1025.0, 35.0)
		event.set_camera_sequence_look_at(0.0, 1025.0, 0.0)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(4, "うつむく", 6)
		event.queue_object_sequence_next_motion(4, "うつむくL", 6)
		event.queue_object_sequence_next_motion(4, "顔を上げる", 2)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(4, 75)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(4, "口パク")
		at = 28
		helper_4116e6bb(2600050)
		event.reset_mouth_texture_animations()
		at = 29
		wait_objects(4)
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 14)
		event.set_character_active(0, 12)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		helper_4116e6bb(2600060)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0, 15)
		at = 31
		wait_frames(15)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 14)
		event.set_character_active(0, 12)
		at = 32
		helper_4116e6bb(2600070)
		at = 33
		helper_4116e6bb(2600075)
		at = 34
		helper_4116e6bb(2600080)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0, 15)
		at = 35
		wait_frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		at = 36
		helper_4116e6bb(2600090)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 128.0, 15)
		at = 37
		wait_frames(15)
		event.set_event_sprite_draw_pass(1, 0)
		at = 38
		helper_4116e6bb(2600100)
		at = 39
		helper_4116e6bb(2600110)
		at = 40
		helper_4116e6bb(2600115)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(23, 128.0, 128.0, 128.0, 128.0, 15)
		at = 41
		wait_frames(15)
		event.set_event_sprite_draw_pass(2, 0)
		at = 42
		helper_4116e6bb(2600120)
		at = 43
		helper_4116e6bb(2600130)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(24, 128.0, 128.0, 128.0, 128.0, 15)
		at = 44
		wait_frames(15)
		event.set_event_sprite_draw_pass(3, 0)
		at = 45
		helper_4116e6bb(2600140)
		at = 46
		helper_4116e6bb(2600145)
		at = 47
		helper_4116e6bb(2600150)
		at = 48
		helper_4116e6bb(2600160)
		event.set_camera_sequence_position(19.72, 819.45, -34.3)
		event.set_camera_sequence_look_at(0.0, 823.12, 0.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_position(0, -15.79, 795.0, 7.98)
		event.set_object_sequence_rotation(0, 0.0, 2.3, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 0.0, 795.0, 10.0)
		event.set_object_sequence_rotation(1, 0.0, 3.1415927, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(4, 0.0, 795.0, -10.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_color(24, 128.0, 128.0, 128.0, 0.0, 15)
		at = 49
		wait_frames(15)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		helper_4116e6bb(2600170)
		event.reset_mouth_texture_animations()
		event.move_camera_sequence_angle_height_distance(0.79, -4.57, 45.0, 360)
		event.set_mouth_texture_animations(4, "口パク")
		at = 51
		helper_4116e6bb(2600180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 52
		helper_4116e6bb(2600190)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 53
		helper_4116e6bb(2600200)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 54
		helper_4116e6bb(2600210)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 55
		helper_4116e6bb(2600220)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 56
		helper_4116e6bb(2600230)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 57
		helper_4116e6bb(2600240)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 58
		helper_4116e6bb(2600250)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 13)
		event.attach_character_to_frame(12, "letter", 13)
		event.set_object_sequence_motion(4, "手紙を渡す", 2)
		event.queue_object_sequence_next_motion(4, "手紙を渡すL", 4)
		event.play_sound_effect(var0, 2)
		event.set_mouth_texture_animations(4, "口パク")
		at = 59
		helper_4116e6bb(2600260)
		event.reset_mouth_texture_animations()
		at = 60
		wait_objects(4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(0, -42.69, 774.65, -517.65)
		event.set_object_sequence_rotation(0, 0.0, 2.13, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.detach_character_from_frame(13)
		event.attach_character_to_frame(global1, "sword_hand", 13)
		event.set_object_sequence_position(1, -28.93, 774.65, -505.13)
		event.set_object_sequence_rotation(1, 0.0, 2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "封筒受け取り", 6)
		event.queue_object_sequence_next_motion(1, "封筒受け取りＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.play_sound_effect(var0, 3)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 61
		helper_4116e6bb(2600270)
		event.reset_mouth_texture_animations()
		event.pause_music()
		event.set_character_active(1, 11)
		event.set_character_position(11, -18.72, 797.98, -512.22)
		event.set_character_rotation(11, 0.0, 1.5707964, 0.0)
		event.set_character_motion(11, "発動", 6)
		at = 62
		wait_frames(2)
		event.play_sound_effect(var1, 0)
		at = 63
		wait_frames(120)
		event.play_sound_effect(var0, 4)
		event.apply_message_window_preset(1, 4)
		set_window_mode(1, 4)
		event.set_message_item_name(1, 1, 385)
		at = 64
		helper_75684dd8(1, 10, 8, 0, 0)
		event.play_music(0)
		event.set_character_active(0, 11)
		event.detach_character_from_frame(13)
		event.set_character_active(0, 13)
		event.set_camera_sequence_position(0.0, 1017.78, 76.79)
		event.set_camera_sequence_look_at(0.0, 1025.0, 0.0)
		event.move_camera_sequence(0.0, 1025.0, 35.0, 0.0, 1025.0, 0.0, 180)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_position(4, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_mouth_texture_animations(4, "口パク")
		at = 65
		helper_4116e6bb(2600280)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 66
		helper_4116e6bb(2600290)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 67
		helper_4116e6bb(2600300)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 23)
		event.set_object_sequence_position(14, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(14, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(14, "光る", 6)
		event.queue_object_sequence_next_motion(14, "光MAX", 4)
		event.play_sound_effect(var0, 5)
		event.fade_out_music(30)
		at = 68
		wait_frames(60)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(186.87, 1388.53, 256.46)
		event.set_camera_sequence_look_at(0.0, 1025.0, 0.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_object_sequence_position(0, -143.38, 788.23, 56.15)
		event.set_object_sequence_rotation(0, 0.0, 2.3, 0.0)
		event.set_object_sequence_position(1, -123.21, 788.97, 62.99)
		event.set_object_sequence_rotation(1, 0.0, 2.46, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上から左", 5)
		event.set_character_active(1, 22)
		event.set_object_sequence_position(13, 0.0, 1000.0, 0.0)
		event.reset_object_sequence_motion(13)
		event.set_object_sequence_motion(13, "ホーリーの光", 6)
		at = 69
		wait_frames(60)
		event.set_character_active(0, 12)
		event.set_character_active(0, 23)
		event.set_character_active(1, 15)
		event.set_character_active(1, 16)
		event.set_character_active(1, 17)
		event.set_character_active(1, 18)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		event.set_character_active(1, 21)
		event.set_object_sequence_position(6, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.7853982, 0.0)
		event.set_object_sequence_position(7, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_position(8, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_position(9, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, 3.1415927, 0.0)
		event.set_object_sequence_position(10, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(10, 0.0, -2.3561945, 0.0)
		event.set_object_sequence_position(11, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_position(12, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, -0.7853982, 0.0)
		event.move_object_sequence(6, 353.55338, 1000.0, 353.55338, 120)
		event.move_object_sequence(7, 500.0, 1000.0, 0.0, 120)
		event.move_object_sequence(8, 353.55338, 1000.0, -353.55338, 120)
		event.move_object_sequence(9, 0.0, 1000.0, -500.0, 120)
		event.move_object_sequence(10, -353.55338, 1000.0, -353.55338, 120)
		event.move_object_sequence(11, -500.0, 1000.0, 0.0, 120)
		event.move_object_sequence(12, -353.55338, 1000.0, 353.55338, 120)
		event.play_sound_effect(var0, 6)
		at = 70
		wait_frames(150)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 19)
		event.set_character_active(0, 20)
		event.set_character_active(0, 21)
		event.set_character_active(0, 22)
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_environment_music_volume(1.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(0, -42.69, 774.65, -517.65)
		event.set_object_sequence_rotation(0, 0.0, 2.49, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_position(1, -28.93, 774.65, -505.13)
		event.set_object_sequence_rotation(1, 0.0, 2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "上から左", 5)
		at = 71
		wait_frames(90)
		event.set_object_sequence_motion(1, "上から左", 2)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 72
		helper_4116e6bb(2600310)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上向く戻り", 2)
		event.queue_object_sequence_next_motion(0, "右向く", 6)
		event.wait_object_sequence_motion_end(0)
		at = 73
		wait_objects(0)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 74
		helper_4116e6bb(2600320)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		at = 75
		wait_frames(45)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(30)
		end
		if at <= 2 then
			wait_frames_skipping(4)
		end
		if at <= 3 then
			helper_22a00000()
			wait_frames_skipping(30)
		end
		if at <= 4 then
			wait_frames_skipping(3)
		end
		if at <= 5 then
			wait_frames_skipping(3)
		end
		if at <= 6 then
			wait_frames_skipping(3)
		end
		if at <= 7 then
			wait_frames_skipping(3)
		end
		if at <= 8 then
			wait_frames_skipping(3)
		end
		if at <= 9 then
			wait_frames_skipping(3)
		end
		if at <= 10 then
			wait_frames_skipping(60)
		end
		if at <= 11 then
			helper_238b5abc(10)
		end
		if at <= 12 then
			helper_238b5abc(11)
		end
		if at <= 13 then
			helper_238b5abc(6)
		end
		if at <= 14 then
			helper_238b5abc(7)
		end
		if at <= 15 then
			helper_238b5abc(12)
		end
		if at <= 16 then
			helper_238b5abc(9)
		end
		if at <= 17 then
			helper_238b5abc(8)
		end
		if at <= 18 then
			wait_frames_skipping(60)
		end
		if at <= 19 then
			wait_frames_skipping(60)
		end
		if at <= 20 then
			wait_frames_skipping(150)
		end
		if at <= 21 then
			helper_8cd371d7(2600010)
		end
		if at <= 22 then
			helper_8cd371d7(2600020)
		end
		if at <= 23 then
			helper_8cd371d7(2600030)
		end
		if at <= 24 then
			helper_238b5abc(4)
		end
		if at <= 25 then
			helper_8cd371d7(2600040)
		end
		if at <= 26 then
			helper_8cd371d7(2600045)
		end
		if at <= 27 then
			helper_8cd371d7(2600050)
		end
		if at <= 28 then
			helper_238b5abc(4)
		end
		if at <= 29 then
			helper_8cd371d7(2600060)
		end
		if at <= 30 then
			wait_frames_skipping(15)
		end
		if at <= 31 then
			helper_8cd371d7(2600070)
		end
		if at <= 32 then
			helper_8cd371d7(2600075)
		end
		if at <= 33 then
			helper_8cd371d7(2600080)
		end
		if at <= 34 then
			wait_frames_skipping(15)
		end
		if at <= 35 then
			helper_8cd371d7(2600090)
		end
		if at <= 36 then
			wait_frames_skipping(15)
		end
		if at <= 37 then
			helper_8cd371d7(2600100)
		end
		if at <= 38 then
			helper_8cd371d7(2600110)
		end
		if at <= 39 then
			helper_8cd371d7(2600115)
		end
		if at <= 40 then
			wait_frames_skipping(15)
		end
		if at <= 41 then
			helper_8cd371d7(2600120)
		end
		if at <= 42 then
			helper_8cd371d7(2600130)
		end
		if at <= 43 then
			wait_frames_skipping(15)
		end
		if at <= 44 then
			helper_8cd371d7(2600140)
		end
		if at <= 45 then
			helper_8cd371d7(2600145)
		end
		if at <= 46 then
			helper_8cd371d7(2600150)
		end
		if at <= 47 then
			helper_8cd371d7(2600160)
		end
		if at <= 48 then
			wait_frames_skipping(15)
		end
		if at <= 49 then
			helper_8cd371d7(2600170)
		end
		if at <= 50 then
			helper_8cd371d7(2600180)
		end
		if at <= 51 then
			helper_8cd371d7(2600190)
		end
		if at <= 52 then
			helper_8cd371d7(2600200)
		end
		if at <= 53 then
			helper_8cd371d7(2600210)
		end
		if at <= 54 then
			helper_8cd371d7(2600220)
		end
		if at <= 55 then
			helper_8cd371d7(2600230)
		end
		if at <= 56 then
			helper_8cd371d7(2600240)
		end
		if at <= 57 then
			helper_8cd371d7(2600250)
		end
		if at <= 58 then
			helper_8cd371d7(2600260)
		end
		if at <= 59 then
			helper_238b5abc(4)
		end
		if at <= 60 then
			helper_8cd371d7(2600270)
		end
		if at <= 61 then
			wait_frames_skipping(2)
		end
		if at <= 62 then
			wait_frames_skipping(120)
		end
		if at <= 63 then
			helper_fbd9683d(1, 4)
			helper_ee1c51d0(1, 10, 8, 0, 0)
		end
		if at <= 64 then
			helper_8cd371d7(2600280)
		end
		if at <= 65 then
			helper_8cd371d7(2600290)
		end
		if at <= 66 then
			helper_8cd371d7(2600300)
		end
		if at <= 67 then
			wait_frames_skipping(60)
		end
		if at <= 68 then
			wait_frames_skipping(60)
		end
		if at <= 69 then
			wait_frames_skipping(150)
		end
		if at <= 70 then
			wait_frames_skipping(90)
		end
		if at <= 71 then
			helper_8cd371d7(2600310)
		end
		if at <= 72 then
			helper_238b5abc(0)
		end
		if at <= 73 then
			helper_8cd371d7(2600320)
		end
		if at <= 74 then
			wait_frames_skipping(45)
		end
		return true
	end)
	at = 76
	vm.entry(76)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.stop_sound_effect(var1, 0)
	event.stop_music(0)
	helper_175bc()
	event.show_dungeon_status_bar(1, 1.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_11fd8

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	helper_89dcac54()
	helper_ad8b424a()
	event.stop_music(0)
	wait_frames(4)
	event.load_music(31)
	event.play_music(0)
	event.set_character_position(0, -124.13, 782.88, -644.77)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_11fd8()
	helper_89dcac54()
	helper_ad8b424a()
	vm.wait(3)
	event.set_character_position(0, -124.13, 782.88, -644.77)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.stop_music(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.clear_event_battle_monsters(-1)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		event.set_dungeon_floor_info(stage_id, var1, 5, 2)
		at = 2
		helper_1a400()
		event.add_inventory_item(385)
		at = 3
		helper_a87eb945(0)
		event.skip_next_music_load()
		event.load_dungeon_map("d02b01")
		event.load_event_script("d02b01/d02b01.stb", 201)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_1a400()
				return vm.continue_with(function()
					event.add_inventory_item(385)
					at = 3
					helper_a87eb945(0)
					event.skip_next_music_load()
					event.load_dungeon_map("d02b01")
					event.load_event_script("d02b01/d02b01.stb", 201)
					return
				end)
			end
			if at <= 2 then
				helper_bb522b21(0)
			end
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "La farfalla si [UNI00e8] scissa in\nsette farfalle. Ora puoi\nattaccarle una ad una!")
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"Le farfalle sono sensibili al\nsuono e al movimento. Spostati con\ncautela per non farle scappare."
	)
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Devi sconfiggerle seguendo\nun certo ordine. Pensa ai\ncolori dell'arcobaleno...")
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end

--- Event 505, which map data, a script or the engine runs by number.
function script.event_505()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Sconfiggile secondo l'ordine dei\ncolori dell'arcobaleno. Il primo\n[UNI00e8] il rosso.")
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end

--- Event 506, which map data, a script or the engine runs by number.
function script.event_506()
	event.set_dungeon_pause_flags(3, 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(665.3, 1226.64, 776.05)
	event.set_camera_sequence_look_at(426.01, 939.19, -311.58)
	wait_frames(300)
	event.set_dungeon_pause_flags(3, 0)
end

--- Event 507, which map data, a script or the engine runs by number.
function script.event_507()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_dungeon_pause_flags(1, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Sembra non funzioni nulla\n   contro la Farfalla Arcobaleno.\n   Meglio escogitare\n   qualche altra tattica."
	)
	helper_75684dd8(0, -1, 5, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]La Farfalla Arcobaleno [UNI00e8] apparsa\n   allo sbocciare della Lafrescia, che\n   potrebbe quindi fornire indizi per\n   sconfiggere la Farfalla Arcobaleno."
	)
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event.play_music(0)
end

--- Event 511, which map data, a script or the engine runs by number.
function script.event_511()
	event.play_music(1)
end

--- Event 512, which map data, a script or the engine runs by number.
function script.event_512()
	event.stop_music(0)
end

--- Event 513, which map data, a script or the engine runs by number.
function script.event_513()
	event.stop_music(1)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 12551, which map data, a script or the engine runs by number.
function script.event_12551()
	event.load_dungeon_map("d02b01")
	event.load_event_script("d02b01/d02b01.stb", 12551)
end

--- Event 12552, which map data, a script or the engine runs by number.
function script.event_12552()
	event.load_dungeon_map("d02b01")
	event.load_event_script("d02b01/d02b01.stb", 12552)
end

--- Event 12560, which map data, a script or the engine runs by number.
function script.event_12560()
	event.load_dungeon_map("d02b01")
	event.load_event_script("d02b01/d02b01.stb", 12560)
end

--- Event 12570, which map data, a script or the engine runs by number.
script.event_12570 = helper_11fd8

--- Event 12600, which map data, a script or the engine runs by number.
script.event_12600 = helper_1a400

return script
