--!strict
-- map/i/i05/h01/i05h01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_8a24aea5 = require("@lib/event/helper_8a24aea5")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_cc614fd6 = require("@lib/event/helper_cc614fd6")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Helper function.
local function helper_386f0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local now_party_chara_id: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_ed0a80b8(30)
			end
			if at <= 2 then
				helper_e2d04ed9(1)
			end
			if at <= 3 then
				helper_c3ce9c48(3050010)
			end
			if at <= 4 then
				helper_c3ce9c48(3050020)
			end
			if at <= 5 then
				helper_e2d04ed9(1)
			end
			if at <= 6 then
				helper_b8f871c8(0, -1, 8, 0, 0)
			end
			if at <= 7 then
				helper_ed0a80b8(10)
			end
			if at <= 8 then
				helper_ed0a80b8(20)
			end
			if at <= 9 then
				helper_ed0a80b8(30)
			end
			if at <= 10 then
				helper_ed0a80b8(20)
			end
			if at <= 11 then
				helper_ed0a80b8(20)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		if at <= 13 then
			helper_8a24aea5()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, 0)
		event.SpriteSetDraw(0, 1)
		event.ObjsSetColor(2, 0.0, 0.0, 0.0, 128.0)
		event.SetFadeIn(0)
		helper_8a24aea5()
		if vm.skipping() then
			return skip(14)
		end
		if vm.wait() then
			return skip(15)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		var3 = event.GetNpcStatus(now_party_chara_id) or var3
		if bit32.band(var3, 4) ~= 0 then
			event.SetNpcStatus(now_party_chara_id, 4)
		else
			event.SetNpcStatus(now_party_chara_id, 2)
		end
		event.SetNpcStatus(6, 128)
		event.SetNpcStatus(6, 1)
		event.SpriteSetDraw(0, 0)
		event.SetFadeOut(0)
		if active_chr_no ~= 0 then
			event.DeleteChara(32)
			event.DeleteChara(33)
		else
			event.DelExtMotion(0)
		end
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		if vm.wait() then
			return skip(16)
		end
	end
	event.SetFadeOut(0)
	event.SetFlag(305, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	event.StopBgm(0)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(57)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(1249) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadMes(0, 5, "event/e300/e305/e305_1.txt")
	if active_chr_no ~= 0 then
		event.CharaActive(0, 0)
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.CharaActive(32)
		event.CharaActive(33)
		event.EohSyncChara(0, 32)
	else
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "event/e300/e305/e305_duck.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(1, 34)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSetPos(0, 41.0, 0.0, 44.0)
	event.EohSetRot(0, 0.0, -1.57, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 3)
	event.EohSetPos(1, -31.0, 0.0, 90.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "花見立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目パチ")
	event.EohSetSoundId(1, var0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(43.93, 53.83, 21.86)
	event.CmrsSetRef(-14.62, 23.71, 94.06)
	event.SetFadeIn(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "振り向く", 2)
	event.ObjsNextMotion(1, "振り向くL", 4)
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuMotion(1, "振り向く会話", 0, "振り向くL", 0)
	helper_c3ce9c48(3050010)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(29.17, 40.75, 148.74)
	event.CmrsSetRef(-14.4, 16.43, 33.37)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, -31.0, 0.0, 49.0, 40)
	event.ObjsRotation(1, 0.0, 3.14, 0.0, 18)
	event.ObjsRotDelay(1, 12)
	event.ObjsRotation(1, 0.0, 1.92, 0.0, 10)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -2.0, 0.0, 44.0, 50)
	event.ObjsRotDelay(0, 40)
	event.ObjsRotation(0, 0.0, -1.11, 0.0, 10)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(3050020)
	if vm.skipping() then
		return skip(5)
	end
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "会話2", 2)
	event.ObjsNextMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, 3050030)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 45.0, 0.0, 44.0, 60)
	event.ObjsRotation(0, 0.0, 1.57, 0.0, 14)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, 24.0, 0.0, 49.0, 50)
	event.ObjsRotation(1, 0.0, 1.8, 0.0, 8)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(9)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(2, 0.0, 0.0, 0.0, 255.0, 30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetMotion(0, "立ち", 4)
	event.SndSePlay(var0, 3)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var0, 4)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1ef0d4b2

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		var2 = event.SearchCharaNo(6) or var2
		event.SetAi(0, var2)
		event.CharaActive(0, var2)
		helper_386f0()
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var2)
		event.CharaActive(1, var2)
		event.GotoOutside(-1, "m05")
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cc614fd6()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13050.
script[13050] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.SearchCharaNo(6) or var0
	event.SetAi(0, var0)
	event.CharaActive(0, var0)
	helper_386f0()
	if vm.skipping() then
		return skip(1)
	end
	event.SetAi(1, var0)
	event.CharaActive(1, var0)
end

return script
