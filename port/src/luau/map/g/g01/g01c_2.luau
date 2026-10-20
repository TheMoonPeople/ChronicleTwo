--!strict
-- map/g/g01/g01c_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0679f808 = require("@lib/event/helper_0679f808")
local helper_7ca74f30 = require("@lib/event/helper_7ca74f30")
local helper_ba76842a = require("@lib/event/helper_ba76842a")
local helper_c61bc42d = require("@lib/event/helper_c61bc42d")
local helper_fde5e965 = require("@lib/event/helper_fde5e965")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_e6d0()
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
		event.LoadChara(5, "chara/c01_event.gltf", "info", global0)
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
	block = event.LoadImg_4(5, "textures/event/e200/e250/e250_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e25002", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadMes(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_e3a4()
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
local function helper_f628()
	local var1: s32 = 0
	local flag: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 38 then
			if at <= 2 then
				helper_ba76842a(4)
			end
			if at <= 3 then
				print("e250 change bgm-------------------\n")
				helper_e6d0()
			end
			if at <= 4 then
				helper_c61bc42d(2500500)
			end
			if at <= 5 then
				helper_c61bc42d(2500510)
			end
			if at <= 6 then
				helper_fde5e965(1)
			end
			if at <= 7 then
				helper_c61bc42d(2500520)
			end
			if at <= 8 then
				helper_c61bc42d(2500523)
			end
			if at <= 9 then
				helper_c61bc42d(2500525)
			end
			if at <= 10 then
				helper_7ca74f30()
			end
			if at <= 11 then
				helper_c61bc42d(2500530)
			end
			if at <= 12 then
				helper_c61bc42d(2500540)
			end
			if at <= 13 then
				helper_c61bc42d(2500545)
			end
			if at <= 14 then
				helper_c61bc42d(2500550)
			end
			if at <= 15 then
				helper_c61bc42d(2500555)
			end
			if at <= 16 then
				helper_c61bc42d(2500560)
			end
			if at <= 17 then
				helper_c61bc42d(2500570)
			end
			if at <= 18 then
				helper_c61bc42d(2500580)
			end
			if at <= 19 then
				helper_ba76842a(27)
			end
			if at <= 20 then
				helper_c61bc42d(2500590)
			end
			if at <= 21 then
				helper_c61bc42d(2500595)
			end
			if at <= 22 then
				helper_c61bc42d(2500600)
			end
			if at <= 23 then
				helper_c61bc42d(2500610)
			end
			if at <= 24 then
				helper_c61bc42d(2500620)
			end
			if at <= 25 then
				helper_c61bc42d(2500630)
			end
			if at <= 26 then
				helper_c61bc42d(2500640)
			end
			if at <= 27 then
				helper_fde5e965(0)
			end
			if at <= 28 then
				helper_ba76842a(30)
			end
			if at <= 29 then
				helper_ba76842a(30)
			end
			if at <= 30 then
				helper_c61bc42d(2500650)
			end
			if at <= 31 then
				helper_c61bc42d(2500655)
			end
			if at <= 32 then
				helper_ba76842a(15)
			end
			if at <= 33 then
				helper_c61bc42d(2500660)
			end
			if at <= 34 then
				helper_0679f808(0, -1, 8, 0, 0)
			end
			if at <= 35 then
				helper_0679f808(0, -1, 8, 0, 0)
			end
			if at <= 36 then
				helper_0679f808(0, -1, 8, 0, 0)
			end
			if at <= 37 then
				helper_ba76842a(30)
			end
			if vm.skip_end() then
				return skip(39)
			end
			return part2()
		end
		if at <= 39 then
			helper_ba76842a(4)
		end
		helper_e3a4()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_ba76842a(4)
		if vm.skipping() then
			return skip(40)
		end
		event.LoadBgm(1)
		event.PlayBgm(0)
		event.CharaActive(1, 120)
		event.CharaActive(1, 121)
		helper_e3a4()
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFlag(250, 1)
	event.Initialize()
	event.LoadSound(2234)
	var1 = event.SndLoadSound(2234) or var1
	flag = event.GetFlag(43) or flag
	if flag ~= 0 then
		event.StopBgm(0)
		helper_ba76842a(4)
		if vm.skipping() then
			return skip(3)
		end
		event.LoadBgm(22)
		event.PlayBgm(0)
		event.SetFlag(43, 0)
		print("e250 change bgm-------------------\n")
	end
	helper_e6d0()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, 120)
	event.CharaActive(1, 121)
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.SetCharaPos(global0, var3, var4, var5)
	event.SetCharaPos(global1, var3, var4, var5)
	event.CmrsSetPos(-663.41, 22.05, -973.57)
	event.CmrsSetRef(-664.94, 26.2, -1002.99)
	event.ObjsSetPos(0, -639.63, -0.03, -1057.59)
	event.ObjsSetRot(0, 0.0, -2.71, 0.0)
	event.ObjsSetPos(1, -646.9, -0.0, -1083.44)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(4)
	end
	event.SetFadeIn(30)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500500)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_c61bc42d(2500510)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_fde5e965(1)
	if vm.skipping() then
		return skip(7)
	end
	event.CharaActive(0, global1)
	event.CmrsSetPos(-701.14, 38.12, -985.84)
	event.CmrsSetRef(-699.63, 28.19, -1037.85)
	event.CmrsMove2(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500520)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500523)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500525)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_7ca74f30()
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(1, global1)
	event.CharaActive(0, 120)
	event.CharaActive(0, 121)
	event.CmrsSetPos(-676.6, 19.02, -1089.83)
	event.CmrsSetRef(-659.95, 20.37, -1081.54)
	event.ObjsSetRot(0, 0.0, -2.59, 0.0)
	event.ObjsSetRot(1, 0.0, -1.44, 0.0)
	event.ObjsSetMotion(1, "左向くL", 4, -1.0, 1)
	event.CharaDaEnable(global0, 0)
	event.ObjsSetMotion(0, "アトラを持つ", 6)
	event.ObjsNextMotion(0, "アトラを持つL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c61bc42d(2500530)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500540)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向き立ちからアトラ", 6)
	event.ObjsNextMotion(1, "左向き立ちからアトラＬ", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500545)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(2, 128.0, 128.0, 128.0, 128.0, 10)
	helper_c61bc42d(2500550)
	if vm.skipping() then
		return skip(15)
	end
	helper_c61bc42d(2500555)
	if vm.skipping() then
		return skip(16)
	end
	helper_c61bc42d(2500560)
	if vm.skipping() then
		return skip(17)
	end
	event.SpriteSetDraw(0, 0)
	event.CharaActive(1, 120)
	event.CharaActive(1, 121)
	event.CharaDaEnable(global0, 1)
	event.CmrsSetPos(-765.64, 99.33, -1010.96)
	event.CmrsSetRef(-727.55, 75.53, -1041.04)
	event.ObjsSetRot(0, 0.0, -1.39, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c61bc42d(2500570)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "上→右見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c61bc42d(2500580)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 120)
	event.CharaActive(0, 121)
	event.CharaActive(0, global0)
	event.CmrsSetPos(-673.77, 22.39, -1079.75)
	event.CmrsSetRef(-649.49, 22.05, -1082.79)
	event.SndSePlay(var1, 23)
	event.ObjsSetMotion(1, "アトラ見る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "アトラ見るL", 0)
	helper_ba76842a(27)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500590)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500595)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "アトラ見から立ちに", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500600)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, global0)
	event.CharaActive(0, global1)
	if global0 == 0 then
		event.CharaActive(0, 37)
	end
	event.CmrsSetPos(-664.87, 45.8, -1032.95)
	event.CmrsSetRef(-649.78, 27.94, -1048.88)
	event.ObjsSetMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c61bc42d(2500610)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 120)
	event.CharaActive(1, 121)
	event.CharaActive(1, global1)
	if global0 == 0 then
		event.CharaActive(1, 37)
	end
	event.CmrsSetPos(-685.99, 21.17, -1117.78)
	event.CmrsSetRef(-668.5, 20.23, -1096.88)
	event.ObjsSetRot(0, 0.0, -2.59, 0.0)
	event.CmrsSetPos(-695.73, 21.17, -1136.67)
	event.CmrsSetRef(-685.84, 20.66, -1124.85)
	event.ObjsSetPos(0, -649.07, -0.03, -1073.1)
	event.ObjsSetRot(0, 0.0, -2.59, 0.0)
	event.ObjsSetPos(1, -657.42, -0.0, -1101.87)
	event.ObjsSetRot(1, 0.0, -1.8, 0.0)
	event.ObjsSetRot(1, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsRotation(1, 0.0, -1.92, 0.0, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500620)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500630)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.CharaDaEnable(global0, 0)
	event.SndSePlay(var1, 24)
	event.ObjsSetMotion(0, "アトラを持つ", 6)
	event.ObjsNextMotion(0, "アトラを持つL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c61bc42d(2500640)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	helper_fde5e965(0)
	if vm.skipping() then
		return skip(28)
	end
	helper_ba76842a(30)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsRotation(1, 0.0, 0.24, 0.0, 30)
	helper_ba76842a(30)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500650)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c61bc42d(2500655)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "アトラを持つ戻り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_ba76842a(15)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var1, 25)
	event.ObjsSetMotion(0, "うなづく", 6, -1.0, 1)
	event.ObjsNextMotion(0, " 立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c61bc42d(2500660)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Tu peux utiliser le Charpention.\n   Alors pourquoi ne pas essayer\n   de reconstruire Sindain ?"
	)
	helper_0679f808(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(35)
	end
	event.MesMake_2(
		0,
		"[(!)]Quand tu changes Sindain, cela\n   peut avoir un impact sur divers\n   [UNI00e9]l[UNI00e9]ments du monde.<page>Pour voir le monde tel qu'il sera dans\n100 ans, passe par la Porte temporelle."
	)
	helper_0679f808(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(36)
	end
	event.MesMake_2(
		0,
		"[(!)]Peut-[UNI00ea]tre rencontreras-tu des gens\n   encore inconnus ou d[UNI00e9]couvriras-tu des\n   [UNI00e9]v[UNI00e9]nements qui ne se sont pas d[UNI00e9]roul[UNI00e9]s.<page>Mais, chaque chose en son temps. Pour\nl'instant, il te faut ranimer Jurak."
	)
	helper_0679f808(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(37)
	end
	event.SetMesWindowMode(0, 7)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ba76842a(30)
	if vm.skipping() then
		return skip(38)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f628()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		if vm.wait() then
			return skip(3)
		end
		event.LoadScript("g01/g01_1.stb", -1)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	helper_f628()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
