--!strict
--- Drives the Ridepod robot's actions: melee combo, ranged weapon fire, guard and kick.

local vm = require("@lib/vm")
local timing = require("@lib/action/timing")

local next_arm: s32 = 0
local fire_counter: s32 = 0

--- Runs the robot's two-arm melee combo, advancing a hit when the attack button is pressed in the given timing windows.
local function run_melee_combo(first_window_start: f32, first_window_end: f32, second_window_start: f32, second_window_end: f32)
	local attack_queued: s32 = 0
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 100 then
		action.play_motion("右手攻撃", -1, 6, "arm")
		result = action.get_motion_progress("arm") or result
		if result >= first_window_start and result <= first_window_end then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("左手攻撃", -1, 6, "arm")
				action.set_program_value(prog + 1)
				action.reset_button_history()
			end
		else
			status = action.get_motion_status("arm") or status
			if status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 101 then
		result = action.get_motion_progress("arm") or result
		if result >= second_window_start and result <= second_window_end then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("両手攻撃", -1, 6, "arm")
				action.set_program_value(prog + 1)
				action.reset_button_history()
			end
		else
			status = action.get_motion_status("arm") or status
			if status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 102 then
		status = action.get_motion_status("arm") or status
		if status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Fires one shot from the robot's weapon on the arm whose turn it is, then swaps arms for the next shot, for the first attack type.
local function run_alternating_arm_shot()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 100 then
		if next_arm == 0 then
			action.play_motion("右手攻撃", -1, 6, "arm")
		else
			action.play_motion("左手攻撃", -1, 6, "arm")
		end
		status = action.get_motion_status("arm") or status
		result = action.get_motion_progress("arm") or result
		if result > vm.f32(0.3) and result < vm.f32(0.4) then
			action.fire_ridepod_weapon(next_arm)
		end
		if status == 4 then
			action.set_program_value(0)
			if next_arm == 0 then
				next_arm = 1
			else
				next_arm = 0
			end
		end
		return
	end
end

--- Winds up and fires the robot's weapon for a fixed number of frames.
local function run_timed_burst_fire()
	local prog: s32 = 0
	local status: s32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	action.get_button_state_2(56)
	if prog == 100 then
		action.play_motion("攻撃１in", -1, 6, "arm")
		action.set_program_value(prog + 1)
		return
	end
	if prog == 101 then
		status = action.get_motion_status("arm") or status
		if status == 4 then
			action.play_motion("攻撃１", -1, 0, "arm")
			fire_counter = 30
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 102 then
		if fire_counter > 0 then
			fire_counter = fire_counter - 1
			action.fire_ridepod_weapon(0)
		else
			action.play_motion("攻撃１out", -1, 6, "arm")
			action.set_program_value(110)
		end
		return
	end
	if prog == 110 then
		status = action.get_motion_status("arm") or status
		if status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Fires the robot's weapon every few frames while the fire button is held.
local function run_rapid_fire()
	local prog: s32 = 0
	local fire_button: s32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	fire_button = action.get_button_state_2(56) or fire_button
	if prog == 100 then
		action.play_motion("攻撃１", -1, 4, "arm")
		action.set_program_value(101)
		fire_counter = 0
		return
	end
	if prog == 101 then
		if fire_button == 0 then
			action.set_program_value(0)
			return
		else
			fire_counter = vm.i32(fire_counter + 1)
			if fire_counter >= 3 then
				fire_counter = 0
				action.fire_ridepod_weapon(0)
			end
		end
		return
	end
end

--- Winds up and fires the robot's weapon for a short burst.
local function run_short_burst_fire()
	local prog: s32 = 0
	local status: s32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	action.get_button_state_2(56)
	if prog == 100 then
		action.play_motion("攻撃１in", -1, 6, "arm")
		action.set_program_value(prog + 1)
		return
	end
	if prog == 101 then
		status = action.get_motion_status("arm") or status
		if status == 4 then
			action.play_motion("攻撃１r", -1, 2, "arm")
			fire_counter = 15
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 102 then
		if fire_counter > 0 then
			fire_counter = fire_counter - 1
			action.fire_ridepod_weapon(0)
		else
			action.play_motion("攻撃１out", -1, 6, "arm")
			action.set_program_value(110)
		end
		return
	end
	if prog == 110 then
		status = action.get_motion_status("arm") or status
		if status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Fires one shot from the robot's weapon on the arm whose turn it is, then swaps arms for the next shot.
