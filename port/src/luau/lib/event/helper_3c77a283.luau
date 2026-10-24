--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_3c77a283(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e8f4b85c(1)
		end
		if at <= 2 then
			helper_93bb7fa4(3140020)
		end
		if at <= 3 then
			helper_93bb7fa4(3140030)
		end
		if at <= 4 then
			helper_93bb7fa4(3140040)
		end
		if at <= 5 then
			helper_93bb7fa4(3140050)
		end
		if at <= 6 then
			helper_e8f4b85c(1)
		end
		if at <= 7 then
			helper_93bb7fa4(3140055)
		end
		if at <= 8 then
			helper_93bb7fa4(3140060)
		end
		if at <= 9 then
			helper_93bb7fa4(3140070)
		end
		if at <= 10 then
			helper_93bb7fa4(3140080)
		end
		if at <= 11 then
			helper_e8f4b85c(1)
		end
		if at <= 12 then
			helper_93bb7fa4(3140090)
		end
		if at <= 13 then
			helper_93bb7fa4(3140100)
		end
		if at <= 14 then
			helper_93bb7fa4(3140110)
		end
		if at <= 15 then
			helper_b027b809()
		end
		if at <= 16 then
			helper_93bb7fa4(3140120)
		end
		if at <= 17 then
			helper_93bb7fa4(3140130)
		end
		if at <= 18 then
			helper_93bb7fa4(3140140)
		end
		if at <= 19 then
			helper_e8f4b85c(1)
		end
		if at <= 20 then
			helper_93bb7fa4(3140145)
		end
		if at <= 21 then
			helper_93bb7fa4(3140150)
		end
		if at <= 22 then
			helper_e8f4b85c(1)
		end
		if at <= 23 then
			helper_e8f4b85c(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(50.0, 77.5, 1300.0)
	event.CmrsSetRef(-10.0, 77.5, 1300.0)
	event.ObjsSetPos(1, -10.0, 62.27, 1250.0)
	event.ObjsMove(1, -10.0, 62.79, 1296.0, 50, 1)
	event.ObjsRotDelay(1, 40)
	event.ObjsRotation(1, 0.0, 1.57, 0.0, 10)
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "立ち")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140020)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetColor(2, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140030)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140040)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetColor(2, 128, 128, 128, 0, 30)
	event.CmrsSetPos(1.0, 85.0, 1296.0)
	event.CmrsSetRef(0.0, 85.0, 1296.0)
	event.SndSePlay(arg0, 0)
	event.ObjsSetPos(1, -26.0, 62.27, 1296.0)
	event.ObjsSetMotion(1, "指立て", 6, -1.0, 1)
	event.ObjsNextMotion(1, "指立てＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140050)
	if vm.skipping() then
		return skip(6)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140055)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140060)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140070)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.CmrsSetPos(1.0, 85.0, 1296.0)
	event.CmrsSetRef(0.0, 85.0, 1296.0)
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(1, "立ち", 6)
	event.ObjsMotionDelay(1, 1)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140080)
	if vm.skipping() then
		return skip(11)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140090)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	event.CmrsSetPos(1.0, 85.0, 1296.0)
	event.CmrsSetRef(0.0, 85.0, 1296.0)
	event.CmrsMoveAhd2(-1.56, 0.0, 1.0, 120, 0, 1.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, 26.0, 62.27, 1296.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140100)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140110)
	if vm.skipping() then
		return skip(15)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(20.91, 86.95, 1309.81)
	event.CmrsSetRef(-8.42, 82.7, 1280.07)
	event.ObjsSetPos(0, 10.0, 62.8, 1290.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -10.0, 62.79, 1290.0)
	event.ObjsSetRot(1, 0.0, 1.33, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140120)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140130)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "下向く", 6)
	event.ObjsNextMotion(1, "下向くＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140140)
	if vm.skipping() then
		return skip(19)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-0.03, 67.1, 1346.95)
	event.CmrsSetRef(0.2, 76.75, 1291.95)
	event.SndSePlay(arg0, 3)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(1, "下向きからすふぃあ見る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "ふぃあ見るＬ", 4)
	event.ObjsSetMotion(0, "スフィア見る", 6)
	event.ObjsNextMotion(0, "スフィア見るL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140145)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(20.91, 86.95, 1309.81)
	event.CmrsSetRef(-8.42, 82.7, 1280.07)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, 1.33, 0.0)
	event.ObjsSetMotion(1, "すふぃあ見る戻り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "スフィア見る戻り", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3140150)
	if vm.skipping() then
		return skip(22)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(23)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(24)
	end
end

return helper_3c77a283
