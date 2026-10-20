--!strict
-- map/g/g02/g02_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06423b6b = require("@lib/event/helper_06423b6b")
local helper_0aad4720 = require("@lib/event/helper_0aad4720")
local helper_0ec08062 = require("@lib/event/helper_0ec08062")
local helper_407b4453 = require("@lib/event/helper_407b4453")
local helper_559461c9 = require("@lib/event/helper_559461c9")
local helper_585cedf7 = require("@lib/event/helper_585cedf7")
local helper_58610e3d = require("@lib/event/helper_58610e3d")
local helper_758669fc = require("@lib/event/helper_758669fc")
local helper_7d17ed71 = require("@lib/event/helper_7d17ed71")
local helper_8e53ce0a = require("@lib/event/helper_8e53ce0a")
local helper_9d160cf5 = require("@lib/event/helper_9d160cf5")
local helper_a255005b = require("@lib/event/helper_a255005b")
local helper_a9038fed = require("@lib/event/helper_a9038fed")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")
local helper_c2223bb0 = require("@lib/event/helper_c2223bb0")
local helper_cac435d9 = require("@lib/event/helper_cac435d9")
local helper_dcb58cd3 = require("@lib/event/helper_dcb58cd3")
local helper_f8aba7e6 = require("@lib/event/helper_f8aba7e6")

--- Helper function.
local function helper_28970()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 17 then
			if at <= 1 then
				helper_8e53ce0a(1)
			end
			if at <= 2 then
				helper_bc77b237(10)
			end
			if at <= 3 then
				helper_c2223bb0(3020010, 100)
			end
			if at <= 4 then
				helper_c2223bb0(3020020, 40)
			end
			if at <= 5 then
				helper_407b4453()
			end
			if at <= 6 then
				helper_c2223bb0(3020025, 240)
			end
			if at <= 7 then
				helper_407b4453()
			end
			if at <= 8 then
				helper_bc77b237(60)
			end
			if at <= 9 then
				helper_559461c9(3020030)
			end
			if at <= 10 then
				helper_8e53ce0a(1)
			end
			if at <= 11 then
				helper_559461c9(3020033)
			end
			if at <= 12 then
				helper_8e53ce0a(0)
			end
			if at <= 13 then
				helper_559461c9(3020036)
			end
			if at <= 14 then
				helper_bc77b237(30)
			end
			if at <= 15 then
				helper_bc77b237(30)
			end
			if at <= 16 then
				helper_bc77b237(30)
			end
			if vm.skip_end() then
				return skip(18)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -484.3, 0.0, -241.8)
		event.SetCharaRot(0, 0.0, 0.63, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(302, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(3203)
	var0 = event.SndLoadSound(3203) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e302/")
	event.LoadMes(0, 5, "e302_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e302_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e302_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e302/e302_mints.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e302/e302_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetFootSoundId(0, 1)
	event.EohSetPos(0, -896.43, 0.0, -466.97)
	event.EohSetRot(0, 0.0, 1.46, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 90)
	event.ObjsAddPas(0, -942.31, 0.0, -490.69)
	event.ObjsAddPas(0, -900.66, 0.0, -465.41)
	event.ObjsAddPas(0, -864.88, 0.0, -454.67)
	event.ObjsAddPas(0, -842.75, 0.0, -451.14)
	event.ObjsStartPas(0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.EohSetFootSoundId(1, 1)
	event.EohSetPos(1, -906.51, 0.0, -493.26)
	event.EohSetRot(1, 0.0, 1.46, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 94)
	event.ObjsAddPas(1, -936.77, 0.0, -513.55)
	event.ObjsAddPas(1, -908.26, 0.0, -495.93)
	event.ObjsAddPas(1, -873.95, 0.0, -481.67)
	event.ObjsAddPas(1, -846.98, 0.0, -473.74)
	event.ObjsStartPas(1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 94)
	event.ObjsSetMotion(1, "立ち")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-628.61, 133.43, -295.88)
	event.CmrsSetRef(-904.95, 45.82, -445.11)
	event.SetFadeIn(30)
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-788.75, 21.72, -466.41)
	event.CmrsSetRef(-845.61, 14.05, -462.57)
	event.CmrsMoveAhd(1.24, 7.67, 56.93, 140)
	event.ObjsSetMotion(0, "キョロキョロ", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c2223bb0(3020010, 100)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c2223bb0(3020020, 40)
	if vm.skipping() then
		return skip(5)
	end
	helper_407b4453()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-423.31, 320.91, -1037.27)
	event.CmrsSetRef(-224.16, 315.23, -1109.17)
	event.CmrsMove2(-423.31, 320.91, -1037.27, -353.89, 315.23, -1191.88, 120, 2, 0.5)
	helper_c2223bb0(3020025, 240)
	if vm.skipping() then
		return skip(7)
	end
	helper_407b4453()
	if vm.skipping() then
		return skip(8)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-310.58, 2305.36, 307.51)
	event.CmrsSetRef(-285.96, 2254.59, 250.8)
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-788.75, 21.72, -466.41)
	event.CmrsSetRef(-845.61, 14.05, -462.57)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "手当てきょろきょろ", 6)
	event.ObjsNextMotion(1, "戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.EohSetTexAnim(0, 1, "口とじ～半口")
	helper_559461c9(3020030)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetTexAnim(0, 0, "口とじ～半口")
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-866.53, 35.13, -489.41)
	event.CmrsSetRef(-761.07, 14.23, -373.8)
	event.ObjsSetRot(0, 0.0, 2.43, 0.0)
	event.ObjsSetMotion(0, "指さす", 6, -1.0, 1)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_559461c9(3020033)
	if vm.skipping() then
		return skip(12)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-798.38, 18.7, -471.33)
	event.CmrsSetRef(-843.17, 20.06, -461.7)
	event.ObjsSetRot(0, 0.0, 2.91, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "右向くL", 4, -1.0, 1)
	event.SetPakuAnim(0, "わらい口パク")
	helper_559461c9(3020036)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "右向くうなづき", 6)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-890.1, 44.29, -500.83)
	event.CmrsSetRef(-840.33, 36.43, -459.09)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 0.87, 0.0, 10)
	event.ObjsMove(0, -801.56, 0.0, -408.6, 60)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsRotation(1, 0.0, 0.87, 0.0, 20)
	event.ObjsMove(1, -798.52, 0.0, -429.51, 60)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(30)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(17)
	end
	return part2()
