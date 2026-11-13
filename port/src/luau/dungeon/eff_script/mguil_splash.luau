--!strict
--- The magma splash shown where Mguil's attack lands.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Plays the slowed magma splash motion at the given position until it finishes.
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
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_scale(2.5, 2.5, 2.5)
	effect.set_effect_character_motion_speed(0.1)
	effect.set_effect_character_motion("マグマしぶき", -1, 6)
	effect.set_effect_character_motion_speed(0.1)
	vm.wait()
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
