--!strict
--- Drops a fireball onto the player from above after an approach arc.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Arcs the fireball toward the player, then drops it from above onto the player position with a knockback damage object until it reaches the ground.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local wall_hit_x: f32 = 0
	local wall_hit_y: f32 = 0
	local wall_hit_z: f32 = 0
	local cos_angle: f32 = 0
	local sin_angle: f32 = 0
	local extra_frames: f32 = 0
	local frame: f32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	local hit_count: s32 = 0
	local owner_id: s32 = 0
	local damage_object: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		extra_frames = out1 or extra_frames
		offset_angle = out2 or offset_angle
		offset_distance = out3 or offset_distance
	end
	effect.set_effect_character_scale(2.0, 2.0, 2.0)
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(player_x, player_y, player_z)
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
	cos_angle = vm.cos(vm.f32(1.0471976))
	sin_angle = vm.sin(vm.f32(1.0471976))
	velocity_x = vm.f32(direction_x * cos_angle)
	velocity_y = vm.f32(1.0 * sin_angle)
	velocity_z = vm.f32(direction_z * cos_angle)
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 16.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	frame = 0
	while frame < vm.f32(15.0 + extra_frames) do
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
		vm.wait()
		frame = vm.f32(frame + 1.0)
	end
	owner_id = effect.get_owner_character() or owner_id
	damage_object = effect.create_damage_object("吹っ飛び攻撃", 20.0, owner_id) or damage_object
	effect.set_damage_object_damage(damage_object, 6)
	effect.set_damage_object_position(damage_object, position_x, position_y, position_z)
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	offset_angle = vm.f32(vm.f32(offset_angle / 180.0) * vm.f32(3.1415927))
	position_x = vm.f32(vm.sin(offset_angle) * offset_distance)
	position_z = vm.f32(vm.cos(offset_angle) * offset_distance)
	player_x = vm.f32(player_x + position_x)
	player_z = vm.f32(player_z + position_z)
	do
		local out1, out2, out3 = effect.copy_vector(player_x, player_y + 200.0, player_z)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(player_x, player_y, player_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(direction_x, direction_y, direction_z, player_x, player_y + 200.0, player_z)
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
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
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
				effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
			wall_hit_x = out1 or wall_hit_x
			wall_hit_y = out2 or wall_hit_y
			wall_hit_z = out3 or wall_hit_z
			hit_count = out4 or hit_count
		end
		if hit_count >= 0 then
			effect.delete_damage_object(damage_object)
			effect.create_effect_1("火炎弾ヒット")
			effect.set_effect_first_work_vector(wall_hit_x, wall_hit_y, wall_hit_z)
			effect.set_effect_second_work_vector(pitch, yaw, roll)
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
			effect.set_damage_object_position(damage_object, position_x, position_y, position_z)
			do
				local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			vm.wait()
			frame = vm.f32(frame + 1.0)
		end
	end
	effect.delete_damage_object(damage_object)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
