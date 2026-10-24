--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")

--- Helper function.
local function helper_b2900e73(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_9e7d1511(1, var2, 8, 0, 0)
end

return helper_b2900e73
