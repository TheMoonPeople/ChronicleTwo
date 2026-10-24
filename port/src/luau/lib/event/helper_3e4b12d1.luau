--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bf3cde9 = require("@lib/event/helper_0bf3cde9")
local helper_7d5778b3 = require("@lib/event/helper_7d5778b3")

--- Helper function.
local function helper_3e4b12d1(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0bf3cde9(1, 4)
			helper_7d5778b3(1, 9, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_0bf3cde9(1, 4)
	event.SetMesItem(1, 1, arg0)
	event.SetMesItem(1, 2, arg2)
	event.SetMesItem(1, 3, arg4)
	event.SetMesValue(1, 1, arg1)
	event.SetMesValue(1, 2, arg3)
	event.SetMesValue(1, 3, arg5)
	helper_7d5778b3(1, 9, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_3e4b12d1
