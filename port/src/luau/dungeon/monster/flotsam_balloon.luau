--!strict
--- Controls the Flotsam Balloon monster, which arcs out when it spawns, then walks and runs toward the player and attacks at close range.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Moves the monster along a gravity arc between two positions over a set number of frames.
local function arc_to_position(start_x: f32, start_y: f32, start_z: f32, end_x: f32, end_y: f32, end_z: f32, gravity: f32, frame_count: s32)
	local frame: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local velocity_y: f32 = 0
	frame = 0
	while frame < frame_count do
		velocity_y = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(end_y - start_y) * 2.0) - vm.f32(vm.f32(gravity * vm.i32(frame_count + 1)) * vm.i32(frame_count + 1))),
				vm.f32(vm.i32(frame_count + 1) * 2.0)
			)
		)
		y = start_y
		for i = 0, frame - 1 do
			velocity_y = vm.f32(velocity_y + gravity)
			y = vm.f32(y + velocity_y)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(end_x - start_x) * frame), frame_count)) + start_x)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(end_z - start_z) * frame), frame_count)) + start_z)
		if y < end_y then
			y = end_y
		end
		monster.set_position(x, y, z)
		frame = frame + 1
		vm.wait()
	end
end

--- Builds a bit mask describing the target's facing, range and the monster's rage state.
local function get_situation_flags()
	local flags: s32 = 0
	local target_distance: f32 = 0
	local is_facing_target: s32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	flags = 0
	is_facing_target = sense.is_facing_target_with_offset(0, 180.0)
	if is_facing_target == 1 then
		flags = vm.i32(bit32.bor(flags, 4))
	end
	if is_facing_target == 0 then
		flags = vm.i32(bit32.bor(flags, 8))
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 2400.0 then
		flags = vm.i32(bit32.bor(flags, 1))
	end
	if target_distance > 2400.0 then
		flags = vm.i32(bit32.bor(flags, 2))
	end
	if sense.is_facing_target_with_offset(0, 60.0) ~= 0 and target_distance <= 40.0 then
		flags = vm.i32(bit32.bor(flags, 16))
	end
	priority = monster.get_priority() or priority
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if priority <= 2 or gekirin == 0 then
		flags = vm.i32(bit32.bor(flags, 32))
	end
	return flags
end

--- Plays a near or far attack depending on the target's distance.
local function attack_target()
	local target_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 30.0 then
		monster.set_motion("攻撃１", -1, 2)
	else
		monster.set_motion("攻撃２", -1, 2)
	end
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(8)
end

--- Drifts toward the target until it comes within range or a random frame budget runs out.
local function drift_toward_target()
	local frame_budget: s32 = 0
	local target_distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	frame_budget = monster.get_random(90) or frame_budget
	frame_budget = vm.i32(frame_budget + 150)
	while true do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 2400.0 then
			break
		else
			monster.set_motion("歩き")
			do
				local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			movement.turn_toward_target(vm.f32(0.024543693))
			monster.move_toward_position(pos_x, pos_y, pos_z, 0.9, 1.0)
			frame_budget = vm.i32(frame_budget - 1)
			if frame_budget < 0 then
				break
			else
				vm.wait()
			end
		end
	end
end

--- Waits until the target comes within range or the frame limit expires.
local function wait_for_target_in_range(max_frames: any)
	local target_distance: f32 = 0
	while true do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance <= 2400.0 then
			break
		else
			max_frames = vm.wrap(max_frames - 1)
			if max_frames < 0 then
				break
			else
				vm.wait()
			end
		end
	end
end

--- Turns in place until facing the target.
local function turn_to_face_target()
	local current_angle: f32 = 0
	local target_angle: f32 = 0
	monster.set_motion("歩き")
	while true do
		movement.turn_toward_target(vm.f32(0.049087387))
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		target_angle = monster.get_target_angle() or target_angle
		if calc.compare_angles(target_angle, current_angle, vm.f32(0.049087387)) == 0 then
			movement.stop_turning()
			break
		else
			vm.wait()
		end
	end
end

--- Runs toward the target until close enough, returning 1 if the target leaves its front or range and 0 otherwise.
local function chase_target(situation_flags: s32)
	local target_distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	while true do
		if sense.is_facing_target_with_offset(0, 180.0) == 0 then
			return 1
		end
		target_distance = monster.get_target_distance() or target_distance
		if bit32.band(situation_flags, 32) ~= 0 then
			if target_distance <= 40.0 then
				return 0
			end
		elseif target_distance <= 160.0 then
			return 0
		end
		if target_distance > 2400.0 then
			return 1
		end
		monster.set_motion("走り")
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		movement.turn_toward_target(vm.f32(0.049087387))
		monster.move_toward_position(pos_x, pos_y, pos_z, 1.8, 1.0)
		vm.wait()
	end
	return 0
end

