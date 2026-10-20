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
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	if prog == 100 then
		action.SetMos("右手攻撃", -1, 6, "arm")
		result = action.NowMosWait("arm") or result
		if result >= arg0 and result <= arg1 then
			var4 = action.GetPadHistory() or var4
			if var4 ~= 0 then
				action.SetMos("左手攻撃", -1, 6, "arm")
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
			end
		else
			status = action.GetMosStatus("arm") or status
			if status == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 101 then
		result = action.NowMosWait("arm") or result
		if result >= arg2 and result <= arg3 then
			var4 = action.GetPadHistory() or var4
			if var4 ~= 0 then
				action.SetMos("両手攻撃", -1, 6, "arm")
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
			end
		else
			status = action.GetMosStatus("arm") or status
			if status == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 102 then
		status = action.GetMosStatus("arm") or status
		if status == 4 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_2fd8()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	if prog == 100 then
		if global0 == 0 then
			action.SetMos("右手攻撃", -1, 6, "arm")
		else
			action.SetMos("左手攻撃", -1, 6, "arm")
		end
		status = action.GetMosStatus("arm") or status
		result = action.NowMosWait("arm") or result
		if result > vm.f32(0.3) and result < vm.f32(0.4) then
			action.Shot(global0)
		end
		if status == 4 then
			action.ProgSet(0)
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
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	action.GetBtn_2(56)
	if prog == 100 then
		action.SetMos("攻撃１in", -1, 6, "arm")
		action.ProgSet(prog + 1)
		return
	end
	if prog == 101 then
		status = action.GetMosStatus("arm") or status
		if status == 4 then
			action.SetMos("攻撃１", -1, 0, "arm")
			global1 = 30
			action.ProgSet(prog + 1)
		end
		return
	end
	if prog == 102 then
		if global1 > 0 then
			global1 = global1 - 1
			action.Shot(0)
		else
			action.SetMos("攻撃１out", -1, 6, "arm")
			action.ProgSet(110)
		end
		return
	end
	if prog == 110 then
		status = action.GetMosStatus("arm") or status
		if status == 4 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_20c8()
	local prog: s32 = 0
	local var2: s32 = 0
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	var2 = action.GetBtn_2(56) or var2
	if prog == 100 then
		action.SetMos("攻撃１", -1, 4, "arm")
		action.ProgSet(101)
		global1 = 0
		return
	end
	if prog == 101 then
		if var2 == 0 then
			action.ProgSet(0)
			return
		else
			global1 = vm.i32(global1 + 1)
			if global1 >= 3 then
				global1 = 0
				action.Shot(0)
			end
		end
		return
	end
end

