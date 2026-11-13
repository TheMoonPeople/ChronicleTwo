--!strict
--- Sends a sonic wave toward the player, accelerating and optionally homing, and damages what it hits.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Flies the wave toward the player with optional homing and random offset, ending on a hit, wall or timeout, then fades it out.
function script.on_start()
	local wave_x: f32 = 0
	local wave_y: f32 = 0
	local wave_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local speed: f32 = 0
	local to_target_x: f32 = 0
	local to_target_y: f32 = 0
	local to_target_z: f32 = 0
	local heading_x: f32 = 0
	local heading_y: f32 = 0
	local heading_z: f32 = 0
	local distance: f32 = 0
	local offset_angle: f32 = 0
	local turn_angle: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local homing_weight: f32 = 0
	local retargets_player: s32 = 0
	local uses_exact_aim: s32 = 0
	local side_roll: s32 = 0
	local hit_result: s32 = 0
	speed = 8.0
	uses_exact_aim = 0
	damage = 0
	homing_weight = 0.0
	retargets_player = 0
	uses_exact_aim = 0
	turn_angle = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		wave_x = out1 or wave_x
		wave_y = out2 or wave_y
		wave_z = out3 or wave_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	damage = effect.get_script_value(0) or damage
	homing_weight = effect.get_script_value_float(1) or homing_weight
	retargets_player = effect.get_script_value(2) or retargets_player
	uses_exact_aim = effect.get_script_value(3) or uses_exact_aim
	turn_angle = effect.get_script_value_float(4) or turn_angle
	effect.set_effect_character_position(wave_x, wave_y, wave_z)
	effect.set_effect_character_motion("ループ")
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	target_y = 0.0
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		to_target_x = out1 or to_target_x
		to_target_y = out2 or to_target_y
		to_target_z = out3 or to_target_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(to_target_x, to_target_y, to_target_z, wave_x, wave_y, wave_z)
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
	distance = effect.get_distance_between(target_x, target_y, target_z, wave_x, wave_y, wave_z) or distance
	if distance < 150.0 then
		homing_weight = 1.0
	else
		if retargets_player == 0 then
			do
				local out1, out2, out3 = effect.copy_vector(to_target_x, to_target_y, to_target_z)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			target_y = 0.0
			do
				local out1, out2, out3 = effect.scale_vector(target_x, target_y, target_z, 2000.0)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
		end
		if uses_exact_aim == 0 then
			distance = 0.0
			offset_angle = 0.0
			offset_angle = effect.get_random_number(1.5707964) or offset_angle
			distance = effect.get_random_number(50.0) or distance
			distance = vm.f32(distance + 100.0)
			side_roll = 0
			side_roll = effect.get_random_number_int(100) or side_roll
			if side_roll < 50 then
				offset_angle = vm.f32(offset_angle * -1.0)
			end
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			target_x = vm.f32(target_x + vm.f32(vm.sin(offset_angle) * distance))
			target_y = 0.0
			target_z = vm.f32(target_z + vm.f32(vm.cos(offset_angle) * distance))
		end
	end
	effect.create_collision_primitive("グリソニック")
	effect.set_collision_primitive_damage(damage)
	heading_x = vm.f32(vm.f32(to_target_x * vm.cos(turn_angle)) + vm.f32(to_target_z * vm.sin(turn_angle)))
	heading_y = to_target_y
	heading_z = vm.f32(vm.f32(to_target_x * -vm.sin(turn_angle)) + vm.f32(to_target_z * vm.cos(turn_angle)))
	do
		local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(wave_x, wave_y, wave_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 25 do
		if retargets_player ~= 0 then
			if frame < 13 and frame > 6 then
				do
					local out1, out2, out3 = effect.get_scene_character_position(0)
					target_x = out1 or target_x
					target_y = out2 or target_y
					target_z = out3 or target_z
				end
				target_y = 0.0
			end
		end
		if frame < 18 then
			speed = vm.f32(speed + 1.0)
			to_target_x = vm.f32(target_x - wave_x)
			to_target_y = vm.f32(target_y - wave_y)
			to_target_z = vm.f32(target_z - wave_z)
			do
				local out1, out2, out3 = effect.normalize_vector(to_target_x, to_target_y, to_target_z)
				to_target_x = out1 or to_target_x
				to_target_y = out2 or to_target_y
				to_target_z = out3 or to_target_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(to_target_x, to_target_y, to_target_z, homing_weight)
				to_target_x = out1 or to_target_x
				to_target_y = out2 or to_target_y
				to_target_z = out3 or to_target_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(heading_x, heading_y, heading_z, 1.0 - homing_weight)
				heading_x = out1 or heading_x
				heading_y = out2 or heading_y
				heading_z = out3 or heading_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(heading_x, heading_y, heading_z, to_target_x, to_target_y, to_target_z)
				heading_x = out1 or heading_x
				heading_y = out2 or heading_y
				heading_z = out3 or heading_z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
				heading_x = out1 or heading_x
				heading_y = out2 or heading_y
				heading_z = out3 or heading_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(heading_x, heading_y, heading_z)
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
		end
		do
			local out1, out2, out3 = effect.add_vectors(wave_x, wave_y, wave_z, step_x, step_y, step_z)
			wave_x = out1 or wave_x
			wave_y = out2 or wave_y
			wave_z = out3 or wave_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(wave_x, wave_y, wave_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(wave_x, wave_y, wave_z)
		effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
		effect.set_collision_primitive_shape(wave_x, wave_y, wave_z, 15.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			break
		else
			do
				local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, wave_x, wave_y, wave_z)
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(wave_x, wave_y, wave_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				if speed > 50.0 then
					break
				else
					vm.wait()
					frame = frame + 1
				end
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_character_visible(0, 1, -0.9)
	frame = 0
	while frame < 15 do
		vm.wait()
		frame = frame + 1
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
