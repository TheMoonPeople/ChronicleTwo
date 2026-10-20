--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_898707d9()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 34)
	event.CharaActive(0, 41)
	event.CharaActive(0, 36)
	event.CharaActive(0, 35)
	event.CharaActive(0, 38)
	event.CharaActive(0, 40)
	event.DeleteChara(34)
	event.DeleteChara(41)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.DeleteChara(38)
	event.DeleteChara(40)
end

return helper_898707d9
