--!strict
--- Spawns a tornado that damages whoever touches it.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the tornado motion at the target position with a damage sphere that lasts until it hits something or 18 frames pass, then waits out the motion.
function script.on_start()
	local damage: s32 = 0
	local tornado_x: f32 = 0
	local tornado_y: f32 = 0
	local tornado_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	damage = effect.get_script_value(0) or damage
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		tornado_x = out1 or tornado_x
		tornado_y = out2 or tornado_y
		tornado_z = out3 or tornado_z
	end
	effect.set_effect_character_position(tornado_x, tornado_y, tornado_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_motion("サンの竜巻", -1, 6)
	effect.create_collision_primitive("吹っ飛び中")
	effect.set_collision_primitive_damage(damage)
	effect.set_collision_primitive_shape(tornado_x, tornado_y, tornado_z, 20.0)
	frame = 0
	hit_count = 0
	while frame < 40 do
		if hit_count <= 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 then
				break
			end
		end
		if frame == 18 then
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	while frame < 40 do
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
