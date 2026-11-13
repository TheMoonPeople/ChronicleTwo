--!strict
--- Max's room flashback with the potato pie meal scene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local maxs_room_flashback = require("@lib/event/maxs_room_flashback")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local voice_frame_count: s32 = 0

--- Plays the flashback of Minchu waking in bed in the evening while Eina reads, with sound effects.
local function play_minchu_wakes_scene()
	local sound_bank: s32 = 0
	local saved_time_of_day: f32 = 0
	vm.section(function()
		event.set_save_flag(406, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_all_sounds()
		event.load_music(58)
		event.play_music(0)
		event.load_map_sounds(4801)
		sound_bank = event.load_sound_effect_file_2(4801) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e400/e406/")
		event.load_message_file(0, 5, "e406.txt")
		event.load_character(5, "e406_minchu.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e406_eina.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e406_bed.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.set_object_handle_position(0, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "寝てる", 4)
		event.attach_character_to_frame(10, "minchu", 8)
		event.set_object_handle_sound_bank(0, sound_bank)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 64.33, 13.21, 70.24)
		event.set_object_handle_rotation(1, 0.0, -1.48, 0.0)
		event.set_object_handle_motion(1, "本読む", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.set_character_position(10, 58.0, 13.0, 108.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.set_character_motion(10, "寝てる", 4)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_time_of_day(22.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-25.28, 87.45, 28.6)
		event.set_camera_sequence_look_at(68.06, 28.91, 95.45)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(4060020)
		event.set_object_sequence_motion(1, "本閉じる", 2)
		event.queue_object_sequence_next_motion(1, "ユリス見るL", 4)
		wait.for_frame_count(14)
		event.play_sound_effect(sound_bank, 0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(62.04, 40.15, 70.68)
		event.set_camera_sequence_look_at(59.03, 34.16, 100.4)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(4060030)
		event.set_object_sequence_motion(0, "エイナを見る", 6)
		event.queue_object_sequence_next_motion(0, "エイナを見るL", 4)
		event.set_object_sequence_motion(2, "エイナを見る", 6)
		event.queue_object_sequence_next_motion(2, "エイナを見るL", 4)
		event.play_sound_effect(sound_bank, 1)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(4060035)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.set_camera_sequence_position(43.31, 40.29, 81.27)
		event.set_camera_sequence_look_at(72.59, 39.24, 71.2)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(4060040)
		event.set_camera_sequence_position(3.77, 60.04, 42.87)
		event.set_camera_sequence_look_at(71.41, 28.24, 86.89)
		event.set_object_sequence_motion(1, "上を見る", 6)
		event.queue_object_sequence_next_motion(1, "上を見るL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(4060044)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(4060048)
		object.wait_until_done(1)
		event.set_camera_sequence_position(62.04, 40.15, 70.68)
		event.set_camera_sequence_look_at(59.03, 35.79, 100.4)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(4060050)
		event.set_object_sequence_motion(0, "起きる", 6)
		event.queue_object_sequence_next_motion(0, "起きるL", 4)
		event.set_object_sequence_motion(2, "起きる", 6)
		event.queue_object_sequence_next_motion(2, "起きるL", 4)
		event.play_sound_effect(sound_bank, 2)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(4060055)
		event.set_camera_sequence_position(48.78, 37.2, 87.09)
		event.set_camera_sequence_look_at(65.24, 40.1, 73.06)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "わらい目")
		event.set_object_sequence_motion(1, "ユリス見るL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		message.show_voiced(4060060)
		event.set_camera_sequence_position(61.65, 38.17, 78.76)
		event.set_camera_sequence_look_at(58.54, 38.63, 100.33)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "起きる会話", 6)
		event.queue_object_sequence_next_motion(0, "起きるL", 4)
		event.set_object_sequence_motion(2, "起きる会話", 6)
		event.queue_object_sequence_next_motion(2, "起きるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4060070)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.move_camera_sequence_eased(60.7, 40.1, 85.35, 58.54, 40.56, 100.33, 40, 0, 0.2)
		camera.wait_until_done()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_time_of_day_advancing(1)
	event.set_time_of_day(saved_time_of_day)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.stop_music(0)
	vm.wait(24)
end

--- Drives mouth animations from the voice stream until the message advances.
local function lip_sync_voice(window: s32)
	local motion_wait: f32 = 0
	local mouth_state: s32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local advance_result: s32 = 0
	local frame_count: s32 = 0
	local previous_audible: s32 = 0
	local is_audible: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		mouth_state = 0
		frame_count = 0
		previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
		is_audible = 0
		while true do
			motion_wait = event.get_character_motion_wait(32) or motion_wait
			if motion_wait < vm.f32(0.01) then
				event.set_object_sequence_texture_animation(0, 0, "パクパク")
				event.set_object_sequence_texture_animation(0, 1, "パクパク")
			end
			previous_voice_state = voice_state
			voice_state = event.get_voice_stream_state(1) or voice_state
			if previous_voice_state ~= 0 and voice_state == 0 then
				event.trigger_mouth_motion(2)
				mouth_state = 2
			end
			previous_audible = is_audible
			is_audible = event.is_voice_stream_audible(1) or is_audible
			if previous_audible == 0 and is_audible == 1 then
				event.trigger_mouth_texture_animation(1)
			end
			if previous_audible == 1 and is_audible == 0 then
				event.trigger_mouth_texture_animation(0)
			end
			local t0: s32
			t0, mouth_state = message.poll_advance(window, mouth_state)
			advance_result = t0
			if advance_result ~= 0 then
				frame_count = vm.i32(frame_count + 1)
				break
			else
				if voice_frame_count == 137 then
					event.set_object_sequence_texture_animation(0, 0)
					event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
					event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
				end
				resume_step = 1
				vm.wait(1)
				frame_count = vm.i32(frame_count + 1)
				voice_frame_count = vm.i32(voice_frame_count + 1)
			end
		end
		if mouth_state == 0 then
			event.trigger_mouth_motion(2)
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.stop_voice_stream(1)
		return
	end, function(received: { any })
		if resume_step <= 1 then
			frame_count = frame_count + 1
			local _ = voice_frame_count == 137
			voice_frame_count = vm.i32(voice_frame_count + 1)
			return frame_count
		end
		return nil
	end)
end

--- Applies the end state of the lip sync when the scene is skipped.
local function skip_lip_sync(window: s32)
	local mouth_state: s32 = 0
	local frame_count: s32 = 0
	mouth_state = 0
	frame_count = 0
	mouth_state = 2
	do
		local _: any
		_, mouth_state = maxs_room_flashback.pass_value(window, mouth_state)
	end
	frame_count = frame_count + 1
	frame_count = frame_count + 1
	local _ = voice_frame_count == 137
	voice_frame_count = vm.i32(voice_frame_count + 1)
end

--- Opens a voice stream and message window and plays them with lip sync.
local function play_voiced_message(message_id: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.open_voice_stream_wave(1, message_id)
		while true do
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			else
				resume_step = 1
				vm.wait(1)
			end
		end
		event.ready_voice_stream(1)
		while true do
			stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
			if stream_open_state_2 == 0 then
				break
			else
				resume_step = 2
				vm.wait(2)
			end
		end
		event.open_message_window_2(0, message_id)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		resume_step = 3
		lip_sync_voice(0)
		message.close(0)
		event.close_voice_stream(1)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 2 then
				message.open_skipping(0, -1, 8, 0, 0)
				skip_lip_sync(0)
			end
			message.close_skipping(0)
			return 0
		end
		return nil
	end)
end

--- Applies the end state of a voiced message when the scene is skipped.
local function skip_voiced_message(message_id: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	skip_lip_sync(0)
	message.close_skipping(0)
end

--- Plays the scene where Yulis brings potato pie to Eina.
local function cutscene_potato_pie()
	local saved_time_of_day: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		cutscene.load_e209_actors_primary()
		voice_frame_count = 0
		event.stop_music(0)
		resume_step = 1
		wait.for_frame_count(4)
		event.load_music(58)
		event.play_music(0)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		resume_step = 2
		wait.for_frame_count(120)
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
		resume_step = 3
		wait.for_frame_count(60)
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
		resume_step = 4
		play_voiced_message(2090590)
		resume_step = 5
		play_voiced_message(2090593)
		resume_step = 6
		play_voiced_message(2090595)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_step = 7
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.skip_frame_count(120)
		end
		if resume_step <= 2 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 3 then
			skip_voiced_message(2090590)
		end
		if resume_step <= 4 then
			skip_voiced_message(2090593)
		end
		if resume_step <= 5 then
			skip_voiced_message(2090595)
		end
		if resume_step <= 6 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	cutscene.unload_e209_actors()
	event.stop_music(0)
	event.set_time_of_day_advancing(1)
	event.set_time_of_day(saved_time_of_day)
	event.fade_in_screen(30)
end

--- Plays the flashback of Eina tending the sick Minchu in bed.
local function play_minchu_eina_bedside_scene()
	local saved_time_of_day: f32 = 0
	vm.section(function()
		event.set_save_flag(307, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_all_sounds()
		event.load_music(58)
		event.play_music(0)
		event.load_map_sounds(3801)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e300/e307/")
		event.load_message_file(0, 5, "e307.txt")
		event.load_character(5, "e307_minchu.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e307_eina.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e307_bed.gltf", "info", 10)
		event.set_character_active(10)
		event.load_character(5, "e307_senmen.gltf", "info", 11)
		event.set_character_active(11)
		event.change_directory("")
		event.set_object_handle_position(0, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "寝てる", 4)
		event.attach_character_to_frame(10, "minchu", 8)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "苦しい顔")
		event.set_object_handle_texture_animation(0, 1, "苦しい目パチ")
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "座り", 4)
		event.attach_character_to_frame(10, "eina", 9)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "わらい顔")
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.set_character_position(10, 58.0, 13.0, 108.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.set_character_motion(10, "寝てる", 4)
		event.set_character_position(11, 56.65, 13.0, 71.33)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-25.28, 87.45, 28.6)
		event.set_camera_sequence_look_at(68.06, 28.91, 95.45)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_motion(1, "頭を冷やす", 6)
		event.queue_object_sequence_next_motion(1, "座り", 4)
		object.wait_until_done(1)
		event.set_camera_sequence_position(51.94, 47.84, 90.03)
		event.set_camera_sequence_look_at(64.5, 32.42, 98.98)
		event.set_mouth_texture_animations(0, "苦しい口パク")
		message.show_voiced(3070030)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3070040)
		event.delay_object_sequence_texture_animation_track(0, 180)
		event.set_object_sequence_texture_animation(0, 1, "目あき～とじ")
		event.delay_object_sequence_texture_animation_track(0, 90)
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 0, "目あき～とじ")
		event.set_object_sequence_texture_animation(0, 0, "目とじ～目あき")
		event.set_mouth_texture_animations(0, "苦しい口パク")
		message.show_voiced(3070050)
		event.set_object_sequence_motion(1, "頭をなでる", 2)
		event.queue_object_sequence_next_motion(1, "頭をなでるL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3070060)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3070070)
		event.set_camera_sequence_position(35.28, 48.46, 114.2)
		event.set_camera_sequence_look_at(66.59, 39.0, 88.86)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3070075)
		event.set_mouth_texture_animations(0, "苦しい口パク")
		message.show_voiced(3070080)
		event.set_camera_sequence_position(50.56, 35.76, 96.14)
		event.set_camera_sequence_look_at(69.63, 43.83, 87.3)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3070090)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_music(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	vm.wait(11)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_minchu_wakes_scene

--- Plays the potato pie scene and jumps to g01i07.
function script.cutscene_potato_pie_to_g01i07()
	cutscene_potato_pie()
	event.skip_next_music_play()
	event.jump_to_map_3(-1, "g01i07", 502)
	vm.wait(2)
end
script[501] = script.cutscene_potato_pie_to_g01i07

--- Plays the bedside scene and loads d03.
function script.cutscene_bedside_to_d03()
	play_minchu_eina_bedside_scene()
	event.load_dungeon_map("d03f01", "d03f01", 6)
	event.load_event_script("d03/d03.stb", 500)
end
script[510] = script.cutscene_bedside_to_d03

--- Plays the waking scene and loads d04.
function script.cutscene_wakes_to_d04()
	play_minchu_wakes_scene()
	event.load_dungeon_map("d04f02", "d04f02", 40)
	event.load_event_script("d04/d04.stb", 500)
end
script[520] = script.cutscene_wakes_to_d04

--- Event 600, which map data, a script or the engine runs by number.
script.cutscene_potato_pie = cutscene_potato_pie
script[600] = script.cutscene_potato_pie

return script
