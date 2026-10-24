--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d8d161f8 = require("@lib/event/helper_d8d161f8")

--- Helper function.
local function helper_375124ef()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d8d161f8(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_d8d161f8(var0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_375124ef
