--!strict
--- Action script that drives Max's weapon combos, gun aiming, guarding, catching and throwing.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local movement = require("@lib/action/movement")
local timing = require("@lib/action/timing")

local weapon_model_number: s32 = 0
local shot_interval_counter: s32 = 0

--- Clears the guarding state.
local function stop_guarding()
	action.set_guarding(0)
end

--- Runs the weapon combo chain for the weapon with model number 0, advancing the program value from one swing to the next.
local function perform_weapon_combo_model_0()
	local has_button_history: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local motion_progress: f32 = 0
	local charge_steps: s32 = 0
	local stick_alignment: f32 = 0
	program_value = action.get_program_value() or program_value
	action.get_button_state_2(50)
	if program_value == 100 then
		action.play_motion("5連続攻撃1", -1, 2)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.05) and motion_progress <= vm.f32(0.4) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.714) and motion_progress <= 1.0 then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps > 8 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if motion_progress >= vm.f32(0.33) and motion_progress <= vm.f32(0.45) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃2", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 101 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.409) then
			action.set_move_impulse(0.93, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.464) and motion_progress <= vm.f32(0.545) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				stick_alignment = action.get_stick_facing_alignment() or stick_alignment
				if stick_alignment > vm.f32(0.6) then
					action.play_motion("3段目", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5連続攻撃3", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(program_value + 1)
					action.reset_button_history()
					action.set_murderous(0, 3)
				end
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 102 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= 0.375 then
			action.set_move_impulse(0.63, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.675) and motion_progress <= 1.0 then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if motion_progress >= 0.5 and motion_progress <= vm.f32(0.55) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃4", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 103 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.339) then
			action.set_move_impulse(0.787, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.47) and motion_progress <= vm.f32(0.522) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃5", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 104 then
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.24) then
			action.set_move_impulse(0.85, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.7) and motion_progress <= 1.0 then
			action.set_move_impulse(0.4, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 105 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.8) then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Runs the weapon combo chain for the weapon with model number 1, advancing the program value from one swing to the next.
local function perform_weapon_combo_model_1()
	local has_button_history: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local motion_progress: f32 = 0
	local charge_steps: s32 = 0
	local stick_alignment: f32 = 0
	program_value = action.get_program_value() or program_value
	action.get_button_state_2(50)
	if program_value == 100 then
		action.play_motion("5連続攻撃1", -1, 2)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.05) and motion_progress <= vm.f32(0.267) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.711) and motion_progress <= 1.0 then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.41) and motion_progress < vm.f32(0.44) then
			action.shake_camera(4.0, 8)
		end
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps > 8 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if motion_progress >= vm.f32(0.45) and motion_progress <= vm.f32(0.67) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃2", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 101 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.22) then
			action.set_move_impulse(0.93, 0.0, 1)
		end
		if motion_progress >= 0.5 and motion_progress <= vm.f32(0.65) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				stick_alignment = action.get_stick_facing_alignment() or stick_alignment
				if stick_alignment > vm.f32(0.6) then
					action.play_motion("3段目", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5連続攻撃3", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(program_value + 1)
					action.reset_button_history()
					action.set_murderous(0, 3)
				end
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 102 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.23) then
			action.set_move_impulse(0.63, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.966) and motion_progress <= 1.0 then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if motion_progress >= 0.5 and motion_progress <= vm.f32(0.6) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃4", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 103 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.15) and motion_progress <= vm.f32(0.406) then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.41) and motion_progress < vm.f32(0.44) then
			action.shake_camera(5.0, 10)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 105 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= 0.25 then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Runs the weapon combo chain for the weapon with model number 2, advancing the program value from one swing to the next.
