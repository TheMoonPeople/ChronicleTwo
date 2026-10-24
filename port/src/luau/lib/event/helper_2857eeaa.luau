--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_9ce61bb7 = require("@lib/event/helper_9ce61bb7")

--- Helper function.
local function helper_2857eeaa(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	helper_9ce61bb7(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_2857eeaa
