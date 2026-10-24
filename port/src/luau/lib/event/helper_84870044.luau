--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ab4f271 = require("@lib/event/helper_1ab4f271")

--- Helper function.
local function helper_84870044(arg0: s32)
	event.SetMesPreset(1, 4)
	event.SetMesWindowMode(1, 4)
	helper_1ab4f271(1, vm.i32(60 + arg0), 8, 0, 0)
end

return helper_84870044