local function perform_weapon_combo_model_2()
	local has_button_history: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local motion_progress: f32 = 0
	local charge_steps: s32 = 0
	local stick_alignment: f32 = 0
	program_value = action.get_program_value() or program_value
	action.get_button_state_2(50)
	if program_value == 100 then
		action.play_motion("5連続攻撃1", -1, 2)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.05) and motion_progress <= vm.f32(0.267) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps > 8 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if motion_progress >= vm.f32(0.52) and motion_progress <= vm.f32(0.67) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃2", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 101 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.42) then
			action.set_move_impulse(0.93, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.6) and motion_progress <= vm.f32(0.7) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				stick_alignment = action.get_stick_facing_alignment() or stick_alignment
				if stick_alignment > vm.f32(0.6) then
					action.play_motion("3段目", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5連続攻撃3", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(program_value + 1)
					action.reset_button_history()
					action.set_murderous(0, 3)
				end
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 102 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.36) then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		if motion_progress >= 0.5 and motion_progress <= vm.f32(0.65) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃4", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 103 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.35) then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.6) and motion_progress <= vm.f32(0.7) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5連続攻撃5", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(program_value + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 104 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.34) and motion_progress <= vm.f32(0.6) then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 105 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.05) and motion_progress <= vm.f32(0.236) then
			action.set_move_impulse(1.0, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.236) and motion_progress <= 0.5 then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Aims the gun and fires a single shot each time fire is pressed.
local function aim_and_fire_gun()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local is_fire_pressed: s32 = 0
	local is_aim_held: s32 = 0
	local motion_progress: f32 = 0
	is_fire_pressed = action.get_button_state_2(56) or is_fire_pressed
	is_aim_held = action.get_button_state_2(53) or is_aim_held
	program_value = action.get_program_value() or program_value
	action.set_gun_aimed()
	if program_value == 800 then
		action.run_aim_movement("銃狙う", "銃回転")
		if is_aim_held ~= 0 then
			if is_fire_pressed ~= 0 then
				action.play_motion("発砲", -1, 6)
				action.set_murderous(1, 3)
				action.set_program_value(program_value + 1)
			end
		else
			action.set_program_value(0)
		end
		return
	end
	if program_value == 801 then
		action.play_motion("発砲", -1, 6)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress > vm.f32(0.1) and motion_progress < vm.f32(0.2) then
			action.fire_shot(6, "n_gun", 2, 5)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.play_motion("銃狙う", -1, 4)
			action.set_program_value(program_value - 1)
		end
	end
end

--- Aims the gun and fires repeated shots at a fixed interval while fire is held.
local function aim_and_fire_machine_gun()
	local program_value: s32 = 0
	local is_fire_pressed: s32 = 0
	local is_aim_held: s32 = 0
	is_fire_pressed = action.get_button_state_2(56) or is_fire_pressed
	is_aim_held = action.get_button_state_2(53) or is_aim_held
	program_value = action.get_program_value() or program_value
	action.set_gun_aimed()
	if program_value == 820 then
		action.run_aim_movement("銃狙う", "銃回転")
		if is_aim_held ~= 0 then
			if is_fire_pressed ~= 0 then
				action.play_motion("機関銃", -1, 4)
				action.set_murderous(1, 3)
				shot_interval_counter = 0
				action.set_program_value(program_value + 1)
			end
		else
			action.set_program_value(0)
		end
		return
	end
	if program_value == 821 then
		action.play_motion("機関銃", -1, 4)
		shot_interval_counter = vm.i32(shot_interval_counter + 1)
		if shot_interval_counter >= 3 then
			shot_interval_counter = 0
			action.fire_shot(6, "n_gun", 2, 5)
		end
		if is_aim_held == 0 or is_fire_pressed == 0 then
			action.set_program_value(820)
		end
	end
end

--- Aims the gun and fires a single shot, then pauses briefly before aiming again.
local function aim_and_fire_gun_with_recovery()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local is_fire_pressed: s32 = 0
	local is_aim_held: s32 = 0
	local motion_progress: f32 = 0
	is_fire_pressed = action.get_button_state_2(56) or is_fire_pressed
	is_aim_held = action.get_button_state_2(53) or is_aim_held
	program_value = action.get_program_value() or program_value
	action.set_gun_aimed()
	if program_value == 840 then
		action.run_aim_movement("銃狙う", "銃回転")
		if is_aim_held ~= 0 then
			if is_fire_pressed ~= 0 then
				action.play_motion("発砲", -1, 6)
				action.set_murderous(1, 3)
				action.set_program_value(program_value + 1)
			end
		else
			action.set_program_value(0)
		end
		return
	end
	if program_value == 841 then
		action.play_motion("発砲", -1, 6)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress > vm.f32(0.1) and motion_progress < vm.f32(0.2) then
			action.fire_shot(6, "n_gun", 2, 5)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.play_motion("銃狙う", -1, 4)
			timing.wait_frames(6)
			action.set_program_value(program_value - 1)
		end
	end
