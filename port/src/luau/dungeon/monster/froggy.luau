--!strict
--- Drives the Froggy family of frog monsters that spit poison and leap at the player.

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

--- Runs or sidesteps toward the target until it is within close range.
local function approach_target()
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local destination_x: f32 = 0
	local destination_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	monster.get_random(120)
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 80.0 then
			break
		else
			do
				local _, out2, _ = monster.get_position_3()
				position_y = out2 or position_y
			end
			if target_distance > 200.0 then
				movement.turn_toward_target(vm.f32(0.09817477))
				monster.set_motion("走り")
				do
					local out1, _, out3 = monster.get_target_position()
					destination_x = out1 or destination_x
					destination_z = out3 or destination_z
				end
				monster.move_toward_position(destination_x, position_y - 20.0, destination_z, 3.6, 60.0)
			else
				monster.stop_moving()
				monster.set_mask_flags(1, 1)
				monster.set_mask_flags(2, 1)
				monster.set_motion("歩き", -1, 2)
				do
					local out1, out2, out3 = monster.get_rotation()
					rotation_x = out1 or rotation_x
					rotation_y = out2 or rotation_y
					rotation_z = out3 or rotation_z
				end
				movement.face_target_instantly()
				do
					local out1, _, out3 = monster.get_point_from_facing(0.0, 40.0)
					destination_x = out1 or destination_x
					destination_z = out3 or destination_z
				end
				monster.set_rotation(rotation_x, rotation_y, rotation_z)
				timer.wait_frames_with_guard_update(5)
				movement.turn_toward_target(vm.f32(0.049087387))
				monster.move_toward_position(destination_x, position_y - 20.0, destination_z, 1.8, 4.0)
				motion.wait_until_finished_guarded()
				monster.set_motion("立ち")
				monster.stop_moving()
				movement.stop_turning()
				monster.set_mask_flags(1, 0)
				monster.set_mask_flags(2, 0)
			end
		end
	end
	monster.stop_moving()
	monster.set_motion("立ち")
end

--- Spits a poison glob at the target from the mouth.
local function spit_poison()
	local attack: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(10.0, vm.f32(0.4), -1.0)
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("毒液L")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(8)
end

--- Leaps at the target and back with the first attack.
local function leap_attack()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_x_2: f32 = 0
	local position_z_2: f32 = 0
	local target_distance: f32 = 0
	local move_speed: f32 = 0
	movement.face_target_instantly()
	reaction.update_and_wait_frame()
	do
		local out1, out2, _ = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
	end
	monster.set_motion("攻撃１", -1, 2)
	timer.wait_frames_with_guard_update(10)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_point_from_facing(0.0, target_distance)
		position_x_2 = out1 or position_x_2
		position_z_2 = out3 or position_z_2
	end
	move_speed = vm.f32(target_distance / 20.0)
	monster.move_toward_position(position_x_2, position_y - 20.0, position_z_2, move_speed, 0.1)
	timer.wait_frames_with_guard_update(22)
	move_speed = vm.f32(target_distance / 35.0)
	monster.move_toward_position(position_x, position_y - 20.0, position_z_2, move_speed, 0.1)
	timer.wait_frames_with_guard_update(25)
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(8)
end

