--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b51fc149 = require("@lib/event/helper_b51fc149")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_664f3040(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(50)
		end
		if at <= 2 then
			helper_f33fd19e(0)
		end
		if at <= 3 then
			helper_f33fd19e(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-408.29, 60.12, 94.13)
	event.CmrsSetRef(-475.86, 71.34, 81.15)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -492.64, 50.09, 76.79)
	event.ObjsSetRot(0, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(0, "プルプル", 4, -1.0, 1)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -492.64, 50.09, 76.79)
	event.ObjsSetRot(1, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(1, "プルプル", 4)
	event.SndSePlay(arg0, 0)
	helper_b51fc149(50)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(0, "ジャンプ", 6, 0.4)
	event.ObjsSetMotion(1, "ジャンプ", 6, 0.4)
	event.ObjsPosDelay(0, 3)
	event.ObjsPosDelay(1, 3)
	event.ObjsJump(0, -739.96, 133.89, -9.49, -0.28, 33)
	event.ObjsJump(1, -739.96, 133.89, -9.49, -0.28, 33)
	event.ObjsMotionWait(0)
	event.ObjsMotionWait(1)
	event.CmrsMove2(-408.29, 60.12, 94.13, -709.98, 167.81, 0.97, 25, 0, 0.4)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(arg0, 0)
end

return helper_664f3040
