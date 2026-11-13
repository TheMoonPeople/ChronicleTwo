--!strict
--- Pumpkinhead's knockback projectile that flies in an arc and spawns a curse-ball hit effect on contact.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Flies the projectile along an arc from its start point and spawns the curse-ball hit effect on contact.
function script.on_start()
	local projectile_x: f32 = 0
	local projectile_y: f32 = 0
	local projectile_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local forward_distance: f32 = 0
	local arc_height: f32 = 0
	local scratch_y: f32 = 0
	local hit_result: s32 = 0
	local intersection_x: f32 = 0
	local intersection_y: f32 = 0
	local intersection_z: f32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		projectile_x = out1 or projectile_x
		projectile_y = out2 or projectile_y
		projectile_z = out3 or projectile_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	damage = effect.get_script_value(0) or damage
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
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 8.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_position(projectile_x, projectile_y, projectile_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("ループ")
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < 60 do
		forward_distance = vm.f32(vm.f32(1.5 * vm.cos(0.0)) * frame)
		arc_height = vm.f32(
			vm.f32(vm.f32(1.5 * vm.sin(0.0)) * frame) - vm.f32(vm.f32(vm.f32(vm.f32(0.025) * frame) * frame) / 2)
		)
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, scratch_y, velocity_z, forward_distance)
			velocity_x = out1 or velocity_x
			scratch_y = out2 or scratch_y
			velocity_z = out3 or velocity_z
		end
		velocity_y = 1.0
		do
			local out1, out2, out3 = effect.scale_vector(scratch_y, velocity_y, vm.bits_float(hit_result) :: number, arc_height)
			scratch_y = out1 or scratch_y
			velocity_y = out2 or velocity_y
			hit_result = vm.float_bits(out3) or hit_result
		end
		do
			local out1, out2, out3 = effect.copy_vector(projectile_x, projectile_y, projectile_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(projectile_x, projectile_y, projectile_z, velocity_x, velocity_y, velocity_z)
			projectile_x = out1 or projectile_x
			projectile_y = out2 or projectile_y
			projectile_z = out3 or projectile_z
		end
		effect.set_effect_character_position(projectile_x, projectile_y, projectile_z)
		effect.set_collision_primitive_shape(projectile_x, projectile_y, projectile_z, 10.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.delete_collision_primitive(-1)
			effect.create_effect_1("呪い弾Ｈ")
			effect.set_effect_first_work_vector(projectile_x, projectile_y, projectile_z)
			effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, projectile_x, projectile_y, projectile_z)
				intersection_x = out1 or intersection_x
				intersection_y = out2 or intersection_y
				intersection_z = out3 or intersection_z
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				effect.delete_collision_primitive(-1)
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
				do
					local out1, out2, out3 = effect.copy_vector(intersection_x, intersection_y, intersection_z)
					impact_x = out1 or impact_x
					impact_y = out2 or impact_y
					impact_z = out3 or impact_z
				end
				do
					local out1, out2, out3 = effect.add_vectors(impact_x, impact_y, impact_z, -velocity_x, -velocity_y, -velocity_z)
					impact_x = out1 or impact_x
					impact_y = out2 or impact_y
					impact_z = out3 or impact_z
				end
				effect.create_effect_1("呪い弾Ｈ")
				effect.set_effect_first_work_vector(impact_x, impact_y, impact_z)
				effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
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
--- Does nothing when the effect ends.
function script.on_finish() end

return script
