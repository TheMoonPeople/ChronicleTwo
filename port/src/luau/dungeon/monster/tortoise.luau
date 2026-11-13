--!strict
--- Drives the tortoise monsters (Tortoise, Sea, Star and Ebony Tortoise).

local vm = require("@lib/vm")
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

--- Keeps facing the target while the player stays transformed.
local function face_transformed_player(monster_kind: any)
	local character_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		character_id = monster.get_player_transform_id() or character_id
		if character_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(0.75)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts facing the target if the player is currently transformed.
local function face_player_if_transformed()
	local character_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	character_id = monster.get_player_transform_id() or character_id
	if character_id > -1 then
		face_transformed_player(monster_kind)
	end
end

--- Builds a bit mask describing the target's range and facing.
local function classify_situation()
	local situation_flags: s32 = 0
	local target_distance: f32 = 0
	local is_facing_target: s32 = 0
	situation_flags = 0
	is_facing_target = sense.is_facing_target_degrees(0, 200.0)
	if is_facing_target == 1 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 4))
	end
	if is_facing_target == 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 8))
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 240.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 1))
	end
	if target_distance > 240.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 2))
	end
	if sense.is_facing_target_degrees(0, 45.0) ~= 0 and target_distance <= 50.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 16))
	end
	return situation_flags
end

--- Plays the near or far attack depending on the target distance and waits for it to finish.
local function bite_target()
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 30.0 then
		monster.reset_motion()
		monster.set_motion("攻撃１", -1, 6)
	else
		monster.reset_motion()
		monster.set_motion("攻撃２", -1, 6)
	end
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	timer.wait_frames_with_guard_update(3)
end

--- Spins left or right on the spot until it faces the target.
local function turn_toward_target_in_place()
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	while true do
		if sense.is_facing_target_degrees(90, 180) ~= 0 then
			monster.set_motion("回転右")
		else
			monster.set_motion("回転左")
		end
		movement.turn_toward_target(vm.f32(0.02617994))
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		target_angle = monster.get_target_angle() or target_angle
		if calc.compare_angles(target_angle, rotation_y, vm.f32(0.02617994)) == 0 then
			movement.stop_turning()
			break
		else
			reaction.update_and_wait_frame()
		end
	end
end

--- Walks toward the target until close, and returns whether the target was lost.
local function approach_target()
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	while true do
		if sense.is_facing_target_degrees(0, 200.0) == 0 then
			return 1
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 50.0 then
			movement.stop_turning()
			monster.stop_moving()
			return 0
		end
		if target_distance > 240.0 then
			movement.stop_turning()
			monster.stop_moving()
			return 1
		end
		monster.set_motion("歩き")
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		movement.turn_toward_target(vm.f32(0.01308997))
		monster.move_toward_position(position_x, position_y, position_z, 0.4, 1.0)
		reaction.update_and_wait_frame()
	end
	return 0
end

--- Picks a reaction (attack, turn or approach) from the situation mask.
local function react_to_situation(situation_flags: s32)
	local roll: s32 = 0
	face_player_if_transformed()
	if bit32.band(situation_flags, 16) ~= 0 then
		bite_target()
		return
	end
	if bit32.band(situation_flags, 2) ~= 0 then
		if sense.is_facing_target_degrees(0, 45.0) == 0 then
			roll = monster.get_random(100) or roll
			if roll < 2 then
				turn_toward_target_in_place()
			end
		end
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 8) else 0) ~= 0 then
		turn_toward_target_in_place()
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 4) else 0) ~= 0 then
		if approach_target() ~= 0 then
			return
		else
			turn_toward_target_in_place()
		end
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
		movement.turn_to_angle_and_wait(turn_angle, 0.75)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(0.75, vm.f32(0.4), turn_angle, clear_distance, 30.0, 30)
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
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(0.4), 0.75, place_distance, orbit_start_angle, 30.0, 60)
				orbit_end_turn_angle = monster.get_random_whole_number(180.0) or orbit_end_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					orbit_end_turn_angle = vm.f32(orbit_end_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(orbit_end_turn_angle, 0.75)
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
			movement.turn_to_angle_and_wait(turn_angle, 0.75)
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
					threat_result = movement.walk_to_point_near_target(vm.f32(0.4), 0.75, approach_angle, approach_distance, 30.0, 60)
					final_turn_angle = monster.get_random_whole_number(360.0) or final_turn_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_angle = vm.f32(final_turn_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_angle, 0.75)
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
					movement.move_in_direction_guarded(vm.f32(0.4), turn_angle, 1000.0, 30.0, 60)
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
			movement.wander(vm.f32(0.4), 0.75, place_distance, 360.0, 40.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks after the target with its shell guard up and then stands.
local function chase_target_while_guarding()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(vm.f32(0.4), 1.0, 30.0, 90)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(60)
end

--- Chooses between engaging the target, wandering and releasing the guard each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_release_distance: f32 = 0
	local situation_flags: s32 = 0
	local situation_flags_after_guard: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		face_player_if_transformed()
		if target_distance < 100.0 then
			monster.set_motion("立ち")
			situation_flags = classify_situation()
			react_to_situation(situation_flags)
		else
			wander_near_spawn()
		end
	else
		guard_release_distance = state.get_secondary_float(guard_release_distance)
		if target_distance < guard_release_distance then
			if target_distance < 75.0 then
				monster.set_monster_guard_rate(-1, 1.0)
				reaction.set_guard_active(0)
				monster.set_motion("立ち")
				situation_flags_after_guard = classify_situation()
				react_to_situation(situation_flags_after_guard)
			else
				monster.set_monster_guard_rate(-1, 4.0)
				chase_target_while_guarding()
			end
		else
			monster.set_monster_guard_rate(-1, 1.0)
			reaction.set_guard_active(0)
		end
	end
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Registers the tortoise's hit reactions and sets its guard and clip distances.
function script.init()
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.554, 0.677, 0)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃２", 0.343, 0.486, 0)
	state.set_secondary_flag(300)
	configure_guard_and_clip_distance()
end

--- Updates the tortoise's behaviour every frame.
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

--- Either turns and counter attacks or staggers back from a hit.
function script.on_damage()
	local roll: s32 = 0
	state.stop_and_clear_action()
	roll = monster.get_random(100) or roll
	if roll < 35 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(calc.radians_to_degrees(vm.f32(0.01308997)) * 1.5))
		monster.reset_motion()
		monster.set_motion("攻撃１", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("立ち", -1, 4)
		timer.wait_frames_with_guard_update(3)
	else
		monster.stop_moving()
		movement.stop_turning()
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		timer.wait_frames_with_guard_update(16)
	end
	state.do_nothing()
end

--- Either turns and counter attacks or staggers back after a heavy hit.
function script.on_knockdown()
	local roll: s32 = 0
	state.lock_and_face_target_guarded()
	roll = monster.get_random(100) or roll
	if roll < 40 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(calc.radians_to_degrees(vm.f32(0.01308997)) * 1.5))
		monster.reset_motion()
		monster.set_motion("攻撃２", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("立ち", -1, 4)
		timer.wait_frames_with_guard_update(3)
	else
		monster.stop_moving()
		movement.stop_turning()
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		motion.wait_until_finished_guarded()
		timer.wait_frames_with_guard_update(16)
	end
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

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default dodge.
function script.on_dodge_2() end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default hold reaction.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default landing.
function script.on_land() end

--- Staggers and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(8)
	reaction.stun_until_recovered()
end

return script
