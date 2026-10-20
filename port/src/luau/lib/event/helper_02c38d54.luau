--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_02c38d54()
	local flag: s32 = 0
	flag = event.GetFlag(448) or flag
	if flag ~= 0 then
		event.EohSyncObj(1, "p11_g0301")
		event.EohSetShow(1, 0)
		event.EohSyncObj(1, "p12_g0301")
		event.EohSetShow(1, 1)
	end
end

return helper_02c38d54
