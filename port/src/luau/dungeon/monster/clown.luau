--!strict
--- Drives the clown soldier monster, which stabs and throws knives.

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

--- Keeps facing the target while the player stays transformed.
local function face_transformed_player(monster_kind: any)
	local character_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		timer.wait_one_frame()
		character_id = monster.get_player_transform_id() or character_id
		if character_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(vm.f32(5.6))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts facing the target if the player is currently transformed.
local function face_player_if_transformed()
	local character_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	character_id = monster.get_player_transform_id() or character_id
	if character_id > -1 then
		face_transformed_player(monster_kind)
	end
end

--- Builds a bit mask describing the target's range and facing.
local function classify_situation()
	local situation_flags: s32 = 0
	local target_distance: f32 = 0
	local is_facing_target: s32 = 0
	situation_flags = 0
	is_facing_target = sense.is_facing_target_with_offset(0, 120.0)
	if is_facing_target == 1 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 4))
	end
	if is_facing_target == 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 8))
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 160.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 1))
	end
	if target_distance > 160.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 2))
	end
	if sense.is_facing_target_with_offset(0, 45.0) ~= 0 and target_distance <= 135.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 16))
	end
	return situation_flags
end

--- Stabs when the target is adjacent or throws a knife from mid range, and recovers if it attacked.
local function stab_or_throw_knife()
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local step_position_x: f32 = 0
	local step_position_z: f32 = 0
	local attack_power: s32 = 0
	local did_attack: s32 = 0
	local throw_distance: f32 = 0
	local roll: s32 = 0
	local monster_kind: s32 = 0
	local throw_chance: s32 = 0
	did_attack = 1
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 40.0 then
		monster.set_motion("攻撃１", -1, 2)
		timer.wait_frames(calc.pass_through(24))
		do
			local out1, _, out3 = monster.get_point_from_facing(0.0, 30.0)
			step_position_x = out1 or step_position_x
			step_position_z = out3 or step_position_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			position_y = out2 or position_y
		end
		monster.move_toward_position(step_position_x, position_y, step_position_z, 2.0, 2.0)
		motion.wait_until_finished()
	else
		throw_distance = monster.get_target_distance() or throw_distance
		if throw_distance > 90.0 then
			throw_chance = 50
			monster_kind = monster.get_monster_kind() or monster_kind
			if monster_kind == 600 then
				throw_chance = 0
			else
				throw_chance = 15
			end
			roll = monster.get_random(100) or roll
			if roll < throw_chance then
				monster.set_motion("攻撃２", -1, 6)
				timer.wait_frames(calc.pass_through(6))
				do
					local out1, _, out3 = monster.get_point_from_facing(0.0, 6.0)
					step_position_x = out1 or step_position_x
					step_position_z = out3 or step_position_z
				end
				do
					local _, out2, _ = monster.get_position_3()
					position_y = out2 or position_y
				end
				monster.move_toward_position(step_position_x, position_y, step_position_z, 0.6, 0.6)
				motion.wait_until_progress_facing_target(4.0, vm.f32(0.521), vm.f32(0.02))
				attack_power = monster.get_attack_power_1() or attack_power
				monster.create_effect_1("ピエロ兵ナイフ")
				monster.set_effect_value(-1, 0, attack_power)
				timer.wait_frames(calc.pass_through(5))
				monster.stop_moving()
				do
					local out1, _, out3 = monster.get_point_from_facing(0.0, 26.0)
					step_position_x = out1 or step_position_x
					step_position_z = out3 or step_position_z
				end
				do
					local _, out2, _ = monster.get_position_3()
					position_y = out2 or position_y
				end
				monster.move_toward_position(step_position_x, position_y, step_position_z, 1.8, 1.8)
				motion.wait_until_finished()
			else
				did_attack = 0
			end
		else
			did_attack = 0
		end
	end
	if did_attack ~= 0 then
		monster.stop_moving()
		monster.set_motion("立ち")
		timer.wait_frames(3)
	end
end

--- Turns on the spot until it faces the target.
local function turn_toward_target_in_place()
	local rotation_y: f32 = 0
	local target_angle: f32 = 0
	while true do
		monster.set_motion("歩き")
		movement.turn_toward_target(vm.f32(0.09817477))
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		target_angle = monster.get_target_angle() or target_angle
		if calc.compare_angles(target_angle, rotation_y, vm.f32(0.09817477)) == 0 then
			movement.stop_turning()
			break
		else
			vm.wait()
		end
	end
end

