--!strict
--- Raises a monster fire pillar that burns characters standing at its position.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the fire pillar animation and sound and holds a fire collision for a short time or until it hits.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local damage: s32 = 0
	local is_collision_deleted: s32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	damage = effect.get_script_value(0) or damage
	effect.play_battle_sound(76, position_x, position_y, position_z)
	effect.set_effect_character_motion("火柱", -1, 6)
	is_collision_deleted = 0
	frame = 0
	effect.create_collision_primitive("火弾")
	effect.set_collision_primitive_damage(damage)
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 20.0)
	while frame < 20 do
		if is_collision_deleted == 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 then
				is_collision_deleted = 1
				effect.delete_collision_primitive(-1)
				break
			end
		end
		if frame == 13 then
			is_collision_deleted = 1
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
		frame = frame + 1
	end
	motion.wait_until_finished()
	if is_collision_deleted == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
