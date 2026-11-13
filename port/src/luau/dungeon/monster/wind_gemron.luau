--!strict
--- Controls the Wind Gemron, a hovering monster that shoots wind bullets.

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

local ground_y: f32 = 0

--- Sets the monster's clip distance and resets its ground height.
local function configure_clip_distance()
	local boss: s32 = 0
	ground_y = 0.0
	boss = monster.is_boss() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.get_position_3()
			ground_y = out2 or ground_y
		end
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
	ground_y = 0.0
end

--- Strafes to a point around the target or stands and watches it.
local function reposition_or_wait()
	local random_value: s32 = 0
	local side_angle_degrees: f32 = 0
	local distance: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		random_value = monster.get_random(100) or random_value
		side_angle_degrees = monster.get_random_whole_number(30.0) or side_angle_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 80.0)
		if random_value < 50 then
			side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
		else
			side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), side_angle_degrees, distance, 35.0, 25.0, 60)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Plays the shooting attack and launches a wind bullet toward the target.
local function shoot_wind_bullet()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_progress_facing_target(vm.f32(4.8), vm.f32(0.39), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("風弾Ｆ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	motion.wait_until_progress_reached(vm.f32(0.42), -1.0)
	monster.create_effect_1("風弾Ｌ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished()
end

--- Shoots the target or circles it when the target is at far range.
local function act_at_far_range()
	local random_value: s32 = 0
	local orbit_angle_degrees: f32 = 0
	local target_distance: f32 = 0
	if random_value < 65 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		shoot_wind_bullet()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(15)
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			orbit_angle_degrees = -45.0
		else
			orbit_angle_degrees = 45.0
		end
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		monster.set_motion("歩き", -1, 0)
		target_distance = monster.get_target_distance() or target_distance
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), orbit_angle_degrees, target_distance, 35.0, 25.0, 60)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Steps around the target to the given side by an angle and extra distance.
local function circle_step_around_target(extra_distance: f32, angle_degrees: f32, step_right: s32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local angle_radians: f32 = 0
	local distance: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.8))
	distance = monster.get_target_distance() or distance
	distance = vm.f32(distance + extra_distance)
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	angle_radians = monster.get_target_angle() or angle_radians
	angle_radians = vm.f32(angle_radians - vm.f32(3.1415927))
	angle_radians = vm.f32(angle_radians + angle_degrees)
	if angle_radians > vm.f32(3.1415927) then
		angle_radians = vm.f32(angle_radians - vm.f32(6.2831855))
	end
	if angle_radians <= vm.f32(-3.1415927) then
		angle_radians = vm.f32(angle_radians + vm.f32(6.2831855))
	end
	if step_right == 1 then
		monster.set_motion("ステップ右", -1, 0)
	else
		monster.set_motion("ステップ左", -1, 0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(position_x + vm.f32(vm.sin(angle_radians) * distance))
	position_y = ground_y
	position_z = vm.f32(position_z + vm.f32(vm.cos(angle_radians) * distance))
	movement.walk_to_position(position_x, position_y, position_z, 4.0, 4.0, 5.0, vm.idiv(max_frames, 2))
	movement.walk_to_position(position_x, position_y, position_z, 4.0, 4.0, 25.0, vm.idiv(max_frames, 2))
end

--- Circles around the target toward a randomly chosen side.
local function circle_step_random_side()
	local random_value: s32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		circle_step_around_target(50.0, 150.0, 1, 30)
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		circle_step_around_target(50.0, -150.0, 0, 30)
	end
end

--- Shoots, circles or strafes around the target when it is at medium range.
local function act_at_medium_range()
	local random_value: s32 = 0
	local target_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 60 then
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			shoot_wind_bullet()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		else
			circle_step_random_side()
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(9.6))
			shoot_wind_bullet()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			orbit_angle_degrees = -45.0
		else
			orbit_angle_degrees = 45.0
		end
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		monster.set_motion("歩き", -1, 0)
		target_distance = monster.get_target_distance() or target_distance
		target_distance = vm.f32(target_distance + 10.0)
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), orbit_angle_degrees, target_distance, 35.0, 25.0, 60)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Shoots, circles, retreats or walks away when the target is at melee range.
local function act_at_melee_range()
	local random_value: s32 = 0
	local target_distance: f32 = 0
	monster.get_life_int()
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 40.0 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		shoot_wind_bullet()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(21)
	end
	random_value = monster.get_random(100) or random_value
	if random_value < 60 then
		random_value = monster.get_random(100) or random_value
		if random_value < 60 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			shoot_wind_bullet()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		else
			circle_step_random_side()
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(9.6))
			shoot_wind_bullet()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 30 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			movement.retreat_from_target(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(2.0)
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				movement.walk_along_heading(2.0, 215.0, 100.0, 35.0, 25.0, 20)
			else
				movement.walk_along_heading(2.0, 145.0, 100.0, 35.0, 25.0, 20)
			end
		end
	end
end

--- Repeatedly chooses an attack by target distance until the target leaves range.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_wide_cone()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 220.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			reposition_or_wait()
			continue
		end
		if target_distance < 220.0 and target_distance >= 170.0 then
			act_at_far_range()
		elseif target_distance < 170.0 and target_distance >= 80.0 then
			act_at_medium_range()
		else
			act_at_melee_range()
		end
	end
end

--- Fights the target with a close-range attack mix once no rage hits are left.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local random_value: s32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 220.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 2 then
			reposition_or_wait()
			continue
		end
		if target_distance < 80.0 then
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.8))
				shoot_wind_bullet()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(5)
			else
				circle_step_random_side()
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(9.6))
				shoot_wind_bullet()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(5)
			end
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 60 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.8))
				shoot_wind_bullet()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(5)
			else
				circle_step_random_side()
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(9.6))
				shoot_wind_bullet()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(5)
			end
		end
	end
