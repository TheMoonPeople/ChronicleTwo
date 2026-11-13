--!strict
--- Player character attack, charge and combo state machines.

local vm = require("@lib/vm")
local timing = vm.module("@lib/action/timing")

local attack = {}

--- Runs Max's charge loop and charged attack state machine.
function attack.max_charge_attack()
	local is_attack_button_held: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local charge_steps: s32 = 0
	local progress: f32 = 0
	program_value = action.get_program_value() or program_value
	is_attack_button_held = action.get_button_state_2(56) or is_attack_button_held
	if program_value == 1200 then
		action.play_motion("ためループ")
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps == 20 then
			action.start_palette_flash(220, 255, 255, 1, 12)
		end
		if charge_steps > 20 then
			action.set_program_value(program_value + 1)
		end
		if charge_steps == 0 then
			action.set_program_value(0)
			timing.wait_frames(2)
		end
		action.run_charge_movement()
		return
	end
	if program_value == 1201 then
		if is_attack_button_held == 0 then
			action.set_invulnerable_time(30)
			action.play_motion("ため攻撃", -1, 6)
			action.get_position()
			action.create_effect_1("ユリス溜め攻撃")
			action.set_program_value(program_value + 1)
		else
			action.run_charge_movement()
		end
		return
	end
	if program_value == 1202 then
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.202) and progress <= vm.f32(0.472) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
			timing.wait_frames(2)
		end
		return
	end
end

--- Plays Max's kick attack against a downed enemy and returns to idle when it ends.
function attack.max_kick_downed_enemy()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 300 then
		action.play_motion("ダウン･蹴り", -1, 6)
		action.set_program_value(program_value + 1)
	end
	if program_value == 301 then
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
			timing.wait_frames(3)
		end
		return
	end
end

--- Runs Max's mid-range attack with a forward lunge and returns to idle.
function attack.max_mid_range_attack()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local progress: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 200 then
		action.play_motion("中距離攻撃", -1, 6)
		action.set_program_value(program_value + 1)
	end
	if program_value == 201 then
		progress = action.get_motion_progress() or progress
		if progress > vm.f32(0.3) and progress < vm.f32(0.4) then
			action.set_move_impulse(6.0, 0.0, 12)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
			timing.wait_frames(6)
		end
		return
	end
end

--- Runs Monica's charge loop and charged attack state machine.
function attack.monica_charge_attack()
	local is_attack_button_held: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local charge_steps: s32 = 0
	local progress: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 1200 then
		action.play_motion("ためループ")
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps == 20 then
			action.start_palette_flash(220, 255, 255, 1, 12)
		end
		if charge_steps > 20 then
			action.set_program_value(program_value + 1)
		end
		if charge_steps == 0 then
			action.set_program_value(0)
			timing.wait_frames(2)
		end
		action.run_charge_movement()
		return
	end
	if program_value == 1201 then
		is_attack_button_held = action.get_button_state_2(56) or is_attack_button_held
		if is_attack_button_held == 0 then
			action.set_invulnerable_time(30)
			action.play_motion("ため攻撃", -1, 6)
			action.create_effect_1("モニカ溜め攻撃")
			action.set_program_value(program_value + 1)
		else
			action.run_charge_movement()
		end
		return
	end
	if program_value == 1202 then
		motion_status = action.get_motion_status() or motion_status
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.12) and progress < vm.f32(0.626) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if progress >= vm.f32(0.626) and progress < vm.f32(0.67) then
			action.shake_camera(6.0, 20)
		end
		if motion_status == 4 then
			action.set_program_value(0)
			timing.wait_frames(2)
		end
		return
	end
end

