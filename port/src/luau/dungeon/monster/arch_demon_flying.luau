--!strict
--- Controls the flying Arch Demon boss, which circles the arena, alternates between vulnerable and invulnerable colour phases, fires beams and summons its ground form.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Marks the stored beam effect slots as empty.
local function clear_beam_effect_slots()
	for slot_index = 0, 3 do
		monster.set_variable(slot_index + 96, -9999)
	end
end

--- Limits how far away the monster stays active unless it is a boss.
local function set_clip_distance_for_boss()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Ends any beam effects that are still running and clears their stored slots.
local function finish_beam_effects()
	local effect_slot: s32 = 0
	effect_slot = monster.get_variable(96) or effect_slot
	if effect_slot ~= -9999 then
		monster.finish_effect(effect_slot)
		monster.set_variable(96, -9999)
	end
	effect_slot = monster.get_variable(97) or effect_slot
	if effect_slot ~= -9999 then
		monster.set_effect_value(effect_slot, 1, 2)
		monster.finish_effect(effect_slot)
		monster.set_variable(97, -9999)
	end
end

--- Counts the monsters in the arena, doubling the count while the boss is in its vulnerable phase.
local function count_monsters_for_phase()
	local phase: s32 = 0
	local monster_count: s32 = 0
	phase = monster.get_variable(3) or phase
	if phase == 1 then
		monster_count = monster.get_monster_count() or monster_count
		if monster_count > 2 then
			monster_count = vm.i32(monster_count * 2)
		end
	else
		monster_count = monster.get_monster_count() or monster_count
	end
end

--- Stores the last attack type and the damage just taken.
local function record_last_attack(current_life: s32, previous_life: s32)
	local attack_type: s32 = 0
	attack_type = monster.get_last_attack_type() or attack_type
	monster.set_variable(5, attack_type)
	monster.set_variable(6, vm.i32(previous_life - current_life))
end

--- Compares the monster life with the stored value and reports whether it died, was damaged or is unchanged.
local function detect_life_change()
	local life: s32 = 0
	local previous_life: s32 = 0
	previous_life = monster.get_variable(4) or previous_life
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(4, life)
		return 1
	end
	if vm.i32(life - previous_life) < 0 then
		monster.set_variable(4, life)
		record_last_attack(life, previous_life)
		return 2
	end
	monster.set_variable(4, life)
	return 0
end

--- Increments the monster state flag.
local function advance_state_flag()
	local flag: s32 = 0
	flag = state.get_state_flag(flag)
	state.set_state_flag(vm.i32(flag + 1))
end

--- Creates the ground-form Arch Demon beneath the boss when the flying form is invulnerable and few monsters exist.
local function spawn_ground_demon()
	local phase: s32 = 0
	local monster_count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	phase = monster.get_variable(3) or phase
	if phase == 2 and timer.get_elapsed_time(1) > 60 then
		monster_count = monster.get_monster_count() or monster_count
		if monster_count < 13 then
			do
				local out1, out2, out3 = monster.get_position_3()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			do
				local _, out2, _ = monster.get_rotation()
				rotation_y = out2 or rotation_y
			end
			monster.create_monster(630, position_x, position_y - 10.0, position_z, rotation_y)
			timer.start(2)
			movement.stop_turning()
			advance_state_flag()
		end
		timer.start(1)
	end
end

--- Swaps the boss between its vulnerable and invulnerable colour phases.
local function switch_vulnerability_phase()
	local phase: s32 = 0
	phase = monster.get_variable(3) or phase
	monster.get_monster_count()
	monster.set_variable(13, 1)
	if phase == 2 then
		print("kita-------------------\n")
		monster.set_invulnerable_time(0)
		monster.set_variable(3, 1)
	else
		monster.set_invulnerable_time(9999)
		monster.set_variable(3, 2)
	end
end

