--!strict
--- The impact flash of Monica's lightning magic with flying sparks and rotating streaks.

local vm = require("@lib/vm")

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Plays a flash, outward-flying sparks and spinning streaks at the impact point.
function script.on_start()
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	local power_scale: f32 = 0
	local index: s32 = 0
	local spark_count: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local random_pitch: f32 = 0
	local random_yaw: f32 = 0
	local streak_angle: f32 = 0
	local texture_column: s32 = 0
	local streak_index: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		impact_x = out1 or impact_x
		impact_y = out2 or impact_y
		impact_z = out3 or impact_z
	end
	power_scale = effect.get_script_value_float(0) or power_scale
	spark_count = vm.f32(16 + vm.f32(16 * power_scale))
	effect.set_sprite_texture("c02lightning_hit")
	effect.allocate_sprites_1(5 + spark_count)
	effect.reset_sprites(0, 5 + spark_count)
	effect.set_sprite_blend_mode(0, 2, 5 + spark_count)
	effect.set_sprite_visible(0, 1, 5 + spark_count)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 48.0, 48.0)
	effect.set_sprite_size(0, 20.0, 20.0)
	effect.set_sprite_position(0, impact_x, impact_y, impact_z)
	effect.set_sprite_scale(0, vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale), vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale))
	effect.ease_sprite_scale(0, 2.0 + vm.f32(2.0 * power_scale), 2.0 + vm.f32(2.0 * power_scale), 4.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 255.0)
	effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 6.0)
	effect.set_sprite_texture_rect(1, 16, 96, 32, 32, spark_count)
	effect.set_sprite_size(1, 6.0, 6.0, spark_count)
	effect.set_sprite_position(1, impact_x, impact_y, impact_z, spark_count)
	effect.set_sprite_color(1, 128.0, 128.0, 128.0, 128.0, spark_count)
	effect.set_sprite_color_acceleration(1, 0.0, 0.0, 0.0, -1.4, spark_count)
	effect.set_sprite_scale(1, vm.f32(0.6) + vm.f32(vm.f32(0.6) * power_scale), vm.f32(0.6) + vm.f32(vm.f32(0.6) * power_scale), spark_count)
	index = 0
	while index < spark_count do
		random_yaw = effect.get_random_number(6.2831855) or random_yaw
		random_yaw = vm.f32(random_yaw - vm.f32(3.1415927))
		random_pitch = effect.get_random_number(6.2831855) or random_pitch
		random_pitch = vm.f32(random_pitch - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.get_direction_vector(random_yaw, random_pitch, 0.0)
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
			local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, vm.f32(1.6) + vm.f32(vm.f32(1.6) * power_scale))
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		effect.set_sprite_velocity(vm.i32(1 + index), direction_x, direction_y, direction_z)
		direction_x = -vm.f32(direction_x * vm.f32(0.05))
		direction_y = -vm.f32(direction_y * vm.f32(0.05))
		direction_z = -vm.f32(direction_z * vm.f32(0.05))
		effect.set_sprite_acceleration(vm.i32(1 + index), direction_x, direction_y, direction_z)
		index = vm.i32(index + 1)
	end
	effect.set_sprite_size(1 + spark_count, 2.0, 12.8, 4)
	effect.set_sprite_color(1 + spark_count, 128.0, 128.0, 128.0, 255.0, 4)
	effect.ease_sprite_color(1 + spark_count, 128.0, 128.0, 128.0, 0.0, 5.0, 4)
	effect.set_sprite_scale(
		1 + spark_count,
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale),
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale),
		4
	)
	effect.ease_sprite_scale(1 + spark_count, 2.0 + vm.f32(2.0 * power_scale), 2.0 + vm.f32(2.0 * power_scale), 8.0, 4)
	streak_angle = effect.get_random_number(6.2831855) or streak_angle
	streak_angle = vm.f32(streak_angle - vm.f32(3.1415927))
	index = 0
	while index < 4 do
		streak_angle = vm.f32(streak_angle + vm.f32(0.7853982))
		streak_angle = effect.wrap_angle(streak_angle) or streak_angle
		effect.set_sprite_rotation(vm.f32(1 + spark_count) + index, streak_angle)
		random_yaw = effect.get_random_number(6.2831855) or random_yaw
		random_yaw = vm.f32(random_yaw - vm.f32(3.1415927))
		random_pitch = effect.get_random_number(6.2831855) or random_pitch
		random_pitch = vm.f32(random_pitch - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.get_direction_vector(random_yaw, random_pitch, 0.0)
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
			local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, vm.f32(2.8) + vm.f32(vm.f32(2.8) * power_scale))
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(direction_x, direction_y, direction_z, impact_x, impact_y, impact_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		effect.set_sprite_position(vm.f32(1 + spark_count) + index, direction_x, direction_y, direction_z)
		texture_column = effect.get_random_number_int(4) or texture_column
		effect.set_sprite_texture_rect(vm.f32(1 + spark_count) + index, vm.i32(vm.i32(texture_column * 20) + 48), 0, 20, 128)
		index = index + 1
	end
	streak_index = 0
	index = 0
	while index < 32 do
		if index < spark_count then
			effect.set_sprite_blinking(1 + index, 0.0, 0.0, 0.0, 32.0, 1.5707964)
		end
		texture_column = effect.get_random_number_int(4) or texture_column
		effect.set_sprite_texture_rect(vm.f32(1 + spark_count) + streak_index, vm.i32(vm.i32(texture_column * 20) + 48), 0, 20, 128)
		streak_index = streak_index + 1
		if streak_index >= 4 then
			streak_index = 0
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