end

--- Steps sideways around the target while briefly ignoring collisions.
local function dodge_sideways()
	local random_value: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local target_distance: f32 = 0
	local offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		monster.set_motion("ステップ右", -1, 0)
		offset_degrees = 60.0
	else
		monster.set_motion("ステップ左", -1, 0)
		offset_degrees = -60.0
	end
	approach_x, approach_y, approach_z = movement.get_approach_point(offset_degrees, target_distance, approach_x, approach_y, approach_z)
	movement.walk_to_position(approach_x, ground_y, approach_z, 3.0, 3.0, 25.0, 10)
	monster.set_monster_attributes(32, 0)
	movement.wait_until_move_finished_without_stopping(30)
	monster.stop_moving()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the Wind Gemron hit boxes, loads its effect scripts and applies its default settings.
function script.init()
	local texture_block: s32 = 0
	local launch_effect_loaded: s32 = 0
	local flight_effect_loaded: s32 = 0
	local hit_effect_loaded: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		launch_effect_loaded = monster.load_effect_script("風弾Ｆ", texture_block) or launch_effect_loaded
		flight_effect_loaded = monster.load_effect_script("風弾Ｌ", texture_block) or flight_effect_loaded
		hit_effect_loaded = monster.load_effect_script("風弾Ｈ", texture_block) or hit_effect_loaded
		if (if (if launch_effect_loaded ~= 0 then 1 else flight_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	state.initialize_flying()
	state.set_max_flight_height(40.0)
	configure_clip_distance()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_position(position_x, vm.f32(position_y + 25.0) - 10.0, position_z)
end

--- Runs the Wind Gemron fighting and roaming behavior every frame.
function script.loop()
	local rage_hits_left: s32 = 0
	local horizontal_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.try_face_transformed_player_wide_cone()
			horizontal_distance = sense.get_horizontal_target_distance(horizontal_distance)
			if horizontal_distance < 220.0 then
				fight_target_in_range()
			else
				behavior.choose_wander_action()
			end
		else
			fight_without_rage_hits()
		end
	end
end

--- Freezes the monster in a damage pose until its status ailments clear.
function script.on_status_hit()
	local has_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_ailment = 1
	while has_ailment ~= 0 do
		has_ailment = monster.get_status_ailments(40) or has_ailment
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction when the monster takes a staggering hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(16)
	monster.set_motion("立ち", -1, 0)
	state.do_nothing()
end

--- Plays the knock-down and get-up sequence when the monster is blown over.
function script.on_knockdown()
	reaction.begin_knockdown()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 25)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	reaction.end_knockdown()
end

--- Plays the guard reaction when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード入り", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("ガード戻り", -1, 6)
	motion.wait_until_finished()
	state.unlock()
end

--- Is intentionally empty so the monster has no first dodge reaction.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	movement.face_target_instantly()
	vm.wait()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.8))
	dodge_sideways()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Is intentionally empty so the monster has no second dodge reaction.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.8))
	dodge_sideways()
	movement.face_target_instantly()
	vm.wait()
	motion.wait_until_finished()
	monster.set_motion("よけるもどり", -1, 6)
	motion.wait_until_finished()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Plays the death motion and the death effects.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling motion while the monster is held.
function script.on_caught()
	state.stop_flying_and_reset_motion()
	monster.set_motion("じたばた", -1, 4)
	timer.wait_forever_unguarded()
end

--- Recovers the monster and stands it back up after it lands from a throw.
function script.on_land()
	reaction.end_throw_and_resume_flying()
	state.set_flying_attributes(1)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	movement.raise_one_unit()
	return 1
end

--- Knocks the monster down and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("吹っ飛びループ", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("気絶", -1)
	reaction.stun_until_recovered()
end

return script
