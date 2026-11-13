--!strict
--- Dragon fireball projectile that flies forward and explodes on impact.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Flies the fireball, damages targets, and creates the explosion on impact.
function script.on_start()
	local fireball_x: f32 = 0
	local fireball_y: f32 = 0
	local fireball_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local hit_result: s32 = 0
	local intersection_x: f32 = 0
	local intersection_y: f32 = 0
	local intersection_z: f32 = 0
	damage = 0
	speed = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		fireball_x = out1 or fireball_x
		fireball_y = out2 or fireball_y
		fireball_z = out3 or fireball_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
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
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_motion("火炎弾ループ", -1, 4)
	effect.set_effect_character_scale(1.2, 1.2, 1.2)
	do
		local out1, out2, out3 = effect.copy_vector(fireball_x, fireball_y, fireball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
		if frame == 4 then
			effect.create_collision_primitive("ドラゴン火弾")
			effect.set_collision_primitive_damage(damage)
		end
		do
			local out1, out2, out3 = effect.add_vectors(fireball_x, fireball_y, fireball_z, velocity_x, velocity_y, velocity_z)
			fireball_x = out1 or fireball_x
			fireball_y = out2 or fireball_y
			fireball_z = out3 or fireball_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(fireball_x, fireball_y, fireball_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(fireball_x, fireball_y, fireball_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		if frame > 4 then
			effect.set_collision_primitive_shape(fireball_x, fireball_y, fireball_z, 12.0)
		end
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.create_effect_1("ドラゴン火弾Ｈ")
			effect.set_effect_first_work_vector(fireball_x, fireball_y, fireball_z)
			effect.set_effect_value(0, damage)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, fireball_x, fireball_y, fireball_z)
				intersection_x = out1 or intersection_x
				intersection_y = out2 or intersection_y
				intersection_z = out3 or intersection_z
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				effect.create_effect_1("ドラゴン火弾Ｈ")
				effect.set_effect_first_work_vector(intersection_x, intersection_y, intersection_z)
				effect.set_effect_value(0, damage)
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(fireball_x, fireball_y, fireball_z)
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
