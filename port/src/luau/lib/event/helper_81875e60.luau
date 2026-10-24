--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_81875e60()
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_e34416e2(2850030)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsRotation(0, 0.0, 0.2, 0.0, 15)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 15)
	helper_25abe6d2(15)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(30)
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 13.4, 6.52, 613.7)
	event.ObjsAddPas(0, 16.54, 2.3, 632.93)
	event.ObjsAddPas(0, 19.85, -3.85, 662.84)
	event.ObjsAddPas(0, 22.02, -8.04, 684.68)
	event.ObjsAddPas(0, 24.22, -12.54, 709.74)
	event.ObjsAddPas(0, 26.96, -12.32, 737.33)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 47.24, 7.54, 600.38)
	event.ObjsAddPas(1, 49.86, 2.84, 624.2)
	event.ObjsAddPas(1, 51.55, -2.15, 651.95)
	event.ObjsAddPas(1, 52.91, -6.17, 674.31)
	event.ObjsAddPas(1, 55.85, -12.79, 722.8)
	event.ObjsStartPas(1)
	helper_25abe6d2(60)
end

return helper_81875e60
