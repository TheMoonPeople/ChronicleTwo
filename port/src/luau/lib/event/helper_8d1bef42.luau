--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8d1bef42()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		event.FuncPointShow("", "fc_event_202", 1)
	else
		event.FuncPointShow("", "fc_event_202", 0)
		event.EohSyncObj(0, "p01_train01")
		event.EohSetShow(0, 0)
	end
end

return helper_8d1bef42
