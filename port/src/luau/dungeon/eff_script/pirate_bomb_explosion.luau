--!strict
--- Plays a pirate bomb explosion with a short damage area.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Starts the explosion with a damage area that is removed after 30 frames.
function script.on_start()
	local damage: s32 = 0
	local is_collision_removed: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local frame: s32 = 0
	is_collision_removed = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	damage = effect.get_script_value(0) or damage
	effect.get_script_value(1)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.create_collision_primitive("海賊爆弾")
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 20.0)
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < 40 do
		if frame == 30 then
			is_collision_removed = 1
			effect.delete_collision_primitive(-1)
		end
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_finished()
	if is_collision_removed == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
