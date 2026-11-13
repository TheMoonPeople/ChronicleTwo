--!strict
--- Controls the Griffon Soldier: it patrols, circles and chases the player and attacks with lunging strikes, triggering an event once four have been defeated.

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

--- Gives bosses an unlimited clip distance and other monsters a short one.
local function set_clip_distance_for_boss()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Either strafes around the player at a random angle or stands until the player is in front.
local function strafe_or_wait()
	local roll: s32 = 0
	local angle_offset_degrees: f32 = 0
	local circle_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		angle_offset_degrees = monster.get_random_whole_number(30.0) or angle_offset_degrees
		circle_distance = monster.get_random_whole_number(30.0) or circle_distance
		circle_distance = vm.f32(circle_distance + 160.0)
		if roll < 50 then
			angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
		else
			angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = movement.walk_around_target(1.75, vm.f32(4.2), angle_offset_degrees, circle_distance, 44.0, 30)
		movement.turn_toward_target_and_wait(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(44.0, 45.0, 30)
	end
end

--- Turns to the player and waits, or walks toward them.
local function act_at_long_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(160.0, 75.0, 75)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(160.0, 75.0, 30)
		end
	else
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.2))
		monster.set_motion("歩き", -1.0, 0)
		movement.chase_target(1.75, vm.f32(4.2), 44.0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns to the player and waits, or walks toward them.
local function act_at_mid_range()
	local roll: s32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(160.0, 75.0, 45)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(160.0, 75.0, 30)
		end
	else
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.2))
		monster.set_motion("歩き", -1.0, 0)
		movement.chase_target(1.75, vm.f32(4.2), 44.0, 75)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Tracks the player, then lunges forward with the first attack.
local function attack_lunge_first()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target(vm.f32(4.2), calc.pass_through(24))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(heading) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(heading) * 100.0))
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 1.75, 1.75)
	timer.wait_frames(calc.pass_through(7))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Tracks the player, then lunges forward with the second attack.
local function attack_lunge_second()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 6)
	movement.track_target(vm.f32(4.2), calc.pass_through(12))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(heading) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(heading) * 100.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.625, 2.625)
	timer.wait_frames(calc.pass_through(17))
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Performs the second attack while turning toward the player without moving forward.
local function attack_second_in_place()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_facing_target(vm.f32(4.2))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Hops backward away from the player, briefly becoming untouchable.
local function back_step()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local backward_heading: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	backward_heading = vm.f32(heading + vm.f32(3.1415927))
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(backward_heading) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(backward_heading) * 100.0))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames(calc.pass_through(12))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 4.2, 4.2)
	timer.wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

--- Sidesteps to the right or left around the player while tracking them.
local function sidestep_around_target(is_right: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local angle_offset_degrees: f32 = 0
	local circle_distance: f32 = 0
	circle_distance = monster.get_target_distance() or circle_distance
	if is_right ~= 0 then
		monster.set_motion("歩き右", -1, 0)
		angle_offset_degrees = -45.0
	else
		monster.set_motion("歩き左", -1, 0)
		angle_offset_degrees = 45.0
	end
	if circle_distance < 88.0 then
		circle_distance = vm.f32(circle_distance + 30.0)
	end
	destination_x, destination_y, destination_z = movement.get_approach_point(angle_offset_degrees, circle_distance, destination_x, destination_y, destination_z)
	monster.move_toward_position(destination_x, destination_y, destination_z, 1.75, 1.75)
	movement.track_target(vm.f32(4.2), calc.pass_through(40))
	monster.stop_moving()
end

--- Charges and attacks a nearby player, or backs off and sidesteps.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.2))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_directly(vm.f32(4.2), vm.f32(4.2), 44.0, 75)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				attack_lunge_first()
			else
				attack_lunge_second()
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target(1.75, vm.f32(4.2), 44.0, 90)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				attack_lunge_first()
			else
				attack_second_in_place()
			end
		end
	else
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 66.0 then
			back_step()
		end
		roll = monster.get_random(100) or roll
		if roll < 50 then
			sidestep_around_target(1)
		else
			sidestep_around_target(0)
		end
	end
end

--- Chooses an action by distance to the player until the player leaves range or the rage hits run out.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		monster.get_life()
		behavior.face_target_if_transformed()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			strafe_or_wait()
			continue
		end
		if target_distance < 300.0 and target_distance >= 240.0 then
			act_at_long_range()
		elseif target_distance < 240.0 and target_distance >= 160.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Idles, wanders or strafes around when the player is out of range, returning toward its placed position when it has strayed.
