--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bf3cde9 = require("@lib/event/helper_0bf3cde9")
local helper_7d5778b3 = require("@lib/event/helper_7d5778b3")

--- Helper function.
local function helper_988b2a39(arg0: any, arg1: s32, arg2: s32, arg3: s32)
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 <= 0 then
		return
	end
	event.SetMesPreset(1, 4)
	helper_0bf3cde9(1, 4)
	var4 = -1
	if arg1 == 1 then
		if arg3 == 1 then
			var4 = 14
		else
			var4 = 21
		end
	end
	if arg1 == 2 then
		if arg3 == 1 then
			var4 = 26
		else
			var4 = 24
		end
	end
	if arg1 == 3 then
		if arg3 == 1 then
			var4 = 27
		else
			var4 = 25
		end
	end
	if var4 == -1 then
		return
	end
	event.SetMesValue(1, 1, arg1)
	event.SetMesItem(1, 1, arg2)
	event.SetMesValue(1, 2, arg3)
	helper_7d5778b3(1, var4, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_988b2a39
