--!strict
-- Shared event helper used by 49 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")

--- Helper function.
local function helper_7b829e53(arg0: s32)
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	helper_9e7d1511(1, vm.i32(60 + arg0), 8, 0, 0)
end

return helper_7b829e53
