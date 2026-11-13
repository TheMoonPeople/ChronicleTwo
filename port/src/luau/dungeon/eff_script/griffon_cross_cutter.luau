--!strict
--- Launches a spinning cross-shaped blade that accelerates forward and damages what it hits.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Accelerates the blade along its heading until it hits a character or a wall, then fades it out.
function script.on_start()
	local blade_x: f32 = 0
	local blade_y: f32 = 0
	local blade_z: f32 = 0
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local hit_result: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		blade_x = out1 or blade_x
		blade_y = out2 or blade_y
		blade_z = out3 or blade_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(blade_x, blade_y, blade_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("ループ")
	speed = 10.0
	do
		local out1, out2, out3 = effect.get_direction_vector(rotation_x, rotation_y, rotation_z)
		dir_x = out1 or dir_x
		dir_y = out2 or dir_y
		dir_z = out3 or dir_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, 10.0)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	effect.create_collision_primitive("吹っ飛び中")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(blade_x, blade_y, blade_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 130 do
		do
			local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(step_x, step_y, step_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, speed)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		speed = vm.f32(speed + vm.f32(1.2))
		vm.wait()
		do
			local out1, out2, out3 = effect.add_vectors(blade_x, blade_y, blade_z, step_x, step_y, step_z)
			blade_x = out1 or blade_x
			blade_y = out2 or blade_y
			blade_z = out3 or blade_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(blade_x, blade_y, blade_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(blade_x, blade_y, blade_z)
		effect.set_collision_primitive_shape(blade_x, blade_y, blade_z, 25.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.delete_collision_primitive(-1)
			if frame < 115 then
				frame = 115
			end
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, blade_x, blade_y, blade_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.delete_collision_primitive(-1)
			if frame < 115 then
				frame = 115
			end
		end
		do
			local out1, out2, out3 = effect.copy_vector(blade_x, blade_y, blade_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		if frame == 115 then
			effect.delete_collision_primitive(-1)
			effect.set_effect_character_visible(0, 1, -0.9)
		end
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
