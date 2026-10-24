--!strict
-- map/d/d02/b01/d02b01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_043f6604 = require("@lib/event/helper_043f6604")
local helper_0775cc3d = require("@lib/event/helper_0775cc3d")
local helper_180778df = require("@lib/event/helper_180778df")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_4b68ef15 = require("@lib/event/helper_4b68ef15")
local helper_4b830b8e = require("@lib/event/helper_4b830b8e")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_7e1e9066 = require("@lib/event/helper_7e1e9066")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_b431dfdc = require("@lib/event/helper_b431dfdc")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_c9057fa5 = require("@lib/event/helper_c9057fa5")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")
local helper_e31fb26a = require("@lib/event/helper_e31fb26a")
local helper_ec112754 = require("@lib/event/helper_ec112754")
local helper_f2fdc03d = require("@lib/event/helper_f2fdc03d")
local helper_f4bcb68c = require("@lib/event/helper_f4bcb68c")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1754c()
	local active_chr_no: s32 = 0
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
		event.LoadMotion(5, "event/e200/e256/e256_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e256/e256_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e256/e256_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e256/e256_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadMes(0, 5, "event/e200/e256/e256_1.txt")
end

--- Helper function.
local function helper_171b4()
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
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
end

--- Helper function.
local function helper_18268()
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local stream_open_state_3: s32 = 0
	local stream_open_state_4: s32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 18 then
			if at <= 1 then
				helper_1754c()
				var8 = vm.f32(vm.sin(vm.f32(vm.f32(-1.51) + var7)) * var6)
				var9 = vm.f32(vm.cos(vm.f32(vm.f32(-1.51) + var7)) * var6)
				helper_aafd6a80(60)
			end
			if at <= 2 then
				helper_6c719c99(2560010)
			end
			if at <= 3 then
				helper_8f31f334(0)
			end
			if at <= 4 then
				helper_8f31f334(1)
			end
			if at <= 5 then
				helper_6c719c99(2560020)
			end
			if at <= 6 then
				helper_6c719c99(2560030)
			end
			if at <= 7 then
				helper_8f31f334(0)
			end
			if at <= 8 then
				helper_8f31f334(1)
			end
			if at <= 9 then
				helper_aafd6a80(11)
			end
			if at <= 12 then
				helper_aafd6a80(11)
			end
			if at <= 13 then
				helper_aafd6a80(8)
			end
			if at <= 16 then
				var14 = 0
				var15 = helper_043f6604(1.0, vm.f32(0.45), var14, 60)
			end
			if at <= 17 then
				var14 = var14 + 1
				helper_aafd6a80(45)
			end
			if vm.skip_end() then
				return skip(19)
			end
			return part2()
		end
		helper_171b4()
	end
	function part2()
		event.CancelDramaScene()
		helper_171b4()
		event.SetStatusbarShow(1, 1.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(256, 1)
	helper_e31fb26a(2)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2830)
	var4 = event.SndLoadSound(2830) or var4
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_1754c()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.SetStatusbarShow(0, 1.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(198.99, 28.85, 11.03)
	event.CmrsSetRef(261.25, 30.97, -11.58)
	event.ObjsSetPos(0, 238.89, 10.0, -8.34)
	event.ObjsSetRot(0, 0.0, -1.51, 0.0)
	event.ObjsSetMotion(0, "触ろうとする", 5, -1.0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	var6 = event.DistVector(13.2361, 0.0, -6.22552) or var6
	var7 = event.Atan2f(13.2361, -6.22552) or var7
	var8 = vm.f32(vm.sin(vm.f32(vm.f32(-1.51) + var7)) * var6)
	var9 = vm.f32(vm.cos(vm.f32(vm.f32(-1.51) + var7)) * var6)
	event.ObjsSetPos(1, vm.f32(238.89) + var8, 10.0, vm.f32(-8.34) + var9)
	event.ObjsSetRot(1, 0.0, -1.51, 0.0)
	event.ObjsSetMotion(1, "触ろうとする", 5, -1.0, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetFadeIn(30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "触ろうとする", 6)
	event.ObjsNextMotion(0, "触ろうとするL", 4)
	event.ObjsSetMotion(1, "触ろうとする", 6)
	event.ObjsNextMotion(1, "触ろうとするL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(2560010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "やめときなよ", 6)
	event.ObjsNextMotion(0, "やめときなよL", 4)
	event.ObjsSetMotion(1, "やめときなよ", 6)
	event.ObjsNextMotion(1, "やめときなよL", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SndSePlay(var4, 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(2560020)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "わらい口パク")
	helper_6c719c99(2560030)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "つるをつかむ", 6)
	event.ObjsNextMotion(0, "つるをつかむL", 4)
	event.ObjsSetMotion(0, "上へ", 6)
	event.ObjsNextMotion(0, "上へL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(1, "つるをつかむ", 6)
	event.ObjsNextMotion(1, "つるをつかむL", 4)
	event.ObjsSetMotion(1, "上へ", 6)
	event.ObjsNextMotion(1, "上へL", 4)
	helper_aafd6a80(11)
	if vm.skipping() then
		return skip(10)
	end
	event.StreamOpen3(1, 2560040)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(11)
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
				return skip(12)
			end
		end
	end
	event.StreamPlay(1)
	helper_aafd6a80(11)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var4, 1)
	helper_aafd6a80(8)
	if vm.skipping() then
		return skip(14)
	end
	event.StreamClose(1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "大口パク")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 1, "通常口パク")
	event.SndSePlay(var4, 2)
	event.CmrsSetPos(227.57, 420.0, -4.83)
	event.CmrsSetRef(236.82, 22.53, -16.55)
	event.ObjsMove(0, 238.89, 410.0, -8.34, 60)
	event.ObjsMove(1, vm.f32(238.89) + var8, 410.0, vm.f32(-8.34) + var9, 60)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	event.StreamOpen3(1, 2560050)
	while true do
		stream_open_state_3 = event.StreamOpenCheck() or stream_open_state_3
		if stream_open_state_3 == 0 then
			break
		else
			if vm.wait() then
				return skip(15)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_4 = event.StreamOpenCheck() or stream_open_state_4
		if stream_open_state_4 == 0 then
			break
		else
			if vm.wait() then
				return skip(16)
			end
		end
	end
	event.StreamPlay(1)
	event.FuncPointShow("neba", "nebaanime", 0)
	event.EohSyncObj(28, "neba", "neba3")
	var14 = 0
	while var14 < 60 do
		var15 = helper_043f6604(1.0, vm.f32(0.45), var14, 60)
		event.EohSetScale(28, var15, var15, var15)
		if vm.wait() then
			return skip(17)
		end
		var14 = var14 + 1
	end
	event.SetFadeOut(30)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(18)
	end
	event.StreamClose(1)
	return part2()
end

--- Helper function.
local function helper_12be0()
	local active_chr_no: s32 = 0
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
		event.LoadMotion(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e255/e255_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e255/e255_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e200/e255/taiysizk_t.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(4, 11)
	event.ObjsInit(3, 11)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/e200/e255/e255_rafhikari.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(5, 14)
	event.ObjsInit(4, 14)
	event.ObjsSyncObj(4, 5)
	event.LoadChara(5, "event/e200/e255/e255_rafkage.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.EohSyncChara(6, 15)
	event.ObjsInit(5, 15)
	event.ObjsSyncObj(5, 6)
	event.SetStatus(1, 15, 512, 1)
	event.EsmInitialize(5)
	event.EsmLoadBasePack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e200/e255/e255_1.txt")
end

--- Helper function.
local function helper_12788()
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
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(11)
	event.DeleteChara(14)
	event.DeleteChara(15)
	event.EsmClear()
	event.LoadMes(0, -1)
end

--- Helper function.
local function helper_13d74()
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_e31fb26a(0)
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_12be0()
				helper_aafd6a80(60)
			end
			if at <= 3 then
				helper_aafd6a80(15)
			end
			if at <= 4 then
				var9 = vm.f32(vm.f32(vm.f32(280.0 - pos_x) * vm.f32(0.7)) + pos_x)
				var10 = -30.0
				var11 = vm.f32(vm.f32(vm.f32(-360.0 - pos_z) * vm.f32(0.7)) + pos_z)
				helper_aafd6a80(30)
			end
			if at <= 5 then
				helper_aafd6a80(30)
			end
			if at <= 6 then
				helper_aafd6a80(60)
			end
			if at <= 7 then
				helper_aafd6a80(120)
			end
			if at <= 8 then
				helper_aafd6a80(30)
			end
			if at <= 9 then
				helper_aafd6a80(15)
			end
			if at <= 10 then
				helper_aafd6a80(30)
			end
			if at <= 11 then
				helper_aafd6a80(15)
			end
			if at <= 12 then
				helper_aafd6a80(30)
			end
			if at <= 13 then
				helper_aafd6a80(60)
			end
			if at <= 14 then
				helper_aafd6a80(15)
			end
			if at <= 15 then
				helper_aafd6a80(30)
			end
			if at <= 16 then
				helper_aafd6a80(45)
			end
			if at <= 17 then
				helper_e31fb26a(1)
				var12 = 0
				var13 = helper_043f6604(128.0, 64.0, var12, 120)
				var12 = var12 + 1
			end
			if at <= 18 then
				helper_aafd6a80(180)
			end
			if at <= 19 then
				helper_aafd6a80(180)
			end
			if at <= 20 then
				helper_1f9a3afd(2550010, 180)
			end
			if at <= 21 then
				helper_1f9a3afd(2550020, 90)
			end
			if at <= 22 then
				helper_aafd6a80(35)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		helper_12788()
		helper_e31fb26a(2)
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var4, 3)
		event.SetModelLightSwitch(global0, 1)
		event.SetModelLightSwitch(global1, 1)
		event.SetModelLightSwitch(13, 1)
		event.SetModelLightSwitch(3, 1)
		helper_12788()
		event.SetStatusbarShow(1, 1.0)
		helper_e31fb26a(2)
		event.SetMotion(0, "立ち")
		event.SetCharaPos(0, 152.66, 0.07, 288.35)
		event.SetCharaRot(0, 0.0, 2.57, 0.0)
		event.ResetCamera(1, 3.14, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(255, 1)
	helper_e31fb26a(0)
	event.FuncPointShow("", "e255", 0)
	event.FuncPointShow("", "e256", 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(2827)
	var4 = event.SndLoadSound(2827) or var4
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_12be0()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.SetStatusbarShow(0, 1.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(165.23, 27.59, -378.25)
	event.CmrsSetRef(193.46, 7.26, -193.75)
	event.SetReference(global0, "ef00", 11)
	event.ObjsSetPos(0, 205.98, 0.0, -180.32)
	event.ObjsSetRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetMotion(0, "投げる", 5)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetPos(1, 171.66, 0.0, -193.35)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsMove(201.05, 139.37, -720.52, 257.49, -54.51, -224.57, 150)
	event.SetFadeIn(30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "投げる", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var4, 0)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "ef00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.DelReference(11)
	event.ObjsSetPos(3, pos_x, pos_y, pos_z)
	var9 = vm.f32(vm.f32(vm.f32(280.0 - pos_x) * vm.f32(0.7)) + pos_x)
	var10 = -30.0
	var11 = vm.f32(vm.f32(vm.f32(-360.0 - pos_z) * vm.f32(0.7)) + pos_z)
	event.ObjsJump(3, var9, var10, var11, -0.5, 30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	event.EsmCreate("足水パシャ")
	event.EsmSetVect1(var9, var10, var11)
	event.SndSePlay(var4, 1)
	event.CharaActive(0, 11)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	event.CmrsSetPos(376.67, 142.57, -99.0)
	event.CmrsSetRef(308.65, 16.16, -300.89)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(7)
	end
	event.CharaActive(1, 14)
	event.ObjsSetPos(4, 306.62, 23.94, -274.4)
	event.ObjsSetMotion(4, "ラフレシアの光", 6)
	event.SndSePlay(var4, 2)
	helper_aafd6a80(120)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(0, 14)
	event.CmrsSetPos(209.92, 20.41, -217.76)
	event.CmrsSetRef(193.9, 22.53, -164.47)
	event.ObjsSetPos(0, 203.0, 0.0, -178.08)
	event.ObjsSetRot(0, 0.0, 2.21, 0.0)
	event.ObjsSetMotion(0, "まぶしい", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "目とじ")
	event.ObjsTexAnime(0, 1, "大口")
	event.ObjsSetPos(1, 195.5, 0.0, -191.28)
	event.ObjsSetRot(1, 0.0, 1.85, 0.0)
	event.ObjsSetMotion(1, "まぶしいＬ", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "目とじ")
	event.FuncPointShow("", "light", 1)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(9)
	end
	event.FuncPointShow("", "light", 0)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.ObjsTexAnime(0, 1, "大口～半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	event.ObjsTexAnime(1, 1, "口とじ～大口")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsQuake(0.0, 0.5, 0.0, -1)
	event.SndSePlay(var4, 3)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "きょろきょろ入り", 2)
	event.ObjsNextMotion(0, "きょろきょろ", 4)
	event.ObjsSetMotion(1, "きょろきょろ入り", 2)
	event.ObjsNextMotion(1, "きょろきょろ入りＬ", 4)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsMove(209.92, 140.41, -217.76, 193.9, 142.53, -164.47, 150)
	event.ObjsMove(0, 203.0, 120.0, -178.08, 150)
	event.ObjsMove(1, 195.5, 120.0, -191.28, 150)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "ころげる", 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "大口パク")
	event.ObjsSetMotion(1, "こける", 2)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "大口パク")
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var4, 4)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var4, 5)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsInit()
	event.CmrsSetPos(66.68, 32.93, 571.9)
	event.CmrsSetRef(9.6, -29.41, 637.45)
	event.CmrsMove(66.68, 94.82, 571.9, 9.6, -29.41, 637.45, 300)
	helper_e31fb26a(1)
	event.CharaActive(1, 15)
	event.ObjsSetPos(5, 304.99, -11.65, 256.72)
	event.ObjsSetRot(5, 0.0, -0.6, 0.0)
	event.ObjsMove(5, 180.23, -11.65, 406.64, 300)
	event.ObjsSetPos(0, 35.85, -11.65, 620.66)
	event.ObjsSetRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetMotion(0, "ころげるふるふる", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目とじ")
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "ころげるL")
	event.ObjsTexaDelay(0, 90)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目とじ～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsSetPos(1, 25.34, -12.1, 603.98)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetMotion(1, "体おこし", 5)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "ひき目とじ")
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "体おこし", 6)
	event.ObjsNextMotion(1, "おこしＬ", 4)
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "ひき目とじ～おどろき目")
	event.ObjsTexAnime(1, 1, "口とじ～おどろき口")
	event.ObjsResetDaPosition(1)
	event.SetModelLightSwitch(global0, 0)
	event.SetModelLightSwitch(global1, 0)
	event.SetModelLightSwitch(13, 0)
	event.SetModelLightSwitch(3, 0)
	var12 = 0
	while var12 < 120 do
		var13 = helper_043f6604(128.0, 64.0, var12, 120)
		event.SetModelLightColor(global0, var13, var13, var13, 128.0)
		event.SetModelLightColor(global1, var13, var13, var13, 128.0)
		event.SetModelLightColor(13, var13, var13, var13, 128.0)
		event.SetModelLightColor(3, var13, var13, var13, 128.0)
		var12 = var12 + 1
		if vm.wait() then
			return skip(18)
		end
	end
	event.ObjsSetMotion(0, "見上げる", 2)
	event.ObjsNextMotion(0, "見上げるL", 4)
	helper_aafd6a80(180)
	if vm.skipping() then
		return skip(19)
	end
	event.CharaActive(0, 15)
	event.SndSeStop(var4, 3)
	event.CmrsSetPos(102.35, 17.52, 484.45)
	event.CmrsSetRef(149.91, 29.34, 259.34)
	event.CmrsMove(102.35, 17.52, 484.45, 149.91, 192.84, 259.34, 150)
	helper_aafd6a80(180)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(27.96, 10.19, 586.18)
	event.CmrsSetRef(27.35, -2.18, 625.61)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_1f9a3afd(2550010, 180)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "大口パク")
	helper_1f9a3afd(2550020, 90)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_aafd6a80(35)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_1054c()
	local active_chr_no: s32 = 0
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
		event.LoadMotion(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e255/e255_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e255/e255_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e200/e255/e255_rafu_tane.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(4, 11)
	event.ObjsInit(3, 11)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/e200/e255/e255_rafbaku.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(5, 14)
	event.ObjsInit(4, 14)
	event.ObjsSyncObj(4, 5)
	event.EsmInitialize(5)
	event.EsmLoadBasePack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.EsmInitFix(5)
end

--- Helper function.
local function helper_10154()
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
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(11)
	event.DeleteChara(14)
	event.EsmClear()
end

--- Helper function.
local function helper_11514()
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_e31fb26a(3)
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_1054c()
				helper_aafd6a80(60)
			end
			if at <= 3 then
				helper_aafd6a80(15)
			end
			if at <= 4 then
				helper_aafd6a80(30)
			end
			if at <= 5 then
				helper_aafd6a80(30)
			end
			if at <= 6 then
				helper_aafd6a80(60)
			end
			if at <= 7 then
				var9 = 0.0
				var10 = 30.0
				var11 = helper_043f6604(0.0, 1.0, var9, var10)
				var9 = vm.f32(var9 + 1.0)
			end
			if at <= 8 then
				helper_aafd6a80(90)
			end
			if at <= 9 then
				helper_aafd6a80(35)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		helper_10154()
		helper_e31fb26a(0)
	end
	function part2()
		event.CancelDramaScene()
		helper_10154()
		event.SetStatusbarShow(1, 1.0)
		helper_e31fb26a(0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(255, 1)
	helper_e31fb26a(3)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(2824)
	var4 = event.SndLoadSound(2824) or var4
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_1054c()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.SetStatusbarShow(0, 1.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(165.23, 27.59, -378.25)
	event.CmrsSetRef(193.46, 7.26, -193.75)
	event.SetReference(global0, "ef00", 11)
	event.ObjsSetPos(0, 205.98, 0.0, -180.32)
	event.ObjsSetRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetMotion(0, "投げる", 5)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetPos(1, 171.66, 0.0, -193.35)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsMove(201.05, 139.37, -720.52, 257.49, -54.51, -224.57, 150)
	event.SetFadeIn(30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "投げる", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var4, 0)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "ef00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.DelReference(11)
	event.ObjsSetPos(3, pos_x, pos_y, pos_z)
	event.ObjsJump(3, 280.0, -30.0, -360.0, -0.5, 30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	event.EsmCreate("足水パシャ")
	event.EsmSetVect1(280.0, -30.0, -360.0)
	event.SndSePlay(var4, 1)
	event.CharaActive(0, 11)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	event.CmrsSetPos(376.67, 142.57, -99.0)
	event.CmrsSetRef(308.65, 16.16, -300.89)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(7)
	end
	event.CharaActive(1, 14)
	event.ObjsSetPos(4, 306.62, 23.94, -274.4)
	event.ObjsSetMotion(4, "ｴﾌｪｸﾄ_ラフレシア爆発", 6)
	event.SndSePlay(var4, 2)
	event.EohSyncObj(10, "p05_d02b01")
	event.EohSetShow(10, 1)
	event.EohSetPos(10, 280.0, -30.0, -360.0)
	var9 = 0.0
	var10 = 30.0
	while var9 < var10 do
		var11 = helper_043f6604(0.0, 1.0, var9, var10)
		event.EohSetScale(10, var11, var11, var11)
		var9 = vm.f32(var9 + 1.0)
		if vm.wait() then
			return skip(8)
		end
	end
	event.EohSetScale(10, 1.0, 1.0, 1.0)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(35)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		print("###############################start_event_out\n")
	end
	print("############################start_event_in\n")
	helper_7e1e9066(1)
	helper_0775cc3d()
	helper_b431dfdc()
	if vm.skipping() then
		return skip(1)
	end
	print("###############################start_event_out\n")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_18268()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		print("###############################start_event_tree_out\n")
	end
	print("############################start_event_tree_in\n")
	event.FuncPointShow("", "exit", 1)
	helper_7e1e9066(1)
	helper_0775cc3d()
	helper_b431dfdc()
	if vm.skipping() then
		return skip(1)
	end
	event.ResetCamera(0)
	print("###############################start_event_tree_out\n")
end

--- Program 201.
script[201] = function()
	event.FuncPointShow("", "exit", 1)
	helper_7e1e9066(1)
	helper_0775cc3d()
	event.PlayEnvBgm(0)
	event.ResetCamera(0)
	event.Initialize()
	helper_7d7eee8f(vm.f32(94.3), vm.f32(-7.7), vm.f32(537.9), vm.f32(2.46))
	event.SetCameraPos(78.24, 23.07, 626.86)
	event.SetCameraRef(94.3, 22.26, 537.9)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 2
		end
		if at <= 2 then
			helper_13d74()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_4b830b8e(0)
			helper_f2fdc03d()
		end
		if at <= 5 then
			helper_11514()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 6 then
			helper_4b830b8e(0)
			helper_f2fdc03d()
		end
	end
	function part2() end
	function landing1()
		helper_4b830b8e(0)
		event.SetFlag(24, 1)
		return part2()
	end
	function landing2()
		helper_4b830b8e(0)
		event.SetFlag(23, 1)
		return part2()
	end
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			event.SetMesPreset(0, 0)
			event.SetMesShippo(0, 0)
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.MesMake_2(
					0,
					"Da w[UNI00e4]chst ein gro[UNI00df]er Spross.\nAber irgendwas fehlt noch.<page>Etwas Wachstumsf[UNI00f6]rderndes ...?\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)"
				)
			else
				event.MesMake_2(
					0,
					"Da ist ein kleiner Sumpf. Er hat\netwas Geheimnisvolles ...\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)"
				)
			end
			event.SetMotion(0, "立ち")
			var3 = helper_180778df(0, -1, 5, 0, 0, var3)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesShippo(0, 1)
			if var3 == 1 then
				var0 = 2
			end
		end
	end
	if var0 == 2 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.GotoUseItem(356)
				do
					local skipped = vm.wait()
					var2 = event.DeferredOutput() or var2
					if skipped then
						return skip(2)
					end
				end
				if 0 < var2 then
					if var2 == 356 then
						event.SetMotion(0, "立ち")
						helper_13d74()
						if vm.skipping() then
							return skip(3)
						end
						helper_4b830b8e(0)
						event.SetFlag(24, 1)
					else
						helper_f2fdc03d()
						if vm.skipping() then
							return skip(4)
						end
					end
				end
			else
				event.GotoUseItem(361)
				do
					local skipped = vm.wait()
					var2 = event.DeferredOutput() or var2
					if skipped then
						return skip(5)
					end
				end
				if 0 < var2 then
					if var2 == 361 then
						event.SetMotion(0, "立ち")
						helper_11514()
						if vm.skipping() then
							return skip(6)
						end
						helper_4b830b8e(0)
						event.SetFlag(23, 1)
					else
						helper_f2fdc03d()
						if vm.skipping() then
							return skip(7)
						end
					end
				end
			end
		end
	end
	return part2()
end

--- Program 401.
script[401] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7e1e9066(0)
			helper_aafd6a80(1)
		end
		if at <= 2 then
			helper_aafd6a80(1)
		end
		if at <= 3 then
			helper_c9057fa5(1, 4)
			helper_27ff0b8f(1, -1, 5, 0, 0)
			helper_4b68ef15(64)
		end
		if at <= 4 then
			helper_dd7a6f53(1)
			helper_aafd6a80(30)
		end
	end
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		helper_18268()
		if vm.skipping() then
			return skip(1)
		end
		helper_7e1e9066(0)
		if false then
			event.Initialize()
			event.SpriteInit(0)
			event.SpriteSetType(0, 0)
			event.SpriteSetPos(0, 256, 208)
			event.SpriteSetPutsize(0, 512, 416)
			event.SpriteSetColor(0, 0, 0, 0, 0)
			event.SpriteSetDraw(0, 1)
			event.EohSyncSprite(11, 0)
			event.ObjsInit(11)
			event.ObjsSyncObj(11, 11)
			event.ObjsSetColor(11, 0, 0, 0, 255, 1)
			helper_aafd6a80(1)
			if vm.skipping() then
				return skip(2)
			end
			event.SetFadeIn(1)
			helper_aafd6a80(1)
			if vm.skipping() then
				return skip(3)
			end
			event.SetMesPreset(1, 4)
			helper_c9057fa5(1, 4)
			event.MesMake_2(1, "To be continue...")
			helper_27ff0b8f(1, -1, 5, 0, 0)
			helper_4b68ef15(64)
			if vm.skipping() then
				return skip(4)
			end
			helper_dd7a6f53(1)
			event.SetFadeOut(30)
			helper_aafd6a80(30)
			if vm.skipping() then
				return skip(5)
			end
			event.SpriteSetDraw(0, 0)
			event.SetExitFlag(1)
			event.SetFadeIn(30)
			return
		end
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("d02b02")
		event.LoadScript("d02b02/d02b02.stb", 500)
	end
end

--- Program 402.
script[402] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local yaw: f32 = 0
	local get_angle: f32 = 0
	local var10: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c049c42a(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_ec112754()
			end
			helper_7e1e9066(0)
			return
		end
		var10 = var10 + 1
	end
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.Initialize()
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_c049c42a(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_c049c42a(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(1, 0)
		event.SetCharaPos(0, 94.3, -7.7, 537.9)
		event.SetCharaRot(0, 0.0, 2.46, 0.0)
		event.Finish()
		return
	end
	var1 = helper_f4bcb68c(6, 16)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		helper_ec112754()
		if vm.skipping() then
			return skip(4)
		end
		event.FuncPointShow("", "exit", 0)
		helper_7e1e9066(0)
		event.GotoEdit(16)
		return
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetMotion(0, "歩き", 4)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.GetCharaRot(0)
		yaw = event.GetRefAngle(var2, var3, var4, 112.99, 3.46, 468.16) or yaw
		event.ObjsRotation(0, 0.0, yaw, 0.0, 15)
		event.ObjsMove(0, 112.99, 3.46, 468.16, 90, 1)
		get_angle = event.GetFcameraAngle() or get_angle
		if get_angle > vm.f32(1.5707964) or get_angle < vm.f32(-1.5707964) then
			event.CmrsMove(141.62, 78.35, 269.76, var2, var3 + 30.0, var4, 90)
		end
		var10 = 0
		while var10 < 60 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			event.CmrsSetRef(var2, var3 + 30.0, var4)
			event.SetCameraRef(var2, var3 + 30.0, var4)
			if vm.wait() then
				return skip(5)
			end
			var10 = var10 + 1
		end
		event.ObjsSetMotion(0, "立ち")
		event.ResetCamera(0)
		event.Finish()
	end
end

--- Program 12551.
script[12551] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11514()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12552.
script[12552] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_13d74()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12560.
script[12560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_18268()
	if vm.skipping() then
		return skip(1)
	end
end

return script
