--!strict
--- Drives the Kotore family of small tree monsters that rush the player and explode.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets how far from the camera the monster stays active.
local function set_clip_distance()
	local is_boss: s32 = 0
	is_boss = monster.is_boss() or is_boss
	if is_boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Picks a random idle action such as wandering, turning or watching when the target is far away.
local function wander_when_idle()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local final_turn_angle: f32 = 0
	local approach_angle: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local look_angle: f32 = 0
	timer.wait_one_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_position_x = out1 or place_position_x
		place_position_y = out2 or place_position_y
		place_position_z = out3 or place_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 60.0 then
		turn_angle = monster.get_random_whole_number(360.0) or turn_angle
		monster.set_motion("攻撃１", -1.0, 0)
		movement.turn_to_angle(turn_angle, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 60.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction(vm.f32(4.8), 1.75, turn_angle, clear_distance, 60.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("攻撃１", -1.0, 0)
				movement.walk_around_position_unguarded(place_position_x, place_position_y, place_position_z, 1.75, vm.f32(4.8), distance, orbit_angle, 60.0, 60)
				final_turn_angle = monster.get_random_whole_number(180.0) or final_turn_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_angle = vm.f32(final_turn_angle * -1.0)
				end
				movement.turn_to_angle(final_turn_angle, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 80.0, 50.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 5 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 80.0, 50.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle = monster.get_random_whole_number(180.0) or turn_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle = vm.f32(turn_angle * -1.0)
			end
			monster.set_motion("攻撃１", -1.0, 0)
			movement.turn_to_angle(turn_angle, vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_variable(0, 4)
					roll = monster.get_random(100) or roll
					approach_angle = monster.get_random_whole_number(180.0) or approach_angle
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_angle = vm.f32(approach_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_angle = vm.f32(-approach_angle - 30.0)
					else
						approach_angle = vm.f32(approach_angle + 30.0)
					end
					monster.set_motion("攻撃１", -1.0, 0)
					wait_result = movement.walk_around_target(1.75, vm.f32(4.8), approach_angle, approach_distance, 60.0, 60)
					look_angle = monster.get_random_whole_number(360.0) or look_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						look_angle = vm.f32(look_angle * -1.0)
					end
					movement.turn_to_angle(look_angle, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("攻撃１", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle = calc.radians_to_degrees(rotation_y)
					if turn_angle > vm.f32(3.1415927) then
						turn_angle = vm.f32(turn_angle - vm.f32(6.2831855))
					end
					if turn_angle <= vm.f32(-3.1415927) then
						turn_angle = vm.f32(turn_angle + vm.f32(6.2831855))
					end
					movement.move_in_direction(1.75, turn_angle, 1000.0, 60.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 80.0, 50.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("攻撃１", -1.0, 0)
			movement.wander_unguarded(1.75, vm.f32(4.8), distance, 360.0, 40.0, 60.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chases the target and explodes against it, or explodes when its time runs out.
local function run_suicide_attack()
	local target_distance: f32 = 0
	local attack_state: s32 = 0
	local attack: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local chase_speed_bonus: f32 = 0
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
		monster.set_effect_value(-1, 0, attack)
		monster.set_motion("死に", -1, 6)
		motion.wait_until_finished()
		monster.spawn_death_effects()
		while true do
			vm.wait()
		end
	end
	attack = monster.get_attack_power_1() or attack
	vm.wait()
	attack_state = monster.get_variable(0) or attack_state
	if attack_state == 0 then
		movement.stop_turning()
		monster.reset_motion()
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(4.5)
		monster.reset_motion()
		monster.set_motion("攻撃１out", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("攻撃１", -1, 0)
		chase_speed_bonus = monster.get_random_whole_number(3.0) or chase_speed_bonus
		movement.chase_target(vm.f32(chase_speed_bonus + 2.0), 4.5, 22.0, 30)
		monster.set_motion("立ち", -1, 0)
		monster.set_variable(0, 1)
	end
	monster.get_random(100)
	if sense.is_target_threatening(100.0, 80.0, 50.0, vm.f32(1.2)) ~= 0 then
		monster.set_motion("攻撃１", -1, 0)
		movement.rush_forward(4.5, 4.5, 22.0, 100)
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
			monster.set_effect_value(-1, 0, attack)
			monster.set_motion("死に", -1, 6)
			motion.wait_until_finished()
			monster.spawn_death_effects()
			while true do
				vm.wait()
			end
		end
		monster.reset_motion()
		monster.set_motion("攻撃１out", -1, 6)
		motion.wait_until_finished()
		monster.set_motion("立ち", -1, 0)
	else
		wander_when_idle()
	end
	vm.wait()
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Starts the self-destruct timer and sets the monster's clip distance.
function script.init()
	monster.reset_dungeon_timer()
	timer.start_primary()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	set_clip_distance()
	monster.set_monster_attributes(16, 1)
	monster.set_clip_distance(10000000.0)
end

--- Runs the suicide attack every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		run_suicide_attack()
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
	timer.wait_frames(12)
	monster.set_motion("立ち")
end

--- Kills the monster outright when it is knocked down.
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
--- Does nothing so the engine does not run its default guard.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine does not run its default dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine does not run its default dodge.
function script.on_dodge_2() end

--- Plays the monster's death animation and effects.
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

--- Makes the monster struggle while it is held by the player.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Ends the throw when the monster lands.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	return 1
end

--- Staggers the monster and keeps it stunned until the stun ends.
function script.on_stun()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames(12)
	monster.set_motion("気絶", -1)
	reaction.wait_for_stun_end()
end

return script
