--!strict
-- dungeon/eff_script/mj_beam_h2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_2: s32 = 0
	local value_3: s32 = 0
	local check_motion_end: s32 = 0
	value_3 = 0
	value_2 = 0
	value = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value_3 = effect.get_script_value(0) or value_3
	value = effect.get_script_value_float(1) or value
	value_2 = effect.get_script_value(2) or value_2
	effect.set_effect_character_scale(value, value, value)
	effect.set_effect_character_motion("攻撃２ループ", 0)
	effect.create_collision_primitive("魔人ビーム")
	effect.set_collision_primitive_damage(value_3)
	while true do
		value = effect.get_script_value_float(1) or value
		effect.set_effect_character_scale(value, value, value)
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 45.0)
		value_2 = effect.get_script_value(2) or value_2
		if value_2 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_character_motion("攻撃２戻り", 6)
	while true do
		vm.wait()
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
		check_motion_end = effect.is_effect_character_motion_finished() or check_motion_end
		if check_motion_end ~= 0 then
			break
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
