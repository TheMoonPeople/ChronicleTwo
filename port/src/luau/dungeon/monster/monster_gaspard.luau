--!strict
--- Controls the Monster Gaspard boss, which alternates fireball attacks on the ground with resting and magma phases.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

local ground_phase_step: s32 = 0
local magma_phase_step: s32 = 0
local drip_effect: any = 0
local smoke_effect: any = 0

--- Uses a short clip distance for a normal monster and an unlimited one for a boss.
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

--- Starts the dripping magma effect and attaches it to the monster's character.
local function start_drip_effect()
	local character_number: s32 = 0
	character_number = monster.get_character_number() or character_number
	drip_effect = monster.create_effect_2("Ｍギルぽたぽた") or drip_effect
	monster.set_effect_owner(drip_effect, character_number)
	monster.set_effect_value(drip_effect, 2, 0)
	vm.wait()
end

--- Waits the given number of frames.
local function wait_frames(frame_count: s32)
	for index = 0, frame_count - 1 do
		vm.wait()
	end
end

--- Converts a number to an integer by truncation.
local function truncate_to_integer(value: any)
	return vm.ftoi(value)
end

--- Slams the ground with the first slam motion and releases a shockwave at the hand.
local function perform_slam_attack_3()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local attack: s32 = 0
	print("Attack3------------------------\n")
	monster.reset_motion()
	monster.set_motion("攻撃３", -1, 6)
	wait_frames(truncate_to_integer(14))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, _, out3 = monster.get_frame_position("dcol00")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, 0.0, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.shake_camera(2.0, 30)
	motion.wait_until_finished()
end

--- Slams the ground with the second slam motion and releases a shockwave at the hand.
local function perform_slam_attack_4()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local attack: s32 = 0
	print("Attack3------------------------\n")
	monster.reset_motion()
	monster.set_motion("攻撃４", -1, 6)
	wait_frames(truncate_to_integer(14))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, _, out3 = monster.get_frame_position("dcol01")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, 0.0, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.shake_camera(2.0, 30)
	motion.wait_until_finished()
end

--- Walks toward a position for up to a number of frames, slamming when the target gets close.
local function walk_to_position(target_x: f32, target_y: f32, target_z: f32, speed: f32, max_frames: s32)
	local arrived: s32 = 0
	local roll: s32 = 0
	local target_distance: f32 = 0
	local motion_progress: f32 = 0
	local target_angle: f32 = 0
	local walk_angle: f32 = 0
	for index = 0, max_frames - 1 do
		arrived = monster.is_move_finished() or arrived
		target_distance = monster.get_target_distance() or target_distance
		motion_progress = 1.0
		motion_progress = monster.get_motion_progress() or motion_progress
		if target_distance < 75.0 then
			roll = monster.get_random(200) or roll
			if roll < 10 then
				monster.stop_moving()
				target_angle = monster.get_target_angle() or target_angle
				if target_angle > vm.f32(3.1415927) then
					target_angle = vm.f32(target_angle - vm.f32(6.2831855))
				end
				if target_angle <= vm.f32(-3.1415927) then
					target_angle = vm.f32(target_angle + vm.f32(6.2831855))
				end
				movement.turn_toward_target_and_wait(5.0)
				if target_angle < 0.0 then
					perform_slam_attack_3()
				else
					perform_slam_attack_4()
				end
				monster.set_motion("立ち", -1, 0)
				wait_frames(15)
				monster.set_motion("歩き", -1, 0)
				do
					local _, out2, _ = monster.get_rotation_toward_6(target_x, target_y, target_z)
					walk_angle = out2 or walk_angle
				end
				movement.turn_to_angle(calc.radians_to_degrees(walk_angle), 5.0)
				monster.set_motion("歩き", -1, 0)
				monster.move_toward_position(target_x, target_y, target_z, speed, speed)
			end
		end
		if motion_progress >= vm.f32(0.524998) and motion_progress <= vm.f32(0.539998) then
			monster.shake_camera(1.8, 12)
		end
		if motion_progress >= vm.f32(0.97) then
			monster.shake_camera(1.8, 9)
		end
		if arrived == 0 then
			vm.wait()
		else
			monster.stop_moving()
			return
		end
	end
end

