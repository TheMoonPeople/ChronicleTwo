--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_e9042a30 = require("@lib/event/helper_e9042a30")

--- Helper function.
local function helper_f49dcfa8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e9042a30(1070030)
		end
		if at <= 2 then
			helper_af3fca28(0)
		end
		if at <= 3 then
			helper_af3fca28(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-221.89, 93.35, -18.76)
	event.CmrsSetRef(-248.13, 94.53, -3.27)
	event.ObjsSetPos(0, -245.08, 50.51, -6.05)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -245.08, 50.51, -6.05)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsSetMotion(1, "驚く", 6)
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1070030)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_f49dcfa8
