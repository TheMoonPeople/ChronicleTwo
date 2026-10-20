--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_449e3f4b = require("@lib/event/helper_449e3f4b")
local helper_6b3518ef = require("@lib/event/helper_6b3518ef")

--- Helper function.
local function helper_a739b05c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_6b3518ef(1)
		helper_449e3f4b(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_6b3518ef(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_449e3f4b(arg0, argc)
	end
end

return helper_a739b05c
