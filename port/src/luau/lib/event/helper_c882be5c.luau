--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c882be5c()
	local ball_col: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		ball_col = 1
		ball_col = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	ball_col = event.SphidaGetBallCol() or ball_col
	if ball_col == 0 then
		ball_col = 1
		event.CharaActive(1, 8)
		event.CharaActive(0, 9)
	else
		ball_col = 0
		event.CharaActive(0, 8)
		event.CharaActive(1, 9)
	end
	event.SphidaSetBallCol(ball_col)
end

return helper_c882be5c
