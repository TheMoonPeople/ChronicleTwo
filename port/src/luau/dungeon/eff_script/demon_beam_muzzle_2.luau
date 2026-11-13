--!strict
--- The muzzle flash that follows the demon's mouth while it charges its second beam.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Plays the beam's charge-up motion at the owner's mouth frame for a fixed number of frames.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local yaw: f32 = 0
	local rotation_z: f32 = 0
	local value: f32 = 0
	local user_id: s32 = 0
	local frame: s32 = 0
	value = 0.0
	value = effect.get_script_value_float(0) or value
	effect.set_effect_character_scale(value, value, value)
	effect.set_effect_character_motion("攻撃２入り", 6)
	user_id = effect.get_owner_character() or user_id
	do
		local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "dcol2")
		rotation_x = out1 or rotation_x
		yaw = out2 or yaw
		rotation_z = out3 or rotation_z
	end
	effect.rotate_effect_character_toward(rotation_x, yaw, rotation_z)
	while frame < 73 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
