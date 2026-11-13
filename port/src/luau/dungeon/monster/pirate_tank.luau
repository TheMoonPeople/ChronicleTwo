--!strict
--- Controls the Pirate Tank, a cannon monster that fires shells and launches pirate bombs.

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

--- Sets the monster's default guard and clip-distance settings, with unlimited clip distance for bosses.
local function apply_default_settings()
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

--- Strafes around the target at a fixed distance or idles in place while waiting for an opening.
local function keep_distance_while_waiting()
	local roll: s32 = 0
	local offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_degrees = monster.get_random_whole_number(30.0) or offset_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 90.0)
		if roll < 50 then
			offset_degrees = vm.f32(-offset_degrees - 30.0)
		else
			offset_degrees = vm.f32(offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(1.75, vm.f32(4.8), offset_degrees, distance, 30.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(30.0, 45.0, 30)
	end
end

--- Turns toward the target using the side-step motion for the turn direction.
local function turn_toward_target_with_side_step(turn_speed: f32)
	local target_angle: f32 = 0
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	if target_angle < 0.0 then
		monster.set_motion("歩き右", -1, 0)
	else
		monster.set_motion("歩き左", -1, 0)
	end
	movement.turn_toward_target_and_wait_guarded(turn_speed)
	monster.set_motion("立ち", -1, 0)
end

--- Spawns a pirate bomb from the cannon with a smoke effect unless too many monsters exist.
local function launch_bomb(hold_frames: f32)
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local grade: s32 = 0
	argc = monster.get_monster_count() or argc
	if argc >= 20 then
		return
	end
	turn_toward_target_with_side_step(vm.f32(4.8))
	monster.set_motion("攻撃２in", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("攻撃２", -1, 0)
	timer.wait_frames_with_guard_update(hold_frames)
	monster.set_motion("攻撃２out", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	monster.create_effect_1("Ｍ煙")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value_float(-1, 0, 1.0)
	grade = monster.get_monster_grade_2(-1) or grade
	monster.create_monster(vm.i32(1002 + grade), pos_x, pos_y, pos_z, yaw)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Picks a random bomb launch, circling move or wait for a target at long range.
local function choose_long_range_move()
	local roll: s32 = 0
	local threat_result: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 45 then
		launch_bomb(4.2e-44) -- retail: the integer 30 is passed where the callee reads a float, so it reads its bits
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
			movement.walk_to_point_near_target(1.75, vm.f32(4.8), strafe_degrees, 60.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			monster.set_motion("立ち", -1, 0)
			threat_result = sense.wait_until_target_threatening_guarded(270.0, 60.0, 100.0, vm.f32(1.2), 60)
			if threat_result == 1 then
				turn_toward_target_with_side_step(vm.f32(4.8))
				launch_bomb(8.4e-44) -- retail: the integer 60 is passed where the callee reads a float, so it reads its bits
			end
		end
	end
end

--- Turns to the target and fires a high-speed shell from the cannon.
local function fire_cannon()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local attack: s32 = 0
	local yaw: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_variable(0, 1)
	turn_toward_target_with_side_step(vm.f32(4.8))
	monster.set_motion("攻撃１", -1, 6)
	movement.turn_until_motion_progress(vm.f32(4.8), vm.f32(0.09), -1.0)
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	do
		local out1, out2, out3 = monster.copy_vector(vm.sin(yaw), 0.0, vm.cos(yaw))
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
	monster.create_effect_1("高速弾")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, 10.0)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Walks backward away from the target and returns -1 when the way is blocked.
local function retreat_backward(speed: f32, distance: f32, near_distance: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local clear_distance: f32 = 0
	local backward_yaw: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	backward_yaw = vm.f32(yaw + vm.f32(3.1415927))
	if backward_yaw > vm.f32(3.1415927) then
		backward_yaw = vm.f32(backward_yaw - vm.f32(6.2831855))
	end
	if backward_yaw <= vm.f32(-3.1415927) then
		backward_yaw = vm.f32(backward_yaw + vm.f32(6.2831855))
	end
	clear_distance = monster.get_clear_distance(80.0, 3.1415927) or clear_distance
	if clear_distance < 80.0 then
		distance = vm.f32(distance - clear_distance)
		if distance < near_distance then
			return -1
		end
	end
	retreat_x = vm.f32(pos_x + vm.f32(vm.sin(backward_yaw) * distance))
	retreat_y = vm.f32(pos_y - 20.0)
	retreat_z = vm.f32(pos_z + vm.f32(vm.cos(backward_yaw) * distance))
	monster.set_motion("歩き後", -1, 0)
	monster.move_toward_position(retreat_x, retreat_y, retreat_z, speed, speed)
	movement.wait_until_arrived(near_distance, max_frames)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	return 0
end

--- Turns to a heading in degrees using the side-step motion for the turn direction.
local function turn_to_heading_with_side_step(target_degrees: f32, turn_speed: f32)
	local yaw: f32 = 0
	local angle_difference: f32 = 0
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	target_degrees = calc.degrees_to_radians(target_degrees)
	angle_difference = vm.f32(target_degrees - yaw)
	if target_degrees > vm.f32(3.1415927) then
		target_degrees = vm.f32(target_degrees - vm.f32(6.2831855))
	end
	if target_degrees <= vm.f32(-3.1415927) then
		target_degrees = vm.f32(target_degrees + vm.f32(6.2831855))
	end
	if angle_difference < 0.0 then
		monster.set_motion("歩き右", -1, 0)
	else
		monster.set_motion("歩き左", -1, 0)
	end
	movement.turn_to_angle_and_wait(target_degrees, turn_speed)
	movement.stop_turning()
	monster.set_motion("立ち", -1, 0)
end

--- Picks a random cannon shot, bomb launch or retreat for a target at mid range.
local function choose_mid_range_move()
	local roll: s32 = 0
	local retreat_result: s32 = 0
	local turn_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			fire_cannon()
		else
			launch_bomb(4.2e-44) -- retail: the integer 30 is passed where the callee reads a float, so it reads its bits
		end
	else
		retreat_result = retreat_backward(1.75, 80.0, 30.0, 60)
		if retreat_result == -1 then
			roll = monster.get_random(100) or roll
			if roll < 40 then
				turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
				turn_to_heading_with_side_step(turn_degrees, vm.f32(4.8))
				retreat_backward(1.75, 80.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				fire_cannon()
			end
		end
	end
end

--- Picks a random cannon shot or retreat for a target at close range.
local function choose_close_range_move()
	local roll: s32 = 0
	local retreat_result: s32 = 0
	local turn_degrees: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 25 then
		fire_cannon()
	else
		retreat_result = retreat_backward(1.75, 80.0, 30.0, 60)
		if retreat_result == -1 then
			if roll < 60 then
				turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
				turn_to_heading_with_side_step(turn_degrees, vm.f32(4.8))
				retreat_backward(1.75, 80.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				fire_cannon()
			end
		end
	end
end

--- Loops choosing moves by target distance until the target leaves range or rage hits run out.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 270.0 then
			reaction.update_and_wait_frame()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 270.0 and target_distance >= 160.0 then
			choose_long_range_move()
		elseif target_distance < 160.0 and target_distance >= 90.0 then
			choose_mid_range_move()
		else
			choose_close_range_move()
		end
	end
end

--- Walks toward the target while the guard state is active.
local function chase_target_while_guarded()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.75, vm.f32(4.8), 30.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Fires, launches bombs and retreats once its rage hits are used up.
local function fight_when_rage_exhausted()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local retreat_result: s32 = 0
	local close_turn_degrees: f32 = 0
	local far_turn_degrees: f32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		priority = monster.get_priority() or priority
		if priority > 4 then
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 90.0 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				fire_cannon()
			else
				retreat_result = retreat_backward(1.75, 80.0, 30.0, 60)
				if retreat_result == -1 then
					if roll < 60 then
						close_turn_degrees = monster.get_random_whole_number(360.0) or close_turn_degrees
						turn_to_heading_with_side_step(close_turn_degrees, vm.f32(4.8))
						retreat_backward(1.75, 80.0, 30.0, 60)
						monster.set_motion("立ち", -1, 0)
					else
						fire_cannon()
					end
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 90 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					fire_cannon()
				else
					launch_bomb(4.2e-44) -- retail: the integer 30 is passed where the callee reads a float, so it reads its bits
				end
			else
				retreat_result = retreat_backward(1.75, 80.0, 30.0, 60)
				if retreat_result == -1 then
					roll = monster.get_random(100) or roll
					if roll < 40 then
						far_turn_degrees = monster.get_random_whole_number(360.0) or far_turn_degrees
						turn_to_heading_with_side_step(far_turn_degrees, vm.f32(4.8))
						retreat_backward(1.75, 80.0, 30.0, 60)
						monster.set_motion("立ち", -1, 0)
					else
						fire_cannon()
					end
				end
			end
		end
	end
end

--- Chooses between fighting, roaming and guard handling for each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		behavior.face_target_if_transformed_fast()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 270.0 then
				fight_target()
			else
				behavior.roam()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 270.0 then
					reaction.set_guard_active(0)
					fight_target()
				else
					chase_target_while_guarded()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_when_rage_exhausted()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Loads the Pirate Tank's shell, explosion and smoke effects and applies its default settings when it is placed.
function script.init()
	local texture_block: s32 = 0
	local shell_loaded: s32 = 0
	local explosion_loaded: s32 = 0
	monster.set_variable(0, 0)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		shell_loaded = monster.load_effect_script("高速弾", texture_block) or shell_loaded
		explosion_loaded = monster.load_effect_script("海賊爆弾爆発", texture_block) or explosion_loaded
		monster.load_effect_script("Ｍ煙", texture_block) -- retail: output 1 points past the frame, at the operand stack, so the value is lost
		if (if shell_loaded ~= 0 then 1 else explosion_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	apply_default_settings()
end

--- Runs the Pirate Tank's normal combat behaviour.
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

--- Holds the Pirate Tank in its damage pose while a status ailment is active.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the Pirate Tank's stagger reaction to a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the Pirate Tank's knockdown reaction empty so the engine default does not run.
function script.on_knockdown() end

--- Handles the Pirate Tank guarding against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the Pirate Tank's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Handles the Pirate Tank being caught and lifted.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers the Pirate Tank after it lands from a throw.
function script.on_land()
	reaction.recover_from_throw()
	state.do_nothing_hook()
	return 1
end

--- Stuns the Pirate Tank until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
