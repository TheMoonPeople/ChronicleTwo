--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_468e8623 = require("@lib/event/helper_468e8623")
local helper_4c0ea368 = require("@lib/event/helper_4c0ea368")
local helper_640906f2 = require("@lib/event/helper_640906f2")
local helper_8d31221d = require("@lib/event/helper_8d31221d")

--- Helper function.
local function helper_b4323b2b(arg0: s32, arg1: s32)
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
		helper_8d31221d(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_468e8623(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_640906f2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_4c0ea368(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_b4323b2b
