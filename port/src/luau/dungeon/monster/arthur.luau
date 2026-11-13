--!strict
--- Drives the Arthur, Lancer, Iron Spear and Flying Steel monsters, which charge with lances and fire rocket barrages.

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
		if roll < 50 then
			roll = monster.get_random(100) or roll
			strafe_degrees = monster.get_random_whole_number(30.0) or strafe_degrees
			strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
			strafe_distance = vm.f32(strafe_distance + 130.0)
			if roll < 50 then
				strafe_degrees = vm.f32(-strafe_degrees - 30.0)
			else
				strafe_degrees = vm.f32(strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(2.5, vm.f32(4.2), strafe_degrees, strafe_distance, 50.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(50.0, 45.0, 30)
		end
	else
		behavior.play_facing_target()
	end
end

--- Walks up to the target and fires a barrage of rockets in random directions.
local function fire_rocket_barrage(barrage_frames: any)
	local attack: s32 = 0
	local rage_hits_left: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local frame: s32 = 0
	local roll: s32 = 0
	local spread_radians: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(2.5, vm.f32(6.2999997), 50.0, 60)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃３in", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃３", -1, 4)
	barrage_frames = 32
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left <= 0 then
		barrage_frames = barrage_frames * 2
	end
	frame = 0
	while frame < barrage_frames do
		if vm.imod(frame, 8) == 0 then
			do
				local out1, out2, out3 = monster.get_frame_position("dcol2")
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			spread_radians = monster.get_random_whole_number(1.5707964) or spread_radians
			roll = monster.get_random(100) or roll
			if roll < 50 then
				spread_radians = vm.f32(spread_radians * -1.0)
			end
			do
				local out1, out2, out3 = monster.copy_vector(vm.sin(spread_radians), 0.5, vm.cos(spread_radians))
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			monster.fire_rocket(position_x, position_y, position_z, direction_x, direction_y, direction_z, 12.0, 2, 45, attack)
		end
		reaction.update_and_wait_frame()
		frame = vm.i32(frame + 1)
	end
	monster.set_motion("攻撃３out", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a long-range action: rocket barrage or chase.
local function act_at_long_range()
	local roll: s32 = 0
	local life: f32 = 0
	life = 0.0
	life = monster.get_life() or life
	monster.get_target_distance()
	if life > vm.f32(0.7) then
		roll = monster.get_random(100) or roll
		if roll < 25 then
			behavior.play_facing_target()
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 20 then
		fire_rocket_barrage(30)
	else
		roll = monster.get_random(100) or roll
		if roll < 45 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(6.0, vm.f32(4.2), 130.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 45 then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target_guarded(2.5, vm.f32(4.2), 130.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				fire_rocket_barrage(30)
			end
		end
	end
end

--- Walks up to the target and charges forward with the lance.
local function charge_attack()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_radians: f32 = 0
	local charge_radians: f32 = 0
	local roll: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(2.5, vm.f32(6.2999997), 50.0, 60)
	movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	charge_radians = facing_radians
	if charge_radians > vm.f32(3.1415927) then
		charge_radians = vm.f32(charge_radians - vm.f32(6.2831855))
	end
	if charge_radians <= vm.f32(-3.1415927) then
		charge_radians = vm.f32(charge_radians + vm.f32(6.2831855))
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(charge_radians) * 100.0))
	position_y = vm.f32(position_y - 20.0)
	position_z = vm.f32(position_z + vm.f32(vm.cos(charge_radians) * 100.0))
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress(vm.f32(0.373), -1.0)
	monster.move_toward_position(position_x, position_y, position_z, 6.0, 6.0)
	motion.wait_until_progress(vm.f32(0.613), -1.0)
	motion.wait_until_finished_guarded()
	roll = monster.get_random(100) or roll
	if roll < 10 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
		monster.set_motion("遊び", -1, 2)
		motion.wait_until_finished_guarded()
	end
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a medium-range action: charge, rocket barrage, chase or circle the target.
local function act_at_medium_range()
	local roll: s32 = 0
	local life: f32 = 0
	local strafe_degrees: f32 = 0
	life = 0.0
	life = monster.get_life() or life
	monster.get_target_distance()
	if life > vm.f32(0.7) then
		roll = monster.get_random(100) or roll
		if roll < 15 then
			behavior.play_facing_target()
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 45 then
			charge_attack()
		else
			fire_rocket_barrage(30)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 48 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				charge_attack()
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(6.0, vm.f32(4.2), 50.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 35 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(2.5, vm.f32(4.2), 50.0, 45)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(6.0, vm.f32(4.2), 50.0, 45)
					monster.set_motion("立ち", -1, 0)
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					roll = monster.get_random(100) or roll
					strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
					if roll < 50 then
						strafe_degrees = vm.f32(-strafe_degrees - 30.0)
					else
						strafe_degrees = vm.f32(strafe_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					movement.walk_to_point_near_target(2.5, vm.f32(4.2), strafe_degrees, 100.0, 1.0, 25)
					movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(9)
				else
					behavior.play_facing_target()
				end
			end
		end
	end
end

--- Walks up to the target and performs the melee attack.
local function melee_attack()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(2.5, vm.f32(6.2999997), 50.0, 60)
	movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a close-range action: melee, charge, circle or step back.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life()
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if target_distance < 60.0 then
				melee_attack()
			else
				charge_attack()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			print("near_move---------------------\n")
			roll = monster.get_random(100) or roll
			strafe_degrees = monster.get_random_whole_number(60.0) or strafe_degrees
			if roll < 50 then
				strafe_degrees = vm.f32(-strafe_degrees - 30.0)
			else
				strafe_degrees = vm.f32(strafe_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.5, vm.f32(4.2), strafe_degrees, 100.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			movement.step_backward_guarded()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Fights the target while rage hits remain and the target stays within range.
local function fight_normal_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 350.0 then
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
			strafe_while_waiting()
			continue
		end
		if target_distance < 350.0 and target_distance >= 200.0 then
			act_at_long_range()
		elseif target_distance < 200.0 and target_distance >= 130.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Wanders around the spawn point and waits for the target to approach while no target is in range.
local function roam_around_home()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local home_distance: f32 = 0
	local turn_degrees: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_radians: f32 = 0
	local clear_distance: f32 = 0
	local circle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local offset_degrees: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_position_x = out1 or place_position_x
		place_position_y = out2 or place_position_y
		place_position_z = out3 or place_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	home_distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_radians = out2 or facing_radians
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 50.0 then
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 50.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), 1.75, turn_degrees, clear_distance, 50.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if home_distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				circle_degrees = monster.get_random_whole_number(360.0) or circle_degrees
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					circle_degrees = vm.f32(-circle_degrees - 30.0)
				else
					circle_degrees = vm.f32(circle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, 1.75, vm.f32(4.2), home_distance, circle_degrees, 50.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
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
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_degrees = vm.f32(turn_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.2))
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
					offset_degrees = monster.get_random_whole_number(180.0) or offset_degrees
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if roll < 50 then
						offset_degrees = vm.f32(offset_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_degrees = vm.f32(-offset_degrees - 30.0)
					else
						offset_degrees = vm.f32(offset_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(1.75, vm.f32(4.2), offset_degrees, offset_distance, 50.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_radians = out2 or facing_radians
					end
					turn_degrees = calc.radians_to_degrees(facing_radians)
					if turn_degrees > vm.f32(3.1415927) then
						turn_degrees = vm.f32(turn_degrees - vm.f32(6.2831855))
					end
					if turn_degrees <= vm.f32(-3.1415927) then
						turn_degrees = vm.f32(turn_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.75, turn_degrees, 1000.0, 50.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.75, vm.f32(4.2), home_distance, 360.0, 40.0, 50.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Fires a rocket barrage or runs at the target while it is guarding.
local function approach_while_guarded()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 60 then
		behavior.play_facing_target()
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		fire_rocket_barrage(30)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(6.0, vm.f32(8.4), 50.0, 60)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Fights aggressively once no rage hits remain.
local function fight_enraged_phase()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
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
			strafe_while_waiting()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 130.0 then
			roll = monster.get_random(100) or roll
			if roll < 97 then
				roll = monster.get_random(100) or roll
				if roll < 90 then
					if target_distance < 60.0 then
						melee_attack()
					else
						roll = monster.get_random(60) or roll
						fire_rocket_barrage(vm.i32(75 + roll))
					end
				else
					charge_attack()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(6.0, vm.f32(8.4), 50.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		elseif target_distance < 160.0 then
			charge_attack()
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
			monster.set_motion("走り", -1, 0)
			movement.chase_target_guarded(6.0, vm.f32(4.2), 50.0, 60)
			monster.set_motion("立ち", -1, 0)
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
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 350.0 then
				fight_normal_phase()
			else
				roam_around_home()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 200.0 then
					reaction.set_guard_active(0)
					fight_normal_phase()
				else
					approach_while_guarded()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_enraged_phase()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the lance hit boxes and applies the default settings.
function script.init()
	monster.register_damage_hit("弱ＧＣ", 7.8, "攻撃１", 0.347, 0.613, 0)
	monster.register_damage_hit("吹っ飛び弱", 8.2, "攻撃２", 0.293, 0.507, 1)
	monster.set_variable(0, 0)
	initialize_defaults()
end

--- Repeats the behavior update every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
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
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch motion with a short knockback and stands back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard motion and holds it for a short time.
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

--- Turns toward the target and steps backward.
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
	movement.step_backward_guarded()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Turns toward the target and steps sideways.
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
	movement.step_sideways_guarded()
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

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster cannot be caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the monster ignores landing.
function script.on_land() end

--- Plays the knockback and getting-up motions, then stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
