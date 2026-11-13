--!strict
--- Controls the King Mimic, a larger treasure chest monster with three attacks.

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
			circle_distance = vm.f32(circle_distance + 120.0)
			if roll < 50 then
				circle_degrees = vm.f32(-circle_degrees - 30.0)
			else
				circle_degrees = vm.f32(circle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_around_target(vm.f32(1.8), 3.0, circle_degrees, circle_distance, 60.0, 30)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(60.0, 45.0, 30)
		end
	else
		motion.play_idle_and_watch_far()
	end
end

--- Picks an action while the target is far away: rush or circle.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local circle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 90 then
		roll = monster.get_random(100) or roll
		if roll < 95 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(vm.f32(1.8), 3.0, 60.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(60.0, 45.0, 75)
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
		movement.walk_around_target(vm.f32(1.8), 3.0, circle_degrees, target_distance, 120.0, 45)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(3.0)
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(60.0, 45.0, 30)
	end
end

--- Faces the target and performs the third attack.
local function perform_attack_3()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃３", -1, 2)
	timer.wait_frames(calc.pass_through(28))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Picks an action while the target is at medium distance: attack, rush or circle.
local function act_at_medium_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		perform_attack_3()
	else
		roll = monster.get_random(100) or roll
		if roll < 90 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(vm.f32(1.8), 3.0, 60.0, 90)
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
			timer.wait_frames(calc.pass_through(13))
			movement.circle_target(vm.f32(2.6999998), circle_degrees, 3.0, calc.pass_through(9))
			monster.stop_moving()
			timer.wait_frames(calc.pass_through(3))
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(60.0, 45.0, 30)
		end
	end
end

--- Faces the target and performs the second attack.
local function perform_attack_2()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 2)
	timer.wait_frames(calc.pass_through(28))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Lunges forward with the first attack.
local function perform_lunge_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_motion("攻撃１", -1, 2)
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
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.6999998, 2.6999998)
	timer.wait_frames(calc.pass_through(15))
	monster.stop_moving()
	timer.wait_frames(calc.pass_through(4))
end

--- Sidesteps around the target with collision disabled.
local function step_sideways(move_speed: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local step_distance: f32 = 0
	local step_heading: f32 = 0
	local roll: s32 = 0
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
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("歩き左", -1, 6)
		step_heading = vm.f32(rotation_y + vm.f32(1.5707964))
	else
		monster.set_motion("歩き右", -1, 6)
		step_heading = vm.f32(rotation_y - vm.f32(1.5707964))
	end
	step_distance = 100.0
	if step_heading > vm.f32(3.1415927) then
		step_heading = vm.f32(step_heading - vm.f32(6.2831855))
	end
	if step_heading <= vm.f32(-3.1415927) then
		step_heading = vm.f32(step_heading + vm.f32(6.2831855))
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(step_heading) * step_distance))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(step_heading) * step_distance))
	motion.wait_until_progress_reached(vm.f32(0.444), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target, target_2, target_3, move_speed, move_speed)
	motion.wait_until_finished()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
end

