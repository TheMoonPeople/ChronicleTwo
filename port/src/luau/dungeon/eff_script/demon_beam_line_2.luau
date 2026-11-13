--!strict
--- The beam body of the demon's second beam, which tracks the target from the demon's mouth and spawns its impact effect.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Aims the beam from the owner's mouth frame through its charge, held and release phases, driving the impact effect at the beam end.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local yaw: f32 = 0
	local rotation_z: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local value: f32 = 0
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	local pos_y_2: f32 = 0
	local user_id: s32 = 0
	local frame: s32 = 0
	local value_2: s32 = 0
	local handle: s32 = 0
	local value_3: s32 = 0
	local scale: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	value_3 = 0
	value = 0.0
	user_id = effect.get_owner_character() or user_id
	value_3 = effect.get_script_value(0) or value_3
	value = effect.get_script_value_float(2) or value
	effect.set_effect_character_scale(value, value, value * 2.0)
	effect.set_effect_character_frame_visible("hamon", 0, 1)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_effect_character_motion("攻撃２入り", 6)
	while frame < 13 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "dcol2")
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(work_vect1_x, work_vect1_y, work_vect1_z)
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		effect.rotate_effect_character_toward(rotation_x, yaw, rotation_z)
		vm.wait()
		frame = frame + 1
		value_2 = effect.get_script_value(1) or value_2
		if value_2 == 1 then
			break
		end
	end
	handle = effect.create_effect_2("魔人ビームＨ２") or handle
	effect.set_effect_value(handle, 0, value_3)
	effect.set_effect_value(handle, 2, 0)
	effect.create_collision_primitive("通常攻撃")
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "dcol2")
		rotation_x = out1 or rotation_x
		yaw = out2 or yaw
		rotation_z = out3 or rotation_z
	end
	effect.set_effect_character_position(pos_x, pos_y, pos_z)
	effect.set_effect_character_motion("攻撃２ループ", 0)
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "dcol2")
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		yaw = motion.get_angle_to_target(work_vect1_x, work_vect1_y, work_vect1_z, yaw)
		effect.get_distance_between(work_vect1_x, work_vect1_y, work_vect1_z, pos_x, pos_y, pos_z)
		do
			local _, out2, _ = effect.get_effect_character_position()
			pos_y_2 = out2 or pos_y_2
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation()
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(rot_x, rot_y, rot_z)
			dir_x = out1 or dir_x
			dir_y = out2 or dir_y
			dir_z = out3 or dir_z
		end
		scale = pos_y_2
		do
			local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(offset_x, offset_y, offset_z, scale)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(work_vect1_x, work_vect1_y, work_vect1_z)
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_first_work_vector(handle, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_effect_value_float(handle, 1, value)
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		effect.rotate_effect_character_toward(rotation_x, yaw, rotation_z)
		vm.wait()
		value_2 = effect.get_script_value(1) or value_2
		if value_2 == 2 then
			break
		end
	end
	effect.delete_collision_primitive(-1)
	print("hit eff end-----------------------------\n")
	effect.set_effect_value(handle, 2, 1)
	effect.set_effect_character_motion("攻撃２戻り", 6)
	while frame < 40 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(work_vect1_x, work_vect1_y, work_vect1_z)
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_first_work_vector(handle, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		effect.rotate_effect_character_toward(rotation_x, yaw, rotation_z)
		vm.wait()
		frame = frame + 1
		value_2 = effect.get_script_value(1) or value_2
		if value_2 == 3 then
			break
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
