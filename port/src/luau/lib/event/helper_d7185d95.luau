--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d7185d95(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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

return helper_d7185d95
