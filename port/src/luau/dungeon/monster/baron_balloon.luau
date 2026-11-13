--!strict
--- Drives the balloon monsters (Baron, Count and Duke Balloon).

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard thresholds and the draw clip distance, unlimited for bosses.
local function configure_guard_and_clip_distance()
	local is_boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	is_boss = monster.is_boss() or is_boss
	if is_boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Builds a bit mask describing the target's range, facing and the monster's rage state.
local function classify_situation()
	local situation_flags: s32 = 0
	local target_distance: f32 = 0
	local is_facing_target: s32 = 0
	local monster_priority: s32 = 0
	local rage_hits_left: s32 = 0
	situation_flags = 0
	is_facing_target = sense.is_facing_target_with_offset(0, 180.0)
	if is_facing_target == 1 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 4))
	end
	if is_facing_target == 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 8))
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 320.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 1))
	end
	if target_distance > 320.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 2))
		monster.set_variable(0, 0)
	end
	if sense.is_facing_target_with_offset(0, 60.0) ~= 0 and target_distance <= 40.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 16))
	end
	monster_priority = monster.get_priority() or monster_priority
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if monster_priority <= 3 or rage_hits_left == 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 32))
	end
	return situation_flags
end

--- Plays the close or far swing depending on the target distance and waits for it to finish.
local function attack_nearby_target()
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 30.0 then
		monster.set_motion("攻撃１", -1, 2)
	else
		monster.set_motion("攻撃２", -1, 2)
	end
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(15)
end

--- Walks slowly toward the target until it is in range or a random time runs out.
local function advance_slowly_until_in_range()
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	roll = monster.get_random(90) or roll
	roll = vm.i32(roll + 150)
	while true do
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.face_target_if_transformed_slow()
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 320.0 then
			break
		else
			monster.set_motion("歩き")
			do
				local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			movement.turn_toward_target(vm.f32(0.024543693))
			monster.move_toward_position(position_x, position_y, position_z, 0.9, 1.0)
			roll = vm.i32(roll - 1)
			if roll < 0 then
				break
			else
				reaction.update_and_wait_frame()
			end
		end
	end
end

--- Waits for a number of frames or until the target comes within range.
local function wait_until_target_in_range(timeout_frames: any)
	local target_distance: f32 = 0
	while true do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 320.0 then
			break
		else
			timeout_frames = vm.wrap(timeout_frames - 1)
			if timeout_frames < 0 then
				break
			else
				reaction.update_and_wait_frame()
			end
		end
	end
end

--- Turns on the spot until it faces the target.
local function turn_toward_target_in_place()
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("歩き")
	while true do
		movement.turn_toward_target(vm.f32(0.049087387))
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		target_angle = monster.get_target_angle() or target_angle
		if calc.compare_angles(target_angle, rotation_y, vm.f32(0.049087387)) == 0 then
			movement.stop_turning()
			break
		else
			reaction.update_and_wait_frame()
		end
	end
end

--- Runs at the target until it is close enough to attack, and returns whether the chase was given up.
local function chase_target_until_close(situation_flags: s32)
	local target_distance: f32 = 0
	local variable_0: s32 = 0
	local lunge_chance: s32 = 0
	local roll: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	while true do
		if sense.is_facing_target_with_offset(0, 180.0) == 0 then
			return 1
		end
		target_distance = monster.get_target_distance() or target_distance
		if bit32.band(situation_flags, 32) ~= 0 then
			if target_distance <= 40.0 then
				return 0
			end
		elseif target_distance <= 160.0 then
			return 0
		end
		variable_0 = monster.get_variable(0) or variable_0
		if variable_0 == 0 then
			lunge_chance = 100
		else
			lunge_chance = 1
		end
		roll = monster.get_random(100) or roll
		if (if roll < lunge_chance and target_distance < 120.0 then sense.is_facing_target_with_offset(0, 60.0) else 0) ~= 0 then
			monster.set_variable(0, 1)
			monster.set_variable(1, 1)
			return 0
		end
		if target_distance > 320.0 then
			return 1
		end
		monster.set_motion("走り")
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		movement.turn_toward_target(vm.f32(0.049087387))
		monster.move_toward_position(position_x, position_y, position_z, 1.8, 1.0)
		reaction.update_and_wait_frame()
	end
	return 0