--- Lifts the monster by a height over a number of frames while it keeps facing the target.
local function rise_facing_target(x: f32, y: f32, z: f32, rise_height: f32, frame_count: f32)
	local step_height: f32 = 0
	local frame: f32 = 0
	local target_angle: f32 = 0
	step_height = vm.f32(vm.fdiv(rise_height, frame_count))
	frame = 0.0
	while frame < frame_count do
		target_angle = monster.get_target_angle() or target_angle
		monster.set_position(x, y + vm.f32(step_height * frame), z)
		monster.set_rotation(0.0, target_angle, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait()
	end
	monster.set_position(x, y + rise_height, z)
end

--- Rises, fires four fireballs in a ring, then sinks back to the ground.
local function fireball_ring_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local fireball_speed: f32 = 0
	local value: s32 = 0
	local target_id: s32 = 0
	local attack: s32 = 0
	local rise_height: f32 = 0
	local rise_frames: s32 = 0
	local character_number: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(32, 1)
	print("Attack1-------------------------\n")
	rise_height = 50.0
	monster.reset_motion()
	monster.set_motion("攻撃１入り", -1, 6)
	do
		local out1, out2, out3 = monster.get_position_3()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	monster.copy_vector(start_x, start_y, start_z)
	movement.track_target(10.0, truncate_to_integer(11))
	monster.set_monster_attributes(32, 0)
	monster.set_invulnerable_time(truncate_to_integer(124))
	rise_frames = truncate_to_integer(29)
	rise_facing_target(start_x, start_y, start_z, rise_height, rise_frames)
	motion.wait_until_finished()
	monster.set_motion("攻撃１", -1, 6)
	value = movement.track_target(5.0, truncate_to_integer(28))
	wait_frames(truncate_to_integer(vm.i32(28 - value)))
	value = monster.get_variable(4) or value
	if value == 0 then
		target_id = 0
	else
		target_id = 1
	end
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.3)))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	character_number = monster.get_character_number() or character_number
	target_id = 0
	fireball_speed = 16.0
	monster.play_monster_sound(character_number, 5)
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, target_id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, fireball_speed, 0.2, -90.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, character_number)
	monster.play_monster_sound(character_number, 5)
	wait_frames(truncate_to_integer(10))
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, target_id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, fireball_speed, 0.2, -0.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, character_number)
	monster.play_monster_sound(character_number, 5)
	wait_frames(truncate_to_integer(10))
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, target_id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, fireball_speed, 0.2, -180.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, character_number)
	monster.play_monster_sound(character_number, 5)
	wait_frames(truncate_to_integer(10))
	monster.create_effect_1("Ｍギル火炎弾２")
	monster.set_effect_target(-1, target_id)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, fireball_speed, 0.2, 90.0)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value(-1, 1, character_number)
	monster.play_monster_sound(character_number, 5)
	wait_frames(truncate_to_integer(10))
	monster.set_motion("攻撃１終わり", -1, 6)
	start_y = vm.f32(start_y + rise_height)
	rise_frames = truncate_to_integer(32)
	rise_facing_target(start_x, start_y, start_z, -rise_height, rise_frames)
	monster.stop_moving()
	monster.shake_camera(2.0, truncate_to_integer(15))
	motion.wait_until_finished()
	do
		local out1, out2, out3 = monster.get_position_3()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	monster.set_position(start_x, 0.0, start_z)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_monster_attributes(32, 0)
end

--- Walks to a random point on a circle around the arena centre, then turns and uses the fireball ring attack.
local function walk_to_random_point_and_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local angle: f32 = 0
	local distance: f32 = 0
	local frame_count: s32 = 0
	monster.set_motion("歩き", -1, 0)
	angle = monster.get_random_whole_number(6.2831855) or angle
	print("random angle=", vm.float(angle), "-----------------\n")
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = 0.0
	pos_z = 0.0
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(angle) * 250.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(angle) * 250.0))
	angle = monster.get_angle_to_position(pos_x, pos_y, pos_z) or angle
	movement.turn_to_angle(calc.radians_to_degrees(angle), 5.0)
	movement.stop_turning()
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.0, 3.0)
	distance = monster.get_distance_to_position(pos_x, pos_y, pos_z) or distance
	frame_count = vm.ftoi(vm.f32(distance / 3.0))
	print("frame=", frame_count, "--------------------\n")
	walk_to_position(pos_x, pos_y, pos_z, 3.0, frame_count)
	monster.stop_moving()
	movement.turn_toward_target_and_wait(5.0)
	fireball_ring_attack()
	monster.set_motion("立ち", -1, 0)
	wait_frames(15)
end

--- Advances one frame toward a position, slamming when the target gets close, and reports when it has arrived.
local function step_toward_position(target: f32, target_2: f32, target_3: f32, speed: f32)
	local arrived: s32 = 0
	local roll: s32 = 0
	local target_distance: f32 = 0
	local motion_progress: f32 = 0
	local target_angle: f32 = 0
	local walk_angle: f32 = 0
	arrived = monster.is_move_finished() or arrived
	target_distance = monster.get_target_distance() or target_distance
	motion_progress = 1.0
	motion_progress = monster.get_motion_progress() or motion_progress
	if target_distance < 75.0 then
		roll = monster.get_random(200) or roll
		if roll < 10 then
			monster.stop_moving()
			target_angle = monster.get_target_angle() or target_angle
			if target_angle > vm.f32(3.1415927) then
				target_angle = vm.f32(target_angle - vm.f32(6.2831855))
			end
			if target_angle <= vm.f32(-3.1415927) then
				target_angle = vm.f32(target_angle + vm.f32(6.2831855))
			end
			movement.turn_toward_target_and_wait(5.0)
			if target_angle < 0.0 then
				perform_slam_attack_3()
			else
				perform_slam_attack_4()
			end
			monster.set_motion("立ち", -1, 0)
			wait_frames(15)
			monster.set_motion("歩き", -1, 0)
			monster.call_command(101, target, target_2, target_3, walk_angle) -- retail: the handler rejects 4 arguments
			movement.turn_to_angle(calc.radians_to_degrees(walk_angle), 5.0)
			monster.set_motion("歩き", -1, 0)
			monster.move_toward_position(target, target_2, target_3, speed, speed)
		end
	end
	if motion_progress >= vm.f32(0.524998) and motion_progress <= vm.f32(0.539998) then
		monster.shake_camera(1.8, 12)
	end
	if motion_progress >= vm.f32(0.97) then
		monster.shake_camera(1.8, 9)
	end
	if arrived == 0 then
		vm.wait()
	else
		monster.stop_moving()
		return 2
	end
	return 0
end

