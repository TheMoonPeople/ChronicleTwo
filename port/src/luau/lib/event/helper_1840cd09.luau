--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b971cedc = require("@lib/event/helper_b971cedc")

--- Helper function.
local function helper_1840cd09(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b971cedc(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_b971cedc(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
end

return helper_1840cd09
