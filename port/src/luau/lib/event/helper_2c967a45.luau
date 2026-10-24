--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_336b519d = require("@lib/event/helper_336b519d")
local helper_377e162e = require("@lib/event/helper_377e162e")
local helper_81254767 = require("@lib/event/helper_81254767")
local helper_83f868da = require("@lib/event/helper_83f868da")
local helper_951d9474 = require("@lib/event/helper_951d9474")
local helper_9e9b6d8c = require("@lib/event/helper_9e9b6d8c")
local helper_b60b09bd = require("@lib/event/helper_b60b09bd")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_d607c00a = require("@lib/event/helper_d607c00a")
local helper_e03e89ed = require("@lib/event/helper_e03e89ed")
local helper_f31893ce = require("@lib/event/helper_f31893ce")

--- Helper function.
local function helper_2c967a45(arg0: s32, arg1: s32)
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			argc = 1
			argc = 2
			argc = 13
			return
		end
		if at <= 5 then
			if at <= 2 then
				var24 = 0
				helper_377e162e(3, 1)
				helper_336b519d(3, argc)
				var25 = -1
				helper_e03e89ed(3, var25, 3, 256, 208)
				helper_377e162e(1, 8)
				helper_e03e89ed(1, 1, 1, 0, 0)
				helper_377e162e(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_83f868da(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_81254767(3)
				helper_c1c32f84(30)
			end
			helper_f31893ce(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_377e162e(3, 8)
				helper_951d9474(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_951d9474(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_f31893ce(arg0, arg1)
				helper_d607c00a(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_d607c00a(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_d607c00a(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_d607c00a(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_d607c00a(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_d607c00a(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_d607c00a(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_d607c00a(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_d607c00a(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_d607c00a(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_d607c00a(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_d607c00a(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_d607c00a(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_d607c00a(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_d607c00a(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_d607c00a(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_d607c00a(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_d607c00a(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_d607c00a(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_d607c00a(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_d607c00a(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_d607c00a(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_d607c00a(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_b60b09bd()
			helper_951d9474(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_f31893ce(arg0, arg1)
			helper_c1c32f84(30)
		end
		helper_f31893ce(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
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
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var24 = 0
	while true do
		helper_377e162e(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_336b519d(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_e03e89ed(3, var25, 3, 256, 208)
		helper_377e162e(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_e03e89ed(1, 1, 1, 0, 0)
		helper_377e162e(2, 2)
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
		var24 = helper_83f868da(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_81254767(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_c1c32f84(30)
				if vm.skipping() then
					return skip(4)
				end
				if arg1 == 0 then
					event.CharaActive(0, arg0)
					argc_2 = event.GetLocalCnt2(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.CharaActive(argc_2)
					end
				end
				event.SetNpcStatus(argc, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(5)
				end
				helper_f31893ce(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_377e162e(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Das geht jetzt nicht. Du musst\nerst Lin zum Leuchtturm bringen!")
			helper_951d9474(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_377e162e(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_951d9474(3, var25, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Na gut, die Reparaturen\nsind abgeschlossen!")
						helper_951d9474(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_f31893ce(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_d607c00a(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_d607c00a(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_9e9b6d8c(3)
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_d607c00a(arg0, arg1, 33)
							if vm.skipping() then
								return skip(12)
							end
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
						helper_d607c00a(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_d607c00a(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_d607c00a(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_d607c00a(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_d607c00a(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_d607c00a(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_d607c00a(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_d607c00a(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_d607c00a(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_d607c00a(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_d607c00a(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_d607c00a(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_d607c00a(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_d607c00a(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_d607c00a(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_d607c00a(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_d607c00a(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_d607c00a(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_d607c00a(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_d607c00a(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_d607c00a(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_b60b09bd()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_951d9474(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_f31893ce(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_c1c32f84(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_f31893ce(arg0, arg1)
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
	helper_f31893ce(arg0, arg1)
	event.SetCrossfade(10)
end

return helper_2c967a45