--- Chases the target for up to a number of frames and stops when a step reports arrival.
local function chase_target(speed: f32, turn_degrees: f32, stop_distance: any, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_angle: f32 = 0
	local result: s32 = 0
	local frame: s32 = 0
	local _ = calc.degrees_to_radians(turn_degrees)
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		target_angle = monster.get_target_angle() or target_angle
		if step_toward_position(target_x, target_y, target_z, speed) == 2 then
			break
		else
			monster.move_toward_position(target_x, target_y, target_z, speed, speed)
			monster.set_rotation(0.0, target_angle, 0.0)
			vm.wait()
			frame = frame + 1
		end
	end
	monster.stop_moving()
	return result
end

--- Roars and, in the enraged form, spits four fireballs around itself.
local function roar_and_spray_fireballs(is_enraged: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local character_number: s32 = 0
	local character_value: s32 = 0
	local effect_float_1: f32 = 0
	local effect_float_2: f32 = 0
	local attack: s32 = 0
	monster.set_motion("立ち", -1, 0)
	vm.wait()
	monster.set_motion("吠える", -1, 6)
	wait_frames(truncate_to_integer(58))
	monster.shake_camera(3.0, 90)
	character_number = monster.get_character_number() or character_number
	character_value = character_number
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if is_enraged == 1 then
		effect_float_2 = 10.0
		effect_float_1 = 1.5
		attack = monster.get_attack_power_1() or attack
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, character_number)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 0.0, 30.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, effect_float_1)
		monster.set_effect_value_float(-1, 2, effect_float_2)
		monster.set_effect_value(-1, 3, character_value)
		wait_frames(truncate_to_integer(10))
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, character_number)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 120.0, 40.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, effect_float_1)
		monster.set_effect_value_float(-1, 2, effect_float_2)
		monster.set_effect_value(-1, 3, character_value)
		wait_frames(truncate_to_integer(10))
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, character_number)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 240.0, 30.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, effect_float_1)
		monster.set_effect_value_float(-1, 2, effect_float_2)
		monster.set_effect_value(-1, 3, character_value)
		wait_frames(truncate_to_integer(10))
		monster.create_effect_1("Ｍギル火炎弾３")
		monster.set_effect_target(-1, character_number)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, 50.0, 0.0, 40.0)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value_float(-1, 1, effect_float_1)
		monster.set_effect_value_float(-1, 2, effect_float_2)
		monster.set_effect_value(-1, 3, character_value)
	end
	motion.wait_until_finished()
end

--- Chases the target and then roars, using the enraged form when the life is low.
local function chase_then_roar()
	local enraged_stage: s32 = 0
	enraged_stage = monster.get_variable(4) or enraged_stage
	monster.set_motion("歩き", -1, 0)
	local _ = chase_target(3.0, 5.0, 75.0, 60)
	if enraged_stage == 0 then
		roar_and_spray_fireballs(0)
	else
		roar_and_spray_fireballs(1)
	end
end

--- Swaps the dripping magma effect and the smoke effect depending on whether the body is heated.
local function switch_heat_effects(is_heated: s32)
	if is_heated ~= 0 then
		drip_effect = monster.create_effect_2("Ｍギルぽたぽた") or drip_effect
		monster.set_effect_value(drip_effect, 2, 0)
		monster.set_effect_value(smoke_effect, 2, 1)
		monster.finish_effect(smoke_effect)
	else
		smoke_effect = monster.create_effect_2("Ｍギル煙") or smoke_effect
		monster.set_effect_value(drip_effect, 2, 1)
		monster.set_effect_value(smoke_effect, 2, 0)
		monster.finish_effect(drip_effect)
	end
end

