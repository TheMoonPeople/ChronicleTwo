--!strict
--- Drives the Alexander monster, which melees and launches flame shots.

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
		strafe_distance = vm.f32(strafe_distance + 90.0)
		if roll < 50 then
			strafe_degrees = vm.f32(-strafe_degrees - 30.0)
		else
			strafe_degrees = vm.f32(strafe_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, strafe_distance, 45.0, 30)
		movement.turn_toward_target_and_wait_guarded(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(45.0, 45.0, 30)
	end
end

--- Turns toward the target and launches a flame shot from the hand.
local function fire_flame_shot()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.0)
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(3.0, vm.f32(0.52), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("火炎弾ループ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Picks a long-range action: rush, wait, sidestep or fire a flame shot.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(2.0, 3.0, 45.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(45.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
			else
				strafe_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, target_distance, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.0)
		fire_flame_shot()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Picks a medium-range action: flame shot, rush or sidestep.
local function act_at_medium_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 60 then
		fire_flame_shot()
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.0, 3.0, 45.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
			else
				strafe_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		end
	end
end

--- Turns toward the target and performs the melee attack.
local function melee_attack()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(6.0)
	monster.set_motion("攻撃１", -1, 2)
	timer.wait_frames(calc.pass_through(45))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Steps to a random side while briefly invulnerable.
local function step_sideways()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ右", -1, 6)
	else
		monster.set_motion("ステップ左", -1, 6)
	end
	timer.wait_frames(calc.pass_through(5))
	monster.set_monster_attributes(32, 1)
	timer.wait_frames(calc.pass_through(15))
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Steps backward while briefly invulnerable.
local function step_backward()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(6))
	monster.set_monster_attributes(32, 1)
	timer.wait_frames(calc.pass_through(14))
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Picks a close-range action: melee, flame shot, step away or circle the target.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		target_distance = monster.get_target_distance() or target_distance
		roll = monster.get_random(100) or roll
		if target_distance < 70.0 then
			melee_attack()
		else
			fire_flame_shot()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 55.0 then
				step_sideways()
			else
				step_backward()
			end
			melee_attack()
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
			movement.walk_to_point_near_target(2.0, 3.0, strafe_degrees, 90.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(9)
		end
	end
end

--- Fights the target while rage hits remain and the target stays within range.
local function fight_normal_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 220.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_while_waiting()
			continue
		end
		if target_distance < 220.0 and target_distance >= 140.0 then
			act_at_long_range()
		elseif target_distance < 140.0 and target_distance >= 90.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Walks toward the target and may fire a flame shot.
local function chase_and_shoot()
	local roll: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(vm.f32(2.4), 3.0, 45.0, 60)
	roll = monster.get_random(100) or roll
	if roll < 70 then
		fire_flame_shot()
	end
	monster.set_motion("立ち", -1, 0)
end

--- Fights aggressively once no rage hits remain.
local function fight_enraged_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life_int()
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 220.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			strafe_while_waiting()
			continue
		end
		if target_distance < 90.0 then
			if target_distance < 75.0 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(vm.f32(2.4), 3.0, 45.0, 30)
				melee_attack()
			else
				fire_flame_shot()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				fire_flame_shot()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward_guarded(vm.f32(2.4), 3.0, 45.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_degrees = -30.0
					else
						strafe_degrees = 30.0
					end
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("歩き", -1, 0)
					movement.walk_to_point_near_target(vm.f32(2.4), 3.0, strafe_degrees, target_distance, 1.0, 45)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.0)
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(45.0, 45.0, 30)
				end
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
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 220.0 then
				fight_normal_phase()
			else
				movement.wander_near_home_slow()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 140.0 then
					reaction.set_guard_active(0)
					fight_normal_phase()
				else
					chase_and_shoot()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_enraged_phase()
	end
end

--- Slides backward away from the target while invulnerable.
local function evade_backward(move_speed: f32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local target_distance: f32 = 0
	local distance_jitter: f32 = 0
	local current_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		approach_x = out1 or approach_x
		approach_z = out3 or approach_z
	end
	distance_jitter = monster.get_random_whole_number(10.0) or distance_jitter
	target_distance = vm.f32(target_distance + vm.f32(40.0 + distance_jitter))
	approach_x, approach_y, approach_z = movement.get_approach_point(0.0, target_distance, approach_x, approach_y, approach_z)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(approach_x, current_y, approach_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(17))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Slides to a random side of the target while invulnerable.
local function evade_sideways(move_speed: f32)
	local roll: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local current_y: f32 = 0
	local target_distance: f32 = 0
	local side_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		side_degrees = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		side_degrees = -30.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(side_degrees, target_distance, approach_x, approach_y, approach_z)
	sense.wait_until_target_in_front(45.0, 45.0, calc.pass_through(5))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(approach_x, current_y - 10.0, approach_z, move_speed, move_speed)
	monster.set_monster_attributes(32, 1)
	sense.wait_until_target_in_front(45.0, 45.0, calc.pass_through(15))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the melee hit box, loads the flame shot effects and applies the default settings.
function script.init()
	local texture_block: s32 = 0
	local flame_loop_loaded: s32 = 0
	local flame_hit_loaded: s32 = 0
	monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.4, 0.556, 0, 1)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		flame_loop_loaded = monster.load_effect_script("火炎弾ループ", texture_block) or flame_loop_loaded
		flame_hit_loaded = monster.load_effect_script("火炎弾ヒット", texture_block) or flame_hit_loaded
		if (if flame_loop_loaded ~= 0 then 1 else flame_hit_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
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
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown motion, lies on the ground, then gets back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards, sometimes turning toward the target first.
function script.on_guard()
	local roll: s32 = 0
	state.lock_and_stop_moving()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(8)
		monster.set_motion("ガードout", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(15.0)
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(60)
		monster.set_motion("ガードout", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち")
	end
	state.unlock()
end

--- Evades backward.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	evade_backward(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Evades sideways.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	evade_sideways(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling motion while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers from a throw and stands up.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Plays the knockback and getting-up motions, then stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
