--!strict
--- Bursts into fire flashes and sparks where an event fire bolt lands.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Spawns up to three flame flashes with ten sparks each at random points around the impact over 60 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local power: f32 = 0
	local burst_x: f32 = 0
	local burst_y: f32 = 0
	local burst_z: f32 = 0
	local angle: f32 = 0
	local frame: s32 = 0
	local burst_count: s32 = 0
	local spark_index: s32 = 0
	local random_roll: s32 = 0
	local flash_sprite_index: s32 = 0
	local spark_velocity_x: f32 = 0
	local spark_velocity_y: f32 = 0
	local spark_velocity_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	power = effect.get_script_value_float(0) or power
	effect.set_sprite_texture("c02flame")
	effect.allocate_sprites_1(36)
	effect.reset_sprites(0, 36)
	effect.set_sprite_size(0, 10.0, 10.0, 36)
	effect.set_sprite_visible(0, 0, 36)
	random_roll = 3
	spark_index = 6
	burst_count = 0
	while frame < 60 do
		if burst_count < 3 and vm.imod(random_roll, 3) == 0 then
			burst_x = effect.get_random_number(6.0 + vm.f32(6.0 * power)) or burst_x
			burst_x = vm.f32(vm.f32(burst_x - vm.f32(vm.f32(6.0 + vm.f32(6.0 * power)) / 2.0)) + work_vect1_x)
			burst_y = effect.get_random_number(6.0 + vm.f32(6.0 * power)) or burst_y
			burst_y = vm.f32(vm.f32(burst_y - vm.f32(vm.f32(6.0 + vm.f32(6.0 * power)) / 2.0)) + work_vect1_y)
			burst_z = effect.get_random_number(6.0 + vm.f32(6.0 * power)) or burst_z
			burst_z = vm.f32(vm.f32(burst_z - vm.f32(vm.f32(6.0 + vm.f32(6.0 * power)) / 2.0)) + work_vect1_z)
			angle = effect.get_random_number(6.2831855) or angle
			angle = vm.f32(angle - vm.f32(3.1415927))
			angle = effect.wrap_angle(angle) or angle
			flash_sprite_index = burst_count * 2
			effect.set_sprite_visible(flash_sprite_index, 1)
			effect.set_sprite_blend_mode(flash_sprite_index, 3)
			effect.set_sprite_texture_rect(flash_sprite_index, 64.0, 64.0, 64.0, 64.0)
			effect.set_sprite_position(flash_sprite_index, burst_x, burst_y, burst_z)
			effect.set_sprite_rotation(flash_sprite_index, angle)
			effect.set_sprite_color(flash_sprite_index, 128.0, 128.0, 128.0, 16.0)
			effect.set_sprite_color_velocity(flash_sprite_index, 0.0, 0.0, 0.0, 2.56)
			effect.set_sprite_color_acceleration(flash_sprite_index, 0.0, 0.0, 0.0, -0.4)
			effect.set_sprite_scale(
				flash_sprite_index,
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * power),
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * power)
			)
			effect.ease_sprite_scale(flash_sprite_index, 6.0 + vm.f32(6.0 * power), 6.0 + vm.f32(6.0 * power), 6.0)
			flash_sprite_index = flash_sprite_index + 1
			effect.set_sprite_visible(flash_sprite_index, 1)
			effect.set_sprite_blend_mode(flash_sprite_index, 2)
			effect.set_sprite_texture_rect(flash_sprite_index, 0.0, 0.0, 64.0, 64.0)
			effect.set_sprite_position(flash_sprite_index, burst_x, burst_y, burst_z)
			effect.set_sprite_rotation(flash_sprite_index, angle)
			effect.set_sprite_color(flash_sprite_index, 128.0, 128.0, 128.0, 92.0)
			effect.set_sprite_color_velocity(flash_sprite_index, 0.0, 0.0, 0.0, 2.56)
			effect.set_sprite_color_acceleration(flash_sprite_index, 0.0, 0.0, 0.0, -0.4)
			effect.set_sprite_scale(
				flash_sprite_index,
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * power),
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * power)
			)
			effect.ease_sprite_scale(flash_sprite_index, 6.0 + vm.f32(6.0 * power), 6.0 + vm.f32(6.0 * power), 6.0)
			for i = 0, 9 do
				effect.set_sprite_visible(spark_index, 1)
				effect.set_sprite_blend_mode(spark_index, 2)
				effect.set_sprite_size(spark_index, 4.0, 4.0)
				effect.set_sprite_texture_rect(spark_index, 91.0, 0.0, 18.0, 6.0)
				effect.set_sprite_position(spark_index, burst_x, burst_y, burst_z)
				effect.set_sprite_color(spark_index, 128.0, 128.0, 128.0, 128.0)
				effect.set_sprite_scale(spark_index, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power))
				angle = effect.get_random_number(6.2831855) or angle
				angle = vm.f32(angle - vm.f32(3.1415927))
				angle = effect.wrap_angle(angle) or angle
				effect.set_sprite_rotation(spark_index, angle)
				spark_velocity_x = effect.get_random_number(5.0 + vm.f32(5.0 * power)) or spark_velocity_x
				spark_velocity_x = vm.f32(spark_velocity_x - vm.f32(vm.f32(5.0 + vm.f32(5.0 * power)) / 2.0))
				spark_velocity_y = effect.get_random_number(5.0 + vm.f32(5.0 * power)) or spark_velocity_y
				spark_velocity_y = vm.f32(spark_velocity_y - vm.f32(vm.f32(5.0 + vm.f32(5.0 * power)) / 2.0))
				spark_velocity_z = effect.get_random_number(5.0 + vm.f32(5.0 * power)) or spark_velocity_z
				spark_velocity_z = vm.f32(spark_velocity_z - vm.f32(vm.f32(5.0 + vm.f32(5.0 * power)) / 2.0))
				effect.set_sprite_velocity(spark_index, spark_velocity_x, spark_velocity_y, spark_velocity_z)
				effect.set_sprite_acceleration(spark_index, -spark_velocity_x * vm.f32(0.05), -spark_velocity_y * vm.f32(0.05), -spark_velocity_z * vm.f32(0.05))
				effect.set_sprite_color_velocity(spark_index, 0.0, 0.0, 0.0, 0.0)
				effect.set_sprite_color_acceleration(spark_index, 0.0, 0.0, 0.0, -0.8)
				spark_index = vm.i32(spark_index + 1)
			end
			burst_count = burst_count + 1
		end
		random_roll = effect.get_random_number_int(100) or random_roll
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
