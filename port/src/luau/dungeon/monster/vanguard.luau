--!strict
--- Drives the Vanguard family of armoured robot monsters that charge, spin and slam the player.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Starts the story event the first time the player hits a Vanguard.
local function request_first_hit_event()
	local is_event_seen: s32 = 0
	local attack_type: s32 = 0
	is_event_seen = monster.is_save_flag_set(51) or is_event_seen
	if is_event_seen == 0 then
		attack_type = monster.get_last_attack_type() or attack_type
		if attack_type == 0 then
			monster.set_save_flag(51, 1)
			monster.request_event_script(2510)
		end
	end
end

--- Walks toward the target until it should turn, attack, guard or give up, and returns which.
local function walk_toward_target_until_action()
	local action_code: s32 = 0
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local position_y: f32 = 0
	while true do
		request_first_hit_event()
		if sense.is_facing_target_degrees(0, 180.0) == 0 then
			action_code = 1
			break
		else
			target_distance = monster.get_target_distance() or target_distance
			if target_distance > 360.0 then
				action_code = 0
				break
			else
				priority = monster.get_priority() or priority
				if priority > 3 and target_distance < 120.0 then
					action_code = 4
					break
				else
					if sense.is_facing_target_degrees(0, 60.0) ~= 0 then
						if target_distance < 60.0 then
							action_code = 2
							break
						end
						roll = monster.get_random(200) or roll
						if roll < 1 then
							action_code = 3
							break
						end
					end
					monster.set_motion("歩き", -1.0, 0)
					do
						local out1, _, out3 = monster.get_target_position()
						target_x = out1 or target_x
						target_z = out3 or target_z
					end
					movement.turn_toward_target(vm.f32(0.05235988))
					do
						local _, out2, _ = monster.get_position_3()
						position_y = out2 or position_y
					end
					monster.move_toward_position(target_x, position_y - 20.0, target_z, 1.5, 1.5)
					vm.wait()
					monster.stop_moving()
				end
			end
		end
	end
	return action_code
end

--- Turns the monster until it faces the target.
local function turn_to_face_target()
	local current_rotation: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("歩き", -1.0, 0)
	while true do
		movement.turn_toward_target(vm.f32(0.07853982))
		do
			local _, out2, _ = monster.get_rotation()
			current_rotation = out2 or current_rotation
		end
		target_angle = monster.get_target_angle() or target_angle
		if calc.compare_angles(target_angle, current_rotation, vm.f32(0.1)) == 0 then
			movement.stop_turning()
			break
		else
			vm.wait()
		end
	end
end