--- Runs Monica's mid-range attack with a forward lunge and returns to idle.
function attack.monica_mid_range_attack()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local progress: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 200 then
		action.play_motion("中距離攻撃", -1, 6)
		action.set_program_value(program_value + 1)
	end
	if program_value == 201 then
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.137) and progress < vm.f32(0.495) then
			action.set_move_impulse(6.0, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Plays Monica's sword attack against a downed enemy and returns to idle when it ends.
function attack.monica_slash_downed_enemy()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 300 then
		action.play_motion("ダウン･剣", -1, 6)
		action.set_program_value(program_value + 1)
	end
	if program_value == 301 then
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
			timing.wait_frames(3)
		end
		return
	end
end

--- Runs Monica's five-hit sword combo state machine with per-hit lunge and chain windows.
function attack.monica_sword_combo_a()
	local has_button_history: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local progress: f32 = 0
	local charge_steps: s32 = 0
	local stick_alignment: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 100 then
		action.play_motion("5剣1", -1, 6)
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.26) and progress <= vm.f32(0.45) then
			action.set_move_impulse(1.2, 0.0, 1)
		end
		if progress >= vm.f32(0.6) and progress <= 1.0 then
			action.set_move_impulse(0.92, 0.0, 1)
		end
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps > 10 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if progress >= vm.f32(0.45) and progress <= vm.f32(0.63) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣2", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.238) and progress <= vm.f32(0.418) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		if progress >= vm.f32(0.38) and progress <= vm.f32(0.58) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				stick_alignment = action.get_stick_facing_alignment() or stick_alignment
				if stick_alignment > vm.f32(0.6) then
					action.play_motion("ふっとばし", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5剣3", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.39) and progress <= vm.f32(0.53) then
			action.set_move_impulse(2.5, 0.0, 1)
		end
		if progress >= vm.f32(0.64) and progress <= 1.0 then
			action.set_move_impulse(-0.919, 0.0, 1)
		end
		if progress >= vm.f32(0.51) and progress <= vm.f32(0.64) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣4", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.35) and progress <= vm.f32(0.55) then
			action.set_move_impulse(2.0, 0.0, 1)
		end
		if progress >= 0.5 and progress <= vm.f32(0.7) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣5", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.28) and progress <= vm.f32(0.45) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		if progress >= vm.f32(0.609) and progress <= 1.0 then
			action.set_move_impulse(0.57, 0.0, 1)
		end
		if progress >= vm.f32(0.48) and progress <= vm.f32(0.64) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣6", -1, 6)
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
	if program_value == 105 then
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.14) and progress <= vm.f32(0.45) then
			action.set_move_impulse(2.2, 0.0, 1)
		end
		if progress >= vm.f32(0.66) and progress <= 1.0 then
			action.set_move_impulse(0.825, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 105 then
		motion_status = action.get_motion_status() or motion_status
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.1) and progress <= vm.f32(0.4) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Runs Monica's five-hit sword combo state machine with per-hit lunge and chain windows.
function attack.monica_sword_combo_b()
	local has_button_history: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local progress: f32 = 0
	local charge_steps: s32 = 0
	local stick_alignment: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 100 then
		action.play_motion("5剣1", -1, 6)
		progress = action.get_motion_progress() or progress
		if progress >= 0.0 and progress <= vm.f32(0.38) then
			action.set_move_impulse(1.2, 0.0, 1)
		end
		if progress >= vm.f32(0.65) and progress <= 1.0 then
			action.set_move_impulse(0.92, 0.0, 1)
		end
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps > 10 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if progress >= 0.5 and progress <= vm.f32(0.65) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣2", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= 0.0 and progress <= vm.f32(0.19) then
			action.set_move_impulse(1.0, 0.0, 1)
		end
		if progress >= vm.f32(0.39) and progress <= vm.f32(0.51) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				stick_alignment = action.get_stick_facing_alignment() or stick_alignment
				if stick_alignment > vm.f32(0.6) then
					action.play_motion("ふっとばし", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5剣3", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= 0.0 and progress <= vm.f32(0.35) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		if progress >= vm.f32(0.63) and progress <= 1.0 then
			action.set_move_impulse(-0.919, 0.0, 1)
		end
		if progress >= 0.5 and progress <= vm.f32(0.66) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣4", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= 0.0 and progress <= vm.f32(0.36) then
			action.set_move_impulse(1.1, 0.0, 1)
		end
		if progress >= vm.f32(0.37) and progress <= 0.5 then
			action.set_move_impulse(1.4, 0.0, 1)
		end
		if progress >= vm.f32(0.6) and progress <= 1.0 then
			action.set_move_impulse(0.825, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 105 then
		motion_status = action.get_motion_status() or motion_status
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.22) and progress <= vm.f32(0.56) then
			action.set_move_impulse(2.5, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Runs Monica's five-hit sword combo state machine with per-hit lunge and chain windows.
function attack.monica_sword_combo_c()
	local has_button_history: s32 = 0
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local progress: f32 = 0
	local charge_steps: s32 = 0
	local stick_alignment: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 100 then
		action.play_motion("5剣1", -1, 6)
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.309) and progress <= vm.f32(0.394) then
			action.set_move_impulse(4.75, 0.0, 1)
		end
		if progress >= vm.f32(0.647) and progress <= 1.0 then
			action.set_move_impulse(0.92, 0.0, 1)
		end
		charge_steps = action.get_charge_steps() or charge_steps
		if charge_steps > 10 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if progress >= 0.5 and progress <= vm.f32(0.562) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣2", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.238) and progress <= vm.f32(0.418) then
			action.set_move_impulse(2.56, 0.0, 1)
		end
		if progress >= vm.f32(0.476) and progress <= vm.f32(0.529) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				stick_alignment = action.get_stick_facing_alignment() or stick_alignment
				if stick_alignment > vm.f32(0.6) then
					action.play_motion("ふっとばし", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5剣3", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.27) and progress <= vm.f32(0.33) then
			action.set_move_impulse(3.89, 0.0, 1)
		end
		if progress >= vm.f32(0.54) and progress <= 1.0 then
			action.set_move_impulse(-0.919, 0.0, 1)
		end
		if progress >= vm.f32(0.51) and progress <= vm.f32(0.57) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣4", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.291) and progress <= vm.f32(0.423) then
			action.set_move_impulse(2.25, 0.0, 1)
		end
		if progress >= vm.f32(0.609) and progress <= 1.0 then
			action.set_move_impulse(0.57, 0.0, 1)
		end
		if progress >= vm.f32(0.58) and progress <= vm.f32(0.609) then
			has_button_history = action.get_button_history() or has_button_history
			if has_button_history ~= 0 then
				action.play_motion("5剣5", -1, 6)
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
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.225) and progress <= vm.f32(0.637) then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		if progress >= 0.75 and progress <= 1.0 then
			action.set_move_impulse(0.825, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 105 then
		motion_status = action.get_motion_status() or motion_status
		progress = action.get_motion_progress() or progress
		if progress >= 0.0 and progress <= vm.f32(0.6) then
			action.set_move_impulse(2.5, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Plays the first basic attack and returns to idle when it ends.
function attack.run_first_attack()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 100 then
		action.play_motion("攻撃１", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Plays the second basic attack and returns to idle when it ends.
function attack.run_second_attack()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 200 then
		action.play_motion("攻撃２", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Plays the item throw motion and releases the held item at the right point of the motion.
function attack.throw_item()
	local is_finished: s32 = 0
	local program_value: s32 = 0
	local progress: f32 = 0
	program_value = action.get_program_value() or program_value
	if program_value == 1000 then
		action.play_motion("アイテム投げ", -1, 6)
		action.set_program_value(program_value + 1)
	end
	if program_value == 1001 then
		progress = action.get_motion_progress() or progress
		if progress >= vm.f32(0.45) and progress < 0.5 then
			action.throw_held_item()
		end
		is_finished = vm.float_bits(action.is_motion_finished()) or is_finished
		if is_finished ~= 0 then
			action.set_program_value(0)
		end
	end
end

return attack
