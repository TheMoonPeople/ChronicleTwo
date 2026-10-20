--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d8fad9b = require("@lib/event/helper_9d8fad9b")

--- Helper function.
local function helper_2440b79e()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
		helper_9d8fad9b(var0, var1, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	var1 = event.GetCnt(0) or var1
	var2 = event.GetCnt(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_9d8fad9b(var0, var1, var2)
end

return helper_2440b79e
