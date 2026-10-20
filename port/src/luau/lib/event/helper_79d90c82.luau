--!strict
-- Shared event helper used by 89 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_79d90c82()
	local ball_col: s32 = 0
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

return helper_79d90c82
