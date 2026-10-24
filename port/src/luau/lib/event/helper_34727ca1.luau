--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_62946a4e = require("@lib/event/helper_62946a4e")
local helper_e304888c = require("@lib/event/helper_e304888c")

--- Helper function.
local function helper_34727ca1(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e304888c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_62946a4e(arg0, 0, var6)
		end
		helper_38448da1(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e304888c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_62946a4e(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_38448da1(arg0)
end

return helper_34727ca1
