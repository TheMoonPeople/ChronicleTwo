--!strict
--- Controls the butterfly boss that circles the arena, attacks with scale powder and a beam, and splits into and merges from a flock.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local sense = require("@lib/monster/sense")
local timer = require("@lib/monster/timer")

local is_camera_orbit_active: s32 = 0

--- Requests the first-hit event script once the boss has been struck without damage.
local function trigger_first_hit_event()
	local value: s32 = 0
	local no_damage_cnt: s32 = 0
	value = monster.get_variable(18) or value
	if value == 0 then
		no_damage_cnt = monster.get_no_damage_hit_count() or no_damage_cnt
		if 1 <= no_damage_cnt then
			monster.set_variable(18, 1)
			monster.request_event_script(507)
		end
	end
end

--- Computes the point at an angle and radius around a centre and stores it in the output arguments.
local function get_point_on_circle(center_x: f32, center_z: f32, angle: f32, radius: f32, out_x: f32, out_z: f32)
	local offset_x: f32 = 0
	local offset_z: f32 = 0
	offset_x = vm.f32(vm.sin(angle) * radius)
	offset_z = vm.f32(vm.cos(angle) * radius)
	offset_x = vm.f32(offset_x + center_x)
	offset_z = vm.f32(offset_z + center_z)
	out_x = offset_x
	out_z = offset_z
	return out_x, out_z
end

--- Places the camera on a circle around the arena centre, on the side facing the player, looking at the centre.
local function point_camera_at_arena_center()
	local target_x: f32 = 0
	local target_z: f32 = 0
	local camera_angle: f32 = 0
	local x: f32 = 0
	local z: f32 = 0
	if is_camera_orbit_active == 0 then
		return
	end
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	camera_angle = monster.get_arc_tangent(target_x - vm.f32(268.8), target_z - vm.f32(-322.4)) or camera_angle
	if camera_angle > vm.f32(3.1415927) then
		camera_angle = vm.f32(camera_angle - vm.f32(6.2831855))
	end
	if camera_angle <= vm.f32(-3.1415927) then
		camera_angle = vm.f32(camera_angle + vm.f32(6.2831855))
	end
	x, z = get_point_on_circle(vm.f32(268.8), vm.f32(-322.4), camera_angle, 800.0, x, z)
	monster.set_camera_position(x, 850.0, z)
	monster.set_camera_look_at(268.8, 1050.0, -322.4)
end

--- Walks the boss toward a height and facing, returning 5 when it is interrupted and 0 once both are reached.
local function settle_height_and_yaw(target_height: f32, target_yaw: f32, is_interruptible: s32)
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local yaw: f32 = 0
	local rotation_z: f32 = 0
	local height_difference: f32 = 0
	local yaw_difference: f32 = 0
	monster.set_motion("歩き")
	while true do
		trigger_first_hit_event()
		if is_interruptible ~= 0 then
			value = monster.get_variable(8) or value
			if value == 16 then
				return 5
			end
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_rotation()
			rotation_x = out1 or rotation_x
			yaw = out2 or yaw
			rotation_z = out3 or rotation_z
		end
		if pos_y == target_height and yaw == target_yaw then
			return 0
		end
		height_difference = vm.f32(target_height - pos_y)
		if height_difference < -2.0 then
			pos_y = vm.f32(pos_y - 2.0)
		elseif height_difference < 2.0 then
			pos_y = target_height
		else
			pos_y = vm.f32(pos_y + 2.0)
		end
		monster.set_position(pos_x, pos_y, pos_z)
		yaw_difference = vm.f32(target_yaw - yaw)
		if yaw_difference > vm.f32(3.1415927) then
			yaw_difference = vm.f32(yaw_difference - vm.f32(6.2831855))
		end
		if yaw_difference <= vm.f32(-3.1415927) then
			yaw_difference = vm.f32(yaw_difference + vm.f32(6.2831855))
		end
		if yaw_difference < vm.f32(-0.05) then
			yaw = vm.f32(yaw - vm.f32(0.05))
		elseif yaw_difference < vm.f32(0.05) then
			yaw = target_yaw
		else
			yaw = vm.f32(yaw + vm.f32(0.05))
		end
		if yaw > vm.f32(3.1415927) then
			yaw = vm.f32(yaw - vm.f32(6.2831855))
		end
		if yaw <= vm.f32(-3.1415927) then
			yaw = vm.f32(yaw + vm.f32(6.2831855))
		end
		monster.set_rotation(rotation_x, yaw, rotation_z)
		point_camera_at_arena_center()
		vm.wait()
	end
	return 0
