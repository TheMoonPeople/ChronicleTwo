--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_7377ea1d()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.SetAi(1, 24)
	event.CharaActive(1, 0)
	event.CharaActive(1, 24)
	event.ResetCamera(1)
	event.SetFadeIn(30)
end

return helper_7377ea1d
