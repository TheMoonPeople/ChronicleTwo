--!strict
--- Spawns and configures sprite particles such as sparks and smoke.

local vm = require("@lib/vm")

local particles = {}

--- Places a sprite at a random point around a position and launches it along a heading with a slow spin while it fades.
function particles.spawn_smoke(sprite: s32, center_x: f32, center_y: f32, center_z: f32, heading: f32, range: f32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local fade_rate: f32 = 0
	local radius: f32 = 0
	local angle_radians: f32 = 0
	local spin_speed: f32 = 0
	local rise_speed: f32 = 0
	radius = effect.get_random_number(range) or radius
	angle_radians = effect.get_random_number(360.0) or angle_radians
	spin_speed = effect.get_random_number(0.01) or spin_speed
	rise_speed = effect.get_random_number(1.25) or rise_speed
	rise_speed = vm.f32(rise_speed + 2.0)
	angle_radians = vm.f32(vm.f32(angle_radians / 180.0) * vm.f32(3.1415927))
	spin_speed = vm.f32(spin_speed + vm.f32(0.024543693))
	position_x = vm.f32(center_x + vm.f32(vm.sin(angle_radians) * radius))
	position_y = center_y
	position_z = vm.f32(center_z + vm.f32(vm.cos(angle_radians) * radius))
	velocity_x = vm.f32(vm.f32(0.8) * vm.sin(heading))
	velocity_y = rise_speed
	velocity_z = vm.f32(vm.f32(0.8) * vm.cos(heading))
	effect.set_sprite_visible(sprite, 1)
	effect.set_sprite_position(sprite, position_x, position_y, position_z)
	effect.set_sprite_color(sprite, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_scale(sprite, 1.0, 1.0)
	effect.set_sprite_velocity(sprite, velocity_x, velocity_y, velocity_z)
	fade_rate = effect.get_random_number(3.0) or fade_rate
	effect.set_sprite_color_velocity(sprite, 0.0, 0.0, 0.0, fade_rate + 3.0)
	effect.set_sprite_angular_velocity(sprite, spin_speed)
	effect.set_sprite_scale_velocity(sprite, 0.01, 0.01)
end

--- Places a sprite at a random point around a center and launches it upward and outward while it fades.
function particles.spawn_spark(sprite: s32, range: f32, center_x: f32, center_y: f32, center_z: f32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local angle_radians: f32 = 0
	local radius: f32 = 0
	local height_offset: f32 = 0
	local scale: f32 = 0
	local unused_speed: f32 = 0
	local rise_speed: f32 = 0
	unused_speed = effect.get_random_number(150.0) or unused_speed
	unused_speed = vm.f32(unused_speed / 100.0)
	unused_speed = vm.f32(unused_speed + 2.0)
	scale = effect.get_random_number(6.0) or scale
	scale = vm.f32(scale + 1.0)
	scale = vm.f32(scale * 2.0)
	angle_radians = 1.0
	radius = 1.0
	height_offset = 1.0
	angle_radians = effect.get_random_number(360.0) or angle_radians
	radius = effect.get_random_number(range) or radius
	height_offset = effect.get_random_number(8.0) or height_offset
	angle_radians = vm.f32(vm.f32(angle_radians / 180.0) * vm.f32(3.1415927))
	x = vm.f32(vm.sin(angle_radians) * radius)
	y = 0.0
	z = vm.f32(vm.cos(angle_radians) * radius)
	position_x = vm.f32(center_x + x)
	position_y = vm.f32(vm.f32(center_y - height_offset) + 4.0)
	position_z = vm.f32(center_z + z)
	do
		local out1, out2, out3 = effect.normalize_vector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = effect.scale_vector(x, y, z, 1.2)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	effect.set_sprite_position(sprite, position_x, position_y, position_z)
	effect.set_sprite_color(sprite, 128.0, 128.0, 128.0, 128.0)
	effect.set_sprite_visible(sprite, 1)
	effect.set_sprite_scale(sprite, scale, scale)
	rise_speed = effect.get_random_number(4.0) or rise_speed
	rise_speed = vm.f32(rise_speed + 1.0)
	effect.set_sprite_velocity(sprite, x, rise_speed, z)
	effect.set_sprite_color_velocity(sprite, 0.0, 0.0, 0.0, -2.0)
end

return particles
