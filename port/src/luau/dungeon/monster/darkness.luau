--!strict
--- Drives the Darkness family: shadow monsters that lunge at the target and turn toward a transformed player.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard threshold, secondary parameters and clip distance shared by this monster's variants.
local function set_default_parameters()
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

--- Keeps facing the target for as long as the player stays transformed.
local function face_target_while_player_transformed(monster_kind: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		timer.wait_frame_with_lighting()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_with_lighting(5.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Faces the target when the player is transformed.
local function face_target_if_player_transformed()
	local transform_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		face_target_while_player_transformed(monster_id)
	end
end

--- Turns toward and walks to a point near the target, returning the arrival result or -1 when blocked.
local function walk_to_point_near_target(move_speed: f32, turn_speed: f32, offset_angle: f32, offset_distance: f32, arrival_distance: f32, max_frames: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local result: s32 = 0
	point_x, point_y, point_z = movement.get_approach_point(offset_angle, offset_distance, point_x, point_y, point_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	offset_angle = monster.get_angle_to_position(point_x, point_y, point_z) or offset_angle
	if offset_angle > vm.f32(3.1415927) then
		offset_angle = vm.f32(offset_angle - vm.f32(6.2831855))
	end
	if offset_angle <= vm.f32(-3.1415927) then
		offset_angle = vm.f32(offset_angle + vm.f32(6.2831855))
	end
	movement.turn_to_angle_with_lighting(calc.radians_to_degrees(offset_angle), turn_speed)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(point_x, point_y, point_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
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
	clear_distance = monster.get_clear_distance(move_speed + arrival_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + arrival_distance) then
		point_x = vm.f32(position_x + vm.f32(vm.sin(offset_angle) * clear_distance))
		point_y = position_y
		point_z = vm.f32(position_z + vm.f32(vm.cos(offset_angle) * clear_distance))
		clear_distance = vm.f32(clear_distance - arrival_distance)
		if clear_distance < arrival_distance then
			return -1
		end
	end
	monster.move_toward_position(point_x, position_y - 20.0, point_z, move_speed, move_speed)
	result = movement.wait_until_arrived_with_lighting(arrival_distance, max_frames)
	monster.stop_moving()
	return result
end

--- Plays the idle motion for a number of intervals, optionally returning 1 when the target steps into view.
local function play_idle_and_watch(intervals: s32, watch_for_target: s32)
	local i: s32 = 0
	local found_target: s32 = 0
	i = 0
	monster.set_motion("遊び", -1, 0)
	while i < intervals do
		if watch_for_target == 1 then
			found_target = sense.wait_until_target_in_arc_with_lighting(75.0, 45.0, calc.pass_through(84))
			if found_target == 1 then
				return found_target
			end
		else
			found_target = 0
			timer.wait_frames_with_lighting(calc.pass_through(84))
		end
		i = i + 1
	end
	return 0
end

--- Keeps turning toward the target until the current motion ends.
local function turn_toward_target_until_motion_finishes(rot_speed: f32)
	local target_angle: f32 = 0
	local is_finished: s32 = 0
	rot_speed = calc.degrees_to_radians(rot_speed)
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		timer.wait_frame_with_lighting()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			movement.stop_turning()
			break
		end
	end
end

--- Winds up, lunges past the target for a number of frames and recovers.
local function perform_lunge_attack(lunge_frames: s32)
	local target_x: f32 = 0
	local unassigned_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local target_distance: f32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 2)
	turn_toward_target_until_motion_finishes(5.0)
	monster.set_motion("攻撃１", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	target_distance = monster.get_target_distance() or target_distance
	target_x = vm.f32(position_x + vm.f32(vm.f32(vm.sin(rotation_y) * target_distance) * 2.0))
	target_z = vm.f32(position_z + vm.f32(vm.f32(vm.cos(rotation_y) * target_distance) * 2.0))
	monster.move_toward_position(target_x, unassigned_y - 10.0, target_z, 4.8, 4.8)
	timer.wait_frames_with_lighting(lunge_frames)
	monster.stop_moving()
	monster.reset_motion()
	monster.set_motion("攻撃１out", -1, 2)
	motion.wait_until_finished_with_lighting()
end

--- Steps away from the target, then idles, lunges or stands.
local function step_back_and_follow_up(move_speed: f32, retreat_offset: f32)
	local current_y: f32 = 0
	local roll: s32 = 0
	local extra_frames: s32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra: f32 = 0
	extra_frames = monster.get_random(2) or extra_frames
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		point_x = out1 or point_x
		point_z = out3 or point_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	retreat_distance = vm.f32(retreat_distance + vm.f32(retreat_offset + random_extra))
	point_x, point_y, point_z = movement.get_approach_point(0.0, retreat_distance, point_x, point_y, point_z)
	monster.set_motion("ステップ後", -1, 6)
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(point_x, current_y, point_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_lighting(vm.i32(1 + extra_frames))
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_with_lighting()
	monster.stop_moving()
	roll = monster.get_random(100) or roll
	if roll < 25 then
		play_idle_and_watch(1, 1)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
			perform_lunge_attack(30)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_lighting(3)
		else
			monster.set_motion("立ち", -1)
		end
	end
end

--- Walks toward the target frame by frame until it is within the stop distance or the frames run out.
local function approach_target(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local i: s32 = 0
	movement.turn_toward_target_and_wait_with_lighting(rot_speed)
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	i = 0
	while i < max_frames do
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
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(vector_x, vector_y, vector_z, position_x, position_y, position_z)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(vector_x, vector_y, vector_z)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(vector_x, vector_y, vector_z, move_speed + stop_distance)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(vector_x, vector_y, vector_z, position_x, position_y, position_z)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		monster.move_toward_position(vector_x, position_y - 20.0, vector_z, move_speed, move_speed)
		timer.wait_frame_with_lighting()
		i = i + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Hovers near the target at a random offset or waits for it to face the monster while another monster holds the attack priority.
local function wait_for_turn()
	local roll: s32 = 0
	local result: s32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc_with_lighting(30.0, 45.0, 30)
	else
		-- retail: the script tests this condition again, so its branch never runs
		if roll < 50 then
			roll = monster.get_random(100) or roll
			offset_angle = monster.get_random_whole_number(30.0) or offset_angle
			offset_distance = monster.get_random_whole_number(30.0) or offset_distance
			offset_distance = vm.f32(offset_distance + 90.0)
			if roll < 50 then
				offset_angle = vm.f32(-offset_angle - 30.0)
			else
				offset_angle = vm.f32(offset_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			result = walk_to_point_near_target(2.0, 5.0, offset_angle, offset_distance, 30.0, 30)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
		elseif roll < 40 then
			roll = monster.get_random(2) or roll
			result = play_idle_and_watch(vm.i32(1 + roll), 1)
			if result == 1 then
				roll = monster.get_random(100) or roll
				if roll < 10 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_with_lighting(5.0)
					step_back_and_follow_up(vm.f32(2.4), 25.0)
				else
					monster.set_motion("歩き", -1, 0)
					approach_target(3.0, 5.0, 30.0, 30)
					movement.turn_toward_target_and_wait_with_lighting(5.0)
					perform_lunge_attack(30)
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_lighting(3)
				end
			end
		end
	end
end

--- Turns by a random angle and walks a random distance, stopping short of obstacles.
local function wander(move_speed: f32, turn_speed: f32, base_distance: f32, turn_range: f32, distance_range: f32, arrival_distance: f32, max_frames: s32)
	local current_y: f32 = 0
	local heading: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local wander_distance: f32 = 0
	local random_turn: f32 = 0
	local new_rotation: f32 = 0
	local clear_distance: f32 = 0
	turn_range = calc.degrees_to_radians(turn_range)
	wander_distance = monster.get_random_whole_number(distance_range) or wander_distance
	random_turn = monster.get_random_whole_number(turn_range) or random_turn
	do
		local out1, _, out3 = monster.get_position_3()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		new_rotation = out2 or new_rotation
	end
	new_rotation = vm.f32(new_rotation + calc.degrees_to_radians(random_turn))
	movement.turn_to_angle_with_lighting(calc.radians_to_degrees(new_rotation), turn_speed)
	movement.stop_turning()
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance == 100.0 then
		wander_distance = vm.f32(wander_distance + vm.f32(base_distance + move_speed))
		target_x = vm.f32(target_x + vm.f32(wander_distance * vm.sin(heading)))
		target_z = vm.f32(target_z + vm.f32(wander_distance * vm.cos(heading)))
	else
		clear_distance = vm.f32(clear_distance - arrival_distance)
		if clear_distance > 0.0 then
			target_x = vm.f32(target_x + vm.f32(wander_distance * vm.sin(heading)))
			target_z = vm.f32(target_z + vm.f32(wander_distance * vm.cos(heading)))
		else
			return
		end
	end
	if wander_distance < move_speed then
		wander_distance = vm.f32(wander_distance + move_speed)
	end
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(target_x, current_y - 20.0, target_z, move_speed, move_speed)
	local _ = movement.wait_until_arrived_with_lighting(arrival_distance, max_frames)
	monster.stop_moving()
end

--- Picks a far-range action: approaching the target, waiting or wandering.
local function act_at_far_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 85 then
			monster.set_motion("歩き", -1, 0)
			approach_target(2.0, 5.0, 90.0, 25)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc_with_lighting(30.0, 45.0, 30)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", -1, 0)
			wander(2.0, 5.0, 30.0, 180.0, 30.0, 90.0, 25)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Plays the second and first attack motions in a row, sometimes rushing forward.
local function perform_combo_attack()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 4)
	timer.wait_frames_with_lighting(calc.pass_through(72))
	monster.set_motion("攻撃１", -1, 0)
	if roll < 50 then
		timer.wait_frames_with_lighting(calc.pass_through(15))
	else
		movement.rush_forward_with_lighting(6.0, 5.0, 1.0, calc.pass_through(15))
	end
	monster.reset_motion()
	monster.set_motion("攻撃１out", -1, 6)
	motion.wait_until_finished_with_lighting()
	monster.reset_motion()
	monster.set_motion("立ち", -1, 4)
end

--- Picks a mid-range action: idling and lunging, a combo, a stare or a flanking walk.
local function act_at_mid_range()
	local roll: s32 = 0
	local result: s32 = 0
	local offset_angle: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 40 then
			roll = monster.get_random(2) or roll
			result = play_idle_and_watch(vm.i32(1 + roll), 1)
			if result == 1 then
				roll = monster.get_random(100) or roll
				if roll < 10 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_with_lighting(5.0)
					step_back_and_follow_up(vm.f32(2.4), 25.0)
				else
					monster.set_motion("歩き", -1, 0)
					approach_target(3.0, 5.0, 30.0, 30)
					movement.turn_toward_target_and_wait_with_lighting(5.0)
					perform_lunge_attack(30)
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_lighting(3)
				end
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
			perform_combo_attack()
			timer.wait_frames_with_lighting(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc_with_lighting(90.0, 45.0, 30)
		else
			roll = monster.get_random(100) or roll
			offset_angle = monster.get_random_whole_number(30.0) or offset_angle
			if roll < 50 then
				offset_angle = vm.f32(-offset_angle - 30.0)
			else
				offset_angle = vm.f32(offset_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			result = walk_to_point_near_target(2.0, 5.0, offset_angle, 60.0, 30.0, 40)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
			if result == 1 then
				perform_lunge_attack(20)
			end
		end
	end
end

--- Steps to one side of the target, then lunges if it is close.
local function sidestep_and_follow_up(move_speed: f32, step_angle_degrees: f32)
	local extra_frames: s32 = 0
	local side_roll: s32 = 0
	local target_x: f32 = 0
	local point_y: f32 = 0
	local target_z: f32 = 0
	local current_y: f32 = 0
	local target_distance: f32 = 0
	local step_angle: f32 = 0
	local attack_roll: s32 = 0
	extra_frames = monster.get_random(2) or extra_frames
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	side_roll = monster.get_random(100) or side_roll
	if side_roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		step_angle = step_angle_degrees
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		step_angle = -step_angle_degrees
	end
	target_x, point_y, target_z = movement.get_approach_point(step_angle, target_distance, target_x, point_y, target_z)
	timer.wait_frames_with_lighting(vm.i32(1 + extra_frames))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(target_x, current_y - 10.0, target_z, move_speed, move_speed)
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_with_lighting()
	monster.stop_moving()
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 90.0 then
		attack_roll = monster.get_random(100) or attack_roll
		if attack_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
			perform_lunge_attack(30)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_lighting(3)
		else
			monster.set_motion("立ち", -1)
		end
	else
		monster.set_motion("立ち", -1)
	end
end

--- Picks a close-range action: a lunge, a combo, a flanking walk or a step with follow-up.
local function act_at_close_range()
	local roll: s32 = 0
	local result: s32 = 0
	local life: f32 = 0
	local target_distance: f32 = 0
	local offset_angle: f32 = 0
	life = vm.bits_float(monster.get_life_int()) or life
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_with_lighting(5.0)
		perform_lunge_attack(20 + roll)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_lighting(3)
	else
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 30.0 then
			if life > 0.25 and life == 0.0 then
				monster.get_random(100, roll)
				monster.get_random_whole_number(30.0, offset_angle)
				if roll < 50 then
					offset_angle = vm.f32(-offset_angle - 30.0)
				else
					offset_angle = vm.f32(offset_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				result = walk_to_point_near_target(2.0, 5.0, offset_angle, 60.0, 30.0, 40)
				movement.turn_toward_target_and_wait_with_lighting(5.0)
				if result == 1 then
					perform_lunge_attack(20)
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_with_lighting(5.0)
				perform_combo_attack()
				timer.wait_frames_with_lighting(3)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_with_lighting(5.0)
				step_back_and_follow_up(2.0, 15.0)
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_lighting(2)
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_with_lighting(5.0)
				sidestep_and_follow_up(2.0, 15.0)
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_lighting(2)
				end
			end
		end
	end
end

--- Fights the target by distance until it leaves range or the rage counter runs out.
local function fight_target_cautiously()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		timer.wait_frame_with_lighting()
		face_target_if_player_transformed()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
			timer.wait_frame_with_lighting()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			timer.wait_frame_with_lighting()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			wait_for_turn()
			continue
		end
		if target_distance < 250.0 and target_distance >= 150.0 then
			act_at_far_range()
		elseif target_distance < 150.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
		timer.wait_frame_with_lighting()
	end
end

--- Turns to a direction and walks a distance along it.
local function turn_and_walk_in_direction(turn_speed: f32, move_speed: f32, direction: f32, distance: f32, arrival_distance: f32, max_frames: s32)
	local current_y: f32 = 0
	local target_x: f32 = 0
	local start_y: f32 = 0
	local target_z: f32 = 0
	direction = calc.degrees_to_radians(direction)
	if direction < calc.degrees_to_radians(turn_speed) then
		direction = vm.f32(direction + calc.degrees_to_radians(turn_speed))
	end
	movement.turn_to_angle_with_lighting(calc.radians_to_degrees(direction), turn_speed)
	movement.stop_turning()
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		target_x = out1 or target_x
		start_y = out2 or start_y
		target_z = out3 or target_z
	end
	target_x = vm.f32(target_x + vm.f32(vm.sin(direction) * distance))
	target_z = vm.f32(target_z + vm.f32(vm.cos(direction) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(target_x, current_y - 20.0, target_z, move_speed, move_speed + 1.0)
	local _ = movement.wait_until_arrived_with_lighting(arrival_distance, max_frames)
	monster.stop_moving()
end

--- Walks to a point on a circle around the given position.
local function move_around_position(
	center_x: f32,
	center_y: f32,
	center_z: f32,
	move_speed: f32,
	turn_speed: f32,
	radius: f32,
	offset_degrees: f32,
	arrival_distance: f32,
	max_frames: s32
)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local current_y: f32 = 0
	local offset_radians: f32 = 0
	local angle: f32 = 0
	offset_radians = vm.f32(offset_degrees * vm.f32(0.017453292))
	angle = monster.get_angle_to_position(center_x, center_y, center_z) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = vm.f32(angle + offset_radians)
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	point_x = vm.f32(center_x + vm.f32(radius * vm.sin(angle)))
	point_y = center_y
	point_z = vm.f32(center_z + vm.f32(radius * vm.cos(angle)))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	offset_degrees = monster.get_angle_to_position(point_x, point_y, point_z) or offset_degrees
	movement.turn_to_angle_with_lighting(calc.radians_to_degrees(offset_degrees), turn_speed)
	movement.stop_turning()
	monster.move_toward_position(point_x, current_y - 20.0, point_z, move_speed, move_speed)
	local _ = movement.wait_until_arrived_with_lighting(arrival_distance, max_frames)
	monster.stop_moving()
end

--- Walks a distance along a direction without turning first.
local function walk_in_direction(move_speed: f32, direction: f32, distance: f32, arrival_distance: f32, max_frames: s32)
	local current_y: f32 = 0
	local target_x: f32 = 0
	local start_y: f32 = 0
	local target_z: f32 = 0
	if distance < move_speed then
		distance = vm.f32(move_speed + 1.0)
	end
	direction = calc.degrees_to_radians(direction)
	if direction > vm.f32(3.1415927) then
		direction = vm.f32(direction - vm.f32(6.2831855))
	end
	if direction <= vm.f32(-3.1415927) then
		direction = vm.f32(direction + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		target_x = out1 or target_x
		start_y = out2 or start_y
		target_z = out3 or target_z
	end
	target_x = vm.f32(target_x + vm.f32(vm.sin(direction) * distance))
	target_z = vm.f32(target_z + vm.f32(vm.cos(direction) * distance))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(target_x, current_y, target_z, move_speed, move_speed + 1.0)
	movement.wait_until_arrived_with_lighting(arrival_distance, max_frames)
	monster.stop_moving()
end

--- Roams around the placement position by circling it, wandering or waiting for the target to threaten.
local function roam()
	local roll: s32 = 0
	local result: s32 = 0
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
	local circle_angle: f32 = 0
	local turn_after_walk: f32 = 0
	local offset_angle: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local turn_after_approach: f32 = 0
	timer.wait_frame_with_lighting()
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
		movement.turn_to_angle_with_lighting(turn_angle, 5.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			turn_and_walk_in_direction(5.0, 2.0, turn_angle, clear_distance, 30.0, 30)
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
				circle_angle = monster.get_random_whole_number(360.0) or circle_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					circle_angle = vm.f32(-circle_angle - 30.0)
				else
					circle_angle = vm.f32(circle_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				move_around_position(place_position_x, place_position_y, place_position_z, 2.0, 5.0, distance, circle_angle, 30.0, 60)
				turn_after_walk = monster.get_random_whole_number(180.0) or turn_after_walk
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_after_walk = vm.f32(turn_after_walk * -1.0)
				end
				movement.turn_to_angle_with_lighting(turn_after_walk, 5.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_with_lighting(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_with_lighting(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_with_lighting(turn_angle, 5.0)
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
					offset_angle = monster.get_random_whole_number(180.0) or offset_angle
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if roll < 50 then
						offset_angle = vm.f32(offset_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_angle = vm.f32(-offset_angle - 30.0)
					else
						offset_angle = vm.f32(offset_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					result = walk_to_point_near_target(2.0, 5.0, offset_angle, offset_distance, 30.0, 60)
					turn_after_approach = monster.get_random_whole_number(360.0) or turn_after_approach
					roll = monster.get_random(100) or roll
					if roll < 50 then
						turn_after_approach = vm.f32(turn_after_approach * -1.0)
					end
					movement.turn_to_angle_with_lighting(turn_after_approach, 5.0)
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
					walk_in_direction(2.0, turn_angle, 1000.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				result = sense.wait_until_target_threatening_with_lighting(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			wander(2.0, 5.0, distance, 360.0, 40.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Lunges at the target, approaches it again and lunges once more.
local function lunge_twice()
	perform_lunge_attack(60)
	monster.set_motion("歩き", -1, 0)
	approach_target(2.0, 5.0, 30.0, 90)
	monster.set_motion("立ち", -1, 0)
	perform_lunge_attack(60)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target aggressively once the rage counter has run out.
local function fight_target_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local current_distance: f32 = 0
	monster.get_life_int()
	while true do
		timer.wait_frame_with_lighting()
		target_distance = monster.get_target_distance() or target_distance
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			wait_for_turn()
			continue
		end
		if target_distance < 90.0 then
			if roll < 45 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_with_lighting(5.0)
				perform_lunge_attack(20 + roll)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_lighting(2)
			else
				current_distance = monster.get_target_distance() or current_distance
				if current_distance > 30.0 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_with_lighting(5.0)
					perform_combo_attack()
					timer.wait_frames_with_lighting(2)
				else
					roll = monster.get_random(100) or roll
					if roll < 60 then
						monster.set_motion("歩き", -1, 0)
						movement.turn_toward_target_and_wait_with_lighting(5.0)
						step_back_and_follow_up(5.0, 30.0)
						roll = monster.get_random(100) or roll
						if roll < 50 then
							monster.set_motion("立ち", -1, 0)
							timer.wait_frames_with_lighting(2)
						end
					else
						monster.set_motion("歩き", -1, 0)
						movement.turn_toward_target_and_wait_with_lighting(5.0)
						sidestep_and_follow_up(5.0, 30.0)
						roll = monster.get_random(100) or roll
						if roll < 50 then
							monster.set_motion("立ち", -1, 0)
							timer.wait_frames_with_lighting(2)
						end
					end
				end
			end
		elseif target_distance > 150.0 then
			monster.set_motion("歩き", -1, 0)
			approach_target(2.0, 5.0, 90.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_with_lighting(5.0)
			perform_combo_attack()
			timer.wait_frames_with_lighting(3)
		end
	end
end

--- Chooses between fighting, roaming and chasing from the target distance, the guard state and the rage counter.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	target_distance = monster.get_target_distance() or target_distance
	if rage_hits_left > 0 then
		face_target_if_player_transformed()
		if reaction.is_guard_active() == 0 then
			if target_distance < 90.0 then
				fight_target_cautiously()
			else
				roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 150.0 then
					monster.set_monster_escape_rate(-1, 1.0)
					reaction.set_guard_active(0)
					fight_target_cautiously()
				else
					monster.set_monster_escape_rate(-1, 10.0)
					lunge_twice()
				end
			else
				monster.set_monster_escape_rate(-1, 1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		fight_target_enraged()
	end
end

--- Masks the monster, stops it, faces the target and marks it as acting.
local function lock_and_face_target()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	timer.wait_frame_with_lighting()
	monster.set_action_status(1)
end

local script = {}

--- Runs once when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the monster's attack hits and applies its default parameters when it is placed.
function script.init()
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１in", 0.887, 1.0, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１", 0.0, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１", 0.5, 1.0, 0)
	monster.register_damage_hit("通常攻撃", 9.0, "攻撃２", 0.38, 0.68, 0, 1)
	monster.add_sword_trail(0, "攻撃２", 0.2, 0.22, "dcol0", "dcol1", 50, 10, 15)
	set_default_parameters()
end

--- Runs the monster's main behaviour loop.
function script.loop()
	monster.stop_moving()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		timer.wait_frame_with_lighting()
		choose_behavior()
	end
end

--- Holds the monster in its damage pose until its status ailment ends.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		timer.wait_frame_with_lighting()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers the monster back, occasionally followed by a step backward.
function script.on_damage()
	local roll: s32 = 0
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_with_lighting()
	timer.wait_frames_with_lighting(12)
	monster.set_motion("立ち")
	roll = monster.get_random(100) or roll
	if roll < 8 then
		monster.set_motion("ステップ後", -1, 0)
		step_back_and_follow_up(3.0, 30.0)
	end
	state.do_nothing()
end

--- Knocks the monster down, then lets it get back up.
function script.on_knockdown()
	lock_and_face_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_with_lighting()
	monster.set_action_status(1)
	timer.wait_frames_with_lighting(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_lighting()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no guard reaction.
function script.on_guard() end

--- Dodges the first kind of attack by sidestepping or stepping backward.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_with_lighting(5.0)
		sidestep_and_follow_up(3.0, 45.0)
	else
		monster.set_motion("ステップ後", -1, 0)
		step_back_and_follow_up(3.0, 30.0)
	end
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the second kind of attack by sidestepping around the target.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_with_lighting(5.0)
	sidestep_and_follow_up(3.0, 45.0)
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the monster's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster is not held.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no landing reaction.
function script.on_land() end

--- Knocks the monster over and holds it until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_with_lighting()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_lighting()
	reaction.stun_until_recovered()
end

return script
