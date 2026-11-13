--!strict
--- The smoke puff left behind by a robot missile.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Scatters a few smoke sprites around the position and fades them out while they grow.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_4_2: f32 = 0
	local smoke_scale: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_texture("m_kemuri")
	effect.allocate_sprites_1(8)
	effect.reset_sprites(0, 8)
	effect.set_sprite_blend_mode(0, 2, 8)
	effect.set_sprite_visible(0, 1, 8)
	effect.set_sprite_size(0, 10.0, 10.0, 8)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 8)
	for index = 0, 7 do
		value = effect.get_random_number(25.0) or value
		value = vm.f32(value - 12.5)
		value_2 = effect.get_random_number(25.0) or value_2
		value_2 = vm.f32(value_2 - 12.5)
		value_3 = effect.get_random_number(25.0) or value_3
		value_3 = vm.f32(value_3 - 12.5)
		effect.set_sprite_position(index, work_vect1_x + value, work_vect1_y + value_2, work_vect1_z + value_3)
		value_4 = effect.get_random_number(360.0) or value_4
		value_4 = vm.f32(vm.f32(vm.f32(vm.f32(value_4 / 360.0) * vm.f32(3.1415927)) * 2.0) - vm.f32(3.1415927))
		effect.set_sprite_rotation(index, value_4)
	end
	value_4_2 = 128.0
	smoke_scale = 1.0
	while true do
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, value_4_2, 8)
		effect.set_sprite_scale(0, smoke_scale, smoke_scale, 8)
		value_4_2 = vm.f32(value_4_2 - 6.0)
		if value_4_2 <= 0.0 then
			break
		else
			smoke_scale = vm.f32(smoke_scale + vm.f32(0.2))
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