--- Switches the colour phase when the state flag or phase timer reaches its threshold.
local function update_phase_change()
	local phase: s32 = 0
	local state_flag: s32 = 0
	state_flag = state.get_state_flag(state_flag)
	phase = monster.get_variable(3) or phase
	if phase == 2 then
		timer.start(0)
	end
	if phase == 2 and state_flag == 6 then
		print("change color blue-----------------\n")
		switch_vulnerability_phase()
		state.set_state_flag(0)
		timer.start(0)
	end
	if phase == 1 and timer.get_elapsed_time(0) > 300 then
		print("change color red-----------------\n")
		switch_vulnerability_phase()
		state.set_state_flag(0)
	end
end

--- Tints the model for a short flash after each phase change and applies the matching texture at the end.
local function flash_model_colour()
	local flash_frame: s32 = 0
	local phase_changed: s32 = 0
	local phase: s32 = 0
	phase_changed = monster.get_variable(13) or phase_changed
	if phase_changed ~= 0 then
		monster.set_variable(14, 0)
		monster.set_variable(13, 0)
	else
		monster.set_model_lighting(1)
	end
	flash_frame = monster.get_variable(14) or flash_frame
	if flash_frame < 15 then
		monster.set_model_lighting(0)
		phase = monster.get_variable(3) or phase
		if phase == 1 then
			if vm.imod(flash_frame, 2) == 0 then
				monster.set_model_color(128.0, 128.0, 148.0, 128.0)
			end
			if vm.imod(flash_frame, 4) == 0 then
				monster.set_model_color(160.0, 160.0, 180.0, 160.0)
			end
			if vm.imod(flash_frame, 6) == 0 then
				monster.set_model_color(140.0, 140.0, 160.0, 140.0)
			end
		else
			if vm.imod(flash_frame, 2) == 0 then
				monster.set_model_color(148.0, 128.0, 128.0, 128.0)
			end
			if vm.imod(flash_frame, 4) == 0 then
				monster.set_model_color(180.0, 160.0, 160.0, 160.0)
			end
			if vm.imod(flash_frame, 6) == 0 then
				monster.set_model_color(160.0, 140.0, 140.0, 140.0)
			end
		end
		if flash_frame == 14 then
			if phase == 1 then
				monster.set_invulnerable_time(0)
				monster.apply_reserved_image(1)
			else
				monster.set_invulnerable_time(9999)
				monster.apply_reserved_image(0)
			end
		end
		monster.set_variable(14, flash_frame + 1)
	end
end

--- Returns the angle stored for the boss orbit around the arena centre.
local function get_orbit_angle(orbit_angle: f32)
	local stored_angle: f32 = 0
	stored_angle = 0.0
	stored_angle = monster.get_variable_float(15) or stored_angle
	orbit_angle = stored_angle
	return orbit_angle
end

--- Returns the heading from the boss to a point, wrapped to a half turn either side.
local function compute_heading_to_point(point_x: f32, point_y: f32, point_z: any, heading: f32)
	local raw_heading: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local wrapped_heading: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	position_x = vm.f32(point_x - position_x)
	position_y = vm.f32(point_y - position_y)
	do
		local _, _, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
		raw_heading = out3 or raw_heading
	end
	wrapped_heading = raw_heading
	if wrapped_heading > vm.f32(3.1415927) then
		wrapped_heading = vm.f32(wrapped_heading - vm.f32(6.2831855))
	end
	if wrapped_heading <= vm.f32(-3.1415927) then
		wrapped_heading = vm.f32(wrapped_heading + vm.f32(6.2831855))
	end
	heading = wrapped_heading
	return heading
end

