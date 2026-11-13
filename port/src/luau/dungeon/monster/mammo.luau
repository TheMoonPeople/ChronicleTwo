--!strict
--- Controls the Mammo boss: it circles and approaches the player, then attacks with a swipe or a ground shockwave.

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
		circle_distance = vm.f32(circle_distance + 130.0)
		if roll < 50 then
			angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
		else
			angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_around_target(vm.f32(2.6), 3.0, angle_offset_degrees, circle_distance, 69.0, 30)
		movement.turn_toward_target_and_wait(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(69.0, 45.0, 30)
	end
end

--- Plays the left or right turning motion and turns to face the player.
local function turn_toward_target_with_animation()
	if sense.is_facing_target_with_whole_offset(90, 180) ~= 0 then
		monster.set_motion("回転右", -1.0, 0)
	else
		monster.set_motion("回転左", -1.0, 0)
	end
	movement.turn_toward_target_and_wait(3.0)
end

--- Walks or runs toward the player until within the stop distance or the frame limit is reached.
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
		if sense.is_facing_target_with_whole_offset(0, 20) ~= 0 then
			monster.set_motion("歩き")
		elseif sense.is_facing_target_with_whole_offset(90, 180) ~= 0 then
			monster.set_motion("回転右")
		else
			monster.set_motion("回転左")
		end
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

--- Closes the distance to a distant player or circles around them.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 90 then
		turn_toward_target_with_animation()
		monster.set_motion("歩き", -1, 0)
		approach_target(vm.f32(2.6), 3.0, 130.0, 90)
		monster.set_motion("立ち", -1, 0)
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
			turn_toward_target_with_animation()
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(2.6), 3.0, strafe_angle_degrees, target_distance, 130.0, 45)
			monster.set_motion("歩き", -1, 0)
			turn_toward_target_with_animation()
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(69.0, 45.0, 30)
		end
	end
end

--- Swings at the player and releases a ground shockwave in front of the monster.
local function attack_shockwave()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_variable(1, 2)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_progress_facing_target(3.0, 0.5, vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_point_from_facing(0.0, 16.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	attack = monster.get_attack_power_1() or attack
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_counted(9)
end

--- Uses the shockwave, approaches the player or circles around them.
local function act_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 10 then
		attack_shockwave()
	else
		roll = monster.get_random(100) or roll
		if roll < 90 then
			monster.set_motion("歩き", -1, 0)
			turn_toward_target_with_animation()
			monster.set_motion("歩き", -1, 0)
			approach_target(vm.f32(2.6), 6.0, 69.0, 60)
			monster.set_motion("立ち", -1, 0)
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
				turn_toward_target_with_animation()
				monster.set_motion("歩き", -1, 0)
				movement.walk_around_target(vm.f32(2.6), 3.0, strafe_angle_degrees, target_distance, 1.0, 45)
				monster.set_motion("歩き", -1, 0)
				turn_toward_target_with_animation()
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(69.0, 45.0, 30)
			end
		end
	end
end

--- Turns to the player and performs the melee swipe attack.
local function attack_swipe()
	monster.set_variable(1, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(3.0)
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_progress_facing_target(3.0, vm.f32(0.267), -1.0)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Attacks a nearby player with the swipe or shockwave, or runs in and circles.
local function act_at_close_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 90 then
		roll = monster.get_random(100) or roll
		if roll < 40 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			approach_target(vm.f32(3.2), 6.0, 69.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
		monster.get_target_distance()
		roll = monster.get_random(100) or roll
		if roll < 70 then
			attack_swipe()
		else
			attack_shockwave()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			approach_target(vm.f32(3.2), 6.0, 69.0, 60)
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
			movement.walk_around_target(vm.f32(2.6), 3.0, strafe_angle_degrees, 138.0, 1.0, 25)
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
			strafe_or_wait()
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

--- Registers the attack hit windows and loads the shockwave effect.
function script.init()
	local texture_block: s32 = 0
	local loaded_shockwave: s32 = 0
	monster.register_damage_hit("弱連続", 8.0, "攻撃１", 0.217, 0.256, 0)
	monster.register_damage_hit("吹っ飛び弱", 8.0, "攻撃１", 0.486, 0.524, 0)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		loaded_shockwave = monster.load_effect_script("ヴァンガード衝撃波", texture_block) or loaded_shockwave
		if loaded_shockwave ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(1, 0)
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.9)
end

--- Approaches the player and fights while the player is within range.
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
			turn_toward_target_with_animation()
			monster.set_motion("歩き", -1, 0)
			approach_target(vm.f32(2.6), 3.0, 69.0, 60)
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
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Faces the player, flinches back and returns to standing.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves guarding to the engine default by defining nothing.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the first dodge to the engine default by defining nothing.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the second dodge to the engine default by defining nothing.
function script.on_dodge_2() end

--- Plays the death motion and effects, then requests the boss defeat event.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	timer.wait_frames(30)
	camera.reset_mode()
	monster.request_event_script(500)
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
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
