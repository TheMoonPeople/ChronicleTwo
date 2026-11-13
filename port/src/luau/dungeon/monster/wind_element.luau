--!strict
--- Controls the Wind Element, a floating wind element that shoots wind balls at the target.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets how far away the monster stays active, unlimited for bosses.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Aims at the target and fires a wind ball from its face.
local function shoot_wind_ball()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
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
	monster.create_effect_1("風弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	motion.wait_until_progress_updating_lighting(vm.f32(0.608), -1.0)
	monster.create_effect_1("風弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_updating_lighting()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_updating_lighting(9)
end

--- Picks an action while the target is far away: ranged shot, chase or dash.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	target_distance = sense.get_horizontal_target_distance(target_distance)
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 20 then
			movement.chase_if_target_ahead()
		else
			shoot_wind_ball()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.dash_toward_target(1.75, vm.f32(4.8), 90.0, 60)
			movement.chase_target_stopping_at_obstacle(1.75, vm.f32(4.8), 30.0, 30.0, 0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front_updating_lighting(30.0, 45.0, 75)
		end
	end
end

--- Picks an action while the target is at medium distance: shoot, reposition or sidestep.
local function act_at_medium_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local circle_degrees: f32 = 0
	local is_stepping_right: s32 = 0
	target_distance = sense.get_horizontal_target_distance(target_distance)
	roll = monster.get_random(100) or roll
	if roll < 60 then
		shoot_wind_ball()
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			movement.chase_if_target_ahead()
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				circle_degrees = monster.get_random_whole_number(60.0) or circle_degrees
				if roll < 50 then
					circle_degrees = vm.f32(-circle_degrees - 30.0)
				else
					circle_degrees = vm.f32(circle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.move_around_target(1.75, vm.f32(4.8), circle_degrees, 60.0, 1.0, 30.0, 75)
				movement.turn_toward_target_until_facing_updating_lighting(vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_updating_lighting(9)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					is_stepping_right = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					is_stepping_right = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				movement.sidestep_toward_side(1.75, 30.0, 30.0, is_stepping_right, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Fights the target by distance until it leaves range.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		timer.wait_frame()
		monster.get_life()
		reaction.watch_transformation_floating()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance > 190.0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			movement.strafe_or_wait()
			continue
		end
		if target_distance < 190.0 and target_distance >= 140.0 then
			act_at_long_range()
		elseif target_distance < 140.0 and target_distance >= 90.0 then
			act_at_medium_range()
		else
			combat.engage_target()
		end
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the melee hits, loads the wind ball effects and sets up flight.
function script.init()
	local free_texture_block: s32 = 0
	local effect_f: s32 = 0
	local effect_l: s32 = 0
	local effect_h: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 0)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 1)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 0)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 1)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		effect_f = monster.load_effect_script("風弾Ｆ", free_texture_block) or effect_f
		effect_l = monster.load_effect_script("風弾Ｌ", free_texture_block) or effect_l
		effect_h = monster.load_effect_script("風弾Ｈ", free_texture_block) or effect_h
		if (if (if effect_f ~= 0 then 1 else effect_l) ~= 0 then 1 else effect_h) ~= 0 then
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
	configure_clip_distance()
	monster.set_variable(0, 0)
end

--- Fights the target when it is near and wanders around its home otherwise.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		timer.wait_frame()
		reaction.watch_transformation_floating()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance < 190.0 then
			fight_target_in_range()
		else
			movement.wander_flying_around_home()
		end
	end
end

--- Freezes the monster in a damage pose until its status ailment wears off.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage reaction and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_updating_lighting()
	timer.wait_frames_updating_lighting(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
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

--- Plays the guard pose and holds it briefly.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_updating_lighting(8)
	state.unlock()
end

--- Faces the target and returns to standing.
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

--- Faces the target and turns toward it.
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

--- Plays the death animation and death effects.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished_updating_lighting()
	death.play_effects()
end

--- Struggles in the air while held.
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
	reaction.recover_after_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_updating_lighting(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_updating_lighting()
	movement.raise_one_unit()
	return 1
end

--- Falls, recovers and floats again while stunned.
function script.on_stun()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local is_motion_finished: s32 = 0
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
			is_motion_finished = monster.is_motion_finished() or is_motion_finished
			if is_motion_finished ~= 0 then
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
			is_motion_finished = monster.is_motion_finished() or is_motion_finished
			if is_motion_finished ~= 0 then
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
