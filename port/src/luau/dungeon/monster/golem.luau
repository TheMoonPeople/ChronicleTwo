--!strict
--- Drives the Golem, Rave Golem, Rock Taster and Titan monsters, which swing their arms and slam shockwaves.

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

--- Sets the guard threshold, secondary variables and clip distance shared by the whole family.
local function initialize_defaults()
	local boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Turns toward the target and plays the idle play motion until it is in front.
local function play_idle_animation()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("遊び", -1, 2)
	sense.wait_until_target_in_front(66.0, 45.0, calc.pass_through(133))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(6)
end

--- Sidesteps around the target or waits for it to face the monster while the monster is not allowed to attack.
local function strafe_while_waiting()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	local strafe_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			strafe_degrees = monster.get_random_whole_number(30.0) or strafe_degrees
			strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
			strafe_distance = vm.f32(strafe_distance + 150.0)
			if roll < 50 then
				strafe_degrees = vm.f32(-strafe_degrees - 30.0)
			else
				strafe_degrees = vm.f32(strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(1.25, 3.0, strafe_degrees, strafe_distance, 66.0, 90)
			movement.turn_toward_target_and_wait_guarded(3.0)
		else
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(30)
		end
	else
		play_idle_animation()
	end
end

--- Chases the target or stands still for a moment.
local function approach_or_wait()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.25, 3.0, 66.0, 150)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(30)
	end
end

--- Chases the target or plays the idle motion.
local function approach_or_play()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 90 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.25, 3.0, 66.0, 120)
		monster.set_motion("立ち", -1, 0)
	else
		play_idle_animation()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(6)
	end
end

--- Walks up to the target and swings its arm.
local function melee_attack()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.25, 3.0, 66.0, 90)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(6)
end

--- Walks up to the target and slams both fists, spawning a shockwave at each.
local function slam_shockwave_attack()
	local attack: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.25, 3.0, 66.0, 90)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_progress(vm.f32(0.64), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, position_x, position_y - 38.0, position_z)
	monster.set_effect_value(-1, 0, attack)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, position_x, position_y - 38.0, position_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(6)
end

--- Picks a close-range action: arm swing, slam or chase.
local function act_at_close_range()
	local roll: s32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			melee_attack()
		else
			slam_shockwave_attack()
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.25, 3.0, 66.0, 60)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Fights the target while rage hits remain and the target stays within range.
local function fight_normal_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 330.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_while_waiting()
			continue
		end
		if target_distance < 330.0 and target_distance >= 230.0 then
			approach_or_wait()
		elseif target_distance < 230.0 and target_distance >= 150.0 then
			approach_or_play()
		else
			act_at_close_range()
		end
	end
end

--- Wanders around the spawn point and waits for the target to approach while no target is in range.
local function roam_around_home()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local home_distance: f32 = 0
	local turn_degrees: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_radians: f32 = 0
	local clear_distance: f32 = 0
	local circle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local offset_degrees: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
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
	home_distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 66.0 then
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 66.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.8), 1.25, turn_degrees, clear_distance, 66.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if home_distance > 800.0 then
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
				circle_degrees = monster.get_random_whole_number(360.0) or circle_degrees
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					circle_degrees = vm.f32(-circle_degrees - 30.0)
				else
					circle_degrees = vm.f32(circle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, 1.25, vm.f32(4.8), home_distance, circle_degrees, 66.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_degrees = vm.f32(turn_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.8))
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
					offset_degrees = monster.get_random_whole_number(180.0) or offset_degrees
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if roll < 50 then
						offset_degrees = vm.f32(offset_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_degrees = vm.f32(-offset_degrees - 30.0)
					else
						offset_degrees = vm.f32(offset_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(1.25, vm.f32(4.8), offset_degrees, offset_distance, 66.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_radians = out2 or facing_radians
					end
					turn_degrees = calc.radians_to_degrees(facing_radians)
					if turn_degrees > vm.f32(3.1415927) then
						turn_degrees = vm.f32(turn_degrees - vm.f32(6.2831855))
					end
					if turn_degrees <= vm.f32(-3.1415927) then
						turn_degrees = vm.f32(turn_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.25, turn_degrees, 1000.0, 66.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.25, vm.f32(4.8), home_distance, 360.0, 40.0, 66.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks toward the target.
local function advance_on_target()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.25, 3.0, 66.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Attacks up close or advances once no rage hits remain, with raised defense.
local function fight_enraged_phase()
	local target_distance: f32 = 0
	local roll: s32 = 0
	monster.get_life()
	target_distance = monster.get_target_distance() or target_distance
	monster.set_defense_rate(1.2)
	if target_distance < 150.0 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			melee_attack()
		else
			slam_shockwave_attack()
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.5, 3.0, 66.0, 120)
	end
end

--- Chooses between roaming, guarding and the normal or enraged fighting phase based on the target distance and remaining rage hits.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			monster.set_defense_rate(1.0)
			if target_distance < 330.0 then
				fight_normal_phase()
			else
				roam_around_home()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 230.0 then
					monster.set_defense_rate(1.0)
					monster.set_monster_guard_rate(-1, 1.0)
					reaction.set_guard_active(0)
					fight_normal_phase()
				else
					monster.set_defense_rate(3.0)
					monster.set_monster_guard_rate(-1, 10.0)
					advance_on_target()
				end
			else
				monster.set_defense_rate(1.0)
				monster.set_monster_guard_rate(-1, 1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		monster.set_defense_rate(1.5)
		fight_enraged_phase()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit boxes, loads the shockwave effect and applies the default settings.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 6.5, "攻撃１", 0.3, 0.37, 0)
	monster.register_damage_hit("吹っ飛び中", 6.5, "攻撃１", 0.5, 0.6, 2)
	monster.load_effect_script("ヴァンガード衝撃波")
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃２", 0.227, 0.533, 1009)
	end
	initialize_defaults()
end

--- Repeats the behavior update every frame.
function script.loop()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Stops the current action and plays the damage motion until the status ailment wears off.
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

--- Plays the flinch motion with a short knockback.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster is never knocked down.
function script.on_knockdown() end

--- Plays the guard motion and holds it for a short time.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガードin", 1.0, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Raises its guard instead of dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Raises its guard instead of dodging.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster cannot be caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster ignores landing.
function script.on_land() end

--- Plays the damage motion briefly, then stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 4)
	timer.wait_frames_with_guard_update(3)
	reaction.stun_until_recovered()
end

return script
