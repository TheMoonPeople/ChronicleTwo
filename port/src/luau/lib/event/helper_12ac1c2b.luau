--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c6932bb = require("@lib/event/helper_0c6932bb")

--- Helper function.
local function helper_12ac1c2b()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0c6932bb(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_0c6932bb(var0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_12ac1c2b
