--!strict
--- Flies an ice ball in a straight line at a given speed, bursting on contact or being knocked back by a guard.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Launches the ice ball straight along its direction, shatters it on a hit or wall, and sends it back along the guard knockback if reflected.
function script.on_start()
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
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
	local revers_vec_x: f32 = 0
	local revers_vec_y: f32 = 0
	local revers_vec_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local reversed: s32 = 0
	local hit_result: s32 = 0
	local surface_x: f32 = 0
	local surface_y: f32 = 0
	local surface_z: f32 = 0
	local reflected_hit_result: s32 = 0
	local reflected_surface_x: f32 = 0
	local reflected_surface_y: f32 = 0
	local reflected_surface_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	effect.set_effect_character_position(ball_x, ball_y, ball_z)
	effect.set_effect_character_motion("冷気弾ループ", -1, 4)
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
	effect.create_collision_primitive("氷弾２")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
		do
			local out1, out2, out3 = effect.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(ball_x, ball_y, ball_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(ball_x, ball_y, ball_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		effect.set_collision_primitive_shape(ball_x, ball_y, ball_z, 8.400001)
		do
			local out1, out2, out3, out4 = effect.get_collision_primitive_knockback()
			reversed = out1 or reversed
			revers_vec_x = out2 or revers_vec_x
			revers_vec_y = out3 or revers_vec_y
			revers_vec_z = out4 or revers_vec_z
		end
		if reversed > 0 then
			effect.create_effect_1("ガードエフェクトＡ")
			effect.set_effect_first_work_vector(ball_x, ball_y, ball_z)
			break
		else
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("氷弾Ｈ")
				effect.set_effect_first_work_vector(ball_x, ball_y, ball_z)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, ball_x, ball_y, ball_z)
					surface_x = out1 or surface_x
					surface_y = out2 or surface_y
					surface_z = out3 or surface_z
					hit_result = out4 or hit_result
				end
				if hit_result >= 0 then
					effect.create_effect_1("氷弾Ｈ")
					effect.set_effect_first_work_vector(surface_x, surface_y, surface_z)
					break
				else
					do
						local out1, out2, out3 = effect.copy_vector(ball_x, ball_y, ball_z)
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
	if reversed > 0 then
		if revers_vec_x == 0.0 and revers_vec_y == 0.0 and revers_vec_z == 0.0 then
			print("reverse zero vector-----------\n")
			reversed = 0
		end
	end
	vm.wait()
	if reversed > 0 then
		effect.create_collision_primitive("氷弾２", 0)
		effect.set_collision_primitive_damage(damage)
		do
			local out1, out2, out3 = effect.copy_vector(revers_vec_x, revers_vec_y, revers_vec_z)
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 7.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		frame = 0
		while frame < 60 do
			do
				local out1, out2, out3 = effect.get_effect_character_position()
				ball_x = out1 or ball_x
				ball_y = out2 or ball_y
				ball_z = out3 or ball_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
				ball_x = out1 or ball_x
				ball_y = out2 or ball_y
				ball_z = out3 or ball_z
			end
			do
				local out1, out2, out3 = effect.get_effect_character_rotation_toward(ball_x, ball_y, ball_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
			effect.set_effect_character_position(ball_x, ball_y, ball_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
			effect.set_collision_primitive_shape(ball_x, ball_y, ball_z, 6.0)
			reflected_hit_result = effect.get_collision_primitive_hit_count() or reflected_hit_result
			if reflected_hit_result > 0 then
				effect.create_effect_1("氷弾Ｈ")
				effect.set_effect_first_work_vector(ball_x, ball_y, ball_z)
				effect.set_effect_second_work_vector(pitch, yaw, roll)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, ball_x, ball_y, ball_z)
					reflected_surface_x = out1 or reflected_surface_x
					reflected_surface_y = out2 or reflected_surface_y
					reflected_surface_z = out3 or reflected_surface_z
					reflected_hit_result = out4 or reflected_hit_result
				end
				if reflected_hit_result >= 0 then
					effect.create_effect_1("氷弾Ｈ")
					effect.set_effect_first_work_vector(reflected_surface_x, reflected_surface_y, reflected_surface_z)
					effect.set_effect_second_work_vector(pitch, yaw, roll)
					break
				else
					do
						local out1, out2, out3 = effect.copy_vector(ball_x, ball_y, ball_z)
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
--- Does nothing when the effect ends.
function script.on_finish() end

return script
