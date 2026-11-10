--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_c45eb7de = require("@lib/event/helper_c45eb7de")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_94011697(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var7: s32 = 0
	local at: number = 0
	local t1: s32 = 0
	return vm.guard(function()
		local _ = open_message(arg0, arg1, arg2, arg3, arg4)
		at = 1
		local t0: s32
		t0, arg5 = helper_c45eb7de(arg0, 1, arg5)
		var7 = t0
		close_message(arg0)
		return arg5
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				t1 = received[1] :: number
				arg5 = received[2] :: number
			end
			var7 = t1
			helper_d16eef1e(arg0)
			return var7, arg5
		end
		return nil, arg5
	end)
end

return helper_94011697
