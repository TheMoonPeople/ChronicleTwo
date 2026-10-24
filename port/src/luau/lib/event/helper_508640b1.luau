--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_508640b1(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0da018f4()
		end
		if at <= 2 then
			helper_f33fd19e(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-158.38, 85.25, 3.62)
	event.CmrsSetRef(-34.81, 85.07, -0.49)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 0.0, 50.0, 0.0)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetScale(2, 1.3, 1.3, 1.3)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_0da018f4()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(2, "死", 6)
	event.ObjsMotionWait(2)
	helper_f33fd19e(2)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_508640b1
