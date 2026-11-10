--!strict
-- dungeon/eff_script/e10a_kabobomb_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8b333653 = require("@lib/effect/helper_8b333653")

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
	local var6: s32 = 0
	local hit_num: s32 = 0
	local value: s32 = 0
	local var9: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.get_second_work_vector()
	value = effect.get_script_value(0) or value
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_motion("火炎弾（ヒット）", -1, 6)
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(value)
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 15.0)
	var9 = 0
	var6 = 0
	while var6 < 20 do
		if var9 == 0 then
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num > 0 then
				var9 = 1
				effect.delete_collision_primitive(-1)
			end
		end
		if var6 == 16 then
			var9 = 1
			effect.delete_collision_primitive(-1)
		end
		var6 = var6 + 1
		vm.wait()
	end
	helper_8b333653()
	if var9 == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
