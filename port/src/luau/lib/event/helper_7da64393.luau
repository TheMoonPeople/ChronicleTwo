--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00bbde3d = require("@lib/event/helper_00bbde3d")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2a729875 = require("@lib/event/helper_2a729875")
local helper_514aa6a3 = require("@lib/event/helper_514aa6a3")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_83896a01 = require("@lib/event/helper_83896a01")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_e15e1b0a = require("@lib/event/helper_e15e1b0a")

--- Helper function.
local function helper_7da64393(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: any = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local var28: s32 = 0
	local argc_2: s32 = 0
	if arg1 == 1 then
		argc = 1
	elseif arg1 == 2 then
		argc = 2
	elseif arg1 == 3 then
		argc = 13
	else
		argc = event.GetLocalCnt(arg0) or argc
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if argc == now_party_chara_id then
		return
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if argc == 18 then
		var4 = 20
	end
	if argc == 25 then
		var4 = 24
	end
	if argc == 12 or argc == 17 then
		var4 = 28
	end
	if argc == 7 then
		var4 = 32
	end
	if argc == 10 or argc == 6 or argc == 24 then
		var4 = 40
	end
	if argc == 8 or argc == 1 or argc == 2 or argc == 3 or argc == 15 or argc == 16 or argc == 21 then
		var4 = 44
	end
	if argc == 4 or argc == 19 or argc == 20 or argc == 22 then
		var4 = 48
	end
	if argc == 5 or argc == 11 or argc == 23 or argc == 13 then
		var4 = 52
	end
	if argc == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	event.EyeViewDrawOnOff(1)
	if arg1 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local _, out2, _ = event.EohGetRot(0)
			var9 = out2 or var9
		end
	else
		var11 = event.GetNpcTrainEtc(1, argc) or var11
		do
			local out1, out2, out3, out4 = event.GetTrainNpcPos(var11)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var9 = out4 or var9
		end
		event.EohSyncChara(0, arg0)
		event.EohSetPos(0, var5, var6, var7)
		event.EohSetRot(0, 0.0, var9, 0.0)
		event.SetMotion(arg0, "立ち", 4)
	end
	var12 = vm.f32(vm.sin(var9) * 75.0)
	var12 = vm.f32(var12 + var5)
	var13 = vm.f32(var6 + 45.0)
	var14 = vm.f32(vm.cos(var9) * 75.0)
	var14 = vm.f32(var14 + var7)
	event.SetCameraPos(var12, var13, var14)
	var15 = var5
	var16 = vm.f32(var6 + 30.0)
	var17 = var7
	event.SetCameraRef(var15, var16, var17)
	var18 = vm.f32(vm.sin(var9) * 30.0)
	var18 = vm.f32(var18 + var5)
	var19 = var6
	var20 = vm.f32(vm.cos(var9) * 30.0)
	var20 = vm.f32(var20 + var7)
	event.SetCharaPos(0, var18, var19, var20)
	var21 = 0
	var22 = vm.f32(var9 + vm.f32(3.1415927))
	if var22 > vm.f32(3.1415927) then
		var22 = vm.f32(var22 - vm.f32(6.2831855))
	end
	var23 = 0
	event.SetCharaRot(0, var21, var22, var23)
	vm.wait(1)
	event.SetCrossfade(10)
	var24 = 0
	while true do
		helper_125385ee(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_83896a01(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_82705ce2(3, var25, 3, 256, 208)
		helper_125385ee(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_82705ce2(1, 1, 1, 0, 0)
		helper_125385ee(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(argc, 4)
			var25 = out1 or var25
			var28 = out2 or var28
		end
		if var28 == 3 then
			var25 = 30
		end
		if var28 == 4 then
			event.SetMesItemDirect(2, 1, var25)
			var25 = 31
		end
		if var28 == 5 then
			event.SetMesItemDirect(2, 1, var25)
			event.SetMesItemDirect(2, 2, vm.i32(var25 + 1))
			var25 = 32
		end
		var24 = helper_c190f878(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		helper_6992f518(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_25abe6d2(30)
				if arg1 == 0 then
					event.CharaActive(0, arg0)
					argc_2 = event.GetLocalCnt2(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.CharaActive(argc_2)
					end
				end
				event.SetNpcStatus(argc, 1)
				event.GotoSelectParty()
				vm.wait(4)
				helper_514aa6a3(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_125385ee(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Non puoi farlo ora. Devi prima\nportare Lin al faro!")
			helper_a3cc6850(3, -1, 9, 0, 0)
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_125385ee(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_a3cc6850(3, var25, 9, 0, 0)
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Benone, con le riparazioni\nabbiamo finito!")
						helper_a3cc6850(3, -1, 3, 256, 208)
						helper_514aa6a3(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_e15e1b0a(arg0, arg1, 6)
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_e15e1b0a(arg0, arg1, 23)
						return
					end
					if argc == 4 then
						if helper_00bbde3d(3) ~= 0 then
							helper_e15e1b0a(arg0, arg1, 33)
							return
						end
					end
				end
				if var24 == 4 then
					break
				end
				if var24 == -1 then
					break
				end
			else
				if var24 == 2 then
					if argc == 15 then
						helper_e15e1b0a(arg0, arg1, 0)
					end
					if argc == 12 then
						helper_e15e1b0a(arg0, arg1, 1)
					end
					if argc == 6 then
						helper_e15e1b0a(arg0, arg1, 2)
					end
					if argc == 7 then
						helper_e15e1b0a(arg0, arg1, 3)
					end
					if argc == 2 then
						helper_e15e1b0a(arg0, arg1, 7)
					end
					if argc == 3 then
						helper_e15e1b0a(arg0, arg1, 8)
					end
					if argc == 5 then
						helper_e15e1b0a(arg0, arg1, 9)
					end
					if argc == 8 then
						helper_e15e1b0a(arg0, arg1, 10)
					end
					if argc == 10 then
						helper_e15e1b0a(arg0, arg1, 11)
					end
					if argc == 11 then
						helper_e15e1b0a(arg0, arg1, 12)
					end
					if argc == 13 then
						helper_e15e1b0a(arg0, arg1, 13)
					end
					if argc == 16 then
						helper_e15e1b0a(arg0, arg1, 14)
					end
					if argc == 18 then
						helper_e15e1b0a(arg0, arg1, 15)
					end
					if argc == 19 then
						helper_e15e1b0a(arg0, arg1, 16)
					end
					if argc == 20 then
						helper_e15e1b0a(arg0, arg1, 17)
					end
					if argc == 21 then
						helper_e15e1b0a(arg0, arg1, 18)
					end
					if argc == 22 then
						helper_e15e1b0a(arg0, arg1, 19)
					end
					if argc == 23 then
						helper_e15e1b0a(arg0, arg1, 20)
					end
					if argc == 24 then
						helper_e15e1b0a(arg0, arg1, 21)
					end
					if argc == 25 then
						helper_e15e1b0a(arg0, arg1, 22)
					end
					if argc == 17 then
						helper_e15e1b0a(arg0, arg1, 32)
					end
					if argc == 9 then
						helper_2a729875()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_a3cc6850(3, -1, 3, 256, 208)
						helper_514aa6a3(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_25abe6d2(30)
						event.GotoMenu(25)
						vm.wait(35)
						helper_514aa6a3(arg0, arg1)
						event.SetFadeIn(30)
					end
					return
				end
				if var24 == 3 then
					break
				end
				if var24 == -1 then
					break
				end
			end
		else
			if var24 == 2 then
				break
			end
			if var24 == -1 then
				break
			end
		end
	end
	helper_514aa6a3(arg0, arg1)
	event.SetCrossfade(10)
end

return helper_7da64393
