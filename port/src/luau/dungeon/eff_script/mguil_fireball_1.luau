--!strict
--- Mguil's first fire bolt, which arcs toward the target and erupts into a fire pillar on impact.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Flies a damaging fire bolt along a curved path until it hits the ground or a target, then spawns a fire pillar.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local path_x: f32 = 0
	local path_y: f32 = 0
	local path_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local sin_arc: f32 = 0
	local cos_arc: f32 = 0
	local cos_curve: f32 = 0
	local sin_curve: f32 = 0
	local one_minus_cos_curve: f32 = 0
	local character: s32 = 0
	local frame: s32 = 0
	local value: s32 = 0
	local curved_x: f32 = 0
	local curved_y: f32 = 0
	local curved_z: f32 = 0
	local hit_result: s32 = 0
	local scale: f32 = 0
	local scale_2: f32 = 0
	local scratch_y: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.get_script_value(0) or value
	character = effect.get_target_character() or character
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(character)
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	character = effect.get_owner_character() or character
	do
		local out1, out2, out3 = effect.get_direction_vector(rotation_x, rotation_y, rotation_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
		path_x = out1 or path_x
		path_y = out2 or path_y
		path_z = out3 or path_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(path_x, path_y, path_z, work_vect2_x)
		path_x = out1 or path_x
		path_y = out2 or path_y
		path_z = out3 or path_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("火炎弾ループ")
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(value)
	do
		local out1, out2, out3 = effect.copy_vector(work_vect1_x, work_vect1_y, work_vect1_z)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	work_vect2_y = vm.f32(vm.f32(work_vect2_y / 180.0) * vm.f32(3.1415927))
	cos_arc = vm.cos(work_vect2_y)
	sin_arc = vm.sin(work_vect2_y)
	work_vect2_z = vm.f32(vm.f32(work_vect2_z / 180.0) * vm.f32(3.1415927))
	cos_curve = vm.cos(work_vect2_z)
	sin_curve = vm.sin(work_vect2_z)
	one_minus_cos_curve = vm.f32(1.0 - cos_curve)
	frame = 0
	while frame < 60 do
		scale = vm.f32(vm.f32(work_vect2_x * cos_arc) * frame)
		scale_2 =
			vm.f32(vm.f32(vm.f32(work_vect2_x * sin_arc) * frame) + vm.f32(vm.f32(vm.f32(-0.5 * frame) * frame) / 2))
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			path_x = out1 or path_x
			path_y = out2 or path_y
			path_z = out3 or path_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(path_x, scratch_y, path_z, scale)
			path_x = out1 or path_x
			scratch_y = out2 or scratch_y
			path_z = out3 or path_z
		end
		path_y = 1.0
		do
			local out1, out2, _ = effect.scale_vector(scratch_y, path_y, 0, scale_2) -- retail: output 3 points past the frame, at the operand stack, so the value is lost
			scratch_y = out1 or scratch_y
			path_y = out2 or path_y
		end
		curved_x = vm.f32(
			vm.f32(
				vm.f32(path_x * vm.f32(cos_curve + vm.f32(vm.f32(one_minus_cos_curve * direction_x) * direction_x)))
					+ vm.f32(path_y * vm.f32(vm.f32(vm.f32(one_minus_cos_curve * direction_x) * direction_y) + vm.f32(direction_z * sin_curve)))
			) + vm.f32(path_z * vm.f32(vm.f32(vm.f32(one_minus_cos_curve * direction_x) * direction_z) + vm.f32(direction_y * sin_curve)))
		)
		curved_y = vm.f32(
			vm.f32(
				vm.f32(path_x * vm.f32(vm.f32(vm.f32(one_minus_cos_curve * direction_x) * direction_y) - vm.f32(direction_z * sin_curve)))
					+ vm.f32(path_y * vm.f32(cos_curve + vm.f32(vm.f32(one_minus_cos_curve * direction_y) * direction_y)))
			) + vm.f32(path_z * vm.f32(vm.f32(vm.f32(one_minus_cos_curve * direction_y) * direction_z) + vm.f32(direction_x * sin_curve)))
		)
		curved_z = vm.f32(
			vm.f32(
				vm.f32(path_x * vm.f32(vm.f32(vm.f32(one_minus_cos_curve * direction_z) * direction_x) + vm.f32(direction_y * sin_curve)))
					+ vm.f32(path_y * vm.f32(vm.f32(vm.f32(one_minus_cos_curve * direction_y) * direction_z) - vm.f32(direction_x * sin_curve)))
			) + vm.f32(path_z * vm.f32(cos_curve + vm.f32(vm.f32(one_minus_cos_curve * direction_z) * direction_z)))
		)
		do
			local out1, out2, out3 = effect.copy_vector(curved_x, curved_y, curved_z)
			path_x = out1 or path_x
			path_y = out2 or path_y
			path_z = out3 or path_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(path_x, path_y, path_z, work_vect1_x, work_vect1_y, work_vect1_z)
			path_x = out1 or path_x
			path_y = out2 or path_y
			path_z = out3 or path_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(path_x, path_y, path_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, path_x, path_y, path_z)
			curved_x = out1 or curved_x
			curved_y = out2 or curved_y
			curved_z = out3 or curved_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 and frame <= 52 then
			effect.delete_collision_primitive(-1)
			effect.create_effect_1("Ｍギル火柱１")
			effect.set_effect_first_work_vector(curved_x, curved_y, curved_z)
			effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
			effect.set_effect_value(0, value)
			break
		else
			effect.set_effect_character_position(path_x, path_y, path_z)
			effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
			effect.set_collision_primitive_shape(path_x, path_y, path_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.delete_collision_primitive(-1)
				effect.create_effect_1("Ｍギル火柱１")
				effect.set_effect_first_work_vector(path_x, path_y, path_z)
				effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
				effect.set_effect_value(0, value)
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(path_x, path_y, path_z)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				frame = frame + 1
				if frame == 47 then
					effect.set_effect_character_visible(0, 1, -10.0)
					effect.delete_collision_primitive(-1)
				end
			end
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
