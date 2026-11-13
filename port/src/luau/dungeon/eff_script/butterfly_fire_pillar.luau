--!strict
--- Spawns a fire pillar that damages whoever touches it for a short time.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the fire pillar motion at the target position with a damage sphere that lasts until it hits something or 20 frames pass.
function script.on_start()
	local damage: s32 = 0
	local pillar_x: f32 = 0
	local pillar_y: f32 = 0
	local pillar_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		pillar_x = out1 or pillar_x
		pillar_y = out2 or pillar_y
		pillar_z = out3 or pillar_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(pillar_x, pillar_y, pillar_z)
	effect.set_effect_character_motion("七色蝶の火柱", -1, 6)
	effect.create_collision_primitive("吹っ飛び中")
	effect.set_collision_primitive_shape(pillar_x, pillar_y, pillar_z, 20.0)
	effect.set_collision_primitive_damage(damage)
	hit_count = 0
	frame = 0
	while frame < 24 do
		if hit_count <= 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 or frame == 20 then
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
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
