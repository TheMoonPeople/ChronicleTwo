--!strict
--- Drives the Dog Statue family: a guarding statue that rushes at nearby targets.

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

local destination_y: f32 = 0

--- Sets the guard threshold, secondary parameters and clip distance shared by this monster's variants.
local function set_default_parameters()
	local boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	destination_y = 0.0
	boss = monster.is_boss() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.get_position_3()
			destination_y = out2 or destination_y
		end
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
	destination_y = 0.0
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
		offset_distance = vm.f32(offset_distance + 90.0)
		if roll < 50 then
			offset_angle = vm.f32(-offset_angle - 30.0)
		else
			offset_angle = vm.f32(offset_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.6), 4.0, offset_angle, offset_distance, 50.0, 30)
		movement.turn_toward_target_and_wait_guarded(4.0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(50.0, 45.0, 30)
	end
end

--- Turns to the target or waits for it to come in front.
local function face_or_wait_for_target()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(1.6))
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(100.0, 45.0, 30)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(100.0, 45.0, 30)
	end
end

--- Steps away from the target by a randomised distance.
local function step_backward()
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra: f32 = 0
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		point_x = out1 or point_x
		point_z = out3 or point_z
	end
	random_extra = monster.get_random_whole_number(15.0) or random_extra
	retreat_distance = vm.f32(retreat_distance + vm.f32(25.0 + random_extra))
	point_x, point_y, point_z = movement.get_approach_point(0.0, retreat_distance, point_x, point_y, point_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	monster.move_toward_position(point_x, destination_y, point_z, 1.6, 1.6)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
end

--- Rushes forward for a number of frames, turns to the target and steps back.
local function rush_and_step_back(rush_frames: s32)
	monster.set_motion("攻撃１", -1, 0)
	movement.rush_forward_guarded(5.25, 4.0, 1.0, rush_frames)
	monster.stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(4.0)
	step_backward()
	monster.set_motion("立ち", -1, 0)
end

--- Picks a mid-range action: a rush, a stare or backing away.
local function act_at_mid_range()
	local roll: s32 = 0
	local target_angle: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 25 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_with_offset_guarded(4.0, 50.0, 15)
		rush_and_step_back(30)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(17)
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			movement.rush_forward_guarded(vm.f32(1.6), 4.0, vm.f32(60.000004), 30)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 75 then
				roll = monster.get_random(100) or roll
				if roll < 70 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(1.6))
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(50.0, 45.0, 30)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					target_angle = monster.get_target_angle() or target_angle
					movement.move_in_direction_guarded(
						vm.f32(1.2800001),
						calc.radians_to_degrees(vm.f32(target_angle + vm.f32(3.1415927))),
						100.0,
						50.0,
						30
					)
				end
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(50.0, 45.0, 30)
			end
		end
	end
end

--- Picks a close-range action: a rush, a step back or moving toward the target.
local function act_at_close_range()
	local roll: s32 = 0
	local target_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 40 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		rush_and_step_back(30)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(17)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			step_backward()
			monster.set_motion("立ち", -1, 0)
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				rush_and_step_back(30)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(17)
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			target_angle = monster.get_target_angle() or target_angle
			movement.move_in_direction_guarded(vm.f32(1.6), calc.radians_to_degrees(target_angle), 100.0, 1.0, 45)
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
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
			monster.set_variable(5, 1)
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			wait_for_turn()
			continue
		end
		if target_distance < 250.0 and target_distance >= 165.0 then
			face_or_wait_for_target()
		elseif target_distance < 165.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Keeps the guard raised until the target closes in fast, then drops the guard and strikes.
local function stay_guarded_until_provoked()
	local target_distance: f32 = 0
	local target_speed: f32 = 0
	local guard_dropped: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_fast()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if reaction.is_guard_active() ~= 0 or rage_hits_left <= 0 then
			return
		end
		guard_dropped = monster.get_variable(5) or guard_dropped
		target_distance = monster.get_target_distance() or target_distance
		target_speed = monster.get_target_speed() or target_speed
		if target_distance < 90.0 and target_speed > vm.f32(1.8) then
			monster.set_variable(5, 1)
			monster.set_motion("ガードout", -1, 6)
			motion.wait_until_finished_guarded()
			roll = monster.get_random(100) or roll
			if roll < 70 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				rush_and_step_back(30)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(17)
			end
			return
		end
		if guard_dropped == 1 then
			monster.set_motion("ガードin", -1, 6)
			motion.wait_until_finished_guarded()
			monster.set_motion("ガード", -1, 0)
			monster.set_variable(5, 0)
		end
	end
end

