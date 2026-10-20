--!strict
-- map/s/s08/s08.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_12595efb = require("@lib/event/helper_12595efb")
local helper_19b130fb = require("@lib/event/helper_19b130fb")
local helper_3dd588e7 = require("@lib/event/helper_3dd588e7")
local helper_5e932d83 = require("@lib/event/helper_5e932d83")
local helper_7f754b8f = require("@lib/event/helper_7f754b8f")
local helper_8b00b423 = require("@lib/event/helper_8b00b423")
local helper_99c5f02b = require("@lib/event/helper_99c5f02b")
local helper_b4ed6a5a = require("@lib/event/helper_b4ed6a5a")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_d95797cc = require("@lib/event/helper_d95797cc")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_e204533c = require("@lib/event/helper_e204533c")

local global0: s32 = 0

--- Helper function.
local function helper_2349c()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(global0, 2)
	event.SndSePlay(global0, 8)
end

--- Helper function.
local function helper_23558()
	event.Initialize()
	global0 = 0
	event.LoadSound(2200)
	global0 = event.SndLoadSound(2200) or global0
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(1, 9)
	event.SetCharaPos(9, 5.62, 36.1, 39.9)
	event.SetCharaRot(9, 0.0, 3.04, 0.0)
	event.SetMotion(9, "立ち", 4)
	event.LoadChara(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 10)
	event.SetCharaPos(10, -38.37, 36.08, 32.88)
	event.SetCharaRot(10, 0.0, 1.48, 0.0)
	event.SetMotion(10, "立ち", 4)
	event.LoadChara(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(1, 11)
	event.SetCharaPos(11, -1.81, 36.1, 72.51)
	event.SetCharaRot(11, 0.0, -0.48, 0.0)
	event.SetMotion(11, "立ち", 4)
	event.EohSetSoundId(3, global0)
	event.RegisterVillager(9, 1)
	event.RegisterVillager(10, 2)
	event.RegisterVillager(11, 13, 65)
	event.SetCharaNo(9, 1)
	event.SetCharaNo(10, 2)
	event.SetCharaNo(11, 13)
	helper_2349c()
end

--- Helper function.
local function helper_d24(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

--- Helper function.
local function helper_f28(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d24(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d24(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_1a12c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
	end
	var0 = event.GetCnt(1) or var0
	if var0 == 2 then
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(1)
		end
		return
	end
	if var0 == 3 then
		event.MapJump(-1, "s04")
		if vm.wait() then
			return skip(2)
		end
		return
	end
	if var0 == 4 then
		event.MapJump(-1, "s09")
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if var0 == 5 then
		event.MapJump(-1, "s10")
		if vm.wait() then
			return skip(4)
		end
		return
	end
	if var0 == 6 then
		event.MapJump(-1, "s11")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	if var0 == 7 then
		event.MapJump(-1, "s12")
		if vm.wait() then
			return skip(6)
		end
		return
	end
	if var0 == 8 then
		event.MapJump(-1, "s31")
		if vm.wait() then
			return skip(7)
		end
		return
	end
	if var0 == 9 then
		event.MapJump(-1, "s34")
		if vm.wait() then
			return skip(8)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(9)
	end
end

--- Helper function.
local function helper_df1c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_5e932d83(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_5e932d83(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_5e932d83(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1fed8()
	local block: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.LoadMotion(5, "event/e200/e203/e203_mints.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e200/e203/e203_starbre.gltf", "info", 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 33)
	event.LoadChara(5, "event/e200/e203/e203_vorneo.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "event/e200/e203/e203_tom.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadChara(5, "event/e200/e203/e203_sekitan.gltf", "info", 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 37)
	event.EohSyncObj(4, "p06_kikan", "kikan_06-m")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 3.1415927, 0.0)
	block = event.LoadImg_4(5, "textures/event/e200/e203/e203.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e20301", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 51.2, 41.6)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e20302", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(11, 1)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e20303", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 416)
	event.SpriteSetPutsize(2, 512, 416)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(12, 2)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e20304", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(3, 51.2, 41.6)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(13, 3)
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.LoadMes(0, 5, "event/e200/e203/e203.txt")
	event.SetStatus(1, 0, 256, 1)
end

--- Helper function.
local function helper_1da38(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(30)
		end
		if at <= 2 then
			helper_e204533c()
		end
		if at <= 3 then
			helper_5e932d83(20)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
	helper_5e932d83(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "腰に手", 4)
	event.ObjsSetMotion(2, "斜め向き立ち", 4)
	event.ObjsSetMotion(3, "石炭", 4)
	event.CmrsMove2(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	helper_e204533c()
	if vm.skipping() then
		return skip(3)
	end
	helper_5e932d83(20)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_1dcec(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd588e7(2030010)
		end
		if at <= 2 then
			helper_3dd588e7(2030020)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "スコップ立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_3dd588e7(2030010)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_3dd588e7(2030020)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_1deec(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd588e7(2030030)
		end
		if at <= 2 then
			helper_3dd588e7(2030040)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 33)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ぼうぜん顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.CmrsSetPos(8.87, 61.22, 40.34)
	event.CmrsSetRef(2.69, 59.0, 20.67)
	event.CmrsMove2(7.72, 61.22, 36.68, 2.69, 59.0, 20.67, 450, 2, 0.4)
	helper_3dd588e7(2030030)
	if vm.skipping() then
		return skip(2)
	end
	helper_3dd588e7(2030040)
	if vm.skipping() then
		return skip(3)
	end
	event.PlayBgm(0)
end

--- Helper function.
local function helper_1e1a8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd588e7(2030050)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetPutsize(0, 512.0, 416.0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetPos(10, 256.0, 208.0, 10.0)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 30)
	helper_3dd588e7(2030050)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e36c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(15)
		end
		if at <= 2 then
			helper_3dd588e7(2030060)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 11)
	event.CharaActive(1, 33)
	event.SpriteSetPutsize(1, 512.0, 416.0)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetPos(11, 256.0, 208.0, 10.0)
	event.ObjsSetColor(11, 128.0, 128.0, 128.0, 128.0, 15)
	helper_5e932d83(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(0, 0)
	helper_3dd588e7(2030060)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1e5e4(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(15)
		end
		if at <= 2 then
			helper_3dd588e7(2030070)
		end
		if at <= 3 then
			helper_3dd588e7(2030073)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetPutsize(2, 512.0, 416.0)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetPos(12, 256.0, 208.0, 10.0)
	event.ObjsSetColor(12, 128.0, 128.0, 128.0, 128.0, 15)
	helper_5e932d83(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(1, 0)
	helper_3dd588e7(2030070)
	if vm.skipping() then
		return skip(3)
	end
	helper_3dd588e7(2030073)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_1e820(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(15)
		end
		if at <= 2 then
			helper_3dd588e7(2030080)
		end
		if at <= 3 then
			helper_3dd588e7(2030083)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetPutsize(3, 512.0, 416.0)
	event.SpriteSetDraw(3, 1)
	event.ObjsSetPos(13, 256.0, 208.0, 0.0)
	event.ObjsSetColor(13, 128.0, 128.0, 128.0, 128.0, 15)
	helper_5e932d83(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(2, 0)
	helper_3dd588e7(2030080)
	if vm.skipping() then
		return skip(3)
	end
	helper_3dd588e7(2030083)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_1ec34(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(15)
		end
		if at <= 2 then
			helper_3dd588e7(2030090)
		end
		if at <= 3 then
			helper_3dd588e7(2030100)
		end
		if at <= 4 then
			helper_5e932d83(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
	event.ObjsSetColor(13, 0.0, 0.0, 0.0, 15)
	helper_5e932d83(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(3, 0)
	event.CmrsMove2(10.91, 58.61, 33.87, 1.64, 58.99, 18.19, 300, 2, 0.4)
	helper_3dd588e7(2030090)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(0, 1, "眉真剣")
	helper_3dd588e7(2030100)
	if vm.skipping() then
		return skip(4)
	end
	event.StopBgm(0)
	event.SndSePlay(arg0, 5)
	event.CmrsQuake(0.0, 0.8, 0.0, 45)
	helper_5e932d83(45)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1f028(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(23)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 11)
	event.CharaActive(1, 35)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "振り返るL", 0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_5e932d83(23)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1cbc0(arg0: s32, arg1: f32, arg2: f32, arg3: s32)
	local var4: s32 = 0
	local get_now_frame_wait: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg2 = vm.f32(0.01)
			var4 = 0
			return
		end
		var4 = var4 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 == -1.0 then
		arg2 = vm.f32(0.01)
	end
	var4 = 0
	while var4 < arg3 do
		get_now_frame_wait = event.GetMotNowWait(arg0) or get_now_frame_wait
		if get_now_frame_wait < vm.f32(arg1 + arg2) and get_now_frame_wait > vm.f32(arg1 - arg2) then
			return
		end
		if vm.wait() then
			return skip(2)
		end
		var4 = var4 + 1
	end
end

--- Helper function.
local function helper_1f34c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e932d83(20)
		end
		if at <= 2 then
			helper_3dd588e7(2030110)
		end
		if at <= 3 then
			helper_3dd588e7(2030120)
		end
		if at <= 4 then
			helper_3dd588e7(2030130)
		end
		if at <= 5 then
			helper_3dd588e7(2030135)
		end
		if at <= 6 then
			helper_1cbc0(0, vm.f32(0.267), -1.0, 30)
		end
		if at <= 7 then
			helper_3dd588e7(2030140)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(arg0, 7)
	event.ObjsSetMotion(1, "驚く", 6)
	event.ObjsNextMotion(1, "驚くL", 0)
	event.ObjsSetMotion(2, "驚く", 6)
	event.ObjsNextMotion(2, "驚くL", 0)
	event.ObjsSetMotion(3, "驚く", 6)
	event.ObjsNextMotion(3, "驚くL", 0)
	helper_5e932d83(20)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 8)
	event.SetPakuAnim(1, "大口パク")
	helper_3dd588e7(2030110)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_3dd588e7(2030120)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(23.44, 65.11, 70.77)
	event.CmrsSetRef(-17.65, 56.75, -37.19)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.ObjsSetMotion(1, "会話2", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_3dd588e7(2030130)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "大口パク")
	helper_3dd588e7(2030135)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_1cbc0(0, vm.f32(0.267), -1.0, 30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_3dd588e7(2030140)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_1fc00()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.DelExtMotion(0)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(37)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 0)
	event.DelImg(0)
	event.DelImg(1)
end

--- Helper function.
local function helper_211d4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_1da38(var0)
			end
			if at <= 2 then
				helper_1dcec(var0)
			end
			if at <= 3 then
				helper_e204533c()
			end
			if at <= 4 then
				helper_1deec(var0)
			end
			if at <= 5 then
				helper_1e1a8(var0)
			end
			if at <= 6 then
				helper_1e36c(var0)
			end
			if at <= 7 then
				helper_1e5e4(var0)
			end
			if at <= 8 then
				helper_1e820(var0)
			end
			if at <= 9 then
				helper_1ec34(var0)
			end
			if at <= 10 then
				helper_1f028(var0)
			end
			if at <= 11 then
				helper_1f34c(var0)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		helper_1fc00()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		helper_1fc00()
		event.CharaActive(1, 9)
		event.CharaActive(1, 10)
		event.CharaActive(1, 11)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 8)
		event.CmrsSetPos(29.29, 88.68, -13.52)
		event.CmrsSetRef(-6.48, 65.74, 32.61)
		event.ResetCamera(0)
	end
	event.SetFlag(203, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2200) or var0
	helper_1fed8()
	event.EohSetSoundId(3, var0)
	event.StopBgm(0)
	helper_5e932d83(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(105)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.SetStatus(1, 0, 256, 1)
	event.InitDramaScene()
	event.CharaActive(1, 0)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	event.CmrsSetPos(41.03, 65.52, -72.49)
	event.CmrsSetRef(1.22, 121.98, 25.12)
	event.ObjsSetPos(0, 2.3, 36.08, 14.12)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 5.62, 36.1, 39.9)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	event.ObjsSetPos(2, -38.37, 36.08, 32.88)
	event.ObjsSetRot(2, 0.0, 1.48, 0.0)
	event.ObjsSetPos(3, -1.81, 36.1, 72.51)
	event.ObjsSetRot(3, 0.0, -0.48, 0.0)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var0, 2)
	helper_1da38(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(54.99, 53.17, 1.95)
	event.CmrsSetRef(-1.12, 50.66, 35.36)
	event.CmrsMoveAhd2(2.64, 2.9, 55.5, 140, 0, 1.0)
	event.ObjsSetPos(0, 2.3, 36.08, 14.12)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	helper_1dcec(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_e204533c()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(11.36, 60.35, 36.83)
	event.CmrsSetRef(-1.48, 59.0, 7.39)
	helper_1deec(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_1e1a8(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_1e36c(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_1e5e4(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_1e820(var0)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(1, 0)
	event.CmrsInit()
	event.CmrsSetPos(12.55, 58.61, 36.64)
	event.CmrsSetRef(3.28, 58.99, 20.96)
	helper_1ec34(var0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsInit()
	event.CmrsSetPos(3.0, 69.45, -14.12)
	event.CmrsSetRef(-5.47, 39.58, 58.5)
	helper_1f028(var0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(29.29, 88.68, -13.52)
	event.CmrsSetRef(-6.48, 65.74, 32.61)
	event.ObjsSetPos(0, 6.15, 36.08, -1.68)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(2, -18.35, 36.08, 35.6)
	event.ObjsSetRot(2, 0.0, 1.48, 0.0)
	event.ObjsResetDaPosition(0)
	helper_1f34c(var0)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_224a8()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e200/e205/e205_starbre.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 32)
	event.LoadChara(5, "event/e200/e205/e205_vorneo.gltf", "info", 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 33)
	event.LoadChara(5, "event/e200/e205/e205_tom.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadMes(0, 5, "event/e200/e205/e205.txt")
	event.CharaActive(0, 0)
end

--- Helper function.
local function helper_223b0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.CharaActive(1, 0)
end

--- Helper function.
local function helper_2297c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd588e7(2050020)
			end
			if at <= 2 then
				helper_5e932d83(30)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
		helper_223b0()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.CmrsInit()
		helper_223b0()
		event.SetFadeIn(30)
	end
	event.SetFlag(205, 1)
	event.Initialize()
	event.LoadSound(2206)
	var0 = event.SndLoadSound(2206) or var0
	helper_224a8()
	event.StopBgm(0)
	event.SetFadeIn(30)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	event.CmrsSetPos(26.2, 66.14, -50.83)
	event.CmrsSetRef(13.28, 59.7, -9.45)
	event.ObjsSetPos(0, 24.27, 36.08, -15.66)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(1, -25.76, 36.08, 14.84)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetPos(2, -5.4, 36.08, 70.48)
	event.ObjsSetRot(2, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(0, "だめじゃ", 4)
	event.ObjsSetMotion(1, "気絶", 4)
	event.ObjsSetMotion(2, "錯乱", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.SndSePlay(var0, 0)
	event.CmrsQuake(0.0, 0.5, 0.1, -1)
	event.SetPakuAnim(0, "大口パク")
	helper_3dd588e7(2050010)
	if vm.skipping() then
		return skip(1)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "口パク")
	helper_3dd588e7(2050020)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_5e932d83(30)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_2a8c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_8d68(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_99c5f02b(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_99c5f02b(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a29c(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return rot_y
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8d68(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
	return rot_y
end

--- Helper function.
local function helper_a55c(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_12595efb(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_d95797cc(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_a29c(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_12595efb(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_d95797cc(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	helper_19b130fb()
	helper_8b00b423()
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_7f754b8f(1)
		event.SetBitCtrl(1, 1)
	else
		helper_7f754b8f(0)
	end
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, 38.0, 36.1, -100.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
	end
	if flag == 1 and flag_2 == 0 then
		helper_23558()
	end
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f28(32)
		end
		if at <= 2 then
			helper_b4ed6a5a(0, 1002, 8, 450, 100)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_f28(32)
	if vm.skipping() then
		return skip(2)
	end
	helper_b4ed6a5a(0, 1002, 8, 450, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.Test(0)
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("-------event_200----------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_1a12c()
		if vm.skipping() then
			return skip(1)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("-------event_201----------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_1a12c()
		if vm.skipping() then
			return skip(1)
		end
	end
end

--- Program 203.
script[203] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetBitCtrl(1, 0)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetCnt(0, 1)
		event.SetFadeOut(30)
		helper_5e932d83(30)
		if vm.skipping() then
			return skip(1)
		end
		event.SetCharaPos(0, 0.0, 36.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.MapJump(-1, "s07")
	end
end

--- Program 204.
script[204] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(30)
		event.SndSeStop(global0, 2)
		event.SndSeStop(global0, 8)
		event.MapJump(-1, "s03", 501)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 205.
script[205] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 206.
script[206] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 208.
script[208] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event208-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 209.
script[209] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event209-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetSavedataEtc(3, 1)
	helper_df1c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(3, 0)
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2349c()
	end
	helper_8b00b423()
	helper_7f754b8f(1)
	helper_23558()
	helper_211d4()
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(1, 1)
	helper_2349c()
	event.SetFadeIn(30)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2297c()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s03", 512)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_2a8c(0, 1)
	if var0 == 9 then
		event.MesMake_2(0, "なにをもたもたしとる！\nはやくはしごをのぼるんじゃ。")
	end
	if var0 == 10 then
		event.MesMake_2(
			0,
			"今は世界がどうしたとか言ってる場合じゃないな。\nユリス、急いで外の様子を見てきてくれ。"
		)
	end
	if var0 == 11 then
		event.MesMake_2(
			0,
			"さっきのゆれ方からすると、\nわりと小さい爆弾と思うっす。<page>でも、当たり所が悪いとヤバいっすよ。"
		)
	end
	helper_a55c(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12030.
script[12030] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2349c()
	end
	helper_23558()
	helper_211d4()
	if vm.skipping() then
		return skip(1)
	end
	helper_2349c()
	event.SetFadeIn(30)
end

--- Program 12050.
script[12050] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2297c()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s03", 512)
	if vm.wait() then
		return skip(2)
	end
end

return script
