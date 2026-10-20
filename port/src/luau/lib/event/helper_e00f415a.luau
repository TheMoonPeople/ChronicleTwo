--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_b51fc149 = require("@lib/event/helper_b51fc149")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_e00f415a(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f33fd19e(0)
		end
		if at <= 2 then
			helper_f33fd19e(1)
		end
		if at <= 3 then
			helper_06d53ec5(1080020)
		end
		if at <= 4 then
			helper_f33fd19e(3)
		end
		if at <= 5 then
			helper_b51fc149(30)
		end
		if at <= 6 then
			var1 = 0
		end
		if at <= 7 then
			var1 = var1 + 1
			helper_f33fd19e(3)
		end
		if at <= 8 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraPos(-480.46, 80.16, -12.91)
	event.SetCameraRef(-259.64, 146.91, -128.27)
	event.SetCharaPos(0, -409.26, 50.0, -69.12)
	event.SetCharaRot(0, 0.0, 1.41, 0.0)
	event.SetCharaPos(9, -409.26, 50.0, -69.12)
	event.SetCharaRot(9, 0.0, 1.41, 0.0)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, -302.17, 113.58, -60.02)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.ObjsSetMotion(0, "上見L", 6)
	event.ObjsSetMotion(1, "上見L", 6)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(3, "ウッキー", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_06d53ec5(1080020)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(5)
	end
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsMove2(-491.11, 58.84, -65.59, -180.4, 265.78, -14.82, 75, 2, 0.4)
	event.SndSePlay(arg0, 3)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 90)
	event.ObjsAddPas(3, -302.17, 113.58, -60.02)
	event.ObjsAddPas(3, -273.27, 162.52, -91.31)
	event.ObjsAddPas(3, -277.61, 214.43, -63.38)
	event.ObjsAddPas(3, -270.68, 254.99, -10.75)
	event.ObjsAddPas(3, -258.74, 289.17, 32.34)
	event.ObjsAddPas(3, -264.84, 267.38, 91.29)
	event.ObjsAddPas(3, -274.53, 223.84, 104.42)
	event.ObjsAddPas(3, -263.59, 171.46, 62.02)
	event.ObjsAddPas(3, -241.79, 175.34, 11.82)
	event.ObjsAddPas(3, -235.1, 208.28, -15.33)
	event.ObjsAddPas(3, -215.1, 272.95, -30.99)
	event.ObjsAddPas(3, -206.66, 335.24, -34.05)
	event.ObjsAddPas(3, -186.98, 388.24, -30.99)
	event.ObjsAddPas(3, -161.91, 455.92, -27.1)
	event.ObjsStartPas(3)
	var1 = 0
	while var1 < 90 do
		event.ObjsSetRot(3, 0.0, -1.71, 0.0)
		if vm.wait() then
			return skip(7)
		end
		var1 = var1 + 1
	end
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(8)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(arg0, 2)
end

return helper_e00f415a
