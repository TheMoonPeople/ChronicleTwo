--!strict
--- Lobs a monster venom glob along a parabolic arc at the target character and spawns the venom hit effect where it lands.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the venom glob along a parabola set by the launch speed, angle and gravity, and spawns the venom hit effect on a character or ground hit.
function script.on_start()
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local horizontal_distance: f32 = 0
	local height_offset: f32 = 0
	local launch_angle: f32 = 0
	local launch_speed: f32 = 0
	local gravity: f32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	local damage: s32 = 0
	effect.get_owner_character()
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		origin_x = out1 or origin_x
		origin_y = out2 or origin_y
		origin_z = out3 or origin_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		launch_speed = out1 or launch_speed
		launch_angle = out2 or launch_angle
		gravity = out3 or gravity
	end
	hit_result = effect.get_target_character() or hit_result
	damage = effect.get_script_value(0) or damage
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(hit_result)
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
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
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(position_x, position_y, position_z, launch_speed)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_effect_character_position(origin_x, origin_y, origin_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("毒液ループ")
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.create_collision_primitive("毒液２")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(origin_x, origin_y, origin_z)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	launch_angle = vm.f32(vm.f32(launch_angle / 180.0) * vm.f32(3.1415927))
	rotation_x = vm.cos(launch_angle)
	rotation_y = vm.sin(launch_angle)
	gravity = -gravity
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		height_offset = vm.f32(launch_speed * frame)
		horizontal_distance = vm.f32(height_offset * rotation_x)
		height_offset = vm.f32(vm.f32(height_offset * rotation_y) + vm.f32(vm.f32(vm.f32(gravity * frame) * frame) * 0.5))
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		position_y = 1.0
		position_x = vm.f32(position_x * horizontal_distance)
		position_z = vm.f32(position_z * horizontal_distance)
		position_y = vm.f32(position_y * height_offset)
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, origin_x, origin_y, origin_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("毒液H")
			effect.set_effect_first_work_vector(previous_x, previous_y + 1.0, previous_z)
			break
		else
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 8.400001)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("毒液H")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				break
			else
				vm.wait()
				frame = frame + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
