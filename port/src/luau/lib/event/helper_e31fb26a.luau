--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e31fb26a(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(10, "p05_d02b01")
	event.EohSyncObj(11, "p02_d02b01")
	event.EohSyncObj(14, "p03_d02b01")
	event.EohSyncObj(17, "p04_d02b01")
	event.EohSyncObj(20, "bero", "03bossbero")
	event.EohSyncObj(21, "bero-1", "03bossbero")
	event.EohSyncObj(22, "bero-2", "03bossbero")
	event.EohSyncObj(23, "bero-3", "03bossbero")
	event.EohSyncObj(24, "bero-4", "03bossbero")
	event.EohSyncObj(25, "bero-5", "03bossbero")
	event.EohSyncObj(26, "bero-6", "03bossbero")
	event.EohSyncObj(27, "bero-7", "03bossbero")
	event.EohSyncObj(28, "neba", "neba3")
	if arg0 == 0 then
		event.EohSetShow(10, 1)
		event.EohSetShow(11, 0)
		event.EohSetShow(14, 0)
		event.EohSetShow(17, 1)
		event.EohSetShow(20, 0)
		event.EohSetShow(21, 0)
		event.EohSetShow(22, 0)
		event.EohSetShow(23, 0)
		event.EohSetShow(24, 0)
		event.EohSetShow(25, 0)
		event.EohSetShow(26, 0)
		event.EohSetShow(27, 0)
		event.EohSetShow(28, 0)
	end
	if arg0 == 1 then
		event.EohSetShow(10, 0)
		event.EohSetShow(11, 1)
		event.EohSetShow(14, 1)
		event.EohSetShow(17, 0)
		event.EohSetShow(20, 1)
		event.EohSetShow(21, 1)
		event.EohSetShow(22, 1)
		event.EohSetShow(23, 1)
		event.EohSetShow(24, 1)
		event.EohSetShow(25, 1)
		event.EohSetShow(26, 1)
		event.EohSetShow(27, 1)
		event.EohSetShow(28, 0)
	end
	if arg0 == 2 then
		event.EohSetShow(10, 0)
		event.EohSetShow(11, 1)
		event.EohSetShow(14, 1)
		event.EohSetShow(17, 0)
		event.EohSetShow(20, 1)
		event.EohSetShow(21, 1)
		event.EohSetShow(22, 1)
		event.EohSetShow(23, 1)
		event.EohSetShow(24, 1)
		event.EohSetShow(25, 1)
		event.EohSetShow(26, 1)
		event.EohSetShow(27, 1)
		event.EohSetShow(28, 1)
	end
	if arg0 == 3 then
		event.EohSetShow(10, 0)
		event.EohSetShow(11, 0)
		event.EohSetShow(14, 0)
		event.EohSetShow(17, 1)
		event.EohSetShow(20, 0)
		event.EohSetShow(21, 0)
		event.EohSetShow(22, 0)
		event.EohSetShow(23, 0)
		event.EohSetShow(24, 0)
		event.EohSetShow(25, 0)
		event.EohSetShow(26, 0)
		event.EohSetShow(27, 0)
		event.EohSetShow(28, 0)
	end
end

return helper_e31fb26a
