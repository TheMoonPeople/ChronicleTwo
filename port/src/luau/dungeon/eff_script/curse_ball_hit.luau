--!strict
--- Shows the burst of a curse ball hitting something.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Plays the hit motion at the first work vector and waits for it to finish.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_effect_character_motion("ヒット", 6)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	vm.wait()
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
