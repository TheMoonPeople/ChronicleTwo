--!strict
--- Shows a cloud of dust puffs rising from the ground at a point and fading out.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Scatters eight dust sprites near the work position that rise and spin while growing and fading out.
function script.on_start()
	local dust_x: f32 = 0
	local dust_y: f32 = 0
	local dust_z: f32 = 0
	local i: s32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local random_angle: f32 = 0
	local spin_choice: s32 = 0
	local alpha_velocity: f32 = 0
	local scale: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		dust_x = out1 or dust_x
		dust_y = out2 or dust_y
		dust_z = out3 or dust_z
	end
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(8)
	effect.reset_sprites(0, 8)
	effect.set_sprite_blend_mode(0, 1, 8)
	effect.set_sprite_visible(0, 1, 8)
	effect.set_sprite_size(0, 14.0, 14.0, 8)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 8)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 8)
	i = 0
	while i < 8 do
		sprite_x = effect.get_random_number(18.0) or sprite_x
		sprite_x = vm.f32(vm.f32(sprite_x - 9.0) + dust_x)
		sprite_y = effect.get_random_number(9.0) or sprite_y
		sprite_y = vm.f32(sprite_y + dust_y)
		sprite_z = effect.get_random_number(18.0) or sprite_z
		sprite_z = vm.f32(vm.f32(sprite_z - 9.0) + dust_z)
		effect.set_sprite_position(i, sprite_x, sprite_y, sprite_z)
		effect.set_sprite_velocity(i, 0.0, 0.2, 0.0)
		effect.set_sprite_acceleration(i, 0.0, -0.01, 0.0)
		random_angle = effect.get_random_number(6.2831855) or random_angle
		random_angle = vm.f32(random_angle - vm.f32(3.1415927))
		effect.set_sprite_rotation(i, random_angle)
		spin_choice = effect.get_random_number_int(100) or spin_choice
		if spin_choice < 50 then
			random_angle = vm.f32(0.06)
		else
			random_angle = vm.f32(-0.06)
		end
		effect.set_sprite_angular_velocity(i, random_angle)
		effect.set_sprite_angular_acceleration(i, -vm.f32(random_angle * vm.f32(0.02)))
		alpha_velocity = effect.get_random_number(10.0) or alpha_velocity
		alpha_velocity = vm.f32(alpha_velocity + vm.f32(15.6))
		effect.set_sprite_color_velocity(i, 0.0, 0.0, 0.0, alpha_velocity)
		alpha_velocity = effect.get_random_number(2.0) or alpha_velocity
		alpha_velocity = vm.f32(alpha_velocity + 2.0)
		effect.set_sprite_color_acceleration(i, 0.0, 0.0, 0.0, -alpha_velocity)
		i = i + 1
	end
	scale = 1.0
	i = 0
	while i < 30 do
		effect.set_sprite_scale(0, scale, scale, 8)
		scale = vm.f32(scale + vm.f32(0.06))
		i = i + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