end

--- Turns the boss at its current height until it faces the given yaw.
local function turn_to_yaw(target_yaw: f32)
	local pos_y: f32 = 0
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	settle_height_and_yaw(pos_y, target_yaw, 1)
	return 0
end

--- Plays a sound of the boss's character.
local function play_butterfly_sound(sound: s32)
	local chara_type: s32 = 0
	chara_type = monster.get_character_number() or chara_type
	monster.play_monster_sound(chara_type, sound)
end

--- Stops a sound of the boss's character.
local function stop_butterfly_sound(sound: s32)
	local chara_type: s32 = 0
	chara_type = monster.get_character_number() or chara_type
	monster.stop_monster_sound(chara_type, sound)
end

--- Faces the player and sprinkles scale powder for two seconds, returning the next attack state.
local function attack_scale_powder()
	local target_x: f32 = 0
	local target_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_z: f32 = 0
	local target_yaw: f32 = 0
	local result: s32 = 0
	local frame: s32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, _, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_z = out3 or rotation_z
	end
	target_yaw = monster.get_arc_tangent(target_x - pos_x, target_z - pos_z) or target_yaw
	result = turn_to_yaw(target_yaw)
	if result == 5 then
		return 5
	end
	monster.set_motion("りんぷん")
	monster.set_positional_sound(1)
	play_butterfly_sound(6)
	frame = 0
	while frame < 120 do
		if vm.imod(frame, 60) == 0 then
			monster.create_effect_1("蝶りんぷん")
			monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
			monster.set_effect_second_vector(-1, rotation_x, target_yaw, rotation_z)
			monster.set_effect_value(-1, 0, 24)
			monster.set_effect_target(-1, 0)
		end
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_ended()
	stop_butterfly_sound(6)
	monster.set_positional_sound(2)
	return 2
end

--- Aims a sweeping beam at the player's position while spawning fire pillars along it, then returns to the arena ring.
local function attack_rainbow_beam()
	local target_x: f32 = 0
	local target_z: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local target_yaw: f32 = 0
	local result: s32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local beam_start_x: f32 = 0
	local beam_start_y: f32 = 0
	local beam_start_z: f32 = 0
	local beam_end_x: f32 = 0
	local beam_end_y: f32 = 0
	local beam_end_z: f32 = 0
	local slot: s32 = 0
	local emitter_x: f32 = 0
	local emitter_y: f32 = 0
	local emitter_z: f32 = 0
	local frame: s32 = 0
	local attack: s32 = 0
	local value: s32 = 0
	local vector: f32 = 0
	local vector_2: f32 = 0
	local vector_3: f32 = 0
	local pos_x_3: f32 = 0
	local pos_z_3: f32 = 0
	local angle_from_center: f32 = 0
	local return_yaw: f32 = 0
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	target_yaw = monster.get_arc_tangent(target_x - pos_x, target_z - pos_z) or target_yaw
	result = settle_height_and_yaw(1050.0, target_yaw, 1)
	if result == 5 then
		return 5
	end
	monster.set_motion("ビーム構え", -1, 2)
	motion.wait_until_finished()
	do
		local out1, out2, out3 = monster.get_target_position()
		aim_x = out1 or aim_x
		aim_y = out2 or aim_y
		aim_z = out3 or aim_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	monster.set_motion("ビーム", -1, 4)
	monster.set_positional_sound(1)
	play_butterfly_sound(8)
	beam_start_x = pos_x_2
	beam_start_y = aim_y
	beam_start_z = pos_z_2
	beam_end_x = aim_x
	beam_end_y = aim_y
	beam_end_z = aim_z
	slot = monster.create_effect_2("蝶ビーム") or slot
	do
		local out1, out2, out3 = monster.get_object_position("obj17")
		emitter_x = out1 or emitter_x
		emitter_y = out2 or emitter_y
		emitter_z = out3 or emitter_z
	end
	monster.set_effect_first_vector(slot, emitter_x, emitter_y, emitter_z)
	attack = monster.get_attack_power_1() or attack
	frame = 0
	while frame < 60 do
		value = monster.get_variable(8) or value
		if value == 16 then
			monster.finish_effect(slot)
			stop_butterfly_sound(8)
			monster.set_positional_sound(2)
			return 5
		end
		vector = calc.interpolate(beam_start_x, beam_end_x, vm.f32(vm.fdiv(frame, 60)))
		vector_2 = calc.interpolate(beam_start_y, beam_end_y, vm.f32(vm.fdiv(frame, 60)))
		vector_3 = calc.interpolate(beam_start_z, beam_end_z, vm.f32(vm.fdiv(frame, 60)))
		monster.set_effect_second_vector(slot, vector, vector_2, vector_3)
		frame = frame + 1
		if vm.imod(frame, 3) == 0 then
			monster.create_effect_1("七色蝶の火柱")
			monster.set_effect_first_vector(-1, vector, vector_2, vector_3)
			monster.set_effect_value(-1, 0, attack)
		end
		if frame == 44 then
			monster.finish_effect(slot)
		end
		vm.wait()
	end
	stop_butterfly_sound(8)
	monster.set_positional_sound(2)
	monster.set_motion("ビーム戻り", -1, 6)
	motion.wait_until_finished()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x_3 = out1 or pos_x_3
		pos_z_3 = out3 or pos_z_3
	end
	angle_from_center = monster.get_arc_tangent(pos_x_3 - vm.f32(268.8), pos_z_3 - vm.f32(-322.4)) or angle_from_center
	return_yaw = vm.f32(angle_from_center + vm.f32(1.5707964))
	if return_yaw > vm.f32(3.1415927) then
		return_yaw = vm.f32(return_yaw - vm.f32(6.2831855))
	end
	if return_yaw <= vm.f32(-3.1415927) then
		return_yaw = vm.f32(return_yaw + vm.f32(6.2831855))
	end
	local _ = settle_height_and_yaw(850.0, return_yaw, 1)
	if result == 5 then
		return 5
	end
	return 1
