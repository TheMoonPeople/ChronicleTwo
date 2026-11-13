--!strict
--- Shows the jet flame of a flying character attached to its left or right jet bone.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Follows the owner's jet bone while the stop flag is clear, then keeps following for 30 frames while the flame fades out.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local stop_flag: s32 = 0
	local user_id: s32 = 0
	local is_right_jet: s32 = 0
	stop_flag = 0
	user_id = 0
	is_right_jet = 0
	user_id = effect.get_owner_character() or user_id
	stop_flag = effect.get_script_value(0) or stop_flag
	is_right_jet = effect.get_script_value(1) or is_right_jet
	effect.set_effect_character_visible(1, 1)
	print("id=", user_id, "--------\n")
	effect.set_effect_character_motion("MPジェット", -1, 4)
	while true do
		if is_right_jet ~= 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "jet_r")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "jet_r")
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
		else
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "jet_l")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "jet_l")
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
		end
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		vm.wait()
		stop_flag = effect.get_script_value(0) or stop_flag
		if stop_flag ~= 0 then
			break
		end
	end
	effect.set_effect_character_visible(0, 1, -3.0)
	for i = 0, 29 do
		if is_right_jet ~= 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "jet_r")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "jet_r")
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
		else
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "jet_l")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "jet_l")
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
		end
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		vm.wait()
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
