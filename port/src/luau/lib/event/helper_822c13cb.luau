--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_822c13cb(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f33fd19e(0)
		end
		if at <= 2 then
			helper_f33fd19e(1)
		end
		if at <= 3 then
			helper_0da018f4()
		end
		if at <= 4 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-501.66, 281.73, -144.66)
	event.CmrsSetRef(-757.43, 150.05, -3.21)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -739.96, 133.89, -9.49)
	event.ObjsSetRot(0, 0.0, 1.2, 0.0)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -739.96, 133.89, -9.49)
	event.ObjsSetRot(1, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsRotation(0, 0.0, -1.44, 0.0, 20)
	event.ObjsRotation(1, 0.0, -1.44, 0.0, 20)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(100)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -915.85, 133.64, -6.02, 150)
	event.ObjsMove(1, -915.85, 133.64, -6.02, 150)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_0da018f4()
	if vm.skipping() then
		return skip(5)
	end
end

return helper_822c13cb
