--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_548b5fe0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.CharaActive(0, 9)
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(10)
end

return helper_548b5fe0
