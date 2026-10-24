--!strict
-- map/s/s47/s47_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_1fc036d8 = require("@lib/event/helper_1fc036d8")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_61224aa3 = require("@lib/event/helper_61224aa3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_bf9e1d50 = require("@lib/event/helper_bf9e1d50")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_ccbab5a2 = require("@lib/event/helper_ccbab5a2")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_db509971 = require("@lib/event/helper_db509971")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_e6c0ae70 = require("@lib/event/helper_e6c0ae70")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")
local helper_ec7d9573 = require("@lib/event/helper_ec7d9573")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1cff0()
	local active_chr_no: s32 = 0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 38)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/e200/e254/e254_fukuro.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(5, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 5)
	event.LoadChara(5, "event/e200/e254/e254_toryon.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 6)
	event.LoadMes(0, 5, "event/e200/e254/e254.txt")
end

--- Helper function.
local function helper_22b00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1cbec()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(38)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(38)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.DeleteChara(37)
end

--- Helper function.
local function helper_1e040()
	local var5: s32 = 0
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesPreset(0, 0)
		event.SetFadeOut(30)
		at = 1
		helper_25abe6d2(30)
		event.LoadSound(2238)
		var5 = event.SndLoadSound_2(2238) or var5
		helper_1cff0()
		event.InitDramaScene()
		event.CmrsInit()
		event.CmrsSetPos(-36.27, 5.25, -87.21)
		event.CmrsSetRef(0.0, 35.12, -200.0)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(1, 38)
		event.CharaActive(1, 36)
		event.CharaActive(1, 35)
		event.ObjsSetPos(0, 9.65, 0.0, -163.16)
		event.ObjsSetRot(0, 0.0, -2.66, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsSetPos(1, 27.55, 0.0, -175.0)
		event.ObjsSetRot(1, 0.0, -2.66, 0.0)
		event.ObjsSetMotion(1, "立ち", 4)
		event.ObjsSetPos(3, 0.0, 0.0, -200.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(3, "立ち", 4)
		event.ObjsSetPos(4, -29.84, 0.0, -214.7)
		event.ObjsSetRot(4, 0.0, -0.04, 0.0)
		event.ObjsSetScale(4, 1.0, 1.0, 1.0)
		event.SetFadeIn(30)
		at = 2
		helper_25abe6d2(30)
		event.ObjsSetMotion(3, "会話2")
		event.MesMake_2(
			0,
			"Questo [UNI00e8] un nostro pensierino.\nAbbiamo raccolto delle cose utili\nper ricostruire la foresta.<page>Pur avendo il Carpenterion e le\nGeopietre, non concludereste nulla\nsenza materiali!"
		)
		at = 3
		helper_a3cc6850(0, -1, 2, 256, 416)
		event.MesMake_2(
			0,
			"...Sai, la tua bisaccia per\ngli oggetti mi sembra un po'\npiccola: non hai pi[UNI00f9] spazio.<page>Sai cosa ti dico? Voglio\nproprio farti un grosso\nfavore. Ingrandiamola!"
		)
		at = 4
		helper_a3cc6850(0, -1, 2, 256, 416)
		event.MesMake_2(
			0,
			"Per tua norma, non sono\nsempre cos[UNI00ec] generoso.<page>[UNI00c8] che oggi... mi\nsento altruista."
		)
		at = 5
		helper_a3cc6850(0, -1, 2, 256, 416)
		event.ObjsSetMotion(3, "立ち")
		event.ObjsSetScale(4, 0.9, 0.9, 0.9)
		at = 6
		helper_e8257c69(210, 28)
		event.ObjsSetScale(4, 0.8, 0.8, 0.8)
		at = 7
		helper_e8257c69(214, 1)
		event.ObjsSetScale(4, 0.7, 0.7, 0.7)
		at = 8
		helper_e8257c69(216, 1)
		event.ObjsSetScale(4, 0.6, 0.6, 0.6)
		at = 9
		helper_e8257c69(220, 1)
		event.ObjsSetScale(4, 0.5, 0.5, 0.5)
		at = 10
		helper_e8257c69(224, 1)
		event.ObjsSetScale(4, 0.4, 0.4, 0.4)
		at = 11
		helper_e8257c69(235, 1)
		event.ObjsSetScale(4, 0.3, 0.3, 0.3)
		at = 12
		helper_e8257c69(231, 20)
		event.ObjsSetMotion(3, "会話2")
		event.MesMake_2(0, "Ora fate venire il\nCarpenterion.")
		at = 13
		helper_a3cc6850(0, -1, 2, 256, 416)
		event.ObjsSetMotion(3, "会話")
		event.MesMake_2(0, "Per posizionarti sulla mappa\nDiorama, premi [select].\nAvanti, provaci!")
		at = 14
		var6 = helper_db509971(0, -1, 2, 256, 416, var6)
		while var6 ~= 1 do
			event.ObjsSetMotion(3, "会話")
			event.MesMake_2(0, "Devi premere\n[select]!")
			at = 15
			var6 = helper_db509971(0, -1, 2, 256, 416, var6)
		end
		event.ObjsSetMotion(3, "立ち")
		event.SetFadeOut(30)
		at = 16
		helper_25abe6d2(30)
		event.CmrsSetPos(80.99, 2.59, -80.49)
		event.CmrsSetRef(-3.12, 130.83, -201.26)
		event.CharaActive(1, 37)
		event.ObjsSetPos(5, -236.26, 800.0, -539.2)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(5, "浮遊", 4)
		event.ObjsMove2(5, -236.26, 63.05, -539.2, 150, 2, 1.0)
		event.EohSyncChrobj(20, 37, "puropera")
		event.ObjsInit(20)
		event.ObjsSyncObj(20, 20)
		event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
		event.SetFadeIn(30)
		at = 17
		helper_25abe6d2(30)
		event.SndSePlay(var5, 8)
		at = 18
		helper_25abe6d2(30)
		event.CmrsMove(80.99, 2.59, -80.49, -3.12, 50.81, -201.26, 150)
		at = 19
		helper_25abe6d2(90)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 20
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at == 14 then
			var6 = received[2] :: number
		end
		if at == 15 then
			var6 = received[2] :: number
		end
		if at <= 1 then
			helper_22b00000()
			helper_d3f20302(30)
		end
		if at <= 2 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 3 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 4 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 5 then
			helper_5c12934f(210, 28)
		end
		if at <= 6 then
			helper_5c12934f(214, 1)
		end
		if at <= 7 then
			helper_5c12934f(216, 1)
		end
		if at <= 8 then
			helper_5c12934f(220, 1)
		end
		if at <= 9 then
			helper_5c12934f(224, 1)
		end
		if at <= 10 then
			helper_5c12934f(235, 1)
		end
		if at <= 11 then
			helper_5c12934f(231, 20)
		end
		if at <= 12 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 13 then
			var6 = helper_1fc036d8(0, -1, 2, 256, 416, var6)
		end
		if at <= 14 then
			var6 = helper_1fc036d8(0, -1, 2, 256, 416, var6)
		end
		if at <= 15 then
			local _ = var6 ~= 1
			helper_d3f20302(30)
		end
		if at <= 16 then
			helper_d3f20302(30)
		end
		if at <= 17 then
			helper_d3f20302(30)
		end
		if at <= 18 then
			helper_d3f20302(90)
		end
		if at <= 19 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SndSeStop(var5, 8)
	helper_1cbec()
	event.Finish()
	event.StopBgm(0)
	event.BgmLoadCancel()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e3b4()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.EohSyncChara(5, 39)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 39)
end

--- Helper function.
local function helper_10924()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EohSyncObj_2(12, "p01_g010701")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	helper_e3b4()
	event.LoadMes(0, 5, "event/e200/e250/e250_1.txt")
	event.AssignStack(6)
	event.ClearStack(6)
end

--- Helper function.
local function helper_105f8()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	helper_61224aa3()
	helper_ccbab5a2()
	event.DeleteChara(39)
end

--- Helper function.
local function helper_10bc8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(250, 1)
		event.Initialize()
		event.LoadSound(2229)
		var11 = event.SndLoadSound_2(2229) or var11
		helper_10924()
		do
			local out1, out2, out3 = event.EohGetPos(12)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = event.EohGetRot(12)
			rot_y = out2 or rot_y
		end
		event.SetWorldCoord(pos_x, pos_y, pos_z, rot_y)
		event.EohSetSoundId(0, var11)
		helper_bf9e1d50()
		event.StopBgm(1)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(193)
		event.SetLoadbgFile_4(
			"event/e200/e250/e250_toryon.gltf",
			"event/lm/e250r/e250_tree.gltf",
			"event/e200/e250/e250_konoha.gltf",
			"event/e200/e250/shuchusen.gltf"
		)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.EohSyncObj_2(13, "p01_a1301-4")
		event.EohSetShow(13, 0)
		event.InitDramaScene()
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(1, 34)
		event.CharaActive(1, 38)
		event.CharaActive(1, 39)
		event.CharaActive(1, 41)
		event.CharaActive(1, 40)
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.CmrsSetPos(113.09, 252.02, 174.44)
		event.CmrsSetRef(-869.33, -1297.8, -411.75)
		event.SetFadeIn(30)
		event.CmrsMove2(113.09, 65.59, 174.44, -1546.66, 23.97, -658.2, 230, 2, 0.4)
		event.ObjsSetPos(0, -14.3, 35.67, 60.81)
		event.ObjsSetRot(0, 0.0, -1.47, 0.0)
		event.ObjsSetPos(1, -14.3, 35.67, 70.35)
		event.ObjsSetRot(1, 0.0, -1.68, 0.0)
		event.ObjsSetPos(5, -14.299988, 35.67, 53.670013)
		event.ObjsSetRot(5, 0.0, -1.56, 0.0)
		event.ObjsSetPos(8, -14.299988, 35.67, 53.670013)
		event.ObjsSetRot(8, 0.0, -1.44, 0.0)
		event.ObjsSetPos(7, -14.299988, 35.67, 70.350006)
		event.ObjsSetRot(7, 0.0, -1.2, 0.0)
		event.ObjsSetPos(2, -14.299988, 35.67, 70.350006)
		event.ObjsSetRot(2, 0.0, -1.56, 0.0)
		event.ObjsSetPos(3, -14.299988, 35.67, 70.350006)
		event.ObjsSetRot(3, 0.0, -1.56, 0.0)
		event.ObjsSetPos(4, -14.299988, 35.67, 53.670013)
		event.ObjsSetRot(4, 0.0, -1.68, 0.0)
		event.ObjsSetPos(6, -14.299988, 35.67, 70.350006)
		event.ObjsSetRot(6, 0.0, -1.2, 0.0)
		event.EohSetFootSoundId(0, 3)
		event.EohSetFootSoundId(1, 3)
		event.ObjsSetMotion(0, "立ち", -1, 4)
		event.ObjsMotionDelay(0, 90)
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsMotionDelay(0, 75)
		event.ObjsSetMotion(0, "立ち", 0)
		event.ObjsRotation(0, 0.0, -1.49, 0.0, 165)
		event.ObjsPosDelay(0, 75)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 90)
		event.ObjsAddPas(0, -14.3, 35.67, 53.67)
		event.ObjsAddPas(0, -26.37, 35.67, 57.03)
		event.ObjsAddPas(0, -72.16, 14.0, 64.22)
		event.ObjsAddPas(0, -88.64, 14.0, 64.27)
		event.ObjsStartPas(0)
		event.ObjsSetMotion(1, "立ち", -1, 4)
		event.ObjsMotionDelay(1, 90)
		event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
		event.ObjsMotionDelay(1, 90)
		event.ObjsSetMotion(1, "立ち", 0)
		event.ObjsRotation(1, 0.0, -1.64, 0.0, 180)
		event.ObjsPosDelay(1, 90)
		event.ObjsInitPas(1)
		event.ObjsSetPasFrm(1, 90)
		event.ObjsAddPas(1, -14.3, 35.67, 70.35)
		event.ObjsAddPas(1, -27.29, 35.67, 70.35)
		event.ObjsAddPas(1, -68.45, 15.54, 70.63)
		event.ObjsAddPas(1, -87.24, 14.0, 87.83)
		event.ObjsStartPas(1)
		var10 = 0
		while var10 < 7 do
			event.ObjsSetMotion(2 + var10, "走り", 4)
			event.EohSetFootSoundId(5 + var10, 1)
			var10 = var10 + 1
		end
		event.ObjsInitPas(2)
		event.ObjsSetPasFrm(2, 15)
		event.ObjsAddPas(2, -14.31, 35.67, 70.35)
		event.ObjsAddPas(2, -28.37, 35.67, 70.35)
		event.ObjsAddPas(2, -70.8, 14.0, 66.4)
		event.ObjsAddPas(2, -99.73, 13.49, 63.63)
		event.ObjsAddPas(2, -115.19, 8.79, 62.15)
		event.ObjsAddPas(2, -136.2, 0.0, 60.14)
		event.ObjsStartPas(2)
		event.ObjsMove(2, -1411.86, -0.0, -148.97, 195)
		event.ObjsPosDelay(3, 10)
		event.ObjsInitPas(3)
		event.ObjsSetPasFrm(3, 15)
		event.ObjsAddPas(3, -14.31, 35.67, 70.35)
		event.ObjsAddPas(3, -28.37, 35.67, 70.35)
		event.ObjsAddPas(3, -70.8, 14.0, 66.4)
		event.ObjsAddPas(3, -99.73, 13.49, 63.63)
		event.ObjsAddPas(3, -115.19, 8.79, 62.15)
		event.ObjsAddPas(3, -136.2, 0.0, 60.14)
		event.ObjsStartPas(3)
		event.ObjsMove(3, -1411.86, -0.0, -148.97, 195)
		event.ObjsPosDelay(4, 20)
		event.ObjsInitPas(4)
		event.ObjsSetPasFrm(4, 15)
		event.ObjsAddPas(4, -16.96, 35.67, 57.27)
		event.ObjsAddPas(4, -30.65, 35.67, 58.87)
		event.ObjsAddPas(4, -74.26, 14.0, 63.97)
		event.ObjsAddPas(4, -97.55, 14.0, 66.69)
		event.ObjsAddPas(4, -113.48, 8.85, 69.63)
		event.ObjsAddPas(4, -128.87, 1.8, 71.43)
		event.ObjsStartPas(4)
		event.ObjsMove(4, -1370.73, -0.0, -123.06, 195)
		event.ObjsPosDelay(6, 30)
		event.ObjsInitPas(6)
		event.ObjsSetPasFrm(6, 15)
		event.ObjsAddPas(6, -15.82, 35.67, 62.54)
		event.ObjsAddPas(6, -29.9, 35.67, 63.43)
		event.ObjsAddPas(6, -68.92, 15.16, 65.92)
		event.ObjsAddPas(6, -95.99, 14.0, 67.64)
		event.ObjsAddPas(6, -112.97, 8.96, 68.73)
		event.ObjsAddPas(6, -133.66, 0.0, 70.05)
		event.ObjsStartPas(6)
		event.ObjsMove(6, -1317.43, -0.0, -99.53, 195)
		event.ObjsPosDelay(5, 40)
		event.ObjsInitPas(5)
		event.ObjsSetPasFrm(5, 15)
		event.ObjsAddPas(5, -14.3, 35.67, 53.67)
		event.ObjsAddPas(5, -30.28, 35.67, 53.76)
		event.ObjsAddPas(5, -61.37, 21.67, 59.67)
		event.ObjsAddPas(5, -100.52, 12.96, 59.88)
		event.ObjsAddPas(5, -117.29, 7.96, 59.97)
		event.ObjsAddPas(5, -135.22, 0.0, 60.07)
		event.ObjsStartPas(5)
		event.ObjsMove(5, -1333.23, -0.0, -138.83, 195)
		event.ObjsPosDelay(7, 50)
		event.ObjsInitPas(7)
		event.ObjsSetPasFrm(7, 15)
		event.ObjsAddPas(7, -14.3, 35.67, 65.19)
		event.ObjsAddPas(7, -27.94, 35.67, 66.4)
		event.ObjsAddPas(7, -68.78, 15.27, 70.03)
		event.ObjsAddPas(7, -92.62, 14.0, 72.15)
		event.ObjsAddPas(7, -111.92, 9.26, 73.86)
		event.ObjsAddPas(7, -134.81, 0.0, 75.89)
		event.ObjsStartPas(7)
		event.ObjsMove(7, -1316.98, -0.0, -190.07, 195)
		event.ObjsPosDelay(8, 60)
		event.ObjsInitPas(8)
		event.ObjsSetPasFrm(8, 15)
		event.ObjsAddPas(8, -14.3, 35.67, 66.92)
		event.ObjsAddPas(8, -28.53, 35.67, 65.18)
		event.ObjsAddPas(8, -75.65, 14.0, 64.98)
		event.ObjsAddPas(8, -99.2, 14.0, 70.35)
		event.ObjsAddPas(8, -120.92, 5.79, 62.69)
		event.ObjsAddPas(8, -133.21, 0.0, 60.52)
		event.ObjsStartPas(8)
		event.ObjsMove(8, -1299.13, -0.0, -155.72, 195)
		event.ObjsMotionDelay(3, 210)
		event.ObjsSetMotion(3, "ふみきり", 6)
		event.ObjsNextMotion(3, "空中", 0)
		event.ObjsMotionDelay(4, 220)
		event.ObjsSetMotion(4, "ふみきり", 6)
		event.ObjsNextMotion(4, "空中", 0)
		event.ObjsMotionDelay(6, 230)
		event.ObjsSetMotion(6, "ふみきり", 6)
		event.ObjsNextMotion(6, "空中", 0)
		event.ObjsMotionDelay(5, 240)
		event.ObjsSetMotion(5, "ふみきり", 6)
		event.ObjsNextMotion(5, "空中", 0)
		event.ObjsMotionDelay(8, 250)
		event.ObjsSetMotion(8, "ふみきり", 6)
		event.ObjsNextMotion(8, "空中", 0)
		event.ObjsMotionDelay(7, 260)
		event.ObjsSetMotion(7, "ふみきり", 6)
		event.ObjsNextMotion(7, "空中", 0)
		event.ObjsMotionDelay(2, 270)
		event.ObjsSetMotion(2, "ふみきり", 6)
		event.ObjsNextMotion(2, "空中", 0)
		event.ObjsJump(5, -1998.62, -0.0, -102.27, -0.25, 60)
		event.ObjsPosDelay(8, 0)
		event.ObjsJump(8, -1953.56, -0.0, -154.54, -0.25, 60)
		event.ObjsPosDelay(7, 0)
		event.ObjsJump(7, -1920.26, -0.0, -167.95, -0.25, 60)
		event.ObjsPosDelay(2, 0)
		event.ObjsJump(2, -1980.06, -0.86, -200.42, -0.25, 60)
		event.ObjsPosDelay(3, 0)
		event.ObjsJump(3, -1901.42, -0.0, -212.85, -0.25, 60)
		event.ObjsPosDelay(4, 0)
		event.ObjsJump(4, -1909.43, -0.0, -100.82, -0.25, 60)
		event.ObjsPosDelay(6, 0)
		event.ObjsJump(6, -1963.98, -0.0, -28.93, -0.25, 60)
		at = 2
		helper_25abe6d2(75)
		event.SndSePlay(var11, 14)
		at = 3
		helper_25abe6d2(255)
		helper_61224aa3()
		at = 4
		vm.wait(4)
		event.ClearStack(6)
		at = 5
		helper_479dc9e9()
		helper_ec7d9573(var11)
		at = 6
		vm.wait(6)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CmrsSetPos(-130.74, 32.47, 120.8)
		event.CmrsSetRef(-102.69, 36.9, 82.53)
		event.ObjsResetDaPosition(1)
		event.SetPakuAnim(1, "通常口パク")
		at = 7
		helper_e34416e2(2500180)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "首をかしげる", 6, -1.0, 1)
		event.ObjsNextMotion(0, "立ち", 4)
		at = 8
		helper_25abe6d2(5)
		event.SetPakuAnim(0, "通常口パク")
		at = 9
		helper_e34416e2(2500190)
		event.ResetPakuAnim()
		at = 10
		helper_0958ca60(0)
		event.SndSePlay(var11, 15)
		at = 11
		helper_25abe6d2(3)
		event.SetPakuAnim(1, "通常口パク")
		at = 12
		helper_e34416e2(2500200)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "指さす", 6, -1.0, 1)
		event.ObjsNextMotion(0, "指さすL", 0)
		event.SetPakuAnim(0, "通常口パク")
		at = 13
		helper_e34416e2(2500210)
		event.ResetPakuAnim()
		at = 14
		helper_0958ca60(0)
		event.PlayBgm(1)
		event.CharaActive(1, 42)
		event.CharaActive(1, 46)
		event.SetCharaPos(46, pos_x - vm.f32(1780.39), pos_y + vm.f32(773.93), pos_z + vm.f32(82.37))
		event.SetCharaRot(46, 0.0, rot_y + vm.f32(0.36), 0.0)
		event.ObjsResetMotion(14)
		event.ObjsMotionDelay(14, 30)
		event.ObjsSetMotion(14, "木の葉散る", 6)
		event.EohSyncChrobj(20, 42, "puropera")
		event.ObjsInit(20)
		event.ObjsSyncObj(20, 20)
		event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
		event.CmrsSetPos(-1120.67, 799.61, 245.65)
		event.CmrsSetRef(-1205.48, 813.47, 219.34)
		event.ObjsSetPos(9, -1983.37, 365.71, 26.93)
		event.ObjsSetRot(9, 0.0, 1.85, 0.0)
		event.SndSePlay(var11, 16)
		event.ObjsMove2(9, -1983.37, 942.49, 26.93, 60, 0, 0.4)
		at = 15
		helper_0958ca60(9)
		at = 16
		helper_25abe6d2(80)
		event.CharaActive(0, 46)
		event.CmrsMove2(206.33, 67.63, 392.02, 17.65, 209.62, 96.0, 120, 0, 0.4)
		event.ObjsMove2(9, -203.42, 128.16, -69.67, 120, 0, 0.4)
		event.ObjsRotation2(9, 0.0, 1.13, 0.0, 120, 0, 0.4)
		at = 17
		helper_c624bc16()
		event.CharaActive(0, 42)
		event.CmrsSetPos(-256.13, 70.1, 44.86)
		event.CmrsSetRef(-237.13, 29.77, 17.22)
		event.ObjsSetPos(0, -241.0, 0.0, 2.23)
		event.ObjsSetRot(0, 0.0, -0.41, 0.0)
		event.ObjsSetPos(1, -215.63, 0.0, 10.45)
		event.ObjsSetRot(1, 0.0, -0.68, 0.0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "うれし顔")
		event.ObjsTexAnime(0, 1, "目キラキラ")
		event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.SetPakuAnim(1, "通常口パク")
		at = 18
		helper_c28d4a31(2500220, 90)
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "うれし口～大口")
		at = 19
		helper_c28d4a31(2500230, 60)
		event.ResetPakuAnim()
		event.CharaActive(1, 42)
		event.CharaActive(1, 43)
		event.CharaActive(1, 44)
		event.CmrsSetPos(-147.0, 30.77, -328.58)
		event.CmrsSetRef(-178.12, 65.41, -171.95)
		event.ObjsSetPos(0, -249.75, 0.0, 7.65)
		event.ObjsSetRot(0, 0.0, -0.41, 0.0)
		event.ObjsSetPos(1, -193.44, 0.0, 6.3)
		event.ObjsSetRot(1, 0.0, -0.68, 0.0)
		event.ObjsSetPos(9, -335.13, 0.0, 295.03)
		event.ObjsSetRot(9, 0.0, 2.81, 0.0)
		event.SetCharaRot(43, 0.0, 3.1415927, 0.0)
		event.SetCharaRot(44, 0.0, 3.1415927, 0.0)
		event.ObjsSetMotion(9, "木持ち浮遊", 4)
		at = 20
		helper_25abe6d2(30)
		event.ObjsSetMotion(9, "右の木を植える", 6)
		event.ObjsNextMotion(9, "右の木を植えるL", 4)
		at = 21
		helper_25abe6d2(8)
		event.ObjsSetMotion(0, "右へよける", 6)
		event.ObjsSetMotion(1, "上向きから驚き", 6, -1.0, 1)
		event.ObjsNextMotion(1, "上向きから驚きＬ", 0)
		at = 22
		helper_25abe6d2(10)
		event.CmrsQuake(0.0, 4.0, 0.0, 20)
		at = 23
		helper_25abe6d2(5)
		do
			local out1, _, out3 = event.EohGetFramePos(9, "R_tree")
			pos_x_2 = out1 or pos_x_2
			pos_z_2 = out3 or pos_z_2
		end
		event.DelReference(43)
		event.ObjsSetPos(10, pos_x_2, 0.0, pos_z_2)
		event.ObjsSetMotion(10, "ぷるん", 6)
		at = 24
		helper_0958ca60(10)
		at = 25
		helper_c28d4a31(2500235, -1)
		at = 26
		helper_0958ca60(9)
		event.CharaActive(0, 43)
		event.CharaActive(1, 45)
		event.ObjsSetPos(13, 1200.0, -300.0, 12000.0)
		event.CmrsSetPos(-260.7, 41.9, 24.51)
		event.CmrsSetRef(-254.62, 30.24, 15.15)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.ObjsSetMotion(0, "前を見る", 6, 0.6)
		event.ObjsNextMotion(0, "前を見るL", 4)
		event.ObjsPosDelay(13, 15)
		event.ObjsMotionDelay(13, 15)
		event.ObjsSetPos(13, -235.28, -5.32, -11.39)
		event.ObjsSetRot(13, 0.0, 0.12, 0.0)
		event.ObjsSetMotion(13, "回転", 4)
		event.SetPakuAnim(0, "大口パク")
		at = 27
		helper_c28d4a31(2500240, 25)
		event.ResetPakuAnim()
		event.CharaActive(1, 43)
		event.CharaActive(1, 44)
		event.CharaActive(0, 45)
		event.CmrsSetPos(-147.0, 30.77, -328.58)
		event.CmrsSetRef(-178.12, 65.41, -171.95)
		event.ObjsSetPos(0, -310.86, 0.0, -37.43)
		event.ObjsSetRot(0, 0.0, -0.41, 0.0)
		event.ObjsSetPos(9, -407.63, 0.0, 280.62)
		event.ObjsSetRot(9, 0.0, 2.81, 0.0)
		event.ObjsSetMotion(9, "左の木を植える", 6)
		event.ObjsNextMotion(9, "左の木を植えるL", 4)
		at = 28
		helper_25abe6d2(8)
		event.ObjsSetMotion(0, "左へよける", 6)
		at = 29
		helper_25abe6d2(10)
		event.CmrsQuake(0.0, 4.0, 0.0, 20)
		at = 30
		helper_25abe6d2(5)
		do
			local out1, _, out3 = event.EohGetFramePos(9, "L_tree")
			pos_x_2 = out1 or pos_x_2
			pos_z_2 = out3 or pos_z_2
		end
		event.DelReference(44)
		event.ObjsSetPos(11, pos_x_2, 0.0, pos_z_2)
		event.ObjsSetMotion(11, "ぷるん", 6)
		at = 31
		helper_0958ca60(9)
		at = 32
		helper_25abe6d2(30)
		event.CharaActive(1, global1)
		event.CharaActive(0, 42)
		event.CmrsSetPos(-315.45, 23.19, 14.98)
		event.CmrsSetRef(-271.54, 21.8, 7.43)
		event.ObjsSetPos(0, -276.1, 0.0, -7.52)
		event.ObjsSetRot(0, 0.0, -0.41, 0.0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(0, 1, "うれし半口")
		event.ObjsSetMotion(0, "よけたあと", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向きから驚きＬ", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 33
		helper_e34416e2(2500250)
		event.ResetPakuAnim()
		event.ObjsTexAnime(0, 1, "目キラキラ")
		event.ObjsSetMotion(0, "すごいよ", 6, -1.0, 1)
		event.ObjsNextMotion(0, "すごいよL", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 34
		helper_e34416e2(2500260)
		event.ResetPakuAnim()
		event.CharaActive(1, 42)
		event.CharaActive(0, 43)
		event.CharaActive(0, 44)
		event.CmrsSetPos(-366.92, 245.56, -135.81)
		event.CmrsSetRef(-333.13, 279.7, -11.5)
		event.ObjsSetPos(0, -183.8, 0.0, 277.38)
		event.ObjsSetRot(0, 0.0, -0.6, 0.0)
		event.ObjsSetPos(1, -161.6, 0.0, 288.11)
		event.ObjsSetRot(1, 0.0, -0.72, 0.0)
		event.ObjsSetPos(9, -306.32, 272.97, 403.99)
		event.ObjsSetRot(9, 0.0, 3.14, 0.0)
		event.SndSePlay(var11, 19)
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.ObjsSetMotion(5, "立ち", 4)
		event.ObjsSetMotion(9, "浮遊", 4)
		event.CmrsMove2(-366.92, 245.56, -135.81, -333.13, 217.63, -11.5, 60, 2, 0.2)
		event.ObjsMove2(9, -306.32, 83.84, 403.99, 60, 2, 0.2)
		at = 35
		helper_25abe6d2(72)
		event.CharaActive(1, 39)
		event.EohSetShadow(0, 0)
		event.EohSetShadow(1, 0)
		event.EohSetShadow(5, 0)
		event.ObjsSetPos(5, -314.51, 136.42, 395.63)
		event.ObjsSetRot(5, 0.0, 3.04, 0.0)
		event.FadeOutBgm(60)
		event.ObjsSetMotion(9, "浮遊", 2)
		event.ObjsMotionWait(9)
		at = 36
		helper_0958ca60(9)
		event.SndSePlay(var11, 20)
		event.ObjsSetMotion(9, "入り口開く", 6)
		event.ObjsNextMotion(9, "入り口開くL", 4)
		event.ObjsMove(5, -314.51, 12.03, 395.63, 66)
		at = 37
		helper_25abe6d2(67)
		event.CmrsSetPos(-272.42, 14.88, 304.99)
		event.CmrsSetRef(-302.58, 33.94, 399.83)
		event.ObjsSetPos(0, -281.71, 0.0, 363.1)
		event.ObjsSetRot(0, 0.0, -0.84, 0.0)
		event.ObjsSetPos(1, -268.51, 0.0, 369.08)
		event.ObjsSetRot(1, 0.0, -1.2, 0.0)
		event.ObjsSetPos(5, -315.44, 12.03, 391.74)
		event.ObjsSetRot(5, 0.0, 2.32, 0.0)
		event.EohSetFootSoundId(0, 1)
		event.EohSetFootSoundId(1, 1)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(5, "会話", 6)
		event.ObjsNextMotion(5, "立ち", 0)
		at = 38
		helper_e34416e2(2500270)
		event.ObjsSetMotion(0, "上→すごいよ", 6)
		event.ObjsNextMotion(0, "すごいよL", 0)
		event.SetPakuAnim(0, "わらい口パク")
		at = 39
		helper_e34416e2(2500280)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "すごいよ戻り", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsSetMotion(5, "会話2", 6)
		event.ObjsNextMotion(5, "立ち", 0)
		at = 40
		helper_e34416e2(2500290)
		event.ObjsSetMotion(0, "上向く戻り", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "上向く戻り", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 41
		helper_0958ca60(0)
		at = 42
		helper_25abe6d2(3)
		event.ObjsSetMotion(0, "歩き", 0)
		event.ObjsSetMotion(1, "歩き", 0)
		event.ObjsRotation(0, 0.0, 0.12, 0.0, 6)
		event.ObjsRotation(1, 0.0, -0.24, 0.0, 6)
		at = 43
		helper_25abe6d2(6)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsSetMotion(1, "走り", 4)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 45)
		event.ObjsAddPas(0, -285.87, 0.0, 357.41)
		event.ObjsAddPas(0, -257.04, 0.0, 389.98)
		event.ObjsAddPas(0, -274.42, 0.0, 429.26)
		event.ObjsStartPas(0)
		event.ObjsInitPas(1)
		event.ObjsSetPasFrm(1, 45)
		event.ObjsAddPas(1, -266.64, 0.0, 363.55)
		event.ObjsAddPas(1, -264.8, 0.0, 426.42)
		event.ObjsAddPas(1, -300.44, 0.0, 458.67)
		event.ObjsStartPas(1)
		at = 44
		helper_25abe6d2(30)
		event.ObjsInitPas(0)
		event.ObjsInitPas(1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CmrsSetPos(-312.83, 198.18, 285.67)
		event.CmrsSetRef(-304.45, 164.0, 318.5)
		event.ObjsSetPos(0, -294.8, 16.560001, 393.65)
		event.ObjsSetRot(0, 0.0, 2.44, 0.0)
		event.ObjsSetPos(1, -289.64, 16.560001, 408.11)
		event.ObjsSetRot(1, 0.0, 2.35, 0.0)
		event.ObjsSetPos(5, -310.53, 16.560001, 383.79)
		event.ObjsSetRot(5, 0.0, 2.68, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		at = 45
		helper_25abe6d2(30)
		event.SndSePlay(var11, 21)
		event.ObjsSetMotion(9, "閉まる", 6, -1.0, 1)
		event.ObjsMove(0, -294.8, 150.42, 393.65, 68)
		event.ObjsMove(1, -289.64, 150.42, 408.11, 68)
		event.ObjsMove(5, -310.53, 150.42, 383.79, 68)
		at = 46
		helper_25abe6d2(38)
		event.SetFadeOut(30)
		at = 47
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var10 = 0
			local _ = var10 < 7
			var10 = var10 + 1
			helper_d3f20302(75)
		end
		if at <= 2 then
			helper_d3f20302(255)
		end
		if at <= 3 then
			helper_1ef0d4b2()
		end
		if at <= 4 then
			helper_344d6cd8()
		end
		if at <= 5 then
			helper_e6c0ae70(var11)
		end
		if at <= 6 then
			helper_8cd371d7(2500180)
		end
		if at <= 7 then
			helper_d3f20302(5)
		end
		if at <= 8 then
			helper_8cd371d7(2500190)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_d3f20302(3)
		end
		if at <= 11 then
			helper_8cd371d7(2500200)
		end
		if at <= 12 then
			helper_8cd371d7(2500210)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_238b5abc(9)
		end
		if at <= 15 then
			helper_d3f20302(80)
		end
		if at <= 16 then
			helper_344d6cd8()
		end
		if at <= 17 then
			helper_52aadc70(2500220, 90)
		end
		if at <= 18 then
			helper_52aadc70(2500230, 60)
		end
		if at <= 19 then
			helper_d3f20302(30)
		end
		if at <= 20 then
			helper_d3f20302(8)
		end
		if at <= 21 then
			helper_d3f20302(10)
		end
		if at <= 22 then
			helper_d3f20302(5)
		end
		if at <= 23 then
			helper_238b5abc(10)
		end
		if at <= 24 then
			helper_52aadc70(2500235, -1)
		end
		if at <= 25 then
			helper_238b5abc(9)
		end
		if at <= 26 then
			helper_52aadc70(2500240, 25)
		end
		if at <= 27 then
			helper_d3f20302(8)
		end
		if at <= 28 then
			helper_d3f20302(10)
		end
		if at <= 29 then
			helper_d3f20302(5)
		end
		if at <= 30 then
			helper_238b5abc(9)
		end
		if at <= 31 then
			helper_d3f20302(30)
		end
		if at <= 32 then
			helper_8cd371d7(2500250)
		end
		if at <= 33 then
			helper_8cd371d7(2500260)
		end
		if at <= 34 then
			helper_d3f20302(72)
		end
		if at <= 35 then
			helper_238b5abc(9)
		end
		if at <= 36 then
			helper_d3f20302(67)
		end
		if at <= 37 then
			helper_8cd371d7(2500270)
		end
		if at <= 38 then
			helper_8cd371d7(2500280)
		end
		if at <= 39 then
			helper_8cd371d7(2500290)
		end
		if at <= 40 then
			helper_238b5abc(0)
		end
		if at <= 41 then
			helper_d3f20302(3)
		end
		if at <= 42 then
			helper_d3f20302(6)
		end
		if at <= 43 then
			helper_d3f20302(30)
		end
		if at <= 44 then
			helper_d3f20302(30)
		end
		if at <= 45 then
			helper_d3f20302(38)
		end
		if at <= 46 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.StopBgm(1)
	event.StopBgm(0)
	event.SndSeStop(var11, 15)
	event.EohSetShadow(0, 1)
	event.EohSetShadow(1, 1)
	event.EohSetShadow(5, 1)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	var10 = 0
	while var10 < 7 do
		event.ObjsSetMotion(2 + var10, "走り", 4)
		event.EohSetFootSoundId(5 + var10, 0)
		var10 = var10 + 1
	end
	helper_105f8()
	event.EohSetShow(13, 1)
	event.Initialize()
end

--- Helper function.
local function helper_1944c()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	block = event.LoadImg_4(5, "textures/event/e200/e250/e250_2d.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e250_cut25", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadMes(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_22900000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_19120()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_1a3bc()
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFadeOut(0)
		at = 1
		vm.wait(1)
		event.SetFlag(250, 1)
		event.Initialize()
		var1 = event.SndLoadSound_2(2234) or var1
		helper_1944c()
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CharaActive(1, 120)
		event.CharaActive(1, 121)
		event.InitDramaScene()
		event.SndSePlay(var1, 22)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.SetCharaPos(global0, var2, var3, var4)
		event.SetCharaPos(global1, var2, var3, var4)
		event.SetFadeIn(30)
		event.CmrsSetPos(-772.48, 31.27, -965.22)
		event.CmrsSetRef(-701.0, 38.37, -1042.75)
		event.ObjsSetPos(0, -647.25, -0.0, -1047.89)
		event.ObjsSetRot(0, 0.0, -2.11, 0.0)
		event.ObjsSetPos(1, -654.69, -0.0, -1072.52)
		event.ObjsSetRot(1, 0.0, -1.2, 0.0)
		at = 2
		vm.wait(2)
		event.SetFadeIn(30)
		event.SetPakuAnim(1, "わらい口パク")
		at = 3
		helper_e34416e2(2500500)
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "通常口パク")
		at = 4
		helper_e34416e2(2500510)
		event.ResetPakuAnim()
		event.CharaActive(0, global1)
		event.CmrsSetPos(-701.14, 38.12, -985.84)
		event.CmrsSetRef(-699.63, 28.19, -1037.85)
		event.CmrsMove2(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
		event.SetPakuAnim(1, "わらい口パク")
		at = 5
		helper_e34416e2(2500520)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "わらい口パク")
		at = 6
		helper_e34416e2(2500525)
		event.ResetPakuAnim()
		at = 7
		helper_0958ca60(1)
		at = 8
		helper_c624bc16()
		event.CharaActive(1, global1)
		event.CharaActive(0, 120)
		event.CharaActive(0, 121)
		event.CmrsSetPos(-697.66, 20.36, -1062.26)
		event.CmrsSetRef(-643.59, 17.44, -1071.09)
		event.ObjsSetPos(0, -639.63, -0.0, -1057.59)
		event.ObjsSetRot(0, 0.0, -1.75, 0.0)
		event.ObjsSetPos(1, -646.9, -0.0, -1083.44)
		event.ObjsSetRot(1, 0.0, -0.84, 0.0)
		event.ObjsSetMotion(1, "左向くL", 4, -1.0, 1)
		event.CharaDaEnable(global0, 0)
		event.ObjsSetMotion(0, "アトラを持つ", 6)
		event.ObjsNextMotion(0, "アトラを持つL", 0)
		event.SetPakuAnim(0, "通常口パク")
		at = 9
		helper_e34416e2(2500530)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "左向く会話", 6)
		event.ObjsNextMotion(1, "左向くL", 0)
		event.SetPakuAnim(1, "わらい口パク")
		at = 10
		helper_e34416e2(2500540)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "わらい口パク")
		at = 11
		helper_e34416e2(2500545)
		event.ResetPakuAnim()
		event.SpriteSetDraw(0, 1)
		event.ObjsSetColor(2, 128.0, 128.0, 128.0, 128.0, 10)
		at = 12
		helper_e34416e2(2500550)
		at = 13
		helper_e34416e2(2500555)
		at = 14
		helper_e34416e2(2500560)
		event.SpriteSetDraw(0, 0)
		event.CharaActive(1, 120)
		event.CharaActive(1, 121)
		event.CharaDaEnable(global0, 1)
		event.CmrsSetPos(-799.13, 98.14, -1023.59)
		event.CmrsSetRef(-641.21, 13.62, -1089.99)
		event.ObjsSetPos(0, -647.09, -0.0, -1050.31)
		event.ObjsSetRot(0, 0.0, -1.75, 0.0)
		event.ObjsSetPos(1, -643.59, -0.0, -1073.29)
		event.ObjsSetRot(1, 0.0, -1.56, 0.0)
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.SetPakuAnim(1, "わらい口パク")
		at = 15
		helper_e34416e2(2500570)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "上→右見", 6, -1.0, 1)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 16
		helper_e34416e2(2500580)
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "通常口パク")
		at = 17
		helper_e34416e2(2500585)
		event.ResetPakuAnim()
		event.CharaActive(0, 120)
		event.CharaActive(0, 121)
		event.CharaActive(0, global0)
		event.CmrsSetPos(-675.55, 30.55, -1072.9)
		event.CmrsSetRef(-648.05, 22.05, -1072.56)
		event.SndSePlay(var1, 23)
		event.ObjsSetMotion(1, "アトラ見る", 6, -1.0, 1)
		event.ObjsNextMotion(1, "アトラ見るL", 0)
		at = 18
		helper_25abe6d2(27)
		event.SetPakuAnim(1, "通常口パク")
		at = 19
		helper_e34416e2(2500590)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "通常口パク")
		at = 20
		helper_e34416e2(2500595)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "アトラ見から立ちに", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 21
		helper_e34416e2(2500600)
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.CmrsSetPos(-675.37, 33.53, -1088.87)
		event.CmrsSetRef(-659.31, 20.57, -1054.58)
		event.ObjsSetPos(0, -661.43, -0.0, -1055.96)
		event.ObjsSetRot(0, 0.0, 3.04, 0.0)
		event.ObjsSetMotion(0, "モニカ見立ち", 4)
		at = 22
		helper_e34416e2(2500610)
		event.CharaActive(1, 120)
		event.CharaActive(1, 121)
		event.CharaActive(1, global1)
		event.CmrsSetPos(-757.19, 37.47, -1029.97)
		event.CmrsSetRef(-663.0, 20.57, -1070.18)
		event.ObjsSetPos(0, -642.21, -0.0, -1050.46)
		event.ObjsSetRot(0, 0.0, -2.04, 0.0)
		event.ObjsSetPos(1, -653.99, -0.0, -1067.84)
		event.ObjsSetRot(1, 0.0, -0.36, 0.0)
		event.ObjsSetMotion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsRotation(1, 0.0, -2.28, 0.0, 30)
		at = 23
		helper_e34416e2(2500620)
		at = 24
		helper_e34416e2(2500630)
		event.CharaDaEnable(global0, 0)
		event.SndSePlay(var1, 24)
		event.ObjsSetMotion(0, "アトラを持つ", 6)
		event.ObjsNextMotion(0, "アトラを持つL", 0)
		at = 25
		helper_e34416e2(2500640)
		at = 26
		helper_0958ca60(0)
		at = 27
		helper_25abe6d2(30)
		event.ObjsSetMotion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsRotation(1, 0.0, 0.24, 0.0, 30)
		at = 28
		helper_25abe6d2(30)
		at = 29
		helper_e34416e2(2500650)
		at = 30
		helper_e34416e2(2500655)
		event.ObjsSetMotion(1, "アトラを持つ戻り", 6, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 31
		helper_25abe6d2(15)
		event.SndSePlay(var1, 25)
		event.ObjsSetMotion(0, "うなづく", 6, -1.0, 1)
		event.ObjsNextMotion(0, "立ち", 4)
		at = 32
		helper_e34416e2(2500660)
		event.SetFadeOut(30)
		at = 33
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22900000()
		end
		if at <= 2 then
			helper_8cd371d7(2500500)
		end
		if at <= 3 then
			helper_8cd371d7(2500510)
		end
		if at <= 4 then
			helper_8cd371d7(2500520)
		end
		if at <= 5 then
			helper_8cd371d7(2500525)
		end
		if at <= 6 then
			helper_238b5abc(1)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			helper_8cd371d7(2500530)
		end
		if at <= 9 then
			helper_8cd371d7(2500540)
		end
		if at <= 10 then
			helper_8cd371d7(2500545)
		end
		if at <= 11 then
			helper_8cd371d7(2500550)
		end
		if at <= 12 then
			helper_8cd371d7(2500555)
		end
		if at <= 13 then
			helper_8cd371d7(2500560)
		end
		if at <= 14 then
			helper_8cd371d7(2500570)
		end
		if at <= 15 then
			helper_8cd371d7(2500580)
		end
		if at <= 16 then
			helper_8cd371d7(2500585)
		end
		if at <= 17 then
			helper_d3f20302(27)
		end
		if at <= 18 then
			helper_8cd371d7(2500590)
		end
		if at <= 19 then
			helper_8cd371d7(2500595)
		end
		if at <= 20 then
			helper_8cd371d7(2500600)
		end
		if at <= 21 then
			helper_8cd371d7(2500610)
		end
		if at <= 22 then
			helper_8cd371d7(2500620)
		end
		if at <= 23 then
			helper_8cd371d7(2500630)
		end
		if at <= 24 then
			helper_8cd371d7(2500640)
		end
		if at <= 25 then
			helper_238b5abc(0)
		end
		if at <= 26 then
			helper_d3f20302(30)
		end
		if at <= 27 then
			helper_d3f20302(30)
		end
		if at <= 28 then
			helper_8cd371d7(2500650)
		end
		if at <= 29 then
			helper_8cd371d7(2500655)
		end
		if at <= 30 then
			helper_d3f20302(15)
		end
		if at <= 31 then
			helper_8cd371d7(2500660)
		end
		if at <= 32 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SndSeStop(var1, 22)
	helper_19120()
	event.SetFadeIn(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1e040

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_10bc8()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s26", 501)
	vm.wait(2)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_1a3bc()
	event.MapJump_2(-1, "g01")
end

--- Event 505, which map data, a script or the engine runs by number.
function script.event_505()
	helper_1e040()
	event.MapJump_3(-1, "s26", 502)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_10bc8()
	print("KITA###########################\n")
	event.SetFadeIn(30)
	print("KITA2222222###########################\n")
end

return script
