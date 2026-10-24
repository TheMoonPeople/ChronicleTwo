--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_1e1681bf = require("@lib/event/helper_1e1681bf")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_36fbebd5()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(504, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(32)
		event.LoadSound(5203)
		var0 = event.SndLoadSound_2(5203) or var0
		event.SndSePlay(var0, 0)
		event.SndSeStop(var0, 0)
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.ChangeDir("event/e500/e504/")
		event.LoadMes(0, 5, "e504_1.txt")
		if active_chr_no == 0 then
			event.LoadMotion(5, "e504_mints.gltf", "info", 0)
			event.CharaActive(0, 0)
			event.EohSyncChara(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
		end
		if active_chr_no == 1 then
			event.LoadMotion(5, "e504_monica.gltf", "info", 0)
			event.CharaActive(0, 0)
			event.EohSyncChara(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
		end
		event.LoadChara(5, "e504_ark_kage.gltf", "info", 34)
		event.CharaActive(34)
		event.EohSyncChara(7, 34)
		event.ObjsInit(7, 34)
		event.ObjsSyncObj(7, 7)
		event.SetStatus(1, 34, 512, 1)
		event.ChangeDir("")
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 33)
			event.LoadMotion(5, "event/e500/e504/e504_mints.gltf", "info", 32)
			event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.EohSyncChara(0, 32)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
			event.LoadEquip(5, 1, 4, "info", 32)
			event.LoadEquip(5, 1, 3, "info", 32)
			event.LoadEquip(5, 1, 2, "info", 32, 33)
			event.LoadMotion(5, "event/e500/e504/e504_monica.gltf", "info", 32)
			event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.EohSyncChara(1, 32)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.CharaActive(0, 32)
		event.CharaActive(0, 33)
		event.EohSyncObj_2(2, "p01_battleship")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.EohSetPos(1, 2053.12, 0.0, -189.76)
		event.EohSetRot(1, 0.0, -1.58, 0.0)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetFootSoundId(1, 16)
		event.EohSetPos(0, 2033.55, 0.0, -166.12)
		event.EohSetRot(0, 0.0, -1.7, 0.0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, 16)
		event.EohSetPos(7, 1973.31, 18.13, -474.55)
		event.EohSetRot(7, 0.0, 2.9, 0.0)
		event.EohSetShow(7, 1)
		event.EohSetPos(2, 3606.9, 843.3, -1400.5)
		event.EohSetRot(2, 0.0, -1.186824, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.SetModelLightSwitch(0, 0)
		event.SetModelLightSwitch(32, 0)
		event.SetModelLightSwitch(33, 0)
		event.SetModelLightSwitch(3, 0)
		event.SetModelLightColor(0, 100.0, 100.0, 100.0, 128.0)
		event.SetModelLightColor(32, 100.0, 100.0, 100.0, 128.0)
		event.SetModelLightColor(33, 100.0, 100.0, 100.0, 128.0)
		event.SetModelLightColor(3, 100.0, 100.0, 100.0, 128.0)
		event.InitDramaScene()
		event.EohSetShow(2, 0)
		event.CmrsInit()
		event.CmrsSetPos(1807.61, 141.62, -352.77)
		event.CmrsSetRef(1973.44, 14.96, -195.42)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 1960.74, 0.0, -178.61, 120)
		event.ObjsMotionDelay(0, 120)
		event.ObjsSetMotion(0, "立ち")
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMove(1, 1970.04, 0.0, -200.85, 120)
		event.ObjsMotionDelay(1, 120)
		event.ObjsSetMotion(1, "立ち")
		event.SetFadeIn(30)
		event.StopBgm(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		at = 2
		helper_25abe6d2(60)
		event.SndSePlay(var0, 0)
		at = 3
		helper_25abe6d2(30)
		event.ObjsMove(7, 1829.02, 18.13, 47.54, 150)
		event.SetModelLightSwitch(0, 0)
		event.SetModelLightSwitch(32, 0)
		event.SetModelLightSwitch(33, 0)
		event.SetModelLightSwitch(3, 0)
		var2 = 0
		while var2 < 60 do
			var3 = helper_1e1681bf(100.0, 40.0, var2, 60)
			event.SetModelLightColor(0, var3, var3, var3, 128.0)
			event.SetModelLightColor(32, var3, var3, var3, 128.0)
			event.SetModelLightColor(33, var3, var3, var3, 128.0)
			event.SetModelLightColor(3, var3, var3, var3, 128.0)
			var2 = var2 + 1
			at = 4
			vm.wait(4)
		end
		event.SndSePlay(var0, 1)
		event.ObjsSetMotion(0, "上向く", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsMotionDelay(1, 10)
		event.ObjsSetMotion(1, "上向く", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 5
		helper_25abe6d2(30)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目～おこり目")
		event.ObjsTexAnime(1, 1, "半口")
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目～おこり目")
		event.SetPakuAnim(0, "通常口パク")
		at = 6
		helper_c28d4a31(5040010, 45)
		event.SetModelLightSwitch(0, 1)
		event.SetModelLightSwitch(32, 1)
		event.SetModelLightSwitch(33, 1)
		event.SetModelLightSwitch(3, 1)
		event.PlayBgm(0)
		event.EohSetShow(2, 1)
		event.ObjsSetScale(2, 0.8, 0.8, 0.8)
		event.EohSetShow(7, 0)
		event.CmrsSetPos(-630.25, 1117.68, 190.22)
		event.CmrsSetRef(2862.65, 578.01, -1018.41)
		event.CmrsMove(-630.25, 1117.68, 190.22, -662.156, 1651.45, -2008.72, 180)
		event.ObjsMove(2, -596.8, 1241.3, -2007.8, 180)
		event.ObjsRotation(2, 0.0, -1.9896754, 0.0, 180)
		at = 7
		helper_25abe6d2(180)
		event.CmrsSetPos(-2083.55, 144.26, 1858.12)
		event.CmrsSetRef(-972.92, 1902.75, -3946.41)
		event.ObjsSetPos(2, -596.8, 1241.3, -2007.8)
		event.ObjsSetRot(2, 0.0, -2.4609144, 0.0)
		event.ObjsMove(2, -9640.1, 6816.1, -17522.8, 1200)
		event.ObjsRotation2(2, 0.0, -2.8099802, 0.0, 60, 0, 1.0)
		event.ObjsSetPos(1, 1982.08, 0.0, -201.51)
		event.ObjsSetRot(1, 0.0, -1.58, 0.0)
		event.ObjsSetPos(0, 1979.69, 0.0, -181.39)
		event.ObjsSetRot(0, 0.0, -1.7, 0.0)
		at = 8
		helper_25abe6d2(180)
		event.CmrsSetPos(1904.82, 53.4, -194.35)
		event.CmrsSetRef(1984.16, 13.62, -191.87)
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.ObjsSetMotion(1, "怒り会話", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.SetPakuAnim(1, "通常口パク")
		at = 9
		helper_e34416e2(5040020)
		event.ObjsSetMotion(0, "上向く会話", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.SetPakuAnim(0, "通常口パク")
		at = 10
		helper_e34416e2(5040030)
		event.ObjsSetMotion(1, "握りこぶし", 6)
		event.ObjsNextMotion(1, "握りこぶしL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 11
		helper_e34416e2(5040040)
		event.ObjsSetPos(2, -5192.1, 12410.2, -23114.3)
		event.ObjsSetRot(2, 0.0, 2.4870944, 0.0)
		event.ObjsSetScale(2, 0.5, 0.5, 0.5)
		event.ObjsMove(2, -3988.6, 12410.2, -26396.5, 120)
		event.CmrsSetPos(1174.88, 7.04, 1268.65)
		event.CmrsSetRef(1158.55, 18.83, 1228.31)
		event.CmrsMoveAhd2(1.31, -11.79, 43.89, 120, 1, 1.0)
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 12
		helper_c28d4a31(5040050, 120)
		event.CmrsInit()
		event.CmrsSetPos(1932.53, 50.96, -195.43)
		event.CmrsSetRef(1975.85, 22.78, -192.38)
		event.ObjsSetMotion(1, "上→左", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.ObjsMotionDelay(0, 40)
		event.ObjsSetMotion(0, "上→右", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 13
		helper_e34416e2(5040060)
		event.ObjsSetMotion(1, "左向く会話", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 14
		helper_e34416e2(5040065)
		at = 15
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "右→上", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsMotionDelay(1, 40)
		event.ObjsSetMotion(1, "左→上", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 16
		helper_e34416e2(5040070)
		at = 17
		helper_c624bc16()
		at = 18
		helper_0958ca60(1)
		event.CmrsSetPos(2031.54, 20.63, -189.44)
		event.CmrsSetRef(1980.42, 21.38, -191.05)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "立ち", 4)
		event.ObjsResetDaPosition(1)
		event.SetPakuAnim(1, "通常口パク")
		at = 19
		helper_e34416e2(5040080)
		event.CmrsSetPos(1913.48, 18.68, -196.77)
		event.CmrsSetRef(1985.94, 18.83, -191.67)
		event.SndSePlay(var0, 2)
		event.ObjsSetMotion(0, "右向く", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.ObjsMotionDelay(1, 30)
		event.SndSePlay(var0, 3)
		event.ObjsSetMotion(1, "左向く", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.SetPakuAnim(0, "通常口パク")
		at = 20
		helper_e34416e2(5040090)
		at = 21
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "左向くうなづき", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.SndSePlay(var0, 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 22
		helper_e34416e2(5040100)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 23
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_d3f20302(60)
		end
		if at <= 2 then
			helper_d3f20302(30)
		end
		if at <= 3 then
			var2 = 0
			var3 = helper_1e1681bf(100.0, 40.0, var2, 60)
			local _ = var2 < 60
			var2 = var2 + 1
		end
		if at <= 4 then
			helper_d3f20302(30)
		end
		if at <= 5 then
			helper_52aadc70(5040010, 45)
		end
		if at <= 6 then
			helper_d3f20302(180)
		end
		if at <= 7 then
			helper_d3f20302(180)
		end
		if at <= 8 then
			helper_8cd371d7(5040020)
		end
		if at <= 9 then
			helper_8cd371d7(5040030)
		end
		if at <= 10 then
			helper_8cd371d7(5040040)
		end
		if at <= 11 then
			helper_52aadc70(5040050, 120)
		end
		if at <= 12 then
			helper_8cd371d7(5040060)
		end
		if at <= 13 then
			helper_8cd371d7(5040065)
		end
		if at <= 14 then
			helper_238b5abc(1)
		end
		if at <= 15 then
			helper_8cd371d7(5040070)
		end
		if at <= 16 then
			helper_344d6cd8()
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_8cd371d7(5040080)
		end
		if at <= 19 then
			helper_8cd371d7(5040090)
		end
		if at <= 20 then
			helper_238b5abc(1)
		end
		if at <= 21 then
			helper_8cd371d7(5040100)
		end
		if at <= 22 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.StopBgm(0)
	event.SndSeStop(var0, 0)
	event.SndSeStop(var0, 1)
	event.SndSeStop(var0, 2)
	event.SndSeStop(var0, 3)
	event.SndSeStop(var0, 4)
	event.EohSetPos(2, 3139.7, 9.0, 918.2)
	event.Ext(703, 2, 2.4260077, 0.0) -- retail: the handler rejects 3 arguments
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.SetModelLightSwitch(0, 1)
	event.SetModelLightSwitch(32, 1)
	event.SetModelLightSwitch(33, 1)
	event.SetModelLightSwitch(3, 1)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.LoadMes(0, -1)
end

return helper_36fbebd5
