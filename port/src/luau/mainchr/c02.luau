--!strict
-- mainchr/c02.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_21d040f0 = require("@lib/action/helper_21d040f0")
local helper_2ec4bb16 = require("@lib/action/helper_2ec4bb16")
local helper_969ab7e3 = require("@lib/action/helper_969ab7e3")
local helper_9d1f223a = require("@lib/action/helper_9d1f223a")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")
local helper_b1d92b97 = require("@lib/action/helper_b1d92b97")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")
local helper_c97ab93c = require("@lib/action/helper_c97ab93c")
local helper_de5acdcc = require("@lib/action/helper_de5acdcc")
local helper_dea24da5 = require("@lib/action/helper_dea24da5")

local global0: s32 = 0
local global1: f32 = 0
local global2: s32 = 0

--- Helper function.
local function helper_2ec()
	action.SetGuardFlag(0)
	if global0 ~= -1 then
		action.EsmDelete(global0)
	end
end

--- Helper function.
local function helper_7ef8()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local acumu_pad: s32 = 0
	local var6: f32 = 0
	prog = action.ProgGet() or prog
	if prog == 100 then
		action.SetMos("5剣1", -1, 6)
		var4 = action.NowMosWait() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.3) then
			action.SetBlowMove(0.8, 0.0, 1)
		end
		acumu_pad = action.GetAcumuPad() or acumu_pad
		if acumu_pad > 10 then
			action.ResetAcumuPad()
			action.ProgSet(1200)
			return
		end
		if var4 >= vm.f32(0.35) and var4 <= vm.f32(0.7) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣2", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 101 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.4) then
			action.SetBlowMove(1.5, 0.0, 1)
		end
		if var4 >= 0.5 and var4 <= vm.f32(0.8) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				var6 = action.CheckFrontKey() or var6
				if var6 > vm.f32(0.6) then
					action.SetMos("ふっとばし", -1, 6)
					action.SetTrgAngle(40.0, 2.0)
					action.ProgSet(105)
				else
					action.SetMos("5剣3", -1, 6)
					action.SetTrgAngle(40.0, 2.0)
					action.ProgSet(prog + 1)
					action.ResetPadHistory()
					action.SetMurderous(0, 3)
				end
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 102 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.49) then
			action.SetBlowMove(1.5, 0.0, 1)
		end
		if var4 >= vm.f32(0.45) and var4 <= vm.f32(0.72) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣4", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 103 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.19) then
			action.SetBlowMove(0.3, 0.0, 1)
		end
		if var4 >= vm.f32(0.22) and var4 <= vm.f32(0.77) then
			action.SetBlowMove(1.0, 0.0, 1)
		end
		if var4 >= vm.f32(0.35) and var4 <= vm.f32(0.57) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣5", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 104 then
		var4 = action.NowMosWait() or var4
		if var4 >= 0.0 and var4 <= 0.5 then
			action.SetBlowMove(1.2, 0.0, 1)
		end
		if var4 >= vm.f32(0.66) and var4 <= 1.0 then
			action.SetBlowMove(0.825, 0.0, 1)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
	if prog == 105 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.15) and var4 <= 0.5 then
			action.SetBlowMove(1.8, 0.0, 1)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_9c64()
	local var0: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	var2 = action.GetBtn_2(53) or var2
	var3 = action.GetBtn_2(50) or var3
	prog = action.ProgGet() or prog
	if prog == 800 then
		action.RunHoldMove("魔法狙う", "魔法回転")
		do
			local out1, out2, out3 = action.GetObjectPos("item")
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		action.EsmSetVect1(global0, var4, var5, var6)
		global1 = vm.f32(global1 + vm.f32(0.008333334))
		if global1 >= vm.f32(1.3) then
			global1 = vm.f32(1.3)
		end
		if var2 ~= 0 then
			if var3 ~= 0 then
				action.SetMos("発動", -1, 6)
				action.ProgSet(prog + 1)
			end
		else
			action.ProgSet(0)
			action.EsmDelete(global0)
		end
		return
	end
	if prog == 801 then
		action.SetMos("発動", -1, 6)
		do
			local out1, out2, out3 = action.GetObjectPos("item")
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		action.EsmSetVect1(global0, var7, var8, var9)
		var10 = action.NowMosWait() or var10
		if var10 >= 0.25 and var10 < vm.f32(0.3) then
			action.SetShot(6, "spell01", 2, 5, global1)
			action.EsmFinish(global0)
			global1 = vm.f32(0.8)
			return
		end
		if (if var2 ~= 0 then var3 else 0) ~= 0 and var10 > vm.f32(0.65) then
			action.ResetMos()
			action.ProgSet(801)
			return
		end
		var0 = action.GetMosStatus() or var0
		if var0 == 4 then
			action.SetMos("魔法狙う", -1, 4)
			do
				local out1, out2, out3 = action.GetObjectPos("item")
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			global0 = action.EsmCreate_2("モニカ魔法－溜め") or global0
			action.EsmSetVect1(global0, var11, var12, var13)
			do
				local out1, out2, out3 = action.GetRingColor()
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			action.EsmSetVect2(global0, var14, var15, var16)
			global1 = vm.f32(0.8)
			action.ProgSet(prog - 1)
		end
	end