--- Flickers the body colour and then sets the colour and defence for the heated or cooled state.
local function flash_into_heat_state(is_heated: s32)
	local brightness: s32 = 0
	for index = 0, 9 do
		monster.set_model_color(128, 128, 128, 128, "skin")
		monster.set_model_color(128, 128, 128, 128, "skin5")
		monster.set_model_color(128, 128, 128, 128, "skin6")
		monster.set_model_color(128, 128, 128, 128, "skin7")
		monster.set_model_color(128, 128, 128, 128, "kao")
		monster.set_model_color(128, 128, 128, 128, "ha1")
		monster.set_model_color(128, 128, 128, 128, "ha2")
		monster.set_model_color(128, 128, 128, 128, "ha3")
		monster.set_model_color(128, 128, 128, 128, "ha4")
		monster.set_model_color(128, 128, 128, 128, "ha5")
		monster.set_model_color(128, 128, 128, 128, "ha6")
		monster.set_model_color(128, 128, 128, 128, "skin8")
		vm.wait()
		monster.set_model_color(112, 112, 112, 128, "skin")
		monster.set_model_color(112, 112, 112, 128, "skin5")
		monster.set_model_color(112, 112, 112, 128, "skin6")
		monster.set_model_color(112, 112, 112, 128, "skin7")
		monster.set_model_color(112, 112, 112, 128, "kao")
		monster.set_model_color(112, 112, 112, 128, "ha1")
		monster.set_model_color(112, 112, 112, 128, "ha2")
		monster.set_model_color(112, 112, 112, 128, "ha3")
		monster.set_model_color(112, 112, 112, 128, "ha4")
		monster.set_model_color(112, 112, 112, 128, "ha5")
		monster.set_model_color(112, 112, 112, 128, "ha6")
		monster.set_model_color(112, 112, 112, 128, "skin8")
		vm.wait()
		monster.set_model_color(80, 80, 80, 128, "skin")
		monster.set_model_color(80, 80, 80, 128, "skin5")
		monster.set_model_color(80, 80, 80, 128, "skin6")
		monster.set_model_color(80, 80, 80, 128, "skin7")
		monster.set_model_color(80, 80, 80, 128, "kao")
		monster.set_model_color(80, 80, 80, 128, "ha1")
		monster.set_model_color(80, 80, 80, 128, "ha2")
		monster.set_model_color(80, 80, 80, 128, "ha3")
		monster.set_model_color(80, 80, 80, 128, "ha4")
		monster.set_model_color(80, 80, 80, 128, "ha5")
		monster.set_model_color(80, 80, 80, 128, "ha6")
		monster.set_model_color(80, 80, 80, 128, "skin8")
		vm.wait()
	end
	if is_heated ~= 0 then
		brightness = 128
		monster.set_defense_rate(1.0)
	else
		brightness = 32
		monster.set_defense_rate(0.5)
	end
	monster.set_model_color(brightness, brightness, brightness, 128, "skin")
	monster.set_model_color(brightness, brightness, brightness, 128, "skin5")
	monster.set_model_color(brightness, brightness, brightness, 128, "skin6")
	monster.set_model_color(brightness, brightness, brightness, 128, "skin7")
	monster.set_model_color(brightness, brightness, brightness, 128, "kao")
	monster.set_model_color(brightness, brightness, brightness, 128, "ha1")
	monster.set_model_color(brightness, brightness, brightness, 128, "ha2")
	monster.set_model_color(brightness, brightness, brightness, 128, "ha3")
	monster.set_model_color(brightness, brightness, brightness, 128, "ha4")
	monster.set_model_color(brightness, brightness, brightness, 128, "ha5")
	monster.set_model_color(brightness, brightness, brightness, 128, "ha6")
	monster.set_model_color(brightness, brightness, brightness, 128, "skin8")
end

--- Repeats the walking attacks and the roar and then cools the body down to begin the magma phase.
local function run_ground_phase()
	while true do
		ground_phase_step = monster.get_variable(11) or ground_phase_step
		if ground_phase_step <= 1 then
			walk_to_random_point_and_attack()
		end
		if ground_phase_step <= 2 and ground_phase_step > 1 then
			chase_then_roar()
		end
		if ground_phase_step <= 3 and ground_phase_step > 2 then
			walk_to_random_point_and_attack()
		end
		if ground_phase_step > 3 then
			switch_heat_effects(0)
			flash_into_heat_state(0)
			ground_phase_step = 0
			monster.set_variable(9, 1)
			monster.set_variable(11, ground_phase_step)
			break
		else
			ground_phase_step = ground_phase_step + 1
			monster.set_variable(11, ground_phase_step)
		end
	end
end

--- Waits up to a number of frames for the current move to finish while shaking the camera on footsteps.
local function walk_until_arrived(max_frames: s32)
	local arrived: s32 = 0
	local motion_progress: f32 = 0
	for index = 0, max_frames - 1 do
		arrived = monster.is_move_finished() or arrived
		monster.get_target_distance()
		motion_progress = 1.0
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.524998) and motion_progress <= vm.f32(0.539998) then
			monster.shake_camera(1.8, 12)
		end
		if motion_progress >= vm.f32(0.97) then
			monster.shake_camera(1.8, 9)
		end
		if arrived == 0 then
			vm.wait()
		else
			monster.stop_moving()
			return
		end
	end
end

