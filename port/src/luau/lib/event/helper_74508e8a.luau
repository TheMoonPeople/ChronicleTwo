--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b1338111 = require("@lib/event/helper_b1338111")
local helper_fb70dad4 = require("@lib/event/helper_fb70dad4")

--- Helper function.
local function helper_74508e8a(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fb70dad4(1, 4)
			helper_b1338111(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_fb70dad4(1, 4)
	helper_b1338111(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_74508e8a
