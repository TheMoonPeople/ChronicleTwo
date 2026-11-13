--!strict
--- Explosion of the final bomb that damages anything nearby.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Plays the explosion and damages targets in the blast until it fades.
function script.on_start()
	local damage: s32 = 0
	local blast_x: f32 = 0
	local blast_y: f32 = 0
	local blast_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		blast_x = out1 or blast_x
		blast_y = out2 or blast_y
		blast_z = out3 or blast_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(blast_x, blast_y, blast_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.set_effect_character_scale(2.0, 2.0, 2.0)
	effect.play_battle_sound(11, blast_x, blast_y, blast_z)
	hit_count = 0
	frame = 0
	effect.create_collision_primitive("通常ＢＧＣ")
	effect.set_collision_primitive_shape(blast_x, blast_y, blast_z, 24.0)
	effect.set_collision_primitive_damage(damage)
	while frame < 20 do
		if hit_count <= 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 or frame == 15 then
				hit_count = 1
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
--- Does nothing when the effect ends.
function script.on_finish() end

return script
