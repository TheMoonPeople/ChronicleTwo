--!strict
-- dungeon/eff_script/e49a_jibaku.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local hit_num: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	value = effect.get_script_value(0) or value
	effect.set_effect_character_motion("自爆", -1, 6)
	var6 = 0
	var7 = 0
	effect.create_collision_primitive("吹っ飛び中")
	effect.set_collision_primitive_damage(value)
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 35.0)
	while var7 < 47 do
		if var6 == 0 then
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num > 0 then
				var6 = 1
				effect.delete_collision_primitive(-1)
				break
			end
		end
		if var7 == 34 then
			if var6 == 0 then
				var6 = 1
				effect.delete_collision_primitive(-1)
			end
		end
		vm.wait()
		var7 = var7 + 1
	end
	while var7 < 35 do
		effect.get_effect_character_motion_progress()
		if var7 == 34 then
			if var6 == 0 then
				var6 = 1
				effect.delete_collision_primitive(-1)
			end
		end
		vm.wait()
		var7 = var7 + 1
	end
	helper_8b333653()
	if var6 == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