--- Moves the boss along its circular orbit around the arena centre with a gentle vertical bob.
local function orbit_around_center()
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local orbit_x: f32 = 0
	local orbit_y: f32 = 0
	local orbit_z: f32 = 0
	local orbit_angle: f32 = 0
	local facing_angle: f32 = 0
	local heading_to_orbit_point: f32 = 0
	local bob_phase: f32 = 0
	local hover_height: f32 = 0
	bob_phase = 0.0
	bob_phase = monster.get_variable_float(19) or bob_phase
	bob_phase = vm.f32(bob_phase + vm.f32(0.08726647))
	hover_height = vm.f32(200.0 + vm.f32(vm.sin(bob_phase) * 15.0))
	monster.set_variable_float(19, bob_phase)
	orbit_angle = get_orbit_angle(orbit_angle)
	center_x = 0.0
	center_y = 0.0
	center_z = 0.0
	orbit_x = vm.f32(center_x + vm.f32(vm.sin(orbit_angle) * 400.0))
	orbit_y = vm.f32(center_y + hover_height)
	orbit_z = vm.f32(center_z + vm.f32(vm.cos(orbit_angle) * 400.0))
	heading_to_orbit_point = compute_heading_to_point(orbit_x, orbit_y, orbit_z, heading_to_orbit_point)
	facing_angle = monster.get_angle_to_position(orbit_x, orbit_y, orbit_z) or facing_angle
	monster.set_position(orbit_x, orbit_y, orbit_z)
	monster.set_rotation(0.0, facing_angle, 0.0)
	state.set_float_state(vm.f32(orbit_angle + vm.f32(0.017453292)))
end

--- Waits until the boss faces a target angle or the frame limit passes, and returns the frames waited.
local function wait_until_facing(target_angle: f32, turn_speed: f32, max_frames: f32)
	local current_angle: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local angle_tolerance: f32 = 0
	target_angle = vm.f32(target_angle * vm.f32(0.017453292))
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = vm.f32(turn_speed * vm.f32(0.017453292))
	frame_limit = max_frames
	if turn_speed < 3.0 then
		angle_tolerance = vm.f32(0.05235988)
	else
		angle_tolerance = turn_speed
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle - angle_tolerance) and current_angle < vm.f32(target_angle + angle_tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle, current_angle, turn_speed) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			vm.wait()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns the boss toward an angle at a given speed and waits until it faces it.
local function turn_to_angle_and_wait(target_angle: f32, turn_speed: f32)
	target_angle = vm.f32(target_angle * vm.f32(0.017453292))
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = vm.f32(turn_speed * vm.f32(0.017453292))
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_angle, turn_speed)
	local _ = wait_until_facing(
		vm.f32(target_angle * vm.f32(57.295776)),
		vm.f32(turn_speed * vm.f32(57.295776)),
		vm.f32(vm.fdiv(360.0, vm.f32(turn_speed * vm.f32(57.295776))))
	)
	movement.stop_turning()
end

