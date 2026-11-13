--!strict
--- Controls the Uther boss: a guarding swordsman that circles and chases the player, slashes, lunges and fires barrages of rockets.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local camera = require("@lib/monster/camera")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard thresholds and gives bosses an unlimited clip distance and other monsters a short one.
local function configure_guard_and_clip_distance()
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

--- Randomly strafes around the player, stands waiting for them, or plays the idle animation.
local function strafe_or_play()
	local roll: s32 = 0
	local angle_offset_degrees: f32 = 0
	local circle_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			angle_offset_degrees = monster.get_random_whole_number(30.0) or angle_offset_degrees
			circle_distance = monster.get_random_whole_number(30.0) or circle_distance
			circle_distance = vm.f32(circle_distance + 130.0)
			if roll < 50 then
				angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
			else
				angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(2.75, vm.f32(4.2), angle_offset_degrees, circle_distance, 60.0, 30)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(60.0, 45.0, 30)
		end
	else
		behavior.play_facing_target()
	end
end

--- Raises the weapon and fires rockets in random directions, more of them when enraged.
local function attack_rocket_barrage(rocket_count: any)
	local attack: s32 = 0
	local gekirin: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local frame: s32 = 0
	local roll: s32 = 0
	local spread_angle: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃３in", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃３", -1, 4)
	rocket_count = 32
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin <= 0 then
		rocket_count = rocket_count * 2
	end
	frame = 0
	while frame < rocket_count do
		if vm.imod(frame, 8) == 0 then
			do
				local out1, out2, out3 = monster.get_frame_position("dcol2")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			spread_angle = monster.get_random_whole_number(1.5707964) or spread_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				spread_angle = vm.f32(spread_angle * -1.0)
			end
			do
				local out1, out2, out3 = monster.copy_vector(vm.sin(spread_angle), 0.5, vm.cos(spread_angle))
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
			monster.fire_rocket(pos_x, pos_y, pos_z, direction_x, direction_y, direction_z, 15.0, 2, 45, attack)
		end
		reaction.update_and_wait_frame()
		frame = vm.i32(frame + 1)
	end
	monster.set_motion("攻撃３out", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Idles, runs or walks toward the player, or fires the rocket barrage.
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
			movement.chase_target_guarded(2.75, vm.f32(4.2), 130.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			attack_rocket_barrage(30)
		end
	end
end

--- Closes in on the player and lunges forward with a slash, sometimes finishing with the idle animation.
local function attack_lunge_slash()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local normalized_heading: f32 = 0
	local roll: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(2.75, vm.f32(6.2999997), 60.0, 60)
	movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
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
	normalized_heading = heading
	if normalized_heading > vm.f32(3.1415927) then
		normalized_heading = vm.f32(normalized_heading - vm.f32(6.2831855))
	end
	if normalized_heading <= vm.f32(-3.1415927) then
		normalized_heading = vm.f32(normalized_heading + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(normalized_heading) * 100.0))
	pos_y = vm.f32(pos_y - 20.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(normalized_heading) * 100.0))
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress(vm.f32(0.373), -1.0)
	monster.move_toward_position(pos_x, pos_y, pos_z, 6.0, 6.0)
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

--- Picks among the lunge slash, rocket barrage, approaches, circling and the idle animation.
local function act_at_mid_range()
	local roll: s32 = 0
	local life: f32 = 0
	local strafe_angle_degrees: f32 = 0
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
	if roll < 40 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			attack_lunge_slash()
		else
			attack_rocket_barrage(30)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 48 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				attack_lunge_slash()
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
				monster.set_motion("走り", -1, 0)
				movement.chase_target_guarded(6.0, vm.f32(4.2), 60.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 35 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_guarded(2.75, vm.f32(4.2), 60.0, 45)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
					monster.set_motion("走り", -1, 0)
					movement.chase_target_guarded(6.0, vm.f32(4.2), 60.0, 45)
					monster.set_motion("立ち", -1, 0)
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					roll = monster.get_random(100) or roll
					strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
					if roll < 50 then
						strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
					else
						strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					movement.walk_to_point_near_target(2.75, vm.f32(4.2), strafe_angle_degrees, 120.0, 1.0, 25)
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

--- Closes in on the player and performs the second melee attack.
local function attack_second()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(2.75, vm.f32(6.2999997), 60.0, 60)
	movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Attacks a nearby player, circles around them or steps backward.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_life()
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if target_distance < 70.0 then
				attack_second()
			else
				attack_lunge_slash()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			print("near_move---------------------\n")
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.75, vm.f32(4.2), strafe_angle_degrees, 120.0, 1.0, 25)
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

--- Chooses an action by distance to the player until the player leaves range or the rage hits run out.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 320.0 then
			reaction.update_and_wait_frame()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			strafe_or_play()
			continue
		end
		if target_distance < 320.0 and target_distance >= 210.0 then
			act_at_long_range()
		elseif target_distance < 210.0 and target_distance >= 130.0 then
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
	reaction.update_and_wait_frame()
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
	if clear_distance < 60.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 60.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), 1.75, turn_angle_degrees, clear_distance, 60.0, 30)
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
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.2), distance_from_home, wander_angle_degrees, 60.0, 60)
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
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.2))
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
					wait_result = movement.walk_to_point_near_target(1.75, vm.f32(4.2), orbit_angle_degrees, orbit_distance, 60.0, 60)
					final_turn_orbit_degrees = monster.get_random_whole_number(360.0) or final_turn_orbit_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_orbit_degrees = vm.f32(final_turn_orbit_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_orbit_degrees, vm.f32(4.2))
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
					movement.move_in_direction_guarded(1.75, turn_angle_degrees, 1000.0, 60.0, 60)
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
			distance_from_home = monster.get_target_distance() or distance_from_home
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.75, vm.f32(4.2), distance_from_home, 360.0, 40.0, 60.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Fights when the player is near, wanders when far, and charges the player when the guard has just ended.
local function choose_action()
	local target_distance: f32 = 0
	monster.get_rage_hits_left()
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		if target_distance < 320.0 then
			fight_target_in_range()
		else
			wander_near_home()
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(6.0, vm.f32(8.4), 60.0, 60)
		monster.set_motion("立ち", -1, 0)
		reaction.set_guard_active(0)
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows and configures the guard.
function script.init()
	monster.register_damage_hit("弱ＧＣ", 7.8, "攻撃１", 0.347, 0.613, 0)
	monster.register_damage_hit("吹っ飛び弱", 8.2, "攻撃２", 0.293, 0.507, 1)
	monster.set_variable(0, 0)
	configure_guard_and_clip_distance()
end

--- Keeps choosing actions every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		reaction.update_and_wait_frame()
		choose_action()
	end
end

--- Staggers in place until the status ailment wears off.
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

--- Plays a short flinch and returns to standing.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Faces the player, flinches back and returns to standing.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Turns to the player, raises the guard and lowers it again.
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

--- Faces the player and steps backward.
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

--- Faces the player and steps sideways.
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

--- Plays the death motion and effects, then requests the boss defeat event.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	camera.reset_mode()
	monster.spawn_death_effects()
	timer.wait_frames(30)
	monster.request_event_script(503)
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves being caught to the engine default by defining nothing.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves landing to the engine default by defining nothing.
function script.on_land() end

--- Falls over and gets back up, staying stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
