--!strict
--- Drives the Corsair, Zombie Pirate, Ore Robber and Elite Corsair monsters, which lunge with swords.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
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

--- Sidesteps around the target or waits for it to face the monster while the monster is not allowed to attack.
local function strafe_while_waiting()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	local strafe_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		strafe_degrees = monster.get_random_whole_number(30.0) or strafe_degrees
		strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
		strafe_distance = vm.f32(strafe_distance + 75.0)
		if roll < 50 then
			strafe_degrees = vm.f32(-strafe_degrees - 30.0)
		else
			strafe_degrees = vm.f32(strafe_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(1.75, vm.f32(4.8), strafe_degrees, strafe_distance, 30.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(30.0, 45.0, 30)
	end
end

--- Runs at the target and lunges forward with the sword.
local function lunge_attack()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_radians: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(vm.f32(7.8), vm.f32(7.2000003), 30.0, 75)
	monster.move_toward_position(position_x, position_y, position_z, 2.775, 2.775)
	monster.set_motion("攻撃１", -1, 2)
	movement.turn_until_motion_progress(vm.f32(4.8), vm.f32(0.315), -1.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(facing_radians) * 100.0))
	position_z = vm.f32(position_z + vm.f32(vm.cos(facing_radians) * 100.0))
	monster.move_toward_position(position_x, position_y - 20.0, position_z, 5.55, 5.55)
	motion.wait_until_progress(vm.f32(0.595), -1.0)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Runs at the target, lunges forward, then turns and swings a second time.
local function lunge_combo_attack()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_radians: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(vm.f32(7.8), vm.f32(7.2000003), 30.0, 75)
	monster.set_motion("攻撃１", -1, 2)
	movement.turn_until_motion_progress(vm.f32(4.8), vm.f32(0.315), -1.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(facing_radians) * 100.0))
	position_z = vm.f32(position_z + vm.f32(vm.cos(facing_radians) * 100.0))
	monster.move_toward_position(position_x, position_y - 20.0, position_z, 5.55, 5.55)
	motion.wait_until_progress(vm.f32(0.595), -1.0)
	monster.stop_moving()
	target_angle = monster.get_target_angle() or target_angle
	monster.turn_toward_angle(target_angle, calc.degrees_to_radians(vm.f32(7.2000003)))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	movement.stop_turning()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a long-range action: lunge, chase or wait.
local function act_at_long_range()
	local roll: s32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			lunge_attack()
		else
			lunge_combo_attack()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.8), 75.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(30.0, 45.0, 75)
		end
	end
end

--- Picks a medium-range action: lunge, chase or circle the target.
local function act_at_medium_range()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 40 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			lunge_attack()
		else
			lunge_combo_attack()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
			if roll < 50 then
				strafe_degrees = vm.f32(-strafe_degrees - 30.0)
			else
				strafe_degrees = vm.f32(strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(1.75, vm.f32(4.8), strafe_degrees, 60.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Walks up to the target and swings the sword while tracking the target.
local function walk_up_and_swing()
	local tracked_frames: s32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.75, vm.f32(7.2000003), 30.0, 75)
	movement.turn_toward_target_and_wait_guarded(vm.f32(9.6))
	monster.set_motion("攻撃１", -1, 2)
	tracked_frames = movement.track_target_guarded(vm.f32(9.6), calc.pass_through(9))
	if tracked_frames < calc.pass_through(15) then
		timer.wait_frames_with_guard_update(calc.pass_through(vm.i32(15 - tracked_frames)))
	end
	movement.stop_turning()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a close-range action: swing, strike, combo, circle or step away.
local function act_at_close_range()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 85 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 60)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				walk_up_and_swing()
			else
				combat.approach_and_strike()
			end
			monster.set_motion("立ち", -1, 0)
		else
			combat.approach_and_combo()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 60 then
			roll = monster.get_random(100) or roll
			strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
			if roll < 50 then
				strafe_degrees = vm.f32(-strafe_degrees - 30.0)
			else
				strafe_degrees = vm.f32(strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(1.75, vm.f32(4.8), strafe_degrees, 60.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				movement.step_backward()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				movement.step_sideways()
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Fights the target while rage hits remain and the target stays within range.
local function fight_normal_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 280.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_while_waiting()
			continue
		end
		if target_distance < 280.0 and target_distance >= 180.0 then
			act_at_long_range()
		elseif target_distance < 180.0 and target_distance >= 75.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Runs at the target and swings the sword if the chase times out.
local function run_at_target()
	local chase_result: s32 = 0
	monster.set_motion("走り", -1, 0)
	chase_result = movement.chase_target_guarded(vm.f32(7.8), vm.f32(4.8), 30.0, 120)
	if chase_result == -1 then
		walk_up_and_swing()
	end
	monster.set_motion("立ち", -1, 0)
end

--- Fights aggressively once no rage hits remain.
local function fight_enraged_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			strafe_while_waiting()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 75.0 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				roll = monster.get_random(100) or roll
				if roll < 80 then
					combat.approach_and_combo()
				else
					lunge_combo_attack()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(1.75, vm.f32(9.6), 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 80 then
				roll = monster.get_random(100) or roll
				if roll < 70 then
					lunge_combo_attack()
				else
					lunge_attack()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(7.2000003))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(vm.f32(7.8), vm.f32(4.8), 30.0, 75)
				monster.set_motion("立ち", -1, 0)
			end
		end
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
			if target_distance < 280.0 then
				fight_normal_phase()
			else
				behavior.roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 180.0 then
					reaction.set_guard_active(0)
					fight_normal_phase()
				else
					run_at_target()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_enraged_phase()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the sword hit boxes and applies the default settings.
function script.init()
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.505, 0.675, 0, 3)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.505, 0.675, 1, 2)
	monster.register_damage_hit("Ｍ連撃２", 2.0, "攻撃２", 0.222, 0.335, 1, 2)
	monster.register_damage_hit("Ｍ連撃２", 2.0, "攻撃２", 0.467, 0.578, 0, 3)
	monster.set_variable(0, 0)
	initialize_defaults()
end

--- Repeats the behavior update every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
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

--- Plays the knockdown motion, lies on the ground, then gets back up.
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

--- Turns toward the target, then plays the guard motion and holds it.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(24.0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(60)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Turns toward the target and steps backward.
function script.on_dodge_1()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	reaction.update_and_wait_frame()
	movement.step_backward()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Turns toward the target and steps sideways.
function script.on_dodge_2()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	reaction.update_and_wait_frame()
	movement.step_sideways()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished_guarded()
	death.play_effects()
end

--- Plays the struggling motion while the monster is held.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Recovers from a throw and stands up.
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

--- Plays the knockback and getting-up motions, then stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