--- Flies the boss in a straight line to a point at a fixed speed until it is close enough or the frame limit passes.
local function fly_straight_to_point(destination_x: f32, destination_y: f32, destination_z: f32, speed: f32, arrival_distance: f32, max_frames: s32)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local facing_angle: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local distance_to_destination: f32 = 0
	local frame_index: s32 = 0
	print("kita---------------------------\n")
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(velocity_x, velocity_y, velocity_z, current_x, current_y, current_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(velocity_x, velocity_y, velocity_z, speed)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	print("x=", vm.float(destination_x), "------------------\n")
	print("y=", vm.float(destination_y), "------------------\n")
	print("z=", vm.float(destination_z), "------------------\n")
	print("pos[0]=", vm.float(current_x), "------------------\n")
	print("pos[1]=", vm.float(current_y), "------------------\n")
	print("pos[2]=", vm.float(current_z), "------------------\n")
	print("speed=", vm.float(speed), "---------------------\n")
	print("velo[0]=", vm.float(velocity_x), "------------------\n")
	print("velo[1]=", vm.float(velocity_y), "------------------\n")
	print("velo[2]=", vm.float(velocity_z), "------------------\n")
	frame_index = 0
	while frame_index < max_frames do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, velocity_x, velocity_y, velocity_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(current_x, current_y, current_z)
			facing_angle = out2 or facing_angle
		end
		distance_to_destination = monster.get_distance_between(current_x, current_y, current_z, destination_x, destination_y, destination_z) or distance_to_destination
		if distance_to_destination < arrival_distance then
			break
		else
			monster.set_position(current_x, current_y, current_z)
			monster.set_rotation(0.0, facing_angle, 0.0)
			vm.wait()
			frame_index = frame_index + 1
		end
	end
end

--- Stores an effect slot in the numbered beam slot variable.
local function store_beam_effect_slot(slot_index: s32, effect_slot: s32)
	monster.set_variable(vm.i32(slot_index + 96), effect_slot)
end

--- Aims at the target and fires a beam that sweeps across the ground toward it.
local function fire_beam_attack()
	local character_type: s32 = 0
	local slot: s32 = 0
	local attack_power: s32 = 0
	local beam_x: f32 = 0
	local beam_y: f32 = 0
	local beam_z: f32 = 0
	local model_scale: f32 = 0
	local facing_angle: f32 = 0
	local random_angle: f32 = 0
	local beam_travel_distance: f32 = 0
	local beam_speed: f32 = 0
	local beam_start_x: f32 = 0
	local beam_start_y: f32 = 0
	local beam_start_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local beam_step_x: f32 = 0
	local beam_step_y: f32 = 0
	local beam_step_z: f32 = 0
	local center_x: f32 = 0
	local center_z: f32 = 0
	finish_beam_effects()
	monster.set_motion("飛行ループ", -1, 0)
	facing_angle = monster.get_target_angle() or facing_angle
	turn_to_angle_and_wait(vm.f32(facing_angle * vm.f32(57.295776)), vm.f32(1.9999999))
	attack_power = monster.get_attack_power_1() or attack_power
	attack_power = vm.ftoi(vm.f32(attack_power * vm.f32(1.8)))
	character_type = monster.get_character_number() or character_type
	do
		local out1, _, _ = monster.get_scale()
		model_scale = out1 or model_scale
	end
	center_x = 0.0
	center_z = 0.0
	do
		local out1, out2, out3 = monster.get_target_position()
		beam_x = out1 or beam_x
		beam_y = out2 or beam_y
		beam_z = out3 or beam_z
	end
	random_angle = monster.get_random_whole_number(6.2831855) or random_angle
	beam_start_x = vm.f32(center_x + vm.f32(vm.sin(random_angle) * 170.0))
	beam_start_y = 5.0
	beam_start_z = vm.f32(center_z + vm.f32(vm.cos(random_angle) * 170.0))
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		beam_step_x = out1 or beam_step_x
		beam_step_y = out2 or beam_step_y
		beam_step_z = out3 or beam_step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(beam_step_x, beam_step_y, beam_step_z, beam_start_x, beam_start_y, beam_start_z)
		beam_step_x = out1 or beam_step_x
		beam_step_y = out2 or beam_step_y
		beam_step_z = out3 or beam_step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(beam_step_x, beam_step_y, beam_step_z)
		beam_step_x = out1 or beam_step_x
		beam_step_y = out2 or beam_step_y
		beam_step_z = out3 or beam_step_z
	end
	beam_travel_distance = 396.0
	beam_speed = vm.f32(beam_travel_distance / 60.0)
	do
		local out1, out2, out3 = monster.scale_vector(beam_step_x, beam_step_y, beam_step_z, beam_speed)
		beam_step_x = out1 or beam_step_x
		beam_step_y = out2 or beam_step_y
		beam_step_z = out3 or beam_step_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(beam_start_x, beam_start_y, beam_start_z)
		beam_x = out1 or beam_x
		beam_y = out2 or beam_y
		beam_z = out3 or beam_z
	end
	facing_angle = monster.get_angle_to_position(beam_start_x, beam_start_y, beam_start_z) or facing_angle
	character_type = monster.get_character_number() or character_type
	monster.play_monster_sound(character_type, 3)
	slot = monster.create_effect_2("魔人ビームＦ２") or slot
	store_beam_effect_slot(0, slot)
	monster.set_effect_owner(slot, character_type)
	monster.set_effect_value_float(slot, 0, model_scale)
	monster.set_effect_first_vector(slot, beam_start_x, beam_start_y, beam_start_z)
	slot = monster.create_effect_2("魔人ビームＬ２") or slot
	store_beam_effect_slot(1, slot)
	monster.set_effect_owner(slot, character_type)
	monster.set_effect_value(slot, 0, attack_power)
	monster.set_effect_value_float(slot, 2, model_scale)
	monster.set_effect_value(slot, 1, 1)
	for i = 0, 89 do
		do
			local out1, out2, out3 = monster.add_vectors(beam_x, beam_y, beam_z, beam_step_x, beam_step_y, beam_step_z)
			beam_x = out1 or beam_x
			beam_y = out2 or beam_y
			beam_z = out3 or beam_z
		end
		facing_angle = monster.get_angle_to_position(beam_x, beam_y, beam_z) or facing_angle
		monster.set_effect_first_vector(slot, beam_x, beam_y, beam_z)
		monster.set_rotation(0.0, facing_angle, 0.0)
		vm.wait()
	end
	monster.set_effect_value(slot, 1, 2)
	timer.wait_frames(90)
	timer.wait_frames(60)
	monster.set_motion("飛行ループ", -1, 0)
end

--- Turns toward the arena centre, flies out over it and fires the beam attack.
local function fly_to_center_and_fire_beam()
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local heading: f32 = 0
	center_x = 0.0
	center_y = 0.0
	center_z = 0.0
	monster.set_motion("飛行ループ", -1, 0)
	heading = monster.get_angle_to_position(center_x, center_y, center_z) or heading
	turn_to_angle_and_wait(vm.f32(heading * vm.f32(57.295776)), vm.f32(1.9999999))
	fly_straight_to_point(center_x, 300.0, center_z, 12.0, 50.0, 300)
	fire_beam_attack()
	monster.set_motion("泳ぐ", -1, 0)
end

--- Flies the boss in a straight line toward a point at a fixed speed, never dropping below a minimum height, until it is close enough or the frame limit passes.
local function fly_toward_point_above_floor(destination_x: f32, destination_y: f32, destination_z: f32, speed: f32, arrival_distance: f32, unused_arc_angle: f32, unused_arc_factor: any, max_frames: s32)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local destination_direction_x: f32 = 0
	local destination_direction_y: f32 = 0
	local destination_direction_z: f32 = 0
	local unused_arc_direction_x: f32 = 0
	local unused_arc_direction_y: f32 = 0
	local unused_arc_direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local facing_angle: f32 = 0
	local distance_to_destination: f32 = 0
	local frame_index: s32 = 0
	local step_direction_x: f32 = 0
	local step_direction_y: f32 = 0
	local step_direction_z: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		step_direction_x = out1 or step_direction_x
		step_direction_y = out2 or step_direction_y
		step_direction_z = out3 or step_direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_direction_x, step_direction_y, step_direction_z, current_x, current_y, current_z)
		step_direction_x = out1 or step_direction_x
		step_direction_y = out2 or step_direction_y
		step_direction_z = out3 or step_direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_direction_x, step_direction_y, step_direction_z)
		step_direction_x = out1 or step_direction_x
		step_direction_y = out2 or step_direction_y
		step_direction_z = out3 or step_direction_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		destination_direction_x = out1 or destination_direction_x
		destination_direction_y = out2 or destination_direction_y
		destination_direction_z = out3 or destination_direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(destination_direction_x, destination_direction_y, destination_direction_z, current_x, current_y, current_z)
		destination_direction_x = out1 or destination_direction_x
		destination_direction_y = out2 or destination_direction_y
		destination_direction_z = out3 or destination_direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(destination_direction_x, destination_direction_y, destination_direction_z)
		destination_direction_x = out1 or destination_direction_x
		destination_direction_y = out2 or destination_direction_y
		destination_direction_z = out3 or destination_direction_z
	end
	unused_arc_direction_x = vm.f32(vm.f32(destination_direction_x * vm.cos(unused_arc_angle)) + vm.f32(destination_direction_z * vm.sin(unused_arc_angle)))
	unused_arc_direction_y = destination_direction_y
	unused_arc_direction_z = vm.f32(vm.f32(destination_direction_x * -vm.sin(unused_arc_angle)) + vm.f32(destination_direction_z * vm.cos(unused_arc_angle)))
	do
		local out1, out2, out3 = monster.normalize_vector(unused_arc_direction_x, unused_arc_direction_y, unused_arc_direction_z)
		unused_arc_direction_x = out1 or unused_arc_direction_x
		unused_arc_direction_y = out2 or unused_arc_direction_y
		unused_arc_direction_z = out3 or unused_arc_direction_z
	end
	frame_index = 0
	while frame_index < max_frames do
		do
			local out1, out2, out3 = monster.copy_vector(step_direction_x, step_direction_y, step_direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(current_x, current_y, current_z)
			facing_angle = out2 or facing_angle
		end
		if current_y < 60.0 then
			current_y = 60.0
		end
		distance_to_destination = monster.get_distance_between(current_x, current_y, current_z, destination_x, destination_y, destination_z) or distance_to_destination
		if distance_to_destination < arrival_distance then
			break
		else
			monster.set_position(current_x, current_y, current_z)
			monster.set_rotation(0.0, facing_angle, 0.0)
			vm.wait()
			frame_index = frame_index + 1
		end
	end
end

--- Flies the boss to the opposite side of the arena from the target.
local function fly_across_arena()
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local angle: f32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	center_x = 0.0
	center_y = 0.0
	center_z = 0.0
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, center_x, center_y, center_z)
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
	angle = monster.get_arc_tangent(direction_x, direction_z) or angle
	angle = vm.f32(angle + vm.f32(3.1415927))
	if angle > vm.f32(3.1415927) then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	if angle <= vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	angle = get_orbit_angle(angle)
	angle = vm.f32(angle + vm.f32(3.1415927))
	destination_x = vm.f32(destination_x + vm.f32(vm.f32(vm.sin(angle) * 220.0) * 2.0))
	destination_y = 150.0
	destination_z = vm.f32(destination_z + vm.f32(vm.f32(vm.cos(angle) * 220.0) * 2.0))
	monster.set_motion("飛行ループ", -1, 0)
	angle = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle
	turn_to_angle_and_wait(vm.f32(angle * vm.f32(57.295776)), vm.f32(1.9999999))
	fly_toward_point_above_floor(destination_x, destination_y, destination_z, 12.0, 100.0, vm.f32(3.1415927), vm.f32(0.2), 500)
