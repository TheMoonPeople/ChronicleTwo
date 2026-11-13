--!strict
--- Waits for effect character motion and computes headings for effect characters.

local vm = require("@lib/vm")

local motion = {}

--- Returns the heading from the effect character's position to the given target position.
function motion.get_angle_to_target(target_x: f32, target_y: f32, target_z: f32, angle: f32)
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local result_angle: f32 = 0
	do
		local out1, out2, out3 = effect.get_effect_character_position()
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(target_x, target_y, target_z, character_x, character_y, character_z)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	result_angle = effect.get_arc_tangent(target_x, target_z) or result_angle
	angle = result_angle
	return angle
end

--- Waits frame by frame until the effect character's current motion has finished.
function motion.wait_until_finished()
	local is_finished: s32 = 0
	while true do
		is_finished = effect.is_effect_character_motion_finished() or is_finished
		if is_finished ~= 0 then
			break
		else
			vm.wait()
		end
	end
end

return motion
