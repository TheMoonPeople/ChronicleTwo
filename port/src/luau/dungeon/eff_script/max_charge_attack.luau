--!strict
--- Shows the charge-up activation motion over the character while a charge attack is held.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Keeps the activation motion on the owner for a fixed time.
function script.on_start()
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local owner_rotation_x: f32 = 0
	local owner_rotation_y: f32 = 0
	local owner_rotation_z: f32 = 0
	local frame: s32 = 0
	local owner_id: s32 = 0
	effect.set_effect_character_motion("発動", -1, 6)
	owner_id = effect.get_owner_character() or owner_id
	frame = 0
	while frame < 48 do
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			owner_x = out1 or owner_x
			owner_y = out2 or owner_y
			owner_z = out3 or owner_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_rotation_4(owner_id)
			owner_rotation_x = out1 or owner_rotation_x
			owner_rotation_y = out2 or owner_rotation_y
			owner_rotation_z = out3 or owner_rotation_z
		end
		effect.set_effect_character_position(owner_x, owner_y, owner_z)
		effect.rotate_effect_character_toward(owner_rotation_x, owner_rotation_y, owner_rotation_z)
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
