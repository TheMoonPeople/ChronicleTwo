--!strict
-- Shared action helper used by 13 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_1eb83da1()
	local var1: s32 = 0
	local prog: s32 = 0
	prog = action.ProgGet() or prog
	if prog == 100 then
		action.SetMos("攻撃１", -1, 6)
		vm.wait()
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
end

return helper_1eb83da1
