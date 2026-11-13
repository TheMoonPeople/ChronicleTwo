--!strict
--- Controls the Mimic, a treasure chest monster that bites with poison and charges.

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

--- Sets how far away the monster stays active, unlimited for bosses.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Plays the idle animation and waits for the target to come in front.
local function play_idle_animation()
	monster.set_motion("遊び", -1, 6)
	sense.wait_until_target_in_arc(40.0, 45.0, calc.pass_through(35))
end

--- Circles the target, waits for it or plays the idle animation.
local function wander_around_target()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	local circle_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			circle_degrees = monster.get_random_whole_number(30.0) or circle_degrees
			circle_distance = monster.get_random_whole_number(30.0) or circle_distance
			circle_distance = vm.f32(circle_distance + 90.0)
			if roll < 50 then
				circle_degrees = vm.f32(-circle_degrees - 30.0)
			else
				circle_degrees = vm.f32(circle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_around_target(vm.f32(2.2), 3.0, circle_degrees, circle_distance, 40.0, 30)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(40.0, 45.0, 30)
		end
	else
		play_idle_animation()
	end
end

--- Charges forward through the target with the knockdown attack.
local function perform_charge_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 6)
	movement.track_target(3.0, calc.pass_through(8))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(rotation_y) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(rotation_y) * 100.0))
	monster.move_toward_position(pos_x, pos_y - 10.0, pos_z, 4.5, 4.5)
	timer.wait_frames(calc.pass_through(17))
	monster.stop_moving()
	monster.get_attack_power_1()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	timer.wait_frames(calc.pass_through(9))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Picks an action while the target is far away: rush, circle or charge.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local circle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward(vm.f32(2.2), 3.0, 40.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(40.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				circle_degrees = -30.0
			else
				circle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(2.2), 3.0, circle_degrees, target_distance, 90.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(40.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(3.0)
		perform_charge_attack()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Picks an action while the target is at medium distance: charge, rush or circle.
local function act_at_medium_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 60 then
		perform_charge_attack()
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(vm.f32(2.2), 3.0, 40.0, 90)
			monster.set_motion("立ち", -1, 0)
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
			movement.circle_target(vm.f32(2.2), circle_degrees, 3.0, 60)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(40.0, 45.0, 30)
		end
	end
end

--- Lunges forward with the poison bite.
local function perform_bite_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_motion("攻撃１", -1, 6)
	timer.wait_frames(calc.pass_through(12))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(rotation_y)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(rotation_y)))
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.08, 3.08)
	timer.wait_frames(calc.pass_through(28))
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Sidesteps around the target with collision disabled.
local function step_sideways(move_speed: f32)
	local roll: s32 = 0
	local target: f32 = 0
	local target_y: f32 = 0
	local target_3: f32 = 0
	local pos_y: f32 = 0
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
	timer.wait_frames(calc.pass_through(7))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 10.0, target_3, move_speed, move_speed)
	monster.set_monster_attributes(32, 1)
	timer.wait_frames(calc.pass_through(9))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

--- Hops backward from the target with collision disabled.
local function step_backward(move_speed: f32)
	local pos_x: f32 = 0
	local target_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local distance_jitter: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_monster_attributes(32, 1)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	distance_jitter = monster.get_random_whole_number(10.0) or distance_jitter
	target_distance = vm.f32(target_distance + vm.f32(40.0 + distance_jitter))
	pos_x, target_y, pos_z = movement.get_approach_point(0.0, target_distance, pos_x, target_y, pos_z)
	monster.set_motion("歩き後", -1, 6)
	timer.wait_frames(calc.pass_through(8))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2, pos_z, move_speed, move_speed + 1.0)
	timer.wait_frames(calc.pass_through(8))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Picks an action while the target is close: bite, dodge or circle.
local function act_at_close_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		perform_bite_attack()
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				step_sideways(3.0)
			else
				step_backward(3.0)
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
			movement.circle_target(vm.f32(2.2), circle_degrees, 3.0, 45)
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
		behavior.try_face_transformed_player_plain_speed_3()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 225.0 then
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
			wander_around_target()
			continue
		end
		if target_distance < 225.0 and target_distance >= 140.0 then
			act_at_long_range()
		elseif target_distance < 140.0 and target_distance >= 90.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Wanders until the target comes within range.
local function wait_for_target_approach()
	local target_distance: f32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 225.0 then
			vm.wait()
			return
		end
		wander_around_target()
	end
end

--- Fights aggressively with bites, charges and rushes until the rage ends.
local function fight_while_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_life_int()
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wander_around_target()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 90.0 then
			perform_bite_attack()
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				perform_charge_attack()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward(vm.f32(2.64), 3.0, 40.0, 30)
					monster.set_motion("立ち", -1, 0)
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
					movement.circle_target(vm.f32(2.2), circle_degrees, 3.0, 45)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait(3.0)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the poison bite and knockdown attack hits and sets the clip distance.
function script.init()
	monster.register_damage_hit("通常毒", 5.0, "攻撃１", 0.382, 0.697, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "攻撃２", 0.522, 0.652, 1)
	configure_clip_distance()
end

--- Fights calmly or enraged depending on its remaining rage hits.
function script.loop()
	local target_distance: f32 = 0
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.try_face_transformed_player_plain_speed_3()
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 225.0 then
				fight_while_calm()
			else
				wait_for_target_approach()
			end
		else
			fight_while_enraged()
		end
	end
end

--- Freezes the monster in a damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
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
		monster.set_motion("ガードin", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		timer.wait_frames(calc.pass_through(8))
		monster.set_motion("ガードout", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(15.0)
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

--- Hops backward to dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	step_backward(3.0)
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
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
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
