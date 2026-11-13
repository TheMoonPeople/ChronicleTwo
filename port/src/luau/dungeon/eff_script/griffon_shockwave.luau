--!strict
--- Creates an expanding shockwave that damages and knocks back nearby characters.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the shockwave motion and resizes its damage sphere in stages before removing it.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("攻撃１", -1, 6)
	effect.create_collision_primitive("吹っ飛び強")
	effect.set_collision_primitive_damage(damage)
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 15.0)
	frame = 0
	while frame < 62 do
		if frame == 3 then
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 40.0)
		end
		if frame == 7 then
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 70.0)
		end
		if frame == 17 then
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 50.0)
		end
		if frame == 26 then
			break
		else
			vm.wait()
			frame = frame + 1
		end
	end
	effect.delete_collision_primitive(-1)
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
