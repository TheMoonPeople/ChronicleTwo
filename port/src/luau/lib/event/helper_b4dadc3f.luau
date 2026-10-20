--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_b4dadc3f(arg0: any, arg1: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			arg0 = arg0
		end
		var3 = vm.i32(var3 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = 0
	arg0 = arg0
	while var3 < arg0 do
		if vm.wait() then
			return skip(2)
		end
		var3 = vm.i32(var3 + 1)
	end
end

return helper_b4dadc3f
