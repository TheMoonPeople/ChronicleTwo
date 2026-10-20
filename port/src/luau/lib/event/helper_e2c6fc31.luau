--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_377e162e = require("@lib/event/helper_377e162e")
local helper_daa12212 = require("@lib/event/helper_daa12212")

--- Helper function.
local function helper_e2c6fc31(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377e162e(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_377e162e(1, 4)
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
	helper_daa12212(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_e2c6fc31
