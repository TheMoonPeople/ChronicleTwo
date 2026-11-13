--!strict
--- Shows an explosion at the position of a treasure chest.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Provides an empty initialisation program for the effect.
function script.init() end

--- Places the explosion character at the first work vector, plays its explosion motion and keeps the effect alive for 70 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local frame_index: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	frame_index = 0
	while frame_index < 70 do
		frame_index = frame_index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
