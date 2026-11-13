--!strict
--- Shows the impact of Monica's fire magic as flame puffs and flying sparks around the hit position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Spawns randomly placed flame puffs and bursts of sparks around the hit position over sixty frames.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local charge_ratio: f32 = 0
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	local rotation: f32 = 0
	local frame: s32 = 0
	local puff_count: s32 = 0
	local spark_sprite_index: s32 = 0
	local spawn_roll: s32 = 0
	local puff_sprite_index: s32 = 0
	local spark_velocity_x: f32 = 0
	local spark_velocity_y: f32 = 0
	local spark_velocity_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	charge_ratio = effect.get_script_value_float(0) or charge_ratio
	effect.set_sprite_texture("c02flame")
	effect.allocate_sprites_1(36)
	effect.reset_sprites(0, 36)
	effect.set_sprite_size(0, 10.0, 10.0, 36)
	effect.set_sprite_visible(0, 0, 36)
	if charge_ratio < 1.0 then
		effect.play_battle_sound(70, hit_x, hit_y, hit_z)
	else
		effect.play_battle_sound(76, hit_x, hit_y, hit_z)
	end
	spawn_roll = 3
	spark_sprite_index = 6
	puff_count = 0
	while frame < 60 do
		if puff_count < 3 and vm.imod(spawn_roll, 3) == 0 then
			puff_x = effect.get_random_number(6.0 + vm.f32(6.0 * charge_ratio)) or puff_x
			puff_x = vm.f32(vm.f32(puff_x - vm.f32(vm.f32(6.0 + vm.f32(6.0 * charge_ratio)) / 2.0)) + hit_x)
			puff_y = effect.get_random_number(6.0 + vm.f32(6.0 * charge_ratio)) or puff_y
			puff_y = vm.f32(vm.f32(puff_y - vm.f32(vm.f32(6.0 + vm.f32(6.0 * charge_ratio)) / 2.0)) + hit_y)
			puff_z = effect.get_random_number(6.0 + vm.f32(6.0 * charge_ratio)) or puff_z
			puff_z = vm.f32(vm.f32(puff_z - vm.f32(vm.f32(6.0 + vm.f32(6.0 * charge_ratio)) / 2.0)) + hit_z)
			rotation = effect.get_random_number(6.2831855) or rotation
			rotation = vm.f32(rotation - vm.f32(3.1415927))
			rotation = effect.wrap_angle(rotation) or rotation
			puff_sprite_index = puff_count * 2
			effect.set_sprite_visible(puff_sprite_index, 1)
			effect.set_sprite_blend_mode(puff_sprite_index, 3)
			effect.set_sprite_texture_rect(puff_sprite_index, 64.0, 64.0, 64.0, 64.0)
			effect.set_sprite_position(puff_sprite_index, puff_x, puff_y, puff_z)
			effect.set_sprite_rotation(puff_sprite_index, rotation)
			effect.set_sprite_color(puff_sprite_index, 128.0, 128.0, 128.0, 16.0)
			effect.set_sprite_color_velocity(puff_sprite_index, 0.0, 0.0, 0.0, 2.56)
			effect.set_sprite_color_acceleration(puff_sprite_index, 0.0, 0.0, 0.0, -0.4)
			effect.set_sprite_scale(
				puff_sprite_index,
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * charge_ratio),
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * charge_ratio)
			)
			effect.ease_sprite_scale(puff_sprite_index, 6.0 + vm.f32(6.0 * charge_ratio), 6.0 + vm.f32(6.0 * charge_ratio), 6.0)
			puff_sprite_index = puff_sprite_index + 1
			effect.set_sprite_visible(puff_sprite_index, 1)
			effect.set_sprite_blend_mode(puff_sprite_index, 2)
			effect.set_sprite_texture_rect(puff_sprite_index, 0.0, 0.0, 64.0, 64.0)
			effect.set_sprite_position(puff_sprite_index, puff_x, puff_y, puff_z)
			effect.set_sprite_rotation(puff_sprite_index, rotation)
			effect.set_sprite_color(puff_sprite_index, 128.0, 128.0, 128.0, 92.0)
			effect.set_sprite_color_velocity(puff_sprite_index, 0.0, 0.0, 0.0, 2.56)
			effect.set_sprite_color_acceleration(puff_sprite_index, 0.0, 0.0, 0.0, -0.4)
			effect.set_sprite_scale(
				puff_sprite_index,
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * charge_ratio),
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * charge_ratio)
			)
			effect.ease_sprite_scale(puff_sprite_index, 6.0 + vm.f32(6.0 * charge_ratio), 6.0 + vm.f32(6.0 * charge_ratio), 6.0)
			for i = 0, 9 do
				effect.set_sprite_visible(spark_sprite_index, 1)
				effect.set_sprite_blend_mode(spark_sprite_index, 2)
				effect.set_sprite_size(spark_sprite_index, 4.0, 4.0)
				effect.set_sprite_texture_rect(spark_sprite_index, 91.0, 0.0, 18.0, 6.0)
				effect.set_sprite_position(spark_sprite_index, puff_x, puff_y, puff_z)
				effect.set_sprite_color(spark_sprite_index, 128.0, 128.0, 128.0, 128.0)
				effect.set_sprite_scale(spark_sprite_index, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio))
				rotation = effect.get_random_number(6.2831855) or rotation
				rotation = vm.f32(rotation - vm.f32(3.1415927))
				rotation = effect.wrap_angle(rotation) or rotation
				effect.set_sprite_rotation(spark_sprite_index, rotation)
				spark_velocity_x = effect.get_random_number(5.0 + vm.f32(5.0 * charge_ratio)) or spark_velocity_x
				spark_velocity_x = vm.f32(spark_velocity_x - vm.f32(vm.f32(5.0 + vm.f32(5.0 * charge_ratio)) / 2.0))
				spark_velocity_y = effect.get_random_number(5.0 + vm.f32(5.0 * charge_ratio)) or spark_velocity_y
				spark_velocity_y = vm.f32(spark_velocity_y - vm.f32(vm.f32(5.0 + vm.f32(5.0 * charge_ratio)) / 2.0))
				spark_velocity_z = effect.get_random_number(5.0 + vm.f32(5.0 * charge_ratio)) or spark_velocity_z
				spark_velocity_z = vm.f32(spark_velocity_z - vm.f32(vm.f32(5.0 + vm.f32(5.0 * charge_ratio)) / 2.0))
				effect.set_sprite_velocity(spark_sprite_index, spark_velocity_x, spark_velocity_y, spark_velocity_z)
				effect.set_sprite_acceleration(spark_sprite_index, -spark_velocity_x * vm.f32(0.05), -spark_velocity_y * vm.f32(0.05), -spark_velocity_z * vm.f32(0.05))
				effect.set_sprite_color_velocity(spark_sprite_index, 0.0, 0.0, 0.0, 0.0)
				effect.set_sprite_color_acceleration(spark_sprite_index, 0.0, 0.0, 0.0, -0.8)
				spark_sprite_index = vm.i32(spark_sprite_index + 1)
			end
			puff_count = puff_count + 1
		end
		spawn_roll = effect.get_random_number_int(100) or spawn_roll
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
