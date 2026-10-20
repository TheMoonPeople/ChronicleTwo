--!strict
-- map/d/d02/b02/d02b02_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_021e710a = require("@lib/event/helper_021e710a")
local helper_1c6f5ce6 = require("@lib/event/helper_1c6f5ce6")
local helper_31ed5d56 = require("@lib/event/helper_31ed5d56")
local helper_37d1ae51 = require("@lib/event/helper_37d1ae51")
local helper_389b7d93 = require("@lib/event/helper_389b7d93")
local helper_604d1827 = require("@lib/event/helper_604d1827")
local helper_85bca15b = require("@lib/event/helper_85bca15b")
local helper_87dfa3c1 = require("@lib/event/helper_87dfa3c1")
local helper_a8e031ba = require("@lib/event/helper_a8e031ba")
local helper_b4b9bfbc = require("@lib/event/helper_b4b9bfbc")
local helper_df58599d = require("@lib/event/helper_df58599d")
local helper_e8b18690 = require("@lib/event/helper_e8b18690")
local helper_f12f1691 = require("@lib/event/helper_f12f1691")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_10e64(arg0: s32)
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 8
		global0 = 8
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e257/e257_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e257/e257_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e257/e257_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e257/e257_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.LoadChara(5, "dungeon/monster/b02a.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, arg0)
	event.ObjsInit(3, 11)
	event.ObjsSyncObj(3, 3)
	block = event.LoadImg_4(5, "textures/event/e200/e257/e257telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e257telop01", block)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetScale(0, 1.0, 1.0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.LoadMes(0, 5, "event/e200/e257/e257_1.txt")
end

--- Helper function.
local function helper_10ae4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(13)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(13)
	end
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.DeleteChara(11)
	event.DelImg(0)
end

--- Helper function.
local function helper_11fd8()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
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
	local var14: f32 = 0
	local var15: s32 = 0
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 31 then
			if at <= 1 then
				helper_e8b18690(4)
			end
			if at <= 2 then
				helper_10e64(var1)
				helper_e8b18690(60)
			end
			if at <= 3 then
				helper_e8b18690(10)
			end
			if at <= 4 then
				helper_e8b18690(20)
			end
			if at <= 5 then
				helper_e8b18690(10)
			end
			if at <= 6 then
				helper_e8b18690(30)
			end
			if at <= 7 then
				var2 = vm.f32(0.116339)
				var3 = vm.f32(0.074309)
				var4 = vm.f32(0.124094)
				var5 = vm.f32(496.65527)
				var6 = vm.f32(526.85187)
				var7 = vm.f32(483.53925)
				var8 = vm.f32(-1.63)
				var9 = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
				var10 = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
				var11 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
				var12 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
				var13 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
				var14 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
			end
			if at <= 8 then
				helper_e8b18690(60)
			end
			if at <= 9 then
				var15 = 2570010
			end
			if at <= 11 then
				helper_b4b9bfbc(0, -1, 8, 0, 0)
				var0 = 0
				var9 = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
				var10 = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
				var11 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
				var12 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
				var13 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
				var14 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
				var0 = var0 + 1
			end
			if at <= 12 then
				var2 = helper_87dfa3c1(vm.f32(var2 - vm.f32(0.002)))
				var8 = helper_87dfa3c1(vm.f32(var8 - vm.f32(0.002)))
				var3 = helper_87dfa3c1(vm.f32(var3 - vm.f32(0.002)))
				var4 = helper_87dfa3c1(vm.f32(var4 - vm.f32(0.002)))
				helper_604d1827(0)
				var18 = vm.f32(var2 + 0.0625)
				var19 = vm.f32(var5 - 100.0)
				var20 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
				var21 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
				var22 = 2.0
				var0 = 0
				var23 = helper_31ed5d56(-0.125, 0.0625, var0, 90)
				var18 = helper_87dfa3c1(vm.f32(var2 + var23))
				var20 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
				var21 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
				var9 = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
				var10 = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
				var11 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
				var12 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
				var13 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
				var14 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
				var0 = var0 + 1
			end
			if at <= 13 then
				var22 = helper_87dfa3c1(vm.f32(var22 - vm.f32(0.002)))
				var2 = helper_87dfa3c1(vm.f32(var2 - vm.f32(0.002)))
				var8 = helper_87dfa3c1(vm.f32(var8 - vm.f32(0.002)))
				var3 = helper_87dfa3c1(vm.f32(var3 - vm.f32(0.002)))
				var4 = helper_87dfa3c1(vm.f32(var4 - vm.f32(0.002)))
				helper_a8e031ba(2570020)
			end
			if at <= 14 then
				var8 = vm.f32(-2.17)
				var0 = 0
			end
			if at <= 15 then
				var8 = helper_87dfa3c1(vm.f32(var8 - vm.f32(0.07)))
				var0 = var0 + 1
				helper_e8b18690(30)
			end
			if at <= 16 then
				helper_604d1827(0)
				var0 = 0
				var28 = helper_31ed5d56(vm.f32(1691.85), vm.f32(858.57), var0, 240)
				var30 = helper_31ed5d56(vm.f32(-3.926991), vm.f32(-1.5707964), var0, 240)
				var27 = vm.f32(vm.sin(var30) * vm.f32(1476.7))
				var29 = vm.f32(vm.cos(var30) * vm.f32(1476.7))
				var27 = vm.f32(var27 + vm.f32(1970.21))
				var29 = vm.f32(var29 + vm.f32(-576.77))
			end
			if at <= 17 then
				var0 = var0 + 1
				var25 = var27
				var26 = var29
				helper_e8b18690(30)
			end
			if at <= 18 then
				helper_e8b18690(240)
			end
			if at <= 19 then
				helper_e8b18690(60)
			end
			if at <= 20 then
				helper_a8e031ba(2570030)
			end
			if at <= 21 then
				helper_e8b18690(30)
			end
			if at <= 22 then
				helper_a8e031ba(2570040)
			end
			if at <= 23 then
				helper_e8b18690(15)
			end
			if at <= 24 then
				helper_e8b18690(30)
			end
			if at <= 25 then
				helper_e8b18690(30)
			end
			if at <= 26 then
				helper_e8b18690(30)
			end
			if at <= 27 then
				helper_e8b18690(30)
			end
			if at <= 28 then
				var0 = 0
				var31 = helper_31ed5d56(vm.f32(3.13), vm.f32(-0.15), var0, 30.0)
				var32 = helper_31ed5d56(vm.f32(-3.07), vm.f32(-0.62), var0, 30.0)
			end
			if at <= 29 then
				var0 = var0 + 1
				helper_a8e031ba(2570050)
			end
			if at <= 30 then
				helper_e8b18690(45)
			end
			if vm.skip_end() then
				return skip(32)
			end
			return part2()
		end
		helper_10ae4()
	end
	function part2()
		event.CancelDramaScene()
		event.CharaDaEnable(global1, 1)
		event.SpriteSetDraw(0, 0)
		helper_10ae4()
		event.SetStatusbarShow(1, 1.0)
		event.SetMotionBlur(0)
		event.PlayBgm(0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(257, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2833)
	var1 = event.SndLoadSound(2833) or var1
	event.StopBgm(0)
	helper_e8b18690(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(31)
	helper_10e64(var1)
	event.ObjsSetMotion(11, "歩き")
	event.CharaActive(0, 11)
	event.SetStatusbarShow(0, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(222.66, 860.66, 315.48)
	event.CmrsSetRef(386.81, 799.84, 241.69)
	event.SetFadeIn(30)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, global1)
	event.EohSetFootSoundId(1, 17)
	event.ObjsSetPos(1, 459.65, 700.0, 314.9)
	event.ObjsSetRot(1, 0.0, -1.63, 0.0)
	event.ObjsJump(1, 338.06, 791.14, 270.62, -0.6, 30)
	event.ObjsSetMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "飛びＬ", 6)
	event.ObjsNextMotion(1, "着地2", 6)
	event.ObjsNextMotion(1, "着地2Ｌ", 6)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_e8b18690(10)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsMove2(222.66, 860.66, 315.48, 374.28, 799.84, 218.4, 30, 2, 1.0)
	event.SndSePlay(var1, 0)
	event.CharaActive(1, global0)
	event.ObjsSetPos(0, 465.64, 700.0, 251.72)
	event.ObjsSetRot(0, 0.0, -1.63, 0.0)
	event.ObjsJump(0, 345.04, 787.93, 219.25, -0.6, 30)
	event.ObjsSetMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "飛びL", 6)
	event.ObjsNextMotion(0, "こける", 6)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CharaDaEnable(global0, 0)
	helper_e8b18690(20)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var1, 1)
	helper_e8b18690(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var1, 2)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CharaDaEnable(global1, 0)
	event.CharaDaEnable(global0, 1)
	event.InitDramaScene()
	var2 = vm.f32(0.116339)
	var3 = vm.f32(0.074309)
	var4 = vm.f32(0.124094)
	var5 = vm.f32(496.65527)
	var6 = vm.f32(526.85187)
	var7 = vm.f32(483.53925)
	var8 = vm.f32(-1.63)
	var9 = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
	var10 = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
	var11 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
	var12 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
	var13 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
	var14 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
	event.CmrsSetPos(var11, 809.42, var12)
	event.CmrsSetRef(var13, 815.5, var14)
	event.ObjsSetPos(1, var9, 791.14, var10)
	event.ObjsSetRot(1, 0.0, var8, 0.0)
	event.ObjsSetMotion(1, "着地2Ｌ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ちあがり", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	if vm.wait() then
		return skip(8)
	end
	event.CharaDaEnable(global1, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsMotionDelay(1, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsMotionDelay(1, 1)
	event.ObjsResetDaPosition(1)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "きょろきょろ歩き", 2)
	event.ObjsNextMotion(1, "歩き", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目～ひき目")
	event.ObjsTexAnime(1, 1, "通常口パク")
	var15 = 2570010
	event.StreamOpen3(1, var15)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(10)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(11)
			end
		end
	end
	event.SetMesOkuri(0, 0)
	event.MesMake_2(0, var15)
	helper_b4b9bfbc(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	var0 = 0
	while var0 < 180 do
		var9 = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
		var10 = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
		var11 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
		var12 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
		var13 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
		var14 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
		event.ObjsSetPos(1, var9, 791.14, var10)
		event.ObjsSetRot(1, 0.0, var8, 0.0)
		event.CmrsSetPos(var11, 809.42, var12)
		event.CmrsSetRef(var13, 815.5, var14)
		var0 = var0 + 1
		if vm.wait() then
			return skip(12)
		end
		var2 = helper_87dfa3c1(vm.f32(var2 - vm.f32(0.002)))
		var8 = helper_87dfa3c1(vm.f32(var8 - vm.f32(0.002)))
		var3 = helper_87dfa3c1(vm.f32(var3 - vm.f32(0.002)))
		var4 = helper_87dfa3c1(vm.f32(var4 - vm.f32(0.002)))
		if var0 == 158 then
			event.ObjsTexAnime(1, 0, "通常口パク")
		end
	end
	helper_604d1827(0)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	var18 = vm.f32(var2 + 0.0625)
	var19 = vm.f32(var5 - 100.0)
	var20 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
	var21 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
	var22 = 2.0
	event.ObjsSetPos(0, var20, 783.25, var21)
	event.ObjsSetRot(0, 0.0, var22, 0.0)
	event.ObjsSetMotion(0, "キョロキョロ歩き")
	event.EohSetFootSoundId(0, 17)
	var0 = 0
	while var0 < 90 do
		var23 = helper_31ed5d56(-0.125, 0.0625, var0, 90)
		var18 = helper_87dfa3c1(vm.f32(var2 + var23))
		var20 = vm.f32(vm.f32(vm.sin(var18) * var19) + vm.f32(268.802))
		var21 = vm.f32(vm.f32(vm.cos(var18) * var19) + vm.f32(-322.002))
		var9 = vm.f32(vm.f32(vm.sin(var2) * var5) + vm.f32(268.802))
		var10 = vm.f32(vm.f32(vm.cos(var2) * var5) + vm.f32(-322.002))
		var11 = vm.f32(vm.f32(vm.sin(var3) * var6) + vm.f32(268.802))
		var12 = vm.f32(vm.f32(vm.cos(var3) * var6) + vm.f32(-322.002))
		var13 = vm.f32(vm.f32(vm.sin(var4) * var7) + vm.f32(268.802))
		var14 = vm.f32(vm.f32(vm.cos(var4) * var7) + vm.f32(-322.002))
		event.ObjsSetPos(0, var20, 783.25, var21)
		event.ObjsSetRot(0, 0.0, var22, 0.0)
		event.ObjsSetPos(1, var9, 791.14, var10)
		event.ObjsSetRot(1, 0.0, var8, 0.0)
		event.CmrsSetPos(var11, 809.42, var12)
		event.CmrsSetRef(var13, 815.5, var14)
		var0 = var0 + 1
		if vm.wait() then
			return skip(13)
		end
		var22 = helper_87dfa3c1(vm.f32(var22 - vm.f32(0.002)))
		var2 = helper_87dfa3c1(vm.f32(var2 - vm.f32(0.002)))
		var8 = helper_87dfa3c1(vm.f32(var8 - vm.f32(0.002)))
		var3 = helper_87dfa3c1(vm.f32(var3 - vm.f32(0.002)))
		var4 = helper_87dfa3c1(vm.f32(var4 - vm.f32(0.002)))
	end
	event.PlayBgm(0)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(0, "指さす", 2)
	event.ObjsNextMotion(0, "指さすL", 4)
	helper_a8e031ba(2570020)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "右振りかえり180度（ＰＧ）", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	var8 = vm.f32(-2.17)
	var0 = 0
	while var0 < 30 do
		event.ObjsSetRot(1, 0.0, var8, 0.0)
		if vm.wait() then
			return skip(15)
		end
		var8 = helper_87dfa3c1(vm.f32(var8 - vm.f32(0.07)))
		var0 = var0 + 1
	end
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(16)
	end
	helper_604d1827(0)
	event.StreamClose(1)
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(1, 11)
	event.CmrsSetPos(356.04, 805.96, -432.95)
	event.CmrsSetRef(414.81, 835.96, -493.23)
	var0 = 0
	while var0 < 240 do
		var28 = helper_31ed5d56(vm.f32(1691.85), vm.f32(858.57), var0, 240)
		var30 = helper_31ed5d56(vm.f32(-3.926991), vm.f32(-1.5707964), var0, 240)
		var27 = vm.f32(vm.sin(var30) * vm.f32(1476.7))
		var29 = vm.f32(vm.cos(var30) * vm.f32(1476.7))
		var27 = vm.f32(var27 + vm.f32(1970.21))
		var29 = vm.f32(var29 + vm.f32(-576.77))
		var24 = event.GetRotLookPos(var27 - var25, var29 - var26) or var24
		event.ObjsSetPos(3, var27, var28, var29)
		event.ObjsSetRot(3, 0.0, var24, 0.0)
		if vm.wait() then
			return skip(17)
		end
		var0 = var0 + 1
		var25 = var27
		var26 = var29
	end
	event.CmrsInit()
	event.CmrsSetPos(564.06, 1040.4275, -876.85254)
	event.CmrsSetRef(535.89, 1075.06, -944.46)
	event.CmrsMove2(648.57, 936.53, -674.03, 535.89, 1075.06, -944.46, 150, 2, 1.0)
	event.ObjsSetPos(3, 500.0, 1100.0, -1000.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.SndSePlay(var1, 4)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(18)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 30)
	helper_e8b18690(240)
	if vm.skipping() then
		return skip(19)
	end
	event.SpriteSetDraw(0, 0)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(0, 11)
	event.CmrsInit()
	event.CmrsSetPos(-242.49, 801.47, -239.88)
	event.CmrsSetRef(-175.51, 815.89, -178.94)
	event.ObjsSetPos(0, -219.74, 784.37, -209.85)
	event.ObjsSetRot(0, 0.0, -1.95, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetPos(1, -215.91, 784.38, -225.43)
	event.ObjsSetRot(1, 0.0, -1.39, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsResetDaPosition(1)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2570030)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向くL")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "かまえる", 2)
	event.ObjsNextMotion(0, "かまえるL", 4)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_a8e031ba(2570040)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-212.52, 803.06, -183.32)
	event.CmrsSetRef(-203.01, 814.64, -250.93)
	event.ObjsSetPos(0, -214.38, 784.37, -234.13)
	event.ObjsSetRot(0, 0.0, 3.13, 0.0)
	event.ObjsSetMotion(0, "かまえるL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetPos(1, -202.79, 784.38, -212.64)
	event.ObjsSetRot(1, 0.0, -3.07, 0.0)
	event.ObjsSetMotion(1, "構えＬ", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おこり目とじ")
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 115.96, 1381.16, -3665.01)
	event.ObjsSetRot(3, 0.7853982, -0.15, 0.0)
	event.ObjsMove(3, -243.09, 926.4, 17.21, 120)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(25)
	end
	event.SndSePlay(var1, 5)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(0, "蝶迫る", 2)
	event.ObjsNextMotion(0, "蝶迫るL", 4)
	event.ObjsSetMotion(1, "構えから顔覆う", 2)
	event.ObjsNextMotion(1, "覆うＬ", 4)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(27)
	end
	event.SetMotionBlur(96)
	event.SetWind(40.0, -9.51001, 0.0, 67.609985)
	event.CmrsQuake2(0.0, 1.0, 0.0, 30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(28)
	end
	event.SetMotionBlur(0)
	event.CharaActive(0, 11)
	event.ObjsSetMotion(0, "振り返る", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "覆いから右回り右180", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	var0 = 0
	while var0 < 30 do
		var31 = helper_31ed5d56(vm.f32(3.13), vm.f32(-0.15), var0, 30.0)
		var32 = helper_31ed5d56(vm.f32(-3.07), vm.f32(-0.62), var0, 30.0)
		event.ObjsSetRot(0, 0.0, var31, 0.0)
		event.ObjsSetRot(1, 0.0, var32, 0.0)
		if vm.wait() then
			return skip(29)
		end
		var0 = var0 + 1
	end
	event.SetWind(-1)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目とじ～おこり目あき")
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2570050)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_e8b18690(45)
	if vm.skipping() then
		return skip(31)
	end
	return part2()
end

--- Helper function.
local function helper_17bac()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 8
		global0 = 8
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e260/e260_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 14)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e260/e260_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 14)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 14)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e260/e260_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 14)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e260/e260_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.LoadChara(5, "event/e200/e260/e260_holly.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4, 12)
	event.ObjsSyncObj(4, 4)
	event.EohSetFrameStatus(4, "kami", 0)
	event.LoadChara(5, "event/e200/e260/e260_lettr1.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5, 13)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "dungeon/monster/b02a1.gltf", "b02a1", 15)
	event.CharaActive(0, 15)
	event.EohSyncChara(6, 15)
	event.ObjsInit(6, 15)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "dungeon/monster/b02a2.gltf", "b02a2", 16)
	event.CharaActive(0, 16)
	event.EohSyncChara(7, 16)
	event.ObjsInit(7, 16)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "dungeon/monster/b02a3.gltf", "b02a3", 17)
	event.CharaActive(0, 17)
	event.EohSyncChara(8, 17)
	event.ObjsInit(8, 17)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "dungeon/monster/b02a4.gltf", "b02a4", 18)
	event.CharaActive(0, 18)
	event.EohSyncChara(9, 18)
	event.ObjsInit(9, 18)
	event.ObjsSyncObj(9, 9)
	event.LoadChara(5, "dungeon/monster/b02a5.gltf", "b02a5", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(10, 19)
	event.ObjsInit(10, 19)
	event.ObjsSyncObj(10, 10)
	event.LoadChara(5, "dungeon/monster/b02a6.gltf", "b02a6", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(11, 20)
	event.ObjsInit(11, 20)
	event.ObjsSyncObj(11, 11)
	event.LoadChara(5, "dungeon/monster/b02a7.gltf", "b02a7", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(12, 21)
	event.ObjsInit(12, 21)
	event.ObjsSyncObj(12, 12)
	event.LoadChara(5, "event/e200/e260/e260_hohikari.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.EohSyncChara(13, 22)
	event.ObjsInit(13, 22)
	event.ObjsSyncObj(13, 13)
	event.LoadChara(5, "event/e200/e260/e260_hohikari1.gltf", "info", 23)
	event.CharaActive(0, 23)
	event.EohSyncChara(14, 23)
	event.ObjsInit(14, 23)
	event.ObjsSyncObj(14, 14)
	block = event.LoadImg_4(5, "textures/event/e200/e260/e260.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e26001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e26002", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(21, 1)
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e26003", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 416)
	event.SpriteSetPutsize(2, 512, 416)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(22, 2)
	event.ObjsInit(22)
	event.ObjsSyncObj(22, 22)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e26004", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416)
	event.SpriteSetPutsize(3, 512, 416)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(23, 3)
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e26005", block)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetUvsize(4, 0, 0, 512.0, 416)
	event.SpriteSetPutsize(4, 512, 416)
	event.SpriteSetPos(4, 256, 208)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(24, 4)
	event.ObjsInit(24)
	event.ObjsSyncObj(24, 24)
	event.LoadMes(0, 5, "event/e200/e260/e260_1.txt")
end

--- Helper function.
local function helper_175bc()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DeleteChara(global1)
		event.DeleteChara(14)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(14)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.DeleteChara(17)
	event.DeleteChara(18)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.DeleteChara(22)
	event.DeleteChara(23)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 0)
	event.SpriteSetDraw(4, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_1a400()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 75 then
			if at <= 1 then
				helper_e8b18690(30)
			end
			if at <= 2 then
				helper_e8b18690(4)
			end
			if at <= 3 then
				helper_17bac()
				helper_e8b18690(30)
			end
			if at <= 4 then
				helper_e8b18690(3)
			end
			if at <= 5 then
				helper_e8b18690(3)
			end
			if at <= 6 then
				helper_e8b18690(3)
			end
			if at <= 7 then
				helper_e8b18690(3)
			end
			if at <= 8 then
				helper_e8b18690(3)
			end
			if at <= 9 then
				helper_e8b18690(3)
			end
			if at <= 10 then
				helper_e8b18690(60)
			end
			if at <= 11 then
				helper_df58599d(10)
			end
			if at <= 12 then
				helper_df58599d(11)
			end
			if at <= 13 then
				helper_df58599d(6)
			end
			if at <= 14 then
				helper_df58599d(7)
			end
			if at <= 15 then
				helper_df58599d(12)
			end
			if at <= 16 then
				helper_df58599d(9)
			end
			if at <= 17 then
				helper_df58599d(8)
			end
			if at <= 18 then
				helper_e8b18690(60)
			end
			if at <= 19 then
				helper_e8b18690(60)
			end
			if at <= 20 then
				helper_e8b18690(150)
			end
			if at <= 21 then
				helper_a8e031ba(2600010)
			end
			if at <= 22 then
				helper_a8e031ba(2600020)
			end
			if at <= 23 then
				helper_a8e031ba(2600030)
			end
			if at <= 24 then
				helper_df58599d(4)
			end
			if at <= 25 then
				helper_a8e031ba(2600040)
			end
			if at <= 26 then
				helper_a8e031ba(2600045)
			end
			if at <= 27 then
				helper_a8e031ba(2600050)
			end
			if at <= 28 then
				helper_df58599d(4)
			end
			if at <= 29 then
				helper_a8e031ba(2600060)
			end
			if at <= 30 then
				helper_e8b18690(15)
			end
			if at <= 31 then
				helper_a8e031ba(2600070)
			end
			if at <= 32 then
				helper_a8e031ba(2600075)
			end
			if at <= 33 then
				helper_a8e031ba(2600080)
			end
			if at <= 34 then
				helper_e8b18690(15)
			end
			if at <= 35 then
				helper_a8e031ba(2600090)
			end
			if at <= 36 then
				helper_e8b18690(15)
			end
			if at <= 37 then
				helper_a8e031ba(2600100)
			end
			if at <= 38 then
				helper_a8e031ba(2600110)
			end
			if at <= 39 then
				helper_a8e031ba(2600115)
			end
			if at <= 40 then
				helper_e8b18690(15)
			end
			if at <= 41 then
				helper_a8e031ba(2600120)
			end
			if at <= 42 then
				helper_a8e031ba(2600130)
			end
			if at <= 43 then
				helper_e8b18690(15)
			end
			if at <= 44 then
				helper_a8e031ba(2600140)
			end
			if at <= 45 then
				helper_a8e031ba(2600145)
			end
			if at <= 46 then
				helper_a8e031ba(2600150)
			end
			if at <= 47 then
				helper_a8e031ba(2600160)
			end
			if at <= 48 then
				helper_e8b18690(15)
			end
			if at <= 49 then
				helper_a8e031ba(2600170)
			end
			if at <= 50 then
				helper_a8e031ba(2600180)
			end
			if at <= 51 then
				helper_a8e031ba(2600190)
			end
			if at <= 52 then
				helper_a8e031ba(2600200)
			end
			if at <= 53 then
				helper_a8e031ba(2600210)
			end
			if at <= 54 then
				helper_a8e031ba(2600220)
			end
			if at <= 55 then
				helper_a8e031ba(2600230)
			end
			if at <= 56 then
				helper_a8e031ba(2600240)
			end
			if at <= 57 then
				helper_a8e031ba(2600250)
			end
			if at <= 58 then
				helper_a8e031ba(2600260)
			end
			if at <= 59 then
				helper_df58599d(4)
			end
			if at <= 60 then
				helper_a8e031ba(2600270)
			end
			if at <= 61 then
				helper_e8b18690(2)
			end
			if at <= 62 then
				helper_e8b18690(120)
			end
			if at <= 63 then
				helper_021e710a(1, 4)
				helper_37d1ae51(1, 10, 8, 0, 0)
			end
			if at <= 64 then
				helper_a8e031ba(2600280)
			end
			if at <= 65 then
				helper_a8e031ba(2600290)
			end
			if at <= 66 then
				helper_a8e031ba(2600300)
			end
			if at <= 67 then
				helper_e8b18690(60)
			end
			if at <= 68 then
				helper_e8b18690(60)
			end
			if at <= 69 then
				helper_e8b18690(150)
			end
			if at <= 70 then
				helper_e8b18690(90)
			end
			if at <= 71 then
				helper_a8e031ba(2600310)
			end
			if at <= 72 then
				helper_df58599d(0)
			end
			if at <= 73 then
				helper_a8e031ba(2600320)
			end
			if at <= 74 then
				helper_e8b18690(45)
			end
			if vm.skip_end() then
				return skip(76)
			end
			return part2()
		end
		helper_175bc()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var1, 0)
		event.StopBgm(0)
		helper_175bc()
		event.SetStatusbarShow(1, 1.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(260, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(2836)
	var0 = event.SndLoadSound(2836) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	event.StopBgm(0)
	helper_e8b18690(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(53)
	event.SndSetEnvVol(0.6)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_17bac()
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.CharaActive(0, 16)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.CharaActive(0, 19)
	event.CharaActive(0, 20)
	event.CharaActive(0, 21)
	event.CharaActive(0, 22)
	event.CharaActive(0, 23)
	event.SetStatusbarShow(0, 1.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 950.0, 200.0)
	event.CmrsSetRef(0.0, 1000.0, 0.0)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(1, 15)
	event.CharaActive(1, 16)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.CharaActive(1, 19)
	event.CharaActive(1, 20)
	event.CharaActive(1, 21)
	event.EohSetScale(6, 0.5, 0.5, 0.5)
	event.EohSetScale(7, 0.5, 0.5, 0.5)
	event.EohSetScale(8, 0.5, 0.5, 0.5)
	event.EohSetScale(9, 0.5, 0.5, 0.5)
	event.EohSetScale(10, 0.5, 0.5, 0.5)
	event.EohSetScale(11, 0.5, 0.5, 0.5)
	event.EohSetScale(12, 0.5, 0.5, 0.5)
	event.ObjsSetPos(6, 0.0, 1000.0, 200.0)
	event.ObjsSetRot(6, 0.0, 3.1415927, 0.0)
	event.ObjsSetMotion(6, "飛行", 4)
	event.ObjsSetPos(7, 141.4, 950.0, 141.4)
	event.ObjsSetRot(7, 0.0, 3.926991, 0.0)
	event.ObjsSetMotion(7, "飛行", 4)
	event.ObjsSetPos(8, -141.4, 950.0, 141.4)
	event.ObjsSetRot(8, 0.0, 2.3561945, 0.0)
	event.ObjsSetMotion(8, "飛行", 4)
	event.ObjsSetPos(9, 70.7, 925.0, 170.7)
	event.ObjsSetRot(9, 0.0, 3.5342917, 0.0)
	event.ObjsSetMotion(9, "飛行", 4)
	event.ObjsSetPos(10, 70.7, 975.0, 170.7)
	event.ObjsSetRot(10, 0.0, 3.5342917, 0.0)
	event.ObjsSetMotion(10, "飛行", 4)
	event.ObjsSetPos(11, -70.7, 925.0, 170.7)
	event.ObjsSetRot(11, 0.0, 27.488937, 0.0)
	event.ObjsSetMotion(11, "飛行", 4)
	event.ObjsSetPos(12, -70.7, 975.0, 170.7)
	event.ObjsSetRot(12, 0.0, 27.488937, 0.0)
	event.ObjsSetMotion(12, "飛行", 4)
	event.ObjsMove(10, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(3)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(11, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(3)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove(6, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(3)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsMove(7, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(3)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMove(12, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(3)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsMove(9, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(3)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsMove(8, 0.0, 1000.0, 0.0, 120)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(1, 22)
	event.ObjsSetPos(13, 0.0, 1000.0, 0.0)
	event.ObjsSetMotion(13, "ホーリーの光", 6)
	event.SndSeStop(var0, 0)
	helper_df58599d(10)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(0, 19)
	helper_df58599d(11)
	if vm.skipping() then
		return skip(13)
	end
	event.CharaActive(0, 20)
	helper_df58599d(6)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(0, 15)
	helper_df58599d(7)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(0, 16)
	helper_df58599d(12)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(0, 21)
	helper_df58599d(9)
	if vm.skipping() then
		return skip(17)
	end
	event.CharaActive(0, 18)
	helper_df58599d(8)
	if vm.skipping() then
		return skip(18)
	end
	event.CharaActive(0, 17)
	event.SndSePlay(var0, 1)
	event.CharaActive(1, 12)
	event.SetCharaShow(12, 1, 1, 0.05)
	event.ObjsSetPos(4, 0.0, 980.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "現れる", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "目とじ")
	event.CharaActive(1, 23)
	event.ObjsSetPos(14, 0.0, 980.0, 0.0)
	event.ObjsSetRot(14, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(14, "光MAX", 4)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(14, "消える", 2)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(20)
	end
	event.CharaActive(0, 22)
	event.CharaActive(0, 23)
	event.CmrsSetPos(0.0, 1010.0, 35.0)
	event.CmrsSetRef(0.0, 1010.0, 0.0)
	event.ObjsSetPos(4, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "目とじ")
	event.CmrsMove(0.0, 1025.0, 35.0, 0.0, 1025.0, 0.0, 150)
	helper_e8b18690(150)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "目とじ～目あき")
	event.PlayBgm(0)
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600010)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CmrsSetPos(-2.24, 796.76, -510.87)
	event.CmrsSetRef(-68.02, 802.26, -509.43)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 14)
	event.CharaActive(0, 12)
	event.ObjsSetPos(0, -42.69, 774.65, -517.65)
	event.ObjsSetRot(0, 0.0, 2.13, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, -28.93, 774.65, -505.13)
	event.ObjsSetRot(1, 0.0, 2.61, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600020)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(19.58, 1019.28, 33.73)
	event.CmrsSetRef(-28.59, 1038.2, -27.4)
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 14)
	event.CharaActive(1, 12)
	event.ObjsSetMotion(4, "会話2", 2)
	event.ObjsNextMotion(4, "立ち")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600030)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(4, "立ち")
	event.ResetPakuAnim()
	helper_df58599d(4)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-2.24, 796.76, -510.87)
	event.CmrsSetRef(-68.02, 802.26, -509.43)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 14)
	event.CharaActive(0, 12)
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600040)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600045)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(0.0, 1025.0, 35.0)
	event.CmrsSetRef(0.0, 1025.0, 0.0)
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 14)
	event.CharaActive(1, 12)
	event.ObjsSetMotion(4, "うつむく", 6)
	event.ObjsNextMotion(4, "うつむくL", 6)
	event.ObjsNextMotion(4, "顔を上げる", 2)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "目あき～目とじ")
	event.ObjsTexaDelay(4, 75)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "目とじ～目あき")
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600050)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	helper_df58599d(4)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(-2.24, 796.76, -510.87)
	event.CmrsSetRef(-68.02, 802.26, -509.43)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 14)
	event.CharaActive(0, 12)
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600060)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 128.0, 15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(31)
	end
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 14)
	event.CharaActive(0, 12)
	helper_a8e031ba(2600070)
	if vm.skipping() then
		return skip(32)
	end
	helper_a8e031ba(2600075)
	if vm.skipping() then
		return skip(33)
	end
	helper_a8e031ba(2600080)
	if vm.skipping() then
		return skip(34)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(21, 128.0, 128.0, 128.0, 128.0, 15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(35)
	end
	event.SpriteSetDraw(0, 0)
	helper_a8e031ba(2600090)
	if vm.skipping() then
		return skip(36)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(22, 128.0, 128.0, 128.0, 128.0, 15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(37)
	end
	event.SpriteSetDraw(1, 0)
	helper_a8e031ba(2600100)
	if vm.skipping() then
		return skip(38)
	end
	helper_a8e031ba(2600110)
	if vm.skipping() then
		return skip(39)
	end
	helper_a8e031ba(2600115)
	if vm.skipping() then
		return skip(40)
	end
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(23, 128.0, 128.0, 128.0, 128.0, 15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(41)
	end
	event.SpriteSetDraw(2, 0)
	helper_a8e031ba(2600120)
	if vm.skipping() then
		return skip(42)
	end
	helper_a8e031ba(2600130)
	if vm.skipping() then
		return skip(43)
	end
	event.SpriteSetDraw(4, 1)
	event.ObjsSetColor(24, 128.0, 128.0, 128.0, 128.0, 15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(44)
	end
	event.SpriteSetDraw(3, 0)
	helper_a8e031ba(2600140)
	if vm.skipping() then
		return skip(45)
	end
	helper_a8e031ba(2600145)
	if vm.skipping() then
		return skip(46)
	end
	helper_a8e031ba(2600150)
	if vm.skipping() then
		return skip(47)
	end
	helper_a8e031ba(2600160)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(19.72, 819.45, -34.3)
	event.CmrsSetRef(0.0, 823.12, 0.0)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 14)
	event.CharaActive(1, 12)
	event.ObjsSetPos(0, -15.79, 795.0, 7.98)
	event.ObjsSetRot(0, 0.0, 2.3, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, 0.0, 795.0, 10.0)
	event.ObjsSetRot(1, 0.0, 3.1415927, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(4, 0.0, 795.0, -10.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.ObjsSetColor(24, 128.0, 128.0, 128.0, 0.0, 15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(49)
	end
	event.SpriteSetDraw(4, 0)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600170)
	if vm.skipping() then
		return skip(50)
	end
	event.ResetPakuAnim()
	event.CmrsMoveAhd(0.79, -4.57, 45.0, 360)
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600180)
	if vm.skipping() then
		return skip(51)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600190)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600200)
	if vm.skipping() then
		return skip(53)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600210)
	if vm.skipping() then
		return skip(54)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600220)
	if vm.skipping() then
		return skip(55)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600230)
	if vm.skipping() then
		return skip(56)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600240)
	if vm.skipping() then
		return skip(57)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600250)
	if vm.skipping() then
		return skip(58)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 13)
	event.SetReference(12, "letter", 13)
	event.ObjsSetMotion(4, "手紙を渡す", 2)
	event.ObjsNextMotion(4, "手紙を渡すL", 4)
	event.SndSePlay(var0, 2)
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600260)
	if vm.skipping() then
		return skip(59)
	end
	event.ResetPakuAnim()
	helper_df58599d(4)
	if vm.skipping() then
		return skip(60)
	end
	event.CmrsInit()
	event.CmrsSetPos(-2.24, 796.76, -510.87)
	event.CmrsSetRef(-68.02, 802.26, -509.43)
	event.CharaActive(0, 12)
	event.ObjsSetPos(0, -42.69, 774.65, -517.65)
	event.ObjsSetRot(0, 0.0, 2.13, 0.0)
	event.ObjsResetDaPosition(0)
	event.DelReference(13)
	event.SetReference(global1, "sword_hand", 13)
	event.ObjsSetPos(1, -28.93, 774.65, -505.13)
	event.ObjsSetRot(1, 0.0, 2.61, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "封筒受け取り", 6)
	event.ObjsNextMotion(1, "封筒受け取りＬ", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SndSePlay(var0, 3)
	event.SetPakuAnim(1, "わらい口パク")
	helper_a8e031ba(2600270)
	if vm.skipping() then
		return skip(61)
	end
	event.ResetPakuAnim()
	event.SndPauseBgm()
	event.CharaActive(1, 11)
	event.SetCharaPos(11, -18.72, 797.98, -512.22)
	event.SetCharaRot(11, 0.0, 1.5707964, 0.0)
	event.SetMotion(11, "発動", 6)
	helper_e8b18690(2)
	if vm.skipping() then
		return skip(62)
	end
	event.SndSePlay(var1, 0)
	helper_e8b18690(120)
	if vm.skipping() then
		return skip(63)
	end
	event.SndSePlay(var0, 4)
	event.SetMesPreset(1, 4)
	helper_021e710a(1, 4)
	event.SetMesItem(1, 1, 385)
	helper_37d1ae51(1, 10, 8, 0, 0)
	if vm.skipping() then
		return skip(64)
	end
	event.PlayBgm(0)
	event.CharaActive(0, 11)
	event.DelReference(13)
	event.CharaActive(0, 13)
	event.CmrsSetPos(0.0, 1017.78, 76.79)
	event.CmrsSetRef(0.0, 1025.0, 0.0)
	event.CmrsMove(0.0, 1025.0, 35.0, 0.0, 1025.0, 0.0, 180)
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 14)
	event.CharaActive(1, 12)
	event.ObjsSetPos(4, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600280)
	if vm.skipping() then
		return skip(65)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600290)
	if vm.skipping() then
		return skip(66)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "口パク")
	helper_a8e031ba(2600300)
	if vm.skipping() then
		return skip(67)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 23)
	event.ObjsSetPos(14, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(14, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(14, "光る", 6)
	event.ObjsNextMotion(14, "光MAX", 4)
	event.SndSePlay(var0, 5)
	event.FadeOutBgm(30)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(68)
	end
	event.CmrsInit()
	event.CmrsSetPos(186.87, 1388.53, 256.46)
	event.CmrsSetRef(0.0, 1025.0, 0.0)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.ObjsSetPos(0, -143.38, 788.23, 56.15)
	event.ObjsSetRot(0, 0.0, 2.3, 0.0)
	event.ObjsSetPos(1, -123.21, 788.97, 62.99)
	event.ObjsSetRot(1, 0.0, 2.46, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上から左", 5)
	event.CharaActive(1, 22)
	event.ObjsSetPos(13, 0.0, 1000.0, 0.0)
	event.ObjsResetMotion(13)
	event.ObjsSetMotion(13, "ホーリーの光", 6)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(69)
	end
	event.CharaActive(0, 12)
	event.CharaActive(0, 23)
	event.CharaActive(1, 15)
	event.CharaActive(1, 16)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.CharaActive(1, 19)
	event.CharaActive(1, 20)
	event.CharaActive(1, 21)
	event.ObjsSetPos(6, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(6, 0.0, 0.7853982, 0.0)
	event.ObjsSetPos(7, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(7, 0.0, 1.5707964, 0.0)
	event.ObjsSetPos(8, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(8, 0.0, 2.3561945, 0.0)
	event.ObjsSetPos(9, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(9, 0.0, 3.1415927, 0.0)
	event.ObjsSetPos(10, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(10, 0.0, -2.3561945, 0.0)
	event.ObjsSetPos(11, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(11, 0.0, -1.5707964, 0.0)
	event.ObjsSetPos(12, 0.0, 1000.0, 0.0)
	event.ObjsSetRot(12, 0.0, -0.7853982, 0.0)
	event.ObjsMove(6, 353.55338, 1000.0, 353.55338, 120)
	event.ObjsMove(7, 500.0, 1000.0, 0.0, 120)
	event.ObjsMove(8, 353.55338, 1000.0, -353.55338, 120)
	event.ObjsMove(9, 0.0, 1000.0, -500.0, 120)
	event.ObjsMove(10, -353.55338, 1000.0, -353.55338, 120)
	event.ObjsMove(11, -500.0, 1000.0, 0.0, 120)
	event.ObjsMove(12, -353.55338, 1000.0, 353.55338, 120)
	event.SndSePlay(var0, 6)
	helper_e8b18690(150)
	if vm.skipping() then
		return skip(70)
	end
	event.CharaActive(0, 15)
	event.CharaActive(0, 16)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.CharaActive(0, 19)
	event.CharaActive(0, 20)
	event.CharaActive(0, 21)
	event.CharaActive(0, 22)
	event.CmrsSetPos(-2.24, 796.76, -510.87)
	event.CmrsSetRef(-68.02, 802.26, -509.43)
	event.SndSetEnvVol(1.0)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 14)
	event.ObjsSetPos(0, -42.69, 774.65, -517.65)
	event.ObjsSetRot(0, 0.0, 2.49, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetPos(1, -28.93, 774.65, -505.13)
	event.ObjsSetRot(1, 0.0, 2.61, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "上から左", 5)
	helper_e8b18690(90)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(1, "上から左", 2)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2600310)
	if vm.skipping() then
		return skip(72)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "上向く戻り", 2)
	event.ObjsNextMotion(0, "右向く", 6)
	event.ObjsMotionWait(0)
	helper_df58599d(0)
	if vm.skipping() then
		return skip(73)
	end
	event.ObjsSetMotion(0, "右向くうなづき", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a8e031ba(2600320)
	if vm.skipping() then
		return skip(74)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_e8b18690(45)
	if vm.skipping() then
		return skip(75)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11fd8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e8b18690(4)
		end
	end
	helper_1c6f5ce6()
	helper_389b7d93()
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_e8b18690(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(31)
	event.PlayBgm(0)
	event.SetCharaPos(0, -124.13, 782.88, -644.77)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1c6f5ce6()
			helper_389b7d93()
		end
	end
	helper_11fd8()
	if vm.skipping() then
		return skip(1)
	end
	helper_1c6f5ce6()
	helper_389b7d93()
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.SetCharaPos(0, -124.13, 782.88, -644.77)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Program 501.
script[501] = function()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1a400()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_85bca15b(0)
		end
	end
	function part2()
		event.AddItem(385)
		helper_85bca15b(0)
		if vm.skipping() then
			return skip(3)
		end
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("d02b01")
		event.LoadScript("d02b01/d02b01.stb", 201)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.StopBgm(0)
	event.SetFadeOut(30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	stage_id = event.DngGetStageId() or stage_id
	var1 = event.DngGetFloorId() or var1
	event.SetFloorInfo(stage_id, var1, 5, 2)
	helper_1a400()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DngPause(3, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "The butterfly separated into seven\nbutterflies. Now you can get them\none by one!")
	helper_37d1ae51(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(3, 0)
	event.Finish()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DngPause(3, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"Butterflies are sensitive to sound\nand movement. If you don't sneak up\nquietly, they'll escape."
	)
	helper_37d1ae51(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(3, 0)
	event.Finish()
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DngPause(3, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "You have to defeat them in a\ncertain order. Think about\nrainbows...")
	helper_37d1ae51(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(3, 0)
	event.Finish()
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DngPause(3, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "Defeat them in the order of the\ncolors of the rainbow. The first\none is red.")
	helper_37d1ae51(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(3, 0)
	event.Finish()
end

--- Program 506.
script[506] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DngPause(3, 1)
	event.CmrsInit()
	event.CmrsSetPos(665.3, 1226.64, 776.05)
	event.CmrsSetRef(426.01, 939.19, -311.58)
	helper_e8b18690(300)
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(3, 0)
end

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_37d1ae51(0, -1, 5, 0, 0)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.DngPause(1, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]Nothing seems to work against\n   the Rainbow Butterfly.\n   You better try coming up with\n   another course of action."
	)
	helper_37d1ae51(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[(!)]The Rainbow Butterfly appeared as soon\n   as the Lafrescia bloomed... Which means\n   the flower itself may hold a clue to\n   help you defeat the Rainbow Butterfly."
	)
	helper_37d1ae51(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(1, 0)
	event.Finish()
end

--- Program 510.
script[510] = function()
	event.PlayBgm(0)
end

--- Program 511.
script[511] = function()
	event.PlayBgm(1)
end

--- Program 512.
script[512] = function()
	event.StopBgm(0)
end

--- Program 513.
script[513] = function()
	event.StopBgm(1)
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f12f1691(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12551.
script[12551] = function()
	event.LoadDungeonMapFile("d02b01")
	event.LoadScript("d02b01/d02b01.stb", 12551)
end

--- Program 12552.
script[12552] = function()
	event.LoadDungeonMapFile("d02b01")
	event.LoadScript("d02b01/d02b01.stb", 12552)
end

--- Program 12560.
script[12560] = function()
	event.LoadDungeonMapFile("d02b01")
	event.LoadScript("d02b01/d02b01.stb", 12560)
end

--- Program 12570.
script[12570] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11fd8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12600.
script[12600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1a400()
	if vm.skipping() then
		return skip(1)
	end
end

return script
