--!strict
--- Plays the large blast of the final bomb with a damage area.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Creates the damage area, plays the hit motion at the requested scale and waits for it to end.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local scale: f32 = 0
	local check_motion_end: s32 = 0
	scale = 0.0
	effect.get_random_number(6.2831855)
	effect.play_battle_sound(56)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.get_script_value(0)
	scale = effect.get_script_value_float(1) or scale
	if scale == 0.0 then
		scale = 1.0
	end
	effect.create_collision_primitive("Ｆボム")
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 80.0)
	effect.set_effect_character_scale(1.8, 1.8, 1.8)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_motion("ヒット", -1, 6)
	effect.set_effect_character_scale(scale, scale, scale)
	effect.set_effect_character_visible(1, 1, 0.1)
	check_motion_end = 0
	while check_motion_end == 0 do
		vm.wait()
		check_motion_end = effect.is_effect_character_motion_finished() or check_motion_end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
