--!strict
--- Plays a shockwave burst at the spawn position that knocks characters away for a short time.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Enables a damage area of the chosen hit type around the spawn position and releases it at frame 16.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local damage: s32 = 0
	local hit_type: s32 = 0
	hit_type = 0
	effect.get_owner_character()
	damage = effect.get_script_value(0) or damage
	hit_type = effect.get_script_value(1) or hit_type
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_motion("発動", -1, 6)
	if hit_type == 0 then
		effect.create_collision_primitive("吹っ飛び弱")
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 30.0)
		effect.set_collision_primitive_damage(damage)
	end
	if hit_type == 1 then
		effect.create_collision_primitive("通常ＢＧＣ")
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 30.0)
		effect.set_collision_primitive_damage(damage)
	end
	for frame = 0, 19 do
		if frame == 16 then
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
	end
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
