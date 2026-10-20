--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")

--- Helper function.
local function helper_ed5fe55d(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(1)
		end
		if at <= 2 then
			helper_8f31f334(2)
		end
		if at <= 3 then
			helper_8f31f334(3)
		end
		if at <= 4 then
			helper_184013af()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-337.21, 57.28, -2006.87)
	event.CmrsSetRef(-278.59, 71.17, -1908.74)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, 0.04, 0.0)
	event.ObjsSetMotion(1, "走り", 4)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "走り", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsMove(1, -264.97, 36.87, -1753.54, 80)
	event.ObjsRotation(1, 0.0, 0.04, 0.0, 150)
	event.ObjsMotionDelay(1, 95)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsRotation(2, 0.0, 0.06, 0.0, 10)
	event.ObjsPosDelay(2, 10)
	event.ObjsMove(2, -221.09, 36.72, -1531.87, 80)
	event.ObjsMotionDelay(2, 95)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsRotation(3, 0.0, 0.16, 0.0, 10)
	event.ObjsPosDelay(3, 10)
	event.ObjsMove(3, -272.59, 36.72, -1640.34, 80)
	event.ObjsMotionDelay(3, 95)
	event.ObjsSetMotion(3, "立ち", 4)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(45)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(5)
	end
end

return helper_ed5fe55d