--- Drops the guard pose if needed and rushes after the target.
local function rush_target_after_guard()
	local guard_dropped: s32 = 0
	guard_dropped = monster.get_variable(5) or guard_dropped
	if guard_dropped == 0 then
		monster.set_variable(5, 1)
		monster.set_motion("ガードout", -1, 6)
		motion.wait_until_finished_guarded()
	end
	monster.set_motion("攻撃１", -1, 0)
	movement.chase_target_guarded(7.0, 4.0, 50.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target aggressively once the rage counter has run out.
local function fight_target_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local target_angle: f32 = 0
	local retreat_target_angle: f32 = 0
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wait_for_turn()
			continue
		end
		if target_distance < 90.0 then
			roll = monster.get_random(100) or roll
			if roll < 70 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				rush_and_step_back(30)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(12)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					step_backward()
					monster.set_motion("立ち", -1, 0)
					roll = monster.get_random(100) or roll
					if roll < 30 then
						monster.set_motion("歩き", -1, 0)
						movement.turn_toward_target_and_wait_guarded(4.0)
						rush_and_step_back(30)
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames_with_guard_update(12)
					end
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					target_angle = monster.get_target_angle() or target_angle
					movement.move_in_direction_guarded(vm.f32(1.6), calc.radians_to_degrees(target_angle), 100.0, 1.0, 45)
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_with_offset_guarded(4.0, 50.0, 15)
				rush_and_step_back(30)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(12)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					movement.rush_forward_guarded(vm.f32(1.6), 4.0, vm.f32(60.000004), 30)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 75 then
						roll = monster.get_random(100) or roll
						if roll < 70 then
							monster.set_motion("歩き", -1, 0)
							movement.turn_toward_target_and_wait_guarded(vm.f32(1.6))
							monster.set_motion("立ち", -1, 0)
							sense.wait_until_target_in_front(50.0, 45.0, 30)
						else
							monster.set_motion("歩き", -1, 0)
							movement.turn_toward_target_and_wait_guarded(4.0)
							retreat_target_angle = monster.get_target_angle() or retreat_target_angle
							movement.move_in_direction_guarded(
								vm.f32(1.2800001),
								calc.radians_to_degrees(vm.f32(retreat_target_angle + vm.f32(3.1415927))),
								100.0,
								50.0,
								30
							)
						end
					else
						monster.set_motion("立ち", -1, 0)
						sense.wait_until_target_in_front(50.0, 45.0, 30)
					end
				end
			end
		end
	end
end

--- Chooses between fighting, guarding and rushing from the target distance, the guard state and the rage counter.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 250.0 then
				reaction.set_guard_active(0)
				fight_target_cautiously()
			else
				stay_guarded_until_provoked()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 90.0 then
					reaction.set_guard_active(0)
					fight_target_cautiously()
				else
					rush_target_after_guard()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_target_enraged()
	end
end

--- Steps to the left or right of the target.
local function sidestep()
	local roll: s32 = 0
	local target_x: f32 = 0
	local point_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local step_angle: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	roll = monster.get_random(100) or roll
	monster.reset_motion()
	if roll < 50 then
		monster.set_motion("ステップ右", -1, 6)
		step_angle = 30.0
	else
		monster.set_motion("ステップ左", -1, 6)
		step_angle = -30.0
	end
	target_x, point_y, target_z = movement.get_approach_point(step_angle, target_distance, target_x, point_y, target_z)
	monster.set_monster_attributes(32, 0)
	monster.move_toward_position(target_x, destination_y, target_z, 1.9200001, 1.9200001)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
end

local script = {}

--- Runs once when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hits and applies its default parameters when it is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "攻撃１", 0.2, 0.8, 0)
	monster.set_variable(5, 0)
	monster.set_motion("ガード", -1, 0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("ガードout", 0.0, 0.52, 1004)
	end
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

--- Staggers the monster back when a hit would knock it down.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard motions when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the first kind of attack by stepping backward or sidestepping.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	monster.call_command(35, roll) -- retail: the handler rejects 1 arguments
	if roll < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		step_backward()
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		sidestep()
	end
	state.unlock()
end

--- Blocks the second kind of attack with the guard motions.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the monster's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles in place while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
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

--- Knocks the monster over, then raises its guard again if the target is far away.
function script.on_stun()
	local target_distance: f32 = 0
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
	reaction.update_and_wait_frame()
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 90.0 then
		monster.set_motion("ガードin", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("ガード", -1, 0)
		monster.set_variable(5, 0)
	else
		monster.set_motion("立ち", -1, 0)
	end
	reaction.update_and_wait_frame()
end

return script
