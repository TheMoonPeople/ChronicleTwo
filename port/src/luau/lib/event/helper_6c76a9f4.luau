--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_781c97dd = require("@lib/event/helper_781c97dd")
local helper_d29b6292 = require("@lib/event/helper_d29b6292")
local helper_d76d5fd4 = require("@lib/event/helper_d76d5fd4")

--- Helper function.
local function helper_6c76a9f4(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d76d5fd4(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_d29b6292(arg0, 0, var6)
		end
		helper_781c97dd(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_d76d5fd4(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_d29b6292(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_781c97dd(arg0)
end

return helper_6c76a9f4
