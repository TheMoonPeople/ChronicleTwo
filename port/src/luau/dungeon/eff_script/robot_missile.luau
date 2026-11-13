--!strict
--- A homing missile fired by a robot that explodes on contact with the player or the ground.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Flies the missile toward the target, leaving a smoke trail, and spawns an explosion on impact or timeout.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local scale: f32 = 0
	local target_id: s32 = 0
	local frame: s32 = 0
	local value: s32 = 0
	local hit_result: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local is_facing_target: s32 = 0
	local target_distance: f32 = 0
	local trail_offset_x: f32 = 0
	local trail_offset_y: f32 = 0
	local trail_offset_z: f32 = 0
	frame = 0
	scale = 16.0
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
	value = effect.get_script_value(0) or value
	target_id = effect.get_target_character() or target_id
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	effect.play_owner_sound(10)
	while true do
		do
			local out1, out2, out3 = effect.get_effect_character_direction()
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, scale)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, position_x, position_y, position_z)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("ロボミサイル爆発")
			effect.set_effect_first_work_vector(hit_x, hit_y, hit_z)
			effect.set_effect_value(0, value)
			break
		else
			do
				local out1, out2, out3 = effect.get_scene_character_position(target_id)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_y = vm.f32(pos_y + 25.0)
			do
				local out1, out2, out3 = effect.get_effect_character_rotation_toward(pos_x, pos_y, pos_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
			do
				local out1, out2, out3 = effect.get_effect_character_rotation()
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			is_facing_target = effect.compare_angles(rotation_y, yaw, 0.76) or is_facing_target
			if is_facing_target == 0 then
				do
					local out1, out2, out3 = effect.copy_vector(pitch, yaw, roll)
					rotation_x = out1 or rotation_x
					rotation_y = out2 or rotation_y
					rotation_z = out3 or rotation_z
				end
			end
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z, 6)
			do
				local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			target_distance = effect.get_distance_between(position_x, position_y, position_z, pos_x, pos_y, pos_z) or target_distance
			if target_distance <= 24.0 then
				effect.create_effect_1("ロボミサイル爆発")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				effect.set_effect_value(0, value)
				break
			else
				if vm.imod(frame, 3) == 0 then
					do
						local out1, out2, out3 = effect.get_effect_character_direction()
						trail_offset_x = out1 or trail_offset_x
						trail_offset_y = out2 or trail_offset_y
						trail_offset_z = out3 or trail_offset_z
					end
					trail_offset_x = -trail_offset_x
					trail_offset_y = -trail_offset_y
					trail_offset_z = -trail_offset_z
					do
						local out1, out2, out3 = effect.scale_vector(trail_offset_x, trail_offset_y, trail_offset_z, 40.0)
						trail_offset_x = out1 or trail_offset_x
						trail_offset_y = out2 or trail_offset_y
						trail_offset_z = out3 or trail_offset_z
					end
					effect.create_effect_1("ロボミサイル煙")
					effect.set_effect_first_work_vector(position_x + trail_offset_x, position_y + trail_offset_y, position_z + trail_offset_z)
				end
				if frame >= 150 then
					effect.create_effect_1("ロボミサイル爆発")
					effect.set_effect_first_work_vector(position_x, position_y, position_z)
					effect.set_effect_value(0, value)
					break
				else
					frame = frame + 1
					vm.wait()
				end
			end
		end
	end
	effect.stop_owner_sound(10)
	effect.play_owner_sound(11)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
