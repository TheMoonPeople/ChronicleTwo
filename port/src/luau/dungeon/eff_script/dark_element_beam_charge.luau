--!strict
--- Plays the beam wind-up motion while following the owner.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Scales the effect character and keeps it at the owner's orb joint while the wind-up motion plays.
function script.on_start()
	local orb_x: f32 = 0
	local orb_y: f32 = 0
	local orb_z: f32 = 0
	local scale: f32 = 0
	local owner_id: s32 = 0
	local frame: s32 = 0
	scale = 0.0
	scale = effect.get_script_value_float(0) or scale
	effect.set_effect_character_scale(scale, scale, scale)
	effect.set_effect_character_motion("攻撃２入り", 6)
	owner_id = effect.get_owner_character() or owner_id
	while frame < 73 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "tama")
			orb_x = out1 or orb_x
			orb_y = out2 or orb_y
			orb_z = out3 or orb_z
		end
		effect.set_effect_character_position(orb_x, orb_y, orb_z)
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
