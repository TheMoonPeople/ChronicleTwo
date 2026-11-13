--!strict
--- Controls one butterfly of the boss flock, which hovers on a ring around the arena and dashes at the player.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local sense = require("@lib/monster/sense")
local timer = require("@lib/monster/timer")

local behavior_state: s32 = 0

--- Hovers at ground level until the flock is released.
local function wait_for_flock_start()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	monster.set_motion("飛行")
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, 0.0, pos_z)
	while true do
		value = monster.get_variable(8) or value
		if value ~= 0 and value ~= 8 and value ~= 16 then
			break
		else
			vm.wait()
		end
	end
end

--- Computes the position of a flock slot on the ring around the arena centre.
local function get_formation_position(slot_index: s32, out_x: f32, out_y: f32, out_z: f32)
	local slot_angle: f32 = 0
	local ring_radius: f32 = 0
	local offset_x: f32 = 0
	local offset_z: f32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	slot_angle = vm.f32(vm.f32(vm.f32(3.1415927) * vm.i32(slot_index - 1)) * 0.25)
	ring_radius = 625.0
	offset_x, offset_z = calc.get_polar_offset(slot_angle, ring_radius, offset_x, offset_z)
	center_x = vm.f32(268.8)
	center_y = 812.5
	center_z = vm.f32(-322.4)
	center_x = vm.f32(center_x + offset_x)
	center_z = vm.f32(center_z + offset_z)
	out_x = center_x
	out_y = center_y
	out_z = center_z
	return out_x, out_y, out_z
end

--- Stores the state of a flock slot in the shared variables.
local function set_slot_state(slot_index: s32, value: s32)
	monster.set_variable(vm.i32(vm.i32(9 + slot_index) - 1), value)
end

--- Flies toward a position while turning and climbing, returning the state to continue with.
local function fly_to_position(target: f32, target_2: f32, target_3: f32, ignores_merge: s32, invulnerable_frames: s32)
	local result: s32 = 0
	local frame_count: s32 = 0
	local is_flying: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local turn_step: f32 = 0
	local relative_angle: f32 = 0
	local step_x: f32 = 0
	local step_z: f32 = 0
	local climb_step: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_z: f32 = 0
	local y_2: f32 = 0
	local value: s32 = 0
	local target_distance: f32 = 0
	frame_count = 0
	is_flying = 1
	while is_flying ~= 0 do
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_rotation()
			yaw = out2 or yaw
		end
		relative_angle = sense.get_relative_angle_to_point(pos_x, pos_z, yaw, target, target_3)
		if true then
			if 0 < relative_angle then
				turn_step = relative_angle
				if vm.f32(0.05) < turn_step then
					turn_step = vm.f32(0.05)
				end
			else
				turn_step = relative_angle
				if turn_step < vm.f32(-0.05) then
					turn_step = vm.f32(-0.05)
				end
			end
		else
			turn_step = 0.0
		end
		step_x, step_z = calc.get_polar_offset(vm.f32(yaw + turn_step), 5.0, step_x, step_z)
		if pos_y == target_2 then
			climb_step = 0.0
		else
			climb_step = vm.f32(target_2 - pos_y)
			if pos_y < target_2 then
				if climb_step > 1.0 then
					climb_step = 1.0
				end
			elseif climb_step < -1.0 then
				climb_step = -1.0
			end
		end
		x = vm.f32(pos_x + step_x)
		y = vm.f32(pos_y + climb_step)
		z = vm.f32(pos_z + step_z)
		monster.set_position(x, y, z)
		do
			local out1, _, out3 = monster.get_rotation()
			rotation_x = out1 or rotation_x
			rotation_z = out3 or rotation_z
		end
		y_2 = vm.f32(yaw + turn_step)
		if y_2 > vm.f32(3.1415927) then
			y_2 = vm.f32(y_2 - vm.f32(6.2831855))
		end
		if y_2 <= vm.f32(-3.1415927) then
			y_2 = vm.f32(y_2 + vm.f32(6.2831855))
		end
		monster.set_rotation(rotation_x, y_2, rotation_z)
		vm.wait()
		frame_count = vm.i32(frame_count + 1)
		if frame_count == invulnerable_frames then
			monster.set_scene_character_status(32, 0)
		end
		value = monster.get_variable(8) or value
		if value == 0 then
			is_flying = 0
			result = 1
		end
		if value == 8 then
			is_flying = 0
			result = 0
		end
		if value == 9 and ignores_merge ~= 1 then
			is_flying = 0
			result = 3
		end
		target_distance = monster.get_distance_to_position(target, target_2, target_3) or target_distance
		if target_distance <= 10.0 then
			is_flying = 0
			result = 6
		end
	end
	monster.set_scene_character_status(32, 0)
	return result
