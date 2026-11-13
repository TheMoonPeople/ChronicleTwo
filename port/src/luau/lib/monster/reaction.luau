--!strict
--- Damage, stun and guard helpers for monster scripts.

local vm = require("@lib/vm")
local calc = vm.module("@lib/monster/calc")
local motion = vm.module("@lib/monster/motion")
local movement = vm.module("@lib/monster/movement")
local sense = vm.module("@lib/monster/sense")
local state = vm.module("@lib/monster/state")
local timer = vm.module("@lib/monster/timer")

local reaction = {}

--- Sets the mask flags, resets the motion, stops turning, waits one frame, turns the flying attributes off and sets the action status to 1.
function reaction.begin_knockdown()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	movement.stop_turning()
	timer.wait_one_frame()
	state.set_flying_attributes(0)
	monster.set_action_status(1)
end

--- Sets the mask flags, resets the motion, stops the monster, faces it toward the target, waits one frame with reaction checks and sets the action status to 1.
function reaction.begin_knockdown_facing_target()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	timer.wait_frame_with_reaction()
	monster.set_action_status(1)
end

--- Sets the mask flags, resets the motion, stops turning, waits one frame with reaction checks, turns the flying attributes off and sets the action status to 1.
function reaction.begin_knockdown_with_reaction()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	movement.stop_turning()
	reaction.update_and_wait_frame()
	state.set_flying_attributes(0)
	monster.set_action_status(1)
end

--- Clears attribute 32, sets the mask flags, turns the flying attributes off, stops the monster and resets its motion.
function reaction.begin_stun()
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	state.set_flying_attributes(0)
	monster.stop_moving()
	movement.stop_turning()
	monster.reset_motion()
end

--- Compares the monster's life with the value stored last time, stores the new life and returns 1 when dead, 2 when damaged and 0 otherwise.
function reaction.check_damage_taken()
	local life: s32 = 0
	local previous_life: s32 = 0
	previous_life = monster.get_secondary_variable(4) or previous_life
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_secondary_variable(4, life)
		return 1
	end
	if vm.i32(life - previous_life) < 0 then
		monster.set_secondary_variable(4, life)
		reaction.record_last_hit(life, previous_life)
		return 2
	end
	monster.set_secondary_variable(4, life)
	return 0
end

