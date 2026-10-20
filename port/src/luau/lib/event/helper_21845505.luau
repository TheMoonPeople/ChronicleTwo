--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cfb096c9 = require("@lib/event/helper_cfb096c9")
local helper_e1e5862e = require("@lib/event/helper_e1e5862e")

--- Helper function.
local function helper_21845505(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e1e5862e(1, 4)
			helper_cfb096c9(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_e1e5862e(1, 4)
	helper_cfb096c9(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_21845505
