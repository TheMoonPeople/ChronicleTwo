--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40d091f5 = require("@lib/event/helper_40d091f5")
local helper_8dba0b6a = require("@lib/event/helper_8dba0b6a")
local helper_9392e34e = require("@lib/event/helper_9392e34e")
local helper_f79a50c6 = require("@lib/event/helper_f79a50c6")

--- Helper function.
local function helper_757397ef(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9392e34e(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9392e34e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_40d091f5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_f79a50c6(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_8dba0b6a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_757397ef
