--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_012ae4e7 = require("@lib/event/helper_012ae4e7")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_c58b8aee(arg0: s32)
	local projection: f32 = 0
	projection = event.GetProjection() or projection
	event.SetProjection(813.9)
	event.CmrsSetPos(-11.48, 40.92, -121.7)
	event.CmrsSetRef(-8.15, 36.49, -100.87)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -4.0, 5.43, -39.21)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ちあがるL", 4)
	event.ObjsSetMotion(1, "腰に手", 6)
	event.ObjsNextMotion(1, "腰に手L")
	helper_0958ca60(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(1090020)
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "机をたたく", 6)
	event.ObjsNextMotion(1, "机をたたくL")
	helper_012ae4e7(33, vm.f32(0.805), -1.0, 60)
	event.SndSePlay(arg0, 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(1090030)
	event.ResetPakuAnim()
	helper_0958ca60(1)
	event.SetProjection(projection)
end

return helper_c58b8aee