--- Randomly spits, leaps or repositions while the target stays close.
local function attack_when_close()
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local roll: s32 = 0
	local priority: s32 = 0
	local roll_2: s32 = 0
	local roll_3: s32 = 0
	local position_x_2: f32 = 0
	local position_z_2: f32 = 0
	while true do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 120.0 then
			break
		else
			do
				local _, out2, _ = monster.get_position_3()
				position_y = out2 or position_y
			end
			behavior.face_target_if_transformed_medium()
			if sense.is_facing_target_with_whole_offset(0, 180) ~= 0 then
				roll = monster.get_random(100) or roll
				if roll < 10 then
					if target_distance > 60.0 then
						spit_poison()
					else
						monster.set_mask_flags(1, 1)
						monster.set_mask_flags(2, 1)
						if sense.is_facing_target_with_whole_offset(0, 30) == 0 then
							monster.set_motion("歩き", -1, 2)
							timer.wait_frames_with_guard_update(5)
							movement.turn_toward_target(vm.f32(0.09817477))
							motion.wait_until_finished_guarded()
							movement.stop_turning()
						end
						priority = monster.get_priority() or priority
						if (if priority <= 3 then sense.is_facing_target_with_whole_offset(0, 30) else 0) ~= 0 then
							leap_attack()
						end
						monster.set_mask_flags(1, 0)
						monster.set_mask_flags(2, 0)
					end
				end
			else
				roll_2 = monster.get_random(100) or roll_2
				if roll_2 < 10 then
					monster.set_mask_flags(1, 1)
					monster.set_mask_flags(2, 1)
					roll_3 = monster.get_random(100) or roll_3
					if roll_3 < 50 then
						monster.set_motion("歩き", -1, 2)
						do
							local out1, _, out3 = monster.get_point_from_facing(0.0, 40.0)
							position_x_2 = out1 or position_x_2
							position_z_2 = out3 or position_z_2
						end
						timer.wait_frames_with_guard_update(5)
						monster.move_toward_position(position_x_2, position_y - 20.0, position_z_2, 1.8, 1.8)
						motion.wait_until_finished_guarded()
						monster.stop_moving()
					else
						monster.set_motion("歩き", -1, 2)
						timer.wait_frames_with_guard_update(5)
						movement.turn_toward_target(vm.f32(0.09817477))
						motion.wait_until_finished_guarded()
						movement.stop_turning()
					end
					monster.set_mask_flags(1, 0)
					monster.set_mask_flags(2, 0)
				end
			end
			monster.set_motion("立ち")
			reaction.update_and_wait_frame()
		end
	end
end

--- Picks a random idle action such as wandering, turning or watching when the target is far away.
local function wander_when_idle()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local final_turn_angle: f32 = 0
	local approach_angle: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local look_angle: f32 = 0
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
	distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 30.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.0, vm.f32(1.8), turn_angle, clear_distance, 30.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
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
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_position_x, place_position_y, place_position_z, vm.f32(1.8), 3.0, distance, orbit_angle, 30.0, 60)
				final_turn_angle = monster.get_random_whole_number(180.0) or final_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_angle = vm.f32(final_turn_angle * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_angle, 3.0)
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
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle, 3.0)
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
					approach_angle = monster.get_random_whole_number(180.0) or approach_angle
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_angle = vm.f32(approach_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_angle = vm.f32(-approach_angle - 30.0)
					else
						approach_angle = vm.f32(approach_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(vm.f32(1.8), 3.0, approach_angle, approach_distance, 30.0, 60)
					look_angle = monster.get_random_whole_number(360.0) or look_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						look_angle = vm.f32(look_angle * -1.0)
					end
					movement.turn_to_angle_and_wait(look_angle, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle = calc.radians_to_degrees(rotation_y)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.8), turn_angle, 1000.0, 30.0, 60)
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
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.8), 3.0, distance, 360.0, 40.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chases the target and spits or leaps at it while no rage hits remain.
local function fight_when_rage_hits_exhausted()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		return
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 60.0 then
		monster.set_motion("走り", -1, 4)
		movement.chase_target_guarded(vm.f32(3.6), 4.0, 45.0, 90)
	end
	if target_distance < 100.0 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			spit_poison()
			monster.set_motion("立ち", -1, 4)
		else
			leap_attack()
			monster.set_motion("立ち", -1, 4)
		end
	end
end

