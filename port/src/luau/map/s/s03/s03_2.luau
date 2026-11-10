--!strict
-- map/s/s03/s03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05a5769c = require("@lib/event/helper_05a5769c")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_482d9cfc = require("@lib/event/helper_482d9cfc")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_8aec2e2d = require("@lib/event/helper_8aec2e2d")
local helper_9b171b08 = require("@lib/event/helper_9b171b08")
local helper_aa5b3ebe = require("@lib/event/helper_aa5b3ebe")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_f2b0ffcb = require("@lib/event/helper_f2b0ffcb")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_1645c()
	local var0: s32 = 0
	local var1: any = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(205, 1)
		event.initialize_event()
		event.load_map_sounds(2206)
		var0 = event.load_sound_effect_file_2(2206) or var0
		helper_482d9cfc()
		event.stop_music(0)
		at = 1
		vm.wait(1)
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.play_sound_effect(var0, 5)
		event.set_character_position(36, 102.27, 0.0, -305.63)
		event.set_character_rotation(36, 0.0, 0.0, 0.0)
		event.set_character_position(35, 44.05, 0.0, 60.82)
		event.set_character_scale(35, 2.0, 2.0, 2.0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 0)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(11, 0)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.play_sound_effect(var0, 1)
		event.attach_object_handle_to_map_part_2(10, "p01_s03t")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		do
			local out1, out2, out3 = event.get_object_handle_position(10)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.move_object_sequence(10, 0.0, 51.92, 0.0, 60)
		event.rotate_object_sequence(10, 0.0, 0.0, -0.785, 60)
		event.set_camera_sequence_position(67.41, 107.89, 704.3)
		event.set_camera_sequence_look_at(59.64, 108.51, 271.98)
		event.move_camera_sequence_eased(58.28, 107.89, 196.59, 57.34, 108.51, 144.64, 50, 1, 0.4)
		at = 2
		wait_frames(45)
		event.set_object_sequence_color(11, 0, 0, 0, 255, 30)
		at = 3
		wait_frames(30)
		event.set_map_piece_character_motion("p01_s03t", "kikan-m", "停止")
		event.clear_effect_manager()
		helper_f2b0ffcb()
		event.set_object_sequence_position(10, pos_x, pos_y, pos_z)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.stop_all_sounds()
		at = 4
		wait_frames(4)
		event.load_music(60)
		event.play_music(1)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "R[UNI00e9]essayer.\nRetourner [UNI00e0] l'[UNI00e9]cran de titre.")
		at = 5
		var1 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 0)
		event.set_character_active(1, 0)
		event.fade_out_screen(0)
		event.set_event_sprite_draw_pass(0, 0)
		return var1
	end, function(received: { any })
		if at <= 5 then
			if at == 5 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(45)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			if at <= 3 then
				helper_1ef0d4b2()
				wait_frames_skipping(4)
			end
			if at <= 4 then
				var1 = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
			end
			return var1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	event.set_character_position(0, 0.0, 140.0, -420.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_position(0.0, 200.0, -260.0)
	event.set_camera_look_at(0.0, 170.0, -420.0)
	event.reset_follow_camera(0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	wait_frames(30)
	helper_05a5769c()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	helper_9b171b08()
	event.fade_in_screen(15)
	event.start_sub_game(3)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s08", 502)
	vm.wait(1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	helper_8aec2e2d()
	event.skip_next_music_play()
	event.jump_to_map_2(-1, "s02")
	vm.wait(2)
end

--- Event 512, which map data, a script or the engine runs by number.
function script.event_512()
	local var0: any = 0
	var0 = helper_1645c()
	helper_aa5b3ebe(var0)
end

--- Event 12040, which map data, a script or the engine runs by number.
function script.event_12040()
	helper_9b171b08()
	event.fade_in_screen(15)
	event.start_sub_game(3)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	local var0: any = 0
	var0 = helper_1645c()
	helper_aa5b3ebe(var0)
end

--- Event 12060, which map data, a script or the engine runs by number.
script.event_12060 = helper_8aec2e2d

--- Event 22010, which map data, a script or the engine runs by number.
function script.event_22010()
	vm.wait(1)
	event.set_character_position(0, 0.0, 140.0, -420.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.start_sub_game(3)
end

return script
