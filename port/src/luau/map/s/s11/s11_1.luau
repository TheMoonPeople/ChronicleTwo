--!strict
-- map/s/s11/s11_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06423b6b = require("@lib/event/helper_06423b6b")
local helper_1f87415e = require("@lib/event/helper_1f87415e")
local helper_35f524f2 = require("@lib/event/helper_35f524f2")
local helper_3ebb30a5 = require("@lib/event/helper_3ebb30a5")
local helper_407b4453 = require("@lib/event/helper_407b4453")
local helper_4fb6aa30 = require("@lib/event/helper_4fb6aa30")
local helper_559461c9 = require("@lib/event/helper_559461c9")
local helper_56de521d = require("@lib/event/helper_56de521d")
local helper_585cedf7 = require("@lib/event/helper_585cedf7")
local helper_758669fc = require("@lib/event/helper_758669fc")
local helper_8229a4fd = require("@lib/event/helper_8229a4fd")
local helper_867cb812 = require("@lib/event/helper_867cb812")
local helper_8ac7d4a3 = require("@lib/event/helper_8ac7d4a3")
local helper_8e53ce0a = require("@lib/event/helper_8e53ce0a")
local helper_8e595e1a = require("@lib/event/helper_8e595e1a")
local helper_9d160cf5 = require("@lib/event/helper_9d160cf5")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a255005b = require("@lib/event/helper_a255005b")
local helper_b518043c = require("@lib/event/helper_b518043c")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")
local helper_c2223bb0 = require("@lib/event/helper_c2223bb0")
local helper_c6a8e6d1 = require("@lib/event/helper_c6a8e6d1")
local helper_cc621191 = require("@lib/event/helper_cc621191")
local helper_cf499094 = require("@lib/event/helper_cf499094")
local helper_d2758d7c = require("@lib/event/helper_d2758d7c")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local var1: s32 = 0
	helper_c6a8e6d1()
	flag = event.GetFlag(640) or flag
	helper_56de521d(flag)
	var1 = event.GetCnt(16) or var1
	if bit32.band(var1, 1) ~= 0 then
		event.EohSyncObj(0, "p01_s11", "s11_10-m0")
		event.EohSetShow(0, 1)
	end
	if bit32.band(var1, 2) ~= 0 then
		event.EohSyncObj(0, "p01_s11", "s11_09-m1")
		event.EohSetShow(0, 1)
	end
	if bit32.band(var1, 4) ~= 0 then
		event.EohSyncObj(0, "p01_s11", "s11_08-m0")
		event.EohSetShow(0, 1)
	end
	if bit32.band(var1, 8) ~= 0 then
		event.EohSyncObj(0, "p01_s11", "s11_07-m0")
		event.EohSetShow(0, 1)
	end
end

--- Helper function.
local function helper_382dc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, -205.0, -268.4, 3225.0)
	event.SetCharaRot(8, 0.0, 3.1415927, 0.0)
	event.SetCharaNo(8, 301)
end

--- Helper function.
local function helper_279f4()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bc77b237(20)
		end
		if at <= 2 then
			helper_8e53ce0a(0)
		end
		if at <= 3 then
			helper_bc77b237(10)
		end
		helper_35f524f2()
	end
	var0 = event.GetCnt(0) or var0
	if var0 == 0 then
		helper_35f524f2()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		event.SetFadeIn(30)
		return
	end
	event.Initialize()
	event.EohSyncObj(1, "p01_train01")
	event.EohSetPos(1, 895.0, -254.5, 3348.1)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
	event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
	event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
	event.EohSyncObj(5, "p01_train01", "s3601_17-m")
	if var0 == 2 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
	end
	if var0 == 3 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m8")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
	end
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	var4 = 350.0
	if var0 == 2 then
		var4 = -170.0
	end
	if var0 == 3 then
		var4 = -690.0
	end
	event.CmrsInit()
	event.CmrsSetPos(var4 - vm.f32(135.23), -235.54, 3098.71)
	event.CmrsSetRef(var4, -236.6, 3227.1)
	event.SetFadeIn(30)
	event.ObjsSetPos(0, var4, -220.0, 3330.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	var5 = event.GetSndId(2) or var5
	event.SndSePlay(var5, 92)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, var4, -268.4, 3227.1, 30)
	event.ObjsSetMotion(0, "走り", 4)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(1)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	helper_35f524f2()
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0)
end

--- Helper function.
local function helper_26810()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8e53ce0a(1)
		end
		if at <= 2 then
			helper_bc77b237(10)
		end
		if at <= 3 then
			helper_bc77b237(30)
		end
		if at <= 4 then
			helper_bc77b237(20)
		end
		if at <= 5 then
			helper_8e53ce0a(0)
		end
		if at <= 6 then
			helper_bc77b237(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 295.0, -254.5, 3348.1)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(1431.5, 490.41, 2669.18)
	event.CmrsSetRef(497.59, -338.93, 3460.46)
	event.SetFadeIn(30)
	event.ObjsMove2(1, 895.0, -254.5, 3348.1, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-305.23, -235.54, 3098.71)
	event.CmrsSetRef(-170.0, -236.6, 3227.1)
	event.EohSetPos(1, 895.0, -254.5, 3348.1)
	event.CharaActive(0)
	event.ObjsSetPos(0, -170.0, -220.0, 3330.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 92)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -170.0, -268.4, 3227.1, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, 895.0, -254.5, 3348.1)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CharaActive(0)
	event.SetCharaPos(0, -170.0, -268.4, 3227.1)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Helper function.
