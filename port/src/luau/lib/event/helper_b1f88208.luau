--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2d2a87f0 = require("@lib/event/helper_2d2a87f0")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_b1f88208(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local at: number = 0
	return vm.guard(function()
		local _ = helper_82705ce2(arg0, arg1, arg2, arg3, arg4)
		at = 1
		var8 = helper_2d2a87f0(arg0, arg5, arg6, 0)
		event.SetMesPos(arg0, 0)
		return var8
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var8 = received[1] :: number
			end
			return var8
		end
		return nil
	end)
end

return helper_b1f88208
