--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_338a95d5 = require("@lib/event/helper_338a95d5")
local helper_3a1f7832 = require("@lib/event/helper_3a1f7832")

--- Helper function.
local function helper_fd931f23(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_338a95d5(1)
		end
		if at <= 2 then
			helper_3a1f7832(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_338a95d5(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_3a1f7832(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_fd931f23
