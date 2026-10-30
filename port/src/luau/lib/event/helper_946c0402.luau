--!strict
-- Shared event helper used by 54 scripts, translated by tools/luau/stb2luau.

local helper_854bd6cf = require("@lib/event/helper_854bd6cf")

--- Helper function.
local function helper_946c0402()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var0 = event.get_save_counter(1) or var0
	var1 = event.get_save_counter(0) or var1
	var2 = event.get_save_counter(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_854bd6cf(var0, var1, var2)
end

return helper_946c0402
