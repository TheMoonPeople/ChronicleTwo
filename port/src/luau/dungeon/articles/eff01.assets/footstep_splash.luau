--!strict
--- Shows water droplets and spray thrown up by a footstep in water.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Launches droplet sprites upward and spray sprites outward from the footstep.
function script.on_start()
	local footstep_x: f32 = 0
	local footstep_y: f32 = 0
	local footstep_z: f32 = 0
	local i: s32 = 0
	local drop_x: f32 = 0
	local drop_y: f32 = 0
	local drop_z: f32 = 0
	local drop_radius: f32 = 0
	local drop_angle: f32 = 0
	local drop_rotation: f32 = 0
	local spray_x: f32 = 0
	local spray_y: f32 = 0
	local spray_z: f32 = 0
	local spray_radius: f32 = 0
	local spray_angle: f32 = 0
	local spray_direction_x: f32 = 0
	local spray_direction_y: f32 = 0
	local spray_direction_z: f32 = 0
	local spray_rotation: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		footstep_x = out1 or footstep_x
		footstep_y = out2 or footstep_y
		footstep_z = out3 or footstep_z
	end
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(12)
	effect.reset_sprites(0, 12)
	effect.set_sprite_blend_mode(0, 2, 12)
	effect.set_sprite_visible(0, 1, 12)
	effect.set_sprite_size(0, 8.0, 16.0, 4)
	effect.set_sprite_texture_rect(0, 129.0, 65.0, 30.0, 62.0, 4)
	effect.set_sprite_size(4, 15.0, 15.0, 8)
	effect.set_sprite_texture_rect(4, 129.0, 1.0, 62.0, 62.0, 8)
	i = 0
	while i < 4 do
		if i < 2 then
			effect.set_sprite_texture_rect(i, 129.0, 65.0, 30.0, 62.0)
		else
			effect.set_sprite_texture_rect(i, 161.0, 65.0, 30.0, 62.0)
		end
		drop_radius = effect.get_random_number(2.0) or drop_radius
		drop_radius = vm.f32(drop_radius + 2.0)
		drop_angle = effect.get_random_number(6.2831855) or drop_angle
		drop_angle = vm.f32(drop_angle - vm.f32(3.1415927))
		drop_angle = effect.wrap_angle(drop_angle) or drop_angle
		drop_x = vm.f32(vm.f32(vm.sin(drop_angle) * drop_radius) + footstep_x)
		drop_y = footstep_y
		drop_z = vm.f32(vm.f32(vm.cos(drop_angle) * drop_radius) + footstep_z)
		effect.set_sprite_position(i, drop_x, drop_y, drop_z)
		drop_x = effect.get_random_number(0.2) or drop_x
		drop_x = vm.f32(drop_x + vm.f32(0.92))
		effect.set_sprite_velocity(i, 0.0, drop_x, 0.0)
		drop_x = effect.get_random_number(-0.02) or drop_x
		drop_x = vm.f32(drop_x - vm.f32(0.05))
		effect.set_sprite_acceleration(i, 0.0, drop_x, 0.0)
		drop_x = effect.get_random_number(-30.0) or drop_x
		effect.set_sprite_color(i, 128.0, 128.0, 128.0, drop_x)
		drop_x = effect.get_random_number(6.0) or drop_x
		drop_x = vm.f32(drop_x + 12.0)
		effect.set_sprite_color_velocity(i, 0.0, 0.0, 0.0, drop_x)
		drop_x = effect.get_random_number(-0.8) or drop_x
		drop_x = vm.f32(drop_x - vm.f32(1.2))
		effect.set_sprite_color_acceleration(i, 0.0, 0.0, 0.0, drop_x)
		effect.set_sprite_scale_velocity(i, 0.03, 0.03)
		effect.set_sprite_scale_acceleration(i, -0.003, -0.003)
		drop_rotation = effect.get_random_number(0.3) or drop_rotation
		drop_rotation = vm.f32(drop_rotation - vm.f32(0.15))
		drop_rotation = effect.wrap_angle(drop_rotation) or drop_rotation
		effect.set_sprite_rotation(i, drop_rotation)
		i = i + 1
	end
	while i < 12 do
		spray_radius = effect.get_random_number(1.0) or spray_radius
		spray_radius = vm.f32(spray_radius + 2.0)
		spray_angle = effect.get_random_number(6.2831855) or spray_angle
		spray_angle = vm.f32(spray_angle - vm.f32(3.1415927))
		spray_angle = effect.wrap_angle(spray_angle) or spray_angle
		spray_x = vm.f32(vm.f32(vm.sin(spray_angle) * spray_radius) + footstep_x)
		spray_y = vm.f32(footstep_y + 2.0)
		spray_z = vm.f32(vm.f32(vm.cos(spray_angle) * spray_radius) + footstep_z)
		effect.set_sprite_position(i, spray_x, spray_y, spray_z)
		do
			local out1, out2, out3 = effect.copy_vector(spray_x, spray_y, spray_z)
			spray_direction_x = out1 or spray_direction_x
			spray_direction_y = out2 or spray_direction_y
			spray_direction_z = out3 or spray_direction_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(spray_direction_x, spray_direction_y, spray_direction_z, footstep_x, footstep_y, footstep_z)
			spray_direction_x = out1 or spray_direction_x
			spray_direction_y = out2 or spray_direction_y
			spray_direction_z = out3 or spray_direction_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(spray_direction_x, spray_direction_y, spray_direction_z)
			spray_direction_x = out1 or spray_direction_x
			spray_direction_y = out2 or spray_direction_y
			spray_direction_z = out3 or spray_direction_z
		end
		spray_y = effect.get_random_number(0.1) or spray_y
		spray_y = vm.f32(spray_y + vm.f32(0.4))
		effect.set_sprite_velocity(i, spray_direction_x / 2.5, spray_y, spray_direction_z / 2.5)
		spray_y = effect.get_random_number(-0.01) or spray_y
		spray_y = vm.f32(spray_y - vm.f32(0.03))
		effect.set_sprite_acceleration(i, -spray_direction_x / 100.0, spray_y, -spray_direction_z / 100.0)
		spray_x = effect.get_random_number(-30.0) or spray_x
		spray_x = vm.f32(spray_x - 10.0)
		effect.set_sprite_color(i, 128.0, 128.0, 128.0, spray_x)
		spray_x = effect.get_random_number(6.0) or spray_x
		spray_x = vm.f32(spray_x + 16.0)
		effect.set_sprite_color_velocity(i, 0.0, 0.0, 0.0, spray_x)
		spray_x = effect.get_random_number(-0.8) or spray_x
		spray_x = vm.f32(spray_x - vm.f32(1.6))
		effect.set_sprite_color_acceleration(i, 0.0, 0.0, 0.0, spray_x)
		spray_rotation = effect.get_random_number(6.2831855) or spray_rotation
		spray_rotation = vm.f32(spray_rotation - vm.f32(3.1415927))
		effect.set_sprite_rotation(i, spray_rotation)
		effect.set_sprite_scale_velocity(i, 0.04, 0.04)
		i = i + 1
	end
	i = 0
	while i < 30 do
		i = i + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
