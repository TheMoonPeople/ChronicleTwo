--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_cb99d2e8(arg0: any, sp: number)
	vm.stack(sp + 1)
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 3)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 3)
	event.SetMesCursor(arg0, -1)
	vm.stack(sp + 2)
	event.MesClose(arg0)
	vm.stack(sp + 3)
	event.SetMesPos(arg0, 0)
	vm.stack(sp + 1)
end

return helper_cb99d2e8