--- Walks toward the target until within a random stopping distance, and returns whether the target was lost.
local function approach_target()
	local stop_distance: f32 = 0
	local roll: s32 = 0
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_z: f32 = 0
	local step_position_y: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		stop_distance = 50.0
	else
		stop_distance = 30.0
	end
	while true do
		face_player_if_transformed()
		if sense.is_facing_target_with_offset(0, 120.0) == 0 then
			return 1
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return 0
		end
		if target_distance > 160.0 then
			movement.stop_turning()
			monster.stop_moving()
			return 1
		end
		monster.set_motion("歩き")
		do
			local out1, _, out3 = monster.get_point_from_facing(0.0, 3.0)
			position_x = out1 or position_x
			position_z = out3 or position_z
		end
		movement.turn_toward_target(vm.f32(0.09817477))
		do
			local _, out2, _ = monster.get_position_3()
			step_position_y = out2 or step_position_y
		end
		monster.move_toward_position(position_x, step_position_y, position_z, 0.8, 1.0)
		vm.wait()
	end
	return 0
end

--- Steps back or sideways toward the target and turns to face it until the step ends.
local function step_around_target()
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local side_angle: f32 = 0
	local step_speed: f32 = 0
	local roll: s32 = 0
	local step_position_y: f32 = 0
	local is_motion_finished: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 80.0 then
		monster.set_motion("ステップ後", -1, 2)
		do
			local out1, out2, out3 = monster.get_point_from_facing(3.1415927, 33.0)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		timer.wait_frames(calc.pass_through(10))
		step_speed = 4.0
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			side_angle = -10.0
			monster.set_motion("ステップ右", -1, 2)
		else
			side_angle = 10.0
			monster.set_motion("ステップ左", -1, 2)
		end
		position_x, position_y, position_z = movement.get_approach_point(side_angle, target_distance, position_x, position_y, position_z)
		timer.wait_frames(calc.pass_through(8))
		step_speed = vm.f32(target_distance / 60.0)
	end
	do
		local _, out2, _ = monster.get_position_3()
		step_position_y = out2 or step_position_y
	end
	monster.move_toward_position(position_x, step_position_y, position_z, step_speed, step_speed)
	while true do
		movement.turn_toward_target(vm.f32(0.09817477))
		is_motion_finished = monster.is_motion_finished() or is_motion_finished
		if is_motion_finished ~= 0 then
			break
		else
			vm.wait()
		end
	end
	movement.stop_turning()
	monster.set_motion("立ち")
end

--- Picks a reaction (attack, run, turn or step) from the situation mask.
local function react_to_situation(situation_flags: s32)
	local position_y: f32 = 0
	local target_distance: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local roll: s32 = 0
	if bit32.band(situation_flags, 16) ~= 0 then
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 40.0 or target_distance > 90.0 then
			stab_or_throw_knife()
			return
		else
			situation_flags = classify_situation()
		end
	end
	if bit32.band(situation_flags, 2) ~= 0 then
		movement.turn_toward_target(vm.f32(0.09817477))
		monster.set_motion("走り")
		do
			local out1, _, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_z = out3 or target_z
		end
		do
			local _, out2, _ = monster.get_position_3()
			position_y = out2 or position_y
		end
		monster.move_toward_position(target_x, position_y, target_z, 3.0, 160.0)
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 8) else 0) ~= 0 then
		turn_toward_target_in_place()
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 4) else 0) ~= 0 then
		roll = monster.get_random(100) or roll
		if roll < 10 then
			if approach_target() ~= 0 then
				return
			else
				turn_toward_target_in_place()
			end
		else
			step_around_target()
		end
	end
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Registers the clown's hit reactions and loads its knife effect.
function script.init()
	monster.register_damage_hit("Ｍ連撃２", 4.5, "攻撃１", 0.579, 0.664, 0)
	monster.register_damage_hit("Ｍ連撃２", 4.5, "攻撃１", 0.236, 0.321, 1)
	monster.load_effect_script("ピエロ兵ナイフ")
end

--- Updates the clown's behaviour every frame.
function script.loop()
	local situation_flags: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		face_player_if_transformed()
		situation_flags = classify_situation()
		react_to_situation(situation_flags)
		vm.wait()
	end
end

--- Plays the damage motion until the status ailments wear off.
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

--- Staggers back from a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(16)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Gets knocked down and stands back up.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default dodge.
function script.on_dodge_2() end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Stands up after being thrown.
function script.on_land()
	combat.finish_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Is knocked down and stays stunned until recovered.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
