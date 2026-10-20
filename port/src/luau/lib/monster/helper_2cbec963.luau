--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_2cbec963(arg0: s32)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		monster.ResetMotion()
		monster.SetMos("攻撃１", -1, 6)
		helper_754712d9(10.0, helper_9df6409a(42))
		var1 = var1 + 1
	end
	if var1 > 1 then
		monster.ResetMotion()
		monster.SetMos("気絶", -1, 0)
		helper_c3e8ae39(vm.i32(var1 * 20))
	end
end

return helper_2cbec963
