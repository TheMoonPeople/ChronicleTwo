--!strict
--- The merged butterfly swarm that holds on screen until the effect ends.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Shows the butterfly union model at the position and holds it until the effect ends.
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
	effect.set_effect_character_scale(20.0, 20.0, 20.0)
	effect.set_effect_character_visible(1, 1, 0.1)
	while true do
		vm.wait()
	end
end

--- Fades out the butterfly union model and waits for it to disappear.
function script.on_finish()
	local frame: s32 = 0
	effect.set_effect_character_visible(0, 1, 0.04)
	frame = 0
	while true do
		if frame == 25 then
			break
		else
			frame = vm.i32(frame + 1)
			vm.wait()
		end
	end
end

return script
