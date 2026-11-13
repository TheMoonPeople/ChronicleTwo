--!strict
--- Mguil's third fire bolt, which lobs an arcing ball of fire that lands on a point near the player and erupts into a fire pillar.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Lobs a spark-trailing fire ball along an arc, then drops a second bolt onto a point near the player until it hits the ground.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local cos_elevation: f32 = 0
	local sin_elevation: f32 = 0
	local work_vect2_x: f32 = 0
	local frame: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local hit_result: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	value_3 = effect.get_script_value(0) or value_3
	value = effect.get_script_value_float(1) or value
	value_2 = effect.get_script_value_float(2) or value_2
	value_4 = effect.get_script_value(3) or value_4
	effect.set_effect_character_scale(2.0, 2.0, 2.0)
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	direction_y = 0.0
	do
		local out1, out2, out3 = effect.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	cos_elevation = vm.cos(vm.f32(1.0471976))
	sin_elevation = vm.sin(vm.f32(1.0471976))
	velocity_x = vm.f32(direction_x * cos_elevation)
	velocity_y = vm.f32(1.0 * sin_elevation)
	velocity_z = vm.f32(direction_z * cos_elevation)
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, value_2 * 2.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	frame = 0
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	while frame < vm.f32(15.0 + work_vect2_x) do
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(position_x, position_y, position_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(position_x, position_y, position_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		if frame > 1.0 then
			effect.create_effect_1("Ｍギル火の粉")
			effect.set_effect_first_work_vector(position_x, position_y, position_z)
			effect.set_effect_second_work_vector(vector_x, vector_y, vector_z)
		end
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		vm.wait()
		frame = vm.f32(frame + 1.0)
	end
	value_3 = effect.get_script_value(0) or value_3
	effect.create_collision_primitive("Ｍギル火柱１")
	effect.set_collision_primitive_damage(value_3)
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	work_vect2_y = vm.f32(vm.f32(work_vect2_y / 180.0) * vm.f32(3.1415927))
	position_x = vm.f32(vm.sin(work_vect2_y) * work_vect2_z)
	position_z = vm.f32(vm.cos(work_vect2_y) * work_vect2_z)
	pos_x = vm.f32(pos_x + position_x)
	pos_z = vm.f32(pos_z + position_z)
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y + 200.0, pos_z)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y + 200.0, pos_z)
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
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 20.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	frame = 0
	while frame < 60.0 do
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, position_x, position_y, position_z)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.delete_collision_primitive(-1)
			effect.create_effect_1("Ｍギル火柱１")
			effect.set_effect_first_work_vector(hit_x, hit_y, hit_z)
			effect.set_effect_second_work_vector(pitch, yaw, roll)
			effect.set_effect_value(0, value_3)
			effect.set_effect_value(1, value_4)
			break
		else
			do
				local out1, out2, out3 = effect.get_effect_character_rotation_toward(position_x, position_y, position_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
			effect.set_collision_primitive_shape(velocity_x, velocity_y, velocity_z, value)
			effect.create_effect_1("Ｍギル火の粉")
			effect.set_effect_first_work_vector(position_x, position_y, position_z)
			effect.set_effect_second_work_vector(vector_x, vector_y, vector_z)
			do
				local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			vm.wait()
			frame = vm.f32(frame + 1.0)
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