end

--- Moves to the arena ring at a fixed height and then flies to this butterfly's formation slot.
local function fly_to_formation_slot()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local monster_id: s32 = 0
	local slot_x: f32 = 0
	local slot_y: f32 = 0
	local slot_z: f32 = 0
	local rotation_x: f32 = 0
	local yaw: f32 = 0
	local rotation_z: f32 = 0
	monster.set_motion("飛行")
	monster.set_monster_attributes(1, 0)
	monster.set_monster_attributes(32, 0)
	do
		local out1, _, out3 = monster.get_kind_position_4(501)
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	x = pos_x
	y = 1050.0
	z = pos_z
	monster.set_position(x, y, z)
	monster_id = monster.get_monster_kind() or monster_id
	slot_x, slot_y, slot_z = get_formation_position(vm.i32(monster_id - 501), slot_x, slot_y, slot_z)
	set_slot_state(vm.i32(monster_id - 501), vm.i32(monster_id - 501))
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		yaw = out2 or yaw
		rotation_z = out3 or rotation_z
	end
	yaw = monster.get_arc_tangent(slot_x - x, slot_z - z) or yaw
	yaw = vm.f32(yaw + vm.f32(3.1415927))
	if vm.f32(3.1415927) < yaw then
		yaw = vm.f32(yaw - vm.f32(6.2831855))
	end
	monster.set_rotation(rotation_x, yaw, rotation_z)
	return fly_to_position(slot_x, slot_y, slot_z, 0, 0)
end

--- Turns toward a point and then flies to it step by step, returning the state to continue with.
local function fly_toward_point(to: f32, to_2: f32, to_3: f32, ignores_merge: s32)
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local yaw: f32 = 0
	local rotation_z: f32 = 0
	local turn_step: f32 = 0
	local relative_angle: f32 = 0
	local y: f32 = 0
	local value_2: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local next_x: f32 = 0
	local next_y: f32 = 0
	local next_z: f32 = 0
	local result: s32 = 0
	monster.set_motion("飛行")
	while true do
		value = monster.get_variable(8) or value
		if value == 0 then
			return 1
		end
		if value == 8 then
			return 0
		end
		if value == 9 and ignores_merge ~= 1 then
			return 3
		end
		do
			local out1, _, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_rotation()
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		relative_angle = sense.get_relative_angle_to_point(pos_x, pos_z, yaw, to, to_3)
		if vm.f32(0.01) < relative_angle or relative_angle < vm.f32(-0.01) then
			if 0 < relative_angle then
				turn_step = relative_angle
				if vm.f32(0.05) < turn_step then
					turn_step = vm.f32(0.05)
				end
			else
				turn_step = relative_angle
				if turn_step < vm.f32(-0.05) then
					turn_step = vm.f32(-0.05)
				end
			end
		else
			break
		end
		y = vm.f32(yaw + turn_step)
		if y > vm.f32(3.1415927) then
			y = vm.f32(y - vm.f32(6.2831855))
		end
		if y <= vm.f32(-3.1415927) then
			y = vm.f32(y + vm.f32(6.2831855))
		end
		monster.set_rotation(rotation_x, y, rotation_z)
		vm.wait()
	end
	while true do
		value_2 = monster.get_variable(8) or value_2
		if value_2 == 0 then
			return 1
		end
		if value_2 == 8 then
			return 0
		end
		if value_2 == 9 and ignores_merge ~= 1 then
			return 3
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, out3, out4 = monster.get_next_move_position(pos_x_2, pos_y_2, pos_z_2, to, to_2, to_3, 5.0)
			next_x = out1 or next_x
			next_y = out2 or next_y
			next_z = out3 or next_z
			result = out4 or result
		end
		monster.set_position(next_x, next_y, next_z)
		vm.wait()
		if result ~= 0 then
			return 6
		end
	end
	return 0
end

