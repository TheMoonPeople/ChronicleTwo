--!strict
--- Controls the Halloween robot boss, which walks, jumps, fires missiles, smashes with both fists, throws nose bombs and spawns minions while circling the arena wall.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Stores a bitmask describing target distance, facing and arena position in monster variable 0.
local function update_situation_flags()
	local situation_flags: s32 = 0
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local origin_distance: f32 = 0
	situation_flags = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 50.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 1))
	elseif target_distance <= 240.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 2))
	elseif target_distance <= 760.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 4))
	else
		situation_flags = vm.i32(bit32.bor(situation_flags, 8))
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	origin_distance = monster.get_vector_length(position_x, position_y, position_z) or origin_distance
	if origin_distance >= 600.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 4096))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	origin_distance = monster.get_vector_length(position_x, position_y, position_z) or origin_distance
	if origin_distance >= 600.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 8192))
	end
	if target_distance <= 240.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 16))
	end
	if sense.is_facing_target_with_offset(0, 45.0) ~= 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 32))
	end
	if target_distance <= 90.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 64))
	end
	if sense.is_facing_target_with_offset(0, 80.0) ~= 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 128))
	end
	if target_distance <= 4000.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 256))
	end
	if sense.is_facing_target_with_offset(0, 60.0) ~= 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 512))
	end
	if target_distance <= 4000.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 1024))
	end
	if sense.is_facing_target_with_offset(0, 360.0) ~= 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 2048))
	end
	monster.set_variable(0, situation_flags)
end

--- Picks the queued actions in monster variables 1 to 4 from the situation flags and random rolls.
local function choose_next_actions()
	local second_action: s32 = 0
	local third_action: s32 = 0
	local fourth_action: s32 = 0
	local situation_flags: s32 = 0
	local roll: s32 = 0
	local second_roll: s32 = 0
	local event_flags: s32 = 0
	second_action = monster.get_variable(2) or second_action
	if second_action ~= -1 then
		third_action = monster.get_variable(3) or third_action
		fourth_action = monster.get_variable(4) or fourth_action
		monster.set_variable(1, second_action)
		monster.set_variable(2, third_action)
		monster.set_variable(3, fourth_action)
		monster.set_variable(4, -1)
		return
	end
	situation_flags = monster.get_variable(0) or situation_flags
	if bit32.band(situation_flags, 8192) ~= 0 then
		monster.set_variable(1, 10)
		monster.set_variable(4, 7)
	end
	if bit32.band(situation_flags, 2) == 0 then
		if bit32.band(situation_flags, 4096) ~= 0 then
			monster.set_variable(1, 5)
			roll = monster.get_random(100) or roll
			if roll < 55 then
				monster.set_variable(2, 12)
				monster.set_variable(3, 1)
				monster.set_variable(4, 7)
			else
				monster.set_variable(2, 3)
				monster.set_variable(3, 12)
			end
			return
		end
	end
	if bit32.band(situation_flags, 1) ~= 0 then
		monster.set_variable(1, 10)
		roll = monster.get_random(100) or roll
		if vm.imod(roll, 2) == 0 then
			monster.set_variable(2, 8)
			monster.set_variable(3, 11)
			monster.set_variable(4, 7)
		else
			monster.set_variable(2, 6)
			monster.set_variable(3, 8)
		end
		return
	end
	if bit32.band(situation_flags, 2) ~= 0 then
		if bit32.band(situation_flags, 192) == 192 then
			monster.set_variable(1, 2)
			monster.set_variable(2, 7)
			return
		end
		if bit32.band(situation_flags, 48) == 48 then
			monster.set_variable(1, 1)
			roll = monster.get_random(100) or roll
			if vm.imod(roll, 3) == 0 then
				monster.set_variable(2, 2)
				monster.set_variable(3, 7)
			else
				monster.set_variable(2, 7)
			end
			return
		end
		roll = monster.get_random(30) or roll
		roll = vm.i32(roll + 30)
		monster.set_variable(1, 9)
		monster.set_variable(2, 11)
		monster.set_variable(3, 7)
		monster.set_variable(5, roll)
		return
	end
	if bit32.band(situation_flags, 4) ~= 0 then
		second_roll = 0
		second_roll = monster.get_random(100) or second_roll
		event_flags = monster.get_variable(7) or event_flags
		if bit32.band(event_flags, 4) == 0 and second_roll < 20 then
			monster.set_variable(7, vm.i32(bit32.bor(event_flags, 4)))
			monster.set_variable(1, 10)
			monster.set_variable(2, 4)
		else
			second_roll = monster.get_random(100) or second_roll
			if vm.imod(second_roll, 4) == 0 then
				if bit32.band(situation_flags, 512) == 0 then
					monster.set_variable(1, 9)
					monster.set_variable(2, 3)
					monster.set_variable(3, 7)
					second_roll = monster.get_random(100) or second_roll
					if second_roll < 50 then
						monster.set_variable(4, 8)
					end
				else
					monster.set_variable(1, 3)
					monster.set_variable(2, 7)
					second_roll = monster.get_random(100) or second_roll
					if second_roll < 50 then
						monster.set_variable(3, 8)
					end
				end
			elseif bit32.band(situation_flags, 32) == 0 then
				monster.set_variable(1, 9)
				monster.set_variable(2, 1)
				monster.set_variable(3, 7)
			else
				monster.set_variable(2, 1)
				monster.set_variable(3, 7)
			end
		end
		return
	end
	if bit32.band(situation_flags, 8) ~= 0 then
		monster.set_variable(1, 5)
		monster.set_variable(2, 7)
		return
	end
	monster.set_variable(1, 7)
