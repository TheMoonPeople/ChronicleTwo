--!strict
--- Flies a monster fireball along a curved path that homes in on a target using parameters from the caster.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the fireball with an optional curve, speed-up and homing pull toward the target, and spawns the fireball hit effect on a hit or fades it out after it expires.
function script.on_start()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local to_target_x: f32 = 0
	local to_target_y: f32 = 0
	local to_target_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local cos_angle: f32 = 0
	local sin_angle: f32 = 0
	local one_minus_cos: f32 = 0
	local speed: f32 = 0
	local acceleration: f32 = 0
	local homing_strength: f32 = 0
	local curve_angle: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local targets_character: s32 = 0
	local is_in_flight: s32 = 0
	local target_id: s32 = 0
	local lifetime: s32 = 0
	local homing_frames: s32 = 0
	local hit_count: s32 = 0
	local wall_hit_x: f32 = 0
	local wall_hit_y: f32 = 0
	local wall_hit_z: f32 = 0
	lifetime = 0
	is_in_flight = 1
	speed = 0.0
	acceleration = 0.0
	homing_strength = 0.0
	curve_angle = 0.0
	damage = 0
	targets_character = 0
	target_id = 0
	effect.get_owner_character()
	target_id = effect.get_target_character() or target_id
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	homing_strength = effect.get_script_value_float(2) or homing_strength
	curve_angle = effect.get_script_value_float(3) or curve_angle
	targets_character = effect.get_script_value(4) or targets_character
	acceleration = effect.get_script_value_float(5) or acceleration
	lifetime = effect.get_script_value(6) or lifetime
	homing_frames = effect.get_script_value(7) or homing_frames
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.create_collision_primitive("火弾")
	effect.set_collision_primitive_damage(damage)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	if targets_character ~= 0 then
		do
			local out1, out2, out3 = effect.get_scene_character_position(target_id)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
	else
		do
			local out1, out2, out3 = effect.get_second_work_vector()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
	end
	do
		local out1, out2, out3 = effect.copy_vector(target_x, target_y, target_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(to_target_x, to_target_y, to_target_z, position_x, position_y, position_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(to_target_x, to_target_y, to_target_z)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	direction_x = vm.f32(vm.f32(to_target_x * vm.cos(vm.f32(-1.5707964))) + vm.f32(to_target_z * vm.sin(vm.f32(-1.5707964))))
	direction_y = to_target_y
	direction_z = vm.f32(vm.f32(to_target_x * -vm.sin(vm.f32(-1.5707964))) + vm.f32(to_target_z * vm.cos(vm.f32(-1.5707964))))
	sin_angle = vm.sin(curve_angle)
	cos_angle = vm.cos(curve_angle)
	one_minus_cos = vm.f32(1.0 - cos_angle)
	target_x = vm.f32(
		vm.f32(
			vm.f32(direction_x * vm.f32(cos_angle + vm.f32(vm.f32(one_minus_cos * to_target_x) * to_target_x)))
				+ vm.f32(direction_y * vm.f32(vm.f32(vm.f32(one_minus_cos * to_target_x) * to_target_y) + vm.f32(to_target_z * sin_angle)))
		) + vm.f32(direction_z * vm.f32(vm.f32(vm.f32(one_minus_cos * to_target_x) * to_target_z) + vm.f32(to_target_y * sin_angle)))
	)
	target_y = vm.f32(
		vm.f32(
			vm.f32(direction_x * vm.f32(vm.f32(vm.f32(one_minus_cos * to_target_x) * to_target_y) - vm.f32(to_target_z * sin_angle)))
				+ vm.f32(direction_y * vm.f32(cos_angle + vm.f32(vm.f32(one_minus_cos * to_target_y) * to_target_y)))
		) + vm.f32(direction_z * vm.f32(vm.f32(vm.f32(one_minus_cos * to_target_y) * to_target_z) + vm.f32(to_target_x * sin_angle)))
	)
	target_z = vm.f32(
		vm.f32(
			vm.f32(direction_x * vm.f32(vm.f32(vm.f32(one_minus_cos * to_target_z) * to_target_x) + vm.f32(to_target_y * sin_angle)))
				+ vm.f32(direction_y * vm.f32(vm.f32(vm.f32(one_minus_cos * to_target_y) * to_target_z) - vm.f32(to_target_x * sin_angle)))
		) + vm.f32(direction_z * vm.f32(cos_angle + vm.f32(vm.f32(one_minus_cos * to_target_z) * to_target_z)))
	)
	do
		local out1, out2, out3 = effect.copy_vector(target_x, target_y, target_z)
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
		local out1, out2, out3 = effect.get_scene_character_position(target_id)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	target_y = vm.f32(target_y + 10.0)
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < lifetime do
		speed = vm.f32(speed + acceleration)
		if targets_character ~= 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_position(target_id)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
		end
		if frame < homing_frames then
			to_target_x = vm.f32(target_x - position_x)
			to_target_y = vm.f32(target_y - position_y)
			to_target_z = vm.f32(target_z - position_z)
			do
				local out1, out2, out3 = effect.normalize_vector(to_target_x, to_target_y, to_target_z)
				to_target_x = out1 or to_target_x
				to_target_y = out2 or to_target_y
				to_target_z = out3 or to_target_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(to_target_x, to_target_y, to_target_z, homing_strength)
				to_target_x = out1 or to_target_x
				to_target_y = out2 or to_target_y
				to_target_z = out3 or to_target_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, 1.0 - homing_strength)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(direction_x, direction_y, direction_z, to_target_x, to_target_y, to_target_z)
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
				local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
		else
			do
				local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
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
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			is_in_flight = 0
			effect.create_effect_1("火弾Ｈ")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			break
		else
			if frame > 10 then
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
					wall_hit_x = out1 or wall_hit_x
					wall_hit_y = out2 or wall_hit_y
					wall_hit_z = out3 or wall_hit_z
					hit_count = out4 or hit_count
				end
				if hit_count >= 0 then
					is_in_flight = 0
					effect.set_effect_character_position(wall_hit_x, wall_hit_y, wall_hit_z)
					effect.create_effect_1("火弾Ｈ")
					effect.set_effect_first_work_vector(wall_hit_x, wall_hit_y, wall_hit_z)
					break
				end
			end
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 8.400001)
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
	effect.delete_collision_primitive(-1)
	if is_in_flight ~= 0 then
		frame = 0
		effect.set_effect_character_visible(0, 1, -0.5)
		while frame < 30 do
			vm.wait()
			frame = frame + 1
		end
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
