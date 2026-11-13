--!strict
--- Shows a single spark sprite at the effect position that fades in and then out.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Fades a spark sprite in at the effect position and then fades it out.
function script.on_start()
	local spark_x: f32 = 0
	local spark_y: f32 = 0
	local spark_z: f32 = 0
	local alpha: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		spark_x = out1 or spark_x
		spark_y = out2 or spark_y
		spark_z = out3 or spark_z
	end
	effect.set_sprite_texture("effect00")
	effect.set_sprite_blend_mode(2)
	effect.allocate_sprites_1(1)
	effect.reset_sprites(0)
	effect.set_sprite_visible(0, 1)
	effect.set_sprite_position(0, spark_x, spark_y, spark_z)
	effect.set_sprite_size(0, 24.0, 24.0)
	effect.set_sprite_texture_rect(0, 193.0, 1.0, 62.0, 62.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0)
	alpha = 0.0
	while true do
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, alpha)
		alpha = vm.f32(alpha + vm.f32(25.6))
		if alpha >= 128.0 then
			alpha = 1.8e-43 -- retail: integer bits read as a float
			break
		end
		vm.wait()
	end
	while true do
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, alpha)
		alpha = vm.f32(alpha - vm.f32(12.8))
		if alpha <= 0.0 then
			break
		else
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