end

--- Helper function.
local function helper_a6e8()
	local result: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local prog: s32 = 0
	local var5: f32 = 0
	local hold_type: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	var3 = action.GetBtn_2(53) or var3
	var1 = action.GetBtn_2(54) or var1
	var2 = action.GetBtn_2(50) or var2
	prog = action.ProgGet() or prog
	if prog == 900 then
		action.SetMos("ガード入り", -1, 6)
		action.SetGuardFlag(1)
		vm.wait()
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			action.ProgSet(prog + 1)
		end
		return
	end
	if prog == 901 then
		action.RunHoldMove("ガードループ", "ガードばたばた")
		if (if var3 ~= 0 then var1 else 0) ~= 0 then
			action.SetGuardFlag(0)
			action.ProgSet(910)
			action.SetMos("5剣1", -1, 6)
			return
		end
		if var2 ~= 0 then
			action.SetMos("持ち上げ", -1, 2)
			action.SetGuardFlag(0)
			action.ProgSet(prog + 1)
			action.SetMuteki(10)
		end
		if var1 == 0 then
			action.SetGuardFlag(0)
			action.ProgSet(0)
		end
		return
	end
	if prog == 902 then
		action.SetMos("持ち上げ", -1, 2)
		var5 = action.NowMosWait() or var5
		if var5 >= vm.f32(0.14) and var5 < vm.f32(0.233) then
			action.CheckCatch("nage")
		end
		vm.wait()
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			hold_type = action.CheckHandObj() or hold_type
			if hold_type == 3 or hold_type == 4 then
				action.ProgSet(prog + 1)
			else
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 903 then
		action.RunShrowMove()
		if var2 ~= 0 then
			action.ProgSet(prog + 1)
			action.SetTrgAngle(40.0, 2.0)
		end
		return
	end
	if prog == 904 then
		action.SetMos("投げ", -1, 6)
		vm.wait()
		var7 = action.NowMosWait() or var7
		if var7 >= vm.f32(0.3) then
			action.ReleaseObj(1)
		end
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			action.ProgSet(0)
		end
		return
	end
	if prog == 910 then
		var8 = action.NowMosWait() or var8
		if global2 == 1 then
			if var8 >= vm.f32(0.35) and var8 <= vm.f32(0.45) then
				action.SetSpecialShot("dcol01")
			end
		elseif var8 >= vm.f32(0.39) and var8 <= vm.f32(0.42) then
			action.SetSpecialShot("dcol01")
		end
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			action.ProgSet(900)
		end
		return
	end
end

