--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31947fd7 = require("@lib/event/helper_31947fd7")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")

--- Helper function.
local function helper_72e9b67e(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var7: s32 = 0
	local at: number = 0
	local t1: s32 = 0
	return vm.guard(function()
		local _ = helper_82705ce2(arg0, arg1, arg2, arg3, arg4)
		at = 1
		local t0: s32
		t0, arg5 = helper_31947fd7(arg0, 1, arg5)
		var7 = t0
		helper_6992f518(arg0)
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

return helper_72e9b67e
