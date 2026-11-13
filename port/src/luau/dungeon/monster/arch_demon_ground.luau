--!strict
--- Controls the ground-form Arch Demon, which drops from the sky and then closes in on the target with melee and sticky-spit attacks.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")

--- Limits how far away the monster stays active unless it is a boss.
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

--- Plays the death motion and the death effects, then idles forever.
local function on_death()
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_monster_attributes(2, 1)
	monster.set_motion("死亡", 6)
	motion.wait_until_finished()
	monster.set_motion("死亡とめ", 0)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Starts the death sequence when the death flag is set.
local function die_if_flagged()
	local death_flag: s32 = 0
	death_flag = monster.get_variable(64) or death_flag
	if death_flag ~= 0 then
		on_death()
	end
end

--- Checks for the death flag and waits one frame.
local function check_death_and_wait_frame()
	die_if_flagged()
	vm.wait()
end

--- Waits until the monster faces a target angle or the frame limit passes, and returns the frames waited.
local function wait_until_facing(target_angle: f32, turn_speed: f32, max_frames: f32)
	local current_angle: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local angle_tolerance: f32 = 0
	target_angle = calc.degrees_to_radians(target_angle)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	frame_limit = max_frames
	if turn_speed < 3.0 then
		angle_tolerance = calc.degrees_to_radians(3.0)
	else
		angle_tolerance = turn_speed
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle - angle_tolerance) and current_angle < vm.f32(target_angle + angle_tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle, current_angle, turn_speed) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			check_death_and_wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns toward the target at a given speed and waits until facing it.
local function turn_toward_target_and_wait(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Chases the target at a given speed until within range or the frame limit passes.
local function run_toward_target(speed: f32, turn_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local frame_index: s32 = 0
	turn_toward_target_and_wait(turn_speed)
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	frame_index = 0
	while frame_index < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
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
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
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
			local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, speed + stop_distance)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		monster.move_toward_position(destination_x, position_y - 20.0, destination_z, speed, speed)
		check_death_and_wait_frame()
		frame_index = frame_index + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Keeps turning toward the target until the current motion finishes.
local function turn_toward_target_until_motion_ends(turn_speed: f32)
	local target_angle: f32 = 0
	local is_finished: s32 = 0
	turn_speed = calc.degrees_to_radians(turn_speed)
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		check_death_and_wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			movement.stop_turning()
			break
		end
	end
end

--- Plays the idle play motion about half of the time.
local function maybe_play_idle_motion()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("遊び", -1, 0)
		turn_toward_target_until_motion_ends(4.0)
	end
end

--- Waits for a number of frames.
local function wait_frames(frame_count: any)
	local frame_index: s32 = 0
	frame_index = 0
	while frame_index < frame_count do
		check_death_and_wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Plays the swing attack, then walks back to a ready stance.
local function swing_and_recover()
	monster.set_motion("攻撃２", -1, 2)
	turn_toward_target_until_motion_ends(4.0)
	monster.set_motion("歩き", -1, 0)
	turn_toward_target_and_wait(4.0)
	maybe_play_idle_motion()
	monster.set_motion("立ち", -1, 0)
	wait_frames(9)
end

--- Waits until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		check_death_and_wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Steps backward away from the target.
local function step_backward()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local backward_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	backward_angle = vm.f32(rotation_y + vm.f32(3.1415927))
	if backward_angle > vm.f32(3.1415927) then
		backward_angle = vm.f32(backward_angle - vm.f32(6.2831855))
	end
	if backward_angle <= vm.f32(-3.1415927) then
		backward_angle = vm.f32(backward_angle + vm.f32(6.2831855))
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(backward_angle) * 200.0))
	position_z = vm.f32(position_z + vm.f32(vm.cos(backward_angle) * 200.0))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(position_x, position_y - 30.0, position_z, 4.2, 4.2)
	wait_frames(calc.pass_through(15))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Steps to the left or right of the target.
