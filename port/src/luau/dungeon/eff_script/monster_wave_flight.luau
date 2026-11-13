--!strict
--- Sends a wave forward from the caster in a straight line that knocks back whatever it hits.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the wave forward each frame until it hits a character or the map, then fades the wave out while it keeps moving.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local hit_result: s32 = 0
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
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(pitch, yaw, roll)
	effect.set_effect_character_motion("ループ")
	do
		local out1, out2, out3 = effect.get_direction_vector(pitch, yaw, roll)
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
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 15.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 115 do
		vm.wait()
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
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 25.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			break
		else
			do
				local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
				hit_result = out4 or hit_result
			end
			if hit_result >= 0 then
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				frame = frame + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_character_visible(0, 1, -0.9)
	frame = 0
	while frame < 15 do
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

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
