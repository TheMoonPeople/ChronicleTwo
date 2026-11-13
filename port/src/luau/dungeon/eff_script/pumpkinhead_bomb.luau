--!strict
--- A bomb thrown by a pumpkin-headed enemy that arcs through the air and explodes on landing.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Throws the bomb along a parabolic path with a damaging hitbox until it lands and spawns a small explosion.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local horizontal_distance: f32 = 0
	local height: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_z: f32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	local value: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	hit_result = effect.get_target_character() or hit_result
	value = effect.get_script_value(0) or value
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(hit_result)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(rot_x, rot_y, rot_z)
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
		local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(position_x, position_y, position_z, work_vect2_x)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(rot_x, rot_y, rot_z)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 1.0)
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(value)
	do
		local out1, out2, out3 = effect.copy_vector(work_vect1_x, work_vect1_y, work_vect1_z)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	work_vect2_y = vm.f32(vm.f32(work_vect2_y / 180.0) * vm.f32(3.1415927))
	rot_x = vm.cos(work_vect2_y)
	rot_y = vm.sin(work_vect2_y)
	work_vect2_z = -work_vect2_z
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
		end
		height = vm.f32(work_vect2_x * frame)
		horizontal_distance = vm.f32(height * rot_x)
		height = vm.f32(vm.f32(height * rot_y) + vm.f32(vm.f32(vm.f32(work_vect2_z * frame) * frame) * 0.5))
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		position_y = 1.0
		position_x = vm.f32(position_x * horizontal_distance)
		position_z = vm.f32(position_z * horizontal_distance)
		position_y = vm.f32(position_y * height)
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, work_vect1_x, work_vect1_y, work_vect1_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3, out4 = effect.get_intersection_point_11(4, hit_x, hit_y, hit_z, position_x, position_y, position_z)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.delete_collision_primitive(-1)
			effect.create_effect_1("Ｍ小爆発")
			effect.set_effect_first_work_vector(hit_x, hit_y + 1.0, hit_z)
			break
		else
			effect.set_effect_character_position(position_x, position_y, position_z)
			effect.set_collision_primitive_shape(position_x, position_y, position_z, 10.0)
			vm.wait()
			frame = frame + 1
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
