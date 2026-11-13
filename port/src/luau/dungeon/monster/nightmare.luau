--!strict
--- Controls the Nightmare boss: it chases and circles the player, fires nose bullets and charges with a shockwave.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
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

--- Walks or runs at the player, circles around them or waits for them to come in front.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 25 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				monster.set_variable(0, 8)
				monster.set_motion("歩き", -1, 0)
				movement.chase_target(vm.f32(1.8), 3.0, 64.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 16)
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_arc(64.0, 45.0, 75)
			end
		else
			monster.set_variable(0, 64)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
			else
				strafe_angle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.8), 3.0, strafe_angle_degrees, target_distance, 200.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(64.0, 45.0, 30)
		end
	else
		monster.set_variable(0, 32)
		monster.set_motion("走り", -1, 0)
		movement.chase_target(3.0, 3.0, 64.0, 120)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Lunges forward at the player and releases a shockwave from the trunk.
local function attack_charge_shockwave()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local attack: s32 = 0
	monster.set_mask_flags(2, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target(3.0, calc.pass_through(15))
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
	monster.get_target_angle()
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(heading) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(heading) * 100.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 5.3999996, 5.3999996)
	timer.wait_frames(calc.pass_through(17))
	do
		local out1, out2, out3 = monster.get_frame_position("chn76")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("ヴァンガード衝撃波")
	monster.set_effect_first_vector(-1, pos_x, pos_y - 20.0, pos_z)
	monster.set_effect_value(-1, 0, attack)
	monster.stop_moving()
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(12)
	monster.set_mask_flags(2, 0)
end

--- Fires nose bullets, charges, approaches or circles the player.
local function act_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			combat.shoot_nose_bullets()
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			movement.chase_target(3.0, 3.0, 64.0, 90)
			attack_charge_shockwave()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			roll = monster.get_random(100) or roll
			if roll < 70 then
				monster.set_variable(0, 8)
				monster.set_motion("歩き", -1, 0)
				movement.chase_target(vm.f32(1.8), 3.0, 64.0, 90)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 32)
				monster.set_motion("走り", -1, 0)
				movement.chase_target(3.0, 3.0, 64.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			monster.set_variable(0, 64)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
			else
				strafe_angle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.8), 3.0, strafe_angle_degrees, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(64.0, 45.0, 30)
		end
	end
end

--- Charges, fires nose bullets or circles a nearby player.
local function act_at_close_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 80 then
		monster.get_target_distance()
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			movement.chase_target(3.0, 3.0, 64.0, 90)
			attack_charge_shockwave()
		else
			combat.shoot_nose_bullets()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
		else
			monster.set_variable(0, 64)
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.8), 3.0, strafe_angle_degrees, 128.0, 1.0, 25)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(12)
		end
	end
end

--- Chooses an action by distance to the player for as long as the player stays in range.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 99999.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			behavior.strafe_or_wait()
			continue
		end
		if target_distance < 99999.0 and target_distance >= 300.0 then
			act_at_long_range()
		elseif target_distance < 300.0 and target_distance >= 200.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the charge hit window and loads the shockwave and nose bullet effects.
function script.init()
	local texture_block: s32 = 0
	local loaded_shockwave: s32 = 0
	local loaded_nose_bullet_light: s32 = 0
	local loaded_nose_bullet_heavy: s32 = 0
	monster.register_damage_hit("吹っ飛び弱", 17.0, "攻撃１", 0.435, 0.532, 0)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		loaded_shockwave = monster.load_effect_script("ヴァンガード衝撃波", texture_block) or loaded_shockwave
		loaded_nose_bullet_light = monster.load_effect_script("鼻弾Ｌ", texture_block) or loaded_nose_bullet_light
		loaded_nose_bullet_heavy = monster.load_effect_script("鼻弾Ｈ", texture_block) or loaded_nose_bullet_heavy
		if (if (if loaded_shockwave ~= 0 then 1 else loaded_nose_bullet_light) ~= 0 then 1 else loaded_nose_bullet_heavy) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.9)
end

--- Chases the player and fights while the player is within range.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 99999.0 then
			fight_target_in_range()
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			movement.chase_target(3.0, 3.0, 64.0, 90)
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

--- Guards with a short knockback.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	state.unlock()
end

--- Resets the motion for the first dodge.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Counterattacks with a charge when it was moving toward or waiting for the player.
function script.on_dodge_2()
	local behavior_flags: s32 = 0
	local target_distance: f32 = 0
	behavior_flags = monster.get_variable(0) or behavior_flags
	target_distance = monster.get_target_distance() or target_distance
	if
		(
			if (if bit32.band(behavior_flags, 4) ~= 0 then 1 else bit32.band(behavior_flags, 2)) ~= 0 or target_distance > 300.0
				then 1
				else bit32.band(behavior_flags, 16)
		) ~= 0
	then
		monster.set_motion("走り", -1, 4)
		movement.rush_forward(6.0, 15.0, 64.0, 90)
		attack_charge_shockwave()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Plays the death motion and effects, then requests the boss defeat event.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	camera.reset_mode()
	monster.spawn_death_effects()
	timer.wait_frames(30)
	monster.request_event_script(501)
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves being caught to the engine default by defining nothing.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves landing to the engine default by defining nothing.
function script.on_land() end

--- Flinches and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 4)
	timer.wait_frames(3)
	reaction.stun_until_recovered()
end

return script
