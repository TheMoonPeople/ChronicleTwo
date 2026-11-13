--!strict
--- Fires a wine barrel shell that flies in the direction given, steers toward its target, trails smoke, and explodes on impact.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Flies the shell forward in fixed steps with a smoke trail, turning toward the target when roughly facing it, and spawns an explosion on a wall or character hit or ends after ninety frames.
function script.on_start()
	local shell_x: f32 = 0
	local shell_y: f32 = 0
	local shell_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local target_id: s32 = 0
	local frame: s32 = 0
	local smoke_index: s32 = 0
	local hit_result: s32 = 0
	local sprites_allocated: s32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local target_roll: f32 = 0
	local angle_mismatch: s32 = 0
	local puff_angle: f32 = 0
	local puff_radius: f32 = 0
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	print("---------  FIRE!!!      \n")
	frame = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		shell_x = out1 or shell_x
		shell_y = out2 or shell_y
		shell_z = out3 or shell_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	effect.get_script_value(0)
	target_id = effect.get_target_character() or target_id
	print("pos[0] = ", vm.float(shell_x), "----------------\n")
	print("pos[1] = ", vm.float(shell_y), "----------------\n")
	print("pos[2] = ", vm.float(shell_z), "----------------\n")
	effect.set_effect_character_position(shell_x, shell_y, shell_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	sprites_allocated = effect.allocate_sprites_2(42) or sprites_allocated
	if sprites_allocated == 0 then
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 48.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(shell_x, shell_y, shell_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(shell_x, shell_y, shell_z, velocity_x, velocity_y, velocity_z)
			shell_x = out1 or shell_x
			shell_y = out2 or shell_y
			shell_z = out3 or shell_z
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, shell_x, shell_y, shell_z)
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
					target_x = out1 or target_x
					target_y = out2 or target_y
					target_z = out3 or target_z
				end
				do
					local out1, out2, out3 = effect.get_effect_character_rotation_toward(target_x, target_y, target_z)
					target_pitch = out1 or target_pitch
					target_yaw = out2 or target_yaw
					target_roll = out3 or target_roll
				end
				do
					local out1, out2, out3 = effect.get_effect_character_rotation()
					rotation_x = out1 or rotation_x
					rotation_y = out2 or rotation_y
					rotation_z = out3 or rotation_z
				end
				angle_mismatch = effect.compare_angles(rotation_y, target_yaw, 0.76) or angle_mismatch
				if angle_mismatch == 0 then
					do
						local out1, out2, out3 = effect.copy_vector(target_pitch, target_yaw, target_roll)
						rotation_x = out1 or rotation_x
						rotation_y = out2 or rotation_y
						rotation_z = out3 or rotation_z
					end
				end
			end
			effect.set_effect_character_position(shell_x, shell_y, shell_z)
			effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z, 12)
			if frame == 1 then
				for i = 0, 9 do
					puff_radius = effect.get_random_number(20.0) or puff_radius
					puff_angle = effect.get_random_number(3.1415927) or puff_angle
					puff_x = vm.f32(shell_x + vm.f32(vm.sin(puff_angle) * puff_radius))
					puff_y = shell_y
					puff_z = vm.f32(shell_z + vm.f32(vm.cos(puff_angle) * puff_radius))
					puff_radius = effect.get_random_number(0.2) or puff_radius
					puff_radius = vm.f32(puff_radius + vm.f32(0.2))
					effect.set_sprite_position(32 + i, puff_x, puff_y, puff_z)
					effect.set_sprite_color(32 + i, 128.0, 128.0, 128.0, 32.0)
					effect.set_sprite_velocity(32 + i, 0.0, puff_radius, 0.0)
					effect.set_sprite_color_velocity(32 + i, 0.0, 0.0, 0.0, -1.0)
					effect.set_sprite_angular_velocity(32 + i, 0.02)
				end
			end
			if vm.imod(frame, 2) == 0 then
				effect.set_sprite_position(smoke_index, shell_x, shell_y, shell_z)
				effect.set_sprite_velocity(smoke_index, 0.0, 0.5, 0.0)
				effect.set_sprite_color(smoke_index, 128.0, 128.0, 128.0, 32.0)
				effect.set_sprite_color_velocity(smoke_index, 0.0, 0.0, 0.0, -1.0)
				effect.set_sprite_angular_velocity(smoke_index, 0.02)
				smoke_index = smoke_index + 1
				if smoke_index >= 42 then
					smoke_index = 0
				end
			end
			effect.set_collision_primitive_shape(previous_x, previous_y, previous_z, shell_x, shell_y, shell_z, 2.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("爆発")
				effect.set_effect_first_work_vector(shell_x, shell_y, shell_z)
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
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
