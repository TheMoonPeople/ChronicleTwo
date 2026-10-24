--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_6da1ee81(arg0: any)
	event.CmrsSetPos(24.93, 29.64, -79.63)
	event.CmrsSetRef(-8.31, 36.32, -96.0)
	event.ObjsSetPos(2, 0.05, 10.14, -94.36)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目とじ～目あけ")
	event.ObjsSetMotion(2, "前を見る", 2)
	event.ObjsNextMotion(2, "前を見るL")
	helper_0958ca60(2)
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090240)
	event.ResetPakuAnim()
	vm.wait(3)
end

return helper_6da1ee81