end

--- Program 210.
local function program_210()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_cac435d9()
		var4 = vm.f32(var4 - vm.f32(3.1415927))
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_cac435d9()
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 61)
	do
		local out1, out2, out3 = event.FuncPointGetPos("", "func3")
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var4 = event.FuncPointGetRot("", "func3") or var4
	var4 = vm.f32(var4 - vm.f32(3.1415927))
	var4 = event.AngleLimit(var4) or var4
	event.SetCharaPos(0, var1, var2, var3)
	event.SetCharaRot(0, 0.0, var4, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_18fec()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_19078(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_a255005b(0, -1, 5, 0, 0)
		end
		helper_18fec()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(0, "We jumped to the future with the\nIxion's time-travelling mechanism.")
	else
		event.MesMake_2(0, "We returned to the present with the\nIxion's time-travelling mechanism.")
	end
	if vm.wait() then
		return skip(3)
	end
	helper_a255005b(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_18fec()
end

--- Helper function.
local function helper_195f0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_407b4453()
			end
			if at <= 2 then
				helper_585cedf7()
			end
			if at <= 3 then
				helper_bc77b237(30)
			end
			if at <= 4 then
				helper_8e53ce0a(0)
			end
			if at <= 5 then
				helper_585cedf7()
			end
			if at <= 6 then
				helper_8e53ce0a(6)
			end
			if at <= 7 then
				helper_bc77b237(60)
			end
			if at <= 8 then
				helper_bc77b237(60)
			end
			if at <= 9 then
				helper_19078(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_407b4453()
	if vm.skipping() then
		return skip(2)
	end
	helper_585cedf7()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_bc77b237(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_585cedf7()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_8e53ce0a(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_19078(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_200fc(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_195f0(arg0, arg1, arg2, arg3, 1, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_195f0(arg0, arg1, arg2, arg3, 1, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_195f0(arg0, arg1, arg2, arg3, 1, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Helper function.
local function helper_2eeac()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_bc77b237(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_14d60(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = helper_758669fc(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
		end
		return var2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_758669fc(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

--- Helper function.
local function helper_20bd0()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_bc77b237(30)
			end
			if at <= 2 then
				helper_bc77b237(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_14d60(5, 54)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(-839.6, 49.25, -439.32)
		event.CmrsSetRef(-953.56, 30.0, -547.13)
		event.EohSetFootSoundId(0, 2)
		event.ObjsSetPos(0, -1064.31, 0.0, -610.92)
		event.ObjsSetRot(0, 0.0, -2.14, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsMove(0, -1180.4, -72.61, -684.29, 50)
		helper_bc77b237(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_bc77b237(30)
		if vm.skipping() then
			return skip(3)
		end
		event.EohSetFootSoundId(0, 0)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(0.92)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(0.92)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30, 1)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(4)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_225b4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a255005b(0, -1, 5, 256, 208)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + var2)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, var3, var4, var5, 30, 1)
	event.ObjsReference(0, var3, var4, var5, 10)
	event.ObjsSetMotion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var6 = var6 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.ObjsSetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	flag = event.GetFlag(304) or flag
	if flag == 0 then
		event.MesMake_2(0, "There may be someone at that last\nhouse. Let's go check.")
	else
		event.MesMake_2(0, "We don't have time for this.\nWe gotta hurry and help Lin!")
	end
	helper_a255005b(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_21674()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var0 = helper_14d60(5, 58)
			end
			if at <= 2 then
				helper_bc77b237(30)
			end
			if at <= 3 then
				helper_bc77b237(30)
			end
			return 1
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_14d60(5, 58)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(2745.73, 115.67, 336.92)
		event.CmrsSetRef(2562.52, 160.38, 739.42)
		event.ObjsSetPos(0, 2625.24, 0.0, 792.83)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, 2625.24, 0.0, 792.83)
		event.ObjsAddPas(0, 2608.8, 0.0, 896.1)
		event.ObjsAddPas(0, 2558.92, 0.0, 1062.37)
		event.ObjsAddPas(0, 2516.28, 0.0, 1156.04)
		event.ObjsStartPas(0, 1)
		helper_bc77b237(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetFadeOut(30)
		helper_bc77b237(30)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(0, "立ち", 4)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + var1)
		var5 = var2
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30, 1)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_2b584()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 28 then
			if at <= 1 then
				helper_407b4453()
			end
			if at <= 2 then
				helper_8e53ce0a(0)
			end
			if at <= 3 then
				helper_8e53ce0a(1)
			end
			if at <= 4 then
				helper_bc77b237(14)
			end
			if at <= 5 then
				helper_8e53ce0a(0)
			end
			if at <= 6 then
				helper_bc77b237(30)
			end
			if at <= 7 then
				helper_559461c9(3060270)
			end
			if at <= 8 then
				helper_8e53ce0a(1)
			end
			if at <= 9 then
				helper_8e53ce0a(0)
			end
			if at <= 10 then
				helper_bc77b237(20)
			end
			if at <= 11 then
				helper_559461c9(3060280)
			end
			if at <= 12 then
				helper_559461c9(3060285)
			end
			if at <= 13 then
				helper_559461c9(3060290)
			end
			if at <= 14 then
				helper_8e53ce0a(3)
			end
			if at <= 15 then
				helper_559461c9(3060300)
			end
			if at <= 16 then
				helper_8e53ce0a(0)
			end
			if at <= 17 then
				helper_559461c9(3060305)
			end
			if at <= 18 then
				helper_8e53ce0a(4)
			end
			if at <= 19 then
				helper_8e53ce0a(0)
			end
			if at <= 20 then
				helper_559461c9(3060310)
			end
			if at <= 21 then
				helper_8e53ce0a(0)
			end
			if at <= 22 then
				helper_559461c9(3060320)
			end
			if at <= 23 then
				helper_8e53ce0a(1)
			end
			if at <= 24 then
				helper_8e53ce0a(0)
			end
			if at <= 25 then
				helper_559461c9(3060330)
			end
			if at <= 26 then
				helper_8e53ce0a(0)
			end
			if at <= 27 then
				helper_bc77b237(30)
			end
			if vm.skip_end() then
				return skip(29)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 1994.4, 0.0, -247.1)
		event.SetCharaRot(0, 0.0, 0.65, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetCameraPos(-621.09, 400.73, 34.49)
	event.SetCameraRef(-487.13, 465.9, -23.46)
	event.SetFlag(306, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_bc77b237(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(2)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(3209) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e306/")
	event.LoadMes(0, 5, "e306_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e306_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e306_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	block = event.LoadImg_4(5, "e306b.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e30604", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e30605", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(3, 1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e30606", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(4, 2)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e306/e306_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e300/e306/e306_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 265.0, 0.0, -73.0)
	event.EohSetRot(0, 0.0, 1.57, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 1)
	event.EohSetPos(1, 270.0, 0.0, -35.0)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 1)
	event.ObjsMove(0, 536.0, 0.0, -76.0, 240)
	event.ObjsMove(1, 507.0, 0.0, -48.0, 240)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-621.09, 400.73, 34.49)
	event.CmrsSetRef(-487.13, 465.9, -23.46)
	event.CmrsMove2(-621.09, 166.82, 34.49, -487.13, 143.67, -23.46, 120, 2, 1.0)
	event.SetFadeIn(30)
	helper_407b4453()
	if vm.skipping() then
		return skip(2)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(2117.25, 46.58, -164.96)
	event.CmrsSetRef(2180.0, 22.74, -75.0)
	event.ObjsSetPos(1, 2136.0, 0.0, -151.18)
	event.ObjsSetRot(1, 0.0, 0.61, 0.0)
	event.ObjsMove(1, 2180.57, 0.0, -93.18, 60)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_bc77b237(14)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(0, 2125.64, 0.0, -140.88)
	event.ObjsSetRot(0, 0.0, 0.61, 0.0)
	event.ObjsMove(0, 2164.86, 0.0, -77.4, 60)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(2176.34, 42.48, -21.97)
	event.CmrsSetRef(2165.23, -0.03, -107.71)
	event.ObjsSetPos(0, 2161.96, 0.0, -70.15)
	event.ObjsSetRot(0, 0.0, 2.65, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -0.95, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060270)
	if vm.skipping() then
		return skip(8)
	end
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 13)
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(10)
	end
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(2244.92, 62.5, -22.07)
	event.CmrsSetRef(2112.09, 19.05, -129.53)
	event.ObjsSetRot(0, 0.0, -2.19, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -2.27, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060280)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(2121.12, 117.35, -94.66)
	event.CmrsSetRef(2199.27, 126.12, -73.41)
	event.SpriteSetDraw(0, 2)
	event.SpriteSetDraw(1, 2)
	event.SpriteSetDraw(2, 2)
	event.ObjsSetColor(2, 128, 128, 128, 128)
	event.ObjsSetPos(0, 2161.96, 100.0, -70.15)
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060285)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "だめだ", 6)
	event.ObjsNextMotion(0, "だめだL", 4)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060290)
	if vm.skipping() then
		return skip(14)
	end
	helper_8e53ce0a(3)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060300)
	if vm.skipping() then
		return skip(16)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(0, "やった", 6)
	event.ObjsNextMotion(0, "やったL", 4)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060305)
	if vm.skipping() then
		return skip(18)
	end
	helper_8e53ce0a(4)
	if vm.skipping() then
		return skip(19)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(20)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.CmrsSetPos(2211.31, 15.69, -35.88)
	event.CmrsSetRef(2160.03, 14.35, -94.15)
	event.ObjsSetPos(0, 2161.96, 0.0, -70.15)
	event.ObjsSetRot(0, 0.0, 0.97, 0.0)
	event.ObjsSetMotion(0, "うーん", 6, -1.0, 1)
	event.ObjsNextMotion(0, "うーんL", 4)
	event.ObjsSetRot(1, 0.0, 0.89, 0.0)
	event.ObjsSetMotion(1, "右向くL", 4, -1.0, 1)
	event.ObjsSeDelay(1, 1)
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(0, "通常口パク")
	helper_559461c9(3060310)
	if vm.skipping() then
		return skip(21)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(1, "右向く会話", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "うーん戻り", 2)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_559461c9(3060320)
	if vm.skipping() then
		return skip(23)
	end
	helper_8e53ce0a(1)
	if vm.skipping() then
		return skip(24)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(0, "左向くうなづき", 2)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 13)
	event.SetPakuAnim(0, "通常口パク")
	helper_559461c9(3060330)
	if vm.skipping() then
		return skip(26)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(27)
	end
	event.SetFadeOut(30)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(28)
	end
	return part2()
end

--- Helper function.
local function helper_becc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	if arg1 == 4 then
		event.MesMake_2(arg0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Hey, how ya doin'? I'm doin' great!")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "I pray for your safety...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "You really like all this\nadventure, don't ya.")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Just on a personal note here, I\nknow Zelmite Mine is a dangerous\nplace. Don't do anything foolish."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "I pray that the world will\nfrom today forever be at peace.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"If the Blackstone Railroad goes all\nover the world, we'll be able to\nvisit lots of cool new places."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"I just wish that Fabio would have\na bit of an interest in something\noutside of fishing, too."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"If the Blackstone Railroad spreads\nall around the world, maybe I'll\nhave to go around the world too."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"You can't fool me. I know you've\nbeen off doing all sorts of fun\nstuff. Tell me about it sometime!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
		)
	end
end

--- Helper function.
local function helper_23e5c(arg0: s32, arg1: s32, sp: number)
	local junk = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dcb58cd3(var4, -1, 0, 0, sp + junk + 8)
			junk += 3
		end
		helper_becc(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"I'm livin' here now,\nbut I'm more worried\nabout Blackstone One.<page>I'm the one who'll be\nkeepin' the train runnin',\njust like old times."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_dcb58cd3(var4, -1, 0, 0, sp + junk + 5)
				if vm.skipping() then
					return skip(2)
				end
				event.MesMake_2(
					arg0,
					"Borneo's a bit heavy-handed,\nand Erik's just a kid.<page>Nothing but home, work,\nhome and work again every\nday for the likes of me.<page>But that's life, eh..."
				)
			else
				event.MesMake_2(arg0, "How's Steve doin'?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "I can't handle just sitting in my\nroom, twiddlin' my thumbs.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Plants and flowers only grow as\nwell as you look after them. I\ncould never neglect my babies."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Wonder if the secret base is okay.\nI wish I could ask someone to check\nit out, but it's a secret, you know?"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Purple's a great colour.\nIt's got a warm kinda coolness,\nand a bright kinda darkness."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "If someone's sick\nI'll go anywhere to help.")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "Only a top chef can \nmake delicious food \neverywhere he goes.")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "When it comes to houses, the\nsturdier the better, right?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"Nuts are pretty good, but those red\nthings were simply scrumptious.\nThink you could bring me some more?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"Damp air is a book's worst enemy.\nI don't think I could ever tolerate\nliving near water."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(arg0, "They're not cute or trendy, but I\nmake clothes that no one else in\nthe world can.")
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "A new place, a new me.\nI feel like a young baker again.")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "I don't care what,\nI just wanna smash something\ninto millions of tiny pieces!")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "If you discover a new monster,\nbe sure to report it right away.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Some say it's not for women,\nbut the sword does not care who\nholds it. May the best fighter win."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "This little house might not be a\nbad place to raise a family.")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "I wonder if Morton's staying on the\nball. He has me a bit worried...")
		end
		if arg1 == 18 then
			event.MesMake_2(arg0, "If you know of a town in need of a\nchurch, I'm your priest. Just let\nme know.")
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"I haven't been thinking about the\nmoon much lately anymore. It must\nbe because of all my new friends."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(
				arg0,
				"Different place, different fish.\nYou have to change your thinking\nto match the territory."
			)
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "This water looks perfect for fish.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn's started on another picture\nof a woman. Says this time she'll\nbe prettier than even me."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "I wonder why insects look\nso revolting...")
		end
		if arg1 == 24 then
			event.MesMake_2(arg0, "Can you make my house any cuter?\nA house can never be too cute,\nyou know!")
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "I never imagined I'd be\nmoving at this age.")
		end
	else
		helper_becc(arg0, arg1)
	end
end

--- Helper function.
local function helper_253a8(sp: number)
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dcb58cd3(var1, -1, 0, 0, sp + 3)
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hello there.\nGreat weather, isn't it.")
	helper_23e5c(0, var2, sp + 3)
	if vm.skipping() then
		return skip(1)
	end
	helper_dcb58cd3(var1, -1, 0, 0, sp + 3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_256ac()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_f8aba7e6(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	helper_f8aba7e6(1)
	event.Finish()
end

--- Helper function.
local function helper_25858(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bc77b237(30)
		end
		helper_256ac()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	helper_256ac()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e484(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_a255005b(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_06423b6b(arg0, 1)
			helper_9d160cf5(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_a255005b(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_06423b6b(arg0, 1)
		event.MesMake_2(arg0, "If you don't bring me more scoops,\nI can't give ya nothin'!")
		if now_map_no == 22 then
			helper_9d160cf5(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_a255005b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_06423b6b(arg0, 1)
		event.MesMake_2(
			arg0,
			"Your Photography level's determined\nby the number of ideas and scoops\nyou have.<page>And as your level goes up, you get\nmore cool items as rewards."
		)
		if now_map_no == 22 then
			helper_9d160cf5(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_a255005b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_eacc(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_a255005b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_a255005b(arg0, -1, 3, 256, 208)
			end
			return helper_e484(arg0)
		end
		if at <= 5 then
			helper_06423b6b(arg0, 1)
			helper_9d160cf5(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_a255005b(arg0, -1, 3, 256, 208)
		end
		return helper_e484(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_06423b6b(arg0, 1)
		event.MesMake_2(arg0, "Go get me a\nScoop Memo, will ya?")
		if now_map_no == 22 then
			helper_9d160cf5(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_a255005b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_06423b6b(arg0, 1)
		event.MesMake_2(arg0, "Looks like there's\nno more scoops to be had.")
		if now_map_no == 22 then
			helper_9d160cf5(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_a255005b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_e484(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_06423b6b(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "I figured out [Number1] more scoops.")
		event.SetMesDrawspeed(arg0, 0)
		helper_a255005b(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_06423b6b(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
	end
	if now_map_no == 22 then
		helper_9d160cf5(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_a255005b(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_e484(arg0)
end

--- Helper function.
local function helper_d1b4()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Great job! Humans\naren't so bad after all!<page>I was wrong!")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"This is it. It's almost over.\nAll we have to do is defeat him.<page>And after that, the world can live again."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"I guess I know how Griffon feels, but I don't\nthink I could ever forgive him for what he did."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Return the garden to its former state, and\nexpose the secret of Griffon, I mean, Sirus.")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"I wonder what she means, \"Sirus' memories.\"\nI guess we'll have to enter the palace to find out."
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Griffon'll get away if we just stand around like\nthis. Let's get to the Moon Flower Palace, quick."
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Looks like we got all the gems. Now we\njust have to hurry to Kazarov Stonehenge.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Whatever it is, we better find the gems\nquick, before it's too late.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Everything started at this palace, huh.\nAnyway, let's head into the garden.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "We better head back to Luna Lab soon.\nThey may be finished with Ixion already.")
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "It's about time to strike back against\nGriffon. Let's head over to the Paznos base.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Remember? Galen Agaris said that if you\nplay the Fire Horn the road will open up.")
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Gotta blow that Firesquall to bits.<page>So it's up there on top of Mt. Gundor, huh?")
		return
	end
	event.MesMake_2(
		3,
		"Just waiting here won't change anything.<page>There's got to be some places we haven't been to yet."
	)
end

--- Helper function.
local function helper_25974(sp: number)
	local junk = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var4 = 0
				var4 = 20
				var4 = 24
				var4 = 28
				var4 = 32
				var4 = 40
				var4 = 44
				var4 = 48
				var4 = 52
				var4 = 56
				var23 = vm.f32(vm.sin(var18) * 30.0)
				var23 = vm.f32(var23 + var5)
				var24 = vm.f32(var6 + 33.0)
				var25 = vm.f32(vm.cos(var18) * 30.0)
				var25 = vm.f32(var25 + var7)
				var26 = var5
				var27 = vm.f32(var6 + 30.0)
				var28 = var7
				junk += 25
			end
			if at <= 2 then
				var29 = 0
				helper_06423b6b(3, 1)
				helper_23e5c(3, var2, sp + junk + 34)
				junk += 1
			end
			if at <= 3 then
				var30 = -1
				helper_06423b6b(1, 8)
				helper_0ec08062(1, 1, 1, 0, 0)
				helper_06423b6b(2, 2)
				var30 = 30
				var30 = 31
				var30 = 32
				var29 = helper_758669fc(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
				junk += 3
			end
			helper_256ac()
			return
		end
		if at <= 6 then
			helper_256ac()
			return
		end
		if at <= 11 then
			if at <= 7 then
				helper_06423b6b(3, 8)
				helper_a255005b(3, var30, 9, 0, 0)
				junk += 1
			end
			if at <= 8 then
				helper_a255005b(3, -1, 3, 256, 208)
				junk += 4
			end
			if at <= 9 then
				helper_256ac()
				helper_25858(6)
				junk += 1
			end
			if at <= 10 then
				helper_25858(23)
				junk += 2
			end
			return
		end
		if at <= 13 then
			if at <= 12 then
				helper_25858(33)
			end
			return
		end
		if at <= 14 then
			helper_25858(1)
			junk += 1
		end
		if at <= 15 then
			helper_25858(2)
			junk += 1
		end
		if at <= 16 then
			helper_25858(3)
			junk += 1
		end
		if at <= 17 then
			helper_25858(7)
			junk += 1
		end
		if at <= 18 then
			helper_25858(8)
			junk += 1
		end
		if at <= 19 then
			helper_25858(9)
			junk += 1
		end
		if at <= 20 then
			helper_25858(10)
			junk += 1
		end
		if at <= 21 then
			helper_25858(11)
			junk += 1
		end
		if at <= 22 then
			helper_25858(12)
			junk += 1
		end
		if at <= 23 then
			helper_25858(13)
			junk += 1
		end
		if at <= 24 then
			helper_25858(14)
			junk += 1
		end
		if at <= 25 then
			helper_25858(15)
			junk += 1
		end
		if at <= 26 then
			helper_25858(16)
			junk += 1
		end
		if at <= 27 then
			helper_25858(17)
			junk += 1
		end
		if at <= 28 then
			helper_25858(18)
			junk += 1
		end
		if at <= 29 then
			helper_25858(19)
			junk += 1
		end
		if at <= 30 then
			helper_25858(20)
			junk += 1
		end
		if at <= 31 then
			helper_25858(21)
			junk += 1
		end
		if at <= 32 then
			helper_25858(22)
			junk += 1
		end
		if at <= 33 then
			helper_25858(32)
			junk += 1
		end
		if at <= 34 then
			helper_d1b4()
			helper_a255005b(3, -1, 3, 256, 208)
			junk += 1
		end
		if at <= 35 then
			helper_256ac()
			helper_bc77b237(30)
			junk += 1
		end
		helper_256ac()
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetMotion(0, "立ち")
	event.SetMotion(var1, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.GetCharaPos(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.GetCharaRot(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.GetCharaRot(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.GetRotLookPos(var5 - var11, var7 - var13) or var17
	event.SetCharaRot(0, var14, var17, var16)
	var18 = event.GetRotLookPos(var11 - var5, var13 - var7) or var18
	event.SetCharaRot(var1, var8, var18, var10)
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.FuncPointGetPos("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.SetCameraPos(var20, var21, var22)
		event.SetCameraRef(var5, var6 + 30.0, var7)
		var18 = event.GetRotLookPos(var20 - var5, var22 - var7) or var18
		event.SetCharaRot(var1, var8, var18, var10)
	else
		var23 = vm.f32(vm.sin(var18) * 30.0)
		var23 = vm.f32(var23 + var5)
		var24 = vm.f32(var6 + 33.0)
		var25 = vm.f32(vm.cos(var18) * 30.0)
		var25 = vm.f32(var25 + var7)
		event.SetCameraPos(var23, var24, var25)
		var26 = var5
		var27 = vm.f32(var6 + 30.0)
		var28 = var7
		event.SetCameraRef(var26, var27, var28)
	end
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_06423b6b(3, 1)
		helper_23e5c(3, var2, sp + junk + 33)
		if vm.skipping() then
			return skip(3)
		end
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_06423b6b(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_0ec08062(1, 1, 1, 0, 0)
		helper_06423b6b(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.SetMesItemDirect(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.SetMesItemDirect(2, 1, var30)
			event.SetMesItemDirect(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_758669fc(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if vm.skipping() then
			return skip(4)
		end
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_256ac()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_bc77b237(30)
				if vm.skipping() then
					return skip(5)
				end
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(6)
				end
				helper_256ac()
				event.SetFadeIn(30)
				return
			end
			helper_06423b6b(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]You can't do that right now. You have\nto bring Lin to the lighthouse first!")
			helper_a255005b(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_06423b6b(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_a255005b(3, var30, 9, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Alright, we're finished\nwith repairs!")
						helper_a255005b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(9)
						end
						helper_256ac()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_25858(6)
					if vm.skipping() then
						return skip(10)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_25858(23)
						if vm.skipping() then
							return skip(11)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_eacc(3)
						if vm.skipping() then
							junk += 1
							return skip(12)
						end
						if t0 ~= 0 then
							helper_25858(33)
							if vm.skipping() then
								return skip(13)
							end
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_25858(0)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 12 then
						helper_25858(1)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 6 then
						helper_25858(2)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 7 then
						helper_25858(3)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 2 then
						helper_25858(7)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 3 then
						helper_25858(8)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 5 then
						helper_25858(9)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 8 then
						helper_25858(10)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 10 then
						helper_25858(11)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 11 then
						helper_25858(12)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 13 then
						helper_25858(13)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 16 then
						helper_25858(14)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 18 then
						helper_25858(15)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 19 then
						helper_25858(16)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 20 then
						helper_25858(17)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 21 then
						helper_25858(18)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 22 then
						helper_25858(19)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 23 then
						helper_25858(20)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 24 then
						helper_25858(21)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 25 then
						helper_25858(22)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 17 then
						helper_25858(32)
						if vm.skipping() then
							return skip(34)
						end
					end
					if var2 == 9 then
						helper_d1b4()
						helper_a255005b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(35)
						end
						helper_256ac()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_bc77b237(30)
						if vm.skipping() then
							return skip(36)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(37)
						end
						helper_256ac()
						event.SetFadeIn(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_256ac()
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_cac435d9

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local old_sub_map_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_28970()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_0aad4720()
		end
		if at <= 3 then
			program_210()
			program_210()
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			print("--- OLD SUBMAP NO = ", old_sub_map_no, "\n")
			helper_7d17ed71(1)
		end
	end
	function part2()
		helper_7d17ed71(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	function landing1()
		return part2()
	end
	helper_cac435d9()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, 1989.0, 0.0, -198.0)
		event.SetCharaRot(0, 0.0, -1.21, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if var2 == 7 or var2 == 8 then
				helper_a9038fed()
				if vm.skipping() then
					return skip(1)
				end
			elseif old_map_no == 26 then
				event.SetCameraPos(-741.9, 50.0, -592.0)
				event.SetCameraRef(-741.9, 30.0, -712.0)
				event.SetCharaPos(0, -741.9, 0.0, -712.0)
				event.SetCharaRot(0, 0.0, 0.0, 0.0)
				event.SetFadeIn(30)
			else
				flag = event.GetFlag(300) or flag
				flag_2 = event.GetFlag(302) or flag_2
				if flag == 1 and flag_2 == 0 then
					helper_28970()
					if vm.skipping() then
						return skip(2)
					end
				else
					helper_0aad4720()
					if vm.skipping() then
						return skip(3)
					end
				end
			end
		else
			old_sub_map_no = event.GetOldSubmapNo() or old_sub_map_no
			if old_sub_map_no == 100 then
				program_210()
			end
			if old_sub_map_no == -1 then
				program_210()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			print("--- OLD SUBMAP NO = ", old_sub_map_no, "\n")
		end
	end
	return part2()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local now_party_chara_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("--- MAP_JUMP(g02i02) ---\n")
			return
		end
		print("--- GOTO_INTERIOR(g02i02) ---\n")
	end
	event.Initialize()
	flag = event.GetFlag(300) or flag
	flag_2 = event.GetFlag(304) or flag_2
	flag_3 = event.GetFlag(306) or flag_3
	flag_4 = event.GetFlag(324) or flag_4
	flag_5 = event.GetFlag(328) or flag_5
	flag_6 = event.GetFlag(330) or flag_6
	if flag == 1 then
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if
			flag_2 == 0
			or flag_3 == 0 and now_party_chara_id == 6
			or flag_4 == 1 and flag_5 == 0
			or flag_4 == 1 and flag_6 == 0
		then
			if not (flag_4 == 1 and flag_5 == 0) then
				event.BgmLoadCancel()
			end
			event.MapJump(-1, "g02i02", 100)
			if vm.wait() then
				return skip(1)
			end
			print("--- MAP_JUMP(g02i02) ---\n")
			return
		end
	end
	event.GotoInterior(-1, "g02i02", 100)
	if vm.wait() then
		return skip(2)
	end
	print("--- GOTO_INTERIOR(g02i02) ---\n")
end

script[210] = program_210

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_200fc(vm.f32(-743.2), 0.0, vm.f32(-708.9), vm.f32(-0.64))
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "f02")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7d17ed71(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eeac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_20bd0()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s04")
	end
end

--- Program 501.
script[501] = function()
	local flag: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_21674()
		end
		if at <= 3 then
			helper_a9038fed()
		end
	end
	flag = event.GetFlag(306) or flag
	if flag == 0 then
		helper_225b4()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_21674()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.DngSetStageId(2)
			event.GotoMenu(3, 2)
			if vm.wait() then
				return skip(3)
			end
			do
				local _, _, out3, _ = event.GetMenuParam_4()
				var3 = out3 or var3
			end
			if var3 == 0 then
				helper_a9038fed()
				if vm.skipping() then
					return skip(4)
				end
			else
				flag_2 = event.GetFlag(307) or flag_2
				flag_3 = event.GetFlag(344) or flag_3
				if var3 == 2 and flag_2 == 0 or var3 == 21 and flag_3 == 0 or var3 == 22 then
					event.BgmLoadCancel()
				end
				event.GotoDng(2, var3, 1010)
			end
		end
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cac435d9()
	helper_58610e3d()
	helper_7d17ed71(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cac435d9()
	helper_2b584()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_25974(sp + 0)
		end
	end
	helper_253a8(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	helper_25974(sp + 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 13020.
script[13020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_28970()
	if vm.skipping() then
		return skip(1)
	end
end

return script
