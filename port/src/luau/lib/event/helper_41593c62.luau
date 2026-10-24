--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")

--- Helper function.
local function helper_41593c62(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4896c0c7(1070020)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-211.94, 92.54, -16.62)
	event.CmrsSetRef(-237.74, 91.77, -7.1)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -245.08, 50.51, -6.05)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -245.08, 50.51, -6.05)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.ObjsResetDaPosition(0)
	event.SndSeStop(arg0, 0)
	helper_4896c0c7(1070020)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_41593c62