--- Waits until the monster faces an angle within a tolerance or the frame limit passes, and returns the frames waited.
local function wait_until_facing(target_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local rotation_y: f32 = 0
	local frame: s32 = 0
	local frame_limit: s32 = 0
	local motion_progress: f32 = 0
	target_degrees = calc.degrees_to_radians(target_degrees)
	if target_degrees > vm.f32(3.1415927) then
		target_degrees = vm.f32(target_degrees - vm.f32(6.2831855))
	end
	if target_degrees <= vm.f32(-3.1415927) then
		target_degrees = vm.f32(target_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = vm.ftoi(max_frames)
	frame = 0
	while frame < frame_limit do
		motion_progress = 1.0
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.524998) and motion_progress <= vm.f32(0.539998) then
			monster.shake_camera(1.2, 12)
		end
		if motion_progress >= vm.f32(0.97) then
			monster.shake_camera(1.2, 9)
		end
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		if rotation_y > vm.f32(target_degrees - tolerance_degrees) and rotation_y < vm.f32(target_degrees + tolerance_degrees) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_degrees, rotation_y, tolerance_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frame >= max_frames then
			movement.stop_turning()
			break
		else
			vm.wait()
			frame = frame + 1
		end
	end
	movement.stop_turning()
	return frame
end

--- Turns the monster to face the target and waits until it does.
local function turn_to_face_target(turn_speed: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed, 360.0)
	movement.stop_turning()
end

--- Walks to a spot away from or toward a moving target, then slams when the target is near or rests tired.
local function retreat_and_rest()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local old_pos_x: f32 = 0
	local old_pos_z: f32 = 0
	local retreat_angle: f32 = 0
	local distance: f32 = 0
	local roll: s32 = 0
	local frame_count: s32 = 0
	local range_class: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, _, out3 = monster.get_target_previous_position()
		old_pos_x = out1 or old_pos_x
		old_pos_z = out3 or old_pos_z
	end
	distance = monster.get_distance_between(target_x, target_y, target_z, pos_x, pos_y, pos_z) or distance
	retreat_angle = monster.get_target_angle() or retreat_angle
	if distance < 600.0 then
		retreat_angle = vm.f32(retreat_angle + vm.f32(3.1415927))
	end
	if retreat_angle > vm.f32(3.1415927) then
		retreat_angle = vm.f32(retreat_angle - vm.f32(6.2831855))
	end
	if retreat_angle <= vm.f32(-3.1415927) then
		retreat_angle = vm.f32(retreat_angle + vm.f32(6.2831855))
	end
	if target_x ~= old_pos_x and target_z ~= old_pos_z then
		monster.set_motion("歩き", -1, 0)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = 0.0
		pos_z = 0.0
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(retreat_angle) * 250.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(retreat_angle) * 250.0))
		retreat_angle = monster.get_angle_to_position(pos_x, pos_y, pos_z) or retreat_angle
		movement.turn_to_angle(calc.radians_to_degrees(retreat_angle), 5.0)
		movement.stop_turning()
		monster.move_toward_position(pos_x, pos_y, pos_z, 3.0, 3.0)
		distance = monster.get_distance_to_position(pos_x, pos_y, pos_z) or distance
		frame_count = vm.ftoi(vm.f32(distance / 3.0))
		walk_until_arrived(frame_count)
		monster.stop_moving()
		turn_to_face_target(5.0)
	end
	roll = monster.get_random(100) or roll
	if roll < 30 then
		range_class = monster.get_variable(5) or range_class
		if range_class == 1 then
			retreat_angle = monster.get_target_angle() or retreat_angle
			if retreat_angle > vm.f32(3.1415927) then
				retreat_angle = vm.f32(retreat_angle - vm.f32(6.2831855))
			end
			if retreat_angle <= vm.f32(-3.1415927) then
				retreat_angle = vm.f32(retreat_angle + vm.f32(6.2831855))
			end
			if retreat_angle < 0.0 then
				perform_slam_attack_3()
			else
				perform_slam_attack_4()
			end
			monster.set_motion("立ち", -1, 0)
			wait_frames(15)
		else
			monster.set_motion("疲労立ち", -1, 0)
			timer.wait_frames(90)
		end
	else
		monster.set_motion("疲労立ち", -1, 0)
		timer.wait_frames(120)
	end
end

