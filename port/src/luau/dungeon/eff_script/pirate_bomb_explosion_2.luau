--!strict
--- The explosion of a thrown pirate bomb.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Plays the explosion at the given position with a damaging hitbox for the first frames.
function script.on_start()
	local value: s32 = 0
	local hitbox_deleted: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local frame: s32 = 0
	hitbox_deleted = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.get_script_value(0) or value
	effect.get_script_value(1)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.create_collision_primitive("海賊爆弾")
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 20.0)
	effect.set_collision_primitive_damage(value)
	frame = 0
	while frame < 40 do
		if frame == 30 then
			hitbox_deleted = 1
			effect.delete_collision_primitive(-1)
		end
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_finished()
	if hitbox_deleted == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
