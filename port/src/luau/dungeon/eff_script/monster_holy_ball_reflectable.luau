--!strict
--- Flies a monster holy ball that a guard can reflect back along its knockback vector.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the holy ball forward at the given speed, ends it on a hit, wall or reflection, and re-launches it along the knockback vector when reflected.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local speed: f32 = 0
	local knockback_x: f32 = 0
	local knockback_y: f32 = 0
	local knockback_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local is_reflected: s32 = 0
	local hit_count: s32 = 0
	local wall_hit_x: f32 = 0
	local wall_hit_y: f32 = 0
	local wall_hit_z: f32 = 0
	local reflected_hit_count: s32 = 0
	local reflected_wall_hit_x: f32 = 0
	local reflected_wall_hit_y: f32 = 0
	local reflected_wall_hit_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.set_effect_character_motion("聖弾ループ", -1, 4)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.create_collision_primitive("風弾２")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
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
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 8.400001)
		do
			local out1, out2, out3, out4 = effect.get_collision_primitive_knockback()
			is_reflected = out1 or is_reflected
			knockback_x = out2 or knockback_x
			knockback_y = out3 or knockback_y
			knockback_z = out4 or knockback_z
		end
		if is_reflected > 0 then
			effect.create_effect_1("ガードエフェクトＡ")
			effect.set_effect_first_work_vector(position_x, position_y, position_z)
			break
		else
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 then
				effect.create_effect_1("聖弾Ｈ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
					wall_hit_x = out1 or wall_hit_x
					wall_hit_y = out2 or wall_hit_y
					wall_hit_z = out3 or wall_hit_z
					hit_count = out4 or hit_count
				end
				if hit_count >= 0 then
					effect.create_effect_1("聖弾Ｈ")
					effect.set_effect_first_work_vector(wall_hit_x, wall_hit_y, wall_hit_z)
					break
				else
					do
						local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
						previous_x = out1 or previous_x
						previous_y = out2 or previous_y
						previous_z = out3 or previous_z
					end
					vm.wait()
					frame = frame + 1
				end
			end
		end
	end
	effect.delete_collision_primitive(-1)
	if is_reflected > 0 then
		if knockback_x == 0.0 and knockback_y == 0.0 and knockback_z == 0.0 then
			print("reverse zero vector-----------\n")
			is_reflected = 0
		end
	end
	vm.wait()
	if is_reflected > 0 then
		effect.create_collision_primitive("弱攻撃", 0)
		effect.set_collision_primitive_damage(damage)
		do
			local out1, out2, out3 = effect.copy_vector(knockback_x, knockback_y, knockback_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 10.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		frame = 0
		while frame < 60 do
			do
				local out1, out2, out3 = effect.get_effect_character_position()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
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
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 6.0)
			reflected_hit_count = effect.get_collision_primitive_hit_count() or reflected_hit_count
			if reflected_hit_count > 0 then
				effect.create_effect_1("聖弾Ｈ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				effect.set_effect_second_work_vector(pitch, yaw, roll)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
					reflected_wall_hit_x = out1 or reflected_wall_hit_x
					reflected_wall_hit_y = out2 or reflected_wall_hit_y
					reflected_wall_hit_z = out3 or reflected_wall_hit_z
					reflected_hit_count = out4 or reflected_hit_count
				end
				if reflected_hit_count >= 0 then
					effect.create_effect_1("聖弾Ｈ")
					effect.set_effect_first_work_vector(reflected_wall_hit_x, reflected_wall_hit_y, reflected_wall_hit_z)
					effect.set_effect_second_work_vector(pitch, yaw, roll)
					break
				else
					do
						local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
						previous_x = out1 or previous_x
						previous_y = out2 or previous_y
						previous_z = out3 or previous_z
					end
					vm.wait()
					frame = frame + 1
				end
			end
		end
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
