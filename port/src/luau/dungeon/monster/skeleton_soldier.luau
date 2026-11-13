--!strict
--- Drives the Skeleton Soldier: a sword-wielding monster that fights by distance, guards and dodges.

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
		offset_distance = vm.f32(offset_distance + 80.0)
		if roll < 50 then
			offset_angle = vm.f32(-offset_angle - 30.0)
		else
			offset_angle = vm.f32(offset_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(1.75, vm.f32(4.8), offset_angle, offset_distance, 30.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(30.0, 45.0, 30)
	end
end

--- Chases the target or wanders when it is far away.
local function close_in_on_target()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 75 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.75, vm.f32(4.8), 80.0, 25)
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", -1, 0)
			movement.wander(1.75, vm.f32(4.8), 30.0, 180.0, 30.0, 80.0, 25)
		end
	end
end

--- Plays the second attack motion to its end.
local function perform_attack_2()
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_finished_guarded()
end

--- Plays the first attack motion to its end.
local function perform_attack_1()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_finished_guarded()
end

--- Picks a mid-range action: a running attack or a walk up to the target.
local function act_at_mid_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 55 then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_attack_2()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_attack_1()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
	end
end

--- Plays the first attack motion and follows with the second after a short delay.
local function perform_combo_attack()
	monster.set_motion("攻撃１", -1, 4)
	timer.wait_frames_with_guard_update(calc.pass_through(18))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
end

--- Plays the first attack motion, waits longer, and follows with the second.
local function perform_slow_combo_attack()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(22))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
end

--- Steps away from the target by a randomised distance at the given speed.
local function step_backward(move_speed: f32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		point_x = out1 or point_x
		point_z = out3 or point_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	retreat_distance = vm.f32(retreat_distance + vm.f32(30.0 + random_extra))
	point_x, point_y, point_z = movement.get_approach_point(0.0, retreat_distance, point_x, point_y, point_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(point_x, current_y, point_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_guard_update(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Steps to the left or right and returns to standing.
local function sidestep()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local step_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local step_distance: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		step_angle = out2 or step_angle
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 2)
		step_angle = vm.f32(step_angle + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 2)
		step_angle = vm.f32(step_angle - vm.f32(1.5707964))
	end
	step_distance = 100.0
	destination_x = vm.f32(position_x + vm.f32(vm.sin(step_angle) * step_distance))
	destination_y = vm.f32(position_y - 20.0)
	destination_z = vm.f32(position_z + vm.f32(vm.cos(step_angle) * step_distance))
	motion.wait_until_progress(vm.f32(0.28), vm.f32(0.05))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(destination_x, destination_y, destination_z, 3.6, 3.6)
	motion.wait_until_progress(vm.f32(0.68), vm.f32(0.05))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Picks a close-range action: one of the attacks, a backward step or a sidestep.
local function act_at_close_range()
	local roll: s32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
				movement.turn_toward_target_with_offset_guarded(vm.f32(4.8), 20.0, 15)
				perform_attack_2()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(3)
			else
				roll = monster.get_random(100) or roll
				if roll < 85 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_attack_1()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				else
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_combo_attack()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				end
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			perform_slow_combo_attack()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				step_backward(vm.f32(2.1000001))
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 30)
					perform_attack_1()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				sidestep()
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
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
		if target_distance > 230.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			wait_for_turn()
			continue
		end
		if target_distance < 230.0 and target_distance >= 140.0 then
			close_in_on_target()
		elseif target_distance < 140.0 and target_distance >= 80.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
		reaction.update_and_wait_frame()
	end
end

--- Runs after the target for a while.
local function chase_target()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 180)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target aggressively once the rage counter has run out.
local function fight_target_enraged()
	local unassigned_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wait_for_turn()
			continue
		end
		if unassigned_distance < 80.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 30 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
					movement.turn_toward_target_with_offset_guarded(vm.f32(4.8), 20.0, 15)
					perform_attack_2()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(2)
				else
					roll = monster.get_random(100) or roll
					if roll < 85 then
						monster.set_motion("歩き", -1, 0)
						movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
						movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
						perform_attack_1()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames_with_guard_update(2)
					else
						monster.set_motion("歩き", -1, 0)
						movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
						movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
						perform_combo_attack()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames_with_guard_update(2)
					end
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 30)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
				perform_slow_combo_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(2)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				roll = monster.get_random(100) or roll
				if roll < 30 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 30)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_attack_2()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 30)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
					perform_attack_1()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				end
			else
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(6.0, vm.f32(4.8), 30.0, 90)
				monster.set_motion("立ち", -1, 0)
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
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 230.0 then
				fight_target_cautiously()
			else
				behavior.roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 140.0 then
					reaction.set_guard_active(0)
					fight_target_cautiously()
				else
					chase_target()
				end
			else
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
	monster.register_damage_hit("Ｍ連撃１", 2.0, "攻撃１", 0.36, 0.5, 0, 1)
	monster.register_damage_hit("通常攻撃", 1.5, "攻撃２", 0.27, 0.5, 0)
	monster.register_damage_hit("通常攻撃", 2.0, "攻撃２", 0.27, 0.5, 1)
	monster.add_sword_trail(0, "攻撃１", 0.25, 0.27, "dcol0", "dcol1", 77, 10, 30)
	monster.add_sword_trail(0, "攻撃２", 0.3, 0.32, "dcol0", "dcol1", 77, 10, 30)
	set_default_parameters()
	state.set_secondary_flag(150)
end

--- Runs the monster's main behaviour loop.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
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
	monster.set_action_status(1)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard motions when the monster blocks a hit.
function script.on_guard()
	local roll: s32 = 0
	state.lock_and_stop_moving()
	roll = monster.get_random(100) or roll
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	if roll < 30 then
		perform_attack_2()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(3)
	else
		monster.set_motion("ガードout", -1, 2)
		motion.wait_until_finished_guarded()
	end
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the first kind of attack by sidestepping or stepping backward.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		sidestep()
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("ステップ後", -1, 0)
		step_backward(vm.f32(2.1000001))
	end
	state.unlock()
end

--- Blocks the second kind of attack with the guard motions.
function script.on_dodge_2()
	state.lock_and_reset_motion()
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

--- Plays the death, with a small chance to get back up with part of its life.
function script.on_death()
	local revived_life: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 10 then
		monster.stop_moving()
		movement.stop_turning()
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		monster.set_monster_attributes(32, 1)
		monster.set_motion("死に", -1, 2)
		motion.wait_until_finished_guarded()
		revived_life = monster.get_random_whole_number(0.3) or revived_life
		revived_life = vm.f32(revived_life + vm.f32(0.2))
		monster.set_life(revived_life)
		timer.wait_frames_with_guard_update(45)
		monster.set_motion("起き上がり", -1, 2)
		motion.wait_until_finished_guarded()
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_monster_attributes(32, 0)
		return
	end
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
