--!strict
--- Holds an unused flying feather-throwing variant of the yellow Atramilia monster.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

local home_x: f32 = 0
local home_y: f32 = 0
local home_z: f32 = 0

--- Reads the current position and issues the stop commands that hold the monster there.
local function hold_position()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.keep_monster_loop_sound_3(position_x, position_y, position_z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	monster.call_command(70, position_x, position_y, position_z, 0.0, 0.0) -- retail: the handler rejects 5 arguments
	monster.call_command(72) -- retail: the handler rejects 0 arguments
end

--- Records the current position as the home position.
local function record_home_position()
	monster.keep_monster_loop_sound_3(home_x, home_y, home_z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	home_y = 0.0
end

--- Glides toward a target point with a computed acceleration until it arrives, overshoots or runs out of frames.
local function glide_to_position(target_x: f32, target_y: f32, target_z: f32, start_speed: f32, stop_distance: f32, distance_margin: f32, travel_ratio: f32, max_frames: s32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local scale: f32 = 0
	local distance: f32 = 0
	local acceleration: f32 = 0
	local frame: s32 = 0
	monster.keep_monster_loop_sound_3(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, x, y, z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	distance = monster.get_distance_between(target_x, target_y, target_z, x, y, z) or distance
	acceleration = calc.get_acceleration(distance, scale, vm.f32(vm.fdiv(vm.f32(vm.f32(distance + distance_margin) * travel_ratio), start_speed)), acceleration)
	scale = start_speed
	frame = 0
	while frame < max_frames do
		monster.keep_monster_loop_sound_3(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		scale = vm.f32(scale + acceleration)
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, scale)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(x, y, z, step_x, step_y, step_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.set_positional_sound(x, y, z)
		if scale < 0.0 then
			return
		end
		distance = monster.get_distance_between(target_x, target_y, target_z, x, y, z) or distance
		if distance < stop_distance then
			return
		end
		monster.copy_vector(x, y, z)
		vm.wait()
		frame = frame + 1
	end
end

--- Turns toward the target and glides to a hover point above the monster's place position.
local function fly_to_hover_point(speed: f32, turn_speed_degrees: any, height_offset: f32, distance_margin: f32, max_frames: s32)
	local place_x: f32 = 0
	local place_y: f32 = 0
	local place_z: f32 = 0
	local hover_height: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	movement.turn_toward_target_and_wait_variant(vm.f32(4.2))
	monster.keep_monster_loop_sound_3(current_x, current_y, current_z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	monster.set_place_position(place_x, place_y, place_z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	hover_height = vm.bits_float(monster.is_move_finished()) or hover_height
	hover_height = vm.f32(current_y - hover_height)
	glide_to_position(place_x, vm.f32(hover_height + height_offset), place_z, speed, speed, distance_margin, vm.f32(1.9), max_frames)
end

--- Waits until the current motion reaches the given progress within a tolerance.
local function wait_for_motion_progress(target_progress: f32, tolerance: f32)
	local motion_progress: f32 = 0
	local frame_count: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		vm.wait()
		motion_progress = vm.bits_float(monster.get_no_damage_hit_count()) or motion_progress
		if motion_progress < vm.f32(target_progress + tolerance) and motion_progress > vm.f32(target_progress - tolerance) then
			break
		else
			frame_count = vm.i32(frame_count + 1)
		end
	end
end

--- Turns toward the target for the given number of frames and then holds the facing.
local function turn_toward_target_for_frames(turn_speed_degrees: f32, frame_count: s32)
	local turn_speed: f32 = 0
	local _ = calc.degrees_to_radians(turn_speed_degrees)
	for frame = 0, frame_count - 1 do
		monster.call_command(75, turn_speed) -- retail: the handler rejects 1 arguments
		monster.call_command(69, turn_speed, turn_speed_degrees) -- retail: command 69 is not registered
		vm.wait()
	end
	movement.hold_current_facing_variant()
end

--- Turns toward the target every frame until the current motion finishes and then holds the facing.
local function turn_toward_target_until_finished(turn_speed_degrees: f32)
	local turn_speed: f32 = 0
	local motion_finished: s32 = 0
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	while true do
		monster.call_command(75, turn_speed) -- retail: the handler rejects 1 arguments
		monster.call_command(69, turn_speed, turn_speed_degrees) -- retail: command 69 is not registered
		vm.wait()
		motion_finished = monster.get_life_int() or motion_finished
		if motion_finished ~= 0 then
			movement.hold_current_facing_variant()
			break
		end
	end
end

--- Throws volleys of feathers from the wing joints in three directions while turning toward the target.
local function attack_feather_volley()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	monster.set_life("攻撃１in", -1, 2)
	monster.set_life("攻撃１", -1, 6)
	wait_for_motion_progress(vm.f32(0.262), -1.0)
	for volley = 0, 3 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.set_place_position(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		do
			local out1, out2, out3 = monster.subtract_vectors(x, y, z, pos_x, pos_y, pos_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.call_command(171, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		turn_toward_target_for_frames(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.set_place_position(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		do
			local out1, out2, out3 = monster.subtract_vectors(x, y, z, pos_x, pos_y, pos_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.call_command(171, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
		monster.call_command(
			174,
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(1.5707964)) * 20.0)
		) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		turn_toward_target_for_frames(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.set_place_position(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		do
			local out1, out2, out3 = monster.subtract_vectors(x, y, z, pos_x, pos_y, pos_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.call_command(171, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
		monster.call_command(
			174,
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(-1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(-1.5707964)) * 20.0)
		) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		turn_toward_target_for_frames(vm.f32(4.2), 1)
	end
	turn_toward_target_until_finished(vm.f32(4.2))
	monster.set_life("攻撃１out", -1, 2)
	state.wait_until_alive()
end

--- Fires rounds of feathers with random speed and spread from the four wing joints.
local function attack_feather_rain()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local initial_x: f32 = 0
	local initial_y: f32 = 0
	local initial_z: f32 = 0
	local feather_speed: f32 = 0
	local feather_spread: f32 = 0
	local feather_angle: f32 = 0
	local motion_index: s32 = 0
	monster.set_life("攻撃１in", -1, 2)
	state.wait_until_alive()
	monster.set_life("攻撃１", -1, 2)
	wait_for_motion_progress(vm.f32(0.262), -1.0)
	for round = 0, 5 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		motion_index = monster.get_random(2) or motion_index
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle * -1.0)
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, initial_x, initial_y, initial_z)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, feather_speed, feather_spread, feather_angle)
		monster.set_motion("", 1, motion_index) -- retail: argument 1 is -1, an address that names nothing the handler finds
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		motion_index = monster.get_random(2) or motion_index
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle * -1.0)
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, initial_x, initial_y, initial_z)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, feather_speed, feather_spread, feather_angle)
		monster.set_motion("", 1, motion_index) -- retail: argument 1 is -1, an address that names nothing the handler finds
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		motion_index = monster.get_random(2) or motion_index
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, initial_x, initial_y, initial_z)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, feather_speed, feather_spread, feather_angle)
		monster.set_motion("", 1, motion_index) -- retail: argument 1 is -1, an address that names nothing the handler finds
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		motion_index = monster.get_random(2) or motion_index
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, initial_x, initial_y, initial_z)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, feather_speed, feather_spread, feather_angle)
		monster.set_motion("", 1, motion_index) -- retail: argument 1 is -1, an address that names nothing the handler finds
		turn_toward_target_for_frames(vm.f32(4.2), 3)
	end
	turn_toward_target_until_finished(vm.f32(4.2))
	monster.set_life("攻撃１out", -1, 2)
	state.wait_until_alive()
end

--- Plays the energy-absorbing animation sequence.
local function attack_absorb_energy()
	monster.set_life("エネルギー吸収in", -1, 2)
	state.wait_until_alive()
	monster.set_life("エネルギー吸収", -1, 2)
	state.wait_until_alive()
	monster.set_life("エネルギー吸収out", 2)
	state.wait_until_alive()
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the feather effects and records the home position.
function script.init()
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	hold_position()
	monster.set_photo_opportunity(4, 1)
	monster.set_photo_opportunity(8, 1)
	monster.stop_palette_pulse(9999.9)
	monster.set_camera_mode(0)
	monster.call_command(106, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
	monster.call_command(106, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
	monster.call_command(106, "グリ羽根Ｈ") -- retail: the handler rejects 1 arguments
	record_home_position()
end

--- Flies to a hover point and cycles through the feather and energy-absorb attacks.
function script.loop()
	monster.set_model_lighting(0)
	monster.set_life("飛び", -1, 0)
	fly_to_hover_point(4.0, vm.f32(4.2), 60.0, 35.0, 90)
	while true do
		vm.wait()
		movement.turn_toward_target_and_wait_variant(vm.f32(4.2))
		attack_feather_volley()
		monster.set_life("飛び", -1, 0)
		timer.wait_frames(60)
		movement.turn_toward_target_and_wait_variant(vm.f32(4.2))
		attack_feather_rain()
		monster.set_life("飛び", -1, 0)
		timer.wait_frames(60)
		attack_absorb_energy()
		monster.set_life("飛び", -1, 0)
		timer.wait_frames(20)
	end
end

--- Plays the damage motion with knockback and waits for recovery.
function script.on_damage()
	state.stop_and_clear_action_variant()
	monster.set_life("ダメージ", -1, 6)
	monster.call_command(140, 4.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	state.wait_until_alive()
	timer.wait_frames(12)
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	state.do_nothing()
end

--- Blows the monster away, then stands it back up.
function script.on_knockdown()
	state.lock_and_face_target_variant()
	monster.set_life("吹っ飛び", -1, 6)
	monster.call_command(140, 3.0, 0.05, 20) -- retail: the handler rejects 3 arguments
	state.wait_until_alive()
	monster.set_model_lighting(1)
	timer.wait_frames(30)
	monster.set_model_lighting(0)
	monster.set_life("起き上がり", -1, 6)
	state.wait_until_alive()
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	state.unlock_variant()
end

--- Plays the guard animation sequence with knockback.
function script.on_guard()
	state.stop_and_reset_motion_variant()
	monster.set_life("歩き", -1, 0)
	movement.turn_toward_target_and_wait_variant(21.0)
	monster.get_attack_power_0()
	monster.set_life("ガードin", -1, 6)
	state.wait_until_alive()
	monster.set_life("ガード", -1, 0)
	monster.call_command(140, 3.0, 0.0, 2) -- retail: the handler rejects 3 arguments
	timer.wait_frames(30)
	monster.set_life("ガードout", -1, 6)
	state.wait_until_alive()
	monster.set_life("立ち", 0)
	state.do_nothing()
end

--- Turns to face the dodge direction and returns to the idle motion.
function script.on_dodge_1()
	local turn_angle: f32 = 0
	state.lock_and_reset_motion_variant()
	monster.call_command(75, turn_angle) -- retail: the handler rejects 1 arguments
	if turn_angle > vm.f32(3.1415927) then
		turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
	end
	if turn_angle <= vm.f32(-3.1415927) then
		turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, turn_angle, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	state.unlock_variant()
end

--- Turns to face the dodge direction and returns to the idle motion.
function script.on_dodge_2()
	local turn_angle: f32 = 0
	state.lock_and_reset_motion_variant()
	monster.call_command(75, turn_angle) -- retail: the handler rejects 1 arguments
	if turn_angle > vm.f32(3.1415927) then
		turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
	end
	if turn_angle <= vm.f32(-3.1415927) then
		turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, turn_angle, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	state.unlock_variant()
end

--- Plays the death motion and then idles forever.
function script.on_death()
	death.begin_variant()
	monster.set_life("死に", -1, 2)
	state.wait_until_alive()
	monster.call_command(142) -- retail: command 142 is not registered
	while true do
		vm.wait()
	end
	death.play_effects_variant()
end

--- Plays the struggling motion while the monster is held.
function script.on_caught()
	monster.set_life("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers the monster after a throw and stands it back up.
function script.on_land()
	combat.finish_throw_variant()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	monster.call_command(143) -- retail: command 143 is not registered
	timer.wait_frames(10)
	monster.get_attack_power_0()
	monster.set_life("起き上がり", -1, 6)
	state.wait_until_alive()
	state.do_nothing_hook()
	return 1
end

--- Plays the blow-away and get-up motions, then waits out the stun.
function script.on_stun()
	state.clear_attribute_and_lock_variant()
	monster.set_life("吹っ飛び", -1, 6)
	state.wait_until_alive()
	monster.set_life("起き上がり", -1, 6)
	state.wait_until_alive()
	reaction.stun_until_recovered_variant()
end

return script
