--!strict
--- Lobs a sticky goo blob from the caster along a falling arc and spawns a splat where it lands.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the goo blob along its falling arc until it hits a character or the map, then spawns the splat just before the impact point.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
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
	local height_offset: f32 = 0
	local scratch_x: f32 = 0
	local hit_count: s32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	local splat_x: f32 = 0
	local splat_y: f32 = 0
	local splat_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	damage = effect.get_script_value(0) or damage
	do
		local out1, out2, out3 = effect.get_direction_vector(pitch, yaw, roll)
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
	effect.rotate_effect_character_toward(pitch, yaw, roll)
	effect.set_effect_character_motion("ループ")
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.create_collision_primitive("ねば攻撃")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while frame < 60 do
		forward_distance = vm.f32(vm.f32(1.5 * vm.cos(0.0)) * frame)
		height_offset = vm.f32(
			vm.f32(vm.f32(1.5 * vm.sin(0.0)) * frame) - vm.f32(vm.f32(vm.f32(vm.f32(0.025) * frame) * frame) / 2)
		)
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, scratch_x, velocity_z, forward_distance)
			velocity_x = out1 or velocity_x
			scratch_x = out2 or scratch_x
			velocity_z = out3 or velocity_z
		end
		velocity_y = 1.0
		do
			local out1, out2, out3 = effect.scale_vector(scratch_x, velocity_y, vm.bits_float(hit_count) :: number, height_offset)
			scratch_x = out1 or scratch_x
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
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			effect.create_effect_1("ねばねばＨ")
			effect.set_effect_first_work_vector(position_x, position_y, position_z)
			effect.set_effect_second_work_vector(pitch, yaw, roll)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
				impact_x = out1 or impact_x
				impact_y = out2 or impact_y
				impact_z = out3 or impact_z
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
					local out1, out2, out3 = effect.copy_vector(impact_x, impact_y, impact_z)
					splat_x = out1 or splat_x
					splat_y = out2 or splat_y
					splat_z = out3 or splat_z
				end
				do
					local out1, out2, out3 = effect.add_vectors(splat_x, splat_y, splat_z, -velocity_x, -velocity_y, -velocity_z)
					splat_x = out1 or splat_x
					splat_y = out2 or splat_y
					splat_z = out3 or splat_z
				end
				effect.create_effect_1("ねばねばＨ")
				effect.set_effect_first_work_vector(splat_x, splat_y, splat_z)
				effect.set_effect_second_work_vector(pitch, yaw, roll)
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
