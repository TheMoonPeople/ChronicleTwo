--!strict
--- Shows the impact of Monica's lightning magic as a flash with scattering sparks and radial streaks at the hit position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Plays a flash, flying sparks and rotating streaks at the hit position.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local charge_ratio: f32 = 0
	local i: s32 = 0
	local spark_count: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local random_yaw: f32 = 0
	local random_pitch: f32 = 0
	local streak_angle: f32 = 0
	local streak_variant: s32 = 0
	local streak_index: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	charge_ratio = effect.get_script_value_float(0) or charge_ratio
	spark_count = vm.f32(16 + vm.f32(16 * charge_ratio))
	effect.set_sprite_texture("c02lightning_hit")
	effect.allocate_sprites_1(5 + spark_count)
	effect.reset_sprites(0, 5 + spark_count)
	effect.set_sprite_blend_mode(0, 2, 5 + spark_count)
	effect.set_sprite_visible(0, 1, 5 + spark_count)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 48.0, 48.0)
	effect.set_sprite_size(0, 20.0, 20.0)
	effect.set_sprite_position(0, hit_x, hit_y, hit_z)
	effect.set_sprite_scale(0, vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio), vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio))
	effect.ease_sprite_scale(0, 2.0 + vm.f32(2.0 * charge_ratio), 2.0 + vm.f32(2.0 * charge_ratio), 4.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 255.0)
	effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 6.0)
	effect.set_sprite_texture_rect(1, 16, 96, 32, 32, spark_count)
	effect.set_sprite_size(1, 6.0, 6.0, spark_count)
	effect.set_sprite_position(1, hit_x, hit_y, hit_z, spark_count)
	effect.set_sprite_color(1, 128.0, 128.0, 128.0, 128.0, spark_count)
	effect.set_sprite_color_acceleration(1, 0.0, 0.0, 0.0, -1.4, spark_count)
	effect.set_sprite_scale(1, vm.f32(0.6) + vm.f32(vm.f32(0.6) * charge_ratio), vm.f32(0.6) + vm.f32(vm.f32(0.6) * charge_ratio), spark_count)
	i = 0
	while i < spark_count do
		random_pitch = effect.get_random_number(6.2831855) or random_pitch
		random_pitch = vm.f32(random_pitch - vm.f32(3.1415927))
		random_yaw = effect.get_random_number(6.2831855) or random_yaw
		random_yaw = vm.f32(random_yaw - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.get_direction_vector(random_pitch, random_yaw, 0.0)
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
		do
			local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, vm.f32(1.6) + vm.f32(vm.f32(1.6) * charge_ratio))
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		effect.set_sprite_velocity(vm.i32(1 + i), direction_x, direction_y, direction_z)
		direction_x = -vm.f32(direction_x * vm.f32(0.05))
		direction_y = -vm.f32(direction_y * vm.f32(0.05))
		direction_z = -vm.f32(direction_z * vm.f32(0.05))
		effect.set_sprite_acceleration(vm.i32(1 + i), direction_x, direction_y, direction_z)
		i = vm.i32(i + 1)
	end
	effect.set_sprite_size(1 + spark_count, 2.0, 12.8, 4)
	effect.set_sprite_color(1 + spark_count, 128.0, 128.0, 128.0, 255.0, 4)
	effect.ease_sprite_color(1 + spark_count, 128.0, 128.0, 128.0, 0.0, 5.0, 4)
	effect.set_sprite_scale(
		1 + spark_count,
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio),
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio),
		4
	)
	effect.ease_sprite_scale(1 + spark_count, 2.0 + vm.f32(2.0 * charge_ratio), 2.0 + vm.f32(2.0 * charge_ratio), 8.0, 4)
	streak_angle = effect.get_random_number(6.2831855) or streak_angle
	streak_angle = vm.f32(streak_angle - vm.f32(3.1415927))
	i = 0
	while i < 4 do
		streak_angle = vm.f32(streak_angle + vm.f32(0.7853982))
		streak_angle = effect.wrap_angle(streak_angle) or streak_angle
		effect.set_sprite_rotation(vm.f32(1 + spark_count) + i, streak_angle)
		random_pitch = effect.get_random_number(6.2831855) or random_pitch
		random_pitch = vm.f32(random_pitch - vm.f32(3.1415927))
		random_yaw = effect.get_random_number(6.2831855) or random_yaw
		random_yaw = vm.f32(random_yaw - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.get_direction_vector(random_pitch, random_yaw, 0.0)
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
		do
			local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, vm.f32(2.8) + vm.f32(vm.f32(2.8) * charge_ratio))
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(direction_x, direction_y, direction_z, hit_x, hit_y, hit_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		effect.set_sprite_position(vm.f32(1 + spark_count) + i, direction_x, direction_y, direction_z)
		streak_variant = effect.get_random_number_int(4) or streak_variant
		effect.set_sprite_texture_rect(vm.f32(1 + spark_count) + i, vm.i32(vm.i32(streak_variant * 20) + 48), 0, 20, 128)
		i = i + 1
	end
	if charge_ratio < 1.0 then
		effect.play_battle_sound(72, hit_x, hit_y, hit_z)
	else
		effect.play_battle_sound(78, hit_x, hit_y, hit_z)
	end
	streak_index = 0
	i = 0
	while i < 32 do
		if i < spark_count then
			effect.set_sprite_blinking(1 + i, 0.0, 0.0, 0.0, 32.0, 1.5707964)
		end
		streak_variant = effect.get_random_number_int(4) or streak_variant
		effect.set_sprite_texture_rect(vm.f32(1 + spark_count) + streak_index, vm.i32(vm.i32(streak_variant * 20) + 48), 0, 20, 128)
		streak_index = streak_index + 1
		if streak_index >= 4 then
			streak_index = 0
		end
		i = i + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