local function run_alternating_single_shot()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 100 then
		if next_arm == 0 then
			action.play_motion("右手攻撃", -1, 6, "arm")
		else
			action.play_motion("左手攻撃", -1, 6, "arm")
		end
		status = action.get_motion_status("arm") or status
		result = action.get_motion_progress("arm") or result
		if result > vm.f32(0.3) and result < vm.f32(0.4) then
			action.fire_ridepod_weapon(next_arm)
		end
		if status == 4 then
			action.set_program_value(0)
			if next_arm == 0 then
				next_arm = 1
			else
				next_arm = 0
			end
		end
		return
	end
end

--- Holds the robot's guard while the guard button is held.
local function run_guard()
	local prog: s32 = 0
	local guard_button: s32 = 0
	guard_button = action.get_button_state_2(54) or guard_button
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 900 then
		action.play_motion("ガード", -1, 2, "arm")
		action.set_guarding(1)
		if guard_button == 0 then
			action.set_guarding(0)
			action.set_program_value(0)
		end
		return
	end
end

--- Kicks and catches or hits a nearby object.
local function run_kick()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 1000 then
		action.play_motion("蹴り", -1, 6, "leg")
		vm.wait()
		result = action.get_motion_progress("leg") or result
		if result > vm.f32(0.35) then
			action.catch_or_kick("keri_R", 1)
			action.set_program_value(1001)
		end
		return
	end
	if prog == 1001 then
		status = action.get_motion_status("leg") or status
		if status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the robot's attack damage for its attack type and picks its idle motion for its movement type.
function script.init()
	local attack_type: s32 = 0
	local move_type: s32 = 0
	action.reset_script_entries_0()
	next_arm = 0
	attack_type = action.get_attack_type() or attack_type
	if attack_type == 0 then
		action.add_motion_damage("dcol00", "", "ロボパンチ１", 5.0, 1.0, "右手攻撃", 0.36, 0.44, "arm")
		action.add_motion_damage("dcol01", "", "ロボパンチ１", 5.0, 1.1, "左手攻撃", 0.25, 0.36, "arm")
		action.add_motion_damage("dcol00", "", "ロボパンチ１", 6.0, 1.2, "両手攻撃", 0.38, 0.42, "arm")
	end
	if attack_type == 20 then
		action.add_motion_damage("dcol_r02", "dcol_r00", "サムライソード", 4.0, 1.0, "右手攻撃", 0.31, 0.47, "arm")
		action.add_motion_damage("dcol_l02", "dcol_l00", "サムライソード", 4.0, 1.0, "左手攻撃", 0.34, 0.5, "arm")
		action.add_motion_damage("dcol_r02", "dcol_r00", "サムライソード", 4.0, 1.0, "両手攻撃", 0.35, 0.52, "arm")
		action.add_sword_effect(0, "右手攻撃", 0.3, 0.35, "dcol_r00", "dcol_r02", 77, 10, 16, "arm")
		action.add_sword_effect(0, "左手攻撃", 0.13, 0.16, "dcol_l00", "dcol_l02", 77, 10, 16, "arm")
		action.add_sword_effect(0, "両手攻撃", 0.28, 0.3, "dcol_r00", "dcol_r02", 77, 10, 16, "arm")
	end
	if attack_type == 50 then
		action.add_motion_damage("dcol00", "", "ロボパンチ１", 5.0, 1.0, "右手攻撃", 0.36, 0.44, "arm")
		action.add_motion_damage("dcol01", "", "ロボパンチ１", 5.0, 1.1, "左手攻撃", 0.25, 0.36, "arm")
		action.add_motion_damage("dcol00", "", "ロボパンチ１", 6.0, 1.2, "両手攻撃", 0.38, 0.42, "arm")
	end
	if attack_type == 60 then
		action.add_motion_damage("dcol00", "", "ロボパンチ１", 5.0, 1.0, "右手攻撃", 0.32, 0.407, "arm")
		action.add_motion_damage("dcol01", "", "ロボパンチ１", 5.0, 1.1, "左手攻撃", 0.48, 0.6, "arm")
		action.add_motion_damage("dcol00", "", "ロボパンチ１", 6.0, 1.2, "両手攻撃", 0.3, 0.35, "arm")
	end
	if attack_type == 80 then
		action.add_motion_damage("dcol00", "", "ドリルアーム", 5.0, 1.0, "右手攻撃", 0.27, 0.69, "arm")
		action.add_motion_damage("dcol01", "", "ドリルアーム", 5.0, 1.1, "左手攻撃", 0.27, 0.69, "arm")
		action.add_motion_damage("dcol00", "", "ドリルアーム", 6.0, 1.2, "両手攻撃", 0.32, 0.64, "arm")
	end
	if attack_type == 10 then
		action.add_object_frame(0, "dcol00")
		action.add_object_frame(1, "dcol01")
	end
	move_type = action.get_move_type() or move_type
	if move_type == 1 then
		action.set_default_motion("立ち-足")
	end
	if move_type == 2 then
		action.set_default_motion("立ち-キャタピラ")
	end
