--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_aa5b3ebe(arg0: any)
	event.Initialize()
	if arg0 == 0 then
		event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
		event.SetFadeIn(30)
		event.GotoSubgame(3)
	else
		event.SetExitFlag(1)
		event.SetFadeIn(30)
		return
	end
end

return helper_aa5b3ebe
