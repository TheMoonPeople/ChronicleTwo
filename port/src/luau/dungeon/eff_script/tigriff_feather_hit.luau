--!strict
--- Impact effect of a thrown Tigriff feather.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Plays the hit motion at the impact point.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	effect.set_effect_character_motion("ヒット", 6)
	effect.set_effect_character_position(hit_x, hit_y, hit_z)
	for i = 0, 21 do
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
