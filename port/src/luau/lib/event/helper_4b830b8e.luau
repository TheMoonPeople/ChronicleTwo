--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_4b830b8e(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 1)
	event.EohSyncChara(1, 2)
	event.EohSetShow(0, arg0)
	event.EohSetShow(1, arg0)
	event.SetStatusbarShow(arg0, 1.0)
end

return helper_4b830b8e