--- Helper function.
local function helper_b818()
	local result: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local hold_type: s32 = 0
	local var5: f32 = 0
	var2 = action.GetBtn_2(50) or var2
	prog = action.ProgGet() or prog
	if prog == 1100 then
		action.SetMos("持ち上げ", -1, 6)
		action.ProgSet(prog + 1)
		action.SetMuteki(10)
	end
	if prog == 1101 then
		action.SetMos("持ち上げ", -1, 2)
		var3 = action.NowMosWait() or var3
		if var3 >= vm.f32(0.14) and var3 < vm.f32(0.233) then
			action.CheckCatch("nage")
		end
		vm.wait()
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			hold_type = action.CheckHandObj() or hold_type
			if hold_type == 3 or hold_type == 4 then
				action.ProgSet(prog + 1)
			else
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 1102 then
		action.RunShrowMove()
		if var2 ~= 0 then
			action.SetMos("投げ", -1, 6)
			action.ProgSet(prog + 1)
			action.SetTrgAngle(40.0, 2.0)
		end
		return
	end
	if prog == 1103 then
		action.SetMos("投げ", -1, 6)
		vm.wait()
		var5 = action.NowMosWait() or var5
		if var5 >= vm.f32(0.333) then
			action.ReleaseObj(1)
		end
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
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
	action.InitScript_0()
	global2 = 0
	global2 = action.GetActionCode() or global2
	global0 = -1
	global1 = 0.0
	action.SetObj(0, "dcol01")
	action.SetObj(1, "dcol00")
	action.SetObj(2, "bcol00")
	action.SetObj(3, "bcol01")
	action.SetObj(4, "keri_R")
	action.SetObj(6, "item")
	if global2 == 0 then
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.36, 0.478)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣2", 0.265, 0.371)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.12, "5剣3", 0.27, 0.45)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣4", 0.397, 0.503)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.25, "5剣5", 0.31, 0.45)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.4, "ふっとばし", 0.54, 0.65)
	end
	if global2 == 1 then
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣1", 0.34, 0.53)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣2", 0.21, 0.36)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "5剣3", 0.36, 0.5)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.35, "5剣4", 0.4, 0.52)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.6, "ふっとばし", 0.38, 0.58)
	end
	if global2 == 2 then
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.3, 0.48)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣2", 0.27, 0.41)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣3", 0.36, 0.53)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣4", 0.38, 0.54)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣5", 0.25, 0.45)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.2, "5剣6", 0.35, 0.52)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.14, 0.45)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.3, "ふっとばし", 0.54, 0.65)
	end
	if global2 == 3 then
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.225, 0.405)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣2", 0.36, 0.54)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣3", 0.327, 0.45)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.14, "5剣4", 0.257, 0.386)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.3, "5剣5", 0.379, 0.521)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.173, 0.312)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.329, 0.415)
		action.SetDmg2("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.2, "ふっとばし", 0.433, 0.502)
	end
	action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.35, 0.46)
	action.SetDmg2("dcol02", "", "モニカ溜め攻撃", 20.0, 1.2, "ため攻撃", 0.62, 0.72)
	action.SetDmg2("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 0.8, "ダウン･剣", 0.46, 0.533)
	if global2 == 0 then
		action.SwEffect(0, "5剣1", 0.3, 0.33, "dcol00", "dcol01", 77, 10, 16)
		action.SwEffect(0, "5剣2", 0.23, 0.26, "dcol00", "dcol01", 77, 4, 12)
		action.SwEffect(0, "5剣3", 0.27, 0.3, "dcol00", "dcol01", 77, 5, 12)
		action.SwEffect(0, "5剣4", 0.39, 0.42, "dcol00", "dcol01", 77, 5, 10)
		action.SwEffect(0, "5剣5", 0.3, 0.33, "dcol00", "dcol01", 77, 12, 20)
		action.SwEffect(0, "ふっとばし", 0.2, 0.25, "dcol00", "dcol01", 77, 20, 20)
	end
	if global2 == 1 then
		action.SwEffect(0, "5剣1", 0.3, 0.34, "dcol00", "dcol01", 77, 10, 12)
		action.SwEffect(0, "5剣2", 0.12, 0.18, "dcol00", "dcol01", 77, 12, 12)
		action.SwEffect(0, "5剣3", 0.33, 0.36, "dcol00", "dcol01", 77, 12, 12)
		action.SwEffect(0, "ふっとばし", 0.42, 0.45, "dcol00", "dcol01", 77, 20, 20)
	end
	if global2 == 2 then
		action.SwEffect(0, "5剣1", 0.26, 0.3, "dcol00", "dcol01", 77, 5, 12)
		action.SwEffect(0, "5剣2", 0.24, 0.3, "dcol00", "dcol01", 77, 10, 12)
		action.SwEffect(0, "5剣3", 0.22, 0.3, "dcol00", "dcol01", 77, 10, 12)
		action.SwEffect(0, "5剣4", 0.25, 0.32, "dcol00", "dcol01", 77, 10, 10)
		action.SwEffect(0, "5剣5", 0.25, 0.32, "dcol00", "dcol01", 77, 10, 10)
		action.SwEffect(0, "5剣6", 0.33, 0.35, "dcol00", "dcol01", 77, 12, 20)
		action.SwEffect(0, "ふっとばし", 0.2, 0.25, "dcol00", "dcol01", 77, 20, 20)
	end
	if global2 == 3 then
		action.SwEffect(0, "5剣1", 0.18, 0.26, "dcol00", "dcol01", 77, 8, 10)
		action.SwEffect(0, "5剣2", 0.27, 0.32, "dcol00", "dcol01", 77, 12, 12)
		action.SwEffect(0, "5剣3", 0.24, 0.3, "dcol00", "dcol01", 77, 8, 10)
		action.SwEffect(0, "5剣4", 0.13, 0.19, "dcol00", "dcol01", 77, 10, 12)
		action.SwEffect(0, "5剣5", 0.07, 0.13, "dcol00", "dcol01", 77, 12, 20)
		action.SwEffect(0, "ふっとばし", 0.2, 0.28, "dcol00", "dcol01", 77, 20, 20)
	end
	action.SwEffect(0, "中距離攻撃", 0.28, 0.31, "dcol00", "dcol01", 77, 10, 30)
	action.SwEffect(0, "勝利のポーズ", 0.1, 0.2, "dcol00", "dcol01", 77, 50, 30)
end

--- Puts the character back into its normal state.
function script.reset()
	helper_2ec()
	action.ReleaseObj(0)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local status: s32 = 0
	local hold_type: s32 = 0
	local used_item_action: s32 = 0
	local acumu_pad: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	local var25: s32 = 0
	action.ProgSet(0)
	while true do
		prog = action.ProgGet() or prog
		var1 = action.GetBtn_2(50) or var1
		var2 = action.GetBtn_2(54) or var2
		var3 = action.GetBtn_2(53) or var3
		var4 = action.GetBtn_2(51) or var4
		var5 = action.CheckPause_2(8192) or var5
		if var5 ~= 0 then
			while true do
				action.RunMainMove()
				vm.wait()
			end
		end
		if prog >= 100 and prog < 199 then
			if global2 == 0 then
				helper_9d1f223a()
			end
			if global2 == 1 then
				helper_2ec4bb16()
			end
			if global2 == 2 then
				helper_21d040f0()
			end
			if global2 == 3 then
				helper_7ef8()
			end
			action.SetNeba2()
			if var1 ~= 0 then
				var6 = action.CheckBackKey() or var6
				if var6 ~= 0 then
					prog = 1300
					action.ProgSet(prog)
				end
			end
			if var2 ~= 0 then
				prog = 900
				action.ProgSet(prog)
			end
			if var3 ~= 0 then
				action.SetMurderous(1, 3)
				do
					local out1, out2, out3 = action.GetObjectPos("item")
					var7 = out1 or var7
					var8 = out2 or var8
					var9 = out3 or var9
				end
				global0 = action.EsmCreate_2("モニカ魔法－溜め") or global0
				action.EsmSetVect1(global0, var7, var8, var9)
				do
					local out1, out2, out3 = action.GetRingColor()
					var10 = out1 or var10
					var11 = out2 or var11
					var12 = out3 or var12
				end
				action.EsmSetVect2(global0, var10, var11, var12)
				global1 = vm.f32(0.8)
				prog = 800
				action.ProgSet(prog)
			end
		end
		if prog >= 200 and prog < 299 then
			helper_969ab7e3()
		end
		if prog >= 1300 and prog < 1399 then
			helper_dea24da5()
			prog = 0
			var1 = 0
		end
		if prog >= 1200 and prog < 1299 then
			helper_de5acdcc()
		end
		if prog >= 300 and prog < 399 then
			action.SetTrgAngle(40.0, 2.0)
			helper_b1d92b97()
		end
		if prog >= 800 and prog < 899 then
			helper_9c64()
			action.SetNeba2()
		end
		if prog >= 900 and prog < 999 then
			helper_a6e8()
			action.SetNeba2()
		end
		if prog >= 1000 and prog < 1099 then
			helper_c97ab93c()
			action.SetNeba2()
		end
		if prog >= 1100 and prog < 1199 then
			helper_b818()
			action.SetNeba2()
		end
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunMainMove()
			if var1 ~= 0 then
				var13 = action.CheckBackKey() or var13
				if var13 ~= 0 then
					prog = 1300
				else
					var14 = action.CheckFrontKey() or var14
					var15 = action.GetTrgDistance() or var15
					if var14 > vm.f32(0.85) and var15 > 40.0 and var15 < 100.0 then
						action.SetTrgAngle(40.0, 2.0)
						prog = 200
						action.SetMurderous(0, 3)
					else
						status = action.GetMonsterNowsts() or status
						if status == 1 and var15 < 28.0 then
							action.SetTrgAngle(40.0, 2.0)
							prog = 300
						else
							action.SetTrgAngle(40.0, 2.0)
							prog = 100
							action.SetMurderous(0, 3)
						end
					end
				end
				action.ResetPadHistory()
			end
			if var2 ~= 0 then
				prog = 900
			end
			if (if var2 ~= 0 then var1 else 0) ~= 0 then
				prog = 1100
			end
			if var4 ~= 0 then
				hold_type = action.CheckHandObj() or hold_type
				if hold_type == 0 then
					used_item_action = action.SetItemUsed() or used_item_action
					if used_item_action == 3 then
						prog = 1100
					end
					if used_item_action == 2 then
						prog = 1000
					end
				end
			end
			acumu_pad = action.GetAcumuPad() or acumu_pad
			if acumu_pad > 10 then
				action.ResetAcumuPad()
				prog = 1200
			end
			if var3 ~= 0 then
				prog = 800
				action.SetMurderous(1, 3)
				do
					local out1, out2, out3 = action.GetObjectPos("item")
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
				end
				global0 = action.EsmCreate_2("モニカ魔法－溜め") or global0
				action.EsmSetVect1(global0, var20, var21, var22)
				do
					local out1, out2, out3 = action.GetRingColor()
					var23 = out1 or var23
					var24 = out2 or var24
					var25 = out3 or var25
				end
				action.EsmSetVect2(global0, var23, var24, var25)
				global1 = vm.f32(0.8)
				action.SetMenuFlag(0)
			end
			action.ProgSet(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
function script.on_small_damage()
	helper_2ec()
	action.BlowStart(5.0, 0.0, 3)
	action.ReleaseObj(0)
	action.SetMos("ダメージ", -1, 2)
	helper_bac4ec65(8)
	action.ProgSet(0)
end

--- Holds the character in place.
function script.on_hold()
	local attributes: s32 = 0
	helper_2ec()
	action.BlowStart(0.0, 0.0, 3)
	action.ReleaseObj(0)
	action.SetMos("ダメージ", -1, 6)
	attributes = 40
	while bit32.band(attributes, 40) ~= 0 do
		action.SetMenuFlag(1)
		vm.wait()
		attributes = action.GetStatusAttr() or attributes
	end
	action.ProgSet(0)
end

--- Reacts to a large hit.
function script.on_large_damage()
	helper_2ec()
	action.BlowStart(4.5, 0.04, 26)
	action.SetBlowAngle()
	action.ReleaseObj(0)
	action.SetMos("吹っ飛び", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(10)
	action.SetMos("起き上がり", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(2)
	action.ProgSet(0)
end

--- Follows up a melee hit that the character has landed.
function script.on_melee_hit()
	local result: s32 = 0
	helper_2ec()
	action.BlowStart(0.0, 0.0, 0)
	action.SetMos("ガード後", -1, 2)
	result = 0
	while result == 0 do
		vm.wait()
		result = vm.float_bits(action.CheckMosEnd()) or result
	end
end

--- Runs the character's death.
function script.on_death()
	helper_2ec()
	action.ReleaseObj(0)
	action.SetMos("死に", -1, 6)
	action.ProgSet(0)
end

--- Lands the character after a fall.
function script.on_land()
	helper_2ec()
	action.ReleaseObj(0)
	helper_9da84b8b()
	action.SetMos("バトル立ち")
	vm.wait()
end

return script