--- Spawns a sticky effect and flies to the arena centre, then queues up for the merge.
local function launch_sticky_attack()
	local monster_id: s32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_angle: f32 = 0
	local result: s32 = 0
	local value: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	set_slot_state(vm.i32(monster_id - 501), 0)
	monster.set_motion("飛行")
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	target_angle = monster.get_target_angle() or target_angle
	monster.create_effect_1("蝶ねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, 0.0, target_angle, 0.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, 1)
	result = fly_toward_point(vm.f32(268.8), 1050.0, vm.f32(-322.4), 1)
	if result == 0 then
		return 0
	end
	if result == 1 then
		return 1
	end
	value = monster.get_variable(8) or value
	if value == 15 then
		monster.set_variable(8, 0)
	else
		monster.set_variable(8, vm.i32(value + 1))
		while value ~= 0 do
			vm.wait()
			value = monster.get_variable(8) or value
		end
	end
	return 1
end

--- Returns 1 when another butterfly of the flock is within a short distance.
local function is_near_other_butterfly()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local monster_id: s32 = 0
	local index: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local distance: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster_id = monster.get_monster_kind() or monster_id
	index = 502
	while index <= 508 do
		if index == monster_id then
			index = index + 1
			continue
		end
		do
			local out1, out2, out3 = monster.get_kind_position_4(index)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		distance = monster.get_distance_between(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2) or distance
		if distance < 50.0 then
			return 1
		end
		index = index + 1
	end
	return 0
end

--- Hovers until the player gets close and fast, or the flock changes state.
local function hover_until_threatened()
	local is_overlapping: s32 = 0
	local target_distance: f32 = 0
	local target_speed: f32 = 0
	local value: s32 = 0
	is_overlapping = is_near_other_butterfly()
	if is_overlapping ~= 0 then
		return 5
	end
	monster.set_motion("飛行", -1, 1)
	while true do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 200.0 then
			target_speed = monster.get_target_speed() or target_speed
			if 3.0 < target_speed then
				return 5
			end
		end
		value = monster.get_variable(8) or value
		if value == 8 then
			return 0
		end
		if value == 9 then
			return 3
		end
		vm.wait()
	end
	return 0
end

--- Reads the state of a flock slot from the shared variables.
local function get_slot_state(slot_index: s32)
	local value: s32 = 0
	value = monster.get_variable(vm.i32(vm.i32(9 + slot_index) - 1)) or value
	return value
end

--- Finds a ring slot that no butterfly occupies and that differs from the current one.
local function find_free_slot(current_slot: any)
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(12, 0)
	frame[1] = current_slot
	frame[10] = 0
	while frame[10] < 8 do
		frame[vm.index(vm.i32(frame[10] + 1), 12)] = 0
		frame[10] = vm.i32(frame[10] + 1)
	end
	frame[12] = 1
	while frame[12] <= 7 do
		frame[11] = get_slot_state(frame[12])
		frame[vm.index(frame[11], 12)] = frame[12]
		frame[12] = vm.i32(frame[12] + 1)
	end
	frame[10] = 0
	while frame[10] < 8 do
		if frame[vm.index(vm.i32(frame[10] + 1), 12)] == 0 then
			if frame[1] == 0 then
				return vm.i32(frame[10] + 1)
			end
			if frame[1] ~= vm.i32(frame[10] + 1) then
				return vm.i32(frame[10] + 1)
			end
		end
		frame[10] = vm.i32(frame[10] + 1)
	end
	return 0
end

--- Dashes to a free ring slot while spawning a sticky effect on the way.
local function dash_to_free_slot()
	local value: s32 = 0
	local monster_id: s32 = 0
	local current_slot: s32 = 0
	local new_slot: s32 = 0
	local slot_x: f32 = 0
	local slot_y: f32 = 0
	local slot_z: f32 = 0
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_angle: f32 = 0
	value = monster.get_variable(18) or value
	if value == 1 then
		monster.set_variable(18, 2)
		monster.request_event_script(503)
		vm.wait()
	end
	monster.set_scene_character_status(32, 1)
	monster.set_motion("急ぎ飛行")
	monster_id = monster.get_monster_kind() or monster_id
	current_slot = get_slot_state(vm.i32(monster_id - 501))
	new_slot = find_free_slot(current_slot)
	set_slot_state(vm.i32(monster_id - 501), new_slot)
	slot_x, slot_y, slot_z = get_formation_position(new_slot, slot_x, slot_y, slot_z)
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	target_angle = monster.get_target_angle() or target_angle
	monster.create_effect_1("蝶ねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, 0.0, target_angle, 0.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, 0)
	return fly_to_position(slot_x, slot_y, slot_z, 0, 30)
end

--- Plays the damage motion and then lifts the butterfly back up to the ring height.
local function rise_after_defeat()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local frame: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ダメージ", -1, 6)
	monster.play_sound(11)
	motion.wait_until_ended()
	monster.set_motion("急ぎ飛行")
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	frame = 0
	while frame < 120 do
		x = pos_x
		y = calc.interpolate(pos_y, 1050.0, vm.f32(vm.fdiv(frame, 120)))
		z = pos_z
		monster.set_position(x, y, z)
		frame = frame + 1
		vm.wait()
	end
end

--- Hovers at ring height until the flock either revives or ends, returning 1 on revival.
local function wait_for_revival()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	monster.set_motion("飛行")
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, 1050.0, pos_z)
	while true do
		value = monster.get_variable(8) or value
		if value == 8 then
			return 0
		end
		if value == 9 then
			return 1
		end
		vm.wait()
	end
	return 0
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Configures the butterfly's attributes and body.
function script.init()
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(32, 1)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_clip_distance(9999.9)
	monster.set_monster_attributes(4, 1)
	monster.register_entry_object(0, "bcol00")
	monster.set_body(0, 6.0)
	behavior_state = 1
end

--- Runs the butterfly's state machine over flying to its slot, attacking and dashing.
function script.loop()
	while true do
		if behavior_state == 1 then
			wait_for_flock_start()
			behavior_state = 2
			monster.set_life(1.0)
		end
		if behavior_state == 2 then
			behavior_state = fly_to_formation_slot()
		end
		if behavior_state == 3 then
			behavior_state = launch_sticky_attack()
		end
		if behavior_state == 6 then
			behavior_state = hover_until_threatened()
		end
		if behavior_state == 5 then
			behavior_state = dash_to_free_slot()
		end
		if behavior_state == 0 then
			return
		end
		monster.get_monster_kind()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores staggering hits.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores knockdown hits.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores guarding.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the first dodge.
function script.on_dodge_1() end

--- Dashes to a free slot when the butterfly dodges.
function script.on_dodge_2()
	behavior_state = dash_to_free_slot()
end

--- Advances the flock's defeat counter and either revives the butterfly or ends the fight after the last one.
function script.on_death()
	local monster_id: s32 = 0
	local slot_index: s32 = 0
	local value: s32 = 0
	local revive_result: s32 = 0
	local value_2: s32 = 0
	monster.set_motion("飛行")
	monster.set_scene_character_status(32, 0)
	monster_id = monster.get_monster_kind() or monster_id
	slot_index = vm.i32(monster_id - 501)
	value = monster.get_variable(8) or value
	if value == slot_index then
		monster.call_command(20, 1) -- retail: command 20 is not registered
		monster.set_variable(8, vm.i32(value + 1))
		if slot_index == 7 then
			monster.request_event_script(501)
			monster.set_camera_mode(0)
			while true do
				vm.wait()
			end
		else
			set_slot_state(vm.i32(monster_id - 501), 0)
			rise_after_defeat()
			revive_result = wait_for_revival()
			if revive_result == 1 then
				monster.set_life(1.0)
				behavior_state = 3
			else
				while true do
					vm.wait()
				end
			end
		end
	else
		monster.call_command(20, 5) -- retail: command 20 is not registered
		monster.set_variable(8, 9)
		value_2 = monster.get_variable(18) or value_2
		if value_2 == 3 then
			monster.set_variable(18, 4)
			monster.request_event_script(505)
			vm.wait()
		end
		if value_2 == 2 then
			monster.set_variable(18, 3)
			monster.request_event_script(504)
			vm.wait()
		end
		behavior_state = 3
	end
end

--- Holds the butterfly still while it is caught.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Waits for the butterfly to touch the ground after a throw and then resets its movement.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.get_height_above_ground() or height
		if height < vm.f32(0.1) then
			timer.wait_frames(3)
			monster.end_throw()
			monster.stop_moving()
			timer.wait_frames(30)
			return 1
		end
		vm.wait()
	end
end

return script
