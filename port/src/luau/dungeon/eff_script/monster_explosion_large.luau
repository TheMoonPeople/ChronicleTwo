--!strict
--- Plays a large explosion at the spawn position that damages nearby characters for a short time.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Spawns the explosion with a damage area and sound, releases the damage area at frame 30 and waits for the motion to finish.
function script.on_start()
	local damage: s32 = 0
	local sound_id: s32 = 0
	local has_released_collision: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local frame: s32 = 0
	has_released_collision = 0
	damage = 0
	sound_id = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	damage = effect.get_script_value(0) or damage
	sound_id = effect.get_script_value(1) or sound_id
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.create_collision_primitive("通常ＢＧＣ")
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 50.0)
	effect.set_collision_primitive_damage(damage)
	effect.play_character_sound(sound_id, 7)
	frame = 0
	while frame < 40 do
		if frame == 30 then
			has_released_collision = 1
			effect.delete_collision_primitive(-1)
		end
		frame = frame + 1
		vm.wait()
	end
	if has_released_collision == 0 then
		effect.delete_collision_primitive(-1)
	end
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
