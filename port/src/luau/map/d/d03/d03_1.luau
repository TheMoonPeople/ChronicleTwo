--!strict
-- map/d/d03/d03_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_03a1d6f1 = require("@lib/event/helper_03a1d6f1")
local helper_0ba2b71d = require("@lib/event/helper_0ba2b71d")
local helper_17b6d01b = require("@lib/event/helper_17b6d01b")
local helper_1a7fd8eb = require("@lib/event/helper_1a7fd8eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_28a5dd67 = require("@lib/event/helper_28a5dd67")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_313d0b27 = require("@lib/event/helper_313d0b27")
local helper_384e16e1 = require("@lib/event/helper_384e16e1")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_3cf99f2c = require("@lib/event/helper_3cf99f2c")
local helper_3d16f076 = require("@lib/event/helper_3d16f076")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_49c6448e = require("@lib/event/helper_49c6448e")
local helper_4c1ba28b = require("@lib/event/helper_4c1ba28b")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_6c7de8d8 = require("@lib/event/helper_6c7de8d8")
local helper_6c8af328 = require("@lib/event/helper_6c8af328")
local helper_74f9cdb5 = require("@lib/event/helper_74f9cdb5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7870f366 = require("@lib/event/helper_7870f366")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7b560508 = require("@lib/event/helper_7b560508")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_86f3f24c = require("@lib/event/helper_86f3f24c")
local helper_8895171c = require("@lib/event/helper_8895171c")
local helper_92471cb6 = require("@lib/event/helper_92471cb6")
local helper_a583d6cd = require("@lib/event/helper_a583d6cd")
local helper_ac9d5b12 = require("@lib/event/helper_ac9d5b12")
local helper_b1b0c1a6 = require("@lib/event/helper_b1b0c1a6")
local helper_b2cb6e46 = require("@lib/event/helper_b2cb6e46")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c3f198dd = require("@lib/event/helper_c3f198dd")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_d1646134 = require("@lib/event/helper_d1646134")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e74dc41f = require("@lib/event/helper_e74dc41f")
local helper_e91d3484 = require("@lib/event/helper_e91d3484")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_efb31e92 = require("@lib/event/helper_efb31e92")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local helper_f90045b0 = require("@lib/event/helper_f90045b0")
local helper_fe9d3952 = require("@lib/event/helper_fe9d3952")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_message_answer = require("@lib/event/wait_message_answer")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3bd7c(arg0: s32)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local active_chr_no: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_032.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
			var5 = out4 or var5
		end
		event.set_event_world_coordinate(var2, var3, var4, var5)
		event.show_dungeon_status_bar(0, 1.0)
		if arg0 ~= 0 then
			var6 = event.get_dungeon_floor() or var6
			var7 = event.get_dungeon_previous_floor() or var7
			event.load_dungeon_map_display(5, 0, 2, var6, var7)
			event.fade_dungeon_map(1, 30)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d02_1.json", 0)
			event.set_event_image_texture(0, "logo_d02")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		end
		var8 = event.get_dungeon_floor_status() or var8
		if var8 ~= 0 then
			if bit32.band(var8, 1) ~= 0 then
				event.switch_dungeon_main_character(1)
			end
			if bit32.band(var8, 2) ~= 0 then
				event.switch_dungeon_main_character(0)
			end
		end
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_scene_status_flags(1, 9, 8, 1)
		event.load_item_model(5, 341, "info", 10)
		event.set_character_active(10)
		event.attach_character_to_frame(9, "niku", 10)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_sequence_position(0, 0.0, 140.0, -200.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "持ち上げ停止", 4, -1.0, 1)
		event.set_object_sequence_position(1, 0.0, 140.0, -200.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "肉つかみ飛び", 4)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.enable_drama_skip()
		event.play_sound_effect(var1, 1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-53.68, 35.8, 200.46)
		event.set_camera_sequence_look_at(12.57, 57.95, 3.94)
		event.move_camera_sequence_eased(-53.68, 35.8, 200.46, 12.57, 10.0, 3.94, 30, 2, 1.0)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		var11 = 0.0
		var12 = -10.0
		var13 = 7.0
		var14 = 0.0
		var15 = -3.0
		var16 = 8.0
		var18 = 0
		var17 = 0
		while var17 < 60 do
			event.add_object_sequence_position_offset(1, var11, var12, var13)
			if var17 < 30 then
				event.add_object_sequence_position_offset(0, var11, var12, var13)
			else
				if var17 == 30 then
					event.set_object_sequence_motion(0, "d03着地", 2)
					event.queue_object_sequence_next_motion(0, "立ち", 4)
				end
				do
					local out1, out2, out3 = event.get_character_position(0)
					var19 = out1 or var19
					var20 = out2 or var20
					var21 = out3 or var21
				end
				if var18 == 0 then
					if vm.f32(var20 + var15) <= 0.0 then
						event.set_character_position(0, var19, 0.0, var21)
						var18 = 1
					else
						event.add_object_sequence_position_offset(0, var14, var15, var16)
						var15 = vm.f32(var15 * vm.f32(1.1))
						var16 = vm.f32(var16 * vm.f32(0.8))
					end
				elseif var18 <= 1 then
					do
						local out1, out2, out3, out4 =
							event.get_segment_collision_12(0, var19, 8.0, var21, var19, -8.0, var21, 0)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
						var18 = out4 or var18
					end
					if var18 >= 0 then
						event.set_character_position(0, var22, var23, var24)
					else
						event.set_character_position(0, var19, -0.7, var21)
					end
					var18 = 10
				end
			end
			var12 = vm.f32(var12 * vm.f32(0.9))
			if arg0 == 1 and var17 == 20 then
				event.set_dungeon_map_piece_moving(1)
			end
			var17 = var17 + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		wait_objects(0)
		at = 4
		wait_frames(20)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_camera_sequence_look_at(0.0, 29.0, 100.0)
		event.set_camera_sequence_position(0.0, 41.0, -20.0)
		event.show_dungeon_status_bar(1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 0.0, -1.0, 100.0, 40)
		at = 5
		wait_frames(10)
		if arg0 ~= 0 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		at = 6
		wait_frames(30)
		event.set_object_sequence_motion(0, "立ち")
		at = 7
		wait_frames(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			var11 = 0.0
			var12 = -10.0
			var13 = 7.0
			var14 = 0.0
			var15 = -3.0
			var16 = 8.0
			var18 = 0
			var17 = 0
			local _ = var18 == 0
			var18 = 1
			local _ = vm.f32(var20 + var15) <= 0.0
			var15 = vm.f32(var15 * vm.f32(1.1))
			var16 = vm.f32(var16 * vm.f32(0.8))
			local _ = var18 <= 1
			local _ = var18 >= 0
			var18 = 10
			var12 = vm.f32(var12 * vm.f32(0.9))
			local _ = var17 < 60
			local _ = var17 < 30
			local _ = var17 == 30
			local _ = var17 == 20
			var17 = var17 + 1
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			wait_frames_skipping(20)
		end
		if at <= 4 then
			wait_frames_skipping(10)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(10)
		end
		return true
	end)
	at = 8
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.stop_sound_effect(var1, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_event_image(0)
	if arg0 ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_position(0, 0.0, -1.0, 100.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(0.0, 29.0, 100.0)
	event.set_camera_position(0.0, 41.0, -20.0)
	event.reset_follow_camera(0)
	event.initialize_event()
	event.fade_in_screen(0)
	if var8 ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(var8, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 9
			vm.wait(9)
			at = 10
			helper_479dc9e9()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "aka_fuuin", block)
		end
		if bit32.band(var8, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 11
			vm.wait(11)
			at = 12
			helper_479dc9e9()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "ao_fuuin", block)
		end
		if bit32.band(var8, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 13
			vm.wait(13)
			at = 14
			helper_479dc9e9()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "shiro_fuuin", block)
		end
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 156)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_color(0, 128, 128, 128, 128, 30)
		var25 = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or var25
		event.play_sound_effect(var25, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(var8, 1) ~= 0 then
			event.open_message_window_2(0, "This floor appears to have a Red Seal on it.")
			at = 15
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Max has been chosen by the Red Atlamillia.\nYou can't switch to him!")
			at = 16
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		if bit32.band(var8, 2) ~= 0 then
			event.open_message_window_2(0, "This floor appears to have a Blue Seal on it.")
			at = 17
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Monica has been chosen by the Blue Atlamillia.\nYou can't switch to her!")
			at = 18
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		if bit32.band(var8, 4) ~= 0 then
			event.open_message_window_2(0, "This floor appears to have a White Seal on it.")
			at = 19
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "You can't restore health or cure\nabnormal statuses anymore.")
			at = 20
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Event 1010, which map data, a script or the engine runs by number.
local function event_1010()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		helper_e91d3484()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.reset_action_character_motion(0)
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		event.set_local_event_flag(4, 0)
		event.set_event_projection(524.9)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		var2 = event.get_dungeon_floor_info(stage_id, var1, 7) or var2
		helper_d1646134(stage_id, var1)
		event.initialize_dungeon_floor()
		if var1 == 0 then
			event.go_to_georama_edit(1)
			at = 2
			vm.wait(2)
			return
		end
		if var1 == 8 then
			event.allow_next_music_load()
			event.load_dungeon_map("s17")
			event.load_event_script("s17/s17.stb", 100)
			return
		end
		if var1 == 15 then
			event.skip_next_music_load()
			event.load_dungeon_map("s14")
			event.load_event_script("s14/s14.stb", 100)
			return
		end
		if var1 == 18 then
			event.skip_next_music_load()
			event.load_dungeon_map("s18")
			event.load_event_script("s18/s18.stb", 100)
			return
		end
		if var1 == 23 then
			flag = event.get_save_flag(356) or flag
			if flag == 0 then
				event.load_dungeon_map("s56")
				event.load_event_script("s56/s56.stb", 100)
			else
				event.load_dungeon_map("d03b01")
				event.load_event_script("d03b01/d03b01.stb", 100)
			end
			return
		end
		flag_2 = event.get_save_flag(344) or flag_2
		if var1 == 21 and flag_2 == 0 then
			event.force_start_fishing_tournament()
			event.set_dungeon_pause_flags(2048, 1)
			event.skip_next_music_load()
			event.load_dungeon_map("s45")
			event.load_event_script("s45/s45.stb", 510)
			return
		end
		flag_3 = event.get_save_flag(307) or flag_3
		if var1 == 2 and flag_3 == 0 then
			event.skip_next_music_load()
			event.load_dungeon_map("d03f01", "d03f01", 6)
			at = 3
			helper_3d16f076()
			event.set_dungeon_pause_flags(2048, 1)
			event.skip_next_music_load()
			event.load_dungeon_map("s46")
			event.load_event_script("s46/s46.stb", 510)
			return
		end
		if var1 == 22 then
			event.allow_next_music_load()
			event.stop_music(0)
			at = 4
			wait_frames(6)
			event.load_music(37)
			event.skip_next_music_load()
		end
		if var1 >= 12 and var1 <= 14 then
			event.load_dungeon_map("d03f02s", "d03f02", 6)
		end
		var6 = vm.float_bits(event.get_random_number(100)) or var6
		if var1 >= 1 and var1 <= 7 then
			if vm.imod(var6, 8) == 0 then
				event.load_dungeon_map("d03f01r", "d03f01", 6)
				event.set_dungeon_weather(2)
			else
				event.load_dungeon_map("d03f01", "d03f01", 6)
			end
		end
		if var1 >= 9 and var1 <= 11 or var1 >= 16 and var1 <= 17 then
			if vm.imod(var6, 8) == 0 then
				event.load_dungeon_map("d03f02r", "d03f02", 6)
				event.set_dungeon_weather(2)
			else
				event.load_dungeon_map("d03f02", "d03f02", 6)
			end
		end
		if var1 >= 19 and var1 <= 22 then
			if vm.imod(var6, 8) == 0 then
				event.load_dungeon_map("d03f03r", "d03f03", 6)
				event.set_dungeon_weather(2)
			else
				event.load_dungeon_map("d03f03", "d03f03", 6)
			end
		end
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		event.play_music(0)
		if var1 == 1 and var2 <= 0 then
			at = 5
			helper_3bd7c(0)
		else
			var7 = event.get_dungeon_previous_floor() or var7
			if var1 == var7 then
				at = 6
				helper_3bd7c(0)
			else
				at = 7
				helper_3bd7c(1)
			end
		end
		event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
		helper_6c7de8d8()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_384e16e1(stage_id, var1)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		if at <= 7 then
			if at <= 4 then
				at = 5
				helper_3bd7c(0)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
					helper_6c7de8d8()
					return
				end)
			end
			if at <= 5 then
				at = 6
				helper_3bd7c(0)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
					helper_6c7de8d8()
					return
				end)
			end
			if at <= 6 then
				at = 7
				helper_3bd7c(1)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
					helper_6c7de8d8()
					return
				end)
			end
			helper_1ef0d4b2()
			return 0
		end
		return nil
	end)
