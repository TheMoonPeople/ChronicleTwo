--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_2164b10b()
	local var0: s32 = 0
	event.EohSyncObj_2(0, "p06_e03h03-0")
	event.EohSyncObj_2(1, "p07_e03h03-0")
	var0 = event.GetSavedataEtc(6) or var0
	if var0 == 1 then
		event.EohSetShow(0, 0)
		event.EohSetShow(1, 1)
	else
		event.EohSetShow(0, 1)
		event.EohSetShow(1, 0)
	end
end

return helper_2164b10b
