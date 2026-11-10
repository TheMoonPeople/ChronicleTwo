--!strict
-- map/s/s46/s46_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_2e67f92b = require("@lib/event/helper_2e67f92b")
local helper_57c93eff = require("@lib/event/helper_57c93eff")
local helper_696c0345 = require("@lib/event/helper_696c0345")
local helper_732ddd37 = require("@lib/event/helper_732ddd37")
local helper_83e6dd8e = require("@lib/event/helper_83e6dd8e")
local helper_afed7092 = require("@lib/event/helper_afed7092")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

local global0: s32 = 0

--- Helper function.
local function helper_e3b4(arg0: s32)
	local get_now_frame_wait: f32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		var2 = 0
		var6 = 0
		argc_2 = event.get_voice_stream_state(1) or argc_2
		loud = 0
		while true do
			get_now_frame_wait = event.get_character_motion_wait(32) or get_now_frame_wait
			if get_now_frame_wait < vm.f32(0.01) then
				event.set_object_sequence_texture_animation(0, 0, "パクパク")
				event.set_object_sequence_texture_animation(0, 1, "パクパク")
			end
			argc_2 = argc
			argc = event.get_voice_stream_state(1) or argc
			if argc_2 ~= 0 and argc == 0 then
				event.trigger_mouth_motion(2)
				var2 = 2
			end
			var7 = loud
			loud = event.is_voice_stream_audible(1) or loud
			if var7 == 0 and loud == 1 then
				event.trigger_mouth_texture_animation(1)
			end
			if var7 == 1 and loud == 0 then
				event.trigger_mouth_texture_animation(0)
			end
			local t0: s32
			t0, var2 = helper_57c93eff(arg0, var2)
			var5 = t0
			if var5 ~= 0 then
				var6 = vm.i32(var6 + 1)
				break
			else
				if global0 == 137 then
					event.set_object_sequence_texture_animation(0, 0)
					event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
					event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
				end
				at = 1
				vm.wait(1)
				var6 = vm.i32(var6 + 1)
				global0 = vm.i32(global0 + 1)
			end
		end
		if var2 == 0 then
			event.trigger_mouth_motion(2)
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.stop_voice_stream(1)
		return
	end, function(received: { any })
		if at <= 1 then
			var6 = var6 + 1
			local _ = global0 == 137
			global0 = vm.i32(global0 + 1)
			return var6
		end
		return nil
	end)
end

--- Helper function.
local function helper_21900000(arg0: s32)
	local var2: s32 = 0
	local var6: s32 = 0
	var2 = 0
	var6 = 0
	var2 = 2
	do
		local _: any
		_, var2 = helper_afed7092(arg0, var2)
	end
	var6 = var6 + 1
	var6 = var6 + 1
	local _ = global0 == 137
	global0 = vm.i32(global0 + 1)
end

--- Helper function.
local function helper_ec5c(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.open_voice_stream_wave(1, arg0)
		while true do
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			else
				at = 1
				vm.wait(1)
			end
		end
		event.ready_voice_stream(1)
		while true do
			stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
			if stream_open_state_2 == 0 then
				break
			else
				at = 2
				vm.wait(2)
			end
		end
		event.open_message_window_2(0, arg0)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 3
		helper_e3b4(0)
		close_message(0)
		event.close_voice_stream(1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 2 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_21900000(0)
			end
			helper_d16eef1e(0)
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_21d00000(arg0: s32)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_21900000(0)
	helper_d16eef1e(0)
end

--- Helper function.
local function helper_f7d8()
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		helper_696c0345()
		global0 = 0
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(58)
		event.play_music(0)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目パチ")
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.attach_character_to_frame(33, "pie", 34)
		event.attach_character_to_frame(33, "pie", 35)
		event.set_camera_sequence_position(-22.48, 31.6, -71.45)
		event.set_camera_sequence_look_at(74.99, 21.39, -133.6)
		event.set_object_sequence_position(0, 71.93, 0.0, -137.17)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -32.7, 0.0, -81.53)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(0, "座り", 4)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "左を見る", 6)
		event.queue_object_sequence_next_motion(0, "左を見るL", 0)
		event.set_object_sequence_motion(1, "ポテトパイ歩き", 4)
		event.move_object_sequence(1, 29.44, 0.0, -115.61, 120)
		at = 2
		wait_frames(120)
		event.detach_character_from_frame(34)
		event.detach_character_from_frame(35)
		event.set_character_active(0, 33)
		event.set_character_active(1, 36)
		event.attach_character_to_frame(32, "pie", 36)
		event.set_camera_sequence_position(15.46, 33.35, -97.19)
		event.set_camera_sequence_look_at(39.19, 15.77, -110.22)
		event.set_object_sequence_position(0, 45.12, 0.0, -113.39)
		event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
		event.set_object_sequence_motion(0, "喜ぶ", 6)
		event.queue_object_sequence_next_motion(0, "喜ぶL", 0)
		at = 3
		wait_frames(60)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(25.57, 23.79, -65.13)
		event.set_camera_sequence_look_at(36.95, 20.17, -110.66)
		event.set_object_sequence_position(0, 45.12, 0.0, -113.39)
		event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
		event.set_object_sequence_position(1, 28.93, 0.0, -101.8)
		event.set_object_sequence_rotation(1, 0.0, 2.04, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "パクパク")
		event.set_object_sequence_motion(0, "食べる", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 6)
		event.queue_object_sequence_next_motion(0, "食べる", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 4)
		event.set_object_sequence_motion(1, "ユリス見立ち", 4)
		at = 4
		helper_ec5c(2090590)
		at = 5
		helper_ec5c(2090593)
		at = 6
		helper_ec5c(2090595)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 7
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(120)
		end
		if at <= 2 then
			wait_frames_skipping(60)
		end
		if at <= 3 then
			helper_21d00000(2090590)
		end
		if at <= 4 then
			helper_21d00000(2090593)
		end
		if at <= 5 then
			helper_21d00000(2090595)
		end
		if at <= 6 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	helper_2e67f92b()
	event.stop_music(0)
	event.set_time_of_day_advancing(1)
	event.set_time_of_day(time)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_83e6dd8e

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_f7d8()
	event.skip_next_music_play()
	event.jump_to_map_3(-1, "g01i07", 502)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_732ddd37()
	event.load_dungeon_map("d03f01", "d03f01", 6)
	event.load_event_script("d03/d03.stb", 500)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_83e6dd8e()
	event.load_dungeon_map("d04f02", "d04f02", 40)
	event.load_event_script("d04/d04.stb", 500)
end

--- Event 600, which map data, a script or the engine runs by number.
script.event_600 = helper_f7d8

return script