end

--- Picks a reaction (attack, wait, turn or chase) from the situation mask.
local function react_to_situation(situation_flags: s32)
	local roll: s32 = 0
	local second_roll: s32 = 0
	local variable_1: s32 = 0
	local target_distance: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local third_roll: s32 = 0
	if (if bit32.band(situation_flags, 16) ~= 0 then bit32.band(situation_flags, 32) else 0) ~= 0 then
		attack_nearby_target()
		return
	end
	if bit32.band(situation_flags, 2) ~= 0 then
		if sense.is_facing_target_with_offset(0, 60.0) ~= 0 then
			roll = monster.get_random(400) or roll
			if roll < 1 then
				advance_slowly_until_in_range()
				roll = monster.get_random(60) or roll
				roll = vm.i32(roll + 60)
				monster.set_motion("立ち")
				wait_until_target_in_range(roll)
			end
		else
			second_roll = monster.get_random(100) or second_roll
			if second_roll < 2 then
				turn_toward_target_in_place()
				second_roll = monster.get_random(60) or second_roll
				second_roll = vm.i32(second_roll + 60)
				monster.set_motion("立ち")
				wait_until_target_in_range(second_roll)
			end
		end
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 8) else 0) ~= 0 then
		turn_toward_target_in_place()
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 4) else 0) ~= 0 then
		if bit32.band(situation_flags, 32) ~= 0 then
			variable_1 = monster.get_variable(1) or variable_1
			if variable_1 == 1 then
				target_distance = monster.get_target_distance() or target_distance
				do
					local out1, out2, out3 = monster.get_target_position()
					target_x = out1 or target_x
					target_y = out2 or target_y
					target_z = out3 or target_z
				end
				monster.move_toward_position(target_x, target_y, target_z, target_distance / 12.0, target_distance / 12.0)
				monster.set_motion("攻撃１", -1, 2)
				movement.turn_toward_target(vm.f32(0.09817477))
				movement.wait_until_move_finished(18)
				motion.wait_until_finished_guarded()
				monster.set_motion("立ち")
				monster.set_variable(1, 0)
				return
			end
		end
		if chase_target_until_close(situation_flags) ~= 0 then
			return
		else
			turn_toward_target_in_place()
		end
		if bit32.band(situation_flags, 32) == 0 then
			third_roll = monster.get_random(100) or third_roll
			if third_roll < 2 then
				turn_toward_target_in_place()
			end
		end
		return
	end
end

