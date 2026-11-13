--!strict
--- Controls the Ice Element, a floating spirit that lunges and shoots ice shards.

local vm = require("@lib/vm")
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

--- Turns to a random heading, waits, and chases the target if it comes into view.
local function look_around_then_chase()
	local sight_result: s32 = 0
	local random_heading: f32 = 0
	random_heading = monster.get_random_whole_number(360.0) or random_heading
	monster.set_motion("歩き", -1, 0)
	movement.turn_to_heading(random_heading, vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_updating_lighting(9)
	sight_result = sense.wait_until_target_in_front_updating_lighting(300.0, 45.0, 45)
	if sight_result == 1 then
		monster.set_motion("走り", -1, 0)
		movement.chase_target_stopping_at_obstacle(3.0, vm.f32(4.8), 30.0, 5.0, 0, 150)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns to the target and shoots an ice shard from its face.
local function shoot_ice_shard()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_until_facing_updating_lighting(vm.f32(7.2000003))
	monster.set_motion("攻撃２", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("face")
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
	movement.track_target_until_progress(vm.f32(4.8), vm.f32(0.592), -1.0)
	monster.create_effect_1("氷弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	motion.wait_until_progress_updating_lighting(vm.f32(0.608), -1.0)
	monster.create_effect_1("氷弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_updating_lighting()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_updating_lighting(9)
end

--- Picks an attack or approach for when the target is far away.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	target_distance = sense.get_horizontal_target_distance(target_distance)
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 20 then
			look_around_then_chase()
		else
			shoot_ice_shard()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.dash_toward_target(2.0, vm.f32(4.8), 120.0, 60)
			movement.chase_target_stopping_at_obstacle(2.0, vm.f32(4.8), 30.0, 30.0, 0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front_updating_lighting(30.0, 45.0, 75)
		end
	end
end

--- Picks an attack, repositioning or sidestep for when the target is at medium distance.
local function act_at_medium_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	local step_right: s32 = 0
	target_distance = sense.get_horizontal_target_distance(target_distance)
	roll = monster.get_random(100) or roll
	if roll < 60 then
		shoot_ice_shard()
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			look_around_then_chase()
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				side_angle = monster.get_random_whole_number(60.0) or side_angle
				if roll < 50 then
					side_angle = vm.f32(-side_angle - 30.0)
				else
					side_angle = vm.f32(side_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.move_around_target(2.0, vm.f32(4.8), side_angle, 60.0, 1.0, 30.0, 75)
				movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_updating_lighting(9)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					step_right = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					step_right = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				movement.sidestep_toward_side(2.0, 30.0, 30.0, step_right, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Turns to the target and lunges at its position.
local function lunge_at_target()
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local ground_offset: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_until_facing_updating_lighting(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	monster.get_target_position(aim_x, aim_y, aim_z)
	ground_offset = sense.get_ground_offset_at(aim_x, aim_y, aim_z, ground_offset)
	movement.move_toward_position(target_x, target_y, target_z, 10.5, 10.0, 3.0, 27)
	motion.wait_until_finished_updating_lighting()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_updating_lighting(9)
end

--- Picks a lunge, repositioning or evasive move for when the target is close.
local function act_at_short_range()
	local roll: s32 = 0
	local side_angle: f32 = 0
	local step_right: s32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.set_motion("歩き", -1, 0)
		movement.approach_target(2.0, vm.f32(4.8), 30.0, 30.0, 60)
		lunge_at_target()
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			roll = monster.get_random(100) or roll
			side_angle = monster.get_random_whole_number(60.0) or side_angle
			if roll < 50 then
				side_angle = vm.f32(-side_angle - 30.0)
			else
				side_angle = vm.f32(side_angle + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.move_around_target(2.0, vm.f32(4.8), side_angle, 60.0, 1.0, 30.0, 50)
			movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_updating_lighting(9)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
			roll = monster.get_random(100) or roll
			if roll < 67 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					step_right = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					step_right = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				movement.sidestep_toward_side(2.0, 30.0, 30.0, step_right, 60)
				monster.set_motion("立ち", -1, 0)
			else
				movement.move_backward(2.0, 30.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses attacks by target distance for as long as the target is in range.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		timer.wait_frame()
		monster.get_life()
		reaction.watch_transformation_floating()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance > 300.0 then
			timer.wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			movement.strafe_or_wait_fast()
			continue
		end
		if target_distance < 300.0 and target_distance >= 200.0 then
			act_at_long_range()
		elseif target_distance < 200.0 and target_distance >= 120.0 then
			act_at_medium_range()
		else
			act_at_short_range()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the body hits, loads the ice shard effects and sets up flight.
function script.init()
	local get_not_used_texb: s32 = 0
	local texture_reserve_flag_1: s32 = 0
	local texture_reserve_flag_2: s32 = 0
	local texture_reserve_flag_3: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 0)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 1)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 0)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 1)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		texture_reserve_flag_1 = monster.load_effect_script("氷弾Ｆ", get_not_used_texb) or texture_reserve_flag_1
		texture_reserve_flag_2 = monster.load_effect_script("氷弾Ｌ", get_not_used_texb) or texture_reserve_flag_2
		texture_reserve_flag_3 = monster.load_effect_script("氷弾Ｈ", get_not_used_texb) or texture_reserve_flag_3
		if (if (if texture_reserve_flag_1 ~= 0 then 1 else texture_reserve_flag_2) ~= 0 then 1 else texture_reserve_flag_3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y + 20.0, pos_z)
	state.initialize_flying_defaults()
	state.set_max_flight_height(45.0)
	set_clip_distance()
	monster.set_variable(0, 0)
end

--- Fights the target when it is near and otherwise wanders in flight around home.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		timer.wait_frame()
		reaction.watch_transformation_floating()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance < 300.0 then
			fight_target()
		else
			movement.wander_flying_around_home()
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
	motion.wait_until_finished_updating_lighting()
	timer.wait_frames_updating_lighting(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is knocked down and gets back up.
function script.on_knockdown()
	state.reset_to_idle()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_updating_lighting()
	monster.set_action_status(1)
	timer.wait_frames_updating_lighting(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_updating_lighting()
	monster.set_motion("立ち")
	reaction.end_knockdown()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_updating_lighting(8)
	state.unlock()
end

--- Snaps to face the target when dodging.
function script.on_dodge_1()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	timer.wait_frame()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Snaps to face the target and turns toward it when dodging.
function script.on_dodge_2()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	timer.wait_frame()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death sequence.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished_updating_lighting()
	death.play_effects()
end

--- Struggles while caught.
function script.on_caught()
	state.stop_flying_and_reset_motion()
	monster.set_motion("じたばた", -1, 4)
	while true do
		timer.wait_frame()
	end
	timer.wait_forever()
end

--- Recovers after landing from a throw.
function script.on_land()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local ground_height: f32 = 0
	reaction.recover_after_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_updating_lighting(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_updating_lighting()
	movement.raise_one_unit()
	ground_height = sense.get_ground_height(ground_height)
	timer.wait_frame()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, ground_height + 10.0, pos_z)
	timer.wait_frame()
	return 1
end

--- Is stunned and recovers at hover height.
function script.on_stun()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local motion_finished: s32 = 0
	local ground_height: f32 = 0
	state.clear_attribute_and_lock()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("吹っ飛び", -1, 6)
	while true do
		height = monster.get_height_above_ground() or height
		if height < 10.0 then
			break
		else
			timer.wait_frame()
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			end
		end
	end
	monster.set_motion("起き上がり", -1, 6)
	while true do
		height = monster.get_height_above_ground() or height
		if height < 10.0 then
			break
		else
			timer.wait_frame()
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			end
		end
	end
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	ground_height = sense.get_ground_height(ground_height)
	timer.wait_frame()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, ground_height + 10.0, pos_z)
	timer.wait_frame()
	reaction.stun_until_recovered()
end

return script
