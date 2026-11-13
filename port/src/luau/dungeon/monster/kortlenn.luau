--!strict
--- Controls a Kortlenn, a suicide attacker that runs at the target and explodes on contact or after a time limit.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

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

--- Plays the death motion and the death effects, then idles forever.
local function die()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Starts the death sequence when the death flag is set.
local function die_if_flagged()
	local death_flag: s32 = 0
	death_flag = monster.get_variable(64) or death_flag
	if death_flag ~= 0 then
		die()
	end
end

--- Checks for the death flag and waits one frame.
local function check_death_and_wait_frame()
	die_if_flagged()
	vm.wait()
end

--- Waits until the monster faces a target angle or the frame limit passes, and returns the frames waited.
local function wait_until_facing(target_angle: f32, turn_speed: f32, max_frames: f32)
	local current_angle: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local angle_tolerance: f32 = 0
	target_angle = calc.degrees_to_radians(target_angle)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	frame_limit = max_frames
	if turn_speed < 3.0 then
		angle_tolerance = calc.degrees_to_radians(3.0)
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
			check_death_and_wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns toward the target at a given speed and waits until facing it.
local function turn_toward_target_and_wait(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Chases the target at a given speed until within range or the frame limit passes.
local function run_toward_target(speed: f32, turn_speed: f32, stop_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local frame_index: s32 = 0
	turn_toward_target_and_wait(turn_speed)
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	frame_index = 0
	while frame_index < max_frames do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, turn_speed)
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_rotation()
		monster.get_target_position()
		do
			local out1, out2, out3 = monster.get_target_position()
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(destination_x, destination_y, destination_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, speed + stop_distance)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(destination_x, destination_y, destination_z, position_x, position_y, position_z)
			destination_x = out1 or destination_x
			destination_y = out2 or destination_y
			destination_z = out3 or destination_z
		end
		monster.move_toward_position(destination_x, position_y - 20.0, destination_z, speed, speed)
		check_death_and_wait_frame()
		frame_index = frame_index + 1
		monster.stop_moving()
		movement.stop_turning()
	end
end

--- Charges at the target and explodes on contact, or when the time limit passes.
local function charge_and_explode()
	local target_distance: f32 = 0
	local has_wound_up: s32 = 0
	local attack_power: s32 = 0
	local roll: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local monster_count: s32 = 0
	if timer.get_primary_elapsed() > 300 then
		monster.stop_moving()
		movement.stop_turning()
		monster.start_death()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.create_effect_1("Ｍ小爆発")
		monster.set_effect_first_vector(-1, position_x, position_y, position_z)
		monster.set_effect_value(-1, 0, attack_power)
		monster.set_motion("死に", -1, 6)
		motion.wait_until_finished()
		monster.spawn_death_effects()
		while true do
			vm.wait()
		end
	end
	attack_power = monster.get_attack_power_1() or attack_power
	vm.wait()
	has_wound_up = monster.get_variable(0) or has_wound_up
	if has_wound_up == 0 then
		movement.stop_turning()
		monster.reset_motion()
		monster.set_motion("歩き", -1, 0)
		turn_toward_target_and_wait(4.5)
		monster.reset_motion()
		monster.set_motion("攻撃１out", -1, 6)
		motion.wait_until_finished()
		monster.set_variable(0, 1)
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("攻撃１", -1, 0)
		run_toward_target(4.5, 4.5, 21.0, 100)
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 42.0 then
		monster.stop_moving()
		movement.stop_turning()
		monster.start_death()
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.create_effect_1("Ｍ小爆発")
		monster.set_effect_first_vector(-1, position_x, position_y, position_z)
		monster.set_effect_value(-1, 0, attack_power)
		monster.set_motion("死に", -1, 6)
		motion.wait_until_finished()
		monster_count = monster.get_monster_count() or monster_count
		if monster_count <= 1 then
			monster.request_event_script(510)
		end
		monster.spawn_death_effects()
		while true do
			vm.wait()
		end
	end
	monster.reset_motion()
	monster.set_motion("攻撃１out", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	vm.wait()
end

local script = {}

--- Does nothing.
function script.setup() end

--- Registers the attack hit window and starts the explosion timer.
function script.init()
	monster.register_damage_hit("コトレン攻撃", 4.5, "攻撃１", 0.0, 1.0, 0)
	monster.reset_dungeon_timer()
	timer.start_primary()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	set_clip_distance_for_boss()
	monster.set_monster_attributes(16, 1)
	monster.set_clip_distance(10000000.0)
end

--- Repeatedly charges the target.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		charge_and_explode()
	end
end

--- Plays the damage motion and waits until the status ailments clear.
function script.on_status_hit()
	local has_status: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status = 1
	while has_status ~= 0 do
		has_status = monster.get_status_ailments(40) or has_status
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion with a small knockback.
function script.on_damage()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
end

--- Plays the death motion and the death effects, then idles forever.
function script.on_knockdown()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

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

--- Plays the death motion and the death effects, then idles forever.
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

--- Struggles while caught.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers after being thrown.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	return 1
end

--- Plays the damage motion and stays stunned until recovered.
function script.on_stun()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames(12)
	monster.set_motion("気絶", -1)
	reaction.wait_for_stun_end()
end

return script