end

--- Flies around the arena centre, speeding up and then slowing down, before choosing the next attack by distance to the player.
local function circle_arena()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local orbit_angle: f32 = 0
	local y: f32 = 0
	local result: s32 = 0
	local duration: s32 = 0
	local elapsed: s32 = 0
	local angular_speed: f32 = 0
	local is_accelerating: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	local value: s32 = 0
	local target_distance: f32 = 0
	monster.set_motion("歩き")
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	orbit_angle = monster.get_arc_tangent(pos_x - vm.f32(268.8), pos_z - vm.f32(-322.4)) or orbit_angle
	y = vm.f32(orbit_angle + vm.f32(1.5707964))
	if y > vm.f32(3.1415927) then
		y = vm.f32(y - vm.f32(6.2831855))
	end
	if y <= vm.f32(-3.1415927) then
		y = vm.f32(y + vm.f32(6.2831855))
	end
	result = turn_to_yaw(y)
	if result == 5 then
		return 5
	end
	duration = 90
	elapsed = 0
	angular_speed = 0.0
	is_accelerating = 1
	while true do
		trigger_first_hit_event()
		value = monster.get_variable(8) or value
		if value == 16 then
			return 5
		end
		if duration < elapsed then
			is_accelerating = 0
			if angular_speed <= 0.0 then
				target_distance = monster.get_target_distance() or target_distance
				if target_distance < 1000.0 then
					return 6
				else
					return 2
				end
			end
		end
		x, z = get_point_on_circle(vm.f32(268.8), vm.f32(-322.4), orbit_angle, 800.0, x, z)
		monster.set_position(x, 850.0, z)
		monster.set_rotation(0.0, y, 0.0)
		if is_accelerating ~= 0 then
			if angular_speed < vm.f32(0.02) then
				angular_speed = vm.f32(angular_speed + vm.f32(0.0005))
			end
		elseif 0 < angular_speed then
			angular_speed = vm.f32(angular_speed - vm.f32(0.0005))
		end
		orbit_angle = vm.f32(orbit_angle + angular_speed)
		if orbit_angle > vm.f32(3.1415927) then
			orbit_angle = vm.f32(orbit_angle - vm.f32(6.2831855))
		end
		if orbit_angle <= vm.f32(-3.1415927) then
			orbit_angle = vm.f32(orbit_angle + vm.f32(6.2831855))
		end
		y = vm.f32(orbit_angle + vm.f32(1.5707964))
		if y > vm.f32(3.1415927) then
			y = vm.f32(y - vm.f32(6.2831855))
		end
		if y <= vm.f32(-3.1415927) then
			y = vm.f32(y + vm.f32(6.2831855))
		end
		vm.wait()
		elapsed = vm.i32(elapsed + 1)
	end
	return 0
