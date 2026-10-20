--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4f9d5a77 = require("@lib/event/helper_4f9d5a77")
local helper_befb9325 = require("@lib/event/helper_befb9325")
local helper_e1f7e111 = require("@lib/event/helper_e1f7e111")

--- Helper function.
local function helper_b4ed6a5a(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_4f9d5a77(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_e1f7e111(arg0, 0, var6)
		end
		helper_befb9325(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_4f9d5a77(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_e1f7e111(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_befb9325(arg0)
end

return helper_b4ed6a5a
