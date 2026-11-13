--!strict
--- Controls the second phase of the Emperor Griffon boss fight, where it fights on the ground with blades.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets a short clip distance for ordinary monsters and an effectively unlimited one for bosses.
local function apply_boss_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Starts the transition cutscene once life drops low enough.
local function check_phase_transition()
	local has_transitioned: s32 = 0
	local life: f32 = 0
	life = 0.0
	life = monster.get_life() or life
	if life < vm.f32(0.34) then
		has_transitioned = monster.get_variable(7) or has_transitioned
		if has_transitioned == 0 then
			monster.set_variable(7, 1)
			monster.request_event_script(501)
		end
	end
end

--- Checks whether the griffon should change phase.
local function update_phase()
	check_phase_transition()
end

--- Checks for a phase change and waits one frame.
local function wait_frame()
	update_phase()
	vm.wait()
end

--- Waits until the griffon faces the given angle, within a tolerance or a frame limit, and returns the frames waited.
local function wait_until_facing_angle(target_angle: f32, turn_speed: f32, max_frames: f32)
	local current_angle: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local tolerance: f32 = 0
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
		tolerance = calc.degrees_to_radians(3.0)
	else
		tolerance = turn_speed
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle - tolerance) and current_angle < vm.f32(target_angle + tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle, current_angle, turn_speed) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns the griffon toward its target and waits until it faces it.
local function face_target(turn_speed: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing_angle(calc.radians_to_degrees(target_angle), turn_speed, 360.0)
	movement.stop_turning()
end

--- Turns toward the target every frame for a number of frames.
local function track_target_for_frames(rot_speed: f32, frame_count: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(rot_speed)
	for i = 0, frame_count - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame()
	end
	movement.stop_turning()
end

--- Waits a number of frames while checking for a phase change.
local function wait_frames_updating_phase(frame_count: s32)
	for i = 0, frame_count - 1 do
		check_phase_transition()
		vm.wait()
	end
end

--- Swings its blades to release a cross-shaped cutter at the target.
local function cross_cutter_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 6)
	track_target_for_frames(vm.f32(4.2), calc.pass_through(15))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("クロスカッター")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	wait_frames_updating_phase(calc.pass_through(9))
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Leaps toward the target and slams down with a camera shake.
local function leap_slam_attack()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local move_speed: f32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.set_motion("攻撃３", -1, 6)
	track_target_for_frames(vm.f32(4.2), calc.pass_through(34))
	monster.get_rotation()
	monster.get_position_3()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	target_distance = monster.get_target_distance() or target_distance
	move_speed = vm.f32(vm.fdiv(target_distance, 25))
	monster.move_toward_position(target_x, target_y, target_z, move_speed, move_speed)
	wait_frames_updating_phase(calc.pass_through(25))
	monster.stop_moving()
	monster.shake_camera(3.0, 30)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	wait_frames_updating_phase(9)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Walks toward the target in a ready stance until it is near or a frame limit passes.
local function chase_target_in_stance(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local frame_index: s32 = 0
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
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
		monster.turn_toward_angle(target_angle, rot_speed)
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		monster.get_rotation()
		monster.move_toward_position(target_x, target_y - 20.0, target_z, move_speed, move_speed)
		wait_frame()
		frame_index = frame_index + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Plays the taunting motion.
local function taunt()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.set_motion("挑発", -1, 0)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Picks an action when the target is far away.
local function choose_far_attack()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("構え歩き", -1, 0)
		face_target(vm.f32(4.2))
		roll = monster.get_random(100) or roll
		if roll < 50 then
			cross_cutter_attack()
		else
			leap_slam_attack()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("構え歩き", -1, 0)
			chase_target_in_stance(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
			monster.set_motion("構え立ち", -1, 0)
		else
			taunt()
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("構え歩き", -1, 0)
				face_target(vm.f32(4.2))
				cross_cutter_attack()
			elseif roll > 30 and roll < 65 then
				monster.set_motion("構え歩き", -1, 0)
				chase_target_in_stance(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
				monster.set_motion("構え立ち", -1, 0)
			end
		end
	end
end

--- Picks an action when the target is at middle range.
local function choose_mid_attack()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 68 then
		monster.set_motion("構え歩き", -1, 0)
		face_target(vm.f32(4.2))
		roll = monster.get_random(100) or roll
		if roll < 30 then
			cross_cutter_attack()
		else
			leap_slam_attack()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("構え歩き", -1, 0)
			chase_target_in_stance(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
			monster.set_motion("構え立ち", -1, 0)
		else
			taunt()
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("構え歩き", -1, 0)
				face_target(vm.f32(4.2))
				cross_cutter_attack()
			elseif roll > 30 and roll < 65 then
				monster.set_motion("構え歩き", -1, 0)
				chase_target_in_stance(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
				monster.set_motion("構え立ち", -1, 0)
			end
		end
	end
end

--- Slashes while advancing toward the target in two steps and shakes the camera.
local function charging_slash_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 6)
	track_target_for_frames(vm.f32(4.2), calc.pass_through(18))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(rotation_y) * 200.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(rotation_y) * 200.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 1.8, 1.8)
	chase_target_in_stance(vm.f32(1.8), vm.f32(4.2), 0.0, 1)
	monster.stop_moving()
	track_target_for_frames(vm.f32(4.2), calc.pass_through(40))
	monster.move_toward_position(pos_x, pos_y, pos_z, 1.8, 1.8)
	timer.wait_frames(calc.pass_through(24))
	monster.shake_camera(3.0, 30)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	wait_frames_updating_phase(calc.pass_through(9))
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Steps backward out of reach.
local function step_back()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(rotation_y + vm.f32(3.1415927))) * 200.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(rotation_y + vm.f32(3.1415927))) * 200.0))
	monster.set_motion("ステップ後", -1, 6)
	wait_frames_updating_phase(calc.pass_through(9))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	wait_frames_updating_phase(calc.pass_through(15))
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
end

