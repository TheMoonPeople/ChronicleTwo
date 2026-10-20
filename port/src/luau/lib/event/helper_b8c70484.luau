--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5e67448e = require("@lib/event/helper_5e67448e")
local helper_e64ec5fa = require("@lib/event/helper_e64ec5fa")

--- Helper function.
local function helper_b8c70484(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5e67448e(1, 4)
			helper_e64ec5fa(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_5e67448e(1, 4)
	helper_e64ec5fa(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_b8c70484