end

--- Walks toward the target for a random time, stopping early when it is too near, too far or the target is out of the arena.
local function walk_toward_target_briefly()
	local frames_remaining: s32 = 0
	local target_distance: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local origin_distance: f32 = 0
	local step_x: f32 = 0
	local step_z: f32 = 0
	frames_remaining = monster.get_random(60) or frames_remaining
	frames_remaining = vm.i32(frames_remaining + 90)
	while true do
		frames_remaining = vm.i32(frames_remaining - 1)
		if frames_remaining <= 0 then
			monster.set_motion("立ち")
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 90.0 then
			monster.set_motion("立ち")
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		if target_distance > 880.0 then
			monster.set_motion("立ち")
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		origin_distance = monster.get_vector_length(target_x, target_y, target_z) or origin_distance
		if origin_distance >= 600.0 then
			monster.set_motion("立ち")
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		monster.set_motion("歩き")
		do
			local out1, _, out3 = monster.get_point_from_facing(0.0, 8.0)
			step_x = out1 or step_x
			step_z = out3 or step_z
		end
		movement.turn_toward_target(vm.f32(0.05235988))
		monster.move_toward_position(step_x, 0.0, step_z, 8.0, 1.0)
		vm.wait()
	end
end

--- Walks toward the target for a random time, stopping early once it is near.
local function walk_toward_target_until_near()
	local frames_remaining: s32 = 0
	local target_distance: f32 = 0
	local step_x: f32 = 0
	local step_z: f32 = 0
	frames_remaining = monster.get_random(90) or frames_remaining
	frames_remaining = vm.i32(frames_remaining + 90)
	while true do
		frames_remaining = vm.i32(frames_remaining - 1)
		if frames_remaining <= 0 then
			monster.set_motion("立ち")
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 240.0 then
			monster.set_motion("立ち")
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		monster.set_motion("歩き")
		do
			local out1, _, out3 = monster.get_point_from_facing(0.0, 8.0)
			step_x = out1 or step_x
			step_z = out3 or step_z
		end
		movement.turn_toward_target(vm.f32(0.05235988))
		monster.move_toward_position(step_x, 0.0, step_z, 8.0, 1.0)
		vm.wait()
	end
end

