--!strict
--- Controls the final phase of the Emperor Griffon boss fight, where it fights with flaming attacks.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
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

--- Performs a long flaming combo with a camera shake at the end.
local function combo_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	monster.set_motion("攻撃４", -1, 6)
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
	monster.create_effect_1("グリコンボ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	timer.wait_frames(calc.pass_through(119))
	monster.shake_camera(3.0, 45)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	timer.wait_frames(calc.pass_through(15))
end

--- Charges the target and follows with a combo if the player is in a specific status.
local function charge_attack_then_combo()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local move_speed: f32 = 0
	local player_status: s32 = 0
	monster.set_motion("構え歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	monster.set_motion("攻撃３", -1, 6)
	timer.wait_frames(calc.pass_through(33))
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, out2, out3 = monster.get_position_3()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.get_rotation()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	move_speed = vm.f32(vm.fdiv(target_distance, 31))
	monster.move_toward_position(target_x, target_y, target_z, move_speed, move_speed)
	timer.wait_frames(calc.pass_through(31))
	monster.stop_moving()
	monster.shake_camera(3.0, 45)
	motion.wait_until_finished()
	player_status = monster.get_player_status_attribute() or player_status
	if player_status == 8 then
		combo_attack()
	end
end

--- Waits a number of frames and charges the target when the player is in a specific status and the cooldown has run out.
local function wait_frames_with_counter_charge(frame_count: s32)
	local frame_index: s32 = 0
	local player_status: s32 = 0
	local cooldown: s32 = 0
	cooldown = monster.get_variable(5) or cooldown
	frame_index = 0
	while frame_index < frame_count do
		player_status = monster.get_player_status_attribute() or player_status
		if player_status == 8 and cooldown <= 0 then
			charge_attack_then_combo()
			cooldown = 90
		end
		vm.wait()
		frame_index = frame_index + 1
		cooldown = vm.i32(cooldown - 1)
	end
	cooldown = 0
	monster.set_variable(5, cooldown)
end

--- Charges at the target and slams into it with a camera shake.
local function charge_attack()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance: f32 = 0
	local move_speed: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	wait_frames_with_counter_charge(1)
	monster.set_motion("攻撃３", -1, 6)
	timer.wait_frames(calc.pass_through(33))
	do
		local out1, out2, out3 = monster.get_position_3()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.get_rotation()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	move_speed = 3.0
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	target_distance = monster.get_target_distance() or target_distance
	move_speed = vm.f32(vm.fdiv(target_distance, calc.pass_through(30)))
	monster.move_toward_position(target_x, target_y, target_z, move_speed, move_speed)
	timer.wait_frames(calc.pass_through(31))
	monster.stop_moving()
	monster.shake_camera(3.0, 45)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
end

--- Slashes with each wing in turn, releasing a flaming slash effect with each.
local function double_slash_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local effect_scale: f32 = 0
	local effect_flag: s32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("構え歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	monster.set_motion("構え立ち", -1, 0)
	wait_frames_with_counter_charge(1)
	monster.set_motion("攻撃２", -1, 6)
	movement.track_target(vm.f32(4.2), calc.pass_through(23))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_r")
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
	pos_y = 0.0
	effect_flag = 0
	monster.get_random(100)
	effect_flag = 1
	effect_scale = monster.get_random_whole_number(0.25) or effect_scale
	effect_scale = vm.f32(effect_scale + vm.f32(0.2))
	monster.create_effect_1("グリＳＷＦ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.create_effect_1("グリＳＷＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, effect_scale)
	monster.set_effect_value(-1, 2, effect_flag)
	monster.set_effect_value(-1, 3, 0)
	monster.set_effect_value_float(-1, 4, -1.5707964)
	movement.track_target(vm.f32(4.2), calc.pass_through(24))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_l")
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
	pos_y = 0.0
	effect_flag = 0
	monster.get_random(100)
	effect_flag = 1
	effect_scale = monster.get_random_whole_number(0.25) or effect_scale
	effect_scale = vm.f32(effect_scale + vm.f32(0.2))
	monster.create_effect_1("グリＳＷＦ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.create_effect_1("グリＳＷＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, effect_scale)
	monster.set_effect_value(-1, 2, effect_flag)
	monster.set_effect_value(-1, 3, 0)
	monster.set_effect_value_float(-1, 4, 1.5707964)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	wait_frames_with_counter_charge(9)
end

--- Picks an action when the target is far away.
local function choose_far_attack()
	local target_distance: f32 = 0
	local roll: s32 = 0
	print("far range--------------------\n")
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 650.0 then
		monster.set_motion("構え歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.2))
		charge_attack()
	end
	roll = monster.get_random(100) or roll
	if roll < 85 then
		monster.set_motion("構え歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.2))
		double_slash_attack()
	else
		monster.set_motion("構え歩き", -1, 0)
		movement.chase_target(2.0, vm.f32(4.2), 55.0, 90)
		monster.set_motion("構え立ち", -1, 0)
	end
end

--- Strikes the ground to release a shockwave and shakes the camera.
local function shockwave_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("構え歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	wait_frames_with_counter_charge(1)
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target(vm.f32(4.2), calc.pass_through(38))
	monster.shake_camera(3.0, calc.pass_through(45))
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
	monster.create_effect_1("グリ衝撃波")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
	monster.set_motion("構え立ち", -1, 0)
	wait_frames_with_counter_charge(9)
end

--- Picks an action when the target is at middle range.
local function choose_mid_attack()
	local roll: s32 = 0
	print("mid range---------------------\n")
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 15 then
			shockwave_attack()
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				monster.set_motion("構え歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.2))
				double_slash_attack()
			else
				charge_attack()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("構え歩き", -1, 0)
			movement.chase_target_directly(2.0, vm.f32(4.2), 55.0, 90)
			monster.set_motion("構え立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("構え歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.2))
				double_slash_attack()
			elseif roll > 30 and roll < 65 then
				monster.set_motion("構え歩き", -1, 0)
				movement.chase_target_directly(2.0, vm.f32(4.2), 55.0, 90)
				monster.set_motion("構え立ち", -1, 0)
			end
		end
	end
end

--- Steps backward out of reach.
local function step_back()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	monster.set_motion("構え歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.2))
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
	timer.wait_frames(calc.pass_through(9))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	timer.wait_frames(calc.pass_through(15))
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
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 110.0 then
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
		target_distance = 85.0
		move_speed = vm.f32(vm.fdiv(target_distance, calc.pass_through(14)))
		pos_x, pos_y, pos_z = movement.get_approach_point(30.0, target_distance, pos_x, pos_y, pos_z)
	end
	monster.set_motion("ステップ右", -1, 6)
	timer.wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, move_speed, move_speed)
	if is_close_range ~= 0 then
		timer.wait_frames(calc.pass_through(14))
	else
		movement.track_target(vm.f32(4.2), calc.pass_through(14))
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
	movement.turn_toward_target_and_wait(vm.f32(4.2))
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 110.0 then
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
		target_distance = 85.0
		pos_x, pos_y, pos_z = movement.get_approach_point(-30.0, target_distance, pos_x, pos_y, pos_z)
	end
	monster.set_motion("ステップ左", -1, 6)
	timer.wait_frames(calc.pass_through(10))
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	if is_close_range ~= 0 then
		timer.wait_frames(calc.pass_through(14))
	else
		movement.track_target(vm.f32(4.2), calc.pass_through(14))
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
	print("near range---------------------\n")
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 85 then
			shockwave_attack()
		else
			roll = monster.get_random(100) or roll
			if roll < 90 then
				double_slash_attack()
			else
				charge_attack()
			end
		end
	elseif distance < 110.0 then
		step_back()
	else
		monster.get_target_angle(target_angle)
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
	if target_distance < 9999.0 and target_distance >= 300.0 then
		choose_far_attack()
	elseif target_distance < 300.0 and target_distance >= 120.0 then
		choose_mid_attack()
	else
		choose_close_attack()
	end
end

local script = {}

--- Runs once when the script loads.
function script.setup() end

--- Registers the griffon's hit windows, loads its flame and slash effects and attaches the flame aura.
function script.init()
	local character_number: s32 = 0
	local flame_effect_slot: s32 = 0
	monster.register_damage_hit("吹っ飛び強", 7.4, "攻撃３", 0.578, 0.627, 0)
	monster.register_damage_hit("吹っ飛び強", 7.4, "攻撃３", 0.578, 0.627, 1)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.107, 0.214, 0)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.221, 0.279, 1)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.286, 0.336, 0)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.343, 0.4, 1)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.407, 0.457, 0)
	monster.register_damage_hit("グリコンボ", 20.0, "攻撃４", 0.464, 0.543, 1)
	monster.register_damage_hit("グリコンボ２", 20.0, "攻撃４", 0.636, 0.707, 0)
	monster.load_effect_script("グリコンボ")
	monster.load_effect_script("グリＳＷＦ")
	monster.load_effect_script("グリＳＷＬ")
	monster.load_effect_script("グリ衝撃波")
	monster.load_effect_script("グリ炎")
	character_number = monster.get_character_number() or character_number
	flame_effect_slot = monster.create_effect_2("グリ炎") or flame_effect_slot
	monster.set_effect_owner(flame_effect_slot, character_number)
	monster.set_variable(6, flame_effect_slot)
	monster.set_clip_distance(9999.9)
	monster.set_camera_mode(4)
	monster.set_life(0.34)
	monster.set_variable(5, 0)
	monster.set_variable(7, 0)
	apply_boss_clip_distance()
end

--- Repeatedly chooses an action by distance to the target.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("構え立ち", -1, 4)
	while true do
		vm.wait()
		choose_action_by_distance()
	end
end

--- Staggers back from a hit and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(calc.pass_through(12))
	monster.set_motion("構え立ち")
	state.do_nothing()
end

--- Faces the target after being knocked down.
function script.on_knockdown()
	state.lock_and_face_target()
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

--- Counterattacks with a double slash or steps aside to dodge.
function script.on_dodge_2()
	local roll: s32 = 0
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.set_motion("構え歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.2))
		double_slash_attack()
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
		double_slash_attack()
	end
	monster.set_motion("構え立ち", -1, 0)
	state.unlock()
end

--- Plays the final death, stopping sounds and the flame aura and starting the ending cutscene.
function script.on_death()
	local flame_effect_slot: s32 = 0
	death.begin()
	monster.stop_sound(2)
	monster.stop_sound(3)
	monster.stop_sound(4)
	monster.stop_sound(5)
	monster.stop_sound(6)
	monster.stop_sound(7)
	monster.stop_sound(23)
	flame_effect_slot = monster.get_variable(6) or flame_effect_slot
	monster.finish_effect(flame_effect_slot)
	monster.request_event_script(502)
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_effects()
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
