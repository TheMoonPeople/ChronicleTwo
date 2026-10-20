--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_69b1df97(arg0: f32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(0.04)
			arg0 = vm.f32(arg0 + vm.f32(0.13))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	arg0 = vm.f32(0.04)
	while var1 <= 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.13))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	return arg0
end

return helper_69b1df97
