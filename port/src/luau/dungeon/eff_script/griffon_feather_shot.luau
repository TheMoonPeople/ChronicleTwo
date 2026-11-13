--!strict
--- Fires a feather that flies straight, damages on contact and fades away.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Flies the feather along its direction, spawning the hit effect when it touches a character or a wall, then fades it out.
function script.on_start()
	local feather_x: f32 = 0
	local feather_y: f32 = 0
	local feather_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local speed_bonus: f32 = 0
	local hit_result: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		feather_x = out1 or feather_x
		feather_y = out2 or feather_y
		feather_z = out3 or feather_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	speed_bonus = 0.0
	speed_bonus = effect.get_random_number(10.0) or speed_bonus
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 10.0 + speed_bonus)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_position(feather_x, feather_y, feather_z)
	effect.create_collision_primitive("グリ羽根")
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
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(feather_x, feather_y, feather_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		effect.set_collision_primitive_shape(feather_x, feather_y, feather_z, 8.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.create_effect_1("グリ羽根Ｈ")
			effect.set_effect_first_work_vector(feather_x, feather_y, feather_z)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, feather_x, feather_y, feather_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				effect.create_effect_1("グリ羽根Ｈ")
				effect.set_effect_first_work_vector(hit_x, hit_y, hit_z)
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
	effect.set_effect_character_visible(0, 1, -0.1)
	frame = 0
	while frame < 30 do
		vm.wait()
		frame = frame + 1
	end
	effect.set_effect_character_visible(0, 0)
	effect.set_effect_character_position(0.0, -100.0, 0.0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