--- Jumps to the magma pool nearest the target and surfaces there, returning 1 when already in magma.
local function jump_into_magma(wait_distance: f32, arrival_wait_frames: s32)
	local move_speed: f32 = 0
	local magma_flag: f32 = 0
	local candidate_distance: f32 = 0
	local nearest_distance: f32 = 0
	local jump_frames: f32 = 0
	local magma_x: f32 = 0
	local magma_y: f32 = 0
	local magma_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local move_x: f32 = 0
	local move_y: f32 = 0
	local move_z: f32 = 0
	local move_angle: f32 = 0
	local candidate_x: f32 = 0
	local candidate_y: f32 = 0
	local candidate_z: f32 = 0
	local value_int = true
	magma_flag = monster.get_variable(3) or magma_flag
	if magma_flag == 0 then
		monster.set_mask_flags(2, 1)
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		monster.get_position_3()
		nearest_distance = vm.f32(99999.9)
		for candidate_index = 0, 7 do
			if candidate_index == 0 then
				candidate_x = vm.f32(272.51)
				candidate_y = 0.0
				candidate_z = vm.f32(-568.85)
			end
			if candidate_index == 1 then
				candidate_x = vm.f32(503.09)
				candidate_y = 0.0
				candidate_z = vm.f32(-432.41)
			end
			if candidate_index == 2 then
				candidate_x = vm.f32(630.23)
				candidate_y = 0.0
				candidate_z = vm.f32(-179.24)
			end
			if candidate_index == 3 then
				candidate_x = vm.f32(633.72)
				candidate_y = 0.0
				candidate_z = vm.f32(36.76)
			end
			if candidate_index == 4 then
				candidate_x = vm.f32(562.85)
				candidate_y = 0.0
				candidate_z = vm.f32(308.49)
			end
			if candidate_index == 5 then
				candidate_x = vm.f32(320.65)
				candidate_y = 0.0
				candidate_z = vm.f32(542.79)
			end
			if candidate_index == 6 then
				candidate_x = vm.f32(-309.06)
				candidate_y = 0.0
				candidate_z = vm.f32(581.76)
			end
			if candidate_index == 7 then
				candidate_x = vm.f32(-527.6)
				candidate_y = 0.0
				candidate_z = vm.f32(387.76)
			end
			candidate_distance = monster.get_distance_between(target_x, target_y, target_z, candidate_x, candidate_y, candidate_z) or candidate_distance
			if candidate_distance < nearest_distance then
				nearest_distance = candidate_distance
				do
					local out1, out2, out3 = monster.copy_vector(candidate_x, candidate_y, candidate_z)
					magma_x = out1 or magma_x
					magma_y = out2 or magma_y
					magma_z = out3 or magma_z
				end
			end
		end
		monster.set_motion("歩き", -1, 0)
		if move_angle > vm.f32(3.1415927) then
			move_angle = vm.f32(move_angle - vm.f32(6.2831855))
		end
		if move_angle <= vm.f32(-3.1415927) then
			move_angle = vm.f32(move_angle + vm.f32(6.2831855))
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(magma_x, magma_y, magma_z)
			move_x = out1 or move_x
			move_y = out2 or move_y
			move_z = out3 or move_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(move_x, move_y, move_z, start_x, start_y, start_z)
			move_x = out1 or move_x
			move_y = out2 or move_y
			move_z = out3 or move_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(move_x, move_y, move_z)
			move_x = out1 or move_x
			move_y = out2 or move_y
			move_z = out3 or move_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(move_x, move_y, move_z, 450.0)
			move_x = out1 or move_x
			move_y = out2 or move_y
			move_z = out3 or move_z
		end
		move_angle = monster.get_angle_to_position(move_x, move_y, move_z) or move_angle
		movement.turn_to_angle(calc.radians_to_degrees(move_angle), 5.0)
		movement.stop_turning()
		monster.move_toward_position(move_x, 0.0, move_z, 3.0, 3.0)
		walk_until_arrived(180)
		monster.stop_moving()
		monster.set_motion("歩き", 0)
		turn_to_face_target(5.0)
		movement.stop_turning()
		do
			local out1, out2, out3 = monster.get_position_3()
			move_x = out1 or move_x
			move_y = out2 or move_y
			move_z = out3 or move_z
		end
		nearest_distance = monster.get_distance_between(move_x, move_y, move_z, magma_x, magma_y, magma_z) or nearest_distance
		jump_frames = 37.0
		move_speed = vm.f32(vm.fdiv(nearest_distance, jump_frames))
		print("magma flag=", if value_int then magma_flag else vm.float(magma_flag), "------------------\n")
		print("pos[0]=", vm.float(magma_x), "------------------\n")
		print("pos[1]=", vm.float(magma_y), "------------------\n")
		print("pos[2]=", vm.float(magma_z), "------------------\n\n")
		monster.set_monster_attributes(32, 1)
		monster.set_motion("ジャンプ入り", -1, 6)
		wait_frames(truncate_to_integer(14))
		monster.set_monster_attributes(16, 1)
		monster.move_toward_position(magma_x, magma_y, magma_z, move_speed, move_speed * 0.5)
		timer.wait_frames(truncate_to_integer(vm.ftoi(jump_frames)))
		monster.set_monster_attributes(16, 0)
		monster.set_position(magma_x, magma_y, magma_z)
		wait_frames(truncate_to_integer(vm.i32(20 - vm.ftoi(jump_frames))))
		switch_heat_effects(1)
		monster.set_effect_value(drip_effect, 1, 1)
		monster.create_effect_1("Ｍギルしぶき")
		monster.set_effect_first_vector(-1, magma_x, magma_y - 20.0, magma_z)
		monster.stop_moving()
		monster.set_motion("ジャンプ終わり", -1, 2)
		magma_flag = movement.turn_toward_target_and_wait(10.0)
		value_int = false
		if truncate_to_integer(74) > truncate_to_integer(magma_flag) then
			wait_frames(truncate_to_integer(vm.f32(74 - magma_flag)))
		end
		motion.wait_until_finished()
		do
			local out1, out2, out3 = monster.get_position_3()
			magma_x = out1 or magma_x
			magma_y = out2 or magma_y
			magma_z = out3 or magma_z
		end
		print("pos[0]=", vm.float(magma_x), "------------------\n")
		print("pos[1]=", vm.float(magma_y), "------------------\n")
		print("pos[2]=", vm.float(magma_z), "------------------\n")
		monster.set_variable(3, 1)
		monster.set_motion("マグマ立ち", -1, 0)
		monster.stop_moving()
		monster.set_monster_attributes(32, 0)
		flash_into_heat_state(1)
		if arrival_wait_frames ~= 0 then
			movement.turn_toward_target_and_wait(5.0)
			sense.wait_until_target_in_arc(wait_distance, 45.0, arrival_wait_frames)
		end
		return 0
	end
	return 1
end

