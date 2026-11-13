--!strict
--- Poison arrow fired from the owner that falls in an arc and bounces off walls.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Flies the arrow, bounces it off walls, and fades it out when it misses.
function script.on_start()
	local arrow_x: f32 = 0
	local arrow_y: f32 = 0
	local arrow_z: f32 = 0
	local owner_rotation_x: f32 = 0
	local owner_rotation_y: f32 = 0
	local owner_rotation_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local bounce_x: f32 = 0
	local bounce_y: f32 = 0
	local bounce_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local launch_height: f32 = 0
	local owner_id: s32 = 0
	local missed_target: s32 = 0
	local damage: s32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	local wall_hit_count: s32 = 0
	local up_x: f32 = 0
	local up_y: f32 = 0
	local up_z: f32 = 0
	missed_target = 1
	damage = effect.get_script_value(0) or damage
	owner_id = effect.get_owner_character() or owner_id
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol0")
		arrow_x = out1 or arrow_x
		arrow_y = out2 or arrow_y
		arrow_z = out3 or arrow_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(owner_id)
		owner_rotation_x = out1 or owner_rotation_x
		owner_rotation_y = out2 or owner_rotation_y
		owner_rotation_z = out3 or owner_rotation_z
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(owner_rotation_x, owner_rotation_y, owner_rotation_z)
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
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 12.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_effect_character_position(arrow_x, arrow_y, arrow_z)
	effect.rotate_effect_character_toward(owner_rotation_x, owner_rotation_y, owner_rotation_z)
	effect.set_effect_character_visible(1, 1)
	effect.create_collision_primitive("通常毒")
	effect.set_collision_primitive_damage(damage)
	effect.set_effect_character_motion("ループ", -1, 0)
	launch_height = arrow_y
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.get_direction_vector(owner_rotation_x, owner_rotation_y, owner_rotation_z)
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 12.0 - vm.f32(vm.f32(0.02) * frame))
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		if frame > 30 then
			velocity_y = vm.f32(velocity_y - vm.f32(vm.f32(0.06) * frame))
		end
		do
			local out1, out2, out3 = effect.copy_vector(arrow_x, arrow_y, arrow_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(arrow_x, arrow_y, arrow_z, velocity_x, velocity_y, velocity_z)
			arrow_x = out1 or arrow_x
			arrow_y = out2 or arrow_y
			arrow_z = out3 or arrow_z
		end
		hit_result = effect.get_intersection_point_8(4, previous_x, previous_y, previous_z, arrow_x, arrow_y, arrow_z) or hit_result
		if hit_result >= 0 then
			wall_hit_count = 0
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					effect.get_intersection_point_14(4, previous_x, previous_y, previous_z, arrow_x, arrow_y, arrow_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
				normal_x = out4 or normal_x
				normal_y = out5 or normal_y
				normal_z = out6 or normal_z
				hit_result = out7 or hit_result
			end
			do
				local out1, out2, out3 = effect.get_direction_vector(owner_rotation_x + vm.f32(1.5707964), 0.0, 0.0)
				up_x = out1 or up_x
				up_y = out2 or up_y
				up_z = out3 or up_z
			end
			do
				local out1, out2, out3 = effect.get_direction_vector(0.0, owner_rotation_y + vm.f32(3.1415927), 0.0)
				bounce_x = out1 or bounce_x
				bounce_y = out2 or bounce_y
				bounce_z = out3 or bounce_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(bounce_x, bounce_y, bounce_z, up_x, up_y, up_z)
				bounce_x = out1 or bounce_x
				bounce_y = out2 or bounce_y
				bounce_z = out3 or bounce_z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(bounce_x, bounce_y, bounce_z)
				bounce_x = out1 or bounce_x
				bounce_y = out2 or bounce_y
				bounce_z = out3 or bounce_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(bounce_x, bounce_y, bounce_z, normal_x, normal_y, normal_z)
				bounce_x = out1 or bounce_x
				bounce_y = out2 or bounce_y
				bounce_z = out3 or bounce_z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(bounce_x, bounce_y, bounce_z)
				bounce_x = out1 or bounce_x
				bounce_y = out2 or bounce_y
				bounce_z = out3 or bounce_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(bounce_x, bounce_y, bounce_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 4.5)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			if velocity_y > 0.0 or arrow_y < vm.f32(launch_height - 10.0) then
				break
			else
				frame = 0
				while frame < 20 do
					do
						local out1, out2, out3 = effect.copy_vector(arrow_x, arrow_y, arrow_z)
						previous_x = out1 or previous_x
						previous_y = out2 or previous_y
						previous_z = out3 or previous_z
					end
					do
						local out1, out2, out3 = effect.add_vectors(arrow_x, arrow_y, arrow_z, velocity_x, velocity_y, velocity_z)
						arrow_x = out1 or arrow_x
						arrow_y = out2 or arrow_y
						arrow_z = out3 or arrow_z
					end
					effect.delete_collision_primitive(-1)
					hit_result = effect.get_intersection_point_8(4, previous_x, previous_y, previous_z, arrow_x, arrow_y, arrow_z) or hit_result
					if hit_result < 0 then
						effect.set_effect_character_position(arrow_x, arrow_y, arrow_z)
					else
						wall_hit_count = wall_hit_count + 1
						if wall_hit_count > 1 then
							break
						end
					end
					vm.wait()
					frame = frame + 1
				end
				break
			end
		else
			effect.set_effect_character_position(arrow_x, arrow_y, arrow_z)
			effect.set_collision_primitive_shape(arrow_x, arrow_y, arrow_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				missed_target = 0
				break
			else
				vm.wait()
				frame = frame + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
	if missed_target == 1 then
		effect.set_effect_character_motion("ループ", -1, 1)
		effect.set_effect_character_visible(0, 1, -7.0)
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
