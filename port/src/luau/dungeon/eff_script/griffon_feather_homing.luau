--!strict
--- Fires a feather that curves toward the player, damages on contact and fades away.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Curves the feather around the player along a rotated heading, spawning the hit effect on contact and fading it out.
function script.on_start()
	local feather_x: f32 = 0
	local feather_y: f32 = 0
	local feather_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local to_player_x: f32 = 0
	local to_player_y: f32 = 0
	local to_player_z: f32 = 0
	local heading_x: f32 = 0
	local heading_y: f32 = 0
	local heading_z: f32 = 0
	local scratch_x: f32 = 0
	local scratch_y: f32 = 0
	local scratch_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local speed: f32 = 0
	local homing_weight: f32 = 0
	local turn_angle: f32 = 0
	local cosine: f32 = 0
	local sine: f32 = 0
	local angle_term: f32 = 0
	local frame: s32 = 0
	local intersection_result: s32 = 0
	local tracks_player: s32 = 0
	local damage: s32 = 0
	local hit_count: s32 = 0
	tracks_player = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		feather_x = out1 or feather_x
		feather_y = out2 or feather_y
		feather_z = out3 or feather_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		speed = out1 or speed
		homing_weight = out2 or homing_weight
		turn_angle = out3 or turn_angle
	end
	tracks_player = effect.get_script_value(1) or tracks_player
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(player_x, player_y, player_z)
		to_player_x = out1 or to_player_x
		to_player_y = out2 or to_player_y
		to_player_z = out3 or to_player_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(to_player_x, to_player_y, to_player_z, feather_x, feather_y, feather_z)
		to_player_x = out1 or to_player_x
		to_player_y = out2 or to_player_y
		to_player_z = out3 or to_player_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(to_player_x, to_player_y, to_player_z)
		to_player_x = out1 or to_player_x
		to_player_y = out2 or to_player_y
		to_player_z = out3 or to_player_z
	end
	damage = effect.get_script_value(0) or damage
	effect.create_collision_primitive("グリ羽根")
	effect.set_collision_primitive_damage(damage)
	angle_term = vm.f32(1.5707964)
	cosine = vm.cos(angle_term)
	sine = vm.sin(angle_term)
	heading_x = vm.f32(vm.f32(to_player_x * cosine) + vm.f32(to_player_z * sine))
	heading_y = to_player_y
	heading_z = vm.f32(vm.f32(to_player_x * -sine) + vm.f32(to_player_z * cosine))
	do
		local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	turn_angle = vm.f32(vm.f32(turn_angle / 180.0) * vm.f32(3.1415927))
	cosine = vm.cos(turn_angle)
	sine = vm.sin(turn_angle)
	angle_term = vm.f32(1.0 - cosine)
	scratch_x = vm.f32(
		vm.f32(
			vm.f32(heading_x * vm.f32(cosine + vm.f32(vm.f32(angle_term * to_player_x) * to_player_x)))
				+ vm.f32(heading_y * vm.f32(vm.f32(vm.f32(angle_term * to_player_x) * to_player_y) + vm.f32(to_player_z * sine)))
		) + vm.f32(heading_z * vm.f32(vm.f32(vm.f32(angle_term * to_player_x) * to_player_z) + vm.f32(to_player_y * sine)))
	)
	scratch_y = vm.f32(
		vm.f32(
			vm.f32(heading_x * vm.f32(vm.f32(vm.f32(angle_term * to_player_x) * to_player_y) - vm.f32(to_player_z * sine)))
				+ vm.f32(heading_y * vm.f32(cosine + vm.f32(vm.f32(angle_term * to_player_y) * to_player_y)))
		) + vm.f32(heading_z * vm.f32(vm.f32(vm.f32(angle_term * to_player_y) * to_player_z) + vm.f32(to_player_x * sine)))
	)
	scratch_z = vm.f32(
		vm.f32(
			vm.f32(heading_x * vm.f32(vm.f32(vm.f32(angle_term * to_player_z) * to_player_x) + vm.f32(to_player_y * sine)))
				+ vm.f32(heading_y * vm.f32(vm.f32(vm.f32(angle_term * to_player_y) * to_player_z) - vm.f32(to_player_x * sine)))
		) + vm.f32(heading_z * vm.f32(cosine + vm.f32(vm.f32(angle_term * to_player_z) * to_player_z)))
	)
	do
		local out1, out2, out3 = effect.copy_vector(scratch_x, scratch_y, scratch_z)
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
		local out1, out2, out3 = effect.copy_vector(feather_x, feather_y, feather_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
		if tracks_player == 1 then
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
		end
		to_player_x = vm.f32(player_x - feather_x)
		to_player_y = vm.f32(player_y - feather_y)
		to_player_z = vm.f32(player_z - feather_z)
		do
			local out1, out2, out3 = effect.normalize_vector(to_player_x, to_player_y, to_player_z)
			to_player_x = out1 or to_player_x
			to_player_y = out2 or to_player_y
			to_player_z = out3 or to_player_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(to_player_x, to_player_y, to_player_z, homing_weight * 100.0)
			to_player_x = out1 or to_player_x
			to_player_y = out2 or to_player_y
			to_player_z = out3 or to_player_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(heading_x, heading_y, heading_z, vm.f32(1.0 - homing_weight) * 100.0)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(heading_x, heading_y, heading_z, to_player_x, to_player_y, to_player_z)
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
		do
			local out1, out2, out3 = effect.add_vectors(feather_x, feather_y, feather_z, step_x, step_y, step_z)
			feather_x = out1 or feather_x
			feather_y = out2 or feather_y
			feather_z = out3 or feather_z
		end
		if frame > 10 then
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, feather_x, feather_y, feather_z)
				scratch_x = out1 or scratch_x
				scratch_y = out2 or scratch_y
				scratch_z = out3 or scratch_z
				intersection_result = out4 or intersection_result
			end
			if intersection_result >= 0 and frame <= 82 then
				effect.create_effect_1("グリ羽根Ｈ")
				effect.set_effect_first_work_vector(scratch_x, scratch_y, scratch_z)
				break
			end
		end
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			effect.create_effect_1("グリ羽根Ｈ")
			effect.set_effect_first_work_vector(feather_x, feather_y, feather_z)
			break
		else
			do
				local out1, out2, out3 = effect.get_effect_character_rotation_toward(feather_x, feather_y, feather_z)
				scratch_x = out1 or scratch_x
				scratch_y = out2 or scratch_y
				scratch_z = out3 or scratch_z
			end
			effect.set_effect_character_position(feather_x, feather_y, feather_z)
			effect.rotate_effect_character_toward(scratch_x, scratch_y, scratch_z)
			effect.set_collision_primitive_shape(feather_x, feather_y, feather_z, 12.0)
			if frame == 77 then
				effect.set_effect_character_visible(0, 1, -10.0)
				effect.delete_collision_primitive(-1)
			end
			do
				local out1, out2, out3 = effect.copy_vector(feather_x, feather_y, feather_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			frame = frame + 1
			vm.wait()
		end
	end
	frame = 0
	effect.set_effect_character_visible(0, 1, -0.1)
	while frame < 15 do
		vm.wait()
		frame = frame + 1
	end
	effect.set_effect_character_visible(0, 0)
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
