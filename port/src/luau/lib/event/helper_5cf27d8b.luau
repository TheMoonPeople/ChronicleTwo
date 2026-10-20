--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_43b6fee5 = require("@lib/event/helper_43b6fee5")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_b12589d2 = require("@lib/event/helper_b12589d2")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_5cf27d8b()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 30 then
			if at <= 1 then
				var0 = 8
				helper_2f481f12(4)
			end
			if at <= 2 then
				helper_2f481f12(10)
			end
			if at <= 3 then
				helper_e8f4b85c(1)
			end
			if at <= 4 then
				helper_2f481f12(10)
			end
			if at <= 5 then
				helper_93bb7fa4(4340010)
			end
			if at <= 6 then
				helper_93bb7fa4(4340015)
			end
			if at <= 7 then
				helper_b027b809()
			end
			if at <= 8 then
				helper_93bb7fa4(4340020)
			end
			if at <= 9 then
				helper_e8f4b85c(0)
			end
			if at <= 10 then
				helper_93bb7fa4(4340030)
			end
			if at <= 11 then
				helper_93bb7fa4(4340040)
			end
			if at <= 12 then
				helper_e8f4b85c(0)
			end
			if at <= 13 then
				helper_93bb7fa4(4340045)
			end
			if at <= 14 then
				helper_93bb7fa4(4340050)
			end
			if at <= 15 then
				helper_93bb7fa4(4340060)
			end
			if at <= 16 then
				helper_93bb7fa4(4340070)
			end
			if at <= 17 then
				helper_e8f4b85c(2)
			end
			if at <= 18 then
				helper_e8f4b85c(2)
			end
			if at <= 19 then
				helper_93bb7fa4(4340075)
			end
			if at <= 20 then
				helper_2f481f12(50)
			end
			if at <= 21 then
				helper_e8f4b85c(2)
			end
			if at <= 22 then
				helper_2f481f12(30)
			end
			if at <= 23 then
				helper_b12589d2(375, 1)
			end
			if at <= 24 then
				helper_2f481f12(4)
			end
			if at <= 25 then
				helper_93bb7fa4(4340080)
			end
			if at <= 26 then
				helper_93bb7fa4(4340090)
			end
			if at <= 27 then
				helper_93bb7fa4(4340100)
			end
			if at <= 28 then
				helper_93bb7fa4(4340110)
			end
			if at <= 29 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(31)
			end
			return part2()
		end
		if at <= 32 then
			helper_43b6fee5(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.CmrsInit()
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.LoadMes(0, -1)
		if active_chr_no == 0 then
			event.ObjsSetPos(0, 0.0, 0.0, 180.0)
		else
			event.ObjsSetPos(1, 0.0, 0.0, 180.0)
		end
		event.CmrsSetPos(0.0, 30.0, 280.0)
		event.CmrsSetRef(0.0, 30.0, 180.0)
		if vm.wait() then
			return skip(32)
		end
		helper_43b6fee5(0)
		if vm.skipping() then
			return skip(33)
		end
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetMotion(0, "立ち")
	event.SetFadeOut(15)
	helper_2f481f12(15)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(434, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = 8
	do
		local out1, out2, out3 = event.GetCharaPos(var0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local _, out2, _ = event.GetCharaRot(var0)
		var5 = out2 or var5
	end
	event.SetWorldCoord(var1, var2, var3, var5)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	var8 = event.GetBgmNo() or var8
	if var8 ~= 3 then
		event.StopBgm(0)
		helper_2f481f12(4)
		if vm.skipping() then
			return skip(2)
		end
		event.LoadBgm(3)
		event.PlayBgm(0)
	end
	event.LoadSound(4817)
	var9 = event.SndLoadSound(4817) or var9
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e434/")
	event.LoadMes(0, 5, "e434_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e434_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e434_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.EohSyncChara(2, 8)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e434_honyaku_y.gltf", "info", 18)
	event.CharaActive(18)
	event.LoadChara(5, "e434_honyaku_m.gltf", "info", 19)
	event.CharaActive(19)
	event.LoadChara(5, "e434_hiyaku.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 16)
		event.LoadEquip(5, 0, 4, "info", 16)
		event.LoadEquip(5, 0, 3, "info", 16)
		event.LoadEquip(5, 0, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e434/e434_mints.gltf", "info", 16)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 16)
		event.EohSyncChara(0, 16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 16)
		event.LoadEquip(5, 1, 4, "info", 16)
		event.LoadEquip(5, 1, 3, "info", 16)
		event.LoadEquip(5, 1, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e434/e434_monica.gltf", "info", 16)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 16)
		event.EohSyncChara(1, 16)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(16)
	event.CharaActive(17)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetShow(3, 0)
	event.EohSetShow(4, 0)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 18)
		event.SetReference(0, "item", 20)
		event.SetReference(16, "item", 19)
	else
		event.SetReference(0, "item", 19)
		event.SetReference(16, "item", 18)
		event.SetReference(16, "item", 20)
	end
	event.EohSetPos(0, 8.0, 0.0, 310.0)
	event.EohSetRot(0, 0.0, -2.9, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -8.0, 0.0, 310.0)
	event.EohSetRot(1, 0.0, 2.9, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetMotion(2, "立ち（下見）", 4)
	event.ObjsSetMotion(0, "耳に当てる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "耳に当てるL", 4)
	event.ObjsSetMotion(1, "耳に当てる", 6, -1.0, 1)
	event.ObjsNextMotion(1, "耳に当てるL", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 22.0, 360.0)
	event.CmrsSetRef(0.0, 22.0, 236.0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var9, 0)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsMove2(0.0, 130.0, 700.0, 0.0, 130.0, 100.0, 60, 0, 1.0)
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_93bb7fa4(4340010)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_93bb7fa4(4340015)
	if vm.skipping() then
		return skip(7)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(0.0, 51.02, 278.53)
	event.CmrsSetRef(0.0, 17.44, 308.64)
	event.ObjsSetMotion(0, "耳に当てる会話", 6)
	event.ObjsNextMotion(0, "耳に当てるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4340020)
	if vm.skipping() then
		return skip(9)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(136.58, 282.08, 250.29)
	event.CmrsSetRef(103.01, 274.65, 222.02)
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_93bb7fa4(4340030)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(532.81, 223.49, 220.44)
	event.CmrsSetRef(84.67, 164.89, 164.57)
	event.ObjsSetMotion(0, "耳に当てる会話", 6)
	event.ObjsNextMotion(0, "耳に当てるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4340040)
	if vm.skipping() then
		return skip(12)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4340045)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(136.58, 282.08, 250.29)
	event.CmrsSetRef(103.01, 274.65, 222.02)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_93bb7fa4(4340050)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(0.0, 51.02, 278.53)
	event.CmrsSetRef(0.0, 17.44, 308.64)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4340060)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(136.58, 282.08, 250.29)
	event.CmrsSetRef(103.01, 274.65, 222.02)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "首ふる", 6)
	event.ObjsNextMotion(2, "首ふるL", 4)
	helper_93bb7fa4(4340070)
	if vm.skipping() then
		return skip(17)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsNextMotion(2, "首ふる戻り", 6)
	event.ObjsNextMotion(2, "会話入り", 4)
	event.ObjsNextMotion(2, "立ち（下見）", 4)
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_93bb7fa4(4340075)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "会話戻り", 2)
	event.ObjsNextMotion(2, "首後ろにやる", 2)
	event.ObjsMotionWait(2)
	helper_2f481f12(50)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var9, 1)
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(63.79, 24.14, 233.74)
	event.CmrsSetRef(6.92, 16.71, 285.79)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaActive(20)
	event.CharaActive(0, 19)
	event.CharaActive(0, 18)
	event.SndSePlay(var9, 2)
	event.ObjsSetMotion(2, "竜の秘薬を渡す2", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "竜の秘薬ゲット", 4, -1.0, 1)
	event.ObjsSetMotion(1, "秘薬見る", 4, -1.0, 1)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(23)
	end
	helper_b12589d2(375, 1)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(258.67, 378.76, -28.84)
	event.CmrsSetRef(79.78, 245.69, 90.44)
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.ObjsSetMotion(0, "上見る", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_2f481f12(4)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_93bb7fa4(4340080)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_93bb7fa4(4340090)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4340100)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "モニカ見る", 6)
	event.ObjsNextMotion(0, "モニカ見うなづく", 6)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93bb7fa4(4340110)
	if vm.skipping() then
		return skip(29)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(30)
	end
	return part2()
end

return helper_5cf27d8b
