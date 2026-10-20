--!strict
-- Shared monster helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")

--- Helper function.
local function helper_b0ab6794(arg0: s32)
	local arrived: s32 = 0
	for var1 = 0, arg0 - 1 do
		arrived = monster.ChkMoveEnd() or arrived
		if arrived == 0 then
			helper_0ba23e4e()
		else
			return
		end
	end
end

return helper_b0ab6794
