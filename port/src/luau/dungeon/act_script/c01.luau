--!strict
-- dungeon/act_script/c01.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47e6f5ef = require("@lib/action/helper_47e6f5ef")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")
local helper_c97ab93c = require("@lib/action/helper_c97ab93c")
local helper_cc6c712f = require("@lib/action/helper_cc6c712f")
local helper_d6400fa5 = require("@lib/action/helper_d6400fa5")
local helper_eb0c92cb = require("@lib/action/helper_eb0c92cb")

--- Helper function.
local function helper_2e4() end

--- Helper function.
local function helper_1a08()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local acumu_pad: s32 = 0
	local var7: f32 = 0
	prog = action.ProgGet() or prog
	action.GetBtn_2(50)
	if prog == 100 then
		action.SetMos("5連続攻撃1", -1, 6)
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.143) and var4 <= vm.f32(0.429) then
			action.SetBlowMove(0.6, 0.0, 1)
		end
		if var4 >= vm.f32(0.714) and var4 <= 1.0 then
			action.SetBlowMove(0.8, 0.0, 1)
		end
		acumu_pad = action.GetAcumuPad() or acumu_pad
		if acumu_pad > 12 then
			action.ResetAcumuPad()
			action.ProgSet(1200)
			return
		end
		if var4 >= vm.f32(0.514) and var4 <= vm.f32(0.571) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5連続攻撃2", -1, 6)
				action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
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
		if var4 >= 0.0 and var4 <= vm.f32(0.409) then
			action.SetBlowMove(0.93, 0.0, 1)
		end
		if var4 >= vm.f32(0.518) and var4 <= vm.f32(0.573) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				var7 = action.CheckFrontKey() or var7
				if var7 > vm.f32(0.6) then
					action.SetMos("3段目", -1, 6)
					action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
					action.ProgSet(105)
				else
					action.SetMos("5連続攻撃3", -1, 6)
					action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
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
		if var4 >= 0.0 and var4 <= 0.375 then
			action.SetBlowMove(0.63, 0.0, 1)
		end
		if var4 >= vm.f32(0.675) and var4 <= 1.0 then
			action.SetBlowMove(0.6, 0.0, 1)
		end
		if var4 >= 0.5 and var4 <= vm.f32(0.55) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5連続攻撃4", -1, 6)
				action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
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
		if var4 >= 0.0 and var4 <= vm.f32(0.339) then
			action.SetBlowMove(0.787, 0.0, 1)
		end
		if var4 >= vm.f32(0.47) and var4 <= vm.f32(0.522) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5連続攻撃5", -1, 6)
				action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
				action.ProgSet(prog + 1)
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
		if var4 >= 0.0 and var4 <= vm.f32(0.24) then
			action.SetBlowMove(0.85, 0.0, 1)
		end
		if var4 >= vm.f32(0.7) and var4 <= 1.0 then
			action.SetBlowMove(0.4, 0.0, 1)
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
		if var4 >= 0.0 and var4 <= vm.f32(0.8) then
			action.SetBlowMove(0.8, 0.0, 1)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_37c0()
	local var0: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	var2 = action.GetBtn_2(56) or var2
	var3 = action.GetBtn_2(53) or var3
	prog = action.ProgGet() or prog
	action.SetDirGun()
	if prog == 800 then
		action.RunHoldMove("銃狙う", "銃回転")
		if var3 ~= 0 then
			if var2 ~= 0 then
				action.SetMos("発砲", -1, 6)
				action.SetMurderous(1, 3)
				action.ProgSet(prog + 1)
			end
		else
			action.ProgSet(0)
		end
		return
	end
	if prog == 801 then
		action.SetMos("発砲", -1, 6)
		var4 = action.NowMosWait() or var4
		if var4 > vm.f32(0.3) and var4 < vm.f32(0.4) then
			action.SetShot(6, "n_gun", 2, 5)
		end
		var0 = action.GetMosStatus() or var0
		if var0 == 4 then
			action.SetMos("銃狙う", -1, 4)
			action.ProgSet(prog - 1)
		end
	end
