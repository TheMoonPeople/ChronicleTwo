--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_353f33ea = require("@lib/event/helper_353f33ea")
local helper_74601df8 = require("@lib/event/helper_74601df8")
local helper_94d5f966 = require("@lib/event/helper_94d5f966")
local helper_f545524f = require("@lib/event/helper_f545524f")

--- Helper function.
local function helper_e7210099(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f545524f(arg0, arg1)
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
		helper_f545524f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_94d5f966(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_74601df8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_353f33ea(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_e7210099
