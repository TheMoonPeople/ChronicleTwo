--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_b8620b27(arg0: s32)
	event.CmrsSetPos(-130.02, 67.35, -2138.26)
	event.CmrsSetRef(-120.37, 83.46, -1843.2)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 6)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_c624bc16()
	event.SndSePlay(arg0, 9)
	event.SndSePlay(arg0, 10)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -116.18, 50.38, -1787.14)
	event.SetMotion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_25abe6d2(30)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.EohSyncObj_2(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.ObjsSetMotion(6, "ぶしゅー", 6)
	event.ObjsSetMotion(7, "ぶしゅー", 6)
	event.ObjsSetPos(6, -114.25, 13.26, -1653.54)
	event.ObjsSetRot(6, 0.0, 3.04, 0.0)
	event.ObjsSetPos(7, -126.53, 32.32, -1662.93)
	event.ObjsSetRot(7, 0.0, -3.12, 0.0)
	event.SndSePlay(arg0, 11)
	helper_25abe6d2(45)
	event.CharaActive(0, 40)
end

return helper_b8620b27
