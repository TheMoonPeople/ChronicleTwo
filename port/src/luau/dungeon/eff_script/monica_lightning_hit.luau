--!strict
--- Monica's lightning magic impact with a flash, sparks and electric streaks.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Spawns the flash, scattering sparks and electric streaks at the hit point.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local power: f32 = 0
	local index: s32 = 0
	local spark_count: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local spark_yaw: f32 = 0
	local spark_pitch: f32 = 0
	local streak_angle: f32 = 0
	local streak_variant: s32 = 0
	local streak_cycle: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	power = effect.get_script_value_float(0) or power
	spark_count = vm.f32(16 + vm.f32(16 * power))
	effect.set_sprite_texture("c02lightning_hit")
	effect.allocate_sprites_1(5 + spark_count)
	effect.reset_sprites(0, 5 + spark_count)
	effect.set_sprite_blend_mode(0, 2, 5 + spark_count)
	effect.set_sprite_visible(0, 1, 5 + spark_count)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 48.0, 48.0)
	effect.set_sprite_size(0, 20.0, 20.0)
	effect.set_sprite_position(0, hit_x, hit_y, hit_z)
	effect.set_sprite_scale(0, vm.f32(0.2) + vm.f32(vm.f32(0.2) * power), vm.f32(0.2) + vm.f32(vm.f32(0.2) * power))
	effect.ease_sprite_scale(0, 2.0 + vm.f32(2.0 * power), 2.0 + vm.f32(2.0 * power), 4.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 255.0)
	effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 6.0)
	effect.set_sprite_texture_rect(1, 16, 96, 32, 32, spark_count)
	effect.set_sprite_size(1, 6.0, 6.0, spark_count)
	effect.set_sprite_position(1, hit_x, hit_y, hit_z, spark_count)
	effect.set_sprite_color(1, 128.0, 128.0, 128.0, 128.0, spark_count)
	effect.set_sprite_color_acceleration(1, 0.0, 0.0, 0.0, -1.4, spark_count)
	effect.set_sprite_scale(1, vm.f32(0.6) + vm.f32(vm.f32(0.6) * power), vm.f32(0.6) + vm.f32(vm.f32(0.6) * power), spark_count)
	index = 0
	while index < spark_count do
		spark_pitch = effect.get_random_number(6.2831855) or spark_pitch
		spark_pitch = vm.f32(spark_pitch - vm.f32(3.1415927))
		spark_yaw = effect.get_random_number(6.2831855) or spark_yaw
		spark_yaw = vm.f32(spark_yaw - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.get_direction_vector(spark_pitch, spark_yaw, 0.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, vm.f32(1.6) + vm.f32(vm.f32(1.6) * power))
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		effect.set_sprite_velocity(vm.i32(1 + index), velocity_x, velocity_y, velocity_z)
		velocity_x = -vm.f32(velocity_x * vm.f32(0.05))
		velocity_y = -vm.f32(velocity_y * vm.f32(0.05))
		velocity_z = -vm.f32(velocity_z * vm.f32(0.05))
		effect.set_sprite_acceleration(vm.i32(1 + index), velocity_x, velocity_y, velocity_z)
		index = vm.i32(index + 1)
	end
	effect.set_sprite_size(1 + spark_count, 2.0, 12.8, 4)
	effect.set_sprite_color(1 + spark_count, 128.0, 128.0, 128.0, 255.0, 4)
	effect.ease_sprite_color(1 + spark_count, 128.0, 128.0, 128.0, 0.0, 5.0, 4)
	effect.set_sprite_scale(
		1 + spark_count,
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * power),
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * power),
		4
	)
	effect.ease_sprite_scale(1 + spark_count, 2.0 + vm.f32(2.0 * power), 2.0 + vm.f32(2.0 * power), 8.0, 4)
	streak_angle = effect.get_random_number(6.2831855) or streak_angle
	streak_angle = vm.f32(streak_angle - vm.f32(3.1415927))
	index = 0
	while index < 4 do
		streak_angle = vm.f32(streak_angle + vm.f32(0.7853982))
		streak_angle = effect.wrap_angle(streak_angle) or streak_angle
		effect.set_sprite_rotation(vm.f32(1 + spark_count) + index, streak_angle)
		spark_pitch = effect.get_random_number(6.2831855) or spark_pitch
		spark_pitch = vm.f32(spark_pitch - vm.f32(3.1415927))
		spark_yaw = effect.get_random_number(6.2831855) or spark_yaw
		spark_yaw = vm.f32(spark_yaw - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.get_direction_vector(spark_pitch, spark_yaw, 0.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, vm.f32(2.8) + vm.f32(vm.f32(2.8) * power))
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(velocity_x, velocity_y, velocity_z, hit_x, hit_y, hit_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		effect.set_sprite_position(vm.f32(1 + spark_count) + index, velocity_x, velocity_y, velocity_z)
		streak_variant = effect.get_random_number_int(4) or streak_variant
		effect.set_sprite_texture_rect(vm.f32(1 + spark_count) + index, vm.i32(vm.i32(streak_variant * 20) + 48), 0, 20, 128)
		index = index + 1
	end
	if power < 1.0 then
		effect.play_battle_sound(72, hit_x, hit_y, hit_z)
	else
		effect.play_battle_sound(78, hit_x, hit_y, hit_z)
	end
	streak_cycle = 0
	index = 0
	while index < 32 do
		if index < spark_count then
			effect.set_sprite_blinking(1 + index, 0.0, 0.0, 0.0, 32.0, 1.5707964)
		end
		streak_variant = effect.get_random_number_int(4) or streak_variant
		effect.set_sprite_texture_rect(vm.f32(1 + spark_count) + streak_cycle, vm.i32(vm.i32(streak_variant * 20) + 48), 0, 20, 128)
		streak_cycle = streak_cycle + 1
		if streak_cycle >= 4 then
			streak_cycle = 0
		end
		index = index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
