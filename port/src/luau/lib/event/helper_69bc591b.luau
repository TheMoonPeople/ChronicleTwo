--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_69bc591b()
	local flag: s32 = 0
	flag = event.GetFlag(448) or flag
	if flag == 1 then
		event.EohSyncObj(1, "p06_s0901")
		event.EohSetShow(1, 0)
		event.EohSyncObj(1, "p07_s0901")
		event.EohSetShow(1, 1)
	end
end

return helper_69bc591b
