--!strict
-- Shared event helper used by 11 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f8b4c27a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = 1
		var2 = 0
		arg0 = vm.i32(arg0 - var3)
		var3 = var3 * 2
		var2 = var2 + 1
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = 1
	var2 = 0
	while var2 < 32 do
		if (if vm.i32(bit32.band(arg0, var3)) ~= 0 then vm.i32(bit32.band(arg1, var3)) else 0) ~= 0 then
			arg0 = vm.i32(arg0 - var3)
		end
		var3 = vm.i32(var3 * 2)
		var2 = var2 + 1
	end
	return arg0
end

return helper_f8b4c27a
