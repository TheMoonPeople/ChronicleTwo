--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_119c2228 = require("@lib/event/helper_119c2228")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_4f735fdf = require("@lib/event/helper_4f735fdf")
local helper_548b5fe0 = require("@lib/event/helper_548b5fe0")
local helper_58c71c96 = require("@lib/event/helper_58c71c96")
local helper_5f2ad8dd = require("@lib/event/helper_5f2ad8dd")
local helper_6df4835c = require("@lib/event/helper_6df4835c")
local helper_b63800d2 = require("@lib/event/helper_b63800d2")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_c34a4dc9 = require("@lib/event/helper_c34a4dc9")
local helper_cc65be7b = require("@lib/event/helper_cc65be7b")
local helper_d974bf77 = require("@lib/event/helper_d974bf77")
local helper_d9e7376f = require("@lib/event/helper_d9e7376f")

--- Helper function.
local function helper_1f378ea6()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_d974bf77()
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_c1c32f84(90)
			end
			if at <= 3 then
				helper_c1c32f84(150)
			end
			if at <= 4 then
				helper_42c67f56(2020010)
			end
			if at <= 5 then
				helper_42c67f56(2020020)
			end
			if at <= 6 then
				helper_c1c32f84(15)
			end
			if at <= 7 then
				helper_42c67f56(2020030)
			end
			if at <= 8 then
				helper_c1c32f84(10)
			end
			if at <= 9 then
				helper_b63800d2(2200.0, 220)
				helper_c1c32f84(50)
			end
			if at <= 10 then
				helper_c1c32f84(70)
			end
			if at <= 11 then
				helper_c1c32f84(120)
			end
			if at <= 12 then
				helper_c1c32f84(60)
			end
			if at <= 13 then
				helper_c1c32f84(40)
			end
			if at <= 14 then
				pos_z = vm.f32(pos_z + vm.f32(-517.642))
				helper_c1c32f84(30)
			end
			if at <= 15 then
				helper_c1c32f84(30)
			end
			if at <= 16 then
				helper_c1c32f84(15)
			end
			if at <= 17 then
				helper_c1c32f84(75)
			end
			if at <= 18 then
				helper_42c67f56(2020040)
			end
			if at <= 19 then
				helper_2386f745(0)
			end
			if at <= 20 then
				helper_42c67f56(2020050)
			end
			if at <= 21 then
				helper_42c67f56(2020060)
			end
			if at <= 22 then
				helper_2386f745(1)
			end
			if at <= 23 then
				helper_d9e7376f(var0)
			end
			if at <= 24 then
				helper_5f2ad8dd(var0)
			end
			helper_119c2228(var0)
			helper_cc65be7b(var0)
			helper_4f735fdf(var0)
			helper_58c71c96(var0)
			helper_c34a4dc9(var0)
			helper_6df4835c(var0)
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
		helper_548b5fe0()
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.SndSeStop(var0, 7)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		helper_548b5fe0()
		event.EsmClear()
		event.ResetCamera(1, 0.0, 20.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(202, 1)
	event.Initialize()
	var0 = event.SndLoadSound(1837) or var0
	helper_d974bf77()
	event.EohSetFootSoundId(0, 0)
	event.StopBgm(0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(1, 0)
	event.CmrsSetPos(-339.31, 136.54, 364.85)
	event.CmrsSetRef(-238.55, 35.08, 513.89)
	event.ObjsSetPos(0, -198.33, 13.59, 420.19)
	event.ObjsSetRot(0, 0.0, -0.35, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ぼうぜん顔")
	event.ObjsTexAnime(0, 1, "つうじょう目パチ")
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 160)
	event.ObjsAddPas(0, -198.33, 13.59, 420.19)
	event.ObjsAddPas(0, -203.12, 13.59, 502.05)
	event.ObjsAddPas(0, -216.28, 13.59, 545.08)
	event.ObjsAddPas(0, -238.62, 13.59, 586.39)
	event.ObjsStartPas(0)
	event.EohSetFootSoundId(0, 15)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 2)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CmrsSetPos(-157.69, 69.09, 657.85)
	event.CmrsSetRef(-309.71, 39.39, 635.31)
	event.ObjsSetPos(0, -218.73, 13.59, 644.79)
	event.ObjsSetRot(0, 0.0, -1.67, 0.0)
	event.ObjsMove(0, -301.77, 13.77, 637.45, 60)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(-157.69, 69.09, 657.85, -309.71, 39.39, 635.31)
	event.CmrsAddPas(-182.29, 46.57, 654.2, -309.71, 39.39, 635.31)
	event.CmrsAddPas(-226.21, 39.3, 647.69, -309.71, 39.39, 635.31)
	event.CmrsStartPas()
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち", 0)
	helper_c1c32f84(150)
	if vm.skipping() then
		return skip(4)
	end
	helper_42c67f56(2020010)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-325.02, 31.34, 616.64)
	event.CmrsSetRef(-305.34, 35.79, 635.58)
	event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
	helper_42c67f56(2020020)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsSetPos(-333.76, 40.57, 633.22)
	event.CmrsSetRef(-302.99, 37.72, 637.65)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目～うれし目")
	event.ObjsTexAnime(0, 1, "半口～うれし開き")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsTexAnime(0, 1, "きらきら目")
	event.CmrsMove2(-326.11, 40.57, 634.32, -302.99, 37.72, 637.65, 90, 2, 0.4)
	helper_42c67f56(2020030)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "まえ向き～左むき")
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(0, "振り返る", 6, -1.0, 1)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsInit()
	helper_b63800d2(2200.0, 220)
	event.CmrsSetPos(-331.99, 42.11, 682.27)
	event.CmrsSetRef(-281.67, 40.37, 620.78)
	event.SndSePlay(var0, 8)
	helper_c1c32f84(50)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "振り返るL", 6, -1.0, 1)
	helper_c1c32f84(70)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "列車を見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "列車を見るL", 0)
	helper_c1c32f84(120)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-704.28, 74.53, 644.02)
	event.CmrsSetRef(-229.0, 60.03, 630.45)
	event.EohSetShadow(0, 0)
	event.EohSetShadow(1, 0)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-272.98, 32.08, 611.38)
	event.CmrsSetRef(-292.01, 32.94, 630.57)
	event.ObjsSetRot(0, 0.0, 1.93, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsSetMotion(0, "キョロキョロ", 4, -1.0, 1)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.CharaActive(1, 9)
	event.CmrsSetPos(-344.7, 43.98, 674.78)
	event.CmrsSetRef(-270.62, 44.19, 558.35)
	event.ObjsSetRot(0, 0.0, 1.69, 0.0)
	event.ObjsSetPos(1, -57.93, 11.86, 130.81)
	event.ObjsSetRot(1, 0.0, -1.55, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_z = vm.f32(pos_z + vm.f32(-517.642))
	event.ObjsSetPos(4, pos_x - 50.0, pos_y, pos_z)
	event.ObjsSetRot(4, 0.0, 0.0, 0.08726647)
	event.SndSePlay(var0, 9)
	event.ObjsRotation(8, 0.0, -1.57, 0.0, 30)
	event.ObjsRotation(7, 0.0, 1.57, 0.0, 30)
	event.ObjsRotation(24, 0.0, -1.57, 0.0, 30)
	event.ObjsRotation(23, 0.0, 1.57, 0.0, 30)
	event.ObjsSetMotion(0, "左を見る", 6)
	event.ObjsNextMotion(0, "左を見るL", 0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 15)
	event.ObjsAddPas(1, -58.2, 12.83, 120.56)
	event.ObjsAddPas(1, -71.49, 12.83, 120.23)
	event.ObjsStartPas(1)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetPos(4, pos_x, pos_y, pos_z)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.ObjsSetRot(24, 0.0, 0.0, 0.0)
	event.ObjsSetRot(23, 0.0, 0.0, 0.0)
	event.CharaActive(1, 0)
	event.CharaActive(1, 9)
	event.CmrsSetPos(-429.29, 148.18, 653.31)
	event.CmrsSetRef(-322.93, 59.6, 619.28)
	event.ObjsSetRot(0, 0.0, 2.65, 0.0)
	event.ObjsSetPos(1, -223.19, 13.78, 510.23)
	event.ObjsSetRot(1, 0.0, -0.5, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(1, -268.59, 13.78, 585.68, 75)
	helper_c1c32f84(75)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsSetPos(-291.41, 39.19, 607.31)
	event.CmrsSetRef(-299.71, 35.93, 634.94)
	event.EohSetShadow(0, 1)
	event.EohSetShadow(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "きらきら目")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2020040)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-315.4, 36.86, 675.88)
	event.CmrsSetRef(-291.69, 35.93, 632.9)
	event.ObjsSetRot(0, 0.0, 2.29, 0.0)
	event.ObjsSetPos(1, -271.9, 13.78, 616.69)
	event.ObjsSetRot(1, 0.0, -0.98, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "腰に手", 6)
	event.ObjsNextMotion(1, "腰に手L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2020050)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "乗れ", 6)
	event.ObjsNextMotion(1, "乗れL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2020060)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-264.17, 27.45, 662.14)
	event.CmrsSetRef(-203.38, 37.55, 662.68)
	event.ObjsSetPos(0, -269.3, 13.77, 637.92)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetPos(1, -273.23, 13.77, 651.56)
	event.ObjsSetRot(1, 0.0, 1.44, 0.0)
	helper_d9e7376f(var0)
	if vm.skipping() then
		return skip(24)
	end
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	helper_5f2ad8dd(var0)
	if vm.skipping() then
		return skip(25)
	end
	helper_119c2228(var0)
	helper_cc65be7b(var0)
	helper_4f735fdf(var0)
	helper_58c71c96(var0)
	helper_c34a4dc9(var0)
	helper_6df4835c(var0)
	return part2()
end

return helper_1f378ea6
