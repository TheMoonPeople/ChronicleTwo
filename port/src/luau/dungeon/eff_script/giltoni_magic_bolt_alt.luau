--!strict
--- Flies the alternate Giltoni magic bolt that curves toward its target and drops spark effects along the way.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Charges at the owner's magic bone, then launches the bolt homing on the target until it hits the ground.
function script.on_start()
	local bolt_x: f32 = 0
	local bolt_y: f32 = 0
	local bolt_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local target_id: s32 = 0
	local user_id: s32 = 0
	local damage: s32 = 0
	local frame: s32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local hit_result: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_yaw: f32 = 0
	local is_facing_target: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bolt_x = out1 or bolt_x
		bolt_y = out2 or bolt_y
		bolt_z = out3 or bolt_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	damage = effect.get_script_value(0) or damage
	target_id = effect.get_target_character() or target_id
	user_id = effect.get_owner_character() or user_id
	frame = 0
	while frame < 10 do
		frame = frame + 1
		vm.wait()
	end
	effect.set_effect_character_motion("ループ", -1, 4)
	effect.set_effect_character_visible(1, 1, 0.04)
	frame = 0
	while frame < 24 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "magic")
			bolt_x = out1 or bolt_x
			bolt_y = out2 or bolt_y
			bolt_z = out3 or bolt_z
		end
		effect.set_effect_character_position(bolt_x, bolt_y, bolt_z)
		frame = frame + 1
		vm.wait()
	end
	effect.set_effect_character_visible(0)
	effect.create_collision_primitive("吹っ飛び弱")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while true do
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(pitch, yaw, roll)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, 16.0)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(bolt_x, bolt_y, bolt_z, step_x, step_y, step_z)
			bolt_x = out1 or bolt_x
			bolt_y = out2 or bolt_y
			bolt_z = out3 or bolt_z
		end
		hit_result = effect.get_intersection_point_8(0, previous_x, previous_y + 1.0, previous_z, bolt_x, bolt_y + 1.0, bolt_z) or hit_result
		if hit_result >= 0 then
			break
		else
			do
				local out1, out2, out3 = effect.get_scene_character_position(target_id)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			do
				local _, out2, _ = effect.get_rotation_toward_9(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z)
				target_yaw = out2 or target_yaw
			end
			is_facing_target = effect.compare_angles(yaw, target_yaw, 1.2) or is_facing_target
			if is_facing_target == 0 then
				target_yaw = vm.f32(target_yaw - yaw)
				target_yaw = effect.wrap_angle(target_yaw) or target_yaw
				target_yaw = vm.f32(target_yaw / 6.0)
				yaw = vm.f32(yaw + target_yaw)
				yaw = effect.wrap_angle(yaw) or yaw
			end
			if vm.imod(frame, 2) == 0 then
				effect.create_effect_1("ギル魔法サブ２")
				effect.set_effect_first_work_vector(bolt_x, 2.5, bolt_z)
			end
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			frame = vm.i32(frame + 1)
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
