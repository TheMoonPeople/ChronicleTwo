--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f6c4dc7 = require("@lib/event/helper_1f6c4dc7")
local helper_894b5c3b = require("@lib/event/helper_894b5c3b")

--- Helper function.
local function helper_4a2354f0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_894b5c3b(1)
		end
		if at <= 2 then
			helper_1f6c4dc7(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_894b5c3b(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_1f6c4dc7(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_4a2354f0
