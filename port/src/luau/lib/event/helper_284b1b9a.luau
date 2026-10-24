--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_689a9ab0 = require("@lib/event/helper_689a9ab0")
local helper_75f3e820 = require("@lib/event/helper_75f3e820")
local helper_af6b904c = require("@lib/event/helper_af6b904c")

--- Helper function.
local function helper_284b1b9a()
	local var0: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_75f3e820(14)
			end
			if at <= 2 then
				helper_75f3e820(66)
			end
			if at <= 3 then
				helper_689a9ab0()
			end
			if at <= 4 then
				helper_af6b904c(2)
			end
			if at <= 5 then
				helper_75f3e820(40)
			end
			if at <= 6 then
				helper_af6b904c(5)
			end
			if at <= 7 then
				helper_689a9ab0()
			end
			if at <= 8 then
				helper_75f3e820(30)
			end
			if at <= 9 then
				helper_75f3e820(70)
			end
			if at <= 10 then
				helper_af6b904c(0)
			end
			if at <= 11 then
				var2 = 0
				var3 = -2600.0
				var4 = -16.0
				var5 = vm.f32(-0.6)
				var3 = vm.f32(var3 + var4)
				var4 = vm.f32(var4 + var5)
				var2 = var2 + 1
			end
			if at <= 12 then
				helper_af6b904c(0)
			end
			if at <= 13 then
				var6 = 460.0
				var7 = 12.5
				var8 = 0.5
				var3 = -5500.0
				var4 = -62.5
				var5 = -2.5
				var2 = 0
				var6 = vm.f32(var6 + var7)
				var7 = vm.f32(var7 + var8)
				var3 = vm.f32(var3 + var4)
				var4 = vm.f32(var4 + var5)
				var2 = var2 + 1
			end
			if at <= 14 then
				var9 = 0.0
				var10 = 0.0
				var11 = vm.f32(0.6)
				var6 = 655.0
				var7 = 40.0
				var8 = vm.f32(0.33333334)
				var3 = -6300.0
				var4 = -200.0
				var5 = vm.f32(-1.6666666)
				var2 = 0
				var9 = vm.f32(var9 + var10)
				var10 = vm.f32(var10 + var11)
				var6 = vm.f32(var6 + var7)
				var7 = vm.f32(var7 + var8)
				var3 = vm.f32(var3 + var4)
				var4 = vm.f32(var4 + var5)
				var2 = var2 + 1
			end
			if at <= 15 then
				helper_75f3e820(10)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.CharaActive(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_75f3e820(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(115)
	event.LoadSound(4525)
	var0 = event.SndLoadSound(4525) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.CharaActive(0, 0)
	event.ChangeDir("event/e600/e600/")
	event.LoadChara(5, "e600_mizusibuki.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.EohSyncChara(15, 32)
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.LoadChara(5, "e600_nagare.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(16, 33)
	event.ObjsInit(16)
	event.ObjsSyncObj(16, 16)
	event.LoadChara(5, "e600_hikari.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.ChangeDir("")
	event.EohSyncObj(0, "p01_train01")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p15_f0301-1")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(2, "p15_f0301")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p22_f0301")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p23_f0301")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p24_f0301")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "s3601_10-m")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p01_train01", "s3601_10-m1")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_train01", "s3601_10-m2")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p01_train01", "s3601_11-m")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p01_train01", "s3601_11-m1")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p18_f0301", "f030407-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p19_f0301", "f030408-m")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(13, "p20_f0301", "f030409-m")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.EohSyncObj(14, "p21_f0301", "f030410-m")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(17, "p25_f0301")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.EohSyncObj(18, "p26_f0301")
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.EohSyncObj(19, "p27_f0301")
	event.ObjsInit(19)
	event.ObjsSyncObj(19, 19)
	event.EohSetPos(0, 0.0, 70.0, -1860.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetPos(3, 0.0, -100.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetPos(4, 0.0, -400.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, 0.0, -700.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(11, 0.0, 2.3561945, 0.0)
	event.EohSetRot(12, 0.0, -0.7853982, 0.0)
	event.EohSetRot(13, 0.0, 0.7853982, 0.0)
	event.EohSetRot(14, 0.0, -2.3561945, 0.0)
	event.EohSetShow(17, 1)
	event.EohSetPos(17, 0.0, -100.0, 0.0)
	event.EohSetRot(17, 0.0, 0.0, 0.0)
	event.EohSetShow(18, 1)
	event.EohSetPos(18, 0.0, -400.0, 0.0)
	event.EohSetRot(18, 0.0, 0.0, 0.0)
	event.EohSetShow(19, 1)
	event.EohSetPos(19, 0.0, -700.0, 0.0)
	event.EohSetRot(19, 0.0, 0.0, 0.0)
	event.EohSetPos(15, 0.0, 7.0, -1860.0)
	event.EohSetRot(15, 0.0, 3.14, 0.0)
	event.EohSetPos(16, 0.0, 150.0, -1800.0)
	event.EohSetRot(16, 0.0, 3.14, 0.0)
	event.SetCharaPos(34, 2566.79, 5880.98, -32029.89)
	event.ObjsRotation2(11, -0.4, 2.3561945, 0.0, 120, 0, 1.0)
	event.ObjsRotation2(12, -0.4, -0.7853982, 0.0, 120, 0, 1.0)
	event.ObjsRotation2(13, -0.4, 0.7853982, 0.0, 120, 0, 1.0)
	event.ObjsRotation2(14, -0.4, -2.3561945, 0.0, 120, 0, 1.0)
	event.CmrsInit()
	event.CmrsSetRef(0.0, 200.0, -1600.0)
	event.CmrsSetAhd(2.6, 800.0, 3000.0)
	event.CmrsMoveAhd2(-2.6, 800.0, 3000.0, 120, 0, 1.0)
	event.SetFadeIn(30)
	helper_75f3e820(14)
	if vm.skipping() then
		return skip(2)
	end
	event.PlayBgm(0)
	helper_75f3e820(66)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 0)
	event.ObjsRotation2(1, 0.0, 0.08, 0.0, 160, 0, 1.0)
	event.ObjsRotation2(2, 0.0, -0.08, 0.0, 160, 0, 1.0)
	helper_689a9ab0()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(213.43, 452.11, -5638.41)
	event.CmrsSetRef(206.97, 452.67, -5520.54)
	event.CmrsMove2(269.87, 930.16, -6906.42, 250.2, 895.98, -6763.9, 360, 0, 1.0)
	helper_af6b904c(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 1)
	event.ObjsMove2(3, 0.0, 0.0, 0.0, 100, 2, 1.0)
	event.ObjsSeDelay(3, 140.0)
	event.ObjsSePlay(3, var0, 3)
	event.ObjsMove2(5, 0.0, 0.0, 0.0, 360, 2, 1.0)
	event.ObjsSeDelay(5, 520.0)
	event.ObjsSePlay(5, var0, 3)
	event.ObjsMove2(17, 0.0, 0.0, 0.0, 100, 2, 1.0)
	event.ObjsMove2(19, 0.0, 0.0, 0.0, 360, 2, 1.0)
	helper_75f3e820(40)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove2(4, 0.0, 0.0, 0.0, 200, 2, 1.0)
	event.ObjsMove2(18, 0.0, 0.0, 0.0, 200, 2, 1.0)
	event.ObjsSeDelay(4, 280.0)
	event.ObjsSePlay(4, var0, 3)
	helper_af6b904c(5)
	if vm.skipping() then
		return skip(7)
	end
	helper_689a9ab0()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(427.74, 105.92, -3207.97)
	event.CmrsSetRef(380.62, 117.95, -3117.35)
	event.SndSePlay(var0, 4)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.EohSetShow(17, 0)
	event.EohSetShow(18, 0)
	event.EohSetShow(19, 0)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 5)
	event.ObjsMove2(0, 0.0, 70.0, -2600.0, 120, 1, 1.0)
	event.ObjsMove2(15, 0.0, 70.0, -2600.0, 120, 1, 1.0)
	event.ObjsRotation2(6, 3.1, 0.0, 0.0, 60, 1, 1.0)
	event.ObjsRotation2(7, 3.1, 0.0, 0.0, 60, 1, 1.0)
	event.ObjsRotation2(8, 3.1, 0.0, 0.0, 60, 1, 1.0)
	event.ObjsRotation2(9, 3.1, 0.0, 0.0, 60, 1, 1.0)
	event.ObjsRotation2(10, 3.1, 0.0, 0.0, 60, 1, 1.0)
	event.ObjsRotation(6, 0.1, 0.0, 0.0, -1)
	event.ObjsRotation(7, 0.1, 0.0, 0.0, -1)
	event.ObjsRotation(8, 0.1, 0.0, 0.0, -1)
	event.ObjsRotation(9, 0.1, 0.0, 0.0, -1)
	event.ObjsRotation(10, 0.1, 0.0, 0.0, -1)
	helper_75f3e820(70)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(1, 32)
	event.SetCharaShow(32, 1, 1, 0.011111111)
	helper_af6b904c(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(493.85, 133.35, -3161.95)
	event.CmrsSetRef(192.71, 140.7, -3161.9)
	var2 = 0
	var3 = -2600.0
	var4 = -16.0
	var5 = vm.f32(-0.6)
	while var2 < 60 do
		event.ObjsSetPos(0, 0.0, 70.0, var3)
		event.ObjsSetPos(15, 0.0, 70.0, var3)
		var3 = vm.f32(var3 + var4)
		var4 = vm.f32(var4 + var5)
		var2 = var2 + 1
		if vm.wait() then
			return skip(12)
		end
	end
	helper_af6b904c(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-1162.38, 1222.12, -7192.96)
	event.CmrsSetRef(-630.41, 849.9, -6224.85)
	event.ObjsSetRot(0, -0.209, 3.14, 0.0)
	event.ObjsSetRot(15, -0.209, 3.14, 0.0)
	var6 = 460.0
	var7 = 12.5
	var8 = 0.5
	var3 = -5500.0
	var4 = -62.5
	var5 = -2.5
	var2 = 0
	while var2 < 20 do
		event.ObjsSetPos(0, 0.0, var6, var3)
		event.ObjsSetPos(15, 0.0, var6, var3)
		var6 = vm.f32(var6 + var7)
		var7 = vm.f32(var7 + var8)
		var3 = vm.f32(var3 + var4)
		var4 = vm.f32(var4 + var5)
		var2 = var2 + 1
		if vm.wait() then
			return skip(14)
		end
	end
	event.CmrsSetPos(-563.64, 740.88, -4153.64)
	event.CmrsSetRef(-529.67, 727.31, -4239.53)
	event.CmrsMove2(-563.64, 740.88, -4153.64, -539.68, 756.14, -4327.6, 90, 2, 1.0)
	event.ObjsRotation2(0, -0.209, 2.8, 0.0, 120, 0, 0.4)
	event.CharaActive(0, 32)
	event.CharaActive(1, 33)
	event.ObjsSetRot(16, -0.209, 3.14, 0.0)
	event.ObjsRotation2(16, -0.209, 2.8, 0.0, 120, 0, 0.4)
	event.ObjsSetMotion(16, "ループ入り", 6)
	event.ObjsNextMotion(16, "ループ", 4)
	var9 = 0.0
	var10 = 0.0
	var11 = vm.f32(0.6)
	var6 = 655.0
	var7 = 40.0
	var8 = vm.f32(0.33333334)
	var3 = -6300.0
	var4 = -200.0
	var5 = vm.f32(-1.6666666)
	var2 = 0
	while var2 < 110 do
		if var2 == 30 then
			event.CharaActive(1, 34)
			event.SetCharaShow(34, 1, 1, 0.016666668)
		end
		event.ObjsSetPos(0, var9, var6, var3)
		event.ObjsSetPos(16, var9, var6 + 80.0, var3)
		var9 = vm.f32(var9 + var10)
		var10 = vm.f32(var10 + var11)
		var6 = vm.f32(var6 + var7)
		var7 = vm.f32(var7 + var8)
		var3 = vm.f32(var3 + var4)
		var4 = vm.f32(var4 + var5)
		var2 = var2 + 1
		if vm.wait() then
			return skip(15)
		end
	end
	event.SetFadeOut(10)
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

return helper_284b1b9a