--- Chooses the behaviour for the given situation flags.
local function act_on_situation(situation_flags: s32)
	local random_roll: s32 = 0
	local random_roll_2: s32 = 0
	local random_roll_3: s32 = 0
	local random_roll_4: s32 = 0
	if (if bit32.band(situation_flags, 16) ~= 0 then bit32.band(situation_flags, 32) else 0) ~= 0 then
		attack_target()
		random_roll = monster.get_random(60) or random_roll
		random_roll = vm.i32(random_roll + 10)
		timer.wait_frames(random_roll)
		return
	end
	if bit32.band(situation_flags, 2) ~= 0 then
		if sense.is_facing_target_with_offset(0, 60.0) ~= 0 then
			random_roll_2 = monster.get_random(400) or random_roll_2
			if random_roll_2 < 1 then
				drift_toward_target()
				random_roll_2 = monster.get_random(60) or random_roll_2
				random_roll_2 = vm.i32(random_roll_2 + 60)
				monster.set_motion("立ち")
				wait_for_target_in_range(random_roll_2)
			end
		else
			random_roll_3 = monster.get_random(100) or random_roll_3
			if random_roll_3 < 2 then
				turn_to_face_target()
				random_roll_3 = monster.get_random(60) or random_roll_3
				random_roll_3 = vm.i32(random_roll_3 + 60)
				monster.set_motion("立ち")
				wait_for_target_in_range(random_roll_3)
			end
		end
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 8) else 0) ~= 0 then
		turn_to_face_target()
		return
	end
	if (if bit32.band(situation_flags, 1) ~= 0 then bit32.band(situation_flags, 4) else 0) ~= 0 then
		if chase_target(situation_flags) ~= 0 then
			return
		else
			turn_to_face_target()
		end
		if bit32.band(situation_flags, 32) == 0 then
			random_roll_4 = monster.get_random(100) or random_roll_4
			if random_roll_4 < 2 then
				turn_to_face_target()
			end
		end
		return
	end
end

local script = {}

--- Runs once when the script is loaded, before any program.
function script.setup() end

--- Registers the body collision, damage hits and clip distance.
function script.init()
	monster.register_entry_object(0, "bcol00")
	monster.register_entry_object(1, "dcol00")
	monster.register_entry_object(2, "dcol00")
	monster.register_entry_object(3, "dcol01")
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃２", 0.2, 0.8, 0)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 1)
	monster.register_damage_hit("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 2)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 2)
	monster.set_body(0, 8.0)
	monster.set_clip_distance(120.0)
end

--- Arcs the monster out when it spawns, then repeatedly picks a behaviour for the current situation.
function script.loop()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local spawn_angle: f32 = 0
	local facing_angle: f32 = 0
	local situation_flags: s32 = 0
	value = monster.get_variable(0) or value
	if value == 0 then
		monster.set_monster_attributes(4, 1)
		monster.set_invulnerable_time(30)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		spawn_angle = monster.get_random_whole_number(6.2831855) or spawn_angle
		spawn_angle = vm.f32(spawn_angle - vm.f32(3.1415927))
		spawn_angle = monster.wrap_angle(spawn_angle) or spawn_angle
		pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(spawn_angle) * 140.0))
		pos_y_2 = 0.0
		pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(spawn_angle) * 140.0))
		facing_angle = monster.get_angle_to_position(pos_x_2, pos_y_2, pos_z_2) or facing_angle
		monster.set_rotation(0.0, facing_angle, 0.0)
		arc_to_position(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2, -1.0, 30)
		monster.set_monster_attributes(4, 0)
		monster.set_variable(0, 1)
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		monster.set_motion("立ち")
		situation_flags = get_situation_flags()
		act_on_situation(situation_flags)
		vm.wait()
	end
end

--- Plays the flinch reaction when the monster is hit.
function script.on_damage()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("立ち")
end

--- Plays the knockdown reaction when the monster is knocked over.
function script.on_knockdown()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 30)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
end

--- Plays the guard reaction when the monster blocks a hit.
function script.on_guard()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("立ち")
end

--- Dodges backward and counterattacks or recovers, depending on the rage state.
function script.on_dodge_1()
	local target_angle: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local gekirin: s32 = 0
	local counterattack_chance: s32 = 0
	local random_roll: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("避け", -1, 2)
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	vm.wait()
	monster.set_invulnerable_time(6)
	timer.wait_frames(6)
	do
		local out1, out2, out3 = monster.get_point_from_facing(3.1415927, 35.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.move_toward_position(pos_x, pos_y, pos_z, 5.0, 5.0)
	motion.wait_until_finished()
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin == 0 then
		counterattack_chance = 80
	else
		counterattack_chance = 30
	end
	random_roll = monster.get_random(100) or random_roll
	if random_roll < counterattack_chance then
		monster.set_motion("避け攻撃", -1, 6)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 30.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, 5.0, 5.0)
		motion.wait_until_finished()
	else
		monster.set_motion("避け戻り", -1, 6)
		motion.wait_until_finished()
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the monster has no second dodge.
function script.on_dodge_2() end

--- Plays the monster's death sequence.
function script.on_death()
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Plays the struggling pose while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Ends the throw and recovers.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	return 1
end

--- Plays the stun reaction until the monster recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
