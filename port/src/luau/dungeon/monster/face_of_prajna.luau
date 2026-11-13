--!strict
--- Controls the Face of Prajna family of masked monsters: they approach and circle the player, breathe poison mist, step aside to dodge and guard against hits.

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

--- Sets guard, secondary variable and clip-distance defaults, using an unlimited clip distance for bosses.
local function apply_default_settings()
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

--- Walks to a random spot near the player or waits until the player is in front.
local function reposition_near_target()
	local roll: s32 = 0
	local side_offset_degrees: f32 = 0
	local distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset_degrees = monster.get_random_whole_number(30.0) or side_offset_degrees
		distance_offset = monster.get_random_whole_number(30.0) or distance_offset
		distance_offset = vm.f32(distance_offset + 90.0)
		if roll < 50 then
			side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
		else
			side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(3.0, 3.5, side_offset_degrees, distance_offset, 45.0, 30)
		movement.turn_toward_target_and_wait_guarded(3.5)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(45.0, 45.0, 30)
	end
end

--- Turns toward the player and breathes a poison mist from the mask's mouth.
local function breathe_poison_mist()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(3.5)
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(3.5, vm.f32(0.42), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol01")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("毒霧Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	timer.wait_frames_with_guard_update(calc.pass_through(18))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Rushes, waits, circles or breathes poison mist at long range, depending on random rolls.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(3.0, 3.5, 45.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(45.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_offset_degrees = -30.0
			else
				side_offset_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(3.0, 3.5, side_offset_degrees, target_distance, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(3.5)
		breathe_poison_mist()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Breathes poison mist, rushes or circles the player at medium range.
local function act_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 60 then
		breathe_poison_mist()
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(3.0, 3.5, 45.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_offset_degrees = -30.0
			else
				side_offset_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(3.0, 3.5, side_offset_degrees, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(45.0, 45.0, 30)
		end
	end
end

--- Turns toward the player and plays the first attack motion.
local function perform_primary_attack()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(7.0)
	monster.set_motion("攻撃１", -1, 2)
	timer.wait_frames_with_guard_update(calc.pass_through(45))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Steps to the left or right while briefly invulnerable.
local function sidestep()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ右", -1, 6)
	else
		monster.set_motion("ステップ左", -1, 6)
	end
	timer.wait_frames_with_guard_update(calc.pass_through(5))
	monster.set_monster_attributes(32, 1)
	timer.wait_frames_with_guard_update(calc.pass_through(15))
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Steps backward while briefly invulnerable.
local function step_backward()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	monster.set_monster_attributes(32, 1)
	timer.wait_frames_with_guard_update(calc.pass_through(14))
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Attacks, breathes mist, steps away or circles the player at close range.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_offset_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		target_distance = monster.get_target_distance() or target_distance
		roll = monster.get_random(100) or roll
		if target_distance < 60.0 then
			perform_primary_attack()
		else
			breathe_poison_mist()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 55.0 then
				sidestep()
			else
				step_backward()
			end
			perform_primary_attack()
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			side_offset_degrees = monster.get_random_whole_number(60.0) or side_offset_degrees
			if roll < 50 then
				side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
			else
				side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(3.0, 3.5, side_offset_degrees, 90.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Picks an approach or attack by distance while the player is in range, until the player leaves range or the mask enrages.
local function fight_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 220.0 then
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
			reposition_near_target()
			continue
		end
		if target_distance < 220.0 and target_distance >= 140.0 then
			act_at_long_range()
		elseif target_distance < 140.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Rushes toward the player while guarded.
local function rush_at_target()
	monster.set_motion("歩き", -1, 0)
	movement.rush_forward_guarded(vm.f32(3.6000001), 3.5, 45.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Rushes, breathes mist and circles the player aggressively until the mask is no longer enraged.
local function fight_while_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local side_offset_degrees: f32 = 0
	monster.get_life_int()
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			reposition_near_target()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 90.0 then
			if target_distance < 75.0 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(vm.f32(3.6000001), 3.5, 45.0, 30)
				perform_primary_attack()
			else
				breathe_poison_mist()
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				breathe_poison_mist()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward_guarded(vm.f32(3.6000001), 3.5, 45.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						side_offset_degrees = -30.0
					else
						side_offset_degrees = 30.0
					end
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.5)
					monster.set_motion("歩き", -1, 0)
					movement.walk_to_point_near_target(vm.f32(3.6000001), 3.5, side_offset_degrees, target_distance, 1.0, 45)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(3.5)
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(45.0, 45.0, 30)
				end
			end
		end
	end
end

--- Chooses between fighting, wandering near home and closing in on a guarding player, using the enraged routine when enraged.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.face_target_if_transformed_medium()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 220.0 then
				fight_in_range()
			else
				movement.wander_near_home_slow()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 90.0 then
					reaction.set_guard_active(0)
					fight_in_range()
				else
					rush_at_target()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_while_enraged()
	end
end

--- Steps backward to a point farther from the player while invulnerable.
local function step_back_from_target(move_speed: f32)
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
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(approach_x, current_y, approach_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_guard_update(calc.pass_through(17))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Steps to a random side of the player while invulnerable.
local function dodge_sideways(move_speed: f32)
	local roll: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local current_y: f32 = 0
	local target_distance: f32 = 0
	local side_offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		side_offset_degrees = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		side_offset_degrees = -30.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(side_offset_degrees, target_distance, approach_x, approach_y, approach_z)
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
	motion.wait_until_finished_guarded()
end

local script = {}

--- Does nothing because the monster needs no load-time setup.
function script.setup() end

--- Registers the attack hit windows by grade, loads the poison mist effects and applies the default settings.
function script.init()
	local grade: s32 = 0
	local free_texture_block: s32 = 0
	local low_effect_handle: s32 = 0
	local high_effect_handle: s32 = 0
	grade = monster.get_monster_grade_2(-1) or grade
	if grade ~= 2 then
		monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.378, 0.556, 0, 2)
	else
		monster.register_damage_hit("通常攻撃", 6.0, "攻撃１", 0.378, 0.556, 0)
		monster.register_damage_hit("通常攻撃", 8.8, "攻撃１", 0.378, 0.556, 2)
	end
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		low_effect_handle = monster.load_effect_script("毒霧Ｌ", free_texture_block) or low_effect_handle
		high_effect_handle = monster.load_effect_script("毒霧Ｈ", free_texture_block) or high_effect_handle
		if (if low_effect_handle ~= 0 then 1 else high_effect_handle) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	apply_default_settings()
end

--- Clears the mask flags and repeatedly updates the mask's behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Plays the damage motion and waits until the status ailment wears off.
function script.on_status_hit()
	local status_ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	status_ailments = 1
	while status_ailments ~= 0 do
		status_ailments = monster.get_status_ailments(40) or status_ailments
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion, knocks the mask back and stays staggered briefly.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the mask back, keeps it down briefly and plays the get-up motion.
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

--- Guards with the guard-in and guard-out motions, sometimes turning toward the player and holding the guard longer.
function script.on_guard()
	local roll: s32 = 0
	state.lock_and_stop_moving()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames_with_guard_update(8)
		monster.set_motion("ガードout", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(17.5)
		monster.reset_motion()
		monster.set_motion("ガードin", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames_with_guard_update(60)
		monster.set_motion("ガードout", -1, 6)
		motion.wait_until_finished_guarded()
		monster.set_motion("立ち")
	end
	state.unlock()
end

--- Dodges the player's first kind of attack by stepping back.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	step_back_from_target(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the player's second kind of attack by stepping sideways.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	dodge_sideways(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death motion and then the death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling motion forever while the mask is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers from a throw, plays the get-up motion and returns to the idle state.
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

--- Plays the knocked-over and get-up motions and stays stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
