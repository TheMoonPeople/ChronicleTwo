--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_51a89305()
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

return helper_51a89305
