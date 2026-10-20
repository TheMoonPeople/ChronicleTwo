--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_941ed74e = require("@lib/event/helper_941ed74e")
local helper_b03eb2e1 = require("@lib/event/helper_b03eb2e1")

--- Helper function.
local function helper_49824eab(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(1, 4)
	helper_b03eb2e1(1, 4)
	helper_941ed74e(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_49824eab