--- Steps to the right, circling the target if it is not close.
local function step_right()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local target_distance: f32 = 0
	local move_speed: f32 = 0
	local is_close_range: s32 = 0
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 120.0 then
		is_close_range = 1
		move_speed = vm.f32(3.6000001)
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		rotation_y = vm.f32(rotation_y - vm.f32(1.5707964))
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(rotation_y) * 200.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(rotation_y) * 200.0))
	else
		is_close_range = 0
		target_distance = 90.0
		move_speed = vm.f32(vm.fdiv(target_distance, 14))
		pos_x, pos_y, pos_z = movement.get_approach_point(30.0, target_distance, pos_x, pos_y, pos_z)
	end
	monster.set_motion("ステップ右", -1, 6)
	wait_frames_updating_phase(calc.pass_through(10))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, move_speed, move_speed)
	if is_close_range ~= 0 then
		wait_frames_updating_phase(calc.pass_through(14))
	else
		track_target_for_frames(vm.f32(4.2), calc.pass_through(14))
	end
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
end

--- Steps to the left, circling the target if it is not close.
local function step_left()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local target_distance: f32 = 0
	local is_close_range: s32 = 0
	monster.set_motion("構え歩き", -1, 0)
	face_target(vm.f32(4.2))
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 120.0 then
		is_close_range = 1
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		rotation_y = vm.f32(rotation_y + vm.f32(1.5707964))
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(rotation_y) * 200.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(rotation_y) * 200.0))
	else
		is_close_range = 0
		target_distance = 90.0
		pos_x, pos_y, pos_z = movement.get_approach_point(-30.0, target_distance, pos_x, pos_y, pos_z)
	end
	monster.set_motion("ステップ左", -1, 6)
	wait_frames_updating_phase(calc.pass_through(10))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	if is_close_range ~= 0 then
		wait_frames_updating_phase(calc.pass_through(14))
	else
		track_target_for_frames(vm.f32(4.2), calc.pass_through(14))
	end
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
end

--- Picks an attack or evasive step when the target is close.
local function choose_close_attack()
	local distance: f32 = 0
	local target_angle: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			charging_slash_attack()
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				cross_cutter_attack()
			else
				leap_slam_attack()
			end
		end
	elseif distance < 150.0 then
		step_back()
	else
		target_angle = monster.get_target_angle() or target_angle
		if target_angle > vm.f32(3.1415927) then
			target_angle = vm.f32(target_angle - vm.f32(6.2831855))
		end
		if target_angle <= vm.f32(-3.1415927) then
			target_angle = vm.f32(target_angle + vm.f32(6.2831855))
		end
		if target_angle < 0.0 then
			step_right()
		else
			step_left()
		end
	end
end

--- Picks an action set from the distance to the target.
local function choose_action_by_distance()
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 9999.0 and target_distance >= 400.0 then
		choose_far_attack()
	elseif target_distance < 400.0 and target_distance >= 150.0 then
		choose_mid_attack()
	else
		choose_close_attack()
	end