--- Jumps in an arc to a point on the arena edge in the direction of the target and lands with a camera shake.
local function jump_to_wall_near_target()
	local target_x: f32 = 0
	local target_z: f32 = 0
	local yaw: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local gravity: f32 = 0
	local invulnerable_frames: s32 = 0
	local frame: s32 = 0
	local arc_x: f32 = 0
	local arc_y: f32 = 0
	local arc_z: f32 = 0
	local vertical_velocity: f32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	yaw = monster.get_angle_between_positions(target_x, 0.0, target_z, 0.0, 0.0, 0.0) or yaw
	x = vm.f32(vm.sin(yaw) * 400.0)
	y = 0.0
	z = vm.f32(vm.cos(yaw) * 400.0)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ジャンプ上昇", -1, 2)
	monster.set_monster_attributes(20, 1)
	timer.wait_frames(17)
	do
		local out1, out2, out3 = monster.get_position_3()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	gravity = vm.f32(-0.7)
	invulnerable_frames = 50
	monster.set_invulnerable_time(invulnerable_frames)
	frame = 0
	while frame <= invulnerable_frames do
		movement.turn_toward_target(vm.f32(0.06981317))
		vertical_velocity = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(y - start_y) * 2.0) - vm.f32(vm.f32(gravity * (invulnerable_frames + 1)) * (invulnerable_frames + 1))),
				vm.f32((invulnerable_frames + 1) * 2.0)
			)
		)
		arc_y = start_y
		for index = 0, frame - 1 do
			vertical_velocity = vm.f32(vertical_velocity + gravity)
			arc_y = vm.f32(arc_y + vertical_velocity)
		end
		arc_x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(x - start_x) * frame), invulnerable_frames)) + start_x)
		arc_z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(z - start_z) * frame), invulnerable_frames)) + start_z)
		if arc_y < y then
			arc_y = y
		end
		monster.set_position(arc_x, arc_y, arc_z)
		if frame == 7 then
			monster.set_motion("ジャンプＬ")
		end
		if frame == invulnerable_frames - 16 + 6 then
			monster.set_motion("ジャンプ下降", -1, 2)
		end
		frame = frame + 1
		vm.wait()
	end
	monster.shake_camera(6.0, 20)
	monster.set_position(x, y, z)
	movement.stop_turning()
	monster.set_monster_attributes(52, 0)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(16)
end

--- Plays the turning motion until it faces the target or the target comes too close.
local function turn_toward_target_slowly()
	local facing_yaw: f32 = 0
	local target_angle: f32 = 0
	local target_distance: f32 = 0
	while true do
		do
			local _, out2, _ = monster.get_rotation()
			facing_yaw = out2 or facing_yaw
		end
		target_angle = monster.get_target_angle() or target_angle
		if calc.compare_angles(target_angle, facing_yaw, vm.f32(0.034906585)) == 0 then
			movement.stop_turning()
			break
		else
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 50.0 then
				state.clear_variables_1_to_4()
				movement.stop_turning()
				break
			else
				monster.set_motion("旋回")
				movement.turn_toward_target(vm.f32(0.034906585))
				vm.wait()
			end
		end
	end
	monster.set_motion("立ち")
end

--- Fires a homing missile from its body toward the target and waits for the motion to end.
local function fire_missile()
	local roll: s32 = 0
	local attack: s32 = 0
	local muzzle_x: f32 = 0
	local muzzle_y: f32 = 0
	local muzzle_z: f32 = 0
	local facing_yaw: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 0.0)
			muzzle_x = out1 or muzzle_x
			muzzle_y = out2 or muzzle_y
			muzzle_z = out3 or muzzle_z
		end
	else
		do
			local out1, out2, out3 = monster.get_point_from_facing(1.5707964, 20.0)
			muzzle_x = out1 or muzzle_x
			muzzle_y = out2 or muzzle_y
			muzzle_z = out3 or muzzle_z
		end
	end
	monster.set_motion("ミサイル発射", -1, 2)
	timer.wait_frames(28)
	do
		local _, out2, _ = monster.get_rotation()
		facing_yaw = out2 or facing_yaw
	end
	muzzle_y = vm.f32(muzzle_y + 60.0)
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("ロボミサイル")
	monster.set_effect_first_vector(-1, muzzle_x, muzzle_y, muzzle_z)
	monster.set_effect_second_vector(-1, 0.0, facing_yaw, 0.0)
	monster.set_effect_target(-1, 0)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1)
	timer.wait_frames(30)
