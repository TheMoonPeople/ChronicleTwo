--!strict
--- Controls the Sea Dragon, a guarding monster that approaches the player, attacks and dives to reappear at the player's position.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
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

--- Walks or rushes toward the player, or waits for them to come in front.
local function act_at_long_range()
	local roll: s32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 95 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(vm.f32(3.2), vm.f32(4.2), 100.0, 90)
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.5, vm.f32(4.2), 100.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(46.0, 45.0, 75)
		end
	end
end

--- Dives out of reach, resurfaces at the player's position after a delay and attacks as it emerges.
local function dive_and_surface_at_target(dive_frames: s32)
	local foot_index: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	monster.set_motion("避け", -1, 2)
	print("foot=", foot_index, "-------------\n")
	motion.wait_until_finished_guarded()
	monster.set_monster_attributes(1, 1)
	timer.wait_frames_with_guard_update(vm.idiv(dive_frames, 2))
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.set_position(target_x, target_y, target_z)
	timer.wait_frames_with_guard_update(vm.idiv(dive_frames, 2))
	monster.set_motion("避け戻り", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	monster.set_monster_attributes(1, 0)
end

--- Approaches and attacks or dives, walks toward the player, or circles around them.
local function act_at_mid_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(2.5, vm.f32(4.2), 46.0, 45)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					combat.turn_and_play_first_attack()
				else
					combat.turn_and_play_second_attack()
				end
			else
				dive_and_surface_at_target(6)
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(2.5, vm.f32(4.2), 46.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 45 then
			else
				roll = monster.get_random(100) or roll
				strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
				if roll < 50 then
					strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
				else
					strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(2.5, vm.f32(4.2), strafe_angle_degrees, 92.0, 1.0, 25)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			end
		end
	end
end

--- Attacks a nearby player, circles around them or dives.
local function act_at_close_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			roll = monster.get_random(100) or roll
			if roll < 70 then
				combat.turn_and_play_first_attack()
			else
				combat.turn_and_play_second_attack()
			end
		else
			dive_and_surface_at_target(6)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 45 then
			roll = monster.get_random(100) or roll
			strafe_angle_degrees = monster.get_random_whole_number(60.0) or strafe_angle_degrees
			if roll < 50 then
				strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
			else
				strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.5, vm.f32(4.2), strafe_angle_degrees, 92.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			roll = monster.get_random(30) or roll
			roll = vm.i32(roll + 15)
			dive_and_surface_at_target(roll)
		end
	end
end

--- Chooses an action by distance to the player for as long as the player stays in range.
local function fight_target_in_range()
	local target_distance: f32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 400.0 then
			reaction.update_and_wait_frame()
			return
		end
		if target_distance < 400.0 and target_distance >= 200.0 then
			act_at_long_range()
		elseif target_distance < 200.0 and target_distance >= 100.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Either walks toward the player or dives for a long stretch.
local function approach_or_dive()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(2.5, vm.f32(4.2), 46.0, 45)
		monster.set_motion("立ち", -1, 0)
	else
		dive_and_surface_at_target(60)
	end
end

--- Fights or approaches the player depending on whether the guard is active and how far away the player is.
local function choose_action()
	local target_distance: f32 = 0
	local guard_release_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if reaction.is_guard_active() == 0 then
		if target_distance < 400.0 then
			fight_target_in_range()
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("歩き", -1, 0)
			movement.pursue_target_guarded(2.5, vm.f32(4.2), 46.0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	else
		guard_release_distance = state.get_secondary_float(guard_release_distance)
		if target_distance < guard_release_distance then
			if target_distance < 100.0 then
				reaction.set_guard_active(0)
				fight_target_in_range()
			else
				approach_or_dive()
			end
		else
			reaction.set_guard_active(0)
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows and configures the guard.
function script.init()
	monster.register_damage_hit("シードラ攻撃２", 8.0, "攻撃１", 0.404, 0.538, 1)
	monster.register_damage_hit("シードラ攻撃２", 13.2, "攻撃１", 0.404, 0.538, 2)
	monster.register_damage_hit("シードラ攻撃", 4.0, "攻撃２", 0.292, 0.375, 0)
	monster.register_damage_hit("シードラ攻撃３", 8.0, "避け戻り", 0.0, 0.627, 3)
	monster.set_variable(0, 0)
	monster.set_variable(0, 0)
	configure_guard_and_clip_distance()
	monster.set_clip_distance(99999.9)
end

--- Waits for the player to come near or for the guard to activate, then keeps choosing actions.
function script.loop()
	local woke_up: s32 = 0
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(1, 0)
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
	monster.set_monster_attributes(1, 0)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the knockdown to the engine default by defining nothing.
function script.on_knockdown() end

--- Answers a guarded hit by diving.
function script.on_guard()
	local dive_frames: s32 = 0
	state.lock_and_stop_moving()
	monster.set_monster_attributes(1, 0)
	dive_frames = monster.get_random(30) or dive_frames
	dive_frames = vm.i32(dive_frames + 15)
	dive_and_surface_at_target(dive_frames)
	state.unlock()
end

--- Dodges the first kind of attack by diving.
function script.on_dodge_1()
	local dive_frames: s32 = 0
	state.lock_and_reset_motion()
	monster.set_monster_attributes(1, 0)
	dive_frames = monster.get_random(30) or dive_frames
	dive_frames = vm.i32(dive_frames + 15)
	dive_and_surface_at_target(dive_frames)
	state.unlock()
end

--- Dodges the second kind of attack by diving.
function script.on_dodge_2()
	local dive_frames: s32 = 0
	state.lock_and_reset_motion()
	monster.set_monster_attributes(1, 0)
	dive_frames = monster.get_random(30) or dive_frames
	dive_frames = vm.i32(dive_frames + 15)
	dive_and_surface_at_target(dive_frames)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished_guarded()
	monster.spawn_death_effects()
	while true do
		reaction.update_and_wait_frame()
	end
	death.play_effects()
end

--- Hangs motionless while held in the air.
function script.on_caught()
	motion.reset()
	timer.wait_forever_guarded()
end

--- Recovers after being thrown.
function script.on_land()
	reaction.recover_from_throw()
	monster.set_monster_attributes(1, 0)
	state.do_nothing_hook()
	return 1
end

--- Falls over and gets back up, staying stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
