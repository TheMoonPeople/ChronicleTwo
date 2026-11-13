--!strict
--- Fires a machine gun round in a straight line, damaging what it hits or stopping on a wall.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Flies the round along its velocity until it hits a character or surface, then plays the impact sound and a short ricochet.
function script.on_start()
	local bullet_x: f32 = 0
	local bullet_y: f32 = 0
	local bullet_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local surface_normal_x: f32 = 0
	local surface_normal_y: f32 = 0
	local surface_normal_z: f32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local speed: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local hit_character: s32 = 0
	local damage: s32 = 0
	local sound_id: s32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	hit_character = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bullet_x = out1 or bullet_x
		bullet_y = out2 or bullet_y
		bullet_z = out3 or bullet_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	sound_id = effect.get_script_value(1) or sound_id
	effect.set_effect_character_scale(0.25, 0.25, 0.25)
	effect.create_collision_primitive("機銃")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(bullet_x, bullet_y, bullet_z, velocity_x, velocity_y, velocity_z)
			bullet_x = out1 or bullet_x
			bullet_y = out2 or bullet_y
			bullet_z = out3 or bullet_z
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.get_intersection_point_14(4, previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			surface_normal_x = out4 or surface_normal_x
			surface_normal_y = out5 or surface_normal_y
			surface_normal_z = out6 or surface_normal_z
			hit_result = out7 or hit_result
		end
		if hit_result >= 0 then
			do
				local out1, out2, out3 = effect.copy_vector(hit_x, hit_y, hit_z)
				bullet_x = out1 or bullet_x
				bullet_y = out2 or bullet_y
				bullet_z = out3 or bullet_z
			end
			do
				local out1, out2, out3 = effect.get_rotation_toward_9(previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
			effect.set_effect_character_position(bullet_x, bullet_y, bullet_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
			speed = effect.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
			do
				local out1, out2, out3 = effect.copy_vector(surface_normal_x, surface_normal_y, surface_normal_z)
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
				local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed / 2.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			effect.play_character_sound(sound_id, 5)
			break
		else
			do
				local out1, out2, out3 = effect.get_rotation_toward_9(previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
			effect.set_effect_character_position(bullet_x, bullet_y, bullet_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
		end
		effect.set_collision_primitive_shape(previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z, 1.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			hit_character = 1
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	if frame >= 90 or hit_character == 1 then
		return
	end
	speed = 128.0
	vm.wait()
	frame = 0
	do
		local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	while frame < 6 do
		do
			local out1, out2, out3 = effect.add_vectors(bullet_x, bullet_y, bullet_z, velocity_x, velocity_y, velocity_z)
			bullet_x = out1 or bullet_x
			bullet_y = out2 or bullet_y
			bullet_z = out3 or bullet_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(-velocity_x, -velocity_y, -velocity_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(trail_x, trail_y, trail_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(trail_x, trail_y, trail_z, 0.5)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.get_rotation_toward_9(previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(bullet_x, bullet_y, bullet_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		do
			local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		speed = vm.f32(speed - vm.f32(21.333334))
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
