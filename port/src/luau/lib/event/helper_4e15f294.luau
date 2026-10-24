--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_4e15f294(arg0: any)
	local var1: f32 = 0
	event.CmrsSetPos(-0.29, 27.55, -25.02)
	event.CmrsSetRef(-1.02, 29.45, -94.81)
	event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetProjection(871.9)
	event.SetCharaPos(34, 0.22, 5.19, -94.18)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "前を見るL", 4)
	helper_0958ca60(2)
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090120)
	event.ResetPakuAnim()
	helper_0958ca60(2)
	event.SetProjection(var1)
end

return helper_4e15f294
