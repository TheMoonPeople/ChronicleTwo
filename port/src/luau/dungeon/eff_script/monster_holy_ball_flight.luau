--!strict
--- Flies a monster holy ball forward and re-launches it back when a guard reflects it.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Launches the holy ball after a short delay, ends it on a hit or wall, and re-launches it along the knockback vector when reflected.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
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
	local knockback_x: f32 = 0
	local knockback_y: f32 = 0
	local knockback_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local is_reflected: s32 = 0
	local forward_distance: f32 = 0
	local vertical_offset: f32 = 0
	local scratch_value: f32 = 0
	local hit_count: s32 = 0
	local wall_hit_x: f32 = 0
	local wall_hit_y: f32 = 0
	local wall_hit_z: f32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	local reflected_hit_count: s32 = 0
	local reflected_wall_hit_x: f32 = 0
	local reflected_wall_hit_y: f32 = 0
	local reflected_wall_hit_z: f32 = 0
	local reflected_impact_x: f32 = 0
	local reflected_impact_y: f32 = 0
	local reflected_impact_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
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
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("聖弾ループ")
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	frame = 0
	while frame < 10 do
		vm.wait()
		frame = frame + 1
	end
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < 60 do
		forward_distance = vm.f32(vm.f32(1.5 * vm.cos(0.0)) * frame)
		vertical_offset = vm.f32(
			vm.f32(vm.f32(1.5 * vm.sin(0.0)) * frame) - vm.f32(vm.f32(vm.f32(vm.f32(0.025) * frame) * frame) / 2)
		)
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, scratch_value, velocity_z, forward_distance)
			velocity_x = out1 or velocity_x
			scratch_value = out2 or scratch_value
			velocity_z = out3 or velocity_z
		end
		velocity_y = 1.0
		do
			local out1, out2, out3 = effect.scale_vector(scratch_value, velocity_y, vm.bits_float(hit_count) :: number, vertical_offset)
			scratch_value = out1 or scratch_value
			velocity_y = out2 or velocity_y
			hit_count = vm.float_bits(out3) or hit_count
		end
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		effect.set_effect_character_position(position_x, position_y, position_z)
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 8.400001)
		do
			local out1, out2, out3, out4 = effect.get_collision_primitive_knockback()
			is_reflected = out1 or is_reflected
			knockback_x = out2 or knockback_x
			knockback_y = out3 or knockback_y
			knockback_z = out4 or knockback_z
		end
		if is_reflected > 0 then
			effect.call_command(250, position_x, position_y, position_z) -- retail: command 250 is not registered
			break
		else
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 then
				effect.create_effect_1("聖弾Ｈ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
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
						local out1, out2, out3 = effect.copy_vector(wall_hit_x, wall_hit_y, wall_hit_z)
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
					effect.create_effect_1("聖弾Ｈ")
					effect.set_effect_first_work_vector(impact_x, impact_y, impact_z)
					effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
					break
				else
					vm.wait()
					frame = frame + 1
				end
			end
		end
	end
	effect.delete_collision_primitive(-1)
	vm.wait()
	if is_reflected > 0 then
		effect.create_collision_primitive("火弾", 0)
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
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 6.0)
			reflected_hit_count = effect.get_collision_primitive_hit_count() or reflected_hit_count
			if reflected_hit_count > 0 then
				effect.create_effect_1("聖弾Ｈ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
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
						local out1, out2, out3 = effect.copy_vector(reflected_wall_hit_x, reflected_wall_hit_y, reflected_wall_hit_z)
						reflected_impact_x = out1 or reflected_impact_x
						reflected_impact_y = out2 or reflected_impact_y
						reflected_impact_z = out3 or reflected_impact_z
					end
					do
						local out1, out2, out3 = effect.add_vectors(reflected_impact_x, reflected_impact_y, reflected_impact_z, -velocity_x, -velocity_y, -velocity_z)
						reflected_impact_x = out1 or reflected_impact_x
						reflected_impact_y = out2 or reflected_impact_y
						reflected_impact_z = out3 or reflected_impact_z
					end
					effect.create_effect_1("聖弾Ｈ")
					effect.set_effect_first_work_vector(reflected_impact_x, reflected_impact_y, reflected_impact_z)
					effect.set_effect_second_work_vector(rotation_x, rotation_y, rotation_z)
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
