--!strict
-- map/s/s06/s06_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_126fe783 = require("@lib/event/helper_126fe783")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_3bce1a2c = require("@lib/event/helper_3bce1a2c")
local helper_46574a08 = require("@lib/event/helper_46574a08")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_4d5f00f9 = require("@lib/event/helper_4d5f00f9")
local helper_5a05ed59 = require("@lib/event/helper_5a05ed59")
local helper_68186cf4 = require("@lib/event/helper_68186cf4")
local helper_69eefc83 = require("@lib/event/helper_69eefc83")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_78df2e5b = require("@lib/event/helper_78df2e5b")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d4f5fdae = require("@lib/event/helper_d4f5fdae")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_fab3eef4 = require("@lib/event/helper_fab3eef4")
local helper_fc872710 = require("@lib/event/helper_fc872710")
local wait_frames = require("@lib/event/wait_frames")

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
local function edit_analyze_changed()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	event.reset_action_character_motion(0)
	flag = event.get_save_flag(7) or flag
	if flag == 0 then
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		var2 = event.set_party_member(2) or var2
		if var2 ~= 0 then
			var1 = event.get_message_window_frame(0) or var1
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "[UNI00a1]Ahora no hay tiempo para eso!")
			helper_75684dd8(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, var1)
			vm.wait(2)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		else
			event.set_character_motion(0, "立ち")
			var1 = event.get_message_window_frame(0) or var1
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			flag = event.get_save_flag(104) or flag
			if flag == 1 then
				event.open_message_window_2(0, "La puerta no se abre.\nHabr[UNI00e1] que volver, de momento.")
			else
				event.open_message_window_2(0, "[UNI00a1]Ahora no hay tiempo para eso!")
			end
			helper_75684dd8(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, var1)
			vm.wait(4)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
	end
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "No podr[UNI00e1]s avanzar\na no ser que te bajes del\nRidepod.")
		helper_75684dd8(0, -1, 8, 256, 208)
		event.finish_event()
		return
	end
	if active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		helper_75684dd8(0, 21, 8, 256, 208)
		event.finish_event()
		return
	end
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	var5 = helper_ed4dc120(1, -1)
	if var5 == 0 then
		event.set_save_control_bits(1, 0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var7 = event.get_dungeon_floor() or var7
		argc = event.get_dungeon_next_floor(var7, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var7, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.fade_out_screen(30)
		wait_frames(30)
		flag = event.get_save_flag(8) or flag
		if flag == 0 then
			event.stop_music(0)
			event.set_save_flag(8, 1)
			event.skip_next_music_load()
			event.go_to_georama_edit(12, 540)
			vm.wait(9)
			return
		end
		event.skip_next_music_load()
		event.go_to_dungeon(0, 5, 1000)
		vm.wait(10)
	end
	event.finish_event()
end

--- Helper function.
local function helper_17d54(arg0: any)
	local var1: s32 = 0
	event.set_camera_sequence_position(-276.53, 81.94, 10.07)
	event.set_camera_sequence_look_at(31.75, 72.44, -9.51)
	event.set_object_sequence_position(0, -165.91, 50.0, 2.54)
	event.set_object_sequence_rotation(0, 0.0, 1.65, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -165.91, 50.0, 2.54)
	event.set_object_sequence_rotation(1, 0.0, 1.65, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	wait_frames(30)
	var1 = event.get_message_window_frame() or var1
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]Puedes usar el Ridepod mediante la\nopci[UNI00f3]n Ridepod del apartado Personaje\n del men[UNI00fa] Principal.<page>Cuando quieras bajarte, elige\nMax en el apartado Personaje."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Cedric puede llenar el dep[UNI00f3]sito del\nRidepod por ti.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Cuando el Ridepod aumente\nen Gasto, Cedric puede\n Mejorar el N[UNI00fa]cleo del Ridepod.<page>La Capacidad del N[UNI00fa]cleo para equipar m[UNI00e1]s\npiezas aumentar[UNI00e1] tambi[UNI00e9]n."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Incrementa la Capacidad del N[UNI00fa]cleo e intenta\ninstalar varias piezas para\nconstruir tu propio Ridepod."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, var1)
end

--- Helper function.
local function helper_18550()
	local var0: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		var0 = event.load_sound_effect_file_2(1819) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_position(6.02, 94.24, 399.23)
		event.set_camera_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(9, 0.0, 50.0, 0.0)
		event.set_character_rotation(9, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_position(10, 0.0, 50.0, 0.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_position(9, 0.0, 50.0, 0.0)
		event.set_character_rotation(9, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(11, 2)
		event.set_object_handle_visible(11, 0)
		event.load_message_file(0, 5, "event/e100/e108/e108a_1.txt")
		event.stop_music(0)
		event.enable_drama_skip()
		helper_46574a08(var0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "おこり顔")
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		helper_fc872710(var0)
		helper_3bce1a2c(var0)
		helper_4d5f00f9(var0)
		helper_78df2e5b(var0)
		helper_17d54(var0)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.stop_sound_effect(var0, 2)
	event.set_character_active(1, 0)
	event.attach_object_handle_to_character(10, 1)
	event.set_object_handle_visible(10, 0)
	event.attach_object_handle_to_character(11, 2)
	event.set_object_handle_visible(11, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.set_camera_position(-276.53, 81.94, 10.07)
	event.set_camera_look_at(31.75, 72.44, -9.51)
	event.reset_follow_camera(0)
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.set_character_position(0, -167.59, 50.0, 2.86)
	event.set_character_rotation(0, 0.0, 1.77, 0.0)
	event.show_dungeon_status_bar(1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(15)
	event.play_music(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
	vm.wait(11)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_d4f5fdae

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.set_character_position(0, -240.84, 50.0, -5.32)
	event.set_character_rotation(0, 0.0, 1.6, 0.0)
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 300, which map data, a script or the engine runs by number.
script.event_300 = edit_analyze_changed

script.edit_analyze_changed = edit_analyze_changed

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	helper_fab3eef4()
	flag = event.get_save_flag(7) or flag
	if flag == 0 then
		flag = event.get_save_flag(106) or flag
		flag_2 = event.get_save_flag(104) or flag_2
		var2 = event.set_party_member(2) or var2
		if (if flag == 1 then var2 else 0) ~= 0 or flag_2 == 0 then
			event.set_save_control_bits(1, 1)
			helper_68186cf4(1)
		end
	end
	event.set_function_point_enabled("", "dun_out", 0)
	flag = event.get_save_flag(7) or flag
	if flag == 1 then
		event.set_function_point_enabled("p01_s06", "doa1", 0)
		event.set_function_point_enabled("p01_s06", "doa0", 1)
		flag = event.get_save_flag(109) or flag
		if flag ~= 0 then
			event.set_function_point_enabled("", "dun_out", 1)
		end
	else
		event.set_function_point_enabled("p01_s06", "doa1", 0)
		event.set_function_point_enabled("p01_s06", "doa0", 1)
		var2 = event.set_party_member(2) or var2
		if var2 == 0 then
			flag = event.get_save_flag(105) or flag
			if flag == 1 then
				event.set_function_point_enabled("", "dun_out", 1)
			end
		else
			event.set_function_point_enabled("", "dun_out", 0)
		end
	end
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	flag = event.get_save_flag(103) or flag
	if flag == 0 then
		helper_68186cf4(1)
		event.load_event_script("s06/s06b_1.stb", 500)
		return
	else
		var2 = event.set_party_member(2) or var2
		if var2 ~= 0 then
			flag = event.get_save_flag(25) or flag
			if flag == 1 then
				event.set_save_flag(5, 0)
				flag = event.get_save_flag(6) or flag
				if flag == 0 then
					event.fade_out_screen(0)
					event.set_save_flag(6, 1)
					event.load_event_script("s06/s06b_1.stb", 510)
					return
				else
					flag = event.get_save_flag(7) or flag
					if flag == 0 then
						event.fade_out_screen(0)
						event.load_event_script("s06/s06b_1.stb", 520)
						return
					else
						helper_d4f5fdae()
					end
				end
			else
				helper_d4f5fdae()
			end
		else
			event.set_save_flag(5, 0)
			flag = event.get_save_flag(7) or flag
			if flag == 1 then
				helper_d4f5fdae()
			else
				var2 = event.set_party_member(2) or var2
				if var2 == 0 then
					flag = event.get_save_flag(105) or flag
					if flag == 1 then
						helper_d4f5fdae()
					end
				else
					event.load_dungeon_monster(601, 1)
					helper_d4f5fdae()
					event.initialize_event()
					event.place_dungeon_monster(601, -36.31, 50.0, 1.24, 0.0, 0.0, 0.0)
					event.finish_event()
				end
			end
		end
	end
	event.fade_in_screen(30)
	event.finish_event()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.initialize_event()
	event.load_event_script("s06/s06c_1.stb", 500)
	vm.wait(1)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.initialize_event()
		event.set_save_flag(7, 1)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		helper_68186cf4(0)
		event.set_dungeon_pause_flags(17, 1)
		at = 2
		helper_18550()
		event.clear_event_battle_monsters(-1)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_4a9b8bc5(0)
				at = 2
				helper_18550()
				return vm.continue_with(function()
					event.clear_event_battle_monsters(-1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local at: number = 0
	return vm.guard(function()
		event.set_save_control_bits(1, 0)
		helper_68186cf4(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.add_hp_by_rate(1.0, 0)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_dungeon_pause_flags(17, 1)
		at = 2
		helper_69eefc83()
		event.skip_next_music_load()
		event.go_to_georama_edit(10, 531)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_69eefc83()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(10, 531)
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

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.fade_out_screen(0)
	helper_126fe783()
end

--- Event 505, which map data, a script or the engine runs by number.
function script.event_505()
	event.load_event_script("s06/06c_1.stb", 500)
	vm.wait(1)
end

--- Event 506, which map data, a script or the engine runs by number.
function script.event_506()
	event.load_event_script("s06/06c_1.stb", 500)
	vm.wait(1)
end

--- Event 507, which map data, a script or the engine runs by number.
function script.event_507()
	event.fade_out_screen(0)
	event.set_save_flag(6, 1)
	event.load_event_script("s06/s06b_1.stb", 510)
	vm.wait(1)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	local active_chr_no: s32 = 0
	local var1: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	event.set_message_window_mode(0, 5)
	var1 = helper_ed4dc120(2, -1)
	if var1 == 0 then
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d01/d01.stb", 1000)
		return
	end
	event.finish_event()
end

--- Event 601, which map data, a script or the engine runs by number.
function script.event_601()
	vm.wait(1)
	helper_68186cf4(1)
	event.load_event_script("s06/s06c_1.stb", 600)
end

--- Event 630, which map data, a script or the engine runs by number.
function script.event_630()
	event.go_to_georama_edit(12, 540)
	vm.wait(1)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			flag = event.get_save_flag(7) or flag
			if flag == 0 then
				event.set_save_flag(6, 1)
				at = 1
				vm.wait(1)
				event.load_event_script("s06/s06.stb", 503)
			else
				at = 2
				helper_2a1e9b48(0)
			end
		else
			at = 3
			helper_2a1e9b48(0)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_5a05ed59(0)
			end
			if at <= 2 then
				helper_5a05ed59(0)
			end
			return 0
		end
		return nil
	end)
end

--- Event 11030, which map data, a script or the engine runs by number.
function script.event_11030()
	event.set_save_flag(103, 0)
	vm.wait(1)
	event.load_event_script("s06/s06b_1.stb", 500)
end

--- Event 11040, which map data, a script or the engine runs by number.
function script.event_11040()
	vm.wait(1)
	event.load_event_script("s06/s06c_1.stb", 500)
end

--- Event 11070, which map data, a script or the engine runs by number.
function script.event_11070()
	event.set_save_flag(107, 1)
	vm.wait(1)
	event.load_event_script("s06/s06b_1.stb", 510)
end

--- Event 11081, which map data, a script or the engine runs by number.
function script.event_11081()
	local at: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(1, 1)
		event.fade_out_screen(15)
		at = 1
		wait_frames(15)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_dungeon_pause_flags(17, 1)
		at = 2
		helper_18550()
		event.set_save_flag(7, 1)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_18550()
				return vm.continue_with(function()
					event.set_save_flag(7, 1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 11082, which map data, a script or the engine runs by number.
function script.event_11082()
	local at: number = 0
	return vm.guard(function()
		event.set_save_control_bits(1, 0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.add_hp_by_rate(1.0, 0)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_dungeon_pause_flags(17, 1)
		at = 2
		helper_69eefc83()
		event.skip_next_music_load()
		event.go_to_georama_edit(10, 531)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_69eefc83()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(10, 531)
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

--- Event 21010, which map data, a script or the engine runs by number.
function script.event_21010()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.set_character_position(0, 0.0, 50.0, 100.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	helper_68186cf4(1)
	event.load_dungeon_monster(601, 1)
	event.place_dungeon_monster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.finish_event()
	event.reset_follow_camera(1, 0.0, 20.0)
end

return script
