--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_24bece14()
	local argc: s32 = 0
	event.Initialize()
	argc = event.GetItemNum(386) or argc
	if 0 < argc then
		event.FuncPointShow("", "item2", 0)
		event.EohSyncObj_2(0, "memo")
		event.EohSetShow(0, 0)
	end
end

return helper_24bece14
