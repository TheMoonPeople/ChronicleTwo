--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c5dd3daa(arg0: f32, arg1: f32, arg2: any, arg3: any)
	local var5: s32 = 0
	local var6: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg2 = arg2
			var5 = 0
			var6 = vm.fdiv(vm.ftoi(vm.f32(arg1 - arg0)), arg2)
		end
		var5 = vm.i32(var5 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	arg2 = arg2
	var5 = 0
	var6 = vm.fdiv(vm.ftoi(vm.f32(arg1 - arg0)), arg2)
	while var5 < arg2 do
		event.SetProjection(arg0 + vm.wrap(var6 * var5))
		if vm.wait() then
			return skip(2)
		end
		var5 = vm.i32(var5 + 1)
	end
end

return helper_c5dd3daa