end

--- Runs the guard stance, catches a nearby object and throws it.
local function run_guard_catch_and_throw()
	local is_motion_finished: s32 = 0
	local program_value: s32 = 0
	local is_attack_held: s32 = 0
	local is_catch_pressed: s32 = 0
	local is_guard_held: s32 = 0
	local catch_progress: f32 = 0
	local held_object_type: s32 = 0
	local throw_progress: f32 = 0
	is_attack_held = action.get_button_state_2(50) or is_attack_held
	is_catch_pressed = action.get_button_state_2(56) or is_catch_pressed
	is_guard_held = action.get_button_state_2(54) or is_guard_held
	program_value = action.get_program_value() or program_value
	if program_value == 900 then
		action.play_motion("ガード入り", -1, 6)
		action.set_guarding(1)
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(program_value + 1)
		end
		return
	end
	if program_value == 901 then
		action.run_aim_movement("ガードループ", "ガードばたばた")
		if is_catch_pressed ~= 0 then
			action.play_motion("持ち上げ", -1, 2)
			action.set_guarding(0)
			action.set_program_value(program_value + 1)
			action.set_invulnerable_time(10)
			print("-- CATCH --\n")
		end
		if is_guard_held == 0 then
			action.set_guarding(0)
			action.set_program_value(0)
		end
		return
	end
	if program_value == 902 then
		action.play_motion("持ち上げ", -1, 2)
		catch_progress = action.get_motion_progress() or catch_progress
		if catch_progress >= vm.f32(0.14) and catch_progress < vm.f32(0.233) then
			action.catch_or_kick("nage")
		end
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			held_object_type = action.get_held_object_type() or held_object_type
			if held_object_type == 3 or held_object_type == 4 then
				action.set_program_value(program_value + 1)
			else
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 903 then
		action.run_carry_movement()
		if is_attack_held ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(program_value + 1)
			action.turn_toward_target(40.0, 2.0)
			return
		end
		return
	end
	if program_value == 904 then
		action.play_motion("投げ", -1, 6)
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.315) then
			action.release_held_object(1)
		end
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(0)
		end
		return
	end
end

--- Catches a nearby object without guarding first and throws it.
local function catch_and_throw_from_standing()
	local is_motion_finished: s32 = 0
	local program_value: s32 = 0
	local is_attack_held: s32 = 0
	local catch_progress: f32 = 0
	local held_object_type: s32 = 0
	local throw_progress: f32 = 0
	is_attack_held = action.get_button_state_2(50) or is_attack_held
	program_value = action.get_program_value() or program_value
	print("CATH!!!!!!!\n")
	if program_value == 1100 then
		action.play_motion("持ち上げ", -1, 6)
		action.set_program_value(program_value + 1)
		action.set_invulnerable_time(10)
	end
	if program_value == 1101 then
		action.play_motion("持ち上げ", -1, 2)
		catch_progress = action.get_motion_progress() or catch_progress
		print("wait =", vm.float(catch_progress), "\n")
		if catch_progress >= vm.f32(0.14) and catch_progress < vm.f32(0.233) then
			action.catch_or_kick("nage")
		end
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			held_object_type = action.get_held_object_type() or held_object_type
			if held_object_type == 3 or held_object_type == 4 then
				action.set_program_value(program_value + 1)
				return
			end
			action.set_program_value(0)
		end
		return
	end
	if program_value == 1102 then
		action.run_carry_movement()
		if is_attack_held ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(program_value + 1)
			action.turn_toward_target(40.0, 2.0)
		end
		return
	end
	if program_value == 1103 then
		action.play_motion("投げ", -1, 6)
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.315) then
			action.release_held_object(1)
		end
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded and needs no setup.
function script.setup() end