--- Dodges and then lunges at the target with the dodging attack.
local function dodge_and_lunge()
	local position_x: f32 = 0
	local position_z: f32 = 0
	local lunge_distance: f32 = 0
	local lunge_speed: f32 = 0
	local position_y_2: f32 = 0
	monster.set_motion("避けin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("避けin攻撃", -1, 6)
	do
		local _, out2, _ = monster.get_position_3()
		position_y_2 = out2 or position_y_2
	end
	lunge_distance = monster.get_target_distance() or lunge_distance
	lunge_distance = vm.f32(lunge_distance + 20.0)
	do
		local out1, _, out3 = monster.get_point_from_facing(0.0, lunge_distance)
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	lunge_speed = vm.f32(lunge_distance / 32.0)
	monster.move_toward_position(position_x, position_y_2, position_z, lunge_speed, lunge_speed)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち")
	timer.wait_frames_with_guard_update(8)
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the attack hit windows and loads the poison effects.
function script.init()
	local free_texture_block: s32 = 0
	local low_effect_loaded: s32 = 0
	local high_effect_loaded: s32 = 0
	monster.register_entry_object(0, "bcol00")
	monster.register_entry_object(1, "dcol00")
	monster.register_entry_object(2, "dcol01")
	monster.register_entry_object(3, "dcol02")
	monster.register_entry_object(4, "dcol03")
	monster.register_damage_hit("敵基本１", 4.5, "攻撃１", 0.3, 0.4, 0)
	monster.register_damage_hit("敵基本１", 4.5, "攻撃１", 0.42, 0.56, 1)
	monster.register_damage_hit("敵基本１", 5.5, "避け攻撃", 0.0, 1.0, 3)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		low_effect_loaded = monster.load_effect_script("毒液L", free_texture_block) or low_effect_loaded
		high_effect_loaded = monster.load_effect_script("毒液H", free_texture_block) or high_effect_loaded
		if (if low_effect_loaded ~= 0 then 1 else high_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
end

--- Approaches and attacks the target, or wanders when it is far away.
function script.loop()
	local rage_hits_left: s32 = 0
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left ~= 0 then
		behavior.face_target_if_transformed_medium()
		while true do
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 200.0 then
				approach_target()
				attack_when_close()
			elseif reaction.is_guard_active() ~= 0 then
				approach_target()
				attack_when_close()
			else
				wander_when_idle()
			end
		end
	else
		fight_when_rage_hits_exhausted()
	end
end

--- Holds the monster in its damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers the monster back when it takes a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the monster over and gets it back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_with_guard_update(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Makes the monster guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	state.unlock()
end

--- Dodges with a lunge, a hop back or a dodge motion.
function script.on_dodge_1()
	local position_y: f32 = 0
	local roll: s32 = 0
	local roll_2: s32 = 0
	local position_x_2: f32 = 0
	local position_z_2: f32 = 0
	state.lock_and_reset_motion()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.face_target_instantly()
	reaction.update_and_wait_frame()
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	roll = monster.get_random(100) or roll
	if roll > 50 then
		dodge_and_lunge()
	else
		roll_2 = monster.get_random(100) or roll_2
		if roll_2 > 50 then
			monster.set_motion("ステップ後", -1, 2)
			do
				local out1, _, out3 = monster.get_point_from_facing(3.1415927, 40.0)
				position_x_2 = out1 or position_x_2
				position_z_2 = out3 or position_z_2
			end
			timer.wait_frames_with_guard_update(10)
			monster.move_toward_position(position_x_2, position_y - 20.0, position_z_2, 4.5, 2.0)
			motion.wait_until_finished_guarded()
		else
			monster.set_motion("避けin", -1, 6)
			motion.wait_until_finished_guarded()
			monster.set_motion("避け戻り", -1, 6)
			motion.wait_until_finished_guarded()
		end
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Dodges with a lunge or a dodge motion.
function script.on_dodge_2()
	local position_y: f32 = 0
	local roll: s32 = 0
	local roll_2: s32 = 0
	local position_x_2: f32 = 0
	local position_z_2: f32 = 0
	local roll_3: s32 = 0
	state.lock_and_reset_motion()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.face_target_instantly()
	reaction.update_and_wait_frame()
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	roll = monster.get_random(100) or roll
	if roll > 70 then
		dodge_and_lunge()
	else
		roll_2 = monster.get_random(100) or roll_2
		if roll_2 > 100 then
			roll_3 = monster.get_random(100) or roll_3
			if roll_3 > 50 then
				monster.set_motion("ステップ左", -1, 6)
				do
					local out1, _, out3 = monster.get_point_from_facing(1.5707964, 30)
					position_x_2 = out1 or position_x_2
					position_z_2 = out3 or position_z_2
				end
			else
				monster.set_motion("ステップ右", -1, 6)
				do
					local out1, _, out3 = monster.get_point_from_facing(-1.5707964, 30)
					position_x_2 = out1 or position_x_2
					position_z_2 = out3 or position_z_2
				end
			end
			timer.wait_frames_with_guard_update(5)
			monster.move_toward_position(position_x_2, position_y - 20.0, position_z_2, 3.0, 5.0)
			movement.wait_until_move_finished(20)
		else
			monster.set_motion("避けin", -1, 6)
			motion.wait_until_finished_guarded()
			monster.set_motion("避け戻り", -1, 6)
			motion.wait_until_finished_guarded()
		end
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Plays the monster's death animation and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Makes the monster struggle while it is held by the player.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Gets the monster back on its feet after it lands from a throw.
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

--- Staggers the monster and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
