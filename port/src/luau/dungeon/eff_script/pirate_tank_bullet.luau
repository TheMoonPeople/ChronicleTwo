--!strict
--- Pirate Tank's fast bullet that flies straight until it hits something.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Flies the bullet forward and damages targets until it hits.
function script.on_start()
	local bullet_x: f32 = 0
	local bullet_y: f32 = 0
	local bullet_z: f32 = 0
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
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bullet_x = out1 or bullet_x
		bullet_y = out2 or bullet_y
		bullet_z = out3 or bullet_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	speed = effect.get_script_value_float(1) or speed
	effect.set_effect_character_position(bullet_x, bullet_y, bullet_z)
	effect.set_effect_character_visible(1, 1, 0.1)
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
	effect.create_collision_primitive("弱攻撃")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
		do
			local out1, out2, out3 = effect.add_vectors(bullet_x, bullet_y, bullet_z, velocity_x, velocity_y, velocity_z)
			bullet_x = out1 or bullet_x
			bullet_y = out2 or bullet_y
			bullet_z = out3 or bullet_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(bullet_x, bullet_y, bullet_z)
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(bullet_x, bullet_y, bullet_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		effect.set_collision_primitive_shape(bullet_x, bullet_y, bullet_z, 5.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			break
		else
			do
				local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
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
