--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_36edc605 = require("@lib/event/helper_36edc605")

--- Helper function.
local function helper_867e7edb(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		helper_36edc605(if arg0 == 0 then 1 else 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(8192, arg0)
	helper_36edc605(if arg0 == 0 then 1 else 0)
	if arg0 == 0 then
		event.ActchrSetDefMotion(0, 4)
	end
	event.SetCharaChangeMask(2, if arg0 == 0 then 1 else 0)
	event.SetCharaChangeMask(3, if arg0 == 0 then 1 else 0)
	event.SetBitCtrl(1, arg0)
end

return helper_867e7edb
