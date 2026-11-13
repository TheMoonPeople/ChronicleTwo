--!strict
--- Drives the Shingala boss that spits, strikes, roars and spawns a fish while roaming its arena.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local movement = require("@lib/monster/movement")
local state = require("@lib/monster/state")

--- Stores the current dungeon timer in the numbered mark slot.
local function record_timer_mark(mark_index: s32)
	local timer: s32 = 0
	timer = monster.get_dungeon_timer() or timer
	monster.set_variable(vm.i32(14 + mark_index), timer)
end

--- Sets the clip distance to a short range for ordinary monsters and a long range for bosses.
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

--- Accumulates the life lost since the last check into the recent and total damage counters.
local function track_damage_taken()
	local life: s32 = 0
	local previous_life: s32 = 0
	local life_lost: s32 = 0
	local recent_damage: s32 = 0
	local total_damage: s32 = 0
	life = 0
	previous_life = 0
	recent_damage = 0
	total_damage = 0
	monster.get_character_number()
	life = monster.get_monster_life(-1) or life
	previous_life = monster.get_variable(12) or previous_life
	life_lost = vm.i32(previous_life - life)
	monster.set_variable(12, life)
	recent_damage = monster.get_variable(11) or recent_damage
	monster.set_variable(11, vm.i32(recent_damage + life_lost))
	total_damage = monster.get_variable(13) or total_damage
	monster.set_variable(13, vm.i32(total_damage + life_lost))
end

--- Returns the dungeon time elapsed since the numbered mark was recorded.
local function get_elapsed_since_mark(mark_index: s32)
	local elapsed: s32 = 0
	local mark_time: s32 = 0
	elapsed = monster.get_dungeon_timer() or elapsed
	mark_time = monster.get_variable(vm.i32(14 + mark_index)) or mark_time
	elapsed = vm.i32(elapsed - mark_time)
	return elapsed
end

--- Requests the hint event once when the fight has lasted long enough.
local function request_hint_event_after_delay()
	local hint_requested: s32 = 0
	hint_requested = monster.get_variable(20) or hint_requested
	if hint_requested == 0 and get_elapsed_since_mark(0) > 900 then
		monster.request_event_script(550)
		monster.set_variable(20, 1)
	end
end

--- Updates the damage counters and the hint timer.
local function update_fight_state()
	track_damage_taken()
	request_hint_event_after_delay()
end

--- Updates the fight state and waits one frame.
local function wait_frame_with_updates()
	update_fight_state()
	vm.wait()
end

