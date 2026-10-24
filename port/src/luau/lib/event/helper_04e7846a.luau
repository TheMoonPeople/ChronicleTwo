--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_04e7846a()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(35)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

return helper_04e7846a
