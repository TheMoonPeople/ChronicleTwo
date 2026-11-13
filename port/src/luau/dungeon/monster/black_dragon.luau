--!strict
--- Controls the Black Dragon boss: it chases and circles the player, swipes, taunts and spits fireballs.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local camera = require("@lib/monster/camera")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Gives bosses an unlimited clip distance and other monsters a short one.
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
	movement.turn_to_angle(calc.radians_to_degrees(angle_offset), turn_speed_degrees)
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
	arrived = movement.wait_until_arrived_unguarded(stop_distance, max_frames)
	monster.stop_moving()
	return arrived
end

--- Waits until the current motion ends or the player is within the front arc.
local function wait_until_finished_or_target_in_front(distance: f32, arc_degrees: f32)
	local is_finished: s32 = 0
	while true do
		timer.wait_one_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
		if sense.is_target_in_front(distance, arc_degrees) == 1 then
			return
		end
	end
end

--- Plays the idle play motion until it ends or the player comes in front.
local function play_idle_animation()
	local result: s32 = 0
	monster.set_variable(1, 32)
	monster.set_motion("遊び", -1, 6)
	wait_until_finished_or_target_in_front(49.0, 45.0)
	return result
end

--- Randomly strafes around the player, stands waiting, or plays the idle animation.
local function strafe_or_idle()
	local roll: s32 = 0
	local angle_offset_degrees: f32 = 0
	local circle_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			angle_offset_degrees = monster.get_random_whole_number(30.0) or angle_offset_degrees
			circle_distance = monster.get_random_whole_number(30.0) or circle_distance
			circle_distance = vm.f32(circle_distance + 130.0)
			if roll < 50 then
				angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
			else
				angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = walk_around_target(vm.f32(1.9), 3.0, angle_offset_degrees, circle_distance, 49.0, 30)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(49.0, 45.0, 30)
		end
	else
		play_idle_animation()
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
	movement.turn_toward_target_and_wait(rot_speed)
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
		timer.wait_one_frame()
		frame = frame + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Turns to the player and performs the sword-trail swipe attack.
local function attack_swipe()
	monster.set_variable(1, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_progress_facing_target(3.0, vm.f32(0.267), -1.0)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Spits a fireball and a fire trail toward the player.
local function attack_fireball()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local fireball_speed: f32 = 0
	local attack: s32 = 0
	monster.set_variable(1, 2)
	fireball_speed = 10.0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_progress_facing_target(3.0, vm.f32(0.431), vm.f32(0.02))
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_frame_position("dcol_00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
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
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("ドラゴン火弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 10.0, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.create_effect_1("ドラゴン火弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 5.0, pos_z)
	monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, fireball_speed)
	motion.wait_until_complete()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_counted(9)
end

--- Runs or walks at the player, circles, plays the idle animation or breathes fire.
local function act_at_long_range()
	local roll: s32 = 0
	local idle_result: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local strafe_angle_degrees: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			roll = monster.get_random(100) or roll
			if roll < 95 then
				life = monster.get_life() or life
				if life < 0.5 then
					monster.set_motion("走り", -1, 0)
					approach_target(4.5, 6.0, 130.0, 75)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					approach_target(vm.f32(1.9), 3.0, 130.0, 90)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(49.0, 45.0, 75)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					strafe_angle_degrees = -30.0
				else
					strafe_angle_degrees = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(3.0)
				monster.set_motion("歩き", -1, 0)
				walk_around_target(vm.f32(1.9), 3.0, strafe_angle_degrees, target_distance, 130.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(3.0)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(49.0, 45.0, 30)
			else
				idle_result = play_idle_animation()
				if idle_result == 1 then
					attack_swipe()
				end
			end
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(3.0)
		attack_fireball()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Breathes fire, approaches, circles or plays the idle animation.
local function act_at_mid_range()
	local roll: s32 = 0
	local idle_result: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local strafe_angle_degrees: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 70 then
		monster.get_random(100, roll)
		if roll < 75 then
			attack_fireball()
		else
			idle_result = play_idle_animation()
			if idle_result == 1 then
				attack_swipe()
			else
				attack_fireball()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			life = monster.get_life() or life
			if life < vm.f32(0.3) then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(3.0)
				monster.set_motion("走り", -1, 0)
				approach_target(4.5, 6.0, 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1, 0)
				approach_target(vm.f32(1.9), 3.0, 49.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					strafe_angle_degrees = -30.0
				else
					strafe_angle_degrees = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(3.0)
				monster.set_motion("歩き", -1, 0)
				walk_around_target(vm.f32(1.9), 3.0, strafe_angle_degrees, target_distance, 1.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(3.0)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(49.0, 45.0, 30)
			else
				play_idle_animation()
			end
		end
	end
end

--- Swipes or breathes fire at a nearby player, or runs in and circles.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 40 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			approach_target(4.5, 6.0, 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
		target_distance = monster.get_target_distance() or target_distance
		roll = monster.get_random(100) or roll
		if target_distance < 70.0 then
			attack_swipe()
		else
			attack_fireball()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			approach_target(4.5, 6.0, 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			walk_around_target(vm.f32(1.9), 3.0, strafe_angle_degrees, 98.0, 1.0, 25)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(9)
		end
	end
end

--- Chooses an action by distance to the player until the player leaves range or the rage hits run out.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		monster.get_life()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 280.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			strafe_or_idle()
			continue
		end
		if target_distance < 280.0 and target_distance >= 210.0 then
			act_at_long_range()
		elseif target_distance < 210.0 and target_distance >= 130.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the swipe hit windows, loads the fireball effects and adds the sword trails.
function script.init()
	local texture_block: s32 = 0
	local loaded_fireball_front: s32 = 0
	local loaded_fireball_light: s32 = 0
	local loaded_fireball_heavy: s32 = 0
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.267, 0.333, 1, 2)
	monster.register_damage_hit("Ｍ連撃２", 3.5, "攻撃１", 0.644, 0.689, 3, 4)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		loaded_fireball_front = monster.load_effect_script("ドラゴン火弾Ｆ", texture_block) or loaded_fireball_front
		loaded_fireball_light = monster.load_effect_script("ドラゴン火弾Ｌ", texture_block) or loaded_fireball_light
		loaded_fireball_heavy = monster.load_effect_script("ドラゴン火弾Ｈ", texture_block) or loaded_fireball_heavy
		if (if (if loaded_fireball_front ~= 0 then 1 else loaded_fireball_light) ~= 0 then 1 else loaded_fireball_heavy) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.add_sword_trail(0, "攻撃１", 0.222, 0.226, "kiseki0", "kiseki1", 45, 20, 45)
	monster.add_sword_trail(1, "攻撃１", 0.622, 0.626, "kiseki2", "kiseki3", 45, 20, 45)
	monster.set_variable(1, 0)
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.9)
end

--- Chases the player and fights while the player is within range.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("立ち", -1, 0)
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 280.0 then
			fight_target_in_range()
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			approach_target(4.5, 6.0, 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
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
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays a short flinch and returns to standing.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Faces the player, flinches back and returns to standing.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("ダメージ後", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards with a short knockback.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
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

--- Plays the death motion and effects, then requests the boss defeat event.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	timer.wait_frames(30)
	camera.reset_mode()
	monster.request_event_script(502)
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves being caught to the engine default by defining nothing.
function script.on_caught() end

--- Finishes the throw after landing.
function script.on_land()
	combat.finish_throw()
	state.do_nothing_hook()
	return 1
end

--- Flinches and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ後", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
