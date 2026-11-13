--!strict
--- Controls an Evil Flame, which arcs into the arena at a free slot, wanders near the centre and replaces itself with a new flame when defeated.

local vm = require("@lib/vm")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Frees its slot, plays the death motion, counts the defeat, requests the progress events at 10 and 20 defeats and spawns a replacement flame.
local function on_death()
	local claimed_slots: s32 = 0
	local own_slot_bit: s32 = 0
	local kill_stage: s32 = 0
	local kill_count: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.stop_moving()
	movement.stop_turning()
	claimed_slots = monster.get_variable(8) or claimed_slots
	own_slot_bit = monster.get_variable(6) or own_slot_bit
	claimed_slots = state.clear_flags(claimed_slots, own_slot_bit)
	monster.set_variable(8, claimed_slots)
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	kill_stage = 0
	kill_count = 0
	kill_stage = monster.get_variable(9) or kill_stage
	kill_count = monster.get_variable(10) or kill_count
	kill_count = vm.i32(kill_count + 1)
	monster.set_variable(10, kill_count)
	if kill_stage == 0 then
		if kill_count >= 10 then
			monster.set_variable(9, 1)
			monster.set_variable(10, 0)
			monster.request_event_script(510)
		end
	elseif kill_stage == 1 then
		if kill_count >= 20 then
			monster.set_variable(9, 2)
			monster.set_variable(10, 0)
			monster.request_event_script(510)
		end
	end
	monster.create_monster(513, 0.0, -100.0, 0.0)
	while true do
		vm.wait()
	end
end

--- Moves the flame along a gravity arc from a start point to an end point over a number of frames.
local function arc_to_point(start_x: f32, start_y: f32, start_z: f32, end_x: f32, end_y: f32, end_z: f32, gravity: f32, frame_count: s32)
	local frame_index: s32 = 0
	local has_passed_end_height: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local vertical_velocity: f32 = 0
	frame_index = 0
	has_passed_end_height = 0
	while frame_index < frame_count do
		vertical_velocity = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(end_y - start_y) * 2.0) - vm.f32(vm.f32(gravity * vm.i32(frame_count + 1)) * vm.i32(frame_count + 1))),
				vm.f32(vm.i32(frame_count + 1) * 2.0)
			)
		)
		y = start_y
		for i = 0, frame_index - 1 do
			vertical_velocity = vm.f32(vertical_velocity + gravity)
			y = vm.f32(y + vertical_velocity)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(end_x - start_x) * frame_index), frame_count)) + start_x)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(end_z - start_z) * frame_index), frame_count)) + start_z)
		if has_passed_end_height == 1 then
			if y < end_y then
				y = end_y
			end
		elseif y > end_y then
			has_passed_end_height = 1
		end
		monster.set_position(x, y, z)
		frame_index = frame_index + 1
		vm.wait()
	end
end

--- Stores flags describing how far the target is and whether it is in front.
local function update_distance_flags()
	local flags: s32 = 0
	local target_distance: f32 = 0
	flags = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance <= 50.0 then
		flags = vm.i32(bit32.bor(flags, 1))
	elseif target_distance <= 240.0 then
		flags = vm.i32(bit32.bor(flags, 2))
	elseif target_distance <= 760.0 then
		flags = vm.i32(bit32.bor(flags, 4))
	else
		flags = vm.i32(bit32.bor(flags, 8))
	end
	if target_distance <= 240.0 then
		flags = vm.i32(bit32.bor(flags, 16))
	end
	if sense.is_facing_target_with_offset(0, 45.0) ~= 0 then
		flags = vm.i32(bit32.bor(flags, 32))
	end
	if target_distance <= 90.0 then
		flags = vm.i32(bit32.bor(flags, 64))
	end
	if sense.is_facing_target_with_offset(0, 80.0) ~= 0 then
		flags = vm.i32(bit32.bor(flags, 128))
	end
	monster.set_variable(0, flags)
end

--- Picks the next behaviour and its follow-up, with a random wait for wandering.
local function choose_next_behavior()
	local queued_behavior: s32 = 0
	local following_behavior: s32 = 0
	local wait_frames: s32 = 0
	queued_behavior = monster.get_variable(2) or queued_behavior
	if queued_behavior ~= -1 then
		following_behavior = monster.get_variable(3) or following_behavior
		monster.set_variable(1, queued_behavior)
		monster.set_variable(2, following_behavior)
		monster.set_variable(3, -1)
		return
	end
	monster.get_variable(0)
	monster.set_variable(1, 4)
	monster.set_variable(2, 3)
	wait_frames = monster.get_random(60) or wait_frames
	wait_frames = vm.i32(wait_frames + 60)
	monster.set_variable(4, wait_frames)
end

