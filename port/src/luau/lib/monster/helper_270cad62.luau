--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_270cad62(arg0: s32, arg1: s32)
	local att_type: s32 = 0
	att_type = monster.get_last_attack_type() or att_type
	monster.set_secondary_variable(6, att_type)
	monster.set_secondary_variable(7, vm.i32(arg1 - arg0))
end

return helper_270cad62
