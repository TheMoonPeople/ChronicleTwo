--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75e128cb = require("@lib/event/helper_75e128cb")
local helper_9277d743 = require("@lib/event/helper_9277d743")
local helper_97082b7a = require("@lib/event/helper_97082b7a")

--- Helper function.
local function helper_0679f808(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_97082b7a(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_75e128cb(arg0, 0, var6)
		end
		helper_9277d743(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_97082b7a(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_75e128cb(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_9277d743(arg0)
end

return helper_0679f808
