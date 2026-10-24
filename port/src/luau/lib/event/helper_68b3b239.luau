--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4be98e52 = require("@lib/event/helper_4be98e52")
local helper_854d8da2 = require("@lib/event/helper_854d8da2")
local helper_e85df3b0 = require("@lib/event/helper_e85df3b0")

--- Helper function.
local function helper_68b3b239(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e85df3b0(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_4be98e52(arg0, 0, var6)
		end
		helper_854d8da2(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e85df3b0(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_4be98e52(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_854d8da2(arg0)
end

return helper_68b3b239
