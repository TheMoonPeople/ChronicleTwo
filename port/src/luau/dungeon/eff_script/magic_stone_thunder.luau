--!strict
--- Shows a magic stone thunder area effect at the spawn position that damages characters inside it.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the thunder effect and sound, keeps a damage area until it hits something or frame 30 and waits for the motion to finish.
function script.on_start()
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
	effect.get_script_value(0)
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_motion("雷", -1, 6)
	effect.play_battle_sound(11, position_x, position_y, position_z)
	hit_count = 0
	frame = 0
	effect.create_collision_primitive("魔石雷")
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 15.0)
	while frame < 40 do
		if hit_count <= 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 or frame == 30 then
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
