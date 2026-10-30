--!strict
-- dungeon/articles/eff01.assets/denkousekka_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	local check_motion_end: s32 = 0
	value = 0.0
	effect.get_random_number(6.2831855)
	effect.play_battle_sound(55)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.get_script_value(0)
	value = effect.get_script_value_float(1) or value
	if value == 0.0 then
		value = 1.0
	end
	effect.create_collision_primitive("電光石花")
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 24.0)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_motion("ヒット", -1, 6)
	effect.set_effect_character_scale(value, value, value)
	effect.set_effect_character_visible(1, 1, 0.1)
	check_motion_end = 0
	while check_motion_end == 0 do
		vm.wait()
		check_motion_end = effect.is_effect_character_motion_finished() or check_motion_end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
