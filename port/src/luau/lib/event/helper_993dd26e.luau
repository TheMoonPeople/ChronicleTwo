--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_993dd26e(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f33fd19e(0)
		end
		if at <= 2 then
			helper_f33fd19e(1)
		end
		if at <= 3 then
			helper_06d53ec5(1080030)
		end
		if at <= 4 then
			helper_06d53ec5(1080033)
		end
		if at <= 5 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-350.38, 95.45, -59.38)
	event.CmrsSetRef(-418.26, 93.83, -69.21)
	event.ObjsSetMotion(0, "上見戻り", 6, 0.06)
	event.ObjsSetMotion(1, "上見戻り", 6, 0.06)
	event.ObjsMotionWait(0)
	event.ObjsMotionWait(1)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4, -1.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4, -1.0)
	event.CmrsMove2(-376.98, 95.45, -63.23, -418.26, 93.83, -69.21, 150, 2, 0.4)
	helper_06d53ec5(1080030)
	if vm.skipping() then
		return skip(4)
	end
	helper_06d53ec5(1080033)
	if vm.skipping() then
		return skip(5)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(6)
	end
end

return helper_993dd26e