local function helper_3a928()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local language_code: s32 = 0
	local var4: f32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_9d160cf5(0, -1, var0, 0, 0)
			end
			if at <= 2 then
				helper_9d160cf5(0, -1, var0, 0, 0)
			end
			if at <= 3 then
				helper_9d160cf5(0, -1, var0, 0, 0)
			end
			if at <= 4 then
				helper_9d160cf5(0, -1, var0, 0, 0)
			end
			if at <= 5 then
				helper_06423b6b(0, 1)
				var2 = helper_758669fc(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_9d160cf5(0, -1, var0, 0, 0)
			end
			return 0
		end
		if at <= 8 then
			helper_559461c9(6480010)
		end
		if at <= 9 then
			helper_06423b6b(0, 1)
			var5 = helper_758669fc(0, -1, 5, 256, 208, 2, 1)
		end
		if at <= 10 then
			helper_559461c9(6480020)
		end
		if at <= 11 then
			helper_06423b6b(0, 1)
			helper_8e595e1a(var0, var4, 0, 0)
		end
		return 1
	end
	var0 = event.GetEventData_2(13) or var0
	flag = event.GetFlag(55) or flag
	if flag == 0 then
		event.SetFlag(55, 1)
		event.SetMesShippo(0, 1)
		event.SetMesPreset(0, 0)
		helper_8ac7d4a3(0, var0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(
			0,
			"Wow! Chrono Unions are actually\npossible! I can't believe it!<page>There's nothing those ancients couldn't\ndo with their science, huh?"
		)
		helper_9d160cf5(0, -1, var0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"According to my research, an object\nunder a Chrono Union may exist in two\nseparate spaces and times at once."
		)
		helper_9d160cf5(0, -1, var0, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"That means that Paznos is here\nin this time, but that it also\nexists in the future, too.<page>I admit, this concept's \na little confusing."
		)
		helper_9d160cf5(0, -1, var0, 0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Well, I guess we'd\nbetter get going.")
		helper_9d160cf5(0, -1, var0, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(var0, "立ち")
		helper_06423b6b(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Yeah!\nI want to stay a little longer.")
		var2 = helper_758669fc(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var2 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "Hurry it up.")
			helper_9d160cf5(0, -1, var0, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(var0, "立ち")
			event.Finish()
			return 0
		end
		return 1
	else
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.AssignStack(5)
		event.ClearStack(5)
		language_code = event.GetLanguage() or language_code
		if language_code == 0 then
			event.LoadMes(0, 5, "event/e600/e648/e648.txt")
		else
			event.LoadMes(0, 5, "event/e600/e648/e648_1.txt")
		end
		event.StopBgm(0)
		var4 = helper_1f87415e(var0, 0, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_559461c9(6480010)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMotion(var0, "立ち")
		helper_06423b6b(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Yeah!\nI want to stay a little longer.")
		var5 = helper_758669fc(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(10)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 ~= 0 then
			event.SetMotion(var0, "会話")
			event.SetMesWindowMode(0, 7)
			helper_559461c9(6480020)
			if vm.skipping() then
				return skip(11)
			end
		end
		event.LoadMes(0, -1)
		helper_06423b6b(0, 1)
		helper_8e595e1a(var0, var4, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
		if var5 == 0 then
			return 1
		else
			event.PlayBgm(0)
			return 0
		end
	end
end

--- Helper function.
local function helper_2ace0()
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
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(13, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 13)
	event.LoadChara(5, "event/e600/e616/e616_eina_holo.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(6, 41)
	event.ObjsInit(6, 41)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e600/e616/e616_touei.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.LoadChara(5, "event/e600/e616/e616_hologram.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.SetCharaType(40, 4)
	event.LoadChara(5, "event/e600/e616/e616_key_h.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 43)
	event.EohSyncChara(15, 43)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 15)
	event.CharaActive(0, 43)
	event.EohSyncObj(16, "p10_s48")
	event.EohSyncObj(4, "p01_train01")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "s3601_12-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(7, "p01_s11", "s11_06-m0")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_s11", "s11_04-m0")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p01_s11", "s11_05-m0")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p01_s11", "s11_04-m0", "mi1")
	event.EohSyncObj(11, "p01_s11", "s11_05-m0", "mi2")
	event.EohSyncObj(12, "p01_s11", "s11_06-m0", "mi")
	event.EohSyncObj(14, "p01_s11", "s11_03-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 14)
	block = event.LoadImg_4(5, "textures/event/e600/e616/e616.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e61601", block)
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
	event.SpriteSetTexture(1, "e61602", block)
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
	event.SpriteSetTexture(2, "e61603", block)
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
	event.SpriteSetTexture(3, "e61604", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(3, 512, 416)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(23, 3)
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e61605", block)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetUvsize(4, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(4, 512, 416)
	event.SpriteSetPos(4, 256, 208)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(24, 4)
	event.ObjsInit(24)
	event.ObjsSyncObj(24, 24)
	event.LoadMes(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_2a62c()
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
	event.ObjsSetPos(4, 895.0, -254.5, 3348.1)
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.ObjsSetPos(9, 0.0, 0.0, 0.0)
	event.ObjsSetPos(8, 0.0, 0.0, 0.0)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.EohSetFrameShow(10, "", 1)
	event.EohSetFrameShow(11, "", 1)
	event.DelImg(0)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.SetCharaPos(0, 1.4, -13.3, 312.5)
	event.SetCharaRot(0, 0.0, 3.12, 0.0)
	event.SetStatus(1, 0, 256, 0)
end

--- Helper function.
local function helper_2d148()
	local var6: s32 = 0
	local var7: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var27: s32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 99 then
			if at <= 5 then
				helper_c6a8e6d1()
				helper_2ace0()
				var11 = 0
			end
			if at <= 6 then
				pos_x = vm.f32(pos_x + vm.f32(vm.f32(-790.0 - pos_x) / 24.0))
				pos_y = vm.f32(pos_y + vm.f32(vm.f32(-254.5 - pos_y) / 16.0))
				pos_z = vm.f32(pos_z + vm.f32(vm.f32(vm.f32(3348.1) - pos_z) / 16.0))
				var11 = var11 + 1
				var12 = 2.0
				var11 = 0
				pos_y = vm.f32(pos_y + var12)
				pos_y = vm.f32(pos_y - var12)
				var12 = vm.f32(var12 - vm.f32(var12 / 30.0))
				var11 = var11 + 1
			end
			if at <= 7 then
				helper_8e53ce0a(4)
			end
			if at <= 8 then
				helper_407b4453()
			end
			if at <= 9 then
				helper_bc77b237(60)
			end
			if at <= 10 then
				helper_c2223bb0(6160130, -1)
			end
			if at <= 11 then
				helper_bc77b237(30)
			end
			if at <= 12 then
				helper_c2223bb0(6160140, -1)
			end
			if at <= 13 then
				helper_c2223bb0(6160150, -1)
			end
			if at <= 14 then
				helper_bc77b237(30)
			end
			if at <= 15 then
				helper_8e53ce0a(0)
			end
			if at <= 16 then
				helper_8e53ce0a(1)
			end
			if at <= 17 then
				helper_8e53ce0a(2)
			end
			if at <= 18 then
				helper_559461c9(6160160)
			end
			if at <= 19 then
				helper_bc77b237(60)
			end
			if at <= 20 then
				helper_8e53ce0a(2)
			end
			if at <= 21 then
				helper_bc77b237(30)
			end
			if at <= 22 then
				helper_559461c9(6160170)
			end
			if at <= 23 then
				helper_559461c9(6160180)
			end
			if at <= 24 then
				helper_407b4453()
			end
			if at <= 25 then
				helper_559461c9(6160190)
			end
			if at <= 26 then
				helper_bc77b237(15)
			end
			if at <= 27 then
				helper_559461c9(6160200)
			end
			if at <= 28 then
				helper_559461c9(6160210)
			end
			if at <= 29 then
				helper_559461c9(6160220)
			end
			if at <= 30 then
				helper_407b4453()
			end
			if at <= 31 then
				helper_559461c9(6160230)
			end
			if at <= 32 then
				helper_559461c9(6160240)
			end
			if at <= 33 then
				helper_bc77b237(15)
			end
			if at <= 34 then
				helper_c2223bb0(6160250, -1)
			end
			if at <= 35 then
				helper_c2223bb0(6160255, -1)
			end
			if at <= 36 then
				helper_c2223bb0(6160260, -1)
			end
			if at <= 37 then
				helper_c2223bb0(6160270, -1)
			end
			if at <= 38 then
				helper_c2223bb0(6160275, -1)
			end
			if at <= 39 then
				helper_c2223bb0(6160280, -1)
			end
			if at <= 40 then
				helper_559461c9(6160290)
			end
			if at <= 41 then
				helper_bc77b237(30)
			end
			if at <= 42 then
				helper_559461c9(6160300)
			end
			if at <= 43 then
				helper_559461c9(6160305)
			end
			if at <= 45 then
				helper_bc77b237(30)
			end
			if at <= 46 then
				helper_559461c9(6160310)
			end
			if at <= 47 then
				helper_bc77b237(30)
			end
			if at <= 48 then
				helper_559461c9(6160320)
			end
			if at <= 49 then
				helper_559461c9(6160330)
			end
			if at <= 50 then
				helper_407b4453()
			end
			if at <= 51 then
				helper_bc77b237(30)
			end
			if at <= 52 then
				helper_559461c9(6160340)
			end
			if at <= 53 then
				helper_559461c9(6160350)
			end
			if at <= 54 then
				helper_407b4453()
			end
			if at <= 55 then
				helper_bc77b237(30)
			end
			if at <= 56 then
				helper_559461c9(6160360)
			end
			if at <= 57 then
				helper_bc77b237(30)
			end
			if at <= 58 then
				helper_559461c9(6160370)
			end
			if at <= 59 then
				helper_559461c9(6160373)
			end
			if at <= 60 then
				helper_559461c9(6160377)
			end
			if at <= 61 then
				helper_bc77b237(60)
			end
			if at <= 62 then
				helper_559461c9(6160380)
			end
			if at <= 63 then
				helper_bc77b237(30)
			end
			if at <= 64 then
				helper_8e53ce0a(1)
			end
			if at <= 65 then
				helper_8e53ce0a(1)
			end
			if at <= 66 then
				helper_bc77b237(30)
			end
			if at <= 67 then
				helper_8e53ce0a(1)
			end
			if at <= 68 then
				helper_8e53ce0a(1)
			end
			if at <= 69 then
				helper_8e53ce0a(1)
			end
			if at <= 70 then
				helper_8e53ce0a(1)
			end
			if at <= 71 then
				helper_bc77b237(30)
			end
			if at <= 72 then
				helper_8e53ce0a(1)
			end
			if at <= 73 then
				helper_bc77b237(30)
			end
			if at <= 74 then
				helper_8e53ce0a(1)
			end
			if at <= 75 then
				helper_bc77b237(30)
			end
			if at <= 76 then
				helper_8e53ce0a(0)
			end
			if at <= 77 then
				helper_8e53ce0a(0)
			end
			if at <= 78 then
				helper_8e53ce0a(0)
			end
			if at <= 79 then
				helper_bc77b237(30)
			end
			if at <= 80 then
				helper_8e53ce0a(0)
			end
			if at <= 81 then
				helper_bc77b237(30)
			end
			if at <= 82 then
				helper_bc77b237(30)
			end
			if at <= 83 then
				var27 = 0
				var15 = 0.0
				var17 = 0.0
				var21 = vm.f32(var18 - var15)
				var23 = vm.f32(var20 - var17)
				var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
				var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
				var18 = var28
				var20 = var29
				var15 = 0.0
				var17 = 0.0
				var21 = vm.f32(var18 - var15)
				var23 = vm.f32(var20 - var17)
				var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
				var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
				var18 = var28
				var20 = var29
				var15 = 0.0
				var17 = 0.0
				var21 = vm.f32(var18 - var15)
				var23 = vm.f32(var20 - var17)
				var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
				var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
				var18 = var28
				var20 = var29
				var15 = 0.0
				var17 = 0.0
				var21 = vm.f32(var18 - var15)
				var23 = vm.f32(var20 - var17)
				var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
				var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
				var18 = var28
				var20 = var29
				var15 = 0.0
				var17 = 0.0
				var21 = vm.f32(var18 - var15)
				var23 = vm.f32(var20 - var17)
				var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
				var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
				var18 = var28
				var20 = var29
				var15 = 0.0
				var17 = 0.0
				var21 = vm.f32(var18 - var15)
				var23 = vm.f32(var20 - var17)
				var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
				var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
				var18 = var28
				var20 = var29
				var27 = var27 + 1
			end
			if at <= 84 then
				helper_bc77b237(30)
			end
			if at <= 85 then
				helper_559461c9(6160400)
			end
			if at <= 86 then
				helper_8e53ce0a(1)
			end
			if at <= 87 then
				helper_3ebb30a5(362, 1)
			end
			if at <= 88 then
				helper_bc77b237(30)
			end
			if at <= 89 then
				helper_8e53ce0a(0)
			end
			if at <= 90 then
				helper_8e53ce0a(1)
			end
			if at <= 91 then
				helper_8e53ce0a(0)
			end
			if at <= 92 then
				helper_8e53ce0a(1)
			end
			if at <= 93 then
				helper_bc77b237(20)
			end
			if at <= 94 then
				helper_559461c9(6160410)
			end
			if at <= 95 then
				helper_559461c9(6160415)
			end
			if at <= 96 then
				helper_559461c9(6160420)
			end
			if at <= 97 then
				helper_559461c9(6160430)
			end
			if at <= 98 then
				helper_bc77b237(30)
			end
			if vm.skip_end() then
				return skip(100)
			end
			return part2()
		end
		if at <= 100 then
			helper_bc77b237(35)
		end
		helper_2a62c()
	end
	function part2()
		event.CancelDramaScene()
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_bc77b237(35)
		if vm.skipping() then
			return skip(101)
		end
		event.StopBgm(0)
		event.SndSeAllStop(4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.BgmLoadCancel()
		helper_2a62c()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.LoadBgm(5)
	event.PlayBgm(0)
	var6 = event.SndLoadSound(6201) or var6
	var7 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var7
	helper_c6a8e6d1()
	helper_2ace0()
	event.SetStatus(1, 0, 256, 1)
	event.EohSetFrameShow(10, "", 0)
	event.EohSetFrameShow(11, "", 0)
	event.EohSetShow(16, 0)
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 14)
	event.EohSetFootSoundId(1, 14)
	event.EohSetFootSoundId(13, 14)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "目パチ")
	event.ObjsSetPos(9, 0.0, 45.5, 0.0)
	event.ObjsSetPos(8, 0.0, 45.5, 0.0)
	event.ObjsSetPos(7, 0.0, -71.0, 0.0)
	event.EohSetPos(4, 6000.0, 2400.0, 5548.1)
	event.EohSetRot(4, 0.2, -1.77, 0.0)
	event.CmrsSetPos(0.0, 95.11, 4837.34)
	event.CmrsSetRef(6000.0, 2400.0, 5548.1)
	event.SndSePlay(var6, 0)
	event.SetFadeIn(30)
	event.ObjsRotation2(4, 0.0, -1.57, 0.0, 60, 2, 1.0)
	var11 = 0
	while var11 < 90 do
		if vm.wait() then
			return skip(6)
		end
		do
			local out1, out2, out3 = event.EohGetPos(4)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.f32(-790.0 - pos_x) / 24.0))
		pos_y = vm.f32(pos_y + vm.f32(vm.f32(-254.5 - pos_y) / 16.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.f32(vm.f32(3348.1) - pos_z) / 16.0))
		event.EohSetPos(4, pos_x, pos_y, pos_z)
		event.CmrsSetRef(pos_x, pos_y, pos_z)
		var11 = var11 + 1
	end
	event.ObjsMove2(4, -790.0, -254.5, 3348.1, 30, 2, 1.0)
	event.CmrsMoveRef(0.0, 102.15, 3577.24, 60)
	event.ObjsRotation(4, 0.0, -1.57, 0.0, 30)
	var12 = 2.0
	var11 = 0
	while var11 < 30 do
		do
			local out1, out2, out3 = event.EohGetPos(4)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if vm.imod(var11, 2) == 0 then
			pos_y = vm.f32(pos_y + var12)
		else
			pos_y = vm.f32(pos_y - var12)
		end
		var12 = vm.f32(var12 - vm.f32(var12 / 30.0))
		event.EohSetPos(4, pos_x, pos_y, pos_z)
		var11 = var11 + 1
		if vm.wait() then
			return skip(7)
		end
	end
	helper_8e53ce0a(4)
	if vm.skipping() then
		return skip(8)
	end
	helper_407b4453()
	if vm.skipping() then
		return skip(9)
	end
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CmrsSyncObj(0, 0.0, 25.0, 0.0, -3.12, -10.0, 70.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsSetPos(1, -20.0, -268.4, 2550.0)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.ObjsSetPos(0, 0.0, -268.4, 2550.0)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(2, 20.0, -268.4, 2550.0)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsMove(0, 0.0, -268.4, 2450.0, 60, 1)
	event.ObjsMove(1, -20.0, -268.4, 2450.0, 60, 1)
	event.ObjsMove(2, 20.0, -268.4, 2450.0, 60, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_c2223bb0(6160130, -1)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsReleaseObj()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(581.19, 1481.15, 2239.69, 100.38, -155.85, 234.68)
	event.CmrsAddPas(855.1, 1481.15, 2395.2, 100.38, -155.85, 234.68)
	event.CmrsStartPas()
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 240)
	event.ObjsAddPas(0, 0.0, -118.38, 1388.15)
	event.ObjsAddPas(0, 0.0, -79.03, 1037.78)
	event.ObjsStartPas(0, 1)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 240)
	event.ObjsAddPas(1, -20.0, -118.38, 1388.15)
	event.ObjsAddPas(1, -20.0, -79.03, 1037.78)
	event.ObjsStartPas(1, 1)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 240)
	event.ObjsAddPas(2, 20.0, -118.38, 1388.15)
	event.ObjsAddPas(2, 20.0, -79.03, 1037.78)
	event.ObjsStartPas(2, 1)
	helper_c2223bb0(6160140, -1)
	if vm.skipping() then
		return skip(13)
	end
	helper_c2223bb0(6160150, -1)
	if vm.skipping() then
		return skip(14)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.EohSetFootSoundId(13, 2)
	event.CmrsSetPos(5.17, 166.7, 673.45)
	event.CmrsSetRef(0.43, 32.65, 49.45)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 200)
	event.ObjsAddPas(0, -11.19, -13.08, 430.16)
	event.ObjsAddPas(0, 13.82, -7.06, 230.85)
	event.ObjsAddPas(0, 57.64, -7.06, 139.2)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 220)
	event.ObjsAddPas(1, -25.21, -13.07, 432.0)
	event.ObjsAddPas(1, -23.57, -9.29, 250.9)
	event.ObjsAddPas(1, -36.33, -7.06, 152.97)
	event.ObjsStartPas(1)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 240)
	event.ObjsAddPas(2, 39.42, -13.09, 422.23)
	event.ObjsAddPas(2, 6.38, -13.28, 301.26)
	event.ObjsAddPas(2, -3.42, -7.89, 248.04)
	event.ObjsAddPas(2, 0.66, -7.06, 171.52)
	event.ObjsStartPas(2)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var6, 1)
	event.ObjsSetMotion(0, "立ち")
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_8e53ce0a(2)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "立ち")
	helper_559461c9(6160160)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.CmrsSetPos(30.32, 33.53, 321.43)
	event.CmrsSetRef(-19.91, 9.23, 144.84)
	event.SetCharaPos(39, -2.0, -3.77, 210.36)
	event.SetCharaRot(39, 0.0, 3.05, 0.0)
	event.SetCharaPos(40, -2.0, -3.77, 210.36)
	event.SetCharaRot(40, 0.0, 3.05, 0.0)
	event.ObjsSetPos(1, -32.3, -7.06, 187.68)
	event.ObjsSetRot(1, 0.0, 0.83, 0.0)
	event.ObjsSetPos(0, 28.47, -7.06, 175.02)
	event.ObjsSetRot(0, 0.0, -0.49, 0.0)
	event.ObjsSetPos(2, -3.65, -7.06, 218.56)
	event.ObjsSetRot(2, 0.0, 3.05, 0.0)
	event.ObjsSetMotion(0, "下見立ち")
	event.ObjsSetMotion(1, "下見立ち")
	event.SndSePlay(var6, 2)
	event.ObjsSetMotion(2, "装置置く", 6)
	event.ObjsNextMotion(2, "装置置くループ", 4)
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "装置置く戻り", 6)
	helper_8e53ce0a(2)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(1, 39)
	event.CharaActive(1, 40)
	event.SndSePlay(var6, 3)
	event.SetMotion(40, "現れる", 6, -1, 1)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(22)
	end
	event.CharaActive(0, 38)
	event.CharaActive(1, 41)
	event.ObjsSetPos(6, -2.0, 5.2, 210.36)
	event.ObjsSetRot(6, 0.0, 3.12, 0.0)
	event.ObjsSetMotion(6, "立ち", 4)
	event.CmrsSetPos(25.82, 26.72, 190.12)
	event.CmrsSetRef(-1.98, 29.58, 205.98)
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160170)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(25.82, 26.72, 190.12, -1.98, 29.58, 205.98)
	event.CmrsAddPas(-28.98, 26.72, 187.0, -1.98, 29.58, 205.98)
	event.CmrsStartPas()
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160180)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_407b4453()
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160190)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_bc77b237(15)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CmrsSetPos(20.07, 36.4, 255.98)
	event.CmrsSetRef(-5.23, 17.06, 110.89)
	event.SetPakuAnim(0, "通常口パク")
	helper_559461c9(6160200)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160210)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(20.07, 36.4, 255.98, -5.23, 17.06, 110.89)
	event.CmrsAddPas(-24.67, 36.4, 257.05, -5.23, 17.06, 110.89)
	event.CmrsStartPas()
	event.SetPakuAnim(1, "通常口パク")
	helper_559461c9(6160220)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_407b4453()
	if vm.skipping() then
		return skip(31)
	end
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160230)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_559461c9(6160240)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	helper_bc77b237(15)
	if vm.skipping() then
		return skip(34)
	end
	event.CharaActive(1, 38)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(800)
	event.CmrsAddPas(-17.0, 360.21, 536.27, -2.0, 596.27, 210.36)
	event.CmrsAddPas(-17.0, 142.48, 536.27, -2.0, 17.1, 210.36)
	event.CmrsStartPas()
	helper_c2223bb0(6160250, -1)
	if vm.skipping() then
		return skip(35)
	end
	helper_c2223bb0(6160255, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_c2223bb0(6160260, -1)
	if vm.skipping() then
		return skip(37)
	end
	helper_c2223bb0(6160270, -1)
	if vm.skipping() then
		return skip(38)
	end
	helper_c2223bb0(6160275, -1)
	if vm.skipping() then
		return skip(39)
	end
	helper_c2223bb0(6160280, -1)
	if vm.skipping() then
		return skip(40)
	end
	helper_559461c9(6160290)
	if vm.skipping() then
		return skip(41)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(42)
	end
	event.SpriteSetDraw(4, 1)
	event.ObjsSetColor(24, 128, 128, 128, 128, 30)
	helper_559461c9(6160300)
	if vm.skipping() then
		return skip(43)
	end
	helper_559461c9(6160305)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsInitPas()
	event.CmrsInit()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CharaActive(0, 38)
	event.CmrsSetPos(20.07, 36.4, 255.98)
	event.CmrsSetRef(-5.23, 17.06, 110.89)
	if vm.wait() then
		return skip(45)
	end
	event.ObjsSetColor(24, 128, 128, 128, 0, 30)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(46)
	end
	helper_559461c9(6160310)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(0.0, 140.0, 0.0, -229.22, 17.06, 307.42)
	event.CmrsAddPas(0.0, 140.0, 0.0, -276.98, 17.06, -272.13)
	event.CmrsStartPas()
	helper_559461c9(6160320)
	if vm.skipping() then
		return skip(49)
	end
	helper_559461c9(6160330)
	if vm.skipping() then
		return skip(50)
	end
	helper_407b4453()
	if vm.skipping() then
		return skip(51)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(0.0, 140.0, 0.0, 236.12, 17.06, -313.37)
	event.CmrsAddPas(0.0, 140.0, 0.0, 282.78, 17.06, 279.16)
	event.CmrsStartPas()
	event.SetCrossfade(30)
	helper_559461c9(6160340)
	if vm.skipping() then
		return skip(53)
	end
	helper_559461c9(6160350)
	if vm.skipping() then
		return skip(54)
	end
	helper_407b4453()
	if vm.skipping() then
		return skip(55)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsSetPos(-1.43, 44.53, 179.99)
	event.CmrsSetRef(-2.0, 29.91, 210.36)
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160360)
	if vm.skipping() then
		return skip(57)
	end
	event.ResetPakuAnim()
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(58)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(20, 128, 128, 128, 128, 30)
	helper_559461c9(6160370)
	if vm.skipping() then
		return skip(59)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(21, 128, 128, 128, 128, 30)
	helper_559461c9(6160373)
	if vm.skipping() then
		return skip(60)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(22, 128, 128, 128, 128, 30)
	helper_559461c9(6160377)
	if vm.skipping() then
		return skip(61)
	end
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(23, 128, 128, 128, 128, 30)
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(62)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.ObjsSetColor(23, 128, 128, 128, 0, 30)
	event.CmrsSetPos(-1.02, 0.96, 158.0)
	event.CmrsSetRef(-2.0, 21.86, 210.36)
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160380)
	if vm.skipping() then
		return skip(63)
	end
	event.ResetPakuAnim()
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(64)
	end
	event.CharaActive(1, 38)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(625.14, 908.7, 665.85)
	event.CmrsSetRef(-3.77, 13.41, -2.77)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -32.3, -7.06, 187.68)
	event.ObjsAddPas(1, -11.34, -7.06, 108.48)
	event.ObjsAddPas(1, -9.03, -7.06, 99.73)
	event.ObjsStartPas(1, 1)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(0, 25.73, -7.06, 162.26)
	event.ObjsSetRot(0, 0.0, -2.65, 0.0)
	event.CmrsSetPos(-198.14, 96.68, 321.01)
	event.CmrsSetRef(-28.92, 35.2, 133.4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -8.28, -7.06, 120.98)
	event.ObjsAddPas(1, -5.01, -7.06, 90.55)
	event.ObjsAddPas(1, -2.73, 3.81, 72.64)
	event.ObjsAddPas(1, -1.59, 3.81, 44.63)
	event.ObjsStartPas(1, 1)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsSetMotion(1, "覗きこみ", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(68)
	end
	event.ObjsRotation(1, 0.0, -1.98, 0.0, 10)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(69)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -1.59, 3.81, 44.63)
	event.ObjsAddPas(1, -55.75, 3.81, 20.86)
	event.ObjsStartPas(1)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsRotation(1, 0.0, 3.12, 0.0, 10)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(72)
	end
	event.ObjsSetMotion(1, "触れる", 2)
	event.ObjsNextMotion(1, "触れるL", 4)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(73)
	end
	event.SndSePlay(var6, 4)
	event.EohSetFrameShow(10, "", 1)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(74)
	end
	event.ObjsSetPos(0, 5.82, -7.06, 132.65)
	event.CmrsSetPos(-74.97, 23.62, 244.3)
	event.CmrsSetRef(-15.01, 35.2, 88.03)
	event.ObjsSetMotion(1, "ユリス見", 2)
	event.ObjsNextMotion(1, "ユリス見L", 4)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(75)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(76)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 2.77, 0.0, 10)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(77)
	end
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 5.82, -7.06, 132.65)
	event.ObjsAddPas(0, 22.37, -7.06, 90.22)
	event.ObjsAddPas(0, 28.16, 3.81, 76.4)
	event.ObjsAddPas(0, 55.75, 3.81, 20.86)
	event.ObjsStartPas(0)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(78)
	end
	event.ObjsRotation(0, 0.0, 3.12, 0.0, 10)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(80)
	end
	event.ObjsSetMotion(0, "柱をさわる", 6)
	event.ObjsNextMotion(0, "柱をさわるL", 4)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(81)
	end
	event.EohSetFrameShow(11, "", 1)
	event.SndSePlay(var6, 4)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(82)
	end
	event.CmrsSetPos(-254.77, 157.73, -140.36)
	event.CmrsSetRef(17.9, 3.44, 114.28)
	event.ObjsSetMotion(1, "触れるL", 4)
	event.ObjsSetPos(2, -30.16, -7.06, 211.83)
	event.ObjsSetRot(2, 0.0, 3.12, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(83)
	end
	var27 = 0
	event.ObjsSetMotion(0, "びっくり", 6)
	event.ObjsNextMotion(0, "びっくりL", 4)
	event.SndSePlay(var6, 5)
	while var27 < 300 do
		do
			local out1, out2, out3 = event.GetCharaPos(global1)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		var15 = 0.0
		var17 = 0.0
		var21 = vm.f32(var18 - var15)
		var23 = vm.f32(var20 - var17)
		var13 = event.DistVector(var21, var22, var23) or var13
		var14 = event.Atan2f(var21, var23) or var14
		var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
		var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
		var18 = var28
		var20 = var29
		event.SetCharaPos(global1, var18, var19, var20)
		event.AddCharaRot(global1, 0.0, 0.020933334, 0.0)
		do
			local out1, out2, out3 = event.GetCharaPos(global0)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		var15 = 0.0
		var17 = 0.0
		var21 = vm.f32(var18 - var15)
		var23 = vm.f32(var20 - var17)
		var13 = event.DistVector(var21, var22, var23) or var13
		var14 = event.Atan2f(var21, var23) or var14
		var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
		var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
		var18 = var28
		var20 = var29
		event.SetCharaPos(global0, var18, var19, var20)
		event.AddCharaRot(global0, 0.0, 0.020933334, 0.0)
		do
			local out1, out2, out3 = event.EohGetPos(8)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = event.EohGetRot(8)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		var15 = 0.0
		var17 = 0.0
		var21 = vm.f32(var18 - var15)
		var23 = vm.f32(var20 - var17)
		var13 = event.DistVector(var21, var22, var23) or var13
		var14 = event.Atan2f(var21, var23) or var14
		var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
		var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
		var18 = var28
		var20 = var29
		event.EohSetPos(8, var18, var19 - vm.f32(0.15166667), var20)
		event.EohSetRot(8, rot_x, rot_y + vm.f32(0.020933334), rot_z)
		do
			local out1, out2, out3 = event.EohGetPos(9)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = event.EohGetRot(9)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		var15 = 0.0
		var17 = 0.0
		var21 = vm.f32(var18 - var15)
		var23 = vm.f32(var20 - var17)
		var13 = event.DistVector(var21, var22, var23) or var13
		var14 = event.Atan2f(var21, var23) or var14
		var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
		var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
		var18 = var28
		var20 = var29
		event.EohSetPos(9, var18, var19 - vm.f32(0.15166667), var20)
		event.EohSetRot(9, rot_x, rot_y + vm.f32(0.020933334), rot_z)
		do
			local out1, out2, out3 = event.EohGetPos(7)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = event.EohGetRot(7)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		var15 = 0.0
		var17 = 0.0
		var21 = vm.f32(var18 - var15)
		var23 = vm.f32(var20 - var17)
		var13 = event.DistVector(var21, var22, var23) or var13
		var14 = event.Atan2f(var21, var23) or var14
		var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
		var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
		var18 = var28
		var20 = var29
		event.EohSetPos(7, var18, var19 + vm.f32(0.23666666), var20)
		event.EohSetRot(7, rot_x, rot_y + vm.f32(0.020933334), rot_z)
		do
			local out1, out2, out3 = event.EohGetPos(14)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = event.EohGetRot(14)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		var15 = 0.0
		var17 = 0.0
		var21 = vm.f32(var18 - var15)
		var23 = vm.f32(var20 - var17)
		var13 = event.DistVector(var21, var22, var23) or var13
		var14 = event.Atan2f(var21, var23) or var14
		var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
		var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
		var18 = var28
		var20 = var29
		event.EohSetPos(14, var18, var19, var20)
		event.EohSetRot(14, rot_x, rot_y + vm.f32(0.020933334), rot_z)
		var27 = var27 + 1
		if vm.wait() then
			return skip(84)
		end
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(85)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsSetRot(1, 0.0, 1.27, 0.0)
	event.CmrsSetPos(0.0, 38.4, 184.95)
	event.CmrsSetRef(0.0, 47.52, 19.95)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_559461c9(6160400)
	if vm.skipping() then
		return skip(86)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -55.82, 3.81, 20.68)
	event.ObjsAddPas(1, -13.49, 3.81, 33.82)
	event.ObjsStartPas(1)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(87)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetPos(1, 0.14, 3.81, 53.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetReference(global1, "item", 42)
	event.CharaActive(1, 42)
	event.ObjsSetPos(11, 5.51, 34.53, 53.38)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.CmrsSetPos(0.8, 51.44, 69.42)
	event.CmrsSetRef(2.22, 23.76, 49.14)
	event.SndPauseBgm()
	event.CharaActive(1, 43)
	event.ObjsSetMotion(11, "発動", 6)
	event.SndSePlay(var6, 6)
	event.SndSePlay(var7, 0)
	event.ObjsSetMotion(1, "ゲット", 4)
	helper_3ebb30a5(362, 1)
	if vm.skipping() then
		return skip(88)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(89)
	end
	event.PlayBgm(0)
	event.CharaActive(0, 42)
	event.CharaActive(0, 43)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(-96.59, 8.53, 249.67)
	event.CmrsSetRef(33.2, 23.76, 157.73)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -14.5, -7.06, 117.32)
	event.ObjsAddPas(1, -12.84, -7.06, 160.19)
	event.ObjsStartPas(1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 90)
	event.ObjsAddPas(0, 14.5, -7.06, 117.32)
	event.ObjsAddPas(0, 12.84, -7.06, 160.19)
	event.ObjsStartPas(0)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(90)
	end
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(91)
	end
	event.ObjsReference(0, -2.0, -7.06, 210.36, 10)
	event.ObjsReference(1, -2.0, -7.06, 210.36, 10)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(92)
	end
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(93)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(94)
	end
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_559461c9(6160410)
	if vm.skipping() then
		return skip(95)
	end
	helper_559461c9(6160415)
	if vm.skipping() then
		return skip(96)
	end
	event.ObjsSetMotion(0, "上向くうなづき", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_559461c9(6160420)
	if vm.skipping() then
		return skip(97)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-0.69, 31.06, 181.32)
	event.CmrsSetRef(-2.0, 30.17, 210.36)
	event.SetPakuAnim(6, "口パク")
	helper_559461c9(6160430)
	if vm.skipping() then
		return skip(98)
	end
	event.SetMotion(40, "消える", 6, -1, 1)
	event.SetCharaShow(41, 0, 1, 0.05)
	event.SndSePlay(var6, 7)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(99)
	end
	return part2()