end

--- Slams both fists down and creates a shockwave at each hand.
local function smash_with_both_fists()
	local left_hand_x: f32 = 0
	local left_hand_z: f32 = 0
	local right_hand_x: f32 = 0
	local right_hand_z: f32 = 0
	local attack: s32 = 0
	monster.set_motion("叩き潰し", -1, 2)
	timer.wait_frames(18)
	do
		local out1, _, out3 = monster.get_frame_position("col_LH1")
		left_hand_x = out1 or left_hand_x
		left_hand_z = out3 or left_hand_z
	end
	do
		local out1, _, out3 = monster.get_frame_position("col_RH1")
		right_hand_x = out1 or right_hand_x
		right_hand_z = out3 or right_hand_z
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, left_hand_x, 0.0, left_hand_z)
	monster.set_effect_value(-1, 0, attack)
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, right_hand_x, 0.0, right_hand_z)
	monster.set_effect_value(-1, 0, attack)
	monster.shake_camera(4.0, 20)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(8)
end

--- Shoots a bomb from its nose toward the target and requests the first-bomb event once.
local function throw_nose_bomb()
	local nose_x: f32 = 0
	local nose_y: f32 = 0
	local nose_z: f32 = 0
	local target_angle: f32 = 0
	local event_flags: s32 = 0
	monster.set_motion("鼻爆弾", -1, 2)
	timer.wait_frames(10)
	do
		local out1, out2, out3 = monster.get_point_from_facing(0.24, 25.0)
		nose_x = out1 or nose_x
		nose_y = out2 or nose_y
		nose_z = out3 or nose_z
	end
	nose_y = vm.f32(nose_y + 30.0)
	target_angle = monster.get_target_angle() or target_angle
	monster.create_monster(1000, nose_x, nose_y, nose_z, target_angle)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(8)
	event_flags = monster.get_variable(7) or event_flags
	if bit32.band(event_flags, 2) == 0 then
		monster.set_variable(7, vm.i32(bit32.bor(event_flags, 2)))
		monster.request_event_script(540)
	end
end

