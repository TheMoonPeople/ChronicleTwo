--!strict
--- Motion waiting helpers for monster scripts.

local vm = require("@lib/vm")
local calc = vm.module("@lib/monster/calc")
local movement = vm.module("@lib/monster/movement")
local reaction = vm.module("@lib/monster/reaction")
local sense = vm.module("@lib/monster/sense")
local timer = vm.module("@lib/monster/timer")

local motion = {}

--- Stops moving, resets the motion and stands idle for the given number of frames while updating the guard state.
function motion.idle_for_frames(frames: s32)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
	timer.wait_frames_guarded(frames)
end

--- Plays the fidget motion and waits for it to finish.
function motion.play_fidget()
	monster.reset_motion()
	monster.set_motion("遊び", -1, 6)
	motion.wait_until_finished()
end

--- Plays the idle animation while watching for the target within 60 units in front.
function motion.play_idle_and_watch_far()
	monster.set_motion("あそび", -1, 6)
	sense.wait_until_target_in_arc(60.0, 45.0, 35)
end

--- Plays the idle animation while watching for the target within 40 units in front.
function motion.play_idle_and_watch_near()
	monster.set_motion("あそび", -1, 6)
	sense.wait_until_target_in_arc(40.0, 45.0, 35)
end

--- Resets the monster's motion.
function motion.reset()
	monster.reset_motion()
end

--- Waits until the current motion finishes.
function motion.wait_until_complete()
	local finished: s32 = 0
	while true do
		timer.wait_one_frame()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			return
		end
	end
end

--- Waits until the motion status reports the ended state.
function motion.wait_until_ended()
	local status: s32 = 0
	status = monster.get_motion_status() or status
	while status ~= 4 do
		vm.wait()
		status = monster.get_motion_status() or status
	end
end

--- Waits frame by frame until the current motion has finished.
function motion.wait_until_finished()
	local finished: s32 = 0
	while true do
		vm.wait()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			return
		end
	end
end

--- Keeps turning toward the target until the current motion finishes.
function motion.wait_until_finished_facing_target(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	local finished: s32 = 0
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		timer.wait_one_frame()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			movement.stop_turning()
			break
		end
	end
end

--- Keeps turning toward the target until the current motion finishes, updating the guard state each frame.
function motion.wait_until_finished_facing_target_guarded(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	local finished: s32 = 0
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed_degrees)
		reaction.update_and_wait_frame()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			movement.stop_turning()
			break
		end
	end
end

--- Waits until the current motion has finished while updating the guard state.
function motion.wait_until_finished_guarded()
	local finished: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			return
		end
	end
end

--- Waits frame by frame until the current motion finishes. It updates the lighting each frame.
function motion.wait_until_finished_updating_lighting()
	local finished: s32 = 0
	while true do
		timer.wait_frame()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			return
		end
	end
end

--- Waits until the current motion finishes, updating the guard state and model lighting each frame.
function motion.wait_until_finished_with_lighting()
	local finished: s32 = 0
	while true do
		timer.wait_frame_with_lighting()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			return
		end
	end
end

--- Waits frame by frame, with reaction checks, until the current motion finishes.
function motion.wait_until_finished_with_reaction()
	local finished: s32 = 0
	while true do
		timer.wait_frame_with_reaction()
		finished = monster.is_motion_finished() or finished
		if finished ~= 0 then
			return
		end
	end
end

--- Waits until the motion reaches a progress point within a tolerance or finishes.
function motion.wait_until_progress(progress: f32, tolerance: f32)
	local current_progress: f32 = 0
	local frames: s32 = 0
	local finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frames = 0
	while true do
		reaction.update_and_wait_frame()
		current_progress = monster.get_motion_progress() or current_progress
		if current_progress < vm.f32(progress + tolerance) and current_progress > vm.f32(progress - tolerance) then
			break
		else
			finished = monster.is_motion_finished() or finished
			if finished ~= 0 then
				break
			else
				frames = vm.i32(frames + 1)
			end
		end
	end
end

--- Keeps turning toward the target until the motion progress is within a tolerance (0.05 when -1) of a progress value.
function motion.wait_until_progress_facing_target(turn_speed_degrees: f32, progress: f32, tolerance: f32)
	local target_angle: f32 = 0
	local current_progress: f32 = 0
	local turn_speed: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.05)
	end
	turn_speed = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		current_progress = monster.get_motion_progress() or current_progress
		if current_progress < vm.f32(progress + tolerance) and current_progress > vm.f32(progress - tolerance) then
			break
		else
			timer.wait_one_frame()
		end
	end
	movement.stop_turning()
end

--- Waits until the motion progress is within a tolerance (0.03 when -1) of a progress value or the motion finishes.
function motion.wait_until_progress_reached(progress: f32, tolerance: f32)
	local current_progress: f32 = 0
	local frame_count: s32 = 0
	local finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		timer.wait_one_frame()
		current_progress = monster.get_motion_progress() or current_progress
		if current_progress < vm.f32(progress + tolerance) and current_progress > vm.f32(progress - tolerance) then
			break
		else
			finished = monster.is_motion_finished() or finished
			if finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

--- Waits until the current motion's progress is within a tolerance of the given value or the motion finishes. It updates the lighting each frame.
function motion.wait_until_progress_updating_lighting(progress: f32, tolerance: f32)
	local current_progress: f32 = 0
	local frame_count: s32 = 0
	local finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		timer.wait_frame()
		current_progress = monster.get_motion_progress() or current_progress
		if current_progress < vm.f32(progress + tolerance) and current_progress > vm.f32(progress - tolerance) then
			break
		else
			finished = monster.is_motion_finished() or finished
			if finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

return motion
