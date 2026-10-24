--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e77b5b1 = require("@lib/event/helper_3e77b5b1")
local helper_fb70dad4 = require("@lib/event/helper_fb70dad4")

--- Helper function.
local function helper_9596be37(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fb70dad4(1, 4)
			helper_3e77b5b1(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_fb70dad4(1, 4)
	helper_3e77b5b1(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_9596be37