--- Walks or runs to a random point near the arena centre.
local function wander_near_center()
	local center_angle: f32 = 0
	local wander_radius: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local move_speed: f32 = 0
	local roll: s32 = 0
	local has_arrived: s32 = 0
	wander_radius = vm.bits_float(monster.get_random(20.0)) or wander_radius
	wander_radius = vm.f32(wander_radius + 20.0)
	center_angle = monster.get_angle_to_position(0.0, 0.0, 0.0) or center_angle
	target_x = vm.f32(vm.f32(vm.sin(center_angle) * wander_radius) + target_x)
	target_y = 0.0
	target_z = vm.f32(vm.f32(vm.cos(center_angle) * wander_radius) + target_z)
	roll = monster.get_random(100) or roll
	if vm.imod(roll, 2) == 0 then
		monster.set_motion("歩き")
		move_speed = vm.f32(0.2)
	else
		monster.set_motion("走り")
		move_speed = vm.f32(0.4)
	end
	monster.move_toward_position(target_x, target_y, target_z, move_speed, move_speed)
	has_arrived = monster.is_move_finished() or has_arrived
	while has_arrived == 0 do
		monster.turn_toward_angle(center_angle, 0.034906585)
		vm.wait()
		has_arrived = monster.is_move_finished() or has_arrived
	end
	monster.set_motion("立ち")
end

--- Waits for the stored delay and resets it.
local function wait_idle_delay()
	local delay_frames: s32 = 0
	delay_frames = monster.get_variable(4) or delay_frames
	timer.wait_frames_countdown(delay_frames)
	monster.set_variable(4, 40)
end

--- Runs the behaviour selected for the flame.
local function run_current_behavior()
	local behavior: s32 = 0
	behavior = monster.get_variable(1) or behavior
	monster.get_variable(0)
	if behavior == 1 then
		state.do_nothing()
	end
	if behavior == 2 then
		state.do_nothing()
	end
	if behavior == 4 then
		wander_near_center()
	end
	if behavior == 3 then
		monster.set_motion("立ち")
		wait_idle_delay()
	end
end

local script = {}

--- Does nothing.
function script.setup() end

--- Initialises the flame variables and clip distance and sets its alpha.
function script.init()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 3)
	monster.set_variable(3, -1)
	monster.set_variable(4, 40)
	monster.set_variable(5, 0)
	monster.set_variable(6, 0)
	monster.set_clip_distance(40.0)
	monster.set_motion("立ち", -1, 4)
	monster.set_alpha(0.99)
end

--- Claims a free slot, arcs into the arena and then repeatedly chooses and runs a behaviour.
function script.loop()
	local has_started: s32 = 0
	local claimed_slots: s32 = 0
	local i: s32 = 0
	local slot_index: s32 = 0
	local slot_bit: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local end_x: f32 = 0
	local end_z: f32 = 0
	local center_angle: f32 = 0
	local slot_angle: f32 = 0
	has_started = monster.get_variable(5) or has_started
	if has_started == 0 then
		vm.wait()
		monster.set_variable(5, 1)
		monster.set_monster_attributes(12, 1)
		monster.set_invulnerable_time(30)
		claimed_slots = monster.get_variable(8) or claimed_slots
		if bit32.band(claimed_slots, 255) == 255 then
			print("ERRER : ---  NOT_ROOT --- \n")
			on_death()
			return
		end
		while true do
			i = 0
			slot_bit = 1
			slot_index = monster.get_random(8) or slot_index
			while i < slot_index do
				slot_bit = vm.i32(slot_bit * 2)
				i = i + 1
			end
			if vm.i32(bit32.band(claimed_slots, slot_bit)) == 0 then
				claimed_slots = vm.i32(bit32.bor(claimed_slots, slot_bit))
				monster.set_variable(8, claimed_slots)
				monster.set_variable(6, slot_bit)
				break
			end
		end
		slot_angle = vm.f32(vm.f32(-0.08) + vm.f32(vm.f32(0.7853982) * slot_index))
		slot_angle = monster.wrap_angle(slot_angle) or slot_angle
		start_x = vm.f32(vm.sin(slot_angle) * 400.0)
		start_y = -80.0
		start_z = vm.f32(vm.cos(slot_angle) * 400.0)
		monster.set_position(start_x, start_y, start_z)
		center_angle = monster.get_angle_to_position(0.0, 0.0, 0.0) or center_angle
		do
			local out1, _, out3 = monster.get_point_from_facing(center_angle, 140.0)
			end_x = out1 or end_x
			end_z = out3 or end_z
		end
		monster.set_rotation(0.0, center_angle, 0.0)
		arc_to_point(start_x, -80.0, start_z, end_x, 0.0, end_z, vm.f32(-0.6), 30)
		monster.set_monster_attributes(12, 0)
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("立ち")
	while true do
		update_distance_flags()
		choose_next_behavior()
		run_current_behavior()
		vm.wait()
	end
end

--- Plays the damage motion with a small knockback.
function script.on_damage()
	state.reset_variables()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames_countdown(8)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Plays the knockdown motion and gets up.
function script.on_knockdown()
	state.reset_variables()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.start_knockback(5.0, 0.05, 10)
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames_countdown(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Faces the target and plays the guard motion.
function script.on_guard()
	state.reset_variables()
	monster.stop_moving()
	movement.face_target_instantly()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 4)
	motion.wait_until_finished()
	timer.wait_frames_countdown(8)
end

--- Dodges the target's first kind of attack.
script.on_dodge_1 = state.reset_variables

--- Dodges the target's second kind of attack.
script.on_dodge_2 = state.reset_variables

script.on_death = on_death

--- Struggles while caught.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers after being thrown and gets back up.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_countdown(10)
	monster.set_motion("起き上がり", -1, 2)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	return 1
end

--- Plays the knockback motions and stays stunned until recovered.
function script.on_stun()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("気絶", -1)
	reaction.wait_for_stun_end()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

return script
