--!strict
--- Controls the Yoyo Barrel, a barrel monster that swings and rolls into the target.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the monster's default guard and clip-distance settings, with unlimited clip distance for bosses.
local function apply_default_settings()
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

--- Strafes around the target at a fixed distance or idles in place while waiting for an opening.
local function keep_distance_while_waiting()
	local roll: s32 = 0
	local offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		offset_degrees = monster.get_random_whole_number(30.0) or offset_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 160.0)
		if roll < 50 then
			offset_degrees = vm.f32(-offset_degrees - 30.0)
		else
			offset_degrees = vm.f32(offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = movement.walk_to_point_near_target(6.0, vm.f32(4.2), offset_degrees, distance, 78.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(78.0, 45.0, 30)
	end
end

--- Turns to the target and walks toward it from long range.
local function approach_from_far()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	movement.chase_target_guarded(6.0, vm.f32(4.2), 78.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Turns to the target and walks toward it from mid range.
local function approach_from_mid_range()
	monster.get_life()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("歩き", -1.0, 0)
	movement.chase_target_guarded(6.0, vm.f32(4.2), 78.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Turns to the target and plays the first attack motion.
local function perform_attack_1()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Turns to the target and plays the second attack motion.
local function perform_attack_2()
	monster.set_motion("歩き", 0.45, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(3)
end

--- Winds up, then rolls forward in a spinning attack before recovering.
local function perform_spin_attack(requested_frames: any)
	local chara_type: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	monster.set_motion("歩き", 0.45, 0)
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
		yaw = out2 or yaw
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(yaw) * 300.0))
	pos_y = vm.f32(pos_y - 20.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(yaw) * 300.0))
	monster.set_motion("攻撃３loop", -1, 4)
	monster.move_toward_position(pos_x, pos_y, pos_z, 7.4, 7.4)
	chara_type = monster.get_character_number() or chara_type
	monster.create_effect_1("スピン")
	monster.set_effect_owner(-1, chara_type)
	monster.set_effect_value(-1, 1, 45)
	monster.set_effect_value_float(-1, 2, 1.0)
	timer.wait_frames_with_guard_update(45)
	monster.stop_moving()
	monster.set_motion("攻撃３out", -1, 6)
	motion.wait_until_finished_guarded()
end

--- Picks a random attack, spin or advance for a target at close range.
local function choose_close_range_move()
	local roll: s32 = 0
	local target_distance: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 60.0 then
				perform_attack_1()
			else
				perform_attack_2()
			end
		else
			perform_spin_attack(45)
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(6.0, vm.f32(4.2), 78.0, 90)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Loops choosing moves by target distance until the target leaves range or rage hits run out.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		reaction.watch_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 290.0 then
			reaction.update_and_wait_frame()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 290.0 and target_distance >= 200.0 then
			approach_from_far()
		elseif target_distance < 200.0 and target_distance >= 160.0 then
			approach_from_mid_range()
		else
			choose_close_range_move()
		end
	end
end

--- Idles, turns, circles or wanders near its spawn point while the target is out of combat range.
local function wander_idle()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unknown_mode: s32 = 0
	local home_distance: f32 = 0
	local turn_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local clear_distance: f32 = 0
	local orbit_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local offset_degrees: f32 = 0
	local walk_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	home_distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 78.0 then
		turn_degrees = monster.get_random_whole_number(360.0) or turn_degrees
		monster.set_motion("歩き", 0.45, 0)
		movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 78.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), 1.75, turn_degrees, clear_distance, 78.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if home_distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.2), home_distance, orbit_degrees, 78.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 40 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_degrees = vm.f32(turn_degrees * -1.0)
			end
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_to_angle_and_wait(turn_degrees, vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_variable(0, 4)
					roll = monster.get_random(100) or roll
					offset_degrees = monster.get_random_whole_number(180.0) or offset_degrees
					walk_distance = monster.get_random_whole_number(30.0) or walk_distance
					target_distance = monster.get_target_distance() or target_distance
					walk_distance = vm.f32(walk_distance + target_distance)
					if roll < 50 then
						offset_degrees = vm.f32(offset_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						offset_degrees = vm.f32(-offset_degrees - 30.0)
					else
						offset_degrees = vm.f32(offset_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(1.75, vm.f32(4.2), offset_degrees, walk_distance, 78.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw = out2 or yaw
					end
					turn_degrees = calc.radians_to_degrees(yaw)
					if turn_degrees > vm.f32(3.1415927) then
						turn_degrees = vm.f32(turn_degrees - vm.f32(6.2831855))
					end
					if turn_degrees <= vm.f32(-3.1415927) then
						turn_degrees = vm.f32(turn_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.75, turn_degrees, 1000.0, 78.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unknown_mode == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.75, vm.f32(4.2), home_distance, 360.0, 40.0, 78.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks toward the target while the guard state is active.
local function chase_target_while_guarded()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(6.0, vm.f32(4.2), 78.0, 120)
	monster.set_motion("立ち", -1, 0)
end

--- Fights with attacks and spins once its rage hits are used up.
local function fight_when_rage_exhausted()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local gekirin: s32 = 0
	local close_distance: f32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 290.0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			keep_distance_while_waiting()
			continue
		end
		if target_distance < 160.0 then
			close_distance = monster.get_target_distance() or close_distance
			if close_distance < 156.0 then
				roll = monster.get_random(100) or roll
				if roll < 70 then
					close_distance = monster.get_target_distance() or close_distance
					if close_distance < 60.0 then
						perform_attack_1()
					else
						perform_attack_2()
					end
				else
					perform_spin_attack(45)
				end
			else
				perform_spin_attack(45)
			end
		else
			monster.set_motion("歩き", 0.45, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("歩き", 0.55, 0)
			movement.chase_target_guarded(vm.f32(3.2), vm.f32(4.2), 78.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chooses between fighting, wandering and guard handling for each frame.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		reaction.watch_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 290.0 then
				fight_target()
			else
				wander_idle()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 160.0 then
					reaction.set_guard_active(0)
					fight_target()
				else
					chase_target_while_guarded()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_when_rage_exhausted()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the Yoyo Barrel's attack hits, loads its spin effect and applies its default settings when it is placed.
function script.init()
	local max_life: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃１", 0.325, 0.375, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃２", 0.319, 0.421, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.0, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.5, 1.0, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.0, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.4, "攻撃３loop", 0.0, 1.0, 1)
	monster.load_effect_script("スピン")
	monster.set_variable(0, 0)
	apply_default_settings()
	max_life = monster.get_monster_max_life(-1) or max_life
	reaction.set_guard_damage_threshold(vm.ftoi(vm.f32(max_life * vm.f32(0.05))))
end

--- Runs the Yoyo Barrel's normal combat behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Holds the Yoyo Barrel in its damage pose while a status ailment is active.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the Yoyo Barrel's stagger reaction to a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Handles the Yoyo Barrel being knocked down.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	state.unlock_and_clear_action()
end

--- Handles the Yoyo Barrel guarding against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the Yoyo Barrel's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Handles the Yoyo Barrel being caught and lifted.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
	timer.wait_forever_guarded()
end

--- Recovers the Yoyo Barrel after it lands from a throw.
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

--- Stuns the Yoyo Barrel until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames_with_guard_update(12)
	reaction.stun_until_recovered()
end

return script
