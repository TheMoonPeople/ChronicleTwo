--!strict
--- Frame waiting helpers for monster scripts.

local vm = require("@lib/vm")
local lighting = vm.module("@lib/monster/lighting")
local reaction = vm.module("@lib/monster/reaction")
local state = vm.module("@lib/monster/state")

local timer = {}

--- Returns the dungeon time elapsed since the start time stored in a numbered timer slot.
function timer.get_elapsed_time(slot: s32)
	local elapsed: s32 = 0
	local start_time: s32 = 0
	elapsed = monster.get_dungeon_timer() or elapsed
	start_time = monster.get_variable(vm.i32(30 + slot)) or start_time
	elapsed = vm.i32(elapsed - start_time)
	return elapsed
end

--- Returns the dungeon time elapsed since the time stored in monster variable 5.
function timer.get_primary_elapsed()
	local elapsed: s32 = 0
	local start_time: s32 = 0
	elapsed = monster.get_dungeon_timer() or elapsed
	start_time = monster.get_variable(5) or start_time
	elapsed = vm.i32(elapsed - start_time)
	return elapsed
end

--- Stores the current dungeon time in a numbered timer slot.
function timer.start(slot: s32)
	local dungeon_time: s32 = 0
	dungeon_time = monster.get_dungeon_timer() or dungeon_time
	monster.set_variable(vm.i32(30 + slot), dungeon_time)
end

--- Stores the current dungeon time in monster variable 5.
function timer.start_primary()
	local dungeon_time: s32 = 0
	dungeon_time = monster.get_dungeon_timer() or dungeon_time
	monster.set_variable(5, dungeon_time)
end

--- Waits out the remaining cooldown frames and resets the cooldown to 20.
function timer.wait_cooldown_and_reset()
	local cooldown_frames: s32 = 0
	cooldown_frames = monster.get_variable(5) or cooldown_frames
	timer.wait_frames(cooldown_frames)
	monster.set_variable(5, 20)
end

--- Waits the given number of frames.
function timer.wait_for_frames(count: s32)
	for i = 0, count - 1 do
		timer.wait_one_frame()
	end
end

--- Waits frame after frame without ever returning.
function timer.wait_forever()
	while true do
		timer.wait_frame()
	end
end

--- Waits forever, updating the guard state every frame.
function timer.wait_forever_guarded()
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Waits forever.
function timer.wait_forever_unguarded()
	while true do
		timer.wait_one_frame()
	end
end

--- Updates the monster's lighting from its rage state and waits one frame.
function timer.wait_frame()
	lighting.update_from_rage_hits()
	vm.wait()
end

--- Updates the guard state and model lighting, then waits one frame.
function timer.wait_frame_with_lighting()
	reaction.update_guard_state()
	if reaction.is_guard_active() ~= 0 then
		if reaction.tick_guard_timer() ~= 0 then
			reaction.set_guard_active(0)
		end
	end
	lighting.update_from_rage_hits()
	vm.wait()
end

--- Waits one frame after checking for damage reactions and counting the frame.
function timer.wait_frame_with_reaction()
	reaction.update_guard_state()
	if reaction.is_guard_active() ~= 0 then
		if reaction.tick_guard_timer() ~= 0 then
			reaction.set_guard_active(0)
		end
	end
	state.increment_frame_counter()
	vm.wait()
end

--- Waits the given number of frames.
function timer.wait_frames(frames: any)
	while frames > 0 do
		vm.wait()
		frames = frames - 1
	end
end

--- Waits the given number of frames by counting the frame argument down to zero.
function timer.wait_frames_countdown(frames: any)
	while frames > 0 do
		vm.wait()
		frames = frames - 1
	end
end

--- Waits the given number of frames with a counting loop.
function timer.wait_frames_counted(frames: any)
	local elapsed: s32 = 0
	elapsed = 0
	while elapsed < frames do
		timer.wait_one_frame()
		elapsed = vm.i32(elapsed + 1)
	end
end

--- Waits the given number of frames while updating the guard state each frame.
function timer.wait_frames_guarded(frames: s32)
	for i = 0, frames - 1 do
		reaction.update_and_wait_frame()
	end
end

--- Waits the given number of frames, updating the monster's lighting each frame.
function timer.wait_frames_updating_lighting(frames: any)
	local i: s32 = 0
	i = 0
	while i < frames do
		timer.wait_frame()
		i = vm.i32(i + 1)
	end
end

--- Waits the given number of frames, updating the guard state each frame.
function timer.wait_frames_with_guard_update(frames: any)
	local i: s32 = 0
	i = 0
	while i < frames do
		reaction.update_and_wait_frame()
		i = vm.i32(i + 1)
	end
end

--- Waits the given number of frames, updating the guard state and model lighting each frame.
function timer.wait_frames_with_lighting(frames: any)
	local i: s32 = 0
	i = 0
	while i < frames do
		timer.wait_frame_with_lighting()
		i = vm.i32(i + 1)
	end
end

--- Waits a number of frames with reaction checks.
function timer.wait_frames_with_reaction(frames: any)
	local frame: s32 = 0
	frame = 0
	while frame < frames do
		timer.wait_frame_with_reaction()
		frame = vm.i32(frame + 1)
	end
end

--- Waits a single frame.
function timer.wait_one_frame()
	vm.wait()
end

return timer
