--!strict
--- A small puff of dust that fades in and then out.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Scatters a few dust sprites around the position and fades them in, then out, while they grow.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local index: s32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_4_2: f32 = 0
	local is_fading: s32 = 0
	local puff_scale: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(3)
	effect.reset_sprites(0, 3)
	effect.set_sprite_blend_mode(0, 1, 3)
	effect.set_sprite_visible(0, 1, 3)
	effect.set_sprite_size(0, 14.0, 14.0, 3)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 3)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 3)
	index = 0
	while index < 3 do
		value = effect.get_random_number(16.0) or value
		value = vm.f32(vm.f32(value - 8.0) + work_vect1_x)
		value_2 = effect.get_random_number(8.0) or value_2
		value_2 = vm.f32(value_2 + work_vect1_y)
		value_3 = effect.get_random_number(16.0) or value_3
		value_3 = vm.f32(vm.f32(value_3 - 8.0) + work_vect1_z)
		effect.set_sprite_position(index, value, value_2, value_3)
		effect.set_sprite_velocity(index, 0.0, 0.2, 0.0)
		effect.set_sprite_acceleration(index, 0.0, -0.01, 0.0)
		value_4 = effect.get_random_number(6.2831855) or value_4
		value_4 = vm.f32(value_4 - vm.f32(3.1415927))
		effect.set_sprite_rotation(index, value_4)
		value_4 = effect.get_random_number(0.06544985) or value_4
		value_4 = vm.f32(value_4 - vm.f32(0.034147747))
		effect.set_sprite_angular_velocity(index, value_4)
		index = index + 1
	end
	is_fading = 0
	value_4_2 = 0.0
	puff_scale = 1.0
	index = 0
	while index < 30 do
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, value_4_2, 3)
		if value_4_2 >= 128.0 then
			is_fading = 1
		end
		if is_fading == 0 then
			value_4_2 = vm.f32(value_4_2 + vm.f32(25.6))
		else
			value_4_2 = vm.f32(value_4_2 - vm.f32(6.4))
		end
		effect.set_sprite_scale(0, puff_scale, puff_scale, 3)
		puff_scale = vm.f32(puff_scale + vm.f32(0.06))
		index = index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
