--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6ac43304 = require("@lib/event/helper_6ac43304")
local helper_7443da3d = require("@lib/event/helper_7443da3d")
local helper_cb795f9c = require("@lib/event/helper_cb795f9c")

--- Helper function.
local function helper_16b2e6fc(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6ac43304(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_cb795f9c(arg0, 0, var5)
		end
		helper_7443da3d(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_6ac43304(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_cb795f9c(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_7443da3d(arg0)
end

return helper_16b2e6fc
