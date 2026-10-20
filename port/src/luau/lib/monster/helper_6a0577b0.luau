--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_274f6d9a = require("@lib/monster/helper_274f6d9a")

--- Helper function.
local function helper_6a0577b0(arg0: f32, arg1: any)
	local var2: s32 = 0
	local arrived: s32 = 0
	local var4: f32 = 0
	var2 = 0
	while var2 < arg1 do
		arrived = monster.ChkMoveEnd() or arrived
		var4 = monster.GetTargetDist() or var4
		if var4 < arg0 then
			monster.ResetMove()
			return 1
		end
		if arrived == 0 then
			helper_274f6d9a()
		else
			monster.ResetMove()
			return 2
		end
		if arrived == 1 then
			monster.ResetMove()
			return 1
		end
		var2 = vm.i32(var2 + 1)
	end
	return 0
end

return helper_6a0577b0
