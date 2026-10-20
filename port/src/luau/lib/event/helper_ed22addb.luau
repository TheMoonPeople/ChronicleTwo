--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_ed22addb()
	local flag: s32 = 0
	event.Initialize()
	flag = event.GetFlag(209) or flag
	if flag == 1 then
		event.EohSyncObj(0, "p09_s0201")
		event.EohSetShow(0, 0)
	end
end

return helper_ed22addb