--- Registers the collision frames, weapon damage windows and trails for the equipped weapon.
function script.init()
	weapon_model_number = 0
	weapon_model_number = action.get_weapon_model_number() or weapon_model_number
	action.add_object_frame(0, "dcol00")
	action.add_object_frame(1, "ef00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(5, "nage")
	action.add_object_frame(6, "gun")
	if weapon_model_number == 0 then
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.0, "5連続攻撃1", 0.15, 0.8)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃2", 0.4, 0.5)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃3", 0.375, 0.47)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.15, "5連続攻撃4", 0.33, 0.443)
		action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.2, "5連続攻撃5", 0.3, 0.4)
		action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.0, "3段目", 0.45, 0.55)
	end
	if weapon_model_number == 1 then
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃1", 0.35, 0.45)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.15, "5連続攻撃2", 0.32, 0.48)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.25, "5連続攻撃3", 0.26, 0.4)
		action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.35, "5連続攻撃4", 0.37, 0.44)
		action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.2, "3段目", 0.29, 0.41)
	end
	if weapon_model_number == 2 then
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.0, "5連続攻撃1", 0.37, 0.52)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃2", 0.38, 0.5)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃3", 0.36, 0.5)
		action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.13, "5連続攻撃4", 0.36, 0.5)
		action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.16, "5連続攻撃5", 0.31, 0.71)
		action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.1, "3段目", 0.44, 0.52)
	end
	action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.5, 0.85)
	action.add_motion_damage("dcol00", "", "ユリス溜め攻撃", 13.0, 1.6, "ため攻撃", 0.24, 0.52)
	action.add_motion_damage("keri_R", "", "ユリス弱蹴り", 4.0, 1.0, "ダウン･蹴り", 0.35, 0.45)
	if weapon_model_number == 0 then
		action.add_sword_effect(0, "5連続攻撃1", 0.15, 0.22, "dcol00", "dcol01", 77, 12, 10)
		action.add_sword_effect(0, "5連続攻撃2", 0.23, 0.26, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5連続攻撃3", 0.27, 0.29, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5連続攻撃4", 0.33, 0.36, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "5連続攻撃5", 0.26, 0.29, "dcol00", "dcol01", 77, 12, 15)
		action.add_sword_effect(0, "3段目", 0.4, 0.45, "dcol00", "dcol01", 77, 12, 12)
	end
	if weapon_model_number == 1 then
		action.add_sword_effect(0, "5連続攻撃1", 0.28, 0.32, "dcol00", "dcol01", 77, 8, 8)
		action.add_sword_effect(0, "5連続攻撃2", 0.25, 0.32, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5連続攻撃3", 0.21, 0.24, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5連続攻撃4", 0.28, 0.31, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "3段目", 0.2, 0.25, "dcol00", "dcol01", 77, 12, 12)
	end
	if weapon_model_number == 2 then
		action.add_sword_effect(0, "5連続攻撃1", 0.37, 0.45, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "5連続攻撃2", 0.24, 0.31, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5連続攻撃3", 0.26, 0.33, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5連続攻撃4", 0.23, 0.27, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5連続攻撃5", 0.22, 0.28, "dcol00", "dcol01", 77, 12, 15)
		action.add_sword_effect(0, "3段目", 0.28, 0.35, "dcol00", "dcol01", 77, 12, 13)
	end
	action.add_sword_effect(0, "中距離攻撃", 0.28, 0.32, "dcol00", "dcol01", 77, 10, 16)
	action.set_charge_effect_object(0, 2)
end

--- Releases guarding and any held object when the character is reset.
function script.reset()
	stop_guarding()
	action.release_held_object(0)
	action.throw_held_item()
	print("RESET SCRIPT RUN !!\n")
end

--- Reads the buttons each frame and dispatches to the combo, gun, guard, catch and item programs.
function script.loop()
	local program_value: s32 = 0
	local is_attack_held: s32 = 0
	local is_guard_held: s32 = 0
	local is_aim_held: s32 = 0
	local is_item_pressed: s32 = 0
	local is_battle_paused: s32 = 0
	local is_stick_pointing_back_in_combo: s32 = 0
	local combo_sub_weapon_item: s32 = 0
	local combo_sub_weapon_attack_type: s32 = 0
	local is_stick_pointing_back: s32 = 0
	local stick_alignment: f32 = 0
	local target_distance: f32 = 0
	local target_status: s32 = 0
	local idle_sub_weapon_item: s32 = 0
	local idle_sub_weapon_attack_type: s32 = 0
	local held_object_type: s32 = 0
	local item_action: s32 = 0
	local charge_steps: s32 = 0
	action.set_program_value(0)
	while true do
		program_value = action.get_program_value() or program_value
		is_attack_held = action.get_button_state_2(50) or is_attack_held
		is_guard_held = action.get_button_state_2(54) or is_guard_held
		is_aim_held = action.get_button_state_2(53) or is_aim_held
		is_item_pressed = action.get_button_state_2(51) or is_item_pressed
		is_battle_paused = action.is_battle_paused_2(8192) or is_battle_paused
		if is_battle_paused ~= 0 then
			while true do
				action.run_movement()
				vm.wait()
			end
		end
		if program_value >= 100 and program_value < 199 then
			if weapon_model_number == 0 then
				perform_weapon_combo_model_0()
			end
			if weapon_model_number == 1 then
				perform_weapon_combo_model_1()
			end
			if weapon_model_number == 2 then
				perform_weapon_combo_model_2()
			end
			action.apply_slow_status()
			if is_attack_held ~= 0 then
				is_stick_pointing_back_in_combo = action.is_stick_pointing_back() or is_stick_pointing_back_in_combo
				if is_stick_pointing_back_in_combo ~= 0 then
					action.set_program_value(1300)
				end
			end
			if is_aim_held ~= 0 then
				combo_sub_weapon_item = action.get_equipped_item(1) or combo_sub_weapon_item
				if combo_sub_weapon_item > 0 then
					combo_sub_weapon_attack_type = action.get_sub_weapon_attack_type() or combo_sub_weapon_attack_type
					if combo_sub_weapon_attack_type == 0 then
						action.set_program_value(800)
					end
					if combo_sub_weapon_attack_type == 30 then
						action.set_program_value(820)
					end
					if combo_sub_weapon_attack_type == 10 then
						action.set_program_value(840)
					end
				end
			end
			if is_guard_held ~= 0 then
				program_value = 900
				action.set_program_value(program_value)
			end
		end
		if program_value >= 200 and program_value < 299 then
			attack.max_mid_range_attack()
		end
		if program_value >= 1200 and program_value < 1299 then
			attack.max_charge_attack()
		end
		if program_value >= 1300 and program_value < 1399 then
			movement.max_backflip_dodge()
			program_value = 0
			is_attack_held = 0
		end
		if program_value >= 300 and program_value < 399 then
			action.turn_toward_target(40.0, 2.0)
			attack.max_kick_downed_enemy()
		end
		if program_value >= 800 and program_value < 819 then
			aim_and_fire_gun()
			action.apply_slow_status()
		end
		if program_value >= 820 and program_value < 839 then
			aim_and_fire_machine_gun()
			action.apply_slow_status()
		end
		if program_value >= 840 and program_value < 859 then
			aim_and_fire_gun_with_recovery()
			action.apply_slow_status()
		end
		if program_value >= 900 and program_value < 999 then
			run_guard_catch_and_throw()
			action.apply_slow_status()
		end
		if program_value >= 1000 and program_value < 1099 then
			attack.throw_item()
			action.apply_slow_status()
		end
		if program_value >= 1100 and program_value < 1199 then
			catch_and_throw_from_standing()
			action.apply_slow_status()
		end
		program_value = action.get_program_value() or program_value
		if program_value == 0 then
			action.run_movement()
			if is_attack_held ~= 0 then
				is_stick_pointing_back = action.is_stick_pointing_back() or is_stick_pointing_back
				if is_stick_pointing_back ~= 0 then
					program_value = 1300
				else
					stick_alignment = action.get_stick_facing_alignment() or stick_alignment
					target_distance = action.get_target_distance() or target_distance
					if stick_alignment > vm.f32(0.85) and (target_distance > 40.0 and target_distance < 100.0) then
						action.turn_toward_target(40.0, 2.0)
						program_value = 200
						action.set_murderous(0, 3)
					else
						target_status = action.get_target_status() or target_status
						if target_status == 1 and target_distance < 28.0 then
							action.turn_toward_target(40.0, 2.0)
							program_value = 300
						else
							action.turn_toward_target(40.0, 2.0)
							action.set_murderous(0, 3)
							program_value = 100
						end
					end
				end
				action.reset_button_history()
			end
			if is_aim_held ~= 0 then
				idle_sub_weapon_item = action.get_equipped_item(1) or idle_sub_weapon_item
				if idle_sub_weapon_item > 0 then
					idle_sub_weapon_attack_type = action.get_sub_weapon_attack_type() or idle_sub_weapon_attack_type
					if idle_sub_weapon_attack_type == 0 or idle_sub_weapon_attack_type == 11 or idle_sub_weapon_attack_type == 20 then
						program_value = 800
					end
					if idle_sub_weapon_attack_type == 30 then
						program_value = 820
					end
					if idle_sub_weapon_attack_type == 10 then
						program_value = 840
					end
				end
			end
			if is_guard_held ~= 0 then
				program_value = 900
			end
			if (if is_guard_held ~= 0 then is_attack_held else 0) ~= 0 then
				program_value = 1100
			end
			if is_item_pressed ~= 0 then
				held_object_type = action.get_held_object_type() or held_object_type
				if held_object_type == 0 then
					item_action = action.use_active_item() or item_action
					if item_action == 3 then
						program_value = 1100
					end
					if item_action == 2 then
						program_value = 1000
					end
				end
			end
			charge_steps = action.get_charge_steps() or charge_steps
			if charge_steps > 12 then
				action.reset_charge_steps()
				program_value = 1200
			end
			action.set_program_value(program_value)
		end
		vm.wait()
	end
end

--- Knocks the character back a short way and plays the flinch motion.
function script.on_small_damage()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	timing.wait_frames(4)
	action.set_program_value(0)
end

--- Holds the character in the damage pose until the binding status conditions clear.
function script.on_hold()
	local status_conditions: s32 = 0
	stop_guarding()
	action.start_knockback(0.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 6)
	status_conditions = 40
	while bit32.band(status_conditions, 40) ~= 0 do
		action.set_menu_allowed(1)
		vm.wait()
		status_conditions = action.get_status_conditions() or status_conditions
	end
	action.set_program_value(0)
end

--- Knocks the character down, then plays the get-up motion.
function script.on_large_damage()
	action.start_knockback(4.5, 0.04, 26)
	action.face_against_knockback()
	action.release_held_object(0)
	action.play_motion("吹っ飛び", -1, 6)
	timing.wait_motion_finished()
	timing.wait_frames(10)
	action.play_motion("起き上がり", -1, 6)
	timing.wait_motion_finished()
	timing.wait_frames(2)
	action.set_program_value(0)
end

--- Plays the post-guard motion after a melee hit lands.
function script.on_melee_hit()
	local is_motion_finished: s32 = 0
	action.set_move_impulse(0.0, 0.0, 0)
	action.play_motion("ガード後", -1, 2)
	is_motion_finished = 0
	while is_motion_finished == 0 do
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
	end
end

--- Plays the death motion.
function script.on_death()
	stop_guarding()
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	action.set_program_value(0)
end

--- Returns to the battle stance after landing.
function script.on_land()
	action.release_held_object(0)
	timing.wait_motion_finished()
	action.play_motion("バトル立ち")
	vm.wait()
end

return script
