--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_7f42ab37()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(2, 0.0, -24.0, -1000.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(10, "p01_train01", "train06-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p01_train01", "train06-m1")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p01_train01", "train05-m10")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(13, "p01_train01", "train05-m11")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.EohSyncObj(14, "p01_train01", "train05-m12")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p01_train01", "train05-m13")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.EohSyncObj(16, "p01_train01", "train05-m14")
	event.ObjsInit(16)
	event.ObjsSyncObj(16, 16)
	event.EohSyncObj(17, "p01_train01", "train05-m15")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.EohSyncObj(18, "p01_train01", "train05-m16")
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.EohSyncObj(19, "p01_train01", "train05-m17")
	event.ObjsInit(19)
	event.ObjsSyncObj(19, 19)
	event.EohSyncObj(20, "p01_train01", "train05-m18")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.EohSyncObj(21, "p01_train01", "train05-m19")
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	var0 = 0
	while var0 < 12 do
		event.ObjsRotation(10 + var0, 0.1, 0.0, 0.0, -1)
		var0 = var0 + 1
	end
end

return helper_7f42ab37
