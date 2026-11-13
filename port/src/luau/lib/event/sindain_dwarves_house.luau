--!strict
--- Event helpers for the Dwarves' House in Sindain.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")

local sindain_dwarves_house = {}

--- Plays a voice stream with its message window and waits for it to end.
function sindain_dwarves_house.play_voiced_message(message_id: s32, duration_frames: s32)
	local open_state: s32 = 0
	local ready_state: s32 = 0
	event.open_voice_stream_wave(1, message_id)
	while true do
		open_state = event.get_voice_stream_open_state() or open_state
		if open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		ready_state = event.get_voice_stream_open_state() or ready_state
		if ready_state == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	sindain_dwarves_house.wait_voice_playback(0, duration_frames)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Plays a voice stream with its message window and closes the window at a given frame.
function sindain_dwarves_house.play_voiced_message_closing_at(message_id: s32, duration_frames: s32, close_frame: s32)
	local open_state: s32 = 0
	local ready_state: s32 = 0
	event.open_voice_stream_wave(1, message_id)
	while true do
		open_state = event.get_voice_stream_open_state() or open_state
		if open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		ready_state = event.get_voice_stream_open_state() or ready_state
		if ready_state == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	sindain_dwarves_house.sync_mouth_to_voice(0, duration_frames, close_frame)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Loads and places the seated Conda, Rococo and Tobo characters.
function sindain_dwarves_house.spawn_seated_dwarves()
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("event/e200/e209/")
	event.load_character(4, "e209_conda.gltf", "info", 8)
	event.set_scene_character_number(8, 34)
	event.set_character_active(8)
	event.set_character_position(8, 59.82, 0.0, -98.58)
	event.set_character_rotation(8, 0.0, 0.0, 0.0)
	event.set_character_motion(8, "座り")
	event.load_character(4, "e209_rococo.gltf", "info", 9)
	event.set_scene_character_number(9, 151)
	event.set_character_active(9)
	event.set_character_position(9, 37.28, 0.0, -29.43)
	event.set_character_rotation(9, 0.0, 2.56, 0.0)
	event.set_character_motion(9, "座り")
	event.load_character(4, "e209_tobo.gltf", "info", 10)
	event.set_scene_character_number(10, 154)
	event.set_character_active(10)
	event.set_character_position(10, 21.3, 0.0, -61.73)
	event.set_character_rotation(10, 0.0, 1.32, 0.0)
	event.set_character_motion(10, "座り")
	event.change_directory("")
end

--- Spawns the seated dwarves when save flags 250 and 247 are both clear.
function sindain_dwarves_house.spawn_seated_dwarves_if_flags_clear()
	local flag_250: s32 = 0
	local flag_247: s32 = 0
	flag_250 = event.get_save_flag(250) or flag_250
	flag_247 = event.get_save_flag(247) or flag_247
	if flag_250 == 0 and flag_247 == 0 then
		sindain_dwarves_house.spawn_seated_dwarves()
	end
end

--- Animates the mouth from voice playback until it ends or the duration passes, closing the window at a given frame.
function sindain_dwarves_house.sync_mouth_to_voice(window: s32, duration_frames: any, close_frame: s32)
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local frame: s32 = 0
	local previous_audible: s32 = 0
	local is_audible: s32 = 0
	local running: s32 = 0
	event.set_message_button_prompt(window, 0)
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	frame = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	is_audible = 0
	running = 1
	while running ~= 0 do
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			if duration_frames == -1 then
				running = 0
			end
		end
		previous_audible = is_audible
		is_audible = event.is_voice_stream_audible(1) or is_audible
		if previous_audible == 0 and is_audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if previous_audible == 1 and is_audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		vm.wait(1)
		frame = vm.i32(frame + 1)
		if duration_frames ~= -1 then
			if duration_frames <= frame then
				running = 0
			end
		end
		if close_frame == frame then
			message.close(window)
		end
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.set_message_button_prompt(window, 1)
end

--- Waits for voice playback to end, driving the mouth animation, without closing the window early.
function sindain_dwarves_house.wait_voice_playback(window: s32, duration_frames: any)
	sindain_dwarves_house.sync_mouth_to_voice(window, vm.ftoi(duration_frames), -1)
end

return sindain_dwarves_house
