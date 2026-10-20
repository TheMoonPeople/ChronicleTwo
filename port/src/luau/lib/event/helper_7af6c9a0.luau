--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e056829 = require("@lib/event/helper_1e056829")
local helper_be382d20 = require("@lib/event/helper_be382d20")

--- Helper function.
local function helper_7af6c9a0(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1e056829(1)
		end
		if at <= 2 then
			helper_be382d20(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_1e056829(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_be382d20(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_7af6c9a0
