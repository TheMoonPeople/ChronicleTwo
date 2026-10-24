--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_20c72d9f = require("@lib/event/helper_20c72d9f")
local helper_9fa762c4 = require("@lib/event/helper_9fa762c4")

--- Helper function.
local function helper_eb4af91a(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9fa762c4(1, 4)
			helper_20c72d9f(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_9fa762c4(1, 4)
	helper_20c72d9f(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_eb4af91a
