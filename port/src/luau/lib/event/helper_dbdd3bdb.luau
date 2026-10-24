--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19b9bab2 = require("@lib/event/helper_19b9bab2")
local helper_2413b547 = require("@lib/event/helper_2413b547")
local helper_b29a4cdd = require("@lib/event/helper_b29a4cdd")
local helper_f740a8ec = require("@lib/event/helper_f740a8ec")

--- Helper function.
local function helper_dbdd3bdb(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b29a4cdd(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_2413b547(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_f740a8ec(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_19b9bab2(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_dbdd3bdb
