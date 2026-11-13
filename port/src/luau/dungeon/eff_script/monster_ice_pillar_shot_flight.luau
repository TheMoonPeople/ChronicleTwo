--!strict
--- Flies a monster ice shot forward and raises an ice pillar where it hits the ground.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the ice shot forward, raises an ice pillar at the wall hit, and removes its collision.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
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
	local hit_count: s32 = 0
	local wall_hit_x: f32 = 0
	local wall_hit_y: f32 = 0
	local wall_hit_z: f32 = 0
	damage = 0
	speed = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
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
	effect.set_effect_character_motion("冷気弾（発射）")
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 90 do
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
		effect.set_effect_character_position(position_x, position_y, position_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 10.0)
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
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
				effect.create_effect_1("氷柱")
				effect.set_effect_first_work_vector(wall_hit_x, wall_hit_y, wall_hit_z)
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

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
