--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")

--- Helper function.
local function helper_901e0132(arg0: s32, arg1: s32)
	local var2: any = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMesQuestionGyou(1, 0)
		event.SetMesWindowMode(1, 5)
		event.SetMesDrawspeed(1, 1)
		event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
		at = 1
		var2 = helper_8f5252f6(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
		event.SetMesDrawspeed(1, 0)
		return var2
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var2 = received[1] :: number
			end
			return var2
		end
		return nil
	end)
end

return helper_901e0132
