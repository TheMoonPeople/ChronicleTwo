--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_6855fc81(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 0 then
		event.EohSyncObj(0, arg0, "d05d01_4-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d01_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da02-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv02-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 1 then
		event.EohSyncObj(0, arg0, "d05d09_4-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d09_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da02-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv02-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 2 then
		event.EohSyncObj(0, arg0, "d05d17_4-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d17_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da02-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv02-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 3 then
		event.EohSyncObj(0, arg0, "d05d33_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d29_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da33-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv33-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 4 then
		event.EohSyncObj(0, arg0, "d05d41_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d37_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da33-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv33-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 5 then
		event.EohSyncObj(0, arg0, "d05d49_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d45_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da33-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv33-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 6 then
		event.EohSyncObj(0, arg0, "d05d69_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d65_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da69-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv69-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 7 then
		event.EohSyncObj(0, arg0, "d05d77_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d73_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da69-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv69-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 8 then
		event.EohSyncObj(0, arg0, "d05d85_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d81_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da69-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv69-c")
		event.EohSetShow(0, 0)
	end
	if arg1 == 9 then
		event.EohSyncObj(0, arg0, "d05d97_1-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05d93_3-m0")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, arg0, "d05da97-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, arg0, "d05dv97-c")
		event.EohSetShow(0, 0)
	end
end

return helper_6855fc81
