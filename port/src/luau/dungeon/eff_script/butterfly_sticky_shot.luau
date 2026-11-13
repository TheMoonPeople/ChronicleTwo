--!strict
--- Shoots a sticky glob that flies straight at the player and splats on contact.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Flies the glob toward the player position at the start of the shot and spawns the sticky hit effect on contact.
function script.on_start()
	local shot_x: f32 = 0
	local shot_y: f32 = 0
	local shot_z: f32 = 0
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
	local attack_type: s32 = 0
	local hit_result: s32 = 0
	local surface_x: f32 = 0
	local surface_y: f32 = 0
	local surface_z: f32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	attack_type = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		shot_x = out1 or shot_x
		shot_y = out2 or shot_y
		shot_z = out3 or shot_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	damage = effect.get_script_value(0) or damage
	attack_type = effect.get_script_value(1) or attack_type
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	direction_y = vm.f32(direction_y + 15.0)
	do
		local out1, out2, out3 = effect.subtract_vectors(direction_x, direction_y, direction_z, shot_x, shot_y, shot_z)
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
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 12.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_position(shot_x, shot_y, shot_z)
	effect.rotate_effect_character_toward(pitch, yaw, roll)
	effect.set_effect_character_motion("ループ")
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	if attack_type == 0 then
		effect.create_collision_primitive("通常攻撃")
	end
	if attack_type == 1 then
		effect.create_collision_primitive("ねば攻撃")
	end
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(shot_x, shot_y, shot_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.add_vectors(shot_x, shot_y, shot_z, velocity_x, velocity_y, velocity_z)
			shot_x = out1 or shot_x
			shot_y = out2 or shot_y
			shot_z = out3 or shot_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(shot_x, shot_y, shot_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.create_effect_1("ねばねばＨ")
			effect.set_effect_first_work_vector(shot_x, shot_y, shot_z)
			effect.set_effect_second_work_vector(pitch, yaw, roll)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, shot_x, shot_y, shot_z)
				surface_x = out1 or surface_x
				surface_y = out2 or surface_y
				surface_z = out3 or surface_z
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
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
					local out1, out2, out3 = effect.copy_vector(surface_x, surface_y, surface_z)
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
				effect.create_effect_1("ねばねばＨ")
				effect.set_effect_first_work_vector(impact_x, impact_y, impact_z)
				effect.set_effect_second_work_vector(pitch, yaw, roll)
				break
			else
				effect.set_effect_character_position(shot_x, shot_y, shot_z)
				effect.rotate_effect_character_toward(pitch, yaw, roll)
				effect.set_collision_primitive_shape(shot_x, shot_y, shot_z, 8.400001)
				do
					local out1, out2, out3 = effect.copy_vector(shot_x, shot_y, shot_z)
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

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
