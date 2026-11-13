--!strict
--- Puffs out eight dust sprites that drift up, spin and fade.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Scatters eight dust sprites around the effect position, scaled by the second work vector, and lets them fade out for 60 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local index: s32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local spin: f32 = 0
	local spin_roll: s32 = 0
	local fade_speed: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, _ = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
	end
	effect.set_sprite_texture("e612_tutikemuri")
	effect.allocate_sprites_1(8)
	effect.reset_sprites(0, 8)
	effect.set_sprite_blend_mode(0, 1, 8)
	effect.set_sprite_visible(0, 1, 8)
	effect.set_sprite_size(0, 10.24, 8.32, 8)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 8)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 8)
	effect.set_sprite_scale(0, work_vect2_x, work_vect2_y, 8)
	effect.set_sprite_scale_velocity(0, vm.f32(0.06) * work_vect2_x, vm.f32(0.06) * work_vect2_y, 8)
	index = 0
	while index < 8 do
		sprite_x = effect.get_random_number(12.0 * work_vect2_x) or sprite_x
		sprite_x = vm.f32(vm.f32(sprite_x - vm.f32(vm.f32(12.0 * work_vect2_x) / 2.0)) + work_vect1_x)
		sprite_y = effect.get_random_number(vm.f32(12.0 * work_vect2_y) / 4.0) or sprite_y
		sprite_y = vm.f32(sprite_y + work_vect1_y)
		sprite_z = effect.get_random_number(12.0 * work_vect2_x) or sprite_z
		sprite_z = vm.f32(vm.f32(sprite_z - vm.f32(vm.f32(12.0 * work_vect2_x) / 2.0)) + work_vect1_z)
		effect.set_sprite_position(index, sprite_x, sprite_y, sprite_z)
		effect.set_sprite_velocity(index, 0.0, vm.f32(0.2) * work_vect2_y, 0.0)
		effect.set_sprite_acceleration(index, 0.0, vm.f32(-0.01) * work_vect2_y, 0.0)
		spin = effect.get_random_number(6.2831855) or spin
		spin = vm.f32(spin - vm.f32(3.1415927))
		effect.set_sprite_rotation(index, spin)
		spin_roll = 0
		spin_roll = effect.get_random_number_int(100) or spin_roll
		if vm.imod(spin_roll, 2) == 0 then
			spin = vm.f32(0.06)
		else
			spin = vm.f32(-0.06)
		end
		effect.set_sprite_angular_velocity(index, spin)
		effect.set_sprite_angular_acceleration(index, -vm.f32(spin * vm.f32(0.02)))
		fade_speed = effect.get_random_number(4.0) or fade_speed
		fade_speed = vm.f32(fade_speed + 20.0)
		effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, fade_speed)
		fade_speed = effect.get_random_number(2.0) or fade_speed
		fade_speed = vm.f32(fade_speed + 1.5)
		effect.set_sprite_color_acceleration(index, 0.0, 0.0, 0.0, -fade_speed)
		index = index + 1
	end
	index = 0
	while index < 60 do
		index = index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
