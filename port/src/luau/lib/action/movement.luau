--!strict
--- Player character evasive movement actions.

local vm = require("@lib/vm")
local timing = vm.module("@lib/action/timing")

local movement = {}

--- Performs Max's invulnerable backflip dodge while sliding backward.
function movement.max_backflip_dodge()
	local is_finished: s32 = 0
	local progress: f32 = 0
	action.play_motion("よけのみ(バク宙）", -1, 6)
	action.set_invulnerable_time(20)
	while true do
		vm.wait()
		progress = action.get_motion_progress() or progress
		if progress > vm.f32(0.18) and progress < vm.f32(0.8) then
			action.set_move_impulse(4.0, 0.0, 1, 180)
		end
		is_finished = vm.float_bits(action.is_motion_finished()) or is_finished
		if is_finished ~= 0 then
			break
		end
	end
	timing.wait_frames(6)
	action.set_program_value(0)
end

--- Performs Monica's invulnerable backflip dodge while sliding backward.
function movement.monica_backflip_dodge()
	local is_finished: s32 = 0
	local progress: f32 = 0
	action.play_motion("バク転", -1, 6)
	action.set_invulnerable_time(20)
	while true do
		vm.wait()
		progress = action.get_motion_progress() or progress
		if progress > vm.f32(0.18) and progress < vm.f32(0.8) then
			action.set_move_impulse(3.0, 0.0, 1, 180)
		end
		is_finished = vm.float_bits(action.is_motion_finished()) or is_finished
		if is_finished ~= 0 then
			break
		end
	end
	timing.wait_frames(6)
	action.set_program_value(0)
end

return movement
