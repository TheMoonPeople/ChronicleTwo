--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_bac0dab2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	if arg0 < 0 or 1 < arg0 or arg1 < 0 or 6 < arg1 then
		return
	end
	var2 = arg0 * 7 + arg1
	if var2 == 0 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m7")
	end
	if var2 == 7 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m21")
	end
	if var2 == 1 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m8")
	end
	if var2 == 8 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m20")
	end
	if var2 == 2 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m9")
	end
	if var2 == 9 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m19")
	end
	if var2 == 3 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m10")
	end
	if var2 == 10 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m18")
	end
	if var2 == 4 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m11")
	end
	if var2 == 11 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m17")
	end
	if var2 == 5 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m12")
	end
	if var2 == 12 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m16")
	end
	if var2 == 6 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m14")
	end
	if var2 == 13 then
		event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m15")
	end
	var3 = event.EohGetShow(0) or var3
	event.EohSetShow(0, if var3 == 0 then 1 else 0)
end

return helper_bac0dab2
