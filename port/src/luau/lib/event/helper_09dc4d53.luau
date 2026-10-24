--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_09dc4d53(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			var1 = var1 + 1
			helper_c1c32f84(30)
		end
		if at <= 2 then
			helper_c1c32f84(75)
		end
		if at <= 3 then
			helper_c1c32f84(75)
		end
		if at <= 4 then
			helper_c1c32f84(150)
		end
		if at <= 5 then
			helper_c1c32f84(165)
		end
		if at <= 6 then
			helper_c1c32f84(180)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(3.45, 77.44, 1389.54)
	event.CmrsSetRef(3.0, 63.96, 1261.17)
	var1 = 0
	while var1 < 12 do
		event.ObjsRotation(10 + var1, 0.03, 0.0, 0.0, -1)
		var1 = var1 + 1
	end
	event.SndSePlay(arg0, 15)
	event.ObjsSetPos(2, 0.0, -24.0, 500.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CharaActive(1, 10)
	event.SetCharaPos(10, 1.55, 41.98, 824.64)
	event.SetMotion(10, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(0, 10)
	event.ObjsMove2(2, 0.0, -24.0, 5000.0, 360, 1, 0.7)
	event.SndSePlay(arg0, 16)
	event.CmrsSetPos(-423.7, 77.44, 613.24)
	event.CmrsSetRef(-149.56, 63.96, 588.35)
	helper_c1c32f84(75)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(3.45, 77.44, 1389.54)
	event.CmrsSetRef(3.0, 63.96, 1261.17)
	event.CmrsMove2(4.3, 77.44, 1631.73, 3.0, 63.96, 1261.17, 75, 2, 0.2)
	helper_c1c32f84(75)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-741.43, 330.34, 349.51)
	event.CmrsSetRef(-180.96, 187.05, 261.6)
	event.CmrsMove2(-741.43, 330.34, 349.51, -335.86, 187.05, 767.89, 90, 2, 0.4)
	helper_c1c32f84(150)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.CmrsFadeDelay(135)
	event.CmrsFadeOut(30, 0.0, 0.0)
	event.CmrsMove2(-1416.81, 608.29, -321.97, -333.28, 187.05, 759.45, 120, 0, 0.4)
	helper_c1c32f84(165)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	helper_c1c32f84(180)
	if vm.skipping() then
		return skip(7)
	end
end

return helper_09dc4d53
