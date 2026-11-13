--!strict
--- Explosion of the pumpkin bomb that damages anything nearby.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Plays the explosion motion and damages targets in the blast until it fades.
function script.on_start()
	local blast_x: f32 = 0
	local blast_y: f32 = 0
	local blast_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	local damage: s32 = 0
	local is_damage_ended: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		blast_x = out1 or blast_x
		blast_y = out2 or blast_y
		blast_z = out3 or blast_z
	end
	effect.get_second_work_vector()
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(blast_x, blast_y, blast_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_motion("火炎弾（ヒット）", -1, 6)
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	effect.set_collision_primitive_shape(blast_x, blast_y, blast_z, 15.0)
	is_damage_ended = 0
	frame = 0
	while frame < 20 do
		if is_damage_ended == 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 then
				is_damage_ended = 1
				effect.delete_collision_primitive(-1)
			end
		end
		if frame == 16 then
			is_damage_ended = 1
			effect.delete_collision_primitive(-1)
		end
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_finished()
	if is_damage_ended == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
