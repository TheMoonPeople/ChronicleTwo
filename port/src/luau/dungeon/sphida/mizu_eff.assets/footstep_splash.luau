--!strict
--- Water splash effect that sprays droplet and ripple sprites outward from the spawn position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no initialisation program.
function script.init() end

--- Spawns four upward splash sprites and eight outward-flying droplet sprites around the effect position, then waits 30 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local sprite_index: s32 = 0
	local value: f32 = 0
	local spawn_y: f32 = 0
	local spawn_z: f32 = 0
	local value_2: f32 = 0
	local splash_angle: f32 = 0
	local tilt_angle: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local droplet_z: f32 = 0
	local value_5: f32 = 0
	local droplet_angle: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local value_6: f32 = 0
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
	sprite_index = 0
	while sprite_index < 4 do
		if sprite_index < 2 then
			effect.set_sprite_texture_rect(sprite_index, 129.0, 65.0, 30.0, 62.0)
		else
			effect.set_sprite_texture_rect(sprite_index, 161.0, 65.0, 30.0, 62.0)
		end
		value_2 = effect.get_random_number(2.0) or value_2
		value_2 = vm.f32(value_2 + 2.0)
		splash_angle = effect.get_random_number(6.2831855) or splash_angle
		splash_angle = vm.f32(splash_angle - vm.f32(3.1415927))
		splash_angle = effect.wrap_angle(splash_angle) or splash_angle
		value = vm.f32(vm.f32(vm.sin(splash_angle) * value_2) + work_vect1_x)
		spawn_y = work_vect1_y
		spawn_z = vm.f32(vm.f32(vm.cos(splash_angle) * value_2) + work_vect1_z)
		effect.set_sprite_position(sprite_index, value, spawn_y, spawn_z)
		value = effect.get_random_number(0.2) or value
		value = vm.f32(value + vm.f32(0.92))
		effect.set_sprite_velocity(sprite_index, 0.0, value, 0.0)
		value = effect.get_random_number(-0.02) or value
		value = vm.f32(value - vm.f32(0.05))
		effect.set_sprite_acceleration(sprite_index, 0.0, value, 0.0)
		value = effect.get_random_number(-30.0) or value
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, value)
		value = effect.get_random_number(6.0) or value
		value = vm.f32(value + 12.0)
		effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, value)
		value = effect.get_random_number(-0.8) or value
		value = vm.f32(value - vm.f32(1.2))
		effect.set_sprite_color_acceleration(sprite_index, 0.0, 0.0, 0.0, value)
		effect.set_sprite_scale_velocity(sprite_index, 0.03, 0.03)
		effect.set_sprite_scale_acceleration(sprite_index, -0.003, -0.003)
		tilt_angle = effect.get_random_number(0.3) or tilt_angle
		tilt_angle = vm.f32(tilt_angle - vm.f32(0.15))
		tilt_angle = effect.wrap_angle(tilt_angle) or tilt_angle
		effect.set_sprite_rotation(sprite_index, tilt_angle)
		sprite_index = sprite_index + 1
	end
	while sprite_index < 12 do
		value_5 = effect.get_random_number(1.0) or value_5
		value_5 = vm.f32(value_5 + 2.0)
		droplet_angle = effect.get_random_number(6.2831855) or droplet_angle
		droplet_angle = vm.f32(droplet_angle - vm.f32(3.1415927))
		droplet_angle = effect.wrap_angle(droplet_angle) or droplet_angle
		value_3 = vm.f32(vm.f32(vm.sin(droplet_angle) * value_5) + work_vect1_x)
		value_4 = vm.f32(work_vect1_y + 2.0)
		droplet_z = vm.f32(vm.f32(vm.cos(droplet_angle) * value_5) + work_vect1_z)
		effect.set_sprite_position(sprite_index, value_3, value_4, droplet_z)
		do
			local out1, out2, out3 = effect.copy_vector(value_3, value_4, droplet_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(direction_x, direction_y, direction_z, work_vect1_x, work_vect1_y, work_vect1_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(direction_x, direction_y, direction_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		value_4 = effect.get_random_number(0.1) or value_4
		value_4 = vm.f32(value_4 + vm.f32(0.4))
		effect.set_sprite_velocity(sprite_index, direction_x / 2.5, value_4, direction_z / 2.5)
		value_4 = effect.get_random_number(-0.01) or value_4
		value_4 = vm.f32(value_4 - vm.f32(0.03))
		effect.set_sprite_acceleration(sprite_index, -direction_x / 100.0, value_4, -direction_z / 100.0)
		value_3 = effect.get_random_number(-30.0) or value_3
		value_3 = vm.f32(value_3 - 10.0)
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, value_3)
		value_3 = effect.get_random_number(6.0) or value_3
		value_3 = vm.f32(value_3 + 16.0)
		effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, value_3)
		value_3 = effect.get_random_number(-0.8) or value_3
		value_3 = vm.f32(value_3 - vm.f32(1.6))
		effect.set_sprite_color_acceleration(sprite_index, 0.0, 0.0, 0.0, value_3)
		value_6 = effect.get_random_number(6.2831855) or value_6
		value_6 = vm.f32(value_6 - vm.f32(3.1415927))
		effect.set_sprite_rotation(sprite_index, value_6)
		effect.set_sprite_scale_velocity(sprite_index, 0.04, 0.04)
		sprite_index = sprite_index + 1
	end
	sprite_index = 0
	while sprite_index < 30 do
		sprite_index = sprite_index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
