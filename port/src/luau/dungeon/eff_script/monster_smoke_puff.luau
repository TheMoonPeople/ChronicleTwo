--!strict
--- Plays a puff of smoke of a given scale at the spawn position.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the smoke motion at the spawn position, defaulting to unit scale, and waits for it to finish.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local scale: f32 = 0
	local is_motion_finished: s32 = 0
	scale = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	scale = effect.get_script_value_float(0) or scale
	if scale == 0.0 then
		scale = 1.0
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_motion("煙", -1, 6)
	effect.set_effect_character_scale(scale, scale, scale)
	effect.set_effect_character_visible(1, 1, 0.1)
	is_motion_finished = 0
	while is_motion_finished == 0 do
		vm.wait()
		is_motion_finished = effect.is_effect_character_motion_finished() or is_motion_finished
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