--- Fires a series of fireballs toward the target, aimed directly when close and in a spread when far.
local function fireball_barrage(range_class: s32)
	local fireball_speed: f32 = 0
	local fireball_ratio: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local target_id: s32 = 0
	local enraged_stage: s32 = 0
	local roll: s32 = 0
	local attack: s32 = 0
	local character_number: s32 = 0
	local jitter: f32 = 0
	local spread_angle: f32 = 0
	print("Attack2------------------------\n")
	character_number = monster.get_character_number() or character_number
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	wait_frames(60)
	if range_class == 1 then
		fireball_speed = 15.0
		fireball_ratio = vm.f32(0.4)
	end
	if range_class == 2 then
		fireball_speed = 22.5
		fireball_ratio = vm.f32(0.3)
	end
	if range_class == 4 then
		fireball_speed = 20.0
		fireball_ratio = vm.f32(0.2)
	end
	if range_class == 8 then
		fireball_speed = 30.0
		fireball_ratio = vm.f32(0.15)
	end
	enraged_stage = monster.get_variable(4) or enraged_stage
	if enraged_stage == 0 then
		target_id = 0
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			target_id = 1
			fireball_speed = 20.0
		else
			target_id = 0
		end
	end
	do
		local out1, out2, out3 = monster.get_frame_position("dcol02")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	fireball_ratio = vm.f32(0.2)
	fireball_speed = 25.0
	target_id = 0
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.3)))
	target_distance = monster.get_target_distance() or target_distance
	for shot = 1, 4 do
		monster.play_monster_sound(character_number, 8)
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 400.0 then
			fireball_ratio = 1.0
			monster.create_effect_1("Ｍギル火炎弾２")
			monster.set_effect_target(-1, target_id)
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_second_vector(-1, 10.0, fireball_ratio, 0.0)
			monster.set_effect_value(-1, 0, attack)
			monster.set_effect_value(-1, 1, character_number)
			wait_frames(truncate_to_integer(15))
		else
			spread_angle = monster.get_target_angle() or spread_angle
			if spread_angle > vm.f32(3.1415927) then
				spread_angle = vm.f32(spread_angle - vm.f32(6.2831855))
			end
			if spread_angle <= vm.f32(-3.1415927) then
				spread_angle = vm.f32(spread_angle + vm.f32(6.2831855))
			end
			print("angle=", vm.float(spread_angle), "--------------------\n")
			fireball_ratio = vm.f32(0.19)
			jitter = monster.get_random_whole_number(10.0) or jitter
			fireball_ratio = vm.f32(fireball_ratio + vm.f32(jitter / 1000.0))
			print("ratio=", vm.float(fireball_ratio), "---------------------\n")
			if vm.imod(shot + 1, 2) == 1 then
				spread_angle = monster.get_random_whole_number(20.0) or spread_angle
				spread_angle = vm.f32(5.0 + spread_angle)
			else
				spread_angle = monster.get_random_whole_number(20.0) or spread_angle
				spread_angle = vm.f32(175.0 - spread_angle)
			end
			jitter = monster.get_random_whole_number(15.0) or jitter
			monster.create_effect_1("Ｍギル火炎弾２")
			monster.set_effect_target(-1, target_id)
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_second_vector(-1, fireball_speed, fireball_ratio, -spread_angle)
			monster.set_effect_value(-1, 0, attack)
			monster.set_effect_value(-1, 1, character_number)
			wait_frames(truncate_to_integer(30))
		end
	end
end

--- Jumps into the magma if needed and fires fireball barrages at the target.
local function attack_from_magma()
	local already_in_magma: s32 = 0
	local enraged_stage: s32 = 0
	local range_class: s32 = 0
	local roll: s32 = 0
	enraged_stage = monster.get_variable(4) or enraged_stage
	range_class = monster.get_variable(5) or range_class
	already_in_magma = jump_into_magma(1200.0, 30)
	if already_in_magma == 1 then
		movement.turn_toward_target_and_wait(5.0)
		fireball_barrage(range_class)
	end
	if enraged_stage == 2 then
		movement.turn_toward_target_and_wait(5.0)
		fireball_barrage(range_class)
		roll = monster.get_random(100) or roll
		if roll < 5 then
			movement.turn_toward_target_and_wait(5.0)
			fireball_barrage(range_class)
		end
	end
	monster.set_motion("マグマ立ち", -1, 0)
end

--- Leaps out of the magma toward the target or a point beside it and lands on the ground.
local function escape_magma()
	local magma_flag: s32 = 0
	local roll: s32 = 0
	local jump_speed: f32 = 0
	local jump_frames: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_angle: f32 = 0
	magma_flag = monster.get_variable(3) or magma_flag
	if magma_flag == 1 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = monster.get_target_position()
				destination_x = out1 or destination_x
				destination_y = out2 or destination_y
				destination_z = out3 or destination_z
			end
			jump_speed = monster.get_distance_between(pos_x, pos_y, pos_z, destination_x, 0.0, destination_z) or jump_speed
			jump_frames = 26.0
			jump_speed = vm.f32(vm.fdiv(jump_speed, jump_frames))
		else
			monster.set_motion("歩き", 0)
			turn_to_face_target(10.0)
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			target_angle = monster.get_target_angle() or target_angle
			destination_x = vm.f32(250.0 * vm.sin(target_angle))
			destination_y = pos_y
			destination_z = vm.f32(250.0 * vm.cos(target_angle))
			do
				local out1, out2, out3 = monster.get_target_position()
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			jump_speed = monster.get_distance_between(target_x, target_y, target_z, destination_x, destination_y, destination_z) or jump_speed
			if jump_speed > 250.0 then
				target_angle = monster.get_target_angle() or target_angle
				target_angle = vm.f32(target_angle + vm.f32(3.1415927))
				if target_angle > vm.f32(3.1415927) then
					target_angle = vm.f32(target_angle - vm.f32(6.2831855))
				end
				if target_angle <= vm.f32(-3.1415927) then
					target_angle = vm.f32(target_angle + vm.f32(6.2831855))
				end
				destination_x = vm.f32(250.0 * vm.sin(target_angle))
				destination_y = pos_y
				destination_z = vm.f32(250.0 * vm.cos(target_angle))
			end
			jump_speed = monster.get_distance_between(pos_x, pos_y, pos_z, destination_x, 0.0, destination_z) or jump_speed
			jump_frames = 26.0
			jump_speed = vm.f32(vm.fdiv(jump_speed, jump_frames))
			ground_phase_step = 2
		end
		monster.set_motion("マグマ脱出", -1, 6)
		wait_frames(truncate_to_integer(29))
		monster.move_toward_position(destination_x, 0.0, destination_z, jump_speed, jump_speed * 0.5)
		wait_frames(truncate_to_integer(30))
		monster.shake_camera(2.5, truncate_to_integer(20))
		motion.wait_until_finished()
		monster.stop_moving()
		monster.set_variable(3, 0)
		monster.set_mask_flags(2, 0)
		return
	end
end

