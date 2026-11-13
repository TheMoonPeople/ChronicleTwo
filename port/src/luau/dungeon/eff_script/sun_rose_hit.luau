--!strict
--- Plays the rose impact motion and its hit sound.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the hit motion at the target position, plays the hit sound and waits for the motion to finish.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local owner_id: s32 = 0
	effect.get_script_value(0)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	effect.set_effect_character_position(hit_x, hit_y, hit_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_motion("薔薇ヒット", -1, 6)
	owner_id = effect.get_script_value(1) or owner_id
	effect.play_character_sound(owner_id, 8)
	vm.wait()
	motion.wait_until_finished()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
