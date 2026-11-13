--!strict
--- Plays the explosion shown when a warship gun is damaged.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Places the explosion model with the second work vector's rotation and plays its motion for 47 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 0.0)
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(pitch, yaw, roll)
	effect.set_effect_character_motion("ｴﾌｪｸﾄ_バギー爆発", -1, 6)
	frame = 0
	while frame < 47 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
