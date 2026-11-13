--!strict
--- Angle conversion, interpolation and other pure numeric helpers for monster scripts.

local vm = require("@lib/vm")

local calc = {}

--- Returns 1 or -1 when two angles differ by more than a tolerance in that direction and 0 when they are within it.
function calc.compare_angles(angle: f32, reference_angle: f32, tolerance: f32)
	local difference: f32 = 0
	difference = vm.f32(angle - reference_angle)
	if difference == 0.0 then
		return 0
	end
	if difference > vm.f32(3.1415927) then
		difference = vm.f32(difference - vm.f32(6.2831855))
	end
	if difference < vm.f32(-3.1415927) then
		difference = vm.f32(difference + vm.f32(6.2831855))
	end
	if difference > tolerance then
		return 1
	end
	if difference < -tolerance then
		return -1
	end
	return 0
end

--- Converts an angle from degrees to radians.
function calc.degrees_to_radians(degrees: f32)
	return vm.f32(vm.f32(degrees / 180.0) * vm.f32(3.1415927))
end

--- Returns the constant acceleration that covers a distance in a number of frames from an initial speed.
function calc.get_acceleration(distance: f32, initial_speed: f32, frames: f32, acceleration: f32)
	acceleration = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(distance - vm.f32(initial_speed * frames)) * 2.0), frames)), frames))
	return acceleration
end

--- Returns the x and z offsets of a distance travelled along an angle.
function calc.get_polar_offset(angle: f32, distance: f32, offset_x: f32, offset_z: f32)
	offset_x = vm.f32(vm.sin(angle) * distance)
	offset_z = vm.f32(vm.cos(angle) * distance)
	return offset_x, offset_z
end

--- Returns the value a given ratio of the way from one value to another.
function calc.interpolate(start_value: f32, end_value: f32, ratio: f32)
	return vm.f32(vm.f32(vm.f32(end_value - start_value) * ratio) + start_value)
end

--- Returns its argument unchanged.
function calc.pass_through(value: s32)
	return value
end

--- Converts an angle from radians to degrees.
function calc.radians_to_degrees(radians: f32)
	return vm.f32(vm.f32(radians * 180.0) / vm.f32(3.1415927))
end

return calc
