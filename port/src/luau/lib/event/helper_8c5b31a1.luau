--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_8c5b31a1(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_184013af()
		end
		if at <= 2 then
			helper_aafd6a80(30)
		end
		if at <= 3 then
			helper_aafd6a80(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-130.02, 67.35, -2138.26)
	event.CmrsSetRef(-120.37, 83.46, -1843.2)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 6)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_184013af()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 9)
	event.SndSePlay(arg0, 10)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -116.18, 50.38, -1787.14)
	event.SetMotion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.EohSyncObj(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.ObjsSetMotion(6, "ぶしゅー", 6)
	event.ObjsSetMotion(7, "ぶしゅー", 6)
	event.ObjsSetPos(6, -114.25, 13.26, -1653.54)
	event.ObjsSetRot(6, 0.0, 3.04, 0.0)
	event.ObjsSetPos(7, -126.53, 32.32, -1662.93)
	event.ObjsSetRot(7, 0.0, -3.12, 0.0)
	event.SndSePlay(arg0, 11)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0, 40)
end

return helper_8c5b31a1
