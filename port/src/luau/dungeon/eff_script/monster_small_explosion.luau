--!strict
--- Shows a small explosion that knocks nearby characters back.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the explosion animation and sound with a knockback collision that ends on the first hit or after a short time.
function script.on_start()
	local damage: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.play_battle_sound(11, position_x, position_y, position_z)
	hit_count = 0
	frame = 0
	effect.create_collision_primitive("吹っ飛び中")
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 12.0)
	effect.set_collision_primitive_damage(damage)
	while frame < 40 do
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
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
