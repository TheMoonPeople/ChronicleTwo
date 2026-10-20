--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29dc3834 = require("@lib/event/helper_29dc3834")
local helper_ed303a24 = require("@lib/event/helper_ed303a24")

--- Helper function.
local function helper_2dfb91ca(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ed303a24(1, 4)
			helper_29dc3834(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_ed303a24(1, 4)
	helper_29dc3834(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_2dfb91ca