--- Picks and performs an attack by target distance and returns the recovery time in frames.
local function attack_target()
	local attack: s32 = 0
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local character_type: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	attack = monster.get_attack_power_1() or attack
	if target_distance < 40.0 then
		monster.set_motion("攻撃２", -1, 2)
		motion.wait_until_progress_reached(vm.f32(0.711), -1.0)
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.create_effect_1("ヴァンガード衝撃波")
		monster.set_effect_first_vector(-1, position_x, position_y, position_z)
		monster.set_effect_value(-1, 0, attack)
		motion.wait_until_finished()
		return 30
	end
	if target_distance < 60.0 then
		monster.stop_moving()
		monster.set_motion("攻撃１", -1, 2)
		motion.wait_until_finished()
		return 30
	end
	if target_distance < 120.0 then
		movement.face_target_instantly()
		vm.wait()
		monster.set_motion("攻撃３in", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("攻撃３", -1, 4)
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		monster.get_position_3()
		monster.move_toward_position(target_x, target_y, target_z, 3.5, 10.0)
		character_type = monster.get_character_number() or character_type
		monster.create_effect_1("スピン")
		monster.set_effect_owner(-1, character_type)
		monster.set_effect_value(-1, 1, vm.ftoi(vm.f32(target_distance / 3.5)))
		monster.set_effect_value_float(-1, 2, 1.0)
		movement.wait_until_move_finished(vm.f32(target_distance / 3.5))
		motion.wait_until_ended()
		monster.stop_moving()
		monster.set_motion("攻撃３out", -1, 6)
		motion.wait_until_finished()
		return 12
	end
	return 0
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Registers the attack hit windows, loads the attack effects and the photo opportunity.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("弱攻撃", 4.0, "攻撃１", 0.3, 0.5, 1)
	monster.register_damage_hit("弱攻撃", 4.0, "攻撃１", 0.3, 0.5, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 4.5, "攻撃３", 0.0, 1.0, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 4.5, "攻撃３", 0.0, 1.0, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 4.5, "攻撃３out", 0.1, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 4.5, "攻撃３out", 0.1, 0.5, 2)
	monster.load_effect_script("ヴァンガード衝撃波")
	monster.load_effect_script("スピン")
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃２", 0.267, 0.622, 1018)
	end
end

--- Walks toward the target, attacks when it is near, and idles when it is far.
function script.loop()
	local action_code: s32 = 0
	local idle_frames: s32 = 0
	local target_distance: f32 = 0
	local current_rotation: f32 = 0
	local target_angle: f32 = 0
	local attack_recovery_frames: s32 = 0
	local attack_recovery_frames_2: s32 = 0
	local roll: s32 = 0
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		behavior.try_face_transformed_player_plain_speed_3()
		vm.wait()
		request_first_hit_event()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 360.0 then
			action_code = walk_toward_target_until_action()
		end
		if target_distance >= 360.0 then
			action_code = 0
		end
		if action_code == 0 then
			monster.set_motion("立ち")
			idle_frames = vm.i32(idle_frames - 1)
			if idle_frames > 0 then
				continue
			end
			idle_frames = monster.get_random(60) or idle_frames
			idle_frames = vm.i32(idle_frames + 30)
			do
				local _, out2, _ = monster.get_rotation()
				current_rotation = out2 or current_rotation
			end
			target_angle = monster.get_target_angle() or target_angle
			if calc.compare_angles(target_angle, current_rotation, vm.f32(0.1)) == 0 then
				continue
			end
			monster.set_motion("歩き")
			while true do
				movement.turn_toward_target(vm.f32(0.05235988))
				do
					local _, out2, _ = monster.get_rotation()
					current_rotation = out2 or current_rotation
				end
				target_angle = monster.get_target_angle() or target_angle
				if calc.compare_angles(target_angle, current_rotation, vm.f32(0.1)) == 0 then
					movement.stop_turning()
					break
				else
					vm.wait()
				end
			end
			monster.set_motion("立ち")
		end
		if action_code == 1 then
			turn_to_face_target()
		end
		if action_code == 2 then
			attack_recovery_frames = attack_target()
			monster.set_motion("立ち")
			timer.wait_frames(attack_recovery_frames)
		end
		if action_code == 3 then
			turn_to_face_target()
			attack_recovery_frames_2 = attack_target()
			monster.set_motion("立ち")
			timer.wait_frames(attack_recovery_frames_2)
		end
		if action_code == 4 then
			monster.stop_moving()
			movement.stop_turning()
			monster.set_motion("立ち")
			if sense.is_facing_target_degrees(0, 60) == 0 then
				roll = monster.get_random(100) or roll
				if roll < 2 then
					monster.set_motion("歩き")
					turn_to_face_target()
					monster.set_motion("立ち")
				end
			end
		end
	end
end

--- Holds the monster in its damage pose until its status ailment wears off.
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

--- Staggers the monster back when it takes a hit.
function script.on_damage()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(8)
end

--- Staggers the monster back when it is knocked down.
function script.on_knockdown()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(8)
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine does not run its default guard.
function script.on_guard() end

--- Occasionally becomes invulnerable and counterattacks.
function script.on_dodge_1()
	local roll: s32 = 0
	monster.set_mask_flags(2, 1)
	roll = monster.get_random(100) or roll
	if roll < 10 then
		monster.set_invulnerable_time(30)
		attack_target()
	end
	monster.set_mask_flags(2, 0)
end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine does not run its default dodge.
function script.on_dodge_2() end

--- Plays the monster's death animation and effects.
function script.on_death()
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Staggers the monster and keeps it stunned until it recovers.
function script.on_stun()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("気絶", -1)
	reaction.wait_for_stun_end()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

return script
