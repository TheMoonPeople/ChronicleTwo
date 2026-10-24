--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_4e6f447c(arg0: any)
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "スコップ立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(2030010)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(2030015)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(2030020)
	event.ResetPakuAnim()
end

return helper_4e6f447c
