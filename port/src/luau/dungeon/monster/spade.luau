--!strict
--- Controls the Spade monster family, a card enemy that slashes and charges forward.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard, clip distance and secondary-variable defaults for the monster.
local function setup_defaults()
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

--- Closes the distance to the target by running, walking or waiting when it is far away.
local function approach_from_far()
	local random_value: s32 = 0
	monster.get_target_distance()
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("走り", -1, 0)
		movement.pursue_target_guarded(vm.f32(3.2), vm.f32(4.2), 90.0, 45)
		monster.set_motion("立ち", -1, 0)
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.pursue_target_guarded(1.75, vm.f32(4.2), 90.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(40.0, 45.0, 75)
		end
	end
end

--- Walks up to the target, slashes and charges forward in the direction it faces.
local function slash_and_charge()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.pursue_target_guarded(1.75, vm.f32(6.2999997), 40.0, 60)
	movement.turn_toward_target_and_wait_guarded(vm.f32(8.4))
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(vm.f32(8.4), calc.pass_through(24))
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(rotation_y) * 300.0))
	position_y = vm.f32(position_y - 20.0)
	position_z = vm.f32(position_z + vm.f32(vm.cos(rotation_y) * 300.0))
	monster.move_toward_position(position_x, position_y, position_z, 3.2, 3.2)
	timer.wait_frames_with_guard_update(calc.pass_through(10))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks an attack, approach or sidestep when the target is at middle range.
local function act_at_mid_range()
	local random_value: s32 = 0
	local side_angle: f32 = 0
	monster.get_target_distance()
	random_value = monster.get_random(100) or random_value
	if random_value < 80 then
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			slash_and_charge()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
			monster.set_motion("走り", -1, 0)
			movement.pursue_target_guarded(vm.f32(3.2), vm.f32(4.2), 40.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 30 then
			monster.set_motion("歩き", -1, 0)
			movement.pursue_target_guarded(1.75, vm.f32(4.2), 40.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 45 then
			else
				random_value = monster.get_random(100) or random_value
				side_angle = monster.get_random_whole_number(60.0) or side_angle
				if random_value < 50 then
					side_angle = vm.f32(-side_angle - 30.0)
				else
					side_angle = vm.f32(side_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(1.75, vm.f32(4.2), side_angle, 80.0, 1.0, 25)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			end
		end
	end
end

--- Picks an attack, sidestep or backstep when the target is close.
local function act_at_close_range()
	local random_value: s32 = 0
	local side_angle: f32 = 0
	monster.get_life()
	random_value = monster.get_random(100) or random_value
	if random_value < 80 then
		slash_and_charge()
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if random_value < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(1.75, vm.f32(4.2), side_angle, 80.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			reaction.dodge_backward_slow()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Fights the target while it stays in range and rage hits remain, choosing behaviour by distance.
local function fight_while_rage_remaining()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 230.0 then
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
			movement.strafe_or_stand()
			continue
		end
		if target_distance < 230.0 and target_distance >= 135.0 then
			approach_from_far()
		elseif target_distance < 135.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Fights the target once no rage hits remain, attacking when close and chasing otherwise.
local function fight_without_rage()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local random_value: s32 = 0
	local rage_hits_left: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			movement.strafe_or_stand()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 90.0 then
			random_value = monster.get_random(100) or random_value
			if random_value < 80 then
				slash_and_charge()
			else
				monster.set_motion("歩き", -1, 0)
				movement.pursue_target_guarded(1.75, vm.f32(8.4), 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 40 then
				slash_and_charge()
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
				monster.set_motion("走り", -1, 0)
				movement.pursue_target_guarded(vm.f32(3.2), vm.f32(4.2), 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, wandering and guard-breaking behaviour from the target distance and guard state.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 230.0 then
				fight_while_rage_remaining()
			else
				movement.wander_near_home_fast()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 90.0 then
					reaction.set_guard_active(0)
					fight_while_rage_remaining()
				else
					movement.run_in_place_range()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the monster's attack hits and loads its resources when it is placed.
function script.init()
	monster.register_damage_hit("吹っ飛び弱", 6.7, "攻撃１", 0.52, 0.65, 1)
	monster.add_sword_trail(0, "攻撃１", 0.486, 0.49, "dcol0", "dcol1", 30, 20, 30)
	monster.set_variable(0, 0)
	setup_defaults()
end

--- Runs the monster's normal behaviour each frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Stands staggered while a status ailment lasts after being hit.
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

--- Reacts to a hit that staggers the monster.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks the monster over and gets it back up.
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
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(21.0)
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

--- Dodges the target's first kind of attack.
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
	reaction.dodge_backward_slow()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's second kind of attack.
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
	reaction.dodge_sideways()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the monster's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished_guarded()
	death.play_effects()
end

--- Struggles while caught by a frame that lifts it.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Gets the monster back up after it has been thrown and lands.
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

--- Knocks the monster down and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