end

--- Locks the griffon in place facing the target after a knockdown.
local function prepare_knockdown()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	wait_frame()
	monster.set_action_status(1)
end

local script = {}

--- Runs once when the script loads.
function script.setup() end

--- Registers the griffon's attack hit windows, sword trails and cutter effect.
function script.init()
	monster.register_damage_hit("弱攻撃", 15.4, "攻撃１", 0.13, 0.17, 2, 1)
	monster.register_damage_hit("弱攻撃", 15.4, "攻撃１", 0.13, 0.192, 4, 0)
	monster.register_damage_hit("弱攻撃", 11.4, "攻撃１", 0.329, 0.363, 2, 3)
	monster.register_damage_hit("通常攻撃", 11.4, "攻撃１", 0.555, 0.589, 4, 5)
	monster.register_damage_hit("通常攻撃", 11.4, "攻撃１", 0.555, 0.589, 2, 3)
	monster.register_damage_hit("中ＢＧＣ", 11.4, "攻撃１", 0.705, 0.74, 2, 3)
	monster.register_damage_hit("中ＢＧＣ", 11.4, "攻撃１", 0.705, 0.74, 4, 5)
	monster.register_damage_hit("通常ＢＧＣ", 11.4, "攻撃３", 0.602, 0.682, 4, 5)
	monster.register_damage_hit("通常ＢＧＣ", 11.4, "攻撃３", 0.602, 0.682, 2, 3)
	monster.load_effect_script("クロスカッター")
	monster.add_sword_trail(0, "攻撃１", 0.123, 0.6, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.add_sword_trail(1, "攻撃１", 0.123, 0.6, "dcol_r00", "dcol_r01", 75, 30, 45)
	monster.add_sword_trail(0, "攻撃２", 0.26, 0.264, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.add_sword_trail(1, "攻撃２", 0.26, 0.264, "dcol_r00", "dcol_r01", 75, 30, 45)
	monster.add_sword_trail(0, "攻撃３", 0.477, 0.48, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.add_sword_trail(1, "攻撃３", 0.477, 0.48, "dcol_r00", "dcol_r01", 75, 30, 45)
	monster.add_sword_trail(0, "挑発", 0.28, 0.284, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.set_clip_distance(9999.9)
	monster.set_camera_mode(4)
	monster.set_life(0.67)
	monster.set_variable(7, 0)
	apply_boss_clip_distance()
end

--- Repeatedly chooses an action by distance to the target.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(32, 0)
	monster.set_motion("構え立ち", -1, 4)
	while true do
		vm.wait()
		check_phase_transition()
		choose_action_by_distance()
	end
end

--- Staggers back from a hit and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	wait_frames_updating_phase(calc.pass_through(12))
	monster.set_motion("構え立ち")
	state.do_nothing()
end

--- Faces the target after being knocked down.
function script.on_knockdown()
	prepare_knockdown()
	state.unlock_and_clear_action()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the griffon never guards.
function script.on_guard() end

--- Steps back or aside to dodge.
function script.on_dodge_1()
	local roll: s32 = 0
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	vm.wait()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		step_back()
	else
		target_angle = monster.get_target_angle() or target_angle
		if target_angle < 0.0 then
			step_right()
		else
			step_left()
		end
	end
	monster.set_motion("構え立ち", -1, 0)
	state.unlock()
end

--- Counterattacks with a cross cutter or steps aside to dodge.
function script.on_dodge_2()
	local roll: s32 = 0
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("構え歩き", -1, 0)
		face_target(vm.f32(4.2))
		cross_cutter_attack()
	else
		target_angle = monster.get_target_angle() or target_angle
		if target_angle > vm.f32(3.1415927) then
			target_angle = vm.f32(target_angle - vm.f32(6.2831855))
		end
		if target_angle <= vm.f32(-3.1415927) then
			target_angle = vm.f32(target_angle + vm.f32(6.2831855))
		end
		if target_angle < 0.0 then
			step_right()
		else
			step_left()
		end
	end
	monster.set_motion("構え立ち", -1, 0)
	state.unlock()
end

--- Finishes the phase check and restores the life so the fight continues into the next phase.
function script.on_death()
	check_phase_transition()
	monster.set_life(0.34)
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing on landing.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when stunned.
function script.on_stun() end

return script
