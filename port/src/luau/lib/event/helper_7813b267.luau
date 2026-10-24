--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_7813b267(arg0: s32)
	event.SetMesPreset(2, 4)
	helper_125385ee(2, 8)
	helper_82705ce2(2, vm.i32(1010 + arg0), 4, 0, 0)
end

return helper_7813b267
