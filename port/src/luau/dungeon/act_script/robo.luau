--!strict
-- dungeon/act_script/robo.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_125c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 100 then
		action.play_motion("右手攻撃", -1, 6, "arm")
		result = action.get_motion_progress("arm") or result
		if result >= arg0 and result <= arg1 then
			var4 = action.get_button_history() or var4
			if var4 ~= 0 then
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
		if result >= arg2 and result <= arg3 then
			var4 = action.get_button_history() or var4
			if var4 ~= 0 then
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

--- Helper function.
local function helper_2fd8()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 100 then
		if global0 == 0 then
			action.play_motion("右手攻撃", -1, 6, "arm")
		else
			action.play_motion("左手攻撃", -1, 6, "arm")
		end
		status = action.get_motion_status("arm") or status
		result = action.get_motion_progress("arm") or result
		if result > vm.f32(0.3) and result < vm.f32(0.4) then
			action.fire_ridepod_weapon(global0)
		end
		if status == 4 then
			action.set_program_value(0)
			if global0 == 0 then
				global0 = 1
			else
				global0 = 0
			end
		end
		return
	end
end

--- Helper function.
local function helper_1a3c()
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
			global1 = 30
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 102 then
		if global1 > 0 then
			global1 = global1 - 1
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

--- Helper function.
local function helper_20c8()
	local prog: s32 = 0
	local var2: s32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	var2 = action.get_button_state_2(56) or var2
	if prog == 100 then
		action.play_motion("攻撃１", -1, 4, "arm")
		action.set_program_value(101)
		global1 = 0
		return
	end
	if prog == 101 then
		if var2 == 0 then
			action.set_program_value(0)
			return
		else
			global1 = vm.i32(global1 + 1)
			if global1 >= 3 then
				global1 = 0
				action.fire_ridepod_weapon(0)
			end
		end
		return
	end
end

--- Helper function.
local function helper_24ac()
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
			global1 = 15
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 102 then
		if global1 > 0 then
			global1 = global1 - 1
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

--- Helper function.
local function helper_2b50()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 100 then
		if global0 == 0 then
			action.play_motion("右手攻撃", -1, 6, "arm")
		else
			action.play_motion("左手攻撃", -1, 6, "arm")
		end
		status = action.get_motion_status("arm") or status
		result = action.get_motion_progress("arm") or result
		if result > vm.f32(0.3) and result < vm.f32(0.4) then
			action.fire_ridepod_weapon(global0)
		end
		if status == 4 then
			action.set_program_value(0)
			if global0 == 0 then
				global0 = 1
			else
				global0 = 0
			end
		end
		return
	end
end

--- Helper function.
local function helper_37d4()
	local prog: s32 = 0
	local var2: s32 = 0
	var2 = action.get_button_state_2(54) or var2
	prog = action.get_program_value() or prog
	action.run_ridepod_movement(0)
	action.set_menu_allowed(0)
	if prog == 900 then
		action.play_motion("ガード", -1, 2, "arm")
		action.set_guarding(1)
		if var2 == 0 then
			action.set_guarding(0)
			action.set_program_value(0)
		end
		return
	end
end

--- Helper function.
local function helper_3a20()
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

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	local attack_type: s32 = 0
	local move_type: s32 = 0
	action.reset_script_entries_0()
	global0 = 0
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

--- Runs the character's normal behaviour.
function script.loop()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local attack_type: s32 = 0
	local move_type: s32 = 0
	local found: s32 = 0
	local attack_type_2: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		var0 = action.get_button_state_2(50) or var0
		var1 = action.get_button_state_2(54) or var1
		if prog >= 100 and prog < 199 then
			attack_type = action.get_attack_type() or attack_type
			if attack_type == 0 then
				helper_125c(vm.f32(0.462), 0.5, vm.f32(0.341), vm.f32(0.386))
			end
			if attack_type == 20 then
				helper_125c(vm.f32(0.476), vm.f32(0.529), vm.f32(0.45), 0.5)
			end
			if attack_type == 50 then
				helper_125c(vm.f32(0.462), vm.f32(0.538), vm.f32(0.386), vm.f32(0.455))
			end
			if attack_type == 60 then
				helper_125c(vm.f32(0.6), vm.f32(0.68), vm.f32(0.72), vm.f32(0.9))
			end
			if attack_type == 80 then
				helper_125c(vm.f32(0.65), vm.f32(0.7), vm.f32(0.65), vm.f32(0.7))
			end
			if attack_type == 10 then
				helper_2fd8()
			end
			if attack_type == 70 then
				helper_1a3c()
			end
			if attack_type == 30 then
				helper_20c8()
			end
			if attack_type == 40 then
				helper_24ac()
			end
			if attack_type == 90 then
				helper_2b50()
			end
		end
		if prog >= 900 and prog < 999 then
			helper_37d4()
		end
		if prog >= 1000 and prog < 1099 then
			helper_3a20()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_ridepod_movement(1)
			move_type = action.get_move_type() or move_type
			if var0 ~= 0 then
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
			if var1 ~= 0 then
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

--- Reacts to a small hit.
function script.on_small_damage()
	action.set_guarding(0)
	action.set_program_value(0)
	vm.wait()
end

--- Reacts to a large hit.
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
	helper_bac4ec65(6)
	action.set_program_value(0)
end

--- Follows up a melee hit that the character has landed.
function script.on_melee_hit()
	action.set_program_value(0)
end

return script
