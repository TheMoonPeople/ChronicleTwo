--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4b830b8e = require("@lib/event/helper_4b830b8e")

--- Helper function.
local function helper_7e1e9066(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		helper_4b830b8e(if arg0 == 0 then 1 else 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(8192, arg0)
	helper_4b830b8e(if arg0 == 0 then 1 else 0)
	if arg0 == 0 then
		event.ActchrSetDefMotion(0, 4)
	end
	event.SetCharaChangeMask(2, if arg0 == 0 then 1 else 0)
	event.SetCharaChangeMask(3, if arg0 == 0 then 1 else 0)
	event.SetBitCtrl(1, arg0)
end

return helper_7e1e9066
