--!strict
--- Controls Inferno, a red swordsman boss that fights with slashes and combos.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard and secondary variables and a clip distance depending on whether it is a boss.
local function configure_defaults()
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

--- Plays the idle motion a number of times, sometimes stepping back when the target is in front.
local function play_idle_taunts(repeat_count: s32)
	local target_in_front: s32 = 0
	local roll: s32 = 0
	for i = 0, repeat_count - 1 do
		reaction.update_and_wait_frame()
		monster.reset_motion()
		monster.set_motion("遊び", -1, 2)
		target_in_front = sense.wait_until_target_in_front(49.0, 90.0, calc.pass_through(56))
		if target_in_front == 1 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				movement.step_back_guarded()
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("立ち", -1, 0)
			end
		end
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(49.0, 90.0, 30)
	end
end

--- Waits, walks to a side point near the target, or plays idle taunts.
local function idle_reposition()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(49.0, 90.0, 30)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			side_offset = monster.get_random_whole_number(30.0) or side_offset
			distance_offset = monster.get_random_whole_number(30.0) or distance_offset
			distance_offset = vm.f32(distance_offset + 85.0)
			if roll < 50 then
				side_offset = vm.f32(-side_offset - 30.0)
			else
				side_offset = vm.f32(side_offset + 30.0)
			end
			monster.set_motion("歩き", 0.6, 0)
			local _ = movement.walk_to_point_near_target(vm.f32(2.4), 4.0, side_offset, distance_offset, 49.0, 40)
			movement.turn_toward_target_and_wait_guarded(4.0)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			roll = monster.get_random(2) or roll
			play_idle_taunts(roll)
		end
	end
end

--- Slashes with the sword and releases a red slash effect.
local function red_sword_slash_attack()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local height: f32 = 0
	local effect_y: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１", -1, 6)
	movement.track_target_guarded(4.0, calc.pass_through(24))
	height = monster.get_height_above_ground() or height
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	effect_y = vm.f32(pos_y - height)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
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
	monster.create_effect_1("ＳＷ赤Ｌ")
	monster.set_effect_first_vector(-1, pos_x, effect_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_guarded()
	monster.set_motion("歩き", -1, 0)
	timer.wait_frames_guarded(3)
end

--- Picks an action when the target is far away.
local function choose_far_attack()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 95 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target_guarded(vm.f32(2.4), 4.0, 85.0, 75)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			red_sword_slash_attack()
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", 0.6, 0)
			movement.wander(vm.f32(2.4), 4.0, 30.0, 180.0, 30.0, 85.0, 45)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			roll = monster.get_random(2) or roll
			play_idle_taunts(roll)
		end
	end
end

--- Picks an action when the target is at middle range.
local function choose_mid_attack()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 5 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_with_offset_guarded(4.0, 20.0, 15)
			combat.play_second_attack_guarded()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_guarded(3)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			red_sword_slash_attack()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_guarded(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target_guarded(vm.f32(2.4), 4.0, 49.0, 60)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			play_idle_taunts(1)
		end
	end
end

--- Picks a combo, a slash, a step back or a sidestep when the target is close.
local function choose_close_attack()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset_guarded(4.0, 20.0, 15)
				combat.play_second_attack_guarded()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_guarded(3)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					red_sword_slash_attack()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_guarded(3)
				else
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					combat.play_two_hit_combo_guarded()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_guarded(3)
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset_guarded(4.0, 20.0, 25)
				combat.play_slow_two_hit_combo_guarded()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_guarded(3)
			else
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				combat.play_repeating_attack_guarded()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_guarded(3)
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			movement.step_back_guarded()
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(30.0) or side_angle
			target_distance = monster.get_random_whole_number(10.0) or target_distance
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + side_angle)
			end
			target_distance = monster.get_target_distance() or target_distance
			monster.set_motion("歩き", 0.65, 0)
			movement.walk_to_point_near_target(vm.f32(2.4), 4.0, calc.radians_to_degrees(side_angle), target_distance, 1.0, 15)
		end
	end
end

--- Fights the target while it is near, picking actions by distance until it leaves or the rage hits run out.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 240.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 0 then
			idle_reposition()
			continue
		end
		if target_distance < 240.0 and target_distance >= 140.0 then
			choose_far_attack()
		elseif target_distance < 140.0 and target_distance >= 85.0 then
			choose_mid_attack()
		else
			choose_close_attack()
		end
		reaction.update_and_wait_frame()
	end
end

local script = {}

--- Runs once when the script loads.
function script.setup() end

--- Registers the attack hit windows and sword trails and loads the red slash effect.
function script.init()
	monster.register_damage_hit("インフェ攻撃２", 2.5, "攻撃１", 0.5, 0.75, 0)
	monster.register_damage_hit("インフェ攻撃", 3.0, "攻撃１", 0.5, 0.75, 1)
	monster.register_damage_hit("インフェ攻撃２", 2.5, "攻撃２", 0.5, 0.8, 0)
	monster.register_damage_hit("インフェ攻撃", 3.0, "攻撃２", 0.5, 0.8, 1)
	monster.register_damage_hit("インフェ攻撃２", 6.0, "攻撃２", 0.15, 0.8, 2)
	monster.add_sword_trail(0, "攻撃１", 0.32, 0.37, "dcol1", "dcol0", 77, 20, 20)
	monster.add_sword_trail(0, "攻撃２", 0.5, 0.53, "dcol1", "dcol0", 77, 20, 20)
	monster.load_effect_script("ＳＷ赤Ｌ")
	monster.set_variable(0, 0)
	configure_defaults()
end

--- Waits for the target to approach, then fights it or chases it.
function script.loop()
	local target_distance: f32 = 0
	local has_engaged: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	has_engaged = monster.get_variable(0) or has_engaged
	if has_engaged == 0 then
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
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 240.0 then
			fight_target_in_range()
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target_guarded(vm.f32(2.4), 4.0, 49.0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stays staggered while a status ailment lasts.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back from a hit and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_guarded(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is thrown back, lies down and gets up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_guarded(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards the hit and recovers.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_guarded(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Sidesteps or steps back to dodge.
function script.on_dodge_1()
	local target_angle: f32 = 0
	local roll: s32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	reaction.update_and_wait_frame()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		movement.sidestep_guarded()
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		target_angle = monster.get_target_angle() or target_angle
		monster.set_rotation(0.0, target_angle, 0.0)
		reaction.update_and_wait_frame()
		movement.step_back_guarded()
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		monster.set_motion("立ち", -1, 0)
	end
	state.unlock()
end

--- Guards in place to avoid the attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_guarded(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays its death motion and effects.
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

--- Struggles forever while caught.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers from a throw and gets up.
function script.on_land()
	combat.finish_throw_guarded()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_guarded(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Falls over, gets up and waits out the stun.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
