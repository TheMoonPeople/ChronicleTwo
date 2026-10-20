--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f0e3e00a()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(11)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DelImg(0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

return helper_f0e3e00a
