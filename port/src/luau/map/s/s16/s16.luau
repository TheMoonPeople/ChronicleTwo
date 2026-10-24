--!strict
-- map/s/s16/s16.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f2a6f5c = require("@lib/event/helper_0f2a6f5c")
local helper_47634cad = require("@lib/event/helper_47634cad")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_79b153cf = require("@lib/event/helper_79b153cf")
local helper_9529405b = require("@lib/event/helper_9529405b")
local helper_a8cd1c0d = require("@lib/event/helper_a8cd1c0d")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_e9042a30 = require("@lib/event/helper_e9042a30")
local helper_eeac58d8 = require("@lib/event/helper_eeac58d8")
local helper_f4839a09 = require("@lib/event/helper_f4839a09")
local helper_f7f0d19e = require("@lib/event/helper_f7f0d19e")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(5694)
	flag = event.GetFlag(636) or flag
	if flag == 1 then
		helper_f4839a09()
	end
end

--- Helper function.
local function helper_1004c()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_690ecd8a(75)
			end
			if at <= 2 then
				helper_690ecd8a(30)
			end
			if at <= 3 then
				helper_af3fca28(2)
			end
			if at <= 4 then
				helper_690ecd8a(75)
			end
			if at <= 5 then
				helper_690ecd8a(30)
			end
			if at <= 6 then
				helper_690ecd8a(30)
			end
			if at <= 7 then
				helper_690ecd8a(30)
			end
			if at <= 8 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DeleteChara(10)
		event.DelImg(0)
		event.SetStatusbarShow(1, 1.0)
		event.CharaActive(0)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(5, "snd2/mon/en_285.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatusbarShow(0, 1.0)
	event.LoadChara(5, "dungeon/monster/e117e.gltf", "e117e", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSetSoundId(2, var0)
	block = event.LoadImg_4(5, "textures/event/e600/e636/e636telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e636telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 0)
	event.ObjsSetPos(2, 0.0, 0.0, -200.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "待機")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 50.0, 1600.0)
	event.CmrsSetRef(0.0, -700.0, -200.0)
	event.CmrsMove2(0.0, 6.41, -114.18, 0.0, 40.0, -197.53, 150, 2, 0.2)
	event.SetFadeIn(30)
	helper_690ecd8a(75)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "立ち", 2)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "攻撃１", 6)
	event.ObjsNextMotion(2, "攻撃２", 6)
	event.ObjsNextMotion(2, "立ち", 6)
	event.ObjsNextMotion(2, "遊び", 4)
	helper_690ecd8a(75)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(6)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_10dec()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_690ecd8a(30)
			end
			if at <= 2 then
				helper_e9042a30(6240010)
			end
			if at <= 3 then
				helper_e9042a30(6240020)
			end
			if at <= 4 then
				helper_690ecd8a(2)
			end
			if at <= 5 then
				helper_690ecd8a(120)
			end
			if at <= 6 then
				helper_47634cad(368, 1)
			end
			if at <= 7 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_f4839a09()
			helper_9529405b(0.0, 4.0, -350.0, 0.0)
			helper_eeac58d8(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.SndSeStop(var1, 0)
		event.SndSeStop(var0, 0)
		event.PlayBgm(0)
		event.EohSetShow(2, 1)
		event.EohSetShow(3, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		helper_f4839a09()
		event.Finish()
		helper_9529405b(0.0, 4.0, -350.0, 0.0)
		event.SetCameraRef(0.0, 34.0, -350.0)
		event.SetCameraPos(0.0, 44.0, -230.0)
		event.ResetCamera(0)
		helper_eeac58d8(0)
		if vm.skipping() then
			return skip(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(636, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var0
	var1 = event.SndLoadSound(5826) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatusbarShow(0, 1.0)
	event.SetWorldCoord(0.0, 0.0, 560.0, 0.0)
	event.ChangeDir("event/e600/e624/")
	event.LoadMes(0, 5, "e624.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e624_mints.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e624_monica.gltf", "info", 0)
	end
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e636_lapis_hi.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetEohFramePos(1, 0, "item", 0.0, 0.0, 0.0, -1)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(2, 0)
	event.EohSetShow(3, 0)
	event.EohSetPos(0, 0.0, 4.0, -920.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-40.26, 20.64, -866.67)
	event.CmrsSetRef(-1.7, 36.27, -951.09)
	event.CmrsMove2(-29.36, 23.4, -890.54, -1.7, 36.27, -951.09, 90, 2, 1.0)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(2)
	end
	if active_chr_no == 0 then
		helper_e9042a30(6240010)
		if vm.skipping() then
			return skip(3)
		end
	else
		helper_e9042a30(6240020)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.CmrsInit()
	event.SndSeStop(var1, 0)
	event.SndPauseBgm()
	event.EohSyncObj(30, "p01_s1301-m-m", "s1301_3-m0")
	event.EohSetShow(30, 0)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	if active_chr_no == 0 then
		event.CmrsSetPos(0.0, 51.31, -963.58)
		event.CmrsSetRef(0.0, 28.64, -917.36)
		event.CmrsMove2(0.0, 46.94, -952.38, 0.0, 28.64, -917.36, 120, 2, 0.4)
		event.SetCharaPos(9, 7.74, 35.0, -358.0)
		event.SetCharaRot(9, 0.2, 0.24, 0.0)
	else
		event.CmrsSetPos(0.0, 53.31, -963.58)
		event.CmrsSetRef(0.0, 30.64, -917.36)
		event.CmrsMove2(0.0, 48.94, -952.38, 0.0, 30.64, -917.36, 120, 2, 0.4)
		event.SetCharaPos(9, -4.45, 37.0, -358.0)
		event.SetCharaRot(9, 0.2, -0.24, 0.0)
	end
	event.SetMotion(9, "発動", 6)
	event.ObjsSetMotion(0, "ラピスゲット", 4, -1.0, 1)
	helper_690ecd8a(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 0)
	helper_690ecd8a(120)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var1, 1)
	helper_47634cad(368, 1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_9529405b(0.0, vm.f32(33.9), vm.f32(1530.4), vm.f32(3.14))
	end
	event.Initialize()
	program_99()
	flag = event.GetFlag(636) or flag
	if flag == 0 then
		helper_1004c()
		if vm.skipping() then
			return skip(1)
		end
		event.FuncPointShow("", "rapis", 0)
		event.LoadMonsterFile(613, 1)
		event.AutoSetMonster(613, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	end
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_9529405b(0.0, vm.f32(33.9), vm.f32(1530.4), vm.f32(3.14))
	event.SetCameraRef(0.0, 63.9, 1530.4)
	event.SetCameraPos(0.0, 83.9, 1650.4)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1004c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f7f0d19e(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_690ecd8a(15)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_f7f0d19e(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_f7f0d19e(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	flag = event.GetFlag(636) or flag
	if flag == 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "まだラピスを手に入れてないよ！")
		helper_f7f0d19e(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		event.Finish()
		return
	end
	var2 = helper_79b153cf(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	if var2 == 0 then
		event.SetFadeOut(15)
		helper_690ecd8a(15)
		if vm.skipping() then
			return skip(5)
		end
		event.DelMonster(-1)
		event.LoadScript("d05/d05.stb", 1000)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f7f0d19e(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_10dec()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_f7f0d19e(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_f7f0d19e(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.AddItem(368, 1)
	event.SetFadeOut(10)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(3)
	end
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	helper_10dec()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a8cd1c0d(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DelMonster(-1)
	event.FuncPointShow("", "rapis", 1)
	event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
	helper_0f2a6f5c()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgmPack(193)
	event.PlayBgm(0)
	event.Finish()
end

--- Program 26040.
script[26040] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_690ecd8a(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadMonsterFile(613, 1)
	event.AutoSetMonster(613, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.DngPause(16384, 1)
	event.StopBgm(0)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.Finish()
end

return script
