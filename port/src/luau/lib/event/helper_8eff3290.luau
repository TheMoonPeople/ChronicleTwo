--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")

--- Helper function.
local function helper_8eff3290(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(4)
		end
		if at <= 2 then
			helper_6c719c99(1090320)
		end
		if at <= 3 then
			helper_184013af()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(212.25, 205.2, 623.4)
	event.CmrsSetRef(236.71, 212.83, 651.45)
	event.ObjsSetPos(4, 258.83, 197.74, 677.01)
	event.ObjsSetRot(4, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	helper_8f31f334(4)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(4, "口パク")
	helper_6c719c99(1090320)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CmrsFadeOut(100, 0.0, 0.0, 0.0)
	helper_184013af()
	if vm.skipping() then
		return skip(4)
	end
end

return helper_8eff3290