local function side_step(distance: f32, step_right: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local step_angle_degrees: f32 = 0
	if step_right ~= 0 then
		monster.set_motion("ステップ右", -1, 6)
		step_angle_degrees = -45.0
	else
		monster.set_motion("ステップ左", -1, 6)
		step_angle_degrees = 45.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(step_angle_degrees, distance, approach_x, approach_y, approach_z)
	wait_frames(calc.pass_through(4))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(approach_x, approach_y - 30.0, approach_z, 4.2, 4.2)
	wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between charging and swinging, stepping backward or side-stepping when the target is near.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local step_right: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 90 then
		monster.set_motion("走り", -1, 0)
		run_toward_target(vm.f32(7.4), 4.0, 39.0, 60)
		swing_and_recover()
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			step_backward()
		else
			step_right = 1
			target_distance = monster.get_target_distance() or target_distance
			roll = monster.get_random(100) or roll
			if roll < 50 then
				step_right = 0
			end
			side_step(vm.f32(target_distance + 30.0), step_right)
		end
	end
end

--- Turns toward the target until the current motion reaches a given progress.
local function turn_until_motion_progress(turn_speed_degrees: f32, progress: f32, tolerance: f32)
	local target_angle: f32 = 0
	local motion_progress: f32 = 0
	local turn_speed: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.05)
	end
	turn_speed = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(progress + tolerance) and motion_progress > vm.f32(progress - tolerance) then
			break
		else
			check_death_and_wait_frame()
		end
	end
	movement.stop_turning()
end

--- Plays the spitting attack and launches a damaging sticky effect from the mouth.
local function spit_sticky_attack()
	local attack_power: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	attack_power = monster.get_attack_power_1() or attack_power
	monster.reset_motion()
	monster.set_motion("攻撃1", -1, 6)
	turn_until_motion_progress(4.0, vm.f32(0.63), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("ねばねばＬ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	turn_toward_target_until_motion_ends(4.0)
	monster.set_motion("歩き", -1, 0)
	turn_toward_target_and_wait(4.0)
	maybe_play_idle_motion()
	monster.set_motion("立ち", -1, 0)
	wait_frames(9)
end

--- Chooses between a spitting attack and running toward the target.
local function act_at_mid_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("歩き", -1, 0)
		turn_toward_target_and_wait(4.0)
		spit_sticky_attack()
	else
		monster.set_motion("走り", -1, 0)
		run_toward_target(vm.f32(7.4), 4.0, 39.0, 60)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns toward an angle at a given speed and waits until facing it.
local function turn_to_angle_and_wait(target_angle: f32, turn_speed: f32)
	target_angle = calc.degrees_to_radians(target_angle)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_angle, turn_speed)
	local _ = wait_until_facing(
		calc.radians_to_degrees(target_angle),
		calc.radians_to_degrees(turn_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(turn_speed)))
	)
	movement.stop_turning()
end

--- Waits until the monster arrives, gets within range of the target or the frame limit passes, and reports which happened.
local function wait_for_move_end(stop_distance: f32, max_frames: any)
	local frame_index: s32 = 0
	local arrived: s32 = 0
	local target_distance: f32 = 0
	frame_index = 0
	while frame_index < max_frames do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			check_death_and_wait_frame()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		frame_index = vm.i32(frame_index + 1)
	end
	return 0
end

