--!strict
--- A projectile of butterfly scales that homes toward the target and bursts on contact.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Flies a damaging butterfly scale projectile toward the target until it hits, is guarded or times out.
function script.on_start()
	local scale: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local work_vect2_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	local target_id: s32 = 0
	local frame: s32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local rotation_error_x: f32 = 0
	local rotation_error_y: f32 = 0
	local reversed: s32 = 0
	local hit_num: s32 = 0
	scale = 12.5
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.get_script_value(0) or value
	target_id = effect.get_target_character() or target_id
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, work_vect2_z)
	effect.set_effect_character_motion("ループ", -1.0, 4)
	frame = 0
	while frame < 300 do
		if frame <= 6 then
			do
				local out1, out2, out3 = effect.get_direction_vector(rotation_x, rotation_y, work_vect2_z)
				aim_x = out1 or aim_x
				aim_y = out2 or aim_y
				aim_z = out3 or aim_z
			end
		elseif frame <= 30 then
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
				aim_x = out1 or aim_x
				aim_y = out2 or aim_y
				aim_z = out3 or aim_z
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(aim_x, aim_y, aim_z, position_x, position_y, position_z)
				aim_x = out1 or aim_x
				aim_y = out2 or aim_y
				aim_z = out3 or aim_z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(aim_x, aim_y, aim_z)
				aim_x = out1 or aim_x
				aim_y = out2 or aim_y
				aim_z = out3 or aim_z
			end
		end
		do
			local out1, out2, out3 = effect.copy_vector(aim_x, aim_y, aim_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, scale)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(target_id)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		pos_y_2 = vm.f32(pos_y_2 + 30.0)
		do
			local out1, out2, _ = effect.get_rotation_toward_9(position_x, position_y, position_z, pos_x_2, pos_y_2, pos_z_2)
			rotation_error_x = out1 or rotation_error_x
			rotation_error_y = out2 or rotation_error_y
		end
		rotation_error_x = vm.f32(rotation_error_x - rotation_x)
		rotation_error_y = vm.f32(rotation_error_y - rotation_y)
		rotation_error_x = effect.wrap_angle(rotation_error_x) or rotation_error_x
		rotation_error_y = effect.wrap_angle(rotation_error_y) or rotation_error_y
		rotation_error_x = vm.f32(rotation_error_x / 30.0)
		rotation_error_y = vm.f32(rotation_error_y / 60.0)
		rotation_x = vm.f32(rotation_x + rotation_error_x)
		rotation_y = vm.f32(rotation_y + rotation_error_y)
		rotation_x = effect.wrap_angle(rotation_x) or rotation_x
		rotation_y = effect.wrap_angle(rotation_y) or rotation_y
		do
			local out1, _, _, _ = effect.get_collision_primitive_knockback()
			reversed = out1 or reversed
		end
		if reversed > 0 then
			effect.create_effect_1("ガードエフェクトＡ")
			effect.set_effect_first_work_vector(position_x, position_y, position_z)
			effect.create_effect_1("蝶りんぷんＨ")
			effect.set_effect_first_work_vector(position_x, position_y, position_z)
			break
		else
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(rotation_x, rotation_y, work_vect2_z)
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num >= 1 then
				effect.create_effect_1("蝶りんぷんＨ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				break
			else
				if vm.imod(frame, 6) == 0 then
					effect.delete_collision_primitive(-1)
					effect.get_owner_character()
					effect.create_collision_primitive("りんぷん")
					effect.set_collision_primitive_damage(value)
					effect.set_collision_primitive_shape(position_x, position_y, position_z, 20.0)
				end
				frame = frame + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	frame = 0
	effect.set_effect_character_visible(0, 1, -3.0)
	while frame < 30 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