--- Leaps in an arc onto the target position while tumbling, then lands with a camera shake.
local function leap_onto_target()
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	local target_angle: f32 = 0
	local target_origin_distance: f32 = 0
	local rotation_step_x: f32 = 0
	local rotation_step_y: f32 = 0
	local rotation_step_z: f32 = 0
	local gravity: f32 = 0
	local invulnerable_frames: s32 = 0
	local frame: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local vertical_velocity: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	monster.set_monster_attributes(52, 1)
	monster.set_motion("ジャンプ上昇", -1, 2)
	timer.wait_frames(17)
	do
		local out1, out2, out3 = monster.get_position_3()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		landing_x = out1 or landing_x
		landing_y = out2 or landing_y
		landing_z = out3 or landing_z
	end
	target_origin_distance = monster.get_vector_length(landing_x, landing_y, landing_z) or target_origin_distance
	if target_origin_distance >= 600.0 then
		landing_x = 0.0
		landing_y = 0.0
		landing_z = 0.0
	end
	target_angle = monster.get_target_angle() or target_angle
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_step_x = out1 or rotation_step_x
		rotation_step_y = out2 or rotation_step_y
		rotation_step_z = out3 or rotation_step_z
	end
	rotation_step_x = vm.f32(0.0 - rotation_step_x)
	rotation_step_y = vm.f32(target_angle - rotation_step_y)
	rotation_step_z = vm.f32(0.0 - rotation_step_z)
	rotation_step_x = monster.wrap_angle(rotation_step_x) or rotation_step_x
	rotation_step_y = monster.wrap_angle(rotation_step_y) or rotation_step_y
	rotation_step_z = monster.wrap_angle(rotation_step_z) or rotation_step_z
	rotation_step_x = vm.f32(rotation_step_x / 20.0)
	rotation_step_y = vm.f32(rotation_step_y / 20.0)
	rotation_step_z = vm.f32(rotation_step_z / 20.0)
	gravity = vm.f32(-0.7)
	invulnerable_frames = 50
	monster.set_invulnerable_time(invulnerable_frames)
	frame = 0
	while frame <= invulnerable_frames do
		vertical_velocity = vm.f32(
			vm.fdiv(
				vm.f32(
					vm.f32(vm.f32(landing_y - start_y) * 2.0) - vm.f32(vm.f32(gravity * (invulnerable_frames + 1)) * (invulnerable_frames + 1))
				),
				vm.f32((invulnerable_frames + 1) * 2.0)
			)
		)
		y = start_y
		for index = 0, frame - 1 do
			vertical_velocity = vm.f32(vertical_velocity + gravity)
			y = vm.f32(y + vertical_velocity)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(landing_x - start_x) * frame), invulnerable_frames)) + start_x)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(landing_z - start_z) * frame), invulnerable_frames)) + start_z)
		if y <= landing_y then
			y = landing_y
		end
		monster.set_position(x, y, z)
		if frame == 7 then
			monster.set_motion("ジャンプＬ")
		end
		if frame == invulnerable_frames - 16 + 6 then
			monster.set_motion("ジャンプ下降", -1, 2)
		end
		if frame >= 10 and frame < 30 then
			do
				local out1, out2, out3 = monster.get_rotation()
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			rotation_x = vm.f32(rotation_x + rotation_step_x)
			rotation_y = vm.f32(rotation_y + rotation_step_y)
			rotation_z = vm.f32(rotation_z + rotation_step_z)
			rotation_x = monster.wrap_angle(rotation_x) or rotation_x
			rotation_y = monster.wrap_angle(rotation_y) or rotation_y
			rotation_z = monster.wrap_angle(rotation_z) or rotation_z
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		end
		frame = frame + 1
		vm.wait()
	end
	monster.shake_camera(6.0, 20)
	monster.set_position(landing_x, landing_y, landing_z)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(16)
	monster.set_monster_attributes(52, 0)
end

