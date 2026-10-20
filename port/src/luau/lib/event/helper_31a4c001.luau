--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4d7f8567 = require("@lib/event/helper_4d7f8567")

--- Helper function.
local function helper_31a4c001(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var2
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_4d7f8567(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

return helper_31a4c001