end

--- Helper function.
local function helper_3d38()
	local result: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local hold_type: s32 = 0
	local var7: f32 = 0
	var2 = action.GetBtn_2(50) or var2
	var3 = action.GetBtn_2(56) or var3
	var4 = action.GetBtn_2(54) or var4
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
		action.SetMos("ガードループ", -1, 4)
		if var3 ~= 0 then
			action.SetMos("持ち上げ", -1, 2)
			action.SetGuardFlag(0)
			action.ProgSet(prog + 1)
			action.SetMuteki(10)
			print("-- CATCH --\n")
		end
		if var4 == 0 then
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
			action.SetMos("投げ", -1, 6)
			action.ProgSet(prog + 1)
			action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
			return
		end
		return
	end
	if prog == 904 then
		action.SetMos("投げ", -1, 6)
		var7 = action.NowMosWait() or var7
		if var7 >= vm.f32(0.315) then
			action.ReleaseObj(1)
		end
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_4b28()
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
				return
			end
			action.ProgSet(0)
		end
		return
	end
	if prog == 1102 then
		action.RunShrowMove()
		if var2 ~= 0 then
			action.SetMos("投げ", -1, 6)
			action.ProgSet(prog + 1)
			action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
		end
		return
	end
	if prog == 1103 then
		action.SetMos("投げ", -1, 6)
		var5 = action.NowMosWait() or var5
		if var5 >= vm.f32(0.315) then
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
	action.SetObj(0, "dcol00")
	action.SetObj(1, "ef00")
	action.SetObj(2, "bcol00")
	action.SetObj(3, "bcol01")
	action.SetObj(4, "keri_R")
	action.SetObj(5, "nage")
	action.SetObj(6, "gun")
	action.SetDmg2("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.0, "5連続攻撃1", 0.37, 0.48)
	action.SetDmg2("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃2", 0.4, 0.5)
	action.SetDmg2("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃3", 0.375, 0.47)
	action.SetDmg2("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.15, "5連続攻撃4", 0.33, 0.443)
	action.SetDmg2("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.2, "5連続攻撃5", 0.3, 0.4)
	action.SetDmg2("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.5, 0.85)
	action.SetDmg2("dcol00", "dcol01", "ユリス溜め攻撃", 15.0, 1.6, "ため攻撃", 0.24, 0.52)
	action.SetDmg2("dcol00", "dcol01", "ユリス強蹴り", 4.0, 1.0, "3段目", 0.45, 0.55)
	action.SetDmg2("keri_R", "", "ユリス弱蹴り", 4.0, 1.0, "ダウン･蹴り", 0.35, 0.45)
	action.SetBody(2, 5.0)
	action.SetBody(3, 4.0)
	action.SwEffect(0, "5連続攻撃1", 0.34, 0.37, "dcol00", "dcol01", 77, 16, 10)
	action.SwEffect(0, "5連続攻撃2", 0.23, 0.26, "dcol00", "dcol01", 77, 12, 12)
	action.SwEffect(0, "5連続攻撃3", 0.27, 0.29, "dcol00", "dcol01", 77, 10, 12)
	action.SwEffect(0, "5連続攻撃4", 0.33, 0.36, "dcol00", "dcol01", 77, 10, 10)
	action.SwEffect(0, "5連続攻撃5", 0.26, 0.28, "dcol00", "dcol01", 77, 12, 15)
	action.SwEffect(0, "3段目", 0.4, 0.45, "dcol00", "dcol01", 77, 12, 12)
	action.SwEffect(0, "中距離攻撃", 0.28, 0.32, "dcol00", "dcol01", 77, 10, 16)
	action.SetAccumeFx(0, 2)
	action.SetSnd(-2, "歩き", 0.07, 0.1)
	action.SetSnd(-3, "歩き", 0.5, 0.55)
	action.SetSnd(-2, "走り", 0.4, 0.5)
	action.SetSnd(-3, "走り", 0.9, 1.0)
	action.SetSnd(400, "3連続レンチ1", 0.1, 0.2)
	action.SetSnd(401, "3連続レンチ2", 0.1, 0.3)
	action.SetSnd(402, "3連続レンチ3", 0.2, 0.3)
	action.SetSnd(403, "銃攻撃", 0.2, 0.3)
	action.SetSnd(400, "中距離攻撃", 0.3, 0.4)
end

--- Puts the character back into its normal state.
function script.reset()
	helper_2e4()
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
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local status: s32 = 0
	local var12: s32 = 0
	local hold_type: s32 = 0
	local used_item_action: s32 = 0
	local acumu_pad: s32 = 0
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
			helper_1a08()
			action.SetNeba2()
			if var1 ~= 0 then
				var6 = action.CheckBackKey() or var6
				if var6 ~= 0 then
					prog = 1300
					action.ProgSet(prog)
				end
			end
			if var3 ~= 0 then
				var7 = action.CheckEquip(1) or var7
				if var7 > 0 then
					prog = 800
					action.ProgSet(prog)
				end
			end
			if var2 ~= 0 then
				prog = 900
				action.ProgSet(prog)
			end
		end
		if prog >= 200 and prog < 299 then
			helper_eb0c92cb()
		end
		if prog >= 1200 and prog < 1299 then
			helper_d6400fa5()
		end
		if prog >= 1300 and prog < 1399 then
			helper_cc6c712f()
		end
		if prog >= 300 and prog < 399 then
			action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
			helper_47e6f5ef()
		end
		if prog >= 800 and prog < 899 then
			helper_37c0()
			action.SetNeba2()
		end
		if prog >= 900 and prog < 999 then
			helper_3d38()
			action.SetNeba2()
		end
		if prog >= 1000 and prog < 1099 then
			helper_c97ab93c()
			action.SetNeba2()
		end
		if prog >= 1100 and prog < 1199 then
			helper_4b28()
			action.SetNeba2()
		end
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunMainMove()
			if var1 ~= 0 then
				var8 = action.CheckBackKey() or var8
				if var8 ~= 0 then
					prog = 1300
				else
					var9 = action.CheckFrontKey() or var9
					var10 = action.GetTrgDistance() or var10
					if var9 > vm.f32(0.85) and (var10 > 40.0 and var10 < 100.0) then
						action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
						prog = 200
						action.SetMurderous(0, 3)
					else
						status = action.GetMonsterNowsts() or status
						if status == 1 and var10 < 28.0 then
							action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
							prog = 300
						else
							action.Ext(93, 2.0) -- retail: the handler rejects 1 arguments
							action.SetMurderous(0, 3)
							prog = 100
						end
					end
				end
				action.ResetPadHistory()
			end
			if var3 ~= 0 then
				var12 = action.CheckEquip(1) or var12
				if var12 > 0 then
					prog = 800
				end
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
			if acumu_pad > 12 then
				action.ResetAcumuPad()
				prog = 1200
			end
			action.ProgSet(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
function script.on_small_damage()
	action.BlowStart(5.0, 0.0, 3)
	action.ReleaseObj(0)
	action.SetMos("ダメージ", -1, 2)
	helper_bac4ec65(4)
	action.ProgSet(0)
end

--- Holds the character in place.
function script.on_hold()
	local attributes: s32 = 0
	action.BlowStart(5.0, 0.0, 3)
	action.ReleaseObj(0)
	action.SetMos("ダメージ", -1, 2)
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
	action.SetBlowMove(0.0, 0.0, 0)
	action.SetMos("ガード後", -1, 2)
	result = 0
	while result == 0 do
		vm.wait()
		result = vm.float_bits(action.CheckMosEnd()) or result
	end
end

--- Runs the character's death.
function script.on_death()
	helper_2e4()
	action.ReleaseObj(0)
	action.SetMos("死に", -1, 6)
	action.ProgSet(0)
end

return script
