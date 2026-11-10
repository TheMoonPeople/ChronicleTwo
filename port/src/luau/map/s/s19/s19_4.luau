--!strict
-- map/s/s19/s19_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_013b7e59 = require("@lib/event/helper_013b7e59")
local helper_0f67d486 = require("@lib/event/helper_0f67d486")
local helper_3d13e6aa = require("@lib/event/helper_3d13e6aa")
local helper_3e84c83c = require("@lib/event/helper_3e84c83c")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7d6d40d6 = require("@lib/event/helper_7d6d40d6")
local helper_80432060 = require("@lib/event/helper_80432060")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_8e4884b7 = require("@lib/event/helper_8e4884b7")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d2e16403 = require("@lib/event/helper_d2e16403")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	event.load_map_sounds(4684)
	flag = event.get_save_flag(408) or flag
	flag_2 = event.get_save_flag(420) or flag_2
	var2 = event.get_save_data_value(2) or var2
	if flag == 1 and flag_2 == 0 and var2 == 1 then
	else
		event.stop_music(0)
		wait_frames(4)
		event.load_music(167)
		event.play_music(0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		event_99()
		flag = event.get_save_flag(400) or flag
		flag_2 = event.get_save_flag(408) or flag_2
		flag_3 = event.get_save_flag(420) or flag_3
		if flag == 1 then
			if flag_2 == 0 then
				at = 2
				helper_0f67d486()
				event.go_to_georama_edit(75, 500)
				return
			end
			if flag_3 == 0 then
				var3 = event.get_save_data_value(2) or var3
				if var3 ~= 0 then
					at = 3
					helper_3d13e6aa(1)
					at = 4
					helper_80432060()
					event.set_save_control_bits(1, 1)
					return
				else
					at = 5
					helper_013b7e59()
					event.stop_all_sounds()
					at = 6
					wait_frames(6)
					event.load_music(18)
					event.load_map_sounds(4601)
					event.play_music(0)
					event.load_event_script("d04/d04.stb", 1000)
					return
				end
			else
				at = 7
				helper_8e4884b7()
			end
		else
			at = 8
			helper_8e4884b7()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_0f67d486()
				return vm.continue_with(function()
					event.go_to_georama_edit(75, 500)
					return
				end)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				at = 4
				helper_80432060()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					return
				end)
			end
			return 0
		end
		if at <= 6 then
			if at <= 5 then
				wait_frames_skipping(6)
			end
			return 0
		end
		if at <= 8 then
			if at <= 7 then
				at = 8
				helper_8e4884b7()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_0f67d486

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.fade_in_screen(30)
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -29.1, 1.4, 787.9)
	event.set_dungeon_pause_flags(17, 0)
	event.load_dungeon_monster(516, 1)
	event.load_dungeon_monster(1001, 0)
	event.place_dungeon_monster(516, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	event.get_character_position(0)
	event.finish_event()
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 153, which map data, a script or the engine runs by number.
function script.event_153()
	local at: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(1, 1)
		event.fade_out_screen(0)
		event.set_dungeon_pause_flags(16, 1)
		at = 1
		wait_frames(30)
		event.fade_in_screen(30)
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_7d6d40d6()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_7d6d40d6()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 154, which map data, a script or the engine runs by number.
function script.event_154()
	event.set_camera_look_at(-33.22, 3.88, 763.5)
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 155, which map data, a script or the engine runs by number.
script.event_155 = helper_80432060

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	event.initialize_event()
	var0 = event.has_save_control_bits(1) or var0
	if var0 == 1 then
		event.set_dungeon_pause_flags(9, 1)
		event.reset_action_character_motion(0)
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Fareste meglio a dare questo\npesce a Shingala... e in fretta!")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_dungeon_pause_flags(9, 0)
		return
	end
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_character_motion(0, "立ち")
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	if helper_3e84c83c(0) ~= 0 then
		event.load_event_script("d04/d04.stb", 1000)
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	event.initialize_event()
	var0 = event.has_save_control_bits(1) or var0
	if var0 == 1 then
		event.set_dungeon_pause_flags(9, 1)
		event.reset_action_character_motion(0)
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Fareste meglio a dare questo\npesce a Shingala... e in fretta!")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_dungeon_pause_flags(9, 0)
		return
	end
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_character_motion(0, "立ち")
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	if helper_3e84c83c(1) ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		var3 = event.get_dungeon_floor() or var3
		argc = event.get_dungeon_next_floor(var3, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var3, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.stop_music(0)
		event.stop_environment_music()
		event.stop_map_object_sounds()
		wait_frames(6)
		event.load_music(18)
		event.load_map_sounds(4601)
		event.play_music(0)
		event.load_event_script("d04/d04.stb", 1000)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		event.clear_event_battle_monsters(-1)
		event.set_save_data_value(4)
		event.set_save_control_bits(1, 0)
		at = 3
		helper_3d13e6aa(0)
		at = 4
		helper_7d6d40d6()
		event.skip_next_music_load()
		event.go_to_georama_edit(75, 100)
		at = 5
		vm.wait(5)
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 2 then
				helper_4a9b8bc5(0)
			end
			if at <= 3 then
				at = 4
				helper_7d6d40d6()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(75, 100)
					at = 5
					vm.wait(5)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	helper_d2e16403()
	event.set_dungeon_pause_flags(1, 0)
	var0 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_dungeon_pause_flags(16384, 1)
	event.save_music_status(-1)
	var1 = event.get_event_sound_bank(4) or var1
	argc = event.get_sound_effect_status(var1, 0) or argc
	battle_bgm_vol = event.get_battle_music_volume() or battle_bgm_vol
	event.stop_sound_effect(var1, 0)
	event.stop_music(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover/gameover_1.json")
	wait_frames(30)
	helper_479dc9e9()
	event.load_music_pack(60)
	event.play_music(0)
	wait_frames(30)
	event.set_dungeon_pause_flags(1, 1)
	event.reset_dungeon_collision_primitives()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"Oh, no! Shingala [UNI00e8] morto... Come\nriportiamo il futuro alla normalit[UNI00e0] senza di lui?"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 0) or block
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
	wait_frames(120)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(8)
		end
	end
	debug_flag = event.get_debug_flag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.run_dungeon_debug_command(0)
		event.reset_action_character_motion(0, 4)
	else
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		if active_chr_no == 2 then
			event.clear_effect_manager()
		end
		event.stop_music(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(0)
		if var0 == 1 then
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
	wait_frames(4)
	load_no = event.get_saved_music_number() or load_no
	event.load_music(load_no)
	event.restore_music_status(-1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(0)
	boss_map = event.is_dungeon_boss_floor() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.play_sound_effect(var1, 0)
			event.set_sound_effect_volume(var1, 0, battle_bgm_vol)
		end
	end
	event.set_camera_control_enabled(1)
	event.show_dungeon_status_bar(1, 1.0)
	if debug_flag ~= 1 then
		event.fade_in_screen(30)
	end
	event.set_dungeon_pause_flags(16385, 0)
	event.finish_event()
	return 0
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Se colpisci Shingala, si arrabbier[UNI00e0] e si\n   avviciner[UNI00e0] a te.\n   Allora spalancher[UNI00e0] la bocca<page>   e cos[UNI00ec] tu potrai tirarci\n   dentro il Pesce Elettrico!"
	)
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(416) or flag
		flag_2 = event.get_save_flag(420) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_47084b1b(0, 8610060)
			else
				at = 2
				helper_47084b1b(0, 8610070)
			end
			return
		end
		at = 3
		helper_f0ee9a01(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8610070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 14080, which map data, a script or the engine runs by number.
function script.event_14080()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 0)
		at = 1
		event_99()
		at = 2
		helper_0f67d486()
		event.clear_event_running_flag()
		event.go_to_georama_edit(75, 500)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_0f67d486()
				return vm.continue_with(function()
					event.clear_event_running_flag()
					event.go_to_georama_edit(75, 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14100, which map data, a script or the engine runs by number.
function script.event_14100()
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		event.set_save_flag(410, 0)
		at = 1
		event_99()
		at = 2
		helper_013b7e59()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_013b7e59()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14160, which map data, a script or the engine runs by number.
function script.event_14160()
	local at: number = 0
	return vm.guard(function()
		at = 1
		event_99()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		at = 2
		helper_80432060()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_80432060()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14200, which map data, a script or the engine runs by number.
function script.event_14200()
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		event.set_save_flag(416, 1)
		at = 1
		event_99()
		at = 2
		helper_7d6d40d6()
		event.clear_event_running_flag()
		event.skip_next_music_load()
		event.go_to_georama_edit(75, 100)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_7d6d40d6()
				return vm.continue_with(function()
					event.clear_event_running_flag()
					event.skip_next_music_load()
					event.go_to_georama_edit(75, 100)
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

return script
