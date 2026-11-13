--!strict
--- Flies an arrow forward from the owner and then steers it toward the player.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Holds the arrow at the owner's bow until released, flies it straight and then homes in on the player until it hits.
function script.on_start()
	local arrow_x: f32 = 0
	local arrow_y: f32 = 0
	local arrow_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local speed: f32 = 0
	local acceleration: f32 = 0
	local homing_weight: f32 = 0
	local steer_angle: f32 = 0
	local frame: s32 = 0
	local owner_id: s32 = 0
	local is_released: s32 = 0
	local tracks_player: s32 = 0
	local has_hit: s32 = 0
	local straight_hit_result: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local to_target_x: f32 = 0
	local to_target_y: f32 = 0
	local to_target_z: f32 = 0
	local heading_x: f32 = 0
	local heading_y: f32 = 0
	local heading_z: f32 = 0
	local homing_hit_result: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	speed = 0.0
	acceleration = 0.0
	homing_weight = 0.0
	steer_angle = 0.0
	effect.get_script_value(0)
	speed = effect.get_script_value_float(2) or speed
	acceleration = effect.get_script_value_float(3) or acceleration
	tracks_player = effect.get_script_value(4) or tracks_player
	homing_weight = effect.get_script_value_float(5) or homing_weight
	steer_angle = effect.get_script_value_float(6) or steer_angle
	owner_id = effect.get_owner_character() or owner_id
	effect.set_effect_character_motion("発射前", 4)
	effect.set_effect_character_visible(1, 1, 0.5)
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "arrow")
			arrow_x = out1 or arrow_x
			arrow_y = out2 or arrow_y
			arrow_z = out3 or arrow_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "arrow")
			pitch = out1 or pitch
			yaw = out2 or yaw
			roll = out3 or roll
		end
		effect.set_effect_character_position(arrow_x, arrow_y, arrow_z)
		effect.rotate_effect_character_toward(pitch, yaw, roll)
		is_released = effect.get_script_value(1) or is_released
		if is_released ~= 0 then
			break
		else
			vm.wait()
		end
	end
	effect.create_collision_primitive("通常攻撃")
	do
		local out1, out2, out3 = effect.get_effect_character_position()
		arrow_x = out1 or arrow_x
		arrow_y = out2 or arrow_y
		arrow_z = out3 or arrow_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(arrow_x, arrow_y, arrow_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "arrow")
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(pitch, yaw, roll)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	has_hit = 0
	frame = 0
	while frame < 9 do
		speed = vm.f32(speed + acceleration)
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
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
		do
			local out1, out2, out3 = effect.add_vectors(arrow_x, arrow_y, arrow_z, step_x, step_y, step_z)
			arrow_x = out1 or arrow_x
			arrow_y = out2 or arrow_y
			arrow_z = out3 or arrow_z
		end
		straight_hit_result = effect.get_collision_primitive_hit_count() or straight_hit_result
		if straight_hit_result > 0 then
			has_hit = 1
			break
		else
			do
				local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, arrow_x, arrow_y, arrow_z)
				straight_hit_result = out4 or straight_hit_result
			end
			if straight_hit_result >= 0 then
				has_hit = 1
				break
			else
				effect.set_effect_character_position(arrow_x, arrow_y, arrow_z)
				effect.set_collision_primitive_shape(arrow_x, arrow_y, arrow_z, 6.0)
				do
					local out1, out2, out3 = effect.copy_vector(arrow_x, arrow_y, arrow_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				vm.wait()
				frame = frame + 1
			end
		end
	end
	if has_hit == 0 then
		do
			local out1, out2, out3 = effect.get_scene_character_position(0)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		target_y = vm.f32(target_y + 30.0)
		do
			local out1, out2, out3 = effect.get_effect_character_position()
			arrow_x = out1 or arrow_x
			arrow_y = out2 or arrow_y
			arrow_z = out3 or arrow_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(target_x, target_y, target_z)
			to_target_x = out1 or to_target_x
			to_target_y = out2 or to_target_y
			to_target_z = out3 or to_target_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(to_target_x, to_target_y, to_target_z, arrow_x, arrow_y, arrow_z)
			to_target_x = out1 or to_target_x
			to_target_y = out2 or to_target_y
			to_target_z = out3 or to_target_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(to_target_x, to_target_y, to_target_z)
			to_target_x = out1 or to_target_x
			to_target_y = out2 or to_target_y
			to_target_z = out3 or to_target_z
		end
		heading_x = vm.f32(vm.f32(to_target_x * vm.cos(steer_angle)) + vm.f32(to_target_z * vm.sin(steer_angle)))
		heading_y = to_target_y
		heading_z = vm.f32(vm.f32(to_target_x * -vm.sin(steer_angle)) + vm.f32(to_target_z * vm.cos(steer_angle)))
		frame = 0
		while frame < 60 do
			speed = vm.f32(speed + acceleration)
			if tracks_player ~= 0 then
				do
					local out1, out2, out3 = effect.get_scene_character_position(0)
					target_x = out1 or target_x
					target_y = out2 or target_y
					target_z = out3 or target_z
				end
			end
			to_target_x = vm.f32(target_x - arrow_x)
			to_target_y = vm.f32(target_y - arrow_y)
			to_target_z = vm.f32(target_z - arrow_z)
			do
				local out1, out2, out3 = effect.normalize_vector(to_target_x, to_target_y, to_target_z)
				to_target_x = out1 or to_target_x
				to_target_y = out2 or to_target_y
				to_target_z = out3 or to_target_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(to_target_x, to_target_y, to_target_z, homing_weight)
				to_target_x = out1 or to_target_x
				to_target_y = out2 or to_target_y
				to_target_z = out3 or to_target_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(heading_x, heading_y, heading_z, 1.0 - homing_weight)
				heading_x = out1 or heading_x
				heading_y = out2 or heading_y
				heading_z = out3 or heading_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(heading_x, heading_y, heading_z, to_target_x, to_target_y, to_target_z)
				heading_x = out1 or heading_x
				heading_y = out2 or heading_y
				heading_z = out3 or heading_z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
				heading_x = out1 or heading_x
				heading_y = out2 or heading_y
				heading_z = out3 or heading_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(heading_x, heading_y, heading_z)
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
			do
				local out1, out2, out3 = effect.add_vectors(arrow_x, arrow_y, arrow_z, step_x, step_y, step_z)
				arrow_x = out1 or arrow_x
				arrow_y = out2 or arrow_y
				arrow_z = out3 or arrow_z
			end
			do
				local out1, out2, out3 = effect.get_effect_character_rotation_toward(arrow_x, arrow_y, arrow_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				roll = out3 or roll
			end
			homing_hit_result = effect.get_collision_primitive_hit_count() or homing_hit_result
			if homing_hit_result > 0 then
				effect.create_effect_1("ＤＥ矢Ｈ")
				effect.set_effect_first_work_vector(arrow_x, arrow_y, arrow_z)
				has_hit = 1
				break
			end
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, arrow_x, arrow_y, arrow_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				homing_hit_result = out4 or homing_hit_result
			end
			if homing_hit_result >= 0 then
				effect.create_effect_1("ＤＥ矢Ｈ")
				effect.set_effect_first_work_vector(hit_x, hit_y, hit_z)
				has_hit = 1
				break
			end
			effect.set_effect_character_position(arrow_x, arrow_y, arrow_z)
			effect.rotate_effect_character_toward(pitch, yaw, roll)
			effect.set_collision_primitive_shape(arrow_x, arrow_y, arrow_z, 6.0)
			do
				local out1, out2, out3 = effect.copy_vector(arrow_x, arrow_y, arrow_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			vm.wait()
			frame = frame + 1
		end
	end
	effect.delete_collision_primitive(-1)
	frame = 0
	effect.set_effect_character_visible(0, 1, -3.0)
	while frame < 15 do
		vm.wait()
		frame = frame + 1
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
