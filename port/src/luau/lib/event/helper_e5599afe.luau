--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13876cb6 = require("@lib/event/helper_13876cb6")
local helper_4cacbc41 = require("@lib/event/helper_4cacbc41")

--- Helper function.
local function helper_e5599afe(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(1, 4)
	helper_13876cb6(1, 4)
	helper_4cacbc41(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_e5599afe
