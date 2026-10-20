--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7443da3d = require("@lib/event/helper_7443da3d")
local helper_cb795f9c = require("@lib/event/helper_cb795f9c")
local helper_fcb18908 = require("@lib/event/helper_fcb18908")

--- Helper function.
local function helper_065641b0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_fcb18908(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_cb795f9c(arg0, 0, var6)
		end
		helper_7443da3d(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_fcb18908(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_cb795f9c(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_7443da3d(arg0)
end

return helper_065641b0
