--!strict
--- Drives the Statue family: a sword-wielding guardian that fights by distance and rushes the target.

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

--- Sets the guard threshold, secondary parameters and clip distance shared by this monster's variants.
local function set_default_parameters()
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

--- Hovers near the target at a random offset or waits for it to face the monster while another monster holds the attack priority.
local function wait_for_turn()
	local roll: s32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_angle = monster.get_random_whole_number(30.0) or offset_angle
		offset_distance = monster.get_random_whole_number(30.0) or offset_distance
		offset_distance = vm.f32(offset_distance + 95.0)
		if roll < 50 then
			offset_angle = vm.f32(-offset_angle - 30.0)
		else
			offset_angle = vm.f32(offset_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.3), vm.f32(2.8), offset_angle, offset_distance, 40.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(2.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(40.0, 45.0, 30)
	end
end

--- Picks a mid-range maneuver: waiting, turning, rushing forward or circling the target.
local function maneuver_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local side_angle: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 60.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			life = monster.get_life() or life
			if life < vm.f32(0.3) then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(vm.f32(1.3), vm.f32(5.6), 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(vm.f32(1.3), vm.f32(2.8), 40.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_angle = -30.0
			else
				side_angle = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.8))
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.3), vm.f32(2.8), side_angle, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(40.0, 45.0, 30)
		end
	end
end

--- Turns to the target and plays the first attack while tracking it.
local function perform_attack_1()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(5.6))
	monster.set_motion("攻撃１", -1, 2)
	movement.track_target_guarded(vm.f32(2.8), calc.pass_through(58))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Turns to the target and plays the wind-up and swing of the second attack.
local function perform_attack_2()
	monster.set_variable(0, 2)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(5.6))
	monster.set_motion("攻撃２in", -1, 6)
	motion.wait_until_finished_facing_target_guarded(vm.f32(2.8))
	monster.set_motion("攻撃２", -1, 6)
	movement.track_target_guarded(vm.f32(2.8), 15)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a close-range action: one of the attacks, a rush forward or a flanking walk.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.get_life()
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 65 then
		if target_distance < 50.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				perform_attack_1()
			else
				perform_attack_2()
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(vm.f32(1.3), vm.f32(5.6), 40.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(vm.f32(1.3), vm.f32(5.6), 40.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(vm.f32(1.3), vm.f32(2.8), side_angle, 80.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Fights the target by distance until it leaves range or the rage counter runs out.
local function fight_target_cautiously()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_slow()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 225.0 then
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
			wait_for_turn()
			continue
		end
		if target_distance < 225.0 and target_distance >= 145.0 then
			behavior.read_distance_and_roll()
		elseif target_distance < 145.0 and target_distance >= 95.0 then
			maneuver_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Roams around the placement position by circling it, wandering or waiting for the target to threaten.
local function roam()
	local roll: s32 = 0
	local result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local circle_angle: f32 = 0
	local turn_after_walk: f32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local turn_after_approach: f32 = 0
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
	distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 40.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, vm.f32(2.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 40.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(2.8), vm.f32(1.2), turn_angle, clear_distance, 40.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 250.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 550.0 then
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
				circle_angle = monster.get_random_whole_number(360.0) or circle_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					circle_angle = vm.f32(-circle_angle - 30.0)
				else
					circle_angle = vm.f32(circle_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.2), vm.f32(2.8), distance, circle_angle, 40.0, 60)
				turn_after_walk = monster.get_random_whole_number(180.0) or turn_after_walk
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_after_walk = vm.f32(turn_after_walk * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_after_walk, vm.f32(2.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_guarded(100.0, 60.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 93 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 60.0, 35.0, vm.f32(1.2), 30)
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
					offset_angle = monster.get_random_whole_number(180.0) or offset_angle
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if roll < 50 then
						offset_angle = vm.f32(offset_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_angle = vm.f32(-offset_angle - 30.0)
					else
						offset_angle = vm.f32(offset_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = movement.walk_to_point_near_target(vm.f32(1.2), vm.f32(2.8), offset_angle, offset_distance, 40.0, 60)
					turn_after_approach = monster.get_random_whole_number(360.0) or turn_after_approach
					roll = monster.get_random(100) or roll
					if roll < 50 then
						turn_after_approach = vm.f32(turn_after_approach * -1.0)
					end
					movement.turn_to_angle_and_wait(turn_after_approach, vm.f32(2.8))
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
					movement.move_in_direction_guarded(vm.f32(1.2), turn_angle, 1000.0, 40.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_guarded(100.0, 60.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.2), vm.f32(2.8), distance, 360.0, 40.0, 40.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks after the target for a while.
local function chase_target()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(vm.f32(1.3), vm.f32(2.8), 40.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target aggressively once the rage counter has run out.
local function fight_target_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 225.0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wait_for_turn()
			continue
		end
		if target_distance < 95.0 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				if target_distance < 75.0 then
					perform_attack_1()
				else
					perform_attack_2()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(vm.f32(1.3), vm.f32(5.6), 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 65 then
				perform_attack_2()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward_guarded(vm.f32(1.3), vm.f32(2.8), 40.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward_guarded(vm.f32(1.3), vm.f32(5.6), 40.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

--- Chooses between fighting, roaming and chasing from the target distance, the guard state and the rage counter.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_slow()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 225.0 then
				fight_target_cautiously()
			else
				roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 95.0 then
					monster.set_monster_guard_rate(-1, 1.0)
					reaction.set_guard_active(0)
					fight_target_cautiously()
				else
					monster.set_monster_guard_rate(-1, 30.0)
					chase_target()
				end
			else
				monster.set_monster_guard_rate(-1, 1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		fight_target_enraged()
	end
end

local script = {}

--- Runs once when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hits and applies its default parameters when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.397, 0.466, 0, 1)
	monster.register_damage_hit("吹っ飛び弱", 3.0, "攻撃２", 0.15, 0.286, 0, 1)
	monster.add_sword_trail(0, "攻撃１", 0.362, 0.366, "dcol0", "dcol1", 45, 10, 45)
	monster.add_sword_trail(0, "攻撃２", 0.19, 0.196, "dcol0", "dcol1", 45, 10, 45)
	monster.set_variable(0, 0)
	set_default_parameters()
end

--- Runs the monster's main behaviour loop.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Holds the monster in its damage pose until its status ailment ends.
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

--- Staggers the monster back and recovers when it takes a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster down, then lets it get back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("起き上がり")
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	state.unlock_and_clear_action()
end

--- Plays the guard motions when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Locks the monster and releases it again without dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Locks the monster and releases it again without dodging.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the monster's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster stays inert while held.
function script.on_caught() end

--- Recovers from the throw and resumes normal behaviour.
function script.on_land()
	reaction.recover_from_throw()
	state.do_nothing_hook()
	return 1
end

--- Knocks the monster over and holds it until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
