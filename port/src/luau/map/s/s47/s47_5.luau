--!strict
-- map/s/s47/s47_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f8064ba = require("@lib/event/helper_7f8064ba")
local helper_898707d9 = require("@lib/event/helper_898707d9")
local helper_8ab48644 = require("@lib/event/helper_8ab48644")
local helper_af980ac0 = require("@lib/event/helper_af980ac0")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_bf9e1d50 = require("@lib/event/helper_bf9e1d50")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_d2746c33 = require("@lib/event/helper_d2746c33")
local helper_dd0e9f78 = require("@lib/event/helper_dd0e9f78")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f90fbb97 = require("@lib/event/helper_f90fbb97")
local helper_f9fe2856 = require("@lib/event/helper_f9fe2856")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1d000()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_1cbfc()
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
local function helper_1e050()
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_1d000()
				helper_ed0a80b8(30)
			end
			if at <= 2 then
				helper_b8f871c8(0, -1, 2, 256, 416)
			end
			if at <= 3 then
				helper_b8f871c8(0, -1, 2, 256, 416)
			end
			if at <= 4 then
				helper_b8f871c8(0, -1, 2, 256, 416)
			end
			if at <= 5 then
				helper_8ab48644(210, 28)
			end
			if at <= 6 then
				helper_8ab48644(214, 1)
			end
			if at <= 7 then
				helper_8ab48644(216, 1)
			end
			if at <= 8 then
				helper_8ab48644(220, 1)
			end
			if at <= 9 then
				helper_8ab48644(224, 1)
			end
			if at <= 10 then
				helper_8ab48644(235, 1)
			end
			if at <= 11 then
				helper_8ab48644(231, 20)
			end
			if at <= 12 then
				helper_b8f871c8(0, -1, 2, 256, 416)
			end
			if at <= 13 then
				var6 = helper_7f8064ba(0, -1, 2, 256, 416, var6)
			end
			if at <= 14 then
				var6 = helper_7f8064ba(0, -1, 2, 256, 416, var6)
			end
			if at <= 15 then
				helper_ed0a80b8(30)
			end
			if at <= 16 then
				helper_ed0a80b8(30)
			end
			if at <= 17 then
				helper_ed0a80b8(30)
			end
			if at <= 18 then
				helper_ed0a80b8(90)
			end
			if at <= 19 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
		helper_1cbfc()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var5, 8)
		helper_1cbfc()
		event.Finish()
		event.StopBgm(0)
		event.BgmLoadCancel()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2238)
	var5 = event.SndLoadSound(2238) or var5
	helper_1d000()
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
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "会話2")
	event.MesMake_2(
		0,
		"Toma: un regalo de nuestra parte.\nTe hemos tra[UNI00ed]do unas cuantas cosas\nque vas a necesitar para\nrepoblar el bosque.<page>Aunque tengas el Carpenterion\ny Geopiedras, no ir[UNI00e1]s a ninguna\n parte sin la materia prima."
	)
	helper_b8f871c8(0, -1, 2, 256, 416)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"...Pero espera, la Bolsa que llevas es\ncanija, ah[UNI00ed] no cabe casi nada.<page>Mira: te voy a\nhacer un favor.\n[UNI00a1]La har[UNI00e9] m[UNI00e1]s grande!"
	)
	helper_b8f871c8(0, -1, 2, 256, 416)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Pero no te acostumbres: no soy\nsiempre tan generoso.<page>Lo que pasa es que hoy me siento espl[UNI00e9]ndido."
	)
	helper_b8f871c8(0, -1, 2, 256, 416)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetScale(4, 0.9, 0.9, 0.9)
	helper_8ab48644(210, 28)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetScale(4, 0.8, 0.8, 0.8)
	helper_8ab48644(214, 1)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetScale(4, 0.7, 0.7, 0.7)
	helper_8ab48644(216, 1)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetScale(4, 0.6, 0.6, 0.6)
	helper_8ab48644(220, 1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetScale(4, 0.5, 0.5, 0.5)
	helper_8ab48644(224, 1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetScale(4, 0.4, 0.4, 0.4)
	helper_8ab48644(235, 1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetScale(4, 0.3, 0.3, 0.3)
	helper_8ab48644(231, 20)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(3, "会話2")
	event.MesMake_2(0, "Ahora atrae\nal Carpenterion.")
	helper_b8f871c8(0, -1, 2, 256, 416)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(3, "会話")
	event.MesMake_2(
		0,
		"Para situarte en el mapa de Georama, pulsa\nel bot[UNI00f3]n [select].\nYa ver[UNI00e1]s, prueba."
	)
	var6 = helper_7f8064ba(0, -1, 2, 256, 416, var6)
	if vm.skipping() then
		return skip(14)
	end
	while var6 ~= 1 do
		event.ObjsSetMotion(3, "会話")
		event.MesMake_2(0, "Pulsa el bot[UNI00f3]n\n [select].")
		var6 = helper_7f8064ba(0, -1, 2, 256, 416, var6)
		if vm.skipping() then
			return skip(15)
		end
	end
	event.ObjsSetMotion(3, "立ち")
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(16)
	end
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
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var5, 8)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsMove(80.99, 2.59, -80.49, -3.12, 50.81, -201.26, 150)
	helper_ed0a80b8(90)
	if vm.skipping() then
		return skip(19)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

--- Helper function.
local function helper_e3c4()
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
local function helper_10934()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EohSyncObj(12, "p01_g010701")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	helper_e3c4()
	event.LoadMes(0, 5, "event/e200/e250/e250_1.txt")
	event.AssignStack(6)
	event.ClearStack(6)
end

--- Helper function.
local function helper_10608()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_898707d9()
		helper_d2746c33()
	end
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
	helper_898707d9()
	helper_d2746c33()
	event.DeleteChara(39)
end

--- Helper function.
local function helper_10bd8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 47 then
			if at <= 1 then
				var10 = 0
				var10 = var10 + 1
				helper_ed0a80b8(75)
			end
			if at <= 2 then
				helper_ed0a80b8(255)
			end
			if at <= 3 then
				helper_898707d9()
			end
			if at <= 4 then
				helper_af980ac0()
			end
			if at <= 5 then
				helper_dd0e9f78(var11)
			end
			if at <= 6 then
				helper_c3ce9c48(2500180)
			end
			if at <= 7 then
				helper_ed0a80b8(5)
			end
			if at <= 8 then
				helper_c3ce9c48(2500190)
			end
			if at <= 9 then
				helper_e2d04ed9(0)
			end
			if at <= 10 then
				helper_ed0a80b8(3)
			end
			if at <= 11 then
				helper_c3ce9c48(2500200)
			end
			if at <= 12 then
				helper_c3ce9c48(2500210)
			end
			if at <= 13 then
				helper_e2d04ed9(0)
			end
			if at <= 14 then
				helper_e2d04ed9(9)
			end
			if at <= 15 then
				helper_ed0a80b8(80)
			end
			if at <= 16 then
				helper_f9fe2856()
			end
			if at <= 17 then
				helper_f90fbb97(2500220, 90)
			end
			if at <= 18 then
				helper_f90fbb97(2500230, 60)
			end
			if at <= 19 then
				helper_ed0a80b8(30)
			end
			if at <= 20 then
				helper_ed0a80b8(8)
			end
			if at <= 21 then
				helper_ed0a80b8(10)
			end
			if at <= 22 then
				helper_ed0a80b8(5)
			end
			if at <= 23 then
				helper_e2d04ed9(10)
			end
			if at <= 24 then
				helper_f90fbb97(2500235, -1)
			end
			if at <= 25 then
				helper_e2d04ed9(9)
			end
			if at <= 26 then
				helper_f90fbb97(2500240, 25)
			end
			if at <= 27 then
				helper_ed0a80b8(8)
			end
			if at <= 28 then
				helper_ed0a80b8(10)
			end
			if at <= 29 then
				helper_ed0a80b8(5)
			end
			if at <= 30 then
				helper_e2d04ed9(9)
			end
			if at <= 31 then
				helper_ed0a80b8(30)
			end
			if at <= 32 then
				helper_c3ce9c48(2500250)
			end
			if at <= 33 then
				helper_c3ce9c48(2500260)
			end
			if at <= 34 then
				helper_ed0a80b8(72)
			end
			if at <= 35 then
				helper_e2d04ed9(9)
			end
			if at <= 36 then
				helper_ed0a80b8(67)
			end
			if at <= 37 then
				helper_c3ce9c48(2500270)
			end
			if at <= 38 then
				helper_c3ce9c48(2500280)
			end
			if at <= 39 then
				helper_c3ce9c48(2500290)
			end
			if at <= 40 then
				helper_e2d04ed9(0)
			end
			if at <= 41 then
				helper_ed0a80b8(3)
			end
			if at <= 42 then
				helper_ed0a80b8(6)
			end
			if at <= 43 then
				helper_ed0a80b8(30)
			end
			if at <= 44 then
				helper_ed0a80b8(30)
			end
			if at <= 45 then
				helper_ed0a80b8(38)
			end
			if at <= 46 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(48)
			end
			return part2()
		end
		var10 = 0
		var10 = var10 + 1
		helper_10608()
	end
	function part2()
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
		helper_10608()
		event.EohSetShow(13, 1)
		event.Initialize()
	end
	event.SetFlag(250, 1)
	event.Initialize()
	event.LoadSound(2229)
	var11 = event.SndLoadSound(2229) or var11
	helper_10934()
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
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(193)
	event.SetLoadbgFile(
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
	event.EohSyncObj(13, "p01_a1301-4")
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
	helper_ed0a80b8(75)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var11, 14)
	helper_ed0a80b8(255)
	if vm.skipping() then
		return skip(3)
	end
	helper_898707d9()
	if vm.wait() then
		return skip(4)
	end
	event.ClearStack(6)
	helper_af980ac0()
	if vm.skipping() then
		return skip(5)
	end
	helper_dd0e9f78(var11)
	if vm.wait() then
		return skip(6)
	end
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(-130.74, 32.47, 120.8)
	event.CmrsSetRef(-102.69, 36.9, 82.53)
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2500180)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "首をかしげる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_ed0a80b8(5)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2500190)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var11, 15)
	helper_ed0a80b8(3)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2500200)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "指さす", 6, -1.0, 1)
	event.ObjsNextMotion(0, "指さすL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2500210)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(14)
	end
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
	helper_e2d04ed9(9)
	if vm.skipping() then
		return skip(15)
	end
	helper_ed0a80b8(80)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(0, 46)
	event.CmrsMove2(206.33, 67.63, 392.02, 17.65, 209.62, 96.0, 120, 0, 0.4)
	event.ObjsMove2(9, -203.42, 128.16, -69.67, 120, 0, 0.4)
	event.ObjsRotation2(9, 0.0, 1.13, 0.0, 120, 0, 0.4)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(17)
	end
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
	helper_f90fbb97(2500220, 90)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "うれし口～大口")
	helper_f90fbb97(2500230, 60)
	if vm.skipping() then
		return skip(19)
	end
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
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(9, "右の木を植える", 6)
	event.ObjsNextMotion(9, "右の木を植えるL", 4)
	helper_ed0a80b8(8)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "右へよける", 6)
	event.ObjsSetMotion(1, "上向きから驚き", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向きから驚きＬ", 0)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_ed0a80b8(5)
	if vm.skipping() then
		return skip(23)
	end
	do
		local out1, _, out3 = event.EohGetFramePos(9, "R_tree")
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	event.DelReference(43)
	event.ObjsSetPos(10, pos_x_2, 0.0, pos_z_2)
	event.ObjsSetMotion(10, "ぷるん", 6)
	helper_e2d04ed9(10)
	if vm.skipping() then
		return skip(24)
	end
	helper_f90fbb97(2500235, -1)
	if vm.skipping() then
		return skip(25)
	end
	helper_e2d04ed9(9)
	if vm.skipping() then
		return skip(26)
	end
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
	helper_f90fbb97(2500240, 25)
	if vm.skipping() then
		return skip(27)
	end
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
	helper_ed0a80b8(8)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "左へよける", 6)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_ed0a80b8(5)
	if vm.skipping() then
		return skip(30)
	end
	do
		local out1, _, out3 = event.EohGetFramePos(9, "L_tree")
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	event.DelReference(44)
	event.ObjsSetPos(11, pos_x_2, 0.0, pos_z_2)
	event.ObjsSetMotion(11, "ぷるん", 6)
	helper_e2d04ed9(9)
	if vm.skipping() then
		return skip(31)
	end
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(32)
	end
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
	helper_c3ce9c48(2500250)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 1, "目キラキラ")
	event.ObjsSetMotion(0, "すごいよ", 6, -1.0, 1)
	event.ObjsNextMotion(0, "すごいよL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_c3ce9c48(2500260)
	if vm.skipping() then
		return skip(34)
	end
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
	helper_ed0a80b8(72)
	if vm.skipping() then
		return skip(35)
	end
	event.CharaActive(1, 39)
	event.EohSetShadow(0, 0)
	event.EohSetShadow(1, 0)
	event.EohSetShadow(5, 0)
	event.ObjsSetPos(5, -314.51, 136.42, 395.63)
	event.ObjsSetRot(5, 0.0, 3.04, 0.0)
	event.FadeOutBgm(60)
	event.ObjsSetMotion(9, "浮遊", 2)
	event.ObjsMotionWait(9)
	helper_e2d04ed9(9)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSePlay(var11, 20)
	event.ObjsSetMotion(9, "入り口開く", 6)
	event.ObjsNextMotion(9, "入り口開くL", 4)
	event.ObjsMove(5, -314.51, 12.03, 395.63, 66)
	helper_ed0a80b8(67)
	if vm.skipping() then
		return skip(37)
	end
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
	helper_c3ce9c48(2500270)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(0, "上→すごいよ", 6)
	event.ObjsNextMotion(0, "すごいよL", 0)
	event.SetPakuAnim(0, "わらい口パク")
	helper_c3ce9c48(2500280)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "すごいよ戻り", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(5, "会話2", 6)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_c3ce9c48(2500290)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "上向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(41)
	end
	helper_ed0a80b8(3)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(0, "歩き", 0)
	event.ObjsSetMotion(1, "歩き", 0)
	event.ObjsRotation(0, 0.0, 0.12, 0.0, 6)
	event.ObjsRotation(1, 0.0, -0.24, 0.0, 6)
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(43)
	end
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
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(44)
	end
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
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(45)
	end
	event.SndSePlay(var11, 21)
	event.ObjsSetMotion(9, "閉まる", 6, -1.0, 1)
	event.ObjsMove(0, -294.8, 150.42, 393.65, 68)
	event.ObjsMove(1, -289.64, 150.42, 408.11, 68)
	event.ObjsMove(5, -310.53, 150.42, 383.79, 68)
	helper_ed0a80b8(38)
	if vm.skipping() then
		return skip(46)
	end
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(47)
	end
	return part2()
end

--- Helper function.
local function helper_1945c()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
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
local function helper_19130()
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
local function helper_1a3cc()
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 33 then
			if at <= 1 then
				helper_1945c()
			end
			if at <= 2 then
				helper_c3ce9c48(2500500)
			end
			if at <= 3 then
				helper_c3ce9c48(2500510)
			end
			if at <= 4 then
				helper_c3ce9c48(2500520)
			end
			if at <= 5 then
				helper_c3ce9c48(2500525)
			end
			if at <= 6 then
				helper_e2d04ed9(1)
			end
			if at <= 7 then
				helper_f9fe2856()
			end
			if at <= 8 then
				helper_c3ce9c48(2500530)
			end
			if at <= 9 then
				helper_c3ce9c48(2500540)
			end
			if at <= 10 then
				helper_c3ce9c48(2500545)
			end
			if at <= 11 then
				helper_c3ce9c48(2500550)
			end
			if at <= 12 then
				helper_c3ce9c48(2500555)
			end
			if at <= 13 then
				helper_c3ce9c48(2500560)
			end
			if at <= 14 then
				helper_c3ce9c48(2500570)
			end
			if at <= 15 then
				helper_c3ce9c48(2500580)
			end
			if at <= 16 then
				helper_c3ce9c48(2500585)
			end
			if at <= 17 then
				helper_ed0a80b8(27)
			end
			if at <= 18 then
				helper_c3ce9c48(2500590)
			end
			if at <= 19 then
				helper_c3ce9c48(2500595)
			end
			if at <= 20 then
				helper_c3ce9c48(2500600)
			end
			if at <= 21 then
				helper_c3ce9c48(2500610)
			end
			if at <= 22 then
				helper_c3ce9c48(2500620)
			end
			if at <= 23 then
				helper_c3ce9c48(2500630)
			end
			if at <= 24 then
				helper_c3ce9c48(2500640)
			end
			if at <= 25 then
				helper_e2d04ed9(0)
			end
			if at <= 26 then
				helper_ed0a80b8(30)
			end
			if at <= 27 then
				helper_ed0a80b8(30)
			end
			if at <= 28 then
				helper_c3ce9c48(2500650)
			end
			if at <= 29 then
				helper_c3ce9c48(2500655)
			end
			if at <= 30 then
				helper_ed0a80b8(15)
			end
			if at <= 31 then
				helper_c3ce9c48(2500660)
			end
			if at <= 32 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(34)
			end
			return part2()
		end
		helper_19130()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 22)
		helper_19130()
		event.SetFadeIn(30)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.SetFlag(250, 1)
	event.Initialize()
	var1 = event.SndLoadSound(2234) or var1
	helper_1945c()
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
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2500500)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2500510)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, global1)
	event.CmrsSetPos(-701.14, 38.12, -985.84)
	event.CmrsSetRef(-699.63, 28.19, -1037.85)
	event.CmrsMove2(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2500520)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2500525)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_f9fe2856()
	if vm.skipping() then
		return skip(8)
	end
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
	helper_c3ce9c48(2500530)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2500540)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2500545)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(2, 128.0, 128.0, 128.0, 128.0, 10)
	helper_c3ce9c48(2500550)
	if vm.skipping() then
		return skip(12)
	end
	helper_c3ce9c48(2500555)
	if vm.skipping() then
		return skip(13)
	end
	helper_c3ce9c48(2500560)
	if vm.skipping() then
		return skip(14)
	end
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
	helper_c3ce9c48(2500570)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "上→右見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2500580)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2500585)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 120)
	event.CharaActive(0, 121)
	event.CharaActive(0, global0)
	event.CmrsSetPos(-675.55, 30.55, -1072.9)
	event.CmrsSetRef(-648.05, 22.05, -1072.56)
	event.SndSePlay(var1, 23)
	event.ObjsSetMotion(1, "アトラ見る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "アトラ見るL", 0)
	helper_ed0a80b8(27)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2500590)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2500595)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "アトラ見から立ちに", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_c3ce9c48(2500600)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(1, global0)
	event.CharaActive(0, global1)
	event.CmrsSetPos(-675.37, 33.53, -1088.87)
	event.CmrsSetRef(-659.31, 20.57, -1054.58)
	event.ObjsSetPos(0, -661.43, -0.0, -1055.96)
	event.ObjsSetRot(0, 0.0, 3.04, 0.0)
	event.ObjsSetMotion(0, "モニカ見立ち", 4)
	helper_c3ce9c48(2500610)
	if vm.skipping() then
		return skip(22)
	end
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
	helper_c3ce9c48(2500620)
	if vm.skipping() then
		return skip(23)
	end
	helper_c3ce9c48(2500630)
	if vm.skipping() then
		return skip(24)
	end
	event.CharaDaEnable(global0, 0)
	event.SndSePlay(var1, 24)
	event.ObjsSetMotion(0, "アトラを持つ", 6)
	event.ObjsNextMotion(0, "アトラを持つL", 0)
	helper_c3ce9c48(2500640)
	if vm.skipping() then
		return skip(25)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(26)
	end
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsRotation(1, 0.0, 0.24, 0.0, 30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(28)
	end
	helper_c3ce9c48(2500650)
	if vm.skipping() then
		return skip(29)
	end
	helper_c3ce9c48(2500655)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsSetMotion(1, "アトラを持つ戻り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(31)
	end
	event.SndSePlay(var1, 25)
	event.ObjsSetMotion(0, "うなづく", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_c3ce9c48(2500660)
	if vm.skipping() then
		return skip(32)
	end
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(33)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1e050()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10bd8()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s26", 501)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1a3cc()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g01")
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1e050()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s26", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		print("KITA###########################\n")
		print("KITA2222222###########################\n")
	end
	helper_10bd8()
	if vm.skipping() then
		return skip(1)
	end
	print("KITA###########################\n")
	event.SetFadeIn(30)
	print("KITA2222222###########################\n")
end

return script
