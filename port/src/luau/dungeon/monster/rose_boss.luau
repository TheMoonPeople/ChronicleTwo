--!strict
--- Controls the rose boss that moves around a ring, casts tornadoes and commands six roses.

local vm = require("@lib/vm")
local motion = require("@lib/monster/motion")
local timer = require("@lib/monster/timer")

local current_slot: any = 0
local remaining_rounds: s32 = 0

--- Computes the position and facing of one of the boss's seven slots, the centre and six around a ring.
local function get_slot_transform(slot: any, out_x: f32, out_y: f32, out_z: f32, out_yaw: f32)
	local slot_x: f32 = 0
	local slot_y: f32 = 0
	local slot_z: f32 = 0
	local slot_yaw: f32 = 0
	if slot == 0 then
		slot_x = 250.0
		slot_y = 300.0
		slot_z = 250.0
		slot_yaw = 0.0
	end
	if slot == 1 then
		slot_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.617994)) * 150.0) + 250.0)
		slot_y = 100.0
		slot_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.617994)) * 150.0) + 250.0)
		slot_yaw = vm.f32(0.5235988)
	end
	if slot == 2 then
		slot_x = vm.f32(vm.f32(vm.sin(vm.f32(-1.5707964)) * 150.0) + 250.0)
		slot_y = 100.0
		slot_z = vm.f32(vm.f32(vm.cos(vm.f32(-1.5707964)) * 150.0) + 250.0)
		slot_yaw = vm.f32(1.5707964)
	end
	if slot == 3 then
		slot_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.5235988)) * 150.0) + 250.0)
		slot_y = 100.0
		slot_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.5235988)) * 150.0) + 250.0)
		slot_yaw = vm.f32(2.617994)
	end
	if slot == 4 then
		slot_x = vm.f32(vm.f32(vm.sin(vm.f32(0.5235988)) * 150.0) + 250.0)
		slot_y = 100.0
		slot_z = vm.f32(vm.f32(vm.cos(vm.f32(0.5235988)) * 150.0) + 250.0)
		slot_yaw = vm.f32(-2.617994)
	end
	if slot == 5 then
		slot_x = vm.f32(vm.f32(vm.sin(vm.f32(1.5707964)) * 150.0) + 250.0)
		slot_y = 100.0
		slot_z = vm.f32(vm.f32(vm.cos(vm.f32(1.5707964)) * 150.0) + 250.0)
		slot_yaw = vm.f32(-1.5707964)
	end
	if slot == 6 then
		slot_x = vm.f32(vm.f32(vm.sin(vm.f32(2.617994)) * 150.0) + 250.0)
		slot_y = 100.0
		slot_z = vm.f32(vm.f32(vm.cos(vm.f32(2.617994)) * 150.0) + 250.0)
		slot_yaw = vm.f32(-0.5235988)
	end
	out_x = slot_x
	out_y = slot_y
	out_z = slot_z
	out_yaw = slot_yaw
	return out_x, out_y, out_z, out_yaw
end

--- Places the boss at a slot instantly.
local function move_to_slot(slot: any)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local y_2: f32 = 0
	x, y, z, y_2 = get_slot_transform(slot, x, y, z, y_2)
	monster.set_position(x, y, z)
	monster.set_rotation(0.0, y_2, 0.0)
	current_slot = slot
end

--- Reads the state of one of the six roses.
local function get_rose_state(rose_index: any)
	local value: s32 = 0
	value = monster.get_variable(vm.wrap(14 + rose_index)) or value
	return value
end

--- Returns 1 when all six roses are in the given state.
local function is_every_rose_in_state(state: s32)
	for rose_index = 0, 5 do
		if state ~= get_rose_state(rose_index) then
			return 0
		end
	end
	return 1
end

--- Waits some frames and then until every rose is idle, returning the next state.
local function wait_for_roses_idle(delay_frames: s32)
	timer.wait_frames(delay_frames)
	while true do
		if is_every_rose_in_state(0) ~= 0 then
			break
		else
			vm.wait()
		end
	end
	return 2
end

--- Plays the attack motion and spawns a tornado effect at the boss.
local function cast_tornado()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	motion.wait_until_ended()
	monster.set_motion("攻撃２", -1, 2)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("サンの竜巻")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 4)
end

