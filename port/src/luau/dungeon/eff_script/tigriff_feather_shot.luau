--!strict
--- Tigriff feather projectile that flies forward and sticks into walls.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Flies the feather, damages targets, and fades it out after sticking into a wall.
function script.on_start()
	local feather_x: f32 = 0
	local feather_y: f32 = 0
	local feather_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local stuck_in_wall: s32 = 0
	local hit_result: s32 = 0
	local intersection_x: f32 = 0
	local intersection_y: f32 = 0
	local intersection_z: f32 = 0
	damage = 0
	speed = 0.0
	stuck_in_wall = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		feather_x = out1 or feather_x
		feather_y = out2 or feather_y
		feather_z = out3 or feather_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(rotation_x, rotation_y, rotation_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	effect.get_script_value(2)
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	velocity_y = vm.f32(-0.6)
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_motion("ティグリフ羽弾（ループ）", 4)
	effect.create_collision_primitive("中攻撃")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(feather_x, feather_y, feather_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
		do
			local out1, out2, out3 = effect.add_vectors(feather_x, feather_y, feather_z, velocity_x, velocity_y, velocity_z)
			feather_x = out1 or feather_x
			feather_y = out2 or feather_y
			feather_z = out3 or feather_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(feather_x, feather_y, feather_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(feather_x, feather_y, feather_z)
		effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
		effect.set_collision_primitive_shape(feather_x, feather_y, feather_z, 8.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			stuck_in_wall = 0
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, feather_x, feather_y, feather_z)
				intersection_x = out1 or intersection_x
				intersection_y = out2 or intersection_y
				intersection_z = out3 or intersection_z
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				effect.create_effect_1("ティグ羽根Ｈ")
				effect.set_effect_first_work_vector(intersection_x, intersection_y, intersection_z)
				stuck_in_wall = 1
				effect.set_effect_character_position(intersection_x, intersection_y, intersection_z)
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(feather_x, feather_y, feather_z)
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
	if stuck_in_wall ~= 0 then
		effect.set_effect_character_visible(0, 1, -0.9)
		frame = 0
		while frame < 30 do
			vm.wait()
			frame = frame + 1
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