--- Turns and runs to a point beside the target, stopping early if blocked.
local function run_to_flank_point(speed: f32, turn_speed_degrees: f32, flank_angle: f32, flank_distance: f32, stop_distance: f32, max_frames: s32)
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	approach_x, approach_y, approach_z = movement.get_approach_point(flank_angle, flank_distance, approach_x, approach_y, approach_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	flank_angle = monster.get_angle_to_position(approach_x, approach_y, approach_z) or flank_angle
	if flank_angle > vm.f32(3.1415927) then
		flank_angle = vm.f32(flank_angle - vm.f32(6.2831855))
	end
	if flank_angle <= vm.f32(-3.1415927) then
		flank_angle = vm.f32(flank_angle + vm.f32(6.2831855))
	end
	turn_to_angle_and_wait(calc.radians_to_degrees(flank_angle), turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(approach_x, approach_y, approach_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
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
	clear_distance = monster.get_clear_distance(speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(speed + stop_distance) then
		approach_x = vm.f32(position_x + vm.f32(vm.sin(flank_angle) * clear_distance))
		approach_y = position_y
		approach_z = vm.f32(position_z + vm.f32(vm.cos(flank_angle) * clear_distance))
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance < stop_distance then
			return
		end
	end
	monster.move_toward_position(approach_x, position_y - 20.0, approach_z, speed, speed)
	local _ = wait_for_move_end(stop_distance, max_frames)
	monster.stop_moving()
end

--- Runs straight at the target or circles to its side before facing it.
local function act_at_far_range()
	local roll: s32 = 0
	local flank_angle: f32 = 0
	local target_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("走り", -1, 0)
		run_toward_target(vm.f32(7.4), 4.0, 39.0, 60)
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		flank_angle = monster.get_random_whole_number(30.0) or flank_angle
		target_distance = monster.get_random_whole_number(30.0) or target_distance
		target_distance = monster.get_target_distance() or target_distance
		if roll < 50 then
			flank_angle = vm.f32(-flank_angle - 30.0)
		else
			flank_angle = vm.f32(flank_angle + 30.0)
		end
		monster.set_motion("走り", -1, 0)
		run_to_flank_point(vm.f32(7.4), 4.0, flank_angle, target_distance, 39.0, 45)
		turn_toward_target_and_wait(4.0)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Picks the close, mid or far range behaviour from the distance to the target.
local function choose_action_by_distance()
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 120.0 then
		act_at_close_range()
	elseif target_distance < 300.0 then
		act_at_mid_range()
	else
		act_at_far_range()
	end
end

--- Stops the monster, faces the target and masks incoming hits for the knockdown.
local function lock_for_knockdown()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	check_death_and_wait_frame()
	monster.set_action_status(1)
end

--- Waits every frame without ever returning.
local function idle_forever()
	while true do
		check_death_and_wait_frame()
	end
end

--- Clears the throw state and waits briefly before the monster resumes.
local function recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
end

local script = {}

--- Does nothing.
function script.setup() end

--- Registers the hit window of the swing attack and sets the model colour and clip distance.
function script.init()
	monster.register_damage_hit("吹っ飛び中", 5.0, "攻撃２", 0.64, 0.72, 0)
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.set_model_lighting(0)
	monster.set_model_color(128.0, 128.0, 128.0, 0.0)
	monster.set_model_lighting(1)
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.9)
end

--- Drops from the sky, lands and then fights by picking a behaviour from the distance to the target.
function script.loop()
	local has_landed: s32 = 0
	local height: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(32, 0)
	monster.set_invulnerable_time(0)
	has_landed = monster.get_variable(0) or has_landed
	if has_landed == 0 then
		monster.set_motion("落下", -1, 0)
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		for i = 0, 119 do
			if i > 9 then
				height = monster.get_height_above_ground() or height
				if height < 30.0 then
					monster.set_motion("着地", -1, 6)
					motion.wait_until_finished()
					break
				end
			end
			check_death_and_wait_frame()
		end
		monster.set_motion("立ち", -1, 0)
		monster.get_height_above_ground(height)
		monster.set_variable(0, 1)
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
	end
	monster.set_motion("立ち", -1, 0)
	monster.set_monster_attributes(16, 0)
	while true do
		check_death_and_wait_frame()
		choose_action_by_distance()
	end
end

--- Plays the damage motion with a small knockback.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ正", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	wait_until_motion_finished()
	wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown motion with a large knockback and gets up.
function script.on_knockdown()
	lock_for_knockdown()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(6.0, 0.05, 30)
	wait_until_motion_finished()
	monster.set_action_status(1)
	wait_frames(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Faces the target and plays the guard motions.
function script.on_guard()
	local target_angle: f32 = 0
	state.lock_and_stop_moving()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	monster.reset_motion()
	monster.set_motion("ガード入り", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("ガードループ", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	wait_frames(30)
	monster.set_motion("ガード戻り", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("立ち", 0)
	state.unlock()
end

--- Locks and releases the monster without moving.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Locks and releases the monster without moving.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

script.on_death = on_death

--- Struggles while caught.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		check_death_and_wait_frame()
	end
	idle_forever()
end

--- Recovers after being thrown and gets back up.
function script.on_land()
	recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	state.do_nothing_hook()
	return 1
end

--- Plays the knockback motions and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	reaction.stun_until_recovered()
end

return script
