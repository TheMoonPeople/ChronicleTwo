--!strict
-- map/s/s30/s30_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1315f555 = require("@lib/event/helper_1315f555")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_278438ff = require("@lib/event/helper_278438ff")
local helper_29585dfe = require("@lib/event/helper_29585dfe")
local helper_4ba013c2 = require("@lib/event/helper_4ba013c2")
local helper_6dca11b1 = require("@lib/event/helper_6dca11b1")
local helper_6e59aa59 = require("@lib/event/helper_6e59aa59")
local helper_758eaf41 = require("@lib/event/helper_758eaf41")
local helper_778d04c1 = require("@lib/event/helper_778d04c1")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_9ced6ae4 = require("@lib/event/helper_9ced6ae4")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b88762f7 = require("@lib/event/helper_b88762f7")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bde1dfef = require("@lib/event/helper_bde1dfef")
local helper_c831193d = require("@lib/event/helper_c831193d")
local helper_d00ee03f = require("@lib/event/helper_d00ee03f")
local helper_de3682e9 = require("@lib/event/helper_de3682e9")
local helper_e4877873 = require("@lib/event/helper_e4877873")
local helper_f242e245 = require("@lib/event/helper_f242e245")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	helper_278438ff()
end

--- Helper function.
local function helper_2f974(arg0: any)
	local var1: s32 = 0
	local var2: any = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 4)
	event.set_message_selection_top_line(0, 1)
	event.set_message_window_option(0, 0, 1)
	event.set_message_window_option(0, 1, 1)
	event.open_message_window_2(
		0,
		"Sprungtor-Ziel w[UNI00e4]hlen:\nSprungtor -- Norden\nSprungtor -- Osten\nSprungtor -- Westen\nVor dem Zeit-Tor"
	)
	var1 = 4
	var2 = helper_bac0e30d(0, -1, 8, 0, 0, var1, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 1, 0)
	if var2 == -1 then
		return
	end
	if vm.wrap(var2 - 1) ~= 1 and vm.wrap(var2 - 1) ~= 2 and vm.wrap(var2 - 1) ~= 3 and vm.wrap(var2 - 1) ~= 0 then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("サンワープ２")
	event.create_effect_work_buffer(5)
	event.create_effect("サンワープ２")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.set_effect_first_vector(var3, var4, var5)
	var6 = event.get_sound_id(2) or var6
	event.play_sound_effect(var6, 120)
	wait_frames(15)
	event.set_character_visible(0, 0, 1, 0.05)
	event.set_character_visible(1, 0, 1, 0.05)
	event.set_character_visible(2, 0, 1, 0.05)
	event.set_character_visible(3, 0, 1, 0.05)
	wait_frames(30)
	event.fade_out_screen(15)
	wait_frames(15)
	event.clear_effect_manager()
	event.set_character_visible(0, 1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_visible(3, 1)
	event.set_save_counter(18, vm.wrap(var2 - 1))
	event.jump_to_map_2(-1, "f04")
	vm.wait(5)
end

--- Helper function.
local function helper_12ef0(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var11: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var15: s32 = 0
	local var16: any = 0
	local at: number = 0
	return vm.guard(function()
		set_window_mode(0, 7)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(1, arg0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			var8 = out2 or var8
		end
		do
			local out1, out2, out3 = event.get_character_position(arg0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local _, out2, _ = event.get_character_rotation(arg0)
			var11 = out2 or var11
		end
		yaw = event.get_direction_angle(var1, var2, var3, var4, var5, var6) or yaw
		yaw_2 = event.get_direction_angle(var4, var5, var6, var1, var2, var3) or yaw_2
		var15 = event.compare_angles(var8, yaw, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		var15 = event.compare_angles(var11, yaw_2, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		at = 1
		wait_frames(20)
		event.open_voice_stream_wave(1, 5400010)
		at = 2
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
		event.open_message_window_2(0, "Unser Gegenangriff auf Griffon\nsollte bald beginnen.")
		at = 3
		helper_0ffc2526(0, -1, arg0, 0, 0)
		event.close_voice_stream(1)
		event.open_voice_stream_wave(1, 5400015)
		at = 4
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, "Bist du bereit?")
		at = 5
		helper_0ffc2526(0, -1, arg0, 0, 0)
		event.close_voice_stream(1)
		set_window_mode(0, 1)
		event.open_message_window_2(0, "Ja.\nNein.")
		at = 6
		var16 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 0)
		if var16 == 0 then
			return 1
		else
			set_window_mode(0, 7)
			event.open_voice_stream_wave(1, 5400020)
			at = 7
			helper_9cbdc640(1)
			event.play_voice_stream(1)
			event.set_mouth_motions(1, "会話", 0, "立ち", 0)
			event.open_message_window_2(0, "Ihre Golem-Einheiten kommen.\nBeeil dich lieber.")
			at = 8
			helper_0ffc2526(0, -1, arg0, 0, 0)
			event.close_voice_stream(1)
			var15 = event.compare_angles(var11, yaw_2, 0.1) or var15
			if var15 ~= 0 then
				event.rotate_object_sequence(1, 0.0, var11, 0.0, 10)
				event.set_object_sequence_motion(1, "歩き")
				event.delay_object_sequence_motion_track(1, 10)
			end
			event.set_object_sequence_motion(1, "立ち")
			at = 9
			wait_frames(11)
			return 0
		end
	end, function(received: { any })
		if at <= 6 then
			if at == 6 then
				var16 = received[1] :: number
			end
			if at <= 1 then
				helper_238b5abc(1)
			end
			if at <= 2 then
				helper_9ced6ae4(0, -1, arg0, 0, 0)
			end
			if at <= 3 then
				helper_238b5abc(1)
			end
			if at <= 4 then
				helper_9ced6ae4(0, -1, arg0, 0, 0)
			end
			if at <= 5 then
				helper_fbd9683d(0, 1)
				var16 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 0)
			end
			return 1
		end
		if at <= 9 then
			if at <= 7 then
				helper_9ced6ae4(0, -1, arg0, 0, 0)
			end
			if at <= 8 then
				wait_frames_skipping(11)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_2360c()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(540, 1)
		at = 2
		helper_778d04c1()
		at = 3
		vm.wait(3)
		event.set_character_active(0, 8)
		event.load_music(116)
		event.play_music(0)
		event.set_movie_caption(0, 0)
		event.set_movie_caption(1, 0, 570, "Paznos ... Abflug!", 60)
		event.set_movie_caption(0, 1)
		event.load_map_sounds(5513)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.fade_in_screen(10)
		event.play_movie(5, "movie/e54001.mp4", 0)
		at = 4
		vm.wait(4)
		event.set_movie_caption(0, 0)
		event.fade_out_screen(0)
		at = 5
		helper_6dca11b1()
		at = 6
		vm.wait(6)
		event.stop_all_sound_effects()
		event.fade_in_screen(10)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.play_movie(5, "movie/e54002.mp4", 0)
		at = 7
		vm.wait(7)
		event.fade_out_screen(0)
		at = 8
		helper_c831193d()
		at = 9
		vm.wait(9)
		event.stop_all_sound_effects()
		var0 = event.get_event_sound_bank(4) or var0
		event.play_sound_effect(var0, 11)
		event.fade_in_screen(10)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.play_movie(5, "movie/e54003.mp4", 0)
		at = 10
		vm.wait(10)
		event.stop_sound_effect(var0, 11)
		event.fade_out_screen(0)
		at = 11
		helper_d00ee03f()
		at = 12
		vm.wait(12)
		event.stop_all_sound_effects()
		event.fade_in_screen(10)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.play_movie(5, "movie/e54004.mp4")
		at = 13
		vm.wait(13)
		event.fade_out_screen(0)
		at = 14
		helper_f242e245()
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s29", 600)
		return
	end, function(received: { any })
		if at <= 14 then
			if at <= 1 then
				at = 2
				helper_778d04c1()
				return vm.continue_with(function()
					at = 3
					vm.wait(3)
					event.set_character_active(0, 8)
					event.load_music(116)
					event.play_music(0)
					event.set_movie_caption(0, 0)
					event.set_movie_caption(1, 0, 570, "Paznos ... Abflug!", 60)
					event.set_movie_caption(0, 1)
					event.load_map_sounds(5513)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.fade_in_screen(10)
					event.play_movie(5, "movie/e54001.mp4", 0)
					at = 4
					vm.wait(4)
					event.set_movie_caption(0, 0)
					event.fade_out_screen(0)
					at = 5
					helper_6dca11b1()
					at = 6
					vm.wait(6)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54002.mp4", 0)
					at = 7
					vm.wait(7)
					event.fade_out_screen(0)
					at = 8
					helper_c831193d()
					at = 9
					vm.wait(9)
					event.stop_all_sound_effects()
					var0 = event.get_event_sound_bank(4) or var0
					event.play_sound_effect(var0, 11)
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54003.mp4", 0)
					at = 10
					vm.wait(10)
					event.stop_sound_effect(var0, 11)
					event.fade_out_screen(0)
					at = 11
					helper_d00ee03f()
					at = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					at = 13
					vm.wait(13)
					event.fade_out_screen(0)
					at = 14
					helper_f242e245()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if at <= 4 then
				at = 5
				helper_6dca11b1()
				return vm.continue_with(function()
					at = 6
					vm.wait(6)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54002.mp4", 0)
					at = 7
					vm.wait(7)
					event.fade_out_screen(0)
					at = 8
					helper_c831193d()
					at = 9
					vm.wait(9)
					event.stop_all_sound_effects()
					var0 = event.get_event_sound_bank(4) or var0
					event.play_sound_effect(var0, 11)
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54003.mp4", 0)
					at = 10
					vm.wait(10)
					event.stop_sound_effect(var0, 11)
					event.fade_out_screen(0)
					at = 11
					helper_d00ee03f()
					at = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					at = 13
					vm.wait(13)
					event.fade_out_screen(0)
					at = 14
					helper_f242e245()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if at <= 7 then
				at = 8
				helper_c831193d()
				return vm.continue_with(function()
					at = 9
					vm.wait(9)
					event.stop_all_sound_effects()
					var0 = event.get_event_sound_bank(4) or var0
					event.play_sound_effect(var0, 11)
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54003.mp4", 0)
					at = 10
					vm.wait(10)
					event.stop_sound_effect(var0, 11)
					event.fade_out_screen(0)
					at = 11
					helper_d00ee03f()
					at = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					at = 13
					vm.wait(13)
					event.fade_out_screen(0)
					at = 14
					helper_f242e245()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if at <= 10 then
				at = 11
				helper_d00ee03f()
				return vm.continue_with(function()
					at = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					at = 13
					vm.wait(13)
					event.fade_out_screen(0)
					at = 14
					helper_f242e245()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if at <= 13 then
				at = 14
				helper_f242e245()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
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
	event_99()
	helper_9dafbc83(-155.0, vm.f32(76.3), -205.0, vm.f32(0.9))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_2f974(4)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_4ba013c2()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f04", 601)
end

--- Event 601, which map data, a script or the engine runs by number.
function script.event_601()
	helper_6dca11b1()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 601)
end

--- Event 602, which map data, a script or the engine runs by number.
function script.event_602()
	helper_c831193d()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 602)
end

--- Event 603, which map data, a script or the engine runs by number.
function script.event_603()
	helper_d00ee03f()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 603)
end

--- Event 604, which map data, a script or the engine runs by number.
function script.event_604()
	helper_f242e245()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s29", 600)
end

--- Event 605, which map data, a script or the engine runs by number.
function script.event_605()
	helper_bde1dfef()
	event.jump_to_map_3(-1, "s10", 510)
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	helper_b88762f7()
	event.jump_to_map_3(-1, "d06b01", 600)
	vm.wait(2)
end

--- Event 620, which map data, a script or the engine runs by number.
function script.event_620()
	helper_1315f555()
	event.jump_to_map_3(-1, "s32", 610)
	vm.wait(2)
end

--- Event 630, which map data, a script or the engine runs by number.
function script.event_630()
	helper_e4877873()
	event.jump_to_map_3(-1, "s32", 620)
	vm.wait(2)
end

--- Event 640, which map data, a script or the engine runs by number.
function script.event_640()
	helper_6e59aa59()
	event.jump_to_map_3(-1, "s32", 630)
	vm.wait(2)
end

--- Event 650, which map data, a script or the engine runs by number.
function script.event_650()
	helper_758eaf41()
	event.jump_to_map_3(-1, "s32", 640)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		var0 = event.get_triggered_event_data_2(14) or var0
		var1 = event.get_triggered_event_data_2(13) or var1
		if var0 == 400 then
			flag = event.get_save_flag(536) or flag
			flag_2 = event.get_save_flag(540) or flag_2
			if flag == 1 and flag_2 == 0 then
				at = 1
				if helper_12ef0(var1) == 1 then
					event.fade_out_music(15)
					event.fade_out_screen(15)
					at = 2
					wait_frames(15)
					at = 3
					helper_2360c()
				end
			else
				at = 4
				helper_29585dfe()
			end
		else
			at = 5
			helper_29585dfe()
		end
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				wait_frames_skipping(15)
			end
			if at <= 2 then
				at = 3
				helper_2360c()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 3 then
				helper_de3682e9()
			end
			if at <= 4 then
				helper_de3682e9()
			end
			return 0
		end
		return nil
	end)
end

--- Event 15400, which map data, a script or the engine runs by number.
function script.event_15400()
	event.set_save_flag(536, 1)
	event.set_save_flag(540, 0)
	event_99()
	helper_2360c()
end

return script