--- Hops backward from the target with collision disabled.
local function step_backward(move_speed: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local backward_heading: f32 = 0
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
	backward_heading = vm.f32(rotation_y + vm.f32(3.1415927))
	if backward_heading > vm.f32(3.1415927) then
		backward_heading = vm.f32(backward_heading - vm.f32(6.2831855))
	end
	if backward_heading <= vm.f32(-3.1415927) then
		backward_heading = vm.f32(backward_heading + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(backward_heading)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(backward_heading)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("歩き後", -1, 2)
	motion.wait_until_progress_reached(vm.f32(0.52), -1.0)
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.6999998, 2.6999998)
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Picks an action while the target is close: attacks, rush, dodge or circle.
local function act_at_close_range()
	local roll: s32 = 0
	local circle_count: s32 = 0
	local circle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(vm.f32(1.8), 3.0, 60.0, 45)
			perform_attack_3()
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 75 then
				perform_attack_2()
			else
				perform_lunge_attack()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward(vm.f32(1.8), 3.0, 60.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 25 then
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
				circle_count = 0
				timer.wait_frames(calc.pass_through(13))
				movement.circle_target(vm.f32(2.6999998), circle_degrees, 3.0, 9)
				monster.stop_moving()
				timer.wait_frames(calc.pass_through(3))
				circle_count = circle_count + 1
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(3.0)
				monster.set_motion("立ち", -1, 0)
			end
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
		if target_distance > 400.0 then
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
		if target_distance < 400.0 and target_distance >= 180.0 then
			act_at_long_range()
		elseif target_distance < 180.0 and target_distance >= 120.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Picks a wandering, waiting or turning behavior while the target is far away.
local function choose_idle_behavior()
	local roll: s32 = 0
	local engagement_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local heading_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local circle_degrees: f32 = 0
	local turn_degrees: f32 = 0
	local side_degrees: f32 = 0
	local orbit_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
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
	distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 60.0 then
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle(heading_degrees, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 60.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction(3.0, vm.f32(1.8), heading_degrees, clear_distance, 60.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
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
				circle_degrees = monster.get_random_whole_number(360.0) or circle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					circle_degrees = vm.f32(-circle_degrees - 30.0)
				else
					circle_degrees = vm.f32(circle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_unguarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.0, distance, circle_degrees, 60.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				movement.turn_to_angle(turn_degrees, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				engagement_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if engagement_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle(heading_degrees, 3.0)
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
					side_degrees = monster.get_random_whole_number(180.0) or side_degrees
					orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
					target_distance = monster.get_target_distance() or target_distance
					orbit_distance = vm.f32(orbit_distance + target_distance)
					if roll < 50 then
						side_degrees = vm.f32(side_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						side_degrees = vm.f32(-side_degrees - 30.0)
					else
						side_degrees = vm.f32(side_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					engagement_result = movement.walk_around_target(vm.f32(1.8), 3.0, side_degrees, orbit_distance, 60.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle(final_turn_degrees, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					heading_degrees = calc.radians_to_degrees(rotation_y)
					if heading_degrees > vm.f32(3.1415927) then
						heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
					end
					if heading_degrees <= vm.f32(-3.1415927) then
						heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction(vm.f32(1.8), heading_degrees, 1000.0, 60.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				engagement_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if engagement_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander_unguarded(vm.f32(1.8), 3.0, distance, 360.0, 40.0, 60.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Fights aggressively with attacks and rushes until the rage ends.
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
		if target_distance < 120.0 then
			roll = monster.get_random(100) or roll
			if roll < 34 then
				perform_lunge_attack()
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					perform_attack_2()
				else
					perform_attack_3()
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 15 then
				perform_attack_3()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.rush_forward(vm.f32(2.16), 3.0, 60.0, 30)
					monster.set_motion("立ち", -1, 0)
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
						timer.wait_frames(calc.pass_through(13))
						movement.circle_target(vm.f32(1.8), circle_degrees, 3.0, calc.pass_through(9))
						monster.stop_moving()
						timer.wait_frames(calc.pass_through(3))
					end
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

--- Registers the three attack hits and sets the clip distance.
function script.init()
	monster.register_damage_hit("通常毒", 8.0, "攻撃１", 0.353, 0.42, 0)
	monster.register_damage_hit("通常乾き", 6.0, "攻撃２", 0.321, 0.536, 1)
	monster.register_damage_hit("Ｋミミック", 8.0, "攻撃３", 0.5, 0.607, 2)
	configure_clip_distance()
end

--- Fights calmly or enraged depending on its remaining rage hits.
function script.loop()
	local target_distance: f32 = 0
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.try_face_transformed_player_plain_speed_3()
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 400.0 then
				fight_while_calm()
			else
				choose_idle_behavior()
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

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster is never knocked down.
function script.on_knockdown() end

--- Locks and unlocks without guarding.
function script.on_guard()
	state.lock_and_stop_moving()
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
