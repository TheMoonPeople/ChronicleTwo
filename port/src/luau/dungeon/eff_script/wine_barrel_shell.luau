--!strict
--- A homing barrel shell that trails smoke and explodes on impact.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Flies the shell toward the target with a smoke trail and spawns an explosion when it hits or times out.
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
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local target_id: s32 = 0
	local frame: s32 = 0
	local smoke_cursor: s32 = 0
	local hit_result: s32 = 0
	local allocation_result: s32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local is_facing_target: s32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	frame = 0
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
	effect.get_script_value(0)
	target_id = effect.get_target_character() or target_id
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	allocation_result = effect.allocate_sprites_2(42) or allocation_result
	if allocation_result == 0 then
		return
	end
	effect.set_sprite_texture("Shell_kemuri")
	effect.reset_sprites(0, 42)
	effect.set_sprite_visible(0, 1, 42)
	effect.set_sprite_blend_mode(0, 2, 42)
	effect.set_sprite_size(0, 24.0, 24.0, 42)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 42)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 42)
	while true do
		do
			local out1, out2, out3 = effect.get_effect_character_direction()
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
			local out1, out2, out3 = effect.scale_vector(direction_x, direction_y, direction_z, 48.0)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
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
			effect.create_effect_1("爆発")
			effect.set_effect_first_work_vector(hit_x, hit_y, hit_z)
			effect.set_effect_value(0, 0)
			break
		else
			if target_id >= 0 then
				do
					local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
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
			end
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z, 12)
			if frame == 1 then
				for puff_index = 0, 9 do
					value_3 = effect.get_random_number(20.0) or value_3
					value_2 = effect.get_random_number(3.1415927) or value_2
					puff_x = vm.f32(position_x + vm.f32(vm.sin(value_2) * value_3))
					puff_y = position_y
					puff_z = vm.f32(position_z + vm.f32(vm.cos(value_2) * value_3))
					value_3 = effect.get_random_number(0.2) or value_3
					value_3 = vm.f32(value_3 + vm.f32(0.2))
					effect.set_sprite_position(32 + puff_index, puff_x, puff_y, puff_z)
					effect.set_sprite_color(32 + puff_index, 128.0, 128.0, 128.0, 32.0)
					effect.set_sprite_velocity(32 + puff_index, 0.0, value_3, 0.0)
					effect.set_sprite_color_velocity(32 + puff_index, 0.0, 0.0, 0.0, -1.0)
					effect.set_sprite_angular_velocity(32 + puff_index, 0.02)
				end
			end
			if vm.imod(frame, 2) == 0 then
				effect.set_sprite_position(smoke_cursor, position_x, position_y, position_z)
				effect.set_sprite_velocity(smoke_cursor, 0.0, 0.5, 0.0)
				effect.set_sprite_color(smoke_cursor, 128.0, 128.0, 128.0, 32.0)
				effect.set_sprite_color_velocity(smoke_cursor, 0.0, 0.0, 0.0, -1.0)
				effect.set_sprite_angular_velocity(smoke_cursor, 0.02)
				smoke_cursor = smoke_cursor + 1
				if smoke_cursor >= 42 then
					smoke_cursor = 0
				end
			end
			effect.set_collision_primitive_shape(vector_x, vector_y, vector_z, position_x, position_y, position_z, 2.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("爆発")
				effect.set_effect_first_work_vector(position_x, position_y, position_z)
				effect.set_effect_value(0, 0)
				break
			elseif frame >= 90 then
				break
			else
				frame = frame + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
