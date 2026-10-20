--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_7ea1bd46(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(11)
		end
		if at <= 2 then
			helper_8f31f334(12)
		end
		if at <= 3 then
			helper_aafd6a80(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-326.52, 113.91, -1579.31)
	event.CmrsSetRef(-22.58, 118.56, -2134.59)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 10)
	event.SndSePlay(arg0, 12)
	event.ObjsMove(11, -200.0, 0.0, 0.0, 285)
	event.ObjsMove(12, 200.0, 0.0, 0.0, 285)
	helper_8f31f334(11)
	if vm.skipping() then
		return skip(2)
	end
	helper_8f31f334(12)
	if vm.skipping() then
		return skip(3)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_7ea1bd46
