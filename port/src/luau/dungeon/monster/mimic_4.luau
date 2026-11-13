--!strict
--- Controls a Mimic variant, a treasure chest monster that lunges and sidesteps.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

local ground_height: f32 = 0

--- Records the monster's height and sets how far away it stays active.
local function configure_clip_distance()
	local boss: s32 = 0
	ground_height = 0.0
	boss = monster.is_boss() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.get_position_3()
			ground_height = out2 or ground_height
		end
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
	ground_height = 0.0
end

--- Sidesteps around the target with collision disabled.
local function step_sideways(move_speed: f32)
	local roll: s32 = 0
	local target: f32 = 0
	local target_y: f32 = 0
	local target_3: f32 = 0
	local target_distance: f32 = 0
	local offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("歩き右", -1, 6)
		offset_degrees = 30.0
	else
		monster.reset_motion()
		monster.set_motion("歩き左", -1, 6)
		offset_degrees = -30.0
	end
	target, target_y, target_3 = movement.get_approach_point(offset_degrees, target_distance, target, target_y, target_3)
	sense.wait_until_target_in_arc(40.0, 45.0, 7)
	monster.move_toward_position(target, ground_height, target_3, move_speed, move_speed)
	monster.set_monster_attributes(32, 1)
	sense.wait_until_target_in_arc(40.0, 45.0, 9)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

--- Picks an action while the target is close: lunge, dodge or circle.
local function act_at_close_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		combat.lunge_forward()
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				step_sideways(3.0)
			else
				movement.retreat_short(3.0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				circle_degrees = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				circle_degrees = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			movement.circle_target(2.0, circle_degrees, 3.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Fights the target by distance until it leaves range or the monster becomes enraged.
local function fight_while_calm()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 175.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			movement.wander_step()
			continue
		end
		if target_distance < 175.0 and target_distance >= 140.0 then
			combat.choose_move_or_dash()
		elseif target_distance < 140.0 and target_distance >= 90.0 then
			combat.choose_dash_or_move()
		else
			act_at_close_range()
		end
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the attack hits and sets the clip distance.
function script.init()
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃１", 0.382, 0.697, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "攻撃２", 0.522, 0.652, 1)
	configure_clip_distance()
end

--- Wanders until the target is near, then fights it.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		movement.wander_until_target_near()
		fight_while_calm()
		vm.wait()
	end
end

--- Plays the damage reaction and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
function script.on_knockdown()
	state.lock_and_face_target()
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

--- Plays the guard animation, sometimes turning toward the target first.
function script.on_guard()
	local roll: s32 = 0
	state.lock_and_stop_moving()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.reset_motion()
		monster.set_motion("ガード入り", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(8)
		monster.set_motion("ガード戻り", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(15.0)
		monster.reset_motion()
		monster.set_motion("ガード入り", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(60)
		monster.set_motion("ガード戻り", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち")
	end
	state.unlock()
end

--- Steps back to dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	movement.retreat_short(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Sidesteps to dodge.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	step_sideways(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death animation and death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers after landing from a throw.
function script.on_land()
	combat.finish_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Falls, recovers and stays stunned until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
