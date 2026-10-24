--!strict
-- Shared event helper used by 120 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c5602593()
	local var0: { s32 } = table.create(14, 0)
	local var14: s32 = 0
	event.EohSyncObj_3(0, "p08_i01h07", "i01h07_13-m7")
	event.EohSyncObj_3(1, "p08_i01h07", "i01h07_13-m21")
	event.EohSyncObj_3(2, "p08_i01h07", "i01h07_13-m8")
	event.EohSyncObj_3(3, "p08_i01h07", "i01h07_13-m20")
	event.EohSyncObj_3(4, "p08_i01h07", "i01h07_13-m9")
	event.EohSyncObj_3(5, "p08_i01h07", "i01h07_13-m19")
	event.EohSyncObj_3(6, "p08_i01h07", "i01h07_13-m10")
	event.EohSyncObj_3(7, "p08_i01h07", "i01h07_13-m18")
	event.EohSyncObj_3(8, "p08_i01h07", "i01h07_13-m11")
	event.EohSyncObj_3(9, "p08_i01h07", "i01h07_13-m17")
	event.EohSyncObj_3(10, "p08_i01h07", "i01h07_13-m12")
	event.EohSyncObj_3(11, "p08_i01h07", "i01h07_13-m16")
	event.EohSyncObj_3(12, "p08_i01h07", "i01h07_13-m14")
	event.EohSyncObj_3(13, "p08_i01h07", "i01h07_13-m15")
	var0[1] = event.EohGetShow(0) or var0[1]
	var0[2] = event.EohGetShow(1) or var0[2]
	var0[3] = event.EohGetShow(2) or var0[3]
	var0[4] = event.EohGetShow(3) or var0[4]
	var0[5] = event.EohGetShow(4) or var0[5]
	var0[6] = event.EohGetShow(5) or var0[6]
	var0[7] = event.EohGetShow(6) or var0[7]
	var0[8] = event.EohGetShow(7) or var0[8]
	var0[9] = event.EohGetShow(8) or var0[9]
	var0[10] = event.EohGetShow(9) or var0[10]
	var0[11] = event.EohGetShow(10) or var0[11]
	var0[12] = event.EohGetShow(11) or var0[12]
	var0[13] = event.EohGetShow(12) or var0[13]
	var0[14] = event.EohGetShow(13) or var0[14]
	var14 = 0
	for var15 = 0, 13 do
		if var0[var15 + 1] ~= 0 then
			var14 = vm.i32(var14 + 1)
		end
	end
	return var14
end

return helper_c5602593
