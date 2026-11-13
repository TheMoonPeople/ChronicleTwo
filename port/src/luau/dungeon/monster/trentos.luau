--!strict
--- Controls Trentos, a guarding boss that stalks the target, strikes it and summons Kortlenns.

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

--- Sets the guard and awareness defaults and limits how far away the monster stays active unless it is a boss.
local function configure_guard_and_clip()
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

--- Walks to a point beside the target or waits for the target to face it.
local function reposition_while_guarded()
	local roll: s32 = 0
	local flank_angle_degrees: f32 = 0
	local flank_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		flank_angle_degrees = monster.get_random_whole_number(30.0) or flank_angle_degrees
		flank_distance = monster.get_random_whole_number(30.0) or flank_distance
		flank_distance = vm.f32(flank_distance + 120.0)
		if roll < 50 then
			flank_angle_degrees = vm.f32(-flank_angle_degrees - 30.0)
		else
			flank_angle_degrees = vm.f32(flank_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(3.2), 3.5, flank_angle_degrees, flank_distance, 65.0, 30)
		movement.turn_toward_target_and_wait_guarded(3.5)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(65.0, 45.0, 30)
	end
end

--- Walks toward the target at a given speed until within range or the frame limit passes.
local function walk_toward_target(speed: f32, turn_speed_degrees: f32, stop_distance: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local turn_speed: f32 = 0
	local target_angle: f32 = 0
	local target_distance: f32 = 0
	local frame_index: s32 = 0
	turn_speed = calc.degrees_to_radians(turn_speed_degrees)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	frame_index = 0
	while frame_index < max_frames do
		monster.get_position_3()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < stop_distance then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		if target_z < -900.0 then
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.move_toward_position(target_x, target_y - 20.0, target_z, speed, speed)
		monster.turn_toward_angle(target_angle, turn_speed)
		reaction.update_and_wait_frame()
		frame_index = frame_index + 1
		movement.stop_turning()
	end
	monster.stop_moving()
	movement.stop_turning()
end

--- Plays the summoning motion and creates three Kortlenns in front of the boss when few monsters exist.
local function summon_kortlenns()
	local smoke_x: f32 = 0
	local smoke_y: f32 = 0
	local smoke_z: f32 = 0
	local i: s32 = 0
	local unused_random: s32 = 0
	local monster_count: s32 = 0
	local spawn_x: f32 = 0
	local spawn_z: f32 = 0
	local rotation_y: f32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	timer.wait_frames_guarded(calc.pass_through(4))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol00")
		smoke_x = out1 or smoke_x
		smoke_y = out2 or smoke_y
		smoke_z = out3 or smoke_z
	end
	monster.create_effect_1("トーレの煙")
	monster.set_effect_first_vector(-1, smoke_x, smoke_y, smoke_z)
	timer.wait_frames_guarded(calc.pass_through(11))
	monster_count = monster.get_monster_count() or monster_count
	if monster_count < 7 then
		monster.get_random(3, unused_random)
		i = 0
		unused_random = unused_random + 1
		monster.set_monster_attributes(16, 1)
		while i < 3 do
			do
				local out1, _, out3 = monster.get_position_3()
				spawn_x = out1 or spawn_x
				spawn_z = out3 or spawn_z
			end
			do
				local _, out2, _ = monster.get_rotation()
				rotation_y = out2 or rotation_y
			end
			do
				local out1, _, out3 = monster.get_point_from_facing(0.0, 40.0 + vm.f32(i * 10.0))
				spawn_x = out1 or spawn_x
				spawn_z = out3 or spawn_z
			end
			monster.create_monster(610, spawn_x, 0.5, spawn_z, rotation_y)
			i = i + 1
		end
	end
	motion.wait_until_finished_guarded()
	timer.wait_frames_guarded(15)
	monster.set_monster_attributes(16, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Sweeps its gaze from side to side and stops when the target comes in front.
local function look_around_for_target(sweep_angle: f32, turn_speed: f32, wait_frames: s32, view_distance: f32)
	local current_rotation: f32 = 0
	local sweep_target: f32 = 0
	sweep_angle = calc.degrees_to_radians(sweep_angle)
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_target = vm.f32(current_rotation + sweep_angle)
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(sweep_target), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if sense.wait_until_target_in_front(view_distance, 80.0, wait_frames) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_target = vm.f32(current_rotation - sweep_angle)
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(sweep_target), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if sense.wait_until_target_in_front(view_distance, 80.0, wait_frames) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_target = vm.f32(current_rotation - sweep_angle)
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(sweep_target), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if sense.wait_until_target_in_front(view_distance, 80.0, wait_frames) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		current_rotation = out2 or current_rotation
	end
	monster.set_motion("歩き", -1.0, 0)
	sweep_target = vm.f32(current_rotation + sweep_angle)
	movement.turn_to_angle_and_wait(calc.radians_to_degrees(sweep_target), turn_speed)
	monster.set_motion("立ち", -1, 0)
	if sense.wait_until_target_in_front(view_distance, 80.0, wait_frames) == 1 then
		return 0
	end
	return 0
end

--- Chooses between summoning, approaching, looking around and waiting when the target is far.
local function act_at_far_range()
	local roll: s32 = 0
	local monster_count: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 10 then
		monster_count = monster.get_monster_count() or monster_count
		if monster_count < 7 then
			monster.set_motion("歩き", -1.0, 0)
			walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
			summon_kortlenns()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("歩き", -1, 0)
			walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
		else
			roll = monster.get_random(100) or roll
			if roll < 40 then
				if look_around_for_target(45.0, 3.5, 60, 200.0) == 1 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(3.5)
					monster.set_motion("歩き", -1.0, 0)
					walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
					monster.set_motion("立ち", -1, 0)
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("待機", -1, 0)
					if sense.wait_until_target_in_front(550.0, 45.0, 75) == 1 then
						monster.set_motion("歩き", -1.0, 0)
						movement.turn_toward_target_and_wait_guarded(3.5)
						monster.set_motion("歩き", -1.0, 0)
						walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
						monster.set_motion("立ち", -1, 0)
					end
				else
					motion.idle_for_frames(30)
				end
			end
		end
	end
	reaction.update_and_wait_frame()
end

--- Chooses between summoning, approaching, wandering and waiting when the target is at mid range.
local function act_at_mid_range()
	local roll: s32 = 0
	local monster_count: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 25 then
		monster_count = monster.get_monster_count() or monster_count
		if monster_count < 7 then
			monster.set_motion("歩き", -1.0, 0)
			walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
			summon_kortlenns()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("歩き", -1.0, 0)
			walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.wander(vm.f32(3.2), 3.5, 40.0, 180.0, 30.0, 65.0, 40)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(150.0, 45.0, 45)
			end
		end
	end
	reaction.update_and_wait_frame()
end

--- Plays the swing attack and waits for it to finish.
local function swing_attack()
	monster.set_motion("攻撃１", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between striking, summoning, approaching and waiting when the target is near.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local monster_count: s32 = 0
	local target_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 85 then
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(3.5)
		monster.set_motion("歩き", -1.0, 0)
		walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
		swing_attack()
	else
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 70.0 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster_count = monster.get_monster_count() or monster_count
				if monster_count < 7 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_with_offset_guarded(7.0, 30.0, 15)
					summon_kortlenns()
				end
			end
		end
		roll = monster.get_random(100) or roll
		if roll < 70 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(3.5)
			monster.set_motion("歩き", -1.0, 0)
			walk_toward_target(vm.f32(3.2), 3.5, 65.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 100 then
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(120.0, 30.0, 45)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(3.5)
				target_angle = monster.get_target_angle() or target_angle
				monster.set_motion("歩き", -1.0, 0)
				movement.move_in_direction_guarded(vm.f32(3.2), calc.radians_to_degrees(target_angle), 100.0, 600.0, 15)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Keeps engaging the target until it leaves range or the boss is no longer enraged.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 600.0 then
			monster.set_variable(0, 0)
			reaction.update_and_wait_frame()
			return
		elseif target_distance > 120.0 then
			monster.set_variable(0, 0)
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			reposition_while_guarded()
			continue
		end
		if target_distance < 600.0 and target_distance >= 200.0 then
			act_at_far_range()
		elseif target_distance < 200.0 and target_distance >= 120.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
		reaction.update_and_wait_frame()
	end
end

--- Waits for the target to come close enough, then turns toward it and starts the fight.
local function wait_for_target_to_approach()
	local target_distance: f32 = 0
	local has_noticed: s32 = 0
	monster.set_variable(0, 0)
	reaction.update_and_wait_frame()
	target_distance = monster.get_target_distance() or target_distance
	-- retail: monster.set_variable(0, value) does nothing, since its handler stores only an integer or a float
	if target_distance < 320.0 and has_noticed == 0 then
		monster.set_motion("立ち", -1, 0)
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(2.45))
		monster.set_motion("立ち", -1, 0)
		reaction.update_and_wait_frame()
		monster.set_variable(0, 1)
		return
	end
	has_noticed = monster.get_variable(0) or has_noticed
	if has_noticed == 0 then
		monster.set_motion("待機", -1, 0)
		timer.wait_frames_guarded(10)
	end
end

--- Runs toward the target after it has been noticed.
local function charge_toward_noticed_target()
	print("notice--------------\n")
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	walk_toward_target(vm.f32(6.4), 3.5, 65.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between fighting, waiting and charging from the target distance and the guard state.
local function update_engagement()
	local target_distance: f32 = 0
	local alert_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	print("test---------------------\n")
	if reaction.is_guard_active() == 0 then
		if target_distance < 600.0 then
			reaction.set_guard_active(0)
			fight_target()
		else
			wait_for_target_to_approach()
		end
	else
		print("notice-------------\n")
		alert_distance = state.get_secondary_float(alert_distance)
		if target_distance < alert_distance then
			if target_distance < 200.0 then
				reaction.set_guard_active(0)
				fight_target()
			else
				charge_toward_noticed_target()
			end
		else
			reaction.set_guard_active(0)
		end
	end
end

local script = {}

--- Does nothing.
function script.setup() end

--- Registers the attack hit windows, loads the effects and sets the boss defaults.
function script.init()
	local free_texture_block: s32 = 0
	local smoke_loaded: s32 = 0
	local explosion_loaded: s32 = 0
	monster.register_damage_hit("トレントス攻撃", 10.0, "攻撃１", 0.3, 0.7, 1)
	monster.register_damage_hit("トレントス攻撃", 10.0, "攻撃１", 0.4, 0.8, 2)
	monster.set_monster_attributes(512, 1)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		smoke_loaded = monster.load_effect_script("トーレの煙", free_texture_block) or smoke_loaded
		explosion_loaded = monster.load_effect_script("Ｍ小爆発", free_texture_block) or explosion_loaded
		if (if smoke_loaded ~= 0 then 1 else explosion_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	configure_guard_and_clip()
	monster.set_clip_distance(99999.9)
	state.set_unknown_float_8(vm.f32(99999.9))
	state.set_unknown_float_9(vm.f32(99999.9))
end

--- Repeatedly updates the engagement with the target.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(16, 0)
	while true do
		reaction.update_and_wait_frame()
		update_engagement()
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
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion with a small knockback.
function script.on_damage()
	monster.set_monster_attributes(16, 0)
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_guarded(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Faces the target and plays the damage motion with a knockback.
function script.on_knockdown()
	monster.set_monster_attributes(16, 0)
	state.lock_and_face_target_guarded()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_guarded(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Locks and releases the monster while it guards.
function script.on_guard()
	monster.set_monster_attributes(16, 0)
	state.lock_and_stop_moving()
	state.unlock()
end

--- Locks and releases the monster without moving.
function script.on_dodge_1()
	monster.set_monster_attributes(16, 0)
	state.lock_and_reset_motion()
	state.unlock()
end

--- Locks and releases the monster without moving.
function script.on_dodge_2()
	monster.set_monster_attributes(16, 0)
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the death motion and requests the defeat event.
function script.on_death()
	monster.set_variable(64, 1)
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	monster.request_event_script(600)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Struggles while caught.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers after being thrown and gets back up.
function script.on_land()
	combat.finish_throw_guarded()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_guarded(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Plays the damage motion and stays stunned until recovered.
function script.on_stun()
	monster.set_monster_attributes(16, 0)
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames_guarded(12)
	reaction.stun_until_recovered()
end

return script
