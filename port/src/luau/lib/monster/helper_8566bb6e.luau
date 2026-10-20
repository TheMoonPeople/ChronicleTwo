--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8566bb6e(arg0: any)
	local arrived: s32 = 0
	arrived = monster.ChkMoveEnd() or arrived
	while arrived == 0 do
		vm.wait()
		arrived = monster.ChkMoveEnd() or arrived
		arg0 = vm.wrap(arg0 - 1)
		if arg0 <= 0 then
			monster.ResetMove()
			return
		end
	end
	monster.ResetMove()
end

return helper_8566bb6e