--- Steps backward 100 units at speed 3.4 while the monster's attribute 32 is set.
function reaction.dodge_backward_fast()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local yaw: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	yaw = vm.f32(yaw + vm.f32(3.1415927))
	x = vm.f32(x + vm.f32(100.0 * vm.sin(yaw)))
	z = vm.f32(z + vm.f32(100.0 * vm.cos(yaw)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	monster.move_toward_position(x, y, z, 3.4, 3.4)
	timer.wait_frames_with_guard_update(calc.pass_through(5))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Steps backward 100 units at speed 3.2 while the monster's attribute 32 is set.
function reaction.dodge_backward_slow()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local yaw: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	yaw = vm.f32(yaw + vm.f32(3.1415927))
	x = vm.f32(x + vm.f32(100.0 * vm.sin(yaw)))
	z = vm.f32(z + vm.f32(100.0 * vm.cos(yaw)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	monster.move_toward_position(x, y, z, 3.2, 3.2)
	timer.wait_frames_with_guard_update(calc.pass_through(5))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Steps 100 units to a random side at speed 3.84 while the monster's attribute 32 is set.
function reaction.dodge_sideways()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local yaw: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local step_length: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 6)
		yaw = vm.f32(yaw + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		yaw = vm.f32(yaw - vm.f32(1.5707964))
	end
	step_length = 100.0
	target_x = vm.f32(x + vm.f32(vm.sin(yaw) * step_length))
	target_y = vm.f32(y - 20.0)
	target_z = vm.f32(z + vm.f32(vm.cos(yaw) * step_length))
	sense.wait_until_target_in_front(40.0, 45.0, calc.pass_through(6))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target_x, target_y, target_z, 3.8400002, 3.8400002)
	sense.wait_until_target_in_front(40.0, 45.0, calc.pass_through(4))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Turns the flying attributes on, lifts the monster above the ground, clears its mask flags and sets the action status to 0.
function reaction.end_knockdown()
	state.set_flying_attributes(1)
	movement.lift_above_ground()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
end

--- Clears attribute 32, stops the monster, ends the throw, waits 10 frames, turns the flying attributes on and resets the motion.
function reaction.end_throw_and_resume_flying()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_counted(10)
	state.set_flying_attributes(1)
	monster.reset_motion()
end

--- Clears attribute 32, stops the monster, ends the throw, waits 10 frames with reaction checks and resets the motion.
function reaction.end_throw_with_reaction()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_reaction(10)
	monster.reset_motion()
end

--- Keeps the monster facing the target until the player's transformation ends.
function reaction.face_target_while_transformed(monster_kind: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", 0.45, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Moves the monster to a floating height, then keeps facing the target until the player's transformation ends.
function reaction.face_target_while_transformed_floating(monster_kind: any)
	local position_x: f32 = 0
	local position_z: f32 = 0
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	movement.move_toward_position(position_x, 25.0, position_z, 0.875, 10.0, 5.0, 150)
	while true do
		timer.wait_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(90.0) == 0 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Returns the damage amount above which the monster starts guarding.
function reaction.get_guard_damage_threshold(result: s32)
	local threshold: s32 = 0
	threshold = monster.get_secondary_variable(10) or threshold
	result = threshold
	return result
end

--- Returns how many frames the monster guards for.
function reaction.get_guard_duration(result: s32)
	local duration: s32 = 0
	duration = monster.get_secondary_variable(11) or duration
	result = duration
	return result
end

--- Returns the frames the monster has been guarding.
function reaction.get_guard_elapsed(result: s32)
	local elapsed: s32 = 0
	elapsed = monster.get_secondary_variable(12) or elapsed
	result = elapsed
	return result
end

--- Returns the type and amount of the last hit taken.
function reaction.get_last_hit(attack_type: s32, damage: s32)
	local last_attack_type: s32 = 0
	local last_damage: s32 = 0
	last_attack_type = monster.get_secondary_variable(6) or last_attack_type
	last_damage = monster.get_secondary_variable(7) or last_damage
	attack_type = last_attack_type
	damage = last_damage
	return attack_type, damage
end

--- Returns whether the monster is currently guarding.
function reaction.is_guard_active()
	local active: s32 = 0
	active = monster.get_secondary_variable(5) or active
	return active
end

--- Stores the type and amount of the last hit taken.
function reaction.record_last_hit(current_life: s32, previous_life: s32)
	local attack_type: s32 = 0
	attack_type = monster.get_last_attack_type() or attack_type
	monster.set_secondary_variable(6, attack_type)
	monster.set_secondary_variable(7, vm.i32(previous_life - current_life))
end

--- Stops movement, ends the throw state and restores normal attributes and motion.
function reaction.recover_after_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_updating_lighting(10)
	state.set_flying_attributes(1)
	monster.reset_motion()
end

--- Clears attribute bit 32, stops moving, ends the throw, waits ten frames and resets the motion.
function reaction.recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
	monster.reset_motion()
end

--- Sets whether the monster is guarding and restores normal escape and guard rates when it stops.
function reaction.set_guard_active(active: s32)
	monster.set_secondary_variable(5, active)
	if active == 0 then
		monster.set_monster_escape_rate(-1, 1.0)
		monster.set_monster_guard_rate(-1, 1.0)
	end
end

--- Stores the damage amount above which the monster starts guarding.
function reaction.set_guard_damage_threshold(threshold: s32)
	monster.set_secondary_variable(10, threshold)
end

--- Stores the frames the monster has been guarding.
function reaction.set_guard_elapsed(elapsed: s32)
	monster.set_secondary_variable(12, elapsed)
end

--- Plays the stun motion, waits for the stun to end and unlocks the monster's masks.
function reaction.stun_until_recovered()
	monster.set_motion("気絶", -1)
	reaction.wait_for_stun_end()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Plays the stun, waits for it to end and unlocks the masks for monsters using the alternative command set.
function reaction.stun_until_recovered_variant()
	monster.set_life("気絶", -1)
	reaction.wait_for_stun_end_variant()
	monster.call_command(119, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 0) -- retail: the handler rejects 2 arguments
end

--- Plays the stun motion until the stun stars vanish, then turns the flying attributes on, lifts the monster above the ground and clears its mask flags.
function reaction.stun_until_stars_fade()
	monster.set_motion("気絶", -1)
	reaction.wait_for_stun_end()
	state.set_flying_attributes(1)
	movement.lift_above_ground()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Advances the guard timer and returns 1 when it has run out.
function reaction.tick_guard_timer()
	local duration: s32 = 0
	local elapsed: s32 = 0
	duration = reaction.get_guard_duration(duration)
	if duration <= 0 then
		return 0
	end
	elapsed = reaction.get_guard_elapsed(elapsed)
	if elapsed < duration then
		reaction.set_guard_elapsed(elapsed + 1)
		return 0
	end
	reaction.set_guard_elapsed(0)
	return 1
end

--- Updates the guard state and waits one frame.
function reaction.update_and_wait_frame()
	reaction.update_guard_state()
	if reaction.is_guard_active() ~= 0 then
		if reaction.tick_guard_timer() ~= 0 then
			reaction.set_guard_active(0)
		end
	end
	vm.wait()
end

--- Starts guarding when the monster takes a hit larger than its guard damage threshold.
function reaction.update_guard_state()
	local damage_result: s32 = 0
	local attack_type: s32 = 0
	local damage: s32 = 0
	local threshold: s32 = 0
	damage_result = reaction.check_damage_taken()
	if damage_result == 2 then
		attack_type, damage = reaction.get_last_hit(attack_type, damage)
		threshold = reaction.get_guard_damage_threshold(threshold)
		if reaction.is_guard_active() == 0 and damage > threshold then
			print("dmg=", damage, "------------------\n")
			monster.set_secondary_variable(5, 1)
		end
	end
end

--- Shows the stun stars and waits until their timer runs out.
function reaction.wait_for_stun_end()
	local stun_time: s32 = 0
	monster.show_stun_stars()
	stun_time = monster.get_stun_stars_time() or stun_time
	while stun_time > 0 do
		stun_time = monster.get_stun_stars_time() or stun_time
		vm.wait()
	end
end

--- Shows the stun stars and waits until their timer runs out for monsters using the alternative command set.
function reaction.wait_for_stun_end_variant()
	local stun_time: s32 = 0
	monster.call_command(127) -- retail: the handler rejects 0 arguments
	monster.set_scene_character_status(stun_time) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	while stun_time > 0 do
		monster.set_scene_character_status(stun_time) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		vm.wait()
	end
end

--- When the player is transformed, keeps the monster facing the target until the transformation ends.
function reaction.watch_transformation()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		reaction.face_target_while_transformed(monster_kind)
	end
end

--- When the player is transformed, floats the monster and keeps it facing the target until the transformation ends.
function reaction.watch_transformation_floating()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		reaction.face_target_while_transformed_floating(monster_kind)
	end
end

--- When the player is transformed, walks to keep the monster facing the target until the transformation ends.
function reaction.watch_transformation_walking()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		movement.wander_while_player_transformed(monster_kind)
	end
end

return reaction