--- Helper function.
local function helper_24ac()
	local prog: s32 = 0
	local status: s32 = 0
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	action.GetBtn_2(56)
	if prog == 100 then
		action.SetMos("攻撃１in", -1, 6, "arm")
		action.ProgSet(prog + 1)
		return
	end
	if prog == 101 then
		status = action.GetMosStatus("arm") or status
		if status == 4 then
			action.SetMos("攻撃１r", -1, 2, "arm")
			global1 = 15
			action.ProgSet(prog + 1)
		end
		return
	end
	if prog == 102 then
		if global1 > 0 then
			global1 = global1 - 1
			action.Shot(0)
		else
			action.SetMos("攻撃１out", -1, 6, "arm")
			action.ProgSet(110)
		end
		return
	end
	if prog == 110 then
		status = action.GetMosStatus("arm") or status
		if status == 4 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_2b50()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	if prog == 100 then
		if global0 == 0 then
			action.SetMos("右手攻撃", -1, 6, "arm")
		else
			action.SetMos("左手攻撃", -1, 6, "arm")
		end
		status = action.GetMosStatus("arm") or status
		result = action.NowMosWait("arm") or result
		if result > vm.f32(0.3) and result < vm.f32(0.4) then
			action.Shot(global0)
		end
		if status == 4 then
			action.ProgSet(0)
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
	var2 = action.GetBtn_2(54) or var2
	prog = action.ProgGet() or prog
	action.RunRoboMove(0)
	action.SetMenuFlag(0)
	if prog == 900 then
		action.SetMos("ガード", -1, 2, "arm")
		action.SetGuardFlag(1)
		if var2 == 0 then
			action.SetGuardFlag(0)
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_3a20()
	local status: s32 = 0
	local prog: s32 = 0
	local result: f32 = 0
	prog = action.ProgGet() or prog
	if prog == 1000 then
		action.SetMos("蹴り", -1, 6, "leg")
		vm.wait()
		result = action.NowMosWait("leg") or result
		if result > vm.f32(0.35) then
			action.CheckCatch("keri_R", 1)
			action.ProgSet(1001)
		end
		return
	end
	if prog == 1001 then
		status = action.GetMosStatus("leg") or status
		if status == 4 then
			action.ProgSet(0)
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
	action.InitScript_0()
	global0 = 0
	attack_type = action.GetAttkType() or attack_type
	if attack_type == 0 then
		action.SetDmg2("dcol00", "", "ロボパンチ１", 5.0, 1.0, "右手攻撃", 0.36, 0.44, "arm")
		action.SetDmg2("dcol01", "", "ロボパンチ１", 5.0, 1.1, "左手攻撃", 0.25, 0.36, "arm")
		action.SetDmg2("dcol00", "", "ロボパンチ１", 6.0, 1.2, "両手攻撃", 0.38, 0.42, "arm")
	end
	if attack_type == 20 then
		action.SetDmg2("dcol_r02", "dcol_r00", "サムライソード", 4.0, 1.0, "右手攻撃", 0.31, 0.47, "arm")
		action.SetDmg2("dcol_l02", "dcol_l00", "サムライソード", 4.0, 1.0, "左手攻撃", 0.34, 0.5, "arm")
		action.SetDmg2("dcol_r02", "dcol_r00", "サムライソード", 4.0, 1.0, "両手攻撃", 0.35, 0.52, "arm")
		action.SwEffect(0, "右手攻撃", 0.3, 0.35, "dcol_r00", "dcol_r02", 77, 10, 16, "arm")
		action.SwEffect(0, "左手攻撃", 0.13, 0.16, "dcol_l00", "dcol_l02", 77, 10, 16, "arm")
		action.SwEffect(0, "両手攻撃", 0.28, 0.3, "dcol_r00", "dcol_r02", 77, 10, 16, "arm")
	end
	if attack_type == 50 then
		action.SetDmg2("dcol00", "", "ロボパンチ１", 5.0, 1.0, "右手攻撃", 0.36, 0.44, "arm")
		action.SetDmg2("dcol01", "", "ロボパンチ１", 5.0, 1.1, "左手攻撃", 0.25, 0.36, "arm")
		action.SetDmg2("dcol00", "", "ロボパンチ１", 6.0, 1.2, "両手攻撃", 0.38, 0.42, "arm")
	end
	if attack_type == 60 then
		action.SetDmg2("dcol00", "", "ロボパンチ１", 5.0, 1.0, "右手攻撃", 0.32, 0.407, "arm")
		action.SetDmg2("dcol01", "", "ロボパンチ１", 5.0, 1.1, "左手攻撃", 0.48, 0.6, "arm")
		action.SetDmg2("dcol00", "", "ロボパンチ１", 6.0, 1.2, "両手攻撃", 0.3, 0.35, "arm")
	end
	if attack_type == 80 then
		action.SetDmg2("dcol00", "", "ドリルアーム", 5.0, 1.0, "右手攻撃", 0.27, 0.69, "arm")
		action.SetDmg2("dcol01", "", "ドリルアーム", 5.0, 1.1, "左手攻撃", 0.27, 0.69, "arm")
		action.SetDmg2("dcol00", "", "ドリルアーム", 6.0, 1.2, "両手攻撃", 0.32, 0.64, "arm")
	end
	if attack_type == 10 then
		action.SetObj(0, "dcol00")
		action.SetObj(1, "dcol01")
	end
	move_type = action.GetMoveType() or move_type
	if move_type == 1 then
		action.SetDefaultMos("立ち-足")
	end
	if move_type == 2 then
		action.SetDefaultMos("立ち-キャタピラ")
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
	action.ProgSet(0)
	while true do
		prog = action.ProgGet() or prog
		var0 = action.GetBtn_2(50) or var0
		var1 = action.GetBtn_2(54) or var1
		if prog >= 100 and prog < 199 then
			attack_type = action.GetAttkType() or attack_type
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
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunRoboMove(1)
			move_type = action.GetMoveType() or move_type
			if var0 ~= 0 then
				found = 0
				if move_type == 1 then
					found = action.CheckCatch("keri_R", 0) or found
				end
				if found == 0 then
					prog = 100
					action.ResetPadHistory()
				else
					prog = 1000
				end
			end
			if var1 ~= 0 then
				attack_type_2 = action.GetAttkType() or attack_type_2
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
			action.ProgSet(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
function script.on_small_damage()
	action.SetGuardFlag(0)
	action.ProgSet(0)
	vm.wait()
end

--- Reacts to a large hit.
function script.on_large_damage()
	local move_type: s32 = 0
	action.BlowStart(5.0, 0.0, 6)
	action.SetBlowAngle()
	action.SetGuardFlag(0)
	move_type = action.GetMoveType() or move_type
	if move_type == 1 then
		action.SetMos("立ち-足", -1, 4)
	else
		action.SetMos("立ち-キャタピラ", -1, 4)
	end
	helper_bac4ec65(6)
	action.ProgSet(0)
end

--- Follows up a melee hit that the character has landed.
function script.on_melee_hit()
	action.ProgSet(0)
end

return script
