--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f4063d00()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01", "train02-a0")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a1")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a2")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a3")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a4")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a5")
	event.EohSetShow(0, 0)
end

return helper_f4063d00