--- Jumps onto the arena wall and circles it sideways until the spawned minions are defeated, then leaps back onto the target.
local function circle_arena_wall_until_minions_defeated()
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local circle_angle: f32 = 0
	local rotation_step_x: f32 = 0
	local rotation_step_y: f32 = 0
	local rotation_step_z: f32 = 0
	local circle_clockwise: s32 = 0
	local gravity: f32 = 0
	local invulnerable_frames: s32 = 0
	local frame: s32 = 0
	local apex_reached: s32 = 0
	local arc_x: f32 = 0
	local arc_y: f32 = 0
	local arc_z: f32 = 0
	local vertical_velocity: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local landing_roll_angle: f32 = 0
	local clockwise_roll_angle: f32 = 0
	local counter_clockwise_roll_angle: f32 = 0
	local monster_count: s32 = 0
	monster.set_monster_attributes(53, 1)
	do
		local out1, out2, out3 = monster.get_position_3()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	circle_angle = monster.get_target_angle() or circle_angle
	x = vm.f32(vm.sin(circle_angle) * 980.0)
	y = 400.0
	z = vm.f32(vm.cos(circle_angle) * 980.0)
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_step_x = out1 or rotation_step_x
		rotation_step_y = out2 or rotation_step_y
		rotation_step_z = out3 or rotation_step_z
	end
	circle_clockwise = 1
	if circle_clockwise == 1 then
		rotation_step_x = vm.f32(vm.f32(circle_angle - vm.f32(1.5707964)) - rotation_step_x)
		rotation_step_y = vm.f32(0.0 - rotation_step_y)
		rotation_step_z = vm.f32(vm.f32(1.5707964) - rotation_step_z)
	else
		rotation_step_x = vm.f32(vm.f32(circle_angle + vm.f32(1.5707964)) - rotation_step_x)
		rotation_step_y = vm.f32(0.0 - rotation_step_y)
		rotation_step_z = vm.f32(vm.f32(-1.5707964) - rotation_step_z)
	end
	rotation_step_x = monster.wrap_angle(rotation_step_x) or rotation_step_x
	rotation_step_y = monster.wrap_angle(rotation_step_y) or rotation_step_y
	rotation_step_z = monster.wrap_angle(rotation_step_z) or rotation_step_z
	rotation_step_x = vm.f32(rotation_step_x / 20.0)
	rotation_step_y = vm.f32(rotation_step_y / 20.0)
	rotation_step_z = vm.f32(rotation_step_z / 20.0)
	monster.set_motion("ジャンプ上昇", -1, 2)
	timer.wait_frames(17)
	gravity = vm.f32(-0.7)
	invulnerable_frames = 50
	monster.set_invulnerable_time(invulnerable_frames)
	apex_reached = 0
	frame = 0
	while frame <= invulnerable_frames do
		vertical_velocity = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(y - start_y) * 2.0) - vm.f32(vm.f32(gravity * (invulnerable_frames + 1)) * (invulnerable_frames + 1))),
				vm.f32((invulnerable_frames + 1) * 2.0)
			)
		)
		arc_y = start_y
		for index = 0, frame - 1 do
			vertical_velocity = vm.f32(vertical_velocity + gravity)
			arc_y = vm.f32(arc_y + vertical_velocity)
		end
		arc_x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(x - start_x) * frame), invulnerable_frames)) + start_x)
		arc_z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(z - start_z) * frame), invulnerable_frames)) + start_z)
		if arc_y > y then
			apex_reached = 1
		end
		if apex_reached == 1 and arc_y < y then
			arc_y = y
		end
		monster.set_position(arc_x, arc_y, arc_z)
		if frame == 7 then
			monster.set_motion("ジャンプＬ")
		end
		if frame == invulnerable_frames - 16 then
			monster.set_motion("ジャンプ下降", -1, 2)
		end
		if frame >= 30 then
			do
				local out1, out2, out3 = monster.get_rotation()
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			rotation_x = vm.f32(rotation_x + rotation_step_x)
			rotation_y = vm.f32(rotation_y + rotation_step_y)
			rotation_z = vm.f32(rotation_z + rotation_step_z)
			rotation_x = monster.wrap_angle(rotation_x) or rotation_x
			rotation_y = monster.wrap_angle(rotation_y) or rotation_y
			rotation_z = monster.wrap_angle(rotation_z) or rotation_z
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		end
		frame = frame + 1
		vm.wait()
	end
	landing_roll_angle = vm.f32(circle_angle - vm.f32(1.5707964))
	landing_roll_angle = monster.wrap_angle(landing_roll_angle) or landing_roll_angle
	if circle_clockwise == 1 then
		monster.set_rotation(landing_roll_angle, 0.0, 1.57)
	else
		monster.set_rotation(landing_roll_angle, 0.0, 1.57)
	end
	motion.wait_until_finished()
	monster.set_motion("歩き")
	while true do
		x = vm.f32(vm.sin(circle_angle) * 980.0)
		y = 400.0
		z = vm.f32(vm.cos(circle_angle) * 980.0)
		monster.set_position(x, y, z)
		if circle_clockwise == 1 then
			clockwise_roll_angle = vm.f32(circle_angle - vm.f32(1.5707964))
			clockwise_roll_angle = monster.wrap_angle(clockwise_roll_angle) or clockwise_roll_angle
			monster.set_rotation(clockwise_roll_angle, 0.0, 1.57)
			circle_angle = vm.f32(circle_angle - vm.f32(0.01))
		else
			counter_clockwise_roll_angle = vm.f32(circle_angle - vm.f32(1.5707964))
			counter_clockwise_roll_angle = monster.wrap_angle(counter_clockwise_roll_angle) or counter_clockwise_roll_angle
			monster.set_rotation(counter_clockwise_roll_angle, 0.0, 1.57)
			circle_angle = vm.f32(circle_angle + vm.f32(0.01))
		end
		circle_angle = monster.wrap_angle(circle_angle) or circle_angle
		monster_count = monster.get_monster_count() or monster_count
		if monster_count <= 1 then
			break
		else
			monster.set_invulnerable_time(1)
			vm.wait()
		end
	end
	leap_onto_target()
	monster.set_monster_attributes(53, 0)
