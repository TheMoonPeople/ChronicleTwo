--!strict
--- Shoots a sticky goo blob that hops forward from the caster, spawns a splat on impact and shows a guard effect if a guard blocks it.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the goo blob forward with a small vertical hop each frame until it hits a character, a guard or the map.
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
	local was_reflected: s32 = 0
	local speed: f32 = 0
	local vertical_step: f32 = 0
	local previous_velocity_y: f32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	local hit_count: s32 = 0
	effect.get_owner_character()
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
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(pitch, yaw, roll)
	effect.set_effect_character_motion("ネバネバ液（ループ）")
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	position_y = vm.f32(position_y - 1.0)
	vertical_step = vm.f32(0.3)
	speed = 5.0
	frame = 0
	while frame < 100 do
		if frame == 5 then
			effect.create_collision_primitive("ねば攻撃")
			effect.set_collision_primitive_damage(damage)
		end
		previous_velocity_y = velocity_y
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
		velocity_y = vm.f32(previous_velocity_y + vertical_step)
		if velocity_y > vm.f32(2.2) then
			vertical_step = vm.f32(-0.65)
		end
		speed = vm.f32(speed - vm.f32(0.005))
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
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(position_x, position_y, position_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		if frame > 5 then
			do
				local out1, _, _, _ = effect.get_collision_primitive_knockback()
				was_reflected = out1 or was_reflected
			end
			if was_reflected > 0 then
				effect.create_effect_1("ガードエフェクトＡ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				effect.create_effect_1("ねばねばＨ")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				break
			end
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
			impact_x = out1 or impact_x
			impact_y = out2 or impact_y
			impact_z = out3 or impact_z
			hit_count = out4 or hit_count
		end
		if hit_count >= 0 then
			effect.create_effect_1("ねばねばＨ")
			effect.set_effect_first_work_vector(impact_x, impact_y + 1.0, impact_z)
			break
		else
			if frame > 5 then
				hit_count = effect.get_collision_primitive_hit_count() or hit_count
				if hit_count > 0 then
					effect.create_effect_1("ねばねばＨ")
					effect.set_effect_first_work_vector(position_x, position_y, position_z)
					break
				end
			end
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
			if frame > 5 then
				effect.set_collision_primitive_shape(position_x, position_y, position_z, 8.400001)
			end
			vm.wait()
			frame = frame + 1
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
