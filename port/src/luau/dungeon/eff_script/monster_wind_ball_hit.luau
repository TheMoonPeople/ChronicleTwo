--!strict
--- Shows the wind ball impact effect at the hit position.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the wind ball impact motion at the hit position and waits for it to finish.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.get_second_work_vector()
	effect.play_battle_sound(73, position_x, position_y, position_z)
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_motion("風弾（ヒット）", -1, 6)
	vm.wait()
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
