--!strict
--- Provides small numeric helpers for event scripts.

local vm = require("@lib/vm")

local calc = {}

--- Returns the absolute value of a number.
function calc.absolute(value: f32)
	if value < 0 then
		return vm.f32(-1.0 * value)
	else
		return value
	end
end

--- Returns the value step of steps of the way from one number to another.
function calc.interpolate(from: f32, to: f32, step: f32, steps: f32)
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(to - from) * step), steps)) + from)
end

--- Returns whether two angles differ by no more than a tolerance.
function calc.is_angle_within(first_angle: f32, second_angle: f32, tolerance: f32)
	local within: s32 = 0
	within = event.compare_angles(first_angle, second_angle, tolerance) or within
	return within
end

--- Returns the larger of two numbers.
function calc.max(first: f32, second: f32)
	if first > second then
		return first
	else
		return second
	end
end

--- Returns the value with its sign flipped.
function calc.negate(value: f32)
	return vm.f32(-1.0 * value)
end

return calc
