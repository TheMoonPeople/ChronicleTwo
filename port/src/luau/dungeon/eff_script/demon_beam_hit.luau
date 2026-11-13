--!strict
--- The fire pillar and damage zone where the demon's beam strikes.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Plays the hit pillar motion at the impact point with a short damaging hitbox.
function script.on_start()
	local value: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local frame: s32 = 0
	local hit_num: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.get_script_value(0) or value
	print("damage=", value, "--------------\n")
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_scale(2.0, 2.0, 2.0)
	effect.set_effect_character_motion("七色蝶の火柱", -1, 6)
	effect.create_collision_primitive("中ＢＧＣ")
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 20.0)
	effect.set_collision_primitive_damage(value)
	hit_num = 0
	frame = 0
	while frame < 21 do
		if hit_num <= 0 then
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num > 0 or frame == 20 then
				hit_num = 1
				effect.delete_collision_primitive(-1)
			end
		end
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