end

--- Moves the boss to a point in evenly spaced steps over a number of frames.
local function glide_to_point(destination_x: f32, destination_y: f32, destination_z: f32, frame_count: s32)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local facing_angle: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local step_length: f32 = 0
	local distance: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, current_x, current_y, current_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	distance = monster.get_distance_between(destination_x, destination_y, destination_z, current_x, current_y, current_z) or distance
	step_length = vm.f32(vm.fdiv(distance, frame_count))
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, step_length)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	for frame_index = 0, frame_count - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local _, out2, _ = monster.get_rotation_toward_6(current_x, current_y, current_z)
			facing_angle = out2 or facing_angle
		end
		monster.set_position(current_x, current_y, current_z)
		monster.set_rotation(0.0, facing_angle, 0.0)
		vm.wait()
	end
end

--- Picks a random point on the orbit, glides to it and records the new orbit angle.
local function move_to_random_orbit_point()
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local orbit_angle: f32 = 0
	local heading: f32 = 0
	local bob_phase: f32 = 0
	local hover_height: f32 = 0
	bob_phase = 0.0
	bob_phase = monster.get_variable_float(19) or bob_phase
	bob_phase = vm.f32(bob_phase + vm.f32(0.08726647))
	hover_height = vm.f32(200.0 + vm.f32(vm.sin(bob_phase) * 30.0))
	monster.set_variable_float(19, bob_phase)
	orbit_angle = get_orbit_angle(orbit_angle)
	orbit_angle = monster.get_random_whole_number(0.63661975) or orbit_angle
	center_x = 0.0
	center_y = 0.0
	center_z = 0.0
	destination_x = vm.f32(center_x + vm.f32(vm.sin(orbit_angle) * 400.0))
	destination_y = vm.f32(center_y + hover_height)
	destination_z = vm.f32(center_z + vm.f32(vm.cos(orbit_angle) * 400.0))
	heading = monster.get_angle_to_position(destination_x, destination_y, destination_z) or heading
	turn_to_angle_and_wait(vm.f32(heading * vm.f32(57.295776)), vm.f32(1.9999999))
	glide_to_point(destination_x, destination_y, destination_z, 80)
	state.set_float_state(orbit_angle)
	monster.set_motion("泳ぐ", -1, 0)
