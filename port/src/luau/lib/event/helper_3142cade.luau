--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_e03e89ed = require("@lib/event/helper_e03e89ed")

--- Helper function.
local function helper_3142cade(arg0: s32)
	event.SetMesPreset(2, 4)
	helper_125385ee(2, 8)
	helper_e03e89ed(2, vm.i32(1010 + arg0), 4, 0, 0)
end

return helper_3142cade