--- Waits until the monster's yaw is within tolerance of the given angle or the frame limit is reached, and returns the frames waited.
local function wait_until_facing(target_angle_degrees: f32, turn_speed_degrees: f32, max_frames: f32)
	local current_yaw: f32 = 0
	local frames_waited: f32 = 0
	local frame_limit: f32 = 0
	local tolerance: f32 = 0
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	frame_limit = max_frames
	if turn_speed_degrees < 3.0 then
		tolerance = calc.degrees_to_radians(3.0)
	else
		tolerance = turn_speed_degrees
	end
	frames_waited = 0.0
	while frames_waited < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_yaw = out2 or current_yaw
		end
		if current_yaw > vm.f32(target_angle_degrees - tolerance) and current_yaw < vm.f32(target_angle_degrees + tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle_degrees, current_yaw, turn_speed_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frames_waited >= max_frames then
			movement.stop_turning()
			break
		else
			wait_frame_with_updates()
			frames_waited = vm.f32(frames_waited + 1.0)
		end
	end
	movement.stop_turning()
	return frames_waited
end

--- Turns toward the target at the given speed and waits until it is facing it.
local function turn_to_face_target(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Chases the target at the given speed until it is within the stop distance or the frame limit is reached.
local function chase_target(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local frame: s32 = 0
	turn_to_face_target(rot_speed)
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	frame = 0
	while frame < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(destination_x, destination_y, destination_z, pos_x, pos_y, pos_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(destination_x, destination_y, destination_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, move_speed + stop_distance)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(destination_x, destination_y, destination_z, pos_x, pos_y, pos_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		monster.move_toward_position(destination_x, pos_y - 20.0, destination_z, move_speed, move_speed)
		wait_frame_with_updates()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Waits until the current motion reaches the given progress within a tolerance or finishes.
local function wait_for_motion_progress(target_progress: f32, tolerance: f32)
	local motion_progress: f32 = 0
	local frame_count: s32 = 0
	local motion_finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		wait_frame_with_updates()
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(target_progress + tolerance) and motion_progress > vm.f32(target_progress - tolerance) then
			break
		else
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

--- Waits until the current motion finishes.
local function wait_for_motion_end()
	local motion_finished: s32 = 0
	while true do
		wait_frame_with_updates()
		motion_finished = monster.is_motion_finished() or motion_finished
		if motion_finished ~= 0 then
			return
		end
	end
end

--- Turns toward the target and spits the projectile effect during the first attack motion.
local function attack_spit()
	local height: f32 = 0
	local slot: s32 = 0
	local chara_type: s32 = 0
	local attack: s32 = 0
	monster.set_motion("歩き", 0.9, 0)
	turn_to_face_target(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 2)
	wait_for_motion_progress(vm.f32(0.206), -1.0)
	height = monster.get_height_above_ground() or height
	chara_type = monster.get_character_number() or chara_type
	attack = monster.get_attack_power_1() or attack
	slot = monster.create_effect_2("シグー吐き") or slot
	monster.set_variable(14, slot)
	monster.set_effect_owner(-1, chara_type)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, height)
	monster.set_effect_value(slot, 3, 0)
	wait_for_motion_progress(vm.f32(0.927), -1.0)
	monster.set_effect_value(slot, 3, 1)
	monster.set_variable(14, -2)
	wait_for_motion_end()
	monster.set_motion("立ち", -1, 0)
end

--- Turns toward the target and plays the knockback attack when it is not below the floor.
local function attack_knockback_strike()
	local pos_y: f32 = 0
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	if pos_y >= -5.0 then
		monster.set_motion("歩き", 0.9, 0)
		turn_to_face_target(vm.f32(4.2))
		monster.set_motion("攻撃２", -1, 2)
		wait_for_motion_end()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Waits the given number of frames with state updates.
local function wait_frames(frame_count: any)
	local frame: s32 = 0
	frame = 0
	while frame < frame_count do
		wait_frame_with_updates()
		frame = vm.i32(frame + 1)
	end
end

--- Creates the fish monster at one of three random points.
local function spawn_fish_at_random_point()
	local point_index: s32 = 0
	local spawn_x: f32 = 0
	local spawn_y: f32 = 0
	local spawn_z: f32 = 0
	point_index = monster.get_random(3) or point_index
	if point_index == 0 then
		spawn_x = vm.f32(-146.3)
		spawn_y = vm.f32(190.98)
		spawn_z = vm.f32(856.53)
	end
	if point_index == 1 then
		spawn_x = vm.f32(358.6)
		spawn_y = vm.f32(202.17)
		spawn_z = vm.f32(718.47)
	end
	if point_index == 2 then
		spawn_x = vm.f32(402.76)
		spawn_y = vm.f32(402.76)
		spawn_z = vm.f32(729.47)
	end
	monster.create_monster(1001, spawn_x, spawn_y, spawn_z)
end

--- Finishes the spit effect if one is active.
local function finish_spit_effect()
	local effect_slot: s32 = 0
	effect_slot = monster.get_variable(14) or effect_slot
	if effect_slot ~= -2 then
		monster.finish_effect(effect_slot)
		monster.set_variable(14, -2)
	end
end

--- Faces the target and plays the threat roar for the given frames, then returns zero.
local function roar_at_target(duration_frames: s32)
	monster.set_variable(20, 1)
	finish_spit_effect()
	monster.get_position_3()
	monster.set_motion("歩き", 0.9, 0)
	turn_to_face_target(vm.f32(4.2))
	monster.set_variable(0, 32)
	monster.set_variable(8, 32)
	monster.set_motion("威嚇入り", -1, 2)
	wait_for_motion_end()
	monster.set_motion("威嚇Ｌ", -1, 0)
	wait_frames(calc.pass_through(duration_frames))
	monster.set_motion("威嚇戻り", -1, 2)
	wait_for_motion_progress(vm.f32(0.408), -1.0)
	monster.set_variable(0, 0)
	monster.set_variable(8, 0)
	wait_for_motion_end()
	monster.set_motion("立ち", -1, 0)
	return 0
end

--- Walks toward the target inside the arena until it is close, out of the arena or out of frames.
local function walk_toward_target(move_speed: f32, turn_speed_degrees: any, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local target_angle: f32 = 0
	local turn_speed: f32 = 0
	local arena_center_x: f32 = 0
	local arena_center_z: f32 = 0
	local center_distance: f32 = 0
	local target_distance: f32 = 0
	local frame: s32 = 0
	turn_to_face_target(vm.f32(4.2))
	turn_speed = calc.degrees_to_radians(turn_speed)
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(target_x, target_y, target_z, offset_x, offset_y, offset_z)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		target_angle = monster.get_angle_to_position(target_x, target_y, target_z) or target_angle
		target_angle = monster.get_target_angle() or target_angle
		arena_center_x = vm.f32(-33.22)
		arena_center_z = 763.5
		center_distance = monster.get_distance_between(arena_center_x, 0.0, arena_center_z, target_x, 0.0, target_z) or center_distance
		if center_distance > 380.0 then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		monster.move_toward_position(target_x, target_y, target_z, move_speed, move_speed)
		monster.set_rotation(0.0, target_angle, 0.0)
		wait_frame_with_updates()
		frame = frame + 1
	end
	monster.stop_moving()
end

--- Turns to the given angle at the given speed and waits until it is facing it.
local function turn_to_angle(next_rot: f32, rot_speed: f32)
	next_rot = calc.degrees_to_radians(next_rot)
	if next_rot > vm.f32(3.1415927) then
		next_rot = vm.f32(next_rot - vm.f32(6.2831855))
	end
	if next_rot <= vm.f32(-3.1415927) then
		next_rot = vm.f32(next_rot + vm.f32(6.2831855))
	end
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(next_rot, rot_speed)
	local _ = wait_until_facing(
		calc.radians_to_degrees(next_rot),
		calc.radians_to_degrees(rot_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(rot_speed)))
	)
	movement.stop_turning()
end

--- Waits until the current move finishes, the target is close or the frame limit is reached.
local function wait_until_move_done(stop_distance: f32, max_frames: any)
	local frame: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	frame = 0
	while frame < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			monster.stop_moving()
			return
		end
		if arrived == 0 then
			wait_frame_with_updates()
		else
			monster.stop_moving()
			return
		end
		if arrived == 1 then
			monster.stop_moving()
			return
		end
		frame = vm.i32(frame + 1)
	end
end

--- Walks to one of three random retreat points and turns back toward the target.
local function retreat_to_random_point()
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local destination_angle: f32 = 0
	local point_index: s32 = 0
	monster.set_variable(0, 64)
	point_index = monster.get_random(3) or point_index
	if point_index == 0 then
		destination_x = vm.f32(-236.58)
		destination_y = vm.f32(-34.97)
		destination_z = vm.f32(336.42)
	end
	if point_index == 1 then
		destination_x = vm.f32(313.89)
		destination_y = vm.f32(-24.87)
		destination_z = vm.f32(452.05)
	end
	if point_index == 2 then
		destination_x = vm.f32(39.48)
		destination_y = vm.f32(-23.78)
		destination_z = vm.f32(405.92)
	end
	destination_angle = monster.get_angle_to_position(destination_x, destination_y - 100.0, destination_z) or destination_angle
	monster.set_motion("歩き", -1, 0)
	turn_to_angle(calc.radians_to_degrees(destination_angle), vm.f32(4.2))
	monster.move_toward_position(destination_x, destination_y, destination_z, 2.4, 3.6000001)
	wait_until_move_done(0.0, calc.pass_through(600))
	monster.stop_moving()
	monster.set_variable(0, 16)
	monster.set_motion("歩き", -1, 0)
	turn_to_face_target(vm.f32(4.2))
	monster.set_motion("立ち", -1, 0)
end

--- Picks and performs the next attack in the cycle, including the roar and fish spawning after heavy damage.
local function perform_attack_cycle()
	local cycle_count: s32 = 0
	local roll: s32 = 0
	local cycle_step: s32 = 0
	local recent_damage: s32 = 0
	local roar_result: s32 = 0
	local monster_count: s32 = 0
	cycle_step = monster.get_variable(3) or cycle_step
	recent_damage = monster.get_variable(11) or recent_damage
	monster.get_variable(13)
	if recent_damage > 150 then
		monster.set_motion("歩き", -1, 0)
		turn_to_face_target(vm.f32(4.2))
		attack_knockback_strike()
		monster_count = monster.get_monster_count() or monster_count
		if monster_count == 1 then
			spawn_fish_at_random_point()
		end
		roar_result = roar_at_target(210)
		if roar_result == 0 then
			monster.set_variable(11, 0)
		end
	end
	track_damage_taken()
	if cycle_step == 0 then
		monster.set_variable(3, 1)
		monster.set_motion("歩き", -1, 0)
		walk_toward_target(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
		attack_spit()
	end
	track_damage_taken()
	if cycle_step == 1 then
		monster.set_variable(3, 2)
		monster.set_motion("歩き", -1, 0)
		walk_toward_target(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
		attack_knockback_strike()
	end
	track_damage_taken()
	if cycle_step == 2 then
		monster.set_variable(3, 3)
	end
	track_damage_taken()
	if cycle_step == 3 then
		roll = monster.get_random(100) or roll
		if roll < 10 then
			retreat_to_random_point()
			monster.set_motion("立ち", -1, 0)
			roll = monster.get_random(30) or roll
			wait_frames(calc.pass_through(vm.i32(30 + roll)))
		else
			monster.set_motion("歩き", -1, 0)
			walk_toward_target(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
			attack_knockback_strike()
		end
		monster.set_variable(3, 4)
		roll = monster.get_random(100) or roll
		if roll < 30 then
			monster.set_motion("歩き", -1, 0)
			walk_toward_target(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
			attack_spit()
		end
	end
	track_damage_taken()
	if cycle_step == 4 then
		monster.set_variable(3, 0)
		roll = monster.get_random(100) or roll
		if roll < 20 then
			monster.set_motion("歩き", -1, 0)
			turn_to_face_target(vm.f32(4.2))
			attack_spit()
		end
	end
	monster.set_variable(2, cycle_count + 1)
end

--- Stops all movement and motion and faces the target to start a forced reaction.
local function begin_forced_reaction()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	wait_frame_with_updates()
	monster.set_action_status(1)
end

--- Clears the held attribute and ends the throw, then resets the motion.
local function recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers its damage hits and spit effect, resets its counters and spawns the fish.
function script.init()
	local life: s32 = 0
	local monster_count: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 12.0, "攻撃２", 0.216, 0.432, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 12.0, "攻撃２", 0.216, 0.432, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 10.0, "攻撃１", 0.418, 0.655, 3)
	monster.set_photo_opportunity(1016)
	monster.load_effect_script("シグー吐き")
	monster.get_character_number()
	life = 0
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	monster.set_variable(4, 0)
	monster.set_variable(8, 0)
	monster.set_variable(9, 0)
	monster.set_variable(14, -2)
	monster.set_variable(20, 0)
	monster.reset_dungeon_timer()
	record_timer_mark(0)
	monster.get_character_number()
	life = monster.get_monster_life(-1) or life
	monster.set_variable(12, life)
	monster.set_variable(11, 0)
	monster.set_variable(13, 0)
	monster.set_clip_distance(9999.9)
	monster.set_monster_attributes(128, 1)
	monster.set_camera_mode(0)
	monster_count = monster.get_monster_count() or monster_count
	if monster_count == 1 then
		monster.create_monster(1001, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	end
	monster.set_camera_mode(4)
	configure_clip_distance()
end

--- Walks into the arena, then attacks, keeps within the arena and spawns the fish.
function script.loop()
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local center_distance: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local intro_done: s32 = 0
	local monster_count: s32 = 0
	local roll: s32 = 0
	local return_roll: s32 = 0
	local center_angle: f32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	intro_done = monster.get_variable(9) or intro_done
	if intro_done == 0 then
		monster.set_motion("歩き", 0.75, 0)
		chase_target(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
		monster.set_motion("立ち", -1, 0)
		monster.set_variable(9, 1)
	end
	center_x = vm.f32(-33.22)
	center_y = vm.f32(3.88)
	center_z = 763.5
	while true do
		wait_frame_with_updates()
		do
			local out1, _, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		center_distance = monster.get_distance_between(pos_x, 0.0, pos_z, center_x, 0.0, center_z) or center_distance
		print("dist=", vm.float(center_distance), "---------------\n")
		if center_distance > 380.0 then
			roll = monster.get_random(100) or roll
			if roll < 15 then
				attack_spit()
			else
				if roll >= 15 and roll < 30 then
					attack_knockback_strike()
				end
				if roll > 30 and roll < 50 then
					monster.set_motion("歩き", 0.9, 0)
					turn_to_face_target(vm.f32(4.2))
				end
			end
			return_roll = monster.get_random(100) or return_roll
			if return_roll < 50 then
				monster.set_motion("歩き", 0.75, 0)
				for frame = 0, 89 do
					center_angle = monster.get_angle_to_position(center_x, center_y, center_z) or center_angle
					monster.move_toward_position(center_x, center_y, center_z, 2.4, 2.4)
					monster.turn_toward_angle(center_angle, calc.degrees_to_radians(vm.f32(4.2)))
					wait_frame_with_updates()
				end
				monster.stop_moving()
			end
			monster.set_motion("立ち", -1, 0)
			wait_frames(30)
			continue
		end
		perform_attack_cycle()
		monster_count = monster.get_monster_count() or monster_count
		if monster_count == 1 then
			spawn_fish_at_random_point()
		end
	end
end

--- Plays the damage motion with knockback and counts the hit.
function script.on_damage()
	local hit_count: s32 = 0
	state.stop_and_clear_action()
	finish_spit_effect()
	hit_count = monster.get_variable(4) or hit_count
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	wait_for_motion_end()
	wait_frames(12)
	monster.set_motion("立ち")
	monster.set_variable(4, vm.i32(hit_count + 1))
	state.do_nothing()
end

--- Cancels the spit effect and recovers from the forced reaction.
function script.on_knockdown()
	begin_forced_reaction()
	finish_spit_effect()
	state.unlock_and_clear_action()
end

--- Cancels the spit effect and recovers from the guard.
function script.on_guard()
	state.lock_and_stop_moving()
	finish_spit_effect()
	state.unlock()
end

--- Cancels the spit effect and recovers from the dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	finish_spit_effect()
	state.unlock()
end

--- Cancels the spit effect and recovers from the dodge.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	finish_spit_effect()
	state.unlock()
end

--- Cancels the spit effect, requests the defeat event and waits forever.
function script.on_death()
	finish_spit_effect()
	monster.request_event_script(510)
	death.begin()
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(32, 1)
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Cancels the spit effect and plays the struggling motion while held.
function script.on_caught()
	finish_spit_effect()
	monster.set_motion("じたばた", -1, 4)
	while true do
		wait_frame_with_updates()
	end
end

--- Recovers the monster after a throw and stands it back up.
function script.on_land()
	recover_from_throw()
	finish_spit_effect()
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	wait_for_motion_end()
	state.do_nothing_hook()
	return 1
end

--- Checks whether the stun hit the fish near its head and reacts with the roar event or counters the hit.
function script.on_stun()
	local nearest_pos_x: f32 = 0
	local nearest_pos_y: f32 = 0
	local nearest_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local fish_distance: f32 = 0
	local mode: s32 = 0
	local hit_count: s32 = 0
	local effect_slot: s32 = 0
	monster.stop_moving()
	movement.stop_turning()
	monster.reset_motion()
	mode = monster.get_variable(0) or mode
	if mode == 64 then
		return
	end
	do
		local out1, out2, out3 = monster.get_frame_position("sakana")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3, out4 = monster.get_nearest_monster_position()
		nearest_pos_x = out1 or nearest_pos_x
		nearest_pos_y = out2 or nearest_pos_y
		nearest_pos_z = out3 or nearest_pos_z
		fish_distance = out4 or fish_distance
	end
	effect_slot = monster.get_variable(5) or effect_slot
	monster.finish_effect(effect_slot)
	fish_distance = monster.get_distance_between(pos_x, pos_y, pos_z, nearest_pos_x, nearest_pos_y, nearest_pos_z) or fish_distance
	if fish_distance < 60.0 then
		mode = monster.get_variable(0) or mode
		hit_count = monster.get_variable(1) or hit_count
		if mode == 32 then
			finish_spit_effect()
			monster.set_variable(8, 128)
			monster.request_event_script(500)
			wait_frame_with_updates()
		else
			monster.set_motion("歩き", 0.9, 0)
			turn_to_face_target(vm.f32(4.2))
			attack_knockback_strike()
			monster.set_motion("歩き", 0.9, 0)
			turn_to_face_target(vm.f32(4.2))
			attack_knockback_strike()
			hit_count = vm.i32(hit_count + 2)
			monster.set_variable(1, hit_count)
		end
		print("hit head-------------\n")
	elseif fish_distance < 90.0 then
		print("osii-----\n")
		hit_count = hit_count + 1
		monster.set_variable(1, hit_count)
	end
end

return script
