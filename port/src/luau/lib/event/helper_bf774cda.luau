--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_bf774cda()
	event.CmrsSetPos(1.94, 46.13, 182.69)
	event.CmrsSetRef(0.3, 9.85, 111.43)
	helper_e34416e2(4120280)
	event.CmrsSetPos(12.38, 21.89, 126.92)
	event.CmrsSetRef(0.56, 16.44, 101.56)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_e34416e2(4120290)
	helper_e34416e2(4120295)
	helper_0958ca60(2)
	event.CmrsSetPos(0.07, 37.81, 61.37)
	event.CmrsSetRef(0.86, 4.93, 133.5)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_e34416e2(4120300)
	helper_0958ca60(2)
	event.ObjsSetMotion(0, "オズ見会話", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_e34416e2(4120310)
	helper_0958ca60(0)
end

return helper_bf774cda