--- Frames the boss with the camera while it casts a tornado, then restores the camera.
local function cast_tornado_with_camera()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_camera_follow(0)
	monster.set_pause_flags(6, 1)
	monster.set_camera_speed(16.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_camera_position(pos_x, pos_y + 25.0, pos_z + 100.0)
	monster.set_camera_look_at(pos_x, pos_y + 25.0, pos_z)
	cast_tornado()
	monster.set_camera_follow(1)
	monster.set_camera_speed(8.0)
	monster.set_pause_flags(6, 0)
end

--- Sends a command to one of the six roses.
local function set_rose_command(rose_index: s32, value: s32)
	monster.set_variable(vm.i32(8 + rose_index), value)
end

--- Raises the roses in one of six random orders, with pauses between groups.
local function command_roses_randomly()
	local pattern: s32 = 0
	pattern = monster.get_random(6) or pattern
	if pattern == 0 then
		set_rose_command(1, 2)
		set_rose_command(3, 2)
		set_rose_command(5, 2)
		timer.wait_frames(90)
		set_rose_command(0, 2)
		set_rose_command(2, 2)
		set_rose_command(4, 2)
		timer.wait_frames(90)
	end
	if pattern == 1 then
		set_rose_command(0, 2)
		set_rose_command(2, 2)
		set_rose_command(4, 2)
		timer.wait_frames(90)
		set_rose_command(1, 2)
		set_rose_command(3, 2)
		set_rose_command(5, 2)
		timer.wait_frames(90)
	end
	if pattern == 2 then
		set_rose_command(3, 2)
		set_rose_command(4, 2)
		set_rose_command(5, 2)
		timer.wait_frames(90)
		set_rose_command(0, 2)
		set_rose_command(1, 2)
		set_rose_command(2, 2)
		timer.wait_frames(90)
	end
	if pattern == 3 then
		set_rose_command(0, 2)
		set_rose_command(1, 2)
		set_rose_command(2, 2)
		timer.wait_frames(90)
		set_rose_command(3, 2)
		set_rose_command(4, 2)
		set_rose_command(5, 2)
		timer.wait_frames(90)
	end
	if pattern == 4 then
		set_rose_command(5, 2)
		timer.wait_frames(30)
		set_rose_command(4, 2)
		timer.wait_frames(30)
		set_rose_command(3, 2)
		timer.wait_frames(30)
		set_rose_command(2, 2)
		timer.wait_frames(30)
		set_rose_command(1, 2)
		timer.wait_frames(30)
		set_rose_command(0, 2)
		timer.wait_frames(90)
	end
	if pattern == 5 then
		set_rose_command(0, 2)
		timer.wait_frames(30)
		set_rose_command(1, 2)
		timer.wait_frames(30)
		set_rose_command(2, 2)
		timer.wait_frames(30)
		set_rose_command(3, 2)
		timer.wait_frames(30)
		set_rose_command(4, 2)
		timer.wait_frames(30)
		set_rose_command(5, 2)
		timer.wait_frames(90)
	end
end

--- Returns the linear interpolation between two values at an elapsed time of a duration.
local function interpolate(start: f32, finish: f32, elapsed: f32, duration: f32)
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(finish - start) * elapsed), duration)) + start)
end