--- Rests, repeats the magma attacks and then leaves the magma to begin the ground phase.
local function run_magma_phase()
	while true do
		magma_phase_step = monster.get_variable(12) or magma_phase_step
		if magma_phase_step < 1 then
			retreat_and_rest()
		else
			attack_from_magma()
		end
		if magma_phase_step >= 3 then
			escape_magma()
			magma_phase_step = 0
			monster.set_variable(9, 2)
			monster.set_variable(12, magma_phase_step)
			break
		else
			magma_phase_step = magma_phase_step + 1
			monster.set_variable(12, magma_phase_step)
		end
	end
end

--- Updates the enraged stage and range class every frame and runs the ground or magma phase.
local function select_phase()
	local target_distance: f32 = 0
	local life: f32 = 0
	local life_points: s32 = 0
	local phase: s32 = 0
	local life_int = true
	ground_phase_step = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		life = (if life_int then vm.bits_float(monster.get_life_int()) else monster.get_life()) or life
		print("life=", vm.float(life), "----------\n")
		life_int = false
		life_points = monster.get_life_int() or life_points
		if vm.f32(life_points / 200.0) < 0.5 or life < 0.5 and life ~= 0.0 then
			monster.set_variable(4, 0)
			if vm.f32(life_points / 200.0) < vm.f32(0.2) or life < 0.5 and life ~= 0.0 then
				monster.set_variable(4, 2)
			end
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance >= 1200.0 then
			vm.wait()
			return
		end
		if target_distance < 1200.0 and target_distance >= 800.0 then
			print("FarRange-------------------------------\n")
			monster.set_variable(5, 4)
		elseif target_distance < 800.0 and target_distance >= 400.0 then
			print("MidRange-------------------------------\n")
			state.do_nothing()
			monster.set_variable(5, 2)
		else
			print("NearRange-------------------------------\n")
			state.do_nothing()
			monster.set_variable(5, 1)
		end
		phase = monster.get_variable(9) or phase
		if phase == 2 then
			run_ground_phase()
		elseif phase == 1 then
			run_magma_phase()
		end
		vm.wait()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Loads the fire and shockwave effects, registers the slam hits and sets the starting phase.
function script.init()
	print("initialize -------------------\n")
	ground_phase_step = 0
	magma_phase_step = 0
	monster.register_damage_hit("吹っ飛び弱", 9.0, "攻撃３", 0.393, 0.426, 0)
	monster.register_damage_hit("吹っ飛び弱", 9.0, "攻撃４", 0.393, 0.426, 1)
	monster.load_effect_script("Ｍギル火炎弾２")
	monster.load_effect_script("Ｍギル火炎弾３")
	monster.load_effect_script("ヴァンガード衝撃波")
	monster.load_effect_script("Ｍギル火柱１")
	monster.load_effect_script("Ｍギルぽたぽた")
	monster.load_effect_script("Ｍギルしぶき")
	monster.load_effect_script("Ｍギル煙")
	monster.set_camera_mode(4)
	monster.set_model_lighting(0)
	monster.set_model_color(128, 128, 128, 128)
	ground_phase_step = 0
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	monster.set_variable(4, 0)
	monster.set_variable(5, 0)
	monster.set_variable(6, 128)
	monster.set_variable(7, 128)
	monster.set_variable(8, 128)
	monster.set_variable(9, 2)
	monster.set_variable(11, 0)
	monster.set_variable(12, 0)
	configure_clip_distance()
	monster.set_clip_distance(9999.9)
	monster.set_photo_opportunity(1017)
	start_drip_effect()
end

--- Runs the phase selection forever.
function script.loop()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	print("start---------\n")
	while true do
		select_phase()
	end
end

--- Roars when hit and spits fireballs in the enraged form.
function script.on_damage()
	local enraged_stage: s32 = 0
	monster.set_monster_attributes(32, 0)
	enraged_stage = monster.get_variable(4) or enraged_stage
	if enraged_stage == 0 then
		roar_and_spray_fireballs(0)
	else
		roar_and_spray_fireballs(1)
	end
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores knockdown hits.
function script.on_knockdown() end

--- Cancels the attack state when guarding.
function script.on_guard()
	monster.set_monster_attributes(32, 0)
end

--- Stops moving and turning and cancels the attack state when dodging.
function script.on_dodge_1()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	movement.stop_turning()
end

--- Stops moving and turning and cancels the attack state when dodging.
function script.on_dodge_2()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	movement.stop_turning()
end

--- Plays the death in the magma or on the ground and requests the defeat event.
function script.on_death()
	local magma_flag: s32 = 0
	monster.finish_effect(drip_effect)
	monster.finish_effect(smoke_effect)
	monster.stop_moving()
	movement.stop_turning()
	monster.set_camera_mode(0)
	monster.set_monster_attributes(64, 1)
	monster.set_monster_attributes(2, 1)
	monster.start_death()
	magma_flag = monster.get_variable(3) or magma_flag
	monster.reset_motion()
	if magma_flag == 1 then
		monster.set_motion("マグマ死に", -1, 6)
	else
		monster.set_motion("死に", -1, 6)
	end
	motion.wait_until_finished()
	monster.request_event_script(570)
	timer.wait_frames(30)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Stops moving and turning and cancels the attack state when caught.
function script.on_caught()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	movement.stop_turning()
end

--- Stops moving and turning and cancels the attack state after a throw.
function script.on_land()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	movement.stop_turning()
	return 1
end

--- Stops moving and turning and cancels the attack state when stunned.
function script.on_stun()
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	movement.stop_turning()
end

return script
