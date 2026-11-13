--!strict
--- A single sparkle that drifts upward and fades out above a healed character.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Floats one rotating sparkle sprite upward until it has faded away.
function script.on_start()
	local alpha: f32 = 0
	local spin_speed: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_texture("n_heal")
	effect.set_sprite_blend_mode(2)
	effect.allocate_sprites_1(1)
	effect.reset_sprites(0)
	effect.set_sprite_visible(0, 1)
	effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_sprite_size(0, 6.0, 6.0)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 32.0, 32.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0)
	alpha = 128.0
	value = effect.get_random_number(40.0) or value
	value = vm.f32(value - 20.0)
	value = vm.f32(vm.f32(value / 360.0) * vm.f32(3.1415927))
	spin_speed = value
	while true do
		effect.offset_sprite_position(0, 0.0, -0.1, 0.0)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, alpha)
		effect.offset_sprite_rotation(0, spin_speed)
		alpha = vm.f32(alpha - 4.0)
		if alpha <= 0.0 then
			break
		else
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
