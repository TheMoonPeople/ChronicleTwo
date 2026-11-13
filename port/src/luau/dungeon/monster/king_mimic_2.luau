--!strict
--- Controls a King Mimic variant, a larger treasure chest monster with three attacks.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
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
	timer.wait_frames(13)
	target, target_y, target_3 = movement.get_approach_point(offset_degrees, target_distance, target, target_y, target_3)
	monster.move_toward_position(target, ground_height, target_3, move_speed, move_speed)
	monster.set_monster_attributes(32, 1)
	timer.wait_frames(9)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

--- Picks an action while the target is close: attacks, dodge or circle.
local function act_at_close_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 34 then
			combat.lunge_forward_short()
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				combat.perform_strike_2()
			else
				combat.perform_strike_3()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				step_sideways(3.0)
			else
				movement.retreat_long(3.0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				circle_degrees = -30.0
				monster.set_motion("歩き左", -1, 4)
			else
				circle_degrees = 30.0
				monster.set_motion("歩き右", -1, 4)
			end
			for i = 0, 2 do
				timer.wait_frames(13)
				movement.circle_target(vm.f32(2.5500002), circle_degrees, 3.0, 9)
				monster.stop_moving()
				timer.wait_frames(3)
			end
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
		if target_distance > 200.0 then
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
			movement.wander_step_slow()
			continue
		end
		if target_distance < 200.0 and target_distance >= 140.0 then
			combat.choose_move_or_swing()
		elseif target_distance < 140.0 and target_distance >= 100.0 then
			combat.choose_move_or_slam()
		else
			act_at_close_range()
		end
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the three attack hits and sets the clip distance.
function script.init()
	monster.register_damage_hit("通常攻撃", 8.0, "攻撃１", 0.353, 0.42, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃２", 0.321, 0.536, 1)
	monster.register_damage_hit("弱攻撃", 8.0, "攻撃３", 0.5, 0.607, 2)
	configure_clip_distance()
end

--- Wanders until the target is in range, then fights it.
function script.loop()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		movement.wander_until_target_in_range()
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

--- Locks and unlocks without being knocked down.
function script.on_knockdown()
	state.lock_and_face_target()
	state.unlock_and_clear_action()
end

--- Locks and unlocks without guarding.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Steps back to dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	movement.retreat_long(3.0)
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

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster ignores being caught.
function script.on_caught() end

--- Recovers after landing from a throw.
function script.on_land()
	combat.finish_throw()
	state.do_nothing_hook()
	return 1
end

--- Plays the damage pose briefly, then stays stunned until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames(3)
	reaction.stun_until_recovered()
end

return script
