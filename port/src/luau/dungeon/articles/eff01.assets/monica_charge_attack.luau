--!strict
--- Plays Monica's charged attack activation motion on an effect character that follows the owner.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Plays the activation motion at the owner's position and facing, refreshing the placement once after 24 frames, for 68 frames.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local frame: s32 = 0
	local owner_id: s32 = 0
	effect.set_effect_character_motion("発動", -1, 6)
	owner_id = effect.get_owner_character() or owner_id
	frame = 0
	do
		local out1, out2, out3 = effect.get_scene_character_position(owner_id)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(owner_id)
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	while frame < 24 do
		frame = frame + 1
		vm.wait()
	end
	do
		local out1, out2, out3 = effect.get_scene_character_position(owner_id)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(owner_id)
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	while frame < 68 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