end

--- Lays minions from its back and then circles the arena wall until they are defeated.
local function spawn_minions_then_circle_wall()
	local spawn_x: f32 = 0
	local spawn_y: f32 = 0
	local spawn_z: f32 = 0
	monster.set_monster_attributes(32, 1)
	monster.set_motion("産み落とし", -1, 2)
	timer.wait_frames(10)
	do
		local out1, out2, out3 = monster.get_point_from_facing(3.1415927, 32.0)
		spawn_x = out1 or spawn_x
		spawn_y = out2 or spawn_y
		spawn_z = out3 or spawn_z
	end
	spawn_y = vm.f32(spawn_y + 135.0)
	for index = 0, 5 do
		timer.wait_frames(5)
		monster.create_monster(25, spawn_x, spawn_y, spawn_z)
	end
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(8)
	monster.set_camera_mode(0)
	circle_arena_wall_until_minions_defeated()
	monster.set_camera_mode(1)
end

--- Waits for the number of frames stored in monster variable 5 and resets it.
local function wait_idle_frames()
	local idle_frames: s32 = 0
	idle_frames = monster.get_variable(5) or idle_frames
	timer.wait_frames(idle_frames)
	monster.set_variable(5, 40)
end

--- Runs the action currently queued in monster variable 1, adjusting it by the situation flags.
local function perform_queued_action()
	local queued_action: s32 = 0
	local situation_flags: s32 = 0
	local close_situation_flags: s32 = 0
	queued_action = monster.get_variable(1) or queued_action
	if queued_action == 8 then
		walk_toward_target_briefly()
	end
	if queued_action == 12 then
		walk_toward_target_until_near()
	end
	if queued_action == 10 then
		jump_to_wall_near_target()
	end
	if queued_action == 9 then
		turn_toward_target_slowly()
	end
	if queued_action == 6 then
		situation_flags = monster.get_variable(0) or situation_flags
		if bit32.band(situation_flags, 4096) ~= 0 then
			fire_missile()
			return
		end
		if bit32.band(situation_flags, 192) == 192 then
			smash_with_both_fists()
			return
		end
		if bit32.band(situation_flags, 48) == 48 then
			throw_nose_bomb()
			return
		end
		if bit32.band(situation_flags, 768) == 768 then
			fire_missile()
			return
		end
		leap_onto_target()
	end
	if queued_action == 11 then
		close_situation_flags = monster.get_variable(0) or close_situation_flags
		if bit32.band(close_situation_flags, 48) == 48 then
			throw_nose_bomb()
			return
		end
		if bit32.band(close_situation_flags, 192) == 192 then
			smash_with_both_fists()
			return
		end
	end
	if queued_action == 1 then
		throw_nose_bomb()
	end
	if queued_action == 2 then
		smash_with_both_fists()
	end
	if queued_action == 3 then
		fire_missile()
	end
	if queued_action == 4 then
		spawn_minions_then_circle_wall()
	end
	if queued_action == 5 then
		leap_onto_target()
	end
	if queued_action == 7 then
		monster.set_motion("立ち")
		wait_idle_frames()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the collision parts and hit windows, clears the monster variables and loads the missile and shockwave effects.
