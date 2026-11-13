--!strict
--- Shows an explosion that damages nearby characters, used for the robo missile and the treasure box explosions.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the explosion animation at the given position with a damaging collision that lasts part of the animation.
function script.on_start()
	local damage: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.create_collision_primitive("鼻爆弾", 0)
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 20.0)
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < 40 do
		if frame == 30 then
			effect.delete_collision_primitive(-1)
		end
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_finished()
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
