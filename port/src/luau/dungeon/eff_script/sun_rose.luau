--!strict
--- Flies a rose toward a point, sways in place, then lunges at a target and damages it.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Moves the rose to its destination, sways until signalled, then flies it at the target and spawns the hit effect.
function script.on_start()
	local rose_x: f32 = 0
	local rose_y: f32 = 0
	local rose_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local anchor_x: f32 = 0
	local anchor_y: f32 = 0
	local anchor_z: f32 = 0
	local speed: f32 = 0
	local distance: f32 = 0
	local orbit_speed: f32 = 0
	local bob_speed: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local flight_frames: s32 = 0
	local signal_flag: s32 = 0
	local owner_id: s32 = 0
	local bob_angle: f32 = 0
	local orbit_angle: f32 = 0
	local bob_offset_y: f32 = 0
	local orbit_offset_x: f32 = 0
	local orbit_offset_z: f32 = 0
	local hit_result: s32 = 0
	damage = 0
	flight_frames = 0
	speed = 0.0
	orbit_speed = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		rose_x = out1 or rose_x
		rose_y = out2 or rose_y
		rose_z = out3 or rose_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	owner_id = effect.get_owner_character() or owner_id
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	flight_frames = effect.get_script_value(2) or flight_frames
	signal_flag = effect.get_script_value(7) or signal_flag
	effect.set_effect_character_position(rose_x, rose_y, rose_z)
	distance = effect.get_distance_between(step_x, step_y, step_z, rose_x, rose_y, rose_z) or distance
	speed = vm.f32(vm.fdiv(distance, flight_frames))
	do
		local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, rose_x, rose_y, rose_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(rose_x, rose_y, rose_z)
		anchor_x = out1 or anchor_x
		anchor_y = out2 or anchor_y
		anchor_z = out3 or anchor_z
	end
	frame = 0
	while frame < flight_frames do
		do
			local out1, out2, out3 = effect.add_vectors(rose_x, rose_y, rose_z, step_x, step_y, step_z)
			rose_x = out1 or rose_x
			rose_y = out2 or rose_y
			rose_z = out3 or rose_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(rose_x, rose_y, rose_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(rose_x, rose_y, rose_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		do
			local out1, out2, out3 = effect.copy_vector(rose_x, rose_y, rose_z)
			anchor_x = out1 or anchor_x
			anchor_y = out2 or anchor_y
			anchor_z = out3 or anchor_z
		end
		vm.wait()
		frame = frame + 1
	end
	while true do
		signal_flag = effect.get_script_value(7) or signal_flag
		if signal_flag == 1 then
			effect.set_script_value_int(7, 0)
			break
		else
			vm.wait()
		end
	end
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		anchor_x = out1 or anchor_x
		anchor_y = out2 or anchor_y
		anchor_z = out3 or anchor_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_position()
		rose_x = out1 or rose_x
		rose_y = out2 or rose_y
		rose_z = out3 or rose_z
	end
	speed = effect.get_script_value_float(1) or speed
	orbit_speed = effect.get_script_value_float(3) or orbit_speed
	bob_speed = effect.get_script_value_float(4) or bob_speed
	bob_angle = 0.0
	orbit_angle = 0.0
	orbit_angle = effect.get_script_value_float(5) or orbit_angle
	frame = 0
	while true do
		bob_offset_y = vm.f32(vm.sin(bob_angle) * 30.0)
		orbit_offset_x = vm.f32(vm.sin(orbit_angle) * 30.0)
		orbit_offset_z = vm.f32(vm.cos(orbit_angle) * 30.0)
		step_x = vm.f32(anchor_x + orbit_offset_x)
		step_y = vm.f32(anchor_y + bob_offset_y)
		step_z = vm.f32(anchor_z + orbit_offset_z)
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(step_x, step_y, step_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(step_x, step_y, step_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		bob_angle = vm.f32(bob_angle + bob_speed)
		orbit_angle = vm.f32(orbit_angle + orbit_speed)
		vm.wait()
		signal_flag = effect.get_script_value(7) or signal_flag
		if signal_flag == 1 then
			effect.set_script_value_int(7, 0)
			break
		else
			frame = vm.i32(frame + 1)
		end
	end
	do
		local out1, out2, out3 = effect.get_effect_character_position()
		rose_x = out1 or rose_x
		rose_y = out2 or rose_y
		rose_z = out3 or rose_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(rose_x, rose_y, rose_z)
		anchor_x = out1 or anchor_x
		anchor_y = out2 or anchor_y
		anchor_z = out3 or anchor_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	flight_frames = effect.get_script_value(2) or flight_frames
	do
		local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, rose_x, rose_y, rose_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	effect.create_collision_primitive("サン薔薇")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < flight_frames do
		do
			local out1, out2, out3 = effect.add_vectors(rose_x, rose_y, rose_z, step_x, step_y, step_z)
			rose_x = out1 or rose_x
			rose_y = out2 or rose_y
			rose_z = out3 or rose_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(rose_x, rose_y, rose_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(rose_x, rose_y, rose_z)
		effect.rotate_effect_character_toward(pitch - vm.f32(1.5707964), yaw, roll)
		effect.set_collision_primitive_shape(rose_x, rose_y, rose_z, 10.0)
		hit_result = effect.get_intersection_point_8(4, anchor_x, anchor_y, anchor_z, rose_x, rose_y, rose_z) or hit_result
		if hit_result >= 0 then
			break
		else
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				do
					local out1, out2, out3 = effect.get_collision_primitive_hit_position()
					anchor_x = out1 or anchor_x
					anchor_y = out2 or anchor_y
					anchor_z = out3 or anchor_z
				end
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(rose_x, rose_y, rose_z)
					anchor_x = out1 or anchor_x
					anchor_y = out2 or anchor_y
					anchor_z = out3 or anchor_z
				end
				vm.wait()
				frame = frame + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.create_effect_1("バラヒット")
	effect.set_effect_first_work_vector(anchor_x, anchor_y, anchor_z)
	effect.set_effect_value(0, damage)
	effect.set_effect_value(1, owner_id)
end

--- Shrinks the rose away over a few frames.
function script.on_finish()
	local scale: f32 = 0
	local scale_step: f32 = 0
	effect.delete_collision_primitive(-1)
	scale = 1.0
	scale_step = vm.f32(0.11111111)
	for index = 0, 8 do
		effect.set_effect_character_scale(scale, scale, scale)
		scale = vm.f32(scale - scale_step)
		vm.wait()
	end
end

return script