function script.init()
	monster.register_entry_object(0, "col_head")
	monster.register_entry_object(1, "col_LF1")
	monster.register_entry_object(2, "col_LH2")
	monster.register_entry_object(3, "col_LH1")
	monster.register_entry_object(4, "col_RF1")
	monster.register_entry_object(5, "col_RH1")
	monster.register_entry_object(6, "col_RH2")
	monster.register_damage_hit("通常攻撃", 15.0, "叩き潰し", 0.332, 0.545, 2)
	monster.register_damage_hit("通常攻撃", 15.0, "叩き潰し", 0.332, 0.545, 4)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 3)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 4)
	monster.register_damage_hit("吹っ飛び攻撃", 15.0, "ジャンプ下降", 0.205, 0.532, 5)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 2)
	monster.set_variable(3, 7)
	monster.set_variable(4, -1)
	monster.set_variable(5, 40)
	monster.set_variable(6, 0)
	monster.set_variable(7, 0)
	monster.load_effect_script("ロボミサイル")
	monster.load_effect_script("ロボミサイル爆発")
	monster.load_effect_script("ロボミサイル煙")
	monster.load_effect_script("ヴァンガード衝撃波")
	monster.set_photo_opportunity("ミサイル発射", 0.3, 0.6, 1014)
	monster.set_motion("", -1, 2)
	monster.set_clip_distance(120.0)
	monster.set_motion("立ち", -1, 4)
	monster.set_camera_mode(4)
end

--- Recovers from a fall when needed, then repeatedly updates the situation, chooses actions and performs them.
function script.loop()
	local recovery_frames: s32 = 0
	local event_flags: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	recovery_frames = monster.get_variable(6) or recovery_frames
	if recovery_frames ~= 0 then
		if recovery_frames == 120 then
			monster.stop_moving()
			movement.stop_turning()
			monster.set_invulnerable_time(38)
			monster.set_motion("倒れ", -1, 2)
			motion.wait_until_finished()
			event_flags = monster.get_variable(7) or event_flags
			if bit32.band(event_flags, 1) == 0 then
				monster.set_variable(7, vm.i32(bit32.bor(event_flags, 1)))
				monster.request_event_script(530)
			end
		end
		while recovery_frames > 0 do
			recovery_frames = recovery_frames - 1
			monster.set_variable(6, recovery_frames)
			vm.wait()
		end
		monster.set_invulnerable_time(35)
		monster.set_motion("立ち戻り", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち")
	end
	monster.set_motion("立ち")
	while true do
		update_situation_flags()
		choose_next_actions()
		perform_queued_action()
		vm.wait()
	end
end

--- Cancels the invulnerable jump attributes and clears the queued actions.
function script.on_damage()
	monster.set_monster_attributes(52, 0)
	state.clear_variables_1_to_4()
end

--- Cancels the invulnerable jump attributes and clears the queued actions.
function script.on_knockdown()
	monster.set_monster_attributes(52, 0)
	state.clear_variables_1_to_4()
end

--- Cancels the invulnerable jump attributes and clears the queued actions.
function script.on_guard()
	monster.set_monster_attributes(52, 0)
	state.clear_variables_1_to_4()
end

--- Cancels the invulnerable jump attributes and clears the queued actions.
function script.on_dodge_1()
	monster.set_monster_attributes(52, 0)
	state.clear_variables_1_to_4()
end

--- Cancels the invulnerable jump attributes and clears the queued actions.
function script.on_dodge_2()
	monster.set_monster_attributes(52, 0)
	state.clear_variables_1_to_4()
end

--- Releases the camera, plays the fall and requests the defeat event.
function script.on_death()
	monster.reset_camera_limits()
	monster.set_camera_mode(0)
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(2, 1)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.start_death()
	monster.set_motion("倒れ", -1, 2)
	motion.wait_until_finished()
	timer.wait_frames(30)
	monster.request_event_script(520)
	monster.set_camera_mode(0)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so that the engine skips its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so that the engine skips its default.
function script.on_land() end

--- Starts the fall recovery timer and clears the queued actions.
function script.on_stun()
	local recovery_frames: s32 = 0
	recovery_frames = monster.get_variable(6) or recovery_frames
	if recovery_frames == 0 then
		monster.set_variable(6, 120)
	end
	monster.set_monster_attributes(52, 0)
	state.clear_variables_1_to_4()
end

return script