end

--- Helper function.
local function helper_1d734()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06423b6b(0, 1)
			return 0
		end
		if at <= 3 then
			helper_bc77b237(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_06423b6b(0, 4)
	event.MesMake_2(0, "Go inside\nLeave")
	var0 = helper_758669fc(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_06423b6b(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_bc77b237(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_bc77b237(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_36960()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bc77b237(30)
			end
			if vm.skip_end() then
				return skip(3)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SndSeStop(var0, 9)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetFootSoundId(2, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -2.21, 0.0, 25.73)
		event.SetCharaRot(0, 0.0, 0.03, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(648, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6237)
	var0 = event.SndLoadSound(6237) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e648/")
	event.LoadMes(0, 5, "e648_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e648_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e648_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e648_osmond.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 3.38, -9.6, -127.86)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 23)
	event.EohSetPos(1, 19.72, -9.6, -146.14)
	event.EohSetRot(1, 0.0, -0.81, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 23)
	event.EohSetPos(2, 0.11, -2.82, -96.44)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 23)
	event.EohSetPos(3, 1789.1, -254.5, 3348.1)
	event.EohSetRot(3, 0.0, -1.57, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-4336.34, 1717.11, 4012.69)
	event.CmrsSetRef(-3273.36, 957.4, 3430.04)
	event.CharaActive(0, 0)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 9)
	event.ObjsMove2(3, -5344.1, 1488.8, 3348.1, 120, 1, 0.7)
	event.ObjsRotDelay(3, 30)
	event.ObjsRotation2(3, 0.0, -1.57, -0.157, 60, 1, 1.0)
	helper_bc77b237(120)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Helper function.
local function helper_3956c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bc77b237(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFadeOut(30)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(2)
	end
	event.MapJump(-1, "s66", 600)
	if vm.wait() then
		return skip(3)
	end
end

--- Helper function.
local function helper_397cc(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			var3 = 2
		end
		if at <= 3 then
			var1 = vm.i32(bit32.bor(var1, var2))
		end
		if at <= 4 then
			helper_585cedf7()
		end
		if at <= 5 then
			var7 = 15
			helper_3956c()
		end
		if at <= 6 then
			helper_cf499094()
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	if arg0 == 365 then
		var2 = 1
	end
	if arg0 == 367 then
		var2 = 2
	end
	if arg0 == 366 then
		var2 = 4
	end
	if arg0 == 368 then
		var2 = 8
	end
	var1 = event.GetCnt(16) or var1
	if vm.i32(bit32.band(var1, var2)) ~= 0 then
		if arg0 == 365 then
			event.MesMake_2(0, "The Earth Gem is shining")
		end
		if arg0 == 367 then
			event.MesMake_2(0, "The Wind Gem is shining")
		end
		if arg0 == 366 then
			event.MesMake_2(0, "The Water Gem is shining")
		end
		if arg0 == 368 then
			event.MesMake_2(0, "The Fire Gem is shining")
		end
		helper_a255005b(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetEventData_2(6) or var3
	if var3 == 1 then
		if arg0 == 365 then
			event.MesMake_2(0, "There is an Earth Gem Altar.\n(Press (#) to open Menu)")
		end
		if arg0 == 367 then
			event.MesMake_2(0, "There is a Wind Gem Altar.\n(Press (#) to open Menu)")
		end
		if arg0 == 366 then
			event.MesMake_2(0, "There is a Water Gem Altar.\n(Press (#) to open Menu)")
		end
		if arg0 == 368 then
			event.MesMake_2(0, "There is a Fire Gem Altar.\n(Press (#) to open Menu)")
		end
		var5 = helper_4fb6aa30(0, -1, 5, 256, 208, var5)
		if vm.skipping() then
			return skip(2)
		end
		if var5 == 1 then
			var3 = 2
		end
	end
	if var3 == 2 then
		event.GotoUseItem(arg0)
		do
			local skipped = vm.wait()
			var4 = event.DeferredOutput() or var4
			if skipped then
				return skip(3)
			end
		end
		if var4 > 0 then
			if var4 == arg0 then
				var1 = vm.i32(bit32.bor(var1, var2))
				event.SetCnt(16, var1)
				event.SetLoadbgFile("snd2/sp/sp_033.sound.json")
				if vm.wait() then
					return skip(4)
				end
				helper_585cedf7()
				if vm.skipping() then
					return skip(5)
				end
				var6 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var6
				event.SndSePlay(var6, 2)
				if arg0 == 365 then
					event.EohSyncObj(0, "p01_s11", "s11_10-m0")
				end
				if arg0 == 367 then
					event.EohSyncObj(0, "p01_s11", "s11_09-m1")
				end
				if arg0 == 366 then
					event.EohSyncObj(0, "p01_s11", "s11_08-m0")
				end
				if arg0 == 368 then
					event.EohSyncObj(0, "p01_s11", "s11_07-m0")
				end
				event.EohSetShow(0, 1)
				var7 = 15
				if vm.i32(bit32.band(var1, var7)) == var7 then
					helper_3956c()
					if vm.skipping() then
						return skip(6)
					end
				end
			else
				helper_cf499094()
				if vm.skipping() then
					return skip(7)
				end
			end
		end
	end
end

--- Helper function.
local function helper_265c8()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_06423b6b(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "I'll wait for you here.\nI hope it all goes well.")
	else
		event.MesMake_2(0, "I'll wait here.\nMake sure you get him.")
	end
	helper_b518043c(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_26810()
		end
		helper_382dc()
	end
	event.Initialize()
	program_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_382dc()
		helper_9dafbc83(-40.0, vm.f32(-268.4), 3160.0, vm.f32(3.14))
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	else
		helper_9dafbc83(0.0, vm.f32(-268.4), 3000.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			var3 = event.GetCnt(1) or var3
			if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 6 then
				helper_382dc()
				helper_279f4()
				if vm.skipping() then
					return skip(1)
				end
			else
				helper_26810()
				if vm.skipping() then
					return skip(2)
				end
				helper_382dc()
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2d148()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_3a928()
	if vm.skipping() then
		return skip(1)
	end
	helper_2d148()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			helper_8229a4fd()
		end
	end
	var0 = helper_1d734()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 6)
	var1 = event.GetEventData_2(3) or var1
	if var1 <= 1 then
		helper_d2758d7c()
		if vm.skipping() then
			return skip(2)
		end
		event.StopBgm(0)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s37")
		if vm.wait() then
			return skip(4)
		end
	else
		helper_8229a4fd()
		if vm.skipping() then
			return skip(5)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cc621191()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.AddItem(362, 1)
	helper_2d148()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s37", 530)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 510.
script[510] = function()
	program_99()
	helper_382dc()
	helper_9dafbc83(170.0, vm.f32(-268.4), 3140.0, vm.f32(3.14))
	event.ResetCamera(1, 0.0, 0.0)
	event.SetFadeIn(30)
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_36960()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s12", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_397cc(365)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 552.
script[552] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_397cc(367)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 554.
script[554] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_397cc(366)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 556.
script[556] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_397cc(368)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 599.
script[599] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_99()
	helper_382dc()
	helper_9dafbc83(170.0, vm.f32(-268.4), 3140.0, vm.f32(3.14))
	event.ResetCamera(1, 0.0, 0.0)
	helper_867cb812(0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_bc77b237(30)
			end
			return
		end
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 301 then
		flag = event.GetFlag(640) or flag
		flag_2 = event.GetFlag(648) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			local t0 = helper_3a928()
			if vm.skipping() then
				return skip(1)
			end
			if t0 ~= 0 then
				event.SetFadeOut(30)
				helper_bc77b237(30)
				if vm.skipping() then
					return skip(2)
				end
				event.MapJump(-1, "s37", 520)
				if vm.wait() then
					return skip(3)
				end
			end
			return
		end
		helper_265c8()
		if vm.skipping() then
			return skip(4)
		end
	end
end

return script
