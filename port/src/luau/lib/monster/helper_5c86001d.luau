--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bee0409d = require("@lib/monster/helper_bee0409d")

--- Helper function.
local function helper_5c86001d(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_bee0409d()
		var1 = vm.i32(var1 + 1)
	end
end

return helper_5c86001d
