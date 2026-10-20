--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_b941c9b1()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.DeleteChara(46)
	event.DeleteChara(45)
end

return helper_b941c9b1
