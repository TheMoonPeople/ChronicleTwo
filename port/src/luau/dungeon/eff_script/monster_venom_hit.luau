--!strict
--- Shows the splash where a monster venom glob lands.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the venom splash animation at the impact position for a fixed duration.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	effect.get_owner_character()
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_motion("ヒット", -1, 2)
	effect.set_effect_character_visible(1, 1, 0.1)
	for i = 0, 24 do
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