--- Idles by wandering, orbiting the spawn point or watching for the target when it is not engaged.
local function wander_near_spawn()
	local roll: s32 = 0
	local threat_result: s32 = 0
	local unused_selector: s32 = 0
	local place_distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_start_angle: f32 = 0
	local orbit_end_turn_angle: f32 = 0
	local approach_angle: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_angle: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_position_x = out1 or place_position_x
		place_position_y = out2 or place_position_y
		place_position_z = out3 or place_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	place_distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or place_distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 30.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, vm.f32(2.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(2.8), vm.f32(1.8), turn_angle, clear_distance, 30.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if place_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if place_distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_start_angle = monster.get_random_whole_number(360.0) or orbit_start_angle
				place_distance = monster.get_random_whole_number(150.0) or place_distance
				if roll < 50 then
					orbit_start_angle = vm.f32(-orbit_start_angle - 30.0)
				else
					orbit_start_angle = vm.f32(orbit_start_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.8), vm.f32(2.8), place_distance, orbit_start_angle, 30.0, 60)
				orbit_end_turn_angle = monster.get_random_whole_number(180.0) or orbit_end_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					orbit_end_turn_angle = vm.f32(orbit_end_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(orbit_end_turn_angle, vm.f32(2.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle, vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_variable(0, 4)
					roll = monster.get_random(100) or roll
					approach_angle = monster.get_random_whole_number(180.0) or approach_angle
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_angle = vm.f32(approach_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_angle = vm.f32(-approach_angle - 30.0)
					else
						approach_angle = vm.f32(approach_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					threat_result = movement.walk_to_point_near_target(vm.f32(1.8), vm.f32(2.8), approach_angle, approach_distance, 30.0, 60)
					final_turn_angle = monster.get_random_whole_number(360.0) or final_turn_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_angle = vm.f32(final_turn_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_angle, vm.f32(2.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle = calc.radians_to_degrees(rotation_y)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.8), turn_angle, 1000.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
		elseif unused_selector == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			place_distance = monster.get_target_distance() or place_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.8), vm.f32(2.8), place_distance, 360.0, 40.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs after the target for a short while and then stands.
local function chase_target_at_run_speed()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(vm.f32(4.8), 4.0, 30.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between engaging the target, wandering and releasing the guard each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_release_distance: f32 = 0
	local rage_hits_left: s32 = 0
	local situation_flags: s32 = 0
	local situation_flags_after_guard: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_slow()
	end
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		if target_distance < 200.0 then
			monster.set_motion("立ち")
			situation_flags = classify_situation()
			react_to_situation(situation_flags)
		else
			wander_near_spawn()
		end
	else
		guard_release_distance = state.get_secondary_float(guard_release_distance)
		if target_distance < guard_release_distance then
			if target_distance < 200.0 then
				reaction.set_guard_active(0)
				monster.set_motion("立ち")
				situation_flags_after_guard = classify_situation()
				react_to_situation(situation_flags_after_guard)
			else
				chase_target_at_run_speed()
			end
		else
			reaction.set_guard_active(0)
		end
	end
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Registers the balloon's hit reactions and sets its guard and clip distances.
function script.init()
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃２", 0.2, 0.8, 0)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 1)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 2)
	configure_guard_and_clip_distance()
end

--- Updates the balloon's behaviour every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Plays the damage motion until the status ailments wear off.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back from a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Gets knocked down and stands back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_with_guard_update(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges backward and then counter attacks or recovers.
function script.on_dodge_1()
	local target_angle: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rage_hits_left: s32 = 0
	local counter_attack_chance: s32 = 0
	local roll: s32 = 0
	state.lock_and_reset_motion()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避け", -1, 2)
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	monster.set_invulnerable_time(6)
	timer.wait_frames_with_guard_update(6)
	do
		local out1, out2, out3 = monster.get_point_from_facing(3.1415927, 35.0)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.move_toward_position(position_x, position_y, position_z, 5.0, 5.0)
	motion.wait_until_finished_guarded()
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left == 0 then
		counter_attack_chance = 80
	else
		counter_attack_chance = 30
	end
	roll = monster.get_random(100) or roll
	if roll < counter_attack_chance then
		monster.set_motion("避け攻撃", -1, 6)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 30.0)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.move_toward_position(position_x, position_y, position_z, 5.0, 5.0)
		motion.wait_until_finished_guarded()
	else
		monster.set_motion("避け戻り", -1, 6)
		motion.wait_until_finished_guarded()
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Sidesteps left or right away from the attack.
function script.on_dodge_2()
	local target_angle: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local roll: s32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	reaction.update_and_wait_frame()
	roll = monster.get_random(100) or roll
	if roll > 50 then
		monster.set_motion("ダメージ左", -1, 2)
		do
			local out1, out2, out3 = monster.get_point_from_facing(1.5707964, 20)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.move_toward_position(position_x, position_y, position_z, 3.0, 5.0)
	else
		monster.set_motion("ダメージ右", -1, 2)
		do
			local out1, out2, out3 = monster.get_point_from_facing(-1.5707964, 20)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.move_toward_position(position_x, position_y, position_z, 3.0, 5.0)
	end
	movement.wait_until_move_finished(15)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	timer.wait_forever_guarded()
end

--- Stands up after being thrown.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Is knocked down and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