end

--- Keeps the boss invisible until the butterflies are told to merge.
local function hide_until_merge()
	local value: s32 = 0
	monster.set_alpha(0.0)
	while true do
		vm.wait()
		value = monster.get_variable(8) or value
		if value == 9 then
			return 3
		end
	end
	return 0
end

--- Starts or stops the scripted camera orbit and the pause flags that go with it.
local function set_camera_orbit(enabled: s32)
	if enabled ~= 0 then
		monster.set_pause_flags(6, 1)
		is_camera_orbit_active = 1
	else
		monster.set_camera_follow(1)
		monster.set_pause_flags(6, 0)
		is_camera_orbit_active = 0
	end
end

--- Turns toward a point on the ground and then moves to it in fixed steps.
local function walk_to_point(to: f32, to_3: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local turn_step: f32 = 0
	local relative_angle: f32 = 0
	local y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local x: f32 = 0
	local y_2: f32 = 0
	local z: f32 = 0
	local remaining_distance: f32 = 0
	local move_angle: f32 = 0
	local step_x: f32 = 0
	local step_z: f32 = 0
	while true do
		trigger_first_hit_event()
		do
			local out1, _, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_rotation()
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		relative_angle = sense.get_relative_angle_to_point(pos_x, pos_z, rotation_y, to, to_3)
		if vm.f32(0.01) < relative_angle or relative_angle < vm.f32(-0.01) then
			if 0 < relative_angle then
				turn_step = relative_angle
				if vm.f32(0.05) < turn_step then
					turn_step = vm.f32(0.05)
				end
			else
				turn_step = relative_angle
				if turn_step < vm.f32(-0.05) then
					turn_step = vm.f32(-0.05)
				end
			end
		else
			break
		end
		y = vm.f32(rotation_y + turn_step)
		if y > vm.f32(3.1415927) then
			y = vm.f32(y - vm.f32(6.2831855))
		end
		if y <= vm.f32(-3.1415927) then
			y = vm.f32(y + vm.f32(6.2831855))
		end
		monster.set_rotation(rotation_x, y, rotation_z)
		point_camera_at_arena_center()
		vm.wait()
	end
	while true do
		trigger_first_hit_event()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		remaining_distance = monster.get_distance_between(pos_x_2, pos_y_2, pos_z_2, to, pos_y_2, to_3) or remaining_distance
		if vm.f32(0.01) < remaining_distance then
			if 5.0 <= remaining_distance then
				move_angle = monster.get_arc_tangent(to - pos_x_2, to_3 - pos_z_2) or move_angle
				step_x, step_z = calc.get_polar_offset(move_angle, 5.0, step_x, step_z)
				x = vm.f32(pos_x_2 + step_x)
				y_2 = pos_y_2
				z = vm.f32(pos_z_2 + step_z)
			else
				x = to
				y_2 = pos_y_2
				z = to_3
			end
		else
			return
		end
		monster.set_position(x, y_2, z)
		point_camera_at_arena_center()
		vm.wait()
	end
end

--- Fades the merged boss in at the arena centre once all butterflies have been defeated.
local function merge_butterflies()
	local frame: s32 = 0
	local value: s32 = 0
	local slot: s32 = 0
	local value_2: f32 = 0
	local final_yaw: f32 = 0
	timer.wait_frames(120)
	set_camera_orbit(1)
	monster.set_pause_flags(65536, 1)
	while true do
		value = monster.get_variable(8) or value
		if value == 0 then
			break
		else
			point_camera_at_arena_center()
			vm.wait()
		end
	end
	set_camera_orbit(0)
	monster.set_pause_flags(65536, 0)
	slot = monster.create_effect_2("蝶合体") or slot
	monster.set_effect_first_vector(slot, 268.8, 1050.0, -322.4)
	monster.request_event_script(513)
	monster.set_positional_sound(1)
	play_butterfly_sound(10)
	frame = 0
	while frame < 60 do
		point_camera_at_arena_center()
		vm.wait()
		frame = frame + 1
	end
	monster.set_position(268.8, 1050.0, -322.4)
	monster.set_alpha(0.0)
	monster.set_motion("合体")
	frame = 0
	while frame < 90 do
		value_2 = calc.interpolate(0.0, 1.0, vm.f32(vm.fdiv(frame, 90)))
		monster.set_alpha(value_2)
		point_camera_at_arena_center()
		vm.wait()
		frame = frame + 1
	end
	monster.set_alpha(1.0)
	monster.set_monster_attributes(1, 0)
	monster.finish_effect(slot)
	monster.request_event_script(510)
	walk_to_point(vm.f32(268.8), vm.f32(477.6))
	final_yaw = vm.f32(1.5707964)
	settle_height_and_yaw(850.0, final_yaw, 1)
	return 1
end

--- Fades the boss out at the arena centre so the butterfly flock takes over.
local function scatter_into_butterflies()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local angle_from_center: f32 = 0
	local slot: s32 = 0
	local frame: s32 = 0
	local value: f32 = 0
	local value_2: s32 = 0
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	set_camera_orbit(1)
	monster.set_pause_flags(65536, 1)
	angle_from_center = monster.get_arc_tangent(pos_x - vm.f32(268.8), pos_z - vm.f32(-322.4)) or angle_from_center
	monster.set_position(pos_x, 1050.0, pos_z)
	monster.set_rotation(0.0, angle_from_center, 0.0)
	monster.set_motion("歩き")
	walk_to_point(vm.f32(268.8), vm.f32(-322.4))
	slot = monster.create_effect_2("蝶合体") or slot
	monster.set_effect_first_vector(slot, 268.8, 1050.0, -322.4)
	monster.request_event_script(512)
	monster.set_positional_sound(1)
	play_butterfly_sound(9)
	frame = 0
	while frame < 90 do
		frame = frame + 1
		value = calc.interpolate(1.0, 0.0, vm.f32(vm.fdiv(frame, 90)))
		monster.set_alpha(value)
		point_camera_at_arena_center()
		vm.wait()
	end
	monster.set_monster_attributes(1, 1)
	monster.set_alpha(0.0)
	monster.set_motion("歩き", -1, 1)
	monster.finish_effect(slot)
	monster.set_variable(8, 17)
	monster.request_event_script(511)
	frame = 0
	while frame < 60 do
		point_camera_at_arena_center()
		vm.wait()
		frame = frame + 1
	end
	monster.set_variable(8, 1)
	value_2 = monster.get_variable(18) or value_2
	if value_2 == 0 then
		point_camera_at_arena_center()
		monster.set_variable(18, 1)
		monster.request_event_script(502)
		vm.wait()
	end
	set_camera_orbit(0)
	monster.set_pause_flags(65536, 0)
	return 4
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Configures the boss attributes, arena position, effects and body.
function script.init()
	monster.set_visible_monster_limit(15)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_clip_distance(999999.9)
	monster.set_monster_attributes(4, 1)
	monster.set_position(260.0, 850.0, -320.0)
	monster.load_effect_script("蝶ビーム")
	monster.load_effect_script("七色蝶の火柱")
	monster.load_effect_script("蝶合体")
	monster.load_effect_script("蝶りんぷん")
	monster.load_effect_script("蝶りんぷんＨ")
	monster.load_effect_script("蝶ねばＬ")
	monster.load_effect_script("ねばねばＨ")
	monster.set_photo_opportunity("合体", 0.0, 1.0, 1015)
	monster.register_entry_object(0, "body2--a40")
	monster.set_body(0, 12.0)
end

--- Runs the boss's state machine of scale powder, beam, orbit, hidden, merge and scatter states.
function script.loop()
	local state: s32 = 0
	local chara_type: s32 = 0
	monster.set_positional_sound(2)
	state = 1
	while true do
		is_camera_orbit_active = 0
		if state == 6 then
			state = attack_scale_powder()
		end
		if state == 2 then
			state = attack_rainbow_beam()
		end
		if state == 1 then
			state = circle_arena()
		end
		if state == 4 then
			state = hide_until_merge()
		end
		if state == 3 then
			state = merge_butterflies()
		end
		if state == 5 then
			chara_type = monster.get_character_number() or chara_type
			monster.clear_character_effects(chara_type)
			state = scatter_into_butterflies()
		end
		if state == 0 then
			monster.set_positional_sound(0)
			return
		end
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