end

--- Event 1000, which map data, a script or the engine runs by number.
local function event_1000()
	local var0: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	helper_e91d3484()
	event.fade_out_screen(0)
	var0 = event.get_active_music_number() or var0
	if var0 ~= 17 then
		event.stop_music(0)
		wait_frames(6)
		event.load_music(17)
	end
	event.play_music(0)
	event.load_map_sounds(3601)
	event.open_dungeon_floor_map(2)
	vm.wait(2)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		var2 = out2 or var2
		var3 = out3 or var3
	end
	event.set_dungeon_floor(var3)
	event.set_dungeon_previous_floor(var2)
	event_1010()
end

--- Helper function.
local function helper_41594(arg0: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local item: s32 = 0
	local var6: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local var10: s32 = 0
	local argc_2: s32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.get_local_event_flag(arg0)
	event.set_dungeon_pause_flags(1, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.initialize_event()
		helper_ce85b54c()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_message_bubble_tail(0, 1)
		event.set_dungeon_pause_flags(1, 0)
	else
		var3 = event.get_triggered_event_data_2(6) or var3
		if var3 == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(0, "It's the condor's perch.\n(Use (#) to open the menu.)")
			var4 = helper_c292fa16(0, -1, 5, 256, 208, var4)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if var4 == 1 then
				var3 = 2
			end
			event.finish_event()
		end
		if var3 == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait_frames(6)
			event.open_use_item_menu(341)
			vm.wait(5)
			item = vmhost.used_item() or item
			if item == 341 then
				event.set_local_event_flag(arg0, 1)
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(0, "The condor is overhead, looking this way.")
				helper_75684dd8(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 0)
				event.set_message_window_mode(0, 5)
				var6 = helper_bac0e30d(0, 10, 8, 256, 208, 2, 1)
				if var6 == 0 then
					event.clear_event_battle_monsters(-1)
					helper_7b560508()
					helper_0ba2b71d()
					do
						local out1, out2 = event.get_floor_practice_result(1)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					if cleared == 2 or cleared == 3 then
						event.reset_event_sprite(0)
						event.set_event_sprite_type(0, 0)
						event.set_event_sprite_position(0, 256, 208)
						event.set_event_sprite_size(0, 512, 416)
						event.set_event_sprite_color(0, 0, 0, 0, 128)
						event.set_event_sprite_draw_pass(0, 1)
						event.fade_in_screen(0)
						helper_28a5dd67(-1, cleared, bonus)
						vm.wait(10)
						event.fade_out_screen(0)
						event.set_event_sprite_draw_pass(0, 0)
					end
					stage_id = event.get_dungeon_stage_id() or stage_id
					var10 = event.get_dungeon_floor() or var10
					argc_2 = event.get_dungeon_next_floor(var10, arg0) or argc_2
					event.set_dungeon_floor(argc_2)
					event.set_dungeon_floor_info(stage_id, var10, 5, 2)
					event.set_dungeon_floor_info(stage_id, argc_2, 5, 1)
					event.finish_dungeon_floor()
					event.finish_event()
					event_1000()
				else
					event.add_inventory_item(341)
				end
			elseif item <= 0 then
				event.finish_event()
			else
				helper_5fb66cb1()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			wait_frames(6)
		end
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Helper function.
local function helper_223d4()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local is_play_sub_game: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_clear_most_fast_destroy: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		helper_ce85b54c()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		at = 1
		wait_frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if active_chr_no == 0 then
			at = 2
			helper_4c1ba28b(1)
		end
		if active_chr_no == 1 then
			at = 3
			helper_6c8af328(1)
		end
		if active_chr_no == 2 or active_chr_no == 3 then
			at = 4
			helper_fe9d3952(active_chr_no)
		end
		event.set_dungeon_pause_flags(16384, 0)
		helper_1ef0d4b2()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var2 = event.get_dungeon_floor() or var2
		event.set_dungeon_floor_info(stage_id, var2, 5, 2)
		event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
		flag = event.get_save_flag(220) or flag
		flag = event.get_save_flag(317) or flag
		is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
		if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
			event.clear_random_stones()
			helper_c3f198dd(0, -1)
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_position(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_look_at(position_x, position_y, position_z)
		is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		at = 5
		helper_28a5dd67(is_clear_most_fast_destroy, cleared, bonus)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		var12 = event.is_trial_version() or var12
		var13 = event.get_dungeon_floor_status() or var13
		if
			(if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0 then 1 else bit32.band(var13, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(var13, 1) ~= 0 then
				event.open_message_window_2(0, "The Red Seal has been broken.")
			end
			if bit32.band(var13, 2) ~= 0 then
				event.open_message_window_2(0, "The Blue Seal has been broken.")
			end
			if bit32.band(var13, 4) ~= 0 then
				event.open_message_window_2(0, "The White Seal has been broken.")
			end
			at = 6
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		at = 7
		helper_75684dd8(0, 2130, 8, 0, 0)
		if var12 ~= 1 then
			if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
				at = 8
				helper_75684dd8(0, 2120, 8, 0, 0)
				at = 9
				helper_efb31e92()
			else
				if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					at = 10
					helper_75684dd8(0, 2110, 8, 0, 0)
				end
				if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					at = 11
					helper_75684dd8(0, 2100, 8, 0, 0)
					at = 12
					helper_efb31e92()
				end
			end
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(512, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 12 then
			if at <= 1 then
				at = 2
				helper_4c1ba28b(1)
				return vm.continue_with(function()
					if active_chr_no == 1 then
						at = 3
						helper_6c8af328(1)
					end
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 4
						helper_fe9d3952(active_chr_no)
					end
					event.set_dungeon_pause_flags(16384, 0)
					helper_1ef0d4b2()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					var2 = event.get_dungeon_floor() or var2
					event.set_dungeon_floor_info(stage_id, var2, 5, 2)
					event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						helper_c3f198dd(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_position(position_x, position_y, position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_look_at(position_x, position_y, position_z)
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					helper_28a5dd67(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					var12 = event.is_trial_version() or var12
					var13 = event.get_dungeon_floor_status() or var13
					if
						(
							if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0
								then 1
								else bit32.band(var13, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(var13, 1) ~= 0 then
							event.open_message_window_2(0, "The Red Seal has been broken.")
						end
						if bit32.band(var13, 2) ~= 0 then
							event.open_message_window_2(0, "The Blue Seal has been broken.")
						end
						if bit32.band(var13, 4) ~= 0 then
							event.open_message_window_2(0, "The White Seal has been broken.")
						end
						at = 6
						helper_75684dd8(0, -1, 8, 0, 0)
					end
					at = 7
					helper_75684dd8(0, 2130, 8, 0, 0)
					if var12 ~= 1 then
						if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							helper_75684dd8(0, 2120, 8, 0, 0)
							at = 9
							helper_efb31e92()
						else
							if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								helper_75684dd8(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								helper_75684dd8(0, 2100, 8, 0, 0)
								at = 12
								helper_efb31e92()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_6c8af328(1)
				return vm.continue_with(function()
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 4
						helper_fe9d3952(active_chr_no)
					end
					event.set_dungeon_pause_flags(16384, 0)
					helper_1ef0d4b2()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					var2 = event.get_dungeon_floor() or var2
					event.set_dungeon_floor_info(stage_id, var2, 5, 2)
					event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						helper_c3f198dd(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_position(position_x, position_y, position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_look_at(position_x, position_y, position_z)
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					helper_28a5dd67(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					var12 = event.is_trial_version() or var12
					var13 = event.get_dungeon_floor_status() or var13
					if
						(
							if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0
								then 1
								else bit32.band(var13, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(var13, 1) ~= 0 then
							event.open_message_window_2(0, "The Red Seal has been broken.")
						end
						if bit32.band(var13, 2) ~= 0 then
							event.open_message_window_2(0, "The Blue Seal has been broken.")
						end
						if bit32.band(var13, 4) ~= 0 then
							event.open_message_window_2(0, "The White Seal has been broken.")
						end
						at = 6
						helper_75684dd8(0, -1, 8, 0, 0)
					end
					at = 7
					helper_75684dd8(0, 2130, 8, 0, 0)
					if var12 ~= 1 then
						if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							helper_75684dd8(0, 2120, 8, 0, 0)
							at = 9
							helper_efb31e92()
						else
							if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								helper_75684dd8(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								helper_75684dd8(0, 2100, 8, 0, 0)
								at = 12
								helper_efb31e92()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 3 then
				at = 4
				helper_fe9d3952(active_chr_no)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					helper_1ef0d4b2()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					var2 = event.get_dungeon_floor() or var2
					event.set_dungeon_floor_info(stage_id, var2, 5, 2)
					event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						helper_c3f198dd(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_position(position_x, position_y, position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_look_at(position_x, position_y, position_z)
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					helper_28a5dd67(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					var12 = event.is_trial_version() or var12
					var13 = event.get_dungeon_floor_status() or var13
					if
						(
							if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0
								then 1
								else bit32.band(var13, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(var13, 1) ~= 0 then
							event.open_message_window_2(0, "The Red Seal has been broken.")
						end
						if bit32.band(var13, 2) ~= 0 then
							event.open_message_window_2(0, "The Blue Seal has been broken.")
						end
						if bit32.band(var13, 4) ~= 0 then
							event.open_message_window_2(0, "The White Seal has been broken.")
						end
						at = 6
						helper_75684dd8(0, -1, 8, 0, 0)
					end
					at = 7
					helper_75684dd8(0, 2130, 8, 0, 0)
					if var12 ~= 1 then
						if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							helper_75684dd8(0, 2120, 8, 0, 0)
							at = 9
							helper_efb31e92()
						else
							if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								helper_75684dd8(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								helper_75684dd8(0, 2100, 8, 0, 0)
								at = 12
								helper_efb31e92()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 4 then
				helper_1ef0d4b2()
				helper_a583d6cd(0, -1)
				helper_7870f366(is_clear_most_fast_destroy, cleared, bonus)
			end
			if at <= 5 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 6 then
				helper_ee1c51d0(0, 2130, 8, 0, 0)
			end
			if at <= 7 then
				helper_ee1c51d0(0, 2120, 8, 0, 0)
			end
			if at <= 8 then
				helper_74f9cdb5()
			end
			if at <= 9 then
				helper_ee1c51d0(0, 2110, 8, 0, 0)
			end
			if at <= 10 then
				helper_ee1c51d0(0, 2100, 8, 0, 0)
			end
			if at <= 11 then
				helper_74f9cdb5()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local argc: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	argc = event.get_owned_item_count(10) or argc
	if argc <= 0 then
		event.add_inventory_item(10, 1)
	end
	argc = event.get_owned_item_count(302) or argc
	if argc <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_41594(0)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_41594(1)
end

--- Event 320, which map data, a script or the engine runs by number.
function script.event_320()
	helper_41594(2)
end

--- Event 330, which map data, a script or the engine runs by number.
function script.event_330()
	helper_41594(3)
end

--- Event 340, which map data, a script or the engine runs by number.
script.event_340 = helper_e74dc41f

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 0)
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
		var3 = out4 or var3
	end
	event.set_event_world_coordinate(var0, var1, var2, var3)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_position(0, 0.0, -1.0, 100.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(0.0, 29.0, 100.0)
	event.set_camera_position(0.0, 41.0, -20.0)
	event.reset_follow_camera(0)
	event.show_dungeon_status_bar(1, 1.0)
	helper_ac9d5b12()
	event.fade_in_screen(30)
	vm.wait(1)
	helper_6c7de8d8()
	event.finish_event()
end

script.event_1000 = event_1000

script.event_1010 = event_1010

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = helper_8895171c

--- The dungeon system event run when the player steps into a random circle.
function script.random_circle()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local circle_id: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local angle: f32 = 0
	local var29: s32 = 0
	local var30: s32 = 0
	local bright_rate: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.get_direction_angle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.set_character_position(0, var1, var2, var3)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	helper_ce85b54c()
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	helper_479dc9e9()
	var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or var11
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	helper_479dc9e9()
	weight = event.get_random_circle_motion_frame() or weight
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, weight)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.get_random_number(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.wrap_angle(var14) or var14
	event.set_character_rotation(13, 0.0, var14, 0.0)
	event.change_directory("")
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.wrap_angle(var14) or var14
		event.set_character_rotation(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.play_sound_effect(var11, 0)
		end
		if var18 == 30 then
			helper_92471cb6()
		end
		if (if var18 >= 30 then helper_581cb30c(0) else 0) ~= 0 or var18 > 300 then
			event.stop_sound_effect(var11, 0)
			event.play_sound_effect(var11, 3)
			vm.wait(7)
			break
		else
			var18 = var18 + 1
			vm.wait(8)
		end
	end
	helper_3cf99f2c()
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	var27 = 0
	var27 = vm.float_bits(event.get_random_number(10)) or var27
	var27 = vm.i32(var27 + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.wrap_angle(var14) or var14
		event.set_character_rotation(13, 0.0, var14, 0.0)
		vm.wait(9)
		if var18 >= var27 then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.wrap_angle(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	var26 = var14
	wait_frames(20)
	var29 = vm.float_bits(event.get_random_number(10)) or var29
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if var29 < var30 then
		var29 = vm.float_bits(event.get_random_number(10)) or var29
		if circle_id == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if var29 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.wrap_angle(var26) or var26
			event.rotate_object_sequence(5, 0.0, var26, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait_frames(10)
		else
			var29 = vm.float_bits(event.get_random_number(10)) or var29
			if var29 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				wait_frames(20)
			end
		end
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	var18 = 0
	var32 = event.get_random_circle_effect(circle_id) or var32
	if circle_id == 0 then
		event.play_sound_effect(var11, 1)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(13)
		end
		helper_75684dd8(0, 2310, 8, 0, 0)
		result = event.apply_random_circle_effect(var32) or result
		if var32 == 1 then
			helper_75684dd8(0, 2311, 8, 0, 0)
		end
		if var32 == 2 then
			helper_75684dd8(0, 2312, 8, 0, 0)
		end
		if var32 == 3 then
			helper_75684dd8(0, 2313, 8, 0, 0)
		end
		if var32 == 4 then
			event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_75684dd8(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(var11, 2)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(19)
		end
		helper_75684dd8(0, 2320, 8, 0, 0)
		result = event.apply_random_circle_effect(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_75684dd8(0, 2321, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_75684dd8(0, 2322, 8, 0, 0)
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_75684dd8(0, 2323, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_75684dd8(0, 2324, 8, 0, 0)
			end
			if active_chr_no == 2 then
				helper_75684dd8(0, 2325, 8, 0, 0)
			end
		end
		if var32 == 8 then
			helper_75684dd8(0, 2328, 8, 0, 0)
		end
		if var32 == 9 then
			helper_75684dd8(0, 2326, 8, 0, 0)
		end
		if var32 == 10 then
			helper_75684dd8(0, 2329, 8, 0, 0)
		end
		if var32 == 11 then
			helper_75684dd8(0, 2327, 8, 0, 0)
		end
		if var32 == 12 then
			helper_75684dd8(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if var32 == 1 then
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_camera_position(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_camera_look_at(position_x, position_y, position_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- The dungeon system event run when the player uses the geostone.
function script.geostone()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.set_dungeon_pause_flags(16, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_save_flag(31, 1)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or var4
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.copy_vector(var8, var9, var10)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	var17 = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.wrap_angle(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.wrap_angle(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.set_character_position(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.wrap_angle(var17) or var17
	event.set_character_rotation(0, 0.0, var17, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_chr_no == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var8, var9 + 18.0, var10)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var8, var9 + 18.0, var10)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		pos_x_3 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		pos_y_3 = vm.f32(var9 + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait_frames(16)
	event.play_sound_effect(var4, 0)
	wait_frames(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait_frames(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.get_direction_angle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.set_character_rotation(12, 0.0, var17, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait_frames(20)
	event.play_sound_effect(var4, 1)
	wait_objects(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	helper_75684dd8(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	var23 = event.get_dungeon_floor() or var23
	event.set_dungeon_floor_info(stage_id, var23, 5, 256)
	event.start_crossfade(10)
	if active_chr_no == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, var1, var2, var3)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.set_camera_control_enabled(1)
	event.finish_event()
end

--- The dungeon system event run for a monster that can be talked to.
script.monster_talk = helper_313d0b27

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = helper_223d4

--- The dungeon system event run on the first examination of a random stone.
function script.random_stone_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.set_save_flag(50, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	helper_75684dd8(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Event 2510, which map data, a script or the engine runs by number.
function script.event_2510()
	local var0: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	open_message(0, 2610, 8, 0, 0)
	wait_frames(30)
	do
		local _: any
		_, var0 = wait_message_answer(0, 0, var0)
	end
	close_message(0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the player levels up.
function script.level_up_guide()
	local var0: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	open_message(0, 2620, 8, 0, 0)
	wait_frames(30)
	do
		local _: any
		_, var0 = wait_message_answer(0, 0, var0)
	end
	close_message(0)
	helper_75684dd8(0, 2621, 8, 0, 0)
	helper_75684dd8(0, 2622, 8, 0, 0)
	helper_75684dd8(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "To learn more, see Help under the Main Menu.")
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the ridepod's wheels are used.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Driving the Buggy\n   Speed up with (L)↑; Slow down with (L)↓.\n   Steer with (L) ← or →.\n   For tight coners, [l1] + (L) ← or →."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the magic sword counter fills.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]You have learned how to use Magic-Absorb Blade.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Magic-Absorb Blade is a skill that allows\nyou to absorb the energy of elemental attacks,\nsuch as Fire, while guarding. When you swing your\nsword, it fires back as magic."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"You can continuously charge up\nenergy of one elemental type.\nHowever, if you absorb a different\nelemental type, you lose your whole charge."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"The amount of elemental energy you can absorb\ndepends on the durability of your equipped weapon."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"To release absorbed elemental\nenergy in the form of magic,\npress [l1] while guarding with [r1]."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local level: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: s32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var51: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var57: any = 0
	vm.wait(1)
	event.initialize_event()
	helper_ce85b54c()
	event.set_character_motion(0, "立ち")
	if helper_17b6d01b() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0, 0.1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_4(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	vm.wait(3)
	helper_479dc9e9()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.initialize_effect_manager(5, 1)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var2, var3, var4, var6 = helper_49c6448e(var2, var3, var4, var6)
	helper_1a7fd8eb(var6)
	event.set_sphida_status_panel_visible(1)
	var11 = 12.5
	event.set_sphida_carry_angle(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12, var13, level = helper_39ab7f1f(var12, var13, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, var6, var11 = helper_86f3f24c(var6, var11, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(var8, var9, var10)
			event.set_character_position(8, var8, var9, var10)
			event.set_character_position(9, var8, var9, var10)
			helper_03a1d6f1(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, var12, var6, var16, var15, level = helper_b1b0c1a6(var12, tex_bank, var6, var16, var15, var1, level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(var2, var3, var4)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var21 = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, var2, var3 + 30.0, var4)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait_frames(10)
	end
	if var12 <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait_frames(25)
		if level ~= 4 then
			event.play_sound_effect(var1, 3)
		end
	elseif var12 <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait_frames(34)
		event.play_sound_effect(var1, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait_frames(39)
		if level == 0 then
			event.play_sound_effect(var1, 12)
		else
			event.play_sound_effect(var1, 1)
		end
	end
	if level == 4 then
		wait_frames(50)
		helper_f90045b0(var1)
		event.set_sphida_ball_position(var8, var9, var10)
		event.set_character_position(8, var8, var9, var10)
		event.set_character_position(9, var8, var9, var10)
		helper_03a1d6f1(0)
		return
	end
	if level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	var12 = helper_dff48a5c(var12)
	var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12 = vm.f32(var12 - vm.f32(var12 * var11))
	var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
	var23 = vm.f32(var12 * vm.sin(var11))
	var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
	var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
	var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
	var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var29 = 0
	level = 0
	var42 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, var2, var3 + 5.0, var4, var2, var3, var4, 0)
		var30 = out1 or var30
		var31 = out2 or var31
		var32 = out3 or var32
		var41 = out4 or var41
		var43 = out5 or var43
	end
	if var41 >= 0 and (var43 == 1 or var43 == 7) then
		print("----------------START_MIZU-------------------\n")
		var12 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var12 = 0.0
	end
	var46 = 0
	while true do
		if var3 >= 180.0 then
			var22 = vm.f32(var22 * vm.f32(0.999))
			var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
			var24 = vm.f32(var24 * vm.f32(0.999))
		else
			var41 = event.get_segment_collision_9(12, var2, var3, var4, var2, vm.f32(var3 - 3.0) - vm.f32(0.01), var4, 0)
				or var41
			if level == 1 and var41 >= 0 then
				var22 = vm.f32(var22 * vm.f32(0.94))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.94))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
			else
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(var2, var3, var4, var22, var23, var24)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		if var16 ~= 0.0 then
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			var11 = vm.f32(var11 + var16)
			var11 = event.wrap_angle(var11) or var11
			var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
			var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
		end
		var40 = event.get_vector_length(var15, 0.0, var17) or var40
		if var40 > vm.f32(0.01) then
			var25 = event.get_vector_length(var15, 0.0, var17) or var25
			var11 = event.get_direction_angle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.set_character_rotation(8, var5, var11, var7)
			event.offset_character_rotation(8, var25 * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, var5, var11, var7)
			event.offset_character_rotation(9, var25 * 12.0, 0.0, 0.0)
		else
			var25 = event.get_vector_length(var22, 0.0, var24) or var25
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.set_character_rotation(8, var5, var11, var7)
			event.offset_character_rotation(8, var25 / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, var5, var11, var7)
			event.offset_character_rotation(9, var25 / 10.0, 0.0, 0.0)
		end
		var25 = event.get_vector_length(var22, var23, var24) or var25
		var39 = var25
		var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
		var36 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		var38 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			var2 - var36,
			var3,
			var4 - var38,
			vm.f32(var2 + var36) + var36,
			var3,
			vm.f32(var4 + var38) + var38
		)
		do
			local out1, out2, out3 = event.copy_vector(var22, var23, var24)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 0)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var41 = out4 or var41
			var43 = out5 or var43
		end
		if var41 >= 0 and (var43 == 1 or var43 == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(var30, var31, var32)
			if var42 <= 0 then
				event.play_sound_effect(var1, 11)
				var42 = 10
			end
			if var12 == 0.0 then
				var12 = 1.0
				var22 = vm.f32(var22 * vm.f32(0.4))
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var15 = 0.0
				var17 = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				var12 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
		end
		if var41 < 0 then
			if var3 >= 380.0 and var23 > 0.0 then
				do
					local out1, out2, out3 = event.copy_vector(var2, var3, var4)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
				end
				do
					local out1, out2, out3 = event.copy_vector(var22, -var23, var24)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.normalize_vector(var33, var34, var35)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				var41 = 1
			end
		end
		while var41 >= 0 do
			var16 = 0.0
			if var25 > 8.0 then
				helper_79d90c82()
			end
			if var12 ~= 1.0 and var42 <= 0 then
				event.play_sound_effect(var1, 6)
				var42 = 10
			end
			do
				local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.normalize_vector(var22, var23, var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.scale_vector(var22, var23, var24, 3.0)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.add_vectors(var30, var31, var32, var22, var23, var24)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var30, var31, var32)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var40 = event.get_vector_length(var18, var19, var20) or var40
			var40 = vm.f32(var39 - var40)
			if var40 <= 0.0 then
				break
			else
				var39 = var40
				do
					local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				if var23 < 0.0 and var34 > 0.0 then
					var22 = vm.f32(var15 * 2.0)
					var23 = 0.0
					var24 = vm.f32(var17 * 2.0)
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					if
						var22 < 0.0 and var33 > 0.0
						or var22 > 0.0 and var33 < 0.0
						or var24 < 0.0 and var35 > 0.0
						or var24 > 0.0 and var35 < 0.0
					then
						var15 = 0.0
						var17 = 0.0
					end
					var22 = 0.0
					var23 = 0.0
					var24 = 0.0
				end
				if var12 == 0.0 then
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.9)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.58)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var24)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.8)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.4)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.8)) + var24)
				end
				do
					local out1, out2, out3 = event.copy_vector(var30, var31, var32)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				do
					local out1, out2, out3 = event.copy_vector(var22, var23, var24)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.scale_vector(var33, var34, var35, var40)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.copy_vector(var30, var31, var32)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3 = event.add_vectors(var2, var3, var4, var33, var34, var35)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.get_segment_collision_16(
						12,
						var18,
						var19,
						var20,
						var2 + var36,
						var3 + var37,
						var4 + var38,
						1
					)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
					var33 = out4 or var33
					var34 = out5 or var34
					var35 = out6 or var35
					var41 = out7 or var41
					var43 = out8 or var43
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
			var43 = out8 or var43
		end
		if var41 >= 0 then
			var16 = 0.0
			var3 = vm.f32(var31 + 3.0)
			var40 = event.get_vector_length(var22, 0.0, var24) or var40
			if var40 < vm.f32(2.6) or var23 >= -1.0 and var23 <= 0.0 then
				var23 = 0.0
				level = 1
			else
				if var12 == 0.0 then
					var22 = vm.f32(var22 * vm.f32(0.9))
					var23 = -vm.f32(var23 * vm.f32(0.58))
					var24 = vm.f32(var24 * vm.f32(0.9))
					var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
					var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var22 = vm.f32(var22 * vm.f32(0.8))
					var23 = -vm.f32(var23 * vm.f32(0.4))
					var24 = vm.f32(var24 * vm.f32(0.8))
					var15 = 0.0
					var17 = 0.0
				end
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var12 ~= 1.0 and var42 <= 0 then
					event.play_sound_effect(var1, 5)
					var42 = 10
				end
			end
			var40 = event.get_vector_length(var15, 0.0, var17) or var40
			if var23 == 0.0 and var25 < vm.f32(1.6) and var40 < vm.f32(0.4) then
				if var43 == 6 then
					var29 = 1
					break
				end
				var43 = event.get_automap_attribute_status(var2, var3, var4) or var43
				if not (var43 == 1) then
					break
				end
				var29 = 1
				break
			end
		end
		if var3 < -500.0 then
			var29 = 1
			break
		elseif var46 >= 480 then
			var29 = 1
			break
		else
			var44 = event.get_sphida_pin_color() or var44
			var45 = event.get_sphida_ball_color() or var45
			x = vm.f32(pos_x - var2)
			y = vm.f32(pos_y - var3)
			z = vm.f32(pos_z - var4)
			var47 = event.get_vector_length(x, y, z) or var47
			if var45 ~= var44 then
				var51 = event.get_point_to_segment_distance(var18, var19, var20, var2, var3, var4, pos_x, pos_y, pos_z) or var51
				if var51 >= 0.0 and var51 <= 30.0 then
					var21 = 1
					break
				end
				if var47 ~= 0.0 then
					if var47 <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var47))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.add_vectors(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				else
					var21 = 1
					break
				end
			elseif var47 ~= 0.0 then
				if var47 <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var47))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var2, var3, var4, x, y, z)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var22, var23, var24, x, y, z)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
				end
			end
			event.set_character_position(8, var2, var3, var4)
			event.set_character_position(9, var2, var3, var4)
			do
				local out1, out2, out3 = event.copy_vector(var2, var3, var4)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			if var3 <= -50.0 then
				event.set_follow_camera_following(0)
				if var29 >= 30 then
					if var29 >= 50 then
						break
					end
				else
					event.set_camera_look_at(var2, var3, var4)
				end
				var29 = var29 + 1
			elseif var46 >= 20 then
				event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
				event.set_camera_speed(8.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_target(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24
				)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.get_direction_angle(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_camera_control_rotation(yaw)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(var2, var3, var4)
			vm.wait(15)
			if var42 > 0 then
				var42 = var42 - 1
			end
			var46 = var46 + 1
		end
	end
	event.set_character_position(8, var2, var3, var4)
	event.set_character_position(9, var2, var3, var4)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if var29 == 0 then
		event.set_sphida_ball_position(var2, var3, var4)
		count = event.get_sphida_par() or count
		if var21 == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pos_x, pos_y, pos_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(var1, 17)
			var46 = 0
			while var46 < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var46 = var46 + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var46 = 0
			while var46 < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var46 = var46 + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			var44 = event.get_dungeon_stage_id() or var44
			var45 = event.get_dungeon_floor() or var45
			var41 = event.get_dungeon_floor_info(var44, var45, 4) or var41
			do
				local out1, out2 = event.get_sphida_prize(var41)
				var42 = out1 or var42
				var43 = out2 or var43
			end
			var41 = vm.i32(var41 + 1)
			event.set_dungeon_floor_info(var44, var45, 4, var41)
			event.place_treasure_box(pos_x, pos_y - 30.0, pos_z, var11, var42, var43)
			wait_frames(54)
			wait_frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var1
			event.stop_music(0)
			event.play_sound_effect(var1, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			var42 = event.get_language() or var42
			if var42 == 0 then
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 206, 0, 306, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			end
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			wait_objects(0)
			wait_frames(90)
			vm.wait(22)
			event.play_music(0)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		elseif count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			var57 = helper_bac0e30d(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if var57 == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(var2, var3, var4, 100.0, "point")
					var41 = out1 or var41
					var8 = out2 or var8
					var9 = out3 or var9
					var10 = out4 or var10
				end
				if var41 == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(var2, var3, var4, 100.0)
						var8 = out1 or var8
						var9 = out2 or var9
						var10 = out3 or var10
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var25 = event.get_distance_between(var8, var9, var10, pos_x, pos_y, pos_z) or var25
				if var25 < 40.0 then
					var11 = event.get_random_number(6.2831855) or var11
					var11 = vm.f32(var11 - vm.f32(3.1415927))
					var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
					var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var8, var9, var10)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
						var41 = out4 or var41
					end
					var46 = 0
					while var41 >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(var8, var9, var10)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var30, var31, var32)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						var18 = vm.f32(var18 + 1.0)
						var20 = vm.f32(var20 + 1.0)
						do
							local out1, out2, out3 = event.normalize_vector(var18, var19, var20)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.scale_vector(var18, var19, var20, 30.1)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.copy_vector(var30, var31, var32)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						do
							local out1, out2, out3 = event.add_vectors(var8, var9, var10, var18, var19, var20)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						var46 = var46 + 1
						if var46 > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var8, var9, var10)
							var30 = out1 or var30
							var31 = out2 or var31
							var32 = out3 or var32
							var41 = out4 or var41
						end
					end
				end
				var6 = event.get_direction_angle(var8, var9, var10, var2, var3, var4) or var6
				event.set_character_position(0, var8, var9, var10)
				event.set_character_rotation(0, 0.0, var6, 0.0)
				event.set_camera_look_at(var8, var9 + 30.0, var10)
				var6 = vm.f32(var6 - vm.f32(3.1415927))
				var6 = event.wrap_angle(var6) or var6
				var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
				var9 = vm.f32(var9 + 30.0)
				var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
				event.set_camera_position(var8, var9, var10)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(var1, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		wait_objects(0)
		wait_frames(20)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_sphida_ball_position(var8, var9, var10)
		event.set_character_position(8, var8, var9, var10)
		event.set_character_position(9, var8, var9, var10)
		event.release_camera_sequence_follow_object()
	end
	if var21 == 1 then
		helper_f90045b0(-1)
	else
		helper_f90045b0(var1)
	end
	helper_03a1d6f1(var21)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	var0 = helper_bac0e30d(0, 2004, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		helper_f90045b0(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- The Sphida event run when the menu button is pressed near the ball with fewer than two shots of par left.
function script.sphida_near_ball_last()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "This is the last time you'll be\nable to move the Sphere to you.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Move the Sphere to you?")
	var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Event 4000, which map data, a script or the engine runs by number.
function script.event_4000()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local box_pos_x: f32 = 0
	local box_pos_y: f32 = 0
	local box_pos_z: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		helper_e91d3484()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.set_time_of_day(17.5)
		event.set_time_of_day_advancing(0)
		event.load_dungeon_map("d03f01", "d03f01", 6)
		at = 2
		helper_3bd7c(0)
		helper_c3f198dd(0, -1)
		event.add_inventory_item(305, 1)
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_message_window_mode(0, 5)
		event.set_message_selection_top_line(0, 0)
		at = 3
		var20 = helper_bac0e30d(0, 2002, 8, 256, 208, 2, 0)
		at = 4
		vm.wait(4)
		if var20 == 0 then
			do
				local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(pos_x, pos_y, pos_z, 100.0, "point")
				var0 = out1 or var0
				var9 = out2 or var9
				var10 = out3 or var10
				var11 = out4 or var11
			end
			if var0 == 0 then
				do
					local out1, out2, out3 = event.get_nearest_map_parts_position(pos_x, pos_y, pos_z, 100.0)
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
			end
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			var18 = event.get_distance_between(var9, var10, var11, pos_x_2, pos_y_2, pos_z_2) or var18
			if var18 < 40.0 then
				var19 = event.get_random_number(6.2831855) or var19
				var19 = vm.f32(var19 - vm.f32(3.1415927))
				var9 = vm.f32(var9 + vm.f32(vm.sin(var19) * 50.0))
				var11 = vm.f32(var11 + vm.f32(vm.cos(var19) * 50.0))
			else
				do
					local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var9, var10, var11)
					box_pos_x = out1 or box_pos_x
					box_pos_y = out2 or box_pos_y
					box_pos_z = out3 or box_pos_z
					var0 = out4 or var0
				end
				var1 = 0
				while var0 >= 0 do
					do
						local out1, out2, out3 = event.copy_vector(var9, var10, var11)
						var12 = out1 or var12
						var13 = out2 or var13
						var14 = out3 or var14
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var12, var13, var14, box_pos_x, box_pos_y, box_pos_z)
						var12 = out1 or var12
						var13 = out2 or var13
						var14 = out3 or var14
					end
					do
						local out1, out2, out3 = event.normalize_vector(var12, var13, var14)
						var12 = out1 or var12
						var13 = out2 or var13
						var14 = out3 or var14
					end
					do
						local out1, out2, out3 = event.scale_vector(var12, var13, var14, 30.1)
						var12 = out1 or var12
						var13 = out2 or var13
						var14 = out3 or var14
					end
					do
						local out1, out2, out3 = event.copy_vector(box_pos_x, box_pos_y, box_pos_z)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
					do
						local out1, out2, out3 = event.add_vectors(var9, var10, var11, var12, var13, var14)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
					var1 = var1 + 1
					if var1 > 6 then
						break
					end
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var9, var10, var11)
						box_pos_x = out1 or box_pos_x
						box_pos_y = out2 or box_pos_y
						box_pos_z = out3 or box_pos_z
						var0 = out4 or var0
					end
				end
			end
			var5 = event.get_direction_angle(var9, var10, var11, pos_x, pos_y, pos_z) or var5
			event.set_character_position(0, var9, var10, var11)
			event.set_character_rotation(0, 0.0, var5, 0.0)
			event.set_camera_look_at(var9, var10 + 30.0, var11)
			var5 = vm.f32(var5 - vm.f32(3.1415927))
			var5 = event.wrap_angle(var5) or var5
			var9 = vm.f32(vm.f32(vm.sin(var5) * 100.0) + var9)
			var10 = vm.f32(var10 + 30.0)
			var11 = vm.f32(vm.f32(vm.cos(var5) * 100.0) + var11)
			event.set_camera_position(var9, var10, var11)
			event.reset_follow_camera(0)
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 3 then
				var20 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_3bd7c(0)
				return vm.continue_with(function()
					helper_c3f198dd(0, -1)
					event.add_inventory_item(305, 1)
					do
						local out1, out2, out3 = event.get_sphida_ball_position()
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_message_window_mode(0, 5)
					event.set_message_selection_top_line(0, 0)
					at = 3
					var20 = helper_bac0e30d(0, 2002, 8, 256, 208, 2, 0)
					at = 4
					vm.wait(4)
					if var20 == 0 then
						do
							local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(pos_x, pos_y, pos_z, 100.0, "point")
							var0 = out1 or var0
							var9 = out2 or var9
							var10 = out3 or var10
							var11 = out4 or var11
						end
						if var0 == 0 then
							do
								local out1, out2, out3 = event.get_nearest_map_parts_position(pos_x, pos_y, pos_z, 100.0)
								var9 = out1 or var9
								var10 = out2 or var10
								var11 = out3 or var11
							end
						end
						do
							local out1, out2, out3 = event.get_sphida_pin_position()
							pos_x_2 = out1 or pos_x_2
							pos_y_2 = out2 or pos_y_2
							pos_z_2 = out3 or pos_z_2
						end
						var18 = event.get_distance_between(var9, var10, var11, pos_x_2, pos_y_2, pos_z_2) or var18
						if var18 < 40.0 then
							var19 = event.get_random_number(6.2831855) or var19
							var19 = vm.f32(var19 - vm.f32(3.1415927))
							var9 = vm.f32(var9 + vm.f32(vm.sin(var19) * 50.0))
							var11 = vm.f32(var11 + vm.f32(vm.cos(var19) * 50.0))
						else
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var9, var10, var11)
								box_pos_x = out1 or box_pos_x
								box_pos_y = out2 or box_pos_y
								box_pos_z = out3 or box_pos_z
								var0 = out4 or var0
							end
							var1 = 0
							while var0 >= 0 do
								do
									local out1, out2, out3 = event.copy_vector(var9, var10, var11)
									var12 = out1 or var12
									var13 = out2 or var13
									var14 = out3 or var14
								end
								do
									local out1, out2, out3 =
										event.subtract_vectors(var12, var13, var14, box_pos_x, box_pos_y, box_pos_z)
									var12 = out1 or var12
									var13 = out2 or var13
									var14 = out3 or var14
								end
								do
									local out1, out2, out3 = event.normalize_vector(var12, var13, var14)
									var12 = out1 or var12
									var13 = out2 or var13
									var14 = out3 or var14
								end
								do
									local out1, out2, out3 = event.scale_vector(var12, var13, var14, 30.1)
									var12 = out1 or var12
									var13 = out2 or var13
									var14 = out3 or var14
								end
								do
									local out1, out2, out3 = event.copy_vector(box_pos_x, box_pos_y, box_pos_z)
									var9 = out1 or var9
									var10 = out2 or var10
									var11 = out3 or var11
								end
								do
									local out1, out2, out3 = event.add_vectors(var9, var10, var11, var12, var13, var14)
									var9 = out1 or var9
									var10 = out2 or var10
									var11 = out3 or var11
								end
								var1 = var1 + 1
								if var1 > 6 then
									break
								end
								do
									local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var9, var10, var11)
									box_pos_x = out1 or box_pos_x
									box_pos_y = out2 or box_pos_y
									box_pos_z = out3 or box_pos_z
									var0 = out4 or var0
								end
							end
						end
						var5 = event.get_direction_angle(var9, var10, var11, pos_x, pos_y, pos_z) or var5
						event.set_character_position(0, var9, var10, var11)
						event.set_character_rotation(0, 0.0, var5, 0.0)
						event.set_camera_look_at(var9, var10 + 30.0, var11)
						var5 = vm.f32(var5 - vm.f32(3.1415927))
						var5 = event.wrap_angle(var5) or var5
						var9 = vm.f32(vm.f32(vm.sin(var5) * 100.0) + var9)
						var10 = vm.f32(var10 + 30.0)
						var11 = vm.f32(vm.f32(vm.cos(var5) * 100.0) + var11)
						event.set_camera_position(var9, var10, var11)
						event.reset_follow_camera(0)
					end
					return
				end)
			end
			if at <= 2 then
				helper_a583d6cd(0, -1)
				var20 = helper_7d54f41c(0, 2002, 8, 256, 208, 2, 0)
			end
			var19 = vm.f32(var19 - vm.f32(3.1415927))
			var9 = vm.f32(var9 + vm.f32(vm.sin(var19) * 50.0))
			var11 = vm.f32(var11 + vm.f32(vm.cos(var19) * 50.0))
			var1 = 0
			var1 = var1 + 1
			var5 = vm.f32(var5 - vm.f32(3.1415927))
			var9 = vm.f32(vm.f32(vm.sin(var5) * 100.0) + var9)
			var10 = vm.f32(var10 + 30.0)
			var11 = vm.f32(vm.f32(vm.cos(var5) * 100.0) + var11)
			return 0
		end
		return nil
	end)
end

--- Event 13070, which map data, a script or the engine runs by number.
function script.event_13070()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_b2cb6e46()
		event.load_dungeon_map("d03f01", "d03f01", 6)
		at = 2
		helper_3d16f076()
		event.skip_next_music_load()
		event.load_dungeon_map("s46")
		event.load_event_script("s46/s46.stb", 510)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_3d16f076()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s46")
					event.load_event_script("s46/s46.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 13080, which map data, a script or the engine runs by number.
function script.event_13080()
	helper_b2cb6e46()
	event.set_save_flag(308, 0)
	event.load_dungeon_map("s17")
	event.load_event_script("s17/s17.stb", 13080)
end

--- Event 13120, which map data, a script or the engine runs by number.
function script.event_13120()
	helper_b2cb6e46()
	event.set_save_flag(312, 0)
	event.load_dungeon_map("s17")
	event.load_event_script("s17/s17.stb", 13120)
end

--- Event 13170, which map data, a script or the engine runs by number.
function script.event_13170()
	helper_b2cb6e46()
	event.set_save_flag(317, 0)
	event.load_dungeon_map("s17")
	event.load_event_script("s17/s17.stb", 13170)
end

--- Event 13320, which map data, a script or the engine runs by number.
function script.event_13320()
	helper_b2cb6e46()
	event.load_dungeon_map("s18")
	event.load_event_script("s18/s18.stb", 13320)
end

--- Event 13360, which map data, a script or the engine runs by number.
function script.event_13360()
	helper_b2cb6e46()
	event.load_dungeon_map("s18")
	event.load_event_script("s18/s18.stb", 13360)
end

--- Event 13400, which map data, a script or the engine runs by number.
function script.event_13400()
	helper_b2cb6e46()
	event.load_dungeon_map("s18")
	event.load_event_script("s18/s18.stb", 13400)
end

--- Event 13480, which map data, a script or the engine runs by number.
function script.event_13480()
	helper_b2cb6e46()
	event.set_save_flag(348, 0)
	event.load_dungeon_map("s56")
	event.load_event_script("s56/s56.stb", 13480)
end

--- Event 13520, which map data, a script or the engine runs by number.
function script.event_13520()
	helper_b2cb6e46()
	event.set_save_flag(352, 0)
	event.load_dungeon_map("s56")
	event.load_event_script("s56/s56.stb", 13520)
end

--- Event 23020, which map data, a script or the engine runs by number.
function script.event_23020()
	local argc: s32 = 0
	helper_b2cb6e46()
	event.set_character_max_hp(0, 64)
	event.set_character_max_hp(1, 64)
	event.set_character_defence(0, 16)
	event.set_character_defence(1, 16)
	argc = event.get_item_count(270) or argc
	if argc < 20 then
		event.add_inventory_item(270, vm.i32(20 - argc))
	end
	event.add_inventory_item(18)
	event.equip_character_item(0, 18)
	event.add_inventory_item(28)
	event.equip_character_item(0, 28)
	event.add_inventory_item(48)
	event.equip_character_item(1, 48)
	event.add_inventory_item(92)
	event.equip_character_item(1, 92)
	event.load_dungeon_map("s18")
	vm.wait(2)
	event.load_event_script("s18/s18.stb", 23020)
end

--- Event 23030, which map data, a script or the engine runs by number.
function script.event_23030()
	helper_b2cb6e46()
	event.load_dungeon_map("d03b02")
	event.load_event_script("d03b02/d03b02.stb", 23030)
end

--- Event 26020, which map data, a script or the engine runs by number.
function script.event_26020()
	local argc: s32 = 0
	helper_b2cb6e46()
	event.set_character_max_hp(0, 160)
	event.set_character_max_hp(1, 160)
	event.set_character_defence(0, 50)
	event.set_character_defence(1, 50)
	argc = event.get_item_count(270) or argc
	if argc < 20 then
		event.add_inventory_item(270, vm.i32(20 - argc))
	end
	event.add_inventory_item(16)
	event.equip_character_item(0, 16)
	event.add_inventory_item(27)
	event.equip_character_item(0, 27)
	event.add_inventory_item(71)
	event.equip_character_item(1, 71)
	event.add_inventory_item(100)
	event.equip_character_item(1, 100)
	event.load_dungeon_map("s14")
	vm.wait(2)
	event.load_event_script("s14/s14.stb", 26020)
end

return script
