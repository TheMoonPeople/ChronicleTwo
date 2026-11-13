--!strict
--- Waits on frames, input and background loads.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")

local wait = {}

--- Waits until no background file load is pending.
function wait.background_load()
	local pending: s32 = 0
	while true do
		pending = event.is_background_load_pending() or pending
		if pending == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

--- Returns 0 without waiting; this stands in for wait.background_load when events are skipped.
function wait.background_load_skipping()
	return 0
end

--- Waits one frame more than the given count.
function wait.for_frame_count(frames: any)
	while frames >= 0 do
		frames = frames - 1
		vm.wait(1)
	end
end

--- Waits one frame more than the given count.
function wait.frames(frames: any)
	while frames >= 0 do
		frames = frames - 1
		vm.wait(1)
	end
end

--- Counts a frame count down once without waiting; this is what skip mode runs in place of wait.frames.
function wait.frames_skipping(frames: any)
	local _ = frames > 0
	local _ = frames >= 0
	frames = vm.wrap(frames - 1)
end

--- Returns the state of a pad button.
function wait.get_button_state(button: s32)
	local state: s32 = 0
	state = event.get_pad_button_state(button) or state
	return state
end

--- Returns the buttons of a mask that were pressed this frame.
function wait.is_button_pressed(mask: s32)
	local buttons: s32 = 0
	buttons = event.get_buttons_pressed() or buttons
	return vm.i32(bit32.band(buttons, mask))
end

--- Returns 0 whatever the mask is; this stands in for wait.is_button_pressed when events are skipped.
function wait.is_button_pressed_skipping(mask: s32)
	local buttons: s32 = 0
	return vm.i32(bit32.band(buttons, mask))
end

--- Runs the skip-mode wait for 15 frames and then for 36 frames.
function wait.pause_15_then_36_frames_skipping(first_unused: s32, second_unused: s32)
	wait.frames_skipping(15)
	wait.frames_skipping(36)
end

--- Runs the skip-mode wait for 60 frames and then for 2 frames.
function wait.pause_60_then_2_frames_skipping()
	wait.frames_skipping(60)
	wait.frames_skipping(2)
end

--- Runs the skip-mode wait for four frames.
function wait.pause_four_frames_skipping()
	wait.frames_skipping(4)
end

--- Runs the skip-mode wait for four frames and then the skip-mode background load wait.
function wait.pause_four_frames_then_background_load_skipping()
	wait.frames_skipping(4)
	wait.background_load_skipping()
end

--- Runs the skip-mode wait for 60 frames.
function wait.pause_one_second_skipping()
	wait.frames_skipping(60)
end

--- Runs the skip-mode wait for 60 frames.
function wait.pause_one_second_skipping_2()
	wait.frames_skipping(60)
end

--- Waits fifteen skippable frames regardless of the requested count.
function wait.pause_skippable(requested_frames: s32)
	wait.frames_skipping(15)
end

--- Counts down 15 frames and then 36 frames without waiting.
function wait.resume_pause_15_then_36_frames(first_unused: s32, second_unused: s32)
	wait.skip_frame_count(15)
	wait.skip_frame_count(36)
end

--- Counts down four frames without waiting and then runs the skip-mode background load wait.
function wait.resume_pause_four_frames_then_background_load()
	wait.skip_frame_count(4)
	wait.background_load_skipping()
end

--- Counts down 60 frames without waiting.
function wait.resume_pause_one_second()
	wait.skip_frame_count(60)
end

--- Calls the skip-mode background load wait.
function wait.skip_background_load()
	wait.background_load_skipping()
end

--- Counts a frame count down once without waiting; this stands in for waiting on frames when events are skipped.
function wait.skip_frame_count(frames: any)
	local _ = frames >= 0
	frames = vm.wrap(frames - 1)
end

--- Stands in for a long pause when events are skipped: toggles an unknown state on, runs the 10, 30 and 20 frame skip-mode waits, toggles it off and runs a further 10.
function wait.skip_long_pause()
	cutscene.skip_command(1)
	wait.frames_skipping(10)
	wait.frames_skipping(30)
	wait.frames_skipping(20)
	cutscene.skip_command(0)
	wait.frames_skipping(10)
end

--- Stands in for a long pause when events are skipped in the main map scripts: toggles an unknown state on, counts down 10, 30 and 20 frames without waiting, toggles it off and counts down 10 more.
function wait.skip_long_pause_primary()
	cutscene.skip_command(1)
	wait.skip_frame_count(10)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	cutscene.skip_command(0)
	wait.skip_frame_count(10)
end

--- Stands in for a short pause when events are skipped: toggles an unknown state on, runs the 10 and 15 frame skip-mode waits, toggles it off and runs a further 10.
function wait.skip_short_pause()
	cutscene.skip_command(1)
	wait.frames_skipping(10)
	wait.frames_skipping(15)
	cutscene.skip_command(0)
	wait.frames_skipping(10)
end

--- Stands in for a short pause when events are skipped in the main map scripts: toggles an unknown state on, counts down 10 and 15 frames without waiting, toggles it off and counts down 10 more.
function wait.skip_short_pause_primary()
	cutscene.skip_command(1)
	wait.skip_frame_count(10)
	wait.skip_frame_count(15)
	cutscene.skip_command(0)
	wait.skip_frame_count(10)
end

--- Counts a ten frame wait down once without waiting and ignores its argument; this stands in for a ten frame wait when events are skipped.
function wait.skip_ten_frames(unused_value: s32)
	wait.skip_frame_count(10)
end

--- Runs one pass of a ten frame skippable wait without waiting and ignores its argument; this stands in for a ten frame wait when events are skipped.
function wait.skip_ten_frames_variant(unused_value: s32)
	wait.frames_skipping(10)
end

--- Waits until any button of a mask is pressed.
function wait.until_button_pressed(mask: s32)
	while true do
		if wait.is_button_pressed(mask) ~= 0 then
			break
		else
			vm.wait(1)
		end
	end
end

--- Checks a button mask twice without waiting; this stands in for waiting on a button press when events are skipped.
function wait.until_button_pressed_skipping(mask: s32)
	local _ = wait.is_button_pressed_skipping(mask)
	local _ = wait.is_button_pressed_skipping(mask)
end

--- Waits until the current motion of a character has finished.
function wait.until_motion_finished(character_slot: s32)
	local is_finished: s32 = 0
	while true do
		vm.wait(1)
		is_finished = event.is_character_motion_finished(character_slot) or is_finished
		if is_finished ~= 0 then
			break
		end
	end
end

--- Waits until the motion of a character reaches a progress value within a tolerance, giving up after a number of frames.
function wait.until_motion_progress(character_slot: s32, target_progress: f32, tolerance: f32, max_frames: s32)
	local current_progress: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.01)
	end
	for i = 0, max_frames - 1 do
		current_progress = event.get_character_motion_wait(character_slot) or current_progress
		if current_progress < vm.f32(target_progress + tolerance) and current_progress > vm.f32(target_progress - tolerance) then
			return
		end
		vm.wait(1)
	end
end

--- Waits until the motion of a character reaches a progress value within a tolerance, giving up after a number of frames.
function wait.until_motion_progress_counted(character_slot: s32, target_progress: f32, tolerance: f32, max_frames: any)
	local i: s32 = 0
	local current_progress: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.01)
	end
	i = 0
	while i < max_frames do
		current_progress = event.get_character_motion_wait(character_slot) or current_progress
		if current_progress < vm.f32(target_progress + tolerance) and current_progress > vm.f32(target_progress - tolerance) then
			return
		end
		vm.wait(1)
		i = vm.i32(i + 1)
	end
end

return wait
