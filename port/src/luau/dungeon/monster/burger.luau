--!strict
--- Controls the Burger family, monsters that charge with a shockwave and fire nose bullets.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets how far away the monster stays visible, unlimited for bosses.
local function set_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Picks an approach or repositioning move for when the target is far away.
local function act_at_far_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 65 then
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
				side_angle = -30.0
			else
				side_angle = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.8), 3.0, side_angle, target_distance, 200.0, 45)
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
	print("far------------------------------------\n")
end

--- Charges toward the target and releases a shockwave at the end of the charge.
local function charge_with_shockwave()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_angle: f32 = 0
	local attack: s32 = 0
	monster.set_mask_flags(2, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target(3.0, 15)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	target_angle = monster.get_target_angle() or target_angle
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(target_angle) * 100.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(target_angle) * 100.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
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

--- Picks an attack or approach for when the target is at middle distance.
local function act_at_middle_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
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
			charge_with_shockwave()
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
				side_angle = -30.0
			else
				side_angle = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.8), 3.0, side_angle, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(64.0, 45.0, 30)
		end
	end
	print("middle------------------------------------\n")
end

--- Picks an attack or repositioning move for when the target is near.
local function act_at_near_range()
	local roll: s32 = 0
	local side_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 75 then
		monster.get_target_distance()
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("走り", -1, 0)
			movement.chase_target(3.0, 3.0, 64.0, 90)
			charge_with_shockwave()
		else
			combat.shoot_nose_bullets()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
		else
			monster.set_variable(0, 64)
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.8), 3.0, side_angle, 128.0, 1.0, 25)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(12)
		end
	end
	print("near------------------\n")
end

--- Chooses an action by target distance while the target is in range.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		vm.wait()
		behavior.face_target_if_transformed()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 550.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			behavior.strafe_or_wait()
			continue
		end
		if target_distance < 550.0 and target_distance >= 300.0 then
			act_at_far_range()
		elseif target_distance < 300.0 and target_distance >= 200.0 then
			act_at_middle_range()
		else
			act_at_near_range()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the charge hit and effects, then sets the clip distance.
function script.init()
	local get_not_used_texb: s32 = 0
	local texture_reserve_flag_1: s32 = 0
	local texture_reserve_flag_2: s32 = 0
	local texture_reserve_flag_3: s32 = 0
	monster.register_damage_hit("吹っ飛び弱", 17.0, "攻撃１", 0.435, 0.532, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		texture_reserve_flag_1 = monster.load_effect_script("ヴァンガード衝撃波", get_not_used_texb) or texture_reserve_flag_1
		texture_reserve_flag_2 = monster.load_effect_script("鼻弾Ｌ", get_not_used_texb) or texture_reserve_flag_2
		texture_reserve_flag_3 = monster.load_effect_script("鼻弾Ｈ", get_not_used_texb) or texture_reserve_flag_3
		if (if (if texture_reserve_flag_1 ~= 0 then 1 else texture_reserve_flag_2) ~= 0 then 1 else texture_reserve_flag_3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	set_clip_distance()
end

--- Fights the target when in range and otherwise wanders around home.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		vm.wait()
		behavior.face_target_if_transformed()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 550.0 then
			fight_target()
		else
			movement.wander_around_home()
		end
	end
end

--- Staggers in place while a status ailment lasts.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back after a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is knocked back and recovers.
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
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	state.unlock()
end

--- Does nothing when dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Charges at the target after a dodge when the previous action calls for it.
function script.on_dodge_2()
	local value: s32 = 0
	local target_distance: f32 = 0
	value = monster.get_variable(0) or value
	target_distance = monster.get_target_distance() or target_distance
	if
		(
			if (if bit32.band(value, 4) ~= 0 then 1 else bit32.band(value, 2)) ~= 0 or target_distance > 300.0
				then 1
				else bit32.band(value, 16)
		) ~= 0
	then
		monster.set_motion("走り", -1, 4)
		movement.rush_forward(6.0, 15.0, 64.0, 90)
		charge_with_shockwave()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Plays the death sequence.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Has no special behavior while caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Has no special behavior on landing.
function script.on_land() end

--- Is stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 4)
	timer.wait_frames(3)
	reaction.stun_until_recovered()
end

return script