--- Slides and turns the boss to a slot over a number of frames.
local function slide_to_slot(slot: any, duration: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local start_yaw: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local y_2: f32 = 0
	local yaw_difference: f32 = 0
	local elapsed: f32 = 0
	local total_frames: f32 = 0
	local x_2: f32 = 0
	local y_3: f32 = 0
	local z_2: f32 = 0
	local y_4: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		start_yaw = out2 or start_yaw
	end
	x, y, z, y_2 = get_slot_transform(slot, x, y, z, y_2)
	yaw_difference = vm.f32(y_2 - start_yaw)
	if yaw_difference < vm.f32(-3.1415927) then
		yaw_difference = vm.f32(yaw_difference + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < yaw_difference then
		yaw_difference = vm.f32(yaw_difference - vm.f32(6.2831855))
	end
	elapsed = 0.0
	total_frames = duration
	while elapsed <= total_frames do
		x_2 = interpolate(pos_x, x, elapsed, total_frames)
		y_3 = interpolate(pos_y, y, elapsed, total_frames)
		z_2 = interpolate(pos_z, z, elapsed, total_frames)
		monster.set_position(x_2, y_3, z_2)
		y_4 = interpolate(0.0, yaw_difference, elapsed, total_frames)
		y_4 = vm.f32(y_4 + start_yaw)
		monster.set_rotation(0.0, y_4, 0.0)
		elapsed = vm.f32(elapsed + 1.0)
		vm.wait()
	end
	monster.set_position(x, y, z)
	monster.set_rotation(0.0, y_2, 0.0)
	current_slot = slot
end

--- Casts a tornado, commands the roses, waits for them and moves to a random ring slot.
local function run_attack_round()
	local slot_roll: s32 = 0
	cast_tornado_with_camera()
	command_roses_randomly()
	while true do
		if is_every_rose_in_state(2) ~= 0 then
			break
		else
			vm.wait()
		end
	end
	slot_roll = monster.get_random(6) or slot_roll
	current_slot = vm.i32(slot_roll + 1)
	slide_to_slot(current_slot, 90)
	return 3
end

--- Moves between ring slots at a fixed interval until a rose is hit or the rounds run out.
local function rotate_around_ring(frames_per_step: s32)
	local step_count: s32 = 0
	local frame: s32 = 0
	local rose_state: s32 = 0
	local direction_roll: s32 = 0
	step_count = 0
	while true do
		frame = 0
		while frame < frames_per_step do
			rose_state = get_rose_state(vm.wrap(current_slot - 1))
			if rose_state == 3 then
				return 4
			end
			frame = frame + 1
			vm.wait()
		end
		if 5 <= step_count then
			break
		else
			direction_roll = monster.get_random(2) or direction_roll
			if direction_roll ~= 0 then
				current_slot = vm.wrap(current_slot + 1)
			else
				current_slot = vm.wrap(current_slot - 1)
			end
			if current_slot < 1 then
				current_slot = 6
			end
			if 6 < current_slot then
				current_slot = 1
			end
			slide_to_slot(current_slot, 90)
			step_count = step_count + 1
		end
	end
	slide_to_slot(0, 90)
	return 5
end

--- Plays the knockdown motion and optionally gets back up.
local function play_knockdown(gets_up: s32)
	monster.set_motion("吹っ飛び", -1, 2)
	timer.wait_frames(150)
	if gets_up ~= 0 then
		monster.set_motion("起き上がり", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち", -1, 4)
	end
end

--- Consumes a round and either ends the fight or returns to the centre.
local function lose_round()
	remaining_rounds = vm.i32(remaining_rounds - 1)
	if remaining_rounds <= 0 then
		play_knockdown(0)
		return 0
	end
	play_knockdown(1)
	slide_to_slot(0, 90)
	return 5
end

--- Commands every rose into the raised state.
local function raise_all_roses()
	set_rose_command(0, 1)
	set_rose_command(1, 1)
	set_rose_command(2, 1)
	set_rose_command(3, 1)
	set_rose_command(4, 1)
	set_rose_command(5, 1)
end

--- Casts a tornado, raises all roses and waits for them to settle.
local function recover_roses()
	cast_tornado_with_camera()
	raise_all_roses()
	while true do
		if is_every_rose_in_state(0) ~= 0 then
			break
		else
			vm.wait()
		end
	end
	return 1
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Configures the boss attributes, position and effect scripts.
function script.init()
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_clip_distance(999)
	monster.set_monster_attributes(4, 1)
	monster.set_position(250.0, 300.0, 250.0)
	monster.load_effect_script("バラ")
	monster.load_effect_script("バラヒット")
	monster.load_effect_script("サンの竜巻")
end

--- Runs the state machine of waiting, attacking, rotating and recovering until the rounds are used up.
function script.loop()
	local state: s32 = 0
	monster.set_motion("立ち")
	current_slot = 0
	move_to_slot(current_slot)
	remaining_rounds = 3
	state = 1
	while true do
		if state == 1 then
			state = wait_for_roses_idle(90)
		end
		if state == 2 then
			state = run_attack_round()
		end
		if state == 3 then
			state = rotate_around_ring(90)
		end
		if state == 4 then
			state = lose_round()
		end
		if state == 5 then
			state = recover_roses()
		end
		if state == 0 then
			break
		end
	end
	monster.request_event_script(501)
	while true do
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores staggering hits.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores knockdown hits.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores guarding.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the first dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the second dodge.
function script.on_dodge_2() end

--- Runs the monster's death.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the default death handling.
function script.on_death() end

--- Holds the boss still while it is caught.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Waits for the boss to touch the ground after a throw and then resets its movement.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.get_height_above_ground() or height
		if height < vm.f32(0.1) then
			timer.wait_frames(3)
			monster.end_throw()
			monster.stop_moving()
			timer.wait_frames(30)
			return 1
		end
		vm.wait()
	end
end

return script