end

--- Tracks damage and phases, then runs the periodic attack sequence when its timer expires.
local function update_boss_state()
	local life_status: s32 = 0
	local flash_frame: s32 = 0
	local no_damage_hit_count: s32 = 0
	count_monsters_for_phase()
	life_status = detect_life_change()
	if life_status == 1 then
		monster.set_variable(64, 1)
	end
	no_damage_hit_count = monster.get_no_damage_hit_count() or no_damage_hit_count
	flash_frame = monster.get_variable(14) or flash_frame
	monster.get_variable(12)
	if flash_frame > 14 then
		spawn_ground_demon()
	end
	update_phase_change()
	monster.set_variable(12, no_damage_hit_count)
	flash_model_colour()
	if timer.get_elapsed_time(2) < 150 then
		monster.set_monster_attributes(16, 1)
	else
		monster.set_monster_attributes(16, 0)
	end
	orbit_around_center()
	if timer.get_elapsed_time(2) > 300 and flash_frame > 14 then
		fly_to_center_and_fire_beam()
		fly_across_arena()
		move_to_random_orbit_point()
		timer.start(2)
	end
end

--- Updates the boss state and waits one frame.
local function update_and_wait_frame()
	update_boss_state()
	vm.wait()
end

--- Flies the boss toward a point at a fixed height above the ground, stopping when it arrives or is blocked.
local function fly_to_point_above_ground(destination_x: f32, destination_y: f32, destination_z: f32, speed: f32, arrival_margin: f32, hover_height: f32, max_steps: any)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local heading: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local ground_height: f32 = 0
	local distance_to_destination: f32 = 0
	local height_above_ground: f32 = 0
	local step_index: s32 = 0
	local is_blocked: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	ground_height = sense.get_ground_height(ground_height)
	destination_y = vm.f32(ground_height + hover_height)
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, current_x, current_y, current_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	monster.copy_vector(destination_x, destination_y, destination_z)
	heading = monster.get_angle_to_position(current_x + step_x, current_y + step_y, current_z + step_z) or heading
	step_index = 0
	while step_index < max_steps do
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		height_above_ground = monster.get_height_above_ground_at(current_x, current_y, current_z) or height_above_ground
		if height_above_ground >= 200.0 or height_above_ground <= 0.0 then
			current_y = vm.f32(current_y - step_y)
			step_y = 0.0
		end
		distance_to_destination = monster.get_distance_between(current_x, current_y, current_z, destination_x, destination_y, destination_z) or distance_to_destination
		if distance_to_destination < vm.f32(speed + arrival_margin) then
			return
		end
		is_blocked = sense.check_flight_destination(current_x, current_y, current_z, speed, heading)
		if is_blocked ~= 0 then
			return
		end
		monster.set_position(current_x, current_y, current_z)
		monster.copy_vector(current_x, current_y, current_z)
		update_and_wait_frame()
		step_index = vm.i32(step_index + 1)
	end
