--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c0fce92c(arg0: f32)
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = 0
		arg0 = vm.f32(0.04)
		while var1 <= 10 do
			event.SetTbAngle(arg0)
			arg0 = vm.f32(arg0 + vm.f32(0.18))
			var1 = var1 + 1
			at = 1
			vm.wait(1)
		end
		return arg0
	end, function(received: { any })
		if at <= 1 then
			return 0, arg0
		end
		return nil, arg0
	end)
end

return helper_c0fce92c
