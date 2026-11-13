--!strict
--- Splashes droplets and spray when a character steps in shallow water.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Launches four tall droplet sprites and eight round spray sprites from around the step and lets them fade.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local index: s32 = 0
	local drop_x: f32 = 0
	local drop_y: f32 = 0
	local drop_z: f32 = 0
	local drop_radius: f32 = 0
	local drop_angle: f32 = 0
	local drop_rotation: f32 = 0
	local splash_x: f32 = 0
	local splash_y: f32 = 0
	local splash_z: f32 = 0
	local splash_radius: f32 = 0
	local splash_angle: f32 = 0
	local push_x: f32 = 0
	local push_y: f32 = 0
	local push_z: f32 = 0
	local splash_rotation: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
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
	index = 0
	while index < 4 do
		if index < 2 then
			effect.set_sprite_texture_rect(index, 129.0, 65.0, 30.0, 62.0)
		else
			effect.set_sprite_texture_rect(index, 161.0, 65.0, 30.0, 62.0)
		end
		drop_radius = effect.get_random_number(2.0) or drop_radius
		drop_radius = vm.f32(drop_radius + 2.0)
		drop_angle = effect.get_random_number(6.2831855) or drop_angle
		drop_angle = vm.f32(drop_angle - vm.f32(3.1415927))
		drop_angle = effect.wrap_angle(drop_angle) or drop_angle
		drop_x = vm.f32(vm.f32(vm.sin(drop_angle) * drop_radius) + work_vect1_x)
		drop_y = work_vect1_y
		drop_z = vm.f32(vm.f32(vm.cos(drop_angle) * drop_radius) + work_vect1_z)
		effect.set_sprite_position(index, drop_x, drop_y, drop_z)
		drop_x = effect.get_random_number(0.2) or drop_x
		drop_x = vm.f32(drop_x + vm.f32(0.92))
		effect.set_sprite_velocity(index, 0.0, drop_x, 0.0)
		drop_x = effect.get_random_number(-0.02) or drop_x
		drop_x = vm.f32(drop_x - vm.f32(0.05))
		effect.set_sprite_acceleration(index, 0.0, drop_x, 0.0)
		drop_x = effect.get_random_number(-30.0) or drop_x
		effect.set_sprite_color(index, 128.0, 128.0, 128.0, drop_x)
		drop_x = effect.get_random_number(6.0) or drop_x
		drop_x = vm.f32(drop_x + 12.0)
		effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, drop_x)
		drop_x = effect.get_random_number(-0.8) or drop_x
		drop_x = vm.f32(drop_x - vm.f32(1.2))
		effect.set_sprite_color_acceleration(index, 0.0, 0.0, 0.0, drop_x)
		effect.set_sprite_scale_velocity(index, 0.03, 0.03)
		effect.set_sprite_scale_acceleration(index, -0.003, -0.003)
		drop_rotation = effect.get_random_number(0.3) or drop_rotation
		drop_rotation = vm.f32(drop_rotation - vm.f32(0.15))
		drop_rotation = effect.wrap_angle(drop_rotation) or drop_rotation
		effect.set_sprite_rotation(index, drop_rotation)
		index = index + 1
	end
	while index < 12 do
		splash_radius = effect.get_random_number(1.0) or splash_radius
		splash_radius = vm.f32(splash_radius + 2.0)
		splash_angle = effect.get_random_number(6.2831855) or splash_angle
		splash_angle = vm.f32(splash_angle - vm.f32(3.1415927))
		splash_angle = effect.wrap_angle(splash_angle) or splash_angle
		splash_x = vm.f32(vm.f32(vm.sin(splash_angle) * splash_radius) + work_vect1_x)
		splash_y = vm.f32(work_vect1_y + 2.0)
		splash_z = vm.f32(vm.f32(vm.cos(splash_angle) * splash_radius) + work_vect1_z)
		effect.set_sprite_position(index, splash_x, splash_y, splash_z)
		do
			local out1, out2, out3 = effect.copy_vector(splash_x, splash_y, splash_z)
			push_x = out1 or push_x
			push_y = out2 or push_y
			push_z = out3 or push_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(push_x, push_y, push_z, work_vect1_x, work_vect1_y, work_vect1_z)
			push_x = out1 or push_x
			push_y = out2 or push_y
			push_z = out3 or push_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(push_x, push_y, push_z)
			push_x = out1 or push_x
			push_y = out2 or push_y
			push_z = out3 or push_z
		end
		splash_y = effect.get_random_number(0.1) or splash_y
		splash_y = vm.f32(splash_y + vm.f32(0.4))
		effect.set_sprite_velocity(index, push_x / 2.5, splash_y, push_z / 2.5)
		splash_y = effect.get_random_number(-0.01) or splash_y
		splash_y = vm.f32(splash_y - vm.f32(0.03))
		effect.set_sprite_acceleration(index, -push_x / 100.0, splash_y, -push_z / 100.0)
		splash_x = effect.get_random_number(-30.0) or splash_x
		splash_x = vm.f32(splash_x - 10.0)
		effect.set_sprite_color(index, 128.0, 128.0, 128.0, splash_x)
		splash_x = effect.get_random_number(6.0) or splash_x
		splash_x = vm.f32(splash_x + 16.0)
		effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, splash_x)
		splash_x = effect.get_random_number(-0.8) or splash_x
		splash_x = vm.f32(splash_x - vm.f32(1.6))
		effect.set_sprite_color_acceleration(index, 0.0, 0.0, 0.0, splash_x)
		splash_rotation = effect.get_random_number(6.2831855) or splash_rotation
		splash_rotation = vm.f32(splash_rotation - vm.f32(3.1415927))
		effect.set_sprite_rotation(index, splash_rotation)
		effect.set_sprite_scale_velocity(index, 0.04, 0.04)
		index = index + 1
	end
	index = 0
	while index < 30 do
		index = index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