local function wander_near_home()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance_from_home: f32 = 0
	local turn_angle_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local clear_distance: f32 = 0
	local wander_angle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local orbit_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_orbit_degrees: f32 = 0
	timer.wait_one_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	distance_from_home = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance_from_home
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 44.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_to_angle(turn_angle_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 44.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction(vm.f32(4.2), 1.75, turn_angle_degrees, clear_distance, 44.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_home > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_home > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				wander_angle_degrees = monster.get_random_whole_number(360.0) or wander_angle_degrees
				distance_from_home = monster.get_random_whole_number(150.0) or distance_from_home
				if roll < 50 then
					wander_angle_degrees = vm.f32(-wander_angle_degrees - 30.0)
				else
					wander_angle_degrees = vm.f32(wander_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_unguarded(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.2), distance_from_home, wander_angle_degrees, 44.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle(final_turn_degrees, vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 40 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_to_angle(turn_angle_degrees, vm.f32(4.2))
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
					orbit_angle_degrees = monster.get_random_whole_number(180.0) or orbit_angle_degrees
					orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
					target_distance = monster.get_target_distance() or target_distance
					orbit_distance = vm.f32(orbit_distance + target_distance)
					if roll < 50 then
						orbit_angle_degrees = vm.f32(orbit_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
					else
						orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_around_target(1.75, vm.f32(4.2), orbit_angle_degrees, orbit_distance, 44.0, 60)
					final_turn_orbit_degrees = monster.get_random_whole_number(360.0) or final_turn_orbit_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_orbit_degrees = vm.f32(final_turn_orbit_degrees * -1.0)
					end
					movement.turn_to_angle(final_turn_orbit_degrees, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						heading = out2 or heading
					end
					turn_angle_degrees = calc.radians_to_degrees(heading)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction(1.75, turn_angle_degrees, 1000.0, 44.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance_from_home = monster.get_target_distance() or distance_from_home
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander_unguarded(1.75, vm.f32(4.2), distance_from_home, 360.0, 40.0, 44.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs at the player once the rage hits are used up, attacking when close.
local function chase_target_when_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	local distance_after_chase: f32 = 0
	local roll: s32 = 0
	monster.get_life()
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 300.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 2 then
			strafe_or_wait()
			continue
		end
		if target_distance < 160.0 then
			monster.set_motion("走り", -1, 0)
			movement.chase_target(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
			distance_after_chase = monster.get_target_distance() or distance_after_chase
			if distance_after_chase < 110.0 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					attack_lunge_first()
				elseif distance_after_chase < 44.0 then
					attack_second_in_place()
				else
					attack_lunge_second()
				end
			end
		else
			monster.set_motion("走り", -1, 0)
			movement.chase_target(vm.f32(4.2), vm.f32(4.2), 44.0, 90)
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows and resets the shared defeat counter.
function script.init()
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.316, 0.409, 2, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃１", 0.54, 0.595, 0, 1)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.544, 0.583, 2, 3)
	monster.register_damage_hit("通常攻撃", 3.0, "攻撃２", 0.544, 0.583, 0, 1)
	monster.set_variable(0, 0)
	monster.set_variable(127, 0)
	set_clip_distance_for_boss()
end

--- Fights the player when in range, wanders when not, and chases the player once enraged.
function script.loop()
	local gekirin: s32 = 0
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			behavior.face_target_if_transformed()
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 300.0 then
				fight_target_in_range()
			else
				wander_near_home()
			end
		else
			chase_target_when_enraged()
		end
	end
end

--- Plays a short flinch and returns to standing.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is blown backward, lies down and gets back up.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Turns to the player and guards with a short knockback.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(21.0)
	monster.reset_motion()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(12)
	monster.set_motion("立ち", 0)
	state.unlock()
end

--- Faces the player and hops backward.
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
	vm.wait()
	back_step()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Resets the motion for the second dodge.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Counts the defeat and requests the cleared event once the fourth soldier has fallen.
function script.on_death()
	local defeat_count: s32 = 0
	death.begin()
	defeat_count = monster.get_variable(127) or defeat_count
	defeat_count = vm.i32(defeat_count + 1)
	monster.set_variable(127, defeat_count)
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	if defeat_count == 4 then
		monster.request_event_script(510)
	end
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Struggles while held in the air.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
	timer.wait_forever_unguarded()
end

--- Recovers after being thrown and stands back up.
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

--- Flinches and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames(12)
	reaction.stun_until_recovered()
end

return script
