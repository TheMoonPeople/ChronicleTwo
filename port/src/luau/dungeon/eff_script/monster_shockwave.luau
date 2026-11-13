--!strict
--- Plays a shockwave of a given scale at the spawn position that knocks characters away.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Scales the shockwave, enables a knock-away damage area and releases it at frame 16.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local scale: f32 = 0
	local damage: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	damage = effect.get_script_value(0) or damage
	scale = effect.get_script_value_float(1) or scale
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_scale(scale, scale, scale)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_motion("発動", -1, 6)
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 30.0)
	effect.set_collision_primitive_damage(damage)
	for frame = 0, 16 do
		if frame == 16 then
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
	end
	motion.wait_until_finished()
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
