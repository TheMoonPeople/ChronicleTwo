--!strict
--- Shows the shield barrier of Giltoni, playing its raise motion then holding it before fading.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Raises the shield, holds it for 30 frames, then fades it out over 25 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.set_effect_character_motion("発動", -1, 6)
	vm.wait()
	motion.wait_until_finished()
	effect.set_effect_character_motion("ループ")
	frame = 0
	while frame < 30 do
		frame = frame + 1
		vm.wait()
	end
	effect.set_effect_character_visible(0, 1, 0.04)
	frame = 0
	while frame < 25 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
