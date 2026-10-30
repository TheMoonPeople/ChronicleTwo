--!strict
-- Shared event helper used by 155 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_54207bc4 = require("@lib/event/helper_54207bc4")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_959b4d0c = require("@lib/event/helper_959b4d0c")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")
local helper_f0a13ee2 = require("@lib/event/helper_f0a13ee2")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_81e9bf9c(arg0: any, arg1: any)
	local var2: s32 = 0
	local boss_map: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local var10: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		var2 = event.get_dungeon_pause_flags(16384) or var2
		if var2 ~= 16384 then
			event.set_dungeon_pause_flags(16384, 1)
		end
		boss_map = event.is_dungeon_boss_floor() or boss_map
		event.save_music_status(-1)
		if var2 ~= 16384 and boss_map ~= 1 then
			var4 = event.get_event_sound_bank(4) or var4
			argc = event.get_sound_effect_status(var4, 0) or argc
			battle_bgm_vol = event.get_battle_music_volume() or battle_bgm_vol
			event.stop_sound_effect(var4, 0)
			print("---------------------------------------------BATTLE BGM STOP\n")
		end
		event.stop_music(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 or active_chr_no == 1 then
			event.set_character_texture_animation(0, 0, "目パチ")
			event.set_character_texture_animation(0, 1, "死に")
		end
		if active_chr_no == 2 then
			event.set_action_character_motion(0, "故障", 6)
			event.initialize_effect_manager(5, 1)
			event.load_effect_base("ロボ故障")
			event.create_effect_work_buffer(5)
			event.create_effect("ロボ故障")
		end
		var8 = 0
		if active_chr_no == 2 then
			var8 = event.get_character_change_state(0) or var8
			if var8 == 0 then
				var8 = event.get_character_change_state(1) or var8
			end
		end
		if active_chr_no == 0 then
			var8 = event.get_character_change_state(1) or var8
		end
		if active_chr_no == 1 then
			var8 = event.get_character_change_state(0) or var8
		end
		if active_chr_no == 3 then
			var8 = event.get_character_change_state(1) or var8
			if var8 == 0 then
				var8 = event.get_character_change_state(0) or var8
			end
		end
		event.start_background_file_loads_3(
			"snd2/bgm/bg_060.sound.json",
			"textures/dungeon/image/gameover/gameover_1.json",
			"event/boss_btl_lose_1.txt"
		)
		at = 1
		wait_frames(30)
		event.show_dungeon_status_bar(0, 0.06666667)
		at = 2
		helper_479dc9e9()
		event.load_music_pack(60)
		if var8 == 1 or var8 ~= 1 and arg1 < 0 then
			event.play_music(0)
		end
		at = 3
		wait_frames(30)
		event.set_dungeon_pause_flags(1, 1)
		event.reset_dungeon_collision_primitives()
		if var8 ~= 1 then
			block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 1) or block
			if arg1 >= 0 then
				set_window_mode(0, 7)
				event.load_message_file(0, 5, "event/boss_btl_lose_1.txt")
				at = 4
				helper_f0a13ee2(arg1, -1, 10)
				at = 5
				wait_frames(10)
				event.load_message_file(0, -1)
				event.play_music(0)
			end
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "gameover1", block)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
			event.set_event_sprite_size(0, 576, 128)
			event.set_event_sprite_position(0, -320, 208)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.move_object_sequence(0, 288, 208, 0.0, 20)
			at = 6
			wait_frames(30)
			event.reset_event_sprite(1)
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_texture(1, "gameover1", block)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
			event.set_event_sprite_size(1, 576, 64)
			event.set_event_sprite_position(1, 256, 208)
			event.set_event_sprite_draw_pass(1, 1)
			event.attach_object_handle_to_sprite(1, 1)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
			at = 7
			wait_frames(120)
			while true do
				if helper_581cb30c(0) ~= 0 then
					break
				end
				at = 8
				vm.wait(8)
			end
		elseif active_chr_no == 3 then
			var10 = event.get_character_change_state(1) or var10
			if var10 == 0 then
				at = 9
				helper_959b4d0c(1)
			else
				at = 10
				helper_959b4d0c(4)
			end
		elseif active_chr_no == 0 or active_chr_no == 2 then
			at = 11
			helper_959b4d0c(active_chr_no)
		else
			at = 12
			helper_959b4d0c(1)
		end
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 1 then
			event.run_dungeon_debug_command(0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			if active_chr_no == 2 then
				event.clear_effect_manager()
			end
			if active_chr_no == 0 or active_chr_no == 1 then
				event.set_character_texture_animation(0, 0, "死に")
				event.set_character_texture_animation(0, 1, "目パチ")
			end
			event.reset_action_character_motion(0, 4)
		elseif var8 == 1 then
			event.fade_out_screen(30)
			at = 13
			wait_frames(30)
			if active_chr_no == 2 then
				event.clear_effect_manager()
			end
			event.open_dungeon_character_change_menu(-1)
			at = 14
			vm.wait(14)
			event.fade_out_screen(0)
		else
			event.fade_out_music(30)
			event.fade_out_screen(30)
			at = 15
			wait_frames(30)
			if active_chr_no == 2 then
				event.clear_effect_manager()
			end
			event.stop_music(0)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_event_sprite_draw_pass(1, 0)
			event.delete_event_image(1)
			if arg0 == 1 then
				event.add_hp_by_rate(1.0, 0)
				event.add_battle_weapon_durability(0, 999)
				event.add_battle_weapon_durability(1, 999)
				event.run_dungeon_event(-1)
				event.clear_event_battle_monsters(-1)
				event.set_dungeon_pause_flags(1, 0)
				event.finish_event()
				return 1
			else
				event.set_scene_exit_flag(1)
				event.finish_event()
				return 0
			end
		end
		event.stop_music(0)
		at = 16
		wait_frames(4)
		load_no = event.get_saved_music_number() or load_no
		event.load_music(load_no)
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		event.restore_music_status(-1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(1)
		if var2 ~= 16384 and boss_map ~= 1 then
			if argc == 1 then
				print("---------------------------------------------BATTLE BGM PLAY\n")
				event.play_sound_effect(var4, 0)
				event.set_sound_effect_volume(var4, 0, battle_bgm_vol)
			end
		end
		event.set_camera_control_enabled(1)
		event.show_dungeon_status_bar(1, 1.0)
		if debug_flag ~= 1 then
			event.fade_in_screen(10)
		end
		if var2 ~= 16384 then
			event.set_dungeon_pause_flags(16385, 0)
		else
			event.set_dungeon_pause_flags(1, 0)
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 15 then
			if at <= 1 then
				helper_344d6cd8()
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			if at <= 3 then
				helper_fbd9683d(0, 7)
				helper_2f8c501c(arg1, -1, 10)
			end
			if at <= 4 then
				wait_frames_skipping(10)
			end
			if at <= 5 then
				wait_frames_skipping(30)
			end
			if at <= 6 then
				wait_frames_skipping(120)
			end
			if at <= 8 then
				helper_54207bc4(1)
			end
			if at <= 9 then
				local _ = helper_dbff9fb6(0)
				helper_54207bc4(4)
			end
			if at <= 10 then
				helper_54207bc4(active_chr_no)
			end
			if at <= 11 then
				helper_54207bc4(1)
			end
			if at <= 12 then
				wait_frames_skipping(30)
			end
			if at <= 14 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
			print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

return helper_81e9bf9c
