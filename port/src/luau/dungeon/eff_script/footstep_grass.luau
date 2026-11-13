--!strict
--- Kicks up a few grass sprites when a character steps on grass.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Throws three grass sprites upward, fading them in and out while they grow.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local index: s32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local spin: f32 = 0
	local alpha: f32 = 0
	local is_fading_out: s32 = 0
	local scale: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_lighting(1)
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(3)
	effect.reset_sprites(0, 3)
	effect.set_sprite_blend_mode(0, 1, 3)
	effect.set_sprite_visible(0, 1, 3)
	effect.set_sprite_size(0, 8.0, 8.0, 3)
	effect.set_sprite_texture_rect(0, 65.0, 65.0, 62.0, 62.0, 3)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 3)
	index = 0
	while index < 3 do
		sprite_x = effect.get_random_number(10.0) or sprite_x
		sprite_x = vm.f32(vm.f32(sprite_x - 5.0) + work_vect1_x)
		sprite_y = effect.get_random_number(5.0) or sprite_y
		sprite_y = vm.f32(sprite_y + work_vect1_y)
		sprite_z = effect.get_random_number(10.0) or sprite_z
		sprite_z = vm.f32(vm.f32(sprite_z - 5.0) + work_vect1_z)
		effect.set_sprite_position(index, sprite_x, sprite_y, sprite_z)
		effect.set_sprite_velocity(index, 0.0, 0.4, 0.0)
		effect.set_sprite_acceleration(index, 0.0, -0.03, 0.0)
		spin = effect.get_random_number(6.2831855) or spin
		spin = vm.f32(spin - vm.f32(3.1415927))
		effect.set_sprite_rotation(index, spin)
		spin = effect.get_random_number(0.06544985) or spin
		spin = vm.f32(spin - vm.f32(0.034147747))
		effect.set_sprite_angular_velocity(index, spin)
		index = index + 1
	end
	is_fading_out = 0
	alpha = 0.0
	scale = 1.0
	index = 0
	while index < 30 do
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, alpha, 3)
		if alpha >= 128.0 then
			is_fading_out = 1
		end
		if is_fading_out == 0 then
			alpha = vm.f32(alpha + vm.f32(25.6))
		else
			alpha = vm.f32(alpha - vm.f32(12.8))
		end
		effect.set_sprite_scale(0, scale, scale, 3)
		scale = vm.f32(scale + vm.f32(0.06))
		index = index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
