--!strict
--- Controls music, voice streams and sound effects.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local sound = {}

--- Returns the voice number that plays the chest-opening sound for the current dungeon stage.
function sound.get_chest_open_voice()
	local stage_id: s32 = 0
	local voice: s32 = 0
	stage_id = event.get_dungeon_stage_id() or stage_id
	voice = 0
	if stage_id == 0 or stage_id == 1 or stage_id == 6 then
		voice = 110
	end
	if stage_id == 5 then
		voice = 111
	end
	if stage_id == 2 or stage_id == 4 or stage_id == 3 then
		voice = 112
	end
	return voice
end

--- Loads the shared event sound effect file into sound slot 4.
function sound.load_event_sound_effects()
	event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
end

--- Opens a voice stream wave, waits until the stream is ready and starts playing it.
function sound.play_voice(wave_id: s32)
	event.open_voice_stream_wave(1, wave_id)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
end

--- Plays a voice stream for a number of frames and then closes it.
function sound.play_voice_for(voice: any, duration: s32)
	event.open_voice_stream_wave(1, voice)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	message.wait_voice_stopping_for(0, duration)
	event.close_voice_stream(1)
end

--- Counts a voice wait without waiting; this stands in for sound.play_voice_for when events are skipped.
function sound.play_voice_for_skipping(voice: any, duration: s32)
	cutscene.skip_command(1)
	message.wait_voice_stopping_for_skipping(0, duration)
end

--- Plays a voice stream wave while the matching text is shown, then closes the stream.
function sound.play_voice_line(wave_id: s32, text_id: s32)
	event.open_voice_stream_wave(1, wave_id)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	message.wait_voice_for(0, text_id)
	event.close_voice_stream(1)
end

--- Stands in for playing a voice line when events are skipped, waiting only through the skipping voice wait.
function sound.play_voice_line_skipping(wave_id: s32, text_id: s32)
	cutscene.skip_command(1)
	message.wait_voice_for_skipping(0, text_id)
end

--- Opens a voice stream, waits until it is ready, plays it for a number of frames and closes it. It stops the voice when the wait ends.
function sound.play_voice_line_stopping(voice_id: s32, duration_frames: s32)
	event.open_voice_stream_wave(1, voice_id)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	message.wait_voice_stopping_for(0, duration_frames)
	event.close_voice_stream(1)
end

--- Does nothing for the given voice wave; this stands in for sound.play_voice when events are skipped.
function sound.play_voice_skipping(wave_id: s32)
	cutscene.skip_command(1)
end

--- Waits until a voice stream has finished opening and is ready to play.
function sound.wait_voice_stream_ready(stream: s32)
	local stream_open_state: s32 = 0
	while true do
		vm.wait(1)
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.ready_voice_stream(stream)
	while true do
		vm.wait(2)
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
end

--- Waits until a voice stream is ready to play; returns the frames it waited.
function sound.wait_voice_stream_ready_counting(stream: s32)
	local stream_open_state: s32 = 0
	local frames: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		frames = 0
		while true do
			resume_step = 1
			vm.wait(1)
			frames = vm.i32(frames + 1)
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			end
		end
		event.ready_voice_stream(stream)
		while true do
			resume_step = 2
			vm.wait(2)
			frames = vm.i32(frames + 1)
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			end
		end
		return frames
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				frames = frames + 1
			end
			frames = frames + 1
			return frames
		end
		return nil
	end)
end

--- Returns a frame count without waiting; this stands in for sound.wait_voice_stream_ready_counting when events are skipped.
function sound.wait_voice_stream_ready_counting_skipping(stream: s32)
	local frames: s32 = 0
	frames = 0
	frames = frames + 1
	frames = frames + 1
	return frames
end

return sound
