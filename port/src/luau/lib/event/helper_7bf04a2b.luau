--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_7bf04a2b()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.DeleteChara(33)
	event.DeleteChara(32)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
end

return helper_7bf04a2b
