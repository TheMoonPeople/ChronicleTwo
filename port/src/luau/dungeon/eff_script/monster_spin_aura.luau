--!strict
--- Shows a spinning aura that follows its owner for a set time and then fades out.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Keeps the aura on the owner's position for the requested number of frames, then fades it out.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local scale: f32 = 0
	local frame: s32 = 0
	local duration_frames: s32 = 0
	local owner_id: s32 = 0
	scale = 0.0
	duration_frames = 0
	owner_id = effect.get_owner_character() or owner_id
	effect.get_script_value(0)
	duration_frames = effect.get_script_value(1) or duration_frames
	scale = effect.get_script_value_float(2) or scale
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_scale(scale, scale, scale)
	effect.set_effect_character_motion("攻撃2loop")
	effect.set_effect_character_visible(1, 1, 0.1)
	frame = 0
	while frame < duration_frames do
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		effect.set_effect_character_position(position_x, position_y, position_z)
		vm.wait()
		frame = frame + 1
	end
	effect.set_effect_character_visible(0, 1, -0.1)
	frame = 0
	while frame < 15 do
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