end

--- Starts the robot's attack, guard and kick programs from the attack and guard buttons.
function script.loop()
	local attack_button: s32 = 0
	local guard_button: s32 = 0
	local prog: s32 = 0
	local attack_type: s32 = 0
	local move_type: s32 = 0
	local found: s32 = 0
	local attack_type_2: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		attack_button = action.get_button_state_2(50) or attack_button
		guard_button = action.get_button_state_2(54) or guard_button
		if prog >= 100 and prog < 199 then
			attack_type = action.get_attack_type() or attack_type
			if attack_type == 0 then
				run_melee_combo(vm.f32(0.462), 0.5, vm.f32(0.341), vm.f32(0.386))
			end
			if attack_type == 20 then
				run_melee_combo(vm.f32(0.476), vm.f32(0.529), vm.f32(0.45), 0.5)
			end
			if attack_type == 50 then
				run_melee_combo(vm.f32(0.462), vm.f32(0.538), vm.f32(0.386), vm.f32(0.455))
			end
			if attack_type == 60 then
				run_melee_combo(vm.f32(0.6), vm.f32(0.68), vm.f32(0.72), vm.f32(0.9))
			end
			if attack_type == 80 then
				run_melee_combo(vm.f32(0.65), vm.f32(0.7), vm.f32(0.65), vm.f32(0.7))
			end
			if attack_type == 10 then
				run_alternating_arm_shot()
			end
			if attack_type == 70 then
				run_timed_burst_fire()
			end
			if attack_type == 30 then
				run_rapid_fire()
			end
			if attack_type == 40 then
				run_short_burst_fire()
			end
			if attack_type == 90 then
				run_alternating_single_shot()
			end
		end
		if prog >= 900 and prog < 999 then
			run_guard()
		end
		if prog >= 1000 and prog < 1099 then
			run_kick()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_ridepod_movement(1)
			move_type = action.get_move_type() or move_type
			if attack_button ~= 0 then
				found = 0
				if move_type == 1 then
					found = action.catch_or_kick("keri_R", 0) or found
				end
				if found == 0 then
					prog = 100
					action.reset_button_history()
				else
					prog = 1000
				end
			end
			if guard_button ~= 0 then
				attack_type_2 = action.get_attack_type() or attack_type_2
				if attack_type_2 == 0 then
					prog = 900
				end
				if attack_type_2 == 20 then
					prog = 900
				end
				if attack_type_2 == 50 then
					prog = 900
				end
				if attack_type_2 == 60 then
					prog = 900
				end
				if attack_type_2 == 80 then
					prog = 900
				end
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Drops the guard and ends the current program.
function script.on_small_damage()
	action.set_guarding(0)
	action.set_program_value(0)
	vm.wait()
end

--- Knocks the robot back and plays its idle motion for its movement type.
function script.on_large_damage()
	local move_type: s32 = 0
	action.start_knockback(5.0, 0.0, 6)
	action.face_against_knockback()
	action.set_guarding(0)
	move_type = action.get_move_type() or move_type
	if move_type == 1 then
		action.play_motion("立ち-足", -1, 4)
	else
		action.play_motion("立ち-キャタピラ", -1, 4)
	end
	timing.wait_frames(6)
	action.set_program_value(0)
end

--- Ends the current program after a melee hit.
function script.on_melee_hit()
	action.set_program_value(0)
end

return script
