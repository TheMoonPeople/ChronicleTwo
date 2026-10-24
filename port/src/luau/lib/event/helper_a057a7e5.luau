--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1dacf506 = require("@lib/event/helper_1dacf506")
local helper_ffa2b2b2 = require("@lib/event/helper_ffa2b2b2")

--- Helper function.
local function helper_a057a7e5(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_ffa2b2b2(arg0, arg1, arg2, arg3, arg4)
			local _ = helper_1dacf506(arg0, arg5)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_ffa2b2b2(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_1dacf506(arg0, arg5)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
end

return helper_a057a7e5