end

--- Updates the monster state for a number of frames.
local function wait_frames_updating(frame_count: any)
	local frame_index: s32 = 0
	frame_index = 0
	while frame_index < frame_count do
		update_and_wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Updates the monster state every frame without ever returning.
local function idle_forever()
	while true do
		update_and_wait_frame()
	end
end

--- Clears the throw state and waits briefly before the monster resumes.
local function recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	wait_frames_updating(10)
	monster.reset_motion()
end

--- Updates the monster state each frame until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		update_and_wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

local script = {}

--- Does nothing.
function script.setup() end

--- Places the boss, loads its effects and images and sets its initial state.
function script.init()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local life: s32 = 0
	local free_texture_block: s32 = 0
	local first_script_loaded: s32 = 0
	local second_script_loaded: s32 = 0
	local third_script_loaded: s32 = 0
	local no_damage_hit_count: s32 = 0
	monster.set_variable(2, 0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_position(position_x, position_y + 10.0, position_z)
	monster.reset_dungeon_timer()
	monster.set_monster_attributes(512, 1)
	monster.set_visible_monster_limit(6)
	timer.start(0)
	timer.start(1)
	timer.start(2)
	timer.start(2)
	life = monster.get_monster_life(-1) or life
	monster.set_variable(4, life)
	monster.set_variable(64, 0)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		first_script_loaded = monster.load_effect_script("ねばねばＦ", free_texture_block) or first_script_loaded
		second_script_loaded = monster.load_effect_script("ねばねばＬ", free_texture_block) or second_script_loaded
		third_script_loaded = monster.load_effect_script("ねばねばＨ", free_texture_block) or third_script_loaded
		if (if (if first_script_loaded ~= 0 then 1 else second_script_loaded) ~= 0 then 1 else third_script_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		first_script_loaded = monster.load_effect_script("魔人ビームＦ２", free_texture_block) or first_script_loaded
		second_script_loaded = monster.load_effect_script("魔人ビームＨ２", free_texture_block) or second_script_loaded
		third_script_loaded = monster.load_effect_script("魔人ビームＬ２", free_texture_block) or third_script_loaded
		if (if (if first_script_loaded ~= 0 then 1 else second_script_loaded) ~= 0 then 1 else third_script_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	state.set_state_flag(0)
	monster.set_photo_opportunity(249)
	monster.set_monster_attributes(128, 1)
	no_damage_hit_count = monster.get_no_damage_hit_count() or no_damage_hit_count
	monster.set_variable(12, no_damage_hit_count)
	monster.set_variable(13, 0)
	monster.set_variable(14, 999999)
	monster.set_variable_float(15, 0.0)
	clear_beam_effect_slots()
	monster.set_variable_float(19, 0.0)
	state.set_flying_defaults()
	state.set_max_flight_height(250.0)
	state.set_flight_clearance(42.0)
	set_clip_distance_for_boss()
	monster.set_clip_distance(999999.9)
	monster.load_reserved_image(0, "textures/dungeon/monster/b13a01.json")
	monster.load_reserved_image(1, "textures/dungeon/monster/b13a02.json")
	monster.set_camera_mode(0)
end

--- Rises to hover height on the first run, then keeps the boss swimming through the air while it updates its state.
function script.loop()
	local value: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(16, 1)
	finish_beam_effects()
	value = monster.get_variable(2) or value
	if value == 0 then
		monster.set_invulnerable_time(9999)
		monster.apply_reserved_image(0)
		monster.set_variable(3, 2)
		monster.set_scale(8.0, 8.0, 8.0)
		monster.set_motion("飛行ループ入り", -1, 6)
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		fly_to_point_above_ground(position_x, position_y, position_z, 2.0, 21.0, 200.0, 33)
		monster.set_motion("泳ぐ", -1, 0)
		monster.set_variable(2, 1)
	end
	while true do
		monster.set_motion("泳ぐ", -1, 0)
		update_and_wait_frame()
		wait_frames_updating(60)
	end
end

--- Plays the airborne damage motion and returns to swimming.
function script.on_damage()
	finish_beam_effects()
	monster.stop_moving()
	monster.reset_motion()
	monster.set_action_status(0)
	monster.set_motion("空中ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("泳ぐ", -1, 0)
	state.do_nothing()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default knockdown reaction.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default guard reaction.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default dodge reaction.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default dodge reaction.
function script.on_dodge_2() end

--- Plays the death motion and requests the defeat event.
function script.on_death()
	monster.set_variable(64, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("ダメージ", -1, 0)
	finish_beam_effects()
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(64, 1)
	monster.reset_camera_limits()
	monster.set_motion("死亡", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("死亡とめ", -1, 0)
	monster.request_event_script(510)
	timer.wait_frames(30)
	while true do
		vm.wait()
	end
end

--- Struggles in the air while caught.
function script.on_caught()
	motion.reset()
	monster.set_motion("じたばた", -1, 4)
	while true do
		update_and_wait_frame()
	end
	idle_forever()
end

--- Recovers after being thrown and gets back up.
function script.on_land()
	recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	wait_frames_updating(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	state.do_nothing_hook()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default stun reaction.
function script.on_stun() end

return script
