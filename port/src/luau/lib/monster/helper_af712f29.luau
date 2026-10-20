--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_af712f29(arg0: s32, arg1: s32)
	local var3: s32 = 0
	var3 = 1
	for var2 = 0, 31 do
		if (if vm.i32(bit32.band(arg0, var3)) ~= 0 then vm.i32(bit32.band(arg1, var3)) else 0) ~= 0 then
			arg0 = vm.i32(arg0 - var3)
		end
		var3 = vm.i32(var3 * 2)
	end
	return arg0
end

return helper_af712f29
