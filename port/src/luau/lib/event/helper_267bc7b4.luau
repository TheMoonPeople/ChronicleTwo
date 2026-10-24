--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_267bc7b4(arg0: s32, arg1: s32, sp: number)
	vm.stack(sp + 2)
	vm.stack(sp + 4)
	event.SetMesWindowMode(arg0, arg1)
	vm.stack(sp + 2)
end

return helper_267bc7b4
