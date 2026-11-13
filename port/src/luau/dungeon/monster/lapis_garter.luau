--!strict
--- Controls the Lapis Garter, a guarding monster that approaches the player, bites and uses a spinning charge.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
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

--- Walks to a point around the player, stopping early when blocked, and returns whether it arrived.
local function walk_around_target(move_speed: f32, turn_speed_degrees: f32, angle_offset: f32, circle_distance: f32, stop_distance: f32, max_frames: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local clear_distance: f32 = 0
	local arrived: s32 = 0
	destination_x, destination_y, destination_z = movement.get_approach_point(angle_offset, circle_distance, destination_x, destination_y, destination_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	angle_offset = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle_offset
	if angle_offset > vm.f32(3.1415927) then
		angle_offset = vm.f32(angle_offset - vm.f32(6.2831855))
	end
	if angle_offset <= vm.f32(-3.1415927) then
		angle_offset = vm.f32(angle_offset + vm.f32(6.2831855))
	end
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(angle_offset), turn_speed_degrees)
	movement.stop_turning()
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y, pos_z)
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
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 100.0 then
		destination_x = vm.f32(pos_x + vm.f32(vm.sin(angle_offset) * clear_distance))
		destination_y = pos_y
		destination_z = vm.f32(pos_z + vm.f32(vm.cos(angle_offset) * clear_distance))
		clear_distance = vm.f32(clear_distance - stop_distance)
		if clear_distance < stop_distance then
			return -1
		end
	end
	monster.move_toward_position(destination_x, pos_y - 20.0, destination_z, move_speed, move_speed)
	arrived = movement.wait_until_arrived(stop_distance, max_frames)
	monster.stop_moving()
	return arrived
end

--- Either strafes around the player at a random angle or stands until the player is in front.
local function strafe_or_wait()
	local roll: s32 = 0
	local angle_offset_degrees: f32 = 0
	local circle_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		angle_offset_degrees = monster.get_random_whole_number(30.0) or angle_offset_degrees
		circle_distance = monster.get_random_whole_number(30.0) or circle_distance
		circle_distance = vm.f32(circle_distance + 160.0)
		if roll < 50 then
			angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
		else
			angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = walk_around_target(6.0, vm.f32(4.2), angle_offset_degrees, circle_distance, 60.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(60.0, 45.0, 30)
	end
end

--- Moves toward the player until within the stop distance or the frame limit is reached.
local function approach_target(move_speed: f32, rot_speed: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_z: f32 = 0
	local pos_y: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local frame: s32 = 0
	movement.turn_toward_target_and_wait_guarded(rot_speed)
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
		do
			local out1, _, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_z = out3 or target_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			pos_y = out2 or pos_y
		end
		monster.get_rotation()
		monster.move_toward_position(target_x, pos_y - 20.0, target_z, move_speed, move_speed)
		reaction.update_and_wait_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Turns to the player and walks toward them.
local function approach_at_long_range()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	approach_target(6.0, vm.f32(4.2), 60.0, 45)
	monster.set_motion("立ち", -1, 0)
end

--- Turns to the player and walks toward them.
local function approach_at_mid_range()
	monster.get_life()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	approach_target(6.0, vm.f32(4.2), 60.0, 45)
	monster.set_motion("立ち", -1, 0)
end

--- Turns to the player and performs the first melee attack.
local function attack_primary()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Turns to the player and performs the second melee attack.
local function attack_secondary()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Winds up, then charges forward in a spin that hits anything in its path.
local function attack_spin_charge(spin_frames: any)
	local character_number: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃３in", -1, 6)
	motion.wait_until_finished_guarded()
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(heading) * 300.0))
	pos_y = vm.f32(pos_y - 20.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(heading) * 300.0))
	monster.set_motion("攻撃３loop", -1, 4)
	monster.move_toward_position(pos_x, pos_y, pos_z, 6.4, 6.4)
	character_number = monster.get_character_number() or character_number
	monster.create_effect_1("スピン")
	monster.set_effect_owner(-1, character_number)
	monster.set_effect_value(-1, 1, 45)
	monster.set_effect_value_float(-1, 2, 1.0)
	timer.wait_frames_with_guard_update(45)
	monster.stop_moving()
	monster.set_motion("攻撃３out", -1, 6)
	motion.wait_until_finished_guarded()
end

--- Randomly bites, spins or walks toward a nearby player.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 60.0 then
				attack_primary()
			else
				attack_secondary()
			end
		else
			attack_spin_charge(45)
		end
	else
		monster.set_motion("歩き", -1, 0)
		approach_target(6.0, vm.f32(4.2), 60.0, 90)
		monster.set_motion("立ち", -1, 0)
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
		if target_distance > 800.0 then
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
			strafe_or_wait()
			continue
		end
		if target_distance < 800.0 and target_distance >= 280.0 then
			approach_at_long_range()
		elseif target_distance < 280.0 and target_distance >= 160.0 then
			approach_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Walks toward the player for a long stretch.
local function approach_for_attack()
	monster.set_motion("歩き", -1, 0)
	approach_target(6.0, vm.f32(4.2), 60.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Fights or approaches the player depending on whether the guard is active and how far away the player is.
local function choose_action()
	local target_distance: f32 = 0
	local guard_release_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		if target_distance < 800.0 then
			fight_target_in_range()
		else
			monster.set_motion("歩き", -1, 0)
			approach_target(6.0, vm.f32(4.2), 60.0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	else
		guard_release_distance = state.get_secondary_float(guard_release_distance)
		if target_distance < guard_release_distance then
			if target_distance < 280.0 then
				reaction.set_guard_active(0)
				fight_target_in_range()
			else
				approach_for_attack()
			end
		else
			reaction.set_guard_active(0)
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows and loads the spin effect.
function script.init()
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃１", 0.325, 0.375, 1)
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃２", 0.319, 0.421, 0)
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃３loop", 0.0, 1.0, 0)
	monster.register_damage_hit("吹っ飛び弱", 7.4, "攻撃３loop", 0.0, 1.0, 1)
	monster.load_effect_script("スピン")
	monster.set_variable(0, 0)
	monster.set_variable(0, 0)
	configure_guard_and_clip_distance()
	monster.set_clip_distance(999999.9)
end

--- Waits for the player to come near or for the guard to activate, then keeps choosing actions.
function script.loop()
	local woke_up: s32 = 0
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	woke_up = monster.get_variable(0) or woke_up
	if woke_up == 0 then
		monster.set_motion("立ち", -1, 0)
		while true do
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 500.0 then
				break
			elseif reaction.is_guard_active() ~= 0 then
				break
			else
				reaction.update_and_wait_frame()
			end
		end
		monster.set_variable(0, 1)
	end
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

--- Faces the player and recovers from the knockdown.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	state.unlock_and_clear_action()
end

--- Stops moving while guarding.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Resets the motion for the first dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Resets the motion for the second dodge.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished_guarded()
	monster.spawn_death_effects()
	while true do
		reaction.update_and_wait_frame()
	end
	death.play_effects()
end

--- Struggles while held in the air.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Recovers after being thrown and stands back up.
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

--- Flinches and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames_with_guard_update(12)
	reaction.stun_until_recovered()
end

return script
